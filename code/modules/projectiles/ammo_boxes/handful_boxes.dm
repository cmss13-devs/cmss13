
//-----------------------SHOTGUN SHELL BOXES-----------------------

/obj/item/ammo_box/magazine/shotgun
	name = "\improper shotgun shell box (Slugs x 100)"
	icon_state = "base_slug"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = ""
	overlay_gun_type = "_shells"
	overlay_content = "_slug"
	magazine_type = /obj/item/ammo_magazine/shotgun/slugs
	num_of_magazines = 100
	handfuls = TRUE

/obj/item/ammo_box/magazine/shotgun/update_icon()
	if(overlays)
		overlays.Cut()
	overlays += image(icon, icon_state = "[icon_state]_lid") //adding lid
	overlays += image(text_markings_icon, icon_state = "text[overlay_gun_type]") //adding text

/obj/item/ammo_box/magazine/shotgun/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/buckshot
	name = "\improper shotgun shell box (Buckshot x 100)"
	icon_state = "base_buck"
	overlay_content = "_buck"
	magazine_type = /obj/item/ammo_magazine/shotgun/buckshot

/obj/item/ammo_box/magazine/shotgun/buckshot/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/flechette
	name = "\improper shotgun shell box (Flechette x 100)"
	icon_state = "base_flech"
	overlay_content = "_flech"
	magazine_type = /obj/item/ammo_magazine/shotgun/flechette

/obj/item/ammo_box/magazine/shotgun/flechette/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/incendiary
	name = "\improper shotgun shell box (Incendiary slug x 100)"
	icon_state = "base_inc"
	overlay_content = "_incen"
	magazine_type = /obj/item/ammo_magazine/shotgun/incendiary

/obj/item/ammo_box/magazine/shotgun/incendiary/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/incendiarybuck
	name = "\improper shotgun shell box (Incendiary buckshot x 100)"
	icon_state = "base_incbuck"
	overlay_content = "_incenbuck"
	magazine_type = /obj/item/ammo_magazine/shotgun/incendiarybuck

/obj/item/ammo_box/magazine/shotgun/incendiarybuck/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/beanbag
	name = "\improper shotgun shell box (Beanbag x 100)"
	icon_state = "base_bean"
	overlay_content = "_bean"
	magazine_type = /obj/item/ammo_magazine/shotgun/beanbag
	can_explode = FALSE


/obj/item/ammo_box/magazine/shotgun/beanbag/empty
	empty = TRUE


//-----------------------16 GAUGE SHOTGUN SHELL BOXES-----------------------

/obj/item/ammo_box/magazine/shotgun/light/breaching
	name = "\improper 16-gauge shotgun shell box (Breaching x 120)"
	icon_state = "base_breach"
	overlay_content = "_breach"
	magazine_type = /obj/item/ammo_magazine/shotgun/light/breaching
	num_of_magazines = 120 //10 full mag reloads.
	can_explode = FALSE

/obj/item/ammo_box/magazine/shotgun/light/breaching/empty
	empty = TRUE

//-----------------------R4T Lever-action rifle handfuls box-----------------------

/obj/item/ammo_box/magazine/lever_action
	name = "\improper 45-70 bullets box (45-70 x 300)"
	icon_state = "base_4570"
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_4570"
	overlay_content = "_4570"
	magazine_type = /obj/item/ammo_magazine/handful/lever_action
	num_of_magazines = 300
	handfuls = TRUE
	handful = "rounds"

/obj/item/ammo_box/magazine/lever_action/empty
	empty = TRUE

/obj/item/ammo_box/magazine/lever_action/training
	name = "\improper 45-70 blank box (45-70 x 300)"
	icon_state = "base_4570"
	overlay_ammo_type = "_45_training"
	overlay_gun_type = "_4570"
	overlay_content = "_training"
	magazine_type = /obj/item/ammo_magazine/handful/lever_action/training

/obj/item/ammo_box/magazine/lever_action/training/empty
	empty = TRUE

//unused
/obj/item/ammo_box/magazine/lever_action/tracker
	name = "\improper 45-70 tracker bullets box (45-70 x 300)"
	icon_state = "base_4570"
	overlay_ammo_type = "_45_tracker"
	overlay_gun_type = "_4570"
	overlay_content = "_tracker"
	magazine_type = /obj/item/ammo_magazine/handful/lever_action/tracker

/obj/item/ammo_box/magazine/lever_action/tracker/empty
	empty = TRUE

//unused
/obj/item/ammo_box/magazine/lever_action/marksman
	name = "\improper 45-70 marksman bullets box (45-70 x 300)"
	icon_state = "base_4570"
	overlay_ammo_type = "_45_marksman"
	overlay_gun_type = "_4570"
	overlay_content = "_marksman"
	magazine_type = /obj/item/ammo_magazine/handful/lever_action/marksman

/obj/item/ammo_box/magazine/lever_action/marksman/empty
	empty = TRUE
