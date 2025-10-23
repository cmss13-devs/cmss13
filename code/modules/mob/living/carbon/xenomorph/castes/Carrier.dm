/datum/caste_datum/carrier
	caste_type = XENO_CASTE_CARRIER
	caste_desc = "A carrier of huggies."
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_6
	plasma_max = XENO_PLASMA_TIER_5
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_4

	available_strains = list(/datum/xeno_strain/eggsac)
	behavior_delegate_type = /datum/behavior_delegate/carrier_base

	evolution_allowed = TRUE
	evolves_to = list(XENO_CASTE_REAPER)
	deevolves_to = list(XENO_CASTE_DRONE)
	throwspeed = SPEED_AVERAGE
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_ONE_HAND
	weed_level = WEED_LEVEL_STANDARD

	hugger_nurturing = TRUE

	tackle_min = 2
	tackle_max = 4
	tackle_chance = 50
	tacklestrength_min = 4
	tacklestrength_max = 5

	aura_strength = 2
	hugger_delay = 20
	egg_cooldown = 250

	minimum_evolve_time = 5 MINUTES

	minimap_icon = "carrier"

/mob/living/carbon/xenomorph/carrier
	caste_type = XENO_CASTE_CARRIER
	name = XENO_CASTE_CARRIER
	desc = "A strange-looking alien creature. It carries a number of scuttling jointed crablike creatures."
	icon_size = 64
	icon_xeno = 'icons/mob/xenos/castes/tier_2/carrier.dmi'
	icon_state = "Carrier Walking"
	plasma_types = list(PLASMA_PURPLE)

	drag_delay = 6 //pulling a big dead xeno is hard

	mob_size = MOB_SIZE_BIG
	tier = 2
	pixel_x = -16 //Needed for 2x2
	old_x = -16
	organ_value = 1000

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/plant_weeds, //1st macro
		/datum/action/xeno_action/onclick/place_trap, //2nd macro
		/datum/action/xeno_action/activable/throw_hugger, //3rd macro
		/datum/action/xeno_action/activable/retrieve_hugger_egg, //4th macro
		/datum/action/xeno_action/onclick/set_hugger_reserve,
		)

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	icon_xenonid = 'icons/mob/xenonids/castes/tier_2/carrier.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Carrier_1","Carrier_2","Carrier_3")
	weed_food_states_flipped = list("Carrier_1","Carrier_2","Carrier_3")

	skull = /obj/item/skull/carrier
	pelt = /obj/item/pelt/carrier

	huggers_max = 16
	eggs_max = 8

	var/list/hugger_image_index = list()
	var/mutable_appearance/hugger_overlays_icon
	var/mutable_appearance/eggsac_overlays_icon

	//Carrier specific vars
	var/threw_a_hugger = 0

/mob/living/carbon/xenomorph/carrier/proc/update_hugger_overlays()
	if(!hugger_overlays_icon)
		return

	overlays -= hugger_overlays_icon
	hugger_overlays_icon.overlays.Cut()

	if(!huggers_cur)
		hugger_image_index.Cut()
		return

	update_clinger_maths(floor(( huggers_cur / huggers_max ) * 3.999) + 1)

	for(var/i in hugger_image_index)
		if(stat == DEAD)
			hugger_overlays_icon.overlays += icon(icon, "clinger_[i] Knocked Down")
		else if(body_position == LYING_DOWN)
			if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
				hugger_overlays_icon.overlays += icon(icon, "clinger_[i] Sleeping")
			else
				hugger_overlays_icon.overlays +=icon(icon, "clinger_[i] Knocked Down")
		else
			hugger_overlays_icon.overlays +=icon(icon, "clinger_[i]")

	overlays += hugger_overlays_icon

/mob/living/carbon/xenomorph/carrier/proc/update_clinger_maths(number)
	var/clinger_list = list(1,2,3,4)
	if(length(hugger_image_index) != number)
		if(length(hugger_image_index) > number)
			while(length(hugger_image_index) != number)
				hugger_image_index -= hugger_image_index[length(hugger_image_index)]
		else
			while(length(hugger_image_index) != number)
				for(var/i in hugger_image_index)
					if(locate(i) in clinger_list)
						clinger_list -= i
				hugger_image_index += clinger_list[rand(1,length(clinger_list))]

/mob/living/carbon/xenomorph/carrier/proc/update_eggsac_overlays()
	if(!eggsac_overlays_icon)
		return

	overlays -= eggsac_overlays_icon
	eggsac_overlays_icon.overlays.Cut()

	if(!eggs_cur)
		return

	///Simplified image index change.
	var/i = 0
	if(eggs_cur > 8)
		i = 3
	else if (eggs_cur > 4)
		i = 2
	else if (eggs_cur > 0)
		i = 1

	if(stat != DEAD)
		if(body_position == LYING_DOWN)
			if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
				eggsac_overlays_icon.overlays += icon(icon, "eggsac_[i] Sleeping")
			else
				eggsac_overlays_icon.overlays +=icon(icon, "eggsac_[i] Knocked Down")
		else
			eggsac_overlays_icon.overlays +=icon(icon, "eggsac_[i]")

	overlays += eggsac_overlays_icon

/mob/living/carbon/xenomorph/carrier/Initialize(mapload, mob/living/carbon/xenomorph/oldxeno, h_number)
	. = ..()
	hugger_overlays_icon = mutable_appearance('icons/mob/xenos/overlay_effects64x64.dmi',"empty")
	eggsac_overlays_icon = mutable_appearance('icons/mob/xenos/overlay_effects64x64.dmi',"empty")

/mob/living/carbon/xenomorph/carrier/proc/throw_hugger(atom/T)
	if(!T)
		return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(T, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = T
		if(isturf(F.loc) && Adjacent(F))
			if(F.hivenumber != hivenumber)
				to_chat(src, SPAN_WARNING("That facehugger is tainted!"))
				drop_inv_item_on_ground(F)
				return
			if(on_fire)
				to_chat(src, SPAN_WARNING("Touching \the [F] while you're on fire would burn it!"))
				return
			store_hugger(F)
			return

	//target an egg morpher to top up on huggers
	if(istype(T, /obj/effect/alien/resin/special/eggmorph))
		var/obj/effect/alien/resin/special/eggmorph/morpher = T
		if(Adjacent(morpher))
			if(morpher.linked_hive && (morpher.linked_hive.hivenumber != hivenumber))
				to_chat(src, SPAN_WARNING("That egg morpher is tainted!"))
				return
			if(on_fire)
				to_chat(src, SPAN_WARNING("Touching \the [morpher] while you're on fire would burn the facehuggers in it!"))
				return
			store_huggers_from_egg_morpher(morpher)
			return

	var/obj/item/clothing/mask/facehugger/F = get_active_hand()
	if(!F) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(huggers_cur <= 0)
			to_chat(src, SPAN_WARNING("We don't have any facehuggers to use!"))
			return

		if(on_fire)
			to_chat(src, SPAN_WARNING("Retrieving a stored facehugger while we're on fire would burn it!"))
			return

		F = new(src, hivenumber)
		huggers_cur--
		put_in_active_hand(F)
		to_chat(src, SPAN_XENONOTICE("We grab one of the facehugger in our storage. Now sheltering: [huggers_cur] / [huggers_max]."))
		update_icons()
		return

	if(!istype(F)) //something else in our hand
		to_chat(src, SPAN_WARNING("We need a facehugger in our hand to throw one!"))
		return

	if(!threw_a_hugger)
		threw_a_hugger = TRUE
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()
		drop_inv_item_on_ground(F)
		F.throw_atom(T, 4, caste.throwspeed)
		visible_message(SPAN_XENOWARNING("\The [src] throws something towards \the [T]!"),
			SPAN_XENOWARNING("We throw a facehugger towards \the [T]!"))
		spawn(caste.hugger_delay)
			threw_a_hugger = 0
			for(var/X in actions)
				var/datum/action/A = X
				A.update_button_icon()


/datum/behavior_delegate/carrier_base
	name = "Base Carrier Behavior Delegate"

/datum/behavior_delegate/carrier_base/on_update_icons()
	var/mob/living/carbon/xenomorph/carrier/bound_carrier = bound_xeno
	bound_carrier.update_hugger_overlays()

/datum/action/xeno_action/activable/throw_hugger/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/carrier/carrier_owner = owner
	carrier_owner.throw_hugger(target)
	return ..()

/datum/action/xeno_action/activable/retrieve_egg/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/carrier/carrier_owner = owner
	carrier_owner.retrieve_egg(target)
	return ..()
