var/datum/subsystem/whiskey/SSwhiskey

/datum/subsystem/whiskey
	name          = "Whiskey Outpost"
	init_order    = SS_INIT_WHISKEY
	display_order = SS_DISPLAY_WHISKEY
	priority      = SS_PRIORITY_WHISKEY
	wait          = 5 SECONDS
	flags         = SS_NO_TICK_CHECK | SS_KEEP_TIMING

	var/datum/game_mode/whiskey_outpost/wo_game_mode

/datum/subsystem/whiskey/New()
	NEW_SS_GLOBAL(SSwhiskey)

/datum/subsystem/whiskey/Initialize(timeofday)
	if(map_tag != MAP_WHISKEY_OUTPOST)
		pause()
	..()

/datum/subsystem/whiskey/fire(resumed = FALSE)
	if(!wo_game_mode)
		if(ticker && ticker.mode && istype(ticker.mode,/datum/game_mode/whiskey_outpost))
			wo_game_mode = ticker.mode
		else
			pause()
			return

	//XENO AND SUPPLY DROPS SPAWNER
	if(spawn_next_wo_wave)
		spawn_next_wo_wave = 0
		world << "<br><br>"
		world << "<br><br>"
		world << "<span class='notice'>*___________________________________*</span>" //We also then ram it down later anyways, should cut down on the lag a bit.
		world << "<span class='boldnotice'>***Whiskey Outpost Controller***</span>"
		world << "<span class='boldnotice'>Wave:</span> [wo_game_mode.xeno_wave][wo_game_mode.wave_times_delayed?"|<span class='warning'>Times delayed: [wo_game_mode.wave_times_delayed]":""]</span>"
		world << "<span class='notice'>*___________________________________*</span>"
		world << "<br><br>"
		world << "<br><br>"

		if(wo_game_mode.xeno_wave != (1 || 8 || 9)) // Make sure to not xeno roar over our story sounds.
			world << sound(pick('sound/voice/alien_distantroar_3.ogg','sound/voice/xenos_roaring.ogg', 'sound/voice/4_xeno_roars.ogg'))

		spawn_whiskey_outpost_xenos(wo_game_mode.spawn_xeno_num)

		if(wo_game_mode.wave_times_delayed)
			wo_game_mode.wave_times_delayed = 0

		switch(wo_game_mode.xeno_wave)
			if(1)
				command_announcement.Announce("We're tracking the creatures that wiped out our patrols heading towards your outpost.. Stand-by while we attempt to establish a signal with the USS Alistoun to alert them of these creatures.", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")
			if(8)
				command_announcement.Announce("Captain Naiche speaking, we've been unsuccessful in establishing offworld communication for the moment. We're prepping our M402 mortars to destroy the inbound xeno force on the main road. Standby for fire support.", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")
			if(9)
				world << sound('sound/voice/alien_queen_command.ogg')
				command_announcement.Announce("Our garrison forces are reaching seventy percent casualties, we are losing our grip on LV-624. It appears that vanguard of the hostile force is still approaching, and most of the other Dust Raider platoons have been shattered. We're counting on you to keep holding.", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")
			if(12)
				command_announcement.Announce("This is Captain Naiche, we are picking up large signatures inbound, we'll see what we can do to delay them.", "Captain Naich, 3rd Battalion Command, LV-624")
			if(14)
				command_announcement.Announce("This is Captain Naiche, we've established our distress beacon for the USS Alistoun and the remaining Dust Raiders. Hold on for a bit longer while we trasmit our coordinates!", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")


		//SUPPLY SPAWNER
		if(wo_game_mode.xeno_wave == wo_game_mode.next_supply)
			for(var/turf/S in wo_game_mode.supply_spawns)

				var/turf/picked_sup = pick(wo_game_mode.supply_spawns) //ONLY ONE TYPE OF DROP NOW!
				place_whiskey_outpost_drop(picked_sup,"sup") //This is just extra guns, medical supplies, junk, and some rare-r ammo.
				wo_game_mode.supply_spawns -= picked_sup
				wo_game_mode.supply_spawns += list(picked_sup)

				break //Place only 3

			switch(wo_game_mode.xeno_wave)
				if(1 to 11)
					wo_game_mode.next_supply++
				if(12 to 18)
					wo_game_mode.next_supply += 2
				else
					wo_game_mode.next_supply += 3

		wo_game_mode.xeno_wave++
	else
		var/i = 1
		while(i++ < 5 && dead_hardcore_xeno_list.len) // nibble away at the dead over time
			qdel(pick(dead_hardcore_xeno_list))
