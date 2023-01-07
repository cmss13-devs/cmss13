//-----------------------AMMUNITION BOXES (LOOSE AMMO)-----------------------

//----------------10x24mm Ammunition Boxes (for M41 family and L42)------------------

/obj/item/ammo_box/rounds/ap
	name = "\improper rifle ammunition box (10x24mm AP)"
	desc = "A 10x24mm armor-piercing ammunition box. Used to refill M41A MK2 and L42A AP magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_box/rounds/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/le
	name = "\improper rifle ammunition box (10x24mm LE)"
	desc = "A 10x24mm armor-shredding ammunition box. Used to refill M41A MK2 and L42A LE magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_le"
	default_ammo = /datum/ammo/bullet/rifle/le

/obj/item/ammo_box/rounds/le/empty
	empty = TRUE

/obj/item/ammo_box/rounds/incen
	name = "\improper rifle ammunition box (10x24mm Incen)"
	desc = "A 10x24mm incendiary ammunition box. Used to refill M41A MK2 and L42A incendiary magazines. It comes with a leather strap allowing to wear it on the back."
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
	default_ammo = /datum/ammo/bullet/rifle

/obj/item/ammo_box/rounds/type71/empty
	empty = TRUE

/obj/item/ammo_box/rounds/type71/ap
	name = "\improper rifle ammunition box (5.45x39mm AP)"
	desc = "A 5.45x39mm armor-piercing ammunition box. Used to refill Type71 AP magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

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
