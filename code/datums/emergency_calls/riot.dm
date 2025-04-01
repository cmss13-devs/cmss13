
//Anti-riot team
/datum/emergency_call/riot
	name = "USCM Riot Control"
	mob_max = 10
	mob_min = 5
	objectives = "Ensure order is restored and Marine Law is maintained."
	probability = 0


/datum/emergency_call/riot/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_WARDEN, JOB_CHIEF_POLICE), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/uscm_ship/uscm_police/riot_mp/riot_cmp, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are the leader of the High Command Riot Control!"))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from High Command!"))
		to_chat(H, SPAN_ROLE_BODY("You only answer to the Marine Law and the High Command!"))
	else
		arm_equipment(H, /datum/equipment_preset/uscm_ship/uscm_police/riot_mp, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a member of the High Command Riot Control!"))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from High Command or your superior!"))
		to_chat(H, SPAN_ROLE_BODY("You only answer to your superior, the Marine Law and the High Command!"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)


/datum/emergency_call/riot/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/nade_box/tear_gas(drop_spawn)
	new /obj/item/storage/box/nade_box/tear_gas(drop_spawn)

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)
	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/weapon/gun/launcher/grenade/m84(drop_spawn)
	new /obj/item/weapon/gun/launcher/grenade/m84(drop_spawn)
	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/weapon/gun/launcher/grenade/m84(drop_spawn)
	new /obj/item/weapon/gun/launcher/grenade/m84(drop_spawn)
