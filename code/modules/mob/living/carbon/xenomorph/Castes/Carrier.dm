/datum/caste_datum/carrier
	caste_name = "Carrier"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0
	melee_damage_lower = 20
	melee_damage_upper = 30
	tackle_chance = 40
	plasma_gain = 8
	plasma_max = 250
	upgrade_threshold = 800
	evolution_allowed = FALSE
	caste_desc = "A carrier of huggies."
	max_health = 175
	speed = 0.0
	aura_strength = 1 //Carrier's pheromones are equivalent to Hivelord. Climbs 0.5 up to 2.5
	huggers_max = 8
	throwspeed = 1
	hugger_delay = 30
	eggs_max = 3
	can_hold_facehuggers = 1
	armor_deflection = 10
	can_hold_eggs = CAN_HOLD_ONE_HAND

/datum/caste_datum/carrier/mature

	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 25
	melee_damage_upper = 35
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	plasma_gain = 10
	plasma_max = 300
	armor_deflection = 15
	caste_desc = "A portable Love transport. It looks a little more dangerous."
	max_health = 200
	speed = -0.1
	aura_strength = 1.5
	huggers_max = 9
	eggs_max = 4

/datum/caste_datum/carrier/elder

	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 30
	melee_damage_upper = 40
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	plasma_gain = 12
	plasma_max = 350
	armor_deflection = 20
	caste_desc = "A portable Love transport. It looks pretty strong."
	max_health = 225
	speed = -0.2
	aura_strength = 2
	huggers_max = 10
	hugger_delay = 20
	eggs_max = 5

/datum/caste_datum/carrier/ancient

	upgrade_name = "Ancient"

	upgrade = 3
	melee_damage_lower = 35
	melee_damage_upper = 45
	tacklemin = 5
	tacklemax = 6
	tackle_chance = 55
	plasma_gain = 15
	plasma_max = 400
	armor_deflection = 25
	caste_desc = "It's literally crawling with 10 huggers."
	max_health = 250
	speed = -0.3
	aura_strength = 2.5
	huggers_max = 11
	hugger_delay = 10
	eggs_max = 6

/mob/living/carbon/Xenomorph/Carrier
	caste_name = "Carrier"
	name = "Carrier"
	desc = "A strange-looking alien creature. It carries a number of scuttling jointed crablike creatures."
	icon = 'icons/Xeno/xenomorph_64x64.dmi' //They are now like, 2x2
	icon_state = "Carrier Walking"
	health = 175
	maxHealth = 175
	plasma_stored = 250

	drag_delay = 6 //pulling a big dead xeno is hard

	mob_size = MOB_SIZE_BIG
	tier = 3
	upgrade = 0
	pixel_x = -16 //Needed for 2x2
	old_x = -16

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/plant_weeds,
		/datum/action/xeno_action/emit_pheromones,
		/datum/action/xeno_action/activable/throw_hugger,
		/datum/action/xeno_action/activable/retrieve_egg,
		/datum/action/xeno_action/place_trap,
		)

	death(gibbed)
		if(..() && !gibbed && huggers_cur)
			var/obj/item/clothing/mask/facehugger/F
			var/i = 3
			var/chance = 75
			visible_message("<span class='xenowarning'>The chittering mass of tiny aliens is trying to escape [src]!</span>")
			while(i && huggers_cur)
				if(prob(chance))
					huggers_cur--
					F = new(loc)
					F.hivenumber = hivenumber
					step_away(F,src,1)
				i--
				chance -= 30


/mob/living/carbon/Xenomorph/Carrier/Stat()
	if (!..())
		return 0

	stat(null, "Stored Huggers: [huggers_cur] / [caste.huggers_max]")
	stat(null, "Stored Eggs: [eggs_cur] / [caste.eggs_max]")
	return 1

/mob/living/carbon/Xenomorph/Carrier/proc/store_hugger(obj/item/clothing/mask/facehugger/F)
	if(huggers_cur < caste.huggers_max)
		if(F.stat == CONSCIOUS && !F.sterile)
			huggers_cur++
			src << "<span class='notice'>You store the facehugger and carry it for safekeeping. Now sheltering: [huggers_cur] / [caste.huggers_max].</span>"
			cdel(F)
		else
			src << "<span class='warning'>This [F.name] looks too unhealthy.</span>"
	else
		src << "<span class='warning'>You can't carry more facehuggers on you.</span>"


/mob/living/carbon/Xenomorph/Carrier/proc/throw_hugger(atom/T)
	if(!T) return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(T, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = T
		if(isturf(F.loc) && Adjacent(F))
			if(F.hivenumber != hivenumber)
				src << "<span class='warning'>That facehugger is tainted!</span>"
				drop_inv_item_on_ground(F)
				return
			store_hugger(F)
			return

	var/obj/item/clothing/mask/facehugger/F = get_active_hand()
	if(!F) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(huggers_cur <= 0)
			src << "<span class='warning'>You don't have any facehuggers to use!</span>"
			return
		F = new()
		F.hivenumber = hivenumber
		huggers_cur--
		put_in_active_hand(F)
		src << "<span class='xenonotice'>You grab one of the facehugger in your storage. Now sheltering: [huggers_cur] / [caste.huggers_max].</span>"
		return

	if(!istype(F)) //something else in our hand
		src << "<span class='warning'>You need a facehugger in your hand to throw one!</span>"
		return

	if(!threw_a_hugger)
		threw_a_hugger = 1
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()
		drop_inv_item_on_ground(F)
		F.throw_at(T, 4, caste.throwspeed)
		visible_message("<span class='xenowarning'>\The [src] throws something towards \the [T]!</span>", \
		"<span class='xenowarning'>You throw a facehugger towards \the [T]!</span>")
		spawn(caste.hugger_delay)
			threw_a_hugger = 0
			for(var/X in actions)
				var/datum/action/A = X
				A.update_button_icon()



/mob/living/carbon/Xenomorph/Carrier/proc/store_egg(obj/item/xeno_egg/E)
	if(E.hivenumber != hivenumber)
		src << "<span class='warning'>That egg is tainted!</span>"
		return
	if(eggs_cur < caste.eggs_max)
		if(stat == CONSCIOUS)
			eggs_cur++
			src << "<span class='notice'>You store the egg and carry it for safekeeping. Now sheltering: [eggs_cur] / [caste.eggs_max].</span>"
			cdel(E)
		else
			src << "<span class='warning'>This [E.name] looks too unhealthy.</span>"
	else
		src << "<span class='warning'>You can't carry more eggs on you.</span>"


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
			src << "<span class='warning'>You don't have any egg to use!</span>"
			return
		E = new()
		E.hivenumber = hivenumber
		eggs_cur--
		put_in_active_hand(E)
		src << "<span class='xenonotice'>You grab one of the eggs in your storage. Now sheltering: [eggs_cur] / [caste.eggs_max].</span>"
		return

	if(!istype(E)) //something else in our hand
		src << "<span class='warning'>You need an empty hand to grab one of your stored eggs!</span>"
		return
