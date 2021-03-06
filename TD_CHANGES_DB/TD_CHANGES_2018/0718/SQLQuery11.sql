USE [TD5R1]
GO
/****** Object:  Trigger [dbo].[AFTER_ORDER_PHONE_CHANGE]    Script Date: 15.07.2018 11:13:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[AFTER_ORDER_PHONE_CHANGE] 
   ON  [dbo].[Zakaz] 
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @db_version INT, 
	@phoneBonus decimal(28,10),
	@newPhone varchar(255),
	@oldPhone varchar(255), @nOldValue int;
	
	SELECT TOP 1 @db_version=ISNULL(db_version,3)
	FROM Objekt_vyborki_otchyotnosti
	WHERE Tip_objekta='for_drivers';
		
	SELECT @nOldValue=b.BOLD_ID, 
	@newPhone = ISNULL(a.Telefon_klienta, ''),
	@oldPhone = b.Telefon_klienta
	FROM inserted a, deleted b

	IF ((@db_version>=5) AND (@newPhone <> '') AND (@newPhone <> @oldPhone) )
	BEGIN

		SELECT COUNT(BOLD_ID)
		FROM Sootvetstvie_parametrov_zakaza sp
		WHERE sp.Telefon_klienta = @newPhone;

		IF @@ROWCOUNT = 1 BEGIN

			SELECT  @phoneBonus = sp.bonus_summ
			FROM Sootvetstvie_parametrov_zakaza sp
			WHERE sp.Telefon_klienta = @newPhone;

			UPDATE Zakaz SET bonus_all = @phoneBonus
			WHERE BOLD_ID = @nOldValue;
		END;

	END;
	
END


