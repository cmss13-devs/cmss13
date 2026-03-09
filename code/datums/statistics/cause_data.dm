GLOBAL_LIST_EMPTY(ref_mob_to_last_cause_data_time)

GLOBAL_LIST_INIT(exempted_cause_objects, typecacheof(list(
	/obj/structure/machinery/defenses,
)))

GLOBAL_LIST_INIT(exempted_cause_areas, typecacheof(list(
	/area/almayer/shipboard/firing_range_north,
	/area/almayer/shipboard/firing_range_south
)))

/datum/cause_data
	var/datum/weakref/weak_mob
	var/ckey
	var/role
	var/faction
	var/cause_name
	var/datum/weakref/weak_cause

	var/time_created

/datum/cause_data/New(cause_name, mob/causing_mob, obj/causing_object)
	src.cause_name = cause_name
	time_created = world.time

	if(causing_object)
		weak_cause = WEAKREF(causing_object)

	if(istype(causing_mob))
		weak_mob = WEAKREF(causing_mob)

		role = causing_mob.get_role_name()
		faction = causing_mob.faction

		if(causing_mob.mind)
			ckey = causing_mob.mind.ckey

		if(causing_object && is_type_in_typecache(causing_object, GLOB.exempted_cause_objects))
			return

		if(islarva(causing_mob))
			var/mob/living/carbon/burst = locate(/mob/living/carbon) in get_turf(causing_mob)
			if(!burst)
				return

			if(!HAS_TRAIT(burst, TRAIT_NESTED))
				return

		var/area/mob_area = get_area(causing_mob)
		if(is_type_in_typecache(mob_area, GLOB.exempted_cause_areas))
			return

		GLOB.ref_mob_to_last_cause_data_time[weak_mob.reference] = world.time


/datum/cause_data/proc/resolve_mob()
	if(!weak_mob)
		return null
	return weak_mob.resolve()

/datum/cause_data/proc/resolve_cause()
	if(!weak_cause)
		return null
	return weak_cause.resolve()

/proc/create_cause_data(new_cause, mob/M = null, obj/C = null)
	if(!new_cause)
		return null
	var/datum/cause_data/new_data = new(new_cause, M, C)
	return new_data
