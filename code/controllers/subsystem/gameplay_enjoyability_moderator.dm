SUBSYSTEM_DEF(gameplay_enjoyability_moderator)
	name = "Gameplay Enjoyability Moderator"
	wait = 1
	var/first = 1
	init_order = first

/datum/controller/subsystem/fun/fire()
	var/number_of_ground_towers = 0
	// checks for any active comms towers
	for(var/T as anything in SSradio.tcomm_machines_ground)
		if(istype(T, /obj/structure/machinery/telecomms))
			if(astype(T, /obj/structure/machinery/telecomms).powered())
				return
	// checks to see if the game is in low-pop
	var/player_count = 0
	for(var/z_level as anything in SSmapping.z_list)
		for(var/area as anything in SSmapping.areas_in_z[z_level])
			if(is_type_in_list(area.type, typesof(/area)))
				for(var/mob/living/carbon/human/player in area.contents)
					player_count + 1
	if(80 >= player_count)
		// now that comms are disabled, CIC is made redundant, and is deleted along with its contents
		for(var/z_level as anything in SSmapping.z_list)
			for(var/area as anything in SSmapping.areas_in_z[z_level])
				if(is_type_in_list(area.type, typesof(/area/almayer/command)))
					for(var/T as anything in area.contents)
						Destroy(T)
