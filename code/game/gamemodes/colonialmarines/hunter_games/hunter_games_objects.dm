/// Objects for the hunter games mode

/obj/item/storage/pouch/survival/hunter_games // missing the knife, radio, and light
	name = "survival pouch"
	desc = "It's all you woke up with..."
	icon_state = "tools"
	storage_slots = 4
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
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/splint(src)


/// Melee weapons scattered around the map at melee_weapon landmarks, Common.
#define HUNTER_MELEE_ITEM list(\
	/obj/item/weapon/baseballbat, \
	/obj/item/weapon/baseballbat/metal, \
	/obj/item/weapon/butterfly, \
	/obj/item/tool/hatchet, \
	/obj/item/weapon/twohanded/spear, \
	/obj/item/tool/scythe, \
	/obj/item/tool/kitchen/knife/butcher, \
	/obj/item/attachable/bayonet, \
	)


#define HUNTER_BEST_ITEM  pick(\
	/obj/item/weapon/gun/shotgun/double/damaged, \
	/obj/item/clothing/glasses/night, \
	/obj/item/storage/belt/grenade/full, \
	/obj/item/weapon/gun/flamer/m240, \
	/obj/item/weapon/twohanded/yautja/glaive, \
	/obj/item/clothing/mask/gas/yautja/hunter, \
	/obj/item/clothing/suit/armor/yautja/hunter, \
	/obj/item/clothing/shoes/yautja/hunter, \
	/obj/item/weapon/yautja/chained/combistick, \
	/obj/item/clothing/mask/gas/yautja/hunter, \
	/obj/item/clothing/suit/armor/yautja/hunter/full, \
	/obj/item/clothing/shoes/yautja/hunter, \
	/obj/item/stack/medical/advanced/ointment, \
	/obj/item/stack/medical/advanced/bruise_pack, \
	/obj/item/storage/belt/medical/lifesaver/full, \
	/obj/item/clothing/under/marine/veteran/pmc/apesuit, \
	/obj/item/clothing/suit/storage/marine/veteran/pmc/apesuit, \
	/obj/item/clothing/gloves/marine/veteran/pmc/apesuit, \
	/obj/item/clothing/shoes/veteran/pmc/commando, \
	/obj/item/clothing/head/helmet/marine/veteran/pmc/apesuit, \
	/obj/item/weapon/yautja/chain, \
	/obj/item/weapon/yautja/knife, \
	/obj/item/weapon/yautja/scythe, \
	/obj/item/hunting_trap, \
	/obj/item/weapon/gun/revolver/mateba/general, \
	/obj/item/ammo_magazine/revolver/mateba, \
	/obj/item/ammo_magazine/revolver/mateba, \
	/obj/item/clothing/mask/balaclava/tactical, \
	/obj/item/weapon/shield/energy, \
	/obj/item/weapon/energy/axe, \
	/obj/item/clothing/under/chainshirt/hunter, \
	/obj/item/clothing/head/helmet/gladiator, \
	/obj/item/clothing/suit/armor/gladiator, \
	)

#define HUNTER_GOOD_ITEM  list(\
	/obj/item/weapon/shield/riot, \
	/obj/item/weapon/sword, \
	/obj/item/weapon/sword/katana, \
	/obj/item/weapon/harpoon/yautja, \
	/obj/item/weapon/sword, \
	/obj/item/weapon/sword/machete, \
	/obj/item/weapon/twohanded/fireaxe, \
\
	/obj/item/device/binoculars, \
\
	/obj/item/explosive/grenade/flashbang, \
	/obj/item/hunting_trap, \
	/obj/item/explosive/plastic, \
	/obj/item/explosive/grenade/high_explosive, \
	/obj/item/explosive/grenade/high_explosive/frag, \
	/obj/item/explosive/grenade/incendiary, \
\
	/obj/item/clothing/suit/armor/vest/security, \
	/obj/item/clothing/head/helmet/riot, \
	/obj/item/clothing/gloves/marine/veteran/pmc, \
	/obj/item/clothing/glasses/hud/sensor, \
\
	/obj/item/storage/firstaid/regular, \
	/obj/item/storage/firstaid/fire, \
	/obj/item/storage/box/mre/wy, \
\
	/obj/item/storage/backpack/pmc/backpack/commando/apesuit, \
	/obj/item/storage/backpack/yautja, \
	/obj/item/storage/backpack/holding, \
	/obj/item/storage/belt/knifepouch, \
	/obj/item/storage/belt/utility/full, \
	)

#define HUNTER_OKAY_ITEM  list(\
\
	/obj/item/device/flashlight/combat, \
	/obj/item/device/binoculars, \
\
	/obj/item/storage/pouch/firstaid/ert, \
	/obj/item/stack/medical/bruise_pack, \
	/obj/item/stack/medical/ointment, \
	/obj/item/reagent_container/food/snacks/donkpocket, \
\
	/obj/item/storage/pill_bottle/tramadol, \
	/obj/item/explosive/grenade/smokebomb, \
	/obj/item/explosive/grenade/empgrenade, \
	/obj/item/storage/backpack, \
	/obj/item/storage/backpack/cultpack, \
	/obj/item/storage/backpack/satchel, \
	/obj/item/clothing/gloves/brown, \
	/obj/item/clothing/suit/storage/CMB, \
	/obj/item/clothing/accessory/storage/webbing, \
	)



/** /datum/game_mode/hunter_games/proc/place_drop(turf/spawn_turf, type)
 * Spawn a melee weapon on the provided turf picked from the HUNTER_X_ITEM defines.
 *
 * args:
 * turf/spawn_turf - The turf to place the weapon on, required
 * type - the type of item to place at the location, defaults to DROP_MELEE_WEAPON
 */

/datum/game_mode/hunter_games/proc/place_drop(turf/spawn_turf, type = DROP_MELEE_WEAPON)
	switch(type)
		if(DROP_MELEE_WEAPON)
			var/picked = pick(HUNTER_MELEE_ITEM)
			new picked(spawn_turf)

		if(DROP_GOOD_ITEM)
			var/rng = rand(1, 100)
			var/picked = /obj/item/toy/bikehorn

			switch(rng)
				if(1 to 33) // 33% chance of nothing.
					return
				if(34 to 66) // 32% chance of a decent item.
					picked = pick(HUNTER_OKAY_ITEM)
				if(67 to 89) // 22% chance of a good item.
					picked = pick(HUNTER_GOOD_ITEM)
				if(90 to 100) // 10% chance of something wacky.
					picked = pick(HUNTER_BEST_ITEM)

			var/obj/structure/closet/crate/explosives/crate = new(spawn_turf)
			new picked(crate)

