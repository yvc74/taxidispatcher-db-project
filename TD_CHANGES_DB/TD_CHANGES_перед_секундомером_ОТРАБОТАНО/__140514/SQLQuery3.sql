USE [TD5R1]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDrComment]    Script Date: 05/14/2014 11:53:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[GetUseDrBCounter] ()
RETURNS int
AS
BEGIN
   DECLARE @use_dr_bcounter int
   
   SELECT @use_dr_bcounter=use_dr_balance_counter FROM Objekt_vyborki_otchyotnosti WHERE Tip_objekta='for_drivers';  

   SET @use_dr_bcounter=ISNULL(@use_dr_bcounter,0);

   RETURN(@use_dr_bcounter)
END
