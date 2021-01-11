// STANDARD Sentry
/obj/item/ammo_magazine/sentry
	name = "M30 ammo drum (10x28mm Caseless)"
	desc = "An ammo drum of 500 10x28mm caseless rounds for the UA 571-C Sentry Gun. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	w_class = SIZE_MEDIUM
	icon_state = "ua571c"
	flags_magazine = NO_FLAGS //can't be refilled or emptied by hand
	caliber = "10x28mm"
	max_rounds = 500
	default_ammo = /datum/ammo/bullet/turret
	gun_type = null

/obj/item/ammo_magazine/sentry/premade
	max_rounds = 1000000

/obj/item/ammo_magazine/sentry/premade/dumb
	default_ammo = /datum/ammo/bullet/turret/dumb


// FLAMER Sentry
/obj/item/ammo_magazine/sentry_flamer
	name = "sentry incinerator tank"
	desc = "A fuel tank of usually Ultra Thick Napthal Fuel, a sticky combustable liquid chemical, used in the UA 42-F."
	w_class = SIZE_MEDIUM
	icon_state = "ua571c"
	flags_magazine = NO_FLAGS
	caliber = "Napalm B"
	max_rounds = 100
	default_ammo = /datum/ammo/flamethrower/sentry_flamer
	gun_type = null