
/obj/item/reagent_container/borghypo
	name = "Robot Hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/items/syringe.dmi'
	item_state = "hypo"
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null
	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 2 SECONDS //Time it takes for shots to recharge

	var/list/reagent_ids = list("tricordrazine", "bicaridine", "kelotane", "dexalinp", "anti_toxin", "inaprovaline", "tramadol", "imidazoline", "spaceacillin", "quickclot")
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()

/obj/item/reagent_container/borghypo/Initialize()
	. = ..()

	for(var/T in reagent_ids)
		reagent_volumes[T] = volume
		var/datum/reagent/R = chemical_reagents_list[T]
		reagent_names += R.name

	START_PROCESSING(SSobj, src)


/obj/item/reagent_container/borghypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/reagent_container/borghypo/process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
	if(++charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume)
					R.cell.use(charge_cost)
					reagent_volumes[T] = min(reagent_volumes[T] + 5, volume)
	return 1

/obj/item/reagent_container/borghypo/attack(mob/living/M as mob, mob/user as mob)
	if(!istype(M))
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, SPAN_WARNING("The injector is empty."))
		return

	to_chat(user, SPAN_NOTICE(" You inject [M] with the injector."))
	to_chat(M, SPAN_NOTICE(" [user] injects you with the injector."))
	playsound(loc, 'sound/items/hypospray.ogg', 50, 1)

	if(M.reagents)
		var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
		M.reagents.add_reagent(reagent_ids[mode], t)
		reagent_volumes[reagent_ids[mode]] -= t
		// to_chat(user, SPAN_NOTICE("[t] units injected. [reagent_volumes[reagent_ids[mode]]] units remaining."))
		to_chat(user, SPAN_NOTICE(" [t] units of \red [reagent_ids[mode]] \blue injected for a total of \red [round(M.reagents.get_reagent_amount(reagent_ids[mode]))]\blue. [reagent_volumes[reagent_ids[mode]]] units remaining."))

	return

/obj/item/reagent_container/borghypo/attack_self(mob/user)
	..()
	var/selection = tgui_input_list(usr, "Please select a reagent:", "Reagent", reagent_ids)
	if(!selection) return
	var/datum/reagent/R = chemical_reagents_list[selection]
	to_chat(user, SPAN_NOTICE(" Synthesizer is now producing '[R.name]'."))
	mode = reagent_ids.Find(selection)
	playsound(src.loc, 'sound/effects/pop.ogg', 15, 0)
	return

/obj/item/reagent_container/borghypo/get_examine_text(mob/user)
	. = ..()
	if (user != loc) return

	var/datum/reagent/R = chemical_reagents_list[reagent_ids[mode]]

	. += SPAN_NOTICE("It is currently producing [R.name] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left.")
