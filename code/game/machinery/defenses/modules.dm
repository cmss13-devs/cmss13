/obj/item/defense_module
	unacidable = TRUE
	w_class = SIZE_TINY
	icon = 'icons/obj/structures/machinery/defenses.dmi'
	desc = "A special component to be placed and welded onto a defense base to produce the finest product USCM can offer."

/obj/item/defense_module/attackby(var/obj/item/O, var/mob/user)
	if(iscrowbar(O))
		user.visible_message(SPAN_NOTICE("[user] pulls [src] apart."), SPAN_NOTICE("You pull [src] apart."))
		playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
		new /obj/item/stack/sheet/metal(loc, MODULE_METAL_COST)
		qdel(src)
		return
	
	. = ..()

/obj/item/defense_module/sentry
	name = "\improper UA 571-C turret module"
	icon_state = "uac_sentry_preweld"

/obj/item/defense_module/sentry_flamer
	name = "\improper UA 42-F turret module"
	icon_state = "uac_flamer_preweld"

/obj/item/defense_module/planted_flag
	name = "\improper JIMA planted flag module"
	icon_state = "planted_flag_preweld"

/obj/item/defense_module/bell_tower
	name = "\improper R-1NG bell tower module"
	icon_state = "bell_tower_preweld"

/obj/item/defense_module/tesla_coil
	name = "\improper 21S tesla coil module"
	icon_state = "tesla_coil_preweld"