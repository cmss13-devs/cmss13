/datum/caste_datum/carrier
	caste_name = "Carrier"
	upgrade_name = "Young"
	caste_desc = "A carrier of huggies."
	tier = 2
	upgrade = 0
	melee_damage_lower = 20
	melee_damage_upper = 30
	tackle_chance = 40
	plasma_gain = 0.032
	plasma_max = 300
	evolution_allowed = FALSE
	deevolves_to = "Drone"
	max_health = 210
	speed = -0.1
	aura_strength = 1 //Carrier's pheromones are equivalent to Hivelord. Climbs 0.5 up to 2.5
	huggers_max = 9
	eggs_max = 4
	throwspeed = 1
	hugger_delay = 30
	can_hold_facehuggers = 1
	armor_deflection = 10
	can_hold_eggs = CAN_HOLD_ONE_HAND
	can_denest_hosts = 1
	xeno_explosion_resistance = 60
	weed_level = 1
	egg_cooldown = 300

/datum/caste_datum/carrier/mature
	upgrade_name = "Mature"
	caste_desc = "A portable Love transport. It looks a little more dangerous."
	upgrade = 1
	max_health = 210
	melee_damage_lower = 25
	melee_damage_upper = 35
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	plasma_gain = 0.034
	plasma_max = 350
	speed = -0.1
	armor_deflection = 15
	throwspeed = 1
	hugger_delay = 30
	aura_strength = 1.5
	egg_cooldown = 300

/datum/caste_datum/carrier/elder
	upgrade_name = "Elder"
	caste_desc = "A portable Love transport. It looks pretty strong."
	upgrade = 2
	melee_damage_lower = 30
	melee_damage_upper = 40
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	plasma_gain = 0.035
	armor_deflection = 20
	max_health = 225
	speed = -0.2
	aura_strength = 2
	huggers_max = 10
	hugger_delay = 20
	eggs_max = 5
	egg_cooldown = 250

/datum/caste_datum/carrier/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	caste_desc = "It's literally crawling with 10 huggers."
	melee_damage_lower = 30
	melee_damage_upper = 40
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	plasma_gain = 0.035
	armor_deflection = 20
	max_health = 225
	speed = -0.2
	aura_strength = 2
	huggers_max = 10
	hugger_delay = 20
	eggs_max = 5
	egg_cooldown = 220

/mob/living/carbon/Xenomorph/Carrier
	caste_name = "Carrier"
	name = "Carrier"
	desc = "A strange-looking alien creature. It carries a number of scuttling jointed crablike creatures."
	icon = 'icons/Xeno/xenomorph_64x64.dmi' //They are now like, 2x2
	icon_state = "Carrier Walking"

	drag_delay = 6 //pulling a big dead xeno is hard

	mob_size = MOB_SIZE_BIG
	tier = 3
	pixel_x = -16 //Needed for 2x2
	old_x = -16

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/plant_weeds,
		/datum/action/xeno_action/emit_pheromones,
		/datum/action/xeno_action/activable/throw_hugger,
		/datum/action/xeno_action/activable/retrieve_egg,
		/datum/action/xeno_action/place_trap
		)

	new_actions = list(
		/datum/action/xeno_action/activable/lay_egg,
	)

	death(gibbed)
		if(..(gibbed))
			var/obj/item/xeno_egg/E
			var/obj/item/clothing/mask/facehugger/F
			var/chance = 75

			while (eggs_cur > 0)
				if(prob(chance))
					E = new(loc)
					E.hivenumber = hivenumber
					eggs_cur--
			if (huggers_cur)
				visible_message("<span class='xenowarning'>The chittering mass of tiny aliens is trying to escape [src]!</span>")
				while(huggers_cur)
					if(prob(chance))
						F = new(loc)
						F.hivenumber = hivenumber
						step_away(F,src,1)
					huggers_cur--


/mob/living/carbon/Xenomorph/Carrier/Stat()
	if (!..())
		return 0

	stat("Stored Huggers:", "[huggers_cur] / [huggers_max]")
	stat("Stored Eggs:", "[eggs_cur] / [eggs_max]")
	return 1

/mob/living/carbon/Xenomorph/Carrier/proc/store_hugger(obj/item/clothing/mask/facehugger/F)
	if(huggers_cur < huggers_max)
		if(F.stat == CONSCIOUS && !F.sterile)
			huggers_cur++
			src << "<span class='notice'>You store the facehugger and carry it for safekeeping. Now sheltering: [huggers_cur] / [huggers_max].</span>"
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
		src << "<span class='xenonotice'>You grab one of the facehugger in your storage. Now sheltering: [huggers_cur] / [huggers_max].</span>"
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
	if(eggs_cur < eggs_max)
		if(stat == CONSCIOUS)
			eggs_cur++
			src << "<span class='notice'>You store the egg and carry it for safekeeping. Now sheltering: [eggs_cur] / [eggs_max].</span>"
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
		src << "<span class='xenonotice'>You grab one of the eggs in your storage. Now sheltering: [eggs_cur] / [eggs_max].</span>"
		return

	if(!istype(E)) //something else in our hand
		src << "<span class='warning'>You need an empty hand to grab one of your stored eggs!</span>"
		return

/mob/living/carbon/Xenomorph/Carrier/proc/lay_egg()

	if(!check_state())
		return

	if(laid_egg)
		src << "<span class='xenowarning'>You must wait before laying another egg.</span>"
		return

	if(!check_plasma(50))
		return

	var/obj/item/xeno_egg/E = get_active_hand()
	if(!E)
		E = new()
		E.hivenumber = hivenumber
		put_in_active_hand(E)
		use_plasma(50)
		src << "<span class='xenonotice'>You produce an egg.</span>"
		playsound(loc, "alien_resin_build", 25)
		laid_egg = TRUE
		spawn(caste.egg_cooldown)
			laid_egg = FALSE
			src << "<span class='xenonotice'>You can produce an egg again.</span>"
			for(var/X in actions)
				var/datum/action/A = X
				A.update_button_icon()

	return 1