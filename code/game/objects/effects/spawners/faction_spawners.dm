/*
 * USCM weapons
 */
/obj/effect/spawner/random/gun/uscm_primary
	name = "USCM primary weapon spawner"
	desc = "spawns USCM primary weapons"
	mags_max = 2
	mags_min = 1
	guns = list(
		/obj/item/weapon/gun/rifle/m41a = /obj/item/ammo_magazine/rifle,
		/obj/item/weapon/gun/rifle/m41a/tactical = /obj/item/ammo_magazine/rifle,
		/obj/item/weapon/gun/smg/m39 = /obj/item/ammo_magazine/smg/m39,
		/obj/item/weapon/gun/smg/m39 = /obj/item/ammo_magazine/smg/m39,
		/obj/item/weapon/gun/shotgun/pump = /datum/ammo/bullet/shotgun/buckshot
	)

/obj/effect/spawner/random/gun/uscm_primary/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_rifle_20"

/obj/effect/spawner/random/gun/uscm_primary/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_rifle_50"

/obj/effect/spawner/random/gun/uscm_primary/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_rifle_80"

/obj/effect/spawner/random/gun/uscm_secondary
	name = "USCM secondary weapon spawner"
	desc = "spawns USCM secondary weapons"
	spawn_nothing_percentage = 0
	mags_max = 2
	mags_min = 1
	guns = list(
		/obj/item/weapon/gun/pistol/m4a3 = /obj/item/ammo_magazine/pistol,
		/obj/item/weapon/gun/revolver/m44 = /obj/item/ammo_magazine/handful/revolver/marksman
	)

/obj/effect/spawner/random/gun/uscm_secondary/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_pistol_20"

/obj/effect/spawner/random/gun/uscm_secondary/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_pistol_50"

/obj/effect/spawner/random/gun/uscm_secondary/highchance
	spawn_nothing_percentage = 80
	icon_state = "loot_pistol_80"


/*
 * UPP weapons
 */
/obj/effect/spawner/random/gun/upp_primary
	name = "UPP primary weapon spawner"
	desc = "spawns UPP primary weapons"
	mags_max = 2
	mags_min = 1
	guns = list(
		/obj/item/weapon/gun/smg/bizon/upp = /obj/item/ammo_magazine/smg/bizon,
		/obj/item/weapon/gun/rifle/type71 = /obj/item/ammo_magazine/rifle/type71,
		/obj/item/weapon/gun/rifle/type71/carbine = /obj/item/ammo_magazine/rifle/type71
	)

/obj/effect/spawner/random/gun/upp_primary/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_rifle_20"

/obj/effect/spawner/random/gun/upp_primary/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_rifle_50"

/obj/effect/spawner/random/gun/upp_primary/highchance
	spawn_nothing_percentage = 80
	icon_state = "loot_rifle_80"

/obj/effect/spawner/random/gun/upp_secondary
	name = "UPP secondary weapon spawner"
	desc = "spawns UPP secondary weapons"
	mags_max = 2
	mags_min = 1
	guns = list(
		/obj/item/weapon/gun/pistol/t73 = /obj/item/ammo_magazine/pistol/t73,
		/obj/item/weapon/gun/pistol/np92 = /obj/item/ammo_magazine/pistol/np92,
		/obj/item/weapon/gun/revolver/upp = /obj/item/ammo_magazine/revolver/upp
	)

/obj/effect/spawner/random/gun/upp_secondary/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_pistol_20"

/obj/effect/spawner/random/gun/upp_secondary/medchance
	spawn_nothing_percentage = 50
	icon_state = "loot_pistol_50"

/obj/effect/spawner/random/gun/upp_secondary/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_pistol_80"
/*
 * PMC weapons
 */
/obj/effect/spawner/random/gun/pmc_primary
	name = "PMC primary weapon spawner"
	desc = "spawns PMC primary weapons"
	mags_max = 2
	mags_min = 1
	guns = list(
		/obj/item/weapon/gun/rifle/m41a/elite = /obj/item/ammo_magazine/rifle/ap,
		/obj/item/weapon/gun/rifle/m41a/elite = /obj/item/ammo_magazine/rifle/extended,
		/obj/item/weapon/gun/smg/m39/elite = /obj/item/ammo_magazine/smg/m39/ap,
		/obj/item/weapon/gun/smg/m39/elite = /obj/item/ammo_magazine/smg/m39/extended,
		/obj/item/weapon/gun/rifle/nsg23 = /obj/item/ammo_magazine/rifle/nsg23/ap,
		/obj/item/weapon/gun/rifle/nsg23 = /obj/item/ammo_magazine/rifle/nsg23/extended
	)

/obj/effect/spawner/random/gun/pmc_primary/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_rifle_20"

/obj/effect/spawner/random/gun/pmc_primary/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_rifle_50"

/obj/effect/spawner/random/gun/pmc_primary/highchance
	spawn_nothing_percentage = 80
	icon_state = "loot_rifle_80"

/obj/effect/spawner/random/gun/pmc_secondary
	name = "PMC secondary weapon spawner"
	desc = "spawns PMC secondary weapons"
	mags_max = 2
	mags_min = 1
	guns = list(
		/obj/item/weapon/gun/pistol/vp78 = /obj/item/ammo_magazine/pistol/vp78,
		/obj/item/weapon/gun/pistol/mod88 = /obj/item/ammo_magazine/pistol/mod88
	)

/obj/effect/spawner/random/gun/pmc_secondary/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_pistol_20"

/obj/effect/spawner/random/gun/pmc_secondary/medchance
	spawn_nothing_percentage = 50
	icon_state = "loot_pistol_50"

/obj/effect/spawner/random/gun/pmc_secondary/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_pistol_80"

/*
 * CLF weapons
 */
/obj/effect/spawner/random/gun/clf_primary
	name = "CLF primary weapon spawner"
	desc = "spawns CLF primary weapons"
	mags_max = 2
	mags_min = 1
	guns = list(
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40
	)

/obj/effect/spawner/random/gun/clf_primary/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_rifle_20"

/obj/effect/spawner/random/gun/clf_primary/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_rifle_50"

/obj/effect/spawner/random/gun/clf_primary/highchance
	spawn_nothing_percentage = 80
	icon_state = "loot_rifle_80"

/obj/effect/spawner/random/gun/clf_secondary
	name = "CLF secondary weapon spawner"
	desc = "spawns CLF secondary weapons"
	mags_max = 2
	mags_min = 1
	guns = list(
		/obj/item/weapon/gun/pistol/kt42 = /obj/item/ammo_magazine/pistol/kt42,
		/obj/item/weapon/gun/pistol/b92fs = /obj/item/ammo_magazine/pistol/b92fs
	)

/obj/effect/spawner/random/gun/clf_secondary/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_pistol_20"

/obj/effect/spawner/random/gun/clf_secondary/medchance
	spawn_nothing_percentage = 50
	icon_state = "loot_pistol_50"

/obj/effect/spawner/random/gun/clf_secondary/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_pistol_80"
