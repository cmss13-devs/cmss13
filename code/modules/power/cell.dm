// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power

/obj/item/cell
	name = "\improper power cell"
	desc = "A rechargeable electrochemical power cell."
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "cell"
	item_state = "cell"

	force = 5
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	/// How much the cell should hold at most, power-wise
	var/maxcharge = 1000
	/// How much charge the cell should start with. -1 will start it with maxcharge
	var/charge = -1
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	matter = list("metal" = 700, "glass" = 50)

/obj/item/cell/Initialize()
	. = ..()
	AddComponent(/datum/component/cell, maxcharge, initial_charge = charge)
	update_icon()
	RegisterSignal(src, COMSIG_CELL_CHARGE_MODIFIED, PROC_REF(update_icon))

/obj/item/cell/update_icon()
	..()
	overlays.Cut()

	if(charge < 0.01)
		return
	else if(charge/maxcharge >=0.995)
		overlays += image('icons/obj/structures/machinery/power.dmi', "cell-o2")
	else
		overlays += image('icons/obj/structures/machinery/power.dmi', "cell-o1")

/obj/item/cell/proc/percent() // return % charge of cell
	return get_cell_charge()

/obj/item/cell/proc/fully_charged()
	if(SEND_SIGNAL(src, COMSIG_CELL_CHECK_FULL_CHARGE) & COMPONENT_CELL_CHARGE_NOT_FULL)
		return FALSE
	return TRUE

/// use power from a cell
/obj/item/cell/proc/use(amount)
	if(SEND_SIGNAL(src, COMSIG_CELL_USE_CHARGE, amount) & COMPONENT_CELL_NO_USE_CHARGE)
		return FALSE
	return TRUE

/// recharge the cell
/obj/item/cell/proc/give(amount)
	SEND_SIGNAL(src, COMSIG_CELL_ADD_CHARGE, amount)

/obj/item/cell/get_examine_text(mob/user)
	. = ..()
	var/max_charge = get_cell_max_charge()
	if(max_charge <= 2500)
		. += SPAN_NOTICE("The manufacturer's label states this cell has a power rating of <b>[max_charge]</b>, and that you should not swallow it.\nThe charge meter reads <b>[get_cell_percent()]%</b>.")
	else
		. += SPAN_NOTICE("This power cell has an exciting chrome finish, as it is an uber-capacity cell type! It has a power rating of <b>[max_charge]</b>!\nThe charge meter reads <b>[get_cell_percent()]%</b>.")
	if(crit_fail)
		. += SPAN_DANGER("This power cell seems to be faulty.")

/obj/item/cell/ex_act(severity)

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				deconstruct()
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct()
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct()
			return
	return

/obj/item/cell/proc/get_electrocute_damage()
	switch (get_cell_charge())
		if (1000000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200000 to 1000000-1)
			return min(rand(25,80),rand(25,80))
		if (100000 to 200000-1)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000-1)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000-1)
			return min(rand(10,20),rand(10,20))
		else
			return 0

/obj/item/cell/crap
	name = "\improper W-Y rechargeable mini-battery"
	desc = "Cheap, throwaway batteries provided by the Weyland-Yutani Corporation. The 'rechargeable' feature was added to be more marketable to independent colonists hell-bent on 'using it till it disintegrates', a common sentiment on the frontier."
	icon_state = "mini-cell"
	w_class = SIZE_TINY
	maxcharge = 500
	matter = list("metal" = 700, "glass" = 40)

/obj/item/cell/crap/empty
	charge = 0

/obj/item/cell/secborg
	name = "\improper security borg rechargeable D battery"

	maxcharge = 600 //600 max charge / 100 charge per shot = six shots
	matter = list("metal" = 700, "glass" = 40)

/obj/item/cell/secborg/empty
	charge = 0

/obj/item/cell/apc
	name = "\improper heavy-duty power cell"

	maxcharge = 5000
	matter = list("metal" = 700, "glass" = 50)

/obj/item/cell/apc/empty
	charge = 0

/obj/item/cell/high
	name = "\improper high-capacity power cell"

	icon_state = "hcell"
	maxcharge = 10000
	matter = list("metal" = 700, "glass" = 60)

/obj/item/cell/high/empty
	charge = 0

/obj/item/cell/super
	name = "\improper super-capacity power cell"

	icon_state = "scell"
	maxcharge = 20000
	matter = list("metal" = 700, "glass" = 70)

/obj/item/cell/super/empty
	charge = 0

/obj/item/cell/hyper
	name = "\improper hyper-capacity power cell"

	icon_state = "hpcell"
	maxcharge = 30000
	matter = list("metal" = 700, "glass" = 80)

/obj/item/cell/hyper/empty
	charge = 0

/obj/item/cell/infinite
	name = "\improper infinite-capacity power cell!"
	icon_state = "icell"
	maxcharge = 30000
	matter = list("metal" = 700, "glass" = 80)

/obj/item/cell/infinite/use()
	return 1

/obj/item/cell/potato
	name = "\improper potato battery"
	desc = "A rechargeable starch-based power cell."

	icon = 'icons/obj/structures/machinery/power.dmi' //'icons/obj/items/harvest.dmi'
	icon_state = "potato_cell" //"potato_battery"
	maxcharge = 300
	minor_fault = TRUE
