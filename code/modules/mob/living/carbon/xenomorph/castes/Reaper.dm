/datum/caste_datum/reaper
	caste_type = XENO_CASTE_REAPER
	caste_desc = "A flexible frontline supporter."
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_6
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

	huggers_max = 12
	eggs_max = 12

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
	desc = "A large gangly alien with a grim visage. The stench of rot follows it wherever it goes."
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
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/place_construction/not_primary,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/activable/retrieve_hugger_egg,
		/datum/action/xeno_action/onclick/set_hugger_reserve_reaper,
		/datum/action/xeno_action/activable/haul_corpse,
		/datum/action/xeno_action/activable/flesh_harvest, //second macro
		/datum/action/xeno_action/activable/replenish, //third macro
		/datum/action/xeno_action/onclick/emit_mist, //fourth macro
		/datum/action/xeno_action/onclick/tacmap,
	)

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Reaper_1","Reaper_2","Reaper_3")
	weed_food_states_flipped = list("Reaper_1","Reaper_2","Reaper_3")

	// Borrowed Carrier vars
	var/huggers_reserved = 0
	var/huggers_cur = 0
	var/eggs_cur = 0
	var/huggers_max = 0
	var/eggs_max = 0

	// Reaper vars
	var/harvesting = FALSE // So you can't harvest multiple corpses at once

	var/flesh_plasma = 0
	var/flesh_plasma_max = 600

	var/list/corpses_hauled = list()
	var/corpse_no = 0
	var/corpse_max = 4

/mob/living/carbon/xenomorph/reaper/recalculate_actions()
	. = ..()
	huggers_max = caste.huggers_max
	eggs_max = caste.eggs_max

/mob/living/carbon/xenomorph/reaper/get_status_tab_items()
	. = ..()
	. += "Flesh Plasma: [flesh_plasma]/[flesh_plasma_max]"
	. += "Hauled Corpses: [corpse_no] / [corpse_max]"
	. += ""
	. += "Stored Huggers: [huggers_cur] / [huggers_max]"
	. += "Stored Eggs: [eggs_cur] / [eggs_max]"

/mob/living/carbon/xenomorph/reaper/proc/modify_flesh_plasma(amount)
	flesh_plasma += amount
	if(flesh_plasma > flesh_plasma_max)
		flesh_plasma = flesh_plasma_max
	if(flesh_plasma < 0)
		flesh_plasma = 0

/mob/living/carbon/xenomorph/reaper/get_examine_text(mob/user)
	. = ..()
	if(corpse_no > 0)
		. += "[corpse_no] corpses hang from its back limbs."

/mob/living/carbon/xenomorph/reaper/death(cause, gibbed)
	. = ..(cause, gibbed)
	if(.)
		if(corpse_no > 0)
			visible_message(SPAN_XENOWARNING("The corpses on [src]'s back limbs fall off!"))
			for(var/atom/movable/corpse_mob in corpses_hauled)
				corpses_hauled.Remove(corpse_mob)
				corpse_no -= 1
				corpse_mob.forceMove(get_true_turf(loc))
				step_away(corpse_mob, src, 1)

//	Code from this point has been shamelessly yoinked from Carrier with minimal alterations
//	If it works, it works

		var/chance = 75 //75% to drop an egg or hugger.

		if(huggers_cur)
			//Hugger explosion, like an egg morpher
			var/obj/item/clothing/mask/facehugger/hugger
			visible_message(SPAN_XENOWARNING("The chittering mass of tiny aliens is trying to escape [src]!"))
			for(var/i in 1 to huggers_cur)
				if(prob(chance))
					hugger = new(loc, hivenumber)
					step_away(hugger, src, 1)

		var/eggs_dropped = FALSE
		for(var/i in 1 to eggs_cur)
			if(prob(chance))
				new /obj/item/xeno_egg(loc, hivenumber)
				eggs_dropped = TRUE
		eggs_cur = 0

		if(eggs_dropped) //Checks whether or not to announce egg drop.
			xeno_message(SPAN_XENOANNOUNCE("[src] has dropped some precious eggs!"), 2, hive.hivenumber)

/mob/living/carbon/xenomorph/reaper/proc/store_hugger(obj/item/clothing/mask/facehugger/huggie)
	if(huggie.hivenumber != hivenumber)
		to_chat(src, SPAN_WARNING("This hugger is tainted!"))
		return

	if(huggers_max > 0 && huggers_cur < huggers_max)
		if(huggie.stat != DEAD && !huggie.sterile)
			huggers_cur++
			to_chat(src, SPAN_NOTICE("We take a facehugger and carry it for safekeeping. Now sheltering: [huggers_cur] / [huggers_max]."))
			qdel(huggie)
		else
			to_chat(src, SPAN_WARNING("This [huggie.name] looks too unhealthy."))
	else
		to_chat(src, SPAN_WARNING("We can't carry more facehuggers on us."))

/mob/living/carbon/xenomorph/reaper/proc/store_huggers_from_egg_morpher(obj/effect/alien/resin/special/eggmorph/morpher)
	if(morpher.linked_hive && (morpher.linked_hive.hivenumber != hivenumber))
		to_chat(src, SPAN_WARNING("That egg morpher is tainted!"))
		return

	if(morpher.stored_huggers == 0)
		to_chat(src, SPAN_WARNING("The egg morpher is empty!"))
		return

	if(huggers_max > 0 && huggers_cur < huggers_max)
		var/huggers_to_transfer = min(morpher.stored_huggers, huggers_max-huggers_cur)
		huggers_cur += huggers_to_transfer
		morpher.stored_huggers -= huggers_to_transfer
		if(huggers_to_transfer == 1)
			to_chat(src, SPAN_NOTICE("We take one facehugger and carry it for safekeeping. Now sheltering: [huggers_cur] / [huggers_max]."))
		else
			to_chat(src, SPAN_NOTICE("We take [huggers_to_transfer] facehuggers and carry them for safekeeping. Now sheltering: [huggers_cur] / [huggers_max]."))
	else
		to_chat(src, SPAN_WARNING("We can't carry more facehuggers on you."))

/mob/living/carbon/xenomorph/reaper/proc/retrieve_hugger(atom/target)
	if(!target)
		return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(target, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/huggie = target
		if(isturf(huggie.loc) && Adjacent(huggie))
			if(huggie.hivenumber != hivenumber)
				to_chat(src, SPAN_WARNING("That facehugger is tainted!"))
				drop_inv_item_on_ground(huggie)
				return
			if(on_fire)
				to_chat(src, SPAN_WARNING("Touching \the [huggie] while you're on fire would burn it!"))
				return
			store_hugger(huggie)
			return

	//target an egg morpher to top up on huggers
	if(istype(target, /obj/effect/alien/resin/special/eggmorph))
		var/obj/effect/alien/resin/special/eggmorph/morpher = target
		if(Adjacent(morpher))
			if(morpher.linked_hive && (morpher.linked_hive.hivenumber != hivenumber))
				to_chat(src, SPAN_WARNING("That egg morpher is tainted!"))
				return
			if(on_fire)
				to_chat(src, SPAN_WARNING("Touching \the [morpher] while you're on fire would burn the facehuggers in it!"))
				return
			store_huggers_from_egg_morpher(morpher)
			return

	var/obj/item/clothing/mask/facehugger/huggie = get_active_hand()
	if(!huggie) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(huggers_cur <= 0)
			to_chat(src, SPAN_WARNING("We don't have any facehuggers to use!"))
			return

		if(on_fire)
			to_chat(src, SPAN_WARNING("Retrieving a stored facehugger while we're on fire would burn it!"))
			return

		huggie = new(src, hivenumber)
		huggers_cur--
		put_in_active_hand(huggie)
		to_chat(src, SPAN_XENONOTICE("We grab one of the facehugger in our storage. Now sheltering: [huggers_cur] / [huggers_max]."))
		update_icons()
		return

/mob/living/carbon/xenomorph/reaper/proc/store_egg(obj/item/xeno_egg/eggies)
	if(eggies.hivenumber != hivenumber)
		to_chat(src, SPAN_WARNING("That egg is tainted!"))
		return
	if(eggs_cur < eggs_max)
		if(stat == CONSCIOUS)
			eggs_cur++
			to_chat(src, SPAN_NOTICE("We store the egg and carry it for safekeeping. Now sheltering: [eggs_cur] / [eggs_max]."))
			qdel(eggies)
		else
			to_chat(src, SPAN_WARNING("This [eggies.name] looks too unhealthy."))
	else
		to_chat(src, SPAN_WARNING("We can't carry more eggs on ourselves."))

/mob/living/carbon/xenomorph/reaper/proc/retrieve_egg(atom/target)
	if(!target)
		return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(target, /obj/item/xeno_egg))
		var/obj/item/xeno_egg/eggies = target
		if(isturf(eggies.loc) && Adjacent(eggies))
			var/turf/egg_turf = eggies.loc
			store_egg(eggies)
			//Grab all the eggs from the turf
			if(eggs_cur < eggs_max)
				for(eggies in egg_turf)
					if(eggs_cur < eggs_max)
						store_egg(eggies)
			return

	if(istype(target, /obj/effect/alien/resin/special/eggmorph))
		store_eggs_into_egg_morpher(target)
		return

	var/obj/item/xeno_egg/eggies = get_active_hand()
	if(!eggies) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(eggs_cur <= 0)
			to_chat(src, SPAN_WARNING("We don't have any eggs to use!"))
			return
		eggies = new(src, hivenumber)
		eggs_cur--
		put_in_active_hand(eggies)
		to_chat(src, SPAN_XENONOTICE("We grab one of the eggs in our storage. Now sheltering: [eggs_cur] / [eggs_max]."))
		return

	if(!istype(eggies)) //something else in our hand
		to_chat(src, SPAN_WARNING("We need an empty hand to grab one of our stored eggs!"))
		return

/mob/living/carbon/xenomorph/reaper/proc/store_eggs_into_egg_morpher(obj/effect/alien/resin/special/eggmorph/morpher)
	if(action_busy)
		return FALSE

	if(!morpher_safety_checks(morpher))
		return

	visible_message(SPAN_XENOWARNING("[src] starts placing facehuggers into [morpher] from their eggs..."), SPAN_XENONOTICE("We start placing children into [morpher] from our eggs..."))
	while(eggs_cur > 0)
		if(!morpher_safety_checks(morpher))
			return

		if(!do_after(src, 0.75 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(src, SPAN_WARNING("We stop filling [morpher] with our children."))
			return

		playsound(src.loc, "sound/effects/alien_egg_move.ogg", 20, TRUE)
		morpher.stored_huggers = min(morpher.huggers_max_amount, morpher.stored_huggers + 1)
		eggs_cur--
		to_chat(src, SPAN_XENONOTICE("We slide one of the children out of an egg and place them into [morpher]. Now sheltering: [eggs_cur] / [eggs_max]."))

/mob/living/carbon/xenomorph/reaper/proc/morpher_safety_checks(obj/effect/alien/resin/special/eggmorph/morpher)
	if(morpher.linked_hive && (morpher.linked_hive.hivenumber != hivenumber))
		to_chat(src, SPAN_WARNING("That egg morpher is tainted!"))
		return FALSE

	if(morpher.stored_huggers == morpher.huggers_max_amount)
		to_chat(src, SPAN_WARNING("[morpher] is full of children!"))
		return FALSE

	if(eggs_cur < 1)
		to_chat(src, SPAN_WARNING("We don't have any eggs left!"))
		return FALSE

	return TRUE

/mob/living/carbon/xenomorph/reaper/attack_ghost(mob/dead/observer/user)
	. = ..() //Do a view printout as needed just in case the observer doesn't want to join as a Hugger but wants info
	join_as_facehugger_from_this(user)

/mob/living/carbon/xenomorph/reaper/proc/join_as_facehugger_from_this(mob/dead/observer/user)
	if(!huggers_max) //Eggsac doesn't have huggers, do nothing!
		return
	if(stat == DEAD)
		to_chat(user, SPAN_WARNING("\The [src] is dead and all their huggers died with it."))
		return
	if(!huggers_cur)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any facehuggers to inhabit."))
		return
	if(huggers_cur <= huggers_reserved)
		to_chat(user, SPAN_WARNING("\The [src] has reserved the remaining facehuggers for themselves."))
		return
	if(!GLOB.hive_datum[hivenumber].can_spawn_as_hugger(user))
		return
	//Need to check again because time passed due to the confirmation window
	if(!huggers_cur)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any facehuggers to inhabit."))
		return
	GLOB.hive_datum[hivenumber].spawn_as_hugger(user, src)
	huggers_cur--

// Shamelessly yoinked code ends here

/datum/behavior_delegate/base_reaper
	name = "Base Reaper Behavior Delegate"

	var/passive_flesh_regen = 1 // Base value for passive regen, this is not modified by abilities
	var/passive_flesh_multi= 1
	var/passive_multi_max = 5
	var/pause_decay = FALSE
	var/pause_dur = 5 SECONDS
	var/unpause_incoming = FALSE

/datum/behavior_delegate/base_reaper/proc/mult_decay()
	if(pause_decay == FALSE && passive_flesh_multi > 1)
		modify_passive_mult(-1)

/datum/behavior_delegate/base_reaper/proc/unpause_decay()
	pause_decay = FALSE
	unpause_incoming = FALSE
	pause_dur = 5 SECONDS

/datum/behavior_delegate/base_reaper/proc/modify_passive_mult(amount)
	passive_flesh_multi += amount
	if(passive_flesh_multi > passive_multi_max)
		passive_flesh_multi = passive_multi_max
	if(passive_flesh_multi < 1)
		passive_flesh_multi = 1

/datum/behavior_delegate/base_reaper/melee_attack_additional_effects_target(mob/living/carbon/target_mob)
	modify_passive_mult(1)

/datum/behavior_delegate/base_reaper/on_kill_mob()
	if(!unpause_incoming == TRUE)
		pause_decay = TRUE

/datum/behavior_delegate/base_reaper/on_life()
	var/mob/living/carbon/xenomorph/reaper/reaper = bound_xeno
	reaper.modify_flesh_plasma(passive_flesh_regen * passive_flesh_multi)

	mult_decay()
	if(pause_decay == TRUE && unpause_incoming == FALSE)
		unpause_incoming = TRUE
		addtimer(CALLBACK(src, PROC_REF(unpause_decay)), pause_dur)

	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_flesh = round((reaper.flesh_plasma / reaper.flesh_plasma_max) * 100, 10)
	if(percentage_flesh)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_flesh]")

/datum/behavior_delegate/base_reaper/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

// Powers

/datum/action/xeno_action/activable/retrieve_hugger_egg/use_ability(atom/thing)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner

	if(thing == xeno)
		var/action_icon_result
		if(getting_egg == TRUE)
			action_icon_result = "throw_hugger"
			to_chat(xeno, SPAN_XENONOTICE("We will now retrieve facehuggers from our storage."))
			getting_egg = FALSE
		else
			action_icon_result = "retrieve_egg"
			to_chat(xeno, SPAN_XENONOTICE("We will now retrieve eggs from our storage."))
			getting_egg = TRUE
		button.overlays.Cut()
		button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)
		return ..()

	if(getting_egg)
		xeno.retrieve_egg(thing)
	else
		xeno.retrieve_hugger(thing)
	return ..()

/datum/action/xeno_action/onclick/set_hugger_reserve_reaper/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	xeno.huggers_reserved = tgui_input_number(usr,
		"How many facehuggers would you like to keep safe from Observers wanting to join as facehuggers?",
		"How many to reserve?",
		xeno.huggers_reserved, xeno.huggers_max, 0
	)
	to_chat(xeno, SPAN_XENONOTICE("We reserve [xeno.huggers_reserved] facehuggers for ourself."))
	return ..()

/datum/action/xeno_action/activable/haul_corpse/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/carbon = target

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(target == xeno)
		if(xeno.corpse_no > 0)
			corpse_retrieve(carbon)
			return
		else
			to_chat(xeno, SPAN_XENONOTICE("We aren't hauling any corpses."))
			return

	var/distance = get_dist(xeno, target)
	if((distance > 2) && !xeno.Adjacent(target))
		return

	if(xeno.harvesting == TRUE)
		to_chat(xeno, SPAN_XENOWARNING("We are busy harvesting!"))
		return

	if(istype(target, /obj/effect/alien/weeds)) // To get at weed fooded corpses, can be used to restart weed growth
		var/obj/effect/alien/weeds/target_weeds = target
		var/target_weeds_loc = target.loc
		var/obj/effect/alien/weeds/node/target_weeds_node = null
		var/target_weeds_hive = target_weeds.hivenumber
		if(target_weeds.parent)
			target_weeds_node = target_weeds.parent
		playsound(target_weeds.loc, "alien_resin_break", 25)
		qdel(target_weeds)
		apply_cooldown()
		if(target_weeds_node)
			if((target_weeds_hive == xeno.hivenumber)) // If our hive, weeds are pruned; pruned weeds can restart spreading, pruned nodes get a bit funky but otherwise work
				xeno.visible_message(SPAN_DANGER("[xeno] prunes [target_weeds]!"),
				SPAN_DANGER("We prune [target_weeds]!"))
				sleep(0.5 SECONDS) // Necessary so any weed food actually stops being weed food
				if(istype(target_weeds, /obj/effect/alien/weeds/node))
					new /obj/effect/alien/weeds/node(target_weeds_loc, target_weeds_node, xeno)
				if(!istype(target_weeds, /obj/effect/alien/weeds/weedwall/window) && !istype(target_weeds, /obj/effect/alien/weeds/weedwall/frame)) // These are a bit fucky, so don't regrow
					if(istype(target_weeds, /obj/effect/alien/weeds/weedwall))
						new /obj/effect/alien/weeds/weedwall(target_weeds_loc)
					else
						new /obj/effect/alien/weeds(target_weeds_loc, target_weeds_node, TRUE, TRUE)
					playsound(target_weeds_loc, "alien_resin_build", 5)
			else // If not our hive, just destroy!
				xeno.visible_message(SPAN_DANGER("[xeno] forcefully uproots [target_weeds]!"),
				SPAN_DANGER("We uproot [target_weeds]!"))
		target_weeds_node = null
		return

	if(xeno.corpse_no == xeno.corpse_max)
		to_chat(xeno, SPAN_XENOWARNING("We cannot haul more!"))
		return

	if(!iscarbon(carbon))
		return

	if(issynth(carbon))
		to_chat(xeno, SPAN_XENOWARNING("This one is a fake, why would we try hauling it?"))
		return

	if(!carbon.chestburst)
		to_chat(xeno, SPAN_XENOWARNING("We can only haul those that have burst."))
		return

	if(ishuman(carbon))
		corpse_add(carbon)

	return ..()

/datum/action/xeno_action/activable/haul_corpse/proc/corpse_add(mob/living/corpse)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner

	xeno.corpses_hauled.Add(corpse)
	xeno.corpse_no += 1
	corpse.forceMove(xeno)
	xeno.visible_message(SPAN_XENONOTICE("[xeno] impales [corpse] with a wing-like limb."), \
	SPAN_XENONOTICE("We hoist the corpse onto our back for hauling."))

/datum/action/xeno_action/activable/haul_corpse/proc/corpse_retrieve(mob/living/corpse)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner

	for(var/atom/movable/corpse_mob in xeno.corpses_hauled)
		xeno.corpses_hauled.Remove(corpse_mob)
		xeno.corpse_no -= 1
		corpse_mob.forceMove(get_true_turf(xeno.loc))
		break
	xeno.visible_message(SPAN_XENONOTICE("[xeno] slides a corpse off one of its wing-like limbs with it's tail."), \
	SPAN_XENONOTICE("We remove a corpse from one of our back limbs."))

/datum/action/xeno_action/activable/flesh_harvest/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/carbon = target
	var/mob/living/carbon/human/victim = carbon

	if(!action_cooldown_check())
		return

	if(!iscarbon(carbon))
		return

	if(!xeno.check_state())
		return

	var/distance = get_dist(xeno, target)
	if((distance > 2) && !xeno.Adjacent(target))
		return

	if(xeno.harvesting == TRUE)
		to_chat(xeno, SPAN_XENOWARNING("We are already harvesting!"))
		return

	if(isxeno(carbon))
		return

	if(issynth(carbon))
		to_chat(xeno, SPAN_XENOWARNING("This one is a fake, we get nothing from it!"))
		return

	if(affect_living != TRUE)
		if(carbon.stat != DEAD)
			to_chat(xeno, SPAN_XENOWARNING("This one still lives, they are not suitable."))
			return

		if(victim.is_revivable(TRUE) && victim.check_tod())
			to_chat(xeno, SPAN_XENOWARNING("This one still pulses with life, they are not suitable."))
			return

	if(victim.status_flags & XENO_HOST)
		for(var/obj/item/alien_embryo/embryo in victim)
			if(HIVE_ALLIED_TO_HIVE(xeno.hivenumber, embryo.hivenumber))
				to_chat(xeno, SPAN_XENOWARNING("A sister is still growing inside this one, we should refrain from harvesting them yet."))
				return

	var/obj/limb/target_limb = victim.get_limb(check_zone(xeno.zone_selected))
	if(ishuman(carbon) && !target_limb || (target_limb.status & LIMB_DESTROYED))
		to_chat(xeno, SPAN_XENOWARNING("There is nothing to harvest!"))
		return

	xeno.face_atom(carbon)
	var/obj/limb/limb = target_limb
	switch(limb.name)
		if("head")
			cannot_harvest()
			return
		if("chest", "groin")
			burst_chest(victim, affect_living)
		if("l_arm")
			do_harvest(victim, limb)
		if("l_hand")
			limb = carbon.get_limb("l_arm")
			do_harvest(victim, limb)
		if("r_arm")
			do_harvest(victim, limb)
		if("r_hand")
			limb = carbon.get_limb("r_arm")
			do_harvest(victim, limb)
		if("l_leg")
			do_harvest(victim, limb)
		if("l_foot")
			limb = carbon.get_limb("l_leg")
			do_harvest(victim, limb)
		if("r_leg")
			do_harvest(victim, limb)
		if("r_foot")
			limb = carbon.get_limb("r_leg")
			do_harvest(victim, limb)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/flesh_harvest/proc/do_harvest(mob/living/carbon/carbon, obj/limb/limb)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	var/limb_remove_end = pick('sound/scp/firstpersonsnap.ogg','sound/scp/firstpersonsnap2.ogg')
	var/limb_remove_start = pick('sound/effects/bone_break2.ogg','sound/effects/bone_break3.ogg')

	xeno.harvesting = TRUE
	xeno.visible_message(SPAN_XENONOTICE("[xeno] reaches down and grabs [victim]'s [limb.display_name], twisting and pulling at it!"), \
	SPAN_XENONOTICE("We begin to harvest the [limb.display_name]!"))

	playsound(victim, limb_remove_start, 50, TRUE)
	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		if(!xeno.Adjacent(victim))
			to_chat(xeno, SPAN_XENOWARNING("Our harvest was interrupted!"))
			xeno.harvesting = FALSE
			return

	playsound(xeno, limb_remove_end, 25, TRUE)
	if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		xeno.visible_message(SPAN_XENOWARNING("[xeno] wrenches off [victim]'s [limb.display_name] with a final violent motion and drops it!"), \
		SPAN_XENOWARNING("We harvest the [limb.display_name], but it's a useless fake!"))
		limb.droplimb(FALSE, FALSE, "flesh harvest")
	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno] wrenches off [victim]'s [limb.display_name] with a final violent motion and swallows it whole!"), \
		SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
		limb.droplimb(FALSE, TRUE, "flesh harvest")
		xeno.modify_flesh_plasma(harvest_gain)
	reaper.pause_decay = TRUE
	xeno.harvesting = FALSE

/datum/action/xeno_action/activable/flesh_harvest/proc/burst_chest(mob/living/carbon/carbon, burst_living = FALSE)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	if(victim.chestburst)
		to_chat(xeno, SPAN_XENOWARNING("There is nothing to harvest!"))
		return

	xeno.harvesting = TRUE
	xeno.visible_message(SPAN_XENONOTICE("[xeno] gently lifts [victim]!"), \
	SPAN_XENONOTICE("We prepare our inner jaw to harvest [victim]'s chest organs!"))

	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		if(!xeno.Adjacent(victim))
			to_chat(xeno, SPAN_XENOWARNING("Our harvest was interrupted!"))
			xeno.harvesting = FALSE
			return

	if(ishuman(victim))
		var/mob/living/carbon/human/victim_human = victim
		var/datum/internal_organ/organ
		var/internal
		for(internal in list("heart","lungs")) // Ripped from Embryo code for vibes, with single letter vars murdered (I wish I found this months sooner)
			organ = victim_human.internal_organs_by_name[internal]
			victim_human.internal_organs_by_name -= internal
			victim_human.internal_organs -= organ
	if(burst_living == TRUE && victim.stat != DEAD)
		var/datum/cause_data/cause = create_cause_data("reaper living burst chest", src)
		victim.last_damage_data = cause
		victim.death(cause)
	playsound(victim, 'sound/weapons/alien_bite2.ogg', 50, TRUE)
	xeno.visible_message(SPAN_XENOWARNING("[xeno]'s inner jaw shoots out of it's mouth, gouging a large hole in [victim]'s chest!"), \
	SPAN_XENOWARNING("We plunge our inner jaw into [victim]'s chest and harvest their organs!"))
	victim.chestburst = 2
	victim.update_burst()
	xeno.modify_flesh_plasma(harvest_gain * 2)
	reaper.pause_decay = TRUE
	xeno.harvesting = FALSE

/datum/action/xeno_action/activable/flesh_harvest/proc/cannot_harvest()
	to_chat(owner, SPAN_XENOWARNING("This part is not worth harvesting!"))

/datum/action/xeno_action/activable/replenish/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/xenomorph/xeno_carbon = target

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(!check_plasma_owner())
		return

	if(!istype(xeno_carbon))
		return

	if(xeno.flesh_plasma < flesh_plasma_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh plasma, we need [flesh_plasma_cost - xeno.flesh_plasma] more!"))
		return

	if(!xeno.can_not_harm(xeno_carbon))
		to_chat(xeno, SPAN_XENODANGER("We must target an ally!"))
		return

	if(get_dist(xeno, xeno_carbon) > range)
		to_chat(xeno, SPAN_WARNING("They are too far away!"))
		return

	if(xeno_carbon.stat == DEAD)
		to_chat(xeno, SPAN_XENODANGER("We cannot heal the dead!"))
		return

	if(SEND_SIGNAL(xeno_carbon, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		to_chat(xeno, SPAN_XENOWARNING("We cannot help [xeno_carbon] when they're on fire!"))
		return

	if(xeno_carbon.health >= xeno_carbon.maxHealth)
		to_chat(xeno, SPAN_XENOWARNING("[xeno_carbon] is already at max health!"))
		return

	if(xeno_carbon != xeno && !xeno.Adjacent(xeno_carbon))
		plas_mod = 1
		var/obj/effect/alien/weeds/user_weeds = locate() in xeno.loc
		var/obj/effect/alien/weeds/target_weeds = locate() in xeno_carbon.loc
		if((!user_weeds && !target_weeds))
			to_chat(xeno, SPAN_XENOWARNING("We must either be adjacent to our target or both of us must be on our hive's weeds!"))
			return
		if(user_weeds.linked_hive.hivenumber != xeno.hivenumber && target_weeds.linked_hive.hivenumber != xeno.hivenumber)
			to_chat(xeno, SPAN_XENOWARNING("Both us and our target must be on our hive's weeds!"))
			return
	else
		plas_mod = 0.5

	xeno.face_atom(xeno_carbon)

	var/recovery_amount = xeno_carbon.maxHealth * 0.15 // 15% of the Xeno's max health feels like a good value for semi-ranged healing

	if(islarva(xeno_carbon) && islesserdrone(xeno_carbon))
		recovery_amount = xeno_carbon.maxHealth * 0.3 // 15% on these ones ain't much, so let them get 30% instead

	else if(isfacehugger(xeno_carbon))
		recovery_amount = xeno_carbon.maxHealth // Can as well just fully heal them if you choose to waste the flesh plasma on them

	if(xeno_carbon.health < 0)
		recovery_amount = (xeno_carbon.maxHealth * 0.05) + abs(xeno_carbon.health) // If they're in crit, get them out of it but heal less

	xeno_carbon.gain_health(recovery_amount)
	xeno_carbon.updatehealth()
	xeno_carbon.xeno_jitter(1 SECONDS)
	xeno_carbon.flick_heal_overlay(3 SECONDS, "#c5bc81")

	if(xeno_carbon == xeno)
		xeno.visible_message(SPAN_XENOWARNING("[xeno]'s wounds emit a foul scent and close up faster!"), \
		SPAN_XENOWARNING("We absorb flesh plasma, healing some of our injuries!"))
	else if(xeno.Adjacent(xeno_carbon))
		xeno.visible_message(SPAN_XENOWARNING("[xeno] smears a foul-smelling ooze onto [xeno_carbon]'s wounds, causing them to close up faster!"), \
		SPAN_XENOWARNING("We use flesh plasma to heal [xeno_carbon]'s wounds!"))
		to_chat(xeno_carbon, SPAN_XENOWARNING("[xeno] smears a pale ooze onto our wounds, causing them to close up faster!"))
	else if(!xeno.Adjacent(xeno_carbon))
		xeno.visible_message(SPAN_XENOWARNING("The weeds between [xeno] and [xeno_carbon] ripple and emit a foul scent as [xeno_carbon]'s wounds close up faster!"), \
		SPAN_XENOWARNING("We channel flesh plasma to heal [xeno_carbon]'s wounds from afar!"))
		to_chat(xeno_carbon, SPAN_XENOWARNING("The weeds beneath us shudder as a pale ooze forms on our wounds, causing them to close up faster!"))

	use_plasma_owner(plasma_cost * plas_mod)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/emit_mist/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/datum/effect_system/smoke_spread/reaper_mist/cloud = new /datum/effect_system/smoke_spread/reaper_mist

	if(!isxeno(owner))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	if(xeno.flesh_plasma < flesh_plasma_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh plasma, we need [flesh_plasma_cost - xeno.flesh_plasma] more!"))
		return

	var/datum/cause_data/cause_data = create_cause_data("reaper mist", owner)
	cloud.set_up(3, 0, get_turf(xeno), null, 10, new_cause_data = cause_data)
	cloud.start()
	xeno.emote("roar")
	xeno.visible_message(SPAN_XENOWARNING("[xeno] belches a sickly green mist!"), \
		SPAN_XENOWARNING("We breath a cloud of mist of evaporated flesh plasma!"))

	xeno.modify_flesh_plasma(-flesh_plasma_cost)
	apply_cooldown()
	return ..()


// Strain Powers (Here as it's a WIP and maybe not a great idea to include with a brand new xeno)

/datum/action/xeno_action/activable/reap/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/carbon = target
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	var/damage = xeno.melee_damage_upper + xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER

	if(!action_cooldown_check())
		return

	if(!isxeno_human(carbon) || xeno.can_not_harm(carbon))
		return

	if(!xeno.check_state())
		return

	if(carbon.stat == DEAD)
		return

	if(HAS_TRAIT(carbon, TRAIT_NESTED))
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
	if(iscarbon(carbon))
		var/mob/living/carbon/human/victim = carbon
		if(!issynth(victim))
			victim.reagents.add_reagent("sepsicine", toxin_amount)
			victim.reagents.set_source_mob(xeno, /datum/reagent/toxin/sepsicine)
	carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")
	carbon.apply_effect(2, DAZE)
	reaper.pause_decay = TRUE
	reaper.modify_passive_mult(1)
	shake_camera(target, 2, 1)
	apply_cooldown()
	return ..()
