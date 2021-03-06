USE [TD5R1]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDriversCCHTTPParams]    Script Date: 09.03.2017 21:47:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER FUNCTION [dbo].[GetDriversCCHTTPParams] ()
RETURNS varchar(1500)
AS
BEGIN
	declare @res varchar(1500);
	DECLARE @CURSOR cursor;
	DECLARE @dr_count int,
		@lat varchar(50), @lon varchar(50), 
		@counter int, @dr_num int;
   
	SET @res='dc=0';
	SET @counter = 0;
	
	SELECT @dr_count=COUNT(*)  
	FROM Voditelj WHERE ISNULL(last_lat,'')<>'' 
	AND ISNULL(last_lon,'')<>'' AND Pozyvnoi>0 
	AND (ABS(DATEDIFF(minute, last_cctime, GETDATE())) < 10);
	
	IF (@dr_count>0)
	BEGIN
	
	SET @res='dc='+CAST(@dr_count as varchar(20));
	
	SET @CURSOR  = CURSOR SCROLL
	FOR
	SELECT last_lat, last_lon, Pozyvnoi  
	FROM Voditelj WHERE ISNULL(last_lat,'')<>'' 
	AND ISNULL(last_lon,'')<>'' AND Pozyvnoi>0; 
	--AND (ABS(DATEDIFF(minute, last_cctime, GETDATE())) < 10);
	/*Открываем курсор*/
	OPEN @CURSOR
	/*Выбираем первую строку*/
	FETCH NEXT FROM @CURSOR INTO @lat, @lon, @dr_num
	/*Выполняем в цикле перебор строк*/
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @counter=@counter+1;
        SET @res=@res+'&lat'+CAST(@counter as varchar(20))+'='+CAST(@lat as varchar(20))+
			'&lon'+CAST(@counter as varchar(20))+'='+CAST(@lon as varchar(20))+
			'&dn'+CAST(@counter as varchar(20))+'='+CAST(@dr_num as varchar(20));
        
		/*Выбираем следующую строку*/
		FETCH NEXT FROM @CURSOR INTO @lat, @lon, @dr_num
	END
	CLOSE @CURSOR
	
	END

	RETURN(@res)
END
