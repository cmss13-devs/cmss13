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
	point_defense = point_defense == "Yes"
	var/exactplace = tgui_alert(src, "Shoot it at random places, or where you're at?", "Choose wisely!", list("Random", "Where I am"), 20 SECONDS)
	if(!exactplace)
		return
	exactplace = exactplace == "Where I am"

	var/salvo
	var/quantity
	if(exactplace == FALSE)
		salvo = tgui_alert(src, "Make it a salvo or a single fire?", "Choose wisely!", list("Salvo", "Single"), 20 SECONDS)
		if(!salvo)
			return
		salvo = salvo == "Salvo"
		if(salvo == TRUE)
			quantity = tgui_input_number(src, "How many?", "Don't go overboard. Please.", 2, 10, 2, 20 SECONDS)

	var/prompt = tgui_alert(src, "Are you sure you want to open fire at the USS Almayer with those parameters?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
	if(prompt != "Yes")
		return
	var/atom/picked_atom
	var/list/targets = list()
	switch(weapontype)

		if("Missile")
			if(exactplace == TRUE)
				shipwide_ai_announcement("DANGER: MISSILE WARNING. LAUNCH DETECTED, BRACE, BRACE, BRACE. ESTIMATED TIME: [hiteta] SECONDS.", MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, mob.loc, point_defense), hiteta SECONDS)
				message_admins("[key_name_admin(src)] Fired a Single Missile at the Almayer at their own location, [mob.loc], with point defense as [point_defense]")
				if(point_defense == TRUE)
					var/spoolup = hiteta - 4
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shipwide_ai_announcement), "ATTENTION: TRACKING TARGET, SPOOLING UP POINT DEFENSE. ATTEMPTING TO INTERCEPT." , MAIN_AI_SYSTEM, 'sound/effects/supercapacitors_charging.ogg'), spoolup SECONDS)

			if(exactplace == FALSE)
				if(salvo == TRUE)
					shipwide_ai_announcement("DANGER: MISSILE SALVO DETECTED, BRACE, BRACE, BRACE. SALVO SIZE: [quantity], ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
					targets = shipside_random_turf_picker(quantity)
					if(targets == null)
						tgui_alert(src, "Uh oh! Something broke at this point! Contact the coders!", "Acknowledge!", list("ok."), 10 SECONDS)
						return
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, targets, point_defense, salvo), hiteta SECONDS)
					message_admins("[key_name_admin(src)] Fired a salvo of [quantity] Missiles at the Almayer at random places, with point defense as [point_defense]")
					if(point_defense == TRUE)
						var/spoolup = hiteta - 4
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shipwide_ai_announcement), "ATTENTION: TRACKING TARGETS, SPOOLING UP POINT DEFENSE. ATTEMPTING TO INTERCEPT." , MAIN_AI_SYSTEM, 'sound/effects/supercapacitors_charging.ogg'), spoolup SECONDS)
				else
					shipwide_ai_announcement("DANGER: MISSILE WARNING. LAUNCH DETECTED, BRACE, BRACE, BRACE. ESTIMATED TIME: [hiteta] SECONDS.", MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
					picked_atom = shipside_random_turf_picker(1)
					if(picked_atom == null)
						tgui_alert(src, "Uh oh! Something broke at this point! Contact the coders!", "Acknowledge!", list("ok."), 10 SECONDS)
						return
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, picked_atom, point_defense), hiteta SECONDS)
					message_admins("[key_name_admin(src)] Fired a Single Missile at the Almayer at a random place, [picked_atom], with point defense as [point_defense]")
					if(point_defense == TRUE)
						var/spoolup = hiteta - 4
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shipwide_ai_announcement), "ATTENTION: TRACKING TARGET, SPOOLING UP POINT DEFENSE. ATTEMPTING TO INTERCEPT." , MAIN_AI_SYSTEM, 'sound/effects/supercapacitors_charging.ogg'), spoolup SECONDS)

		if("Railgun")
			if(exactplace == TRUE)
				shipwide_ai_announcement("DANGER: RAILGUN EMISSIONS DETECTED, INCOMING SHOT. BRACE, BRACE, BRACE. ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 2, mob.loc, point_defense), hiteta SECONDS)
				message_admins("[key_name_admin(src)] Fired a single Railgun Slug at the Almayer at their location, [mob.loc], with the possibility of missing as [point_defense]")


			if(exactplace == FALSE)
				if(salvo == TRUE)
					shipwide_ai_announcement("DANGER: RAILGUN EMISSIONS DETECTED, SALVO INCOMING. BRACE, BRACE, BRACE. SALVO SIZE: [quantity], ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
					targets = shipside_random_turf_picker(quantity)
					if(targets == null)
						tgui_alert(src, "Uh oh! Something broke at this point! Contact the coders!", "Acknowledge!", list("ok."), 10 SECONDS)
						return
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 2, targets, point_defense, salvo), hiteta SECONDS)
					message_admins("[key_name_admin(src)] Fired a salvo of Railgun Slugs at the Almayer at random places, with the possibility of missing [point_defense]")
					picked_atom = null
					targets = null

				if(salvo == FALSE)
					prompt = tgui_alert(src, "Are you sure you want to shoot a railgun slug at the USS Almayer at a random place?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
					if(prompt == "Yes")
						shipwide_ai_announcement("DANGER: RAILGUN EMISSIONS DETECTED, INCOMING SHOT. BRACE, BRACE, BRACE. ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
						picked_atom = shipside_random_turf_picker(1)
						if(picked_atom == null)
							tgui_alert(src, "Uh oh! Something broke at this point! Contact the coders!", "Acknowledge!", list("ok."), 10 SECONDS)
							return
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 2, picked_atom, point_defense), hiteta SECONDS)
						message_admins("[key_name_admin(src)] Fired a single Railgun Slug at the Almayer at a random location, [picked_atom], with the possibility of missing as [point_defense]")

/proc/shipside_random_turf_picker(turfquantity)

	var/picked_atom
	var/picked_area
	var/list/targets = list()
	var/list/turfs_of_area = list()
	for(var/currentturf in 1 to turfquantity)
		for(var/limiter in 1 to 120)
			picked_area = pick(GLOB.ship_areas)
			for(var/turf/my_turf in picked_area)
				turfs_of_area += my_turf
			if(turfs_of_area.len > 0)
				picked_atom = pick(turfs_of_area)
				if (picked_atom != null)
					targets += picked_atom
					break

	if(targets.len < turfquantity)
		return null
	else
		return targets

