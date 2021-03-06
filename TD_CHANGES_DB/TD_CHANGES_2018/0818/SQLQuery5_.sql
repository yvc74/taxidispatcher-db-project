USE [TD5R1]
GO
/****** Object:  StoredProcedure [dbo].[RecalcCurrentOrderRatingBonuses]    Script Date: 31.08.2018 19:19:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[RecalcCurrentOrderRatingBonuses] 
	-- Add the parameters for the stored procedure here
AS
BEGIN 
	DECLARE @CURSOR cursor, @order_id int, 
		@rating_bonus decimal(18, 5);

	SET @CURSOR  = CURSOR SCROLL
	FOR
	SELECT BOLD_ID  
	FROM Zakaz 
	WHERE Zavershyon = 0 AND Arhivnyi = 0;
	/*Открываем курсор*/
	OPEN @CURSOR
	/*Выбираем первую строку*/
	FETCH NEXT FROM @CURSOR INTO @order_id
	/*Выполняем в цикле перебор строк*/
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC GetOrderRatingBonus @order_id, 0, 0, 0, 
			@rating_bonus = @rating_bonus OUTPUT;

		/*Выбираем следующую строку*/
		FETCH NEXT FROM @CURSOR INTO @order_id
	END
	CLOSE @CURSOR
END












