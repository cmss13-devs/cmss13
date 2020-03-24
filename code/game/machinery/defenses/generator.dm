/obj/structure/machinery/generator
	name = "G3-N phoron generator"
	desc = "The most commonly used source for planetside powering of defenses. Produces high output with a special phoron blend with minimal heat."
	icon = 'icons/obj/structures/machinery/defenses.dmi'
	icon_state = "generator"
	health = 300
	anchored = TRUE
	density = FALSE
	use_power = FALSE
	var/obj/structure/machinery/defenses/defenses_in_range = list()
	var/turned_on = FALSE
	var/belonging_to_faction = list(FACTION_MARINE)

/obj/structure/machinery/generator/New(var/loc, var/mob/user)
	. = ..()

	if(istype(user))
		belonging_to_faction = list(user.faction)

	if(!(belonging_to_faction in faction_phoron_stored_list))
		belonging_to_faction = list(FACTION_MARINE)

/obj/structure/machinery/generator/Initialize()
	..()
	search_defenses()

/obj/structure/machinery/generator/update_icon()
	overlays.Cut()

	if(faction_phoron_stored_list[belonging_to_faction])
		switch(round(faction_phoron_stored_list[belonging_to_faction] * 100 / MAX_PHORON_STORAGE))
			if(75 to INFINITY)
				overlays += "+full_amount"
			if(25 to 75)
				overlays += "+medium_amount"
			if(1 to 25)
				overlays += "+small_amount"

	if(turned_on)
		icon_state = "generator_on"
	else
		icon_state = initial(icon_state)

/obj/structure/machinery/generator/process()
	if(!turned_on)
		return

	if(faction_phoron_stored_list[belonging_to_faction])
		var/phoron_percentage = round(faction_phoron_stored_list[belonging_to_faction] * 100 / MAX_PHORON_STORAGE)
		// Only update between these intervals
		if(0 > phoron_percentage < 10 || 20 > phoron_percentage < 30 || 70 > phoron_percentage < 80)
			update_icon()

	if(faction_phoron_stored_list[belonging_to_faction] <= 0)
		turned_on = FALSE
		power_on_defenses()
		stop_processing()
		update_icon()
	else
		faction_phoron_stored_list[belonging_to_faction] -= 0.2

	return

/obj/structure/machinery/generator/examine()
	..()
	if(faction_phoron_stored_list[belonging_to_faction])
		to_chat(usr, SPAN_NOTICE("[src] has [faction_phoron_stored_list[belonging_to_faction]] units of fuel left, producing power to defenses in a radius of [GEN_SEARCH_RANGE]."))
	else
		to_chat(usr, SPAN_NOTICE("It looks like [src] is lacking fuel."))

/obj/structure/machinery/generator/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/tank/phoron))
		var/obj/item/tank/phoron/P = O
		if(P.volume <= 0)
			to_chat(user, SPAN_NOTICE("[P] is empty."))
			return

		if(P.volume + faction_phoron_stored_list[belonging_to_faction] > MAX_PHORON_STORAGE)
			P.volume -= MAX_PHORON_STORAGE - faction_phoron_stored_list[belonging_to_faction]
			faction_phoron_stored_list[belonging_to_faction] = MAX_PHORON_STORAGE
			to_chat(user, SPAN_NOTICE("[name] is now full."))
			update_icon()
			return

		faction_phoron_stored_list[belonging_to_faction] += P.volume
		P.volume = 0
		P.update_icon()
		update_icon()
		return

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_METAL))
		to_chat(user, SPAN_WARNING("You are not trained to configure [src]..."))
		return

	if(iswrench(O))
		if(anchored)
			if(turned_on)
				to_chat(user, SPAN_WARNING("[src] is currently active. The motors will prevent you from unanchoring it safely."))
				return
			
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You unsecure [name] from the floor."))
			anchored = FALSE
			remove_from_defenses()
			defenses_in_range = list()
		else
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You secure [name] to the floor."))
			anchored = TRUE
			search_defenses()

	if(iscrowbar(O))
		user.visible_message(SPAN_NOTICE("[user] starts pulling [src] apart."), SPAN_NOTICE("You start pulling [src] apart."))
		playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)

		if(!do_after(user, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			return

		user.visible_message(SPAN_NOTICE("[user] pulls [src] apart."), SPAN_NOTICE("You pull [src] apart."))
		playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
		new /obj/item/stack/sheet/plasteel(loc, GEN_PLASTEEL_COST)
		qdel(src)

/obj/structure/machinery/generator/attack_hand(mob/user as mob)
	..()
	if(!anchored)
		return

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_PLASTEEL))
		to_chat(user, SPAN_WARNING("You don't have the training to do this."))
		return

	var/is_collector_on = FALSE
	for(var/obj/structure/machinery/collector/C in marine_collectors)
		is_collector_on = TRUE
		break

	if(!turned_on && (faction_phoron_stored_list[belonging_to_faction] <= 0) && !is_collector_on)
		to_chat(user, SPAN_NOTICE("[name] lacks fuel to turn on."))
		return

	if(!do_after(user, 5, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
		return

	turned_on = !turned_on
	if(turned_on)
		start_processing()
	else
		stop_processing()
	power_on_defenses()
	update_icon()

/obj/structure/machinery/generator/proc/search_defenses()
	defenses_in_range = list()
	for(var/obj/structure/machinery/defenses/D in orange(GEN_SEARCH_RANGE))
		if(!D.anchored)
			continue
		else
			D.add_generator(src)
			add_defense(D)


/obj/structure/machinery/generator/proc/power_on_defenses()
	for(var/obj/structure/machinery/defenses/D in defenses_in_range)
		D.power_on()

/obj/structure/machinery/generator/proc/remove_from_defenses()
	for(var/obj/structure/machinery/defenses/D in defenses_in_range)
		D.remove_generator(src)

/obj/structure/machinery/generator/proc/remove_defense(var/obj/structure/machinery/defenses/D)
	defenses_in_range -= D

/obj/structure/machinery/generator/proc/add_defense(var/obj/structure/machinery/defenses/D)
	defenses_in_range += D

/obj/structure/machinery/generator/power_change()
	return

/obj/structure/machinery/generator/Dispose()
	if(defenses_in_range)
		remove_from_defenses()
		defenses_in_range = null

	. = ..()
	