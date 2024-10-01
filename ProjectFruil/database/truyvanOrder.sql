/*CRUD Payment_Type*/
/*Thêm các cách thức thanh toán*/
INSERT INTO Payment_Type (name)
VALUES (N'Thẻ Tín Dụng'),
       (N'Thẻ Ghi Nợ'),
       (N'MoMo')
;	   

/*Xem tất cả các cách thức thanh toán*/
SELECT * 
FROM Payment_Type;

/*Sửa Tên Cách Thức Thanh Toán*/
UPDATE Payment_Type
SET name = N'Thẻ ATM'
WHERE id = 1;

/*Xóa Cách Thức Thanh Toán*/
DELETE FROM Payment_Type
WHERE id = 3;

/*CRUD User_Payment_method*/
/*Thêm Cách Thức Thanh Toán Của User*/
INSERT INTO User_Payment_Method (user_id, payment_type_id, card_number, card_holder_name, expiry_date, provider, is_default)
VALUES (6, 1, '1234567891011121314', 'Tran Thanh Dat', '2025-12-31', 'Vietcombank', 1),
       (1, 2, '1234567891011121315', 'Tran Thanh Dat', '2026-06-30', 'VIB', 0);

/*Xem Tất Cả Cách Thức Thanh Toán*/
SELECT * FROM User_Payment_Method;

/*Xem Tất Cả Cách Thức Thanh Toán Của User*/
SELECT * FROM User_Payment_Method
WHERE user_id = 1;

/*Xem Cách Thức Thanh Toán Mặc Định Của User*/
SELECT * FROM User_Payment_Method
WHERE user_id = 1 and is_default = 0;
GO

/*Sửa cách thức thanh toán*/
UPDATE User_Payment_Method
SET expiry_date = '2027-06-30'
WHERE id = 2;
GO

/*Xóa cách thức thanh toán*/
CREATE OR ALTER PROCEDURE deleteUserMethodPayment
    @id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @is_default BIT
    SELECT @is_default = is_default FROM User_Payment_Method WHERE id = @id

    -- Kiểm tra có phải phương thức thanh toán mặc định hay không
    IF @is_default = 0
    BEGIN
        -- Tìm cách thức thanh toán khác
        DECLARE @new_default_id INT
        SELECT TOP 1 @new_default_id = id 
        FROM User_Payment_Method
        WHERE user_id = (SELECT user_id FROM User_Payment_Method WHERE id = @id)
        AND id <> @id
        ORDER BY id

        -- Set mặc định cho id khác
        IF @new_default_id IS NOT NULL
        BEGIN
            UPDATE User_Payment_Method
            SET is_default = 0
            WHERE id = @new_default_id
        END
    END

    -- Delete the payment method
    DELETE FROM User_Payment_Method
    WHERE id = @id
END
EXEC deleteUserMethodPayment @id = 2;

/*CRUD ORDER*/
/*THÊM ĐƠN HÀNG*/
INSERT INTO [Order] (user_id, user_payment_method_id)
VALUES (1,2);

/*Xem Đơn Hàng*/
SELECT *
FROM [Order]
WHERE user_id = 1;

/*Sửa Đơn Hàng*/
UPDATE [Order]
SET user_payment_method_id = 2
WHERE id = 1;

/*Xóa Đơn Hàng*/
DELETE FROM [Order]
WHERE id = 1;

/*CRUD ORDER_ITEM*/
/*THÊM CHI TIẾT ĐƠN HÀNG*/
INSERT INTO Order_Item (order_id, product_item_id, qty, price)
VALUES (2, 1, 5, 20000);
INSERT INTO Order_Item (order_id, product_item_id, qty, price)
VALUES (2, 2, 8, 15000);
INSERT INTO Order_Item (order_id, product_item_id, qty, price)
VALUES (2, 4, 2, 15000);

/*Xem Chi Tiết Đơn Hàng*/
SELECT oi.*
FROM Order_Item oi
JOIN [Order] o ON oi.order_id = o.id
WHERE o.user_id = 1;

/*Sửa Chi Tiết Đơn Hàng*/
UPDATE Order_Item
SET qty = 3
WHERE id = 1;

/*Xóa Chi Tiết Đơn Hàng*/
DELETE FROM Order_Item
WHERE id = 1;

/*Show Đơn Hàng*/
SELECT
    o.id AS order_id,
    u.name AS customer_name,
    a.city, a.ward, a.street,
    SUM(oi.qty * oi.price) AS total_order_value,
    o.create_at AS order_created_at
FROM [Order] o
JOIN [User] u ON o.user_id = u.id
JOIN [User_Address] ua ON u.id = ua.user_id AND ua.is_default = 0
JOIN [Address] a ON ua.address_id = a.id
JOIN Order_Item oi ON o.id = oi.order_id
WHERE o.user_id = 1
GROUP BY
    o.id,
    u.name,
    a.city, a.ward, a.street,
    o.create_at;

/*CRUD REVIEW*/
/*THÊM REVIEW*/
INSERT INTO Review (ordered_product_id, user_id, rating_value, comment)
VALUES (12, 1, 3, 'Sản Phẩm Ngon!');
/*XÓA REVIEW*/
DELETE FROM Review
WHERE id = 1;
/*SỬA REVIEW*/
UPDATE Review
SET rating_value = 5, comment = 'QUÁ NGON!'
WHERE id = 3;
/*XEM TẤT CẢ REVIEW */
select *  from Review
/*XEM REVIEW THEO MÃ PRODUCT*/
SELECT r.id, r.ordered_product_id, r.user_id, r.rating_value, r.comment, r.update_at
FROM Review r
INNER JOIN Order_Item oi ON r.ordered_product_id = oi.id
WHERE oi.product_item_id = 4
ORDER BY r.create_at DESC;
GO

/*Tạo Order và OrderDetail */
CREATE OR ALTER PROCEDURE sp_CreateOrder
    @user_id INT,
    @user_payment_method_id INT,
    @address_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @total_amount FLOAT = 0;

    -- Lấy địa chỉ từ bảng Address
    DECLARE @shipping_address NVARCHAR(255);
    SELECT @shipping_address = CONCAT(
        city, ', ',
        ward, ', ',
        street, '.'
    )
    FROM Address
    WHERE id = @address_id;

    -- Kiểm tra xem giỏ hàng của người dùng có sản phẩm không
    IF EXISTS (SELECT 1 FROM Cart WHERE user_id = @user_id)
    BEGIN
        -- Tạo một đơn hàng mới
        INSERT INTO [Order] (user_id, user_payment_method_id,shipping_address, total_amount)
        VALUES (@user_id, @user_payment_method_id, @shipping_address, @total_amount);

        DECLARE @order_id INT = SCOPE_IDENTITY();

        -- Thêm các mặt hàng từ giỏ hàng của người dùng vào chi tiết đơn hàng
        INSERT INTO Order_Item (order_id, product_item_id, qty, price)
        SELECT @order_id, c.product_item_id, c.qty, pi.price
        FROM Cart c
        JOIN Product_Item pi ON c.product_item_id = pi.id
        WHERE c.user_id = @user_id;

        -- Tính tổng số tiền của đơn hàng
        SELECT @total_amount = SUM(qty * price)
        FROM Order_Item
        WHERE order_id = @order_id;

        -- Cập nhật tổng số tiền của đơn hàng
        UPDATE [Order]
        SET total_amount = @total_amount
        WHERE id = @order_id;
    END
    ELSE
    BEGIN
        -- Giỏ hàng trống, không tạo đơn hàng
        PRINT N'Giỏ hàng trống, không thể tạo đơn hàng.'
    END
END
GO

EXEC sp_CreateOrder @user_id = 1, @user_payment_method_id = 1, @address_id = 1;
GO

SELECT * FROM [Order]

SELECT * FROM User_Payment_Method;

/*hiển thị đơn hàng theo mã người dùng*/
SELECT
    o.id AS N'Mã Đơn hàng',
    u.name AS N'Tên Người Mua',
    a.city + ', ' + a.ward + ', ' + a.street AS N'Địa Chỉ Giao Hàng',
    pt.name AS N'Phương Thức Thanh Toán',
    o.total_amount AS N'Tổng Giá Trị Đơn Hàng',
    o.create_at AS N'Ngày Tạo Đơn Hàng',
	o.order_status AS N'Ngày Tạo Đơn Hàng'
FROM [Order] o
JOIN [User] u ON o.user_id = u.id
JOIN User_Address ua ON o.address_id = ua.address_id
JOIN Address a ON ua.address_id = a.id
JOIN User_Payment_Method upm ON o.user_payment_method_id = upm.id
JOIN Payment_Type pt ON upm.payment_type_id = pt.id
WHERE u.id = 1;

UPDATE [Order] 
SET order_status = 0
FROM [Order] o
INNER JOIN [User] u ON o.user_id = u.id
WHERE u.id = 6;

SELECT * FROM [Order];

GO
CREATE OR ALTER FUNCTION FN_OrderDetail(
    @order_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        o.id AS N'Mã Đơn hàng',
        u.name AS N'Người Mua',
        p.name AS N'Tên Sản Phẩm',
        oi.price AS N'Đơn Giá Sản Phẩm',
        oi.qty AS N'Số Lượng',
        oi.price * oi.qty AS N'Thành Tiền'
    FROM [Order] o
    JOIN [User] u ON o.user_id = u.id
    JOIN Order_Item oi ON o.id = oi.order_id
    JOIN Product_Item pi ON oi.product_item_id = pi.id
    JOIN Product p ON p.id = pi.product_id
    WHERE o.id = @order_id
)

GO
SELECT *
FROM FN_OrderDetail(13);

GO
-- Xóa order , order item
CREATE OR ALTER PROCEDURE sp_DeleteOrder
    @order_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    -- Xóa các chi tiết đơn hàng
    DELETE FROM Order_Item
    WHERE order_id = @order_id;

    -- Xóa đơn hàng
    DELETE FROM [Order]
    WHERE id = @order_id;

    COMMIT TRANSACTION;
END
GO
SELECT * FROM [order];
EXEC sp_DeleteOrder @order_id = 2;
GO

-- Sửa Order Order Item--

CREATE OR ALTER PROCEDURE sp_UpdateOrder
    @order_id INT,
    @user_payment_method_id INT,
    @address_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @total_amount FLOAT = 0;

    -- Cập nhật thông tin thanh toán và địa chỉ của đơn hàng
    UPDATE [Order]
    SET user_payment_method_id = @user_payment_method_id,
        address_id = @address_id
    WHERE id = @order_id;

    -- Xóa các mặt hàng cũ trong chi tiết đơn hàng
    DELETE FROM Order_Item
    WHERE order_id = @order_id;

    -- Thêm các mặt hàng từ giỏ hàng của người dùng vào chi tiết đơn hàng
    INSERT INTO Order_Item (order_id, product_item_id, qty, price)
    SELECT @order_id, c.product_item_id, c.qty, pi.price
    FROM Cart c
    JOIN Product_Item pi ON c.product_item_id = pi.id
    WHERE c.user_id = (SELECT user_id FROM [Order] WHERE id = @order_id);

    -- Tính tổng số tiền của đơn hàng
    SELECT @total_amount = SUM(qty * price)
    FROM Order_Item
    WHERE order_id = @order_id;

    -- Cập nhật tổng số tiền của đơn hàng
    UPDATE [Order]
    SET total_amount = @total_amount
    WHERE id = @order_id;
END
GO

