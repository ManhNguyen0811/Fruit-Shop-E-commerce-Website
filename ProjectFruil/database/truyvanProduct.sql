/*CRUD Category*/
/*Thêm Danh Mục*/
INSERT INTO Category (name)
VALUES (N'Trái Cây');
INSERT INTO Category (parent_id,name)
VALUES ('1',N'Táo');
INSERT INTO Category (parent_id,name)
VALUES ('1',N'Nho');
INSERT INTO Category (parent_id,name)
VALUES ('1',N'Chuối');

INSERT INTO Category (name)
VALUES (N'Rau Củ');
INSERT INTO Category (parent_id,name)
VALUES ('2',N'Cà Rốt');
INSERT INTO Category (parent_id,name)
VALUES ('2',N'Khoai Tây');
INSERT INTO Category (parent_id,name)
VALUES ('2',N'Rau Cải')

INSERT INTO Category (name)
VALUES (N'Khác');

/*Show Toàn Bộ Danh Mục*/
SELECT * FROM Category;

/*Show Toàn Bộ Danh Mục*/
SELECT * FROM Category
where parent_id = 2;
/*Sửa tên danh mục*/
UPDATE Category
SET name = N'Rau Củ'
WHERE id = 2;

/*Xóa Danh Mục*/
DELETE FROM Category
WHERE id = 1;


/*CRUD Product*/
/*Thêm Sản Phẩm*/
INSERT INTO Product (category_id, name, description)
VALUES
    ((SELECT id FROM Category WHERE name = N'Táo'), N'Táo Đỏ Ngon', N'Táo đỏ ngọt và giòn'),
    ((SELECT id FROM Category WHERE name = N'Nho'), N'Nho Xanh', N'Nho ngọt không hạt'),
    ((SELECT id FROM Category WHERE name = N'Chuối'), N'Chuối Cavendish', N'Chuối tươi ngọt'),
    ((SELECT id FROM Category WHERE name = N'Cà Rốt'), N'Cà Rốt Con', N'Cà rốt con mềm và ngọt'),
    ((SELECT id FROM Category WHERE name = N'Khoai Tây'), N'Khoai Tây Russet', N'Khoai tây lớn và bở'),
    ((SELECT id FROM Category WHERE name = N'Rau Cải'), N'Xà Lách Romaine', N'Xà lách giòn và dinh dưỡng'),
    ((SELECT id FROM Category WHERE name = N'Khác'), N'Mật Ong Hữu Cơ', N'Mật ong nguyên chất');

/*Show Toàn Bộ Sản Phẩm*/
SELECT * FROM Product;

/*Show Toàn Bộ Sản Phẩm Theo 1 Danh Mục Cha*/
SELECT 
    p.id,
    p.name,
    p.description,
    p.create_at,
    p.update_at
FROM Product p
JOIN Category c ON p.category_id = c.id
WHERE c.parent_id = (SELECT id FROM Category WHERE name = N'Trái Cây')

/*Show Toàn Bộ Sản Phẩm Theo 1 Danh Mục Con*/
SELECT 
    p.id,
    p.name,
    p.description,
    p.create_at,
    p.update_at
FROM Product p
JOIN Category c ON p.category_id = c.id
WHERE c.name= N'Táo';

/*Show 1 sản phẩm*/
SELECT 
    p.name AS N'Tên Sản Phẩm',
    CASE 
        WHEN pi.original_price = pi.price THEN pi.original_price
        ELSE pi.price
    END AS N'Giá'
FROM 
    Product p
JOIN 
    Product_Item pi ON p.id = pi.product_id
JOIN Category c ON p.category_id = c.id
 
WHERE c.name= N'Táo' AND
    pi.id = (
        SELECT 
            MAX(id)
        FROM 
            Product_Item
        WHERE 
            product_id = p.id
);


/*Sửa Thông Tin Sản Phẩm*/
UPDATE Product
SET name = 'Táo Gala', description = 'Táo Gala tươi ngon, giòn giòn',update_at = GETDATE()
WHERE id = 1;

/*Xóa Sản Phẩm*/
DELETE FROM Product
WHERE id = 1;

/*CRUD Gallery*/
/*Thêm Ảnh/Video*/
INSERT INTO Gallery (product_id, thumbnail)
VALUES (1, 'apple1.png');
INSERT INTO Gallery (product_id, thumbnail)
VALUES (1, 'apple2.png');
INSERT INTO Gallery (product_id, thumbnail)
VALUES (2, 'grape1.png');
INSERT INTO Gallery (product_id, thumbnail)
VALUES (3, 'banana1.png');
INSERT INTO Gallery (product_id, thumbnail)
VALUES (3, 'banana2.png');
INSERT INTO Gallery (product_id, thumbnail)
VALUES (4, 'carrot1.png');
INSERT INTO Gallery (product_id, thumbnail)
VALUES (5, 'potato1.png');
INSERT INTO Gallery (product_id, thumbnail)
VALUES (7, 'honey1.png');


/*Show Toàn Bộ Ảnh*/
SELECT * FROM Gallery;

/*Show Ảnh Theo Sản Phẩm*/
SELECT thumbnail FROM Gallery
WHERE product_id = 2;

/*Sửa Thông Tin Ảnh*/
UPDATE Gallery
SET thumbnail = 'carrot1.png'
WHERE id = 4;

/*Xóa Ảnh*/
DELETE FROM Gallery
WHERE id = 4;

/*CRUD Product_Item*/
/*Thêm Sản Phẩm Vào Kho*/
INSERT INTO Product_Item (product_id, qty_in_stock, price, original_price )
VALUES (1, 20, 20000,20000);
INSERT INTO Product_Item (product_id, qty_in_stock, price, original_price )
VALUES (2, 30, 15000,20000);
INSERT INTO Product_Item (product_id, qty_in_stock, price, original_price )
VALUES (3, 80, 30000,30000);
INSERT INTO Product_Item (product_id, qty_in_stock, price, original_price )
VALUES (4, 10, 15000,20000);
INSERT INTO Product_Item (product_id, qty_in_stock, price, original_price )
VALUES (5, 20, 20000,30000);
INSERT INTO Product_Item (product_id, qty_in_stock, price, original_price )
VALUES (6, 10, 15000,20000);
INSERT INTO Product_Item (product_id, qty_in_stock, price, original_price )
VALUES (7, 20, 20000,30000);

/*Show Tất Cả Sản Phẩm Trong Kho*/
SELECT * FROM Product_Item;

/*Show 1 Sản Phẩm trong kho*/
SELECT * FROM Product_Item
WHERE id =1;

/*Sửa giá và số lượng sản phẩm trong Kho*/
UPDATE Product_Item
SET qty_in_stock = 50, price = 15000, update_at = GETDATE()
WHERE id = 1;

/*Xóa sản phẩm trong kho*/
DELETE FROM Product_Item 
WHERE id = 1;

GO
/*CRUD Cart*/
/*Thêm Sản Phẩm Vào Cart*/
INSERT INTO Cart (user_id, product_item_id, qty)
VALUES (1, 12, 2);
INSERT INTO Cart (user_id, product_item_id, qty)
VALUES (1, 9, 8);
INSERT INTO Cart (user_id, product_item_id, qty)
VALUES (2, 12, 2);
INSERT INTO Cart (user_id, product_item_id, qty)
VALUES (2, 11, 2);

/*Show Tất Cả Cart*/
SELECT * FROM Cart;

/*Show Cart Theo User ID bao gồm Tên Sản Phẩm/ Giá Sản Phẩm/ Số Lượng/ Tổng*/
SELECT 
    p.name AS product_name,
    pi.price AS product_price,
    c.qty AS quantity,
    (pi.price * c.qty) AS total_price
FROM Cart c
JOIN Product_Item pi ON c.product_item_id = pi.id
JOIN Product p ON pi.product_id = p.id
WHERE c.user_id = 1

/*Sửa Số Lượng Của 1 Sản Phẩm Trong Giỏ Hàng*/
UPDATE Cart 
SET qty = 5
WHERE user_id = 1 AND product_item_id = 1 

/*Xóa 1 Sản Phẩm Trong Giỏ Hàng*/
DELETE FROM Cart
WHERE user_id = 1 AND product_item_id = 1;

/*Clear Giỏ Hàng*/
DELETE FROM Cart
WHERE user_id = 2;

/*CRUD WishList*/
/*Thêm Sản Phẩm Vào WishList*/
INSERT INTO Wishlist (user_id, product_item_id)
VALUES (1,5);
INSERT INTO Wishlist (user_id, product_item_id)
VALUES (1,3);

/*Show Tất Cả WishLish*/
SELECT * FROM WishList;

/*Show WishList Theo User ID bao gồm Tên Sản Phẩm/ Giá Sản Phẩm/ Số Lượng Tồn*/
SELECT 
    p.name AS product_name,
    pi.price AS product_price,
    pi.qty_in_stock AS quantity
FROM WishList wl
JOIN Product_Item pi ON wl.product_item_id = pi.id
JOIN Product p ON pi.product_id = p.id
WHERE wl.user_id = 1

/*Xóa 1 Sản Phẩm Trong WishList*/
DELETE FROM Wishlist
WHERE user_id = 1 AND product_item_id = 5;