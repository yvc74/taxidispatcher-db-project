USE [TD5R1]
GO
/****** Object:  UserDefinedFunction [dbo].[GetOrdOptsStrByOComb]    Script Date: 09/15/2014 13:53:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER FUNCTION [dbo].[GetOrdOptsStrByOComb]  (@ocomb bigint)
RETURNS varchar(1000)
AS
BEGIN
	DECLARE @res varchar(1000), @option_name varchar(255), 
		@mod2 int, @counter int;
	DECLARE @CURSOR cursor;
   
	SET @res='';
	SET @counter=0;
   
	SET @CURSOR  = CURSOR SCROLL
	FOR
	SELECT OPTION_NAME   
	FROM ORDER_OPTION  
    ORDER BY ID ASC;
    
    OPEN @CURSOR
	/*Выбираем первую строку*/
	FETCH NEXT FROM @CURSOR INTO @option_name
	/*Выполняем в цикле перебор строк*/
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @mod2=@ocomb % 2;
		if(@mod2<>0)
		BEGIN
		    if(@counter>0)
		    BEGIN
				SET @res=@res+' ,';
		    END
			SET @res=@res+@option_name;
			SET @counter=@counter+1;
		END;
		SET @ocomb=@ocomb/2;
		FETCH NEXT FROM @CURSOR INTO @option_name
	END
	CLOSE @CURSOR
    
    SET @res=ISNULL(@res,'');
    if(@res='') 
    BEGIN
		SET @res='Нет опций';
    END 

	RETURN(@res)
END
