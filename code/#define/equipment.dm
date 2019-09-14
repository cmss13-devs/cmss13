//FLAGS BITMASK


//turf-only flags
#define NOJAUNT		1

//PASS FLAGS
#define PASSTABLE	1
#define PASSGLASS	2
#define PASSGRILLE	4
#define PASSBLOB	8
#define PASSMOB		16

//FLAGS
#define NOFLAGS					0		//Nothing.

//==========================================================================================

//flags_atom

#define NOINTERACT				1		// You can't interact with it, at all. Useful when doing certain animations.
#define FPRINT					2		// takes a fingerprint
#define CONDUCT					4		// conducts electricity (metal etc.)
#define ON_BORDER				8		// 'border object'. item has priority to check when entering or leaving
#define NOBLOODY				16		// Don't want a blood overlay on this one.
#define DIRLOCK					32		// movable atom won't change direction when Moving()ing. Useful for items that have several dir states.
#define	NOREACT					64		//Reagents dont' react inside this container.
#define OPENCONTAINER			128		//is an open container for chemistry purposes
#define RELAY_CLICK				256		//This is used for /obj/ that relay your clicks via handle_click(), mostly for MGs + Sentries ~Art
#define ITEM_UNCATCHABLE		512 	// The item can't be caught out of the air.
#define UNIQUE_ITEM_TYPE		1024 	// Used for donor items to exclude them for checks.
#define NO_SNOW_TYPE			2048	// Used for armors or uniforms that don't have a snow icon state.
#define INVULNERABLE			4096
#define TIMELESS				8192	// Immune to time manipulation.
//==========================================================================================

#define HANDLE_BARRIER_CHANCE 1
#define HANDLE_BARRIER_BLOCK 2

//flags_item
//bitflags that were previously under flags_atom, these only apply to items.
//clothing specific stuff uses flags_inventory.

#define NODROP					1	// Cannot be dropped/unequipped at all, only deleted.
#define NOBLUDGEON  			2	// when an item has this it produces no "X has been hit by Y with Z" message with the default handler
#define NOSHIELD				4	// weapon not affected by shield (does nothing currently)
#define DELONDROP				8	// Deletes on drop instead of falling on the floor.
#define TWOHANDED				16	// The item is twohanded.
#define WIELDED					32	// The item is wielded with both hands.
#define	ITEM_ABSTRACT			64	// The item is abstract (grab, powerloader_clamp, etc)
#define ITEM_PREDATOR			128 //Specific predator item interactions.

//==========================================================================================


//flags_inv_hide
//Bit flags for the flags_inv_hide variable, which determine when a piece of clothing hides another. IE a helmet hiding glasses.

#define HIDEGLOVES		1
#define HIDESUITSTORAGE	2
#define HIDEJUMPSUIT	4
#define HIDESHOES		8
#define HIDEMASK		16
#define HIDEEARS		32		//(ears means headsets and such)
#define HIDEEYES		64		//(eyes means glasses)
#define HIDELOWHAIR		128		// temporarily removes the user's facial hair overlay.
#define HIDETOPHAIR		256		// temporarily removes the user's hair overlay. Leaves facial hair.
#define HIDEALLHAIR		512		// temporarily removes the user's hair, facial and otherwise.
#define HIDETAIL 		1024
#define HIDEFACE		2056	//Dictates whether we appear as unknown.


//==========================================================================================

//flags_inventory

//Another flag for clothing items that determines a few other things now
#define CANTSTRIP		1		// Can't be removed by others. No longer used by donor items, now only for facehuggers

//SHOES ONLY===========================================================================================
#define NOSLIPPING		2	//prevents from slipping on wet floors, in space etc
//SHOES ONLY===========================================================================================

//HELMET AND MASK======================================================================================
#define COVEREYES		4 // Covers the eyes/protects them.
#define COVERMOUTH		8 // Covers the mouth.
#define ALLOWINTERNALS	16	//mask allows internals
#define ALLOWREBREATH	32 //Mask allows to breath in really hot or really cold air.
#define BLOCKGASEFFECT	64 // blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets
#define ALLOWCPR		512 // Allows CPR even though the face is covered by a mask
//HELMET AND MASK======================================================================================

//SUITS AND HELMETS====================================================================================
//To successfully stop taking all pressure damage you must have both a suit and head item with this flag.
#define BLOCKSHARPOBJ 	128  //From /tg: prevents syringes, parapens and hypos if the external suit or helmet (if targeting head) has this flag. Example: space suits, biosuit, bombsuits, thick suits that cover your body.
#define NOPRESSUREDMAGE 256 //This flag is used on the flags variable for SUIT and HEAD items which stop pressure damage.
//SUITS AND HELMETS====================================================================================





//===========================================================================================
//Marine armor only, use for flags_marine_armor.
#define ARMOR_SQUAD_OVERLAY		1
#define ARMOR_LAMP_OVERLAY		2
#define ARMOR_LAMP_ON			4
#define ARMOR_IS_REINFORCED		8
//===========================================================================================

//===========================================================================================
//Marine helmet only, use for flags_marine_helmet.
#define HELMET_SQUAD_OVERLAY	1
#define HELMET_GARB_OVERLAY		2
#define HELMET_DAMAGE_OVERLAY	4
#define HELMET_STORE_GARB		8
#define HELMET_IS_DAMAGED		16
//===========================================================================================

//ITEM INVENTORY SLOT BITMASKS
#define SLOT_OCLOTHING 		1
#define SLOT_ICLOTHING 		2
#define SLOT_HANDS 			4
#define SLOT_EYES 			8
#define SLOT_EAR 			16
#define SLOT_FACE 			32
#define SLOT_HEAD 			64
#define SLOT_FEET 			128
#define SLOT_ID 			256
#define SLOT_WAIST			512
#define SLOT_BACK 			1024
#define SLOT_STORE 			2048	//this is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_NO_STORE		4096	//this is to deny items with a w_class of 2 or 1 to fit in pockets.
#define SLOT_LEGS 			16384
#define SLOT_ACCESSORY		32768
//=================================================

//slots
//Text strings so that the slots can be associated when doing inventory lists.
#define WEAR_ID				"id"
#define WEAR_EAR			"wear_ear"
#define WEAR_BODY			"w_uniform"
#define WEAR_LEGS			"legs"
#define WEAR_FEET			"shoes"
#define WEAR_HANDS			"gloves"
#define WEAR_WAIST			"belt"
#define WEAR_JACKET			"wear_suit"
#define WEAR_EYES			"glasses"
#define WEAR_FACE			"wear_mask"
#define WEAR_HEAD			"head"
#define WEAR_BACK			"back"
#define WEAR_L_STORE		"l_store"
#define WEAR_R_STORE		"r_store"
#define WEAR_ACCESSORY		"accessory"
#define WEAR_J_STORE		"j_store"
#define WEAR_L_HAND			"l_hand"
#define WEAR_R_HAND			"r_hand"
#define WEAR_HANDCUFFS		"handcuffs"
#define WEAR_LEGCUFFS		"legcuffs"
#define WEAR_IN_BACK		"in_back"
#define WEAR_IN_JACKET		"in_jacket"
#define WEAR_IN_ACCESSORY	"in_accessory"
#define WEAR_IN_BELT        "in_belt"
#define WEAR_IN_SCABBARD    "in_scabbard"
#define WEAR_IN_J_STORE     "in_j_store"
#define WEAR_IN_L_STORE     "in_l_store"
#define WEAR_IN_R_STORE     "in_r_store"
#define WEAR_IN_SHOES		"in_shoes"


//=================================================

//slot-related

//The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
#define DEFAULT_SLOT_PRIORITY  list( \
		WEAR_BACK,\
		WEAR_ID,\
		WEAR_BODY,\
		WEAR_JACKET,\
		WEAR_HEAD,\
		WEAR_FEET,\
		WEAR_IN_SHOES,\
		WEAR_FACE,\
		WEAR_HANDS,\
		WEAR_EAR,\
		WEAR_EYES,\
		WEAR_IN_BELT,\
		WEAR_IN_SCABBARD,\
		WEAR_WAIST,\
		WEAR_IN_J_STORE,\
		WEAR_IN_L_STORE,\
		WEAR_IN_R_STORE,\
		WEAR_J_STORE,\
		WEAR_IN_ACCESSORY,\
		WEAR_IN_JACKET,\
		WEAR_L_STORE,\
		WEAR_R_STORE,\
		WEAR_IN_BACK\
	)

//=================================================

// bitflags for clothing parts
#define NO_BODY			0
#define HEAD			1
#define FACE			2
#define EYES			4
#define UPPER_TORSO		8
#define LOWER_TORSO		16
#define LEG_LEFT		32
#define LEG_RIGHT		64
#define LEGS			96
#define FOOT_LEFT		128
#define FOOT_RIGHT		256
#define FEET			384
#define ARM_LEFT		512
#define ARM_RIGHT		1024
#define ARMS			1536
#define HAND_LEFT		2048
#define HAND_RIGHT		4096
#define HANDS			6144
#define FULL_BODY		8191
//=================================================

//defense zones for selecting them via the hud.
#define DEFENSE_ZONES_LIVING list("head","chest","mouth","eyes","groin","l_leg","l_foot","r_leg","r_foot","l_arm","l_hand","r_arm","r_hand")

// bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_flags_heat_protection() and human/proc/get_flags_cold_protection()
// The values here should add up to 1.
// Hands and feet have 2.5%, arms and legs 7.5%, each of the torso parts has 15% and the head has 30%
#define THERMAL_PROTECTION_HEAD			0.3
#define THERMAL_PROTECTION_UPPER_TORSO	0.15
#define THERMAL_PROTECTION_LOWER_TORSO	0.15
#define THERMAL_PROTECTION_LEG_LEFT		0.075
#define THERMAL_PROTECTION_LEG_RIGHT	0.075
#define THERMAL_PROTECTION_FOOT_LEFT	0.025
#define THERMAL_PROTECTION_FOOT_RIGHT	0.025
#define THERMAL_PROTECTION_ARM_LEFT		0.075
#define THERMAL_PROTECTION_ARM_RIGHT	0.075
#define THERMAL_PROTECTION_HAND_LEFT	0.025
#define THERMAL_PROTECTION_HAND_RIGHT	0.025
//=================================================

//=================================================
#define SPACE_HELMET_min_cold_protection_temperature 	2.0 //what min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define SPACE_SUIT_min_cold_protection_temperature 		2.0 //what min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define SPACE_SUIT_max_heat_protection_temperature 		5000	//These need better heat protect, but not as good heat protect as firesuits.
#define FIRESUIT_max_heat_protection_temperature 		30000 //what max_heat_protection_temperature is set to for firesuit quality headwear. MUST NOT BE 0.
#define FIRE_HELMET_max_heat_protection_temperature 	30000 //for fire helmet quality items (red and white hardhats)
#define HELMET_min_cold_protection_temperature 			200	//For normal helmets
#define HELMET_max_heat_protection_temperature 			600	//For normal helmets
#define ARMOR_min_cold_protection_temperature 			200	//For armor
#define ARMOR_max_heat_protection_temperature 			600	//For armor

#define GLOVES_min_cold_protection_temperature 			200	//For some gloves (black and)
#define GLOVES_max_heat_protection_temperature 			650	//For some gloves
#define SHOE_min_cold_protection_temperature 			200	//For gloves
#define SHOE_max_heat_protection_temperature 			650	//For gloves

#define ICE_PLANET_min_cold_protection_temperature 		200 //For the ice planet map protection from the elements.
//=================================================

//=================================================
#define ACCESSORY_SLOT_UTILITY  "Utility"
#define ACCESSORY_SLOT_ARMBAND  "Armband"
#define ACCESSORY_SLOT_RANK     "Rank"
#define ACCESSORY_SLOT_DECOR    "Decor"
#define ACCESSORY_SLOT_MEDAL    "Medal"
#define ACCESSORY_SLOT_ARMOR_C  "Chest armor"
#define ACCESSORY_SLOT_ARMOR_A  "Arm armor"
#define ACCESSORY_SLOT_ARMOR_L  "Leg armor"
#define ACCESSORY_SLOT_ARMOR_S  "Armor storage"
#define ACCESSORY_SLOT_ARMOR_M  "Misc armor"
#define ACCESSORY_SLOT_HELM_C	"Helmet cover"
//=================================================

//=================================================
#define UNIFORM_VEND_UTILITY_UNIFORM	"utility uniform"
#define UNIFORM_VEND_UTILITY_JACKET		"utility overwear"
#define UNIFORM_VEND_UTILITY_HEAD		"utility cover"
#define UNIFORM_VEND_UTILITY_GLOVES		"utility gloves"
#define UNIFORM_VEND_UTILITY_SHOES		"utility shoes"
#define UNIFORM_VEND_UTILITY_EXTRA		"utility extra"

#define UNIFORM_VEND_SERVICE_UNIFORM	"service uniform"
#define UNIFORM_VEND_SERVICE_JACKET		"service overwear"
#define UNIFORM_VEND_SERVICE_HEAD		"service cover"
#define UNIFORM_VEND_SERVICE_GLOVES		"service gloves"
#define UNIFORM_VEND_SERVICE_SHOES		"service shoes"
#define UNIFORM_VEND_SERVICE_EXTRA		"service extra"

#define UNIFORM_VEND_DRESS_UNIFORM		"dress uniform"
#define UNIFORM_VEND_DRESS_JACKET		"dress overwear"
#define UNIFORM_VEND_DRESS_HEAD			"dress cover"
#define UNIFORM_VEND_DRESS_GLOVES		"dress gloves"
#define UNIFORM_VEND_DRESS_SHOES		"dress shoes"
#define UNIFORM_VEND_DRESS_EXTRA		"dress extra"

/*
#define UNIFORM_VEND_UTILITY list(UNIFORM_VEND_UTILITY_UNIFORM, UNIFORM_VEND_UTILITY_JACKET, UNIFORM_VEND_UTILITY_GLOVES, UNIFORM_VEND_UTILITY_SHOES)
#define UNIFORM_VEND_UTILITY_EXTRA list(UNIFORM_VEND_UTILITY_EXTRA)
#define UNIFORM_VEND_SERVICE list(UNIFORM_VEND_SERVICE_UNIFORM, UNIFORM_VEND_SERVICE_JACKET, UNIFORM_VEND_SERVICE_GLOVES, UNIFORM_VEND_SERVICE_SHOES)
#define UNIFORM_VEND_SERVICE_EXTRA list(UNIFORM_VEND_SERVICE_EXTRA)
#define UNIFORM_VEND_DRESS list(UNIFORM_VEND_DRESS_UNIFORM, UNIFORM_VEND_DRESS_JACKET, UNIFORM_VEND_DRESS_GLOVES, UNIFORM_VEND_DRESS_SHOES)
#define UNIFORM_VEND_DRESS_EXTRA list(UNIFORM_VEND_DRESS_EXTRA)
*/

var/global/list/uniform_categories = list(
	"UTILITY" = list(UNIFORM_VEND_UTILITY_UNIFORM, UNIFORM_VEND_UTILITY_JACKET, UNIFORM_VEND_UTILITY_HEAD, UNIFORM_VEND_UTILITY_GLOVES, UNIFORM_VEND_UTILITY_SHOES), 
	"UTILITY EXTRAS" = list(UNIFORM_VEND_UTILITY_EXTRA), 
	"SERVICE" = list(UNIFORM_VEND_SERVICE_UNIFORM, UNIFORM_VEND_SERVICE_JACKET, UNIFORM_VEND_SERVICE_HEAD, UNIFORM_VEND_SERVICE_GLOVES, UNIFORM_VEND_SERVICE_SHOES), 
	"SERVICE EXTRAS" = list(UNIFORM_VEND_SERVICE_EXTRA), 
	"DRESS" = list(UNIFORM_VEND_DRESS_UNIFORM, UNIFORM_VEND_DRESS_JACKET, UNIFORM_VEND_DRESS_HEAD, UNIFORM_VEND_DRESS_GLOVES, UNIFORM_VEND_DRESS_SHOES), 
	"DRESS EXTRAS" = list(UNIFORM_VEND_DRESS_EXTRA)
)
//=================================================
