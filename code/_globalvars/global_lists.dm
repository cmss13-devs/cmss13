
var/list/unansweredAhelps = list()			//This feels inefficient, but I can't think of a better way. Stores the message indexed by CID
var/list/CLFaxes = list()					//List of all CL faxes sent this round
var/list/fax_contents = list() 				//List of fax contents to maintain it even if source paper is deleted
var/list/USCMFaxes = list()					//List of all USCM faxes sent this round

//Names of maps that can be compiled on
var/list/DEFAULT_NEXT_MAP_CANDIDATES = list(MAP_LV_624, MAP_BIG_RED, MAP_WHISKEY_OUTPOST, MAP_DESERT_DAM, MAP_ICE_COLONY, MAP_PRISON_STATION, MAP_CORSAT, MAP_SOROKYNE_STRATA, MAP_KUTJEVO)
var/list/LOWPOP_NEXT_MAP_CANDIDATES = list(MAP_LV_624, MAP_BIG_RED, MAP_PRISON_STATION, MAP_KUTJEVO, MAP_PRISON_STATION_V3)
var/list/NOTVOTABLE_MAPS = list(MAP_WHISKEY_OUTPOST, MAP_ICE_COLONY)
var/list/NEXT_MAP_CANDIDATES = DEFAULT_NEXT_MAP_CANDIDATES.Copy() - NOTVOTABLE_MAPS

// Global lists of the HUDs
var/global/list/custom_huds_list = list("midnight" = new /datum/custom_hud(),
									"dark" = new /datum/custom_hud/dark(),
									"old" = new /datum/custom_hud/old(),
									"orange" = new /datum/custom_hud/orange(),
									"white" = new /datum/custom_hud/white(),
									"alien" = new /datum/custom_hud/alien(),
									"robot" = new /datum/custom_hud/robot()
									)

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

var/readied_players = 0								//How many players are readied up in the lobby

GLOBAL_LIST_EMPTY_TYPED(human_agent_list, /mob/living/carbon/human)
GLOBAL_LIST_EMPTY_TYPED(other_factions_human_list, /mob/living/carbon/human)

var/global/list/ai_mob_list = list()				//List of all AIs

GLOBAL_LIST_EMPTY(freed_mob_list) 	// List of mobs freed for ghosts

// Xeno stuff //
// Resin constructions parameters
GLOBAL_LIST_INIT_TYPED(resin_constructions_list, /datum/resin_construction, setup_resin_constructions())

GLOBAL_LIST_INIT(resin_build_order_default, list(
	/datum/resin_construction/resin_turf/wall,
	/datum/resin_construction/resin_turf/membrane,
	/datum/resin_construction/resin_obj/nest,
	/datum/resin_construction/resin_obj/sticky_resin,
	/datum/resin_construction/resin_obj/fast_resin,
	/datum/resin_construction/resin_obj/door,
))
GLOBAL_LIST_INIT(resin_build_order_hivelord, list(
	/datum/resin_construction/resin_turf/wall/resin_turf/thick,
	/datum/resin_construction/resin_turf/membrane/thick,
	/datum/resin_construction/resin_obj/nest,
	/datum/resin_construction/resin_obj/sticky_resin,
	/datum/resin_construction/resin_obj/fast_resin,
	/datum/resin_construction/resin_obj/door/thick,
))

/// Xeno caste datums
GLOBAL_REFERENCE_LIST_INDEXED(xeno_datum_list, /datum/caste_datum, caste_name)

//Chem Stuff
var/global/list/chemical_reactions_filtered_list	//List of all /datum/chemical_reaction datums filtered by reaction components. Used during chemical reactions
var/global/list/chemical_reactions_list		//List of all /datum/chemical_reaction datums indexed by reaction id. Used to search for the result instead of the components.
var/global/list/chemical_reagents_list		//List of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
var/global/list/chemical_properties_list	//List of all /datum/chem_property datums indexed by property name
var/global/list/chemical_objective_list	 = list()	//List of all objective reagents indexed by ID associated with the objective value
var/global/list/chemical_identified_list = list()	//List of all identified objective reagents indexed by ID associated with the objective value
//List of all id's from classed /datum/reagent datums indexed by class or tier. Used by chemistry generator and chem spawners.
var/global/list/list/chemical_gen_classes_list = list("C" = list(),"C1" = list(),"C2" = list(),"C3" = list(),"C4" = list(),"C5" = list(),"C6" = list(),"T1" = list(),"T2" = list(),"T3" = list(),"T4" = list(),"omega" = list(),"tau" = list())

GLOBAL_LIST_INIT_TYPED(surgery_steps, /datum/surgery_step, setup_surgeries())				//List of all surgery steps  |BS12
GLOBAL_LIST_INIT_TYPED(ammo_list, /datum/ammo, setup_ammo())					//List of all ammo types. Used by guns to tell the projectile how to act.
GLOBAL_REFERENCE_LIST_INDEXED(joblist, /datum/job, title)					//List of all jobstypes, minus borg and AI

GLOBAL_LIST_INIT_TYPED(gear_presets_list, /datum/equipment_preset, setup_gear_presets())

var/global/list/active_areas = list()
var/global/list/all_areas = list()

var/global/list/turfs = list()
var/global/list/z1turfs = list()

/var/global/list/objects_of_interest // This is used to track the stealing objective for Agents.

// exceptions to grenade antigrief
var/global/list/grenade_antigrief_exempt_areas = list(
)

var/global/list/yautja_gear = list() // list of loose pred gear
var/global/list/untracked_yautja_gear = list() // List of untracked loose pred gear

GLOBAL_LIST_EMPTY_TYPED(gun_cabinets, /obj/structure/closet/secure_closet/guncabinet)

//Languages/species/whitelist.
GLOBAL_LIST_INIT_TYPED(all_species, /datum/species, setup_species())
GLOBAL_REFERENCE_LIST_INDEXED(all_languages, /datum/language, name)
GLOBAL_LIST_INIT(language_keys, setup_language_keys())					//table of say codes for all languages
var/global/list/synth_types = list("Synthetic","Second Generation Synthetic")

//Xeno mutators
GLOBAL_REFERENCE_LIST_INDEXED_SORTED(xeno_mutator_list, /datum/xeno_mutator, name)

//Xeno hives
GLOBAL_LIST_INIT_TYPED(hive_datum, /datum/hive_status, list(
	XENO_HIVE_NORMAL = new /datum/hive_status(),
	XENO_HIVE_CORRUPTED = new /datum/hive_status/corrupted(),
	XENO_HIVE_ALPHA = new /datum/hive_status/alpha(),
	XENO_HIVE_BRAVO = new /datum/hive_status/bravo(),
	XENO_HIVE_CHARLIE = new /datum/hive_status/charlie(),
	XENO_HIVE_DELTA = new /datum/hive_status/delta(),
))

GLOBAL_LIST_INIT(custom_event_info_list, setup_custom_event_info())

//DEFCON rewards / assets
GLOBAL_REFERENCE_LIST_INDEXED_SORTED(defcon_reward_list, /datum/defcon_reward, name)

// Posters
GLOBAL_LIST_INIT(poster_designs, subtypesof(/datum/poster))

//Preferences stuff
	// Ethnicities
GLOBAL_REFERENCE_LIST_INDEXED(ethnicities_list, /datum/ethnicity, name)			// Stores /datum/ethnicity indexed by name
	// Body Types
GLOBAL_REFERENCE_LIST_INDEXED(body_types_list, /datum/body_type, name)			// Stores /datum/body_type indexed by name
	//Hairstyles
GLOBAL_REFERENCE_LIST_INDEXED(hair_styles_list, /datum/sprite_accessory/hair, name)			//stores /datum/sprite_accessory/hair indexed by name
GLOBAL_REFERENCE_LIST_INDEXED(facial_hair_styles_list, /datum/sprite_accessory/facial_hair, name)	//stores /datum/sprite_accessory/facial_hair indexed by name

	//Underwear
var/global/list/underwear_m = list("Briefs") //Curse whoever made male/female underwear diffrent colours
var/global/list/underwear_f = list("Briefs", "Panties")
	//undershirt
var/global/list/undershirt_t = list("None","Undershirt(Sleeveless)", "Undershirt(Sleeved)", "Rolled Undershirt(Sleeveless)", "Rolled Undershirt(Sleeved)")
	//Backpacks
var/global/list/backbaglist = list("Backpack", "Satchel")
// var/global/list/exclude_jobs = list(/datum/job/ai,/datum/job/cyborg)
var/global/round_should_check_for_win = TRUE

var/global/list/key_mods = list("CTRL", "ALT", "SHIFT")

// A list storing the pass flags for specific types of atoms
var/global/list/pass_flags_cache = list()

//Parameterss cache
var/global/list/paramslist_cache = list()

#define cached_key_number_decode(key_number_data) cached_params_decode(key_number_data, /proc/key_number_decode)
#define cached_number_list_decode(number_list_data) cached_params_decode(number_list_data, /proc/number_list_decode)

/proc/cached_params_decode(var/params_data, var/decode_proc)
	. = paramslist_cache[params_data]
	if(!.)
		. = call(decode_proc)(params_data)
		paramslist_cache[params_data] = .

/proc/key_number_decode(var/key_number_data)
	var/list/L = params2list(key_number_data)
	for(var/key in L)
		L[key] = text2num(L[key])
	return L

/proc/number_list_decode(var/number_list_data)
	var/list/L = params2list(number_list_data)
	for(var/i in 1 to L.len)
		L[i] = text2num(L[i])
	return L

/proc/setup_species()
	var/rkey = 0
	var/list/all_species = list()
	for(var/T in subtypesof(/datum/species))
		rkey++
		var/datum/species/S = new T
		S.race_key = rkey //Used in mob icon caching.
		all_species[S.name] = S
	return all_species

/proc/setup_ammo()
	var/list/blacklist = list(/datum/ammo/energy, /datum/ammo/energy/yautja, /datum/ammo/energy/yautja/rifle, /datum/ammo/bullet/shotgun, /datum/ammo/xeno)
	var/list/ammo_list = list()
	for(var/T in subtypesof(/datum/ammo) - blacklist)
		var/datum/ammo/A = new T
		ammo_list[A.type] = A
	return ammo_list

/proc/setup_resin_constructions()
	var/list/resin_constructions_list = list()
	for (var/T in subtypesof(/datum/resin_construction) - list(/datum/resin_construction/resin_obj, /datum/resin_construction/resin_turf))
		var/datum/resin_construction/RC = new T
		resin_constructions_list[T] = RC
	return sortAssoc(resin_constructions_list)

/proc/setup_gear_presets()
	var/list/gear_presets_list = list()
	for(var/T in typesof(/datum/equipment_preset))
		var/datum/equipment_preset/EP = T
		if (!initial(EP.flags))
			continue
		EP = new T
		gear_presets_list[EP.name] = EP
	return sortAssoc(gear_presets_list)

/proc/setup_language_keys()
	var/list/language_keys = list()
	for (var/language_name in subtypesof(/datum/language))
		var/datum/language/L = language_name
		language_keys[":[lowertext(initial(L.key))]"] = initial(L.name)
		language_keys[".[lowertext(initial(L.key))]"] = initial(L.name)
		language_keys["#[lowertext(initial(L.key))]"] = initial(L.name)
	return language_keys

/proc/setup_custom_event_info()
	//faction event messages
	var/list/custom_event_info_list = list()
	var/datum/custom_event_info/CEI = new /datum/custom_event_info
	CEI.faction = "Global"		//the old public one for whole server to see
	custom_event_info_list[CEI.faction] = CEI
	for(var/T in FACTION_LIST_HUMANOID)
		CEI = new /datum/custom_event_info
		CEI.faction = T
		custom_event_info_list[T] = CEI

	var/datum/hive_status/hive
	for(var/hivenumber in GLOB.hive_datum)
		hive = GLOB.hive_datum[hivenumber]
		CEI = new /datum/custom_event_info
		CEI.faction = hive.internal_faction
		custom_event_info_list[hive.name] = CEI

	return custom_event_info_list

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_filtered_list)
		. += "chemical_reactions_filtered_list\[\"[reaction]\"\] = \"[chemical_reactions_filtered_list[reaction]]\"\n"
		if(islist(chemical_reactions_filtered_list[reaction]))
			var/list/L = chemical_reactions_filtered_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	world << .
*/
