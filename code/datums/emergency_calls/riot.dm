
//Anti-riot team
/datum/emergency_call/riot
	name = "USCM Riot Control"
	mob_max = 10
	mob_min = 5
	objectives = "Ensure order is restored and Marine Law is maintained."
	probability = 0


/datum/emergency_call/riot/create_member(datum/mind/M)
	var/turf/T = get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader)       //First one spawned is always the leader.
		leader = H
		arm_equipment(H, "USCM Riot Chief MP (RCMP)", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are the leader of the High Command Riot Control!"))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from High Command!</b>"))
		to_chat(H, SPAN_ROLE_BODY("You only answer to the Marine Law and the High Command!"))
	else
		arm_equipment(H, "USCM Riot MP (RMP)", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a member of the High Command Riot Control!!"))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from High Command or your superior!"))
		to_chat(H, SPAN_ROLE_BODY("You only answer to your superior, the Marine Law and the High Command!"))

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)


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
	new /obj/item/weapon/gun/launcher/grenade/m81/riot(drop_spawn)
	new /obj/item/weapon/gun/launcher/grenade/m81/riot(drop_spawn)
	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/weapon/gun/launcher/grenade/m81/riot(drop_spawn)
	new /obj/item/weapon/gun/launcher/grenade/m81/riot(drop_spawn)