

/obj/item/frame/light_fixture
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "tube-construct-item"
	flags_atom = FPRINT|CONDUCT
	var/fixture_type = "tube"
	var/obj/structure/machinery/light/newlight = null
	var/sheets_refunded = 2

/obj/item/frame/light_fixture/attackby(obj/item/W as obj, mob/user as mob)
	if (HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		new /obj/item/stack/sheet/metal( get_turf(src.loc), sheets_refunded )
		qdel(src)
		return
	..()

/obj/item/frame/light_fixture/proc/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in cardinal))
		return
	var/turf/loc = get_turf(usr)
	if (!istype(loc, /turf/open/floor))
		to_chat(usr, SPAN_DANGER("[src.name] cannot be placed on this spot."))
		return
	to_chat(usr, "Attaching [src] to the wall.")
	playsound(src.loc, 'sound/machines/click.ogg', 15, 1)
	var/constrdir = usr.dir
	var/constrloc = usr.loc
	if (!do_after(usr, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	switch(fixture_type)
		if("bulb")
			newlight = new /obj/structure/machinery/light_construct/small(constrloc)
		if("tube")
			newlight = new /obj/structure/machinery/light_construct(constrloc)
	newlight.setDir(constrdir)
	transfer_fingerprints_to(newlight)
	usr.visible_message("[usr.name] attaches [src] to the wall.", \
		"You attach [src] to the wall.")
	qdel(src)

/obj/item/frame/light_fixture/small
	name = "small light fixture frame"
	desc = "Used for building small lights."
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "bulb-construct-item"
	fixture_type = "bulb"
	sheets_refunded = 1