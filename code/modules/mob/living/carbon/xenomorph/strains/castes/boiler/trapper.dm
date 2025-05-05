/datum/xeno_strain/trapper
	name = BOILER_TRAPPER
	description = "You trade your ability to bombard, lance, and dump your acid in order to gain some speed and the ability to create acid explosions and restrain enemies within them. With your longer-range vision, set up traps that immobilize your opponents and place acid mines which deal damage to enemies and barricades and reduce the cooldown of your trap deployment for every enemy hit. Finally, hit enemies with your Acid Shotgun ability which adds a stack of insight to empower the next trap you place once you reach a maximum of ten insight. A point-blank shot or a shot on a stunned target will instantly apply ten stacks."
	flavor_description = "The battlefield is my canvas, this one, my painter. Melt them where they stand."

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit/bombard,
		/datum/action/xeno_action/onclick/shift_spits/boiler,
		/datum/action/xeno_action/activable/spray_acid/boiler,
		/datum/action/xeno_action/onclick/toggle_long_range/boiler,
		/datum/action/xeno_action/onclick/acid_shroud,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/boiler_trap,
		/datum/action/xeno_action/activable/acid_mine,
		/datum/action/xeno_action/activable/acid_shotgun,
		/datum/action/xeno_action/onclick/toggle_long_range/trapper,
	)

	behavior_delegate_type = /datum/behavior_delegate/boiler_trapper

/datum/xeno_strain/trapper/apply_strain(mob/living/carbon/xenomorph/boiler/boiler)
	if(!istype(boiler))
		return FALSE

	if(boiler.is_zoomed)
		boiler.zoom_out()

	boiler.tileoffset = 0
	boiler.viewsize = TRAPPER_VIEWRANGE
	boiler.plasma_types -= PLASMA_NEUROTOXIN
	boiler.ammo = GLOB.ammo_list[boiler.caste.spit_types[1]]
	boiler.armor_modifier -= XENO_ARMOR_MOD_LARGE // no armor
	boiler.health_modifier -= XENO_HEALTH_MOD_MED

	boiler.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5 // compensating for base buffs
	boiler.recalculate_everything()

/datum/behavior_delegate/boiler_trapper
	name = "Boiler Trapper Behavior Delegate"

	// Config
	var/temp_movespeed_amount = 1.25
	var/temp_movespeed_duration = 50
	var/temp_movespeed_cooldown = 200
	var/bonus_damage_shotgun_trapped = 7.5

	// State
	var/temp_movespeed_time_used = 0
	var/temp_movespeed_usable = FALSE
	var/temp_movespeed_messaged = FALSE

/datum/behavior_delegate/boiler_trapper/append_to_stat()
	. = list()
	var/datum/action/xeno_action/activable/boiler_trap/trap_ability = get_action(bound_xeno, /datum/action/xeno_action/activable/boiler_trap)
	. += "Insight Amount: [trap_ability.empowering_charge_counter]/[trap_ability.empower_charge_max]"

/datum/behavior_delegate/boiler_trapper/on_hitby_projectile(ammo)
	if (temp_movespeed_usable)
		temp_movespeed_time_used = world.time
		temp_movespeed_usable = FALSE

		if (isxeno(bound_xeno))
			var/mob/living/carbon/xenomorph/xeno = bound_xeno
			xeno.speed_modifier -= temp_movespeed_amount
			xeno.recalculate_speed()
			addtimer(CALLBACK(src, PROC_REF(remove_speed_buff)), temp_movespeed_duration)

/datum/behavior_delegate/boiler_trapper/ranged_attack_additional_effects_target(atom/target_atom)
	if (!ishuman(target_atom))
		return
	if (!istype(bound_xeno))
		return

	var/mob/living/carbon/human/target_human = target_atom
	var/datum/effects/boiler_trap/found = null
	for (var/datum/effects/boiler_trap/trap in target_human.effects_list)
		if (trap.cause_data?.resolve_mob() == bound_xeno)
			found = trap
			break

	var/datum/action/xeno_action/activable/boiler_trap/trap_ability = get_action(bound_xeno, /datum/action/xeno_action/activable/boiler_trap)
	if (found)
		target_human.apply_armoured_damage(bonus_damage_shotgun_trapped, ARMOR_BIO, BURN)
		trap_ability.empowering_charge_counter = trap_ability.empower_charge_max
	else
		target_human.adjust_effect(2, SLOW)
		trap_ability.empowering_charge_counter++

	if(!trap_ability.empowered && trap_ability.empowering_charge_counter >= trap_ability.empower_charge_max)
		trap_ability.empowered = TRUE
		trap_ability.button.overlays += image('icons/mob/hud/actions_xeno.dmi', "+empowered")
		to_chat(bound_xeno, SPAN_XENODANGER("You have gained sufficient insight in your prey to empower your next [trap_ability.name]."))

	if(trap_ability.empowering_charge_counter > trap_ability.empower_charge_max)
		trap_ability.empowering_charge_counter = trap_ability.empower_charge_max

/datum/behavior_delegate/boiler_trapper/on_life()
	if ((temp_movespeed_time_used + temp_movespeed_cooldown) < world.time)
		if (!temp_movespeed_messaged)
			to_chat(bound_xeno, SPAN_XENODANGER("You feel your adrenaline glands refill! Your speedboost will activate again."))
			temp_movespeed_messaged = TRUE
		temp_movespeed_usable = TRUE
		return

/datum/behavior_delegate/boiler_trapper/proc/remove_speed_buff()
	if (isxeno(bound_xeno))
		var/mob/living/carbon/xenomorph/xeno = bound_xeno
		xeno.speed_modifier += temp_movespeed_amount
		xeno.recalculate_speed()
		temp_movespeed_messaged = FALSE

/datum/action/xeno_action/activable/boiler_trap/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!can_see(xeno, affected_atom, TRAPPER_VIEWRANGE))
		to_chat(xeno, SPAN_XENODANGER("We cannot see that location!"))
		return

	if (!check_and_use_plasma_owner())
		return

	// 5-long line of turfs orthogonal to the line between us and our target as precisely as we can figure it
	var/dir_between = Get_Compass_Dir(xeno, affected_atom)
	var/list/target_turfs = list()
	var/target_turf = get_turf(affected_atom)
	var/left_turf = get_step(target_turf, turn(dir_between, -90))
	var/right_turf = get_step(target_turf, turn(dir_between, 90))
	target_turfs += target_turf
	target_turfs += left_turf
	target_turfs += right_turf
	target_turfs += get_step(left_turf, turn(dir_between, -90))
	target_turfs += get_step(right_turf, turn(dir_between, 90))

	for (var/turf/turf in target_turfs)
		if (!istype(turf) || turf.density)
			continue

		var/trap_found = FALSE
		for (var/obj/effect/alien/resin/boilertrap/boiler_trap in turf)
			trap_found = TRUE
			break

		if (trap_found)
			continue

		var/obj/effect/alien/resin/boilertrap/boiler_trap
		if(empowered)
			boiler_trap = new /obj/effect/alien/resin/boilertrap/empowered(turf, xeno)
		else
			boiler_trap = new /obj/effect/alien/resin/boilertrap(turf, xeno)
		QDEL_IN(boiler_trap, trap_ttl)

	if(empowered)
		empowered = FALSE
		empowering_charge_counter = 0
		button.overlays -= image('icons/mob/hud/actions_xeno.dmi', "+empowered")
		var/datum/action/xeno_action/activable/acid_mine/mine = get_action(xeno, /datum/action/xeno_action/activable/acid_mine)
		if(!mine.empowered)
			mine.empowered = TRUE
			mine.button.overlays += image('icons/mob/hud/actions_xeno.dmi', "+empowered")
			to_chat(xeno, SPAN_XENODANGER("We tap into our reserves to prepare a stronger [mine.name]!"))

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/acid_mine/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!xeno.check_state())
		return

	if (!action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc))
		return

	if(!check_clear_path_to_target(xeno, affected_atom, TRUE, TRAPPER_VIEWRANGE))
		to_chat(xeno, SPAN_XENOWARNING("Something is in the way!"))
		return

	if (!check_and_use_plasma_owner())
		return

	var/turf/turf = get_turf(affected_atom)
	var/acid_bolt_message = "a bolt of acid"
	if(empowered)
		acid_bolt_message = "a powerful bolt of acid"

	xeno.visible_message(SPAN_XENODANGER("[xeno] fires " + acid_bolt_message + " at [affected_atom]!"), SPAN_XENODANGER("We fire " + acid_bolt_message + " at [affected_atom]!"))
	new /obj/effect/xenomorph/acid_damage_delay/boiler_landmine(turf, damage, delay, empowered, "You are blasted with " + acid_bolt_message + "!", xeno)

	for (var/turf/target_turf in orange(1, turf))
		new /obj/effect/xenomorph/acid_damage_delay/boiler_landmine(target_turf, damage, delay, empowered, "You are blasted with a " + acid_bolt_message + "!", xeno)

	if(empowered)
		empowered = FALSE
		button.overlays -= image('icons/mob/hud/actions_xeno.dmi', "+empowered")

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/acid_shotgun/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc) || !xeno.check_state())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] fires a blast of acid at [affected_atom]!"), SPAN_XENOWARNING("We fire a blast of acid at [affected_atom]!"))

	var/turf/target_turf = locate(affected_atom.x, affected_atom.y, affected_atom.z)
	var/obj/projectile/proj = new(xeno.loc, create_cause_data("acid shotgun", xeno))
	var/datum/ammo/ammoDatum = new ammo_type()

	proj.generate_bullet(ammoDatum)
	proj.fire_at(target_turf, xeno, xeno, ammoDatum.max_range, ammoDatum.shell_speed)

	apply_cooldown()
	return ..()

/datum/ammo/xeno/acid_shotgun
	name = "acid ball"
	ping = null
	flags_ammo_behavior = AMMO_SKIPS_ALIENS|AMMO_STOPPED_BY_COVER|AMMO_IGNORE_ARMOR|AMMO_ACIDIC
	bonus_projectiles_type = /datum/ammo/xeno/acid_shotgun/spread
	hit_effect_color = "#FF0000"

/datum/ammo/xeno/acid_shotgun/New()
	..()
	damage = 10
	max_range = 5
	damage_type = BURN
	accuracy = HIT_ACCURACY_TIER_8
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_9
	shrapnel_type = /datum/ammo/xeno/acid_shotgun/spread
	shrapnel_chance = 100

/datum/ammo/xeno/acid_shotgun/spread
	name = "acid ball"

/datum/ammo/xeno/acid_shotgun/spread/New()
	..()
	scatter = SCATTER_AMOUNT_TIER_1
	bonus_projectiles_amount = 0
	max_range = 4
