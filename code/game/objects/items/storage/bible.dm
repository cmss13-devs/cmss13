/obj/item/storage/bible
	name = "bible"
	desc = "Apply to head repeatedly."
	icon_state ="bible"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	var/mob/affecting = null
	var/deity_name = "Christ"

/obj/item/storage/bible/booze
	name = "bible"
	desc = "To be applied to the head repeatedly."
	icon_state ="bible"

/obj/item/storage/bible/booze/fill_preset_inventory()
	new /obj/item/reagent_container/food/drinks/cans/beer(src)
	new /obj/item/reagent_container/food/drinks/cans/beer(src)
	new /obj/item/spacecash(src)
	new /obj/item/spacecash(src)
	new /obj/item/spacecash(src)

/obj/item/storage/bible/hefa
	name = "Holy texts of the High Explosive Fragmenting Anti-personnel hand grenade."
	desc = "Praise be he, reverand Clearsmire who has brought us into the light of the shrapnel! Sworn to the holy service of the HEFA lord are we, and while few, we are the voices of the silent many! Printed in the RESS."
	icon_state ="tome_hefa"

/obj/item/storage/bible/hefa/Initialize()
	. = ..()
	new /obj/item/explosive/grenade/HE/frag(src)
	new /obj/item/explosive/grenade/HE/frag(src)
	new /obj/item/explosive/grenade/HE/frag(src)

/obj/item/storage/bible/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(user.job == "Chaplain")
		if(A.reagents && A.reagents.has_reagent("water")) //blesses all the water in the holder
			to_chat(user, SPAN_NOTICE("You bless [A]."))
			var/water2holy = A.reagents.get_reagent_amount("water")
			A.reagents.del_reagent("water")
			A.reagents.add_reagent("holywater",water2holy)

/obj/item/storage/bible/attackby(obj/item/W as obj, mob/user as mob)
	if (use_sound)
		playsound(loc, use_sound, 25, TRUE, 6)
	..()
