/client/proc/adminpanelweapons()
	set name = "Weapons"
	set category = "Admin.Ship"

	var/weapontype = tgui_alert(src, "What weapon?", "Choose wisely!", list("Missile", "Railgun"), 20 SECONDS) == "Railgun"

	var/hiteta = tgui_input_number(src, "Give an ETA for the weapon to hit.", "Don't make them wait too long!", 10, 120, 10, 20 SECONDS)
	if(!hiteta)
		return

	var/point_defense = tgui_alert(src, "Allow Point Defence of the ship to intercept, or for the weapon to miss?", "standard PD/miss chance is 30%.", list("Yes", "No"), 20 SECONDS) == "Yes"

	var/targets
	var/salvo = FALSE
	var/quantity = 1
	if(tgui_alert(src, "Shoot it at random places, or where you're at?", "Choose wisely!", list("Random", "Where I am"), 20 SECONDS) == "Where I am")
		targets = list(get_turf(mob))
	else
		quantity = tgui_input_number(src, "How many?", "Don't go overboard. Please.", 1, 16, 1, 20 SECONDS)
		if(quantity > 1)
			salvo = TRUE
		targets = shipside_random_turf_picker(quantity)

	if(tgui_alert(src, "Are you sure you want to open fire at the [MAIN_SHIP_NAME] with those parameters?", "Choose wisely!", list("Yes", "No"), 20 SECONDS) != "Yes")
		return

	shipwide_ai_announcement("DANGER: [weapontype ? "RAILGUN EMISSIONS DETECTED, INCOMING SHOT." : "MISSILE WARNING, LAUNCH DETECTED."]BRACE, BRACE, BRACE. [salvo ? "SALVO SIZE: [quantity],"] ESTIMATED TIME: [hiteta] SECONDS." , MAIN_AI_SYSTEM, 'sound/effects/missile_warning.ogg')
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(weaponhits), weapontype, targets, point_defense, salvo), hiteta SECONDS)
	message_admins("[key_name_admin(src)] Fired a [salvo ? "salvo of [quantity]" : "single"] [weapontype ? "Missile" : "Railgun Slug"] at the Almayer, with point defense as [point_defense]")
	if(point_defense)
		var/spoolup = hiteta - 4
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shipwide_ai_announcement), "ATTENTION: TRACKING TARGET[salvo ? "S" : ""], SPOOLING UP POINT DEFENSE. ATTEMPTING TO INTERCEPT." , MAIN_AI_SYSTEM, 'sound/effects/supercapacitors_charging.ogg'), spoolup SECONDS)

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
			picked_atom = pick(turfs_of_area)
			targets += picked_atom
			break
	return targets
