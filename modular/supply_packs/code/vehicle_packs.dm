// ==========================================
// =============== Мотоциклы ================

/datum/supply_packs/motorbike
	name = "Vehicle - Motorbike (x1)"
	contains = list(
		/obj/vehicle/motorbike/camo,
		/obj/item/pamphlet/skill/vc/low,
	)
	cost = 40
	containertype = /obj/structure/largecrate
	containername = "Упакованный мотоцикл"
	group = "Vehicle Equipment"

// ======== Коляски для мотоциклов ==========
/datum/supply_packs/motorbike_stroller
	name = "Vehicle - Motorbike stroller (x1)"
	contains = list(
		/obj/structure/bed/chair/stroller/camo,
	)
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "Упакованная коляска для мотоцикла"
	group = "Vehicle Equipment"

// ==========================================
