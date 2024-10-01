
INSERT INTO [User] (password, name, phone, email, role)
VALUES
('password1', 'John Doe', '0987654321', 'john.doe@example.com', 0),
('password2', 'Jane Smith', '0123456789', 'jane.smith@example.com', 0),
('password3', 'Admin User', '0456789012', 'admin@example.com', 1);

-- Insert data into Address table
INSERT INTO Address (city, ward, street)
VALUES
(N'Hà Nội', N'Quận Hoàn Kiếm', N'Phố Hàng Bài'),
(N'Hà Nội', N'Quận Ba Đình', N'Phố Nguyễn Trãi'),
(N'TP Hồ Chí Minh', N'Quận 1', N'Đường Lê Lợi');

-- Insert data into User_Address table
INSERT INTO User_Address (user_id, address_id, is_Default)
VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1);

-- Insert data into Category table
INSERT INTO Category (parent_id, name)
VALUES
(NULL, N'Trái cây'),
(1, N'Trái cây nhập khẩu'),
(1, N'Trái cây nội địa'),
(NULL, N'Rau củ');

-- Insert data into Product table
INSERT INTO Product (category_id, name, description)
VALUES
(2, N'Táo Fuji', N'Táo Fuji nhập khẩu từ Nhật Bản'),
(3, N'Xoài cát Hòa Lộc', N'Xoài cát Hòa Lộc tươi ngon'),
(4, N'Cải thảo', N'Cải thảo tươi ngon, sạch');

-- Insert data into Gallery table
INSERT INTO Gallery (product_id, thumbnail)
VALUES
(1, 'fuji_apple.jpg'),
(2, 'hoa_loc_mango.jpg'),
(3, 'cabbage.jpg');

-- Insert data into Product_Item table
INSERT INTO Product_Item (product_id, qty_in_stock, price, original_price)
VALUES
(1, 50, 25000.0, 30000.0),
(2, 30, 35000.0, 40000.0),
(3, 80, 10000.0, 12000.0);

-- Insert data into Payment_Type table
INSERT INTO Payment_Type (name)
VALUES
('Credit Card'),
('Debit Card'),
('Cash on Delivery');

-- Insert data into User_Payment_Method table
INSERT INTO User_Payment_Method (user_id, payment_type_id, card_number, card_holder_name, expiry_date, provider, is_default)
VALUES
(1, 1, '1234567890123456', 'John Doe', '2025-12-31', 'Visa', 1),
(2, 2, '0987654321098765', 'Jane Smith', '2026-06-30', 'MasterCard', 1),
(3, 3, '0987654321098765', 'Jane Smith', '2026-06-30', 'MasterCard', 1);

-- Insert data into Order table
INSERT INTO [Order] (user_id, user_payment_method_id, address_id, shipping_address, total_amount)
VALUES
(1, 7, 1, N'Phố Hàng Bài, Quận Hoàn Kiếm, Hà Nội', 25000.0),
(2, 8, 2, N'Phố Nguyễn Trãi, Quận Ba Đình, Hà Nội', 35000.0),
(3, 9, 3, N'Đường Lê Lợi, Quận 1, TP Hồ Chí Minh', 10000.0);

-- Insert data into Order_Item table
INSERT INTO Order_Item (order_id, product_item_id, qty, price)
VALUES
(5, 1, 1, 25000.0),
(6, 2, 1, 35000.0),
(7, 3, 1, 10000.0);

-- Insert data into Review table
INSERT INTO Review (ordered_product_id, user_id, rating_value, comment)
VALUES
(2, 2, 4, N'Sản phẩm rất tốt, giao hàng nhanh chóng'),
(3, 1, 5, N'Trái cây tươi ngon, đúng chất lượng'),
(4, 3, 3, N'Sản phẩm khá tốt, nhưng giá hơi cao');



select * from[User]
UPDATE [user]
set password = '$2a$12$uHm36NIyWUMB8uynYMUUT.xMO/DFkoc2VPvZYZw2oEv2wUmMXV2qe'
where id = 1;


