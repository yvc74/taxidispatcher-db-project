USE [TD5R1]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDrComment]    Script Date: 05/14/2014 11:53:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[GetDriversMinBalance] ()
RETURNS decimal(28,10)
AS
BEGIN
   DECLARE @min_debet decimal(28,10)
   
   SELECT @min_debet=MIN_DEBET FROM Objekt_vyborki_otchyotnosti WHERE Tip_objekta='for_drivers';  

   SET @min_debet=ISNULL(@min_debet,0);

   RETURN(@min_debet)
END
