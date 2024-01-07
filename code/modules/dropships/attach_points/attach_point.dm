/// The bases onto which you attach dropship equipments.
/obj/effect/attach_point
	name = "equipment attach point"
	desc = "A place where heavy equipment can be installed with a powerloader."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "equip_base"
	unacidable = TRUE
	anchored = TRUE
	layer = ABOVE_TURF_LAYER
	/// The currently installed equipment, if any
	var/obj/structure/dropship_equipment/installed_equipment
	/// What kind of equipment this base accepts
	var/base_category
	/// Identifier used to refer to the dropship it belongs to
	var/ship_tag
	/// Static numbered identifier for singular attach points
	var/attach_id
	/// Relative position of the attach_point alongside dropship transverse
	var/transverse = NONE
	/// Relative position alongside longitudinal axis
	var/long = NONE

/obj/effect/attach_point/Destroy()
	QDEL_NULL(installed_equipment)
	return ..()

/obj/effect/attach_point/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		install_equipment(PC, user)
		return TRUE
	return ..()

/// Called when a real user with a powerloader attempts to install an equipment on the attach point
/obj/effect/attach_point/proc/install_equipment(obj/item/powerloader_clamp/PC, mob/living/user)
	if(!istype(PC.loaded, /obj/structure/dropship_equipment))
		return
	var/obj/structure/dropship_equipment/SE = PC.loaded
	if(!(base_category in SE.equip_categories))
		to_chat(user, SPAN_WARNING("[SE] doesn't fit on [src]."))
		return TRUE
	if(installed_equipment)
		return TRUE
	playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
	var/point_loc = loc
	if(!user || !do_after(user, (7 SECONDS) * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return TRUE
	if(loc != point_loc)//dropship flew away
		return TRUE
	if(installed_equipment || PC.loaded != SE)
		return TRUE
	to_chat(user, SPAN_NOTICE("You install [SE] on [src]."))
	SE.forceMove(loc)
	PC.loaded = null
	playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
	PC.update_icon()
	installed_equipment = SE
	SE.ship_base = src

	for(var/obj/docking_port/mobile/marine_dropship/shuttle in SSshuttle.mobile)
		if(shuttle.id == ship_tag)
			SE.linked_shuttle = shuttle
			SEND_SIGNAL(shuttle, COMSIG_DROPSHIP_ADD_EQUIPMENT, SE)
			break

	SE.update_equipment()

/// Weapon specific attachment point
/obj/effect/attach_point/weapon
	name = "weapon system attach point"
	icon_state = "equip_base_front"
	base_category = DROPSHIP_WEAPON
	layer = ABOVE_OBJ_LAYER
	var/firing_arc_min
	var/firing_arc_max

/// Get base allowed offsets for the attach point
/obj/effect/attach_point/weapon/proc/get_offsets()
	return list(
		"min" = transverse + firing_arc_min,
		"max" = transverse + firing_arc_max
	)
