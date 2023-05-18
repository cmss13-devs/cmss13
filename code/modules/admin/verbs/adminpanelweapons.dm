/client/proc/adminpanelweapons()
	set name = "Weapons"
	set category = "Admin.Ship"

	var/datum/space_weapon/weapon_type = tgui_alert(src, "What weapon?", "Choose wisely!", GLOB.space_weapons, 20 SECONDS)
	if(!weapon_type)
		return
	weapon_type = GLOB.space_weapons[weapon_type]

	var/ammo_type = tgui_alert(src, "What weapon?", "Choose wisely!", weapon_type.possibly_ammunition + list("Random"), 20 SECONDS)
	if(!ammo_type)
		return
	if(ammo_type == "Random")
		ammo_type = weapon_type.possibly_ammunition

	var/hit_eta = tgui_input_number(src, "Give an ETA for the weapon to hit.", "Don't make them wait too long!", 10, 120, 10, 20 SECONDS)
	if(!hit_eta)
		return

	var/intercept_chance = tgui_alert(src, "Chance Point Defence of the ship to intercept, or for the weapon to miss?", "standard PD chance is 0%.", 0, 100, 0, 20 SECONDS)

	var/targets
	var/quantity = 1
	if(tgui_alert(src, "Shoot it at random places, or where you're at?", "Choose wisely!", list("Random", "Where I am"), 20 SECONDS) == "Where I am")
		targets = list(get_turf(mob))
	else
		quantity = tgui_input_number(src, "How many?", "Don't go overboard. Please.", 1, 16, 1, 20 SECONDS)
		targets = shipside_random_turf_picker(quantity)

	if(tgui_alert(src, "Are you sure you want to open fire at the [MAIN_SHIP_NAME] with those parameters?", "Choose wisely!", list("Yes", "No"), 20 SECONDS) != "Yes")
		return

	weapon_type.shot_message(length(targets), hit_eta)
	addtimer(CALLBACK(weapon_type, TYPE_PROC_REF(/datum/space_weapon, on_shot), targets, ammo_type, intercept_chance), hit_eta SECONDS)
	message_admins("[key_name_admin(src)] Fired [quantity] of [ammo_type] form [weapon_type] at the Almayer, with point defense as [intercept_chance]%")
	if(intercept_chance)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shipwide_ai_announcement), "ATTENTION: TRACKING TARGET[quantity > 1 ? "S" : ""], SPOOLING UP POINT DEFENSE. ATTEMPTING TO INTERCEPT." , MAIN_AI_SYSTEM, 'sound/effects/supercapacitors_charging.ogg'), (hit_eta - 4) SECONDS)

/proc/shipside_random_turf_picker(turfquantity)
	var/list/targets = list()
	for(var/currentturf = 1 to turfquantity)
		var/list/turfs_of_area = list()
		for(var/area in GLOB.ship_areas)
			for(var/turf/my_turf in area)
				turfs_of_area += my_turf
		targets += pick(turfs_of_area)
	return targets
