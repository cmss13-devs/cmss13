/obj/structure/debris
	name = "debris"
	icon = 'icons/obj/structures/debris.dmi'
	icon_state = "debris_0"
	desc = "Debris from collapsed roof."
	var/amount = 0
	var/max_amount = 2

/obj/structure/debris/Initialize(mapload, ...)
	. = ..()
	for(var/obj/structure/debris/debris in loc)
		if(debris != src)
			debris.pile_up()
			qdel(src)

/obj/structure/debris/update_icon()
	. = ..()
	icon_state = "debris_[amount]"


/obj/structure/debris/proc/pile_up()
	if(amount == max_amount)
		return

	amount++
	update_icon()
	return




