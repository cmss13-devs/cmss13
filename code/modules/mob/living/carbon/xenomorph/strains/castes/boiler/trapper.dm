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
		trap_ability.button.overlays += "+empowered"
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
