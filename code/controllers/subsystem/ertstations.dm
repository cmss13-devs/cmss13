SUBSYSTEM_DEF(ertstations)
	name   = "ERTStations"
	init_order = SS_INIT_ERTSTATIONS
	flags  = SS_NO_FIRE

	var/datum/map_template/ship_templateWY // Current ship template in use
	var/datum/map_template/ship_templateUPP // Current ship template in use
	var/datum/map_template/ship_templateTWE // Current ship template in use
	var/datum/map_template/ship_templateCLF // Current ship template in use

/datum/controller/subsystem/ertstations/Initialize(timeofday)
	if(!ship_templateUPP)
		ship_templateUPP = new /datum/map_template("maps/templates/upp_ert_station.dmm", cache = TRUE)
		ship_templateUPP.load_new_z()
	if(!ship_templateWY)
		ship_templateWY = new /datum/map_template("maps/templates/weyland_ert_station.dmm", cache = TRUE)
		ship_templateWY.load_new_z()
	if(!ship_templateTWE)
		ship_templateTWE = new /datum/map_template("maps/templates/twe_ert_station.dmm", cache = TRUE)
		ship_templateTWE.load_new_z()
	if(!ship_templateCLF)
		ship_templateCLF = new /datum/map_template("maps/templates/clf_ert_station.dmm", cache = TRUE)
		ship_templateCLF.load_new_z()
	return SS_INIT_SUCCESS
