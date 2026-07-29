/**
 * vehicle_rider tracks whether an atom/movable (a mob or a droppable obj) is currently riding atop a multitile vehicle's hull.
 *
 * Added by /obj/vehicle/multitile/proc/mark_on_top and obj_mark_on_top when something climbs onto, or is otherwise placed atop, a vehicle. Removed by clear_on_top/obj_clear_on_top when it leaves.
 *
 * Holds a weakref to the vehicle rather than a direct reference, so a rider never keeps a destroyed vehicle referenced, and so the component can detect a qdel'd vehicle and clean itself up on the next lookup.
 */
/datum/component/vehicle_rider
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/datum/weakref/vehicle_ref

/datum/component/vehicle_rider/Initialize(obj/vehicle/multitile/vehicle)
	if(!ismovable(parent) || !istype(vehicle))
		return COMPONENT_INCOMPATIBLE
	vehicle_ref = WEAKREF(vehicle)

/datum/component/vehicle_rider/InheritComponent(datum/component/vehicle_rider/new_comp, i_am_original, obj/vehicle/multitile/vehicle)
	if(istype(vehicle))
		vehicle_ref = WEAKREF(vehicle)

/datum/component/vehicle_rider/Destroy(force, silent)
	vehicle_ref = null
	return ..()

/datum/component/vehicle_rider/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_parent_qdel))

/datum/component/vehicle_rider/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_PARENT_QDELETING)

/datum/component/vehicle_rider/proc/on_parent_qdel()
	SIGNAL_HANDLER
	qdel(src)

/datum/component/vehicle_rider/proc/get_vehicle()
	var/obj/vehicle/multitile/vehicle = vehicle_ref?.resolve()
	if(!vehicle)
		qdel(src)
	return vehicle
