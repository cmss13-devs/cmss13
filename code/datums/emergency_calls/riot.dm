
//Anti-riot team
/datum/emergency_call/riot
	name = "USCM Riot Control"
	mob_max = 10
	mob_min = 5
	objectives = "Ensure order is restored and Marine Law is maintained."
	probability = 0


/datum/emergency_call/riot/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/T = get_spawn_point()

	if(!istype(T)) r_FAL

	var/mob/living/carbon/human/H = new(T)
	H.dna.ready_dna(H)
	H.key = M.key
	if(H.client) H.client.change_view(world.view)

	ticker.mode.traitors += H.mind

	if(!leader)       //First one spawned is always the leader.
		leader = H
		arm_equipment(H, "USCM Riot Chief MP (RCMP)", TRUE)
		H << "<font size='3'>\red You are the leader of the High Command Riot Control!</font>"
		H << "<B> Follow any orders directly from High Command!</b>"
		H << "<B> You only answer to the Marine Law and the High Command!</b>"
	else
		arm_equipment(H, "USCM Riot MP (RMP)", TRUE)
		H << "<font size='3'>\red You are a member of the High Command Riot Control!!</font>"
		H << "<B> Follow any orders directly from High Command or your superior!</b>"
		H << "<B> You only answer to your superior, the Marine Law and the High Command!</b>"

	sleep(10)
	M << "<B>Objectives:</b> [objectives]"


/datum/emergency_call/riot/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(1)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

	drop_spawn = get_spawn_point(1)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

	drop_spawn = get_spawn_point(1)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	drop_spawn = get_spawn_point(1)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)

	drop_spawn = get_spawn_point(1)
	new /obj/item/storage/box/nade_box/tear_gas(drop_spawn)
	new /obj/item/storage/box/nade_box/tear_gas(drop_spawn)

	drop_spawn = get_spawn_point(1)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)
	drop_spawn = get_spawn_point(1)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)

	drop_spawn = get_spawn_point(1)
	new /obj/item/weapon/gun/launcher/m81/riot(drop_spawn)
	new /obj/item/weapon/gun/launcher/m81/riot(drop_spawn)
	drop_spawn = get_spawn_point(1)
	new /obj/item/weapon/gun/launcher/m81/riot(drop_spawn)
	new /obj/item/weapon/gun/launcher/m81/riot(drop_spawn)