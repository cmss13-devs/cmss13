//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "happy pills"
	gender = PLURAL
	desc = "Highly illegal drug. When you want to see the rainbow."
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/happy/Initialize()
	. = ..()
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )

/obj/item/storage/pill_bottle/frenzy
	name = "Frenzy"
	gender = PLURAL
	desc = "A highly illegal concotion of drugs, infamously utilized by CLF fighters to improve performance and steel their nerves before combat. Extremely volatile side effects. The subject of many CMB sting operations, a minimum charge for possession of Frenzy carries at least 10 years in UA federal prison."
	skilllock = SKILL_MEDICAL_TRAINED

/obj/item/storage/pill_bottle/frenzy/Initialize()
	. = ..()
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )
	new /obj/item/reagent_container/pill/frenzy( src )

/obj/item/storage/pill_bottle/zombie_powder
	name = "suspicious pill bottle"
	icon_state = "pill_canister10"
	pill_type_to_fill = /obj/item/reagent_container/pill/zombie_powder
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "??"

/obj/item/reagent_container/food/drinks/flask/weylandyutani/poison
	desc = "A metal flask embossed with Weyland-Yutani's signature logo that some corporate bootlicker probably ordered to be stocked in USS military vessels' canteen vendors. This one smells off..."

/obj/item/reagent_container/food/drinks/flask/weylandyutani/poison/Initialize()
	. = ..()
	reagents.remove_any(60)
	reagents.add_reagent("souto_classic", 30)
	reagents.add_reagent("neurotoxin", 30)

/obj/item/reagent_container/food/drinks/bottle/holywater/bong
	name = "flask of hippie water"
	desc = "Formerly a flask of the chaplain's holy water, this one has been repurposed as... something else visually similar."

/obj/item/reagent_container/food/drinks/bottle/holywater/bong/Initialize()
	. = ..()
	reagents.remove_any(100)
	reagents.add_reagent("hippiesdelight", 100)

/obj/item/weapon/baton/damaged
	name = "damaged stunbaton"
	desc = "A stun baton for incapacitating people with. This one seems pretty broken and beat up, especially around the on/off switch.."
	force = 12
	has_user_lock = FALSE
