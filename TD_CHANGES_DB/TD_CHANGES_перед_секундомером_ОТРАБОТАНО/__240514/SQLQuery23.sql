USE [TD5R1]
GO
/****** Object:  Trigger [dbo].[AFTER_ORDER_SDIRECTION]    Script Date: 05/24/2014 17:05:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER TRIGGER [dbo].[AFTER_ORDER_SDIRECTION] 
   ON  [dbo].[Zakaz] 
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @db_version INT, 
	@odirect_to_dsect smallint;
	
	SET @odirect_to_dsect=0;
	
	SELECT TOP 1 @db_version=ISNULL(db_version,3),
	@odirect_to_dsect=ISNULL(odirect_to_dsect,0) 
	FROM Objekt_vyborki_otchyotnosti
	WHERE Tip_objekta='for_drivers';
	
	IF((@db_version>=5) AND (@odirect_to_dsect=1))
	BEGIN
	
		DECLARE @oldDirSectId int, @newDirSectId int, 
			@newOrdDrId INT;
			
		SELECT @oldDirSectId=b.direct_sect_id, 
		@newDirSectId=a.direct_sect_id,
		@newOrdDrId=a.vypolnyaetsya_voditelem
		FROM inserted a, deleted b

		IF ((@newDirSectId>0) AND (@oldDirSectId<>@newDirSectId) 
			AND (@newOrdDrId>0))
		BEGIN
			EXEC SetDriverSector @newOrdDrId, @newDirSectId, 
				0, 1, '';
		END;

	END;
	
	
	
END


