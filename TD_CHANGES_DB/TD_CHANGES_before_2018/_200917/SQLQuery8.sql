USE [TD5R1]
GO
/****** Object:  StoredProcedure [dbo].[SetOrdersWideBroadcasts]    Script Date: 20.09.2017 14:16:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SetOrdersWideBroadcasts] 
	-- Add the parameters for the stored procedure here
	(@set_owbcast int, @forders_bcasts varchar(5000) OUT)
AS
BEGIN 

	DECLARE @db_version INT, @use_fordbroadcast_priority int;
	
	SELECT TOP 1 @db_version=ISNULL(db_version,3),
	@use_fordbroadcast_priority=ISNULL(use_fordbroadcast_priority,0) 
	FROM Objekt_vyborki_otchyotnosti
	WHERE Tip_objekta='for_drivers';

	SET @forders_bcasts='';
	IF (ISNULL(@set_owbcast,0)=1)
	BEGIN
		IF @use_fordbroadcast_priority = 0
		BEGIN
			SELECT @forders_bcasts=ISNULL(dbo.GetJSONOrdersBCasts(),'');
			UPDATE Objekt_vyborki_otchyotnosti 
			SET forders_wbroadcast=@forders_bcasts,
			has_ford_wbroadcast=1;
		END
		ELSE
		BEGIN
			DECLARE @CURSOR cursor, @DRID int, @priority int;
				
			SELECT BOLD_ID FROM Voditelj;
			IF @@ROWCOUNT>0
			BEGIN

				SET @CURSOR  = CURSOR SCROLL
				FOR SELECT BOLD_ID, [Priority] FROM Voditelj;
					
				/*Открываем курсор*/
				OPEN @CURSOR
				/*Выбираем первую строку*/
				FETCH NEXT FROM @CURSOR INTO @DRID, @priority;
				/*Выполняем в цикле перебор строк*/
				WHILE @@FETCH_STATUS = 0
				BEGIN
					UPDATE Voditelj SET forders_wbroadcast = ISNULL(dbo.GetJSONDriverOrdersBCasts(@DRID),'');
					FETCH NEXT FROM @CURSOR INTO @DRID, @priority;
				END
				CLOSE @CURSOR
			END
		END
	END
	ELSE
	BEGIN
		UPDATE Objekt_vyborki_otchyotnosti
		SET has_ford_wbroadcast=0;
	END;
END
