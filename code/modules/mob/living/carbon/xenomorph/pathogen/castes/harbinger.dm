/// The minimum number of people to hit on the first spin to trigger the extra spins.
#define PATHOGEN_CYCLONE_MIN_HITS 2

/datum/caste_datum/pathogen/harbinger
	caste_type = PATHOGEN_CREATURE_HARBINGER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_6 //Stats TBC
	melee_damage_upper = XENO_DAMAGE_TIER_7
	melee_vehicle_damage = XENO_DAMAGE_TIER_7
	max_health = XENO_HEALTH_TIER_12
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_8
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_5

	attack_delay = 0

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/harbinger

	deevolves_to = list(PATHOGEN_CREATURE_BLIGHT)
	caste_desc = "Death is no sanctuary."
	evolves_to = list()

	heal_resting = 1.6
	is_intelligent = TRUE

	minimap_icon = "harbinger"
	evolution_allowed = FALSE
	royal_caste = TRUE

/mob/living/carbon/xenomorph/harbinger
	caste_type = PATHOGEN_CREATURE_HARBINGER
	name = PATHOGEN_CREATURE_HARBINGER
	desc = "Doom is walking."
	icon_size = 48
	icon_state = "Harbinger Walking"
	plasma_types = list()
	pixel_x = -16
	old_x = -16
	tier = 3
	organ_value = 8000
	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough/pathogen,
		/datum/action/xeno_action/onclick/xeno_resting/pathogen,
		/datum/action/xeno_action/onclick/release_haul/pathogen,
		/datum/action/xeno_action/watch_xeno/pathogen,
		/datum/action/xeno_action/activable/tail_stab/pathogen/tier3,
		/datum/action/xeno_action/activable/pounce/charge, // Macro 1
		/datum/action/xeno_action/activable/prae_impale/venator, //Macro 2
		/datum/action/xeno_action/activable/cyclone, // Macro 3
		/datum/action/xeno_action/activable/mycotoxin, // Macro 4
		/datum/action/xeno_action/onclick/blight_slash, //Macro 5
	)
	claw_type = CLAW_TYPE_VERY_SHARP

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 45

	icon_xeno = 'icons/mob/pathogen/harbinger.dmi'
	icon_xenonid = 'icons/mob/pathogen/harbinger.dmi'

	skull = /obj/item/skull/pathogen_none
	pelt = /obj/item/pelt/pathogen_harbinger

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_48x48.dmi'
	weed_food_states = list("Harbinger_1","Harbinger_2","Harbinger_3")
	weed_food_states_flipped = list("Harbinger_1","Harbinger_2","Harbinger_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"

	mob_size = MOB_SIZE_BIG
	acid_blood_damage = 0
	bubble_icon = "pathogenroyal"
	fire_immunity = FIRE_VULNERABILITY



/datum/behavior_delegate/pathogen_base/harbinger
	name = "Base Harbinger Behavior Delegate"





/datum/action/xeno_action/activable/cyclone
	name = "Cyclone"
	button_icon_state = "template_pathogen"
	icon_file = 'icons/mob/hud/actions_pathogen.dmi'
	action_icon_state = "cyclone"
	macro_path = /datum/action/xeno_action/verb/verb_cyclone
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 0
	xeno_cooldown = 23 SECONDS

	// Config values
	var/activation_delay = 2 SECONDS

	var/armor_pen = 20
	var/base_damage = 25
	var/base_range = 2
	var/cycles = 4
	var/cycle_damage = 15
	var/cycle_delay = 3 SECONDS
	/// Less than the delay between cycles, the longer one stands spinning the less safe it is.
	var/cycle_shield_duration = 2 SECONDS
	var/cycle_shield_value = 50

/datum/action/xeno_action/activable/cyclone/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/range = base_range

	if(!action_cooldown_check() || xeno.action_busy)
		return

	if(!xeno.check_state())
		return

	apply_cooldown()

	// To-Do, change message.
	xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] begins digging in for a massive strike!"), SPAN_XENOHIGHDANGER("We begin digging in for a massive strike!"))

	ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Cyclone"))
	xeno.anchored = TRUE

	var/found_target = 0
	if(do_after(xeno, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		xeno.emote("roar")
		xeno.spin_circle()

		for(var/mob/living/carbon/targets_to_hit in orange(xeno, base_range))
			if(!isxeno_human(targets_to_hit) || xeno.can_not_harm(targets_to_hit))
				continue

			if(targets_to_hit.stat == DEAD)
				continue

			if(HAS_TRAIT(targets_to_hit, TRAIT_NESTED))
				continue

			if(!check_clear_path_to_target(xeno, targets_to_hit))
				continue

			found_target++
			xeno.visible_message(SPAN_XENODANGER("[xeno] stabs [targets_to_hit]!"), SPAN_XENODANGER("We stab [targets_to_hit]!"))
			targets_to_hit.apply_effect(get_xeno_stun_duration(targets_to_hit, 1), WEAKEN)
			playsound(get_turf(targets_to_hit), 'sound/weapons/alien_tail_attack.ogg', 30, TRUE)

			targets_to_hit.apply_armoured_damage(get_xeno_damage_slash(targets_to_hit, base_damage), ARMOR_MELEE, BRUTE, "chest", armor_pen)


	if(found_target < PATHOGEN_CYCLONE_MIN_HITS)
		REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Cyclone"))
		xeno.anchored = FALSE
		return..()

	var/total_shield_value = cycle_shield_value * cycles
	var/total_shield_duration = (cycle_shield_duration * cycles) - min(0.5 SECONDS * cycles, 2 SECONDS)
	xeno.add_xeno_shield(total_shield_value, XENO_SHIELD_SOURCE_CYCLONE, /datum/xeno_shield/harbinger)
	xeno.overlay_shields()
	addtimer(CALLBACK(src, PROC_REF(remove_shield)), total_shield_duration)

	REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Cyclone"))
	xeno.anchored = FALSE

	var/current_cycle = 0
	while(current_cycle < cycles)
		var/cycle_delay_modifier = 0.5 SECONDS * current_cycle
		current_cycle++

		var/current_cycle_delay = max(1.5 SECONDS, cycle_delay - cycle_delay_modifier)
		if(!do_after(xeno, current_cycle_delay, INTERRUPT_INCAPACITATED, BUSY_ICON_HOSTILE))
			break

		xeno.spin_circle(6)
		xeno.emote("growl")

		var/cycle_range = min(range, 4)
		for(var/mob/living/carbon/targets_to_hit in orange(xeno, cycle_range))
			if(!isxeno_human(targets_to_hit) || xeno.can_not_harm(targets_to_hit))
				continue

			if(targets_to_hit.stat == DEAD)
				continue

			if(HAS_TRAIT(targets_to_hit, TRAIT_NESTED))
				continue

			if(!check_clear_path_to_target(xeno, targets_to_hit))
				continue

			xeno.visible_message(SPAN_XENODANGER("[xeno] lashes out at [targets_to_hit]!"), SPAN_XENODANGER("We lash out at [targets_to_hit]!"))
			targets_to_hit.apply_effect(get_xeno_stun_duration(targets_to_hit, 1), SLOW)
			playsound(get_turf(targets_to_hit), "alien_claw_flesh", 30, 1)

			targets_to_hit.apply_armoured_damage(get_xeno_damage_slash(targets_to_hit, cycle_damage), ARMOR_MELEE, BRUTE, "chest", armor_pen / 2)
		range++

	return ..()



/datum/action/xeno_action/activable/cyclone/proc/remove_shield()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	var/datum/xeno_shield/found
	for(var/datum/xeno_shield/shield in xeno.xeno_shields)
		if(shield.shield_source == XENO_SHIELD_SOURCE_CYCLONE)
			found = shield
			break

	if(istype(found))
		found.on_removal()
		qdel(found)
		to_chat(xeno, SPAN_XENOHIGHDANGER("We feel our shield end!"))
		button.icon_state = "template_xeno"

	xeno.overlay_shields()

/datum/action/xeno_action/verb/verb_cyclone()
	set category = "Alien"
	set name = "Cyclone"
	set hidden = TRUE
	var/action_name = "Cyclone"
	handle_xeno_macro(src, action_name)



/datum/action/xeno_action/activable/mycotoxin
	name = "Mycotoxin Injection (100)"
	button_icon_state = "template_pathogen"
	icon_file = 'icons/mob/hud/actions_pathogen.dmi'
	action_icon_state = "inject_walker"
	action_type = XENO_ACTION_CLICK
	charge_time = 2 SECONDS
	xeno_cooldown = 3 MINUTES
	ability_primacy = XENO_PRIMARY_ACTION_4
	var/stab_range = 2
	plasma_cost = 100
	var/matriarch_stab = FALSE

/datum/action/xeno_action/activable/mycotoxin/matriarch
	name = "Mycotoxin Injection (150)"
	plasma_cost = 150
	matriarch_stab = TRUE
	xeno_cooldown = 5 MINUTES
	stab_range = 3
	ability_primacy = XENO_NOT_PRIMARY_ACTION

/datum/action/xeno_action/activable/mycotoxin/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/stabbing_xeno = owner
	if(HAS_TRAIT(targetted_atom, TRAIT_HAULED))
		return

	if(HAS_TRAIT(stabbing_xeno, TRAIT_ABILITY_BURROWED) || stabbing_xeno.is_ventcrawling)
		to_chat(stabbing_xeno, SPAN_XENOWARNING("We must be above ground to do this."))
		return

	if(!stabbing_xeno.check_state() || stabbing_xeno.cannot_slash)
		return FALSE

	if(!action_cooldown_check())
		return FALSE

	if (world.time <= stabbing_xeno.next_move)
		return FALSE

	if(stabbing_xeno.z != targetted_atom.z)
		return

	var/distance = get_dist(stabbing_xeno, targetted_atom)
	if(distance > stab_range)
		return FALSE

	var/list/turf/path = get_line(stabbing_xeno, targetted_atom, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
			return FALSE
		for(var/obj/path_contents in path_turf.contents)
			if(path_contents != targetted_atom && path_contents.density && !path_contents.throwpass)
				to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
				return FALSE

		var/atom/barrier = path_turf.handle_barriers(stabbing_xeno, null, (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			var/tail_stab_cooldown_multiplier = barrier.handle_tail_stab(stabbing_xeno)
			if(!tail_stab_cooldown_multiplier)
				to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
			else
				apply_cooldown(cooldown_modifier = tail_stab_cooldown_multiplier)
				xeno_attack_delay(stabbing_xeno)
			return FALSE

	var/tail_stab_cooldown_multiplier = targetted_atom.handle_tail_stab(stabbing_xeno)
	if(tail_stab_cooldown_multiplier)
		stabbing_xeno.animation_attack_on(targetted_atom)
		apply_cooldown(cooldown_modifier = tail_stab_cooldown_multiplier)
		xeno_attack_delay(stabbing_xeno)
		return ..()

	if(!ishuman(targetted_atom))
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] swipes their tail through the air!"), SPAN_XENOWARNING("We swipe our tail through the air!"))
		apply_cooldown(cooldown_modifier = 0.1)
		xeno_attack_delay(stabbing_xeno)
		playsound(stabbing_xeno, "alien_tail_swipe", 50, TRUE)
		return FALSE

	if(stabbing_xeno.can_not_harm(targetted_atom))
		return FALSE

	if(issynth(targetted_atom))
		return FALSE

	var/mob/living/carbon/human/target = targetted_atom
	var/mostly_dead = FALSE
	if(!target.is_revivable(TRUE))
		to_chat(stabbing_xeno, SPAN_PATHOGEN_LEADER("You cannot inject this target with mycotoxin, their body is too degraded!"))
		return FALSE

	if(target.stat & DEAD)
		if(world.time > target.timeofdeath + target.revive_grace_period - 1 MINUTES)
			mostly_dead = TRUE


	if(!matriarch_stab && !mostly_dead)
		to_chat(stabbing_xeno, SPAN_PATHOGEN_LEADER("You cannot inject this target with mycotoxin, their body still functions!"))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_NESTED))
		return FALSE

	var/obj/limb/limb = target.get_limb(check_zone(stabbing_xeno.zone_selected))
	if (ishuman(target) && (!limb || (limb.status & LIMB_DESTROYED)))
		to_chat(stabbing_xeno, (SPAN_WARNING("What [limb.display_name]?")))
		return FALSE

	if(!check_and_use_plasma_owner())
		return FALSE

	var/result = ability_act(stabbing_xeno, target, limb)

	apply_cooldown()
	xeno_attack_delay(stabbing_xeno)
	..()
	return result

/datum/action/xeno_action/activable/mycotoxin/proc/ability_act(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/human/target, obj/limb/limb)

	target.last_damage_data = create_cause_data(initial(stabbing_xeno.caste_type), stabbing_xeno)

	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = stabbing_xeno.dir
	/// Direction var to make the tail stab look cool and immersive.
	var/stab_direction = turn(get_dir(stabbing_xeno, target), 180)

	stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] skewers [target] through the [limb ? limb.display_name : "chest"] with its razor sharp tail!"), SPAN_XENOWARNING("We skewer [target] through the [limb? limb.display_name : "chest"] with our razor sharp tail!"))
	playsound(target, "alien_bite", 50, TRUE)
	// The xeno flips around for a second to impale the target with their tail. These look awsome.
	stab_direction = turn(get_dir(stabbing_xeno, target), 180)
	log_attack("[key_name(stabbing_xeno)] injected [key_name(target)] with mycotoxin at [get_area_name(stabbing_xeno)]")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>was injected with mycotoxin by [key_name(stabbing_xeno)]</font>")
	stabbing_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>injected [key_name(target)] with mycotoxin</font>")

	if(last_dir != stab_direction)
		stabbing_xeno.setDir(stab_direction)
		stabbing_xeno.emote("tail")
		/// Ditto.
		var/new_dir = stabbing_xeno.dir
		addtimer(CALLBACK(src, PROC_REF(reset_direction), stabbing_xeno, last_dir, new_dir), 0.5 SECONDS)

	stabbing_xeno.animation_attack_on(target)
	stabbing_xeno.flick_attack_overlay(target, "tail")
	var/message = "You have injected [target] with mycotoxin! If they perish with this toxin in their body they will rise again at your service!"
	if(matriarch_stab) // Only the Matriarch can inject into a living target.
		var/damage = (stabbing_xeno.melee_damage_upper + stabbing_xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER) * TAILSTAB_MOB_DAMAGE_MULTIPLIER

		if(stabbing_xeno.behavior_delegate)
			stabbing_xeno.behavior_delegate.melee_attack_additional_effects_target(target)
			stabbing_xeno.behavior_delegate.melee_attack_additional_effects_self()
			damage = stabbing_xeno.behavior_delegate.melee_attack_modify_damage(damage, target)

		target.apply_armoured_damage(get_xeno_damage_slash(target, damage), ARMOR_MELEE, BRUTE, limb ? limb.name : "chest")
		if(stabbing_xeno.mob_size >= MOB_SIZE_BIG)
			target.apply_effect(3, DAZE)
		else if(stabbing_xeno.mob_size == MOB_SIZE_XENO)
			target.apply_effect(1, DAZE)
		shake_camera(target, 2, 1)

		target.reagents.add_reagent("mycotoxin_e", 4)
		target.reagents.set_source_mob(owner, /datum/reagent/toxin/mycotoxin/enhanced)
	else
		target.reagents.add_reagent("mycotoxin", 6)
		target.reagents.set_source_mob(owner, /datum/reagent/toxin/mycotoxin)
		message = "You have injected [target] with mycotoxin! They will rise again in service to the Overmind!"

	to_chat(target, SPAN_HIGHDANGER("You are injected with a powerful mycotoxin by [stabbing_xeno]!"))
	to_chat(stabbing_xeno, SPAN_PATHOGEN_QUEEN(message))

	target.handle_blood_splatter(get_dir(owner.loc, target.loc))
	return target

/datum/action/xeno_action/activable/mycotoxin/proc/reset_direction(mob/living/carbon/xenomorph/stabbing_xeno, last_dir, new_dir)
	// If the xenomorph is still holding the same direction as the tail stab animation's changed it to, reset it back to the old direction so the xenomorph isn't stuck facing backwards.
	if(new_dir == stabbing_xeno.dir)
		stabbing_xeno.setDir(last_dir)
