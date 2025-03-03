/datum/action/xeno_action/activable/pounce/crusher_charge
	name = "Charge"
	action_icon_state = "ready_charge"
	action_text = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_charge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 14 SECONDS
	plasma_cost = 20
	// Config options
	distance = 9
	knockdown = TRUE
	knockdown_duration = 2
	slash = FALSE
	freeze_self = FALSE
	windup = TRUE
	windup_duration = 1.2 SECONDS
	windup_interruptable = FALSE
	should_destroy_objects = TRUE
	throw_speed = SPEED_FAST
	tracks_target = FALSE
	var/direct_hit_damage = 60
	var/frontal_armor = 15
	// Object types that dont reduce cooldown when hit
	var/list/not_reducing_objects = list()


/datum/action/xeno_action/activable/pounce/crusher_charge/New()
	. = ..()
	not_reducing_objects = typesof(/obj/structure/barricade) + typesof(/obj/structure/machinery/defenses)

/datum/action/xeno_action/activable/pounce/crusher_charge/initialize_pounce_pass_flags()
	pounce_pass_flags = PASS_CRUSHER_CHARGE

/datum/action/xeno_action/onclick/crusher_stomp
	name = "Stomp"
	action_icon_state = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_stomp
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 18 SECONDS
	plasma_cost = 30

	var/damage = 65

	var/distance = 2
	var/effect_type_base = /datum/effects/xeno_slow/superslow
	var/effect_duration = 1 SECONDS

/datum/action/xeno_action/onclick/crusher_stomp/charger
	name = "Crush"
	action_icon_state = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_charger_stomp
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 25
	damage = 75
	distance = 3
	xeno_cooldown = 12 SECONDS


/datum/action/xeno_action/onclick/crusher_shield
	name = "Defensive Shield"
	action_icon_state = "empower"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_charge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 50
	xeno_cooldown = 26 SECONDS
	var/shield_amount = 200
	var/explosion_immunity_dur = 2.5 SECONDS
	var/shield_dur = 7 SECONDS

/datum/action/xeno_action/activable/fling/charger
	name = "Headbutt"
	action_icon_state = "ram"
	macro_path = /datum/action/xeno_action/verb/verb_fling
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 10 SECONDS
	plasma_cost = 10
	// Configurables
	fling_distance = 3
	stun_power = 0
	weaken_power = 0
	slowdown = 8


/datum/action/xeno_action/onclick/charger_charge
	name = "Toggle Charging"
	action_icon_state = "ready_charge"
	plasma_cost = 0 // manually applied in the proc
	macro_path = /datum/action/xeno_action/verb/verb_crusher_toggle_charging
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1

	// Config vars
	var/max_momentum = 8
	var/steps_to_charge = 4
	var/speed_per_momentum = XENO_SPEED_FASTMOD_TIER_5 + XENO_SPEED_FASTMOD_TIER_1//2
	var/plasma_per_step = 3 // charger has 400 plasma atm, this gives a good 100 tiles of crooshing

	// State vars
	var/activated = FALSE
	var/steps_taken = 0
	var/charge_dir
	var/noise_timer = 0

	//How much shield you gain on max momentum
	var/shield_amount = 100
	// How long the max momentum shield lasts
	var/shield_timeout = 4
	// If the shield is active or not
	var/shield_active = FALSE

	/// The last time the crusher moved while charging
	var/last_charge_move
	/// Dictates speed and damage dealt via collision, increased with movement
	var/momentum = 0


/datum/action/xeno_action/onclick/charger_charge/proc/handle_position_change(mob/living/carbon/xenomorph/xeno, body_position)
	SIGNAL_HANDLER
	if(body_position == LYING_DOWN)
		handle_movement(xeno)

/datum/action/xeno_action/onclick/charger_charge/proc/handle_movement(mob/living/carbon/xenomorph/Xeno, atom/oldloc, dir, forced)
	SIGNAL_HANDLER
	if(Xeno.pulling)
		if(!momentum)
			steps_taken = 0
			return
		else
			Xeno.stop_pulling()

	if(Xeno.is_mob_incapacitated())
		if(!momentum)
			return
		var/distance_to_throw = get_ranged_target_turf(Xeno, charge_dir, momentum/2)
		INVOKE_ASYNC(Xeno, TYPE_PROC_REF(/atom/movable, throw_atom), distance_to_throw, momentum/2, SPEED_FAST, null, TRUE)
		stop_momentum()
		return
	if(!isturf(Xeno.loc))
		stop_momentum()
		return
	// Don't build up charge if you move via getting propelled by something
	if(Xeno.throwing)
		stop_momentum()
		return

	var/do_stop_momentum = FALSE

	// Need to be constantly moving in order to maintain charge
	if(world.time > last_charge_move + 0.5 SECONDS)
		do_stop_momentum = TRUE
	if(dir != charge_dir)
		charge_dir = dir
		do_stop_momentum = TRUE

	if(do_stop_momentum)
		stop_momentum()
	if(Xeno.plasma_stored <= plasma_per_step)
		stop_momentum()
		return
	last_charge_move = world.time
	steps_taken++
	if(steps_taken < steps_to_charge)
		return
	if(momentum < max_momentum)
		momentum++
		ADD_TRAIT(Xeno, TRAIT_CHARGING, TRAIT_SOURCE_XENO_ACTION_CHARGE)
		Xeno.update_icons()
		if(momentum == max_momentum)
			Xeno.emote("roar")
	//X.use_plasma(plasma_per_step) // take if you are in toggle charge mode
	if(momentum > 0)
		Xeno.use_plasma(plasma_per_step) // take plasma when you have momentum

	noise_timer = noise_timer ? --noise_timer : 3
	if(noise_timer == 3)
		playsound(Xeno, 'sound/effects/alien_footstep_charge1.ogg', 50)

	for(var/mob/living/carbon/human/Mob in Xeno.loc)
		if(Mob.body_position == LYING_DOWN && Mob.stat != DEAD)
			Xeno.visible_message(SPAN_DANGER("[Xeno] runs [Mob] over!"),
				SPAN_DANGER("We run [Mob] over!")
			)
			var/ram_dir = pick(get_perpen_dir(Xeno.dir))
			var/dist = 1
			if(momentum == max_momentum)
				dist = momentum * 0.25
			step(Mob, ram_dir, dist)
			Mob.take_overall_armored_damage(momentum * 6)
			INVOKE_ASYNC(Mob, TYPE_PROC_REF(/mob/living/carbon/human, emote),"pain")
			shake_camera(Mob, 7,3)
			animation_flash_color(Mob)

	Xeno.recalculate_speed()

/datum/action/xeno_action/onclick/charger_charge/proc/handle_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	if(new_dir != charge_dir)
		charge_dir = new_dir
		if(momentum)
			stop_momentum()

/datum/action/xeno_action/onclick/charger_charge/proc/handle_river(datum/source, covered)
	SIGNAL_HANDLER
	if(!covered)
		stop_momentum()

/datum/action/xeno_action/onclick/charger_charge/proc/update_speed(mob/living/carbon/xenomorph/Xeno)
	SIGNAL_HANDLER
	Xeno.speed += momentum * speed_per_momentum

/datum/action/xeno_action/onclick/charger_charge/proc/stop_momentum(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/xenomorph/Xeno = owner
	if(momentum == max_momentum)
		Xeno.visible_message(SPAN_DANGER("[Xeno] skids to a halt!"))

	REMOVE_TRAIT(Xeno, TRAIT_CHARGING, TRAIT_SOURCE_XENO_ACTION_CHARGE)
	steps_taken = 0
	momentum = 0
	Xeno.recalculate_speed()
	Xeno.update_icons()

/datum/action/xeno_action/onclick/charger_charge/proc/lose_momentum(amount)
	if(amount >= momentum)
		stop_momentum()
	else
		momentum -= amount
		var/mob/living/carbon/xenomorph/Xeno = owner
		Xeno.recalculate_speed()

/datum/action/xeno_action/onclick/charger_charge/proc/handle_collision(mob/living/carbon/xenomorph/Xeno, atom/tar)
	SIGNAL_HANDLER
	if(!momentum)
		stop_momentum()
		return

	var/result = tar.handle_charge_collision(Xeno, src)
	switch(result)
		if(XENO_CHARGE_TRY_MOVE)
			if(step(Xeno, charge_dir))
				return COMPONENT_LIVING_COLLIDE_HANDLED

/datum/action/xeno_action/onclick/charger_charge/proc/start_charging(datum/source)
	SIGNAL_HANDLER
	steps_taken = steps_to_charge


/datum/action/xeno_action/activable/tumble
	name = "Tumble"
	action_icon_state = "tumble"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_tumble
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2

	plasma_cost = 25
	xeno_cooldown = 10 SECONDS

/datum/action/xeno_action/activable/tumble/proc/on_end_throw(start_charging)
	var/mob/living/carbon/xenomorph/Xeno = owner
	Xeno.flags_atom &= ~DIRLOCK
	if(start_charging)
		SEND_SIGNAL(Xeno, COMSIG_XENO_START_CHARGING)


/datum/action/xeno_action/activable/tumble/proc/handle_mob_collision(mob/living/carbon/Mob)
	var/mob/living/carbon/xenomorph/Xeno = owner
	Xeno.visible_message(SPAN_XENODANGER("[Xeno] Sweeps to the side, knocking down [Mob]!"), SPAN_XENODANGER("We knock over [Mob] as we sweep to the side!"))
	var/turf/target_turf = get_turf(Mob)
	playsound(Mob,'sound/weapons/alien_claw_block.ogg', 50, 1)
	Mob.apply_damage(15,BRUTE)
	if(ishuman(Mob))
		var/mob/living/carbon/human/Human = Mob
		Xeno.throw_carbon(Human, distance = 1)
		Human.apply_effect(1, WEAKEN)
	else
		Mob.apply_effect(1, WEAKEN)
	if(!LinkBlocked(Xeno, get_turf(Xeno), target_turf))
		Xeno.forceMove(target_turf)

