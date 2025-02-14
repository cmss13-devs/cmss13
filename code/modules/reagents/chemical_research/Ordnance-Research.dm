GLOBAL_DATUM_INIT(ordnance_research, /datum/ordnance_research, new)

/datum/ordnance_research
	var/technology_credits = 5 //this means we start with 10 since credits_to_allocate also happens at round start
	/// amount of credits earned every 10 minutes
	var/credits_to_allocate = 5
	/// technology bought so far, if something is in this list then it can't be bought again
	var/list/tech_bought = list()
	///	photocopier where the explosion photos are sent
	var/obj/structure/machinery/photocopier/photocopier
	/// to prevent duplicate photos
	var/last_grenade

/datum/ordnance_research/proc/update_credits(change)
	technology_credits = max(0, technology_credits + change)

/datum/ordnance_research/proc/take_image(grenade, grenade_location)
	if(grenade == last_grenade)
		return
	addtimer(CALLBACK(src, PROC_REF(print_image), grenade_location), 1.2 SECONDS)
	last_grenade = grenade

/datum/ordnance_research/proc/print_image(grenade_location)
	var/obj/item/device/camera/camera = new()
	camera.size = 9 //anything larger and it starts to lag bad
	camera.captureimage(grenade_location, location_to_print = photocopier.loc)
	playsound(photocopier.loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 30, 1)
	qdel(camera)

	//items

	/obj/item/ordnance/tech_disk
	name = "you aren't supposed to have this"
	desc = "Insert this in an armylathe or, if applicable, a dropship part fabricator to obtain this technology"
	icon = 'icons/obj/items/disk.dmi'
	w_class = SIZE_TINY
	icon_state = "datadisk1"
	///is it an autolathe upgrade or unlock?
	var/tech_type
	/// stuff that this unlocks when put in a lathe
	var/list/tech = list()

/obj/item/ordnance/data_analyzer
	name = "explosive data analyzer"
	desc = "Limits casing capacity but analyzes the explosion and fire caused and the amount of targets hit, granting ordnance technology credits. Cannot be removed once attached."
	w_class = SIZE_TINY
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "eftpos"
	///amount of credits to reward per mob hit
	var/credits_to_award = 3
	///amount of max_container_volume to remove when attached, 2x if above casing_cutoff_point
	var/base_remove_amount = 30
	///point at which base_remove_amount is doubled
	var/casing_cutoff_point = 200
	///explosive we are attached to
	var/obj/item/explosive/attached
	///mobs hit
	var/list/mobs_hit = list()

/obj/item/ordnance/data_analyzer/ex_act(severity, explosion_direction)
	return

/obj/item/ordnance/data_analyzer/proc/apply_casing_limit(obj/item/explosive/item)
	if(!item.customizable)
		return
	if(item.max_container_volume <= casing_cutoff_point)
		item.max_container_volume = max(item.max_container_volume - base_remove_amount, 0)
	else
		item.max_container_volume = max(item.max_container_volume - base_remove_amount*2, 0)

/obj/item/ordnance/data_analyzer/proc/add_mob(mob/mob)
	if(mob.stat == DEAD)
		return
	if(mobs_hit.Find(mob))
		return
	if(ismonkey(mob)) //no farming points with monkeys
		return
	mobs_hit += mob
	beam(mob, "b_beam", time = 0.8 SECONDS)

//gives 5 seconds for the explosion to finish before sending credits
/obj/item/ordnance/data_analyzer/proc/activate()
	addtimer(CALLBACK(src, PROC_REF(finish)), 5 SECONDS)

/obj/item/ordnance/data_analyzer/proc/finish()
	var/counter = 0
	for(var/mob in mobs_hit)
		counter++
	GLOB.ordnance_research.update_credits(counter * credits_to_award)
	qdel(src)
