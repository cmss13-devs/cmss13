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
