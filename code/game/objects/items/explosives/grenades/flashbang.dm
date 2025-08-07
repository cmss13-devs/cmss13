/obj/item/explosive/grenade/flashbang
	name = "flashbang"
	icon_state = "flashbang"
	item_state = "grenade_flashbang"
	black_market_value = 10

	//can be used by synths
	harmful = FALSE

	//skill required to use
	var/skill_requirement = SKILL_POLICE_SKILLED

	//ignores ship anti-grief system
	antigrief_protection = FALSE

	//doesn't deal damage to eyes and ears (for cluster)
	var/no_damage = FALSE
	var/strength = 50

/obj/item/explosive/grenade/flashbang/Initialize()
	if(type == /obj/item/explosive/grenade/flashbang) // ugly but we only want to change base level flashbangs
		if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
			new /obj/item/explosive/grenade/flashbang/noskill(loc)
			return INITIALIZE_HINT_QDEL
		else if(SSticker.current_state < GAME_STATE_PLAYING)
			RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(replace_flashbang))
	return ..()

/obj/item/explosive/grenade/flashbang/proc/replace_flashbang()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		new /obj/item/explosive/grenade/flashbang/noskill(loc)
		qdel(src)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/item/explosive/grenade/flashbang/attack_self(mob/user)
	if(active)
		return

	if(!can_use_grenade(user))
		return

	if(isnull(loc))
		return

	if(!skillcheck(user, SKILL_POLICE, skill_requirement))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	..()

/obj/item/explosive/grenade/flashbang/prime()
	..()

	var/turf/T = get_turf(src)
	for(var/obj/structure/closet/L in hear(7, T))
		SEND_SIGNAL(L, COMSIG_CLOSET_FLASHBANGED, src)

	for(var/mob/living/carbon/M in hear(7, T))
		bang(T, M)

	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1)

	new/obj/effect/particle_effect/smoke/flashbang(T)
	qdel(src)
	return

// Added a new proc called 'bang' that takes a location and a person to be banged.
// Called during the loop that bangs people in lockers/containers and when banging
// people in normal view.  Could theoretically be called during other explosions.
/obj/item/explosive/grenade/flashbang/proc/bang(turf/T , mob/living/carbon/M)

	if(isxeno(M))
		return

	to_chat(M, SPAN_WARNING("<B>BANG</B>"))

	for(var/obj/item/device/chameleon/S in M)
		S.disrupt(M)

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
			to_chat(M, SPAN_HELPFUL("Your gear protects you from \the [src]."))
			return

	var/weaken_amount
	var/paralyze_amount
	var/deafen_amount

	if(M.flash_eyes())
		weaken_amount += 2
		paralyze_amount += 10

	if((get_dist(M, T) <= 2 || src.loc == M.loc || src.loc == M))
		if(trained_human)
			weaken_amount += 2
			paralyze_amount += 1
		else
			weaken_amount += 10
			paralyze_amount += 3
			deafen_amount += 15
			if(!no_damage)
				if((prob(14) || (M == src.loc && prob(70))))
					M.ear_damage += rand(1, 10)
				else
					M.ear_damage += rand(0, 5)

	else if(get_dist(M, T) <= 5)
		if(!trained_human)
			weaken_amount += 8
			deafen_amount += 10
			if(!no_damage)
				M.ear_damage += rand(0, 3)

	else if(!trained_human)
		weaken_amount += 4
		deafen_amount += 5
		if(!no_damage)
			M.ear_damage += rand(0, 1)

	if(HAS_TRAIT(M, TRAIT_EAR_PROTECTION))
		weaken_amount *= 0.85
		paralyze_amount *= 0.85
		deafen_amount = 0
		to_chat(M, SPAN_HELPFUL("Your gear protects you from the worst of the 'bang'."))

	M.Stun(weaken_amount)
	M.KnockDown(weaken_amount)
	M.KnockOut(paralyze_amount)
	if(deafen_amount)
		M.SetEarDeafness(max(M.ear_deaf, deafen_amount))

//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, SPAN_WARNING("Your eyes start to burn badly!"))
			if(!no_damage)
				if (E.damage >= E.min_broken_damage)
					to_chat(M, SPAN_WARNING("You can't see anything!"))
	if (M.ear_damage >= 15)
		to_chat(M, SPAN_WARNING("Your ears start to ring badly!"))
		if(!no_damage)
			if (prob(M.ear_damage - 10 + 5))
				to_chat(M, SPAN_WARNING("You can't hear anything!"))
				M.sdisabilities |= DISABILITY_DEAF
	else
		if (M.ear_damage >= 5)
			to_chat(M, SPAN_WARNING("Your ears start to ring!"))

//Created by Polymorph, fixed by Sieve
/obj/item/explosive/grenade/flashbang/cluster
	name = "cluster flashbang"
	desc = "Use of this weapon may be considered a war crime in your area, consult your local commanding officer."
	icon_state = "cluster"
	no_damage = TRUE

/obj/item/explosive/grenade/flashbang/cluster/primed/Initialize()
	. = ..()
	icon_state = "cluster_active"
	det_time = 10
	active = TRUE
	w_class = SIZE_MASSIVE // We cheat a little, primed nades become massive so they cant be stored anywhere
	addtimer(CALLBACK(src, PROC_REF(prime)), det_time)

/obj/item/explosive/grenade/flashbang/cluster/prime()
	for(var/i in 1 to rand(2,5))
		//Creates a 'segment' that launches a few more flashbangs
		new /obj/item/explosive/grenade/flashbang/cluster/segment(get_turf(src))
	qdel(src)

/obj/item/explosive/grenade/flashbang/cluster/segment
	name = "cluster flashbang segment"
	desc = "A smaller segment of a clusterbang. Better run."
	icon_state = "cluster_segment"

//Segments should never exist except part of the clusterbang, since these immediately 'do their thing' and explode
/obj/item/explosive/grenade/flashbang/cluster/segment/Initialize()
	icon_state = "cluster_segment_active"
	playsound(src.loc, 'sound/weapons/armbomb.ogg', 25, 1, 6)
	//Saves the current location to know where to step away from
	var/temploc = get_turf(src)
	//segments scatter in all directions
	walk_away(src,temploc,rand(1,4))
	addtimer(CALLBACK(src, PROC_REF(prime)), rand(10,20))
	return ..()

//Segment spawns cluster versions of flashbangs, 3 total
/obj/item/explosive/grenade/flashbang/cluster/segment/prime()
	for(var/i in 1 to 3)
		new /obj/item/explosive/grenade/flashbang/cluster_piece(src.loc)
	qdel(src)

/obj/item/explosive/grenade/flashbang/cluster_piece
	icon_state = "flashbang_active"
	no_damage = TRUE

/obj/item/explosive/grenade/flashbang/cluster_piece/Initialize()
	. = ..()
	var/temploc = get_turf(src)
	walk_away(src,temploc,rand(1,4))
	playsound(src.loc, 'sound/weapons/armbomb.ogg', 25, 1, 6)
	addtimer(CALLBACK(src, PROC_REF(prime)), rand(10,20))

//special flashbang nade for events. Skills are not required neither affect the effect.
//Knockdowns only within 3x3 area, causes temporary blindness, deafness and daze, depending on range and type of mob. Effects reduced when lying.
//Makes it perfect support tool, but not an insta win.
/obj/item/explosive/grenade/flashbang/noskill
	name = "M40 stun grenade"
	desc = "A less-lethal explosive device used to temporarily disorient an enemy by producing a flash of light and an intensely loud \"bang\", which cause temporary blindness and deafness. More commonly referred to as a \"flashbang\". Still dangerous if it explodes nearby."

	icon_state = "flashbang_noskill"
	item_state = "grenade_flashbang_noskill"

	skill_requirement = SKILL_POLICE_DEFAULT

/obj/item/explosive/grenade/flashbang/noskill/primed
	det_time = 10

/obj/item/explosive/grenade/flashbang/noskill/primed/Initialize()
	. = ..()
	activate()

/obj/item/explosive/grenade/flashbang/noskill/bang(turf/T , mob/living/M)
	if(M.stat == DEAD)
		return

	to_chat(M, SPAN_WARNING("<B>BANG</B>"))

	//some effects for non-humans
	if(!ishuman(M))
		if(isxeno(M))
			if(get_dist(M, T) <= 4)
				var/mob/living/carbon/xenomorph/X = M
				X.Daze(2)
				X.SetEarDeafness(max(X.ear_deaf, 3))
		else //simple mobs?
			M.Stun(5)
			M.KnockDown(1)

	var/mob/living/carbon/human/H = M

	for(var/obj/item/device/chameleon/S in H)
		S.disrupt(H)

	//decide how banged mob is
	var/bang_effect = 0
	var/lying = H.body_position == LYING_DOWN

	//flashbang effect depends on eye protection only, so we will process this case first
	//A bit dumb, but headsets don't have ear protection and even earmuffs are a fluff now
	if(H.get_eye_protection() > 0)
		to_chat(H, SPAN_HELPFUL("Your gear protects you from \the [src]."))
		if((get_dist(H, T) <= 1 || src.loc == H.loc || src.loc == H))
			H.apply_damage(5, BRUTE)
			H.apply_damage(5, BURN)
			if(lying)
				bang_effect = 1
			else
				bang_effect = 2
		else
			bang_effect = 1
		return

	else if((get_dist(get_turf(H), T) <= 1 || src.loc == H.loc || src.loc == H))

		H.apply_damage(5, BRUTE)
		H.apply_damage(5, BURN)

		if(lying)
			bang_effect = 4
		else
			bang_effect = 5

	else if(get_dist(H, T) <= 5)
		if(lying)
			bang_effect = 3
		else
			bang_effect = 4

	else
		bang_effect = 2


	var/flash_amount
	var/daze_amount
	var/paralyze_amount
	var/deafen_amount

	switch(bang_effect)
		if(1)
			deafen_amount = 2
		if(2)
			daze_amount = 2
			deafen_amount = 3
		if(3)
			flash_amount = 10
			daze_amount = 5
			deafen_amount = 5
		if(4)
			flash_amount = 20
			daze_amount = 5
			deafen_amount = 7
			M.ear_damage += rand(1, 5)
		if(5)
			flash_amount = 50
			daze_amount = 10
			paralyze_amount = 5
			deafen_amount = 10
			M.ear_damage += rand(1, 10)

	if(HAS_TRAIT(M, TRAIT_EAR_PROTECTION))
		daze_amount *= 0.85
		paralyze_amount *= 0.85
		deafen_amount = 0
		to_chat(M, SPAN_HELPFUL("Your gear protects you from the worst of the 'bang'."))

	M.apply_effect(daze_amount, DAZE)
	M.apply_effect(paralyze_amount, PARALYZE)

	if(flash_amount)
		M.flash_eyes(EYE_PROTECTION_FLASH, TRUE, flash_amount, /atom/movable/screen/fullscreen/flash)
	if(deafen_amount)
		M.SetEarDeafness(max(M.ear_deaf, deafen_amount))

	var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
	if(E && E.damage >= E.min_bruised_damage)
		to_chat(H, SPAN_WARNING("Your eyes start to burn badly!"))
		if (E.damage >= E.min_broken_damage)
			to_chat(H, SPAN_WARNING("You can't see anything!"))
	if(H.ear_damage >= 15)
		to_chat(H, SPAN_WARNING("Your ears start to ring badly!"))
		if(prob(H.ear_damage - 10 + 5))
			to_chat(H, SPAN_WARNING("You can't hear anything!"))
			H.sdisabilities |= DISABILITY_DEAF
	else
		if(H.ear_damage >= 5)
			to_chat(H, SPAN_WARNING("Your ears start to ring!"))

