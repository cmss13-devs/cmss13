//Packets of spec ammo, for easier Requisitions delivery
/obj/item/storage/box/packet/spec
	w_class = SIZE_LARGE //Not very useful in a bag, but good for crate delivery

//Sniper
/obj/item/storage/box/packet/spec/sniper
	name = "\improper M42A marksman magazine packet (10x28mm Caseless)"
	desc = "It contains five M42A marksman magazines."
	storage_slots = 5
	can_hold = list(/obj/item/ammo_magazine/sniper)
	content_type = /obj/item/ammo_magazine/sniper

/obj/item/storage/box/packet/spec/sniper/incendiary
	name = "\improper M42A incendiary magazine packet (10x28mm)"
	desc = "It contains five M42A incendiary magazines."
	content_type = /obj/item/ammo_magazine/sniper/incendiary

/obj/item/storage/box/packet/spec/sniper/flak
	name = "\improper M42A flak magazine packet (10x28mm)"
	desc = "It contains five M42A flak magazines."
	content_type = /obj/item/ammo_magazine/sniper/flak

/obj/item/storage/box/packet/spec/sniper/mixed
	name = "\improper M42A mixed magazine packet (10x28mm)"
	desc = "It contains six mixed M42A magazines."
	storage_slots = 6
	content_type = null //Null because we don't want it indexed

/obj/item/storage/box/packet/spec/sniper/mixed/fill_preset_inventory()
	new /obj/item/ammo_magazine/sniper(src)
	new /obj/item/ammo_magazine/sniper(src)
	new /obj/item/ammo_magazine/sniper/flak(src)
	new /obj/item/ammo_magazine/sniper/flak(src)
	new /obj/item/ammo_magazine/sniper/incendiary(src)
	new /obj/item/ammo_magazine/sniper/incendiary(src)

//Scout
/obj/item/storage/box/packet/spec/scout
	name = "\improper A19 high velocity magazine packet (10x24mm)"
	desc = "It contains five A19 high velocity magazines."
	storage_slots = 5
	can_hold = list(/obj/item/ammo_magazine/rifle/m4ra)
	content_type = /obj/item/ammo_magazine/rifle/m4ra

/obj/item/storage/box/packet/spec/scout/incendiary
	name = "\improper A19 high velocity incendiary magazine packet (10x24mm)"
	desc = "It contains five A19 high velocity incendiary magazines."
	content_type = /obj/item/ammo_magazine/rifle/m4ra/incendiary

/obj/item/storage/box/packet/spec/scout/impact
	name = "\improper A19 high velocity impact magazine packet (10x24mm)"
	desc = "It contains five A19 high velocity impact magazines."
	content_type = /obj/item/ammo_magazine/rifle/m4ra/impact

/obj/item/storage/box/packet/spec/scout/mixed
	name = "\improper A19 mixed high velocity magazine packet (10x24mm)"
	desc = "It contains six mixed A19 high velocity impact magazines."
	storage_slots = 6
	content_type = null //Null because we don't want it indexed

/obj/item/storage/box/packet/spec/scout/mixed/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/m4ra(src)
	new /obj/item/ammo_magazine/rifle/m4ra(src)
	new /obj/item/ammo_magazine/rifle/m4ra/incendiary(src)
	new /obj/item/ammo_magazine/rifle/m4ra/incendiary(src)
	new /obj/item/ammo_magazine/rifle/m4ra/impact(src)
	new /obj/item/ammo_magazine/rifle/m4ra/impact(src)

//Demolitionist
/obj/item/storage/box/packet/spec/demo
	name = "\improper M5 RPG Rocket packet (HE)"
	desc = "It contains three M5 RPG HE rockets."
	storage_slots = 3
	can_hold = list(/obj/item/ammo_magazine/rocket)
	content_type = /obj/item/ammo_magazine/rocket

/obj/item/storage/box/packet/spec/demo/ap
	name = "\improper M5 RPG Rocket packet (AP)"
	desc = "It contains three M5 RPG AP rockets."
	content_type = /obj/item/ammo_magazine/rocket/ap

/obj/item/storage/box/packet/spec/demo/wp
	name = "\improper M5 RPG Rocket packet (WP)"
	desc = "It contains three M5 RPG WP rockets."
	content_type = /obj/item/ammo_magazine/rocket/wp

/obj/item/storage/box/packet/spec/demo/mixed
	name = "\improper M5 RPG Rocket packet (Mixed)"
	desc = "It contains three mixed M5 RPG rockets."
	content_type = null

/obj/item/storage/box/packet/spec/demo/mixed/fill_preset_inventory()
	new /obj/item/ammo_magazine/rocket(src)
	new /obj/item/ammo_magazine/rocket/ap(src)
	new /obj/item/ammo_magazine/rocket/wp(src)

//Pyrotechnician
/obj/item/storage/box/packet/spec/pyro
	name = "\improper M240-T Extended Fuel Tank packet"
	desc = "It contains three M5 RPG HE rockets."
	storage_slots = 3
	can_hold = list(/obj/item/ammo_magazine/flamer_tank/large)
	content_type = /obj/item/ammo_magazine/flamer_tank/large

/obj/item/storage/box/packet/spec/pyro/B
	name = "\improper M240-T Type-B Fuel Tank packet"
	desc = "It contains three M240-T Type-B Fuel Tanks."
	content_type = /obj/item/ammo_magazine/flamer_tank/large/B

/obj/item/storage/box/packet/spec/pyro/X
	name = "\improper M240-T Type-X Fuel Tank packet"
	desc = "It contains three M240-T Type-X Fuel Tanks."
	content_type = /obj/item/ammo_magazine/flamer_tank/large/X

/obj/item/storage/box/packet/spec/pyro/mixed
	name = "\improper M240-T Mixed Fuel Tank packet"
	desc = "It contains three mixed M240-T Fuel Tanks."
	content_type = null

/obj/item/storage/box/packet/spec/pyro/mixed/fill_preset_inventory()
	new /obj/item/ammo_magazine/flamer_tank/large(src)
	new /obj/item/ammo_magazine/flamer_tank/large/B(src)
	new /obj/item/ammo_magazine/flamer_tank/large/X(src)

//Smartgunner
/obj/item/storage/box/packet/spec/smartgunner
	name = "\improper M56 smartgun drum packet"
	desc = "It contains two M56 smartgun drums."
	storage_slots = 2
	can_hold = list(/obj/item/ammo_magazine/smartgun)
	content_type = /obj/item/ammo_magazine/smartgun
