/datum/entity/marine_death
	/// What map this death happened on
	var/map_name
	/// X coord of the death
	var/x
	/// Y coord of the death
	var/y
	/// Z coord of the death
	var/z
	/// What minute this death happened at, rounded down
	var/death_minute
	/// What role this marine was
	var/role
	/// How many minutes the marine had been alive for, rounded down
	var/minutes_alive
	/// Ckey of the player who died
	var/ckey
	/// How much damage this marine
	var/damage_taken
	/// What killed this marine ("Ravager")
	var/killed_by
	/// Round ID that this marine died in
	var/round_id
	/// The primary weapon (as best we can find) of the marine
	var/primary_weapon
	/// The armor the marine was wearing on death
	var/armor
	/// How many kills this marine got
	var/kill_count
	/// What squad this player belongs to, if any
	var/squad

/datum/entity/marine_death/proc/load_data(mob/living/carbon/human/dead_marine, datum/cause_data/death_cause)
	map_name = SSmapping.configs[GROUND_MAP]?.map_name || "Unknown Map"
	x = dead_marine.x || -1
	y = dead_marine.y || -1
	z = dead_marine.z || -1
	death_minute = floor((world.time * 0.1) / 60)
	role = dead_marine.job
	ckey = dead_marine.ckey || dead_marine.persistent_ckey || ""
	damage_taken = dead_marine.life_damage_taken_total || 0
	killed_by = strip_improper(death_cause?.cause_name) || "Unknown"
	round_id = GLOB.round_id || -1
	kill_count = dead_marine.life_kills_total || 0
	if(isgun(dead_marine.s_store))
		primary_weapon = strip_improper(dead_marine.s_store::name)
	else if(isgun(dead_marine.back))
		primary_weapon = strip_improper(dead_marine.back::name)
	else
		var/obj/item/weapon/gun/found_gun = locate(/obj/item/weapon/gun) in dead_marine.contents
		if(found_gun)
			primary_weapon = strip_improper(found_gun::name)

	if(istype(dead_marine.wear_suit, /obj/item/clothing/suit))
		armor = strip_improper(dead_marine.wear_suit::name)

	if(dead_marine.assigned_squad)
		squad = dead_marine.assigned_squad.name

	SSticker?.mode?.round_stats?.marine_deaths += src
	save()

/datum/entity_meta/marine_death
	entity_type = /datum/entity/marine_death
	table_name = "marine_deaths"
	field_types = list(
		"map_name" = DB_FIELDTYPE_STRING_MEDIUM,
		"x" = DB_FIELDTYPE_INT,
		"y" = DB_FIELDTYPE_INT,
		"z" = DB_FIELDTYPE_INT,
		"death_minute" = DB_FIELDTYPE_INT,
		"role" = DB_FIELDTYPE_STRING_MEDIUM,
		"ckey" = DB_FIELDTYPE_STRING_MEDIUM,
		"damage_taken" = DB_FIELDTYPE_INT,
		"killed_by" = DB_FIELDTYPE_STRING_MEDIUM,
		"round_id" = DB_FIELDTYPE_INT,
		"primary_weapon" = DB_FIELDTYPE_STRING_MEDIUM,
		"armor" = DB_FIELDTYPE_STRING_MEDIUM,
		"kill_count" = DB_FIELDTYPE_INT,
		"squad" = DB_FIELDTYPE_STRING_SMALL,
	)
