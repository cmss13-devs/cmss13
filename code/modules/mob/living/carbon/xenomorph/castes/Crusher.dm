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
		/datum/action/xeno_action/onclick/release_haul,
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

	skull = /obj/item/skull/crusher
	pelt = /obj/item/pelt/crusher

// Refactored to handle all of crusher's interactions with object during charge.
/mob/living/carbon/xenomorph/proc/handle_collision(atom/target)
	if(!target)
		return FALSE

	//Barricade collision
	else if (istype(target, /obj/structure/barricade))
		var/obj/structure/barricade/blockade_in_path = target
		visible_message(SPAN_DANGER("[src] rams into [blockade_in_path] and skids to a halt!"), SPAN_XENOWARNING("We ram into [blockade_in_path] and skid to a halt!"))

		blockade_in_path.Collided(src)
		. =  FALSE

	else if (istype(target, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/vehicle_in_path = target
		visible_message(SPAN_DANGER("[src] rams into [vehicle_in_path] and skids to a halt!"), SPAN_XENOWARNING("We ram into [vehicle_in_path] and skid to a halt!"))

		vehicle_in_path.Collided(src)
		. = FALSE

	else if (istype(target, /obj/structure/machinery/m56d_hmg))
		var/obj/structure/machinery/m56d_hmg/weapon_in_path = target
		visible_message(SPAN_DANGER("[src] rams [weapon_in_path]!"), SPAN_XENODANGER("We ram [weapon_in_path]!"))
		playsound(loc, "punch", 25, 1)
		weapon_in_path.CrusherImpact()
		. =  FALSE

	else if (istype(target, /obj/structure/window))
		var/obj/structure/window/window_in_path = target
		if (window_in_path.unacidable)
			. = FALSE
		else
			window_in_path.deconstruct(FALSE)
			. =  TRUE // Continue throw
		playsound(loc, 'sound/effects/Glassbr1.ogg')

	else if (istype(target, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/airlock_in_path = target

		if (airlock_in_path.unacidable)
			. = FALSE
		else
			airlock_in_path.deconstruct()

	else if (istype(target, /obj/structure/grille))
		var/obj/structure/grille/grille_in_path = target
		if(grille_in_path.unacidable)
			. =  FALSE
		else
			grille_in_path.health -=  80 //Usually knocks it down.
			grille_in_path.healthcheck()
			. = TRUE

	else if (istype(target, /obj/structure/surface/table))
		var/obj/structure/surface/table/table_in_path = target
		table_in_path.Crossed(src)
		. = TRUE

	else if (istype(target, /obj/structure/machinery/defenses))
		var/obj/structure/machinery/defenses/defenses_in_path = target
		visible_message(SPAN_DANGER("[src] rams [defenses_in_path]!"), SPAN_XENODANGER("We ram [defenses_in_path]!"))

		if (!defenses_in_path.unacidable)
			playsound(loc, "punch", 25, 1)
			defenses_in_path.stat = 1
			defenses_in_path.update_icon()
			defenses_in_path.update_health(40)

		. =  FALSE

	else if (istype(target, /obj/structure/machinery/vending))
		var/obj/structure/machinery/vending/vending_in_path = target

		if (vending_in_path.unslashable)
			. = FALSE
		else
			visible_message(SPAN_DANGER("[src] smashes straight into [vending_in_path]!"), SPAN_XENODANGER("We smash straight into [vending_in_path]!"))
			playsound(loc, "punch", 25, 1)
			vending_in_path.tip_over()

			var/impact_range = 1
			var/turf/turfs_charged_at = get_diagonal_step(vending_in_path, dir)
			turfs_charged_at = get_step_away(turfs_charged_at, src)
			var/launch_speed = 2
			launch_towards(turfs_charged_at, impact_range, launch_speed)

			. =  TRUE

	else if (istype(target, /obj/structure/machinery/cm_vending))
		var/obj/structure/machinery/cm_vending/vending_in_path = target
		if (vending_in_path.unslashable)
			. = FALSE
		else
			visible_message(SPAN_DANGER("[src] smashes straight into [vending_in_path]!"), SPAN_XENODANGER("We smash straight into [vending_in_path]!"))
			playsound(loc, "punch", 25, 1)
			vending_in_path.tip_over()

			var/impact_range = 1
			var/turf/turfs_charged_at = get_diagonal_step(vending_in_path, dir)
			turfs_charged_at = get_step_away(turfs_charged_at, src)
			var/launch_speed = 2
			throw_atom(turfs_charged_at, impact_range, launch_speed)

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
			var/obj/objects_in_path = target
			if (objects_in_path.unacidable)
				. = FALSE
			else if (objects_in_path.anchored)
				visible_message(SPAN_DANGER("[src] crushes [objects_in_path]!"), SPAN_XENODANGER("We crush [objects_in_path]!"))
				if(length(objects_in_path.contents)) //Hopefully won't auto-delete things inside crushed stuff.
					var/turf/turf_for_obj = get_turf(src)
					for(var/atom/movable/stuff_to_move in turf_for_obj.contents) stuff_to_move.forceMove(turf_for_obj)

				qdel(objects_in_path)
				. = TRUE

			else
				if(objects_in_path.buckled_mob)
					objects_in_path.unbuckle()
				visible_message(SPAN_WARNING("[src] knocks [objects_in_path] aside!"), SPAN_XENOWARNING("We knock [objects_in_path] aside.")) //Canisters, crates etc. go flying.
				playsound(loc, "punch", 25, 1)

				var/impact_range = 2
				var/turf/turfs_to_get = get_diagonal_step(objects_in_path, dir)
				turfs_to_get = get_step_away(turfs_to_get, src)
				var/launch_speed = 2
				throw_atom(turfs_to_get, impact_range, launch_speed)

				. = TRUE

	if (!.)
		update_icons()

// Mutator delegate for base ravager
/datum/behavior_delegate/crusher_base
	name = "Base Crusher Behavior Delegate"

	var/aoe_slash_damage_reduction = 0.40

	/// Utilized to update charging animation.
	var/is_charging = FALSE

/datum/behavior_delegate/crusher_base/melee_attack_additional_effects_target(mob/living/carbon/target)

	if (!isxeno_human(target))
		return

	new /datum/effects/xeno_slow(target, bound_xeno, 2 SECONDS)

	var/damage = bound_xeno.melee_damage_upper * aoe_slash_damage_reduction

	var/base_cdr_amount = 1.5 SECONDS
	var/cdr_amount = base_cdr_amount
	for (var/mob/living/carbon/aoe_targets in orange(1, target))
		if (aoe_targets.stat == DEAD)
			continue

		if(!isxeno_human(aoe_targets) || bound_xeno.can_not_harm(aoe_targets))
			continue

		if (HAS_TRAIT(aoe_targets, TRAIT_NESTED))
			continue

		cdr_amount += 0.5 SECONDS

		to_chat(aoe_targets, SPAN_XENODANGER("[bound_xeno] slashes [aoe_targets]!"))
		to_chat(bound_xeno, SPAN_XENODANGER("We slash [aoe_targets]!"))

		bound_xeno.flick_attack_overlay(aoe_targets, "slash")

		aoe_targets.last_damage_data = create_cause_data(initial(bound_xeno.name), bound_xeno)
		//Logging, including anti-rulebreak logging
		if(aoe_targets.status_flags & XENO_HOST && aoe_targets.stat != DEAD)
			//Host might be rogue, needs further investigation
			aoe_targets.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [key_name(bound_xeno)] while they were infected</font>")
			bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [key_name(aoe_targets)] while they were infected</font>")
		else //Normal xenomorph friendship with benefits
			aoe_targets.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [key_name(bound_xeno)]</font>")
			bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [key_name(aoe_targets)]</font>")
		log_attack("[key_name(bound_xeno)] slashed [key_name(aoe_targets)]")
		aoe_targets.apply_armoured_damage(get_xeno_damage_slash(aoe_targets, damage), ARMOR_MELEE, BRUTE, bound_xeno.zone_selected)

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
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	for (var/mob/living/carbon/target in orange(1, get_turf(xeno)))
		if(xeno.can_not_harm(target))
			continue

		new /datum/effects/xeno_slow(target, xeno, null, null, 3.5 SECONDS)
		to_chat(target, SPAN_XENODANGER("You are slowed as the impact of [xeno] shakes the ground!"))

/datum/action/xeno_action/activable/pounce/crusher_charge/additional_effects(mob/living/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/target_to_check = target
	if (!isxeno_human(target))
		return

	if (target_to_check.stat == DEAD)
		return

	xeno.emote("roar")
	target.apply_effect(2, WEAKEN)
	xeno.visible_message(SPAN_XENODANGER("[xeno] overruns [target_to_check], brutally trampling them underfoot!"), SPAN_XENODANGER("We brutalize [target_to_check] as we crush them underfoot!"))

	target_to_check.apply_armoured_damage(get_xeno_damage_slash(target_to_check, direct_hit_damage), ARMOR_MELEE, BRUTE)
	xeno.throw_carbon(target_to_check, xeno.dir, 3)

	target_to_check.last_damage_data = create_cause_data(xeno.caste_type, xeno)
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
/mob/living/carbon/xenomorph/crusher/pounced_obj(obj/pounced_object)
	var/datum/action/xeno_action/activable/pounce/crusher_charge/crusher_charge_action = get_action(src, /datum/action/xeno_action/activable/pounce/crusher_charge)
	if (istype(crusher_charge_action) && !crusher_charge_action.action_cooldown_check() && !(pounced_object.type in crusher_charge_action.not_reducing_objects))
		crusher_charge_action.reduce_cooldown(50)

	gain_plasma(10)

	if (!handle_collision(pounced_object)) // Check old backend
		obj_launch_collision(pounced_object)

/mob/living/carbon/xenomorph/crusher/pounced_turf(turf/pounced_turf)
	pounced_turf.ex_act(EXPLOSION_THRESHOLD_VLOW, , create_cause_data(caste_type, src))
	..(pounced_turf)

/datum/action/xeno_action/onclick/crusher_stomp/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	playsound(xeno, 'sound/effects/bang.ogg', 25)
	xeno.visible_message(SPAN_XENODANGER("[xeno] smashes into the ground!"), SPAN_XENODANGER("We smash into the ground!"))
	xeno.create_stomp()


	for (var/mob/living/carbon/targets in orange(distance, xeno))

		if (targets.stat == DEAD || xeno.can_not_harm(targets))
			continue

		if(targets in get_turf(xeno))
			targets.apply_armoured_damage(get_xeno_damage_slash(targets, damage), ARMOR_MELEE, BRUTE)

		if(targets.mob_size < MOB_SIZE_BIG)
			targets.apply_effect(get_xeno_stun_duration(targets, 0.2), WEAKEN)

		new /datum/effects/xeno_slow(targets, xeno, ttl = get_xeno_stun_duration(targets, effect_duration))
		targets.apply_effect(get_xeno_stun_duration(targets, 0.2), WEAKEN)
		to_chat(targets, SPAN_XENOHIGHDANGER("You are slowed as [xeno] knocks you off balance!"))

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/crusher_stomp/charger/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/stomped_carbon

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	playsound(get_turf(xeno), 'sound/effects/bang.ogg', 25, 0)
	xeno.visible_message(SPAN_XENODANGER("[xeno] smashes into the ground!"), SPAN_XENODANGER("We smash into the ground!"))
	xeno.create_stomp()

	for (var/mob/living/carbon/target_to_stomp in get_turf(xeno)) // MOBS ONTOP
		if (target_to_stomp.stat == DEAD || xeno.can_not_harm(target_to_stomp))
			continue

		new effect_type_base(target_to_stomp, xeno, null, null, get_xeno_stun_duration(target_to_stomp, effect_duration))
		to_chat(target_to_stomp, SPAN_XENOHIGHDANGER("You are BRUTALLY crushed and stomped on by [xeno]!!!"))
		shake_camera(target_to_stomp, 10, 2)
		if(target_to_stomp.mob_size < MOB_SIZE_BIG)
			target_to_stomp.apply_effect(get_xeno_stun_duration(target_to_stomp, 0.2), WEAKEN)

		target_to_stomp.apply_armoured_damage(get_xeno_damage_slash(target_to_stomp, damage), ARMOR_MELEE, BRUTE,"chest", 3)
		target_to_stomp.apply_armoured_damage(15, BRUTE) // random
		target_to_stomp.last_damage_data = create_cause_data(xeno.caste_type, xeno)
		target_to_stomp.emote("pain")
		target_to_stomp = stomped_carbon
	for (var/mob/living/carbon/targets_to_get in orange(distance, get_turf(xeno))) // MOBS AROUND
		if (targets_to_get.stat == DEAD || xeno.can_not_harm(targets_to_get))
			continue
		if(targets_to_get.client)
			shake_camera(targets_to_get, 10, 2)
		if(stomped_carbon)
			to_chat(targets_to_get, SPAN_XENOHIGHDANGER("You watch as [stomped_carbon] gets crushed by [xeno]!"))
		to_chat(targets_to_get, SPAN_XENOHIGHDANGER("You are shaken as [xeno] quakes the earth!"))

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

	addtimer(CALLBACK(src, PROC_REF(remove_explosion_immunity)), explosion_immunity_dur)
	addtimer(CALLBACK(src, PROC_REF(remove_shield)), shield_dur)

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
