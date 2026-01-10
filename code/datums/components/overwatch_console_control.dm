/// component for adding and removing hearing and seeing flag on items, depending on whether an item is being observed by overwatch or not
/datum/component/overwatch_console_control
	var/list/overwatch_consoles = list()

/datum/component/overwatch_console_control/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_OW_CONSOLE_OBSERVE_START, PROC_REF(add_observing_console))
	RegisterSignal(parent, COMSIG_OW_CONSOLE_OBSERVE_END, PROC_REF(remove_observing_console))

/datum/component/overwatch_console_control/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_OW_CONSOLE_OBSERVE_START,
		COMSIG_OW_CONSOLE_OBSERVE_END
	))

/datum/component/overwatch_console_control/proc/add_observing_console(datum/weakref/console)
	overwatch_consoles += console
	var/obj/item/parent_item = parent
	parent_item.flags_atom |= (USES_HEARING|USES_SEEING)

/datum/component/overwatch_console_control/proc/remove_observing_console(datum/weakref/console)
	overwatch_consoles -= console
	if(length(overwatch_consoles) > 0)
		return
	var/obj/item/parent_item = parent
	parent_item.flags_atom &= ~(USES_HEARING|USES_SEEING)
