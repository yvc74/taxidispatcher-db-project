USE [TD5R1]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDrUseDynBByNum]    Script Date: 05/24/2014 02:47:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[GetDrDynBalanceByNum]  ( @dr_num int)
RETURNS decimal(28,10)
AS
BEGIN
   declare @res decimal(28,10)
   
   SET @res=0
   
   if (@dr_num>0)
   begin
	select @res=DRIVER_BALANCE   
	from Voditelj where 
		Pozyvnoi=@dr_num 
   end

   SET @res=ISNULL(@res,0);

   RETURN(@res)
END