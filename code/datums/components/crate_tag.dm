/datum/component/crate_tag
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// The crate tag used for notifications and as label
	var/name

/datum/component/crate_tag/Initialize(name, obj/structure/closet/crate/masquarade_type)
	var/obj/structure/closet/crate/crate = parent
	if(!istype(crate))
		return COMPONENT_INCOMPATIBLE
	setup(name, masquarade_type)
	RegisterSignal(parent, COMSIG_STRUCTURE_CRATE_SQUAD_LAUNCHED, PROC_REF(notify_squad))

/datum/component/crate_tag/InheritComponent(datum/component/C, i_am_original, name, obj/structure/closet/crate/masquarade_type)
	. = ..()
	setup(name, masquarade_type)

/datum/component/crate_tag/proc/setup(name, obj/structure/closet/crate/masquarade_type)
	var/obj/structure/closet/crate/crate = parent
	if(masquarade_type)
		crate.name = initial(masquarade_type.name)
		crate.desc = initial(masquarade_type.desc)
		crate.icon_opened = initial(masquarade_type.icon_opened)
		crate.icon_closed = initial(masquarade_type.icon_closed)
		if(crate.opened)
			crate.icon_state = crate.icon_opened
		else
			crate.icon_state = crate.icon_closed
	if(name)
		parent.AddComponent(/datum/component/label, name)
		src.name = name // Keep it around additionally for notifications

/// Handler to notify an overwatched squad that this crate has been dropped for them
/datum/component/crate_tag/proc/notify_squad(datum/source, datum/squad/squad)
	SIGNAL_HANDLER
	squad.send_message("Приближается дроп-под '[name]' со снабжением. Осторожно!")
	squad.send_maptext(name, "Приближается дроп-под снабжения:")
