// SINGED IS REAL
/datum/moba_caste/boiler
	equivalent_caste_path = /datum/caste_datum/boiler
	equivalent_xeno_path = /mob/living/carbon/xenomorph/boiler
	name = XENO_CASTE_BOILER
	desc = {"
		Disruptive tank that deals damage primarily through DOT.<br>
		<b>P:</b> Gain bonus movespeed the less health you have.<br>
		<b>1:</b> Continuously release a transparent gas trail that poisons anyone who walks into it.<br>
		<b>2:</b> Release a slowing excretion that slows anyone who walks into it.<br>
		<b>3:</b> Fling a target behind you, dealing max health damage and rooting if they land in slowing excretion.<br>
		<b>U:</b> Gain a large boost to acid power, movespeed, armor, and regeneration for a time.
	"}
	category = MOBA_ARCHETYPE_TANK
	icon_state = "boiler"
	ideal_roles = list(MOBA_LANE_TOP)
	starting_health = 575
	ending_health = 2300
	starting_health_regen = 2
	ending_health_regen = 8
	starting_plasma = 350
	ending_plasma = 875
	starting_plasma_regen = 1.4
	ending_plasma_regen = 3.5
	starting_armor = 0
	ending_armor = 15
	starting_acid_armor = 5
	ending_acid_armor = 20
	speed = 0.9
	attack_delay_modifier = 0
	starting_attack_damage = 37.5
	ending_attack_damage = 52.5
	abilities_to_add = list(
		/datum/action/xeno_action/onclick/toggle_acid_trail,
		/datum/action/xeno_action/activable/moba_fling,
		/datum/action/xeno_action/onclick/slowing_excretion,
		/datum/action/xeno_action/onclick/overdrive,
	)

/datum/moba_caste/boiler/apply_caste(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/player_component, datum/moba_player/player_datum)
	. = ..()
	RegisterSignal(xeno, COMSIG_MOB_TAKE_DAMAGE, PROC_REF(on_damage))
	RegisterSignal(xeno, COMSIG_MOB_DEATH, PROC_REF(on_death))

/datum/moba_caste/boiler/proc/on_damage(mob/living/carbon/xenomorph/source, list/damagedata, damagetype)
	SIGNAL_HANDLER

	switch(source.health / source.getMaxHealth())
		if(0 to 0.25)
			source.apply_status_effect(/datum/status_effect/speed_boost, -0.5)
		if(0.25 to 0.5)
			source.apply_status_effect(/datum/status_effect/speed_boost, -0.3)
		if(0.5 to 0.75)
			source.apply_status_effect(/datum/status_effect/speed_boost, -0.2)
		if(0.75 to 1)
			source.apply_status_effect(/datum/status_effect/speed_boost, -0.1)

/*datum/moba_caste/boiler/proc/on_death(mob/living/carbon/xenomorph/source, gibbed)
	SIGNAL_HANDLER

	var/datum/cause_data/cause_data = create_cause_data("acid shroud gas", owner)
	spicy_gas.set_up(1, 0, get_turf(xeno), null, 6, new_cause_data = cause_data)
	spicy_gas.start()*/

/datum/action/xeno_action/onclick/toggle_acid_trail
	name = "Gas Trail"
	action_icon_state = "dump_acid"
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 15
	var/trailing = FALSE
	var/damage_over_time = 5

/datum/action/xeno_action/onclick/toggle_acid_trail/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!trailing && !check_and_use_plasma_owner())
		return

	if(!xeno.check_state())
		return

	if(trailing)
		stop_trailing()
		return
	start_trailing()
	return ..()

/datum/action/xeno_action/onclick/toggle_acid_trail/proc/start_trailing()
	trailing = TRUE
	START_PROCESSING(SSfastobj, src)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	owner.visible_message(SPAN_NOTICE("[owner] starts releasing a trail of acid gas."),
		SPAN_NOTICE("We start releasing a trail of acid gas."), null, 5)
	button.icon_state = "template_active"

/datum/action/xeno_action/onclick/toggle_acid_trail/proc/stop_trailing()
	trailing = FALSE
	STOP_PROCESSING(SSfastobj, src)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	owner.visible_message(SPAN_NOTICE("[owner] stops releasing a trail of acid gas."),
		SPAN_NOTICE("We stop releasing a trail of acid gas."), null, 5)
	button.icon_state = "template"

/datum/action/xeno_action/onclick/toggle_acid_trail/process(delta_time)
	if(!check_and_use_plasma_owner(floor(plasma_cost * 0.5)))
		stop_trailing()
		return

	generate_smoke()

/datum/action/xeno_action/onclick/toggle_acid_trail/proc/on_move(datum/source, atom/mover, dir, forced)
	SIGNAL_HANDLER

	generate_smoke()

/datum/action/xeno_action/onclick/toggle_acid_trail/proc/generate_smoke()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!locate(/obj/effect/particle_effect/smoke/xeno_burn/moba) in owner.loc)
		var/obj/effect/particle_effect/smoke/xeno_burn/moba/gas = new(owner.loc)
		gas.cause_data = create_cause_data("gas trail", owner)
		var/list/ap_list = list()
		SEND_SIGNAL(owner, COMSIG_MOBA_GET_AP, ap_list)
		var/list/pen_list = list()
		SEND_SIGNAL(owner, COMSIG_MOBA_GET_ACID_PENETRATION, pen_list)
		gas.penetration = pen_list[1]
		gas.poison_dot = damage_over_time + (ap_list[1] * 0.15)
		gas.color = xeno.hive.color
		gas.friendly_hive = xeno.hivenumber


/datum/action/xeno_action/onclick/toggle_acid_trail/level_up_ability(new_level)
	switch(new_level)
		if(2)
			plasma_cost = 13
			damage_over_time = 7.5
		if(3)
			plasma_cost = 10
			damage_over_time = 10

	desc = "Toggle the release of a trail of acid gas behind you that lingers for 3 seconds. Any enemies stepping into the trail become poisoned for 2 seconds, taking [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 5, 7.5, 10)] (+15% AP) acid damage every 0.2 seconds. Plasma cost of [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 15, 13, 10)] per second."


/datum/action/xeno_action/onclick/slowing_excretion
	name = "Slowing Excretion"
	action_icon_state = "resin_pit"
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 60
	xeno_cooldown = 12 SECONDS
	var/slow = 0.5

/datum/action/xeno_action/onclick/slowing_excretion/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] excretes a brown fluid!"),
	SPAN_XENOWARNING("We excrete a slowing solution."))

	for(var/turf/open/tile in range(1, xeno))
		new /obj/effect/xenomorph/slowing_excretion(tile, slow, xeno.hivenumber)

	playsound(xeno, 'sound/effects/refill.ogg', 25, 1)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/slowing_excretion/level_up_ability(new_level)
	xeno_cooldown = src::xeno_cooldown - ((1 SECONDS) * (new_level - 1))
	slow = src::slow + (0.2 * (new_level - 1))
	plasma_cost = src::plasma_cost + (20 * (new_level - 1))

	desc = "Release slowing secretions in a 1 tile radius centered on yourself, lingering for 3 seconds. All enemies that step into the secretions are slowed by [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "0.5", "0.7", "0.9")] while they remain inside of it. Cooldown of [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "12", "11", "10")] seconds. Plasma cost [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "60", "80", "100")]."


/obj/effect/xenomorph/slowing_excretion
	name = "excretion"
	desc = "A thick, bubbling secretion of... something."
	icon_state = "secretions"
	layer = BELOW_MOB_LAYER
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	unacidable = TRUE
	var/slow_amount = 0.5
	var/friendly_hive

/obj/effect/xenomorph/slowing_excretion/Initialize(mapload, slow_amount = 0.5, hivenumber)
	. = ..()
	src.slow_amount = slow_amount
	friendly_hive = hivenumber
	QDEL_IN(src, 3 SECONDS)
	START_PROCESSING(SSfastobj, src)
	var/turf/our_turf = get_turf(src)
	RegisterSignal(our_turf, COMSIG_TURF_ENTERED, PROC_REF(on_enter))

/obj/effect/xenomorph/slowing_excretion/Destroy(force)
	STOP_PROCESSING(SSfastobj, src)
	return ..()

/obj/effect/xenomorph/slowing_excretion/proc/on_enter(datum/source, atom/movable/mover)
	SIGNAL_HANDLER

	if(isliving(mover))
		var/mob/living/living_mover = mover
		if(living_mover.ally_of_hivenumber(friendly_hive))
			return

		living_mover.apply_status_effect(/datum/status_effect/slow/replace, slow_amount, 1 SECONDS)

/obj/effect/xenomorph/slowing_excretion/process()
	for(var/mob/living/person in loc)
		if(person.ally_of_hivenumber(friendly_hive))
			return

		person.apply_status_effect(/datum/status_effect/slow/replace, slow_amount, 1 SECONDS)


/datum/action/xeno_action/activable/moba_fling
	name = "Fling"
	action_icon_state = "fling"
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 10 SECONDS
	plasma_cost = 100
	var/fling_damage = 50

/datum/action/xeno_action/activable/moba_fling/use_ability(atom/target_atom)
	if(!action_cooldown_check())
		return

	var/mob/living/carbon/xenomorph/xeno = owner

	if(!isliving(target_atom))
		return

	var/mob/living/target_living = target_atom

	if(xeno.can_not_harm(target_living))
		return

	if(!xeno.Adjacent(target_living))
		to_chat(xeno, SPAN_XENODANGER("They have to be closer to us!"))
		return

	if(!xeno.check_state())
		return

	xeno.setDir(get_cardinal_dir(xeno, target_living))

	var/dir_to_fling = get_dir(target_living, xeno)
	var/turfs_travelled = 1
	var/turf/open/turf_to_fling_to = get_turf(xeno)
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
	target_living.Stun(1)
	xeno.Root(1)

	var/list/acidpen_list = list()
	SEND_SIGNAL(xeno, COMSIG_MOBA_GET_ACID_PENETRATION, acidpen_list)
	var/list/ap_list = list()
	SEND_SIGNAL(xeno, COMSIG_MOBA_GET_AP, ap_list)
	target_living.apply_armoured_damage(fling_damage + (target_living.getMaxHealth() * 0.07) + (ap_list[1] * 0.6), ARMOR_MELEE, BURN, penetration = acidpen_list[1])

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

	SEND_SIGNAL(xeno, COMSIG_XENO_PHYSICAL_ABILITY_HIT, target_living)
	addtimer(CALLBACK(src, PROC_REF(end_fling), target_living, old_layer, old_pixel_x, old_pixel_y), 0.6 SECONDS)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/moba_fling/proc/end_fling(mob/living/target_living, original_layer, old_px, old_py)
	var/mob/living/carbon/xenomorph/xeno = owner
	target_living.SetStun(0)
	if(locate(/obj/effect/xenomorph/slowing_excretion) in get_turf(target_living))
		target_living.Root(2)
	xeno.SetRoot(0)
	target_living.layer = original_layer
	target_living.pixel_x = old_px
	target_living.pixel_y = old_py

/datum/action/xeno_action/activable/moba_fling/level_up_ability(new_level)
	xeno_cooldown = src::xeno_cooldown - (new_level - 1)
	plasma_cost = src::plasma_cost - ((new_level - 1) * 20)
	fling_damage = src::fling_damage + ((new_level - 1) * 20)

	desc = "Fling a target several tiles behind you, dealing [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 50, 70, 90)] (+60% AP) (+7% Target Max HP) acid damage to a target. Cooldown [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 10, 9, 8)] seconds. Plasma cost [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 100, 80, 60)]."

/datum/action/xeno_action/onclick/overdrive
	name = "Overdrive"
	action_icon_state = "empower"
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_4
	plasma_cost = 100
	xeno_cooldown = 100 SECONDS
	var/acid_power = 33
	var/movespeed_bonus = -0.2
	var/armor_bonus = 10
	var/health_plasma_regen_bonus = 7

/datum/action/xeno_action/onclick/overdrive/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	xeno.apply_status_effect(/datum/status_effect/overdrive, acid_power, movespeed_bonus, armor_bonus, health_plasma_regen_bonus)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/overdrive/level_up_ability(new_level)
	switch(new_level)
		if(2)
			acid_power = 66
			movespeed_bonus = -0.4
			armor_bonus = 20
			health_plasma_regen_bonus = 14
		if(3)
			acid_power = 100
			movespeed_bonus = -0.6
			armor_bonus = 30
			health_plasma_regen_bonus = 25

	desc = "Go into overdrive mode, gaining [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 33, 66, 100)] acid power, [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, -0.2, -0.4, -0.6)] movespeed, [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 10, 20, 30)] armor and acid armor, and [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 7, 14, 25)] health and plasma regeneration for 20 seconds. Cooldown of 100 seconds. Plasma cost 100."
