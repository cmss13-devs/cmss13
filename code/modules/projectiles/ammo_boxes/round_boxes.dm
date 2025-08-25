//-----------------------AMMUNITION BOXES (LOOSE AMMO)-----------------------

//----------------10x24mm Ammunition Boxes (for M41 family, M4RA, and L42)------------------

/obj/item/ammo_box/rounds/ap
	name = "\improper rifle ammunition box (10x24mm AP)"
	desc = "A 10x24mm armor-piercing ammunition box. Used to refill M41A MK2, and M4RA AP magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_box/rounds/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/le
	name = "\improper rifle ammunition box (10x24mm LE)"
	desc = "A 10x24mm armor-shredding ammunition box. Used to refill M41A MK2 LE magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_le"
	default_ammo = /datum/ammo/bullet/rifle/le

/obj/item/ammo_box/rounds/le/empty
	empty = TRUE

/obj/item/ammo_box/rounds/incen
	name = "\improper rifle ammunition box (10x24mm Incen)"
	desc = "A 10x24mm incendiary ammunition box. Used to refill M41A MK2 and M4RA incendiary magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_incen"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	bullet_amount = 400 //Incen is OP
	max_bullet_amount = 400

/obj/item/ammo_box/rounds/incen/empty
	empty = TRUE

/obj/item/ammo_box/rounds/heap
	name = "rifle ammunition box (10x24mm HEAP)"
	desc = "A 10x24mm high-explosive armor-piercing ammunition box. Used to refill magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_heap"
	default_ammo = /datum/ammo/bullet/rifle/heap

/obj/item/ammo_box/rounds/heap/empty
	empty = TRUE

//----------------10x20mm Ammunition Boxes (for M39 SMG)------------------

/obj/item/ammo_box/rounds/smg
	name = "\improper SMG HV ammunition box (10x20mm)"
	desc = "A 10x20mm ammunition box. Used to refill M39 HV and extended magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	icon_state = "base_m39"
	overlay_content = "_hv"
	default_ammo = /datum/ammo/bullet/smg/m39

/obj/item/ammo_box/rounds/smg/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/ap
	name = "\improper SMG ammunition box (10x20mm AP)"
	desc = "A 10x20mm armor-piercing ammunition box. Used to refill M39 AP magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/smg/ap

/obj/item/ammo_box/rounds/smg/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/le
	name = "\improper SMG ammunition box (10x20mm LE)"
	desc = "A 10x20mm armor-shredding ammunition box. Used to refill M39 LE magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	overlay_content = "_le"
	default_ammo = /datum/ammo/bullet/smg/le

/obj/item/ammo_box/rounds/smg/le/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/incen
	name = "\improper SMG ammunition box (10x20mm Incen)"
	desc = "A 10x20mm incendiary ammunition box. Used to refill M39 incendiary magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	overlay_content = "_incen"
	default_ammo = /datum/ammo/bullet/smg/incendiary
	bullet_amount = 400 //Incen is OP
	max_bullet_amount = 400

/obj/item/ammo_box/rounds/smg/incen/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/heap
	name = "SMG ammunition box (10x20mm HEAP)"
	desc = "A 10x20mm armor-piercing high-explosive ammunition box. Used to refill M39 HEAP magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	overlay_content = "_heap"
	default_ammo = /datum/ammo/bullet/smg/heap

/obj/item/ammo_box/rounds/smg/heap/empty
	empty = TRUE

//----------------5.45x39mm Ammunition Boxes (for UPP Type71 family)------------------

/obj/item/ammo_box/rounds/type71
	name = "\improper rifle ammunition box (5.45x39mm)"
	desc = "A 5.45x39mm ammunition box. Used to refill Type71 magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_reg"
	caliber = "5.45x39mm"
	default_ammo = /datum/ammo/bullet/rifle/type71

/obj/item/ammo_box/rounds/type71/empty
	empty = TRUE

/obj/item/ammo_box/rounds/type71/ap
	name = "\improper rifle ammunition box (5.45x39mm AP)"
	desc = "A 5.45x39mm armor-piercing ammunition box. Used to refill Type71 AP magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_ap"
	default_ammo = /datum/ammo/bullet/rifle/type71/ap

/obj/item/ammo_box/rounds/type71/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/type71/heap
	name = "rifle ammunition box (5.45x39mm HEAP)"
	desc = "A 5.45x39mm high-explosive armor-piercing ammunition box. Used to refill Type71 HEAP magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_heap"
	default_ammo = /datum/ammo/bullet/rifle/type71/heap

/obj/item/ammo_box/rounds/type71/heap/empty
	empty = TRUE

//----------------9mm Pistol Ammunition Boxes (for mod88, M4A3 pistols)------------------

/obj/item/ammo_box/rounds/pistol
	name = "\improper pistol ammunition box (9mm)"
	desc = "A 9mm ammunition box. Used to refill M4A3 magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "9mm"
	icon_state = "base_m4a3"
	overlay_content = "_reg"
	default_ammo = /datum/ammo/bullet/pistol

/obj/item/ammo_box/rounds/pistol/empty
	empty = TRUE

/obj/item/ammo_box/rounds/pistol/ap
	name = "\improper pistol ammunition box (9mm AP)"
	desc = "A 9mm armor-piercing ammunition box. Used to refill mod88 and M4A3 magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/pistol/ap

/obj/item/ammo_box/rounds/pistol/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/pistol/hp
	name = "\improper pistol ammunition box (9mm HP)"
	desc = "A 9mm hollow-point ammunition box. Used to refill M4A3 magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_hp"
	default_ammo = /datum/ammo/bullet/pistol/hollow

/obj/item/ammo_box/rounds/pistol/hp/empty
	empty = TRUE

/obj/item/ammo_box/rounds/pistol/incen
	name = "\improper pistol ammunition box (9mm Incendiary)"
	desc = "A 9mm incendiary ammunition box. Used to refill M4A3 magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_incen"
	default_ammo = /datum/ammo/bullet/pistol/incendiary

/obj/item/ammo_box/rounds/pistol/incen/empty
	empty = TRUE

//----------------8.88x51mm round boxes for L23 battle rifles------------------

/obj/item/ammo_box/rounds/l23
	name = "\improper rifle ammunition box (8.88x51mm)"
	desc = "A 8.88x51mm ammunition box. Used to refill L23 regular and extended magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_l23"
	overlay_content = "_l23_reg"
	caliber = "8.88x51mm"
	default_ammo = /datum/ammo/bullet/rifle/l23

/obj/item/ammo_box/rounds/l23/empty
	empty = TRUE

/obj/item/ammo_box/rounds/l23/ap
	name = "\improper rifle ammunition box (8.88x51mm AP)"
	desc = "A 8.88x51mm ammunition box. Used to refill L23 AP magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_l23_ap"
	default_ammo = /datum/ammo/bullet/rifle/l23/ap

/obj/item/ammo_box/rounds/l23/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/l23/heap
	name = "\improper rifle ammunition box (8.88x51mm HEAP)"
	desc = "A 8.88x51mm ammunition box. Used to refill L23 HEAP magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_l23_heap"
	default_ammo = /datum/ammo/bullet/rifle/l23/heap

/obj/item/ammo_box/rounds/l23/heap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/l23/incendiary
	name = "\improper rifle ammunition box (8.88x51mm Incendiary)"
	desc = "A 8.88x51mm ammunition box. Used to refill L23 incendiary magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_l23_incen"
	default_ammo = /datum/ammo/bullet/rifle/l23/incendiary
	bullet_amount = 420 //Incen is OP
	max_bullet_amount = 420

/obj/item/ammo_box/rounds/l23/incendiary/empty
	empty = TRUE
