USE [TD5R1]
GO
/****** Object:  StoredProcedure [dbo].[SetOrderDriverCancelAttStatus]    Script Date: 05/13/2014 00:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[InsertEvent] 
	-- Add the parameters for the stored procedure here
	(@etype_id int, @order_id int, @driver_id int, @sector_id int, 
	@edate datetime, @description varchar(2000), @adres varchar(255), 
	@phone varchar(255), @dr_num int, @count int OUT)
AS
BEGIN 
	--DECLARE @count int;
	SET @count = 0;
	
	SET @count=@@ROWCOUNT;
	
END







