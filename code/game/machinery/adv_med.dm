// Pretty much everything here is stolen from the dna scanner FYI


/obj/structure/machinery/bodyscanner
	name = "body scanner"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1

	use_power = 1
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.
	var/mob/living/carbon/occupant
	var/locked
	var/obj/structure/machinery/body_scanconsole/connected


/obj/structure/machinery/bodyscanner/Initialize()
	. = ..()
	connect_body_scanconsole()
	flags_atom |= USES_HEARING


/obj/structure/machinery/bodyscanner/proc/connect_body_scanconsole()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/body_scanconsole,get_step(src, EAST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/body_scanconsole,get_step(src, WEST))
	if(connected)
		connected.connected = src

/obj/structure/machinery/bodyscanner/Destroy()
	if(occupant)
		go_out()
	if(connected)
		connected.connected = null
		QDEL_NULL(connected)
	. = ..()

/obj/structure/machinery/bodyscanner/relaymove(mob/user)
	if(user.is_mob_incapacitated(TRUE))
		return
	go_out()


/obj/structure/machinery/bodyscanner/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Body Scanner"

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/structure/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Body Scanner"

	if (usr.stat || !(ishuman(usr)))
		return
	if (src.occupant)
		to_chat(usr, SPAN_BOLDNOTICE("The scanner is already occupied!"))
		return
	if (usr.abiotic())
		to_chat(usr, SPAN_BOLDNOTICE("Subject cannot have abiotic items on."))
		return
	go_in_bodyscanner(usr)
	add_fingerprint(usr)


/obj/structure/machinery/bodyscanner/proc/go_in_bodyscanner(mob/M)
	if(isXeno(M))
		return
	if(do_after(usr, 10, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		if(occupant)
			to_chat(usr, SPAN_BOLDNOTICE("The scanner is already occupied!"))
			return
		to_chat(usr, SPAN_NOTICE("You move [M.name] inside \the [src]."))
		M.forceMove(src)
		occupant = M
		update_use_power(2)
		icon_state = "body_scanner_1"
		//prevents occupant's belonging from landing inside the machine
		for(var/obj/O in src)
			O.forceMove(loc)
		playsound(src, 'sound/machines/scanning_pod1.ogg')

/obj/structure/machinery/bodyscanner/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
	for(var/obj/O in src)
		O.forceMove(loc)
		//Foreach goto(30)
	occupant.forceMove(loc)
	occupant = null
	update_use_power(1)
	icon_state = "body_scanner_0"
	playsound(src, 'sound/machines/hydraulics_3.ogg')


/obj/structure/machinery/bodyscanner/attack_hand(mob/living/user)
	go_out()

//clickdrag code - "resist to get out" code is in living_verbs.dm
/obj/structure/machinery/bodyscanner/MouseDrop_T(mob/target, mob/user)
	. = ..()
	var/mob/living/H = user
	if(!istype(H) || target != user) //cant make others get in. grab-click for this
		return

	go_in_bodyscanner(target)

/obj/structure/machinery/bodyscanner/attackby(obj/item/I, mob/living/user)
	var/mob/M
	if (istype(I, /obj/item/grab))
		if (occupant)
			to_chat(user, SPAN_WARNING("The scanner is already occupied!"))
			return
		var/obj/item/grab/G = I
		if(istype(G.grabbed_thing,/obj/structure/closet/bodybag/cryobag))
			var/obj/structure/closet/bodybag/cryobag/C = G.grabbed_thing
			if(!C.stasis_mob)
				to_chat(user, SPAN_WARNING("The stasis bag is empty!"))
				return
			M = C.stasis_mob
			C.open()
			user.start_pulling(M)
		else if(ismob(G.grabbed_thing))
			M = G.grabbed_thing
		else
			return
	else
		return
	if (M.abiotic())
		to_chat(user, SPAN_WARNING("Subject cannot have abiotic items on."))
		return
	if (isXeno(M))
		to_chat(user, SPAN_WARNING("An unsupported lifeform was detected, aborting!"))
		return

	go_in_bodyscanner(M)
	add_fingerprint(user)
	//G = null


/obj/structure/machinery/bodyscanner/ex_act(var/severity, var/datum/cause_data/cause_data)
	for(var/atom/movable/A as mob|obj in src)
		A.forceMove(loc)
		A.ex_act(severity, , cause_data)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
		else
	return

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/bodyscanner/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant) && occupant.stat != DEAD)
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH

/obj/structure/machinery/body_scanconsole
	name = "body scanner console"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "body_scannerconsole"
	density = 0
	anchored = TRUE
	dir = SOUTH
	var/obj/structure/machinery/bodyscanner/connected
	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)
	var/delete
	var/temphtml
	var/datum/health_scan/last_health_display

/obj/structure/machinery/body_scanconsole/Initialize()
	. = ..()
	connect_bodyscanner()


/obj/structure/machinery/body_scanconsole/proc/connect_bodyscanner()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/bodyscanner,get_step(src, WEST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/bodyscanner,get_step(src, EAST))
	if(connected)
		connected.connected = src


/obj/structure/machinery/body_scanconsole/Destroy()
	QDEL_NULL(last_health_display)
	if(connected)
		if(connected.occupant)
			connected.go_out()

		connected.connected = null
		QDEL_NULL(connected)
	. = ..()


/obj/structure/machinery/body_scanconsole/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
		else
	return

/obj/structure/machinery/body_scanconsole/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "body_scannerconsole-p"
	else
		if (stat & NOPOWER)
			spawn(rand(0, 15))
				src.icon_state = "body_scannerconsole-p"
		else
			icon_state = initial(icon_state)



/obj/structure/machinery/body_scanconsole/attack_remote(user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/body_scanconsole/attack_hand(var/mob/living/user)
	if(..())
		return
	if(inoperable())
		to_chat(user, SPAN_WARNING("This console is not functional."))
		return
	if(!connected || (connected.inoperable()))
		to_chat(user, SPAN_WARNING("This console is not connected to a functioning body scanner."))
		return

	if(!connected.occupant)
		to_chat(user, SPAN_WARNING("No lifeform detected."))
		return

	if(!ishuman(connected.occupant))
		to_chat(user, SPAN_WARNING("This device can only scan compatible lifeforms."))
		return

	var/mob/living/carbon/human/H = connected.occupant
	var/datum/data/record/N = null
	var/human_ref = WEAKREF(H)
	for(var/datum/data/record/R as anything in GLOB.data_core.medical)
		if (R.fields["ref"] == human_ref)
			N = R
	if(isnull(N))
		N = create_medical_record(H)
	var/list/od = connected.get_occupant_data()
	var/dat
	dat = format_occupant_data(od)
	N.fields["last_scan_time"] = od["stationtime"]
	// I am sure you are wondering why this is still here. And indeed why the rest of the autodoc html shit is here.
	// The answer is : it is used in the medical records computer to print out the results of their last scan data
	// Do I want to make it so that data from a tgui static data proc can go into a piece of paper? no
	// Do I want to remove the feature from medical records computers? no
	// and so here we are.
	N.fields["last_scan_result"] = dat

	if (!last_health_display)
		last_health_display = new(H)
	else
		last_health_display.target_mob = H

	N.fields["last_tgui_scan_result"] = last_health_display.ui_data(user, DETAIL_LEVEL_BODYSCAN)
	N.fields["autodoc_data"] = generate_autodoc_surgery_list(H)
	visible_message(SPAN_NOTICE("\The [src] pings as it stores the scan report of [H.real_name]"))
	playsound(src.loc, 'sound/machines/screen_output1.ogg', 25)

	last_health_display.look_at(user, DETAIL_LEVEL_BODYSCAN, bypass_checks = TRUE)

	return

/obj/structure/machinery/bodyscanner/proc/get_occupant_data()
	if (!occupant || !istype(occupant, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = occupant
	var/list/occupant_data = list(
		"stationtime" = worldtime2text(),
		"stat" = H.stat,
		"health" = H.health,
		"bruteloss" = H.getBruteLoss(),
		"fireloss" = H.getFireLoss(),
		"oxyloss" = H.getOxyLoss(),
		"toxloss" = H.getToxLoss(),
		"cloneloss" = H.getCloneLoss(),
		"brainloss" = H.getBrainLoss(),
		"knocked_out" = H.knocked_out,
		"bodytemp" = H.bodytemperature,
		"inaprovaline_amount" = H.reagents.get_reagent_amount("inaprovaline"),
		"dexalin_amount" = H.reagents.get_reagent_amount("dexalin"),
		"bicaridine_amount" = H.reagents.get_reagent_amount("bicaridine"),
		"dermaline_amount" = H.reagents.get_reagent_amount("dermaline"),
		"meralyne_amount" = H.reagents.get_reagent_amount("meralyne"),
		"blood_amount" = H.blood_volume,
		"max_blood" = H.max_blood,
		"disabilities" = H.sdisabilities,
		"tg_diseases_list" = H.viruses.Copy(),
		"lung_ruptured" = H.is_lung_ruptured(),
		"external_organs" = H.limbs.Copy(),
		"internal_organs" = H.internal_organs.Copy(),
		"species_organs" = H.species.has_organ //Just pass a reference for this, it shouldn't ever be modified outside of the datum.
		)
	return occupant_data


/obj/structure/machinery/body_scanconsole/proc/format_occupant_data(var/list/occ)
	var/dat = "<html><head><style>"
	dat += "table {border: 2px solid; border-collapse: collapse;}"
	dat += "td, th {border: 1px solid; padding-left: 5 px; padding-right: 5px;}"
	dat += "tr {border: 1px solid;}"
	dat += "</style></head><body>"
	dat += "<b>[SET_CLASS("Scan time:", INTERFACE_HEADER_COLOR)] [occ["stationtime"]]<br>"
	dat += "[SET_CLASS("Occupant Statistics:", INTERFACE_HEADER_COLOR)]<br>"
	var/aux
	switch (occ["stat"])
		if(0)
			aux = "Conscious"
		if(1)
			aux = "Unconscious"
		else
			aux = "Dead"
	var/s_class = occ["health"] > 50 ? INTERFACE_GOOD : INTERFACE_BAD
	dat += "[SET_CLASS("Health:", INTERFACE_HEADER_COLOR)] [SET_CLASS("[occ["health"]]% ([aux])</font>", s_class)]<br>"
	if (occ["virus_present"])
		dat += SET_CLASS("Viral pathogen detected in blood stream.", INTERFACE_RED)
		dat += "<br>"

	s_class = occ["bruteloss"] < 60 ? INTERFACE_GOOD : INTERFACE_BAD
	dat += "[SET_CLASS("&nbsp&nbspBrute Damage:", INTERFACE_RED)] [SET_CLASS("[occ["bruteloss"]]%", s_class)]<br>"

	s_class = occ["oxyloss"] < 60 ? INTERFACE_GOOD : INTERFACE_BAD
	dat += "[SET_CLASS("&nbsp&nbspRespiratory Damage:", INTERFACE_BLUE)] [SET_CLASS("[occ["oxyloss"]]%", s_class)]<br>"

	s_class = occ["toxloss"] < 60 ? INTERFACE_GOOD : INTERFACE_BAD
	dat += "[SET_CLASS("&nbsp&nbspToxin Content:", INTERFACE_GREEN)] [SET_CLASS("[occ["toxloss"]]%", s_class)]<br>"

	s_class = occ["fireloss"] < 60 ? INTERFACE_GOOD : INTERFACE_BAD
	dat += "[SET_CLASS("&nbsp&nbspBurn Severity:", INTERFACE_ORANGE)] [SET_CLASS("[occ["fireloss"]]%", s_class)]<br>"

	s_class = occ["cloneloss"] < 1 ? INTERFACE_GOOD : INTERFACE_BAD
	dat += "[SET_CLASS("&nbsp&nbspGenetic Tissue Damage:", INTERFACE_CYAN)] [SET_CLASS("[occ["cloneloss"]]%", s_class)]<br>"

	s_class = occ["brainloss"] < 1 ? INTERFACE_GOOD : INTERFACE_BAD
	dat += "[SET_CLASS("&nbsp&nbspApprox. Brain Damage:", INTERFACE_PINK)] [SET_CLASS("[occ["brainloss"]]%", s_class)]<br><br>"

	dat += "[SET_CLASS("Knocked Out Summary:", "#40628a")] [occ["knocked_out"]]% ([round(occ["knocked_out"] / 4)] seconds left!)<br>"
	dat += "[SET_CLASS("Body Temperature:", "#40628a")] [occ["bodytemp"]-T0C]&deg;C ([occ["bodytemp"]*1.8-459.67]&deg;F)<br><HR>"

	s_class = occ["blood_amount"] > 448 ? INTERFACE_OKAY : INTERFACE_BAD
	dat += "[SET_CLASS("Blood Level:", INTERFACE_HEADER_COLOR)] [SET_CLASS("[occ["blood_amount"]*100 / occ["max_blood"]]% ([occ["blood_amount"]] units)", s_class)]<br><br>"

	dat += "[SET_CLASS("Inaprovaline:", INTERFACE_HEADER_COLOR)] [occ["inaprovaline_amount"]] units<BR>"

	s_class = occ["dermaline_amount"] < 30 ? INTERFACE_OKAY : INTERFACE_BAD
	dat += "[SET_CLASS("Dermaline:", INTERFACE_HEADER_COLOR)] [SET_CLASS("[occ["dermaline_amount"]] units:", s_class)]<BR>"

	s_class = occ["meralyne_amount"] < 30 ? INTERFACE_OKAY : INTERFACE_BAD
	dat += "[SET_CLASS("Meralyne:", INTERFACE_HEADER_COLOR)] [SET_CLASS("[occ["meralyne_amount"]] units:", s_class)]<BR>"

	s_class = occ["bicaridine_amount"] < 30 ? INTERFACE_OKAY : INTERFACE_BAD
	dat += "[SET_CLASS("Bicaridine:", INTERFACE_HEADER_COLOR)] [SET_CLASS("[occ["bicaridine_amount"]] units", s_class)]<BR>"

	s_class = occ["dexalin_amount"] < 30 ? INTERFACE_OKAY : INTERFACE_BAD
	dat += "[SET_CLASS("Dexalin:", INTERFACE_HEADER_COLOR)] [SET_CLASS("[occ["dexalin_amount"]] units", s_class)]<BR>"

	for(var/datum/disease/D in occ["tg_diseases_list"])
		if(!D.hidden[SCANNER])
			dat += SET_CLASS("<B>Warning: [D.form] Detected</B>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]</b>", INTERFACE_RED)
			dat += "<BR>"

	dat += "<HR><table>"
	dat += "<tr>"
	dat += "<th>Organ</th>"
	dat += "<th>Burn Damage</th>"
	dat += "<th>Brute Damage</th>"
	dat += "<th>Other Wounds</th>"
	dat += "</tr>"

	for(var/obj/limb/e in occ["external_organs"])
		var/AN = ""
		var/open = ""
		var/imp = ""
		var/bled = ""
		var/robot = ""
		var/splint = ""
		var/internal_bleeding = ""
		var/lung_ruptured = ""

		dat += "<tr>"

		for(var/datum/effects/bleeding/internal/I in e.bleeding_effects_list)
			internal_bleeding = "Internal bleeding<br>"
			break
		if(istype(e, /obj/limb/chest) && occ["lung_ruptured"])
			lung_ruptured = "Lung ruptured:<br>"
		if(e.status & LIMB_SPLINTED_INDESTRUCTIBLE)
			splint = "Nanosplinted<br>"
		else if(e.status & LIMB_SPLINTED)
			splint = "Splinted<br>"
		for(var/datum/effects/bleeding/external/E in e.bleeding_effects_list)
			bled = "Bleeding<br>"
			break
		if(e.status & LIMB_BROKEN)
			AN = "[e.broken_description]<br>"
		else if(e.status & LIMB_ROBOT)
			if(e.status & LIMB_UNCALIBRATED_PROSTHETIC)
				robot = "Nonfunctional prosthetic<br>"
			else
				robot = "Prosthetic<br>"
		else if(e.status & LIMB_SYNTHSKIN)
			robot = "Synthskin"
		if(e.get_incision_depth())
			open = "Open<br>"

		var/unknown_body = 0
		if (e.implants.len)
			for(var/I in e.implants)
				if(is_type_in_list(I,known_implants))
					imp += "[I] implanted<br>"
				else
					unknown_body++
		if(e.hidden)
			unknown_body++
		if(e.body_part == BODY_FLAG_CHEST) //embryo in chest?
			if(locate(/obj/item/alien_embryo) in connected.occupant)
				unknown_body++
		if(unknown_body)
			if(unknown_body > 1)
				imp += "Unknown bodies present<br>"
			else
				imp += "Unknown body present<br>"

		if(!AN && !open && !imp && !bled && !internal_bleeding && !lung_ruptured)
			AN = "None"

		if(!(e.status & LIMB_DESTROYED))
			dat += "<td>[e.display_name]</td><td>[e.burn_dam]</td><td>[e.brute_dam]</td><td>[robot][bled][AN][splint][open][imp][internal_bleeding][lung_ruptured]</td>"
		else
			dat += "<td>[e.display_name]</td><td>-</td><td>-</td><td>Not Found</td>"
		dat += "</tr>"

	for(var/datum/internal_organ/i in occ["internal_organs"])
		var/mech = ""
		if(i.robotic == ORGAN_ASSISTED)
			mech += "Assisted<br>"
		if(i.robotic == ORGAN_ROBOT)
			mech += "Mechanical<br>"

		if(!mech)
			mech = "None"

		dat += "<tr>"
		dat += "<td>[i.name]</td><td>N/A</td><td>[i.damage]</td><td>[mech]</td>"
		dat += "</tr>"
	dat += "</table>"

	var/list/species_organs = occ["species_organs"]
	for(var/organ_name in species_organs)
		if(!locate(species_organs[organ_name]) in occ["internal_organs"])
			dat += SET_CLASS("No [organ_name] detected.", INTERFACE_RED)
			dat += "<BR>"

	if(occ["sdisabilities"] & DISABILITY_BLIND)
		dat += SET_CLASS("Cataracts detected.", INTERFACE_RED)
		dat += "<BR>"
	if(occ["sdisabilities"] & NEARSIGHTED)
		dat += SET_CLASS("Retinal misalignment detected.", INTERFACE_RED)
		dat += "<BR>"

	dat += "</body></html>"
	return dat

