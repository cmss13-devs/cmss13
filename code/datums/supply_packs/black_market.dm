//*******************************************************************************
//BLACK MARKET
//*******************************************************************************/

//------------------------crates----------------

/*

----

IMPORTANT NOTE!!!!!

black market prices are NOT based on real or in-universe costs. they are based on how much the insane cargo-technician inside the elevator gives a damn about the crate.

----

*/

/datum/supply_packs/contraband//base
	name = "contraband crate"
	contains = null
	containertype = null
	containername = "large crate"
	group = "Black Market"
	contraband = TRUE
	cost = 0
	dollar_cost = 50

/obj/structure/largecrate/black_market
	/// Wipes points from objects inside to avoid infinite farming.
	var/points_wipe = TRUE
	//no special name so it can be hidden

/obj/structure/largecrate/black_market/unpack()
	if(!points_wipe)
		return ..()

	for(var/atom/movable/content_atom in contents)
		content_atom.black_market_value = 0 //no free points
		recursive_points_wipe(content_atom, 1)

	return ..()

#define RECURSION_LIMIT 3

/obj/structure/largecrate/black_market/proc/recursive_points_wipe(atom/movable/content_atom, recursion)
	if(!points_wipe || recursion > RECURSION_LIMIT) // sanity
		return
	for(var/atom/movable/nested_atom in content_atom.contents)
		nested_atom.black_market_value = 0
		recursive_points_wipe(nested_atom, recursion++)

#undef RECURSION_LIMIT

/* --- SEIZED ITEMS --- */

/*

Non-USCM items, from CLF, UPP, colonies, etc. Mostly combat-related.

*/

/datum/supply_packs/contraband/seized
	group = "Seized Items"

/datum/supply_packs/contraband/seized/black_market_scanner
	name = "black market scanner crate"
	contains = list(/obj/item/device/black_market_scanner)
	containername = "trash cart"
	dollar_cost = 5
	containertype = /obj/structure/closet/crate/trashcart

/datum/supply_packs/contraband/seized/confiscated_equipment
	name = "seized foreign equipment crate"
	dollar_cost = 70
	containertype = /obj/structure/largecrate/black_market/confiscated_equipment

/obj/structure/largecrate/black_market/confiscated_equipment/Initialize()
	. = ..()
	switch(rand(1,7))
		if(1) //pmc
			new /obj/item/clothing/under/marine/veteran/pmc(src)
			new /obj/item/clothing/head/helmet/marine/veteran/pmc(src)
			new /obj/item/clothing/suit/storage/marine/veteran/pmc(src)
			new /obj/item/clothing/gloves/marine/veteran/pmc(src)
			new /obj/item/clothing/mask/gas/pmc(src)
			new /obj/item/storage/backpack/lightpack/five_slot(src)
		if(2) //dutch's
			new /obj/item/clothing/head/helmet/marine/veteran/dutch(src)
			new /obj/item/clothing/under/marine/veteran/dutch(src)
			new /obj/item/clothing/suit/storage/marine/veteran/dutch(src)
			new /obj/item/clothing/gloves/marine/veteran(src)
		if(3) //pizza
			new /obj/item/clothing/under/pizza(src)
			new /obj/item/clothing/head/soft/red(src)
		if(4) //clf
			new /obj/item/clothing/under/colonist/clf(src)
			new /obj/item/clothing/suit/storage/militia(src)
			new /obj/item/clothing/head/militia(src)
			new /obj/item/clothing/gloves/marine/veteran(src)
			new /obj/item/storage/backpack/lightpack/five_slot(src)
		if(5) //upp
			new /obj/item/clothing/head/helmet/marine/veteran/UPP(src)
			new /obj/item/clothing/under/marine/veteran/UPP(src)
			new /obj/item/clothing/suit/storage/marine/faction/UPP(src)
			new /obj/item/clothing/shoes/marine/upp(src)
			new /obj/item/clothing/gloves/marine/veteran(src)
			new /obj/item/storage/backpack/lightpack/five_slot(src)
		if(6) //freelancer
			new /obj/item/clothing/under/marine/veteran/freelancer(src)
			new /obj/item/clothing/suit/storage/marine/faction/freelancer(src)
			new /obj/item/clothing/gloves/marine/veteran(src)
			new /obj/item/storage/backpack/lightpack/five_slot(src)
		if(7) //VAIPO
			new /obj/item/clothing/glasses/sunglasses/big(src)
			new /obj/item/clothing/suit/storage/marine/light/vest(src)
			new /obj/item/clothing/under/tshirt/gray_blu(src)

/datum/supply_packs/contraband/seized/confiscated_weaponry
	name = "seized foreign weaponry crate"
	contains = list()
	dollar_cost = 45
	containertype = /obj/structure/largecrate/black_market/confiscated_weaponry

/obj/structure/largecrate/black_market/confiscated_weaponry/Initialize()
	. = ..()
	spawn_guns()
	spawn_guns() //the crate gives 2 guns

/obj/structure/largecrate/black_market/confiscated_weaponry/proc/spawn_guns()
	switch(rand(1,7))
		if(1) //pmc
			if(prob(50))
				new /obj/item/weapon/gun/rifle/nsg23/no_lock(src)
				new /obj/item/ammo_magazine/rifle/nsg23(src)
				new /obj/item/ammo_magazine/rifle/nsg23(src)
				new /obj/item/ammo_magazine/rifle/nsg23/ap(src)
				new /obj/item/ammo_magazine/rifle/nsg23/extended(src)
			else
				new /obj/item/weapon/gun/smg/fp9000(src)
				new /obj/item/ammo_magazine/smg/fp9000(src)
				new /obj/item/ammo_magazine/smg/fp9000(src)
				new /obj/item/ammo_magazine/smg/fp9000(src)
				new /obj/item/ammo_magazine/smg/fp9000(src)
		if(2) //dutch's
			new /obj/item/weapon/gun/rifle/m16/dutch(src)
			new /obj/item/ammo_magazine/rifle/m16/ap(src)
			new /obj/item/ammo_magazine/rifle/m16/ap(src)
			new /obj/item/ammo_magazine/rifle/m16/ap(src)
			new /obj/item/ammo_magazine/rifle/m16/ap(src)
		if(3) //pizza
			new /obj/item/weapon/gun/pistol/holdout(src)
			new /obj/item/ammo_magazine/pistol/holdout(src)
		if(4) //clf
			switch(rand(1, 4))
				if(1)
					new /obj/item/weapon/melee/twohanded/lungemine/damaged(src)
				if(2)
					new /obj/item/weapon/gun/smg/uzi(src)
					new /obj/item/ammo_magazine/smg/uzi/extended(src)
					new /obj/item/ammo_magazine/smg/uzi(src)
					new /obj/item/ammo_magazine/smg/uzi(src)
				if(3)
					new /obj/item/weapon/gun/smg/mac15(src)
					new /obj/item/ammo_magazine/smg/mac15/extended(src)
					new /obj/item/ammo_magazine/smg/mac15(src)
					new /obj/item/ammo_magazine/smg/mac15(src)
				if(4)
					new /obj/item/weapon/gun/m60(src)
					new /obj/item/ammo_magazine/m60(src)
					new /obj/item/ammo_magazine/m60(src)
					new /obj/item/ammo_magazine/m60(src)
		if(5) //upp
			if(prob(50))
				new /obj/item/weapon/gun/rifle/type71(src)
				new /obj/item/ammo_magazine/rifle/type71/ap(src)
				new /obj/item/ammo_magazine/rifle/type71(src)
				new /obj/item/ammo_magazine/rifle/type71(src)
			else
				new /obj/item/weapon/gun/shotgun/type23/riot_control(src)
				new /obj/item/ammo_magazine/handful/shotgun/heavy/beanbag(src)
				new /obj/item/ammo_magazine/handful/shotgun/heavy/beanbag(src)
				new /obj/item/ammo_magazine/handful/shotgun/heavy/flechette(src)
				new /obj/item/ammo_magazine/handful/shotgun/heavy/flechette(src)
				new /obj/item/ammo_magazine/handful/shotgun/heavy/slug(src)
				new /obj/item/ammo_magazine/handful/shotgun/heavy/slug(src) //NO buckshot!
		if(6) //freelancer
			if(prob(80))
				new /obj/item/weapon/gun/rifle/mar40(src)
				new /obj/item/ammo_magazine/rifle/mar40/extended(src)
				new /obj/item/ammo_magazine/rifle/mar40(src)
				new /obj/item/ammo_magazine/rifle/mar40(src)
			else
				new /obj/item/weapon/gun/rifle/mar40/lmg(src)
				new /obj/item/ammo_magazine/rifle/mar40/lmg(src)
		if(7) //VAIPO
			if(prob(50))
				new /obj/item/weapon/gun/rifle/mar40/tactical(src)
				new /obj/item/ammo_magazine/rifle/mar40/extended(src)
				new /obj/item/ammo_magazine/rifle/mar40/extended(src)
				new /obj/item/ammo_magazine/rifle/mar40(src)
			else
				new /obj/item/weapon/gun/rifle/m41aMK1/tactical(src)
				new /obj/item/ammo_magazine/rifle/m41aMK1/ap(src)
				new /obj/item/ammo_magazine/rifle/m41aMK1(src)
				new /obj/item/ammo_magazine/rifle/m41aMK1(src)

/* Misc. Individual Guns */

/* Prices are based on two things.

- 1. How strong the weapon is.
- 2. How underutilized it is by players.

Magazine count is also similarly based on this.

This way, underused-but-good weapons are incentivized to be bought for cheap like the PK-9.

Additionally, weapons that are way too good to put in the basically-flavor black market get weakened versions of themselves.

*/

// Rifles

/datum/supply_packs/contraband/seized/m16
	name = "M16 rifle crate (x4 magazines included)"
	contains = list(
		/obj/item/weapon/gun/rifle/m16,
		/obj/item/ammo_magazine/rifle/m16,
		/obj/item/ammo_magazine/rifle/m16,
		/obj/item/ammo_magazine/rifle/m16,
		/obj/item/ammo_magazine/rifle/m16,
	)
	dollar_cost = 35
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/ar10
	name = "AR10 rifle crate (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/rifle/ar10,
		/obj/item/ammo_magazine/rifle/ar10,
		/obj/item/ammo_magazine/rifle/ar10,
		/obj/item/ammo_magazine/rifle/ar10,
		/obj/item/ammo_magazine/rifle/ar10,
	)
	dollar_cost = 40 // rarer
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/mar30
	name = "MAR-30 battle carbine crate (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/rifle/mar40/carbine,
		/obj/item/ammo_magazine/rifle/mar40,
		/obj/item/ammo_magazine/rifle/mar40,
		/obj/item/ammo_magazine/rifle/mar40,
		/obj/item/ammo_magazine/rifle/mar40,
		/obj/item/ammo_magazine/rifle/mar40,
	)
	dollar_cost = 30
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/hunting
	name = "Basira-Armstrong bolt-action hunting rifle crate (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/boltaction,
		/obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/ammo_magazine/rifle/boltaction,
	)
	dollar_cost = 5
	containertype = /obj/structure/largecrate/black_market

// Shotguns

/datum/supply_packs/contraband/seized/sawny
	name = "Sawn-off Spearhead Rival 78 crate (x1 ammo box included)"
	contains = list(
		/obj/item/weapon/gun/shotgun/double/damaged, //its not actually sawed off........... get fuked
		/obj/item/ammo_magazine/shotgun/buckshot,
	)
	dollar_cost = 45
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/custom
	name = "custom-built shotgun crate (x1 ammo box included)"
	contains = list(
		/obj/item/weapon/gun/shotgun/merc/damaged,
		/obj/item/ammo_magazine/shotgun,
	)
	dollar_cost = 50
	containertype = /obj/structure/largecrate/black_market

// SMGs

/datum/supply_packs/contraband/seized/fp9000
	name = "FN FP9000 submachinegun crate (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/smg/fp9000,
		/obj/item/ammo_magazine/smg/fp9000,
		/obj/item/ammo_magazine/smg/fp9000,
		/obj/item/ammo_magazine/smg/fp9000,
		/obj/item/ammo_magazine/smg/fp9000,
		/obj/item/ammo_magazine/smg/fp9000,
	)
	dollar_cost = 25
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/mp27
	name = "MP-27 submachinegun crate (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/smg/mp27,
		/obj/item/ammo_magazine/smg/mp27,
		/obj/item/ammo_magazine/smg/mp27,
		/obj/item/ammo_magazine/smg/mp27,
		/obj/item/ammo_magazine/smg/mp27,
		/obj/item/ammo_magazine/smg/mp27,
	)
	dollar_cost = 20
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/mp5
	name = "MP5 submachinegun crate (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/smg/mp5,
		/obj/item/ammo_magazine/smg/mp5,
		/obj/item/ammo_magazine/smg/mp5,
		/obj/item/ammo_magazine/smg/mp5,
		/obj/item/ammo_magazine/smg/mp5,
		/obj/item/ammo_magazine/smg/mp5,
	)
	dollar_cost = 25
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/uzi
	name = "UZI submachinegun crate (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/smg/uzi,
		/obj/item/ammo_magazine/smg/uzi,
		/obj/item/ammo_magazine/smg/uzi,
		/obj/item/ammo_magazine/smg/uzi,
		/obj/item/ammo_magazine/smg/uzi,
		/obj/item/ammo_magazine/smg/uzi,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/mac15
	name = "MAC-15 submachinegun crate (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/smg/mac15,
		/obj/item/ammo_magazine/smg/mac15,
		/obj/item/ammo_magazine/smg/mac15,
		/obj/item/ammo_magazine/smg/mac15,
		/obj/item/ammo_magazine/smg/mac15,
		/obj/item/ammo_magazine/smg/mac15,
	)
	dollar_cost = 5
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/ppsh
	name = "PPSh-17b submachinegun crate (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/smg/ppsh,
		/obj/item/ammo_magazine/smg/ppsh/extended,
		/obj/item/ammo_magazine/smg/ppsh/extended,
		/obj/item/ammo_magazine/smg/ppsh,
		/obj/item/ammo_magazine/smg/ppsh,
		/obj/item/ammo_magazine/smg/ppsh,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

//Pistols

/datum/supply_packs/contraband/seized/b92fs
	name = "Beretta pistol crate (x6 magazines included)"
	contains = list(
		/obj/item/weapon/gun/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/heavy
	name = "Desert Eagle crate (x4 magazines included)"
	contains = list(
		/obj/item/weapon/gun/pistol/heavy,
		/obj/item/ammo_magazine/pistol/heavy,
		/obj/item/ammo_magazine/pistol/heavy,
		/obj/item/ammo_magazine/pistol/heavy,
		/obj/item/ammo_magazine/pistol/heavy,
	)
	dollar_cost = 45
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/c99
	name = "Korovin PK-9 pistol crate (x6 magazines included)"
	contains = list(
		/obj/item/weapon/gun/pistol/c99,
		/obj/item/ammo_magazine/pistol/c99,
		/obj/item/ammo_magazine/pistol/c99,
		/obj/item/ammo_magazine/pistol/c99,
		/obj/item/ammo_magazine/pistol/c99,
		/obj/item/ammo_magazine/pistol/c99,
		/obj/item/ammo_magazine/pistol/c99,
	)
	dollar_cost = 5
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/kt42
	name = "KT-42 Automag pistol (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/pistol/kt42,
		/obj/item/ammo_magazine/pistol/kt42,
		/obj/item/ammo_magazine/pistol/kt42,
		/obj/item/ammo_magazine/pistol/kt42,
		/obj/item/ammo_magazine/pistol/kt42,
		/obj/item/ammo_magazine/pistol/kt42,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/holdout
	name = "holdout pistol (x7 magazines included)"
	contains = list(
		/obj/item/weapon/gun/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
	)
	dollar_cost = 5
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/skorpion
	name = "CZ-81 machine pistol (x4 magazines included)"
	contains = list(
		/obj/item/weapon/gun/pistol/skorpion,
		/obj/item/ammo_magazine/pistol/skorpion,
		/obj/item/ammo_magazine/pistol/skorpion,
		/obj/item/ammo_magazine/pistol/skorpion,
		/obj/item/ammo_magazine/pistol/skorpion,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

//Revolvers

/datum/supply_packs/contraband/seized/cmb
	name = "CMB Spearhead revolver (x5 magazines included)"
	contains = list(
		/obj/item/weapon/gun/revolver/cmb,
		/obj/item/ammo_magazine/revolver/cmb,
		/obj/item/ammo_magazine/revolver/cmb,
		/obj/item/ammo_magazine/revolver/cmb,
		/obj/item/ammo_magazine/revolver/cmb,
		/obj/item/ammo_magazine/revolver/cmb,
	)
	dollar_cost = 20
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/small
	name = "S&W revolver (x6 magazines included)"
	contains = list(
		/obj/item/weapon/gun/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/nagant
	name = "N-Y 7.62mm revolver (x6 magazines included)"
	contains = list(
		/obj/item/weapon/gun/revolver/nagant,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/r4t
	name = "R4T hunting rifle case (x3 ammo boxes included)"
	contains = list(
		/obj/item/weapon/gun/lever_action/r4t,
		/obj/item/attachable/stock/r4t,
		/obj/item/ammo_magazine/lever_action,
		/obj/item/ammo_magazine/lever_action,
		/obj/item/ammo_magazine/lever_action/training,
	)
	dollar_cost = 75
	containertype = /obj/structure/largecrate/black_market

/* --- SHIPSIDE CONTRABAND --- */

/*

Primarily made up of things that would be best utilized, well, shipside. Recreational drugs, alcohol, toys...

*/

/datum/supply_packs/contraband/shipside
	group = "Shipside Contraband"

/datum/supply_packs/contraband/shipside/confiscated_alcohol
	name = "confiscated alcohol crate"
	randomised_num_contained = 5
	contains = list(
		/obj/item/reagent_container/food/drinks/bottle/gin,
		/obj/item/reagent_container/food/drinks/bottle/whiskey,
		/obj/item/reagent_container/food/drinks/bottle/sake,
		/obj/item/reagent_container/food/drinks/bottle/vodka,
		/obj/item/reagent_container/food/drinks/bottle/vodka/chess/random,
		/obj/item/reagent_container/food/drinks/bottle/tequila,
		/obj/item/reagent_container/food/drinks/bottle/davenport,
		/obj/item/reagent_container/food/drinks/bottle/bottleofnothing,
		/obj/item/reagent_container/food/drinks/bottle/patron,
		/obj/item/reagent_container/food/drinks/bottle/rum,
		/obj/item/reagent_container/food/drinks/bottle/vermouth,
		/obj/item/reagent_container/food/drinks/bottle/kahlua,
		/obj/item/reagent_container/food/drinks/bottle/goldschlager,
		/obj/item/reagent_container/food/drinks/bottle/cognac,
		/obj/item/reagent_container/food/drinks/bottle/wine,
		/obj/item/reagent_container/food/drinks/bottle/absinthe,
		/obj/item/reagent_container/food/drinks/bottle/melonliquor,
		/obj/item/reagent_container/food/drinks/bottle/bluecuracao,
		/obj/item/reagent_container/food/drinks/bottle/grenadine,
		/obj/item/reagent_container/food/drinks/bottle/pwine,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/tuxedo,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/ganucci,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/bluemalt,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/partypopper,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/tazhushka,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/reaper,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/mono,
	)
	dollar_cost = 35
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/shipside/confiscated_medicine
	name = "confiscated medicinal supplies crate"
	randomised_num_contained = 5
	contains = list(
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/mystery,
		/obj/item/storage/pill_bottle/russianRed/skillless,
		/obj/item/reagent_container/food/drinks/flask/weylandyutani/poison,
		/obj/item/reagent_container/food/drinks/bottle/holywater/bong,
		/obj/item/storage/pill_bottle/paracetamol,
		/obj/item/storage/pill_bottle/zombie_powder,
	)
	dollar_cost = 25
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/shipside/confiscated_cuisine
	name = "confiscated cuisine supplies crate"
	randomised_num_contained = 7
	contains = list(
		/obj/item/reagent_container/food/drinks/bottle/absinthe,
		/obj/item/reagent_container/food/drinks/bottle/pwine,
		/obj/item/reagent_container/food/snacks/stew,
		/obj/item/reagent_container/food/snacks/donut/chaos,
		/obj/item/reagent_container/food/snacks/egg/random,
		/obj/item/reagent_container/food/snacks/egg/random, //not a dupe
		/obj/item/reagent_container/food/snacks/xemeatpie,
		/obj/item/reagent_container/food/snacks/monkeycube,
		/obj/item/reagent_container/food/snacks/monkeycube/farwacube,
		/obj/item/reagent_container/food/snacks/monkeycube/stokcube,
		/obj/item/reagent_container/food/snacks/monkeycube/yirencube,
		/obj/item/reagent_container/food/snacks/upp,
		/obj/item/reagent_container/food/snacks/mre_pack/xmas1,
		/obj/item/reagent_container/food/snacks/mre_pack/xmas2,
		/obj/item/reagent_container/food/snacks/mre_pack/xmas3,
		/obj/item/reagent_container/food/snacks/wrapped/chunk/hunk,
		/obj/item/reagent_container/food/snacks/meat/human,
		/obj/item/reagent_container/food/snacks/meat/corgi,
		/obj/item/reagent_container/food/snacks/meat/xenomeat,
		/obj/item/reagent_container/food/snacks/grown/apple/poisoned,
		/obj/item/reagent_container/food/snacks/grown/poisonberries,
		/obj/item/reagent_container/food/snacks/grown/deathberries,
		/obj/item/reagent_container/food/snacks/carpmeat,
		/obj/item/reagent_container/food/snacks/candy_corn,
		/obj/item/reagent_container/food/snacks/monkeyburger,
		/obj/item/reagent_container/food/snacks/human/burger,
		/obj/item/reagent_container/food/snacks/xenoburger,
		/obj/item/reagent_container/food/snacks/amanitajelly,
		/obj/item/reagent_container/food/snacks/spacylibertyduff,
		/obj/item/reagent_container/food/snacks/monkeysdelight,
		/obj/item/reagent_container/food/snacks/sliceable/braincake,
		/obj/item/reagent_container/food/snacks/resin_fruit,
		/obj/item/reagent_container/food/condiment/hotsauce/franks/macho,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market


/datum/supply_packs/contraband/shipside/confiscated_nicotine
	name = "confiscated nicotine items crate"
	randomised_num_contained = 2
	contains = list(
		/obj/item/storage/fancy/cigarettes/blackpack,
		/obj/item/storage/fancy/cigarettes/wypacket,
		/obj/item/storage/fancy/cigarettes/kpack,
		/obj/item/storage/fancy/cigarettes/arcturian_ace,
		/obj/item/storage/fancy/cigarettes/lady_finger,
		/obj/item/storage/fancy/cigar/tarbacks,
		/obj/item/storage/fancy/cigar/tarbacktube,
	)
	dollar_cost = 45
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/shipside/confiscated_miscellaneous
	name = "confiscated miscellaneous items crate"
	randomised_num_contained = 6
	contains = list(
		/obj/item/toy/bikehorn,
		/obj/item/storage/box/packet/hefa/toy,
		/obj/item/toy/inflatable_duck,
		/obj/item/toy/beach_ball,
		/obj/item/toy/farwadoll,
		/obj/item/toy/waterflower,
		/obj/item/toy/spinningtoy,
		/obj/item/storage/box/snappops,
		/obj/item/storage/fancy/crayons,
		/obj/item/toy/balloon,
		/obj/item/storage/wallet,
		/obj/item/storage/belt/champion,
		/obj/item/clothing/mask/luchador,
		/obj/item/tool/soap/deluxe,
		/obj/item/tool/crowbar/maintenance_jack,
		/obj/item/explosive/grenade/smokebomb,
		/obj/item/corncob,
		/obj/item/poster,
		/obj/item/weapon/melee/banhammer,
		/obj/item/toy/prize/ripley,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/deathripley,
		/obj/item/reagent_container/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_container/food/snacks/grown/ambrosiavulgaris,
		/obj/item/clothing/accessory/horrible,
		/obj/item/storage/belt/marine/quackers,
		/obj/item/storage/belt/shotgun/full/quackers,
		/obj/item/pamphlet/skill/powerloader,
		/obj/item/pamphlet/language/russian,
		/obj/item/pamphlet/language/japanese,
		/obj/item/pamphlet/language/chinese,
		/obj/item/pamphlet/language/german,
		/obj/item/pamphlet/language/spanish,
	)
	dollar_cost = 30
	containertype = /obj/structure/largecrate/black_market


/* --- SURPLUS EQUIPMENT --- */

/*

USCM spare items, miscellaneous gear that's too niche and distant (or restricted) to put in normal req but juuuust USCM-related enough to fit here.

*/

/datum/supply_packs/contraband/surplus
	group = "Surplus Equipment"

/* - Misc. USCM equipment - */

/datum/supply_packs/contraband/surplus/uscm_poncho
	name = "surplus USCM poncho crate (x2)"
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market/poncho

/obj/structure/largecrate/black_market/poncho/Initialize()
	. = ..()
	var/obj/item/paper/nope = new(src)
	nope.name = "automated ASRS note"
	nope.info = "Sorry! Your requested order of <b>USCM PONCHO (X2)</b> was not succesfully delivered because: 'No items of that type found in storage.'"
	nope.color = "green"
	nope.update_icon()

/datum/supply_packs/contraband/surplus/uscm_heap
	name = "surplus high-explosive armor-piercing M41A magazine crate (x3)"
	dollar_cost = 40
	containertype = /obj/structure/largecrate/black_market/uscm_heap

/obj/structure/largecrate/black_market/uscm_heap/Initialize()
	. = ..()
	var/obj/item/paper/nope = new(src)
	nope.name = "automated ASRS note"
	nope.info = "Sorry! Your requested order of <b> HIGH-EXPLOSIVE ARMOR-PIERCING M41A MAGAZINE (X3)</b> was not succesfully delivered because: 'ERROR: UNABLE TO ENTER COMPARTMENT EXIT CODE 2342: EXPLOSION HAZARD'"
	nope.color = "green"
	nope.update_icon()

/datum/supply_packs/contraband/surplus/surplus_police_equipment
	name = "surplus riot control equipment"
	randomised_num_contained = 3
	contains = list(
		/obj/item/weapon/melee/baton/damaged,
		/obj/item/reagent_container/spray/pepper,
		/obj/item/weapon/melee/baton/cattleprod,
		/obj/item/ammo_magazine/shotgun/beanbag,
		/obj/item/storage/box/packet/m15/rubber,
		/obj/item/storage/box/guncase/m79,
		/obj/item/clothing/head/helmet/marine/MP,
		/obj/item/prop/helmetgarb/riot_shield,
	)
	dollar_cost = 55
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/surplus_non_lethal_ammunition
	name = "surplus non-lethal ammunition"
	randomised_num_contained = 2
	contains = list(
		/obj/item/ammo_magazine/smg/m39/rubber,
		/obj/item/ammo_magazine/pistol/rubber,
		/obj/item/ammo_magazine/pistol/mod88/rubber,
		/obj/item/ammo_magazine/rifle/rubber,
		/obj/item/ammo_magazine/rifle/l42a/rubber,
		/obj/item/ammo_magazine/shotgun/beanbag,
	)
	dollar_cost = 50
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/surplus_l42_extended
	name = "surplus magazine box (Ext L42A x 12)"
	contains = list(/obj/item/ammo_box/magazine/l42a/ext)
	dollar_cost = 45
	containertype = /obj/structure/largecrate/black_market

/* - Misc. USCM weaponry - */

/datum/supply_packs/contraband/surplus/mk45_automag
	name = "surplus MK-45 Automagnum case"
	dollar_cost = 35
	contains = list(/obj/item/storage/box/guncase/mk45_automag)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/nsg23_marine
	name = "surplus NSG-23 assault rifle case"
	dollar_cost = 45
	contains = list(/obj/item/storage/box/guncase/nsg23_marine)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/m3717
	name = "surplus M37-17 pump shotgun case"
	dollar_cost = 80
	contains = list(/obj/item/storage/box/guncase/m3717)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/m1911
	name = "surplus M1911 service pistol case"
	dollar_cost = 10
	contains = list(/obj/item/storage/box/guncase/m1911)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/m1911/socom
	name = "surplus SOCOM M1911 service pistol case"
	dollar_cost = 25
	contains = list(/obj/item/storage/box/guncase/m1911/socom)
	containertype = /obj/structure/largecrate/black_market

/* --- DEEP STORAGE --- */

/*

Some of the least-obtainable loadout items, now purchasable from the contraband menu. If you think this is filler, uh........ yeah.

This is where the RO can reclaim their lost honor and purchase the M44 custom, though.

*/

/datum/supply_packs/contraband/deep_storage
	group = "Deep Storage"


// Helmet Garb

/datum/supply_packs/contraband/deep_storage/spacejam
	name = "Tickets to Space Jam"
	contains = list(/obj/item/prop/helmetgarb/spacejam_tickets)
	dollar_cost = 5
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/broken_nvgs
	name = "Broken Night Vision Goggles"
	contains = list(/obj/item/prop/helmetgarb/helmet_nvg/cosmetic)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/xm42b_pipe
	name = "10x99mm XM42B casing"
	contains = list(/obj/item/prop/helmetgarb/bullet_pipe)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/trimmed_wire
	name = "Trimmed Barbed Wire"
	contains = list(/obj/item/prop/helmetgarb/trimmed_wire)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/lucky_feather_random
	name = "Lucky Feather"
	randomised_num_contained = 1
	contains = list(
		/obj/item/prop/helmetgarb/lucky_feather,
		/obj/item/prop/helmetgarb/lucky_feather/blue,
		/obj/item/prop/helmetgarb/lucky_feather/purple,
		/obj/item/prop/helmetgarb/lucky_feather/yellow,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/rosary
	name = "Rosary"
	contains = list(/obj/item/prop/helmetgarb/rosary)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/rabbitsfoot
	name = "Rabbit's Foot"
	contains = list(/obj/item/prop/helmetgarb/rabbitsfoot)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

// Masks

/datum/supply_packs/contraband/deep_storage/tacticalmask_random
	name = "Tactical Mask"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/mask/rebreather/scarf/tacticalmask,
		/obj/item/clothing/mask/rebreather/scarf/tacticalmask/red,
		/obj/item/clothing/mask/rebreather/scarf/tacticalmask/green,
		/obj/item/clothing/mask/rebreather/scarf/tacticalmask/tan,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/skull_balaclava_random
	name = "Skull Balaclava"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/mask/rebreather/skull/black,
		/obj/item/clothing/mask/rebreather/skull,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market


/datum/supply_packs/contraband/deep_storage/skull_facepaint
	name = "Skull Facepaint"
	contains = list(/obj/item/facepaint/skull)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

//Glasses

/datum/supply_packs/contraband/deep_storage/aviator_shades
	name = "Aviator Shades"
	contains = list(/obj/item/clothing/glasses/sunglasses/aviator)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/ballistic_goggles_random
	name = "Ballistic Goggles"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/glasses/mgoggles,
		/obj/item/clothing/glasses/mgoggles/orange,
		/obj/item/clothing/glasses/mgoggles/black,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/bimex_shades
	name = "BiMex Personal Shades"
	contains = list(/obj/item/clothing/glasses/sunglasses/big)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

// Headgear

/datum/supply_packs/contraband/deep_storage/bandana_random
	name = "USCM Bandana"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/head/cmbandana,
		/obj/item/clothing/head/cmbandana/tan,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/uscm_earpiece
	name = "USCM Earpiece"
	randomised_num_contained = 1
	contains = list(/obj/item/clothing/head/headset)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/uscm_headband
	name = "USCM Headband"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/head/headband,
		/obj/item/clothing/head/headband/brown,
		/obj/item/clothing/head/headband/gray,
		/obj/item/clothing/head/headband/red,
		/obj/item/clothing/head/headband/tan,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/uscm_boonie_hat
	name = "USCM Boonie Hat"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/head/cmcap/boonie/tan,
		/obj/item/clothing/head/cmcap/boonie,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

//Misc

/datum/supply_packs/contraband/deep_storage/pdtl_kit
	name = "PDT/L Kit"
	contains = list(/obj/item/storage/box/pdt_kit)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/lucky_lime
	name = "Frozen Lime"
	contains = list(/obj/item/reagent_container/food/snacks/grown/lime)
	dollar_cost = 5
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/uno_reverse_random
	name = "Uno Reverse Card"
	randomised_num_contained = 1
	contains = list(
		/obj/item/toy/handcard/uno_reverse_red,
		/obj/item/toy/handcard/uno_reverse_blue,
		/obj/item/toy/handcard/uno_reverse_purple,
		/obj/item/toy/handcard/uno_reverse_yellow,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/jungle_boots
	name = "Jungle Pattern Combat Boots"
	contains = list(/obj/item/clothing/shoes/marine/jungle)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

//Weapons

/datum/supply_packs/contraband/deep_storage/type_replica
	name = "Type 80 Bayonet Replica"
	contains = list(/obj/item/attachable/bayonet/upp_replica)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/cartridge_bayonet
	name = "M8 Cartridge Bayonet Kit"
	contains = list(/obj/item/storage/box/c02_knife)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/clf_holdout
	name = "D18 Holdout Pistol"
	contains = list(/obj/item/storage/box/clf)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/m4a3_c
	name = "M4A3 Custom Pistol"
	contains = list(/obj/item/weapon/gun/pistol/m4a3/custom)
	dollar_cost = 35
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/m44_c
	name = "M44 Custom Revolver"
	contains = list(/obj/item/weapon/gun/revolver/m44/custom)
	dollar_cost = 70
	containertype = /obj/structure/largecrate/black_market

/* --- MISCELLANEOUS --- */

/*

Things that don't fit anywhere else. If they're meant for shipside use, they probably fit in shipside contraband.

*/

/datum/supply_packs/contraband/miscellaneous
	group = "Miscellaneous"

/datum/supply_packs/contraband/miscellaneous/secured_wildlife
	name = "secured wildlife container"
	dollar_cost = 45
	containertype = /obj/structure/largecrate/black_market/secured_wildlife

/obj/structure/largecrate/black_market/secured_wildlife
	name = "secured wildlife container"
	icon_state = "lisacrate"

/obj/structure/largecrate/black_market/secured_wildlife/unpack()
	//We need to pick a 'secured wildlife' mob that actually makes sense.
	var/unfit_simplemobs = list(/mob/living/simple_animal/drone)
	var/fit_hostiles = list(/mob/living/simple_animal/hostile/giant_spider, /mob/living/simple_animal/hostile/bear, /mob/living/simple_animal/hostile/retaliate/malf_drone, /mob/living/simple_animal/hostile/retaliate/goat)
	var/monkey_mobs = list(/mob/living/carbon/human/monkey, /mob/living/carbon/human/farwa, /mob/living/carbon/human/stok, /mob/living/carbon/human/yiren, /mob/living/carbon/human/neaera)
	var/mob/contained_mob_type = pick( ( subtypesof(/mob/living/simple_animal) - typesof(/mob/living/simple_animal/hostile) ) + fit_hostiles + monkey_mobs - unfit_simplemobs)
	new contained_mob_type(loc)
	. = ..()

/datum/supply_packs/contraband/miscellaneous/potted_plant
	name = "potted plant crate"
	dollar_cost = 50
	contains = list(/obj/structure/flora/pottedplant/random/unanchored)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/miscellaneous/cargo_tug
	name = "cargo tug crate"
	dollar_cost = 50
	contains = list(/obj/vehicle/train/cargo/engine)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/miscellaneous/clf_supplies
	name = "unmarked CLF supply crate"
	dollar_cost = 40
	contains = list()
	containertype = /obj/structure/largecrate/black_market/clf_supplies

/obj/structure/largecrate/black_market/clf_supplies
	name = "unmarked CLF supply crate"
	desc = "What's in the box? Only one way to find out!"
	icon_state = "chest"
	/// If you want to use this in mapping, you can force-set the contents via this.
	var/forced_rng

/obj/structure/largecrate/black_market/clf_supplies/unpack()
	var/loot_luck = rand(1, 100)
	if(forced_rng)
		loot_luck = forced_rng
	var/loot_message
	switch(loot_luck)
		if(1 to 5)
		// Random sheets! Could be iron, could be diamonds.
			for(var/i in 1 to 5)
				var/sheet_type = pick(subtypesof(/obj/item/stack/sheet))
				var/obj/item/stack/sheet/sheet_stack = new sheet_type(loc)
				if(sheet_stack.amount == 1)
					sheet_stack.amount = rand(1, 5)
			loot_message = SPAN_NOTICE("Oh sheet, it's a bunch of sheets!")
		if(6 to 10)
		// Elite recovered gear.
			var/list/armor_to_pick = list(
				// Y8 Miner (default)
				/obj/item/clothing/under/marine/veteran/mercenary/miner,
				/obj/item/clothing/suit/storage/marine/veteran/mercenary/miner,
				/obj/item/clothing/head/helmet/marine/veteran/mercenary/miner,
				// K12 Ceramic (Heavy-ish)
				/obj/item/clothing/under/marine/veteran/mercenary,
				/obj/item/clothing/suit/storage/marine/veteran/mercenary,
				/obj/item/clothing/head/helmet/marine/veteran/mercenary,
				// Z7 Support (Support)
				/obj/item/clothing/under/marine/veteran/mercenary,
				/obj/item/clothing/suit/storage/marine/veteran/mercenary/support,
				/obj/item/clothing/head/helmet/marine/veteran/mercenary/support/engineer
				// You get three random pieces. If you want to complete the set you need to keep rolling the dice!
			)
			for(var/i in 1 to 3)
				var/picked_type = pick(armor_to_pick)
				new picked_type(loc)
			loot_message = SPAN_NOTICE("It's some strange elite gear...?")
		if(11 to 15)
			//Skorpion
			new /obj/item/weapon/gun/pistol/skorpion(loc)
			new /obj/item/ammo_magazine/pistol/skorpion(loc)
			new /obj/item/ammo_magazine/pistol/skorpion(loc)
			new /obj/item/ammo_magazine/pistol/skorpion(loc)
			// Somehow they found a Webley.
			new /obj/item/weapon/gun/revolver/m44/custom/webley(loc)
			new /obj/item/ammo_magazine/revolver/webley(loc)
			new /obj/item/ammo_magazine/revolver/webley(loc)
			new /obj/item/ammo_magazine/revolver/webley(loc)
			loot_message = SPAN_NOTICE("It's some CLF pistol armaments!")
		if(16 to 20)
			// PPSH
			new /obj/item/weapon/gun/smg/ppsh/with_drum_mag(loc)
			new /obj/item/ammo_magazine/smg/ppsh/extended(loc)
			new /obj/item/ammo_magazine/smg/ppsh/extended(loc)
			new /obj/item/ammo_magazine/smg/ppsh/extended(loc)
			// MAC-15
			new /obj/item/weapon/gun/smg/mac15/extended(loc)
			new /obj/item/ammo_magazine/smg/mac15/extended(loc)
			new /obj/item/ammo_magazine/smg/mac15/extended(loc)
			new /obj/item/ammo_magazine/smg/mac15/extended(loc)
			loot_message = SPAN_NOTICE("It's some CLF SMG armaments.")
		if(21 to 25)
			// Discovered Yautja ruins.. (None of these will trigger any alarms. They are far too old, degraded, and useless for any Yautja to care.)
			new /obj/item/clothing/mask/gas/yautja/damaged(loc)
			new /obj/item/clothing/suit/armor/yautja_flavor(loc)
			new /obj/item/clothing/shoes/yautja_flavor(loc)
			new /obj/item/weapon/melee/twohanded/yautja/glaive/damaged(loc)
			new /obj/item/stack/yautja_rope(loc)
			loot_message = SPAN_NOTICE("It's some strange ancient gear...?")
		if(26 to 30)
			// Dutch gear.
			new /obj/item/storage/pouch/medical/socmed/dutch/unmarked(loc)
			new /obj/item/storage/large_holster/machete/arnold/full(loc)
			new /obj/item/clothing/head/helmet/marine/veteran/dutch/cap(loc)
			loot_message = SPAN_NOTICE("It's some dusty, old equipment. Smells like the jungle.")
		if(31 to 35)
		// Damaged lunge mines, don't let the marines near these. Not even *close* to effective against even a runner.
			new /obj/item/weapon/melee/twohanded/lungemine/damaged(loc)
			new /obj/item/weapon/melee/twohanded/lungemine/damaged(loc)
			new /obj/item/weapon/melee/twohanded/lungemine/damaged(loc)
			loot_message = SPAN_NOTICE("It's a bunch of lunge mines..?")
		if(36 to 40)
		// CLF nades!
			loot_message = SPAN_NOTICE("It's a package of assorted CLF grenades!")
			var/list/nades_to_pick = list(
				/obj/item/explosive/grenade/empgrenade,
				/obj/item/explosive/grenade/custom/ied,
				/obj/item/explosive/grenade/incendiary/molotov,
				/obj/item/explosive/grenade/custom/ied_incendiary,
				/obj/item/explosive/grenade/phosphorus/clf,
				/obj/item/explosive/grenade/smokebomb,
				/obj/item/explosive/grenade/smokebomb/airburst,
				/obj/item/explosive/grenade/custom/antiweed
			)
			for(var/i in 1 to 4)
				var/picked_type = pick(nades_to_pick)
				var/obj/item/explosive/grenade/new_nade = new picked_type(loc)
				if(new_nade.hand_throwable && prob(7))
					loot_message = SPAN_HIGHDANGER("It was booby trapped! RUN!")
					new_nade.prime()
		if(41 to 45)
		// Molotovs and supplies to make more...
			new /obj/item/explosive/grenade/incendiary/molotov(loc)
			new /obj/item/explosive/grenade/incendiary/molotov(loc)
			new /obj/item/paper_bin(loc)
			new /obj/item/reagent_container/food/drinks/bottle/whiskey(loc)
			new /obj/item/reagent_container/food/drinks/bottle/kahlua(loc)
			new /obj/item/reagent_container/food/drinks/bottle/rum(loc)
			loot_message = SPAN_NOTICE("It's a bunch of finished and unfinished molotovs.")
		if(46 to 50)
		// Spare CLF gear!
			new /obj/effect/essentials_set/random/clf_shoes(loc)
			new /obj/item/clothing/under/colonist/clf(loc)
			new /obj/effect/essentials_set/random/clf_armor(loc)
			new /obj/effect/essentials_set/random/clf_gloves(loc)
			new /obj/effect/essentials_set/random/clf_head(loc)
			new /obj/effect/essentials_set/random/clf_belt(loc)
			loot_message = SPAN_NOTICE("It's a spare set of CLF equipment. You probably shouldn't wear this...")
		// That was the good 50%. Now it's time for the bad.
		if(51 to 60)
		// Random junk
			new /obj/effect/essentials_set/random/clf_bonus_item(loc)
			new /obj/effect/essentials_set/random/clf_bonus_item(loc)
			new /obj/effect/essentials_set/random/clf_bonus_item(loc)
			new /obj/effect/essentials_set/random/clf_bonus_item(loc)
			new /obj/effect/essentials_set/random/clf_bonus_item(loc)
			loot_message = SPAN_NOTICE("It's a bunch of random junk...")
		if(61 to 70)
			new /obj/effect/spawner/random/bomb_supply(loc)
			new /obj/effect/spawner/random/bomb_supply(loc)
			new /obj/effect/spawner/random/toolbox(loc)
			new /obj/effect/spawner/random/tool(loc)
			new /obj/effect/spawner/random/tool(loc)
			new /obj/effect/spawner/random/attachment(loc)
			if(prob(33))
				new /obj/effect/spawner/random/supply_kit(loc)
			else
				new /obj/effect/spawner/random/attachment(loc)
			loot_message = SPAN_NOTICE("Just some old equipment and parts.")
		if(71 to 75)
			// backpacks
			for(var/i in 1 to rand(3, 6))
				var/pack_type = pick(subtypesof(/obj/item/storage/backpack))
				var/obj/item/storage/backpack/pack = new pack_type(loc)
				if(pack.max_storage_space > 15)
					pack.max_storage_space = 15
			loot_message = SPAN_NOTICE("Some backpacks. They all look empty though...")
		if(76 to 80)
		// CLF corpse!! Why is this here? Don't ask.
			var/mob/living/carbon/human/corpse = new (loc)
			corpse.create_hud() //Need to generate hud before we can equip anything apparently...

			var/corpse_type = pick(/datum/equipment_preset/corpse/clf/burst, /datum/equipment_preset/corpse/clf)
			arm_equipment(corpse, corpse_type, TRUE, FALSE) // I didn't choose the shitcode life, the shitcode life chose me

			loot_message = SPAN_HIGHDANGER("IT'S A CORPSE!!")
		if(81 to 85)
		// Costumes.
			new /obj/effect/landmark/costume/random(loc)
			new /obj/effect/landmark/costume/random(loc)
			new /obj/effect/landmark/costume/random(loc)
			loot_message = SPAN_NOTICE("What the hell is this..?")
		if(86 to 90)
		// Random supply garbage.
			new /obj/effect/spawner/random/tool(loc)
			new /obj/effect/spawner/random/tool(loc)
			new /obj/effect/spawner/random/tech_supply(loc)
			new /obj/effect/spawner/random/tech_supply(loc)
			new /obj/effect/spawner/random/tech_supply(loc)
			new /obj/effect/spawner/random/toy(loc)
			new /obj/effect/spawner/random/toy(loc)
			new /obj/effect/spawner/random/toy(loc)
			loot_message = SPAN_NOTICE("It's just a bunch of junk!")
		if(91 to 95)
		// We don't really have any other kind of booby trap so this will do
			new /obj/item/explosive/grenade/spawnergrenade/claymore_launcher(loc)
			loot_message = SPAN_HIGHDANGER("It was booby trapped! RUN!")
		if(96 to 99)
		// Oh boy. Big booby trap!
			var/obj/item/mortar_shell/frag/fragshell = new(loc)
			var/obj/item/explosive/grenade/incendiary/molotov/molotov = new(loc)
			molotov.prime()
			fragshell.balloon_alert_to_viewers("the mortar shell makes an awful hissing noise!")
			addtimer(CALLBACK(fragshell, TYPE_PROC_REF(/obj/item/mortar_shell/frag, detonate), loc), 5 SECONDS)
			QDEL_IN(fragshell, 5.5 SECONDS)
			loot_message = SPAN_HIGHDANGER("RUN!!!")
		if(100)
		// You got real fuckin' unlucky kid :joker:
			new /obj/item/explosive/grenade/spawnergrenade/claymore_launcher(loc)
			new /obj/item/explosive/grenade/spawnergrenade/claymore_launcher(loc)
			new /obj/item/explosive/grenade/spawnergrenade/claymore_launcher(loc)
			loot_message = SPAN_HIGHDANGER("It was SUPER booby trapped! RUN!")

	visible_message(loot_message, max_distance = 4)
	return ..()
