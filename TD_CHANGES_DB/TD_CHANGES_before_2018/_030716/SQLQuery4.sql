USE [TD5R1]
GO
/****** Object:  StoredProcedure [dbo].[One10SecTask]    Script Date: 03.07.2016 14:56:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[One10SecTask] 
	(@success int OUT)
AS
BEGIN 

	DECLARE @auto_bsector_longorders smallint, @auto_bsectorid_longorders int,
			@auto_bsector_longtime int, @auto_bsector_onlineorders smallint,
			@auto_bsectorid_onlineorders int, @auto_bsector_onlinetime int,
			@auto_neardriver_onlineorders smallint, @auto_neardriver_onlinetime int;
	
	SELECT TOP 1 @auto_bsector_longorders=ISNULL(auto_bsector_longorders,0),
	@auto_bsectorid_longorders=ISNULL(auto_bsectorid_longorders,-1),
	@auto_bsector_longtime=ISNULL(auto_bsector_longtime,0),
	@auto_bsector_onlineorders=ISNULL(auto_bsector_onlineorders,0),
	@auto_bsectorid_onlineorders=ISNULL(auto_bsectorid_onlineorders,-1),
	@auto_bsector_onlinetime=ISNULL(auto_bsector_onlinetime,0),
	@auto_neardriver_onlineorders=ISNULL(auto_neardriver_onlineorders,0), 
	@auto_neardriver_onlinetime=ISNULL(auto_neardriver_onlinetime,0)
	FROM Objekt_vyborki_otchyotnosti
	WHERE Tip_objekta='for_drivers';
	
	SET @success=0;

	if @auto_bsectorid_longorders<=-1 begin
		SELECT TOP 1 @auto_bsectorid_longorders=BOLD_ID FROM Sektor_raboty;
	end

	if @auto_bsectorid_onlineorders<=-1 begin
		SELECT TOP 1 @auto_bsectorid_onlineorders=BOLD_ID FROM Sektor_raboty;
	end

	BEGIN TRY
		if @auto_bsector_longorders>0 and @auto_bsector_longtime>0 and @auto_bsectorid_longorders>-1 begin
			UPDATE dbo.Zakaz SET konechnyi_sektor_raboty=@auto_bsectorid_longorders, 
			SECTOR_ID=@auto_bsectorid_longorders, REMOTE_SET=2, Priority_counter=0
			WHERE (Arhivnyi = 0) AND (Zavershyon = 0) AND (REMOTE_SET = 0) and (Predvariteljnyi=0) and (rclient_status>=0)
			AND (ABS(DATEDIFF(SECOND, Nachalo_zakaza_data, GETDATE())) > @auto_bsector_longtime)
			AND Telefon_klienta<>'' AND Adres_vyzova_vvodim<>''
			SET @success=1;
		end
		if @auto_bsector_onlineorders>0 and @auto_bsector_onlinetime>0 and @auto_bsectorid_onlineorders>-1 begin
			UPDATE dbo.Zakaz SET konechnyi_sektor_raboty=@auto_bsectorid_onlineorders, 
			SECTOR_ID=@auto_bsectorid_onlineorders, REMOTE_SET=2, Priority_counter=0
			WHERE (Arhivnyi = 0) AND (Zavershyon = 0) AND (REMOTE_SET = 0) and (Predvariteljnyi=0) AND rclient_id>-1 and (rclient_status>=0)
			AND (ABS(DATEDIFF(SECOND, Nachalo_zakaza_data, GETDATE())) > @auto_bsector_onlinetime)
			AND Telefon_klienta<>'' AND Adres_vyzova_vvodim<>''
			SET @success=1;
		end
	END TRY
	BEGIN CATCH
		SET @success=0;
	END CATCH;

END


