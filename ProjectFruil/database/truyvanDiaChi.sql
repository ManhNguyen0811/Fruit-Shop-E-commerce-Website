/* CRUD USERS */
/* Thêm User*/
INSERT INTO [User] (password, name, phone, email, role)
VALUES ('123', 'dat', '123456789', 'datttps37451@fpt.edu.vn', 1);
INSERT INTO [User] (password, name, phone, email, role)
VALUES ('123', 'khachhang', '234567891', 'test@fpt.edu.vn', 0);
/* xem users*/
SELECT * FROM [User];
/* xem users theo id*/
SELECT * FROM [User]
WHERE id = 1;
/*update user*/
UPDATE [User]
SET name = 'dat 22',password= '456',email='dat22@gmail.com'
WHERE id = 6;
/*xóa user*/
DELETE FROM [User]
WHERE id = 3;
GO


SELECT a.id, ua.user_id, u.name , a.city, a.ward, a.street, ua.is_Default
FROM User_Address ua
JOIN Address a ON a.id = ua.address_id
JOIN [User] u ON u.id = ua.user_id
WHERE u.name LIKE 'dat'

/*CRUD ADDRESS*/
/*Thêm address của client*/
CREATE OR ALTER PROCEDURE sp_CreateAddressClient
    @user_id INT,
    @city NVARCHAR(50),
    @ward NVARCHAR(50),
    @street NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    INSERT INTO Address (city, ward, street)
    VALUES (@city, @ward, @street);

    DECLARE @new_address_id INT = SCOPE_IDENTITY();

    DECLARE @existing_default_address_id INT = NULL;
    SELECT @existing_default_address_id = address_id
    FROM User_Address
    WHERE user_id = @user_id AND is_Default = 0;

    IF  @existing_default_address_id IS NOT NULL
    BEGIN
        INSERT INTO User_Address (user_id, address_id, is_Default)
		VALUES (@user_id, @new_address_id, 1);
    END
	ELSE IF @existing_default_address_id IS NULL
	   BEGIN
		INSERT INTO User_Address (user_id, address_id, is_Default)
		VALUES (@user_id, @new_address_id, 0);
        END
    COMMIT TRANSACTION;
END
GO
EXEC CreateAddress @user_id = 1, @city= N'TPHCM', @ward = N'Quận 8', @street = N'Âu Dương Lân';
EXEC CreateAddress @user_id = 2, @city= N'Hà Nội', @ward = N'Hoàng Mai', @street = N'7/11 ABC';
EXEC CreateAddress @user_id = 6, @city= N'TPHCM', @ward = N'Quận 5', @street = N'14B Trần Bình Trọng';
GO
/*Thêm address của Admin*/
CREATE OR ALTER PROCEDURE sp_CreateAddressAdmin
    @user_id INT,
    @city NVARCHAR(50),
    @ward NVARCHAR(50),
    @street NVARCHAR(100),
	@is_Default bit
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    INSERT INTO Address (city, ward, street)
    VALUES (@city, @ward, @street);

    DECLARE @new_address_id INT = SCOPE_IDENTITY();

	/*Tìm có địa chỉ nào là mặc định chưa */
    DECLARE @existing_default_address_id INT = NULL;
    SELECT @existing_default_address_id = address_id
    FROM User_Address
    WHERE user_id = @user_id AND is_Default = 0;
	/*Nếu thêm địa chỉ là mặc định và đã tồn tại địa chỉ mặc định */
	IF @is_Default = 0 AND @existing_default_address_id IS NOT NULL
    BEGIN
	/*set không mặc định cho tất cả các địa chỉ*/
        UPDATE User_Address
        SET is_Default = 1
        WHERE user_id = @user_id AND is_Default = 0;
    /*Thêm*/
        INSERT INTO User_Address (user_id, address_id, is_Default)
        VALUES (@user_id, @new_address_id, @is_Default);
    END
	ELSE
    BEGIN    
        INSERT INTO User_Address (user_id, address_id, is_Default)
        VALUES (@user_id, @new_address_id, @is_Default);
    END
    COMMIT TRANSACTION;
END
GO

EXEC sp_CreateAddressAdmin @user_id = 1, @city=N'A City', @ward=N'Quận A', @street=N'14A Đường A', @is_Default = 0;
EXEC sp_CreateAddressAdmin @user_id = 1, @city=N'C City', @ward=N'Quận C', @street=N'14A Đường C', @is_Default = 0;
/*show hết tất cả địa chỉ của user id 1*/
SELECT 
	a.id,
    a.city, 
    a.ward, 
    a.street,
    ua.is_Default
FROM User_Address ua
JOIN Address a ON ua.address_id = a.id
WHERE ua.user_id = 2;
GO
/* Lấy địa chỉ default*/
SELECT 
    u.id AS user_id,
    u.name AS user_name,
    a.id AS address_id,
    a.city, 
    a.ward,
    a.street
FROM [User] u
JOIN User_Address ua ON u.id = ua.user_id
JOIN Address a ON ua.address_id = a.id
WHERE ua.is_Default = 0
GO
/*cập nhật địa chỉ  client*/

CREATE or ALTER PROCEDURE sp_UpdateAddressClient
    @address_id INT,
    @city NVARCHAR(50),
    @ward NVARCHAR(50),
    @street NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    UPDATE Address
    SET city = @city, 
        ward = @ward,
        street = @street
    WHERE id = @address_id;

    COMMIT TRANSACTION;
END
GO
EXEC sp_UpdateAddressClient  @address_id = 8, @city =N'Thành Phố C', @ward=N'Quận C',@street=N'Đường C';

GO
/*cập nhật địa chỉ admin*/
CREATE OR ALTER PROCEDURE sp_UpdateAddressAdmin
    @user_id INT,
    @address_id INT,
    @city NVARCHAR(50),
    @ward NVARCHAR(50),
    @street NVARCHAR(100),
    @is_default BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    
    UPDATE Address
    SET city = @city,
        ward = @ward,
        street = @street
    WHERE id = @address_id;

    DECLARE @current_is_default BIT;
    SELECT @current_is_default = is_Default
    FROM User_Address
    WHERE user_id = @user_id AND address_id = @address_id;

    
    IF @is_default <> @current_is_default
    BEGIN
       DECLARE @new_default_address_id INT;
        IF @is_default = 1 AND NOT EXISTS (
            SELECT 1
            FROM User_Address
            WHERE user_id = @user_id AND is_Default = 0 AND address_id <> @address_id
        )
        BEGIN
            SELECT TOP 1 @new_default_address_id = address_id
            FROM User_Address
            WHERE user_id = @user_id AND address_id <> @address_id
            ORDER BY address_id;

            UPDATE User_Address
            SET is_Default = 0
            WHERE user_id = @user_id AND address_id = @new_default_address_id;
        END

		 IF @is_default = 0 AND EXISTS (
            SELECT 1
            FROM User_Address
            WHERE user_id = @user_id AND is_Default = 0 AND address_id <> @address_id
        )
        BEGIN
            UPDATE User_Address
            SET is_Default = 1
            WHERE user_id = @user_id;

            UPDATE User_Address
            SET is_Default = 0
            WHERE user_id = @user_id AND address_id = @new_default_address_id;
        END

        UPDATE User_Address
        SET is_Default = @is_default
        WHERE user_id = @user_id AND address_id = @address_id;
    END

    COMMIT TRANSACTION;
END

EXEC sp_UpdateAddressAdmin @user_id = 1, @address_id =1, @city= N'TPHCM', @ward=N'Quận 8', @street=N'Âu dương lân', @is_default = 1

SELECT * FROM User_Address
WHERE user_id = 1

GO
/*Xóa địa chỉ cho 1 user */
CREATE or ALTER PROCEDURE sp_DeleteUserAddress
    @user_id INT,
    @address_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    -- Kiểm tra xem địa chỉ này có phải là địa chỉ mặc định không
    DECLARE @is_Default BIT
    SELECT @is_Default = is_Default 
    FROM User_Address
    WHERE user_id = @user_id AND address_id = @address_id

    -- Nếu đây là địa chỉ mặc định, chuyển địa chỉ khác thành mặc định
    IF @is_Default = 0
    BEGIN
        DECLARE @new_default_address_id INT
        SELECT TOP 1 @new_default_address_id = address_id
        FROM User_Address
        WHERE user_id = @user_id AND address_id <> @address_id
        ORDER BY address_id

        UPDATE User_Address
        SET is_Default = 0
        WHERE user_id = @user_id AND address_id = @new_default_address_id
    END

    -- Xóa địa chỉ khỏi bảng User_Address
    DELETE FROM User_Address
    WHERE user_id = @user_id AND address_id = @address_id

    -- Xóa địa chỉ khỏi bảng Address
    DELETE FROM Address
    WHERE id = @address_id

    COMMIT TRANSACTION;
END
GO
EXEC sp_DeleteUserAddress @user_id = 1, @address_id = 2;
GO

/*Đặt làm địa chỉ mặc định*/
CREATE PROCEDURE sp_SetDefaultUserAddress
    @UserID INT,
    @AddressID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật tất cả các địa chỉ của người dùng để không phải là địa chỉ mặc định
    UPDATE user_address
    SET is_default = 1
    WHERE user_id = @UserID;

    -- Đặt địa chỉ được chỉ định là địa chỉ mặc định của người dùng
    UPDATE user_address
    SET is_default = 0
    WHERE user_id = @UserID AND address_id = @AddressID;
END
GO
EXEC sp_SetDefaultUserAddress @UserID =1 , @AddressID = 7

SELECT * FROM User_Address where user_id = 1
