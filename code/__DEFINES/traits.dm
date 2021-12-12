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
 /// If the mob is able to stand up as long as they have one source of support
#define TRAIT_EXTREME_BODY_BALANCE "t_extreme_body_balance"
 /// If the mob has additional support for standing up
#define TRAIT_ADDITIONAL_STAND_SUPPORT "t_additional_stand_support"
 /// Mob stutters
#define TRAIT_MOB_STUTTER "t_mob_stutter"
 /// Mob has weak hands
#define TRAIT_MOB_WEAK_HANDS "t_mob_weak_hands"
 /// If the mob is affected by drag delay.area
#define TRAIT_DEXTROUS "t_dextrous"

//-- item traits --

//If the item works as a crutch when held
#define TRAIT_CRUTCH "t_crutch"

// TOOL TRAITS
#define TRAIT_TOOL_SCREWDRIVER "t_tool_screwdriver"
#define TRAIT_TOOL_CROWBAR "t_tool_crowbar"
#define TRAIT_TOOL_WIRECUTTERS "t_tool_wirecutters"
#define TRAIT_TOOL_WRENCH "t_tool_wrench"
#define TRAIT_TOOL_MULTITOOL "t_tool_multitool"

//If an item with this trait is in an ear slot, no other item with this trait can fit in the other ear slot
#define TRAIT_ITEM_EAR_EXCLUSIVE "t_item_ear_exclusive"

//If the item can be used for more precise actions, such as digging shrapnel out of wounds or speeding up the process of removing something
#define TRAIT_PRECISE "t_precise"
//ORGAN TRAITS
#define TRAIT_ORGAN_MALFUNCTIONING "t_organ_malfunctioning"
#define TRAIT_ORGAN_BROKEN "t_organ_broken"

//LIMB TRAITS
#define TRAIT_LIMB_ALLOWS_STAND "t_limb_allows_stand"

//List of all traits
GLOBAL_LIST_INIT(mob_traits, list(
	TRAIT_YAUTJA_TECH,
	TRAIT_SUPER_STRONG,
	TRAIT_FOREIGN_BIO,
	TRAIT_NESTED,
	TRAIT_INTENT_EYES,
	TRAIT_CRAWLER,
	TRAIT_SIMPLE_DESC,
	TRAIT_TWOBORE_TRAINING,
	TRAIT_MOB_STUTTER,
	TRAIT_MOB_WEAK_HANDS,
	TRAIT_EXTREME_BODY_BALANCE,
	TRAIT_DEXTROUS
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
 ///Status trait coming from generic items
#define TRAIT_SOURCE_ITEM "t_s_item"
 ///Status trait coming from roundstart quirks (that don't exist yet). Unremovable by REMOVE_TRAIT
#define TRAIT_SOURCE_QUIRK "t_s_quirk"
 ///Status trait forced by staff
#define TRAIT_SOURCE_ADMIN "t_s_admin"
 ///Status trait coming from worn clothing
#define TRAIT_SOURCE_CLOTHING "t_s_clothing"
//Inherited from an organ
#define TRAIT_SOURCE_ORGAN "t_s_organ"
//Inherited from a limb
#define TRAIT_SOURCE_LIMB "t_s_limb"
//Inherited from a limb changing it's integrity level
#define TRAIT_SOURCE_INTEGRITY "t_s_integrity"
//Inherited from a helping action
#define TRAIT_SOURCE_HELP_ACTION "t_s_help_action"
 ///Status trait coming from equipment
#define TRAIT_SOURCE_EQUIPMENT(slot) "t_s_equipment_[slot]"
