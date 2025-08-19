/// Objects for the hunter games mode

/obj/item/storage/pouch/survival/hunter_games // missing the knife, radio, and light, + painkillers
	name = "survival pouch"
	desc = "It's all you woke up with..."
	icon_state = "tools"
	storage_slots = 6
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/tool/crowbar,
		/obj/item/storage/pill_bottle/packet,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/splint,
	)

/obj/item/storage/pouch/survival/hunter_games/full/fill_preset_inventory()
	new /obj/item/tool/crowbar/red(src)
	new /obj/item/storage/pill_bottle/packet/tricordrazine(src)
	new /obj/item/storage/pill_bottle/packet/oxycodone(src)
	new /obj/item/storage/pill_bottle/packet/bicaridine(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/splint(src)


/// Melee weapons scattered around the map at melee_weapon landmarks, Common. Damage target is ~25 for these items.
#define HUNTER_MELEE_ITEM list(\
	/obj/item/weapon/baseballbat, \
	/obj/item/weapon/butterfly, \
	/obj/item/tool/hatchet, \
	/obj/item/tool/scythe, \
	/obj/item/tool/kitchen/knife/butcher, \
	/obj/item/attachable/bayonet, \
	/obj/item/weapon/pole, \
	/obj/item/weapon/classic_baton, \
	/obj/item/weapon/twohanded/breacher, \
	/obj/item/weapon/ice_axe, \
	/obj/item/weapon/harpoon, \
	/obj/item/tool/crowbar/tactical, \
	/obj/item/tool/kitchen/knife/butcher, \
	/obj/item/tool/kitchen/knife, \
	)


/// 10% chance on a spawner, This is where the wacky stuff goes; wacky =/= unfun for everyone else though, we want interesting items not ones that trivialize the mode.
#define HUNTER_BEST_ITEM  pick(\
	/obj/item/weapon/gun/shotgun/double/damaged, \
\
	/obj/item/large_shrapnel/at_rocket_dud, \
	/obj/item/tool/kitchen/pizzacutter/holyrelic, \
	/obj/item/reagent_container/food/snacks/wrapped/chunk/hunk, \
	/obj/item/prop/folded_anti_tank_sadar, \
	/obj/item/weapon/twohanded/lungemine, \
\
	/obj/item/weapon/twohanded/yautja/glaive, \
	/obj/item/weapon/yautja/chained/war_axe, \
	/obj/item/weapon/yautja/chained/combistick, \
	/obj/item/weapon/yautja/chain, \
	/obj/item/weapon/yautja/scythe, \
	/obj/item/weapon/yautja/sword, \
\
	/obj/item/weapon/shield/riot/metal, \
\
	/obj/item/explosive/grenade/high_explosive/pmc, \
	/obj/item/storage/box/packet/m15, \
\
	/obj/item/clothing/head/helmet/marine/veteran/dutch, \
\
	/obj/item/storage/backpack/holding, \
	/obj/item/storage/backpack/pmc/backpack/commando/apesuit, \
	/obj/item/storage/backpack/yautja, \
\
	/obj/item/clothing/gloves/marine/veteran/pmc/apesuit, \
	/obj/item/clothing/shoes/veteran/pmc/commando, \
	/obj/item/clothing/head/helmet/marine/veteran/pmc/apesuit, \
	/obj/item/clothing/mask/balaclava/tactical, \
	/obj/item/clothing/under/chainshirt/hunter, \
	/obj/item/clothing/head/helmet/gladiator, \
	/obj/item/clothing/suit/armor/gladiator, \
\
	/obj/item/device/motiondetector/m717/hacked, \
\
	/obj/item/storage/belt/grenade/full, \
\
	/obj/item/clothing/mask/gas/yautja/hunter, \
	/obj/item/clothing/shoes/yautja/hunter, \
\
	/obj/item/stack/medical/advanced/ointment/upgraded, \
	/obj/item/stack/medical/advanced/bruise_pack/upgraded, \
\
	/obj/item/hunting_trap, \
	)

/// 22% chance on a spawner, This is mostly upgraded weapons, and armor-- Still should be mostly melee, damage target for these is ~45.
#define HUNTER_GOOD_ITEM  list(\
	/obj/item/weapon/shield/riot, \
\
	/obj/item/weapon/sword/katana, \
	/obj/item/storage/large_holster/katana/full, \
	/obj/item/weapon/twohanded/fireaxe, \
	/obj/item/weapon/ritual, \
\
	/obj/item/storage/box/packet/hefa, \
	/obj/item/storage/box/packet/rmc/he, \
	/obj/item/storage/box/packet/rmc/incin, \
	/obj/item/explosive/grenade/custom/ied_incendiary, \
\
	/obj/item/storage/pouch/explosive/emp_dutch, \
	/obj/item/storage/pouch/medkit/full_rmc_officer_aid, \
	/obj/item/storage/pouch/explosive/full, \
	/obj/item/storage/pouch/explosive/upp, \
	/obj/item/storage/pouch/tools/tactical/full, \
	/obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, \
\
	/obj/item/clothing/head/helmet/marine, \
	/obj/item/clothing/head/helmet/riot, \
	/obj/item/clothing/head/helmet/marine/veteran/royal_marine, \
	/obj/item/clothing/head/freelancer, \
	/obj/item/clothing/head/helmet/marine/veteran/UPP, \
	/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate, \
	/obj/item/clothing/mask/gas/pmc, \
\
	/obj/item/clothing/suit/armor/vest/security, \
	/obj/item/clothing/suit/storage/marine/light/vest, \
	/obj/item/clothing/suit/armor/vest, \
\
	/obj/item/clothing/glasses/hud/sensor, \
\
	/obj/item/clothing/gloves/marine/veteran, \
	/obj/item/clothing/gloves/marine/veteran/pmc, \
	/obj/item/clothing/gloves/marine/veteran/upp, \
	/obj/item/clothing/gloves/combat, \
	/obj/item/clothing/gloves/marine, \
\
	/obj/item/clothing/shoes/marine/jungle/knife, \
	/obj/item/clothing/shoes/veteran/pmc/knife, \
	/obj/item/clothing/shoes/combat, \
	/obj/item/clothing/shoes/marine/knife, \
\
	/obj/item/storage/backpack/rmc/light, \
	/obj/item/storage/backpack/lightpack, \
\
	/obj/item/storage/belt/medical/lifesaver/upp/full, \
	/obj/item/storage/belt/utility/full, \
	/obj/item/storage/belt/medical/full/with_defib_and_analyzer, \
	/obj/item/storage/belt/medical/lifesaver/full, \
\
	/obj/item/device/motiondetector/hacked, \
	)

/// 32% chance on a spawner, This is mostly utility stuff, meds, binocs, better lights, inventory stuff like pouches, webbings, etc. Damage target ~35
#define HUNTER_OKAY_ITEM  list(\
	/obj/item/device/flashlight/combat, \
	/obj/item/device/flashlight/slime, \
	/obj/item/device/flashlight/lantern, \
	/obj/item/device/flashlight/lantern/yautja, \
\
	/obj/item/device/binoculars, \
\
	/obj/item/weapon/yautja/duelaxe, \
	/obj/item/weapon/yautja/duelknife, \
	/obj/item/tool/pickaxe, \
	/obj/item/tool/shovel/etool, \
	/obj/item/weapon/sword, \
	/obj/item/weapon/sword/machete, \
	/obj/item/weapon/butterfly, \
	/obj/item/weapon/butterfly/switchblade, \
	/obj/item/weapon/baseballbat/metal, \
	/obj/item/weapon/yautja/duelclub, \
	/obj/item/weapon/yautja/duelsword, \
	/obj/item/weapon/yautja/knife, \
	/obj/item/maintenance_jack, \
	/obj/item/weapon/sword/claymore, \
	/obj/item/storage/large_holster/ceremonial_sword/full, \
\
	/obj/item/storage/box/packet/high_explosive, \
	/obj/item/storage/box/packet/incendiary, \
	/obj/item/storage/box/packet/foam, \
	/obj/item/storage/box/packet/smoke, \
	/obj/item/explosive/grenade/empgrenade, \
	/obj/item/explosive/plastic/breaching_charge, \
	/obj/item/explosive/plastic, \
	/obj/item/explosive/grenade/incendiary/molotov, \
\
	/obj/item/storage/box/mre/fsr, \
	/obj/item/storage/box/mre/twe, \
	/obj/item/storage/box/mre/wy, \
	/obj/item/storage/box/mre/pmc, \
	/obj/item/storage/box/mre/upp, \
	/obj/item/mre_food_packet/clf, \
\
	/obj/item/storage/pouch/firstaid/full, \
	/obj/item/storage/pouch/medical/full, \
	/obj/item/storage/pouch/medkit/full, \
	/obj/item/storage/pouch/autoinjector/full, \
	/obj/item/storage/pouch/general/large, \
	/obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, \
	/obj/item/storage/pouch/flare/full, \
	/obj/item/storage/pouch/general/medium, \
	/obj/item/storage/pouch/construction/low_grade_full, \
\
	/obj/item/storage/syringe_case/rmc, \
	/obj/item/storage/box/m94, \
\
	/obj/item/storage/backpack, \
	/obj/item/storage/backpack/satchel, \
\
	/obj/item/storage/backpack/general_belt, \
\
	/obj/item/clothing/suit/storage/CMB, \
	/obj/item/clothing/gloves/yellow, \
	/obj/item/clothing/head/militia/bucket, \
	/obj/item/clothing/head/helmet/swat, \
	/obj/item/clothing/suit/storage/webbing/brown, \
	/obj/item/clothing/head/helmet/marine/veteran/UPP/army, \
\
	/obj/item/clothing/accessory/storage/webbing, \
	/obj/item/clothing/accessory/storage/droppouch, \
	)



/** /datum/game_mode/hunter_games/proc/place_drop(turf/spawn_turf, type)
 * Spawn a loot item on the provided turf
 *
 * args:
 * spawn_loc - The place to place the drop, required
 * type - the type of item to place at the location, defaults to DROP_MELEE_WEAPON
 * drop_type - the method used to place the drop, default HUNTER_DROP_RAW which places it directly on the provided loc.
 */

/datum/game_mode/hunter_games/proc/place_drop(spawn_loc, type = DROP_MELEE_WEAPON, drop_type = HUNTER_DROP_RAW)
	var/obj/item/picked = /obj/item/toy/bikehorn
	switch(type)
		if(DROP_MELEE_WEAPON)
			picked = pick(HUNTER_MELEE_ITEM)

		if(DROP_GOOD_ITEM)
			var/rng = rand(0, 100)
			switch(rng)
				if(0 to 49) // 50% chance of a decent item.
					picked = pick(HUNTER_OKAY_ITEM)
				if(50 to 89) // 32% chance of a good item.
					picked = pick(HUNTER_GOOD_ITEM)
				if(90 to 100) // 10% chance of something wacky.
					picked = pick(HUNTER_BEST_ITEM)

	switch(drop_type)
		if(HUNTER_DROP_RAW)
			new picked(spawn_loc)
		if(HUNTER_DROP_CRATE)
			var/obj/structure/closet/crate/explosives/crate = new(spawn_loc)
			new picked(crate)
		if(HUNTER_DROP_POD)
			var/obj/structure/droppod/hunter_games/pod = new
			new picked(pod)
			pod.launch(spawn_loc)


/obj/structure/droppod/hunter_games/open() // no pre-existing type that has the behavior we want
	. = ..()
	for(var/atom/movable/content as anything in contents)
		content.forceMove(loc)
