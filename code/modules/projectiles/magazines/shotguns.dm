//-------------------------------------------------------
//Generic shotgun magazines. Only three of them, since all shotguns can use the same ammo unless we add other gauges.

/*
Shotguns don't really use unique "ammo" like other guns. They just load from a pool of ammo and generate the projectile
on the go. There's also buffering involved. But, we do need the ammo to check handfuls type, and it's nice to have when
you're looking back on the different shotgun projectiles available. In short of it, it's not needed to have more than
one type of shotgun ammo, but I think it helps in referencing it. ~N
*/

GLOBAL_LIST_INIT(shotgun_boxes_12g, list(
	/obj/item/ammo_magazine/shotgun/buckshot,
	/obj/item/ammo_magazine/shotgun/flechette,
	/obj/item/ammo_magazine/shotgun/slugs
	))

/obj/item/ammo_magazine/shotgun
	name = "box of shotgun slugs"
	desc = "A box filled with heavy shotgun shells. A timeless classic. 12 Gauge."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/shotguns.dmi'
	icon_state = "slugs"
	item_state = "slugs"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/ammo_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/ammo_righthand.dmi'
		)
	default_ammo = /datum/ammo/bullet/shotgun/slug
	caliber = "12g"
	gun_type = /obj/item/weapon/gun/shotgun
	max_rounds = 25 // Real shotgun boxes are usually 5 or 25 rounds. This works with the new system, five handfuls.
	w_class = SIZE_LARGE // Can't throw it in your pocket, friend.
	flags_magazine = AMMUNITION_REFILLABLE|AMMUNITION_HANDFUL_BOX
	handful_state = "slug_shell"
	transfer_handful_amount = 5

/obj/item/ammo_magazine/shotgun/attack_self(mob/user)
	if(current_rounds == 0)
		new /obj/item/stack/sheet/cardboard(user.loc)
		qdel(src)
	else
		return ..()

/obj/item/ammo_magazine/shotgun/slugs//for distinction on weapons that can't take child objects but still take slugs.

/obj/item/ammo_magazine/shotgun/incendiary
	name = "box of incendiary slugs"
	desc = "A box filled with self-detonating incendiary shotgun rounds. 12 Gauge."
	icon_state = "incendiary"
	item_state = "incendiary"
	default_ammo = /datum/ammo/bullet/shotgun/incendiary
	handful_state = "incendiary_slug"

/obj/item/ammo_magazine/shotgun/incendiarybuck
	name = "box of incendiary buckshots"
	desc = "A box filled with self-detonating buckshot incendiary shotgun rounds. 12 Gauge."
	icon_state = "incendiarybuck"
	item_state = "incendiarybuck"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/incendiary
	handful_state = "incen_buckshot"

/obj/item/ammo_magazine/shotgun/buckshot
	name = "box of buckshot shells"
	desc = "A box filled with buckshot spread shotgun shells. 12 Gauge."
	icon_state = "buckshot"
	item_state = "buckshot"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	handful_state = "buckshot_shell"

/obj/item/ammo_magazine/shotgun/flechette
	name = "box of flechette shells"
	desc = "A box filled with flechette shotgun shells. 12 Gauge."
	icon_state = "flechette"
	item_state = "flechette"
	default_ammo = /datum/ammo/bullet/shotgun/flechette
	handful_state = "flechette_shell"

/obj/item/ammo_magazine/shotgun/beanbag
	name = "box of beanbag slugs"
	desc = "A box filled with beanbag shotgun shells used for non-lethal crowd control. 12 Gauge."
	icon_state = "beanbag"
	item_state = "beanbag"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag
	handful_state = "beanbag_slug"

/obj/item/ammo_magazine/shotgun/beanbag/riot
	name = "box of RC beanbag slugs"
	desc = "A box filled with beanbag shotgun shells used for non-lethal crowd control. Riot Control use only."
	icon_state = "beanbag"
	item_state = "beanbag"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag
	handful_state = "beanbag_slug"
	caliber = "20g"

/obj/item/ammo_magazine/shotgun/beanbag/es7
	name = "box of X21 shock slugs"
	desc = "A box filled with X21 shells used for non-lethal crowd control. Riot Control use only."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/WY/shotguns.dmi'
	icon_state = "electric"
	item_state = "incendiary"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag/es7
	handful_state = "elec_slug"
	caliber = "20g"

/obj/item/ammo_magazine/shotgun/beanbag/es7/slug
	name = "box of X21 lethal slugs"
	desc = "A box filled with X21 combat electrostatic lethal shotgun shells designed for ES-7 Supernova."
	icon_state = "slug"
	default_ammo = /datum/ammo/bullet/shotgun/slug/es7
	handful_state = "es7_slug"

/obj/item/ammo_magazine/shotgun/light/breaching
	name = "box of breaching shells"
	desc = "A box filled with breaching shotgun shells. 16 Gauge."
	icon_state = "breaching"
	item_state = "breaching"
	max_rounds = 30 //6 handfuls of 6 shells, 12 rounds in a XM51 mag
	transfer_handful_amount = 6
	default_ammo = /datum/ammo/bullet/shotgun/light/breaching
	handful_state = "breaching_shell"
	caliber = "16g"

// --- UPP Shotgun Box --- //

GLOBAL_LIST_INIT(shotgun_boxes_8g, list(
	/obj/item/ammo_magazine/shotgun/heavy/buckshot,
	/obj/item/ammo_magazine/shotgun/heavy/flechette,
	/obj/item/ammo_magazine/shotgun/heavy/slug
	))

/obj/item/ammo_magazine/shotgun/heavy
	name = "box of shotgun heavy slugs"
	desc = "A box filled with heavy shotgun shells. A timeless classic. 8 Gauge."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/shotguns.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/ammo_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/ammo_righthand.dmi'
		)
	default_ammo = /datum/ammo/bullet/shotgun/heavy/slug
	caliber = "8g"
	gun_type = /obj/item/weapon/gun/shotgun
	max_rounds = 20
	handful_state = "slug_shell"
	transfer_handful_amount = 4

/obj/item/ammo_magazine/shotgun/heavy/slug

/obj/item/ammo_magazine/shotgun/heavy/buckshot
	name = "box of heavy buckshot shells"
	desc = "A box filled with buckshot spread shotgun shells. 8 Gauge."
	icon_state = "buckshot"
	item_state = "buckshot"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot
	handful_state = "buckshot_shell"

/obj/item/ammo_magazine/shotgun/heavy/flechette
	name = "box of heavy flechette shells"
	desc = "A box filled with flechette shotgun shells. 8 Gauge."
	icon_state = "flechette"
	item_state = "flechette"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/flechette
	handful_state = "flechette_shell"

/obj/item/ammo_magazine/shotgun/heavy/incendiary
	name = "box of heavy incendiary slugs"
	desc = "A box filled with self-detonating incendiary shotgun rounds. 8 Gauge."
	icon_state = "incendiary"
	item_state = "incendiary"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath
	handful_state = "incendiary_slug"

/obj/item/ammo_magazine/shotgun/heavy/beanbag
	name = "box of heavy beanbag slugs"
	desc = "A box filled with beanbag shotgun shells used for non-lethal crowd control. 8 Gauge."
	icon_state = "beanbag"
	item_state = "beanbag"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/beanbag
	handful_state = "beanbag_slug"

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

/obj/item/ammo_magazine/internal/shotgun/double/cane
	default_ammo = /datum/ammo/bullet/revolver/marksman
	max_rounds = 6
	caliber = ".44"

/obj/item/ammo_magazine/internal/shotgun/double/mou53
	default_ammo = /datum/ammo/bullet/shotgun/flechette
	max_rounds = 3

/obj/item/ammo_magazine/internal/shotgun/double/twobore //Van Bandolier's superheavy double-barreled hunting rifle.
	caliber = "2 bore"
	default_ammo = /datum/ammo/bullet/shotgun/twobore

/obj/item/ammo_magazine/internal/shotgun/combat/riot
	caliber = "20g"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag

/obj/item/ammo_magazine/internal/shotgun/combat/es7
	caliber = "20g"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag/es7
	max_rounds = 7

/obj/item/ammo_magazine/internal/shotgun/merc
	max_rounds = 5

/obj/item/ammo_magazine/internal/shotgun/buckshot
	default_ammo = /datum/ammo/bullet/shotgun/buckshot

/obj/item/ammo_magazine/internal/shotgun/type23
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot
	caliber = "8g"
	max_rounds = 4

/obj/item/ammo_magazine/internal/shotgun/type23/slug
	default_ammo = /datum/ammo/bullet/shotgun/heavy/slug

/obj/item/ammo_magazine/internal/shotgun/type23/flechette
	default_ammo = /datum/ammo/bullet/shotgun/heavy/flechette

/obj/item/ammo_magazine/internal/shotgun/type23/dragonsbreath
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath

/obj/item/ammo_magazine/internal/shotgun/type23/beanbag
	default_ammo = /datum/ammo/bullet/shotgun/heavy/beanbag

/obj/item/ammo_magazine/internal/shotgun/cmb
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	max_rounds = 4

/obj/item/ammo_magazine/internal/shotgun/cmb/m3717
	max_rounds = 5

//-------------------------------------------------------

/*
Handfuls of shotgun rounds. For spawning directly on mobs in roundstart, ERTs, etc
*/

GLOBAL_LIST_INIT(shotgun_handfuls_8g, list(
	/obj/item/ammo_magazine/handful/shotgun/heavy/slug,
	/obj/item/ammo_magazine/handful/shotgun/heavy/buckshot,
	/obj/item/ammo_magazine/handful/shotgun/heavy/flechette,
	/obj/item/ammo_magazine/handful/shotgun/heavy/beanbag,
	/obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath
	))

GLOBAL_LIST_INIT(shotgun_handfuls_12g, list(
	/obj/item/ammo_magazine/handful/shotgun/slug,
	/obj/item/ammo_magazine/handful/shotgun/buckshot,
	/obj/item/ammo_magazine/handful/shotgun/flechette,
	/obj/item/ammo_magazine/handful/shotgun/incendiary,
	/obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary,
	/obj/item/ammo_magazine/handful/shotgun/beanbag
	))

/obj/item/ammo_magazine/handful/shotgun
	name = "handful of shotgun slugs (12g)"
	icon_state = "slug_shell_5"
	default_ammo = /datum/ammo/bullet/shotgun/slug
	caliber = "12g"
	max_rounds = 5
	current_rounds = 5
	gun_type = /obj/item/weapon/gun/shotgun
	handful_state = "slug_shell"
	transfer_handful_amount = 5

/obj/item/ammo_magazine/handful/shotgun/slug

/obj/item/ammo_magazine/handful/shotgun/incendiary
	name = "handful of incendiary slugs (12g)"
	icon_state = "incendiary_slug_5"
	default_ammo = /datum/ammo/bullet/shotgun/incendiary
	handful_state = "incendiary_slug"

/obj/item/ammo_magazine/handful/shotgun/slug/es7
	name = "handful of X21 solid slugs (20g)"
	icon_state = "es7_slug_5"
	default_ammo = /datum/ammo/bullet/shotgun/slug/es7
	handful_state = "es7_slug"
	caliber = "20g"

/obj/item/ammo_magazine/handful/shotgun/buckshot
	name = "handful of shotgun buckshot shells (12g)"
	icon_state = "buckshot_shell_5"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	handful_state = "buckshot_shell"

/obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary
	name = "handful of incendiary buckshot shells (12g)"
	icon_state = "incen_buckshot_5"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/incendiary
	handful_state = "incen_buckshot"

/obj/item/ammo_magazine/handful/shotgun/custom_color
	name = "abstract handful custom type"
	icon_state = "shell_greyscale_5"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	handful_state = "shell_greyscale" //unneeded

//updates on init
/obj/item/ammo_magazine/handful/shotgun/custom_color/update_icon()
	overlays.Cut()
	. = ..()
	icon_state = "shell_greyscale" + "_[current_rounds]"
	var/image/I = image(icon, src, "+shell_base_[src.current_rounds]")
	I.color = "#ffffff"
	I.appearance_flags = RESET_COLOR|KEEP_APART
	overlays += I

/obj/item/ammo_magazine/handful/shotgun/flechette
	name = "handful of shotgun flechette shells (12g)"
	icon_state = "flechette_shell_5"
	default_ammo = /datum/ammo/bullet/shotgun/flechette
	handful_state = "flechette_shell"

/obj/item/ammo_magazine/handful/shotgun/beanbag
	name = "handful of beanbag slugs (12g)"
	icon_state = "beanbag_slug_5"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag
	handful_state = "beanbag_slug"

/obj/item/ammo_magazine/handful/shotgun/beanbag/riot
	name = "handful of beanbag slugs (20g)"
	caliber = "20g"

/obj/item/ammo_magazine/handful/shotgun/beanbag/es7
	name = "handful of X21 electrostatic slugs (20g)"
	icon_state = "shock_slug_5"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag/es7
	handful_state = "shock_slug"
	caliber = "20g"

/obj/item/ammo_magazine/handful/shotgun/heavy
	name = "handful of heavy shotgun slugs (8g)"
	icon_state = "heavy_slug_4"
	handful_state = "heavy_slug"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/slug
	caliber = "8g"
	max_rounds = 4
	current_rounds = 4
	transfer_handful_amount = 4
	gun_type = /obj/item/weapon/gun/shotgun

/obj/item/ammo_magazine/handful/shotgun/heavy/slug

/obj/item/ammo_magazine/handful/shotgun/heavy/buckshot
	name = "handful of heavy buckshot shells (8g)"
	icon_state = "heavy_buckshot_4"
	handful_state = "heavy_buckshot"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot

/obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath
	name = "handful of dragon's breath shells (8g)"
	desc = "These shells fire magnesium (rather than the usual lead) pellets that ignite on contact with the air, setting anything it hits on fire. Its custom design also increases maximum range."
	icon_state = "heavy_dragonsbreath_4"
	handful_state = "heavy_dragonsbreath"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath

/obj/item/ammo_magazine/handful/shotgun/heavy/flechette
	name = "handful of heavy flechette shells (8g)"
	icon_state = "heavy_flechette_4"
	handful_state = "heavy_flechette"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/flechette

/obj/item/ammo_magazine/handful/shotgun/heavy/beanbag
	name = "handful of heavy beanbag shells (8g)"
	icon_state = "heavy_beanbag_4"
	handful_state = "heavy_beanbag"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/beanbag

/obj/item/ammo_magazine/handful/shotgun/light/breaching
	name = "handful of breaching shells (16g)"
	icon_state = "breaching_shell_6"
	handful_state = "breaching_shell"
	max_rounds = 6 //XM51 magazines are 12 rounds total, two handfuls should be enough to reload a mag
	current_rounds = 6
	transfer_handful_amount = 6
	default_ammo = /datum/ammo/bullet/shotgun/light/breaching
	caliber = "16g"
	gun_type = /obj/item/weapon/gun/rifle/xm51

/obj/item/ammo_magazine/handful/shotgun/light/breaching/rubber
	name = "handful of rubber buckshot shells (16g)"
	icon_state = "rubbershot_shell_6"
	handful_state = "rubbershot_shell"
	default_ammo = /datum/ammo/bullet/shotgun/light/rubber

/obj/item/ammo_magazine/handful/shotgun/twobore
	name = "handful of shotgun slugs (2 bore)"
	icon_state = "twobore_3"
	default_ammo = /datum/ammo/bullet/shotgun/twobore
	caliber = "2 bore"
	max_rounds = 3
	current_rounds = 3
	gun_type = /obj/item/weapon/gun/shotgun/double/twobore
	handful_state = "twobore"
	transfer_handful_amount = 3

// i fucking hate gun code

/obj/item/ammo_magazine/handful/revolver
	name = "handful of revolver bullets (.44)"
	default_ammo = /datum/ammo/bullet/revolver
	caliber = ".44"
	max_rounds = 8
	current_rounds = 8
	gun_type = /obj/item/weapon/gun/shotgun/double/cane

/obj/item/ammo_magazine/handful/revolver/marksman
	name = "handful of marksman revolver bullets (.44)"
	default_ammo = /datum/ammo/bullet/revolver/marksman
	gun_type = /obj/item/weapon/gun/shotgun/double/cane

/obj/item/ammo_magazine/handful/revolver/marksman/six_rounds
	name = "handful of marksman revolver bullets (.44)"
	default_ammo = /datum/ammo/bullet/revolver/marksman
	current_rounds = 6
	gun_type = /obj/item/weapon/gun/shotgun/double/cane
