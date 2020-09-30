var/list/clients = list()					//list of all clients
var/list/admins = list()					//list of all clients whom are admins
var/list/directory = list()					//list of all ckeys with associated client
var/list/unansweredAhelps = list()			//This feels inefficient, but I can't think of a better way. Stores the message indexed by CID
var/list/CLFaxes = list()					//List of all CL faxes sent this round
var/list/fax_contents = list() 				//List of fax contents to maintain it even if source paper is deleted
var/list/USCMFaxes = list()					//List of all USCM faxes sent this round
var/list/active_tracking_beacons = list()	//List of all active squad tracking beacons

//Names of maps that can be compiled on
var/list/DEFAULT_NEXT_MAP_CANDIDATES = list(MAP_LV_624, MAP_BIG_RED, MAP_WHISKEY_OUTPOST, MAP_DESERT_DAM, MAP_ICE_COLONY, MAP_PRISON_STATION, MAP_CORSAT, MAP_SOROKYNE_STRATA, MAP_KUTJEVO)
var/list/LOWPOP_NEXT_MAP_CANDIDATES = list(MAP_LV_624, MAP_BIG_RED, MAP_PRISON_STATION, MAP_KUTJEVO)
var/list/NOTVOTABLE_MAPS = list(MAP_WHISKEY_OUTPOST, MAP_ICE_COLONY)
var/list/NEXT_MAP_CANDIDATES = DEFAULT_NEXT_MAP_CANDIDATES.Copy() - NOTVOTABLE_MAPS
var/list/MAPS_COLD_TEMP = list(MAP_ICE_COLONY, MAP_SOROKYNE_STRATA, MAP_CORSAT)

//List of player votes. Name of the map from NEXT_MAP_CANDIADATES indexed by ckey
var/list/player_votes = list()

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

var/global/list/player_list = list()				//List of all mobs **with clients attached**.
var/global/list/mob_list = list()					//List of all mobs, including clientless
var/global/list/living_mob_list = list()			//List of all alive mobs, including clientless. Excludes /mob/new_player
var/global/list/dead_mob_list = list()				//List of all dead mobs, including clientless. Excludes /mob/new_player

var/global/list/xeno_mob_list = list() 				// list of all /mob/living/carbon/Xenomorph mobs
var/global/list/living_xeno_list = list()			//List of all alive mob/living/carbon/Xenomorph mobs

var/global/list/yautja_mob_list = list()

var/global/list/human_mob_list = list() // list of all /mob/living/carbon/human mobs
var/global/list/processable_human_list = list() //List of all humans to be processed by the SS
var/global/list/living_human_list = list() // list of alive marines
var/global/list/human_agent_list
var/global/list/other_factions_human_list

var/global/list/living_misc_mobs = list() // anything that isnt a xeno or human

var/global/list/ai_mob_list = list()				//List of all AIs

var/global/list/freed_mob_list = list() 	// List of mobs freed for ghosts

var/global/list/xeno_datum_list = list() // multi-d list of xeno datums

//Chem Stuff
var/global/list/chemical_reactions_filtered_list	//List of all /datum/chemical_reaction datums filtered by reaction components. Used during chemical reactions
var/global/list/chemical_reactions_list		//List of all /datum/chemical_reaction datums indexed by reaction id. Used to search for the result instead of the components.
var/global/list/chemical_reagents_list		//List of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
var/global/list/chemical_properties_list	//List of all /datum/chem_property datums indexed by property name
var/global/list/chemical_objective_list	 = list()	//List of all objective reagents indexed by ID associated with the objective value
var/global/list/chemical_identified_list = list()	//List of all identified objective reagents indexed by ID associated with the objective value
//List of all id's from classed /datum/reagent datums indexed by class or tier. Used by chemistry generator and chem spawners.
var/global/list/list/chemical_gen_classes_list = list("C" = list(),"C1" = list(),"C2" = list(),"C3" = list(),"C4" = list(),"C5" = list(),"C6" = list(),"T1" = list(),"T2" = list(),"T3" = list(),"T4" = list(),"omega" = list(),"tau" = list())

var/global/list/landmarks_list = list()				//List of all landmarks created
var/global/list/surgery_steps = list()				//List of all surgery steps  |BS12
var/global/list/side_effects = list()				//List of all medical sideeffects types by thier names |BS12
var/global/list/ammo_list = list()					//List of all ammo types. Used by guns to tell the projectile how to act.
var/global/list/joblist = list()					//List of all jobstypes, minus borg and AI

var/global/list/datum/equipment_preset/gear_presets_list = list()

var/global/list/structure_list = list()				//List of all /obj/structure as they are created, to fetch generic structures with a lot less lag
var/global/list/active_areas = list()
var/global/list/all_areas = list()

var/global/list/turfs = list()
var/global/list/z1turfs = list()
var/global/list/processing_turfs = list()
var/global/list/object_list = list()
var/global/list/item_list = list()
var/global/list/effect_list = list()
var/global/list/cm_vending_vendors = list() //Used by our gamemode code

/var/global/list/objects_of_interest // This is used to track the stealing objective for Agents.

// exceptions to grenade antigrief
var/global/list/grenade_antigrief_exempt_areas = list(
)

var/global/list/yautja_gear = list() // list of loose pred gear
var/global/list/untracked_yautja_gear = list() // List of untracked loose pred gear

var/global/list/gun_cabinets = list()

var/global/list/marine_collectors = list() // Collectors used for marine defenses. They mine.

var/global/list/cm_objectives = list()

//Languages/species/whitelist.
var/global/list/all_species[0]
var/global/list/all_languages[0]
var/global/list/language_keys[0]					//table of say codes for all languages
var/global/list/whitelisted_species = list("Human")
var/global/list/synth_types = list("Synthetic","Second Generation Synthetic")

//Xeno mutators
var/global/list/datum/xeno_mutator/xeno_mutator_list = list()

//Xeno hives
var/global/list/datum/hive_status/hive_datum = list(new /datum/hive_status(), new /datum/hive_status/corrupted(), new /datum/hive_status/alpha(), new /datum/hive_status/bravo(), new /datum/hive_status/charlie(), new /datum/hive_status/delta())

//DEFCON rewards / assets
var/global/list/datum/defcon_reward/defcon_reward_list = list()

// Posters
var/global/list/datum/poster/poster_designs = typesof(/datum/poster) - /datum/poster

//Preferences stuff
	// Ethnicities
var/global/list/ethnicities_list = list()			// Stores /datum/ethnicity indexed by name
	// Body Types
var/global/list/body_types_list = list()			// Stores /datum/body_type indexed by name
	//Hairstyles
var/global/list/hair_styles_list = list()			//stores /datum/sprite_accessory/hair indexed by name
var/global/list/hair_styles_male_list = list()
var/global/list/hair_styles_female_list = list()
var/global/list/facial_hair_styles_list = list()	//stores /datum/sprite_accessory/facial_hair indexed by name
var/global/list/facial_hair_styles_male_list = list()
var/global/list/facial_hair_styles_female_list = list()
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

// Resin constructions parameters
var/global/list/resin_constructions_list = list()

var/global/list/resin_build_order_default = list()
var/global/list/resin_build_order_hivelord = list()

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

//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/makeDatumRefLists()
	var/list/paths

	// Ethnicity - Initialise all /datum/ethnicity into a list indexed by ethnicity name
	paths = typesof(/datum/ethnicity) - /datum/ethnicity
	ethnicities_list = list()
	for (var/path in paths)
		var/datum/ethnicity/E = new path()
		ethnicities_list[E.name] = E

	// Body Type - Initialise all /datum/body_type into a list indexed by body_type name
	paths = typesof(/datum/body_type) - /datum/body_type
	body_types_list = list()
	for (var/path in paths)
		var/datum/body_type/B = new path()
		body_types_list[B.name] = B

	// Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	hair_styles_list = list()
	hair_styles_male_list = list()
	hair_styles_female_list = list()
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	hair_styles_male_list += H.name
			if(FEMALE)	hair_styles_female_list += H.name
			else
				hair_styles_male_list += H.name
				hair_styles_female_list += H.name

	// Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	facial_hair_styles_list = list()
	facial_hair_styles_male_list = list()
	facial_hair_styles_female_list = list()
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	facial_hair_styles_male_list += H.name
			if(FEMALE)	facial_hair_styles_female_list += H.name
			else
				facial_hair_styles_male_list += H.name
				facial_hair_styles_female_list += H.name

	// Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = typesof(/datum/surgery_step)-/datum/surgery_step
	surgery_steps = list()
	for(var/T in paths)
		var/datum/surgery_step/S = new T
		surgery_steps += S
	sort_surgeries()

	// List of job. I can't believe this was calculated multiple times per tick!
	paths = typesof(/datum/job)-/datum/job
	joblist = list()
	// paths -= exclude_jobs
	for(var/T in paths)
		var/datum/job/J = new T
		joblist[J.title] = J

	// Languages and species.
	paths = typesof(/datum/language)-/datum/language
	all_languages = list()
	for(var/T in paths)
		var/datum/language/L = new T
		all_languages[L.name] = L

	language_keys = list()
	for (var/language_name in all_languages)
		var/datum/language/L = all_languages[language_name]
		language_keys[":[lowertext(L.key)]"] = L
		language_keys[".[lowertext(L.key)]"] = L
		language_keys["#[lowertext(L.key)]"] = L

	var/rkey = 0
	paths = typesof(/datum/species)-/datum/species
	all_species = list()
	whitelisted_species = list()
	for(var/T in paths)
		rkey++
		var/datum/species/S = new T
		S.race_key = rkey //Used in mob icon caching.
		all_species[S.name] = S

		if(S.flags & IS_WHITELISTED)
			whitelisted_species += S.name

	// Our ammo stuff is initialized here.
	var/blacklist[] = list(/datum/ammo,/datum/ammo/energy, /datum/ammo/energy/yautja, /datum/ammo/energy/yautja/rifle, /datum/ammo/bullet/shotgun, /datum/ammo/xeno)
	paths = typesof(/datum/ammo) - blacklist
	ammo_list = list()
	for(var/T in paths)
		var/datum/ammo/A = new T
		ammo_list[A.type] = A

	// Resin constructions
	paths = typesof(/datum/resin_construction) - list(/datum/resin_construction, /datum/resin_construction/resin_obj, /datum/resin_construction/resin_turf)
	resin_constructions_list = list()
	for (var/T in paths)
		var/datum/resin_construction/RC = new T
		resin_constructions_list[RC.name] = RC
	resin_constructions_list = sortAssoc(resin_constructions_list)
	resin_build_order_default = list(
		resin_constructions_list["Resin Wall"],
		resin_constructions_list["Resin Membrane"],
		resin_constructions_list["Resin Nest"],
		resin_constructions_list["Sticky Resin"],
		resin_constructions_list["Fast Resin"],
		resin_constructions_list["Resin Door"]
	)
	resin_build_order_hivelord = list(
		resin_constructions_list["Thick Resin Wall"],
		resin_constructions_list["Thick Resin Membrane"],
		resin_constructions_list["Resin Nest"],
		resin_constructions_list["Sticky Resin"],
		resin_constructions_list["Fast Resin"],
		resin_constructions_list["Thick Resin Door"]
	)

	//  Xeno datums
	paths = typesof(/datum/caste_datum) - /datum/caste_datum
	xeno_datum_list = list()
	for(var/T in paths)
		var/datum/caste_datum/CD = new T
		xeno_datum_list[CD.caste_name] = CD

    // Equipment presets
	paths = typesof(/datum/equipment_preset)
	gear_presets_list = list()
	for(var/T in paths)
		var/datum/equipment_preset/EP = T
		if (!initial(EP.flags))
			continue
		EP = new T
		gear_presets_list[EP.name] = EP
	gear_presets_list = sortAssoc(gear_presets_list)

	// Xeno mutators
	paths = typesof(/datum/xeno_mutator) - /datum/xeno_mutator
	xeno_mutator_list = list()
	for(var/T in paths)
		var/datum/xeno_mutator/XM = new T
		xeno_mutator_list[XM.name] = XM
	xeno_mutator_list = sortAssoc(xeno_mutator_list)

	//DEFCON rewards / assets
	paths = typesof(/datum/defcon_reward) - /datum/defcon_reward
	defcon_reward_list = list()
	for(var/T in paths)
		var/datum/defcon_reward/DR = new T
		defcon_reward_list[DR.name] = DR
	defcon_reward_list = sortAssoc(defcon_reward_list)

	return 1

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
