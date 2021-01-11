//-------------------------------------------------------
//Generic shotgun magazines. Only three of them, since all shotguns can use the same ammo unless we add other gauges.

/*
Shotguns don't really use unique "ammo" like other guns. They just load from a pool of ammo and generate the projectile
on the go. There's also buffering involved. But, we do need the ammo to check handfuls type, and it's nice to have when
you're looking back on the different shotgun projectiles available. In short of it, it's not needed to have more than
one type of shotgun ammo, but I think it helps in referencing it. ~N
*/
/obj/item/ammo_magazine/shotgun
	name = "box of shotgun slugs"
	desc = "A box filled with heavy shotgun shells. A timeless classic. 12 Gauge."
	icon_state = "slugs"
	item_state = "slugs"
	default_ammo = /datum/ammo/bullet/shotgun/slug
	caliber = "12g" //All shotgun rounds are 12g right now.
	gun_type = /obj/item/weapon/gun/shotgun
	max_rounds = 25 // Real shotgun boxes are usually 5 or 25 rounds. This works with the new system, five handfuls.
	w_class = SIZE_LARGE // Can't throw it in your pocket, friend.

/obj/item/ammo_magazine/shotgun/slugs//for distinction on weapons that can't take child objects but still take slugs.

/obj/item/ammo_magazine/shotgun/incendiary
	name = "box of incendiary slugs"
	desc = "A box filled with self-detonating incendiary shotgun rounds. 12 Gauge."
	icon_state = "incendiary"
	item_state = "incendiary"
	default_ammo = /datum/ammo/bullet/shotgun/incendiary

/obj/item/ammo_magazine/shotgun/buckshot
	name = "box of buckshot shells"
	desc = "A box filled with buckshot spread shotgun shells. 12 Gauge."
	icon_state = "buckshot"
	item_state = "buckshot"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot

/obj/item/ammo_magazine/shotgun/flechette
	name = "box of flechette shells"
	desc = "A box filled with flechette shotgun shells. 12 Gauge."
	icon_state = "flechette"
	item_state = "flechette"
	default_ammo = /datum/ammo/bullet/shotgun/flechette

/obj/item/ammo_magazine/shotgun/beanbag
	name = "box of beanbag slugs"
	desc = "A box filled with beanbag shotgun shells used for non-lethal crowd control. 12 Gauge."
	icon_state = "beanbag"
	item_state = "beanbag"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag

//-------------------------------------------------------

/*
Generic internal magazine. All shotguns will use this or a variation with different ammo number.
Since all shotguns share ammo types, the gun path is going to be the same for all of them. And it
also doesn't really matter. You can only reload them with handfuls.
*/
/obj/item/ammo_magazine/internal/shotgun
	name = "shotgun tube"
	desc = "An internal magazine. It is not supposed to be seen or removed."
	default_ammo = /datum/ammo/bullet/shotgun/slug
	caliber = "12g"
	max_rounds = 9
	chamber_closed = 0

/obj/item/ammo_magazine/internal/shotgun/double //For a double barrel.
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	max_rounds = 2
	chamber_closed = 1 //Starts out with a closed tube.

/obj/item/ammo_magazine/internal/shotgun/double/mou53
	default_ammo = /datum/ammo/bullet/shotgun/flechette
	max_rounds = 3

/obj/item/ammo_magazine/internal/shotgun/combat/riot
	default_ammo = /datum/ammo/bullet/shotgun/beanbag

/obj/item/ammo_magazine/internal/shotgun/merc
	max_rounds = 5

/obj/item/ammo_magazine/internal/shotgun/buckshot
	default_ammo = /datum/ammo/bullet/shotgun/buckshot

//-------------------------------------------------------

/*
Handfuls of shotgun rounds. For spawning directly on mobs in roundstart, ERTs, etc
*/

/obj/item/ammo_magazine/handful/shotgun
	name = "handful of shotgun slugs (12g)"
	icon_state = "shotgun slug"
	default_ammo = /datum/ammo/bullet/shotgun/slug
	caliber = "12g"
	max_rounds = 5
	current_rounds = 5
	dir = 6
	gun_type = /obj/item/weapon/gun/shotgun

/obj/item/ammo_magazine/handful/shotgun/slug

/obj/item/ammo_magazine/handful/shotgun/incendiary
	name = "handful of incendiary slugs (12g)"
	icon_state = "incendiary slug"
	default_ammo = /datum/ammo/bullet/shotgun/incendiary

/obj/item/ammo_magazine/handful/shotgun/buckshot
	name = "handful of shotgun buckshot shells (12g)"
	icon_state = "shotgun buckshot shell"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot

/obj/item/ammo_magazine/handful/shotgun/flechette
	name = "handful of shotgun flechette shells (12g)"
	icon_state = "shotgun flechette shell"
	default_ammo = /datum/ammo/bullet/shotgun/flechette

/obj/item/ammo_magazine/handful/shotgun/beanbag
	name = "handful of beanbag slugs (12g)"
	icon_state = "beanbag slug"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag