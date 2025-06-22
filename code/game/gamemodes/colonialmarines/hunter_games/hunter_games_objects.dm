/// Objects for the hunter games mode

/** /datum/game_mode/hunter_games/proc/place_drop(turf/spawn_turf, type)
 * Spawn a melee weapon on the provided turf from the PLACEHOLDER_PUT_LIST_HERE
 *
 * args:
 * turf/spawn_turf - The turf to place the weapon on.
 * type - the type of item to place at the location
 */

/datum/game_mode/hunter_games/proc/place_drop(turf/spawn_turf, type)
	world << "DEBUG DEBUG DEBUG HUNTER GAMES PLACE DROP CALLED BUT DOESNT DO SHIT"

/obj/item/storage/pouch/survival/hunter_games
	name = "survival pouch"
	desc = "It's all you woke up with..."
	icon_state = "tools"
	storage_slots = 5
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/device/flashlight,
		/obj/item/tool/crowbar,
		/obj/item/storage/pill_bottle/packet,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/splint,
	)

/obj/item/storage/pouch/survival/hunter_games/full/fill_preset_inventory()
	new /obj/item/device/flashlight(src)
	new /obj/item/tool/crowbar/red(src)
	new /obj/item/storage/pill_bottle/packet/tricordrazine(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/splint(src)





// old list of items

#define HUNTER_BEST_ITEM  pick(\
								75; list(/obj/item/clothing/glasses/night, /obj/item/storage/backpack/holding, /obj/item/storage/belt/grenade/full, /obj/item/weapon/gun/flamer/m240), \
								100; list(/obj/item/weapon/twohanded/yautja/glaive, /obj/item/clothing/mask/gas/yautja/hunter, /obj/item/clothing/suit/armor/yautja/hunter,/obj/item/clothing/shoes/yautja/hunter), \
								50; list(/obj/item/weapon/yautja/chained/combistick, /obj/item/clothing/mask/gas/yautja/hunter, /obj/item/clothing/suit/armor/yautja/hunter/full,/obj/item/clothing/shoes/yautja/hunter), \
								150; list(/obj/item/stack/medical/advanced/ointment, /obj/item/stack/medical/advanced/bruise_pack, /obj/item/storage/belt/medical/lifesaver/full), \
								50; list(/obj/item/clothing/under/marine/veteran/pmc/apesuit, /obj/item/clothing/suit/storage/marine/veteran/pmc/apesuit, /obj/item/clothing/gloves/marine/veteran/pmc/apesuit, /obj/item/clothing/shoes/veteran/pmc/commando, /obj/item/clothing/head/helmet/marine/veteran/pmc/apesuit), \
								125; list(/obj/item/weapon/yautja/chain, /obj/item/weapon/yautja/knife, /obj/item/weapon/yautja/scythe, /obj/item/hunting_trap, /obj/item/hunting_trap), \
								75; list(/obj/item/weapon/gun/revolver/mateba/general, /obj/item/ammo_magazine/revolver/mateba, /obj/item/ammo_magazine/revolver/mateba, /obj/item/clothing/mask/balaclava/tactical), \
								50; list(/obj/item/weapon/shield/energy, /obj/item/weapon/energy/axe, /obj/item/clothing/under/chainshirt/hunter, /obj/item/clothing/head/helmet/gladiator, /obj/item/clothing/suit/armor/gladiator) \
								)

#define HUNTER_GOOD_ITEM  pick(\
								50; /obj/item/weapon/shield/riot, \
								100; /obj/item/weapon/sword, \
								100; /obj/item/weapon/sword/katana, \
								100; /obj/item/weapon/harpoon/yautja, \
								150; /obj/item/weapon/sword, \
								200; /obj/item/weapon/sword/machete, \
								125; /obj/item/weapon/twohanded/fireaxe, \
\
								100; /obj/item/device/binoculars, \
\
								50; /obj/item/device/flash, \
								25; /obj/item/explosive/grenade/flashbang, \
								25; /obj/item/hunting_trap, \
								50; /obj/item/explosive/plastic, \
								100; /obj/item/explosive/grenade/high_explosive, \
								100; /obj/item/explosive/grenade/high_explosive/frag, \
								100; /obj/item/explosive/grenade/incendiary, \
\
								170; /obj/item/clothing/suit/armor/vest/security, \
								165; /obj/item/clothing/head/helmet/riot, \
								160; /obj/item/clothing/gloves/marine/veteran/pmc, \
\
								50; /obj/item/storage/firstaid/regular, \
								50; /obj/item/storage/firstaid/fire, \
								75; /obj/item/storage/box/mre/wy, \
\
								100; /obj/item/storage/backpack/pmc/backpack/commando/apesuit, \
								100; /obj/item/storage/backpack/yautja, \
								100; /obj/item/storage/belt/knifepouch, \
								100; /obj/item/storage/belt/utility/full, \
								100; /obj/item/clothing/accessory/storage/webbing, \
								)

#define HUNTER_OKAY_ITEM  pick(\
								300; /obj/item/tool/crowbar, \
								200; /obj/item/weapon/baseballbat, \
								100; /obj/item/weapon/baseballbat/metal, \
								100; /obj/item/weapon/butterfly, \
								300; /obj/item/tool/hatchet, \
								100; /obj/item/tool/scythe, \
								100; /obj/item/tool/kitchen/knife/butcher, \
								50; /obj/item/weapon/sword/katana/replica, \
								100; /obj/item/weapon/harpoon, \
								75; /obj/item/attachable/bayonet, \
								200; /obj/item/weapon/throwing_knife, \
								400; /obj/item/weapon/twohanded/spear, \
\
								250; /obj/item/device/flashlight/flare, \
								75; /obj/item/device/flashlight, \
								75; /obj/item/device/flashlight/combat, \
\
								25; /obj/item/bananapeel, \
								25; /obj/item/tool/soap, \
\
								75; /obj/item/stack/medical/bruise_pack, \
								75; /obj/item/stack/medical/ointment, \
								75; /obj/item/reagent_container/food/snacks/donkpocket, \
\
								100; /obj/item/cell/high, \
								100; /obj/item/tool/wirecutters, \
								100; /obj/item/tool/weldingtool, \
								100; /obj/item/tool/wrench, \
								100; /obj/item/device/multitool, \
								75; /obj/item/storage/pill_bottle/tramadol, \
								50; /obj/item/explosive/grenade/smokebomb, \
								50; /obj/item/explosive/grenade/empgrenade, \
								100; /obj/item/storage/backpack, \
								100; /obj/item/storage/backpack/cultpack, \
								100; /obj/item/storage/backpack/satchel, \
								75; /obj/item/clothing/gloves/brown, \
								100; /obj/item/clothing/suit/storage/CMB \
								)
