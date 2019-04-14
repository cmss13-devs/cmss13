
//Weyland Yutani SCP. Neutral to USCM, hostile to xenos.
/datum/emergency_call/scp
	name = "SCP - Secure, Contain, Protect (Squad)"
	mob_min = 5
	mob_max = 10
	shuttle_id = "Distress_PMC"
	name_of_spawn = "Distress_PMC"

	New()
		..()
		arrival_message = "[MAIN_SHIP_NAME], this is USCSS Lunalorne responding to your distress call. We are boarding. Any hostile actions will be met with lethal force."
		objectives = "Sweep the [MAIN_SHIP_NAME], secure the speciment, get it safely back onto your shuttle and return. Don't antagonise the crew or engage hostiles, unless they stand between you and your mission."

/datum/emergency_call/scp/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	mob.key = M.key
	if(mob.client) mob.client.change_view(world.view)

	ticker.mode.traitors += mob.mind
	if(!leader)       //First one spawned is always the leader.
		leader = mob
		arm_equipment(mob, "Weyland-Yutani SCP PMC (Leader)", TRUE)
	else
		mob.mind.special_role = "MODE"
		if(prob(55)) //Randomize the heavy commandos and standard PMCs.
			arm_equipment(mob, "Weyland-Yutani SCP PMC (Standard)", TRUE)
			to_chat(mob, "<font size='3'>\red You are a Weyland Yutani mercenary!</font>")
		else
			if(prob(30))
				arm_equipment(mob, "Weyland-Yutani SCP PMC (Sniper)", TRUE)
				to_chat(mob, "<font size='3'>\red You are a Weyland Yutani sniper!</font>")
			else
				arm_equipment(mob, "Weyland-Yutani SCP PMC (Gunner)", TRUE)
				to_chat(mob, "<font size='3'>\red You are a Weyland Yutani heavy gunner!</font>")
	print_backstory(mob)

	sleep(10)
	to_chat(M, "<B>Objectives:</b> [objectives]")



/datum/emergency_call/scp/print_backstory(mob/living/carbon/human/M)
	to_chat(M, "<B>You are part of Weyland Yutani Special Task Force Royal that arrived in 2182 following the UA withdrawl of the Tychon's Rift sector.</b>")
	to_chat(M, "<B>Task-force Royal is stationed aboard the USCSS Lunalorne, a powerful Weyland-Yutani cruiser that patrols the outer edges of Tychon's Rift.</b>")
	to_chat(M, "<B>Under the directive of Weyland-Yutani board member Johan Almric, you act as private security for Weyland Yutani science teams.</b>")
	to_chat(M, "<B>The USCSS Lunalorne contains a crew of roughly two hundred PMCs, and one hundred scientists and support personnel.</b>")
	to_chat(M, "")
	to_chat(M, "")
	to_chat(M, "<B>Sweep the [MAIN_SHIP_NAME], secure the speciment, get it safely back onto your shuttle and return.</b>")
	to_chat(M, "<B>Don't antagonise the crew or engage hostiles, unless they stand between you and your mission.</b>")


/datum/emergency_call/scp/spawn_items()
	var/turf/drop_spawn
	var/choice

	for(var/i = 0 to 0) //Spawns up to 3 random things.
		if(prob(20)) continue
		choice = (rand(1,8) - round(i/2)) //Decreasing values, rarer stuff goes at the end.
		if(choice < 0) choice = 0
		drop_spawn = get_spawn_point(1)
		if(istype(drop_spawn))
			switch(choice)
				if(0)
					new /obj/item/weapon/gun/smg/m39/elite(drop_spawn)
					new /obj/item/weapon/gun/smg/m39/elite(drop_spawn)
					new /obj/item/ammo_magazine/smg/m39/ap
					new /obj/item/ammo_magazine/smg/m39/ap
					continue
				if(1)
					new /obj/item/weapon/gun/smg/m39/elite(drop_spawn)
					new /obj/item/weapon/gun/smg/m39/elite(drop_spawn)
					new /obj/item/ammo_magazine/smg/m39/ap
					new /obj/item/ammo_magazine/smg/m39/ap
					continue
				if(2)
					new /obj/item/weapon/gun/flamer(drop_spawn)
					new /obj/item/weapon/gun/flamer(drop_spawn)
					new /obj/item/weapon/gun/flamer(drop_spawn)
					continue
				if(3)
					new /obj/item/explosive/plastique(drop_spawn)
					new /obj/item/explosive/plastique(drop_spawn)
					new /obj/item/explosive/plastique(drop_spawn)
					continue
				if(4)
					new /obj/item/weapon/gun/rifle/m41a/elite(drop_spawn)
					new /obj/item/weapon/gun/rifle/m41a/elite(drop_spawn)
					new /obj/item/ammo_magazine/rifle/incendiary
					new /obj/item/ammo_magazine/rifle/incendiary
					continue
				if(5)
					new /obj/item/weapon/gun/launcher/m92(drop_spawn)
					new /obj/item/explosive/grenade/HE/PMC(drop_spawn)
					new /obj/item/explosive/grenade/HE/PMC(drop_spawn)
					new /obj/item/explosive/grenade/HE/PMC(drop_spawn)
					continue
				if(6)
					new /obj/item/explosive/grenade/HE/PMC(drop_spawn)
					new /obj/item/weapon/gun/flamer(drop_spawn)
					continue
				if(7)
					new /obj/item/explosive/grenade/HE/PMC(drop_spawn)
					new /obj/item/explosive/grenade/HE/PMC(drop_spawn)
					new /obj/item/explosive/grenade/HE/PMC(drop_spawn)
					new /obj/item/weapon/gun/flamer(drop_spawn)
					continue

/datum/emergency_call/scp/platoon
	name = "SCP - Secure, Contain, Protect (Platoon)"
	mob_min = 8
	mob_max = 25
	probability = 0