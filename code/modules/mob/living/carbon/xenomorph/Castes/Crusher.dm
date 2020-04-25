/datum/caste_datum/crusher
	caste_name = "Crusher"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_MEDIUM
	melee_damage_upper = XENO_DAMAGE_MEDIUM
	max_health = XENO_HEALTH_HIGHMEDIUM
	plasma_gain = XENO_PLASMA_GAIN_HIGHMED
	plasma_max = XENO_PLASMA_MEDIUM
	xeno_explosion_resistance = XENO_GIGA_EXPLOSIVE_ARMOR
	armor_deflection = XENO_HEAVY_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_CRUSHER
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_MEDIUM
	speed_mod = XENO_SPEED_MOD_LARGE

	behavior_delegate_type = /datum/behavior_delegate/crusher_base

	tackle_chance = 15
	evolution_allowed = FALSE
	deevolves_to = "Warrior"
	caste_desc = "A huge tanky xenomorph."

/datum/caste_datum/crusher/mature
	upgrade_name = "Mature"
	caste_desc = "A huge tanky xenomorph. It looks a little more dangerous."
	upgrade = 1
	tackle_chance = 20

/datum/caste_datum/crusher/elder
	upgrade_name = "Elder"
	caste_desc = "A huge tanky xenomorph. It looks pretty strong."
	upgrade = 2
	tackle_chance = 25

/datum/caste_datum/crusher/ancient
	upgrade_name = "Ancient"
	caste_desc = "It always has the right of way."
	upgrade = 3
	tackle_chance = 28

/datum/caste_datum/crusher/primordial
	upgrade_name = "Primordial"
	caste_desc = "This thing could cause a tsunami just by walking. It's a literal freight train."
	upgrade = 4
	melee_damage_lower = 35
	melee_damage_upper = 45
	tackle_chance = 30
	plasma_gain = 0.080
	plasma_max = 600
	armor_deflection = 90
	max_health = XENO_UNIVERSAL_HPMULT * 400
	speed = -0.5

/mob/living/carbon/Xenomorph/Crusher
	caste_name = "Crusher"
	name = "Crusher"
	desc = "A huge alien with an enormous armored head crest."
	icon = 'icons/mob/xenos/2x2_Xenos.dmi'
	icon_size = 64
	icon_state = "Crusher Walking"
	plasma_types = list(PLASMA_CHITIN)
	tier = 3
	drag_delay = 6 //pulling a big dead xeno is hard

	mob_size = MOB_SIZE_BIG

	pixel_x = -16
	pixel_y = -3
	old_x = -16
	old_y = -3

	rebounds = FALSE // no more fucking pinball crooshers

	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/pounce/crusher_charge,
		/datum/action/xeno_action/onclick/crusher_stomp,
		/datum/action/xeno_action/onclick/crusher_shield
	)

	mutation_type = CRUSHER_NORMAL

// Refactored to handle all of crusher's interactions with object during charge.
/mob/living/carbon/Xenomorph/proc/handle_collision(atom/target)
	if(!target)
		return FALSE

	//Barricade collision
	else if (istype(target, /obj/structure/barricade))
		var/obj/structure/barricade/B = target
		visible_message(SPAN_DANGER("[src] rams into [B] and skids to a halt!"), SPAN_XENOWARNING("You ram into [B] and skid to a halt!"))
		
		flags_pass = NO_FLAGS
		B.Collided(src)
		. =  FALSE

	else if (istype(target, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/M = target
		visible_message(SPAN_DANGER("[src] rams into [M] and skids to a halt!"), SPAN_XENOWARNING("You ram into [M] and skid to a halt!"))
		flags_pass = NO_FLAGS
		M.Collided(src)
		. = FALSE

	else if (istype(target, /obj/structure/machinery/m56d_hmg))
		var/obj/structure/machinery/m56d_hmg/HMG = target
		visible_message(SPAN_DANGER("[src] rams [HMG]!"), SPAN_XENODANGER("You ram [HMG]!"))
		playsound(loc, "punch", 25, 1)
		HMG.Collided()
		. =  FALSE

	else if (istype(target, /obj/structure/window))	
		var/obj/structure/window/W = target
		if (W.unacidable)
			. = FALSE
		else
			W.shatter_window(1)
			. =  TRUE // Continue throw

	else if (istype(target, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/A = target

		if (A.unacidable)
			. = FALSE
		else
			A.destroy_airlock()

	else if (istype(target, /obj/structure/grille))
		var/obj/structure/grille/G = target
		if(G.unacidable)
			. =  FALSE
		else 
			G.health -=  80 //Usually knocks it down.
			G.healthcheck()
			. = TRUE

	else if (istype(target, /obj/structure/table))
		var/obj/structure/table/T = target
		T.Crossed(src)
		. = TRUE

	else if (istype(target, /obj/structure/machinery/defenses))
		var/obj/structure/machinery/defenses/DF = target
		visible_message(SPAN_DANGER("[src] rams [DF]!"), SPAN_XENODANGER("You ram [DF]!"))
		
		if (!DF.unacidable)
			playsound(loc, "punch", 25, 1)
			DF.stat = 1
			DF.update_icon()
			DF.update_health(40)
		
		. =  FALSE

	else if (istype(target, /obj/structure/machinery/vending))
		var/obj/structure/machinery/vending/V = target

		if (unacidable)
			. = FALSE
		else
			visible_message(SPAN_DANGER("[src] smashes straight into [V]!"), SPAN_XENODANGER("You smash straight into [V]!"))
			playsound(loc, "punch", 25, 1)
			V.tip_over()

			var/impact_range = 1
			var/turf/TA = get_diagonal_step(V, dir)
			TA = get_step_away(TA, src)
			var/launch_speed = 2
			launch_towards(TA, impact_range, launch_speed)

			. =  TRUE

	// Anything else?
	else 
		if (isobj(target))
			var/obj/O = target
			if (O.unacidable)
				. = FALSE
			else if (O.anchored)
				visible_message(SPAN_DANGER("[src] crushes [O]!"), SPAN_XENODANGER("You crush [O]!"))
				if(O.contents.len) //Hopefully won't auto-delete things inside crushed stuff.
					var/turf/T = get_turf(src)
					for(var/atom/movable/S in T.contents) S.loc = T
			
				qdel(O)
				. = TRUE 
			
			else 
				if(O.buckled_mob)
					O.unbuckle()
				visible_message(SPAN_WARNING("[src] knocks [O] aside!"), SPAN_XENOWARNING("You knock [O] aside.")) //Canisters, crates etc. go flying.
				playsound(loc, "punch", 25, 1)
			
				var/impact_range = 2
				var/turf/TA = get_diagonal_step(O, dir)
				TA = get_step_away(TA, src)
				var/launch_speed = 2
				launch_towards(TA, impact_range, launch_speed)

				. = TRUE

	if (!.)
		update_icons()

/mob/living/carbon/Xenomorph/Crusher/update_icons()
	if(stat == DEAD)
		icon_state = "Crusher Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "Crusher Sleeping"
		else
			icon_state = "Crusher Knocked Down"
	else
		if(m_intent == MOVE_INTENT_RUN)
			if(throwing) //Let it build up a bit so we're not changing icons every single turf
				icon_state = "Crusher Charging"
			else
				icon_state = "Crusher Running"

		else
			icon_state = "Crusher Walking"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.

// Mutator delegate for base ravager
/datum/behavior_delegate/crusher_base
	name = "Base Crusher Behavior Delegate"

	var/aoe_slash_damage_reduction = 0.66

/datum/behavior_delegate/crusher_base/melee_attack_additional_effects_target(atom/A)

	if (!ishuman(A))
		return

	new /datum/effects/xeno_slow(A, bound_xeno, , , 25)

	var/damage = bound_xeno.melee_damage_upper * aoe_slash_damage_reduction

	for (var/mob/living/carbon/human/H in orange(1, A))
		if (H.stat == DEAD)
			continue

		bound_xeno.visible_message(SPAN_DANGER("[bound_xeno] slashes [H]!"), \
			SPAN_DANGER("You slash [H]!"), null, null, CHAT_TYPE_XENO_COMBAT)

		bound_xeno.flick_attack_overlay(H, "slash")
		
		var/obj/limb/affecting
		affecting = H.get_limb(ran_zone(bound_xeno.zone_selected, 70))
		if(!affecting) //No organ, just get a random one
			affecting = H.get_limb(ran_zone(null, 0))
		if(!affecting) //Still nothing??
			affecting = H.get_limb("chest") //Gotta have a torso?!

		var/armor_block = H.getarmor(affecting, ARMOR_MELEE)

		H.last_damage_source = initial(bound_xeno.name)
		H.last_damage_mob = bound_xeno

		//Logging, including anti-rulebreak logging
		if(H.status_flags & XENO_HOST && H.stat != DEAD)
			if(istype(H.buckled, /obj/structure/bed/nest)) //Host was buckled to nest while infected, this is a rule break
				H.attack_log += text("\[[time_stamp()]\] <font color='orange'><B>was slashed by [key_name(bound_xeno)] while they were infected and nested</B></font>")
				bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'><B>slashed [key_name(H)] while they were infected and nested</B></font>")
				msg_admin_ff("[key_name(bound_xeno)] slashed [key_name(H)] while they were infected and nested.") //This is a blatant rulebreak, so warn the admins
			else //Host might be rogue, needs further investigation
				H.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [key_name(bound_xeno)] while they were infected</font>")
				bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [key_name(src)] while they were infected</font>")
		else //Normal xenomorph friendship with benefits
			H.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [key_name(bound_xeno)]</font>")
			bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [key_name(H)]</font>")
		log_attack("[key_name(bound_xeno)] slashed [key_name(H)]")

		var/n_damage = armor_damage_reduction(config.marine_melee, damage, armor_block)

		//nice messages so people know that armor works
		if(n_damage <= 0.34*damage)
			H.show_message(SPAN_WARNING("Your armor absorbs the blow!"), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)
		else if(n_damage <= 0.67*damage)
			H.show_message(SPAN_WARNING("Your armor softens the blow!"), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)

		H.apply_damage(n_damage, BRUTE, affecting, 0, sharp = 1, edge = 1) //This should slicey dicey
		new /datum/effects/xeno_slow(H, bound_xeno, , , 25)

/datum/behavior_delegate/crusher_base/append_to_stat()
	var/shield_total = 0
	for (var/datum/xeno_shield/XS in bound_xeno.xeno_shields)
		if (XS.shield_source == XENO_SHIELD_SOURCE_CRUSHER) 
			shield_total += XS.amount

	stat("Shield:", "[shield_total]")