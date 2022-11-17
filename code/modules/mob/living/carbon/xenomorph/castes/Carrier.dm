/datum/caste_datum/carrier
	caste_type = XENO_CASTE_CARRIER
	caste_desc = "A carrier of huggies."
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_6
	plasma_max = XENO_PLASMA_TIER_4
	crystal_max = XENO_CRYSTAL_LOW
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_4

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_DRONE)
	eggs_max = 5
	throwspeed = SPEED_AVERAGE
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_ONE_HAND
	weed_level = WEED_LEVEL_STANDARD

	hugger_nurturing = TRUE
	huggers_max = 16
	eggs_max = 7

	tackle_min = 2
	tackle_max = 4
	tackle_chance = 50
	tacklestrength_min = 4
	tacklestrength_max = 5

	aura_strength = 2
	hugger_delay = 20
	egg_cooldown = 250

/mob/living/carbon/Xenomorph/Carrier
	caste_type = XENO_CASTE_CARRIER
	name = XENO_CASTE_CARRIER
	desc = "A strange-looking alien creature. It carries a number of scuttling jointed crablike creatures."
	icon_size = 64
	icon_state = "Carrier Walking"
	plasma_types = list(PLASMA_PURPLE)

	drag_delay = 6 //pulling a big dead xeno is hard

	mob_size = MOB_SIZE_BIG
	tier = 2
	pixel_x = -16 //Needed for 2x2
	old_x = -16

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/plant_weeds, //1st macro
		/datum/action/xeno_action/onclick/place_trap, //2nd macro
		/datum/action/xeno_action/activable/throw_hugger, //3rd macro
		/datum/action/xeno_action/activable/retrieve_egg, //4th macro
		)
	mutation_type = CARRIER_NORMAL

	icon_xenonid = 'icons/mob/xenonids/carrier.dmi'

	var/list/hugger_image_index = list()
	var/mutable_appearance/hugger_overlays_icon

/mob/living/carbon/Xenomorph/Carrier/update_icons()
	. = ..()

	update_hugger_overlays()

/mob/living/carbon/Xenomorph/Carrier/proc/update_hugger_overlays()
	if(!hugger_overlays_icon)
		return

	overlays -= hugger_overlays_icon
	hugger_overlays_icon.overlays.Cut()

	if(!huggers_cur)
		hugger_image_index.Cut()
		return

	update_icon_maths(round(( huggers_cur / huggers_max ) * 3.999) + 1)

	for(var/i in hugger_image_index)
		if(stat == DEAD)
			hugger_overlays_icon.overlays += icon(icon, "clinger_[i] Knocked Down")
		else if(lying)
			if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
				hugger_overlays_icon.overlays += icon(icon, "clinger_[i] Sleeping")
			else
				hugger_overlays_icon.overlays +=icon(icon, "clinger_[i] Knocked Down")
		else
			hugger_overlays_icon.overlays +=icon(icon, "clinger_[i]")

	overlays += hugger_overlays_icon

/mob/living/carbon/Xenomorph/Carrier/proc/update_icon_maths(number)
	var/funny_list = list(1,2,3,4)
	if(length(hugger_image_index) != number)
		if(length(hugger_image_index) > number)
			while(length(hugger_image_index) != number)
				hugger_image_index -= hugger_image_index[length(hugger_image_index)]
		else
			while(length(hugger_image_index) != number)
				for(var/i in hugger_image_index)
					if(locate(i) in funny_list)
						funny_list -= i
				hugger_image_index += funny_list[rand(1,length(funny_list))]

/mob/living/carbon/Xenomorph/Carrier/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	icon_xeno = get_icon_from_source(CONFIG_GET(string/alien_carrier))
	. = ..()

	hugger_overlays_icon = mutable_appearance('icons/mob/hostiles/overlay_effects64x64.dmi',"empty")

/mob/living/carbon/Xenomorph/Carrier/death(var/cause, var/gibbed)
	. = ..(cause, gibbed)
	if(.)
		var/chance = 75

		while (eggs_cur > 0)
			if(prob(chance))
				new /obj/item/xeno_egg(loc, hivenumber)
				eggs_cur--

/mob/living/carbon/Xenomorph/Carrier/get_status_tab_items()
	. = ..()
	if(huggers_max > 0)
		. += "Stored Huggers: [huggers_cur] / [huggers_max]"
	. += "Stored Eggs: [eggs_cur] / [eggs_max]"

/mob/living/carbon/Xenomorph/Carrier/proc/store_hugger(obj/item/clothing/mask/facehugger/F)
	if(F.hivenumber != hivenumber)
		to_chat(src, SPAN_WARNING("This hugger is tainted!"))
		return

	if(huggers_max > 0 && huggers_cur < huggers_max)
		if(F.stat != DEAD && !F.sterile)
			huggers_cur++
			to_chat(src, SPAN_NOTICE("You store the facehugger and carry it for safekeeping. Now sheltering: [huggers_cur] / [huggers_max]."))
			update_icons()
			qdel(F)
		else
			to_chat(src, SPAN_WARNING("This [F.name] looks too unhealthy."))
	else
		to_chat(src, SPAN_WARNING("You can't carry more facehuggers on you."))


/mob/living/carbon/Xenomorph/Carrier/proc/throw_hugger(atom/T)
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

	var/obj/item/clothing/mask/facehugger/F = get_active_hand()
	if(!F) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(huggers_cur <= 0)
			to_chat(src, SPAN_WARNING("You don't have any facehuggers to use!"))
			return

		if(on_fire)
			to_chat(src, SPAN_WARNING("Retrieving a stored facehugger while you're on fire would burn it!"))
			return

		F = new(src, hivenumber)
		huggers_cur--
		put_in_active_hand(F)
		to_chat(src, SPAN_XENONOTICE("You grab one of the facehugger in your storage. Now sheltering: [huggers_cur] / [huggers_max]."))
		update_icons()
		return

	if(!istype(F)) //something else in our hand
		to_chat(src, SPAN_WARNING("You need a facehugger in your hand to throw one!"))
		return

	if(!threw_a_hugger)
		threw_a_hugger = TRUE
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()
		drop_inv_item_on_ground(F)
		F.throw_atom(T, 4, caste.throwspeed)
		visible_message(SPAN_XENOWARNING("\The [src] throws something towards \the [T]!"), \
			SPAN_XENOWARNING("You throw a facehugger towards \the [T]!"))
		spawn(caste.hugger_delay)
			threw_a_hugger = 0
			for(var/X in actions)
				var/datum/action/A = X
				A.update_button_icon()

/mob/living/carbon/Xenomorph/Carrier/proc/store_egg(obj/item/xeno_egg/E)
	if(E.hivenumber != hivenumber)
		to_chat(src, SPAN_WARNING("That egg is tainted!"))
		return
	if(eggs_cur < eggs_max)
		if(stat == CONSCIOUS)
			eggs_cur++
			to_chat(src, SPAN_NOTICE("You store the egg and carry it for safekeeping. Now sheltering: [eggs_cur] / [eggs_max]."))
			qdel(E)
		else
			to_chat(src, SPAN_WARNING("This [E.name] looks too unhealthy."))
	else
		to_chat(src, SPAN_WARNING("You can't carry more eggs on you."))


/mob/living/carbon/Xenomorph/Carrier/proc/retrieve_egg(atom/T)
	if(!T) return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(T, /obj/item/xeno_egg))
		var/obj/item/xeno_egg/E = T
		if(isturf(E.loc) && Adjacent(E))
			store_egg(E)
			return

	var/obj/item/xeno_egg/E = get_active_hand()
	if(!E) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(eggs_cur <= 0)
			to_chat(src, SPAN_WARNING("You don't have any egg to use!"))
			return
		E = new(src, hivenumber)
		eggs_cur--
		put_in_active_hand(E)
		to_chat(src, SPAN_XENONOTICE("You grab one of the eggs in your storage. Now sheltering: [eggs_cur] / [eggs_max]."))
		return

	if(!istype(E)) //something else in our hand
		to_chat(src, SPAN_WARNING("You need an empty hand to grab one of your stored eggs!"))
		return
