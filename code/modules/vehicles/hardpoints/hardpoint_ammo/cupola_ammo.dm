/obj/item/ammo_magazine/hardpoint/m56_cupola
	name = "M56 Cupola Magazine"
	desc = "A secondary armament MG magazine"
	caliber = "10x28mm" //Correlates to smartguns
	icon = 'icons/obj/items/ammo_box.dmi'
	icon_state = "big_ammo_box"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/smartgun/marine
	max_rounds = 500
	gun_type = /obj/item/hardpoint/gun/m56cupola
	point_cost = 100

/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon
	name = "RE-RE700 Frontal Cannon magazine"
	desc = "A big box of bullets that looks suspiciously similar to the box you would use to refill a M56 Cupola. The Bleihagel logo sticker has peeled slightly and it looks like there's another logo underneath..."
	gun_type = /obj/item/hardpoint/gun/frontalcannon
