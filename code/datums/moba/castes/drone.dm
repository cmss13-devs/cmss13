/datum/moba_caste/drone
	equivalent_caste_path = /datum/caste_datum/drone
	equivalent_xeno_path = /mob/living/carbon/xenomorph/drone
	name = XENO_CASTE_DRONE
	desc = {"
		Supportive caste focused on healing allies while providing some offensive power.<br>
		<b>P:</b> Gain wards as a team faster and increase your team's ward capacity by 1.<br>
		<b>1:</b> Ready your tail to stab, giving your next attack increased range, attack damage, and daze.<br>
		<b>2:</b> Plant an empowering pillar that grows over a short period, granting nearby allies increased speed.<br>
		<b>3:</b> Create a beam between you and an ally, regenerating their health over time at the cost of plasma.<br>
		<b>U:</b> After a channel, heal all nearby allies for a portion of their max health.
	"}
	category = MOBA_ARCHETYPE_CONTROLLER
	icon_state = "drone"
	ideal_roles = list(MOBA_LANE_SUPPORT)
	starting_health = 450
	ending_health = 1500
	starting_health_regen = 1.5
	ending_health_regen = 6
	starting_plasma = 400
	ending_plasma = 800
	starting_plasma_regen = 2.4
	ending_plasma_regen = 7.2
	starting_armor = 0
	ending_armor = 15
	starting_acid_armor = 0
	ending_acid_armor = 10
	speed = 0.5
	attack_delay_modifier = 0
	starting_attack_damage = 37.5
	ending_attack_damage = 60
	abilities_to_add = list(
		/datum/action/xeno_action/activable/tail_stab/moba,
		/datum/action/xeno_action/activable/spore_fruit,
		/datum/action/xeno_action/activable/life_transfer,
		/datum/action/xeno_action/onclick/rejuvenation_burst,
	)

/datum/action/xeno_action/activable/tail_stab/moba
	name = "Tail Stab"
	desc = "Ready your tail over 1.5 / 1 / 0.7 seconds to stab an enemy. This stab reaches two tiles and does 1.2x/1.4x/1.6x your attack damage while dazing the target for 0.2 / 0.3 / 0.4 seconds."
	action_icon_state = "tail_attack"
	action_type = XENO_ACTION_CLICK
	charge_time = 1.5 SECONDS
	xeno_cooldown = 14 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 60
	stab_range = 2
	limb_targetting = FALSE
	var/damage_multiplier = 1.2
	var/daze_length = 0.2 SECONDS

/datum/action/xeno_action/activable/tail_stab/moba/level_up_ability(new_level)
	if(new_level == 2)
		charge_time = 1 SECONDS
	else if(new_level == 3)
		charge_time = 0.7 SECONDS
	xeno_cooldown = src::xeno_cooldown - ((3 SECONDS) * (new_level - 1))
	damage_multiplier = src::damage_multiplier + (0.2 * (new_level - 1))
	daze_length = src::daze_length + (0.1 * (new_level - 1))

	desc = "Ready your tail over [new_level == 1 ? "<b>1.5</b>" : "1.5"] / [new_level == 2 ? "<b>1</b>" : "1"] / [new_level == 3 ? "<b>0.7</b>" : "0.7"] seconds to stab an enemy. This stab reaches two tiles and does [new_level == 1 ? "<b>1.2x</b>" : "1.2x"] / [new_level == 2 ? "<b>1.4x</b>" : "1.4x"] / [new_level == 3 ? "<b>1.6x</b>" : "1.6x"] your attack damage while dazing the target for [new_level == 1 ? "<b>0.2</b>" : "0.2"] / [new_level == 2 ? "<b>0.3</b>" : "0.3"] / [new_level == 3 ? "<b>0.4</b>" : "0.4"] seconds."

/datum/action/xeno_action/activable/tail_stab/moba/ability_act(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/target, obj/limb/limb)
	. = ..()
	if(!.)
		return
	// zonenote this doesn't apply armor pen
	SEND_SIGNAL(stabbing_xeno, COMSIG_XENO_PHYSICAL_ABILITY_HIT, target)

/datum/action/xeno_action/activable/tail_stab/moba/apply_damage(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/target, obj/limb/limb, damage)
	var/list/armorpen_list = list()
	SEND_SIGNAL(owner, COMSIG_MOBA_GET_PHYS_PENETRATION, armorpen_list)
	target.apply_armoured_damage(get_xeno_damage_slash(target, damage), ARMOR_MELEE, BRUTE, limb ? limb.name : "chest", armorpen_list[1])

/datum/action/xeno_action/activable/spore_fruit
	name = "Empowering Pillar"
	desc = "Plant an empowering pillar up to 2 tiles away. It grows over the course of 1.5 seconds. Once grown, it provides a -0.1/-0.2/-0.3 speed and a 0/0/-0.1 attack delay to all allies within 2 tiles and for 3 seconds after leaving its radius. It has 50/100/150 health and will decay after 15 seconds."
	action_icon_state = "gardener_plant"
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 30 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 100
	var/throw_range = 2 // Range
	var/speed_buff = -0.1
	var/fruit_health = 50
	var/attack_delay_buff = 0

/datum/action/xeno_action/activable/spore_fruit/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/fruit_planter = owner

	if(!fruit_planter.check_state())
		return

	if(get_dist(fruit_planter, targetted_atom) > throw_range)
		to_chat(fruit_planter, SPAN_WARNING("That's too far away."))
		return

	if(!targetted_atom)
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	new /obj/effect/alien/resin/construction/empower(targetted_atom, owner, fruit_planter.hive, speed_buff, attack_delay_buff, fruit_health)
	apply_cooldown()
	..()

/datum/action/xeno_action/activable/spore_fruit/level_up_ability(new_level)
	if(new_level == 2)
		speed_buff = -0.2
	else if(new_level == 3)
		speed_buff = -0.3
		attack_delay_buff = -1
	xeno_cooldown = src::xeno_cooldown - ((new_level - 1) * 5)
	fruit_health = src::fruit_health + ((new_level - 1) * 50)

	desc = "Plant a spore fruit up to 2 tiles away. It grows over the course of 1.5 seconds. Once grown, it provides a [new_level == 1 ? "<b>-0.1</b>" : "-0.1"]/[new_level == 2 ? "<b>-0.2</b>" : "-0.2"]/[new_level == 3 ? "<b>-0.3</b>" : "-0.3"] speed and a [new_level == 1 ? "<b>0</b>" : "0"]/[new_level == 2 ? "<b>0</b>" : "0"]/[new_level == 3 ? "<b>-0.1</b>" : "-0.1"] attack delay to all allies within 2 tiles and for 3 seconds after leaving its radius. It has [new_level == 1 ? "<b>50</b>" : "50"]/[new_level == 2 ? "<b>100</b>" : "100"]/[new_level == 3 ? "<b>150</b>" : "150"] health and will decay after 15 seconds."

/obj/effect/alien/resin/construction/empower
	name = "empowering pillar"
	icon = 'icons/obj/structures/alien/structures64x64.dmi'
	icon_state = "resin_pillar_OLD"
	pixel_x = -16
	pixel_y = -16
	var/buff_duration = 3 SECONDS // seconds of buff they get once they leave the fruit, buffs cannot be re-applied if they are still in the fruit WHILE they have a buff, so its not really infinite but it refreshes once it runs out.
	var/grown = FALSE
	var/hivenumber
	var/speed_buff
	var/attack_delay_buff

/obj/effect/alien/resin/construction/empower/Initialize(mapload, mob/living/carbon/xenomorph/caster, datum/hive_status/hive, speed_buff, attack_delay_buff, fruit_health)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(finish_growing)), 1.5 SECONDS)
	hivenumber = hive.hivenumber
	src.speed_buff = speed_buff
	src.attack_delay_buff = attack_delay_buff
	health = fruit_health
	visible_message(SPAN_WARNING("[caster] raises [src] out of the ground!"))

/obj/effect/alien/resin/construction/empower/proc/decay()
	visible_message(SPAN_WARNING("[src] wilts and decays into nothing."))
	qdel(src)

/obj/effect/alien/resin/construction/empower/proc/finish_growing()
	visible_message(SPAN_WARNING("[src] strengthens, emitting pheromones!"))
	grown = TRUE
	icon_state = "resin_pillar_strong"
	addtimer(CALLBACK(src, PROC_REF(decay)), 15 SECONDS)
	for(var/turf/open/tile in range(2, src))
		RegisterSignal(tile, COMSIG_TURF_ENTERED, PROC_REF(on_turf_enter))

/obj/effect/alien/resin/construction/empower/proc/on_turf_enter(datum/source, atom/movable/mover)
	SIGNAL_HANDLER

	if(isxeno(mover))
		var/mob/living/carbon/xenomorph/target = mover
		if(target.hivenumber != hivenumber)
			return

		if(target.stat == DEAD)
			return

		target.apply_status_effect(/datum/status_effect/empowered, speed_buff, attack_delay_buff)

/datum/action/xeno_action/activable/life_transfer
	name = "Transfer Life"
	desc = "Create a beam between you and an ally, healing them for 100/125/150 (+40% AP) health every 6 seconds, consuming 60 plasma each time. Cooldown 15/12/9 seconds."
	action_icon_state = "apply_salve"
	xeno_cooldown = 10 SECONDS
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_3

	var/max_range = 1 // How much dist they can apply it in
	var/start_healing = FALSE
	var/datum/weakref/healer = null // healer
	var/datum/weakref/healing_target = null // heal target
	var/datum/weakref/beam_focus = null // the beam var
	var/health_to_transfer = 100
	var/plasma_per_tick = 60
	var/process_ticks = 0


/datum/action/xeno_action/activable/life_transfer/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/healer_xeno = owner
	var/mob/living/carbon/xenomorph/possible_healing_target = targetted_atom

	if(healing_target)
		var/mob/living/carbon/xenomorph/target = healing_target.resolve()
		if(!QDELETED(target))
			STOP_PROCESSING(SSobj, src)
			QDEL_NULL(beam_focus)
			healer = null
			healing_target = null
			to_chat(owner, SPAN_XENOWARNING("We break our life transferrance."))
			apply_cooldown()
			return

	if(!isxeno(possible_healing_target))
		return

	if(healer_xeno.hivenumber != possible_healing_target.hivenumber)
		to_chat(owner, SPAN_XENOWARNING("We need to target an ally."))
		return

	if(HAS_TRAIT(possible_healing_target, TRAIT_MOBA_MINION) || (possible_healing_target.stat == DEAD)) // So they dont heal minions
		return

	if(possible_healing_target == owner)
		to_chat(src, SPAN_XENOWARNING("We can't heal ourselves."))
		return

	if(get_dist(healer_xeno, possible_healing_target) > max_range)
		to_chat(healer_xeno, SPAN_XENOWARNING("We need to be next to an ally to start healing them."))
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	healer = WEAKREF(healer_xeno)
	healing_target = WEAKREF(possible_healing_target)

	if(do_after(healer_xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		var/datum/beam/heal_beam = possible_healing_target.beam(healer_xeno, "heal_beam", 'icons/effects/beam.dmi', BEAM_INFINITE_DURATION, beam_type = /obj/effect/ebeam/laser/weak)
		heal_beam.visuals.alpha = 0
		animate(heal_beam.visuals, alpha = initial(heal_beam.visuals.alpha), 3 SECONDS)
		beam_focus = WEAKREF(heal_beam)
		START_PROCESSING(SSobj, src)

	apply_cooldown(0.2) // largely just cosmetic to indicate the button did something
	return ..()

/datum/action/xeno_action/activable/life_transfer/process(delta_time)
	if(!healing_target)
		STOP_PROCESSING(SSobj, src)
		return

	process_ticks++
	if((process_ticks % 3) != 0)
		return

	var/mob/living/carbon/xenomorph/heal_target = healing_target.resolve()
	var/mob/living/carbon/xenomorph/drone_healer = healer.resolve()
	var/datum/beam/beam = beam_focus.resolve()
	var/healing_range = 7 // Screenwide
	if(QDELETED(heal_target) || QDELETED(drone_healer) || QDELETED(beam) || (heal_target.stat == DEAD) || (drone_healer.stat == DEAD))
		STOP_PROCESSING(SSobj, src)
		QDEL_NULL(beam_focus)
		healer = null
		healing_target = null
		apply_cooldown()
		return

	if(get_dist(drone_healer, heal_target) > healing_range)
		to_chat(owner, SPAN_XENOWARNING("We have gotten out of range and have canceled our life transference."))
		STOP_PROCESSING(SSobj, src)
		QDEL_NULL(beam_focus)
		healer = null
		healing_target = null
		apply_cooldown()
		return

	if(!check_and_use_plasma_owner(plasma_per_tick))
		to_chat(owner, SPAN_XENOWARNING("We are out of plasma and have canceled our life transference."))
		STOP_PROCESSING(SSobj, src)
		QDEL_NULL(beam_focus)
		healer = null
		healing_target = null
		apply_cooldown()
		return

	var/list/ap_list = list()
	SEND_SIGNAL(owner, COMSIG_MOBA_GET_AP, ap_list)
	heal_target.gain_health((health_to_transfer + (ap_list[1] * 0.4)) * delta_time)
	heal_target.flick_heal_overlay(1.5 SECONDS, "#0e9b09")

/datum/action/xeno_action/activable/life_transfer/level_up_ability(new_level)
	if(new_level == 2)
		health_to_transfer = 125
		xeno_cooldown = 12 SECONDS
	else if(new_level == 3)
		health_to_transfer = 150
		xeno_cooldown = 9 SECONDS

	desc = "Create a beam between you and an ally, healing them for [new_level == 1 ? "<b>100</b>" : "100"]/[new_level == 2 ? "<b>125</b>" : "125"]/[new_level == 3 ? "<b>150</b>" : "150"] (+40% AP) health every 6 seconds, consuming 60 plasma each time. Cooldown [new_level == 1 ? "<b>15</b>" : "15"]/[new_level == 2 ? "<b>12</b>" : "12"]/[new_level == 3 ? "<b>9</b>" : "9"] seconds."

/datum/action/xeno_action/onclick/rejuvenation_burst
	name = "Rejuvenation Burst"
	desc = "After a 3 second channel, all allied xenos within 4 tiles of you are healed for 15/25/35% (+5% AP) of their max HP. Cooldown 150/120/100 seconds."
	action_icon_state = "screech"
	xeno_cooldown = 130 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_4
	//macro_path = /datum/action/xeno_action/verb/verb_rejuvenation_burst
	plasma_cost = 250
	var/range_to_heal = 4
	var/channel_duration = 3 SECONDS
	var/health_percentage = 0.15
	var/in_use = FALSE

/datum/action/xeno_action/onclick/rejuvenation_burst/use_ability()
	var/mob/living/carbon/xenomorph/support_drone = owner

	if(in_use)
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	in_use = TRUE
	if(do_after(support_drone, channel_duration, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		for(var/mob/living/carbon/xenomorph/alive_targets in orange(support_drone, range_to_heal))
			if(alive_targets.stat == DEAD)
				continue

			if(alive_targets.hivenumber != support_drone.hivenumber)
				continue

			if(HAS_TRAIT(alive_targets, TRAIT_MOBA_MINION)) // So they dont heal minions
				continue

			var/list/ap_list = list()
			SEND_SIGNAL(owner, COMSIG_MOBA_GET_AP, ap_list)
			alive_targets.gain_health(alive_targets.maxHealth * (health_percentage + (ap_list[1] * 0.05 * 0.01))) // 0.01 so that 200 AP becomes 10 becomes .10
			alive_targets.flick_heal_overlay(2 SECONDS, "#34bb19")
		new /obj/effect/xenomorph/xeno_telegraph/drone_heal_template(get_turf(support_drone), 20)
		playsound(get_turf(support_drone), 'sound/voice/xenos_roaring.ogg', 125)

	apply_cooldown() // Sucks to hear you got interrupted. Oh well!
	in_use = FALSE
	return ..()



/datum/action/xeno_action/onclick/rejuvenation_burst/level_up_ability(new_level)
	if(new_level == 2)
		health_percentage = 0.25
		xeno_cooldown = 120 SECONDS
		plasma_cost = 350
	else if (new_level == 3)
		health_percentage = 0.35
		xeno_cooldown = 100 SECONDS
		plasma_cost = 450

	desc = "After a 3 second channel, all allied xenos within 4 tiles of you are healed for [new_level == 1 ? "<b>15</b>" : "15"]/[new_level == 2 ? "<b>25</b>" : "25"]/[new_level == 3 ? "<b>35</b>" : "35"] (+5% AP) of their max HP. Cooldown [new_level == 1 ? "<b>150</b>" : "150"]/[new_level == 2 ? "<b>120</b>" : "120"]/[new_level == 3 ? "<b>100</b>" : "100"] seconds."

/obj/effect/xenomorph/xeno_telegraph/drone_heal_template
	icon = 'icons/effects/96x96.dmi'
	icon_state = "xenolanding"
	layer = BELOW_MOB_LAYER
	pixel_x = -24
	pixel_y = -24
