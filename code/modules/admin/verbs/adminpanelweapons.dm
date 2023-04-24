/client/proc/adminpanelweapons()
	set name = "Weapons"
	set category = "Admin.Ship"

	var/weapontype = tgui_alert(src, "What weapon?", "Choose wisely!", list("Missile", "Railgun"), 20 SECONDS)
	if(!weapontype)
		return
	var/hiteta = tgui_input_number(src, "Give an ETA for the weapon to hit.", "Don't make them wait too long!", 10, 120, 10, 20 SECONDS)
	if(!hiteta)
		return
	var/point_defense = tgui_alert(src, "Allow Point Defence of the ship to intercept, or for the weapon to miss?", "standard  PD/miss chance is 30%.", list("Yes", "No"), 20 SECONDS)
	if(!point_defense)
		return
	var/exactplace = tgui_alert(src, "Shoot it at random places, or where you're at?", "Choose wisely!", list("Random", "Where I am"), 20 SECONDS)
	if(!exactplace)
		return
	var/salvo
	var/quantity
	if(exactplace == "Random")
		salvo = tgui_alert(src, "Make it a salvo or a single fire?", "Choose wisely!", list("Salvo", "Single"), 20 SECONDS)
		if(!salvo)
			return
		if(salvo == "Salvo")
			quantity = tgui_input_number(src, "How many?", "Don't go overboard. Please.", 2, 10, 2, 20 SECONDS)

	var/prompt = tgui_alert(src, "Are you sure you want to open fire at the USS Almayer with those parameters?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
	if(prompt != "Yes")
		return
	var/currentshot
	var/area/picked_area
	var/atom/picked_atom
	var/list/turfs_of_area = list()
	var/list/targets = list()
	switch(weapontype)

		if("Missile")
			if(exactplace == "Where I am")
				shipwide_ai_announcement("DANGER: MISSILE WARNING. LAUNCH DETECTED, BRACE, BRACE, BRACE. ESTIMATED TIME: [hiteta] SECONDS.", MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, mob.loc, point_defense), hiteta SECONDS)
				if(point_defense == "Yes")
					var/spoolup = hiteta - 4
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shipwide_ai_announcement), "ATTENTION: TRACKING TARGET, SPOOLING UP POINT DEFENSE. ATTEMPTING TO INTERCEPT." , MAIN_AI_SYSTEM, 'sound/effects/supercapacitors_charging.ogg'), spoolup SECONDS)

			if(exactplace == "Random")
				if(salvo == "Salvo")
					shipwide_ai_announcement("DANGER: MISSILE SALVO DETECTED, BRACE, BRACE, BRACE. SALVO SIZE: [quantity], ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
					for(currentshot = 1; currentshot <= quantity; currentshot++ )
						while(picked_atom == null)
							picked_area = pick(GLOB.ship_areas)
							for(var/turf/my_turf in picked_area)
								if(isturf(my_turf))
									turfs_of_area += my_turf
							if(turfs_of_area.len > 1)
								picked_atom = pick(turfs_of_area)
								targets += picked_atom
						picked_atom = null
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, targets, point_defense, salvo), hiteta SECONDS)
					if(point_defense == "Yes")
						var/spoolup = hiteta - 4
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shipwide_ai_announcement), "ATTENTION: TRACKING TARGETS, SPOOLING UP POINT DEFENSE. ATTEMPTING TO INTERCEPT." , MAIN_AI_SYSTEM, 'sound/effects/supercapacitors_charging.ogg'), spoolup SECONDS)
				else
					shipwide_ai_announcement("DANGER: MISSILE WARNING. LAUNCH DETECTED, BRACE, BRACE, BRACE. ESTIMATED TIME: [hiteta] SECONDS.", MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
					while(picked_atom == null)
						picked_area = pick(GLOB.ship_areas)
						for(var/turf/my_turf in picked_area)
							if(isturf(my_turf))
								turfs_of_area += my_turf

						if(turfs_of_area.len > 1)
							picked_atom = pick(turfs_of_area)

					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, picked_atom, point_defense), hiteta SECONDS)
					if(point_defense == "Yes")
						var/spoolup = hiteta - 4
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shipwide_ai_announcement), "ATTENTION: TRACKING TARGET, SPOOLING UP POINT DEFENSE. ATTEMPTING TO INTERCEPT." , MAIN_AI_SYSTEM, 'sound/effects/supercapacitors_charging.ogg'), spoolup SECONDS)

		if("Railgun")
			if(exactplace == "Where I am")
				shipwide_ai_announcement("DANGER: RAILGUN EMISSIONS DETECTED, INCOMING SHOT. BRACE, BRACE, BRACE. ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
				while(picked_atom == null)
					picked_area = pick(GLOB.ship_areas)

					for(var/turf/my_turf in picked_area)
						if(isturf(my_turf))
							turfs_of_area += my_turf

					if(turfs_of_area.len > 1)
						picked_atom = pick(turfs_of_area)

				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 2, mob.loc, point_defense), hiteta SECONDS)


			if(exactplace == "Random")
				if(salvo == "Salvo")
					shipwide_ai_announcement("DANGER: RAILGUN EMISSIONS DETECTED, SALVO INCOMING. BRACE, BRACE, BRACE. SALVO SIZE: [quantity], ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
					for(currentshot = 1; currentshot <= quantity; currentshot++ )
						while(picked_atom == null)
							picked_area = pick(GLOB.ship_areas)

							for(var/turf/my_turf in picked_area)
								if(isturf(my_turf))
									turfs_of_area += my_turf
							if(turfs_of_area.len > 1)
								picked_atom = pick(turfs_of_area)
								targets += picked_atom
						picked_atom = null
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 2, targets, point_defense, salvo), hiteta SECONDS)
					picked_atom = null
					targets = null

				if(salvo == "Single")
					prompt = tgui_alert(src, "Are you sure you want to shoot a railgun slug at the USS Almayer at a random place?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
					if(prompt == "Yes")
						shipwide_ai_announcement("DANGER: RAILGUN EMISSIONS DETECTED, INCOMING SHOT. BRACE, BRACE, BRACE. ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
						while(picked_atom == null)
							picked_area = pick(GLOB.ship_areas)

							for(var/turf/my_turf in picked_area)
								if(isturf(my_turf))
									turfs_of_area += my_turf

							if(turfs_of_area.len > 1)
								picked_atom = pick(turfs_of_area)

						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 2, picked_atom, point_defense), hiteta SECONDS)
