USE [TD5R1]
GO
/****** Object:  StoredProcedure [dbo].[GetOrderRatingBonus]    Script Date: 31.08.2018 20:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[GetOrderRatingBonus] 
	-- Add the parameters for the stored procedure here
	(@order_id int, @driver_id int, @add_bonus_in_table smallint, 
		@allow_bonus_duplicate smallint, @rating_bonus decimal(18, 5) OUT)
AS
BEGIN
	SET @rating_bonus = 0;
	SET @add_bonus_in_table = ISNULL(@add_bonus_in_table, 0);
	SET @allow_bonus_duplicate = ISNULL(@allow_bonus_duplicate, 0);
 
    DECLARE @order_rating_bonus decimal(18, 5), 
		@old_order_rating_bonus decimal(18, 5),
		@peak_one_start time(7),
		@peak_one_lenght smallint,
		@peak_one_bonus decimal(18, 5),
		@peak_two_start time(7),
		@peak_two_lenght smallint,
		@peak_two_bonus decimal(18, 5),
		@peak_three_start time(7),
		@peak_three_lenght smallint,
		@peak_three_bonus decimal(18, 5),
		@old_order_time int,
		@order_rating_bonus_time int,
		@old_order_rbonus_time int,
		@peak_one_bonus_time int,
		@peak_two_bonus_time int,
		@peak_three_bonus_time int,
		@start_order_date datetime,
		@expire_date datetime,
		@startOfToday datetime, 
		@ratingBonusCode varchar(255);

	SELECT TOP 1 @order_rating_bonus = order_rating_bonus,
		@old_order_rating_bonus = old_order_rating_bonus,
		@peak_one_start = peak_one_start,
		@peak_one_lenght = peak_one_lenght,
		@peak_one_bonus = peak_one_bonus,
		@peak_two_start = peak_two_start,
		@peak_two_lenght = peak_two_lenght,
		@peak_two_bonus = peak_two_bonus,
		@peak_three_start = peak_three_start,
		@peak_three_lenght = peak_three_lenght,
		@peak_three_bonus = peak_three_bonus,
		@old_order_time = old_order_time,
		@order_rating_bonus_time = order_rating_bonus_time,
		@old_order_rbonus_time = old_order_rbonus_time,
		@peak_one_bonus_time = peak_one_bonus_time,
		@peak_two_bonus_time = peak_two_bonus_time,
		@peak_three_bonus_time = peak_three_bonus_time
	FROM Objekt_vyborki_otchyotnosti
	WHERE Tip_objekta='for_drivers';
   
	select @start_order_date = Nachalo_zakaza_data
		from Zakaz where BOLD_ID = @order_id;

	SET @expire_date = GETDATE();
	SET @ratingBonusCode = '';

	IF NOT @driver_id > 0 BEGIN
		SET @add_bonus_in_table = 0;
	END;

	SET @startOfToday = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	IF @peak_one_lenght > 0 AND @peak_one_bonus > 0 AND @peak_one_bonus_time > 0 AND
		@start_order_date >= (@startOfToday + @peak_one_start) AND 
		@start_order_date < DATEADD(MINUTE, @peak_one_lenght, @startOfToday + @peak_one_start)
	BEGIN
		SET @rating_bonus = @peak_one_bonus;
		SET @expire_date = DATEADD(MINUTE, @peak_one_bonus_time, GETDATE());
		SET @ratingBonusCode = 'peak_one';
	END
	ELSE IF @peak_two_lenght > 0 AND @peak_two_bonus > 0 AND @peak_two_bonus_time > 0 AND
		@start_order_date >= (@startOfToday + @peak_two_start) AND
		@start_order_date <= DATEADD(MINUTE, @peak_two_lenght, @startOfToday + @peak_two_start)
	BEGIN
		SET @rating_bonus = @peak_two_bonus;
		SET @expire_date = DATEADD(MINUTE, @peak_two_bonus_time, GETDATE());
		SET @ratingBonusCode = 'peak_two';
	END
	ELSE IF @peak_three_lenght > 0 AND @peak_three_bonus > 0 AND @peak_three_bonus_time > 0 AND
		@start_order_date >= (@startOfToday + @peak_three_start) AND
		@start_order_date <= DATEADD(MINUTE, @peak_three_lenght, @startOfToday + @peak_three_start)
	BEGIN
		SET @rating_bonus = @peak_three_bonus;
		SET @expire_date = DATEADD(MINUTE, @peak_three_bonus_time, GETDATE());
		SET @ratingBonusCode = 'peak_three';
	END
	ELSE IF @old_order_rating_bonus > 0 AND @old_order_time > 0 AND 
		@start_order_date < GETDATE() AND @old_order_rbonus_time > 0 AND 
		ABS(DATEDIFF(MINUTE, @start_order_date, GETDATE())) >= @old_order_time
	BEGIN
		SET @rating_bonus = @old_order_rating_bonus;
		SET @expire_date = DATEADD(MINUTE, @old_order_rbonus_time, GETDATE());
		SET @ratingBonusCode = 'old_order';
	END
	ELSE IF @order_rating_bonus > 0 AND @order_rating_bonus_time > 0
	BEGIN
		SET @rating_bonus = @order_rating_bonus;
		SET @expire_date = DATEADD(MINUTE, @order_rating_bonus_time, GETDATE());
		SET @ratingBonusCode = 'simple_order';
	END;

	IF @add_bonus_in_table = 1 AND @rating_bonus > 0 BEGIN
		EXEC InsertDriverRating @driver_id, @expire_date, 
			@ratingBonusCode, @order_rating_bonus, @allow_bonus_duplicate;
	END

	UPDATE Zakaz 
	SET driver_rating_diff = @rating_bonus,
	driver_rating_expire_date = @expire_date,
	driver_rating_bonus_code = @ratingBonusCode
	WHERE BOLD_ID = @order_id;
END


