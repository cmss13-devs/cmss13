/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */

//Used for logging people entering cryosleep and important items they are carrying.
GLOBAL_LIST_EMPTY(frozen_crew)
GLOBAL_LIST_INIT(frozen_items, list(SQUAD_NAME_1 = list(), SQUAD_NAME_2 = list(), SQUAD_NAME_3 = list(), SQUAD_NAME_4 = list(), "MP" = list(), "REQ" = list(), "Eng" = list(), "Med" = list(), "Yautja" = list()))

//Main cryopod console.

/obj/structure/machinery/computer/cryopod
	name = "hypersleep bay console"
	desc = "A large console controlling the ship's hypersleep bay. Most of the options are disabled and locked, although it allows recovery of items from long-term hypersleeping crew."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "cellconsole"
	circuit = /obj/item/circuitboard/computer/cryopodcontrol
	exproof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	var/cryotype = "REQ"
	var/mode = null

/obj/structure/machinery/computer/cryopod/medical
	cryotype = "Med"

/obj/structure/machinery/computer/cryopod/brig
	cryotype = "MP"

/obj/structure/machinery/computer/cryopod/eng
	cryotype = "Eng"

/obj/structure/machinery/computer/cryopod/alpha
	cryotype = SQUAD_NAME_1

/obj/structure/machinery/computer/cryopod/bravo
	cryotype = SQUAD_NAME_2

/obj/structure/machinery/computer/cryopod/charlie
	cryotype = SQUAD_NAME_3

/obj/structure/machinery/computer/cryopod/delta
	cryotype = SQUAD_NAME_4

/obj/structure/machinery/computer/cryopod/yautja
	cryotype = "Yautja"

/obj/structure/machinery/computer/cryopod/attack_remote()
	src.attack_hand()

/obj/structure/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(inoperable())
		return

	user.set_interaction(src)
	src.add_fingerprint(usr)

	var/dat

	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref[src];log=1'>View storage log</a>.<br>"
	dat += "<a href='?src=\ref[src];view=1'>View objects</a>.<br>"
	dat += "<a href='?src=\ref[src];item=1'>Recover object</a>.<br>"
	dat += "<a href='?src=\ref[src];allitems=1'>Recover all objects</a>.<br>"

	show_browser(user, dat, "Cryogenic Oversight Control for [cryotype]", "cryopod_console")

/obj/structure/machinery/computer/cryopod/Topic(href, href_list)

	var/mob/user = usr
	var/list/frozen_items_for_type = GLOB.frozen_items[cryotype]

	src.add_fingerprint(user)

	if(href_list["log"])

		var/dat = "<b>Recently stored crewmembers</b><br/><hr/><br/>"
		for(var/person in GLOB.frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"

		show_browser(user, dat, "Cryogenic Oversight Control Logs", "cryolog")

	if(href_list["view"])

		var/dat = "<b>Recently stored objects</b><br/><hr/><br/>"
		for(var/obj/item/I in frozen_items_for_type)
			dat += "[I.name]<br/>"
		dat += "<hr/>"

		show_browser(user, dat, "Cryogenic Oversight Control Logs", "cryoitems")

	else if(href_list["item"])

		if(frozen_items_for_type.len == 0)
			to_chat(user, SPAN_WARNING("There is nothing to recover from storage."))
			return

		var/obj/item/I = input(usr, "Please choose which object to retrieve.", "Object recovery",null) as null|anything in frozen_items_for_type
		if(!I)
			return

		if(!(I in frozen_items_for_type))
			to_chat(user, SPAN_WARNING("[I] is no longer in storage."))
			return

		visible_message(SPAN_NOTICE("[src] beeps happily as it disgorges [I]."))

		I.loc = get_turf(src)
		frozen_items_for_type -= I

	else if(href_list["allitems"])

		if(frozen_items_for_type.len == 0)
			to_chat(user, SPAN_WARNING("There is nothing to recover from storage."))
			return

		visible_message(SPAN_NOTICE("[src] beeps happily as it disgorges the desired objects."))

		for(var/obj/item/I in frozen_items_for_type)
			I.loc = get_turf(src)
			frozen_items_for_type -= I

	src.updateUsrDialog()
	return


//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed

	name = "hypersleep chamber feed"
	desc = "A bewildering tangle of machinery and pipes linking the hypersleep chambers to the hypersleep bay.."
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "cryo_rear"
	anchored = 1
	density = 1

	var/orient_right = null //Flips the sprite.

/obj/structure/cryofeed/right
	orient_right = 1
	icon_state = "cryo_rear-r"

/obj/structure/cryofeed/New()

	if(orient_right)
		icon_state = "cryo_rear-r"
	else
		icon_state = "cryo_rear"
	..()









//Cryopods themselves.
/obj/structure/machinery/cryopod
	name = "hypersleep chamber"
	desc = "A large automated capsule with LED displays intended to put anyone inside into 'hypersleep', a form of non-cryogenic statis used on most ships, linked to a long-term hypersleep bay on a lower level."
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1

	var/mob/living/occupant = null //Person waiting to be despawned.
	var/orient_right = null // Flips the sprite.
	var/time_till_despawn = MINUTES_10 //10 minutes-ish safe period before being despawned.
	var/time_entered = 0 //Used to keep track of the safe period.
	var/obj/item/device/radio/intercom/announce //Intercom for cryo announcements

/obj/structure/machinery/cryopod/right
	dir = WEST

/obj/structure/machinery/cryopod/Initialize()
	. = ..()
	announce = new /obj/item/device/radio/intercom(src)


//Lifted from Unity stasis.dm and refactored. ~Zuhayr
/obj/structure/machinery/cryopod/process()
	if(occupant)
		//if occupant ghosted, time till despawn is severely shorter
		if(!occupant.key && time_till_despawn == MINUTES_10)
			time_till_despawn -= MINUTES_8
		//Allow a ten minute gap between entering the pod and actually despawning.
		if(world.time - time_entered < time_till_despawn)
			return

		if(!occupant.client && occupant.stat < DEAD) //Occupant is living and has no client.
			despawn_occupant()
	else
		stop_processing()

/obj/structure/machinery/cryopod/proc/despawn_occupant()
	time_till_despawn = initial(time_till_despawn)

	//Drop all items into the pod.
	for(var/obj/item/W in occupant)
		occupant.drop_inv_item_to_loc(W, src)

	//Delete all items not on the preservation list.

	var/list/items = contents.Copy()
	items -= occupant //Don't delete the occupant
	items -= announce //or the autosay radio.

	var/list/dept_console = GLOB.frozen_items["REQ"]
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		switch(H.job)
			if("Military Police","Chief MP")
				dept_console = GLOB.frozen_items["MP"]
			if("Doctor","Researcher","Chief Medical Officer")
				dept_console = GLOB.frozen_items["Med"]
			if("Ordnance Techician","Chief Engineer")
				dept_console = GLOB.frozen_items["Eng"]
			if("Predator")
				dept_console = GLOB.frozen_items["Yautja"]

	var/list/deleteempty = list(/obj/item/storage/backpack/marine/satchel)

	var/list/deleteall = list(/obj/item/clothing/mask/cigarette, \
	/obj/item/clothing/glasses/sunglasses, \
	/obj/item/clothing/glasses/mgoggles, \
	/obj/item/clothing/head/helmet/beret/marine/mp, \
	/obj/item/clothing/gloves/black, \
	/obj/item/weapon/melee/baton, \
	/obj/item/weapon/gun/energy/taser, \
	/obj/item/clothing/glasses/sunglasses/sechud, \
	/obj/item/device/radio/headset/almayer, \
	/obj/item/card/id, \
	/obj/item/clothing/under/marine, \
	/obj/item/clothing/shoes/marine, \
	/obj/item/clothing/head/cmcap)

	var/list/strippeditems = list()

	item_loop:
		for(var/obj/item/W in items)
			if(((W.flags_inventory & CANTSTRIP) || (W.flags_item & NODROP) || (W.flags_item & NO_CRYO_STORE)) && !isYautja(occupant)) //We don't keep donor items, undroppable/unremovable items, and specifically filtered items
				if(istype(W, /obj/item/clothing/suit/storage))
					var/obj/item/clothing/suit/storage/SS = W
					for(var/obj/item/I in SS.pockets) //But we keep stuff inside them
						SS.pockets.remove_from_storage(I, loc)
						strippeditems += I
						I.loc = null
				if(isstorage(W))
					var/obj/item/storage/S = W
					for(var/obj/item/I in S)
						S.remove_from_storage(I, loc)
						strippeditems += I
						I.loc = null
				qdel(W)
				continue


			//special items that store stuff in a nonstandard way, we properly remove those items

			if(istype(W, /obj/item/clothing/suit/storage))
				var/obj/item/clothing/suit/storage/SS = W
				for(var/obj/item/I in SS.pockets)
					SS.pockets.remove_from_storage(I, loc)
					strippeditems += I
					I.loc = null

			if(istype(W, /obj/item/clothing/under))
				var/obj/item/clothing/under/UN = W
				for(var/obj/item/I in UN.accessories)
					UN.remove_accessory(occupant, I)
					strippeditems += I
					I.loc = null

			if(istype(W, /obj/item/clothing/shoes/marine))
				var/obj/item/clothing/shoes/marine/MS = W
				if(MS.stored_item)
					strippeditems += MS.stored_item
					MS.stored_item.loc = null
					MS.stored_item = null



			for(var/TT in deleteempty)
				if(istype(W, TT))
					if(length(W.contents) == 0)
						qdel(W) // delete all the empty satchels
						continue item_loop
					break // not empty, don't delete

			for(var/DA in deleteall)
				if(istype(W, DA))
					qdel(W)
					continue item_loop

			dept_console += W
			W.loc = null

	stripped_items:
		for(var/obj/item/A in strippeditems)
			for(var/DAA in deleteall)
				if(istype(A, DAA))
					qdel(A)
					continue stripped_items

			dept_console += A
			A.loc = null

	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		if(H.assigned_squad)
			var/datum/squad/S = H.assigned_squad
			if(H.job == JOB_SQUAD_SPECIALIST)
				//we make the set this specialist took if any available again
				if(H.skills)
					var/set_name
					switch(H.skills.get_skill_level(SKILL_SPEC_WEAPONS))
						if(SKILL_SPEC_ROCKET)
							set_name = "Demolitionist Set"
						if(SKILL_SPEC_GRENADIER)
							set_name = "Heavy Grenadier Set"
						if(SKILL_SPEC_PYRO)
							set_name = "Pyro Set"
						if(SKILL_SPEC_SCOUT)
							set_name = "Scout Set"
						if(SKILL_SPEC_SNIPER)
							set_name = "Sniper Set"

					if(set_name && !available_specialist_sets.Find(set_name))
						available_specialist_sets += set_name
			S.forget_marine_in_squad(H)

	SSticker.mode.latejoin_tally-- //Cryoing someone out removes someone from the Marines, blocking further larva spawns until accounted for

	//Handle job slot/tater cleanup.
	RoleAuthority.free_role(RoleAuthority.roles_for_mode[occupant.job], TRUE)

	//Delete them from datacore.
	for(var/datum/data/record/R in GLOB.data_core.medical)
		if((R.fields["name"] == occupant.real_name))
			GLOB.data_core.medical -= R
			qdel(R)
	for(var/datum/data/record/T in GLOB.data_core.security)
		if((T.fields["name"] == occupant.real_name))
			GLOB.data_core.security -= T
			qdel(T)
	for(var/datum/data/record/G in GLOB.data_core.general)
		if((G.fields["name"] == occupant.real_name))
			GLOB.data_core.general -= G
			qdel(G)

	icon_state = "body_scanner_0"

	if(occupant.key)
		occupant.ghostize(0)

	//Make an announcement and log the person entering storage.
	GLOB.frozen_crew += "[occupant.real_name]"
	if(!isYautja(occupant))
		ai_silent_announcement("[occupant.real_name] has entered long-term hypersleep storage. Belongings moved to hypersleep inventory.")
	visible_message(SPAN_NOTICE("[src] hums and hisses as it moves [occupant.real_name] into hypersleep storage."))

	//Delete the mob.

	QDEL_NULL(occupant)
	stop_processing()

/obj/structure/machinery/cryopod/attackby(obj/item/W, mob/living/user)

	if(istype(W, /obj/item/grab))
		if(isXeno(user)) return
		var/obj/item/grab/G = W
		if(occupant)
			to_chat(user, SPAN_WARNING("[src] is occupied."))
			return

		if(!isliving(G.grabbed_thing))
			return

		var/willing = null //We don't want to allow people to be forced into despawning.
		var/mob/living/M = G.grabbed_thing

		if(M.stat == DEAD) //This mob is dead
			to_chat(user, SPAN_WARNING("[src] immediately rejects [M]. \He passed away!"))
			return

		if(isXeno(M))
			to_chat(user, SPAN_WARNING("There is no way [src] will accept [M]!"))
			return

		if(M.client)
			if(alert(M,"Would you like to enter cryosleep?", , "Yes", "No") == "Yes")
				if(!M || !G || !G.grabbed_thing) return
				willing = 1
		else
			willing = 1

		if(willing)

			visible_message(SPAN_NOTICE("[user] starts putting [M] into [src]."),
			SPAN_NOTICE("You start putting [M] into [src]."))

			if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC)) return
			if(!M || !G || !G.grabbed_thing) return
			if(occupant)
				to_chat(user, SPAN_WARNING("[src] is occupied."))
				return

			go_in_cryopod(M)

			//Book keeping!
			var/area/location = get_area(src)
			message_staff(SPAN_NOTICE("[key_name_admin(user)] put [key_name_admin(M)], [M.job] into [src] at [location]."))

			//Despawning occurs when process() is called with an occupant without a client.
			add_fingerprint(user)

/obj/structure/machinery/cryopod/verb/eject()

	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return

	if(occupant != usr)
		to_chat(usr, SPAN_WARNING("You can't drag people out of hypersleep!"))
		return

	icon_state = "body_scanner_0"

	//Eject any items that aren't meant to be in the pod.
	var/list/items = src.contents
	if(occupant) items -= occupant
	if(announce) items -= announce

	for(var/obj/item/W in items)
		W.loc = get_turf(src)

	go_out()
	add_fingerprint(usr)


/obj/structure/machinery/cryopod/verb/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	if(usr.is_mob_incapacitated() || !(ishuman(usr)))
		return

	if(occupant)
		to_chat(usr, SPAN_WARNING("[src] is occupied."))
		return

	if(isXeno(usr))
		to_chat(usr, SPAN_WARNING("There is no way [src] will accept you!"))
		return

	usr.visible_message(SPAN_NOTICE("[usr] starts climbing into [src]."),
	SPAN_NOTICE("You start climbing into [src]."))

	if(do_after(usr, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))

		if(!usr || !usr.client)
			return

		if(occupant)
			to_chat(usr, SPAN_WARNING("[src] is occupied."))
			return

		go_in_cryopod(usr)
		add_fingerprint(usr)


/obj/structure/machinery/cryopod/proc/go_in_cryopod(mob/M)
	if(occupant)
		return
	M.forceMove(src)
	occupant = M
	icon_state = "body_scanner_1"
	if(M.client)
		to_chat(M, SPAN_NOTICE("You feel cool air surround you. You go numb as your senses turn inward."))
		to_chat(M, SPAN_BOLDNOTICE("If you log out or close your client now, your character will permanently removed from the round in 10 minutes. If you ghost, timer will be decreased to 2 minutes."))
	time_entered = world.time
	start_processing()
	var/area/location = get_area(src)
	if(M.job != JOB_SQUAD_MARINE)
		message_staff(SPAN_NOTICE("[key_name_admin(M)], [M.job], has entered a [src] at [location] after playing for [duration2text(world.time - M.life_time_start)]."))

	playsound(src, 'sound/machines/hydraulics_3.ogg', 30)

/obj/structure/machinery/cryopod/proc/go_out()
	if(!occupant)
		return
	occupant.forceMove(get_turf(src))
	occupant = null
	stop_processing()
	icon_state = "body_scanner_0"
	playsound(src, 'sound/machines/pod_open.ogg', 30)

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/cryopod/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant))
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH