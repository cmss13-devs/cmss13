/client/proc/adminpanelweapons()
	set name = "Weapons"
	set category = "Admin.Ship"

	var/salvo
	var/quantity
	var/currentshot
	var/exactplace

	var/weapontype = tgui_alert(src, "What weapon?", "Choose wisely!", list("Missile", "Railgun", "Particle cannon"), 20 SECONDS)
	var/pd = tgui_alert(src, "Allow Point Defence of the ship to intercept?", "Be nice!", list("Yes", "No"), 20 SECONDS)
	var/hiteta = tgui_input_number(src, "Give an ETA for the weapon to hit.", "Don't make them wait too long!!", 10, 120, 10)
	switch(weapontype)
		if("Missile")
			exactplace = tgui_alert(src, "Shoot it at random places, or where you're at?", "Choose wisely!", list("Random", "Where I am"), 20 SECONDS)
			if(exactplace == "Random")
				salvo = tgui_alert(src, "Make it a salvo or a single fire?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
					if(salvo == "Yes")
						quantity = tgui_input_number(src, "How many?", "Don't go overboard. Please.", 2, 5, 2, 20, TRUE)
						shipwide_ai_announcement("DANGER: MISSILE SALVO DETECTED, BRACE, BRACE, BRACE. SALVO SIZE: [quantity] , ESTIMATED TIME: [hiteta]" , MAIN_AI_SYSTEM, 'sound/effects/ob_alert.ogg')
						for(currentshot = 1; currentshot <= quantity; currentshot++ )
							var/area/picked_area = pick(GLOB.global_ship_areas)
							var/atom/picked_atom = pick(picked_area.contents)
							addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, picked_atom, pd), hiteta SECONDS)
							//weaponhits(1, picked_atom, pd)
					if(salvo == "No")
						var/prompt = tgui_alert(src, "Are you sure you want to open fire at the USS Almayer at a random place?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
							if(prompt == "Yes")
								shipwide_ai_announcement("DANGER: MISSILE WARNING. LAUNCH DETECTED, BRACE BRACE BRACE. ESTIMATED TIME: [hiteta]", MAIN_AI_SYSTEM, 'sound/effects/ob_alert.ogg')
								var/area/picked_area = pick(GLOB.global_ship_areas)
								var/atom/picked_atom = pick(picked_area.contents)
								addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), 1, picked_atom, pd), hiteta SECONDS)
								//weaponhits(1, picked_atom, pd)

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
