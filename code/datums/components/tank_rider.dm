/**
 * tank_rider tracks whether an atom/movable (a mob or a droppable obj) is currently riding atop a tank's hull.
 *
 * Added by /obj/vehicle/multitile/tank/proc/mark_on_top and obj_mark_on_top when something climbs onto,
 * or is otherwise placed atop, a tank. Removed by clear_on_top/obj_clear_on_top whenit leaves
 *
 * holds a weakref to the tank rather than a direct reference so a rider never keeps a destroyed tank
 * referenced, and so the component can detect a qdeld tank and clean ittself up on the next lookup
 */
/datum/component/tank_rider
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/datum/weakref/tank_ref

/datum/component/tank_rider/Initialize(obj/vehicle/multitile/tank/tank)
	if(!ismovable(parent) || !istype(tank))
		return COMPONENT_INCOMPATIBLE
	tank_ref = WEAKREF(tank)

/datum/component/tank_rider/InheritComponent(datum/component/tank_rider/new_comp, i_am_original, obj/vehicle/multitile/tank/tank)
	if(istype(tank))
		tank_ref = WEAKREF(tank)

/datum/component/tank_rider/Destroy(force, silent)
	tank_ref = null
	return ..()

/datum/component/tank_rider/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_parent_qdel))

/datum/component/tank_rider/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_PARENT_QDELETING)

/datum/component/tank_rider/proc/on_parent_qdel()
	SIGNAL_HANDLER
	qdel(src)

/datum/component/tank_rider/proc/get_tank()
	var/obj/vehicle/multitile/tank/tank = tank_ref?.resolve()
	if(!tank)
		qdel(src)
	return tank
