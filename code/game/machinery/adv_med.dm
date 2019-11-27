// Pretty much everything here is stolen from the dna scanner FYI


/obj/structure/machinery/bodyscanner
	name = "Body Scanner"
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
	..()
	connect_body_scanconsole()


/obj/structure/machinery/bodyscanner/proc/connect_body_scanconsole()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/body_scanconsole,get_step(src, EAST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/body_scanconsole,get_step(src, WEST))
	if(connected)
		connected.connected = src

/obj/structure/machinery/bodyscanner/Dispose()
	if(occupant)
		go_out()
	if(connected)
		connected.connected = null
		qdel(connected)
		connected = null
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
		to_chat(usr, SPAN_NOTICE(" <B>The scanner is already occupied!</B>"))
		return
	if (usr.abiotic())
		to_chat(usr, SPAN_NOTICE(" <B>Subject cannot have abiotic items on.</B>"))
		return
	go_in_bodyscanner(usr)
	add_fingerprint(usr)


/obj/structure/machinery/bodyscanner/proc/go_in_bodyscanner(mob/M)
	M.forceMove(src)
	occupant = M
	update_use_power(2)
	icon_state = "body_scanner_1"
	//prevents occupant's belonging from landing inside the machine
	for(var/obj/O in src)
		O.loc = loc


/obj/structure/machinery/bodyscanner/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
	for(var/obj/O in src)
		O.loc = src.loc
		//Foreach goto(30)
	occupant.forceMove(loc)
	occupant = null
	update_use_power(1)
	icon_state = "body_scanner_0"


/obj/structure/machinery/bodyscanner/attack_hand(mob/living/user)
	go_out()

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

	go_in_bodyscanner(M)

	add_fingerprint(user)
	//G = null


/obj/structure/machinery/bodyscanner/ex_act(var/severity, var/source)
	for(var/atom/movable/A as mob|obj in src)
		A.loc = src.loc
		A.ex_act(severity, , source)
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



/obj/structure/machinery/body_scanconsole
	name = "Body Scanner Console"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "body_scannerconsole"
	density = 0
	anchored = TRUE
	dir = SOUTH
	var/obj/structure/machinery/bodyscanner/connected
	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)
	var/delete
	var/temphtml

/obj/structure/machinery/body_scanconsole/Initialize()
	..()
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


/obj/structure/machinery/body_scanconsole/Dispose()
	if(connected)
		if(connected.occupant)
			connected.go_out()

		connected.connected = null
		qdel(connected)
		connected = null
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



/obj/structure/machinery/body_scanconsole/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/body_scanconsole/attack_hand(var/mob/living/user)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, SPAN_WARNING("This console is not functional."))
		return
	if(!connected || (connected.stat & (NOPOWER|BROKEN)))
		to_chat(user, SPAN_WARNING("This console is not connected to a functioning body scanner."))
		return

	if(!connected.occupant)
		to_chat(user, SPAN_WARNING("No lifeform detected."))
		return

	if(!ishuman(connected.occupant))
		to_chat(user, SPAN_WARNING("This device can only scan compatible lifeforms."))
		return

	var/dat
	if (delete && temphtml) //Window in buffer but its just simple message, so nothing
		delete = delete
	else if (!delete && temphtml) //Window in buffer - its a menu, dont add clear message
		dat = text("[]<BR><BR><A href='?src=\ref[];clear=1'>Main Menu</A>", temphtml, src)
	else
		if (connected) //Is something connected?
			var/mob/living/carbon/human/H = connected.occupant
			var/datum/data/record/N = null
			for(var/datum/data/record/R in data_core.medical)
				if (R.fields["name"] == H.real_name)
					N = R
			if(isnull(N))
				N = create_medical_record(H)
			var/list/od = connected.get_occupant_data()
			dat = format_occupant_data(od)
			N.fields["last_scan_time"] = od["stationtime"]
			N.fields["last_scan_result"] = dat
			N.fields["autodoc_data"] = generate_autodoc_surgery_list(H)
			visible_message(SPAN_NOTICE("\The [src] pings as it stores the scan report of [connected.occupant.real_name]"))
			playsound(src.loc, 'sound/machines/ping.ogg', 25, 1)
			//dat += "<HR><A href='?src=\ref[src];print=1'>Print</A><BR>" // no more printing
		else
			dat = "<font color='red'> Error: No Body Scanner connected.</font>"

	dat += text("<BR><A href='?src=\ref[];mach_close=scanconsole'>Close</A>", user)
	user << browse(dat, "window=scanconsole;size=430x600")
	return


/obj/structure/machinery/body_scanconsole/Topic(href, href_list)
	if (..())
		return

	if (href_list["print"])
		if (!src.connected)
			to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Error: No body scanner connected.")]")
			return
		var/mob/living/carbon/human/occupant = src.connected.occupant
		if (!src.connected.occupant)
			to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("The body scanner is empty.")]")
			return
		if (!istype(occupant,/mob/living/carbon/human))
			to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("The body scanner cannot scan that lifeform.")]")
			return
		var/obj/item/paper/R = new(src.loc)
		R.name = "Body scan report -[src.connected.occupant.real_name]-"
		R.info = format_occupant_data(src.connected.get_occupant_data())


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
		"stoxin_amount" = H.reagents.get_reagent_amount("suxamorycin"),
		"bicaridine_amount" = H.reagents.get_reagent_amount("bicaridine"),
		"dermaline_amount" = H.reagents.get_reagent_amount("dermaline"),
		"blood_amount" = H.blood_volume,
		"disabilities" = H.sdisabilities,
		"tg_diseases_list" = H.viruses.Copy(),
		"lung_ruptured" = H.is_lung_ruptured(),
		"external_organs" = H.limbs.Copy(),
		"internal_organs" = H.internal_organs.Copy(),
		"species_organs" = H.species.has_organ //Just pass a reference for this, it shouldn't ever be modified outside of the datum.
		)
	return occupant_data


/obj/structure/machinery/body_scanconsole/proc/format_occupant_data(var/list/occ)
	var/dat = "<font color='blue'><b>Scan performed at [occ["stationtime"]]</b></font><br>"
	dat += "<font color='blue'><b>Occupant Statistics:</b></font><br>"
	var/aux
	switch (occ["stat"])
		if(0)
			aux = "Conscious"
		if(1)
			aux = "Unconscious"
		else
			aux = "Dead"
	dat += text("[]\tHealth %: [] ([])</font><br>", (occ["health"] > 50 ? "<font color='blue'>" : "<font color='red'>"), occ["health"], aux)
	if (occ["virus_present"])
		dat += "<font color='red'>Viral pathogen detected in blood stream.</font><br>"
	dat += text("[]\t-Brute Damage %: []</font><br>", (occ["bruteloss"] < 60 ? "<font color='blue'>" : "<font color='red'>"), occ["bruteloss"])
	dat += text("[]\t-Respiratory Damage %: []</font><br>", (occ["oxyloss"] < 60 ? "<font color='blue'>" : "<font color='red'>"), occ["oxyloss"])
	dat += text("[]\t-Toxin Content %: []</font><br>", (occ["toxloss"] < 60 ? "<font color='blue'>" : "<font color='red'>"), occ["toxloss"])
	dat += text("[]\t-Burn Severity %: []</font><br><br>", (occ["fireloss"] < 60 ? "<font color='blue'>" : "<font color='red'>"), occ["fireloss"])

	dat += text("[]\tGenetic Tissue Damage %: []</font><br>", (occ["cloneloss"] < 1 ?"<font color='blue'>" : "<font color='red'>"), occ["cloneloss"])
	dat += text("[]\tApprox. Brain Damage %: []</font><br>", (occ["brainloss"] < 1 ?"<font color='blue'>" : "<font color='red'>"), occ["brainloss"])
	dat += text("Knocked Out Summary %: [] ([] seconds left!)<br>", occ["knocked_out"], round(occ["knocked_out"] / 4))
	dat += text("Body Temperature: [occ["bodytemp"]-T0C]&deg;C ([occ["bodytemp"]*1.8-459.67]&deg;F)<br><HR>")

	dat += text("[]\tBlood Level %: [] ([] units)</FONT><BR>", (occ["blood_amount"] > 448 ?"<font color='blue'>" : "<font color='red'>"), occ["blood_amount"]*100 / 560, occ["blood_amount"])

	dat += text("Inaprovaline: [] units<BR>", occ["inaprovaline_amount"])
	dat += text("Suxamorycin: [] units<BR>", occ["stoxin_amount"])
	dat += text("[]\tDermaline: [] units</FONT><BR>", (occ["dermaline_amount"] < 30 ? "<font color='black'>" : "<font color='red'>"), occ["dermaline_amount"])
	dat += text("[]\tBicaridine: [] units<BR>", (occ["bicaridine_amount"] < 30 ? "<font color='black'>" : "<font color='red'>"), occ["bicaridine_amount"])
	dat += text("[]\tDexalin: [] units<BR>", (occ["dexalin_amount"] < 30 ? "<font color='black'>" : "<font color='red'>"), occ["dexalin_amount"])

	for(var/datum/disease/D in occ["tg_diseases_list"])
		if(!D.hidden[SCANNER])
			dat += text("<font color='red'><B>Warning: [D.form] Detected</B>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]</FONT><BR>")

	dat += "<HR><table border='1'>"
	dat += "<tr>"
	dat += "<th>Organ</th>"
	dat += "<th>Burn Damage</th>"
	dat += "<th>Brute Damage</th>"
	dat += "<th>Other Wounds</th>"
	dat += "</tr>"

	for(var/datum/limb/e in occ["external_organs"])
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
		if(istype(e, /datum/limb/chest) && occ["lung_ruptured"])
			lung_ruptured = "Lung ruptured:<br>"
		if(e.status & LIMB_SPLINTED)
			splint = "Splinted:<br>"
		for(var/datum/effects/bleeding/external/E in e.bleeding_effects_list)
			bled = "Bleeding:<br>"
			break
		if(e.status & LIMB_BROKEN)
			AN = "[e.broken_description]:<br>"
		if(e.status & LIMB_ROBOT)
			robot = "Prosthetic:<br>"
		if(e.surgery_open_stage)
			open = "Open:<br>"

		var/unknown_body = 0
		if (e.implants.len)
			for(var/I in e.implants)
				if(is_type_in_list(I,known_implants))
					imp += "[I] implanted:<br>"
				else
					unknown_body++
		if(e.hidden)
			unknown_body++
		if(e.body_part == BODY_FLAG_CHEST) //embryo in chest?
			if(locate(/obj/item/alien_embryo) in connected.occupant)
				unknown_body++
		if(unknown_body)
			if(unknown_body > 1)
				imp += "Unknown bodies present:<br>"
			else
				imp += "Unknown body present:<br>"

		if(!AN && !open && !imp && !bled && !internal_bleeding && !lung_ruptured)
			AN = "None:"
		if(!(e.status & LIMB_DESTROYED))
			dat += "<td>[e.display_name]</td><td>[e.burn_dam]</td><td>[e.brute_dam]</td><td>[robot][bled][AN][splint][open][imp][internal_bleeding][lung_ruptured]</td>"
		else
			dat += "<td>[e.display_name]</td><td>-</td><td>-</td><td>Not Found</td>"
		dat += "</tr>"

	for(var/datum/internal_organ/i in occ["internal_organs"])

		var/mech = ""
		if(i.robotic == ORGAN_ASSISTED)
			mech = "Assisted:<br>"
		if(i.robotic == ORGAN_ROBOT)
			mech = "Mechanical:<br>"

		dat += "<tr>"
		dat += "<td>[i.name]</td><td>N/A</td><td>[i.damage]</td><td>[mech]</td><td></td>"
		dat += "</tr>"
	dat += "</table>"

	var/list/species_organs = occ["species_organs"]
	for(var/organ_name in species_organs)
		if(!locate(species_organs[organ_name]) in occ["internal_organs"])
			dat += text("<font color='red'>No [organ_name] detected.</font><BR>")

	if(occ["sdisabilities"] & BLIND)
		dat += text("<font color='red'>Cataracts detected.</font><BR>")
	if(occ["sdisabilities"] & NEARSIGHTED)
		dat += text("<font color='red'>Retinal misalignment detected.</font><BR>")
	return dat

