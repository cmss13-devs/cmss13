/obj/structure/sign
	icon = 'icons/obj/structures/props/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = WALL_OBJ_LAYER

/obj/structure/sign/ex_act(severity)
	qdel(src)
	return

/obj/structure/sign/attackby(obj/item/tool as obj, mob/user as mob)	//deconstruction
	if(istype(tool, /obj/item/tool/screwdriver) && !istype(src, /obj/structure/sign/double))
		to_chat(user, "You unfasten the sign with your [tool].")
		var/obj/item/sign/S = new(src.loc)
		S.name = name
		S.desc = desc
		S.icon_state = icon_state
		//var/icon/I = icon('icons/obj/structures/props/decals.dmi', icon_state)
		//S.icon = I.Scale(24, 24)
		S.sign_state = icon_state
		qdel(src)
	else ..()

/obj/item/sign
	name = "sign"
	desc = ""
	icon = 'icons/obj/structures/props/decals.dmi'
	w_class = SIZE_MEDIUM		//big
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/tool as obj, mob/user as mob)	//construction
	if(istype(tool, /obj/item/tool/screwdriver) && isturf(user.loc))
		var/direction = tgui_input_list(usr, "In which direction?", "Select direction.", list("North", "East", "South", "West", "Cancel"))
		if(direction == "Cancel") return
		var/obj/structure/sign/S = new(user.loc)
		switch(direction)
			if("North")
				S.pixel_y = 32
			if("East")
				S.pixel_x = 32
			if("South")
				S.pixel_y = -32
			if("West")
				S.pixel_x = -32
			else return
		S.name = name
		S.desc = desc
		S.icon_state = sign_state
		to_chat(user, "You fasten \the [S] with your [tool].")
		qdel(src)
	else ..()

/obj/structure/sign/double/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/double/map/left
	icon_state = "map-left"

/obj/structure/sign/double/map/right
	icon_state = "map-right"

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'."
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'."
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM"
	desc = "A guidance sign which reads 'EXAM ROOM'."
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'."
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL LEADS TO SPACE'."
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'."
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'."
	icon_state = "fire"

/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking"

/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking2"

/obj/structure/sign/redcross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "redcross"

/obj/structure/sign/greencross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "greencross"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA Atmospherics Division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/double/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/double/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/maltesefalcon/right
	icon_state = "maltesefalcon-right"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'."
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'."
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'."
	icon_state = "hydro1"

/obj/structure/sign/directions/science
	name = "\improper Science department"
	desc = "A direction sign, pointing out which way the Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "\improper Engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "\improper Security department"
	desc = "A direction sign, pointing out which way the Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name = "\improper Medical Bay"
	desc = "A direction sign, pointing out which way the Medical Bay is."
	icon_state = "direction_med"

/obj/structure/sign/directions/evac
	name = "\improper Escape Arm"
	desc = "A direction sign, pointing out which way the escape shuttle dock is."
	icon_state = "direction_evac"

///////////////////////
///SEMIOTIC STANDARD///
///////////////////////

/obj/structure/sign/safety
	name = "sign"
	icon = 'icons/obj/structures/props/Semiotic_Standard.dmi'
	desc = "A sign denoting Semiotic Standard.The Interstellar Commerce Commission requires that these symbols be placed pretty much everywhere for your safety."
	anchored = 1
	opacity = 0
	density = 0

/obj/structure/sign/safety/airlock
	name = "airlock semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an airlock."
	icon_state = "Airlock"

/obj/structure/sign/safety/ammunition
	name = "ammunition storage semiotic"
	desc = "Semiotic Standard denoting the nearby storage of ammunition."
	icon_state = "Ammo"

/obj/structure/sign/safety/analysis_lab
	name = "analysis laboratory semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an analysis laboratory."
	icon_state = "Analysis_Lab"

/obj/structure/sign/safety/autoopenclose
	name = "automatic opener/closer semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an automatic shutoff valve."
	icon_state = "AutoOpenClose"

/obj/structure/sign/safety/autodoc
	name = "autodoc semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an autodoc."
	icon_state = "Autodoc"

/obj/structure/sign/safety/biolab
	name = "biological laboratory semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a biological laboratory."
	icon_state = "BioLab"

/obj/structure/sign/safety/bridge
	name = "bridge semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a starship's bridge."
	icon_state = "Bridge"

/obj/structure/sign/safety/bulkhead_door
	name = "bulkhead door semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a bulkhead door."
	icon_state = "Bulkhead_Door"

/obj/structure/sign/safety/chem_lab
	name = "chemical laboratory semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a chemical laboratory."
	icon_state = "Chem_Lab"

/obj/structure/sign/safety/coffee
	name = "coffee semiotic"
	desc = "Semiotic Standard denoting the nearby presence of coffee: the lifeblood of any starship crew."
	icon_state = "Coffee"

/obj/structure/sign/safety/commline_connection
	name = "point of connection for a communication line semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a comm line connection."
	icon_state = "Commline_Connection"

/obj/structure/sign/safety/conference_room
	name = "conference room semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a conference room."
	icon_state = "Conf_Room"

/obj/structure/sign/safety/cryo
	name = "cryogenic vault semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a cryogenics vault."
	icon_state = "Cryo"

/obj/structure/sign/safety/distribution_pipes
	name = "distribution pipes semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a distribution pipeline."
	icon_state = "Dist_Pipe"

/obj/structure/sign/safety/east
	name = "\improper East semiotic"
	desc = "Semiotic Standard denoting the nearby presence of something to the East."
	icon_state = "East"

/obj/structure/sign/safety/electronics
	name = "astronic systems semiotic"
	desc = "Semiotic Standard denoting the nearby presence of astronic systems. That's a fancy way of saying electrical systems."
	icon_state = "Astronics"

/obj/structure/sign/safety/elevator
	name = "elevator semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an elevator."
	icon_state = "Elevator"

/obj/structure/sign/safety/exhaust
	name = "exhaust semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an engine or generator exhaust."
	icon_state = "Exhaust"

/obj/structure/sign/safety/food_storage
	name = "organic storage (foodstuffs) semiotic"
	desc = "Semiotic Standard denoting the nearby presence of unrefriderated food storage."
	icon_state = "Food_Storage"

/obj/structure/sign/safety/galley
	name = "galley semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a galley."
	icon_state = "Galley"

/obj/structure/sign/safety/hazard
	name = "hazard semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a hazard. Watch out."
	icon_state = "Hazard"

/obj/structure/sign/safety/high_rad
	name = "high radioactivity semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an area of high radioactivity."
	icon_state = "High_Rad"

/obj/structure/sign/safety/high_voltage
	name = "high voltage semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a high voltage electrical current."
	icon_state = "High_Voltage"

/obj/structure/sign/safety/hvac
	name = "\improper HVAC semiotic"
	desc = "Semiotic Standard denoting the nearby presence of...an HVAC system. This sign must have been updated to the new standard."
	icon_state = "HVAC"

/obj/structure/sign/safety/hvac_old
	name = "\improper HVAC semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an HVAC system. This sign is still using the old standard."
	icon_state = "HVAC-Old"

/obj/structure/sign/safety/intercom
	name = "intercom semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an intercom."
	icon_state = "Comm"

/obj/structure/sign/safety/ladder
	name = "ladder semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a ladder."
	icon_state = "Ladder"

/obj/structure/sign/safety/laser
	name = "laser semiotic"
	desc = "Semiotic Standard denoting the nearby presence of lasers. It's usually not as cool as it sounds."
	icon_state = "Laser"

/obj/structure/sign/safety/life_support
	name = "life support system semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a life support system."
	icon_state = "Life_Support"

/obj/structure/sign/safety/maint
	name = "maintenace semiotic"
	desc = "Semiotic Standard denoting the nearby presence of maintenance access."
	icon_state = "Maint"

/obj/structure/sign/safety/manualopenclose
	name = "manual opener/closer semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a manual shutoff valve."
	icon_state = "ManualOpenClose"

/obj/structure/sign/safety/med_cryo
	name = "medical cryostasis vault semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a medical cryostasis vault."
	icon_state = "Med_Cryo"

/obj/structure/sign/safety/med_life_support
	name = "medical life support semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a life support system for a medbay."
	icon_state = "Med_Life_Support"

/obj/structure/sign/safety/medical
	name = "medical semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a medbay."
	icon_state = "Medical"

/obj/structure/sign/safety/nonpress
	name = "non-pressurized area beyond semiotic"
	desc = "Semiotic Standard denoting that the area beyond isn't pressurized."
	icon_state = "Non-Press_Area"

/obj/structure/sign/safety/nonpress_ag
	name = "zrtificial gravity area, non-pressurized, suit required semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an area with artificial gravity lacking in pressurization."
	icon_state = "Non-Press_AG"

/obj/structure/sign/safety/nonpress_0g
	name = "non-pressurized area, no gravity, suit required semiotic"
	desc = "Semiotic Standard denoting that the area beyond isn't pressurized and has no artificial gravity."
	icon_state = "Non-Press_Zero-G"

/obj/structure/sign/safety/north
	name = "\improper North semiotic"
	desc = "Semiotic Standard denoting the nearby presence of something to the North."
	icon_state = "North"

/obj/structure/sign/safety/opens_up
	name = "opens upwards semiotic"
	desc = "Semiotic Standard denoting the nearby door opens upwards."
	icon_state = "Opens_Up"

/obj/structure/sign/safety/outpatient
	name = "outpatient clinic semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an outpatient clinic."
	icon_state = "Outpatient"

/obj/structure/sign/safety/photonics
	name = "photonics systems (fibre optics) semiotic"
	desc = "Semiotic Standard denoting the nearby presence of fibre optics lines."
	icon_state = "Fibre_Optic"

/obj/structure/sign/safety/press_area_ag
	name = "pressurized with artificial gravity semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a pressurized area without artificial gravity."
	icon_state = "Press_Area_AG"

/obj/structure/sign/safety/press_area
	name = "pressurized area semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a pressurized area."
	icon_state = "Press_Area"

/obj/structure/sign/safety/rad_haz
	name = "radiation hazard semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a radiation hazard."
	icon_state = "Rad_Haz"

/obj/structure/sign/safety/rad_shield
	name = "area shielded from radiation semiotic"
	desc = "Semiotic Standard denoting the nearby presence of an area shielded from radiation."
	icon_state = "Rad_Shield"

/obj/structure/sign/safety/radio_rad
	name = "radiation of radio waves semiotic"
	desc = "Semiotic Standard denoting the nearby presence of radiation from a radio tower."
	icon_state = "Radio_Rad"

/obj/structure/sign/safety/reception
	name = "reception semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a reception area."
	icon_state = "Reception"

/obj/structure/sign/safety/reduction
	name = "reduction dilation of area semiotic"
	desc = "Semiotic Standard denoting that the area gets smaller ahead."
	icon_state = "Reduction"

/obj/structure/sign/safety/ref_bio_storage
	name = "refridgerated biological storage semiotic"
	desc = "Semiotic Standard denoting the nearby presence of refridgerated biological storage."
	icon_state = "Ref_Bio_Storage"

/obj/structure/sign/safety/ref_chem_storage
	name = "refridgerated chemical storage semiotic"
	desc = "Semiotic Standard denoting the nearby presence of refridgerated chemical storage."
	icon_state = "Ref_Chem_Storage"

/obj/structure/sign/safety/fridge
	name = "refridgerated storage (organic foodstuffs) semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a fridge."
	icon_state = "Fridge"

/obj/structure/sign/safety/refridgeration
	name = "refridgeration semiotic"
	desc = "Semiotic Standard denoting the nearby presence of non-food refridgeration."
	icon_state = "Refridgeration"

/obj/structure/sign/safety/rewire
	name = "rewire system semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a rewire system."
	icon_state = "Rewire"

/obj/structure/sign/safety/south
	name = "\improper South semiotic"
	desc = "Semiotic Standard denoting the nearby presence of something to the South."
	icon_state = "South"

/obj/structure/sign/safety/storage
	name = "storage semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a general dry storage room."
	icon_state = "Storage"

/obj/structure/sign/safety/suit_storage
	name = "pressure suit locker semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a pressure suit storage locker."
	icon_state = "Suit_Storage"

/obj/structure/sign/safety/synth_storage
	name = "synthetic storage semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a synthetic storage room."
	icon_state = "Synth_Storage"

/obj/structure/sign/safety/terminal
	name = "computer terminal semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a computer terminal."
	icon_state = "Terminal"

/obj/structure/sign/safety/tram
	name = "tram line semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a tram line."
	icon_state = "Tram_Line"

/obj/structure/sign/safety/twilight_zone_terminator
	name = "twilight zone terminator semiotic"
	desc = "Semiotic Standard denoting the nearby presence of a twilight zone terminator. It's way less cool than it sounds."
	icon_state = "Twilight_Zone_Terminator"

/obj/structure/sign/safety/west
	name = "\improper West semiotic"
	desc = "Semiotic Standard denoting the nearby presence of something to the West."
	icon_state = "West"

/obj/structure/sign/safety/zero_g
	name = "artificial gravity absent semiotic"
	desc = "Semiotic Standard denoting the nearby lack of artificial gravity."
	icon_state = "Zero_G"

//////////////////
///Marine signs///
//////////////////

/obj/structure/sign/ROsign
	name = "\improper USCM Requisitions Office Guidelines"
	desc = " 1. You are not entitled to service or equipment. Attachments are a privilege, not a right.\n 2. You must be fully dressed to obtain service. Cyrosleep underwear is non-permissible.\n 3. The Requsitions Officer has the final say and the right to decline service. Only the Acting Captain may override his decisions.\n 4. Please treat your Requsitions staff with respect. They work hard."
	icon_state = "roplaque"

/obj/structure/sign/prop1
	name = "\improper USCM Poster"
	desc = "The symbol of the United States Colonial Marines corps."
	icon_state = "prop1"

/obj/structure/sign/prop2
	name = "\improper USCM Poster"
	desc = "A deeply faded poster of a group of glamorous Colonial Marines in uniform. Probably taken pre-Alpha."
	icon_state = "prop2"

/obj/structure/sign/prop3
	name = "\improper USCM Poster"
	desc = "An old recruitment poster for the USCM. Looking at it floods you with a mixture of pride and sincere regret."
	icon_state = "prop3"
