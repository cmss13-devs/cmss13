GLOBAL_LIST_EMPTY(PressFaxes)
GLOBAL_LIST_EMPTY(WYFaxes) //Departmental faxes
GLOBAL_LIST_EMPTY(USCMFaxes)
GLOBAL_LIST_EMPTY(ProvostFaxes)
GLOBAL_LIST_EMPTY(CMBFaxes)
GLOBAL_LIST_EMPTY(UPPFaxes)
GLOBAL_LIST_EMPTY(TWEFaxes)
GLOBAL_LIST_EMPTY(CLFFaxes)
GLOBAL_LIST_EMPTY(GeneralFaxes) //Inter-machine faxes
GLOBAL_LIST_EMPTY(fax_contents) //List of fax contents to maintain it even if source paper is deleted

// for all of our various bugs and runtimes
GLOBAL_LIST_EMPTY(bug_reports)

//datum containing a reference to the flattend map png url, the actual png is stored in the user's cache.
GLOBAL_LIST_EMPTY(uscm_flat_tacmap_data)
GLOBAL_LIST_EMPTY(xeno_flat_tacmap_data)

//datum containing the svg overlay coords in array format.
GLOBAL_LIST_EMPTY(uscm_svg_tacmap_data)
GLOBAL_LIST_EMPTY(xeno_svg_tacmap_data)

GLOBAL_LIST_EMPTY(failed_fultons) //A list of fultoned items which weren't collected and fell back down
GLOBAL_LIST_EMPTY(larva_burst_by_hive)

GLOBAL_LIST_INIT_TYPED(custom_huds_list, /datum/custom_hud, setup_all_huds())
GLOBAL_LIST_INIT_TYPED(custom_human_huds, /datum/custom_hud, setup_human_huds())

GLOBAL_VAR_INIT(readied_players, 0) //How many players are readied up in the lobby

GLOBAL_LIST_EMPTY_TYPED(other_factions_human_list, /mob/living/carbon/human)

GLOBAL_LIST_EMPTY(ai_mob_list) //List of all AIs

GLOBAL_LIST_EMPTY(freed_mob_list) // List of mobs freed for ghosts

GLOBAL_LIST_INIT(available_taskbar_icons, setup_taskbar_icons())

GLOBAL_LIST_EMPTY(minimap_icons)

GLOBAL_LIST_EMPTY(mainship_pipes)

/// List of all the maps that have been cached for /proc/load_map
GLOBAL_LIST_EMPTY(cached_maps)

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

GLOBAL_LIST_INIT(resin_build_order_lesser_drone, list(
	/datum/resin_construction/resin_turf/wall,
	/datum/resin_construction/resin_turf/membrane,
	/datum/resin_construction/resin_obj/door,
))

GLOBAL_LIST_INIT(resin_build_order_drone, list(
	/datum/resin_construction/resin_turf/wall,
	/datum/resin_construction/resin_turf/membrane,
	/datum/resin_construction/resin_obj/door,
	/datum/resin_construction/resin_obj/sticky_resin,
	/datum/resin_construction/resin_obj/fast_resin,
	/datum/resin_construction/resin_obj/resin_spike
))

GLOBAL_LIST_INIT(resin_build_order_hivelord, list(
	/datum/resin_construction/resin_turf/wall/thick,
	/datum/resin_construction/resin_turf/wall/reflective,
	/datum/resin_construction/resin_turf/membrane/thick,
	/datum/resin_construction/resin_obj/door/thick,
	/datum/resin_construction/resin_obj/acid_pillar,
	/datum/resin_construction/resin_obj/sticky_resin,
	/datum/resin_construction/resin_obj/fast_resin,
	/datum/resin_construction/resin_obj/resin_spike
))

GLOBAL_LIST_INIT(resin_build_order_hivelord_whisperer, list(
	/datum/resin_construction/resin_turf/wall,
	/datum/resin_construction/resin_turf/membrane,
	/datum/resin_construction/resin_obj/door,
	/datum/resin_construction/resin_obj/sticky_resin,
	/datum/resin_construction/resin_obj/fast_resin,
	/datum/resin_construction/resin_obj/resin_spike,
	/datum/resin_construction/resin_obj/resin_node
))

GLOBAL_LIST_INIT(resin_build_order_ovipositor, list(
	/datum/resin_construction/resin_turf/wall/queen,
	/datum/resin_construction/resin_turf/wall/reflective,
	/datum/resin_construction/resin_turf/membrane/queen,
	/datum/resin_construction/resin_obj/door/queen,
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
GLOBAL_LIST(chemical_reactions_filtered_list) //List of all /datum/chemical_reaction datums filtered by reaction components. Used during chemical reactions
GLOBAL_LIST(chemical_reactions_list) //List of all /datum/chemical_reaction datums indexed by reaction id. Used to search for the result instead of the components.
GLOBAL_LIST(chemical_reagents_list) //List of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
GLOBAL_LIST(chemical_properties_list) //List of all /datum/chem_property datums indexed by property name
//list of all properties that conflict with each other.
GLOBAL_LIST_INIT_TYPED(conflicting_properties, /list, list( PROPERTY_NUTRITIOUS = PROPERTY_HEMORRAGING, PROPERTY_NUTRITIOUS = PROPERTY_HEMOLYTIC, PROPERTY_TOXIC = PROPERTY_ANTITOXIC,\
											PROPERTY_CORROSIVE = PROPERTY_ANTICORROSIVE, PROPERTY_BIOCIDIC = PROPERTY_NEOGENETIC, PROPERTY_HYPERTHERMIC = PROPERTY_HYPOTHERMIC,\
											PROPERTY_NUTRITIOUS = PROPERTY_KETOGENIC, PROPERTY_PAINING = PROPERTY_PAINKILLING, PROPERTY_HALLUCINOGENIC = PROPERTY_ANTIHALLUCINOGENIC,\
											PROPERTY_HEPATOTOXIC = PROPERTY_HEPATOPEUTIC, PROPERTY_NEPHROTOXIC = PROPERTY_NEPHROPEUTIC, PROPERTY_PNEUMOTOXIC = PROPERTY_PNEUMOPEUTIC,\
											PROPERTY_OCULOTOXIC = PROPERTY_OCULOPEUTIC, PROPERTY_CARDIOTOXIC = PROPERTY_CARDIOPEUTIC, PROPERTY_NEUROTOXIC = PROPERTY_NEUROPEUTIC,\
											PROPERTY_FLUXING = PROPERTY_REPAIRING, PROPERTY_RELAXING = PROPERTY_MUSCLESTIMULATING, PROPERTY_HEMOGENIC = PROPERTY_HEMOLYTIC,\
											PROPERTY_HEMOGENIC = PROPERTY_HEMORRAGING, PROPERTY_NUTRITIOUS = PROPERTY_EMETIC,\
											PROPERTY_HYPERGENETIC = PROPERTY_NEOGENETIC, PROPERTY_HYPERGENETIC = PROPERTY_HEPATOPEUTIC, PROPERTY_HYPERGENETIC = PROPERTY_NEPHROPEUTIC,\
											PROPERTY_HYPERGENETIC = PROPERTY_PNEUMOPEUTIC, PROPERTY_HYPERGENETIC = PROPERTY_OCULOPEUTIC, PROPERTY_HYPERGENETIC = PROPERTY_CARDIOPEUTIC,\
											PROPERTY_HYPERGENETIC = PROPERTY_NEUROPEUTIC, PROPERTY_ADDICTIVE = PROPERTY_ANTIADDICTIVE, PROPERTY_NEUROSHIELDING = PROPERTY_NEUROTOXIC,\
											PROPERTY_HYPOMETABOLIC = PROPERTY_HYPERMETABOLIC, PROPERTY_HYPERTHROTTLING = PROPERTY_NEUROINHIBITING,
											PROPERTY_FOCUSING = PROPERTY_NERVESTIMULATING, PROPERTY_THERMOSTABILIZING = PROPERTY_HYPERTHERMIC, PROPERTY_THERMOSTABILIZING = PROPERTY_HYPOTHERMIC,
											PROPERTY_AIDING = PROPERTY_NEUROINHIBITING, PROPERTY_OXYGENATING = PROPERTY_HYPOXEMIC, PROPERTY_ANTICARCINOGENIC = PROPERTY_CARCINOGENIC, \
											PROPERTY_CIPHERING = PROPERTY_CIPHERING_PREDATOR, PROPERTY_TRANSFORMATIVE = PROPERTY_ANTITOXIC, PROPERTY_INTRAVENOUS = PROPERTY_HYPERMETABOLIC,\
											PROPERTY_INTRAVENOUS = PROPERTY_HYPOMETABOLIC, PROPERTY_MUSCLESTIMULATING = PROPERTY_NERVESTIMULATING, PROPERTY_HEMOSITIC = PROPERTY_NUTRITIOUS))
//list of all properties that combine into something else, now featured in global list
GLOBAL_LIST_INIT_TYPED(combining_properties, /list, list( PROPERTY_DEFIBRILLATING = list(PROPERTY_MUSCLESTIMULATING, PROPERTY_CARDIOPEUTIC),\
											PROPERTY_THANATOMETABOL = list(PROPERTY_HYPOXEMIC, PROPERTY_CRYOMETABOLIZING, PROPERTY_NEUROCRYOGENIC),\
											PROPERTY_HYPERDENSIFICATING = list(PROPERTY_MUSCLESTIMULATING, PROPERTY_BONEMENDING, PROPERTY_CARCINOGENIC),\
											PROPERTY_HYPERTHROTTLING = list(PROPERTY_PSYCHOSTIMULATING, PROPERTY_HALLUCINOGENIC),\
											PROPERTY_NEUROSHIELDING = list(PROPERTY_ALCOHOLIC, PROPERTY_BALDING),\
											PROPERTY_ANTIADDICTIVE = list(PROPERTY_PSYCHOSTIMULATING, PROPERTY_ANTIHALLUCINOGENIC),\
											PROPERTY_ADDICTIVE = list(PROPERTY_PSYCHOSTIMULATING, PROPERTY_NEUROTOXIC),\
											PROPERTY_CIPHERING_PREDATOR = list(PROPERTY_CIPHERING, PROPERTY_CROSSMETABOLIZING),\
											PROPERTY_FIRE_PENETRATING = list(PROPERTY_OXYGENATING, PROPERTY_VISCOUS),\
											PROPERTY_BONEMENDING = list(PROPERTY_CRYSTALLIZATION, PROPERTY_NUTRITIOUS),\
											PROPERTY_ENCEPHALOPHRASIVE = list(PROPERTY_NERVESTIMULATING, PROPERTY_PSYCHOSTIMULATING)))
//List of all id's from classed /datum/reagent datums indexed by class or tier. Used by chemistry generator and chem spawners.
GLOBAL_LIST_INIT_TYPED(chemical_gen_classes_list, /list, list("C" = list(),"C1" = list(),"C2" = list(),"C3" = list(),"C4" = list(),"C5" = list(),"C6" = list(),"T1" = list(),"T2" = list(),"T3" = list(),"T4" = list(), "H1" = list(), "tau", list()))
//properties generated in chemicals, helps to make sure the same property doesn't show up 10 times
GLOBAL_LIST_INIT_TYPED(generated_properties, /list, list("positive" = list(), "negative" = list(), "neutral" = list()))

GLOBAL_LIST_INIT_TYPED(space_weapons, /datum/space_weapon, setup_ship_weapon())
GLOBAL_LIST_INIT_TYPED(space_weapons_ammo, /datum/space_weapon_ammo, setup_ship_ammo())

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

GLOBAL_LIST_EMPTY(active_areas)
GLOBAL_LIST_EMPTY(all_areas)

GLOBAL_LIST_EMPTY(turfs)

GLOBAL_LIST(objects_of_interest) // This is used to track the stealing objective for Agents.

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
	XENO_HIVE_YAUTJA = new /datum/hive_status/yautja(),
	XENO_HIVE_RENEGADE = new /datum/hive_status/corrupted/renegade(),
	XENO_HIVE_TUTORIAL = new /datum/hive_status/tutorial()
))

GLOBAL_VAR_INIT(king_acquisition_time, 1 HOURS + 30 MINUTES + rand(0, 25) MINUTES)
GLOBAL_LIST_INIT(xeno_evolve_times, setup_xeno_evolve_times())

/proc/setup_xeno_evolve_times()
	for(var/datum/caste_datum/caste as anything in subtypesof(/datum/caste_datum))
		if(initial(caste.caste_type) == XENO_CASTE_KING)
			LAZYADDASSOCLIST(., num2text(GLOB.king_acquisition_time), caste)
		else
			LAZYADDASSOCLIST(., num2text(initial(caste.minimum_evolve_time)), caste)

GLOBAL_LIST_INIT(custom_event_info_list, setup_custom_event_info())

// Posters
GLOBAL_LIST_INIT(poster_designs, subtypesof(/datum/poster))

//Preferences stuff
	// Skin colors
GLOBAL_REFERENCE_LIST_INDEXED(skin_color_list, /datum/skin_color, name) // Stores /datum/skin_color indexed by name
	// Body
GLOBAL_REFERENCE_LIST_INDEXED(body_type_list, /datum/body_type, name) // Stores /datum/body_type indexed by name
GLOBAL_REFERENCE_LIST_INDEXED(body_size_list, /datum/body_size, name) // Stores /datum/body_size indexed by name
	//Hairstyles
GLOBAL_REFERENCE_LIST_INDEXED(hair_styles_list, /datum/sprite_accessory/hair, name) //stores /datum/sprite_accessory/hair indexed by name
GLOBAL_REFERENCE_LIST_INDEXED(facial_hair_styles_list, /datum/sprite_accessory/facial_hair, name) //stores /datum/sprite_accessory/facial_hair indexed by name
GLOBAL_REFERENCE_LIST_INDEXED(hair_gradient_list, /datum/sprite_accessory/hair_gradient, name)
GLOBAL_REFERENCE_LIST_INDEXED(yautja_hair_styles_list, /datum/sprite_accessory/yautja_hair, name)

	//Backpacks
GLOBAL_LIST_INIT(backbaglist, list("Backpack", "Satchel"))

	//NVG colors
GLOBAL_LIST_INIT(nvg_color_list, list("Green", "White", "Yellow", "Orange", "Red", "Blue"))
	//Armor styles
GLOBAL_LIST_INIT(armor_style_list, list("Padded" = 1, "Padless" = 2, "Ridged" = 3, "Carrier" = 4, "Skull" = 5, "Smooth" = 6, "Random"))

// var/global/list/exclude_jobs = list(/datum/job/ai,/datum/job/cyborg)
GLOBAL_VAR_INIT(round_should_check_for_win, TRUE)

GLOBAL_LIST_INIT(key_mods, list("CTRL", "ALT", "SHIFT"))

// A list storing the pass flags for specific types of atoms
GLOBAL_LIST_EMPTY(pass_flags_cache)

//Parameterss cache
GLOBAL_LIST_EMPTY(paramslist_cache)

//Turf Edge info uberlist -- a list whos states contain GLOB.edgeinfo_X keyed as different icon_states
GLOBAL_LIST_EMPTY(turf_edgeinfo_cache)

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

/// list of categories for working joes
GLOBAL_LIST_EMPTY(wj_categories)
/// dict ("category" : (emotes)) of every wj emote typepath
GLOBAL_LIST_INIT(wj_emotes, setup_working_joe_emotes())
/// list of categories for hazard joes
GLOBAL_LIST_EMPTY(hj_categories)
/// dict ("category" : (emotes)) of every hj emote typepath
GLOBAL_LIST_INIT(hj_emotes, setup_hazard_joe_emotes())
/// list of categories for upp joes
GLOBAL_LIST_EMPTY(uppj_categories)
/// dict ("category" : (emotes)) of every uppj emote typepath
GLOBAL_LIST_INIT(uppj_emotes, setup_upp_joe_emotes())
/// list of categories for wy combat droids
GLOBAL_LIST_EMPTY(wy_droid_categories)
/// dict ("category" : (emotes)) of every wy droid emote typepath
GLOBAL_LIST_INIT(wy_droid_emotes, setup_wy_droid_emotes())

/proc/cached_params_decode(params_data, decode_proc)
	. = GLOB.paramslist_cache[params_data]
	if(!.)
		. = call(decode_proc)(params_data)
		GLOB.paramslist_cache[params_data] = .

/proc/key_number_decode(key_number_data)
	var/list/L = params2list(key_number_data)
	for(var/key in L)
		L[key] = text2num(L[key])
	return L

/proc/number_list_decode(number_list_data)
	var/list/L = params2list(number_list_data)
	for(var/i in 1 to length(L))
		L[i] = text2num(L[i])
	return L

/proc/setup_species()
	var/rkey = 0
	var/list/all_species = list()
	for(var/T in subtypesof(/datum/species))
		rkey++
		var/datum/species/S = new T
		S.race_key = rkey //Used in mob icon caching.
		var/datum/species/existing = all_species[S.name]
		if(existing)
			stack_trace("[S.name] from [T] overlaps with [existing.type]! It must have a unique name for lookup!")
		all_species[S.name] = S
	return all_species

/proc/setup_ship_weapon()
	var/list/ammo_list = list()
	for(var/weapon_type in subtypesof(/datum/space_weapon))
		var/datum/space_weapon/new_weapon  = new weapon_type
		ammo_list[new_weapon.type] = new_weapon
	return ammo_list

/proc/setup_ship_ammo()
	var/list/ammo_list = list()
	for(var/ammo_type in subtypesof(/datum/space_weapon_ammo))
		var/datum/space_weapon_ammo/new_ammo = new ammo_type
		ammo_list[new_ammo.type] = new_ammo
	return ammo_list

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
		var/datum/equipment_preset/existing = gear_path_presets_list[EP.name]
		if(existing)
			stack_trace("[EP.name] from [T] overlaps with [existing.type]! It must have a unique name for lookup!")
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
			gap = floor(gap / 1.247330950103979)
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
		HUD_ALIEN = new /datum/custom_hud/alien()
	)

/proc/setup_human_huds()
	var/list/human_huds = list()
	for(var/type in GLOB.custom_huds_list - list(HUD_ALIEN, HUD_ROBOT))
		human_huds += type
	return human_huds

/proc/setup_yautja_capes()
	var/list/cape_list = list()
	for(var/obj/item/clothing/yautja_cape/cape_type as anything in typesof(/obj/item/clothing/yautja_cape))
		var/cape_name = initial(cape_type.name)
		var/obj/item/clothing/yautja_cape/existing = cape_list[cape_name]
		if(existing)
			stack_trace("[cape_name] from [cape_type] overlaps with [existing.type]! It must have a unique name for lookup!")
		cape_list[cape_name] = cape_type
	return cape_list


/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in GLOB.chemical_reactions_filtered_list)
		. += "GLOB.chemical_reactions_filtered_list\[\"[reaction]\"\] = \"[GLOB.chemical_reactions_filtered_list[reaction]]\"\n"
		if(islist(GLOB.chemical_reactions_filtered_list[reaction]))
			var/list/L = GLOB.chemical_reactions_filtered_list[reaction]
			for(var/t in L)
				. += " has: [t]\n"
	world << .
*/

GLOBAL_REFERENCE_LIST_INDEXED(all_skills, /datum/skill, skill_name)


// Timelock
GLOBAL_LIST_EMPTY(timelocks)

GLOBAL_LIST_EMPTY_TYPED(specialist_set_name_dict, /datum/specialist_set)
GLOBAL_LIST_INIT_TYPED(specialist_set_datums, /datum/specialist_set, setup_specialist_sets())

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

/// Setup for Working joe emotes and category list, returns data for wj_emotes
/proc/setup_working_joe_emotes()
	var/list/emotes_to_add = list()
	for(var/datum/emote/living/carbon/human/synthetic/working_joe/emote as anything in subtypesof(/datum/emote/living/carbon/human/synthetic/working_joe))
		if(!(initial(emote.joe_flag) & WORKING_JOE_EMOTE) || !initial(emote.key) || !initial(emote.say_message))
			continue

		if(!(initial(emote.category) in GLOB.wj_categories))
			GLOB.wj_categories += initial(emote.category)

		emotes_to_add += emote
	return emotes_to_add

/// Setup for Hazard joe emotes and category list, returns data for hj_emotes
/proc/setup_hazard_joe_emotes()
	var/list/emotes_to_add = list()
	for(var/datum/emote/living/carbon/human/synthetic/working_joe/emote as anything in subtypesof(/datum/emote/living/carbon/human/synthetic/working_joe))
		if(!(initial(emote.joe_flag) & HAZARD_JOE_EMOTE) || !initial(emote.key) || !initial(emote.say_message))
			continue

		if(!(initial(emote.category) in GLOB.hj_categories))
			GLOB.hj_categories += initial(emote.category)

		emotes_to_add += emote
	return emotes_to_add

/// Setup for UPP joe emotes and category list, returns data for uppj_emotes
/proc/setup_upp_joe_emotes()
	var/list/emotes_to_add = list()
	for(var/datum/emote/living/carbon/human/synthetic/working_joe/emote as anything in subtypesof(/datum/emote/living/carbon/human/synthetic/working_joe))
		if(!(initial(emote.joe_flag) & UPP_JOE_EMOTE) || !initial(emote.key) || !initial(emote.say_message))
			continue

		if(!(initial(emote.category) in GLOB.uppj_categories))
			GLOB.uppj_categories += initial(emote.category)

		emotes_to_add += emote
	return emotes_to_add

/// Setup for WY droid emotes and category list, returns data for wy_droid_emotes
/proc/setup_wy_droid_emotes()
	var/list/emotes_to_add = list()
	for(var/datum/emote/living/carbon/human/synthetic/colonial/wy_droid/emote as anything in subtypesof(/datum/emote/living/carbon/human/synthetic/colonial/wy_droid))
		if(!initial(emote.key) || !initial(emote.say_message))
			continue

		if(!(initial(emote.category) in GLOB.wy_droid_categories))
			GLOB.wy_droid_categories += initial(emote.category)

		emotes_to_add += emote
	return emotes_to_add

GLOBAL_LIST_EMPTY(topic_tokens)
GLOBAL_PROTECT(topic_tokens)

GLOBAL_LIST_EMPTY(topic_commands)
GLOBAL_PROTECT(topic_commands)
