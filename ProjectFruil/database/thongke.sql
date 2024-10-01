/*Top  sản phẩm bán chạy nhất(Thống kê) */
CREATE OR ALTER PROCEDURE sp_GetBestSellProducts
AS
BEGIN
    SET NOCOUNT ON;

SELECT 
    p.id,
    (SELECT TOP 1 thumbnail 
     FROM Gallery 
     WHERE product_id = p.id
     ORDER BY id ASC) AS img,
    p.name,
	pi.price,
    SUM(od.qty) AS total_sold_quantity,
    SUM(od.qty * od.price) AS total_revenue
FROM Order_item od
JOIN Product_Item pi ON od.product_item_id = pi.id
JOIN Product p ON p.id = pi.product_id
GROUP BY p.id, p.name,pi.price
ORDER BY total_sold_quantity DESC;
END
GO
/*Top  sản phẩm bán chạy nhất*/
EXEC sp_GetBestSellProducts;
GO
/*Top  sản phẩm bán chạy nhất theo tháng và năm*/
CREATE OR ALTER PROCEDURE sp_GetBestSellProductsByTime
    @Year INT,
    @Month INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.id,
        (SELECT TOP 1 thumbnail 
         FROM Gallery 
         WHERE product_id = p.id
         ORDER BY id ASC) AS img,
        p.name,
        pi.price,
        SUM(od.qty) AS total_sold_quantity,
        SUM(od.qty * od.price) AS total_revenue
    FROM Order_item od
    JOIN Product_Item pi ON od.product_item_id = pi.id
    JOIN Product p ON p.id = pi.product_id
    JOIN [Order] o ON od.order_id = o.id
    WHERE MONTH(o.create_at) = @Month
        AND YEAR(o.create_at) = @Year
    GROUP BY p.id, p.name, pi.price
    ORDER BY total_sold_quantity DESC;
END
GO
EXEC sp_GetBestSellProductsByTime @Year = 2024, @Month = 8;

GO
/* Số Lượng Đơn Đặt Hàng Trong Tháng*/
CREATE OR ALTER PROCEDURE sp_GetOrdersCountByMonth
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        COUNT(*) AS total_orders
    FROM [Order]
    WHERE MONTH(create_at) = MONTH(GETDATE())
        AND YEAR(create_at) = YEAR(GETDATE())
    GROUP BY MONTH(create_at), YEAR(create_at);
END
GO
EXEC sp_GetOrdersCountByMonth;
/* Số Lượng Đơn Đặt Hàng Trong Tháng*/
GO

/* Số Lượng Order được tạo*/
CREATE OR ALTER PROCEDURE sp_GetOrdersCount
	@Year INT,
    @Month INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CONCAT(MONTH(create_at), '/', YEAR(create_at)) AS [Month_Year],
        COUNT(*) AS total_orders
    FROM [Order]
    WHERE MONTH(create_at) = @Month
        AND YEAR(create_at) = @Year
    GROUP BY MONTH(create_at), YEAR(create_at);
END
GO
EXEC sp_GetOrdersCount @Year = 2024, @Month = 8;
GO
CREATE OR ALTER PROCEDURE sp_GetOrders
	@Year INT,
    @Month INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        o.id, u.id, u.name, u.email, o.total_amount, CONCAT( DAY(o.create_at),'/',MONTH(o.create_at), '/', YEAR(o.create_at)) AS [Month_Year]
    FROM [Order] o
	JOIN [User] u on u.id = o.user_id  
    WHERE MONTH(o.create_at) = @Month
        AND YEAR(o.create_at) = @Year
  
END
GO
EXEC sp_GetOrders @Year = 2024, @Month = 7;
/* Số Lượng Order được tạo*/


/* Số Lượng User được tạo Trong Tháng*/
GO
CREATE OR ALTER PROCEDURE sp_GetUsersCountByMonth
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        COUNT(*) AS total_users
    FROM [User]
    WHERE MONTH(create_at) = MONTH(GETDATE())
        AND YEAR(create_at) = YEAR(GETDATE())
    GROUP BY MONTH(create_at), YEAR(create_at);
END
GO
EXEC sp_GetUsersCountByMonth;
GO

/* Số Lượng User được tạo Trong Tháng*/
CREATE OR ALTER PROCEDURE sp_GetUsersCount
	@Year INT,
    @Month INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
	CONCAT(MONTH(create_at), '/', YEAR(create_at)) AS [Month_Year],
        COUNT(*) AS total_users
    FROM [User]
    WHERE MONTH(create_at) = @Month
        AND YEAR(create_at) = @Year
    GROUP BY MONTH(create_at), YEAR(create_at);
END
GO
EXEC sp_GetUsersCount @Year = 2024, @Month = 7;
GO

CREATE OR ALTER PROCEDURE sp_GetUsersByTime
	@Year INT,
    @Month INT
AS
	SELECT id, name, email, CONCAT( DAY(create_at),'/',MONTH(create_at), '/', YEAR(create_at)) AS [Month_Year]
	FROM [User]
	WHERE MONTH(create_at) = @Month
        AND YEAR(create_at) = @Year
    ;
GO
EXEC sp_GetUsersByTime @Year = 2024, @Month = 7;



GO
/* Tổng Doanh thu Trong Tháng*/
CREATE OR ALTER PROCEDURE sp_GetRevenueByMonth
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        SUM(total_amount) AS total_Revenue
	FROM [Order] 
    WHERE MONTH(create_at) = MONTH(GETDATE())
        AND YEAR(create_at) = YEAR(GETDATE())
    GROUP BY MONTH(create_at), YEAR(create_at);
END
GO
EXEC sp_GetRevenueByMonth;
GO

/* Tổng Doanh thu theo tháng và năm*/
CREATE OR ALTER PROCEDURE sp_GetRevenue
    @Year INT,
    @Month INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
		CONCAT(MONTH(create_at), '/', YEAR(create_at)) AS [Month_Year],
        SUM(total_amount) AS total_Revenue
    FROM [Order] 
    WHERE MONTH(create_at) = @Month
        AND YEAR(create_at) = @Year
    GROUP BY MONTH(create_at), YEAR(create_at);
END

EXEC sp_GetRevenue @Year = 2024, @Month = 7;
GO

use TRAICAY_DUAN1_V1