/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */

//Used for logging people entering cryosleep and important items they are carrying.
GLOBAL_LIST_EMPTY(frozen_crew)
GLOBAL_LIST_INIT(frozen_items, list(SQUAD_MARINE_1 = list(), SQUAD_MARINE_2 = list(), SQUAD_MARINE_3 = list(), SQUAD_MARINE_4 = list(), "MP" = list(), "REQ" = list(), "Eng" = list(), "Med" = list(), "Yautja" = list(), "Responders" = list()))

//Main cryopod console.

/obj/structure/machinery/computer/cryopod
	name = "hypersleep bay console"
	desc = "A large console controlling the ship's hypersleep bay. Most of the options are disabled and locked, although it allows recovery of items from long-term hypersleeping crew."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "cellconsole"
	circuit = /obj/item/circuitboard/computer/cryopodcontrol
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	var/cryotype = "REQ"
	var/mode = null
	var/z_restricted = TRUE

/obj/structure/machinery/computer/cryopod/medical
	cryotype = "Med"

/obj/structure/machinery/computer/cryopod/brig
	cryotype = "MP"

/obj/structure/machinery/computer/cryopod/eng
	cryotype = "Eng"

/obj/structure/machinery/computer/cryopod/alpha
	cryotype = SQUAD_MARINE_1

/obj/structure/machinery/computer/cryopod/bravo
	cryotype = SQUAD_MARINE_2

/obj/structure/machinery/computer/cryopod/charlie
	cryotype = SQUAD_MARINE_3

/obj/structure/machinery/computer/cryopod/delta
	cryotype = SQUAD_MARINE_4

/obj/structure/machinery/computer/cryopod/yautja
	cryotype = "Yautja"
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	icon_state = "terminal"
	z_restricted = FALSE

/obj/structure/machinery/computer/cryopod/upp
	cryotype = FACTION_UPP

/obj/structure/machinery/computer/cryopod/attack_remote()
	src.attack_hand()

/obj/structure/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(inoperable())
		return

	if(z_restricted && !is_mainship_level(z))
		to_chat(user, SPAN_WARNING("\The [src] cannot connect to the cryo bay system off the [MAIN_SHIP_NAME]!"))
		return

	user.set_interaction(src)
	src.add_fingerprint(usr)

	var/dat

	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='byond://?src=\ref[src];log=1'>View storage log</a>.<br>"
	dat += "<a href='byond://?src=\ref[src];view=1'>View objects</a>.<br>"
	dat += "<a href='byond://?src=\ref[src];item=1'>Recover object</a>.<br>"
	dat += "<a href='byond://?src=\ref[src];allitems=1'>Recover all objects</a>.<br>"

	show_browser(user, dat, "Cryogenic Oversight Control for [cryotype]", "cryopod_console")

/obj/structure/machinery/computer/cryopod/Topic(href, href_list)
	. = ..()
	if(.)
		return
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

		if(length(frozen_items_for_type) == 0)
			to_chat(user, SPAN_WARNING("There is nothing to recover from storage."))
			return

		var/obj/item/I = tgui_input_list(usr, "Please choose which object to retrieve.", "Object recovery", frozen_items_for_type)
		if(!I)
			return

		if(!(I in frozen_items_for_type))
			to_chat(user, SPAN_WARNING("[I] is no longer in storage."))
			return

		visible_message(SPAN_NOTICE("[src] beeps happily as it disgorges [I]."))

		I.forceMove(get_turf(src))
		frozen_items_for_type -= I

	else if(href_list["allitems"])

		if(length(frozen_items_for_type) == 0)
			to_chat(user, SPAN_WARNING("There is nothing to recover from storage."))
			return

		visible_message(SPAN_NOTICE("[src] beeps happily as it disgorges the desired objects."))

		for(var/obj/item/I in frozen_items_for_type)
			I.forceMove(get_turf(src))
			frozen_items_for_type -= I

	src.updateUsrDialog()
	return


//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed

	name = "hypersleep chamber feed"
	desc = "A bewildering tangle of machinery and pipes linking the hypersleep chambers to the hypersleep bay."
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "cryo_rear"
	anchored = TRUE
	density = TRUE

	var/orient_right = null //Flips the sprite.

/obj/structure/cryofeed/right
	orient_right = 1
	icon_state = "cryo_rear-r"

/obj/structure/cryofeed/Initialize()
	. = ..()
	if(orient_right)
		icon_state = "cryo_rear-r"
	else
		icon_state = "cryo_rear"


//Cryopods themselves.
/obj/structure/machinery/cryopod
	name = "hypersleep chamber"
	desc = "A large automated capsule with LED displays intended to put anyone inside into 'hypersleep', a form of non-cryogenic statis used on most ships, linked to a long-term hypersleep bay on a lower level."
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "body_scanner_open"
	density = TRUE
	anchored = TRUE

	var/mob/living/occupant = null //Person waiting to be despawned.
	var/orient_right = null // Flips the sprite.
	var/time_till_despawn = 10 MINUTES //10 minutes-ish safe period before being despawned.
	var/time_entered = 0 //Used to keep track of the safe period.
	var/silent_exit = FALSE
	var/obj/item/device/radio/intercom/announce //Intercom for cryo announcements
	var/no_store_pod = FALSE

/obj/structure/machinery/cryopod/right
	dir = WEST

/obj/structure/machinery/cryopod/no_store
	no_store_pod = TRUE

/obj/structure/machinery/cryopod/no_store/right
	dir = WEST

/obj/structure/machinery/cryopod/Initialize()
	. = ..()
	announce = new /obj/item/device/radio/intercom(src)
	flags_atom |= USES_HEARING

/obj/structure/machinery/cryopod/Destroy()
	QDEL_NULL(occupant)
	QDEL_NULL(announce)
	. = ..()


//Lifted from Unity stasis.dm and refactored. ~Zuhayr
/obj/structure/machinery/cryopod/process()
	if(occupant && !(occupant in GLOB.freed_mob_list)) //ignore freed mobs
		//if occupant ghosted, time till despawn is severely shorter
		if(!occupant.key && time_till_despawn == 10 MINUTES)
			time_till_despawn -= 8 MINUTES
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

	SSminimaps.remove_marker(src)

	var/list/dept_console = GLOB.frozen_items["REQ"]
	if(ishuman(occupant))
		var/mob/living/carbon/human/cryo_human = occupant
		switch(cryo_human.job)
			if(JOB_POLICE, JOB_WARDEN, JOB_CHIEF_POLICE)
				dept_console = GLOB.frozen_items["MP"]
			if(JOB_NURSE, JOB_DOCTOR, JOB_FIELD_DOCTOR, JOB_RESEARCHER, JOB_CMO)
				dept_console = GLOB.frozen_items["Med"]
			if(JOB_MAINT_TECH, JOB_ORDNANCE_TECH, JOB_CHIEF_ENGINEER)
				dept_console = GLOB.frozen_items["Eng"]


		if(cryo_human.faction != FACTION_MARINE)
			dept_console = GLOB.frozen_items[cryo_human.faction]

		if(cryo_human.job in FAX_RESPONDER_JOB_LIST)
			cryo_human.despawn_fax_responder()

		cryo_human.species.handle_cryo(cryo_human)

	var/list/deleteempty = list(/obj/item/storage/backpack/marine/satchel)

	var/list/deleteall = list(/obj/item/clothing/mask/cigarette, \
	/obj/item/clothing/glasses/sunglasses, \
	/obj/item/clothing/glasses/mgoggles, \
	/obj/item/clothing/head/beret/marine/mp, \
	/obj/item/clothing/gloves/black, \
	/obj/item/weapon/baton, \
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
			if((W.flags_inventory & CANTSTRIP) || (W.flags_item & NODROP) || (W.flags_item & NO_CRYO_STORE) || gearless_role(occupant)) //We don't keep donor items, undroppable/unremovable items, and specifically filtered items
				if(istype(W, /obj/item/clothing/suit/storage))
					var/obj/item/clothing/suit/storage/SS = W
					for(var/obj/item/I in SS.pockets) //But we keep stuff inside them
						SS.pockets.remove_from_storage(I, loc)
						strippeditems += I
						I.moveToNullspace()
				if(isstorage(W))
					var/obj/item/storage/S = W
					for(var/obj/item/I in S)
						S.remove_from_storage(I, loc)
						strippeditems += I
						I.moveToNullspace()
				qdel(W)
				continue


			//special items that store stuff in a nonstandard way, we properly remove those items

			if(istype(W, /obj/item/clothing/suit/storage))
				var/obj/item/clothing/suit/storage/SS = W
				for(var/obj/item/I in SS.pockets)
					SS.pockets.remove_from_storage(I, loc)
					strippeditems += I
					I.moveToNullspace()

			if(istype(W, /obj/item/clothing/under))
				var/obj/item/clothing/under/UN = W
				for(var/obj/item/I in UN.accessories)
					UN.remove_accessory(occupant, I)
					strippeditems += I
					I.moveToNullspace()

			if(istype(W, /obj/item/clothing/shoes/marine))
				var/obj/item/clothing/shoes/marine/MS = W
				if(MS.stored_item)
					strippeditems += MS.stored_item
					MS.stored_item.moveToNullspace()
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
			W.moveToNullspace()

	stripped_items:
		for(var/obj/item/A in strippeditems)
			if(gearless_role(occupant))
				qdel(A)
				continue stripped_items
			for(var/DAA in deleteall)
				if(istype(A, DAA))
					qdel(A)
					continue stripped_items

			dept_console += A
			A.moveToNullspace()

	var/datum/job/job = GET_MAPPED_ROLE(occupant.job)
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		job.on_cryo(H)
		if(H.assigned_squad)
			var/datum/squad/S = H.assigned_squad
			S.forget_marine_in_squad(H)

	//Cryoing someone out removes someone from the Marines, blocking further larva spawns until accounted for
	SSticker.mode.latejoin_update(job, -1)

	//Handle job slot/tater cleanup.
	GLOB.RoleAuthority.free_role(GET_MAPPED_ROLE(occupant.job), TRUE)

	var/occupant_ref = WEAKREF(occupant)
	//Delete them from datacore.
	for(var/datum/data/record/R as anything in GLOB.data_core.medical)
		if((R.fields["ref"] == occupant_ref))
			GLOB.data_core.medical -= R
			qdel(R)
	for(var/datum/data/record/T in GLOB.data_core.security)
		if((T.fields["ref"] == occupant_ref))
			GLOB.data_core.security -= T
			qdel(T)
	for(var/datum/data/record/G in GLOB.data_core.general)
		if((G.fields["ref"] == occupant_ref))
			GLOB.data_core.general -= G
			qdel(G)

	icon_state = "body_scanner_open"
	set_light(0)

	if(occupant.key)
		occupant.ghostize(0)

	//Make an announcement and log the person entering storage.
	GLOB.frozen_crew += "[occupant.real_name] ([occupant.job])"

	if(!gearless_role(occupant))
		ai_silent_announcement("[occupant.real_name], [occupant.job], has entered long-term hypersleep storage. Belongings moved to hypersleep inventory.")
	visible_message(SPAN_NOTICE("[src] hums and hisses as it moves [occupant.real_name] into hypersleep storage."))

	//Delete the mob.

	QDEL_NULL(occupant)
	stop_processing()

/obj/structure/machinery/cryopod/attackby(obj/item/W, mob/living/user)
	if(isxeno(user))
		return FALSE
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(occupant)
			to_chat(user, SPAN_WARNING("[src] is occupied."))
			return FALSE

		if(!isliving(G.grabbed_thing))
			return FALSE

		var/willing = FALSE //We don't want to allow people to be forced into despawning.
		var/mob/living/M = G.grabbed_thing

		if(M.stat == DEAD) //This mob is dead
			to_chat(user, SPAN_WARNING("[src] immediately rejects [M]. \He passed away!"))
			return FALSE

		if(isxeno(M))
			to_chat(user, SPAN_WARNING("There is no way [src] will accept [M]!"))
			return FALSE

		if(M.client)
			if(alert(M,"Would you like to enter cryosleep?", , "Yes", "No") == "Yes")
				if(!M || !G || !G.grabbed_thing)
					return FALSE
				willing = TRUE
		else
			willing = TRUE

		if(willing)

			visible_message(SPAN_NOTICE("[user] starts putting [M] into [src]."),
			SPAN_NOTICE("You start putting [M] into [src]."))

			if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				return
			if(!M || !G || !G.grabbed_thing)
				return
			if(occupant)
				to_chat(user, SPAN_WARNING("[src] is occupied."))
				return FALSE

			go_in_cryopod(M)

			//Book keeping!
			var/area/location = get_area(src)
			message_admins("[key_name_admin(user)] put [key_name_admin(M)], [M.job] into [src] at [location].")

			//Despawning occurs when process() is called with an occupant without a client.
			add_fingerprint(user)
			return TRUE

/obj/structure/machinery/cryopod/relaymove(mob/user)
	if(user.is_mob_incapacitated(TRUE))
		return
	eject()

/obj/structure/machinery/cryopod/verb/eject()
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return

	if(occupant != usr)
		to_chat(usr, SPAN_WARNING("You can't drag people out of hypersleep!"))
		return

	if(!silent_exit && alert(usr, "Would you like eject out of the hypersleep chamber?", "Confirm", "Yes", "No") != "Yes")
		return

	go_out() //Not adding a delay for this because for some reason it refuses to work. Not a big deal imo
	add_fingerprint(usr)

	to_chat(usr, SPAN_NOTICE("You get out of \the [src]."))
	if(!silent_exit)
		visible_message(SPAN_WARNING("\The [src]'s casket starts moving!"))
		var/mob/living/M = usr
		var/area/location = get_area(src) //Logs the exit
		message_admins("[key_name_admin(M)], [M.job], has left [src] at [location].")

	var/list/items = src.contents //-Removes items from the chamber
	if(occupant)
		items -= occupant
	if(announce)
		items -= announce

	for(var/obj/item/W in items)
		W.forceMove(get_turf(src))

/obj/structure/machinery/cryopod/verb/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	if(usr.is_mob_incapacitated() || !(ishuman(usr)))
		return

	if(occupant)
		to_chat(usr, SPAN_WARNING("[src] is occupied."))
		return

	if(isxeno(usr))
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


/obj/structure/machinery/cryopod/proc/go_in_cryopod(mob/mob, silent = FALSE)
	if(occupant)
		return
	mob.forceMove(src)
	occupant = mob
	icon_state = "body_scanner_closed"
	set_light(2)
	time_entered = world.time
	start_processing()

	if(!silent)
		if(mob.client)
			to_chat(mob, SPAN_NOTICE("You feel cool air surround you. You go numb as your senses turn inward."))
			to_chat(mob, SPAN_BOLDNOTICE("If you log out or close your client now, your character will permanently removed from the round in 10 minutes. If you ghost, timer will be decreased to 2 minutes."))
			if(!should_block_game_interaction(src)) // Set their queue time now because the client has to actually leave to despawn and at that point the client is lost
				mob.client.player_details.larva_queue_time = max(mob.client.player_details.larva_queue_time, world.time)
		var/area/location = get_area(src)
		if(mob.job != GET_MAPPED_ROLE(JOB_SQUAD_MARINE))
			message_admins("[key_name_admin(mob)], [mob.job], has entered \a [src] at [location] after playing for [duration2text(world.time - mob.life_time_start)].")
		playsound(src, 'sound/machines/hydraulics_3.ogg', 30)
	silent_exit = silent

/obj/structure/machinery/cryopod/proc/go_out()
	if(!occupant)
		return
	occupant.forceMove(get_turf(src))
	occupant = null
	stop_processing()
	icon_state = "body_scanner_open"
	set_light(0)
	playsound(src, 'sound/machines/pod_open.ogg', 30)
	SEND_SIGNAL(src, COMSIG_CRYOPOD_GO_OUT)

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/cryopod/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant))
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH

//clickdrag code - "resist to get out" code is in living_verbs.dm
/obj/structure/machinery/cryopod/MouseDrop_T(mob/target, mob/user)
	. = ..()
	var/mob/living/H = user
	if(!istype(H) || target != user) //cant make others get in. they need to be willing so this is superflous to enable
		return

	move_inside(target)

/obj/structure/machinery/cryopod/proc/gearless_role(mob/occupant)
	if(isyautja(occupant))
		return TRUE
	if(no_store_pod)
		return TRUE
	if(occupant.faction != FACTION_MARINE)
		return TRUE
	return FALSE


/obj/structure/machinery/cryopod/tutorial
	silent_exit = TRUE

/obj/structure/machinery/cryopod/tutorial/process()
	return

/obj/structure/machinery/cryopod/tutorial/go_in_cryopod(mob/mob, silent = FALSE, del_them = TRUE)
	if(occupant)
		return
	mob.forceMove(src)
	occupant = mob
	icon_state = "body_scanner_closed"
	set_light(2)
	time_entered = world.time
	if(del_them)
		despawn_occupant()

/obj/structure/machinery/cryopod/tutorial/despawn_occupant()
	SSminimaps.remove_marker(occupant)

	if(ishuman(occupant))
		var/mob/living/carbon/human/man = occupant
		man.species.handle_cryo(man)

	icon_state = "body_scanner_open"
	set_light(0)


	var/mob/new_player/new_player = new

	if(!occupant.mind)
		occupant.mind_initialize()

	occupant.mind.transfer_to(new_player)
	SEND_SIGNAL(occupant, COMSIG_MOB_END_TUTORIAL)
