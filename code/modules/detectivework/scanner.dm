/obj/item/device/detective_scanner
	name = "forensic scanner"
	desc = "Used to scan objects for DNA and fingerprints."
	icon_state = "forensic1"
	var/list/stored = list()
	w_class = 3.0
	item_state = "electronic"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST

/obj/item/device/detective_scanner/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if (!ishuman(M))
		to_chat(user, SPAN_WARNING("[M] is not human and cannot have the fingerprints."))
		flick("forensic0",src)
		return 0
	if (M.gloves)
		to_chat(user, SPAN_NOTICE("No fingerprints found on [M]"))
		flick("forensic0",src)
		return 0
	else
		var/obj/item/f_card/F = new /obj/item/f_card( user.loc )
		F.amount = 1
		F.add_fingerprint(M)
		F.icon_state = "fingerprint1"
		F.name = text("FPrintC- '[M.name]'")
		to_chat(user, "<span class='notice'>Done printing.")
		to_chat(user, "<span class='notice'>[M]'s Fingerprints: [M.fingerprint]")
	if ( M.blood_DNA && M.blood_DNA.len )
		to_chat(user, SPAN_NOTICE("Blood found on [M]. Analysing..."))
		spawn(15)
			for(var/blood in M.blood_DNA)
				to_chat(user, SPAN_NOTICE("Blood type: [M.blood_DNA[blood]]\nDNA: [blood]"))
	return

/obj/item/device/detective_scanner/afterattack(atom/A as obj|turf, mob/user, proximity)
	if(!proximity) return
	if(ismob(A))
		return
	if(istype(A,/obj/machinery/computer/forensic_scanning))
		user.visible_message("[user] takes a cord out of [src] and hooks its end into [A]" ,\
		SPAN_NOTICE("You download data from [src] to [A]"))
		var/obj/machinery/computer/forensic_scanning/F = A
		F.sync_data(stored)
		return

	if(istype(A,/obj/item/f_card))
		to_chat(user, "The scanner displays on the screen: \"ERROR 43: Object on Excluded Object List.\"")
		flick("forensic0",src)
		return

	add_fingerprint(user)


	//General
	if(istype(A,/turf)) //Due to making blood invisible to the cursor, we need to make sure it scans it here.
		var/turf/T = get_turf(A)
		for(var/obj/effect/decal/cleanable/blood/B in T)
			if (B.blood_DNA && B.blood_DNA.len)
				to_chat(user, SPAN_NOTICE("Blood detected. Analysing..."))
				spawn(15)
					for(var/blood in B.blood_DNA)
						to_chat(user, "Blood type: \red [B.blood_DNA[blood]] \t \black DNA: \red [blood]")
					if(add_data(B))
						to_chat(user, SPAN_NOTICE("Object already in internal memory. Consolidating data..."))
						flick("forensic2",src)
				return
	if ((!A.fingerprints || !A.fingerprints.len) && !A.suit_fibers && !A.blood_DNA)
		user.visible_message("\The [user] scans \the [A] with \a [src], the air around [user.gender == MALE ? "him" : "her"] humming[prob(70) ? " gently." : "."]" ,\
		SPAN_WARNING("Unable to locate any fingerprints, materials, fibers, or blood on [A]!"),\
		"You hear a faint hum of electrical equipment.")
		flick("forensic0",src)
		return 0

	if(add_data(A))
		to_chat(user, SPAN_NOTICE("Object already in internal memory. Consolidating data..."))
		flick("forensic2",src)
		return

	//PRINTS
	if(A.fingerprints && A.fingerprints.len)
		to_chat(user, SPAN_NOTICE("Isolated [A.fingerprints.len] fingerprints:"))
		to_chat(user, "Data Stored: Scan with Hi-Res Forensic Scanner to retrieve.</span>")
		var/list/complete_prints = list()
		for(var/i in A.fingerprints)
			var/print = A.fingerprints[i]
			if(stringpercent(print) <= FINGERPRINT_COMPLETE)
				complete_prints += print
		if(complete_prints.len < 1)
			to_chat(user, SPAN_NOTICE("No intact prints found"))
		else
			to_chat(user, SPAN_NOTICE("Found [complete_prints.len] intact prints"))
			for(var/i in complete_prints)
				to_chat(user, SPAN_NOTICE("&nbsp;&nbsp;&nbsp;&nbsp;[i]"))

	//FIBERS
	if(A.suit_fibers && A.suit_fibers.len)
		to_chat(user, "<span class='notice'>Fibers/Materials Data Stored: Scan with Hi-Res Forensic Scanner to retrieve.")
		flick("forensic2",src)

	//Blood
	if (A.blood_DNA && A.blood_DNA.len)
		to_chat(user, SPAN_NOTICE("Blood detected. Analysing..."))
		spawn(15)
			for(var/blood in A.blood_DNA)
				to_chat(user, "Blood type: \red [A.blood_DNA[blood]] \t \black DNA: \red [blood]")

	user.visible_message("\The [user] scans \the [A] with \a [src], the air around [user.gender == MALE ? "him" : "her"] humming[prob(70) ? " gently." : "."]" ,\
	SPAN_NOTICE("You finish scanning \the [A]."),\
	"You hear a faint hum of electrical equipment.")
	flick("forensic2",src)
	return 0

/obj/item/device/detective_scanner/proc/add_data(atom/A as mob|obj|turf|area)
	var/datum/data/record/forensic/old = stored["\ref [A]"]
	var/datum/data/record/forensic/fresh = new(A)

	if(old)
		fresh.merge(old)
		. = 1
	stored["\ref [A]"] = fresh
