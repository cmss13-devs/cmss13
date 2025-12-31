/obj/structure/closet/secure_closet/emergency/surgery
	name = "emergency surgical equipment cabinet"
	desc = "A hyper-safe, self-sterilizing, wall-mounted cabinet containing extra surgical beds, surgical webbing vests, and portable dialysis machines. It unlocks and opens itself during evac, then closes and locks itself back up if evac is cancelled."
	icon_state = "e-surgical_wall_locked"
	icon_closed = "e-surgical_wall_unlocked"
	icon_locked = "e-surgical_wall_locked"
	icon_opened = "e-surgical_wall_open"
	icon_broken = "e-surgical_wall_spark"
	health = null	// Unbreakable
	unacidable = TRUE
	unslashable = TRUE
	store_mobs = TRUE
	wall_mounted = TRUE

/obj/structure/closet/secure_closet/emergency/surgery/Initialize()
	. = ..()
	new /obj/item/storage/internal/accessory/surg_vest/equipped(src) //one for each doctor slot
	new /obj/item/storage/internal/accessory/surg_vest/equipped(src)
	new /obj/item/storage/internal/accessory/surg_vest/equipped(src)
	new /obj/item/storage/internal/accessory/surg_vest/equipped(src)
	new /obj/item/roller/surgical(src)
	new /obj/item/roller/surgical(src)
	new /obj/item/roller/surgical(src)
	new /obj/item/roller/surgical(src)
	new /obj/item/tool/portadialysis(src) //one for each doctor slot
	new /obj/item/tool/portadialysis(src)
	new /obj/item/tool/portadialysis(src)
	new /obj/item/tool/portadialysis(src)
