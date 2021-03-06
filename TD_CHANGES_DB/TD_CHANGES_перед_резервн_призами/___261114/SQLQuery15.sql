USE [TD5R1]
GO
/****** Object:  StoredProcedure [dbo].[RealizeTDEvent]    Script Date: 11/26/2014 13:57:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[RealizeTDEvent] 
	-- Add the parameters for the stored procedure here
	(@event_id int)
AS
BEGIN 
    DECLARE @event_type int, @summ decimal(28, 10), @edate datetime, @count int, @dr_num int;
    SELECT @event_type=ETYPE_ID, @summ=SUMM, @edate=EDATE,
    @dr_num=DR_NUM FROM TD_EVENTS WHERE EVENT_ID=@event_id;
    SET @summ = -@summ;
	IF(@event_type=7)	
	BEGIN
		EXEC InsertNewDriverIncome -1, 1, @summ, @edate, @dr_num, @count = @count OUTPUT;
		UPDATE Voditelj set daily_paym_status=0 where Pozyvnoi=@dr_num;
	END;
	UPDATE TD_EVENTS 
	SET CLOSED=1 
	WHERE EVENT_ID=@event_id;
END

