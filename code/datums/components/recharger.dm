/datum/component/recharger
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Ref to the inserted item, if any
	var/obj/item/inserted_item
	/// If we're currently recharging anything
	var/recharging = FALSE
	/// A typecache of what items can be inserted into the recharger
	var/list/valid_items
	/// A list of the default acceptable items to be inserted into the recharger, in case one isn't passed in during init
	var/static/list/default_valid_items = list(
		/obj/item/weapon/baton,
		/obj/item/cell,
		/obj/item/weapon/gun/energy,
		/obj/item/device/defibrillator,
		/obj/item/tool/portadialysis,
		/obj/item/clothing/suit/auto_cpr,
		/obj/item/smartgun_battery,
		/obj/item/device/helmet_visor/night_vision,
	)
	/// A list of items that have an overlay added to the recharger when the item is inserted
	/// Formatted like so: list(/type/path = "overlay_name")
	var/list/custom_overlay_items = list()
	/// How much power (later multiplied by CELLRATE, which is 0.006) to recharge by per tick, should the parent not have an active_power_usage
	var/charge_amount = 750
	/// If not empty, the parent has unique overlays dependent on how charged the inserted item is.
	/// Formatted like so: list("icon_state_name" = charge_upper_bound)
	/// Highest charge should be 1st in the list, 2nd highest 2nd in list, etc.
	var/list/charge_overlays = list()
	/// Icon file for charge_overlay and custom_item_overlay
	var/overlay_icon
	/// Ref to the mutable appearance that we use as an overlay for the parent if we're using charge_overlays
	var/mutable_appearance/charge_overlay
	/// Ref to the possible secondary mutable appearance applied if an item present in custom_overlay_items is inserted
	var/mutable_appearance/custom_item_overlay
	/// If things can be inserted/removed while the parent is unanchored
	var/unanchored_use = FALSE

/datum/component/recharger/Initialize(
	valid_items,
	override_charge_amount,
	charge_overlays,
	overlay_icon,
	unanchored_use,
	custom_overlay_items = list(),
)
	. = ..()
	if(!istype(parent, /obj/structure/machinery))
		return COMPONENT_INCOMPATIBLE

	if(valid_items)
		src.valid_items = typecacheof(valid_items)
	else
		src.valid_items = typecacheof(default_valid_items)

	src.overlay_icon = overlay_icon

	if(charge_overlays)
		src.charge_overlays = charge_overlays
		update_overlay()

	var/obj/structure/machinery/machine_parent = parent
	if(machine_parent.active_power_usage && !override_charge_amount)
		charge_amount = machine_parent.active_power_usage

	if(override_charge_amount)
		charge_amount = override_charge_amount

	if(!isnull(unanchored_use))
		src.unanchored_use = unanchored_use

	src.custom_overlay_items = custom_overlay_items

/datum/component/recharger/Destroy(force, silent)
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(inserted_item)

	if(charge_overlay)
		var/obj/structure/machinery/machine_parent = parent
		machine_parent.overlays -= charge_overlay
		QDEL_NULL(charge_overlay)

	if(custom_item_overlay)
		var/obj/structure/machinery/machine_parent = parent
		machine_parent.overlays -= custom_item_overlay
		QDEL_NULL(custom_item_overlay)

	return ..()

/datum/component/recharger/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attack))
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(parent, COMSIG_MACHINERY_POWER_CHANGE, PROC_REF(update_overlay))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_OBJ_TRY_UNWRENCH, PROC_REF(on_unwrench))

/datum/component/recharger/proc/on_unwrench(datum/source, obj/item/wrench, mob/living/user)
	if(!unanchored_use && (recharging || inserted_item))
		to_chat(user, SPAN_WARNING("Remove [inserted_item] from [parent] before trying to move it!"))
		return ELEMENT_OBJ_STOP_UNWRENCH

/datum/component/recharger/proc/on_attack(datum/source, obj/item/weapon, mob/living/user, params)
	SIGNAL_HANDLER

	if(inserted_item)
		to_chat(user, SPAN_WARNING("There's already something recharging inside [parent]."))
		return COMPONENT_NO_AFTERATTACK

	var/obj/structure/machinery/machine_parent = parent
	if(!unanchored_use && !machine_parent.anchored)
		to_chat(user, SPAN_WARNING("You can't put anything inside [parent] while it's unanchored!"))
		return COMPONENT_NO_AFTERATTACK

	var/area/parent_area = get_area(parent)
	if(!isarea(parent_area) || (!parent_area.power_equip && !parent_area.unlimited_power))
		to_chat(user, SPAN_WARNING("[parent] blinks red as you try to insert [weapon]!"))
		return

	if(!is_type_in_typecache(weapon, valid_items))
		return

	insert_item(weapon, user)
	return COMPONENT_NO_AFTERATTACK

/datum/component/recharger/proc/on_attack_hand(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!inserted_item)
		return

	user.put_in_hands(inserted_item)
	inserted_item = null
	stop_charging()
	update_overlay()

/datum/component/recharger/proc/insert_item(obj/item/item, mob/living/user)
	if(user.drop_inv_item_to_loc(item, parent))
		inserted_item = item
		start_charging()

/datum/component/recharger/proc/start_charging()
	START_PROCESSING(SSobj, src)
	recharging = TRUE
	update_overlay()

/datum/component/recharger/proc/stop_charging()
	STOP_PROCESSING(SSobj, src)
	recharging = FALSE
	var/obj/obj_parent = parent
	obj_parent.overlays -= charge_overlay
	obj_parent.overlays -= custom_item_overlay

/datum/component/recharger/proc/on_examine(datum/source, mob/examiner, list/examine_text)
	examine_text += "There's \a [inserted_item ? "[inserted_item.name]" : "nothing"] in the charger."
	if(recharging)
		examine_text += "Current charge: [inserted_item.get_cell_charge()] ([inserted_item.get_cell_percent()]%)"

/datum/component/recharger/proc/on_emp(datum/source, severity)
	SIGNAL_HANDLER

	if(inserted_item)
		// Async called because there's a subtype of /atom/emp_act() that sleeps
		// And since we use SIGNAL_HANDLER above, the linter's unhappy
		INVOKE_ASYNC(inserted_item, TYPE_PROC_REF(/atom, emp_act), severity)

/datum/component/recharger/proc/update_power_use(new_power_use)
	if(isnull(new_power_use))
		return

	var/obj/structure/machinery/machine_parent = parent
	machine_parent.update_use_power(new_power_use)
	update_overlay()

/datum/component/recharger/proc/update_overlay(datum/source)
	SIGNAL_HANDLER

	if(!length(charge_overlays) || !overlay_icon)
		return

	var/obj/structure/machinery/machine_parent = parent

	if(!charge_overlay)
		charge_overlay = mutable_appearance(overlay_icon)

	if(!inserted_item)
		charge_overlay.icon_state = ""
		return

	for(var/path in custom_overlay_items)
		if(istype(inserted_item, path))
			if(!custom_item_overlay)
				custom_item_overlay = new(overlay_icon)
			custom_item_overlay.icon_state = custom_overlay_items[path]
			break

	if(machine_parent.inoperable())
		charge_overlay.icon_state = ""
		return

	for(var/overlay_state in charge_overlays)
		var/charge_percent = charge_overlays[overlay_state]
		// We check if the % needed for the icon state is less the cell
		// If it's more than the cell, we continue down and go to the next (lower) overlay iconstate
		if(SEND_SIGNAL(inserted_item, COMSIG_CELL_CHECK_CHARGE_PERCENT, charge_percent) & COMPONENT_CELL_CHARGE_PERCENT_INSUFFICIENT)
			continue

		charge_overlay.icon_state = overlay_state
		break

	machine_parent.overlays.Cut()
	machine_parent.overlays += charge_overlay
	machine_parent.overlays += custom_item_overlay

/datum/component/recharger/process()
	var/obj/structure/machinery/machine_parent = parent
	if(machine_parent.inoperable() || !machine_parent.anchored)
		update_power_use(USE_POWER_NONE)
		return

	if(!recharging)
		update_power_use(USE_POWER_IDLE)
		return

	if(SEND_SIGNAL(inserted_item, COMSIG_CELL_CHECK_FULL_CHARGE) & COMPONENT_CELL_CHARGE_NOT_FULL)
		SEND_SIGNAL(inserted_item, COMSIG_CELL_ADD_CHARGE, min(charge_amount, (inserted_item.get_cell_max_charge() * 0.1)))
		update_power_use(USE_POWER_ACTIVE)
	else
		update_power_use(USE_POWER_IDLE)
