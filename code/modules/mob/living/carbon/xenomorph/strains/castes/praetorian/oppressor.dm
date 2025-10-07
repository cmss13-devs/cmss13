/datum/xeno_strain/oppressor
	// Dread it, run from it, destiny still arrives... or should I say, I do
	name = PRAETORIAN_OPPRESSOR
	description = "You lose all previous abilities, gaining a tail that can be used to swing people around or into eachother, a punch that roots them in place if they have some sort of crowd control applied to them, and a fling back ability that throws the target you clicked on opposite direction of where you are facing."
	flavor_description = "My reach is endless, this one will pull down the heavens."
	icon_state_prefix = "Oppressor"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/xeno_spit/praetorian,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab/tail_seize,
		/datum/action/xeno_action/activable/prae_abduct,
		/datum/action/xeno_action/activable/oppressor_punch,
		/datum/action/xeno_action/activable/send_back,
	)

	behavior_delegate_type = /datum/behavior_delegate/oppressor_praetorian

/datum/xeno_strain/oppressor/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	prae.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_SMALL
	prae.small_explosives_stun = FALSE
	prae.plasma_types = list(PLASMA_NEUROTOXIN, PLASMA_CHITIN)
	prae.claw_type = CLAW_TYPE_SHARP

	prae.recalculate_everything()

/datum/behavior_delegate/oppressor_praetorian
	name = "Oppressor Praetorian Behavior Delegate"
	var/tearing_damage = 15

/datum/behavior_delegate/oppressor_praetorian/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if(target_carbon.stat == DEAD)
		return

	// impaired in some capacity
	if(!(target_carbon.mobility_flags & MOBILITY_STAND) || !(target_carbon.mobility_flags & MOBILITY_MOVE) || target_carbon.slowed)
		target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, tearing_damage), ARMOR_MELEE, BRUTE, bound_xeno.zone_selected ? bound_xeno.zone_selected : "chest")
		target_carbon.visible_message(SPAN_DANGER("[bound_xeno] tears into [target_carbon]!"))
		playsound(bound_xeno, 'sound/weapons/alien_tail_attack.ogg', 25, TRUE)


/datum/action/xeno_action/activable/tail_stab/tail_seize/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/stabbing_xeno = owner

	if(!action_cooldown_check())
		return FALSE

	if(!stabbing_xeno.check_state())
		return FALSE

	if (world.time <= stabbing_xeno.next_move)
		return FALSE

	if(!check_and_use_plasma_owner())
		return FALSE

	stabbing_xeno.visible_message(SPAN_XENODANGER("\The [stabbing_xeno] uncoils and wildly throws out its tail!"), SPAN_XENODANGER("We uncoil our tail wildly in front of us!"))

	var/obj/projectile/hook_projectile = new /obj/projectile(stabbing_xeno.loc, create_cause_data(initial(stabbing_xeno.caste_type), stabbing_xeno))

	var/datum/ammo/ammoDatum = GLOB.ammo_list[/datum/ammo/xeno/oppressor_tail]

	hook_projectile.generate_bullet(ammoDatum, bullet_generator = stabbing_xeno)
	hook_projectile.bound_beam = hook_projectile.beam(stabbing_xeno, "oppressor_tail", 'icons/effects/beam.dmi', 1 SECONDS, 5)

	hook_projectile.fire_at(targetted_atom, stabbing_xeno, stabbing_xeno, ammoDatum.max_range, ammoDatum.shell_speed)
	playsound(stabbing_xeno, 'sound/effects/oppressor_tail.ogg', 40, FALSE)

	apply_cooldown()
	xeno_attack_delay(stabbing_xeno)
	return ..()

/datum/action/xeno_action/activable/prae_abduct/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/abduct_user = owner
	throw_turf = targetted_atom

	if(!action_cooldown_check() || abduct_user.action_busy)
		return

	if(!abduct_user.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	if(!tail_image)
		tail_image = image('icons/effects/status_effects.dmi', "hooked")


	if(!ability_used_once)
		ability_used_once = TRUE

		if(!targetted_atom || targetted_atom.layer >= FLY_LAYER || !isturf(abduct_user.loc))
			return

		var/turf/turfs_get = get_line(abduct_user, targetted_atom, FALSE)

		for(var/turf/turfs in turfs_get)

			if(turfs.density)
				break

			for(var/obj/structure/structure in turfs)

				if(structure.density)
					break

			telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/abduct_hook(turfs, windup)

			for (var/mob/living/carbon/target in turfs)

				if(target.stat == DEAD)
					continue

				if(abduct_user.can_not_harm(target))
					continue

				if(target.mob_size > MOB_SIZE_BIG)
					continue

				if(!iscarbon(target))
					continue

				if(HAS_TRAIT(target, TRAIT_NESTED))
					continue

				targets_added += target

		if(do_after(abduct_user, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 1))
			for(var/mob/living/target as anything in targets_added)
				ADD_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Abduct"))
				tail_beam = abduct_user.beam(target, "oppressor_tail", 'icons/effects/beam.dmi', 2 SECONDS, 8)
				target.overlays += tail_image

		to_chat(abduct_user, SPAN_XENODANGER("We launch our tail towards [targetted_atom]!"))
		abduct_user.emote("roar")
		addtimer(CALLBACK(src, PROC_REF(reset_ability)), 2 SECONDS)
		to_chat(targets_added, SPAN_DANGER("We are rooted by [abduct_user]'s tail!"))

		return ..()
	else
		initial_throw()
		apply_cooldown()
		return TRUE


/datum/action/xeno_action/activable/prae_abduct/proc/initial_throw()
	var/mob/living/carbon/xenomorph/abduct_user = owner
	var/list/collision_callbacks = list(/mob/living/carbon = CALLBACK(src, PROC_REF(handle_abduct_collision)))
	var/list/end_throw_callbacks = list(CALLBACK(src, PROC_REF(handle_abduct_end_throw)))
	throw_count = 0
	for(var/mob/living/target as anything in targets_added)
		abduct_user.throw_carbon(target, get_dir(target, throw_turf), secondary_throw_distance, SPEED_VERY_FAST, immobilize=FALSE, collision_callbacks=collision_callbacks, end_throw_callbacks=end_throw_callbacks)

/// Callback for other carbons that get collided with in abduct
/datum/action/xeno_action/activable/prae_abduct/proc/handle_abduct_collision(mob/living/carbon/collided)
	var/mob/living/carbon/xenomorph/abduct_user = owner
	if(!abduct_user.can_not_harm(collided))
		targets_collided += collided
		collided.Stun(0.7) // We can't knockdown here else they're no longer a collide target	to_chat(collided, SPAN_XENODANGER("You lose your footing as you're slammed into someone!"))
		playsound(collided, 'sound/weapons/alien_claw_block.ogg', 75, 1)

/// Callback for the end of an abduct for a carbon
/datum/action/xeno_action/activable/prae_abduct/proc/handle_abduct_end_throw()
	if(++throw_count < length(targets_added))
		return // Still other throws processing - we want the last

	for(var/mob/living/target as anything in targets_added)
		if(!(target in targets_collided))
			target.Stun(0.7)
			target.KnockDown(0.7)
			to_chat(targets_added, SPAN_XENODANGER("You are swept off your feet as [owner]'s tail throws you around!"))
			playsound(target, 'sound/weapons/alien_claw_block.ogg', 75, 1)
			affected_count++
	for(var/mob/living/target as anything in targets_collided)
		target.KnockDown(0.7) // We could also just do all effects/chat/sound here instead of some in handle_abduct_collision
		affected_count++

	if(length(targets_collided))
		to_chat(owner, SPAN_XENODANGER("We use our tail to slam our targets together!"))

	else
		to_chat(owner, SPAN_XENODANGER("We spring our tail and throw them around!"))

	qdel(tail_beam)
	apply_cooldown()
	owner.emote("roar")
	to_chat(owner, SPAN_XENONOTICE("Our tail returns!"))


	reset_ability()


/datum/action/xeno_action/activable/prae_abduct/proc/reset_ability()
	for(var/mob/living/target in targets_added)
		REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Abduct"))
		target.overlays -= tail_image
	targets_added.len = 0
	targets_collided.len = 0

	ability_used_once = FALSE
	apply_cooldown()


/datum/action/xeno_action/activable/oppressor_punch/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/oppressor_user = owner

	if (!action_cooldown_check())
		return

	if (!isxeno_human(target_atom) || oppressor_user.can_not_harm(target_atom))
		return

	if (!oppressor_user.check_state() || oppressor_user.agility)
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (!oppressor_user.Adjacent(target_carbon))
		return

	if(target_carbon.stat == DEAD)
		return

	var/obj/limb/target_limb = target_carbon.get_limb(check_zone(oppressor_user.zone_selected))

	if (ishuman(target_carbon) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = target_carbon.get_limb("chest")

	if (!check_and_use_plasma_owner())
		return

	target_carbon.last_damage_data = create_cause_data(oppressor_user.caste_type, oppressor_user)

	oppressor_user.visible_message(SPAN_XENOWARNING("\The [oppressor_user] hits [target_carbon] in the [target_limb? target_limb.display_name : "chest"] with a devastatingly powerful punch!"),
	SPAN_XENOWARNING("We hit [target_carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"))
	var/hitsound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(target_carbon,hitsound, 50, 1)

	oppressor_user.face_atom(target_carbon)
	oppressor_user.animation_attack_on(target_carbon)
	oppressor_user.flick_attack_overlay(target_carbon, "punch")

	if (!(target_carbon.mobility_flags & MOBILITY_MOVE) || !(target_carbon.mobility_flags & MOBILITY_STAND) || target_carbon.slowed)
		target_carbon.apply_damage(get_xeno_damage_slash(target_carbon, damage), BRUTE, target_limb? target_limb.name : "chest")
		ADD_TRAIT(target_carbon, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Oppressor Punch"))

		if (ishuman(target_carbon))
			var/mob/living/carbon/human/human_to_update = target_carbon
			human_to_update.update_xeno_hostile_hud()

		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unroot_human), target_carbon, TRAIT_SOURCE_ABILITY("Oppressor Punch")), get_xeno_stun_duration(target_carbon, 1.2 SECONDS))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("[oppressor_user] has pinned you to the ground! You cannot move!"))
	else
		target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, damage), ARMOR_MELEE, BRUTE, target_limb? target_limb.name : "chest")
		step_away(target_carbon, oppressor_user, 2)


	shake_camera(target_carbon, 2, 1)
	var/datum/action/xeno_action/activable/prae_abduct/abduct_action = get_action(oppressor_user, /datum/action/xeno_action/activable/prae_abduct)
	var/datum/action/xeno_action/activable/send_back/send_back_action = get_action(oppressor_user, /datum/action/xeno_action/activable/send_back)
	if(abduct_action && !abduct_action.action_cooldown_check())
		abduct_action.reduce_cooldown(5 SECONDS)
	if(send_back_action && !send_back_action.action_cooldown_check())
		send_back_action.reduce_cooldown(5 SECONDS)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/send_back/use_ability(atom/target_atom)
	if(!action_cooldown_check())
		return

	var/mob/living/carbon/xenomorph/xeno = owner

	var/mob/living/target_living = target_atom

	if(!iscarbon(target_living))
		return

	if(xeno.can_not_harm(target_living))
		return

	if(target_living.stat == DEAD)
		return

	if(!xeno.Adjacent(target_living))
		to_chat(xeno, SPAN_XENODANGER("They have to be closer to us!"))
		return

	if(!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	xeno.setDir(get_cardinal_dir(xeno, target_living))

	var/dir_to_fling = get_dir(target_living, xeno)
	var/turfs_travelled = 1
	var/turf/open/turf_to_fling_to = get_turf(xeno)
	if(xeno.Adjacent(target_living) && xeno.start_pulling(target_living, TRUE))
		move_loop:
			for(var/i in 1 to 2)
				var/turf/maybe_viable = get_step(turf_to_fling_to, dir_to_fling)
				if(!istype(maybe_viable, /turf/open))
					break

				for(var/obj/thing in maybe_viable.contents)
					if(thing.density)
						break move_loop

				turf_to_fling_to = maybe_viable
				turfs_travelled++

		target_living.forceMove(turf_to_fling_to)
		target_living.throw_atom(get_step_towards(turf_to_fling_to, target_living), 1, SPEED_FAST, xeno, tracking=TRUE)
		target_living.Stun(1)
		xeno.Root(1)

		target_living.apply_armoured_damage(fling_damage)
		playsound(target_living, 'sound/weapons/alien_claw_block.ogg', 75, 1)

		var/old_layer = target_living.layer
		var/old_pixel_x = target_living.pixel_x
		var/old_pixel_y = target_living.pixel_y
		target_living.layer = ABOVE_XENO_LAYER
		switch(xeno.dir)
			if(NORTH)
				target_living.pixel_y = 32 * turfs_travelled
				animate(target_living, 0.6 SECONDS, pixel_y = old_pixel_y)
			if(EAST)
				target_living.pixel_x = 32 * turfs_travelled
				animate(target_living, 0.3 SECONDS, pixel_y = 44, pixel_x = (16 * turfs_travelled))
				animate(0.3 SECONDS, pixel_y = old_pixel_y, pixel_x = old_pixel_x)
			if(SOUTH)
				target_living.pixel_y = -32 * turfs_travelled
				animate(target_living, 0.6 SECONDS, pixel_y = old_pixel_y)
			if(WEST)
				target_living.pixel_x = -32 * turfs_travelled
				animate(target_living, 0.3 SECONDS, pixel_y = 44, pixel_x = (-16 * turfs_travelled))
				animate(0.3 SECONDS, pixel_y = old_pixel_y, pixel_x = old_pixel_x)

		addtimer(CALLBACK(src, PROC_REF(end_fling), target_living, old_layer, old_pixel_x, old_pixel_y), 0.6 SECONDS)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/send_back/proc/end_fling(mob/living/target_living, original_layer, old_px, old_py)
	var/mob/living/carbon/xenomorph/xeno = owner
	target_living.SetStun(0)
	xeno.SetRoot(0)
	target_living.layer = original_layer
	target_living.pixel_x = old_px
	target_living.pixel_y = old_py
