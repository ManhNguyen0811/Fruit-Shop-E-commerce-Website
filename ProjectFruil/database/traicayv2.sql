USE MASTER
CREATE DATABASE TRAICAY_DUAN1_V1
GO

USE TRAICAY_DUAN1_V1
GO

CREATE TABLE [User] (
	id int identity(1,1) not null,
	password varchar(100) not null,
	name nvarchar(100) not null,
	phone varchar(20) unique,
	email varchar(100) unique,
	role bit not null DEFAULT 0,
	create_at DATETIME DEFAULT GETDATE(),
	update_at DATETIME DEFAULT GETDATE(),
	primary key(id)
);
GO

CREATE TABLE Address (
    id INT IDENTITY(1,1) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    ward NVARCHAR(100) NOT NULL,
    street NVARCHAR(200) NOT NULL,
    PRIMARY KEY (id)
);

GO
CREATE TABLE User_Address (
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    is_Default BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, address_id),
    FOREIGN KEY (user_id) REFERENCES [User](id),
    FOREIGN KEY (address_id) REFERENCES Address(id)
);
GO

CREATE TABLE Category (
    id INT IDENTITY(1,1) NOT NULL,
	parent_id INT NULL,
    name NVARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
	FOREIGN KEY (parent_id) REFERENCES Category(id)
);
GO

CREATE TABLE Product (
    id INT IDENTITY(1,1) NOT NULL,
    category_id INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (id),
    FOREIGN KEY (category_id) REFERENCES Category(id)
);
GO

CREATE TABLE Gallery (
    id INT IDENTITY(1,1) NOT NULL,
    product_id INT NOT NULL,
    thumbnail NVARCHAR(200) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES Product(id)
);
GO

CREATE TABLE Product_Item (
    id INT IDENTITY(1,1) NOT NULL,
    product_id INT NOT NULL,
    qty_in_stock INT NOT NULL,
    price FLOAT NOT NULL,
    original_price FLOAT NOT NULL,
	create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES Product(id)
);
GO

CREATE TABLE Cart (
    id INT IDENTITY(1,1) NOT NULL,
    user_id INT NOT NULL,
    product_item_id INT NOT NULL,
    qty INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES [User](id),
    FOREIGN KEY (product_item_id) REFERENCES Product_Item(id)
);
GO

CREATE TABLE WishList (
    id INT IDENTITY(1,1) NOT NULL,
    user_id INT NOT NULL,
    product_item_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES [User](id),
    FOREIGN KEY (product_item_id) REFERENCES Product_Item(id)
);
GO

CREATE TABLE Payment_Type(
	id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);
GO

CREATE TABLE User_Payment_Method(
    id INT IDENTITY(1,1) NOT NULL,
    user_id INT NOT NULL,
    payment_type_id INT NOT NULL,
    card_number VARCHAR(20) NOT NULL,
    card_holder_name NVARCHAR(100) NOT NULL,
    expiry_date DATE NOT NULL,
    provider NVARCHAR(50) NOT NULL,
    is_default BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES [User](id),
    FOREIGN KEY (payment_type_id) REFERENCES Payment_Type(id)
);
GO

CREATE TABLE [Order](
	id INT IDENTITY(1,1) NOT NULL,
    user_id INT NOT NULL,
    user_payment_method_id INT NOT NULL,
	address_id INT NOT NULL,
	shipping_address nvarchar(255) NOT NULL,
	order_status bit NOT NULL DEFAULT 1,
	total_amount float not null,
	create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES [User](id),
    FOREIGN KEY (user_payment_method_id) REFERENCES User_Payment_Method(id)
);


CREATE TABLE Order_Item(
    id INT IDENTITY(1,1) NOT NULL,
    order_id INT NOT NULL,
    product_item_id INT NOT NULL,
    qty INT NOT NULL,
    price FLOAT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES [Order](id),
    FOREIGN KEY (product_item_id) REFERENCES Product_Item(id)
);
GO

CREATE TABLE Review (
    id INT IDENTITY(1,1) NOT NULL,
    ordered_product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating_value INT NOT NULL CHECK (rating_value BETWEEN 1 AND 5),
    comment NVARCHAR(500) NOT NULL,
    create_at DATETIME NOT NULL DEFAULT GETDATE(),
	update_at DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (id),
    FOREIGN KEY (ordered_product_id) REFERENCES  Order_Item(id),
    FOREIGN KEY (user_id) REFERENCES [User](id)
);
GO



