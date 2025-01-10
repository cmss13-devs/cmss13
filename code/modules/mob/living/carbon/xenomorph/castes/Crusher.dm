/datum/caste_datum/crusher
	caste_type = XENO_CASTE_CRUSHER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_5
	melee_damage_upper = XENO_DAMAGE_TIER_5
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_TIER_10
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_2
	heal_standing = 0.66

	available_strains = list(/datum/xeno_strain/charger)
	behavior_delegate_type = /datum/behavior_delegate/crusher_base

	minimum_evolve_time = 15 MINUTES

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 25

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_WARRIOR)
	caste_desc = "A huge tanky xenomorph."

	minimap_icon = "crusher"

/mob/living/carbon/xenomorph/crusher
	caste_type = XENO_CASTE_CRUSHER
	name = XENO_CASTE_CRUSHER
	desc = "A huge alien with an enormous armored crest."
	icon_size = 64
	icon_state = "Crusher Walking"
	plasma_types = list(PLASMA_CHITIN)
	tier = 3
	drag_delay = 6 //pulling a big dead xeno is hard

	small_explosives_stun = FALSE

	mob_size = MOB_SIZE_IMMOBILE

	pixel_x = -16
	pixel_y = -3
	old_x = -16
	old_y = -3
	base_pixel_x = 0
	base_pixel_y = -16

	rebounds = FALSE // no more fucking pinball crooshers
	organ_value = 3000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/pounce/crusher_charge,
		/datum/action/xeno_action/onclick/crusher_stomp,
		/datum/action/xeno_action/onclick/crusher_shield,
		/datum/action/xeno_action/onclick/tacmap,
	)

	claw_type = CLAW_TYPE_VERY_SHARP

	icon_xeno = 'icons/mob/xenos/castes/tier_3/crusher.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_3/crusher.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Crusher_1","Crusher_2","Crusher_3")
	weed_food_states_flipped = list("Crusher_1","Crusher_2","Crusher_3")

// Refactored to handle all of crusher's interactions with object during charge.
/mob/living/carbon/xenomorph/proc/handle_collision(atom/target)
	if(!target)
		return FALSE

	//Barricade collision
	else if (istype(target, /obj/structure/barricade))
		var/obj/structure/barricade/B = target
		visible_message(SPAN_DANGER("[src] rams into [B] and skids to a halt!"), SPAN_XENOWARNING("We ram into [B] and skid to a halt!"))

		B.Collided(src)
		. =  FALSE

	else if (istype(target, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/M = target
		visible_message(SPAN_DANGER("[src] rams into [M] and skids to a halt!"), SPAN_XENOWARNING("We ram into [M] and skid to a halt!"))

		M.Collided(src)
		. = FALSE

	else if (istype(target, /obj/structure/machinery/m56d_hmg))
		var/obj/structure/machinery/m56d_hmg/HMG = target
		visible_message(SPAN_DANGER("[src] rams [HMG]!"), SPAN_XENODANGER("We ram [HMG]!"))
		playsound(loc, "punch", 25, 1)
		HMG.CrusherImpact()
		. =  FALSE

	else if (istype(target, /obj/structure/window))
		var/obj/structure/window/W = target
		if (W.unacidable)
			. = FALSE
		else
			W.deconstruct(FALSE)
			. =  TRUE // Continue throw

	else if (istype(target, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/A = target

		if (A.unacidable)
			. = FALSE
		else
			A.deconstruct()

	else if (istype(target, /obj/structure/grille))
		var/obj/structure/grille/G = target
		if(G.unacidable)
			. =  FALSE
		else
			G.health -=  80 //Usually knocks it down.
			G.healthcheck()
			. = TRUE

	else if (istype(target, /obj/structure/surface/table))
		var/obj/structure/surface/table/T = target
		T.Crossed(src)
		. = TRUE

	else if (istype(target, /obj/structure/machinery/defenses))
		var/obj/structure/machinery/defenses/DF = target
		visible_message(SPAN_DANGER("[src] rams [DF]!"), SPAN_XENODANGER("We ram [DF]!"))

		if (!DF.unacidable)
			playsound(loc, "punch", 25, 1)
			DF.stat = 1
			DF.update_icon()
			DF.update_health(40)

		. =  FALSE

	else if (istype(target, /obj/structure/machinery/vending))
		var/obj/structure/machinery/vending/V = target

		if (V.unslashable)
			. = FALSE
		else
			visible_message(SPAN_DANGER("[src] smashes straight into [V]!"), SPAN_XENODANGER("We smash straight into [V]!"))
			playsound(loc, "punch", 25, 1)
			V.tip_over()

			var/impact_range = 1
			var/turf/TA = get_diagonal_step(V, dir)
			TA = get_step_away(TA, src)
			var/launch_speed = 2
			launch_towards(TA, impact_range, launch_speed)

			. =  TRUE

	else if (istype(target, /obj/structure/machinery/cm_vending))
		var/obj/structure/machinery/cm_vending/V = target
		if (V.unslashable)
			. = FALSE
		else
			visible_message(SPAN_DANGER("[src] smashes straight into [V]!"), SPAN_XENODANGER("We smash straight into [V]!"))
			playsound(loc, "punch", 25, 1)
			V.tip_over()

			var/impact_range = 1
			var/turf/TA = get_diagonal_step(V, dir)
			TA = get_step_away(TA, src)
			var/launch_speed = 2
			throw_atom(TA, impact_range, launch_speed)

			. =  TRUE

	else if(istype(target, /obj/structure/fence/electrified))
		var/obj/structure/fence/electrified/fence = target
		if (fence.cut)
			. = FALSE
		else
			src.visible_message(SPAN_DANGER("[src] smashes into [fence]!"))
			fence.cut_grille()
			. = TRUE

	// Anything else?
	else
		if (isobj(target))
			var/obj/O = target
			if (O.unacidable)
				. = FALSE
			else if (O.anchored)
				visible_message(SPAN_DANGER("[src] crushes [O]!"), SPAN_XENODANGER("We crush [O]!"))
				if(length(O.contents)) //Hopefully won't auto-delete things inside crushed stuff.
					var/turf/T = get_turf(src)
					for(var/atom/movable/S in T.contents) S.forceMove(T)

				qdel(O)
				. = TRUE

			else
				if(O.buckled_mob)
					O.unbuckle()
				visible_message(SPAN_WARNING("[src] knocks [O] aside!"), SPAN_XENOWARNING("We knock [O] aside.")) //Canisters, crates etc. go flying.
				playsound(loc, "punch", 25, 1)

				var/impact_range = 2
				var/turf/TA = get_diagonal_step(O, dir)
				TA = get_step_away(TA, src)
				var/launch_speed = 2
				throw_atom(TA, impact_range, launch_speed)

				. = TRUE

	if (!.)
		update_icons()

// Mutator delegate for base ravager
/datum/behavior_delegate/crusher_base
	name = "Base Crusher Behavior Delegate"

	var/aoe_slash_damage_reduction = 0.40

	/// Utilized to update charging animation.
	var/is_charging = FALSE

/datum/behavior_delegate/crusher_base/melee_attack_additional_effects_target(mob/living/carbon/A)

	if (!isxeno_human(A))
		return

	new /datum/effects/xeno_slow(A, bound_xeno, , , 20)

	var/damage = bound_xeno.melee_damage_upper * aoe_slash_damage_reduction

	var/base_cdr_amount = 15
	var/cdr_amount = base_cdr_amount
	for (var/mob/living/carbon/H in orange(1, A))
		if (H.stat == DEAD)
			continue

		if(!isxeno_human(H) || bound_xeno.can_not_harm(H))
			continue

		cdr_amount += 5

		bound_xeno.visible_message(SPAN_DANGER("[bound_xeno] slashes [H]!"), \
			SPAN_DANGER("You slash [H]!"), null, null, CHAT_TYPE_XENO_COMBAT)

		bound_xeno.flick_attack_overlay(H, "slash")

		H.last_damage_data = create_cause_data(initial(bound_xeno.name), bound_xeno)

		//Logging, including anti-rulebreak logging
		if(H.status_flags & XENO_HOST && H.stat != DEAD)
			if(HAS_TRAIT(H, TRAIT_NESTED)) //Host was buckled to nest while infected, this is a rule break
				H.attack_log += text("\[[time_stamp()]\] <font color='orange'><B>was slashed by [key_name(bound_xeno)] while they were infected and nested</B></font>")
				bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'><B>slashed [key_name(H)] while they were infected and nested</B></font>")
				message_admins("[key_name(bound_xeno)] slashed [key_name(H)] while they were infected and nested.") //This is a blatant rulebreak, so warn the admins
			else //Host might be rogue, needs further investigation
				H.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [key_name(bound_xeno)] while they were infected</font>")
				bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [key_name(src)] while they were infected</font>")
		else //Normal xenomorph friendship with benefits
			H.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [key_name(bound_xeno)]</font>")
			bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [key_name(H)]</font>")
		log_attack("[key_name(bound_xeno)] slashed [key_name(H)]")


		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE, bound_xeno.zone_selected)

	var/datum/action/xeno_action/activable/pounce/crusher_charge/cAction = get_action(bound_xeno, /datum/action/xeno_action/activable/pounce/crusher_charge)
	if (!cAction.action_cooldown_check())
		cAction.reduce_cooldown(cdr_amount)

	var/datum/action/xeno_action/onclick/crusher_shield/sAction = get_action(bound_xeno, /datum/action/xeno_action/onclick/crusher_shield)
	if (!sAction.action_cooldown_check())
		sAction.reduce_cooldown(base_cdr_amount)

/datum/behavior_delegate/crusher_base/append_to_stat()
	. = list()
	var/shield_total = 0
	for (var/datum/xeno_shield/XS in bound_xeno.xeno_shields)
		if (XS.shield_source == XENO_SHIELD_SOURCE_CRUSHER)
			shield_total += XS.amount

	. += "Shield: [shield_total]"

/datum/behavior_delegate/crusher_base/on_update_icons()
	if(bound_xeno.throwing || is_charging) //Let it build up a bit so we're not changing icons every single turf
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Crusher Charging"
		return TRUE


/datum/action/xeno_action/activable/pounce/crusher_charge/additional_effects_always()
	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	for (var/mob/living/carbon/H in orange(1, get_turf(X)))
		if(X.can_not_harm(H))
			continue

		new /datum/effects/xeno_slow(H, X, null, null, 3.5 SECONDS)
		to_chat(H, SPAN_XENODANGER("You are slowed as the impact of [X] shakes the ground!"))

/datum/action/xeno_action/activable/pounce/crusher_charge/additional_effects(mob/living/L)
	if (!isxeno_human(L))
		return

	var/mob/living/carbon/H = L
	if (H.stat == DEAD)
		return

	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	X.emote("roar")
	L.apply_effect(2, WEAKEN)
	X.visible_message(SPAN_XENODANGER("[X] overruns [H], brutally trampling them underfoot!"), SPAN_XENODANGER("We brutalize [H] as we crush them underfoot!"))

	H.apply_armoured_damage(get_xeno_damage_slash(H, direct_hit_damage), ARMOR_MELEE, BRUTE)
	X.throw_carbon(H, X.dir, 3)

	H.last_damage_data = create_cause_data(X.caste_type, X)
	return

/datum/action/xeno_action/activable/pounce/crusher_charge/pre_windup_effects()
	RegisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))

	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(!istype(xeno_owner))
		return

	var/datum/behavior_delegate/crusher_base/crusher_delegate = xeno_owner.behavior_delegate
	if(!istype(crusher_delegate))
		return

	crusher_delegate.is_charging = TRUE
	xeno_owner.update_icons()

/datum/action/xeno_action/activable/pounce/crusher_charge/post_windup_effects(interrupted)
	..()
	UnregisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE)
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(!istype(xeno_owner))
		return

	var/datum/behavior_delegate/crusher_base/crusher_delegate = xeno_owner.behavior_delegate
	if(!istype(crusher_delegate))
		return

	addtimer(CALLBACK(src, PROC_REF(undo_charging_icon)), 0.5 SECONDS) // let the icon be here for a bit, it looks cool

/datum/action/xeno_action/activable/pounce/crusher_charge/proc/undo_charging_icon()
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(!istype(xeno_owner))
		return

	var/datum/behavior_delegate/crusher_base/crusher_delegate = xeno_owner.behavior_delegate
	if(!istype(crusher_delegate))
		return

	crusher_delegate.is_charging = FALSE
	xeno_owner.update_icons()

/datum/action/xeno_action/activable/pounce/crusher_charge/proc/check_directional_armor(mob/living/carbon/xenomorph/X, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(X.dir & REVERSE_DIR(projectile_direction))
		// During the charge windup, crusher gets an extra 15 directional armor in the direction its charging
		damagedata["armor"] += frontal_armor


// This ties the pounce/throwing backend into the old collision backend
/mob/living/carbon/xenomorph/crusher/pounced_obj(obj/O)
	var/datum/action/xeno_action/activable/pounce/crusher_charge/CCA = get_action(src, /datum/action/xeno_action/activable/pounce/crusher_charge)
	if (istype(CCA) && !CCA.action_cooldown_check() && !(O.type in CCA.not_reducing_objects))
		CCA.reduce_cooldown(50)

	gain_plasma(10)

	if (!handle_collision(O)) // Check old backend
		obj_launch_collision(O)

/mob/living/carbon/xenomorph/crusher/pounced_turf(turf/T)
	T.ex_act(EXPLOSION_THRESHOLD_VLOW, , create_cause_data(caste_type, src))
	..(T)

/datum/action/xeno_action/onclick/crusher_stomp/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	playsound(get_turf(X), 'sound/effects/bang.ogg', 25, 0)
	X.visible_message(SPAN_XENODANGER("[X] smashes into the ground!"), SPAN_XENODANGER("We smash into the ground!"))
	X.create_stomp()

	for (var/mob/living/carbon/H in get_turf(X))
		if (H.stat == DEAD || X.can_not_harm(H))
			continue

		new effect_type_base(H, X, , , get_xeno_stun_duration(H, effect_duration))
		to_chat(H, SPAN_XENOHIGHDANGER("You are slowed as [X] knocks you off balance!"))

		if(H.mob_size < MOB_SIZE_BIG)
			H.apply_effect(get_xeno_stun_duration(H, 0.2), WEAKEN)

		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE)
		H.last_damage_data = create_cause_data(X.caste_type, X)

	for (var/mob/living/carbon/H in orange(distance, get_turf(X)))
		if (H.stat == DEAD || X.can_not_harm(H))
			continue

		new effect_type_base(H, X, , , get_xeno_stun_duration(H, effect_duration))
		if(H.mob_size < MOB_SIZE_BIG)
			H.apply_effect(get_xeno_stun_duration(H, 0.2), WEAKEN)
		to_chat(H, SPAN_XENOHIGHDANGER("You are slowed as [X] knocks you off balance!"))

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/crusher_stomp/charger/use_ability()
	var/mob/living/carbon/xenomorph/Xeno = owner
	var/mob/living/carbon/Targeted
	if (!istype(Xeno))
		return

	if (!action_cooldown_check())
		return

	if (!Xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	playsound(get_turf(Xeno), 'sound/effects/bang.ogg', 25, 0)
	Xeno.visible_message(SPAN_XENODANGER("[Xeno] smashes into the ground!"), SPAN_XENODANGER("We smash into the ground!"))
	Xeno.create_stomp()

	for (var/mob/living/carbon/Human in get_turf(Xeno)) // MOBS ONTOP
		if (Human.stat == DEAD || Xeno.can_not_harm(Human))
			continue

		new effect_type_base(Human, Xeno, , , get_xeno_stun_duration(Human, effect_duration))
		to_chat(Human, SPAN_XENOHIGHDANGER("You are BRUTALLY crushed and stomped on by [Xeno]!!!"))
		shake_camera(Human, 10, 2)
		if(Human.mob_size < MOB_SIZE_BIG)
			Human.apply_effect(get_xeno_stun_duration(Human, 0.2), WEAKEN)

		Human.apply_armoured_damage(get_xeno_damage_slash(Human, damage), ARMOR_MELEE, BRUTE,"chest", 3)
		Human.apply_armoured_damage(15, BRUTE) // random
		Human.last_damage_data = create_cause_data(Xeno.caste_type, Xeno)
		Human.emote("pain")
		Targeted = Human
	for (var/mob/living/carbon/Human in orange(distance, get_turf(Xeno))) // MOBS AROUND
		if (Human.stat == DEAD || Xeno.can_not_harm(Human))
			continue
		if(Human.client)
			shake_camera(Human, 10, 2)
		if(Targeted)
			to_chat(Human, SPAN_XENOHIGHDANGER("You watch as [Targeted] gets crushed by [Xeno]!"))
		to_chat(Human, SPAN_XENOHIGHDANGER("You are shaken as [Xeno] quakes the earth!"))

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/crusher_shield/use_ability(atom/Target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] hunkers down and bolsters its defenses!"), SPAN_XENOHIGHDANGER("We hunker down and bolster our defenses!"))
	button.icon_state = "template_active"

	xeno.create_crusher_shield()

	xeno.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_CRUSHER, /datum/xeno_shield/crusher)
	xeno.overlay_shields()

	xeno.explosivearmor_modifier += 1000
	xeno.recalculate_armor()

	addtimer(CALLBACK(src, PROC_REF(remove_explosion_immunity)), 25, TIMER_UNIQUE|TIMER_OVERRIDE)
	addtimer(CALLBACK(src, PROC_REF(remove_shield)), 70, TIMER_UNIQUE|TIMER_OVERRIDE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/crusher_shield/proc/remove_explosion_immunity()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	xeno.explosivearmor_modifier -= 1000
	xeno.recalculate_armor()
	to_chat(xeno, SPAN_XENODANGER("Our immunity to explosion damage ends!"))

/datum/action/xeno_action/onclick/crusher_shield/proc/remove_shield()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	var/datum/xeno_shield/found
	for (var/datum/xeno_shield/shield in xeno.xeno_shields)
		if (shield.shield_source == XENO_SHIELD_SOURCE_CRUSHER)
			found = shield
			break

	if (istype(found))
		found.on_removal()
		qdel(found)
		to_chat(xeno, SPAN_XENOHIGHDANGER("We feel our enhanced shield end!"))
		button.icon_state = "template"

	xeno.overlay_shields()

/datum/action/xeno_action/onclick/charger_charge/use_ability(atom/Target)
	var/mob/living/carbon/xenomorph/Xeno = owner

	activated = !activated
	var/will_charge = "[activated ? "now" : "no longer"]"
	to_chat(Xeno, SPAN_XENONOTICE("We will [will_charge] charge when moving."))
	if(activated)
		RegisterSignal(Xeno, COMSIG_MOVABLE_MOVED, PROC_REF(handle_movement))
		RegisterSignal(Xeno, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(handle_position_change))
		RegisterSignal(Xeno, COMSIG_ATOM_DIR_CHANGE, PROC_REF(handle_dir_change))
		RegisterSignal(Xeno, COMSIG_XENO_RECALCULATE_SPEED, PROC_REF(update_speed))
		RegisterSignal(Xeno, COMSIG_XENO_STOP_MOMENTUM, PROC_REF(stop_momentum))
		RegisterSignal(Xeno, COMSIG_MOVABLE_ENTERED_RIVER, PROC_REF(handle_river))
		RegisterSignal(Xeno, COMSIG_LIVING_PRE_COLLIDE, PROC_REF(handle_collision))
		RegisterSignal(Xeno, COMSIG_XENO_START_CHARGING, PROC_REF(start_charging))
		button.icon_state = "template_active"
	else
		stop_momentum()
		UnregisterSignal(Xeno, list(
			COMSIG_MOVABLE_MOVED,
			COMSIG_LIVING_SET_BODY_POSITION,
			COMSIG_ATOM_DIR_CHANGE,
			COMSIG_XENO_RECALCULATE_SPEED,
			COMSIG_MOVABLE_ENTERED_RIVER,
			COMSIG_LIVING_PRE_COLLIDE,
			COMSIG_XENO_STOP_MOMENTUM,
			COMSIG_XENO_START_CHARGING,
		))
		button.icon_state = "template"
	return ..()

/datum/action/xeno_action/activable/tumble/use_ability(atom/Target)
	if(!action_cooldown_check())
		return
	var/mob/living/carbon/xenomorph/Xeno = owner
	if (!Xeno.check_state())
		return
	if(Xeno.plasma_stored <= plasma_cost)
		return
	var/target_dist = get_dist(Xeno, Target)
	var/dir_between = get_dir(Xeno, Target)
	var/target_dir
	for(var/perpen_dir in get_perpen_dir(Xeno.dir))
		if(dir_between & perpen_dir)
			target_dir = perpen_dir
			break

	if(!target_dir)
		return

	Xeno.visible_message(SPAN_XENOWARNING("[Xeno] tumbles over to the side!"), SPAN_XENOHIGHDANGER("We tumble over to the side!"))
	Xeno.spin(5,1) // note: This spins the sprite and DOES NOT affect directional armor
	var/start_charging = HAS_TRAIT(Xeno, TRAIT_CHARGING)
	SEND_SIGNAL(Xeno, COMSIG_XENO_STOP_MOMENTUM)
	Xeno.flags_atom |= DIRLOCK
	playsound(Xeno,"alien_tail_swipe", 50, 1)

	Xeno.use_plasma(plasma_cost)

	var/target = get_step(get_step(Xeno, target_dir), target_dir)
	var/list/collision_callbacks = list(/mob/living/carbon/human = CALLBACK(src, PROC_REF(handle_mob_collision)))
	var/list/end_throw_callbacks = list(CALLBACK(src, PROC_REF(on_end_throw), start_charging))
	Xeno.throw_atom(target, target_dist, SPEED_FAST, launch_type = LOW_LAUNCH, pass_flags = PASS_CRUSHER_CHARGE, end_throw_callbacks = end_throw_callbacks, collision_callbacks = collision_callbacks)

	apply_cooldown()
	return ..()
