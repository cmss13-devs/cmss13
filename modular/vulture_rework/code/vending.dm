/obj/structure/machinery/cm_vending/sorted/cargo_guns/populate_product_list(scale)
	. = ..()
	LAZYINSERT(listed_products, list(list("M707 Anti Material Rifle", (1), /obj/item/storage/box/guncase/vulture, VENDOR_ITEM_REGULAR)), 13)

/datum/supply_packs/ammo_vulture_mag
	name = "M707 Anti-Materiel Rifle ammo crate"
	contains = list(
		/obj/item/ammo_magazine/rifle/boltaction/vulture,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M707 ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_vulture_mag_holo
	name = "M707 Anti-Materiel Rifle holo target ammo crate"
	contains = list(
		/obj/item/ammo_magazine/rifle/boltaction/vulture/holo_target,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M707 holo target ammo crate"
	group = "Ammo"

/obj/item/storage/box/guncase/vulture/fill_preset_inventory()
	var/obj/item/weapon/gun/boltaction/vulture/rifle = new(src)
	new /obj/item/ammo_magazine/rifle/boltaction/vulture(src)
	new /obj/item/ammo_magazine/rifle/boltaction/vulture/holo_target(src)
	new /obj/item/device/vulture_spotter_tripod(src)
	new /obj/item/device/vulture_spotter_scope(src, WEAKREF(rifle))
	new /obj/item/tool/screwdriver(src) // Spotter scope needs a screwdriver to disassemble
	new /obj/item/pamphlet/trait/vulture(src) //both pamphlets give use of the scope and the rifle
	new /obj/item/pamphlet/trait/vulture(src)
