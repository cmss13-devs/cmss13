// STANDARD Sentry
/obj/item/ammo_magazine/sentry
	name = "M30 ammo drum (10x28mm Caseless)"
	desc = "An ammo drum of 500 10x28mm caseless rounds for the UA 571-C Sentry Gun. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/turrets.dmi'
	icon_state = "ua571c"
	w_class = SIZE_MEDIUM
	flags_magazine = NO_FLAGS //can't be refilled or emptied by hand
	caliber = "10x28mm"
	max_rounds = 500
	default_ammo = /datum/ammo/bullet/turret
	gun_type = null

/obj/item/ammo_magazine/sentry/dropped
	max_rounds = 100
	max_inherent_rounds = 500

/obj/item/ammo_magazine/sentry/premade
	max_rounds = 99999
	current_rounds = 99999

/obj/item/ammo_magazine/sentry/premade/lowammo
	max_rounds = 500
	current_rounds = 500

/obj/item/ammo_magazine/sentry/premade/dumb
	default_ammo = /datum/ammo/bullet/turret/dumb

/obj/item/ammo_magazine/sentry/premade/lowammo/dumb
	default_ammo = /datum/ammo/bullet/turret/dumb

/obj/item/ammo_magazine/sentry/shotgun
	name = "12g buckshot drum"
	desc = "An ammo drum of 50 12g buckshot drums for the UA 12-G Shotgun Sentry. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	caliber = "12g"
	max_rounds = 50
	default_ammo = /datum/ammo/bullet/shotgun/buckshot

/obj/item/ammo_magazine/sentry/wy
	name = "H20 ammo drum (10x42mm Caseless)"
	desc = "An ammo drum of 200 10x42mm caseless rounds for the WY 202-GMA1 Smart Sentry. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/WY/turrets.dmi'
	icon_state = "wy22e5"
	caliber = "10x42mm"
	max_rounds = 200

/obj/item/ammo_magazine/sentry/wy/mini
	name = "H16 ammo drum (10x12mm Caseless)"
	desc = "An ammo drum of 1000 10x12mm caseless rounds for the WY 14-GRA2 Mini Sentry. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/WY/turrets.dmi'
	icon_state = "wy22e5"
	caliber = "10x12mm"
	max_rounds = 1000

/obj/item/ammo_magazine/sentry/upp
	name = "SR32 ammo drum (10x32mm Caseless)"
	desc = "An ammo drum of 200 10x32mm caseless rounds for the UPP SDS-R3 Sentry Gun. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/turrets.dmi'
	icon_state = "uppsds4"
	caliber = "10x42mm"
	max_rounds = 200

// FLAMER Sentry
/obj/item/ammo_magazine/sentry_flamer
	name = "sentry incinerator tank"
	desc = "A fuel tank of usually Ultra Thick Napthal Fuel, a sticky combustible liquid chemical, used in the UA 42-F."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/turrets.dmi'
	icon_state = "ua571c"
	w_class = SIZE_MEDIUM
	flags_magazine = NO_FLAGS
	caliber = "Napalm B"
	max_rounds = 100
	default_ammo = /datum/ammo/flamethrower/sentry_flamer
	gun_type = null

/obj/item/ammo_magazine/sentry_flamer/glob
	name = "plasma sentry incinerator tank"
	desc = "A fuel tank of compressed Ultra Thick Napthal Fuel, used in the UA 60-FP."
	default_ammo = /datum/ammo/flamethrower/sentry_flamer/glob

/obj/item/ammo_magazine/sentry_flamer/mini
	name = "mini sentry incinerator tank"
	desc = "A fuel tank of Ultra Thick Napthal Fuel, used in the UA 45-FM."
	default_ammo = /datum/ammo/flamethrower/sentry_flamer/mini

/obj/item/ammo_magazine/sentry_flamer/wy
	name = "wy sentry incinerator tank"
	desc = "A fuel tank of Ultra Thick Sticky Napthal Fuel, used in the WY 406-FE2."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/WY/turrets.dmi'
	icon_state = "wy22e5"
	caliber = "Sticky Napalm"
	max_rounds = 200
	default_ammo = /datum/ammo/flamethrower/sentry_flamer/wy

/obj/item/ammo_magazine/sentry_flamer/upp
	name = "upp sentry incinerator tank"
	desc = "A fuel tank of Ultra Thick Gel Napthal Fuel, used in the UPP SDS-R5 Sentry Flamer."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/turrets.dmi'
	icon_state = "uppsds4"
	caliber = "Sticky Napalm"
	max_rounds = 200
	default_ammo = /datum/ammo/flamethrower/sentry_flamer/upp
