/datum/caste_datum/ravager
	caste_type = XENO_CASTE_RAVAGER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_6
	melee_damage_upper = XENO_DAMAGE_TIER_6
	melee_vehicle_damage = XENO_DAMAGE_TIER_7 //Queen and Ravs have extra multiplier when dealing damage in multitile_interaction.dm
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_PLASMA_TIER_3
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_8
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_3
	heal_standing = 0.66

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 35
	tacklestrength_min = 4
	tacklestrength_max = 5

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_LURKER)
	caste_desc = "A brutal, devastating front-line attacker."
	fire_immunity = FIRE_IMMUNITY_NO_DAMAGE|FIRE_IMMUNITY_XENO_FRENZY
	attack_delay = -1

	available_strains = list(
		/datum/xeno_strain/berserker,
		/datum/xeno_strain/hedgehog,
	)
	behavior_delegate_type = /datum/behavior_delegate/ravager_base

	minimum_evolve_time = 15 MINUTES

	minimap_icon = "ravager"

/mob/living/carbon/xenomorph/ravager
	caste_type = XENO_CASTE_RAVAGER
	name = XENO_CASTE_RAVAGER
	desc = "A huge, nasty red alien with enormous scythed claws."
	icon = 'icons/mob/xenos/castes/tier_3/ravager.dmi'
	icon_size = 64
	icon_state = "Ravager Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	pixel_x = -16
	old_x = -16
	claw_type = CLAW_TYPE_VERY_SHARP
	organ_value = 3000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/pounce/charge,
		/datum/action/xeno_action/onclick/empower,
		/datum/action/xeno_action/activable/scissor_cut,
		/datum/action/xeno_action/onclick/tacmap,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_3/ravager.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_3/ravager.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Ravager_1","Ravager_2","Ravager_3")
	weed_food_states_flipped = list("Ravager_1","Ravager_2","Ravager_3")


// Mutator delegate for base ravager
/datum/behavior_delegate/ravager_base
	var/shield_decay_time = 15 SECONDS // Time in deciseconds before our shield decays
	var/slash_charge_cdr = 3 SECONDS // Amount to reduce charge cooldown by per slash
	var/knockdown_amount = 1.6
	var/fling_distance = 3
	var/empower_targets = 0
	var/super_empower_threshold = 3
	var/dmg_buff_per_target = 2
	var/mid_charge = FALSE

/datum/behavior_delegate/ravager_base/melee_attack_modify_damage(original_damage, mob/living/carbon/carbon)
	var/damage_plus
	if(empower_targets)
		damage_plus = dmg_buff_per_target * empower_targets

	return original_damage + damage_plus

/datum/behavior_delegate/ravager_base/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/activable/pounce/charge/cAction = get_action(bound_xeno, /datum/action/xeno_action/activable/pounce/charge)
	if (!cAction.action_cooldown_check())
		cAction.reduce_cooldown(slash_charge_cdr)

/datum/behavior_delegate/ravager_base/append_to_stat()
	. = list()
	var/shield_total = 0
	for (var/datum/xeno_shield/xeno_shield in bound_xeno.xeno_shields)
		if (xeno_shield.shield_source == XENO_SHIELD_SOURCE_RAVAGER)
			shield_total += xeno_shield.amount

	. += "Empower Shield: [shield_total]"
	. += "Bonus Slash Damage: [dmg_buff_per_target * empower_targets]"

/datum/behavior_delegate/ravager_base/on_life()
	var/datum/xeno_shield/rav_shield
	for (var/datum/xeno_shield/xeno_shield in bound_xeno.xeno_shields)
		if (xeno_shield.shield_source == XENO_SHIELD_SOURCE_RAVAGER)
			rav_shield = xeno_shield
			break

	if (rav_shield && ((rav_shield.last_damage_taken + shield_decay_time) < world.time))
		QDEL_NULL(rav_shield)
		to_chat(bound_xeno, SPAN_XENODANGER("We feel our shield decay!"))
		bound_xeno.overlay_shields()

/datum/behavior_delegate/ravager_base/override_intent(mob/living/carbon/target_carbon)
	. = ..()

	if(!isxeno_human(target_carbon))
		return

	if(mid_charge)
		return INTENT_HARM

/datum/action/xeno_action/onclick/empower/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!activated_once)
		if (!check_and_use_plasma_owner())
			return

		xeno.visible_message(SPAN_XENODANGER("[xeno] starts empowering!"), SPAN_XENODANGER("We start empowering ourself!"))
		activated_once = TRUE
		button.icon_state = "template_active"
		get_inital_shield()
		addtimer(CALLBACK(src, PROC_REF(timeout)), time_until_timeout)
		apply_cooldown()
		return ..()
	else
		actual_empower(xeno)
		return TRUE

/datum/action/xeno_action/onclick/empower/proc/actual_empower(mob/living/carbon/xenomorph/xeno)
	var/datum/behavior_delegate/ravager_base/behavior = xeno.behavior_delegate

	activated_once = FALSE
	button.icon_state = "template"
	xeno.visible_message(SPAN_XENOWARNING("[xeno] gets empowered by the surrounding enemies!"), SPAN_XENOWARNING("We feel a rush of power from the surrounding enemies!"))
	xeno.create_empower()

	var/list/mobs_in_range = oviewers(empower_range, xeno)
	// Spook patrol
	xeno.emote("tail")

	var/accumulative_health = 0
	var/list/telegraph_atom_list = list()

	var/empower_targets
	for(var/mob/living/mob in mobs_in_range)
		if(empower_targets >= max_targets)
			break
		if(mob.stat == DEAD || HAS_TRAIT(mob, TRAIT_NESTED))
			continue
		if(xeno.can_not_harm(mob))
			continue

		empower_targets++
		accumulative_health += shield_per_human
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(mob.loc, 1 SECONDS)
		shake_camera(mob, 2, 1)

	accumulative_health += main_empower_base_shield

	xeno.add_xeno_shield(accumulative_health, XENO_SHIELD_SOURCE_RAVAGER)
	xeno.overlay_shields()
	if(empower_targets >= behavior.super_empower_threshold) //you go in deep you reap the rewards
		super_empower(xeno, empower_targets, behavior)

/datum/action/xeno_action/onclick/empower/proc/super_empower(mob/living/carbon/xenomorph/xeno, empower_targets, datum/behavior_delegate/ravager_base/behavior)
	xeno.visible_message(SPAN_DANGER("[xeno] glows an eerie red as it empowers further with the strength of [empower_targets] hostiles!"), SPAN_XENOHIGHDANGER("We begin to glow an eerie red, empowered by the [empower_targets] enemies!"))
	xeno.emote("roar")


	behavior.empower_targets = empower_targets

	var/color = "#FF0000"
	var/alpha = 70
	color += num2text(alpha, 2, 16)
	xeno.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))

	addtimer(CALLBACK(src, PROC_REF(weaken_superbuff), xeno, behavior), 5 SECONDS)

/datum/action/xeno_action/onclick/empower/proc/weaken_superbuff(mob/living/carbon/xenomorph/xeno, datum/behavior_delegate/ravager_base/behavior)

	xeno.remove_filter("empower_rage")
	var/color = "#FF0000"
	var/alpha = 35
	color += num2text(alpha, 2, 16)
	xeno.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))

	addtimer(CALLBACK(src, PROC_REF(remove_superbuff), xeno, behavior), 1.5 SECONDS)

/datum/action/xeno_action/onclick/empower/proc/remove_superbuff(mob/living/carbon/xenomorph/xeno, datum/behavior_delegate/ravager_base/behavior)
	behavior.empower_targets = 0

	xeno.visible_message(SPAN_DANGER("[xeno]'s glow slowly dims."), SPAN_XENOHIGHDANGER("Our glow fades away, the power leaving our form!"))
	xeno.remove_filter("empower_rage")

/datum/action/xeno_action/onclick/empower/proc/get_inital_shield()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!activated_once)
		return

	xeno.add_xeno_shield(initial_activation_shield, XENO_SHIELD_SOURCE_RAVAGER)
	xeno.overlay_shields()

/datum/action/xeno_action/onclick/empower/proc/timeout()
	if(!activated_once)
		return

	var/mob/living/carbon/xenomorph/xeno = owner
	actual_empower(xeno)

/datum/action/xeno_action/onclick/empower/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		return TRUE
	else if (activated_once)
		return TRUE
	else
		return FALSE

// Supplemental behavior for our charge
/datum/action/xeno_action/activable/pounce/charge/additional_effects(mob/living/living)

	var/mob/living/carbon/human/human = living
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/ravager_base/behavior = xeno.behavior_delegate
	if(behavior.empower_targets < behavior.super_empower_threshold)
		return
	behavior.mid_charge = TRUE
	xeno.visible_message(SPAN_XENODANGER("[xeno] uses its shield to bash [human] as it charges at them!"), SPAN_XENODANGER("We use our shield to bash [human] as we charge at them!"))
	human.apply_effect(behavior.knockdown_amount, WEAKEN)
	human.attack_alien(xeno, rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
	behavior.mid_charge = FALSE


	var/facing = get_dir(xeno, human)

	xeno.throw_carbon(human, facing, behavior.fling_distance, SPEED_VERY_FAST, shake_camera = FALSE, immobilize = TRUE)

/datum/action/xeno_action/activable/scissor_cut/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/ravager_user = owner

	if (!action_cooldown_check())
		return

	if (!ravager_user.check_state())
		return

	// Determine whether or not we should daze here
	var/should_sslow = FALSE
	var/datum/behavior_delegate/ravager_base/ravager_delegate = ravager_user.behavior_delegate
	if(ravager_delegate.empower_targets >= ravager_delegate.super_empower_threshold)
		should_sslow = TRUE

	// Get line of turfs
	var/list/turf/target_turfs = list()

	var/facing = Get_Compass_Dir(ravager_user, target_atom)
	var/turf/turf = ravager_user.loc
	var/turf/temp = ravager_user.loc
	var/list/telegraph_atom_list = list()

	for (var/step in 0 to 3)
		temp = get_step(turf, facing)
		if(facing in GLOB.diagonals) // check if it goes through corners
			var/reverse_face = GLOB.reverse_dir[facing]

			var/turf/back_left = get_step(temp, turn(reverse_face, 45))
			var/turf/back_right = get_step(temp, turn(reverse_face, -45))
			if((!back_left || back_left.density) && (!back_right || back_right.density))
				break
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/structure_blocker in temp)
			if(istype(structure_blocker, /obj/structure/window/framed))
				var/obj/structure/window/framed/framed_window = structure_blocker
				if(!framed_window.unslashable)
					framed_window.deconstruct(disassembled = FALSE)
			if(istype(structure_blocker, /obj/structure/fence))
				var/obj/structure/fence/fence = structure_blocker
				if(!fence.unslashable)
					fence.health -= 50
					fence.healthcheck()

			if(structure_blocker.opacity)
				blocked = TRUE
				break
		if(blocked)
			break

		turf = temp
		target_turfs += turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(turf, 0.25 SECONDS)

	// Extract our 'optimal' turf, if it exists
	if (length(target_turfs) >= 2)
		ravager_user.animation_attack_on(target_turfs[length(target_turfs)], 15)

	// Hmm today I will kill a marine while looking away from them
	ravager_user.face_atom(target_atom)
	ravager_user.emote("roar")
	ravager_user.visible_message(SPAN_XENODANGER("[ravager_user] sweeps its claws through the area in front of it!"), SPAN_XENODANGER("We sweep our claws through the area in front of us!"))

	// Loop through our turfs, finding any humans there and dealing damage to them
	for (var/turf/target_turf in target_turfs)
		for (var/mob/living/carbon/carbon_target in target_turf)
			if (carbon_target.stat == DEAD)
				continue

			if (HAS_TRAIT(carbon_target, TRAIT_NESTED))
				continue

			if(ravager_user.can_not_harm(carbon_target))
				continue
			ravager_user.flick_attack_overlay(carbon_target, "slash")
			carbon_target.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
			playsound(get_turf(carbon_target), "alien_claw_flesh", 30, TRUE)

			if(should_sslow)
				new /datum/effects/xeno_slow/superslow(carbon_target, ravager_user, ttl = superslow_duration)

	apply_cooldown()
	return ..()
