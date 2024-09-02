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

	icon_xeno = 'icons/mob/xenos/crusher.dmi'
	icon_xenonid = 'icons/mob/xenonids/crusher.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Crusher_1","Crusher_2","Crusher_3")
	weed_food_states_flipped = list("Crusher_1","Crusher_2","Crusher_3")

// TODO: Replace Collided calls with collision interceptors using signals
/atom/proc/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	return

/obj/structure/barricade/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_DEFAULT_BEHAVIOR
	crusher.visible_message(SPAN_DANGER("[crusher] rams into [src] and skids to a halt!"), SPAN_XENOWARNING("We ram into [src] and skid to a halt!"))

	if(crusher_resistant)
		visible_message(SPAN_DANGER("[crusher] smashes into [src]!"))
		take_damage(150)
		playsound(src, barricade_hitsound, 25, TRUE)

	else if(!crusher.stat)
		visible_message(SPAN_DANGER("[crusher] smashes through [src]!"))
		deconstruct(FALSE)
		playsound(src, barricade_hitsound, 25, TRUE)

	Collided(crusher)

/obj/vehicle/multitile/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_DEFAULT_BEHAVIOR
	crusher.visible_message(SPAN_DANGER("[crusher] rams into [src] and skids to a halt!"), SPAN_XENOWARNING("We ram into [src] and skid to a halt!"))

	Collided(crusher)

	var/do_move = TRUE
	if(health > 0)
		take_damage_type(100, "blunt", crusher)
		visible_message(SPAN_DANGER("\The [crusher] rams \the [src]!"))
		for(var/obj/item/hardpoint/locomotion/Loco in hardpoints)
			if(Loco.health > 0)
				do_move = FALSE
				break
	if(do_move)
		try_move(crusher.dir, force=TRUE)
		visible_message(SPAN_DANGER("The sheer force of the impact makes \the [src] slide back!"))
	log_attack("\The [src] was rammed [do_move ? "and pushed " : " "]by [key_name(crusher)].")
	playsound(loc, 'sound/effects/metal_crash.ogg', 35)
	interior_crash_effect()

/obj/structure/machinery/m56d_hmg/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_DEFAULT_BEHAVIOR
	crusher.visible_message(SPAN_DANGER("[crusher] rams [src]!"), SPAN_XENODANGER("We ram [src]!"))
	playsound(crusher.loc, "punch", 25, 1)
	CrusherImpact()

/obj/structure/window/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_CONTINUE_THROW
	if (unacidable)
		return CRUSHER_CHARGED_DEFAULT_BEHAVIOR

	deconstruct(FALSE)

/obj/structure/machinery/door/airlock/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_DEFAULT_BEHAVIOR
	if (unacidable)
		return

	deconstruct()

/obj/structure/grille/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_CONTINUE_THROW
	if(unacidable)
		return CRUSHER_CHARGED_DEFAULT_BEHAVIOR

	health -=  80 //Usually knocks it down.
	healthcheck()

/obj/structure/surface/table/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_CONTINUE_THROW
	Crossed(src)

/obj/structure/machinery/defenses/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_DEFAULT_BEHAVIOR
	crusher.visible_message(SPAN_DANGER("[crusher] rams [src]!"), SPAN_XENODANGER("We ram [src]!"))

	if (unacidable)
		return

	playsound(crusher.loc, "punch", 25, 1)
	stat = 1
	update_icon()
	update_health(40)

/obj/structure/machinery/vending/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_CONTINUE_THROW
	if (unslashable)
		return CRUSHER_CHARGED_DEFAULT_BEHAVIOR

	crusher.visible_message(SPAN_DANGER("[crusher] smashes straight into [src]!"), SPAN_XENODANGER("We smash straight into [crusher]!"))
	playsound(crusher.loc, "punch", 25, 1)
	tip_over()

	var/impact_range = 1
	var/turf/TA = get_diagonal_step(src, dir)
	TA = get_step_away(TA, crusher)
	var/launch_speed = 2
	crusher.launch_towards(TA, impact_range, launch_speed)

/obj/structure/machinery/cm_vending/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_CONTINUE_THROW
	if (unslashable)
		return CRUSHER_CHARGED_DEFAULT_BEHAVIOR

	crusher.visible_message(SPAN_DANGER("[crusher] smashes straight into [src]!"), SPAN_XENODANGER("We smash straight into [src]!"))
	playsound(crusher.loc, "punch", 25, 1)
	tip_over()

	var/impact_range = 1
	var/turf/TA = get_diagonal_step(src, dir)
	TA = get_step_away(TA, crusher)
	var/launch_speed = 2
	crusher.throw_atom(TA, impact_range, launch_speed)

/obj/handle_crusher_charge(mob/living/carbon/xenomorph/crusher/crusher)
	. = CRUSHER_CHARGED_CONTINUE_THROW
	if (unacidable)
		return CRUSHER_CHARGED_DEFAULT_BEHAVIOR

	if (anchored)
		crusher.visible_message(SPAN_DANGER("[crusher] crushes [src]!"), SPAN_XENODANGER("We crush [src]!"))
		if(length(contents))
			for(var/atom/movable/S in contents) S.forceMove(crusher.loc)

		qdel(src)
		return

	if(buckled_mob)
		unbuckle()
	crusher.visible_message(SPAN_WARNING("[crusher] knocks [src] aside!"), SPAN_XENOWARNING("We knock [src] aside.")) //Canisters, crates etc. go flying.
	playsound(crusher.loc, "punch", 25, 1)

	var/impact_range = 2
	var/turf/TA = get_diagonal_step(src, dir)
	TA = get_step_away(TA, crusher)
	var/launch_speed = 2
	crusher.throw_atom(TA, impact_range, launch_speed)

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
	if(HAS_TRAIT(bound_xeno, TRAIT_LAUNCHED) || is_charging) //Let it build up a bit so we're not changing icons every single turf
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Crusher Charging"
		return TRUE
