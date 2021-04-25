/obj/item/explosive/grenade/flashbang
	name = "flashbang"
	icon_state = "flashbang"
	item_state = "grenade_flashbang"

	var/banglet = 0
	harmful = FALSE

	var/strength = 50


/obj/item/explosive/grenade/flashbang/attack_self(mob/user)
	if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return
	..()


/obj/item/explosive/grenade/flashbang/prime()
	..()
	var/turf/T = get_turf(src)
	for(var/obj/structure/closet/L in hear(7, T))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				bang(get_turf(src), M)


	for(var/mob/living/carbon/M in hear(7, T))
		if(!istype(M,/mob/living/carbon/Xenomorph))
			bang(T, M)



	new/obj/effect/particle_effect/smoke/flashbang(T)
	qdel(src)
	return

/obj/item/explosive/grenade/flashbang/proc/bang(var/turf/T , var/mob/living/carbon/M)						// Added a new proc called 'bang' that takes a location and a person to be banged.
	if (locate(/obj/item/device/chameleon, M))			// Called during the loop that bangs people in lockers/containers and when banging
		for(var/obj/item/device/chameleon/S in M)			// people in normal view.  Could theroetically be called during other explosions.
			S.disrupt(M)

	to_chat(M, SPAN_WARNING("<B>BANG</B>"))
	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1)

	var/trained_human = FALSE
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(skillcheck(H, SKILL_POLICE, SKILL_POLICE_SKILLED))
			trained_human = TRUE

		var/list/protections = list(H.glasses, H.wear_mask, H.head)
		var/total_eye_protection = 0

		for(var/obj/item/clothing/C in protections)
			if(C && (C.flags_armor_protection & BODY_FLAG_EYES))
				total_eye_protection += C.armor_energy

		if(total_eye_protection >= strength)
			to_chat(M, SPAN_HELPFUL("Your armor protects you from \the [src]."))
			return

	if(M.flash_eyes())
		M.Stun(2)
		M.KnockDown(10)

	if((get_dist(M, T) <= 2 || src.loc == M.loc || src.loc == M))
		if(trained_human)
			M.Stun(2)
			M.KnockDown(1)
		else
			M.Stun(10)
			M.KnockDown(3)
			if ((prob(14) || (M == src.loc && prob(70))))
				M.ear_damage += rand(1, 10)
			else
				M.ear_damage += rand(0, 5)
				M.ear_deaf = max(M.ear_deaf,15)

	else if(get_dist(M, T) <= 5)
		if(!trained_human)
			M.Stun(8)
			M.ear_damage += rand(0, 3)
			M.ear_deaf = max(M.ear_deaf,10)

	else if(!trained_human)
		M.Stun(4)
		M.ear_damage += rand(0, 1)
		M.ear_deaf = max(M.ear_deaf,5)

//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, SPAN_WARNING("Your eyes start to burn badly!"))
			if(!banglet && !(istype(src , /obj/item/explosive/grenade/flashbang/clusterbang)))
				if (E.damage >= E.min_broken_damage)
					to_chat(M, SPAN_WARNING("You can't see anything!"))
	if (M.ear_damage >= 15)
		to_chat(M, SPAN_WARNING("Your ears start to ring badly!"))
		if(!banglet && !(istype(src , /obj/item/explosive/grenade/flashbang/clusterbang)))
			if (prob(M.ear_damage - 10 + 5))
				to_chat(M, SPAN_WARNING("You can't hear anything!"))
				M.sdisabilities |= DISABILITY_DEAF
	else
		if (M.ear_damage >= 5)
			to_chat(M, SPAN_WARNING("Your ears start to ring!"))


/obj/item/explosive/grenade/flashbang/clusterbang//Created by Polymorph, fixed by Sieve
	desc = "Use of this weapon may constiute a war crime in your area, consult your local captain."
	name = "clusterbang"
	icon_state = "clusterbang"

/obj/item/explosive/grenade/flashbang/clusterbang/prime()
	var/numspawned = rand(4,8)
	var/again = 0
	for(var/more = numspawned,more > 0,more--)
		if(prob(35))
			again++
			numspawned --
	var/turf/T = get_turf(src)
	for(,numspawned > 0, numspawned--)
		spawn(0)
			new /obj/item/explosive/grenade/flashbang/cluster(T)//Launches flashbangs
			playsound(T, 'sound/weapons/armbomb.ogg', 25, 1, 6)

	for(,again > 0, again--)
		spawn(0)
			new /obj/item/explosive/grenade/flashbang/clusterbang/segment(T)//Creates a 'segment' that launches a few more flashbangs
			playsound(T, 'sound/weapons/armbomb.ogg', 25, 1, 6)

	qdel(src)

/obj/item/explosive/grenade/flashbang/clusterbang/primed/Initialize()
	..()
	prime()

/obj/item/explosive/grenade/flashbang/clusterbang/segment
	desc = "A smaller segment of a clusterbang. Better run."
	name = "clusterbang segment"
	icon_state = "clusterbang_segment"

/obj/item/explosive/grenade/flashbang/clusterbang/segment/New()//Segments should never exist except part of the clusterbang, since these immediately 'do their thing' and asplode
	icon_state = "clusterbang_segment_active"
	active = 1
	banglet = 1
	var/stepdist = rand(1,4)//How far to step
	var/temploc = src.loc//Saves the current location to know where to step away from
	walk_away(src,temploc,stepdist)//I must go, my people need me
	var/dettime = rand(15,60)
	addtimer(CALLBACK(src, .proc/prime), dettime)
	..()

/obj/item/explosive/grenade/flashbang/clusterbang/segment/prime()
	var/numspawned = rand(4,8)
	for(var/more = numspawned,more > 0,more--)
		if(prob(35))
			numspawned --
	var/turf/T = get_turf(src)
	for(,numspawned > 0, numspawned--)
		spawn(0)
			new /obj/item/explosive/grenade/flashbang/cluster(T)
			playsound(T, 'sound/weapons/armbomb.ogg', 25, 1, 6)
	qdel(src)

/obj/item/explosive/grenade/flashbang/cluster
	icon_state = "flashbang_active"
	active = 1
	banglet = 1

/obj/item/explosive/grenade/flashbang/cluster/Initialize()
	. = ..()
	var/stepdist = rand(1,3)
	var/temploc = src.loc
	walk_away(src,temploc,stepdist)
	addtimer(CALLBACK(src, .proc/prime), rand(15, 60))
