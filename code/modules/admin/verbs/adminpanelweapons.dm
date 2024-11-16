/client/proc/adminpanelweapons()
	set name = "Weapons"
	set category = "Admin.Ship"

	var/list/datum/space_weapon/potential_weapons = list()
	for(var/weapon_to_get in GLOB.space_weapons)
		var/datum/space_weapon/weapon_to_set = GLOB.space_weapons[weapon_to_get]
		LAZYSET(potential_weapons, weapon_to_set.name, weapon_to_set)

	var/weapon_type = tgui_input_list(src, "What weapon?", "Choose wisely!", potential_weapons)
	if(!weapon_type)
		return

	var/list/ammo_type = list()
	var/answer = tgui_alert(src, "Use all ammo types?", "Ammo selector", list("Yes", "No", "Cancel"))
	if(answer == "Yes")
		ammo_type = potential_weapons[weapon_type].possibly_ammunition
	else if(answer == "No")
		var/list/datum/space_weapon_ammo/potential_ammo = list()
		for(var/ammo_to_get in potential_weapons[weapon_type].possibly_ammunition)
			var/datum/space_weapon_ammo/ammo_to_set = GLOB.space_weapons_ammo[ammo_to_get]
			LAZYSET(potential_ammo, ammo_to_set.name, ammo_to_get)

		while(length(potential_ammo))
			var/additional_ammo = tgui_input_list(src, "Choose ammo", "Ammo selector", potential_ammo, 20 SECONDS)
			if(!additional_ammo)
				break
			ammo_type += potential_ammo[additional_ammo]
			potential_ammo -= additional_ammo
	else
		return

	if(!length(ammo_type))
		return

	var/hit_eta = tgui_input_number(src, "Give an ETA for the weapon to hit.", "Don't make them wait too long!", 10, 120, 10, 20 SECONDS)
	if(!hit_eta)
		return

	var/intercept_chance = tgui_input_number(src, "Chance Point Defence of the ship to intercept, or for the weapon to miss?", "standard PD chance is 0%.", 0, 100, 0, 20 SECONDS)

	var/targets
	var/quantity = 1
	if(tgui_alert(src, "Shoot it at random places, or where you're at?", "Choose wisely!", list("Random", "Where I am"), 20 SECONDS) == "Where I am")
		targets = list(get_turf(mob))
	else
		quantity = tgui_input_number(src, "How many?", "Don't go overboard. Please.", 1, 256, 1, 20 SECONDS)
		targets = shipside_random_turf_picker(quantity)

	var/delay = tgui_input_number(src, "Give delay between hits in diceseconds (1/10 of second). (0 async hits, can cause emotional damage)", "Don't make them wait too long!", 0, 600, 0, 20 SECONDS)

	if(tgui_alert(src, "Are you sure you want to open fire at the [MAIN_SHIP_NAME] with those parameters?", "Choose wisely!", list("Yes", "No")) != "Yes")
		return

	potential_weapons[weapon_type].shot_message(length(targets), hit_eta)
	addtimer(CALLBACK(potential_weapons[weapon_type], TYPE_PROC_REF(/datum/space_weapon, on_shot), targets, ammo_type, intercept_chance, delay), hit_eta SECONDS)
	message_admins("[key_name_admin(src)] Fired [quantity] form [weapon_type] at the Almayer, with point defense as [intercept_chance]% with delay of [delay/10] seconds between hits")
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
