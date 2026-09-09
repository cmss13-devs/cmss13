/obj/structure/machinery/chem_extractor
	name = "Chemical Extractor"
	desc = "Extracts chemicals from the attached vessel, sending it to the specified upstream network."
	icon = 'icons/obj/structures/machinery/chem_collector.dmi'
	icon_state = "deployed_collector"
	active_power_usage = 1000
	layer = BELOW_OBJ_LAYER
	density = TRUE

	/// Chem network that we're connected to
	var/network = "Research"

	/// The chem producer we're extracting from
	var/obj/effect/alien/resin/chem_producer/collecting_from

/obj/structure/machinery/chem_extractor/Initialize(mapload, ...)
	. = ..()
	START_PROCESSING(SSxeno_botany, src)

/obj/structure/machinery/chem_extractor/attackby(obj/item/tool, mob/user)
	. = ..()
	if(istype(tool, /obj/item/tool/wrench))
		user.visible_message(SPAN_NOTICE("[user] starts undeploying [src]"), SPAN_NOTICE("You start undeploying [src]"))
		if(!do_after(user, 1.5 SECONDS, show_busy_icon = TRUE, target = src))
			return
		new /obj/item/chem_extractor(get_turf(src))
		qdel(src)

/obj/structure/machinery/chem_extractor/proc/register_producer(obj/effect/alien/resin/chem_producer/producer)
	if(collecting_from)
		return
	collecting_from = producer
	RegisterSignal(producer, COMSIG_PARENT_QDELETING, PROC_REF(clear_producer))

/obj/structure/machinery/chem_extractor/proc/clear_producer()
	SIGNAL_HANDLER
	collecting_from = null

/obj/structure/machinery/chem_extractor/power_change(area/master_area)
	. = ..()
	if(stat & NOPOWER)
		STOP_PROCESSING(SSxeno_botany, src)
	else
		START_PROCESSING(SSxeno_botany, src)

/obj/structure/machinery/chem_extractor/process()
	if(!collecting_from)
		var/producer = locate(/obj/effect/alien/resin/chem_producer) in get_turf(src)
		if(!producer)
			return
		register_producer(producer)

	var/obj/structure/machinery/chem_storage/sending = GLOB.chemical_data.chemical_networks[network]
	if(!sending)
		return

	for(var/datum/reagent/reagent as anything in collecting_from.reagents.reagent_list)
		var/volume = sending.additional_chemicals[reagent.id] || 0
		var/max_volume = sending.additional_chemical_volume
		var/amt_to_remove = min(max_volume - volume, reagent.volume)
		collecting_from.reagents.remove_reagent_by_reference(reagent, amt_to_remove, TRUE)
		if(reagent.id in sending.additional_chemicals)
			sending.additional_chemicals[reagent.id] += amt_to_remove
		else
			sending.additional_chemicals[reagent.id] = amt_to_remove

/obj/structure/machinery/chem_extractor/Destroy()
	collecting_from = null
	STOP_PROCESSING(SSxeno_botany, src)
	return ..()

/obj/item/chem_extractor
	name = "chemical extractor"
	desc = "A collapsed chemical extractor that can be carried around."
	icon = 'icons/obj/structures/machinery/chem_collector.dmi'
	icon_state = "collector"
	w_class = SIZE_MEDIUM

	var/network = "Research"

/obj/item/chem_extractor/attack_self(mob/user)
	. = ..()
	deploy_extractor(user, get_turf(user))

/obj/item/chem_extractor/proc/is_blocked(turf/spot)
	var/blocked = spot.density
	for(var/obj/object in spot)
		if(object.density)
			blocked = TRUE
			break

	return blocked


/obj/item/chem_extractor/proc/deploy_extractor(mob/user, turf/position)
	if(is_blocked(position))
		to_chat(user, SPAN_WARNING("This spot is already occupied. Find a clear place to deploy this"))
		return
	if(!do_after(user, 3 SECONDS, show_busy_icon = TRUE))
		return
	if(is_blocked(position))
		to_chat(user, SPAN_WARNING("This spot is already occupied. Find a clear place to deploy this"))
		return
	user.visible_message(SPAN_NOTICE("[user] deploys [src]."), SPAN_NOTICE("You deploy [src]."));
	var/obj/structure/machinery/chem_extractor/extractor = new(position)
	extractor.network = network
	qdel(src)
