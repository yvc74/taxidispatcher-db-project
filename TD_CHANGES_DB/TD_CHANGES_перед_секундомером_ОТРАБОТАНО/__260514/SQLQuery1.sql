USE [TD5R1]
GO
/****** Object:  StoredProcedure [dbo].[ProceedOperationRequest]    Script Date: 05/26/2014 22:35:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[ProceedOperationRequest] 
	-- Add the parameters for the stored procedure here
	(@opnm varchar(255), @prm1 int, @prm2 int, 
	 @prm3 int, @prm4 varchar(255), @prm5 varchar(255), 
	 @op_answer varchar(5000) OUT)
AS
BEGIN 

	DECLARE @dr_balance decimal(28,10), 
		@last12h_summ decimal(28,10);

	SET @op_answer = '{"command":"opa","scs":"yes","opnm":"'+
		@opnm+'",';
		
	if (@opnm='dr_bal')
	begin
	
		SET @dr_balance =0;
		SET @last12h_summ=0;
	
		SELECT @dr_balance=ISNULL(DRIVER_BALANCE,0),
			@last12h_summ=dbo.GetDrLastHoursSumm(ISNULL(@prm1,-1),-12) 
		from Voditelj
		WHERE BOLD_ID=ISNULL(@prm1,-1);
		
		SET @op_answer = @op_answer + '"dr_bal":"'+
			CAST(CAST(@dr_balance as INT) as VARCHAR(255))+'",'+ '"lst12hs":"'+
			CAST(CAST(@last12h_summ as INT) as VARCHAR(255))+'",';
	end
	
	SET @op_answer = @op_answer + '"msg_end":"ok"}';
	
END



