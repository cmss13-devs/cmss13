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

	var/weapontype = tgui_alert(src, "What weapon?", "Choose wisely!", list("Missile", "Railgun", "Particle cannon"), 20 SECONDS)
	var/pd = tgui_alert(src, "Allow Point Defence of the ship to intercept?", "Be nice!", list("Yes", "No"), 20 SECONDS)
	var/hiteta = tgui_input_number(src, "Give an ETA for the weapon to hit.", "Don't make them wait too long!!", 10, 120, 10)
	switch(weapontype)
		if("Missile")
			exactplace = tgui_alert(src, "Shoot it at random places, or where you're at?", "Choose wisely!", list("Random", "Where I am"), 20 SECONDS)
			if(exactplace == "Random")
				salvo = tgui_alert(src, "Make it a salvo or a single fire?", "Choose wisely!", list("Salvo", "Single"), 20 SECONDS)
				if(salvo == "Salvo")
					quantity = tgui_input_number(src, "How many?", "Don't go overboard. Please.", 2, 5, 2, 20 SECONDS)
					shipwide_ai_announcement("DANGER: MISSILE SALVO DETECTED, BRACE, BRACE, BRACE. SALVO SIZE: [quantity] , ESTIMATED TIME: [hiteta]" , MAIN_AI_SYSTEM, 'sound/effects/ob_alert.ogg')
					for(currentshot = 1; currentshot <= quantity; currentshot++ )
						while(picked_atom == null)
							picked_area = pick(GLOB.ship_areas)

							for(var/turf/my_turf in picked_area)
								if(isturf(my_turf))
									turfs_of_area += my_turf
							if(turfs_of_area.len > 1)
								picked_atom = pick(turfs_of_area)

						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, picked_atom, pd), hiteta SECONDS)
						picked_atom = null
						//weaponhits(1, picked_atom, pd)
				if(salvo == "Single")
					var/prompt = tgui_alert(src, "Are you sure you want to open fire at the USS Almayer at a random place?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
					if(prompt == "Yes")
						shipwide_ai_announcement("DANGER: MISSILE WARNING. LAUNCH DETECTED, BRACE BRACE BRACE. ESTIMATED TIME: [hiteta]", MAIN_AI_SYSTEM, 'sound/effects/ob_alert.ogg')
						while(picked_atom == null)
							picked_area = pick(GLOB.ship_areas)

							for(var/turf/my_turf in picked_area)
								if(isturf(my_turf))
									turfs_of_area += my_turf

							if(turfs_of_area.len > 1)
								picked_atom = pick(turfs_of_area)

						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, picked_atom, pd), hiteta SECONDS)

			if(exactplace == "Where I am")
				var/prompt = tgui_alert(src, "Are you sure you want to open fire at the USS Almayer with your position as target?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
				if(prompt == "Yes")
					shipwide_ai_announcement("DANGER: MISSILE WARNING. LAUNCH DETECTED, BRACE BRACE BRACE. ESTIMATED TIME: [hiteta]", MAIN_AI_SYSTEM, 'sound/effects/ob_alert.ogg')
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, mob.loc, pd), hiteta SECONDS)
					//weaponhits(1, mob.loc, pd)

		if("Railgun")
			//abagable
		if("Particle cannon")
			//abagable
