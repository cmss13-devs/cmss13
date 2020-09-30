

/obj/item/circuitboard/computer

/obj/item/circuitboard/computer/generic // To be used in machine refactor
	name = "electronics"

/obj/item/circuitboard/computer/generic/New(obj/structure/machinery/M)
	..()
	name = "Circuit board ([M.name])"
	build_path = M.type

//TODO: Move these into computer/camera.dm
/obj/item/circuitboard/computer/security
	name = "Circuit board (Security Camera Monitor)"
	build_path = /obj/structure/machinery/computer/security
	var/network = list("military")
	req_access = list(ACCESS_MARINE_BRIG)
	var/locked = 1

/obj/item/circuitboard/computer/security/construct(var/obj/structure/machinery/computer/security/C)
	if (..(C))
		C.network = network

/obj/item/circuitboard/computer/security/deconstruct(var/obj/structure/machinery/computer/security/C)
	if (..(C))
		network = C.network

/obj/item/circuitboard/computer/security/engineering
	name = "Circuit board (Engineering Camera Monitor)"
	build_path = /obj/structure/machinery/computer/security/engineering
	network = list("Engineering","Power Alarms","Atmosphere Alarms","Fire Alarms")
	req_access = list()
/obj/item/circuitboard/computer/security/mining
	name = "Circuit board (Mining Camera Monitor)"
	build_path = /obj/structure/machinery/computer/security/mining
	network = list("MINE")
	req_access = list()

/obj/item/circuitboard/computer/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = /obj/structure/machinery/computer/cryopod

/obj/item/circuitboard/computer/med_data
	name = "Circuit board (Medical Records)"
	build_path = /obj/structure/machinery/computer/med_data

/obj/item/circuitboard/computer/pandemic
	name = "Circuit board (PanD.E.M.I.C. 2200)"
	build_path = /obj/structure/machinery/computer/pandemic

/obj/item/circuitboard/computer/scan_consolenew
	name = "Circuit board (DNA Machine)"
	// build_path = /obj/structure/machinery/computer/scan_consolenew

/obj/item/circuitboard/computer/communications
	name = "Circuit board (Communications)"
	build_path = /obj/structure/machinery/computer/communications

/obj/item/circuitboard/computer/card
	name = "Circuit board (ID Computer)"
	build_path = /obj/structure/machinery/computer/card

/obj/item/circuitboard/computer/teleporter
	name = "Circuit board (Teleporter)"
	build_path = /obj/structure/machinery/computer/teleporter

/obj/item/circuitboard/computer/secure_data
	name = "Circuit board (Security Records)"
	build_path = /obj/structure/machinery/computer/secure_data

/obj/item/circuitboard/computer/skills
	name = "Circuit board (Employment Records)"
	build_path = /obj/structure/machinery/computer/skills

/obj/item/circuitboard/computer/stationalert
	name = "Circuit board (Station Alerts)"
	build_path = /obj/structure/machinery/computer/station_alert



/obj/item/circuitboard/computer/air_management
	name = "Circuit board (Atmospheric Monitor)"
	build_path = /obj/structure/machinery/computer/general_air_control

/obj/item/circuitboard/computer/air_management/tank_control
	name = "Circuit board (Tank Control)"
	build_path = /obj/structure/machinery/computer/general_air_control/large_tank_control

/obj/item/circuitboard/computer/air_management/injector_control
	name = "Circuit board (Injector Control)"
	build_path = /obj/structure/machinery/computer/general_air_control/fuel_injection



/obj/item/circuitboard/computer/atmos_alert
	name = "Circuit board (Atmospheric Alert)"
	build_path = /obj/structure/machinery/computer/atmos_alert
/obj/item/circuitboard/computer/pod
	name = "Circuit board (Massdriver control)"
	build_path = /obj/structure/machinery/computer/pod
/obj/item/circuitboard/computer/robotics
	name = "Circuit board (Robotics Control)"
	build_path = /obj/structure/machinery/computer/robotics
	
/obj/item/circuitboard/computer/drone_control
	name = "Circuit board (Drone Control)"
	build_path = /obj/structure/machinery/computer/drone_control
	
/obj/item/circuitboard/computer/arcade
	name = "Circuit board (Arcade)"
	build_path = /obj/structure/machinery/computer/arcade
	
/obj/item/circuitboard/computer/turbine_control
	name = "Circuit board (Turbine control)"
	build_path = /obj/structure/machinery/computer/turbine_computer
/obj/item/circuitboard/computer/powermonitor
	name = "Circuit board (Power Monitor)"
	build_path = /obj/structure/machinery/power/monitor
/obj/item/circuitboard/computer/olddoor
	name = "Circuit board (DoorMex)"
	build_path = /obj/structure/machinery/computer/pod/old
/obj/item/circuitboard/computer/syndicatedoor
	name = "Circuit board (ProComp Executive)"
	build_path = /obj/structure/machinery/computer/pod/old/syndicate
/obj/item/circuitboard/computer/swfdoor
	name = "Circuit board (Magix)"
	build_path = /obj/structure/machinery/computer/pod/old/swf
/obj/item/circuitboard/computer/prisoner
	name = "Circuit board (Prisoner Management)"
	build_path = /obj/structure/machinery/computer/prisoner
/obj/item/circuitboard/computer/rdconsole
	name = "Circuit Board (RD Console)"
	build_path = /obj/structure/machinery/computer/rdconsole/core
/obj/item/circuitboard/computer/mecha_control
	name = "Circuit Board (Exosuit Control Console)"
	build_path = /obj/structure/machinery/computer/mecha
/obj/item/circuitboard/computer/rdservercontrol
	name = "Circuit Board (R&D Server Control)"
	build_path = /obj/structure/machinery/computer/rdservercontrol
/obj/item/circuitboard/computer/crew
	name = "Circuit board (Crew monitoring computer)"
	build_path = /obj/structure/machinery/computer/crew
	
/obj/item/circuitboard/computer/ordercomp
	name = "Circuit board (Supply ordering console)"
	build_path = /obj/structure/machinery/computer/ordercomp
	
/obj/item/circuitboard/computer/supply_drop_console
	name = "Circuit board (Supply Drop Console)"
	build_path = /obj/structure/machinery/computer/supply_drop_console
	

/obj/item/circuitboard/computer/supplycomp
	name = "Circuit board (Supply shuttle console)"
	build_path = /obj/structure/machinery/computer/supplycomp
	
	var/contraband_enabled = 0

/obj/item/circuitboard/computer/supplycomp/construct(var/obj/structure/machinery/computer/supplycomp/SC)
	if (..(SC))
		SC.can_order_contraband = contraband_enabled

/obj/item/circuitboard/computer/supplycomp/deconstruct(var/obj/structure/machinery/computer/supplycomp/SC)
	if (..(SC))
		contraband_enabled = SC.can_order_contraband

/obj/item/circuitboard/computer/operating
	name = "Circuit board (Operating Computer)"
	build_path = /obj/structure/machinery/computer/operating
	
/obj/item/circuitboard/computer/comm_monitor
	name = "Circuit board (Telecommunications Monitor)"
	build_path = /obj/structure/machinery/computer/telecomms/monitor
	
/obj/item/circuitboard/computer/comm_server
	name = "Circuit board (Telecommunications Server Monitor)"
	build_path = /obj/structure/machinery/computer/telecomms/server
	
/obj/item/circuitboard/computer/comm_traffic
	name = "Circuitboard (Telecommunications Traffic Control)"
	build_path = /obj/structure/machinery/computer/telecomms/traffic
	

/obj/item/circuitboard/computer/aifixer
	name = "Circuit board (AI Integrity Restorer)"
	build_path = /obj/structure/machinery/computer/aifixer
	
/obj/item/circuitboard/computer/area_atmos
	name = "Circuit board (Area Air Control)"
	build_path = /obj/structure/machinery/computer/area_atmos
	


/obj/item/circuitboard/computer/supplycomp/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/device/multitool))
		var/catastasis = src.contraband_enabled
		var/opposite_catastasis
		if(catastasis)
			opposite_catastasis = "STANDARD"
			catastasis = "BROAD"
		else
			opposite_catastasis = "BROAD"
			catastasis = "STANDARD"

		switch( alert("Current receiver spectrum is set to: [catastasis]","Multitool-Circuitboard interface","Switch to [opposite_catastasis]","Cancel") )
		//switch( alert("Current receiver spectrum is set to: " {(src.contraband_enabled) ? ("BROAD") : ("STANDARD")} , "Multitool-Circuitboard interface" , "Switch to " {(src.contraband_enabled) ? ("STANDARD") : ("BROAD")}, "Cancel") )
			if("Switch to STANDARD","Switch to BROAD")
				src.contraband_enabled = !src.contraband_enabled

			if("Cancel")
				return
			else
				to_chat(user, "DERP! BUG! Report this (And what you were doing to cause it) to Agouri")
	return

/obj/item/circuitboard/computer/security/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/card/id))
		if(check_access(I))
			locked = !locked
			to_chat(user, SPAN_NOTICE(" You [locked ? "" : "un"]lock the circuit controls."))
		else
			to_chat(user, SPAN_DANGER("Access denied."))
	else if(istype(I,/obj/item/device/multitool))
		if(locked)
			to_chat(user, SPAN_DANGER("Circuit controls are locked."))
			return
		var/existing_networks = jointext(network,",")
		var/input = strip_html(input(usr, "Which networks would you like to connect this camera console circuit to? Seperate networks with a comma. No Spaces!\nFor example: military,Security,Secret ", "Multitool-Circuitboard interface", existing_networks))
		if(!input)
			to_chat(usr, "No input found please hang up and try your call again.")
			return
		var/list/tempnetwork = splittext(input, ",")
		tempnetwork = difflist(tempnetwork,RESTRICTED_CAMERA_NETWORKS,1)
		if(tempnetwork.len < 1)
			to_chat(usr, "No network found please hang up and try your call again.")
			return
		network = tempnetwork
	return

/obj/item/circuitboard/computer/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/tool/screwdriver))
		user.visible_message(SPAN_NOTICE("\the [user] adjusts the jumper on the [src]'s access protocol pins."), SPAN_NOTICE("You adjust the jumper on the access protocol pins."))
		if(src.build_path == /obj/structure/machinery/computer/rdconsole/core)
			src.name = "Circuit Board (RD Console - Robotics)"
			src.build_path = /obj/structure/machinery/computer/rdconsole/robotics
			to_chat(user, SPAN_NOTICE(" Access protocols set to robotics."))
		else
			src.name = "Circuit Board (RD Console)"
			src.build_path = /obj/structure/machinery/computer/rdconsole/core
			to_chat(user, SPAN_NOTICE(" Access protocols set to default."))


