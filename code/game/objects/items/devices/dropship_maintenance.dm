// dropship maintenance //

/obj/item/device/dropship_handheld
	name = "Aircraft Maintenance Tuner"
	desc = "A small handheld used by technicians and pilots when repairing dropships. It can scan for both external and internal damage, allowing the data to be transferred to a maintenance computer for further analysis."
	icon_state = "dropship_tuner"
	item_state = "dropship_tuner"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_righthand.dmi',
	)
	pickup_sound = 'sound/handling/wrench_pickup.ogg'
	drop_sound = 'sound/handling/wrench_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	var/list/repair_actions = null
	var/current_repair_step = null
	var/list/scanned_weapons = list() // Store multiple scanned weapons
	var/list/original_mount_points = list() // Track original mount points for each weapon
	flags_item = NOBLUDGEON
	var/on = FALSE

/obj/item/device/dropship_handheld/Initialize()
	. = ..()
	update_icon()

/obj/item/device/dropship_handheld/update_icon()
	. = ..()
	overlays.Cut()
	if(on)
		icon_state = "dropship_tuner_on"
		if(length(scanned_weapons))
			overlays += image('icons/obj/items/devices.dmi', "+dropship_tuner_scan")
	else
		icon_state = "dropship_tuner"

/obj/item/device/dropship_handheld/attack_self(mob/user)
	. = ..()
	on = !on
	if(on)
		to_chat(user, SPAN_NOTICE("You turn on [src]."))
		playsound(src, 'sound/machines/click.ogg', 15, 1)
	else
		to_chat(user, SPAN_NOTICE("You turn off [src]."))
		playsound(src, 'sound/machines/click.ogg', 15, 1)
	update_icon()

/obj/item/device/dropship_handheld/afterattack(atom/target, mob/user, proximity)
	if(!on)
		to_chat(user, SPAN_WARNING("[src] is turned off."))
		return

	if(istype(target, /obj/structure/dropship_equipment/weapon))
		// Only allow people that have at least level 1 in Piloting or Engineering to use the scanner
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) && !skillcheck(user, SKILL_PILOT, SKILL_PILOT_TRAINED))
			to_chat(user, SPAN_WARNING("You don't understand how to scan anything with this!"))
			return
		var/obj/structure/dropship_equipment/weapon/W = target
		if(!length(W.active_effects))
			to_chat(user, SPAN_NOTICE("[W] does not appear to be damaged."))
			return
		var found = FALSE
		for(var/datum/dropship_antiair/effect in W.active_effects)
			if(effect && length(effect.repair_steps))
				found = TRUE
		if(!found)
			to_chat(user, SPAN_NOTICE("No repairable malfunctions detected."))
			return
		if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND | BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		// Check if weapon is already scanned
		if(W in src.scanned_weapons)
			to_chat(user, SPAN_NOTICE("[W] has already been scanned."))
			return

		// Store original mount point when first scanned
		var/original_mount_point = W.ship_base?.attach_id
		src.original_mount_points[W] = original_mount_point

		// Add weapon to scanned list
		src.scanned_weapons += W
		playsound(src, 'sound/mecha/lowpower.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("Repair scan complete. [length(src.scanned_weapons)] weapon[length(src.scanned_weapons) == 1 ? "" : "s"] scanned. Use the maintenance computer to continue repairs."))
		update_icon()
		return
	if(istype(target, /obj/item/device/dropship_computer))
		var/obj/item/device/dropship_computer/comp = target
		if(!in_range(user, comp, 1))
			to_chat(user, SPAN_WARNING("You must be next to the maintenance computer to transfer the data."))
			return
		if(!length(src.scanned_weapons))
			to_chat(user, SPAN_WARNING("No repair scan data found on the handheld device."))
			return
		playsound(src, 'sound/machines/terminal_success.ogg', 50, 1)
		return

/obj/item/device/dropship_computer
	name = "Dropship Maintenance Computer"
	desc = "A dropship maintenance computer that technicians and pilots use to find out what's wrong with a dropship. It has various outlets for different systems."
	icon_state = "dropshipcomp_cl"
	icon = 'icons/obj/structures/props/dropshipcomp.dmi'
	w_class = SIZE_LARGE
	has_special_table_placement = TRUE
	var/open = FALSE
	var/on = FALSE
	var/obj/item/cell/cell
	var/cell_type = /obj/item/cell/super
	var/obj/item/device/dropship_handheld/linked_handheld = null
	var/screen_state = 0
	var/is_linked = FALSE // True if a handheld is linked, False otherwise

/obj/item/device/dropship_computer/Initialize(mapload)
	. = ..()
	if(cell_type)
		cell = new cell_type()
		cell.charge = cell.maxcharge

/obj/item/device/dropship_computer/Destroy()
	. = ..()
	QDEL_NULL(cell)

/obj/item/device/dropship_computer/Move(NewLoc, direct)
	..()
	if(table_setup || open || on)
		teardown()

/obj/item/device/dropship_computer/attack_hand(mob/user)
	if(!table_setup)
		return ..()
	if(!on)
		icon_state = "dropshipcomp_on"
		on = TRUE
		START_PROCESSING(SSobj, src)
		set_light(2, 2, "#00ff00")
		playsound(src, 'sound/machines/terminal_on.ogg', 25, FALSE)
	else
		playsound(src, get_sfx("terminal_button"), 25, FALSE)
		tgui_interact(user)

/obj/item/device/dropship_computer/attackby(obj/item/object, mob/user)
	if(istype(object, /obj/item/device/dropship_handheld))
		var/obj/item/device/dropship_handheld/handheld = object
		if(linked_handheld == handheld)
			to_chat(user, SPAN_NOTICE("Handheld already linked."))
			return
		linked_handheld = handheld
		is_linked = TRUE
		to_chat(user, SPAN_NOTICE("Handheld device linked to maintenance computer."))
		playsound(src, 'sound/machines/terminal_success.ogg', 50, 1)
	else
		..()

/obj/item/device/dropship_computer/get_examine_text()
	. = ..()
	if(cell)
		. += "A [cell.name] is loaded. It has [cell.charge]/[cell.maxcharge] charge remaining."
	else
		. += "It has no battery inserted."

	if(table_setup)
		. += "The computer can be dragged towards you to pick it up."
	else
		. += "The computer must be placed on a table to be used."

/obj/item/device/dropship_computer/proc/unlink_handheld()
	linked_handheld = null
	is_linked = FALSE

/obj/item/device/dropship_computer/teardown()
	. = ..()
	open = FALSE
	on = FALSE
	icon_state = "dropshipcomp_cl"
	set_light(0)
	playsound(src, 'sound/machines/terminal_off.ogg', 25, FALSE)
	STOP_PROCESSING(SSobj, src)
	unlink_handheld()

/obj/item/device/dropship_computer/proc/power_on()
	if(open && !on)
		on = TRUE
		icon_state = "dropshipcomp_on"
		set_light(2, 2, "#00ff00")
		playsound(src, 'sound/machines/terminal_on.ogg', 25, FALSE)

/obj/item/device/dropship_computer/afterattack(atom/target, mob/user, proximity)
	if(!on)
		to_chat(user, SPAN_WARNING("The maintenance computer is powered off."))
		return
	if(!proximity || !istype(target, /obj/item/device/dropship_handheld))
		return

/obj/item/device/dropship_handheld/proc/get_tool_display_name(tool_type)
	var/obj/item/temp_tool = new tool_type() // Get the tool name for display in the maintenance computer
	var/tool_name = temp_tool.name
	qdel(temp_tool)

	return tool_name

/obj/item/device/dropship_handheld/proc/get_repair_data()
	if(!length(src.scanned_weapons))
		return null
	var/list/repair_info = list()
	var/list/weapons_to_remove = list()

	for(var/obj/structure/dropship_equipment/weapon/weapon in src.scanned_weapons)
		if(QDELETED(weapon) || !weapon || !islist(weapon.active_effects) || !length(weapon.active_effects))
			// Remove weapons that are deleted, invalid, or have no antiair effects (fully repaired/destroyed)
			weapons_to_remove += weapon
			continue

		var/mount_point = weapon.ship_base?.attach_id
		var/original_mount_point = src.original_mount_points[weapon]
		var/has_repair_needed = FALSE

		// Get shuttle information
		var/shuttle_name = weapon.linked_shuttle?.name
		var/shuttle_id = weapon.linked_shuttle?.id

		for(var/datum/dropship_antiair/effect as anything in weapon.active_effects)
			if(!islist(effect.repair_steps) || !length(effect.repair_steps))
				continue
			has_repair_needed = TRUE
			// Use a unique id for each effect instance
			var/effect_id = effect.effect_id ? effect.effect_id : "[effect.type]-[effect.creation_time ? effect.creation_time : world.time]"
			var/effect_name = effect.name ? effect.name : "Unknown Effect"
			var/equipment_name = weapon.name ? weapon.name : null
			// Calculate completed steps
			var/completed_steps = (isnum(effect.repair_step_index) && effect.repair_step_index > 1) ? min(effect.repair_step_index - 1, length(effect.repair_steps)) : 0

			// Converts type paths to names
			var/list/readable_steps = list()
			for(var/tool_type in effect.repair_steps)
				var/tool_name = src.get_tool_display_name(tool_type)
				readable_steps += tool_name

			// Additional effect information
			var/effect_description = effect.description ? effect.description : "No description available"
			var/effect_duration = effect.duration ? effect.duration : null
			var/time_applied = effect.creation_time ? effect.creation_time : null
			var/time_applied_text = time_applied ? worldtime2text("hh:mm", time_applied) : null
			// Describe what your antiair effect does here so it can show up on the maintenance computer
			var/list/debuffs = list()
			if(effect.antiair_fire)
				debuffs += "Cannot fire"
			if(effect.antiair_reload)
				debuffs += "Cannot reload"
			if(effect.antiair_destroy)
				debuffs += "Will be destroyed if not repaired"

			repair_info += list(list(
				"id" = "[effect_name] #[effect_id]",
				"steps" = readable_steps,
				"mount_point" = mount_point,
				"original_mount_point" = original_mount_point,
				"effect_name" = effect_name,
				"equipment_name" = equipment_name,
				"completed_steps" = completed_steps,
				"effect_description" = effect_description,
				"effect_duration" = effect_duration,
				"time_applied" = time_applied,
				"time_applied_text" = time_applied_text,
				"shuttle_name" = shuttle_name,
				"shuttle_id" = shuttle_id,
				"debuffs" = debuffs
			))

		// If this weapon has no effects that need repairs, mark it for removal
		if(!has_repair_needed)
			weapons_to_remove += weapon

	// Remove fully repaired weapons from the scanned list
	for(var/weapon in weapons_to_remove)
		src.scanned_weapons -= weapon
		src.original_mount_points -= weapon

	update_icon()

	return repair_info

/obj/item/device/dropship_computer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DropshipMaintenanceUI", name)
		ui.open()

/obj/item/device/dropship_computer/ui_data(mob/user)
	. = list()
	var/obj/item/device/dropship_handheld/handheld = linked_handheld
	var/list/repair_list = handheld ? handheld.get_repair_data() : list()
	. ["repair_list"] = is_linked ? repair_list : list()
	. ["screen_state"] = screen_state
	. ["current_time"] = world.time
	. ["electrical"] = list("charge" = 0, "max_charge" = 0)
	if(cell)
		. ["electrical"]["charge"] = cell.charge
		. ["electrical"]["max_charge"] = cell.maxcharge

/obj/item/device/dropship_computer/ui_static_data(mob/user)
	. = list()
	. ["screen_state"] = screen_state

/obj/item/device/dropship_computer/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!on)
		return UI_CLOSE
	if(!skillcheck(user, SKILL_PILOT, SKILL_PILOT_TRAINED))
		return UI_UPDATE

/obj/item/device/dropship_computer/ui_close(mob/user)
	SEND_SIGNAL(src, COMSIG_CAMERA_UNREGISTER_UI, user)

/obj/item/device/dropship_computer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("screen-state")
			screen_state = params["state"]
			playsound(src, get_sfx("terminal_button"), 25, FALSE)
			return FALSE

/obj/item/device/dropship_handheld/proc/clear_scanned_data()
	scanned_weapons.Cut()
	original_mount_points.Cut()
	update_icon()

/obj/item/device/dropship_handheld/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tool/screwdriver))
		if(!length(scanned_weapons))
			to_chat(user, SPAN_NOTICE("No scan data to clear."))
			return
		to_chat(user, SPAN_NOTICE("You clear the scan data from [src]."))
		clear_scanned_data()
		return
	. = ..()
