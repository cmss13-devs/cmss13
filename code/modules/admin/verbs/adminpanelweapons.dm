/client/proc/adminpanelweapons()
	set name = "Weapons"
	set category = "Admin.Ship"

	//Yes, this is a var list.
	//Friggin' fetching global shit along with conditionals do not enjoy creating vars along with conditionals.
	//Leave the poor thang alone.
	var/salvo
	var/quantity
	var/currentshot
	var/exactplace
	var/area/picked_area
	var/atom/picked_atom
	var/list/turfs_of_area = list()
	var/list/targets = list()

	var/weapontype = tgui_alert(src, "What weapon?", "Choose wisely!", list("Missile", "Railgun"), 20 SECONDS)
	var/hiteta = tgui_input_number(src, "Give an ETA for the weapon to hit.", "Don't make them wait too long!", 10, 120, 10, 20 SECONDS)
	switch(weapontype)
		if("Missile")
			var/point_defense = tgui_alert(src, "Allow Point Defence of the ship to intercept?", "Be nice!", list("Yes", "No"), 20 SECONDS)
			exactplace = tgui_alert(src, "Shoot it at random places, or where you're at?", "Choose wisely!", list("Random", "Where I am"), 20 SECONDS)
			if(exactplace == "Random")
				salvo = tgui_alert(src, "Make it a salvo or a single fire?", "Choose wisely!", list("Salvo", "Single"), 20 SECONDS)
				if(salvo == "Salvo")
					quantity = tgui_input_number(src, "How many?", "Don't go overboard. Please.", 2, 5, 2, 20 SECONDS)
					var/prompt = tgui_alert(src, "Are you sure you want to open fire at the USS Almayer at random places?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
					if(prompt == "Yes")
						shipwide_ai_announcement("DANGER: MISSILE SALVO DETECTED, BRACE, BRACE, BRACE. SALVO SIZE: [quantity] , ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
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
						picked_atom = null
						targets = null

				else
					var/prompt = tgui_alert(src, "Are you sure you want to open fire at the USS Almayer at a random place?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
					if(prompt == "Yes")
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

			if(exactplace == "Where I am")
				var/prompt = tgui_alert(src, "Are you sure you want to open fire at the USS Almayer with your position as target?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
				if(prompt == "Yes")
					shipwide_ai_announcement("DANGER: MISSILE WARNING. LAUNCH DETECTED, BRACE, BRACE, BRACE. ESTIMATED TIME: [hiteta] SECONDS.", MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, mob.loc, point_defense), hiteta SECONDS)
					if(point_defense == "Yes")
						var/spoolup = hiteta - 4
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shipwide_ai_announcement), "ATTENTION: TRACKING TARGET, SPOOLING UP POINT DEFENSE. ATTEMPTING TO INTERCEPT." , MAIN_AI_SYSTEM, 'sound/effects/supercapacitors_charging.ogg'), spoolup SECONDS)

					for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
						if(!is_mainship_level(current_mob.z))
							continue
					//weaponhits(1, mob.loc, point_defense)

		if("Railgun")
			exactplace = tgui_alert(src, "Shoot it at random places, or where you're at?", "Choose wisely!", list("Random", "Where I am"), 20 SECONDS)
			if(exactplace == "Random")
				salvo = tgui_alert(src, "Make it a salvo or a single fire?", "Choose wisely!", list("Salvo", "Single"), 20 SECONDS)
				if(salvo == "Salvo")
					quantity = tgui_input_number(src, "How many?", "Don't go overboard. Please.", 2, 10, 2, 20 SECONDS)
					var/prompt = tgui_alert(src, "Are you sure you want to shoot railgun slugs at the USS Almayer at random places?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
					if(prompt == "Yes")
						shipwide_ai_announcement("DANGER: RAILGUN EMISSIONS DETECTED, SALVO INCOMING. BRACE, BRACE, BRACE. SALVO SIZE: [quantity] , ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
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
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 2, targets, null, salvo), hiteta SECONDS)
						picked_atom = null
						targets = null
				if(salvo == "Single")
					var/prompt = tgui_alert(src, "Are you sure you want to shoot a railgun slug at the USS Almayer at a random place?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
					if(prompt == "Yes")
						shipwide_ai_announcement("DANGER: RAILGUN EMISSIONS DETECTED, INCOMING SHOT. BRACE, BRACE, BRACE. SALVO SIZE: [quantity] , ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
						while(picked_atom == null)
							picked_area = pick(GLOB.ship_areas)

							for(var/turf/my_turf in picked_area)
								if(isturf(my_turf))
									turfs_of_area += my_turf

							if(turfs_of_area.len > 1)
								picked_atom = pick(turfs_of_area)

						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 2, picked_atom, null), hiteta SECONDS)

			if(exactplace == "Where I am")
				var/prompt = tgui_alert(src, "Are you sure you want to shoot a railgun slug at the USS Almayer at your location?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
				if(prompt == "Yes")
					shipwide_ai_announcement("DANGER: RAILGUN EMISSIONS DETECTED, INCOMING SHOT. BRACE, BRACE, BRACE. SALVO SIZE: [quantity] , ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
					while(picked_atom == null)
						picked_area = pick(GLOB.ship_areas)

						for(var/turf/my_turf in picked_area)
							if(isturf(my_turf))
								turfs_of_area += my_turf

						if(turfs_of_area.len > 1)
							picked_atom = pick(turfs_of_area)

					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 2, mob.loc, null), hiteta SECONDS)

		if("Particle cannon")
			//abagable
