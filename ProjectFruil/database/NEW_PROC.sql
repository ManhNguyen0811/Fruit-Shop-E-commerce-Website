
 
 /* đếm qty wishlist */
select count(product_item_id) from WishList where user_id =2

/*RENDER WISH LIST */
select pd.name , p.qty_in_stock ,g.thumbnail ,p.price  from Product_Item p
inner join Gallery g on g.product_id = p.id
inner join Product pd on pd.id = p.product_id

go


CREATE OR ALTER PROC fillItemWishList 
		@product_item_id int 
as
begin
			select DISTINCT pd.name , p.qty_in_stock ,
			(SELECT TOP 1 thumbnail 
			FROM Gallery 
			WHERE product_id = p.id
			ORDER BY id ASC) AS img
			,p.price  
			from Product_Item p
			inner join Gallery g on g.product_id = p.id
			inner join Product pd on pd.id = p.product_id
			where p.id = @product_item_id

end

EXEC fillItemWishList @product_item_id =3 






/* (orderDAO) lấy id_product fill lên chi tiết lịch sử mua hàng 1 ảnh WEB */
CREATE OR ALTER PROCEDURE GetOrderItemDetails
    @order_id INT
AS
BEGIN
    ;WITH GalleryRanked AS (
        SELECT ga.product_id,
               ga.thumbnail,
               ROW_NUMBER() OVER (PARTITION BY ga.product_id ORDER BY ga.id) AS rn
        FROM Gallery ga
    )
    SELECT oi.*,
           u.phone,
           pro.name,
           gr.thumbnail,
           (oi.price * oi.qty) AS total,
           o.shipping_address,
           o.total_amount,
           o.user_payment_method_id,
           payT.name AS payment_type_name,
           u.name AS nameUser,
         
           SUM(oi.price * oi.qty) OVER (PARTITION BY oi.order_id) AS totalAll,
		         SUM( oi.qty) OVER (PARTITION BY oi.order_id) AS qtyAll
    FROM Order_Item oi
    INNER JOIN [Order] o ON oi.order_id = o.id
    INNER JOIN [User] u ON u.id = o.user_id
    INNER JOIN Product_Item pi ON oi.product_item_id = pi.id
    INNER JOIN Product pro ON pro.id = pi.product_id
    INNER JOIN GalleryRanked gr ON gr.product_id = pro.id AND gr.rn = 1
    INNER JOIN User_Payment_Method payUser ON o.user_payment_method_id = payUser.id
    INNER JOIN Payment_Type payT ON payT.id = payUser.payment_type_id
    WHERE oi.order_id = @order_id;
END
GO
EXEC GetOrderItemDetails @order_id = 3


select * from Gallery where product_id =1 
select * from [Order]
/*   */

SELECT SUM(qty) from Cart where user_id = 1


