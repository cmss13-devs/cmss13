datum/controller/process/whiskey
	var/datum/game_mode/whiskey_outpost/wo_game_mode

datum/controller/process/whiskey/setup()
	name = "Whiskey Outpost"
	schedule_interval = 50 //5 seconds
	
	if(map_tag != MAP_WHISKEY_OUTPOST)
		disable()

datum/controller/process/whiskey/doWork()
	if(!wo_game_mode)
		if(ticker && ticker.mode && istype(ticker.mode,/datum/game_mode/whiskey_outpost))
			wo_game_mode = ticker.mode
		else
			return

	//XENO AND SUPPLY DROPS SPAWNER
	if(spawn_next_wo_wave)
		spawn_next_wo_wave = 0
		world << "<br><br>"
		world << "<br><br>"
		world << "<span class='notice'>*___________________________________*</span>" //We also then ram it down later anyways, should cut down on the lag a bit.
		world << "<span class='boldnotice'>***Whiskey Outpost Controller***</span>"
		world << "\blue <b>Wave:</b> [wo_game_mode.xeno_wave][wo_game_mode.wave_times_delayed?"|\red Times delayed: [wo_game_mode.wave_times_delayed]":""]"
		world << "<span class='notice'>*___________________________________*</span>"
		world << "<br><br>"
		world << "<br><br>"

		var/datum/whiskey_outpost_wave/current_wave
		if (wo_game_mode.xeno_wave == 7)
			if(!ticker.mode.picked_call)
				for(var/datum/emergency_call/L in ticker.mode.all_calls)
					if(L.name == "Marine Reinforcements (Squad)")
						ticker.mode.picked_call = L
						ticker.mode.picked_call.activate(FALSE)
		if(wo_game_mode.xeno_wave < 15)
			current_wave = whiskey_outpost_waves[wo_game_mode.xeno_wave]

			if(current_wave.sound_effect && current_wave.sound_effect.len)
				world << sound(pick(current_wave.sound_effect))

			if(current_wave.command_announcement && current_wave.command_announcement.len == 2)
				command_announcement.Announce(current_wave.command_announcement[1],current_wave.command_announcement[2])
		else
			var/random_wave = rand(1,4)
			switch(random_wave)
				if(1)
					current_wave = whiskey_outpost_waves[14] // just a big wave
				if(2)
					current_wave = new /datum/whiskey_outpost_wave/random/wave1
				if(3)
					current_wave = new /datum/whiskey_outpost_wave/random/wave2
				if(4)
					current_wave = new /datum/whiskey_outpost_wave/random/wave3

		spawn_whiskey_outpost_xenos(current_wave)

		if(wo_game_mode.wave_times_delayed)
			wo_game_mode.wave_times_delayed = 0

		//SUPPLY SPAWNER
		if(wo_game_mode.xeno_wave == wo_game_mode.next_supply)
			if(wo_game_mode.supply_spawns && wo_game_mode.supply_spawns.len)

				var/turf/picked_sup = pick(wo_game_mode.supply_spawns)
				place_whiskey_outpost_drop(picked_sup,"sup")
				picked_sup = pick(wo_game_mode.supply_spawns)
				place_whiskey_outpost_drop(picked_sup,"sup")
				picked_sup = pick(wo_game_mode.supply_spawns)
				place_whiskey_outpost_drop(picked_sup,"sup")

			switch(wo_game_mode.xeno_wave)
				if(1 to 11)
					wo_game_mode.next_supply += 1
				if(12 to 18)
					wo_game_mode.next_supply += 3
				else
					wo_game_mode.next_supply += 5

		wo_game_mode.xeno_wave++

	else
		var/i = 1
		while(i++ < 5 && dead_hardcore_xeno_list.len) // nibble away at the dead over time
			cdel(pick(dead_hardcore_xeno_list))
