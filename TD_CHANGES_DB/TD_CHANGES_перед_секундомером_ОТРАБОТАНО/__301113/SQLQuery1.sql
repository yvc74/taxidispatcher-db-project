ALTER FUNCTION [dbo].[GetJSONDriverSettings]  ( @driver_id int)
RETURNS varchar(500)
AS
BEGIN
	declare @en_moving int, @use_gps smallint,
		@gtss_acct_id varchar(50), @gtss_dev_id varchar(50);
	DECLARE @curr_mver INT, @min_mver int, @mand_upd int, 
		@addit_rparams varchar(500), @gps_srv_adr varchar(255),
		@gps_instr varchar(1000);
	
	SELECT TOP 1 @curr_mver=ISNULL(curr_mob_version,2102),
	@min_mver=ISNULL(min_mob_version,2102),
	@mand_upd=ISNULL(mandatory_update,0),
	@addit_rparams=ISNULL(addit_rem_params,''),
	@gps_srv_adr=ISNULL(GPS_SRV_ADR,'') 
	FROM Objekt_vyborki_otchyotnosti
	WHERE Tip_objekta='for_drivers';
   
	SET @en_moving=0;
   
	select @en_moving=ISNULL(EN_MOVING,0),
		@use_gps=ISNULL(USE_GPS,0),
		@gtss_acct_id=ISNULL(GTSS_ACCT_ID,''),
		@gtss_dev_id=ISNULL(GTSS_DEV_ID,'')   
	from Voditelj where BOLD_ID=@driver_id; 
	
	SET @gps_instr='"use_gps":"no",';
	if (@use_gps=1)
	BEGIN
		SET @gps_instr='"use_gps":"yes",';
		if (ISNULL(@gps_srv_adr,'')<>'')
		BEGIN
			SET @gps_instr=@gps_instr+
				'"gps_srv_adr":"'+@gps_srv_adr+'",';
		END;
		if ((ISNULL(@gtss_acct_id,'')<>'') AND 
			(ISNULL(@gtss_acct_id,'')<>'demo'))
		BEGIN
			SET @gps_instr=@gps_instr+
				'"gps_acc_id":"'+@gtss_acct_id+'",';
		END;
		if ((ISNULL(@gtss_dev_id,'')<>'') AND 
			(ISNULL(@gtss_dev_id,'')<>'demo'))
		BEGIN
			SET @gps_instr=@gps_instr+
				'"gps_dev_id":"'+@gtss_dev_id+'",';
		END;
	END;  

	RETURN('{"command":"sets","en_moving":"'+
		CAST(@en_moving as varchar(20))+'","curr_mver":"'+
		CAST(@curr_mver as varchar(20))+'","min_mver":"'+
		CAST(@min_mver as varchar(20))+'","mand_upd":"'+
		CAST(@mand_upd as varchar(20))+'",'+
		@gps_instr+@addit_rparams+
		'"msg_end":"ok"}')
END
