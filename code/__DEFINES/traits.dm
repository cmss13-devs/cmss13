//shamelessly ripped from TG
#define SIGNAL_ADDTRAIT(trait_ref) "addtrait [trait_ref]"
#define SIGNAL_REMOVETRAIT(trait_ref) "removetrait [trait_ref]"

// trait accessor defines
//here be dragons
#define ADD_TRAIT(target, trait, source) \
	do { \
		var/list/_L; \
		if (!target.status_traits) { \
			target.status_traits = list(); \
			_L = target.status_traits; \
			_L[trait] = list(source); \
			SEND_SIGNAL(target, SIGNAL_ADDTRAIT(trait), trait); \
			if(trait in GLOB.traits_with_elements){ \
				target.AddElement(GLOB.traits_with_elements[trait]); \
			} \
		} else { \
			_L = target.status_traits; \
			if (_L[trait]) { \
				_L[trait] |= list(source); \
			} else { \
				_L[trait] = list(source); \
				SEND_SIGNAL(target, SIGNAL_ADDTRAIT(trait), trait); \
				if(trait in GLOB.traits_with_elements){ \
					target.AddElement(GLOB.traits_with_elements[trait]); \
				} \
			} \
		} \
	} while (0)
#define REMOVE_TRAIT(target, trait, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S; \
		if (sources && !islist(sources)) { \
			_S = list(sources); \
		} else { \
			_S = sources\
		}; \
		if (_L && _L[trait]) { \
			for (var/_T in _L[trait]) { \
				if ((!_S && (_T != TRAIT_SOURCE_QUIRK)) || (_T in _S)) { \
					_L[trait] -= _T \
				} \
			};\
			if (!length(_L[trait])) { \
				_L -= trait; \
				SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(trait), trait); \
				if(trait in GLOB.traits_with_elements) { \
					target.RemoveElement(GLOB.traits_with_elements[trait]); \
				} \
			}; \
			if (!length(_L)) { \
				target.status_traits = null \
			}; \
		} \
	} while (0)
#define REMOVE_TRAITS_NOT_IN(target, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S = sources; \
		if (_L) { \
			for (var/_T in _L) { \
				_L[_T] &= _S;\
				if (!length(_L[_T])) { \
					_L -= _T; \
					SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(_T), _T); \
					if(_T in GLOB.traits_with_elements) { \
						target.RemoveElement(GLOB.traits_with_elements[_T]); \
					}; \
				};\
			};\
			if (!length(_L)) { \
				target.status_traits = null\
			};\
		}\
	} while (0)

#define REMOVE_TRAITS_IN(target, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S = sources; \
		if (sources && !islist(sources)) { \
			_S = list(sources); \
		} else { \
			_S = sources\
		}; \
		if (_L) { \
			for (var/_T in _L) { \
				_L[_T] -= _S;\
				if (!length(_L[_T])) { \
					_L -= _T; \
					SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(_T)); \
					if(_T in GLOB.traits_with_elements) { \
						target.RemoveElement(GLOB.traits_with_elements[_T]); \
					}; \
				};\
			};\
			if (!length(_L)) { \
				target.status_traits = null\
			};\
		}\
	} while (0)

#define HAS_TRAIT(target, trait) (target.status_traits ? (target.status_traits[trait] ? TRUE : FALSE) : FALSE)
#define HAS_TRAIT_FROM(target, trait, source) (target.status_traits ? (target.status_traits[trait] ? (source in target.status_traits[trait]) : FALSE) : FALSE)
#define HAS_TRAIT_FROM_ONLY(target, trait, source) (\
	target.status_traits ?\
		(target.status_traits[trait] ?\
			((source in target.status_traits[trait]) && (length(target.status_traits) == 1))\
			: FALSE)\
		: FALSE)
#define HAS_TRAIT_NOT_FROM(target, trait, source) (target.status_traits ? (target.status_traits[trait] ? (length(target.status_traits[trait] - source) > 0) : FALSE) : FALSE)


/// Example trait
// #define TRAIT_X "t_x"
//-- mob traits --
// SPECIES TRAITS
/// Knowledge of Yautja technology
#define TRAIT_YAUTJA_TECH "t_yautja_tech"
/// Absolutely RIPPED. Can do misc. heavyweight stuff others can't. (Yautja, Synths)
#define TRAIT_SUPER_STRONG "t_super_strong"
/// Foreign biology. Basic medHUDs won't show the mob. (Yautja, Zombies)
#define TRAIT_FOREIGN_BIO "t_foreign_bio"
/// Eye color changes on intent. (G1 Synths)
#define TRAIT_INTENT_EYES "t_intent_eyes"
/// Masked synthetic biology. Basic medHUDs will percieve the mob as human. (Infiltrator Synths)
#define TRAIT_INFILTRATOR_SYNTH "t_infiltrator_synth"

// HIVE TRAITS
/// If the Hive is a Xenonid Hive
#define TRAIT_XENONID "t_xenonid"
/// If the Hive delays round end (this is overriden for some hives). Does not occur naturally. Must be applied in events.
#define TRAIT_NO_HIVE_DELAY "t_no_hive_delay"
/// If the Hive uses it's colors on the mobs. Does not occur naturally, excepting the Mutated hive.
#define TRAIT_NO_COLOR "t_no_color"

// MISC MOB TRAITS
/// If the mob is nested.
#define TRAIT_NESTED "t_nested"
/// If the mob can crawl through pipes equipped
#define TRAIT_CRAWLER "t_crawler"
/// If the mob is hidden from examination
#define TRAIT_SIMPLE_DESC "t_simple_desc"
/// Replace s with th in talking
#define TRAIT_LISPING "t_lisping"
/// If the mob can handle the superheavy two-bore rifle and speaks its fluff lines when landing hits with it.
#define TRAIT_TWOBORE_TRAINING "t_twobore"
/// If the mob has equipment that alleviates nearsightedness
#define TRAIT_NEARSIGHTED_EQUIPMENT "t_nearsighted_eq"
/// If the mob is affected by drag delay.area
#define TRAIT_DEXTROUS "t_dextrous"
/// If the mob is currently charging (xeno only)
#define TRAIT_CHARGING "t_charging"
/// If the mob has leadership abilities (giving orders).
#define TRAIT_LEADERSHIP "t_leadership"
/// If the mob can see the reagents contents of stuff
#define TRAIT_REAGENT_SCANNER "reagent_scanner"
/// If the mob is being lazed by a sniper spotter
#define TRAIT_SPOTTER_LAZED "t_spotter_lazed"
/// If the mob has ear protection. Protects from external ear damage effects. Includes explosions, firing the RPG, screeching DEAFNESS only, and flashbangs.
#define TRAIT_EAR_PROTECTION "t_ear_protection"
/// If the mob is Santa. Enough said.
#define TRAIT_SANTA "t_santa"
/// If the mob is wearing bimex glasses. Used for badass laser deflection flavor text.
#define TRAIT_BIMEX "t_bimex"
///Stops emote cooldown
#define TRAIT_EMOTE_CD_EXEMPT "t_emote_cd_exempt"
/// If the mob is holding a cane.
#define TRAIT_HOLDS_CANE "t_holds_cane"

// -- ability traits --
/// Xenos with this trait cannot have plasma transfered to them
#define TRAIT_ABILITY_NO_PLASMA_TRANSFER "t_ability_no_plasma_transfer"
/// Shows that the xeno queen is on ovi
#define TRAIT_ABILITY_OVIPOSITOR "t_ability_ovipositor"

//-- item traits --
// TOOL TRAITS
#define TRAIT_TOOL_SCREWDRIVER "t_tool_screwdriver"
#define TRAIT_TOOL_CROWBAR "t_tool_crowbar"
#define TRAIT_TOOL_WIRECUTTERS "t_tool_wirecutters"
#define TRAIT_TOOL_WRENCH "t_tool_wrench"
#define TRAIT_TOOL_MULTITOOL "t_tool_multitool"

#define TRAIT_TOOL_BLOWTORCH "t_tool_blowtorch"
#define TRAIT_TOOL_SIMPLE_BLOWTORCH "t_tool_simple_blowtorch"

#define TRAIT_TOOL_PEN "t_tool_pen"

// GUN TRAITS
#define TRAIT_GUN_SILENCED "t_gun_silenced"

// Miscellaneous item traits.
// Do NOT bloat this category, if needed make a new category (like shoe traits, xeno item traits...)

//If an item with this trait is in an ear slot, no other item with this trait can fit in the other ear slot
#define TRAIT_ITEM_EAR_EXCLUSIVE "t_item_ear_exclusive"

//This item will force clickdrag to work even if the preference to disable is enabled. (Full-auto items)
#define TRAIT_OVERRIDE_CLICKDRAG "t_override_clickdrag"

//-- structure traits --
// TABLE TRAITS
/// If the table is being flipped, prevent any changes that will mess with adjacency handling
#define TRAIT_TABLE_FLIPPING "t_table_flipping"

//List of all traits
GLOBAL_LIST_INIT(mob_traits, list(
	TRAIT_YAUTJA_TECH,
	TRAIT_SUPER_STRONG,
	TRAIT_FOREIGN_BIO,
	TRAIT_INTENT_EYES,
	TRAIT_NESTED,
	TRAIT_CRAWLER,
	TRAIT_SIMPLE_DESC,
	TRAIT_TWOBORE_TRAINING,
	TRAIT_LEADERSHIP,
	TRAIT_DEXTROUS,
	TRAIT_REAGENT_SCANNER
))

/*
	FUN ZONE OF ADMIN LISTINGS
	Try to keep this in sync with __DEFINES/traits.dm
	quirks have it's own panel so we don't need them here.
*/
GLOBAL_LIST_INIT(traits_by_type, list(
	/mob = list(
		"TRAIT_YAUTJA_TECH" = TRAIT_YAUTJA_TECH,
		"TRAIT_SUPER_STRONG" = TRAIT_SUPER_STRONG,
		"TRAIT_FOREIGN_BIO" = TRAIT_FOREIGN_BIO,
		"TRAIT_INTENT_EYES" = TRAIT_INTENT_EYES,
		"TRAIT_INFILTRATOR_SYNTH" = TRAIT_INFILTRATOR_SYNTH,
		"TRAIT_NESTED" = TRAIT_NESTED,
		"TRAIT_CRAWLER" = TRAIT_CRAWLER,
		"TRAIT_SIMPLE_DESC" = TRAIT_SIMPLE_DESC,
		"TRAIT_TWOBORE_TRAINING" = TRAIT_TWOBORE_TRAINING,
		"TRAIT_NEARSIGHTED_EQUIPMENT" = TRAIT_NEARSIGHTED_EQUIPMENT,
		"TRAIT_DEXTROUS" = TRAIT_DEXTROUS,
		"TRAIT_CHARGING" = TRAIT_CHARGING,
		"TRAIT_LEADERSHIP" = TRAIT_LEADERSHIP,
		"TRAIT_REAGENT_SCANNER" = TRAIT_REAGENT_SCANNER,
		"TRAIT_SPOTTER_LAZED" = TRAIT_SPOTTER_LAZED,
		"TRAIT_EAR_PROTECTION" = TRAIT_EAR_PROTECTION,
		"TRAIT_SANTA" = TRAIT_SANTA,
		"TRAIT_BIMEX" = TRAIT_BIMEX,
		"TRAIT_EMOTE_CD_EXEMPT" = TRAIT_EMOTE_CD_EXEMPT,
		"TRAIT_LISPING" = TRAIT_LISPING,
	),
	/mob/living/carbon/xenomorph = list(
		"TRAIT_ABILITY_NO_PLASMA_TRANSFER" = TRAIT_ABILITY_NO_PLASMA_TRANSFER,
		"TRAIT_ABILITY_OVIPOSITOR" = TRAIT_ABILITY_OVIPOSITOR,
	),
	/datum/hive_status = list(
		"TRAIT_XENONID" = TRAIT_XENONID,
		"TRAIT_NO_HIVE_DELAY" = TRAIT_NO_HIVE_DELAY,
		"TRAIT_NO_COLOR" = TRAIT_NO_COLOR,
	),
	/obj/item = list(
		"TRAIT_TOOL_SCREWDRIVER" = TRAIT_TOOL_SCREWDRIVER,
		"TRAIT_TOOL_CROWBAR" = TRAIT_TOOL_CROWBAR,
		"TRAIT_TOOL_WIRECUTTERS" = TRAIT_TOOL_WIRECUTTERS,
		"TRAIT_TOOL_WRENCH" = TRAIT_TOOL_WRENCH,
		"TRAIT_TOOL_MULTITOOL" = TRAIT_TOOL_MULTITOOL,
		"TRAIT_TOOL_BLOWTORCH" = TRAIT_TOOL_BLOWTORCH,
		"TRAIT_TOOL_SIMPLE_BLOWTORCH" = TRAIT_TOOL_SIMPLE_BLOWTORCH,
		"TRAIT_TOOL_PEN" = TRAIT_TOOL_PEN,
		"TRAIT_ITEM_EAR_EXCLUSIVE" = TRAIT_ITEM_EAR_EXCLUSIVE,
		"TRAIT_OVERRIDE_CLICKDRAG" = TRAIT_OVERRIDE_CLICKDRAG,
	),
	/obj/item/weapon/gun = list(
		"TRAIT_GUN_SILENCED" = TRAIT_GUN_SILENCED,
	),
	/obj/structure/surface/table = list(
		"TRAIT_STRUCTURE_FLIPPING" = TRAIT_TABLE_FLIPPING,
	)
))

/// value -> trait name, generated on use from trait_by_type global
GLOBAL_LIST(trait_name_map)

/proc/generate_trait_name_map()
	. = list()
	for(var/key in GLOB.traits_by_type)
		for(var/tname in GLOB.traits_by_type[key])
			var/val = GLOB.traits_by_type[key][tname]
			.[val] = tname



//trait SOURCES
/// Example trait source
// #define TRAIT_SOURCE_Y "t_s_y"
#define TRAIT_SOURCE_INHERENT "t_s_inherent"
//-- mob traits --
///Status trait coming from species. .human/species_gain()
#define TRAIT_SOURCE_SPECIES "t_s_species"
///Status trait coming from the hive.
#define TRAIT_SOURCE_HIVE "t_s_hive"
///Status trait coming from being buckled.
#define TRAIT_SOURCE_BUCKLE "t_s_buckle"
///Status trait coming from roundstart quirks (that don't exist yet). Unremovable by REMOVE_TRAIT
#define TRAIT_SOURCE_QUIRK "t_s_quirk"
///Status trait coming from being assigned as [acting] squad leader.
#define TRAIT_SOURCE_SQUAD_LEADER "t_s_squad_leader"
///Status trait coming from their job
#define TRAIT_SOURCE_JOB "t_s_job"
///Status trait forced by staff
#define TRAIT_SOURCE_ADMIN "t_s_admin"
///Status trait coming from equipment
#define TRAIT_SOURCE_EQUIPMENT(slot) "t_s_equipment_[slot]"
///Status trait coming from skill
#define TRAIT_SOURCE_SKILL(skill) "t_s_skill_[skill]"
///Status trait coming from attachment
#define TRAIT_SOURCE_ATTACHMENT(slot) "t_s_attachment_[slot]"
///Status trait coming from ability
#define TRAIT_SOURCE_ABILITY(ability) "t_s_ability_[ability]"
///Status trait forced by the xeno action charge
#define TRAIT_SOURCE_XENO_ACTION_CHARGE "t_s_xeno_action_charge"
//-- structure traits --
///Status trait coming from being flipped or unflipped.
#define TRAIT_SOURCE_FLIP_TABLE "t_s_flip_table"

///Status trait from weapons?? buh
#define TRAIT_SOURCE_WEAPON "t_s_weapon"
///Status trait coming from generic items
#define TRAIT_SOURCE_ITEM "t_s_item"
