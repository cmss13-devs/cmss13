#define AMMO_PACKER_CATEGORY_RIFLE "Rifle"
#define AMMO_PACKER_CATEGORY_SUBMACHINEGUN "SMG"
#define AMMO_PACKER_CATEGORY_SHOTGUN "Shotgun"
#define AMMO_PACKER_CATEGORY_SIDEARM "Sidearm"
#define AMMO_PACKER_CATEGORY_HEAVY_WEAPON "Heavy Weapons"
#define AMMO_PACKER_CATEGORY_OTHER "Other"

/datum/ammo_packer/recipe
	var/name = "object"
	var/path
	var/list/factions = list()
	/// var for when the ammo packer gets hacked and can print all recipes, recipes that aren't in the faction of the packer get marked as hidden for the UI
	var/hidden = TRUE
	var/category

// and the suffering begins...

//-------------------------
// USCM / overlaps with WY
//-------------------------
/datum/ammo_packer/recipe/uscm
	factions = list(FACTION_MARINE, FACTION_WY)

// RIFLE //
/datum/ammo_packer/recipe/uscm/rifle
	category = AMMO_PACKER_CATEGORY_RIFLE

// M41A MK2
/datum/ammo_packer/recipe/uscm/rifle/m41a
	name = "magazine box (M41A x 10)"
	path = /obj/item/ammo_box/magazine/empty

/datum/ammo_packer/recipe/uscm/rifle/m41a/ext
	name = "magazine box (M41A Ext x 8)"
	path = /obj/item/ammo_box/magazine/ext/empty

/datum/ammo_packer/recipe/uscm/rifle/m41a/ap
	name = "magazine box (M41A AP x 10)"
	path = /obj/item/ammo_box/magazine/ap/empty

/datum/ammo_packer/recipe/uscm/rifle/m41a/heap
	name = "magazine box (M41A HEAP x 10)"
	path = /obj/item/ammo_box/magazine/heap/empty

/datum/ammo_packer/recipe/uscm/rifle/m41a/explosive
	name = "magazine box (M41A Explosive x 10)"
	path = /obj/item/ammo_box/magazine/explosive/empty

/datum/ammo_packer/recipe/uscm/rifle/m41a/le
	name = "magazine box (M41A LE x 10)"
	path = /obj/item/ammo_box/magazine/le/empty

/datum/ammo_packer/recipe/uscm/rifle/m41a/incen
	name = "magazine box (M41A Incen x 10)"
	path = /obj/item/ammo_box/magazine/incen/empty

// M4RA
/datum/ammo_packer/recipe/uscm/rifle/m4ra
	name = "magazine box (M4RA x 16)"
	path = /obj/item/ammo_box/magazine/m4ra/empty
	factions = list(FACTION_MARINE)

/datum/ammo_packer/recipe/uscm/rifle/m4ra/ext
	name = "magazine box (M4RA Ext x 12)"
	path = /obj/item/ammo_box/magazine/m4ra/ext/empty

/datum/ammo_packer/recipe/uscm/rifle/m4ra/ap
	name = "magazine box (M4RA AP x 16)"
	path = /obj/item/ammo_box/magazine/m4ra/ap/empty

/datum/ammo_packer/recipe/uscm/rifle/m4ra/heap
	name = "magazine box (M4RA HEAP x 16)"
	path = /obj/item/ammo_box/magazine/m4ra/heap/empty

/datum/ammo_packer/recipe/uscm/rifle/m4ra/incen
	name = "magazine box (M4RA Incen x 16)"
	path = /obj/item/ammo_box/magazine/m4ra/incen/empty

// M41A MK1
/datum/ammo_packer/recipe/uscm/rifle/mk1
	name = "magazine box (M41A MK1 x 8)"
	path = /obj/item/ammo_box/magazine/mk1/empty
	factions = list(FACTION_MARINE)

/datum/ammo_packer/recipe/uscm/rifle/mk1/ap
	name = "magazine box (M41A MK1 AP x 8)"
	path = /obj/item/ammo_box/magazine/mk1/ap/empty

// Loose 10x24mm
/datum/ammo_packer/recipe/uscm/rifle/rounds
	name = "rifle ammunition box (10x24mm)"
	path = /obj/item/ammo_box/rounds/empty

/datum/ammo_packer/recipe/uscm/rifle/rounds/ap
	name = "rifle ammunition box (10x24mm AP)"
	path = /obj/item/ammo_box/rounds/ap/empty

/datum/ammo_packer/recipe/uscm/rifle/rounds/heap
	name = "rifle ammunition box (10x24mm HEAP)"
	path = /obj/item/ammo_box/rounds/heap/empty

/datum/ammo_packer/recipe/uscm/rifle/rounds/le
	name = "rifle ammunition box (10x24mm LE)"
	path = /obj/item/ammo_box/rounds/le/empty

/datum/ammo_packer/recipe/uscm/rifle/rounds/incen
	name = "rifle ammunition box (10x24mm Incen)"
	path = /obj/item/ammo_box/rounds/incen/empty

// L42A
/datum/ammo_packer/recipe/uscm/rifle/l42a
	name = "magazine box (L42A x 16)"
	path = /obj/item/ammo_box/magazine/l42a/empty
	factions = list(FACTION_MARINE, FACTION_COLONIST)

/datum/ammo_packer/recipe/uscm/rifle/l42a/ext
	name = "magazine box (L42A Ext x 12)"
	path = /obj/item/ammo_box/magazine/l42a/ext/empty

/datum/ammo_packer/recipe/uscm/rifle/l42a/ap
	name = "magazine box (L42A AP x 16)"
	path = /obj/item/ammo_box/magazine/l42a/ap/empty

/datum/ammo_packer/recipe/uscm/rifle/l42a/heap
	name = "magazine box (L42A HEAP x 16)"
	path = /obj/item/ammo_box/magazine/l42a/heap/empty

/datum/ammo_packer/recipe/uscm/rifle/l42a/le
	name = "magazine box (L42A LE x 16)"
	path = /obj/item/ammo_box/magazine/l42a/le/empty

/datum/ammo_packer/recipe/uscm/rifle/l42a/incen
	name = "magazine box (L42A Incen x 16)"
	path = /obj/item/ammo_box/magazine/l42a/incen/empty

// SUBMACHINEGUN //
/datum/ammo_packer/recipe/uscm/smg
	category = AMMO_PACKER_CATEGORY_SUBMACHINEGUN

// M39
/datum/ammo_packer/recipe/uscm/smg/m39
	name = "magazine box (M39 x 12)"
	path = /obj/item/ammo_box/magazine/m39/empty

/datum/ammo_packer/recipe/uscm/smg/m39/ext
	name = "magazine box (M39 Ext x 10)"
	path = /obj/item/ammo_box/magazine/m39/ext/empty

/datum/ammo_packer/recipe/uscm/smg/m39/ap
	name = "magazine box (M39 AP x 12)"
	path = /obj/item/ammo_box/magazine/m39/ap/empty

/datum/ammo_packer/recipe/uscm/smg/m39/heap
	name = "magazine box (M39 HEAP x 12)"
	path = /obj/item/ammo_box/magazine/m39/heap/empty

/datum/ammo_packer/recipe/uscm/smg/m39/le
	name = "magazine box (M39 LE x 12)"
	path = /obj/item/ammo_box/magazine/m39/le/empty

/datum/ammo_packer/recipe/uscm/smg/m39/incen
	name = "magazine box (M39 Incen x 12)"
	path = /obj/item/ammo_box/magazine/m39/incen/empty

// Loose 10x20mm
/datum/ammo_packer/recipe/uscm/smg/rounds
	name = "SMG HV ammunition box (10x20mm)"
	path = /obj/item/ammo_box/rounds/smg/empty

/datum/ammo_packer/recipe/uscm/smg/rounds/ap
	name = "SMG HV ammunition box (10x20mm AP)"
	path = /obj/item/ammo_box/rounds/smg/ap/empty

/datum/ammo_packer/recipe/uscm/smg/rounds/heap
	name = "SMG HV ammunition box (10x20mm HEAP)"
	path = /obj/item/ammo_box/rounds/smg/heap/empty

/datum/ammo_packer/recipe/uscm/smg/rounds/le
	name = "SMG HV ammunition box (10x20mm LE)"
	path = /obj/item/ammo_box/rounds/smg/le/empty

/datum/ammo_packer/recipe/uscm/smg/rounds/incen
	name = "SMG HV ammunition box (10x20mm Incen)"
	path = /obj/item/ammo_box/rounds/smg/incen/empty

// SHOTGUN //
/datum/ammo_packer/recipe/uscm/shotgun
	category = AMMO_PACKER_CATEGORY_SHOTGUN
	factions = list(FACTION_MARINE, FACTION_WY, FACTION_CONTRACTOR, FACTION_MERCENARY, FACTION_FREELANCER, FACTION_COLONIST, FACTION_CLF)

// Standard :p

/datum/ammo_packer/recipe/uscm/shotgun/slug
	name = "shotgun shell box (Slug x 100)"
	path = /obj/item/ammo_box/magazine/shotgun/empty

/datum/ammo_packer/recipe/uscm/shotgun/buckshot
	name = "shotgun shell box (Buckshot x 100)"
	path = /obj/item/ammo_box/magazine/shotgun/buckshot/empty

/datum/ammo_packer/recipe/uscm/shotgun/flechette
	name = "shotgun shell box (Flechette x 100)"
	path = /obj/item/ammo_box/magazine/shotgun/flechette/empty

/datum/ammo_packer/recipe/uscm/shotgun/beanbag
	name = "shotgun shell box (Beanbag x 100)"
	path = /obj/item/ammo_box/magazine/shotgun/beanbag/empty

/datum/ammo_packer/recipe/uscm/shotgun/incendiary
	name = "shotgun shell box (Incendiary Slug x 100)"
	path =/obj/item/ammo_box/magazine/shotgun/incendiary/empty

/datum/ammo_packer/recipe/uscm/shotgun/incendiarybuck
	name = "shotgun shell box (Incendiary Buckshot x 100)"
	path = /obj/item/ammo_box/magazine/shotgun/incendiarybuck/empty

// XM51, you will be missed
/datum/ammo_packer/recipe/uscm/shotgun/xm51
	name = "magazine box (XM51 x 8)"
	path = /obj/item/ammo_box/magazine/xm51/empty
	factions = list(FACTION_MARINE)

/datum/ammo_packer/recipe/uscm/shotgun/xm51/shells
	name = "16-gauge shotgun shell box (Breaching x 120)"
	path = /obj/item/ammo_box/magazine/shotgun/light/breaching/empty

// Sidearm //
/datum/ammo_packer/recipe/uscm/sidearm
	category = AMMO_PACKER_CATEGORY_SIDEARM

// M4A3 Service Pistol
/datum/ammo_packer/recipe/uscm/sidearm/m4a3
	name = "magazine box (M4A3 x 16)"
	path = /obj/item/ammo_box/magazine/m4a3/empty
	factions = list(FACTION_MARINE)

/datum/ammo_packer/recipe/uscm/sidearm/m4a3/ap
	name = "magazine box (M4A3 AP x 16)"
	path = /obj/item/ammo_box/magazine/m4a3/ap/empty

/datum/ammo_packer/recipe/uscm/sidearm/m4a3/hp
	name = "magazine box (M4A3 HP x 16)"
	path = /obj/item/ammo_box/magazine/m4a3/hp/empty

/datum/ammo_packer/recipe/uscm/sidearm/m4a3/incen
	name = "magazine box (M4A3 Incen x 16)"
	path = /obj/item/ammo_box/magazine/m4a3/incen/empty

// M10 Autopistol
/datum/ammo_packer/recipe/uscm/sidearm/m10
	name = "magazine box (M10 x 22)"
	path = /obj/item/ammo_box/magazine/m10/empty
	factions = list(FACTION_MARINE)

/datum/ammo_packer/recipe/uscm/sidearm/m10/ext
	name = "magazine box (M10 Ext x 14)"
	path = /obj/item/ammo_box/magazine/m10/ext/empty

/datum/ammo_packer/recipe/uscm/sidearm/m10/drum
	name = "magazine box (Drum M10 x 12)"
	path = /obj/item/ammo_box/magazine/m10/drum/empty

// M44 Revolver
/datum/ammo_packer/recipe/uscm/sidearm/m44
	name = "speed loaders box (M44 x 16)"
	path = /obj/item/ammo_box/magazine/m44/empty
	factions = list(FACTION_MARINE)

/datum/ammo_packer/recipe/uscm/sidearm/m44/marksman
	name = "speed loaders box (M44 Marksman  x 16)"
	path = /obj/item/ammo_box/magazine/m44/marksman/empty

/datum/ammo_packer/recipe/uscm/sidearm/m44/heavy
	name = "speed loaders box (M44 Heavy x 16)"
	path = /obj/item/ammo_box/magazine/m44/heavy/empty

// SU-6 Smartpistol
/datum/ammo_packer/recipe/uscm/sidearm/su6
	name = "magazine box (SU-6 x 16)"
	path = /obj/item/ammo_box/magazine/su6/empty

// 88 M4
/datum/ammo_packer/recipe/uscm/sidearm/mod88
	name = "magazine box (88 Mod 4 AP x 16)"
	path = /obj/item/ammo_box/magazine/mod88/empty

// VP78
/datum/ammo_packer/recipe/uscm/sidearm/vp78
	name = "magazine box (VP78 x 16)"
	path = /obj/item/ammo_box/magazine/vp78/empty

// Loose Pistol 9mm
/datum/ammo_packer/recipe/uscm/sidearm/rounds
	name = "pistol ammunition box (9mm)"
	path = /obj/item/ammo_box/rounds/pistol/empty
	factions = list(FACTION_MARINE, FACTION_NSPA)

/datum/ammo_packer/recipe/uscm/sidearm/rounds/ap
	name = "pistol ammunition box (9mm AP)"
	path = /obj/item/ammo_box/rounds/pistol/ap/empty
	factions = list(FACTION_MARINE, FACTION_NSPA, FACTION_WY)

/datum/ammo_packer/recipe/uscm/sidearm/rounds/hp
	name = "pistol ammunition box (9mm HP)"
	path = /obj/item/ammo_box/rounds/pistol/hp/empty

/datum/ammo_packer/recipe/uscm/sidearm/rounds/incen
	name = "pistol ammunition box (9mm Incen)"
	path = /obj/item/ammo_box/rounds/pistol/incen/empty

// Heavy Weapons //
/datum/ammo_packer/recipe/uscm/heavy_weapon
	category = AMMO_PACKER_CATEGORY_HEAVY_WEAPON

// M56A2 Smartgun
/datum/ammo_packer/recipe/uscm/heavy_weapon/m56a2
	name = "drum box (M56A2 x 8)"
	path = /obj/item/ammo_box/magazine/m56a2/empty

/datum/ammo_packer/recipe/uscm/heavy_weapon/m56a2/dirty
	name = "drum box (M56A2 'Dirty' x 8)"
	path = /obj/item/ammo_box/magazine/m56a2/dirty/empty

// M56D
/datum/ammo_packer/recipe/uscm/heavy_weapon/m56d
	name = "drum box (M56D x 8)"
	path = /obj/item/ammo_box/magazine/m56d/empty
	factions = list(FACTION_MARINE)

// M2C
/datum/ammo_packer/recipe/uscm/heavy_weapon/m2c
	name = "ammo box (M2C x 8)"
	path = /obj/item/ammo_box/magazine/m2c/empty
	factions = list(FACTION_MARINE)

// M41AE2
/datum/ammo_packer/recipe/uscm/heavy_weapon/m41ae2
	name = "magazine box (M41AE2 x 8)"
	path = /obj/item/ammo_box/magazine/m41ae2/empty
	factions = list(FACTION_MARINE)

/datum/ammo_packer/recipe/uscm/heavy_weapon/m41ae2
	name = "magazine box (M41AE2 x 8)"
	path = /obj/item/ammo_box/magazine/m41ae2/empty

/datum/ammo_packer/recipe/uscm/heavy_weapon/m41ae2/holo
	name = "magazine box (M41AE2 Holo-Target x 8)"
	path = /obj/item/ammo_box/magazine/m41ae2/holo/empty

/datum/ammo_packer/recipe/uscm/heavy_weapon/m41ae2/heap
	name = "magazine box (M41AE2 HEAP x 8)" //what the actual fuck, when would you ever use this
	path = /obj/item/ammo_box/magazine/m41ae2/heap/empty

// XM88
/datum/ammo_packer/recipe/uscm/heavy_weapon/xm88
	name = ".458 bullets box (.458 x 300)"
	path = /obj/item/ammo_box/magazine/lever_action/xm88/empty

// M240 Incinerator
/datum/ammo_packer/recipe/uscm/heavy_weapon/m240
	name = "flamer tank box (UT-Napthal Fuel x 8)"
	path = /obj/item/ammo_box/magazine/flamer/empty

/datum/ammo_packer/recipe/uscm/heavy_weapon/m240/bgel
	name = "flamer fuel box (Napalm B-Gel x 8)"
	path = /obj/item/ammo_box/magazine/flamer/bgel/empty

// Other //
/datum/ammo_packer/recipe/uscm/other
	category = AMMO_PACKER_CATEGORY_OTHER

// MRE
/datum/ammo_packer/recipe/uscm/other/mre
	name = "box of MREs"
	path = /obj/item/ammo_box/magazine/misc/mre/empty

// M94 Marking Flares
/datum/ammo_packer/recipe/uscm/other/flares
	name = "box of M94 marking flare packs"
	path = /obj/item/ammo_box/magazine/misc/flares/empty

// M89 Signal Flares
/datum/ammo_packer/recipe/uscm/other/flares/signal
	name = "box of M89 signal flare packs"
	path = /obj/item/ammo_box/magazine/misc/flares/signal/empty

//----------------
// Weyland Yutani
//----------------
/datum/ammo_packer/recipe/wy
	factions = list(FACTION_WY)

// RIFLE //
/datum/ammo_packer/recipe/wy/rifle
	category = AMMO_PACKER_CATEGORY_RIFLE

// NSG 23
/datum/ammo_packer/recipe/wy/rifle/nsg23
	name = "magazine box (NSG 23 x 12)"
	path = /obj/item/ammo_box/magazine/nsg23/empty

/datum/ammo_packer/recipe/wy/rifle/nsg23/ext
	name = "magazine box (NSG 23 Ext x 8)"
	path = /obj/item/ammo_box/magazine/nsg23/ext/empty

/datum/ammo_packer/recipe/wy/rifle/nsg23/ap
	name = "magazine box (NSG 23 AP x 12)"
	path = /obj/item/ammo_box/magazine/nsg23/ap/empty

/datum/ammo_packer/recipe/wy/rifle/nsg23/heap
	name = "magazine box (NSG 23 HEAP x 12)"
	path = /obj/item/ammo_box/magazine/nsg23/heap/empty

// Other //
/datum/ammo_packer/recipe/wy/other
	category = AMMO_PACKER_CATEGORY_OTHER

// W-Y Rations
/datum/ammo_packer/recipe/wy/other/mre
	name = "box of W-Y brand rations"
	path = /obj/item/ammo_box/magazine/misc/mre/wy/empty
	factions = list(FACTION_WY, FACTION_COLONIST)

// PMC Rations
/datum/ammo_packer/recipe/wy/other/mre/pmc
	name = "box of PMC CFR rations"
	path = /obj/item/ammo_box/magazine/misc/mre/pmc/empty
	factions = list(FACTION_WY)

//---------------------------------------------------------------------------------
// Old pattern weapons (CLF, Contractors, Mercenaries, Freelancers, Colonists)
//---------------------------------------------------------------------------------
/datum/ammo_packer/recipe/old_pattern
	factions = list(FACTION_CONTRACTOR, FACTION_MERCENARY, FACTION_FREELANCER, FACTION_COLONIST, FACTION_CLF)

// Rifle //
/datum/ammo_packer/recipe/old_pattern/rifle
	category = AMMO_PACKER_CATEGORY_RIFLE

// M16
/datum/ammo_packer/recipe/old_pattern/rifle/m16
	name = "magazine box (M16 x 12)"
	path = /obj/item/ammo_box/magazine/m16/empty

/datum/ammo_packer/recipe/old_pattern/rifle/m16/ap
	name = "magazine box (M16 AP x 12)"
	path = /obj/item/ammo_box/magazine/m16/ap/empty

// AR10
/datum/ammo_packer/recipe/old_pattern/rifle/ar10
	name = "magazine box (AR10 x 12)"
	path = /obj/item/ammo_box/magazine/ar10/empty

// MAR30/40 (weird guns)
/datum/ammo_packer/recipe/old_pattern/rifle/mar30
	name = "magazine box (MAR30/40 x 10)"
	path = /obj/item/ammo_box/magazine/mar30/empty

/datum/ammo_packer/recipe/old_pattern/rifle/mar30/ext
	name = "magazine box (MAR30/40 Ext x 10)"
	path = /obj/item/ammo_box/magazine/mar30/ext/empty

// Submachinegun //
/datum/ammo_packer/recipe/old_pattern/smg
	category = AMMO_PACKER_CATEGORY_SUBMACHINEGUN

// MP5
/datum/ammo_packer/recipe/old_pattern/smg/mp5
	name = "magazine box (MP5 x 12)"
	path = /obj/item/ammo_box/magazine/mp5/empty

// UZI
/datum/ammo_packer/recipe/old_pattern/smg/uzi
	name = "magazine box (UZI x 12)"
	path = /obj/item/ammo_box/magazine/uzi/empty

// MAC-15
/datum/ammo_packer/recipe/old_pattern/smg/mac15
	name = "magazine box (MAC-15 x 12)"
	path = /obj/item/ammo_box/magazine/mac15/empty

// MP27
/datum/ammo_packer/recipe/old_pattern/smg/mp27
	name = "magazine box (MP27 x 12)"
	path = /obj/item/ammo_box/magazine/mp27/empty

// FN FP9000, also used by WY
/datum/ammo_packer/recipe/old_pattern/smg/fp9000
	name = "magazine box (FN FP9000 x 12)"
	path = /obj/item/ammo_box/magazine/fp9000/empty
	factions = list(FACTION_CONTRACTOR, FACTION_MERCENARY, FACTION_FREELANCER, FACTION_COLONIST, FACTION_CLF, FACTION_WY)

// FN P90, has a TWE variation
/datum/ammo_packer/recipe/old_pattern/smg/p90
	name = "magazine box (FN P90 x 12)"
	path = /obj/item/ammo_box/magazine/p90/empty
	factions = list(FACTION_CONTRACTOR, FACTION_MERCENARY, FACTION_FREELANCER, FACTION_COLONIST, FACTION_CLF, FACTION_TWE)

// Sidearm //
/datum/ammo_packer/recipe/old_pattern/sidearm
	category = AMMO_PACKER_CATEGORY_SIDEARM

// Spearhead Autorevolver
/datum/ammo_packer/recipe/old_pattern/sidearm/spearhead
	name = "speed loaders box (Spearhead HP x 12)"
	path = /obj/item/ammo_box/magazine/spearhead/empty

/datum/ammo_packer/recipe/old_pattern/sidearm/spearhead/normalpoint
	name = "speed loaders box (Spearhead x 12)"
	path = /obj/item/ammo_box/magazine/spearhead/normalpoint/empty

// Deagle
/datum/ammo_packer/recipe/old_pattern/sidearm/deagle
	name = "magazine box (Desert Eagle x 12)"
	path = /obj/item/ammo_box/magazine/deagle/empty

/datum/ammo_packer/recipe/old_pattern/sidearm/deagle/super
	name = "magazine box (Desert Eagle Heavy x 8)"
	path = /obj/item/ammo_box/magazine/deagle/super/empty

/datum/ammo_packer/recipe/old_pattern/sidearm/deagle/highimpact
	name = "magazine box (Desert Eagle High-Impact x 8)"
	path = /obj/item/ammo_box/magazine/deagle/super/highimpact/empty

/datum/ammo_packer/recipe/old_pattern/sidearm/deagle/highimpactap
	name = "magazine box (Desert Eagle High-Impact AP x 8)"
	path = /obj/item/ammo_box/magazine/deagle/super/highimpact/ap/empty

// S&W Revolver
/datum/ammo_packer/recipe/old_pattern/sidearm/snw
	name = "speed loaders box (S&W .38 x 12)"
	path = /obj/item/ammo_box/magazine/snw/empty

// M1911
/datum/ammo_packer/recipe/old_pattern/sidearm/m1911
	name = "magazine box (M1911 x 16)"
	path = /obj/item/ammo_box/magazine/m1911/empty

// MK-45 Highpower Pistol
/datum/ammo_packer/recipe/old_pattern/sidearm/mk45
	name = "magazine box (MK-45 x 16)"
	path = /obj/item/ammo_box/magazine/mk45/empty

// KT-42 Automag Pistol
/datum/ammo_packer/recipe/old_pattern/sidearm/kt42
	name = "magazine box (KT-42 x 16)"
	path = /obj/item/ammo_box/magazine/kt42/empty

// Beretta 92FS
/datum/ammo_packer/recipe/old_pattern/sidearm/b92fs
	name = "magazine box (Beretta 92FS x 16)"
	path = /obj/item/ammo_box/magazine/b92fs/empty

// Heavy Weapons //
/datum/ammo_packer/recipe/old_pattern/heavy_weapon
	category = AMMO_PACKER_CATEGORY_HEAVY_WEAPON

/datum/ammo_packer/recipe/old_pattern/heavy_weapon/mar50
	name = "magazine box (MAR50 x 8)"
	path = /obj/item/ammo_box/magazine/mar50/empty

// Other //
/datum/ammo_packer/recipe/old_pattern/other
	category = AMMO_PACKER_CATEGORY_OTHER

// FSR Rations
/datum/ammo_packer/recipe/old_pattern/other/ration
	name = "box of FSR rations"
	path = /obj/item/ammo_box/magazine/misc/mre/fsr/empty

// distant sounds of The Old March growing louder and louder
//-------------------------
// UPP / overlaps with CLF
//-------------------------
/datum/ammo_packer/recipe/upp
	factions = list(FACTION_UPP, FACTION_CLF)

// Rifle //
/datum/ammo_packer/recipe/upp/rifle
	category = AMMO_PACKER_CATEGORY_RIFLE

// Type 71 Pulse Rifle
/datum/ammo_packer/recipe/upp/rifle/type71
	name = "magazine box (Type 71 x 10)"
	path = /obj/item/ammo_box/magazine/type71/empty

/datum/ammo_packer/recipe/upp/rifle/type71/ap
	name = "magazine box (Type 71 AP x 10)"
	path = /obj/item/ammo_box/magazine/type71/ap/empty

/datum/ammo_packer/recipe/upp/rifle/type71/heap
	name = "magazine box (Type 71 HEAP x 10)"
	path = /obj/item/ammo_box/magazine/type71/heap/empty

// Loose 5.45x39mm
/datum/ammo_packer/recipe/upp/rifle/rounds
	name = "rifle ammunition box (5.45x39mm)"
	path = /obj/item/ammo_box/rounds/type71/empty

/datum/ammo_packer/recipe/upp/rifle/rounds/ap
	name = "rifle ammunition box (5.45x39mm AP)"
	path = /obj/item/ammo_box/rounds/type71/ap/empty

/datum/ammo_packer/recipe/upp/rifle/rounds/heap
	name = "rifle ammunition box (5.45x39mm HEAP)"
	path = /obj/item/ammo_box/rounds/type71/heap/empty

// AK-4047 Rifle
/datum/ammo_packer/recipe/upp/rifle/ak4047
	name = "magazine box (AK-4047 x 10)"
	path = /obj/item/ammo_box/magazine/ak4047/empty

/datum/ammo_packer/recipe/upp/rifle/ak4047/ap
	name = "magazine box (AK-4047 AP x 10)"
	path = /obj/item/ammo_box/magazine/ak4047/ap/empty

/datum/ammo_packer/recipe/upp/rifle/ak4047/heap
	name = "magazine box (AK-4047 HEAP x 10)"
	path = /obj/item/ammo_box/magazine/ak4047/heap/empty

/datum/ammo_packer/recipe/upp/rifle/ak4047/incen
	name = "magazine box (AK-4047 Incen x 10)"
	path = /obj/item/ammo_box/magazine/ak4047/incen/empty

// Submachinegun //
/datum/ammo_packer/recipe/upp/smg
	category = AMMO_PACKER_CATEGORY_SUBMACHINEGUN

// Type 64 Bizon
/datum/ammo_packer/recipe/upp/smg/type64
	name = "magazine box (Type 64 x 10)"
	path = /obj/item/ammo_box/magazine/type64/empty

// Type 19
/datum/ammo_packer/recipe/upp/smg/type19
	name = "magazine box (Type 19 x 12)"
	path = /obj/item/ammo_box/magazine/type19/empty

// Shotgun //
/datum/ammo_packer/recipe/upp/shotgun
	category = AMMO_PACKER_CATEGORY_SHOTGUN

// Type 23
/datum/ammo_packer/recipe/upp/shotgun/slug
	name = "Type 23 shotgun shell box (Slug 8g x 100)"
	path = /obj/item/ammo_box/magazine/shotgun/upp/empty

/datum/ammo_packer/recipe/upp/shotgun/buckshot
	name = "Type 23 shotgun shell box (Buckshot 8g x 100)"
	path =/obj/item/ammo_box/magazine/shotgun/upp/buckshot/empty

/datum/ammo_packer/recipe/upp/shotgun/flechette
	name = "Type 23 shotgun shell box (Flechette 8g x 100)"
	path =/obj/item/ammo_box/magazine/shotgun/upp/flechette/empty

/datum/ammo_packer/recipe/upp/shotgun/beanbag
	name = "Type 23 shotgun shell box (Beanbag 8g x 100)"
	path =/obj/item/ammo_box/magazine/shotgun/upp/beanbag/empty

/datum/ammo_packer/recipe/upp/shotgun/incendiary
	name = "Type 23 shotgun shell box (Dragon's Breath 8g x 100)"
	path = /obj/item/ammo_box/magazine/shotgun/upp/incendiary/empty


// Sidearm //
/datum/ammo_packer/recipe/upp/sidearm
	category = AMMO_PACKER_CATEGORY_SIDEARM

// Type 73 Pistol
/datum/ammo_packer/recipe/upp/sidearm/type73
	name = "magazine box (Type 73 x 16)"
	path = /obj/item/ammo_box/magazine/type73/empty

/datum/ammo_packer/recipe/upp/sidearm/type73/impact
	name = "magazine box (Type 73 High-Impact x 10)"
	path = /obj/item/ammo_box/magazine/type73/impact/empty

// ZHNK-72 Revolver
/datum/ammo_packer/recipe/upp/sidearm/zhnk
	name = "speed loaders box (ZhNK-72 x 12)"
	path = /obj/item/ammo_box/magazine/zhnk/empty

// Heavy Weapons //
/datum/ammo_packer/recipe/upp/heavy_weapons
	category = AMMO_PACKER_CATEGORY_HEAVY_WEAPON

// T37 (UPP M2C)
/datum/ammo_packer/recipe/upp/heavy_weapons
	name = "ammo box (T37 x 8)"
	path = /obj/item/ammo_box/magazine/m2c/t37/empty

// Other //
/datum/ammo_packer/recipe/upp/other
	category = AMMO_PACKER_CATEGORY_OTHER

// Rations
/datum/ammo_packer/recipe/upp/other/mre
	name = "box of UPP military rations"
	path = /obj/item/ammo_box/magazine/misc/mre/upp/empty

//--------------------
// Three World Empire
//--------------------
/datum/ammo_packer/recipe/twe
	factions = list(FACTION_TWE)

// Rifle //
/datum/ammo_packer/recipe/twe/rifle
	category = AMMO_PACKER_CATEGORY_RIFLE

// L23
/datum/ammo_packer/recipe/twe/rifle/l23
	name ="magazine box (L23 x 12)"
	path = /obj/item/ammo_box/magazine/l23/empty

/datum/ammo_packer/recipe/twe/rifle/l23/ext
	name ="magazine box (L23 Ext x 8)"
	path = /obj/item/ammo_box/magazine/l23/ext/empty

/datum/ammo_packer/recipe/twe/rifle/l23/ap
	name ="magazine box (L23 AP x 12)"
	path = /obj/item/ammo_box/magazine/l23/ap/empty

/datum/ammo_packer/recipe/twe/rifle/l23/heap
	name ="magazine box (L23 HEAP x 12)"
	path = /obj/item/ammo_box/magazine/l23/heap/empty

/datum/ammo_packer/recipe/twe/rifle/l23/incen
	name ="magazine box (L23 Incen x 12)"
	path = /obj/item/ammo_box/magazine/l23/incen/empty

// Loose 8.88x51mm
/datum/ammo_packer/recipe/twe/rifle/rounds
	name = "rifle ammunition box (8.88x51mm)"
	path = /obj/item/ammo_box/rounds/l23/empty

/datum/ammo_packer/recipe/twe/rifle/rounds/ap
	name = "rifle ammunition box (8.88x51mm AP)"
	path = /obj/item/ammo_box/rounds/l23/ap/empty

/datum/ammo_packer/recipe/twe/rifle/rounds/heap
	name = "rifle ammunition box (8.88x51mm HEAP)"
	path = /obj/item/ammo_box/rounds/l23/heap/empty

/datum/ammo_packer/recipe/twe/rifle/rounds/incen
	name = "rifle ammunition box (8.88x51mm Incen)"
	path = /obj/item/ammo_box/rounds/l23/incen/empty

// Sidearm //
/datum/ammo_packer/recipe/twe/sidearm
	category = AMMO_PACKER_CATEGORY_SIDEARM

// L54 Pistol
/datum/ammo_packer/recipe/twe/sidearm/l54
	name = "magazine box (L54 x 16)"
	path = /obj/item/ammo_box/magazine/l54/empty
	factions = list(FACTION_TWE, FACTION_NSPA)

/datum/ammo_packer/recipe/twe/sidearm/l54/ap
	name = "magazine box (L54 AP x 16)"
	path = /obj/item/ammo_box/magazine/l54/ap/empty

/datum/ammo_packer/recipe/twe/sidearm/l54/hp
	name = "magazine box (L54 HP x 16)"
	path = /obj/item/ammo_box/magazine/l54/hp/empty

/datum/ammo_packer/recipe/twe/sidearm/l54/incen
	name = "magazine box (L54 Incen x 16)"
	path = /obj/item/ammo_box/magazine/l54/incen/empty

// Other //
/datum/ammo_packer/recipe/twe/other
	category = AMMO_PACKER_CATEGORY_OTHER

// Rations
/datum/ammo_packer/recipe/twe/other/mre
	name = "box of TWE ORP rations"
	path = /obj/item/ammo_box/magazine/misc/mre/twe/empty

//------------------------------------------------------------------
// Neutral, for stuff that every faction uses (Nailgun boxes, etc.)
//------------------------------------------------------------------
/datum/ammo_packer/recipe/neutral
	factions = list(FACTION_NEUTRAL)

// Other //
/datum/ammo_packer/recipe/neutral/other
	category = AMMO_PACKER_CATEGORY_OTHER

// Nailgun
/datum/ammo_packer/recipe/neutral/other/nailgun
	name = "magazine box (Nailgun x 10)"
	path = /obj/item/ammo_box/magazine/nailgun/empty

// Emergency Rations
/datum/ammo_packer/recipe/neutral/other/emergency_ration
	name = "box of emergency rations"
	path = /obj/item/ammo_box/magazine/misc/mre/emergency/empty

// Flashlight
/datum/ammo_packer/recipe/neutral/other/flashlight
	name = "box of flashlights"
	path = /obj/item/ammo_box/magazine/misc/flashlight/empty

// Combat Flashlight
/datum/ammo_packer/recipe/neutral/other/flashlight/combat
	name = "box of combat flashlights"
	path = /obj/item/ammo_box/magazine/misc/flashlight/combat/empty

// Battery Box
/datum/ammo_packer/recipe/neutral/other/power_cell
	name = "box of High-Capacity Power Cells"
	path = /obj/item/ammo_box/magazine/misc/power_cell/empty

#undef AMMO_PACKER_CATEGORY_RIFLE
#undef AMMO_PACKER_CATEGORY_SUBMACHINEGUN
#undef AMMO_PACKER_CATEGORY_SHOTGUN
#undef AMMO_PACKER_CATEGORY_SIDEARM
#undef AMMO_PACKER_CATEGORY_HEAVY_WEAPON
#undef AMMO_PACKER_CATEGORY_OTHER
