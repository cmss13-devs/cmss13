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

	behavior_delegate_type = /datum/behavior_delegate/crusher_base

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 25

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_WARRIOR)
	caste_desc = "A huge tanky xenomorph."

/mob/living/carbon/Xenomorph/Crusher
	caste_type = XENO_CASTE_CRUSHER
	name = XENO_CASTE_CRUSHER
	desc = "A huge alien with an enormous armored head crest."
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

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/pounce/crusher_charge,
		/datum/action/xeno_action/onclick/crusher_stomp,
		/datum/action/xeno_action/onclick/crusher_shield,
	)

	claw_type = CLAW_TYPE_VERY_SHARP
	mutation_icon_state = CRUSHER_NORMAL
	mutation_type = CRUSHER_NORMAL

	icon_xeno = 'icons/mob/xenos/crusher.dmi'
	icon_xenonid = 'icons/mob/xenonids/crusher.dmi'

// Refactored to handle all of crusher's interactions with object during charge.
/mob/living/carbon/Xenomorph/proc/handle_collision(atom/target)
	if(!target)
		return FALSE

	//The entire thing needs to be way less specific and way more generic, less we get to snowflake every structure in the game in this single proc
	if (istype(target, /obj/structure/barricade))
		var/obj/structure/barricade/collided_barricade = target
		visible_message(SPAN_DANGER("[src] rams into [collided_barricade] and skids to a halt!"), SPAN_XENOWARNING("You ram into [collided_barricade] and skid to a halt!"))
		collided_barricade.Collided(src)
		. =  FALSE
	else if (istype(target, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/collided_multitile = target
		visible_message(SPAN_DANGER("[src] rams into [collided_multitile] and skids to a halt!"), SPAN_XENOWARNING("You ram into [collided_multitile] and skid to a halt!"))
		collided_multitile.Collided(src)
		. = FALSE
	else if (istype(target, /obj/structure/machinery/m56d_hmg))
		var/obj/structure/machinery/m56d_hmg/collided_m56 = target
		visible_message(SPAN_DANGER("[src] rams [collided_m56]!"), SPAN_XENODANGER("You ram [collided_m56]!"))
		playsound(loc, "punch", 25, TRUE)
		collided_m56.CrusherImpact()
		. =  FALSE
	else if (istype(target, /obj/structure/window))
		var/obj/structure/window/collided_window = target
		if (collided_window.unacidable)
			. = FALSE
		else
			collided_window.deconstruct(FALSE)
			. =  TRUE // Continue throw
	else if (istype(target, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/collided_airlock = target
		if (collided_airlock.unacidable)
			. = FALSE
		else
			collided_airlock.deconstruct()
	else if (istype(target, /obj/structure/grille))
		var/obj/structure/grille/collided_grille = target
		if(collided_grille.unacidable)
			. =  FALSE
		else
			collided_grille.health -=  80 //Usually knocks it down.
			collided_grille.healthcheck()
			. = TRUE
	else if (istype(target, /obj/structure/surface/table))
		var/obj/structure/surface/table/collided_table = target
		collided_table.Crossed(src)
		. = TRUE
	else if (istype(target, /obj/structure/machinery/defenses))
		var/obj/structure/machinery/defenses/collided_defense = target
		visible_message(SPAN_DANGER("[src] rams [collided_defense]!"), SPAN_XENODANGER("You ram [collided_defense]!"))
		if (!collided_defense.unacidable)
			playsound(loc, "punch", 25, TRUE)
			collided_defense.stat = 1
			collided_defense.update_icon()
			collided_defense.update_health(40)
		. =  FALSE
	else if (istype(target, /obj/structure/machinery/vending))
		var/obj/structure/machinery/vending/collided_vending = target
		if (collided_vending.unslashable)
			. = FALSE
		else
			visible_message(SPAN_DANGER("[src] smashes straight into [collided_vending]!"), SPAN_XENODANGER("You smash straight into [collided_vending]!"))
			playsound(loc, "punch", 25, TRUE)
			collided_vending.tip_over()
			var/impact_range = 1
			var/turf/TA = get_diagonal_step(collided_vending, dir)
			TA = get_step_away(TA, src)
			var/launch_speed = 2
			launch_towards(TA, impact_range, launch_speed)
			. =  TRUE
	else if (istype(target, /obj/structure/machinery/cm_vending))
		var/obj/structure/machinery/cm_vending/collided_cm_vending = target
		if (collided_cm_vending.unslashable)
			. = FALSE
		else
			visible_message(SPAN_DANGER("[src] smashes straight into [collided_cm_vending]!"), SPAN_XENODANGER("You smash straight into [collided_cm_vending]!"))
			playsound(loc, "punch", 25, TRUE)
			collided_cm_vending.tip_over()
			var/impact_range = 1
			var/turf/TA = get_diagonal_step(collided_cm_vending, dir)
			TA = get_step_away(TA, src)
			var/launch_speed = 2
			throw_atom(TA, impact_range, launch_speed)
			. =  TRUE
	else
		if (!isobj(target))
			return
		var/obj/object_target = target
		if (object_target.unacidable)
			. = FALSE
		else if (object_target.anchored)
			visible_message(SPAN_DANGER("[src] crushes [object_target]!"), SPAN_XENODANGER("You crush [object_target]!"))
			if(object_target.contents.len) //Hopefully won't auto-delete things inside crushed stuff.
				var/turf/T = get_turf(src)
				for(var/atom/movable/S in T.contents) S.forceMove(T)
			qdel(object_target)
			. = TRUE
		else
			if(object_target.buckled_mob)
				object_target.unbuckle()
			visible_message(SPAN_WARNING("[src] knocks [object_target] aside!"), SPAN_XENOWARNING("You knock [object_target] aside.")) //Canisters, crates etc. go flying.
			playsound(loc, "punch", 25, 1)
			var/impact_range = 2
			var/turf/TA = get_diagonal_step(object_target, dir)
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

/datum/behavior_delegate/crusher_base/melee_attack_additional_effects_target(mob/living/carbon/target)

	if (!isXenoOrHuman(target))
		return

	new /datum/effects/xeno_slow(target, bound_xeno, ttl = 2 SECONDS)

	var/damage = bound_xeno.melee_damage_upper * aoe_slash_damage_reduction

	var/base_cdr_amount = 15
	var/cdr_amount = base_cdr_amount
	for (var/mob/living/carbon/collateral_carbon in orange(1, target))
		if (collateral_carbon.stat == DEAD)
			continue

		if(!isXenoOrHuman(collateral_carbon) || bound_xeno.can_not_harm(collateral_carbon))
			continue

		cdr_amount += 5

		bound_xeno.visible_message(SPAN_DANGER("[bound_xeno] slashes [collateral_carbon]!"), \
			SPAN_DANGER("You slash [collateral_carbon]!"), null, null, CHAT_TYPE_XENO_COMBAT)

		bound_xeno.flick_attack_overlay(collateral_carbon, "slash")

		collateral_carbon.last_damage_data = create_cause_data(initial(bound_xeno.name), bound_xeno)
		//Logging, including anti-rulebreak logging
		if(collateral_carbon.status_flags & XENO_HOST && collateral_carbon.stat != DEAD)
			if(HAS_TRAIT(collateral_carbon, TRAIT_NESTED)) //Host was buckled to nest while infected, this is a rule break
				collateral_carbon.attack_log += text("\[[time_stamp()]\] <font color='orange'><B>was slashed by [key_name(bound_xeno)] while they were infected and nested</B></font>")
				bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'><B>slashed [key_name(collateral_carbon)] while they were infected and nested</B></font>")
				message_staff("[key_name(bound_xeno)] slashed [key_name(collateral_carbon)] while they were infected and nested.") //This is a blatant rulebreak, so warn the admins
			else //Host might be rogue, needs further investigation
				collateral_carbon.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [key_name(bound_xeno)] while they were infected</font>")
				bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [key_name(src)] while they were infected</font>")
		else //Normal xenomorph friendship with benefits
			collateral_carbon.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [key_name(bound_xeno)]</font>")
			bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [key_name(collateral_carbon)]</font>")
		log_attack("[key_name(bound_xeno)] slashed [key_name(collateral_carbon)]")


		collateral_carbon.apply_armoured_damage(get_xeno_damage_slash(collateral_carbon, damage), ARMOR_MELEE, BRUTE, bound_xeno.zone_selected)

	var/datum/action/xeno_action/activable/pounce/crusher_charge/cAction = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/pounce/crusher_charge)
	if (!cAction.action_cooldown_check())
		cAction.reduce_cooldown(cdr_amount)

	var/datum/action/xeno_action/onclick/crusher_shield/sAction = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/crusher_shield)
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
	var/datum/action/xeno_action/activable/pounce/crusher_charge/charge_action = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/pounce/crusher_charge)
	var/charging_icon_state = "[bound_xeno.mutation_icon_state || bound_xeno.mutation_type] Crusher Charging"
	if(charge_action && (bound_xeno.throwing || charge_action.is_charging) && (charging_icon_state in icon_states(bound_xeno.icon))) //Let it build up a bit so we're not changing icons every single turf
		bound_xeno.icon_state = charging_icon_state
		return TRUE
