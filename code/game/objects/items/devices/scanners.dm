/*
CONTAINS:
T-RAY
DETECTIVE SCANNER
HEALTH ANALYZER
GAS ANALYZER
PLANT ANALYZER
MASS SPECTROMETER
REAGENT SCANNER
FORENSIC SCANNER
*/
/obj/item/device/t_scanner
	name = "\improper T-ray scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	icon_state = "t-ray0"
	var/on = 0
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	item_state = "electronic"

	matter = list("metal" = 150)

	

/obj/item/device/t_scanner/attack_self(mob/user)

	on = !on
	icon_state = "t-ray[on]"

	if(on)
		processing_objects.Add(src)


/obj/item/device/t_scanner/process()
	if(!on)
		processing_objects.Remove(src)
		return null

	for(var/turf/T in range(1, src.loc) )

		if(!T.intact_tile)
			continue

		for(var/obj/O in T.contents)

			if(O.level != 1)
				continue

			if(O.invisibility == 101)
				O.invisibility = 0
				O.alpha = 128
				spawn(10)
					if(O && !O.disposed)
						var/turf/U = O.loc
						if(U.intact_tile)
							O.invisibility = 101
							O.alpha = 255

		var/mob/living/M = locate() in T
		if(M && M.invisibility == 2)
			M.invisibility = 0
			spawn(2)
				if(M)
					M.invisibility = INVISIBILITY_LEVEL_TWO


/obj/item/device/healthanalyzer
	name = "\improper HF2 health analyzer"
	icon_state = "health"
	item_state = "analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject. The front panel is able to provide the basic readout of the subject's status."
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	throwforce = 3
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	matter = list("metal" = 200)
	
	var/mode = 1
	var/hud_mode = 1

/obj/item/device/healthanalyzer/attack(mob/living/M, mob/living/user)
	M.health_scan(user, FALSE, mode, hud_mode)
	src.add_fingerprint(user)
	return

/obj/item/device/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"
	mode = !mode
	switch (mode)
		if(1)
			to_chat(usr, "The scanner now shows specific limb damage.")
		if(0)
			to_chat(usr, "The scanner no longer shows limb damage.")

/obj/item/device/healthanalyzer/verb/toggle_hud_mode()
	set name = "Switch Hud"
	set category = "Object"
	hud_mode = !hud_mode
	switch (hud_mode)
		if(1)
			to_chat(usr, "The scanner now shows results on the hud.")
		if(0)
			to_chat(usr, "The scanner no longer shows results on the hud.")

/obj/item/device/analyzer
	desc = "A hand-held environmental scanner which reports current gas levels."
	name = "analyzer"
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

	matter = list("metal" = 30,"glass" = 20)

	

/obj/item/device/analyzer/attack_self(mob/user as mob)

	if (user.stat)
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
		return

	var/turf/location = user.loc
	if (!( istype(location, /turf) ))
		return

	var/env_pressure = location.return_pressure()
	var/env_gas = location.return_gas()
	var/env_temp = location.return_temperature()

	user.show_message(SPAN_NOTICE("<B>Results:</B>"), 1)
	if(abs(env_pressure - ONE_ATMOSPHERE) < 10)
		user.show_message(SPAN_NOTICE("Pressure: [round(env_pressure,0.1)] kPa"), 1)
	else
		user.show_message(SPAN_DANGER("Pressure: [round(env_pressure,0.1)] kPa"), 1)
	if(env_pressure > 0)
		user.show_message(SPAN_NOTICE("Gas Type: [env_gas]"), 1)
		user.show_message(SPAN_NOTICE("Temperature: [round(env_temp-T0C)]&deg;C"), 1)

	src.add_fingerprint(user)
	return

/obj/item/device/mass_spectrometer
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	name = "mass-spectrometer"
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT|OPENCONTAINER
	flags_equip_slot = SLOT_WAIST
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

	matter = list("metal" = 30,"glass" = 20)

	
	var/details = 0
	var/recent_fail = 0

/obj/item/device/mass_spectrometer/New()
	..()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/device/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/device/mass_spectrometer/attack_self(mob/user as mob)
	if (user.stat)
		return
	if (crit_fail)
		to_chat(user, SPAN_DANGER("This device has critically failed and is no longer functional!"))
		return
	if (!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		to_chat(user, SPAN_DANGER("You don't have the dexterity to do this!"))
		return
	return


/obj/item/device/mass_spectrometer/adv
	name = "advanced mass-spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	

/obj/item/device/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	matter = list("metal" = 30,"glass" = 20)

	
	var/details = 0
	var/recent_fail = 0

/obj/item/device/reagent_scanner/afterattack(obj/O, mob/user as mob, proximity)
	if(!proximity)
		return
	if (user.stat)
		return
	if (!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		to_chat(user, SPAN_DANGER("You don't have the dexterity to do this!"))
		return
	if(!istype(O))
		return
	if (crit_fail)
		to_chat(user, SPAN_DANGER("This device has critically failed and is no longer functional!"))
		return

	if(!isnull(O.reagents))
		var/dat = ""
		if(O.reagents.reagent_list.len > 0)
			var/one_percent = O.reagents.total_volume / 100
			for (var/datum/reagent/R in O.reagents.reagent_list)
				if(prob(reliability))
					dat += "\n \t \blue [R.name][details ? ": [R.volume / one_percent]%" : ""]"
					recent_fail = 0
				else if(recent_fail)
					crit_fail = 1
					dat = null
					break
				else
					recent_fail = 1
		if(dat)
			to_chat(user, SPAN_NOTICE(" Chemicals found: [dat]"))
		else
			to_chat(user, SPAN_NOTICE(" No active chemical agents found in [O]."))
	else
		to_chat(user, SPAN_NOTICE(" No significant chemical agents found in [O]."))

	return

/obj/item/device/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
