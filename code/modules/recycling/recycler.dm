
/obj/structure/machinery/recycler
	name = "recycler"
	desc = "A large crushing machine used to recycle trash."
	icon = 'icons/obj/structures/machinery/recycling.dmi'
	icon_state = "separator-AO1"
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	var/recycle_dir = NORTH
	var/list/stored_matter =  list("metal" = 0, "glass" = 0)
	/// Amount of metal refunded per crate, by default about 2 metal sheets (building one takes 5)
	var/crate_reward = 7500
	/// Amount of sheets to stack before outputting a stack
	var/sheets_per_batch = 10
	var/last_recycle_sound //for sound cooldown
	var/ignored_items = list(/obj/item/limb)

/obj/structure/machinery/recycler/whiskey
	crate_reward = 15000 //  Boosted reward (4 sheets) to make up for workload and the fact you can't sell them

/obj/structure/machinery/recycler/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/structure/machinery/recycler/update_icon()
	. = ..()
	icon_state = "separator-AO[(inoperable()) ? "0":"1"]"

/obj/structure/machinery/recycler/Collided(atom/movable/movable)
	if(inoperable())
		return
	var/move_dir = get_dir(loc, movable.loc)
	if(!movable.anchored && move_dir == recycle_dir)
		if(istype(movable, /obj/item))
			recycle(movable)
		else if(istype(movable, /obj/structure/closet/crate))
			recycle_crate(movable)
		else
			movable.forceMove(loc)


/obj/structure/machinery/recycler/proc/recycle(obj/item/I)
	var/turf/T = get_turf(I)

	for(var/forbidden_path in ignored_items)
		if(istype(I, forbidden_path))
			I.forceMove(loc)
			return

	if(isstorage(I))
		var/obj/item/storage/S = I
		for(var/obj/item/X in S.contents)
			S.remove_from_storage(X, T)
			recycle(X)

	if(I.matter)
		for(var/material in I.matter)
			if(isnull(stored_matter[material]))
				continue
			var/total_material = I.matter[material]
			//If it's a stack, we eat multiple sheets.
			if(istype(I,/obj/item/stack))
				var/obj/item/stack/stack = I
				total_material *= stack.get_amount()

			stored_matter[material] += total_material
	qdel(I)
	play_recycle_sound()
	output_materials()

/obj/structure/machinery/recycler/proc/recycle_crate(obj/structure/closet/crate)
	for(var/atom/movable/movable in crate)
		movable.forceMove(loc)
		recycle(movable)
	stored_matter["metal"] += crate_reward
	qdel(crate)
	play_recycle_sound()
	output_materials()

/obj/structure/machinery/recycler/proc/play_recycle_sound()
	if(last_recycle_sound < world.time)
		playsound(loc, 'sound/items/Welder.ogg', 30, 1)
		last_recycle_sound = world.time + 50

/obj/structure/machinery/recycler/proc/output_materials()
	for(var/material in stored_matter)
		if(stored_matter[material] >= sheets_per_batch * 3750)
			var/sheets = floor(stored_matter[material] / 3750)
			stored_matter[material] -= sheets * 3750
			var/obj/item/stack/sheet/sheet_stack
			switch(material)
				if("metal")
					sheet_stack = new /obj/item/stack/sheet/metal(loc)
				if("glass")
					sheet_stack = new /obj/item/stack/sheet/glass(loc)
			if(sheet_stack)
				sheet_stack.amount = sheets
				sheet_stack.update_icon()
