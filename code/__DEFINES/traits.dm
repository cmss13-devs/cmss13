#define SIGNAL_ADDTRAIT(trait_ref) "addtrait [trait_ref]"
#define SIGNAL_REMOVETRAIT(trait_ref) "removetrait [trait_ref]"

// trait accessor defines
#define ADD_TRAIT(target, trait, source) \
	do { \
		var/list/_L; \
		if (!target._status_traits) { \
			target._status_traits = list(); \
			_L = target._status_traits; \
			_L[trait] = list(source); \
			SEND_SIGNAL(target, SIGNAL_ADDTRAIT(trait), trait); \
			if(trait in GLOB.traits_with_elements){ \
				target.AddElement(GLOB.traits_with_elements[trait]); \
			} \
		} else { \
			_L = target._status_traits; \
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
		var/list/_L = target._status_traits; \
		var/list/_S; \
		if (sources && !islist(sources)) { \
			_S = list(sources); \
		} else { \
			_S = sources\
		}; \
		if (_L?[trait]) { \
			for (var/_T in _L[trait]) { \
				if ((!_S && (_T != ROUNDSTART_TRAIT)) || (_T in _S)) { \
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
				target._status_traits = null \
			}; \
		} \
	} while (0)
#define REMOVE_TRAIT_NOT_FROM(target, trait, sources) \
	do { \
		var/list/_traits_list = target._status_traits; \
		var/list/_sources_list; \
		if (sources && !islist(sources)) { \
			_sources_list = list(sources); \
		} else { \
			_sources_list = sources\
		}; \
		if (_traits_list?[trait]) { \
			for (var/_trait_source in _traits_list[trait]) { \
				if (!(_trait_source in _sources_list)) { \
					_traits_list[trait] -= _trait_source \
				} \
			};\
			if (!length(_traits_list[trait])) { \
				_traits_list -= trait; \
				SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(trait), trait); \
				if(trait in GLOB.traits_with_elements) { \
					target.RemoveElement(GLOB.traits_with_elements[trait]); \
				} \
			}; \
			if (!length(_traits_list)) { \
				target._status_traits = null \
			}; \
		} \
	} while (0)
#define REMOVE_TRAITS_NOT_IN(target, sources) \
	do { \
		var/list/_L = target._status_traits; \
		var/list/_S = sources; \
		if (_L) { \
			for (var/_T in _L) { \
				_L[_T] &= _S;\
				if (!length(_L[_T])) { \
					_L -= _T; \
					SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(_T), _T); \
					if(trait in GLOB.traits_with_elements) { \
						target.RemoveElement(GLOB.traits_with_elements[trait]); \
					}; \
				};\
			};\
			if (!length(_L)) { \
				target._status_traits = null\
			};\
		}\
	} while (0)

#define REMOVE_TRAITS_IN(target, sources) \
	do { \
		var/list/_L = target._status_traits; \
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
				target._status_traits = null\
			};\
		}\
	} while (0)

#define HAS_TRAIT(target, trait) (target._status_traits?[trait] ? TRUE : FALSE)
#define HAS_TRAIT_FROM(target, trait, source) (HAS_TRAIT(target, trait) && (source in target._status_traits[trait]))
#define HAS_TRAIT_FROM_ONLY(target, trait, source) (HAS_TRAIT(target, trait) && (source in target._status_traits[trait]) && (length(target._status_traits[trait]) == 1))
#define HAS_TRAIT_NOT_FROM(target, trait, source) (HAS_TRAIT(target, trait) && (length(target._status_traits[trait] - source) > 0))
/// Returns a list of trait sources for this trait. Only useful for wacko cases and internal futzing
/// You should not be using this
#define GET_TRAIT_SOURCES(target, trait) (target._status_traits?[trait] || list())
/// Returns the amount of sources for a trait. useful if you don't want to have a "thing counter" stuck around all the time
#define COUNT_TRAIT_SOURCES(target, trait) length(GET_TRAIT_SOURCES(target, trait))
/// A simple helper for checking traits in a mob's mind
#define HAS_MIND_TRAIT(target, trait) (HAS_TRAIT(target, trait) || (target.mind ? HAS_TRAIT(target.mind, trait) : FALSE))

/// Example trait
// #define TRAIT_X "t_x"

//-- mob traits --
/// Apply this to make a mob not dense, and remove it when you want it to no longer make them undense, other sorces of undesity will still apply. Always define a unique source when adding a new instance of this!
#define TRAIT_UNDENSE "undense"
/// Forces the user to stay unconscious.
#define TRAIT_KNOCKEDOUT "knockedout"
/// Prevents voluntary movement.
#define TRAIT_IMMOBILIZED "immobilized"
/// Prevents voluntary standing or staying up on its own.
#define TRAIT_FLOORED "floored"
/// Forces user to stay standing
#define TRAIT_FORCED_STANDING "forcedstanding"
/// Stuns preventing movement and using objects but without further impairement
#define TRAIT_INCAPACITATED "incapacitated"
/// Disoriented. Unable to talk properly, and unable to use some skills as Xeno
#define TRAIT_DAZED "dazed"
/// Apply this to identify a mob as merged with weeds
#define TRAIT_MERGED_WITH_WEEDS "merged_with_weeds"
/// Apply this to identify a mob as temporarily muted
#define TRAIT_TEMPORARILY_MUTED "temporarily_muted"
/// Mob wont get hit by stray projectiles
#define TRAIT_NO_STRAY "trait_no_stray"
/// When a Xeno hauls us. We can take out our knife or gun if hauled though we are immobilized, also shielded from most damage.
#define TRAIT_HAULED "hauled"
// only used by valkyrie
#define TRAIT_VALKYRIE_ARMORED "trait_valkyrie_armored"

// SPECIES TRAITS
/// Knowledge of Yautja technology
#define TRAIT_YAUTJA_TECH "t_yautja_tech"
/// Absolutely RIPPED. Can do misc. heavyweight stuff others can't. (Yautja, Synths)
#define TRAIT_SUPER_STRONG "t_super_strong"
/// Foreign biology. Basic medHUDs won't show the mob. (Yautja, Zombies)
#define TRAIT_FOREIGN_BIO "t_foreign_bio"
/// Eye color changes on intent. (G1 Synths and WJs)
#define TRAIT_INTENT_EYES "t_intent_eyes"
/// Masked synthetic biology. Basic medHUDs will perceive the mob as human. (Infiltrator Synths)
#define TRAIT_INFILTRATOR_SYNTH "t_infiltrator_synth"
/// Makes it impossible to strip the inventory of this mob.
#define TRAIT_UNSTRIPPABLE "t_unstrippable"

// HIVE TRAITS
/// If the Hive is a Xenonid Hive
#define TRAIT_XENONID "t_xenonid"
/// if the xeno's connection to the hivemind is cut
#define TRAIT_HIVEMIND_INTERFERENCE "t_interference"
/// If the hive or xeno can use objects.
#define TRAIT_OPPOSABLE_THUMBS "t_thumbs"
/// If the hive or xeno can use playing cards.
#define TRAIT_CARDPLAYING_THUMBS "t_card_thumbs"
/// If the Hive delays round end (this is overridden for some hives). Does not occur naturally. Must be applied in events.
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
/// If the mob is affected by drag delay.
#define TRAIT_DEXTROUS "t_dextrous"
/// If the mob is currently charging (xeno only)
#define TRAIT_CHARGING "t_charging"
/// If the mob has leadership abilities (giving orders).
#define TRAIT_LEADERSHIP "t_leadership"
/// If the mob can see the reagents contents of stuff
#define TRAIT_REAGENT_SCANNER "reagent_scanner"
/// If the mob cannot eat/be fed
#define TRAIT_CANNOT_EAT "t_cannot_eat"
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
/// If the mob is buckled to a wheelchair.
#define TRAIT_USING_WHEELCHAIR "t_using_wheelchair"
/// If the mob will instantly go permadead upon death
#define TRAIT_HARDCORE "t_hardcore"
/// If the mob is able to use the vulture rifle or spotting scope
#define TRAIT_VULTURE_USER "t_vulture_user"
/// If the mob is currently loading a tutorial
#define TRAIT_IN_TUTORIAL "t_in_tutorial"
/// If the mob is cloaked in any form
#define TRAIT_CLOAKED "t_cloaked"
/// If the mob claimed a specialist set from a vendor
#define TRAIT_SPEC_VENDOR "t_spec_vendor"
/// If the mob claimed a specialist set from a kit
#define TRAIT_SPEC_KIT "t_spec_kit"
/// What spec set the mob has claimed, if any
#define TRAIT_SPEC(spec_type) "t_spec_[spec_type]"
/// If the mob won't drop items held in face slot when downed
#define TRAIT_IRON_TEETH "t_iron_teeth"

// -- ability traits --
/// Xenos with this trait cannot have plasma transfered to them
#define TRAIT_ABILITY_NO_PLASMA_TRANSFER "t_ability_no_plasma_transfer"
/// Shows that the xeno queen is on ovi
#define TRAIT_ABILITY_OVIPOSITOR "t_ability_ovipositor"
/// Used for burrowed mobs, prevent's SG/sentrys/claymores from autofiring
#define TRAIT_ABILITY_BURROWED "t_ability_burrowed"
/// Xenos with this trait can toggle long sight while resting.
#define TRAIT_ABILITY_SIGHT_IGNORE_REST "t_ability_sight_ignore_rest"

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

/// Can lockout blackmarket from ASRS console circuits.
#define TRAIT_TOOL_TRADEBAND "t_tool_tradeband"

/// Can hack ASRS consoles to access the black market
#define TRAIT_TOOL_BLACKMARKET_HACKER "t_tool_blackmarket_hacker"

// CLOTHING TRAITS
#define TRAIT_CLOTHING_HOOD "t_clothing_hood"

// GUN TRAITS
#define TRAIT_GUN_SILENCED "t_gun_silenced"

#define TRAIT_GUN_BIPODDED "t_gun_bipodded"

#define TRAIT_GUN_LIGHT_FORCE_DEACTIVATED "t_gun_light_deactivated"

/// If this ID belongs to an ERT member
#define TRAIT_ERT_ID "ert_id"

/// If this item can hear things from inside one level of contents.
#define TRAIT_HEARS_FROM_CONTENTS "t_hears_from_contents"

// Miscellaneous item traits.
// Do NOT bloat this category, if needed make a new category (like shoe traits, xeno item traits...)

//If an item with this trait is in an ear slot, no other item with this trait can fit in the other ear slot
#define TRAIT_ITEM_EAR_EXCLUSIVE "t_item_ear_exclusive"

//This item will force clickdrag to work even if the preference to disable is enabled. (Full-auto items)
#define TRAIT_OVERRIDE_CLICKDRAG "t_override_clickdrag"

//This item will use special rename component behaviors.
//ie. naming a regulation tape "example" will become regulation tape (example)
#define TRAIT_ITEM_RENAME_SPECIAL "t_item_rename_special"

// This item can't be implanted into someone, regardless of the size of the item.
#define TRAIT_ITEM_NOT_IMPLANTABLE "t_item_not_implantable"

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
	TRAIT_REAGENT_SCANNER,
	TRAIT_ABILITY_BURROWED,
	TRAIT_VULTURE_USER,
	TRAIT_IN_TUTORIAL,
	TRAIT_SPEC_KIT,
	TRAIT_SPEC_VENDOR,
))

/*
	FUN ZONE OF ADMIN LISTINGS
	Try to keep this in sync with __DEFINES/traits.dm
	quirks have it's own panel so we don't need them here.
*/
GLOBAL_LIST_INIT(traits_by_type, list(
	/mob = list(
		"TRAIT_KNOCKEDOUT" = TRAIT_KNOCKEDOUT,
		"TRAIT_IMMOBILIZED" = TRAIT_IMMOBILIZED,
		"TRAIT_INCAPACITATED" = TRAIT_INCAPACITATED,
		"TRAIT_FLOORED" = TRAIT_FLOORED,
		"TRAIT_DAZED" = TRAIT_DAZED,
		"TRAIT_UNDENSE" = TRAIT_UNDENSE,
		"TRAIT_YAUTJA_TECH" = TRAIT_YAUTJA_TECH,
		"TRAIT_SUPER_STRONG" = TRAIT_SUPER_STRONG,
		"TRAIT_FOREIGN_BIO" = TRAIT_FOREIGN_BIO,
		"TRAIT_INTENT_EYES" = TRAIT_INTENT_EYES,
		"TRAIT_INFILTRATOR_SYNTH" = TRAIT_INFILTRATOR_SYNTH,
		"TRAIT_UNSTRIPPABLE" = TRAIT_UNSTRIPPABLE,
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
		"TRAIT_CANNOT_EAT" = TRAIT_CANNOT_EAT,
		"TRAIT_VULTURE_USER" = TRAIT_VULTURE_USER,
		"TRAIT_CLOAKED" = TRAIT_CLOAKED,
		"TRAIT_SPEC_KIT" = TRAIT_SPEC_KIT,
		"TRAIT_SPEC_VENDOR" = TRAIT_SPEC_VENDOR,
	),
	/mob/living/carbon/xenomorph = list(
		"TRAIT_ABILITY_NO_PLASMA_TRANSFER" = TRAIT_ABILITY_NO_PLASMA_TRANSFER,
		"TRAIT_ABILITY_OVIPOSITOR" = TRAIT_ABILITY_OVIPOSITOR,
		"TRAIT_OPPOSABLE_THUMBS" = TRAIT_OPPOSABLE_THUMBS,
		"TRAIT_CARDPLAYING_THUMBS" = TRAIT_CARDPLAYING_THUMBS,
		"TRAIT_INTERFERENCE" = TRAIT_HIVEMIND_INTERFERENCE,
		"TRAIT_VALKYRIE_ARMOR" = TRAIT_VALKYRIE_ARMORED,
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
		"TRAIT_ITEM_RENAME_SPECIAL" = TRAIT_ITEM_RENAME_SPECIAL,
		"TRAIT_HEARS_FROM_CONTENTS" = TRAIT_HEARS_FROM_CONTENTS,
	),
	/obj/item/clothing = list(
		"TRAIT_CLOTHING_HOOD" = TRAIT_CLOTHING_HOOD
	),
	/obj/item/weapon/gun = list(
		"TRAIT_GUN_SILENCED" = TRAIT_GUN_SILENCED,
		"TRAIT_GUN_BIPODDED" = TRAIT_GUN_BIPODDED,
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
/// cannot be removed without admin intervention
#define ROUNDSTART_TRAIT "roundstart"
//-- mob traits --
///Status trait coming from lying down through update_canmove()
#define LYING_TRAIT "lying"
///Status trait coming from species. .human/species_gain()
#define TRAIT_SOURCE_SPECIES "t_s_species"
///Status trait coming from the hive.
#define TRAIT_SOURCE_HIVE "t_s_hive"
///Status trait coming from xeno strains.
#define TRAIT_SOURCE_STRAIN "t_s_strain"
///Status trait coming from being buckled.
#define TRAIT_SOURCE_BUCKLE "t_s_buckle"
//Status trait coming from being hauled by a xeno.
#define TRAIT_SOURCE_XENO_HAUL "t_s_xeno_haul"
///Status trait coming from being assigned as [acting] squad leader.
#define TRAIT_SOURCE_SQUAD_LEADER "t_s_squad_leader"
///Status trait coming from their job
#define TRAIT_SOURCE_JOB "t_s_job"
///Status trait forced by staff
#define TRAIT_SOURCE_ADMIN "t_s_admin"
/// Status trait coming from a tutorial
#define TRAIT_SOURCE_TUTORIAL "t_s_tutorials"
///Status trait coming from equipment
#define TRAIT_SOURCE_EQUIPMENT(slot) "t_s_equipment_[slot]"
///Status trait coming from skill
#define TRAIT_SOURCE_SKILL(skill) "t_s_skill_[skill]"
///Status trait coming from attachment
#define TRAIT_SOURCE_ATTACHMENT(slot) "t_s_attachment_[slot]"
///Status trait coming from ability
#define TRAIT_SOURCE_ABILITY(ability) "t_s_ability_[ability]"
#define TRAIT_SOURCE_LIMB(limb) "t_s_limb_[limb]"
///Status trait coming from temporary_mute
#define TRAIT_SOURCE_TEMPORARY_MUTE "t_s_temporary_mute"
///Status trait forced by the xeno action charge
#define TRAIT_SOURCE_XENO_ACTION_CHARGE "t_s_xeno_action_charge"
///Status trait coming from hivemind interference
#define TRAIT_SOURCE_HIVEMIND_INTERFERENCE "t_s_hivemind_interference"
///Status trait coming from a xeno nest
#define XENO_NEST_TRAIT "xeno_nest"
///Status trait from a generic throw by xeno abilities
#define XENO_THROW_TRAIT "xeno_throw_trait"
//-- structure traits --
///Status trait coming from being flipped or unflipped.
#define TRAIT_SOURCE_FLIP_TABLE "t_s_flip_table"

///Status trait from weapons?? buh
#define TRAIT_SOURCE_WEAPON "t_s_weapon"
///Status trait coming from generic items
#define TRAIT_SOURCE_ITEM "t_s_item"

//Status trait coming from clothing.
#define TRAIT_SOURCE_CLOTHING "t_s_clothing"

/// trait associated to being buckled
#define BUCKLED_TRAIT "buckled" // Yes the name doesn't conform. /tg/ appears to have changed naming style inbetween
/// trait source when an effect is coming from a fakedeath effect (refactor this)
#define FAKEDEATH_TRAIT "fakedeath"
/// trait source where a condition comes from body state
#define BODY_TRAIT "body"
/// Trait associated to lying down (having a [lying_angle] of a different value than zero).
#define LYING_DOWN_TRAIT "lying-down"
/// trait associated to a stat value or range of
#define STAT_TRAIT "stat"
/// trait effect related to the queen ovipositor
#define OVIPOSITOR_TRAIT "ovipositor"
/// trait associated to being held in a chokehold
#define CHOKEHOLD_TRAIT "chokehold"
/// trait effect related to active specialist gear
#define SPECIALIST_GEAR_TRAIT "specialist_gear"
/// traits associated with usage of snowflake dropship double seats
#define DOUBLE_SEATS_TRAIT "double_seats"
/// traits associated with xeno on-ground weeds
#define XENO_WEED_TRAIT "xeno_weed"
/// traits associated with actively interacted machinery
#define INTERACTION_TRAIT "interaction"
/// traits associated with interacting with a dropship
#define TRAIT_SOURCE_DROPSHIP_INTERACTION "dropship_interaction"
/// traits bound by stunned status effects
#define STUNNED_TRAIT "stunned"
/// traits bound by knocked_down status effect
#define KNOCKEDDOWN_TRAIT "knockeddown"
/// traits bound by knocked_out status effect
#define KNOCKEDOUT_TRAIT "knockedout"
/// traits from being pounced
#define POUNCED_TRAIT "pounced"
/// traits from step_triggers on the map
#define STEP_TRIGGER_TRAIT "step_trigger"
/// traits from hacked machine interactions
#define HACKED_TRAIT "hacked"
/// traits from chloroform usage
#define CHLOROFORM_TRAIT "chloroform"
/// traits transparent turf
#define TURF_Z_TRANSPARENT_TRAIT "turf_z_transparent"
/// traits from wall hiding
#define WALL_HIDING_TRAIT "wallhiding"
