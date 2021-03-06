USE [TD5R1]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDriverRating]    Script Date: 31.08.2018 23:39:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER FUNCTION [dbo].[GetDriverRating]  (@driver_id int)
RETURNS decimal(18, 5)
AS
BEGIN
	DECLARE @rating decimal(18, 5), 
	@base_referral_bonus decimal(18, 5),
	@base_ref_bonus_interval int;

	SELECT TOP 1 @base_referral_bonus = base_referral_bonus,
	@base_ref_bonus_interval = base_ref_bonus_interval
	FROM Objekt_vyborki_otchyotnosti
	WHERE Tip_objekta='for_drivers';

	SET @base_referral_bonus = ISNULL(@base_referral_bonus,0);
	SET @base_ref_bonus_interval = ISNULL(@base_ref_bonus_interval,0);
   
	select @rating = rating FROM Voditelj
	where BOLD_ID = @driver_id

	select @rating = @rating + COUNT(BOLD_ID) * @base_referral_bonus from Voditelj
	where referral_driver_id = @driver_id AND @base_ref_bonus_interval > 0 AND
		referral_set_date < GETDATE() AND
		DATEDIFF(HOUR, referral_set_date, GETDATE()) < @base_ref_bonus_interval
   
	select @rating = @rating + SUM(change_value) from DRIVER_RATING
	where driver_id = @driver_id  

	RETURN(@rating)
END


