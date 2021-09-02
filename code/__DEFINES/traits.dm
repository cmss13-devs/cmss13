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
		} else { \
			_L = target.status_traits; \
			if (_L[trait]) { \
				_L[trait] |= list(source); \
			} else { \
				_L[trait] = list(source); \
				SEND_SIGNAL(target, SIGNAL_ADDTRAIT(trait), trait); \
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
					}; \
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
					}; \
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

// HIVE TRAITS
 /// If the Hive is a Xenonid Hive
#define TRAIT_XENONID "t_xenonid"

// MISC MOB TRAITS
 /// If the mob is nested.
#define TRAIT_NESTED "t_nested"
 /// If the mob can crawl through pipes equipped
#define TRAIT_CRAWLER "t_crawler"
 /// If the mob is hidden from examination
#define TRAIT_SIMPLE_DESC "t_simple_desc"
 /// If the mob can handle the superheavy two-bore rifle and speaks its fluff lines when landing hits with it.
#define TRAIT_TWOBORE_TRAINING "t_twobore"
 /// If the mob has equipment that alleviates nearsightedness
#define TRAIT_NEARSIGHTED_EQUIPMENT "t_nearsighted_eq"



//-- item traits --
// TOOL TRAITS
#define TRAIT_TOOL_SCREWDRIVER "t_tool_screwdriver"
#define TRAIT_TOOL_CROWBAR "t_tool_crowbar"
#define TRAIT_TOOL_WIRECUTTERS "t_tool_wirecutters"
#define TRAIT_TOOL_WRENCH "t_tool_wrench"
#define TRAIT_TOOL_MULTITOOL "t_tool_multitool"

//If an item with this trait is in an ear slot, no other item with this trait can fit in the other ear slot
#define TRAIT_ITEM_EAR_EXCLUSIVE "t_item_ear_exclusive"

//List of all traits
GLOBAL_LIST_INIT(mob_traits, list(
	TRAIT_YAUTJA_TECH,
	TRAIT_SUPER_STRONG,
	TRAIT_FOREIGN_BIO,
	TRAIT_INTENT_EYES,
	TRAIT_NESTED,
	TRAIT_CRAWLER,
	TRAIT_SIMPLE_DESC,
	TRAIT_TWOBORE_TRAINING
))

//trait SOURCES
/// Example trait source
// #define TRAIT_SOURCE_Y "t_s_y"
#define TRAIT_SOURCE_GENERIC "t_s_generic"
//-- mob traits --
 ///Status trait coming from species. .human/species_gain()
#define TRAIT_SOURCE_SPECIES "t_s_species"
 ///Status trait coming from the hive.
#define TRAIT_SOURCE_HIVE "t_s_hive"
 ///Status trait coming from being buckled.
#define TRAIT_SOURCE_BUCKLE "t_s_buckle"
 ///Status trait coming from tools
#define TRAIT_SOURCE_TOOL "t_s_tool"
 ///Status trait coming from roundstart quirks (that don't exist yet). Unremovable by REMOVE_TRAIT
#define TRAIT_SOURCE_QUIRK "t_s_quirk"
 ///Status trait forced by staff
#define TRAIT_SOURCE_ADMIN "t_s_admin"
 ///Status trait coming from worn clothing
#define TRAIT_SOURCE_CLOTHING "t_s_clothing"