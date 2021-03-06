USE [TD5R1]
GO
/****** Object:  StoredProcedure [dbo].[SetOrderCompleteAttemptStatus]    Script Date: 15.07.2018 12:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SetOrderCompleteAttemptStatus] 
	-- Add the parameters for the stored procedure here
	(@order_id int,  @driver_id int, @summ float, @count int OUT, @status int)
AS
BEGIN 
	DECLARE @dont_reset_time smallint,
		@bonusUse decimal(28, 10);
	SET @count = 0;

	SELECT @count=COUNT(*) FROM Zakaz
	WHERE ((Zakaz.REMOTE_SET=8) OR 
	(Zakaz.REMOTE_SET=10)) AND 
	(Zakaz.BOLD_ID=@order_id) AND
	(Zakaz.vypolnyaetsya_voditelem=@driver_id);
	
	IF(@count>0)
	BEGIN

	EXEC CalcBonusSumm @order_id, 0, @bonusUse = @bonusUse OUTPUT;
	
	UPDATE Zakaz 
	SET Zakaz.REMOTE_SET=@status,
	Zakaz.REMOTE_SUMM=@summ,
	Zakaz.Uslovn_stoim=@summ,
	Zakaz.CLIENT_SMS_SEND_STATE=3 
	WHERE  
	(Zakaz.BOLD_ID=@order_id);

	SET @dont_reset_time = ISNULL(@dont_reset_time, 0)

	IF @driver_id > 0 BEGIN
		SELECT @dont_reset_time = dont_reset_time 
		FROM Voditelj 
		WHERE BOLD_ID = @driver_id;
	END
	
	IF @dont_reset_time <> 1 BEGIN
		UPDATE Voditelj 
		SET Vremya_poslednei_zayavki=CURRENT_TIMESTAMP 
		WHERE BOLD_ID=@driver_id;
	END
	
	SET @count=@@ROWCOUNT;
	
	--ORDER_DRV_COMPLETE = 15;
		--ORDER_COMLETE_ALLOW = 16;
		--ORDER_COMPLETE_ALLOW_USER_WAIT = 26;
		--ORDER_CLOSE_ASK_WAIT = 27;
	
	--IF (@count>0)
	--BEGIN
	--	UPDATE Zakaz SET Uslovn_stoim=@summ
	--	WHERE (Zakaz.BOLD_ID=@order_id) AND
	--	(@status in (15,16,26));
	--END;
	
	EXEC CheckDriverBusy @driver_id;
	
	END
	
END

