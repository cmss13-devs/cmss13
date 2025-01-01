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
	desc = "A horrifying alien with a grim visage. The stench of rot follows it wherever it goes."
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
