/datum/xeno_strain/trapper
	name = BOILER_TRAPPER
	description = "You trade a chunk of health alongside your ability to bombard, use neurotoxin gas, and dump acid in exchange for the ability to strongly damage a target area, ensnare targets within said area, and gain improved capacity for close-range combat. Deploy Traps places a line of traps that will root targets for 2 seconds, and successfully catching targets will provide bonuses to your other two abilities for 4 seconds. Use Acid Mortar to trigger a powerful delayed AOE where you're aiming, dealing double damage to barricades, with the trigger delay being decreased after trapping someone. Use Acid Shotgun when in close combat to deal high damage, dealing even more after trapping someone."
	flavor_description = "The battlefield is my canvas, this one, my painter. Melt them where they stand."

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit/bombard,
		/datum/action/xeno_action/onclick/shift_spits/boiler,
		/datum/action/xeno_action/activable/spray_acid/boiler,
		/datum/action/xeno_action/onclick/acid_shroud,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/boiler_trap,
		/datum/action/xeno_action/activable/acid_mortar,
		/datum/action/xeno_action/activable/acid_shotgun,
	)

	behavior_delegate_type = /datum/behavior_delegate/boiler_trapper

/datum/xeno_strain/trapper/apply_strain(mob/living/carbon/xenomorph/boiler/boiler)
	if(!istype(boiler))
		return FALSE

	if(boiler.is_zoomed)
		boiler.zoom_out()

	boiler.plasma_types -= PLASMA_NEUROTOXIN
	boiler.health_modifier -= XENO_HEALTH_MOD_VERY_LARGE

	boiler.recalculate_everything()

/datum/behavior_delegate/boiler_trapper
	name = "Boiler Trapper Behavior Delegate"

	var/successful_trap = FALSE
	var/trap_buff_cooldown = FALSE

/datum/behavior_delegate/boiler_trapper/proc/success_trap_buff()
	if(trap_buff_cooldown != TRUE)
		successful_trap = TRUE
		trap_buff_cooldown = TRUE
		addtimer(CALLBACK(src, PROC_REF(success_trap_buff_remove)), 4 SECONDS)

/datum/behavior_delegate/boiler_trapper/proc/success_trap_buff_remove()
	if(successful_trap != FALSE)
		to_chat(bound_xeno, SPAN_XENONOTICE("We feel our tactical advantage over our foes fade."))
	successful_trap = FALSE

/datum/action/xeno_action/activable/boiler_trap/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(!can_see(xeno, affected_atom))
		to_chat(xeno, SPAN_XENODANGER("We cannot see that location!"))
		return

	if(!do_after(xeno, 0.5 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		return

	if(!check_and_use_plasma_owner())
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

	for(var/turf/turf in target_turfs)
		if(!istype(turf) || turf.density)
			continue

		var/trap_found = FALSE
		for(var/obj/effect/alien/resin/boilertrap/boiler_trap in turf)
			trap_found = TRUE
			break

		if(trap_found)
			continue

		var/obj/effect/alien/resin/boilertrap/boiler_trap
		boiler_trap = new /obj/effect/alien/resin/boilertrap(turf, xeno)
		playsound(affected_atom, "alien_resin_build", 15, 0)
		QDEL_IN(boiler_trap, trap_ttl)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/acid_mortar/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc))
		return

	if(!check_clear_path_to_target(xeno, affected_atom, TRUE))
		to_chat(xeno, SPAN_XENOWARNING("Something is in the way!"))
		return

	if(!do_after(xeno, 0.5 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		return

	if(!check_and_use_plasma_owner())
		return

	var/turf/turf = get_turf(affected_atom)

	var/datum/behavior_delegate/boiler_trapper/be_del = xeno.behavior_delegate
	if(be_del.successful_trap)
		xeno.visible_message(SPAN_XENODANGER("[xeno] fires a bolt of acid in a low arc directed at [affected_atom]!"), SPAN_XENODANGER("We fire a bolt of acid directed at [affected_atom]!"))
	else
		xeno.visible_message(SPAN_XENODANGER("[xeno] fires a bolt of acid in a high arc directed at [affected_atom]!"), SPAN_XENODANGER("We fire a bolt of acid directed at [affected_atom]!"))
	if(be_del.successful_trap)
		delay /= 2
		be_del.successful_trap = FALSE
	new /obj/effect/xenomorph/acid_damage_delay(turf, damage, delay, "You are burned by acid raining from above!", xeno)

	for(var/turf/target_turf in orange(1, turf))
		new /obj/effect/xenomorph/acid_damage_delay/extra(target_turf, damage, delay, "You are burned by acid raining from above!", xeno)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/acid_shotgun/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc) || !xeno.check_state())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] fires a blast of acid at [affected_atom]!"), SPAN_XENOWARNING("We fire a blast of acid at [affected_atom]!"))
	playsound(xeno.loc, "acid_spit", 25, 1)

	var/turf/target_turf = locate(affected_atom.x, affected_atom.y, affected_atom.z)
	var/obj/projectile/proj = new(xeno.loc, create_cause_data("acid shotgun", xeno))
	var/datum/ammo/ammoDatum = new ammo_type()

	proj.generate_bullet(ammoDatum)
	proj.fire_at(target_turf, xeno, xeno, ammoDatum.max_range, ammoDatum.shell_speed)

	apply_cooldown()
	return ..()

/datum/ammo/xeno/acid_shotgun
	name = "acid spatter"
	ping = null
	flags_ammo_behavior = AMMO_SKIPS_ALIENS|AMMO_STOPPED_BY_COVER|AMMO_IGNORE_ARMOR|AMMO_ACIDIC
	bonus_projectiles_type = /datum/ammo/xeno/acid_shotgun/spread
	hit_effect_color = "#FF0000"

/datum/ammo/xeno/acid_shotgun/New()
	..()
	damage = 6
	max_range = 5
	damage_type = BURN
	accuracy = HIT_ACCURACY_TIER_8
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_9
	bonus_projectiles_type = /datum/ammo/xeno/acid_shotgun/spread

/datum/ammo/xeno/acid_shotgun/on_hit_mob(mob/living/carbon/target, obj/projectile/proj)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = proj.firer
	var/datum/behavior_delegate/boiler_trapper/be_del = xeno.behavior_delegate
	if(be_del.successful_trap)
		damage = 9
		be_del.successful_trap = FALSE

/datum/ammo/xeno/acid_shotgun/spread
	name = "acid spatter"

/datum/ammo/xeno/acid_shotgun/spread/New()
	..()
	scatter = SCATTER_AMOUNT_TIER_1
	bonus_projectiles_amount = 0
	max_range = 4
