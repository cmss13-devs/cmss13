#define UNLIMITED_CHARGE -1
#define UNLIMITED_DISTANCE -1

/datum/component/cell
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Maximum charge of the power cell, set to -1 for infinite charge
	var/max_charge = 10000
	/// Initial max charge of the power cell
	var/initial_max_charge
	/// Current charge of power cell
	var/charge = 10000
	/// If the component can be recharged by hitting its parent with a cell
	var/hit_charge = FALSE
	/// The maximum amount that can be recharged per tick when using a cell to recharge this component
	var/max_recharge_tick = 400
	/// If draining charge on process(), how much to drain per process call
	var/charge_drain = 10
	/// If the parent should show cell charge on examine
	var/display_charge = TRUE
	/// From how many tiles at the highest someone can examine the parent to see the charge
	var/charge_examine_range = 1
	/// If the component requires a cell to be inserted to work instead of having an integrated one
	var/cell_insert = FALSE
	/// Ref to an inserted cell. Should only be null if cell_insert is false
	var/obj/item/cell/inserted_cell


/datum/component/cell/Initialize(
	max_charge = 10000,
	hit_charge = FALSE,
	max_recharge_tick = 400,
	charge_drain = 10,
	display_charge = TRUE,
	charge_examine_range = 1,
	cell_insert = FALSE,
	)

	. = ..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.max_charge = max_charge
	charge = max_charge
	src.hit_charge = hit_charge
	src.max_recharge_tick = max_recharge_tick
	src.charge_drain = charge_drain
	src.display_charge = display_charge
	src.charge_examine_range = charge_examine_range
	src.cell_insert = cell_insert

/datum/component/cell/Destroy(force, silent)
	QDEL_NULL(inserted_cell)
	return ..()


/datum/component/cell/RegisterWithParent()
	..()
	RegisterSignal(parent, list(COMSIG_PARENT_ATTACKBY, COMSIG_ITEM_ATTACKED), PROC_REF(on_object_hit))
	RegisterSignal(parent, COMSIG_CELL_ADD_CHARGE, PROC_REF(add_charge))
	RegisterSignal(parent, COMSIG_CELL_USE_CHARGE, PROC_REF(use_charge))
	RegisterSignal(parent, COMSIG_CELL_CHECK_CHARGE, PROC_REF(has_charge))
	RegisterSignal(parent, COMSIG_CELL_START_TICK_DRAIN, PROC_REF(start_drain))
	RegisterSignal(parent, COMSIG_CELL_STOP_TICK_DRAIN, PROC_REF(stop_drain))
	RegisterSignal(parent, COMSIG_CELL_REMOVE_CELL, PROC_REF(remove_cell))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_EMP_ACT, PROC_REF(on_emp))

/datum/component/cell/process()
	use_charge(null, charge_drain)

/datum/component/cell/proc/on_emp(datum/source, severity)
	SIGNAL_HANDLER

	use_charge(null, floor(max_charge / severity))

/datum/component/cell/proc/start_drain(datum/source)
	SIGNAL_HANDLER

	START_PROCESSING(SSobj, src)

/datum/component/cell/proc/stop_drain(datum/source)
	SIGNAL_HANDLER

	STOP_PROCESSING(SSobj, src)

/datum/component/cell/proc/on_examine(datum/source, mob/examiner, list/examine_text)
	SIGNAL_HANDLER

	if(!display_charge)
		return

	if((charge_examine_range != UNLIMITED_DISTANCE) && get_dist(examiner, parent) > charge_examine_range)
		return

	examine_text += "A small gauge in the corner reads \"Power: [floor(100 * charge / max_charge)]%\"."

/datum/component/cell/proc/on_object_hit(datum/source, obj/item/cell/attack_obj, mob/living/attacker, params)
	SIGNAL_HANDLER

	if(!hit_charge || !istype(attack_obj))
		return

	if(!cell_insert)
		INVOKE_ASYNC(src, PROC_REF(charge_from_cell), attack_obj, attacker)

	else
		insert_cell(attack_obj, attacker)

	return COMPONENT_NO_AFTERATTACK|COMPONENT_CANCEL_ITEM_ATTACK

/datum/component/cell/proc/insert_cell(obj/item/cell/power_cell, mob/living/user)
	if(inserted_cell)
		to_chat(user, SPAN_WARNING("There's already a power cell in [parent]!"))
		return

	if(SEND_SIGNAL(parent, COMSIG_CELL_TRY_INSERT_CELL) & COMPONENT_CANCEL_CELL_INSERT)
		return

	power_cell.drop_to_floor(user)
	power_cell.forceMove(parent)
	inserted_cell = power_cell
	charge = power_cell.charge
	max_charge = power_cell.maxcharge

/datum/component/cell/proc/remove_cell(mob/living/user)
	SIGNAL_HANDLER

	user.put_in_hands(inserted_cell, TRUE)
	to_chat(user, SPAN_NOTICE("You remove [inserted_cell] from [parent]."))
	inserted_cell = null
	max_charge = initial_max_charge
	charge = 0

/datum/component/cell/proc/charge_from_cell(obj/item/cell/power_cell, mob/living/user)
	if(max_charge == UNLIMITED_CHARGE)
		to_chat(user, SPAN_WARNING("[parent] doesn't need more power."))
		return

	while(charge < max_charge)
		if(SEND_SIGNAL(parent, COMSIG_CELL_TRY_RECHARGING, user) & COMPONENT_CELL_NO_RECHARGE)
			return

		if(power_cell.charge <= 0)
			to_chat(user, SPAN_WARNING("[power_cell] is completely dry."))
			return

		if(!do_after(user, 1 SECONDS, (INTERRUPT_ALL & (~INTERRUPT_MOVED)), BUSY_ICON_BUILD, power_cell, INTERRUPT_DIFF_LOC))
			to_chat(user, SPAN_WARNING("You were interrupted."))
			return

		if(power_cell.charge <= 0)
			return

		var/to_transfer = min(max_recharge_tick, power_cell.charge, (max_charge - charge))
		if(power_cell.use(to_transfer))
			add_charge(null, to_transfer)
			to_chat(user, "You transfer some power between [power_cell] and [parent]. The gauge now reads: [floor(100 * charge / max_charge)]%.")

/datum/component/cell/proc/add_charge(datum/source, charge_add = 0)
	SIGNAL_HANDLER

	if(max_charge == UNLIMITED_CHARGE)
		return

	if(!charge_add)
		return

	charge = clamp(charge + charge_add, 0, max_charge)

/datum/component/cell/proc/use_charge(datum/source, charge_use = 0)
	SIGNAL_HANDLER

	if(max_charge == UNLIMITED_CHARGE)
		return

	if(!charge_use)
		return

	if(!charge)
		return COMPONENT_CELL_NO_USE_CHARGE

	charge = clamp(charge - charge_use, 0, max_charge)

	if(!charge)
		on_charge_empty()
		return

/datum/component/cell/proc/has_charge(datum/source, charge_amount = 0)
	SIGNAL_HANDLER

	if(!charge)
		return COMPONENT_CELL_CHARGE_INSUFFICIENT

	if(charge < charge_amount)
		return COMPONENT_CELL_CHARGE_INSUFFICIENT

/datum/component/cell/proc/on_charge_empty()
	stop_drain()
	SEND_SIGNAL(parent, COMSIG_CELL_OUT_OF_CHARGE)

#undef UNLIMITED_CHARGE
#undef UNLIMITED_DISTANCE
