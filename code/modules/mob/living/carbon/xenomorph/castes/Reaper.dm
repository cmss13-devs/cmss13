/datum/caste_datum/reaper
	caste_type = XENO_CASTE_REAPER
	caste_desc = "A resource hauler and frontline support."
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_10
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_6
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_3

	behavior_delegate_type = /datum/behavior_delegate/base_reaper

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_CARRIER)
	throwspeed = SPEED_AVERAGE
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_ONE_HAND
	weed_level = WEED_LEVEL_STANDARD

	hugger_nurturing = TRUE

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 35
	tacklestrength_min = 4
	tacklestrength_max = 5

	aura_strength = 3

	minimum_evolve_time = 15 MINUTES

	minimap_icon = "reaper"

/mob/living/carbon/xenomorph/reaper
	caste_type = XENO_CASTE_REAPER
	name = XENO_CASTE_REAPER
	desc = "A large gangly alien with a grim visage. Smells of death."
	icon_size = 64
	icon_xeno = 'icons/mob/xenos/castes/tier_3/reaper.dmi'
	icon_state = "Reaper Walking"
	plasma_types = list(PLASMA_PURPLE, PLASMA_PHEROMONE)

	drag_delay = 6

	mob_size = MOB_SIZE_BIG
	tier = 3
	pixel_x = -16
	old_x = -16

	organ_value = 3000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/place_construction/not_primary,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/activable/retrieve_hugger_egg,
		/datum/action/xeno_action/onclick/set_hugger_reserve,
		/datum/action/xeno_action/activable/reap, //second macro
		/datum/action/xeno_action/activable/breath_miasma, //third macro
		/datum/action/xeno_action/activable/replenish, //fourth macro
	)

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Reaper_1","Reaper_2","Reaper_3")
	weed_food_states_flipped = list("Reaper_1","Reaper_2","Reaper_3")

	huggers_max = 16
	eggs_max = 4

	// Reaper vars
	var/flesh_plasma = 0
	var/flesh_plasma_max = 600

	/// List of dead bodies logged on this tick and added to valid_corpses
	var/list/currently_nearby_corpses = list()
	/// List of dead bodies that were logged the previous tick
	var/list/previously_nearby_corpses = list()
	/// List of corpses that are valid for generating Flesh Plasma, number gathered through length()
	var/list/valid_corpses = list()
	/// Within how many tiles of you do corpses need to be for you to generate flesh plasma off them
	var/nearby_corpse_range = 3

	// Let them know how much they've healed over Xenos for
	var/transferred_healing = 0

/mob/living/carbon/xenomorph/reaper/get_status_tab_items()
	. = ..()
	. += "Flesh Plasma: [flesh_plasma]/[flesh_plasma_max]"
	. += "Healing Done: [transferred_healing]"

/mob/living/carbon/xenomorph/reaper/proc/modify_flesh_plasma(amount)
	flesh_plasma += amount
	if(flesh_plasma > flesh_plasma_max)
		flesh_plasma = flesh_plasma_max
	if(flesh_plasma < 0)
		flesh_plasma = 0

/mob/living/carbon/xenomorph/reaper/proc/corpse_generation()
	var/obj/effect/alien/weeds/our_weeds = locate() in loc
	// We must be on weeds belonging to our hive to generate flesh plasma from nearby corpses
	if(our_weeds && our_weeds.hivenumber == hivenumber)
		for(var/mob/living/carbon/dead_mob in view(nearby_corpse_range, src))
			// If they are not dead, they are not valid
			if(dead_mob.stat != DEAD)
				continue

			// Synths are not organic, they are not valid
			if(issynth(dead_mob))
				continue

			var/obj/effect/alien/weeds/their_weeds = locate() in dead_mob.loc
			// If they are not on weeds belonging to our hive, they are not valid
			if(!their_weeds || (their_weeds && their_weeds.hivenumber != hivenumber))
				continue

			// Add them to list of currently nearby corpses for referancing later
			currently_nearby_corpses.Add(dead_mob)
			// If they are not already in valid_corpses, add them
			if(!(dead_mob in valid_corpses))
				valid_corpses.Add(dead_mob)

	// Now we check for corpses that aren't in range anymore
	for(var/mob/living/carbon/dead_mob in valid_corpses)
		// If the mob is in previously_nearby and not in currently_nearby, it's not nearby anymore
		if((dead_mob in previously_nearby_corpses) && !(dead_mob in currently_nearby_corpses))
			valid_corpses.Remove(dead_mob)
		// Same thing if it's not in either
		if(!(dead_mob in previously_nearby_corpses) && !(dead_mob in currently_nearby_corpses))
			valid_corpses.Remove(dead_mob)

	var/final_corpse_gen_number = length(valid_corpses)
	modify_flesh_plasma(final_corpse_gen_number)
	previously_nearby_corpses = currently_nearby_corpses
	currently_nearby_corpses.Cut()

/mob/living/carbon/xenomorph/reaper/try_fill_trap(obj/effect/alien/resin/trap/target)
	if(!istype(target))
		return FALSE

	if(flesh_plasma < 100)
		to_chat(src, SPAN_XENOWARNING("We do not have enough flesh plasma for this, we need [100 - flesh_plasma] more."))
		return FALSE

	to_chat(src, SPAN_XENONOTICE("We begin charging the resin trap with toxic mist."))
	xeno_attack_delay(src)
	if(!do_after(src, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, src))
		return FALSE

	if(flesh_plasma < 100)
		return FALSE

	target.smoke_system = new /datum/effect_system/smoke_spread/reaper_mist()
	flesh_plasma -= 100

	target.cause_data = create_cause_data("resin mist trap", src)
	target.setup_tripwires()
	target.set_state(RESIN_TRAP_MIST)

	playsound(loc, 'sound/effects/refill.ogg', 25, 1)
	visible_message(SPAN_XENOWARNING("[src] pressurises the resin trap with toxic mist!"), \
	SPAN_XENOWARNING("We pressurise the resin trap with toxic mist!"), null, 5)
	return TRUE

/datum/behavior_delegate/base_reaper
	name = "Base Reaper Behavior Delegate"

	var/flesh_plasma_slash = 3 /// How much flesh plasma is generated on a slash
	var/flesh_plasma_kill = 15 /// How much flesh plasma is generated on a kill

/datum/behavior_delegate/base_reaper/melee_attack_additional_effects_target(mob/living/carbon/target_mob)
	var/mob/living/carbon/xenomorph/reaper/reaper = bound_xeno
	reaper.modify_flesh_plasma(flesh_plasma_slash)

/datum/behavior_delegate/base_reaper/on_kill_mob()
	var/mob/living/carbon/xenomorph/reaper/reaper = bound_xeno
	reaper.modify_flesh_plasma(flesh_plasma_kill)

/datum/behavior_delegate/base_reaper/on_life()
	var/mob/living/carbon/xenomorph/reaper/reaper = bound_xeno

	reaper.corpse_generation()

	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_flesh = round((reaper.flesh_plasma / reaper.flesh_plasma_max) * 100, 10)
	if(percentage_flesh)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_flesh]")

/datum/behavior_delegate/base_reaper/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

// Powers
/datum/action/xeno_action/activable/reap/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/carbon = target

	if(!action_cooldown_check() || !xeno.check_state())
		return

	if(!isxeno_human(carbon) || xeno.can_not_harm(carbon) || carbon.stat == DEAD || (HAS_TRAIT(carbon, TRAIT_NESTED)))
		return

	if(get_dist(xeno, target) > range)
		to_chat(xeno, SPAN_WARNING("They are too far away!"))
		return

	if(!check_and_use_plasma_owner())
		return

	var/list/turf/path = get_line(xeno, carbon, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(xeno, SPAN_WARNING("There's something blocking our strike!"))
			return
		for(var/obj/path_contents in path_turf.contents)
			if(path_contents != carbon && path_contents.density && !path_contents.throwpass)
				to_chat(xeno, SPAN_WARNING("There's something blocking our strike!"))
				return

		var/atom/barrier = path_turf.handle_barriers(xeno, null, (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			to_chat(xeno, SPAN_WARNING("There's something blocking our strike!"))
			return
		for(var/obj/structure/current_structure in path_turf)
			if(current_structure.density && !current_structure.throwpass)
				to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
				return

	var/obj/limb/target_limb = carbon.get_limb(check_zone(xeno.zone_selected))
	if(ishuman(carbon) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = carbon.get_limb("chest")

	xeno.face_atom(carbon)
	xeno.animation_attack_on(carbon)
	xeno.flick_attack_overlay(carbon, "slash")
	playsound(carbon, 'sound/weapons/alien_tail_attack.ogg', 50, TRUE)
	xeno.visible_message(SPAN_XENOWARNING("[xeno] swings its large claws at [carbon], slicing them in the [target_limb ? target_limb.display_name : "chest"]!"), \
	SPAN_XENOWARNING("We slice [carbon] in the [target_limb ? target_limb.display_name : "chest"]!"))

	var/damage = (xeno.melee_damage_upper + xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER)
	carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")
	carbon.apply_effect(1, DAZE)

	for(var/datum/reagent/toxin/sepsicine/sepsis in carbon.reagents.reagent_list)
		xeno.modify_flesh_plasma(flesh_plasma_from_plagued_target)

	shake_camera(target, 2, 1)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/breath_miasma/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner

	if(!action_cooldown_check() || !xeno.check_state())
		return

	if(xeno.flesh_plasma < flesh_plasma_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh plasma, we need [flesh_plasma_cost - xeno.flesh_plasma] more!"))
		return

	if(!check_and_use_plasma_owner())
		return

	xeno.face_atom(target)
	xeno.emote("hiss")
	xeno.visible_message(SPAN_XENOWARNING("[xeno] belches a sickly greenish mist!"), \
		SPAN_XENOWARNING("We breath a cloud of evaporated flesh plasma!"))

	xeno.modify_flesh_plasma(-flesh_plasma_cost)
	apply_cooldown()

	INVOKE_ASYNC(src, PROC_REF(handle_miasma_travel), target)

	return ..()

/datum/action/xeno_action/activable/breath_miasma/proc/handle_miasma_travel(atom/target)
	// Credit to iloveloopers for Flamer Smoke code which I have modified for this to work
	var/datum/cause_data/cause_data = create_cause_data("reaper mist", owner)
	var/source_turf = get_turf(owner)
	var/distance_travelled = 0
	var/turf/turfs[] = get_line(owner, target, FALSE)
	for(var/turf/turf in turfs)
		if(distance_travelled >= breath_range)
			break

		if(turf.density)
			break
		else
			var/obj/effect/particle_effect/smoke/checker = new()
			var/atom/blocked = LinkBlocked(checker, source_turf, turf)
			if(blocked)
				break

		// playsound(turf, '', 5, 1) Put in some nice sounding hiss soundeffect later
		var/datum/effect_system/smoke_spread/reaper_mist/miasma = new()
		miasma.set_up(2, 0, turf, null, cloud_duration, new_cause_data = cause_data)
		miasma.start()
		sleep(5)

		distance_travelled++

/datum/action/xeno_action/activable/replenish/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner

	if(!action_cooldown_check() || !xeno.check_state() || target == xeno)
		return

	if(!check_plasma_owner())
		return

	var/obj/effect/alien/weeds/user_weeds_loc = locate() in xeno.loc
	var/obj/effect/alien/weeds/target_weeds_loc = locate() in target.loc
	var/plasma_cost_mult = plas_mod
	var/mob/living/carbon/xenomorph/xeno_carbon = target

	var/distance = get_dist(xeno, target)

	if(distance > range)
		return

	if(!xeno.Adjacent(target))
		plasma_cost_mult = 1  // We want xenos not within touching distance to cost more plasma

	if(!xeno.can_not_harm(xeno_carbon))
		to_chat(xeno, SPAN_XENODANGER("We must target one of our sisters!"))
		return

	if(xeno_carbon.stat == DEAD)
		to_chat(xeno, SPAN_XENODANGER("We cannot heal the dead!"))
		return

	if(xeno_carbon.health >= xeno_carbon.maxHealth)
		to_chat(xeno, SPAN_XENOWARNING("[xeno_carbon] is already at max health!"))
		return

	if(SEND_SIGNAL(xeno_carbon, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		to_chat(xeno, SPAN_XENOWARNING("We cannot help [xeno_carbon] when they're on fire!"))
		return

	if(xeno.flesh_plasma < flesh_plasma_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh plasma, we need [flesh_plasma_cost - xeno.flesh_plasma] more!"))
		return

	if(!xeno.Adjacent(target) && (!user_weeds_loc || !target_weeds_loc || (!(HIVE_ALLIED_TO_HIVE(xeno.hive, user_weeds_loc.linked_hive)) && !(HIVE_ALLIED_TO_HIVE(xeno.hive, target_weeds_loc.linked_hive)))))
		to_chat(xeno, SPAN_XENOWARNING("We must either be adjacent to our target or both of us must be on allied weeds!"))
		return

	var/recovery_amount = xeno_carbon.maxHealth * 0.15 // 15% of the Xeno's max health feels like a good value for semi-ranged healing

	if(islarva(xeno_carbon) && islesserdrone(xeno_carbon))
		recovery_amount = xeno_carbon.maxHealth * 0.3 // 15% on these ones ain't much, so let them get 30% instead

	else if(isqueen(xeno_carbon) || isking(xeno_carbon))
		recovery_amount = xeno_carbon.maxHealth * 0.10 // Reduced to 10% since a mature Queen has 1k health

	else if(isfacehugger(xeno_carbon))
		recovery_amount = xeno_carbon.maxHealth // Can as well just fully heal huggers if you choose to waste the flesh plasma on them

	if(xeno_carbon.health < 0)
		recovery_amount = (xeno_carbon.maxHealth * 0.05) + abs(xeno_carbon.health) // If they're in crit, get them out of it but heal less

	if(isfacehugger(xeno_carbon))
		xeno_carbon.gain_health(recovery_amount) // Can also as well just instantly heal the Hugger
		xeno_carbon.updatehealth()
	else
		// For a Drone target: 75 health, 15 per second
		// For a Ravager target: 97.5 health, 19.5 per second
		// For a Crusher target: 105 health, 21 per second

		// Healer Drone is still better at large amounts of healing thanks to 10x shorter CD
		// Valkyrie is better for groups fighting off weeds thanks to AOE healing with every slash
		// With the semi-ranged nature and not needing to lose health to give it, this should be good for prolonging lifespans steadily and stably
		new /datum/effects/heal_over_time(xeno_carbon, heal_amount = recovery_amount)
	xeno_carbon.xeno_jitter(1 SECONDS)
	xeno_carbon.flick_heal_overlay(2.5 SECONDS, "#c5bc81")
	xeno.transferred_healing += recovery_amount

	if(xeno.Adjacent(xeno_carbon))
		xeno.visible_message(SPAN_XENOWARNING("[xeno] smears a foul-smelling ooze onto [xeno_carbon]s wounds, causing them to rapidly close!"), \
		SPAN_XENOWARNING("We use flesh plasma to heal [xeno_carbon]s wounds!"))
		to_chat(xeno_carbon, SPAN_XENOWARNING("[xeno] smears a pale ooze onto our wounds, causing them to close up faster!"))

	else if(!xeno.Adjacent(xeno_carbon))
		xeno.visible_message(SPAN_XENOWARNING("The weeds between [xeno] and [xeno_carbon] ripple and emit a foul scent as [xeno_carbon]s wounds to rapidly close!"), \
		SPAN_XENOWARNING("We channel flesh plasma to heal [xeno_carbon]s wounds from afar!"))
		to_chat(xeno_carbon, SPAN_XENOWARNING("The weeds beneath us shudder as a pale ooze forms on our wounds, causing them to close up faster!"))

	xeno.face_atom(xeno_carbon)
	use_plasma_owner(plasma_cost * plasma_cost_mult)
	xeno.modify_flesh_plasma(-flesh_plasma_cost)
	apply_cooldown()
	return ..()
