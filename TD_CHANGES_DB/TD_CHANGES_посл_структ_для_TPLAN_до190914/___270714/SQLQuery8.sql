USE [TD5R1]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDrLastHoursSumm]    Script Date: 07/27/2014 17:47:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER FUNCTION [dbo].[GetDrLastHoursSumm]  (@DriverId int, @hours int)
RETURNS decimal(28, 10)
AS
BEGIN
   DECLARE @summ decimal(28, 10)
   
   SET @summ=0
   
   select @summ=ISNULL(SUM(Uslovn_stoim),0) from Zakaz
   where vypolnyaetsya_voditelem=@DriverId 
   and (Konec_zakaza_data<=CURRENT_TIMESTAMP) 
   and (Konec_zakaza_data>=DATEADD(hour,@hours,CURRENT_TIMESTAMP)) 
   and Arhivnyi=0 and Soobsheno_voditelyu=0 and Zavershyon=1;   

   RETURN(@summ)
END

