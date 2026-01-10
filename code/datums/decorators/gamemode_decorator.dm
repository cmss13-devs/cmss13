#define GAMEMODE_DECORATOR(type, mode, list_edits) \
/datum/decorator/gamemode##type##mode { \
	gamemode = mode; \
	apply_type = type; \
	edits = list_edits; \
}

#define VARIABLE_EDIT(type, variable, value) nameof(type::variable) = value
#define ARMOR_EDIT(variable, value) VARIABLE_EDIT(/obj/item/clothing/suit/storage/marine, variable, value)
#define GUN_EDIT(variable, value) VARIABLE_EDIT(/obj/item/weapon/gun, variable, value)
#define AMMO_EDIT(variable, value) VARIABLE_EDIT(/obj/item/ammo_magazine, variable, value)

/**
 * Gamemode decorators allow us to make changes to edits on specific gamemodes,
 * to assist in balancing varied gameplay in different modes
 *
 * They can be manually defined, and procs overridden. Alternatively,
 * using the GAMEMODE_DECORATOR define, you can quickly make a decorator for
 * a specific type and subtypes.
 *
 * eg:
 * ```
 * GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/smartgunner, /datum/game_mode/extended/faction_clash, list(
 *   ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
 *   ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
 *   ))
 * ```
 *
 * If you need to edit different types, make a new define using VARIABLE_EDIT, and provide the parent path for the type.
 */
/datum/decorator/gamemode
	/// The gamemode type this should apply to
	var/gamemode

	/// Which type this should apply edits to
	var/apply_type

	/// The list of edits to make
	var/list/edits

/datum/decorator/gamemode/get_decor_types()
	return typesof(apply_type)

/datum/decorator/gamemode/decorate(atom/object)
	for(var/edit in edits)
		object.vars[edit] = edits[edit]

//*********************** Human Versus Human ***********************//
//************ USCM Armour Values ************//

//**** Medium Armor ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/medium, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
	ARMOR_EDIT(armor_bomb, CLOTHING_ARMOR_MEDIUM),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

//**** Light Armor ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/light, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_MEDIUM),
	ARMOR_EDIT(armor_bomb, CLOTHING_ARMOR_MEDIUMLOW),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_MEDIUMHIGH)
))

//**** Heavy Armor ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/heavy, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

//**** Smartgunner ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/smartgunner, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

//**** Military Police and Command ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/MP, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
	ARMOR_EDIT(armor_bomb, CLOTHING_ARMOR_MEDIUMHIGH),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

//**** B18 Spec Armor ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/specialist, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGHPLUS),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGHPLUS)
))

//**** Grenadier Spec Armor ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/M3G, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

//**** RPG Spec Armor ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/M3T, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

//**** Scout Spec Armor ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/M3S, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
	ARMOR_EDIT(armor_bomb, CLOTHING_ARMOR_MEDIUM),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

//**** Sniper Spec Armor ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/ghillie, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
	ARMOR_EDIT(armor_bomb, CLOTHING_ARMOR_MEDIUM),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

//**** Pyro Spec Armor ****//
GAMEMODE_DECORATOR(/obj/item/clothing/suit/storage/marine/M35, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
	ARMOR_EDIT(armor_bomb, CLOTHING_ARMOR_MEDIUM),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

//************ USCM Helmet Values ************//

GAMEMODE_DECORATOR(/obj/item/clothing/head/helmet/marine, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
	ARMOR_EDIT(armor_bomb, CLOTHING_ARMOR_MEDIUM),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

GAMEMODE_DECORATOR(/obj/item/clothing/head/helmet/marine/specialist, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bomb, CLOTHING_ARMOR_ULTRAHIGH),
))

//************ Shoe Values ************//

GAMEMODE_DECORATOR(/obj/item/clothing/shoes/marine, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGHPLUS),
	ARMOR_EDIT(armor_bomb, CLOTHING_ARMOR_MEDIUM),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_MEDIUMHIGH)
))

//************ Glove Values ************//

GAMEMODE_DECORATOR(/obj/item/clothing/gloves/marine, /datum/game_mode/extended/faction_clash, list(
	ARMOR_EDIT(armor_bullet, CLOTHING_ARMOR_HIGH),
	ARMOR_EDIT(armor_internaldamage, CLOTHING_ARMOR_HIGH)
))

//*********************** ------------------ ***********************//
