// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power

/obj/item/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "cell"
	item_state = "cell"

	force = 5.0
	throwforce = 5.0
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	var/construction_cost = list("metal"=750,"glass"=75)
	var/construction_time=100
	matter = list("metal" = 700, "glass" = 50)

/obj/item/cell/Initialize()
	. = ..()

	charge = maxcharge
	updateicon()

/obj/item/cell/proc/updateicon()
	overlays.Cut()

	if(charge < 0.01)
		return
	else if(charge/maxcharge >=0.995)
		overlays += image('icons/obj/structures/machinery/power.dmi', "cell-o2")
	else
		overlays += image('icons/obj/structures/machinery/power.dmi', "cell-o1")

/obj/item/cell/proc/percent()		// return % charge of cell
	return 100.0*charge/maxcharge

/obj/item/cell/proc/fully_charged()
	return (charge == maxcharge)

// use power from a cell
/obj/item/cell/proc/use(var/amount)
	if(charge < amount)	return 0
	charge = (charge - amount)
	return 1

// recharge the cell
/obj/item/cell/proc/give(var/amount)
	if(maxcharge < amount)	return 0
	var/amount_used = min(maxcharge-charge,amount)
	if(crit_fail)	return 0
	if(!prob(reliability))
		minor_fault++
		if(prob(minor_fault))
			crit_fail = 1
			return 0
	charge += amount_used
	return amount_used


/obj/item/cell/examine(mob/user)
	if(maxcharge <= 2500)
		to_chat(user, "[desc]\nThe manufacturer's label states this cell has a power rating of [maxcharge], and that you should not swallow it.\nThe charge meter reads [round(src.percent() )]%.")
	else
		to_chat(user, "This power cell has an exciting chrome finish, as it is an uber-capacity cell type! It has a power rating of [maxcharge]!\nThe charge meter reads [round(src.percent() )]%.")
	if(crit_fail)
		to_chat(user, SPAN_DANGER("This power cell seems to be faulty."))


/obj/item/cell/emp_act(severity)
	charge -= 1000 / severity
	if (charge < 0)
		charge = 0
	if(reliability != 100 && prob(50/severity))
		reliability -= 10 / severity
	..()

/obj/item/cell/ex_act(severity)

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
	return

/obj/item/cell/proc/get_electrocute_damage()
	switch (charge)
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
	name = "\improper Yamada brand rechargable AA battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT

	maxcharge = 500
	matter = list("metal" = 700, "glass" = 40)

/obj/item/cell/crap/empty/Initialize()
	. = ..()
	charge = 0

/obj/item/cell/secborg
	name = "security borg rechargable D battery"

	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	matter = list("metal" = 700, "glass" = 40)

/obj/item/cell/secborg/empty/Initialize()
	. = ..()
	charge = 0

/obj/item/cell/apc
	name = "heavy-duty power cell"

	maxcharge = 5000
	matter = list("metal" = 700, "glass" = 50)

/obj/item/cell/apc/full
	charge = 5000

/obj/item/cell/high
	name = "high-capacity power cell"

	icon_state = "hcell"
	maxcharge = 10000
	matter = list("metal" = 700, "glass" = 60)

/obj/item/cell/high/empty/Initialize()
	. = ..()
	charge = 0

/obj/item/cell/super
	name = "super-capacity power cell"

	icon_state = "scell"
	maxcharge = 20000
	matter = list("metal" = 700, "glass" = 70)
	construction_cost = list("metal"=750,"glass"=100)

/obj/item/cell/super/empty/Initialize()
	. = ..()
	charge = 0

/obj/item/cell/hyper
	name = "hyper-capacity power cell"

	icon_state = "hpcell"
	maxcharge = 30000
	matter = list("metal" = 700, "glass" = 80)
	construction_cost = list("metal"=500,"glass"=150,"gold"=200,"silver"=200)

/obj/item/cell/hyper/empty/Initialize()
	. = ..()
	charge = 0

/obj/item/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	maxcharge = 30000
	matter = list("metal" = 700, "glass" = 80)
	use()
		return 1

/obj/item/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."

	icon = 'icons/obj/structures/machinery/power.dmi' //'icons/obj/items/harvest.dmi'
	icon_state = "potato_cell" //"potato_battery"
	charge = 100
	maxcharge = 300
	minor_fault = 1
