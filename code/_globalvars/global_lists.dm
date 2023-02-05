
var/list/unansweredAhelps = list() //This feels inefficient, but I can't think of a better way. Stores the message indexed by CID

GLOBAL_LIST_EMPTY(WYFaxes) //Departmental faxes
GLOBAL_LIST_EMPTY(USCMFaxes)
GLOBAL_LIST_EMPTY(ProvostFaxes)
GLOBAL_LIST_EMPTY(GeneralFaxes) //Inter-machine faxes
GLOBAL_LIST_EMPTY(fax_contents) //List of fax contents to maintain it even if source paper is deleted

GLOBAL_LIST_EMPTY(failed_fultons) //A list of fultoned items which weren't collected and fell back down

GLOBAL_LIST_INIT_TYPED(custom_huds_list, /datum/custom_hud, setup_all_huds())
GLOBAL_LIST_INIT_TYPED(custom_human_huds, /datum/custom_hud, setup_human_huds())

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

var/readied_players = 0 //How many players are readied up in the lobby

GLOBAL_LIST_EMPTY_TYPED(other_factions_human_list, /mob/living/carbon/human)

var/global/list/ai_mob_list = list() //List of all AIs

GLOBAL_LIST_EMPTY(freed_mob_list) // List of mobs freed for ghosts

GLOBAL_LIST_INIT(available_taskbar_icons, setup_taskbar_icons())

GLOBAL_LIST_EMPTY(minimap_icons)

/proc/initiate_minimap_icons()
	var/list/icons = list()
	for(var/iconstate in icon_states('icons/UI_icons/map_blips.dmi'))
		var/icon/image = icon('icons/UI_icons/map_blips.dmi', icon_state = iconstate)
		icons[iconstate] += image

	var/list/base64_icons = list()
	for(var/iconstate in icons)
		base64_icons[iconstate] = icon2base64(icons[iconstate])

	GLOB.minimap_icons = base64_icons



// Xeno stuff //
// Resin constructions parameters
GLOBAL_LIST_INIT_TYPED(resin_constructions_list, /datum/resin_construction, setup_resin_constructions())

GLOBAL_LIST_INIT(resin_build_order_drone, list(
	/datum/resin_construction/resin_turf/wall,
	/datum/resin_construction/resin_turf/membrane,
	/datum/resin_construction/resin_obj/door,
	/datum/resin_construction/resin_obj/nest,
	/datum/resin_construction/resin_obj/sticky_resin,
	/datum/resin_construction/resin_obj/fast_resin,
	/datum/resin_construction/resin_obj/resin_spike
))

GLOBAL_LIST_INIT(resin_build_order_hivelord, list(
	/datum/resin_construction/resin_turf/wall/thick,
	/datum/resin_construction/resin_turf/wall/reflective,
	/datum/resin_construction/resin_turf/membrane/thick,
	/datum/resin_construction/resin_obj/door/thick,
	/datum/resin_construction/resin_obj/nest,
	/datum/resin_construction/resin_obj/acid_pillar,
	/datum/resin_construction/resin_obj/sticky_resin,
	/datum/resin_construction/resin_obj/fast_resin,
	/datum/resin_construction/resin_obj/resin_spike
))

GLOBAL_LIST_INIT(resin_build_order_ovipositor, list(
	/datum/resin_construction/resin_turf/wall/queen,
	/datum/resin_construction/resin_turf/wall/reflective,
	/datum/resin_construction/resin_turf/membrane/queen,
	/datum/resin_construction/resin_obj/door/queen,
	/datum/resin_construction/resin_obj/nest,
	/datum/resin_construction/resin_obj/acid_pillar,
	/datum/resin_construction/resin_obj/sticky_resin,
	/datum/resin_construction/resin_obj/fast_resin,
	/datum/resin_construction/resin_obj/resin_spike
))

//Xeno Leader Mark Meanings
GLOBAL_LIST_INIT_TYPED(resin_mark_meanings, /datum/xeno_mark_define, setup_resin_mark_meanings())

/// Xeno caste datums
GLOBAL_REFERENCE_LIST_INDEXED(xeno_datum_list, /datum/caste_datum, caste_type)

//Chem Stuff
var/global/list/chemical_reactions_filtered_list //List of all /datum/chemical_reaction datums filtered by reaction components. Used during chemical reactions
var/global/list/chemical_reactions_list //List of all /datum/chemical_reaction datums indexed by reaction id. Used to search for the result instead of the components.
var/global/list/chemical_reagents_list //List of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
var/global/list/chemical_properties_list //List of all /datum/chem_property datums indexed by property name
//List of all id's from classed /datum/reagent datums indexed by class or tier. Used by chemistry generator and chem spawners.
var/global/list/list/chemical_gen_classes_list = list("C" = list(),"C1" = list(),"C2" = list(),"C3" = list(),"C4" = list(),"C5" = list(),"C6" = list(),"T1" = list(),"T2" = list(),"T3" = list(),"T4" = list(),"tau" = list())
//properties generated in chemicals, helps to make sure the same property doesn't show up 10 times
GLOBAL_LIST_INIT_TYPED(generated_properties, /list, list("positive" = list(), "negative" = list(), "neutral" = list()))

GLOBAL_LIST_INIT_TYPED(ammo_list, /datum/ammo, setup_ammo()) //List of all ammo types. Used by guns to tell the projectile how to act.
GLOBAL_REFERENCE_LIST_INDEXED(joblist, /datum/job, title) //List of all jobstypes, minus borg and AI

/*Surgical lists.
surgery_invasiveness_levels lists possible incision depths.
surgeries_list lists individual operations as initialised datums. These are used for reference when beginning surgeries.
surgeries_by_zone_and_depth links to initialised surgery datums, indexed by target zone and depth of incision.
surgery_step_list lists the individual surgical steps as initialised datums.
surgical_tools lists all item paths that can be used in a surgery step.
surgical_init_tools lists all item paths that can be used in a surgery step except those flagged to not message on failed init - ex. cable coil, trauma kits etc.
surgical_patient_types is a list of typecaches indexed by surgery, used to test if a patient is a valid mobtype.*/
GLOBAL_LIST_INIT(surgery_invasiveness_levels, list(SURGERY_DEPTH_SURFACE, SURGERY_DEPTH_SHALLOW, SURGERY_DEPTH_DEEP))
GLOBAL_LIST_INIT_TYPED(surgeries_list, /datum/surgery, setup_surgeries())
GLOBAL_LIST_INIT(surgeries_by_zone_and_depth, setup_surgeries_by_zone_and_depth())
GLOBAL_REFERENCE_LIST_INDEXED(surgery_step_list, /datum/surgery_step, type)
GLOBAL_LIST_INIT(surgical_tools, setup_surgical_tools())
GLOBAL_LIST_INIT(surgical_init_tools, GLOB.surgical_tools - typecacheof(SURGERY_TOOLS_NO_INIT_MSG))
GLOBAL_LIST_INIT(surgical_patient_types, setup_surgical_patient_types())

GLOBAL_LIST_INIT_TYPED(gear_path_presets_list, /datum/equipment_preset, setup_gear_path_presets())
GLOBAL_LIST_INIT_TYPED(gear_name_presets_list, /datum/equipment_preset, setup_gear_name_presets())

var/global/list/active_areas = list()
var/global/list/all_areas = list()

var/global/list/turfs = list()
var/global/list/z1turfs = list()

/var/global/list/objects_of_interest // This is used to track the stealing objective for Agents.

// Areas exempt from explosive antigrief (not Z-levels)
GLOBAL_LIST_INIT(explosive_antigrief_exempt_areas, list(
	//non currently
))

GLOBAL_LIST_EMPTY(loose_yautja_gear)
GLOBAL_LIST_EMPTY(tracked_yautja_gear) // list of pred gear with a tracking element attached

GLOBAL_LIST_INIT_TYPED(all_yautja_capes, /obj/item/clothing/yautja_cape, setup_yautja_capes())

//Languages/species/whitelist.
GLOBAL_LIST_INIT_TYPED(all_species, /datum/species, setup_species())
GLOBAL_REFERENCE_LIST_INDEXED(all_languages, /datum/language, name)
GLOBAL_LIST_INIT(language_keys, setup_language_keys()) //table of say codes for all languages

// Origins
GLOBAL_REFERENCE_LIST_INDEXED(origins, /datum/origin, name)
GLOBAL_LIST_INIT(player_origins, USCM_ORIGINS)

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
	XENO_HIVE_FERAL = new /datum/hive_status/feral(),
	XENO_HIVE_TAMED = new /datum/hive_status/corrupted/tamed(),
	XENO_HIVE_MUTATED = new /datum/hive_status/mutated(),
	XENO_HIVE_FORSAKEN = new /datum/hive_status/forsaken(),
	XENO_HIVE_YAUTJA = new /datum/hive_status/yautja()
))

GLOBAL_LIST_INIT(custom_event_info_list, setup_custom_event_info())

// Posters
GLOBAL_LIST_INIT(poster_designs, subtypesof(/datum/poster))

//Preferences stuff
	// Ethnicities
GLOBAL_REFERENCE_LIST_INDEXED(ethnicities_list, /datum/ethnicity, name) // Stores /datum/ethnicity indexed by name
	// Body Types
GLOBAL_REFERENCE_LIST_INDEXED(body_types_list, /datum/body_type, name) // Stores /datum/body_type indexed by name
	//Hairstyles
GLOBAL_REFERENCE_LIST_INDEXED(hair_styles_list, /datum/sprite_accessory/hair, name) //stores /datum/sprite_accessory/hair indexed by name
GLOBAL_REFERENCE_LIST_INDEXED(facial_hair_styles_list, /datum/sprite_accessory/facial_hair, name) //stores /datum/sprite_accessory/facial_hair indexed by name
GLOBAL_REFERENCE_LIST_INDEXED(hair_gradient_list, /datum/sprite_accessory/hair_gradient, name)
GLOBAL_REFERENCE_LIST_INDEXED(yautja_hair_styles_list, /datum/sprite_accessory/yautja_hair, name)

	//Backpacks
var/global/list/backbaglist = list("Backpack", "Satchel")
// var/global/list/exclude_jobs = list(/datum/job/ai,/datum/job/cyborg)
var/global/round_should_check_for_win = TRUE

var/global/list/key_mods = list("CTRL", "ALT", "SHIFT")

// A list storing the pass flags for specific types of atoms
var/global/list/pass_flags_cache = list()

//Parameterss cache
var/global/list/paramslist_cache = list()

//Turf Edge info uberlist -- a list whos states contain GLOB.edgeinfo_X keyed as different icon_states
var/global/list/turf_edgeinfo_cache = list()

#define FULL_EDGE 1
#define HALF_EDGE_RIGHT 2
#define HALF_EDGE_LEFT 3
//right and left looking from the turf who makes an overlay towards its neighbor thats it overlays upon

//These are ordered just like sprites are in the dm dmi editor: 2/SOUTH then 1/NORTH then 4/EAST then 8/WEST
GLOBAL_LIST_INIT(edgeinfo_full, list(
								list(FULL_EDGE, FULL_EDGE, FULL_EDGE, FULL_EDGE),
								list(FULL_EDGE, FULL_EDGE, FULL_EDGE, FULL_EDGE),
								list(FULL_EDGE, FULL_EDGE, FULL_EDGE, FULL_EDGE),
								list(FULL_EDGE, FULL_EDGE, FULL_EDGE, FULL_EDGE)
								))

GLOBAL_LIST_INIT(edgeinfo_edge, list(
								list(null, FULL_EDGE, HALF_EDGE_LEFT, HALF_EDGE_RIGHT),
								list(FULL_EDGE, null, HALF_EDGE_RIGHT, HALF_EDGE_LEFT),
								list(HALF_EDGE_LEFT, HALF_EDGE_RIGHT, null, FULL_EDGE),
								list(HALF_EDGE_RIGHT, HALF_EDGE_LEFT, FULL_EDGE, null)
								))

GLOBAL_LIST_INIT(edgeinfo_corner, list(
								list( HALF_EDGE_LEFT, FULL_EDGE,FULL_EDGE, HALF_EDGE_RIGHT),
								list(HALF_EDGE_RIGHT, FULL_EDGE, HALF_EDGE_LEFT, FULL_EDGE),
								list(FULL_EDGE, HALF_EDGE_LEFT, FULL_EDGE, HALF_EDGE_LEFT),
								list(FULL_EDGE, HALF_EDGE_RIGHT, HALF_EDGE_RIGHT, FULL_EDGE)
								))

GLOBAL_LIST_INIT(edgeinfo_corner2, list(
								list(null, HALF_EDGE_LEFT, null,  HALF_EDGE_RIGHT),
								list(HALF_EDGE_RIGHT, null, HALF_EDGE_RIGHT, null),
								list(null, HALF_EDGE_RIGHT, HALF_EDGE_LEFT, null),
								list(HALF_EDGE_LEFT, null, null, HALF_EDGE_LEFT)
								))

#undef FULL_EDGE
#undef HALF_EDGE_RIGHT
#undef HALF_EDGE_LEFT

GLOBAL_LIST_INIT(color_vars, list("color"))

#define cached_key_number_decode(key_number_data) cached_params_decode(key_number_data, GLOBAL_PROC_REF(key_number_decode))
#define cached_number_list_decode(number_list_data) cached_params_decode(number_list_data, GLOBAL_PROC_REF(number_list_decode))

GLOBAL_LIST_INIT(typecache_mob, typecacheof(/mob))

GLOBAL_LIST_INIT(typecache_living, typecacheof(/mob/living))

GLOBAL_LIST_INIT(emote_list, init_emote_list())

/proc/cached_params_decode(params_data, decode_proc)
	. = paramslist_cache[params_data]
	if(!.)
		. = call(decode_proc)(params_data)
		paramslist_cache[params_data] = .

/proc/key_number_decode(key_number_data)
	var/list/L = params2list(key_number_data)
	for(var/key in L)
		L[key] = text2num(L[key])
	return L

/proc/number_list_decode(number_list_data)
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

/proc/setup_resin_mark_meanings()
	var/list/resin_meanings_list = list()
	for (var/T in subtypesof(/datum/xeno_mark_define))
		var/datum/xeno_mark_define/XMD = new T
		resin_meanings_list[T] = XMD
	return sortAssoc(resin_meanings_list)

/proc/setup_gear_path_presets()
	var/list/gear_path_presets_list = list()
	for(var/T in typesof(/datum/equipment_preset))
		var/datum/equipment_preset/EP = T
		if (!initial(EP.flags))
			continue
		EP = new T
		gear_path_presets_list[EP.type] = EP
	return sortAssoc(gear_path_presets_list)

/proc/setup_gear_name_presets()
	var/list/gear_path_presets_list = list()
	for(var/T in typesof(/datum/equipment_preset))
		var/datum/equipment_preset/EP = T
		if (!initial(EP.flags))
			continue
		EP = new T
		gear_path_presets_list[EP.name] = EP
	return sortAssoc(gear_path_presets_list)

/proc/setup_language_keys()
	var/list/language_keys = list()
	for (var/language_name in subtypesof(/datum/language))
		var/datum/language/L = language_name
		language_keys[":[lowertext(initial(L.key))]"] = initial(L.name)
		language_keys[".[lowertext(initial(L.key))]"] = initial(L.name)
		language_keys["#[lowertext(initial(L.key))]"] = initial(L.name)
	return language_keys

//Comb Sort. This works apparently, so we're keeping it that way
/proc/setup_surgeries()
	var/list/surgeries = list()
	for(var/T in subtypesof(/datum/surgery))
		surgeries += new T

	var/gap = length(surgeries)
	var/swapped = 1
	while(gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.247330950103979)
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= length(surgeries); i++)
			var/datum/surgery/l = surgeries[i] //Fucking hate
			var/datum/surgery/r = surgeries[gap+i] //how lists work here
			if(l.priority < r.priority)
				surgeries.Swap(i, gap + i)
				swapped = 1
	return surgeries

/proc/setup_surgeries_by_zone_and_depth()
	var/list/surgeries = list()
	for(var/L in DEFENSE_ZONES_LIVING)
		surgeries[L] = list()
		for(var/I in GLOB.surgery_invasiveness_levels)
			surgeries[L][I] = list()
			for(var/datum/surgery/T as anything in GLOB.surgeries_list)
				if((L in T.possible_locs) && (I in T.invasiveness))
					surgeries[L][I] += T
	return surgeries

/proc/setup_surgical_tools()
	var/list/tools = list()
	for(var/S in GLOB.surgery_step_list)
		var/datum/surgery_step/step = GLOB.surgery_step_list[S]
		tools |= typecacheof(step.tools)
	return tools

/proc/setup_surgical_patient_types()
	var/list/mobtypes = list()
	for(var/datum/surgery/T as anything in GLOB.surgeries_list)
		mobtypes["[T]"] = typecacheof(T.target_mobtypes)
	return mobtypes

/proc/setup_custom_event_info()
	//faction event messages
	var/list/custom_event_info_list = list()
	var/datum/custom_event_info/CEI = new /datum/custom_event_info
	CEI.faction = "Global" //the old public one for whole server to see
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

/proc/setup_taskbar_icons()
	var/list/png_list = flist("icons/taskbar")
	for(var/png in png_list)
		if(!isfile(png))
			png_list -= png
	return sortList(png_list)

/proc/setup_all_huds()
	return list(
		HUD_MIDNIGHT = new /datum/custom_hud(),
		HUD_DARK = new /datum/custom_hud/dark(),
		HUD_BRONZE = new /datum/custom_hud/bronze(),
		HUD_GLASS = new /datum/custom_hud/glass(),
		HUD_GREEN = new /datum/custom_hud/green(),
		HUD_GREY = new /datum/custom_hud/grey(),
		HUD_HOLO = new /datum/custom_hud/holographic(),
		HUD_OLD = new /datum/custom_hud/old(),
		HUD_ORANGE = new /datum/custom_hud/orange(),
		HUD_RED = new /datum/custom_hud/red(),
		HUD_WHITE = new /datum/custom_hud/white(),
		HUD_ALIEN = new /datum/custom_hud/alien(),
		HUD_ROBOT = new /datum/custom_hud/robot()
	)

/proc/setup_human_huds()
	var/list/human_huds = list()
	for(var/type in GLOB.custom_huds_list - list(HUD_ALIEN, HUD_ROBOT))
		human_huds += type
	return human_huds

/proc/setup_yautja_capes()
	var/list/cape_list = list()
	for(var/obj/item/clothing/yautja_cape/cape_type as anything in typesof(/obj/item/clothing/yautja_cape))
		cape_list[initial(cape_type.name)] = cape_type
	return cape_list


/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_filtered_list)
		. += "chemical_reactions_filtered_list\[\"[reaction]\"\] = \"[chemical_reactions_filtered_list[reaction]]\"\n"
		if(islist(chemical_reactions_filtered_list[reaction]))
			var/list/L = chemical_reactions_filtered_list[reaction]
			for(var/t in L)
				. += " has: [t]\n"
	world << .
*/

GLOBAL_REFERENCE_LIST_INDEXED(all_skills, /datum/skill, skill_name)


// Timelock
GLOBAL_LIST_EMPTY(timelocks)


//the global list of specialist kits that haven't been claimed yet.
var/global/list/available_specialist_sets = list(
			"Scout Set",
			"Sniper Set",
			"Demolitionist Set",
			"Heavy Grenadier Set",
			"Pyro Set"
			)

//Similar thing, but used in /obj/item/spec_kit
var/global/list/available_specialist_kit_boxes = list(
			"Pyro" = 2,
			"Grenadier" = 2,
			"Sniper" = 2,
			"Scout" = 2,
			"Demo" = 2,
			)

/proc/init_global_referenced_datums()
	init_keybindings()
	generate_keybind_ui_data()

/proc/init_emote_list()
	. = list()
	for(var/path in subtypesof(/datum/emote))
		var/datum/emote/E = new path()
		if(E.key)
			if(!.[E.key])
				.[E.key] = list(E)
			else
				.[E.key] += E
		else if(E.message) //Assuming all non-base emotes have this
			stack_trace("Keyless emote: [E.type]")

		if(E.key_third_person) //This one is optional
			if(!.[E.key_third_person])
				.[E.key_third_person] = list(E)
			else
				.[E.key_third_person] |= E
