//FLAGS BITMASK


//==========================================================================================

//flags_atom

/// You can't interact with it, at all. Useful when doing certain animations.
#define NOINTERACT (1<<0)
/// takes a fingerprint
#define FPRINT (1<<1)
/// conducts electricity (metal etc.)
#define CONDUCT (1<<2)
/// 'border object'. item has priority to check when entering or leaving
#define ON_BORDER (1<<3)
/// Don't want a blood overlay on this one.
#define NOBLOODY (1<<4)
/// movable atom won't change direction when Moving()ing. Useful for items that have several dir states.
#define DIRLOCK (1<<5)
/// Reagents dont' react inside this container.
#define NOREACT (1<<6)
/// is an open container for chemistry purposes
#define OPENCONTAINER (1<<7)
/// This is used for /obj/ that relay your clicks via handle_click(), mostly for MGs ~Art
#define RELAY_CLICK (1<<8)
/// The item can't be caught out of the air.
#define ITEM_UNCATCHABLE (1<<9)
/// Used for nonstandard marine clothing to ignore 'specialty' var.
#define NO_NAME_OVERRIDE (1<<10)
/// Used for armors or uniforms that don't have a snow icon state.
#define NO_SNOW_TYPE (1<<11)

#define INVULNERABLE (1<<12)

/// syringes can inject or drain reagents in this even if it isn't an OPENCONTAINER
#define CAN_BE_SYRINGED (1<<13)
/// Chem dispenser can dispense in this even if it isn't an OPENCONTAINER
#define CAN_BE_DISPENSED_INTO (1<<14)
/// Initialized by SSatoms.
#define INITIALIZED (1<<15)
/// Has run Decorate() as part of subsystem init
#define ATOM_DECORATED (1<<16)
/// Whether or not the object uses hearing
#define USES_HEARING (1<<17)

//==========================================================================================

#define HANDLE_BARRIER_CHANCE 1
#define HANDLE_BARRIER_BLOCK 2

//flags_item
//bitflags that were previously under flags_atom, these only apply to items.
//clothing specific stuff uses flags_inventory.

/// Cannot be dropped/unequipped at all, only deleted.
#define NODROP (1<<0)
/// when an item has this it produces no "X has been hit by Y with Z" message with the default handler
#define NOBLUDGEON (1<<1)
/// weapon not affected by shield (does nothing currently)
#define NOSHIELD (1<<2)
/// Deletes on drop instead of falling on the floor.
#define DELONDROP (1<<3)
/// The item is twohanded.
#define TWOHANDED (1<<4)
/// The item is wielded with both hands.
#define WIELDED (1<<5)
/// The item is abstract (grab, powerloader_clamp, etc)
#define	ITEM_ABSTRACT (1<<6)
/// Specific predator item interactions.
#define ITEM_PREDATOR (1<<7)
/// Lock this item to the mob that equips it up until permadeath
#define MOB_LOCK_ON_EQUIP (1<<8)
/// This item deletes itself when put in cryo storage
#define NO_CRYO_STORE (1<<9)
/// For backpacks if they should have unique layering functions
#define ITEM_OVERRIDE_NORTHFACE (1<<10)
/// whether activating it digs shrapnel out of the user and striking others with medical skills can dig shapnel out of other people.
#define CAN_DIG_SHRAPNEL (1<<11)
/// whether it has an animated icon state of "[icon_state]_on" to be used during surgeries.
#define ANIMATED_SURGICAL_TOOL (1<<12)
/// The item goes on top of tables, instead of into them with the overlay system
#define NOTABLEMERGE (1<<13)

//==========================================================================================


//flags_inv_hide
//Bit flags for the flags_inv_hide variable, which determine when a piece of clothing hides another. IE a helmet hiding glasses.

#define HIDEGLOVES (1<<0)
#define HIDESUITSTORAGE (1<<1)
#define HIDEJUMPSUIT (1<<2)
#define HIDESHOES (1<<3)
#define HIDEMASK (1<<4)
/// (ears means headsets and such)
#define HIDEEARS (1<<5)
/// (eyes means glasses)
#define HIDEEYES (1<<6)
/// temporarily removes the user's facial hair overlay.
#define HIDELOWHAIR (1<<7)
/// temporarily removes the user's hair overlay. Leaves facial hair.
#define HIDETOPHAIR (1<<8)
/// temporarily removes the user's hair, facial and otherwise.
#define HIDEALLHAIR (1<<9)

#define HIDETAIL (1<<10)

/// Dictates whether we appear as unknown.
#define HIDEFACE (1<<11)


//==========================================================================================

//flags_inventory

//Another flag for clothing items that determines a few other things now
#define CANTSTRIP (1<<0) // Can't be removed by others. No longer used by donor items, now only for facehuggers

//SHOES ONLY===========================================================================================
#define NOSLIPPING (1<<1) //prevents from slipping on wet floors, in space etc
//SHOES ONLY===========================================================================================

//HELMET AND MASK======================================================================================

/// Covers the eyes/protects them.
#define COVEREYES (1<<2)
/// Covers the mouth.
#define COVERMOUTH (1<<3)
/// mask allows internals
#define ALLOWINTERNALS (1<<4)
/// Mask allows to breath in really hot or really cold air.
#define ALLOWREBREATH (1<<5)
/// blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets
#define BLOCKGASEFFECT (1<<6)
/// Allows CPR even though the face is covered by a mask
#define ALLOWCPR (1<<7)

//HELMET AND MASK======================================================================================

//SUITS AND HELMETS====================================================================================
//To successfully stop taking all pressure damage you must have both a suit and head item with this flag.

/// From /tg: prevents syringes, parapens and hypos if the external suit or helmet (if targeting head) has this flag. Example: space suits, biosuit, bombsuits, thick suits that cover your body.
#define BLOCKSHARPOBJ (1<<8)
/// This flag is used on the flags variable for SUIT and HEAD items which stop pressure damage.
#define NOPRESSUREDMAGE (1<<9)
/// Suits only. Wearing this will stop you from being pushed over.
#define BLOCK_KNOCKDOWN (1<<10)
/// Whether wearing this suit grants you the ability to fire a smartgun
#define SMARTGUN_HARNESS (1<<11)

//SUITS AND HELMETS====================================================================================


//VISION IMPAIRMENT LEVELS===========================================================================

/// No visual impairment
#define VISION_IMPAIR_NONE 0
/// 1 tile of partial impairment
#define VISION_IMPAIR_MIN 1
/// 2 tiles of partial impairment
#define VISION_IMPAIR_WEAK 2
/// 3 tiles of partial impairment
#define VISION_IMPAIR_MED 3
/// 1 tile of full and 2 of partial impairment
#define VISION_IMPAIR_HIGH 4
/// 2 tiles of full and 2 of partial impairment
#define VISION_IMPAIR_STRONG 5
/// 3 tiles of full and 2 of partial impairment (original one)
#define VISION_IMPAIR_MAX 6

//VISION IMPAIRMENT LEVELS===========================================================================


//===========================================================================================
//Uniform flags only, use for flags_jumpsuit. These are autodetected on init.

/// can we roll the sleeves on this uniform?
#define UNIFORM_SLEEVE_ROLLABLE (1<<0)
#define UNIFORM_SLEEVE_ROLLED (1<<1)
/// can the sleeves be cut?
#define UNIFORM_SLEEVE_CUTTABLE (1<<2)
#define UNIFORM_SLEEVE_CUT (1<<3)
/// can the jacket be removed?
#define UNIFORM_JACKET_REMOVABLE (1<<4)
#define UNIFORM_JACKET_REMOVED (1<<5)
/// are accessories never hidden by sleeve/jacket state? (meant for snow uniform which rolls collar instead of sleeves)
#define UNIFORM_DO_NOT_HIDE_ACCESSORIES (1<<6)

//===========================================================================================

//===========================================================================================
//Marine armor only, use for flags_marine_armor.
#define ARMOR_SQUAD_OVERLAY 1
#define ARMOR_LAMP_OVERLAY 2
#define ARMOR_LAMP_ON 4
#define ARMOR_IS_REINFORCED 8
#define SYNTH_ALLOWED 16
//===========================================================================================

//===========================================================================================
//Marine helmet only, use for flags_marine_helmet.
#define HELMET_SQUAD_OVERLAY (1<<0)
#define HELMET_GARB_OVERLAY (1<<1)
#define HELMET_DAMAGE_OVERLAY (1<<2)
#define HELMET_IS_DAMAGED (1<<3)
//===========================================================================================

//===========================================================================================
//Marine caps only, use for flags_marine_hat.
#define HAT_GARB_OVERLAY (1<<0)
#define HAT_CAN_FLIP (1<<1)
#define HAT_FLIPPED (1<<2)
//===========================================================================================

//ITEM INVENTORY SLOT BITMASKS
#define SLOT_OCLOTHING (1<<0)
#define SLOT_ICLOTHING (1<<1)
#define SLOT_HANDS (1<<2)
#define SLOT_EYES (1<<3)
#define SLOT_EAR (1<<4)
#define SLOT_FACE (1<<5)
#define SLOT_HEAD (1<<6)
#define SLOT_FEET (1<<7)
#define SLOT_ID (1<<8)
#define SLOT_WAIST (1<<9)
#define SLOT_BACK (1<<10)
#define SLOT_STORE (1<<11) //this is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_NO_STORE (1<<12) //this is to deny items with a w_class of 2 or 1 to fit in pockets.
#define SLOT_LEGS (1<<13)
#define SLOT_ACCESSORY (1<<14)
#define SLOT_SUIT_STORE (1<<15) //this allows items to be stored in the suit slot regardless of suit
//=================================================

//slots
//Text strings so that the slots can be associated when doing inventory lists.
#define WEAR_ID "id"
#define WEAR_L_EAR "wear_l_ear"
#define WEAR_R_EAR "wear_r_ear"
#define WEAR_BODY "w_uniform"
#define WEAR_FEET "shoes"
#define WEAR_HANDS "gloves"
#define WEAR_WAIST "belt"
#define WEAR_JACKET "wear_suit"
#define WEAR_EYES "glasses"
#define WEAR_FACE "wear_mask"
#define WEAR_HEAD "head"
#define WEAR_BACK "back"
#define WEAR_L_STORE "l_store"
#define WEAR_R_STORE "r_store"
#define WEAR_ACCESSORY "accessory"
#define WEAR_J_STORE "j_store"
#define WEAR_L_HAND "l_hand"
#define WEAR_R_HAND "r_hand"
#define WEAR_HANDCUFFS "handcuffs"
#define WEAR_LEGCUFFS "legcuffs"
#define WEAR_IN_BACK "in_back"
#define WEAR_IN_JACKET "in_jacket"
#define WEAR_IN_ACCESSORY "in_accessory"
#define WEAR_IN_BELT "in_belt"
#define WEAR_IN_SCABBARD "in_scabbard"
#define WEAR_IN_J_STORE  "in_j_store"
#define WEAR_IN_HELMET   "in_helmet"
#define WEAR_IN_L_STORE  "in_l_store"
#define WEAR_IN_R_STORE  "in_r_store"
#define WEAR_IN_SHOES "in_shoes"

// Contained Sprites
#define WORN_LHAND "_lh"
#define WORN_RHAND "_rh"
#define WORN_LSTORE "_ls"
#define WORN_RSTORE "_rs"
#define WORN_SSTORE "_ss"
#define WORN_LEAR "_le"
#define WORN_REAR "_re"
#define WORN_HEAD "_he"
#define WORN_UNDER "_un"
#define WORN_SUIT "_su"
#define WORN_GLOVES "_gl"
#define WORN_SHOES "_sh"
#define WORN_EYES "_ey"
#define WORN_BELT "_be"
#define WORN_BACK "_ba"
#define WORN_ID "_id"
#define WORN_MASK "_ma"

GLOBAL_LIST_INIT(slot_to_contained_sprite_shorthand, list(
	WEAR_L_HAND = WORN_LHAND,
	WEAR_R_HAND = WORN_RHAND,
	WEAR_L_STORE = WORN_LSTORE,
	WEAR_R_STORE = WORN_RSTORE,
	WEAR_J_STORE = WORN_SSTORE,
	WEAR_L_EAR = WORN_LEAR,
	WEAR_R_EAR = WORN_REAR,
	WEAR_HEAD = WORN_HEAD,
	WEAR_BODY = WORN_UNDER,
	WEAR_JACKET = WORN_SUIT,
	WEAR_HANDS = WORN_GLOVES,
	WEAR_FEET = WORN_SHOES,
	WEAR_EYES = WORN_EYES,
	WEAR_WAIST = WORN_BELT,
	WEAR_BACK = WORN_BACK,
	WEAR_ID = WORN_ID,
	WEAR_FACE = WORN_MASK
))

/proc/slotdefine2slotbit(slotdefine)
	. = NO_FLAGS
	switch(slotdefine)
		if(WEAR_ID)
			. = SLOT_ID
		if(WEAR_L_EAR, WEAR_R_EAR)
			. = SLOT_EAR
		if(WEAR_BODY)
			. = SLOT_ICLOTHING
		if(WEAR_FEET)
			. = SLOT_FEET
		if(WEAR_HANDS)
			. = SLOT_HANDS
		if(WEAR_WAIST)
			. = SLOT_WAIST
		if(WEAR_JACKET)
			. = SLOT_OCLOTHING
		if(WEAR_EYES)
			. = SLOT_EYES
		if(WEAR_FACE)
			. = SLOT_FACE
		if(WEAR_HEAD)
			. = SLOT_HEAD
		if(WEAR_BACK)
			. = SLOT_BACK
		if(WEAR_L_STORE, WEAR_R_STORE)
			. = SLOT_STORE
		if(WEAR_ACCESSORY)
			. = SLOT_ACCESSORY
		if(WEAR_J_STORE)
			. = SLOT_SUIT_STORE

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
		WEAR_L_EAR,\
		WEAR_R_EAR,\
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
		WEAR_IN_HELMET,\
		WEAR_L_STORE,\
		WEAR_R_STORE,\
		WEAR_IN_BACK\
	)

//=================================================

// bitflags for clothing parts
#define BODY_FLAG_NO_BODY 0
#define BODY_FLAG_HEAD (1<<0)
#define BODY_FLAG_FACE (1<<1)
#define BODY_FLAG_EYES (1<<2)
#define BODY_FLAG_CHEST (1<<3)
#define BODY_FLAG_GROIN (1<<4)
#define BODY_FLAG_LEG_LEFT (1<<5)
#define BODY_FLAG_LEG_RIGHT (1<<6)
#define BODY_FLAG_LEGS (BODY_FLAG_LEG_LEFT|BODY_FLAG_LEG_RIGHT)
#define BODY_FLAG_FOOT_LEFT (1<<7)
#define BODY_FLAG_FOOT_RIGHT (1<<8)
#define BODY_FLAG_FEET (BODY_FLAG_FOOT_LEFT|BODY_FLAG_FOOT_RIGHT)
#define BODY_FLAG_ARM_LEFT (1<<9)
#define BODY_FLAG_ARM_RIGHT (1<<10)
#define BODY_FLAG_ARMS (BODY_FLAG_ARM_LEFT|BODY_FLAG_ARM_RIGHT)
#define BODY_FLAG_HAND_LEFT (1<<11)
#define BODY_FLAG_HAND_RIGHT (1<<12)
#define BODY_FLAG_HANDS (BODY_FLAG_HAND_LEFT|BODY_FLAG_HAND_RIGHT)
#define BODY_FLAG_ALL_BUT_HEAD (BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS)
#define BODY_FLAG_FULL_BODY ((1<<13)-1)
//=================================================

//defense zones for selecting them via the hud.
#define DEFENSE_ZONES_LIVING list("head","eyes","mouth","chest","groin","l_arm","l_hand","r_arm","r_hand","l_leg","l_foot","r_leg","r_foot")

// bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_flags_heat_protection() and human/proc/get_flags_cold_protection()
// The values here should add up to 1.
// Hands and feet have 2.5%, arms and legs 7.5%, each of the torso parts has 15% and the head has 30%
#define THERMAL_PROTECTION_HEAD 0.3
#define THERMAL_PROTECTION_UPPER_TORSO 0.15
#define THERMAL_PROTECTION_LOWER_TORSO 0.15
#define THERMAL_PROTECTION_LEG_LEFT 0.075
#define THERMAL_PROTECTION_LEG_RIGHT 0.075
#define THERMAL_PROTECTION_FOOT_LEFT 0.025
#define THERMAL_PROTECTION_FOOT_RIGHT 0.025
#define THERMAL_PROTECTION_ARM_LEFT 0.075
#define THERMAL_PROTECTION_ARM_RIGHT 0.075
#define THERMAL_PROTECTION_HAND_LEFT 0.025
#define THERMAL_PROTECTION_HAND_RIGHT 0.025
//=================================================

//=================================================

/// what min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define SPACE_HELMET_MIN_COLD_PROT 2
/// what min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define SPACE_SUIT_MIN_COLD_PROT 2
/// These need better heat protect, but not as good heat protect as firesuits.
#define SPACE_SUIT_MAX_HEAT_PROT 5000
/// what max_heat_protection_temperature is set to for firesuit quality headwear. MUST NOT BE 0.
#define FIRESUIT_MAX_HEAT_PROT 30000
/// for fire helmet quality items (red and white hardhats)
#define FIRE_HELMET_MAX_HEAT_PROT 30000
/// For normal helmets
#define HELMET_MIN_COLD_PROT 175
/// For normal helmets
#define HELMET_MAX_HEAT_PROT 600
/// For armor
#define ARMOR_MIN_COLD_PROT 200
/// For armor
#define ARMOR_MAX_HEAT_PROT 600
/// For some gloves (black and)
#define GLOVES_MIN_COLD_PROT 175
/// For some gloves
#define GLOVES_MAX_HEAT_PROT 650
/// For shoes
#define SHOE_MIN_COLD_PROT 175
/// For shoes
#define SHOE_MAX_HEAT_PROT 650
/// For the ice planet map protection from the elements.
#define ICE_PLANET_MIN_COLD_PROT 175

//=================================================

//=================================================
#define ACCESSORY_SLOT_UTILITY "Utility"
#define ACCESSORY_SLOT_ARMBAND "Armband"
#define ACCESSORY_SLOT_RANK "Rank"
#define ACCESSORY_SLOT_DECOR "Decor"
#define ACCESSORY_SLOT_MEDAL "Medal"
#define ACCESSORY_SLOT_PONCHO "Ponchos"

/// Used for uniform armour inserts.
#define ACCESSORY_SLOT_ARMOR_C "Chest armor"

#define ACCESSORY_SLOT_ARMOR_A "Arm armor"
#define ACCESSORY_SLOT_ARMOR_L "Leg armor"
#define ACCESSORY_SLOT_ARMOR_S "Armor storage"
#define ACCESSORY_SLOT_ARMOR_M "Misc armor"
#define ACCESSORY_SLOT_HELM_C "Helmet cover"
//=================================================

//=================================================
#define UNIFORM_VEND_UTILITY_UNIFORM "utility uniform"
#define UNIFORM_VEND_UTILITY_JACKET "utility overwear"
#define UNIFORM_VEND_UTILITY_HEAD "utility cover"
#define UNIFORM_VEND_UTILITY_GLOVES "utility gloves"
#define UNIFORM_VEND_UTILITY_SHOES "utility shoes"
#define UNIFORM_VEND_UTILITY_EXTRA "utility extra"

#define UNIFORM_VEND_SERVICE_UNIFORM "service uniform"
#define UNIFORM_VEND_SERVICE_JACKET "service overwear"
#define UNIFORM_VEND_SERVICE_HEAD "service cover"
#define UNIFORM_VEND_SERVICE_GLOVES "service gloves"
#define UNIFORM_VEND_SERVICE_SHOES "service shoes"
#define UNIFORM_VEND_SERVICE_EXTRA "service extra"

#define UNIFORM_VEND_DRESS_UNIFORM "dress uniform"
#define UNIFORM_VEND_DRESS_JACKET "dress overwear"
#define UNIFORM_VEND_DRESS_HEAD "dress cover"
#define UNIFORM_VEND_DRESS_GLOVES "dress gloves"
#define UNIFORM_VEND_DRESS_SHOES "dress shoes"
#define UNIFORM_VEND_DRESS_EXTRA "dress extra"


var/global/list/uniform_categories = list(
	"UTILITY" = list(UNIFORM_VEND_UTILITY_UNIFORM, UNIFORM_VEND_UTILITY_JACKET, UNIFORM_VEND_UTILITY_HEAD, UNIFORM_VEND_UTILITY_GLOVES, UNIFORM_VEND_UTILITY_SHOES),
	"UTILITY EXTRAS" = list(UNIFORM_VEND_UTILITY_EXTRA),
	"SERVICE" = list(UNIFORM_VEND_SERVICE_UNIFORM, UNIFORM_VEND_SERVICE_JACKET, UNIFORM_VEND_SERVICE_GLOVES, UNIFORM_VEND_SERVICE_SHOES),
	"SERVICE HEADWEAR" = list(UNIFORM_VEND_SERVICE_HEAD),
	"SERVICE EXTRAS" = list(UNIFORM_VEND_SERVICE_EXTRA),
	"DRESS" = list(UNIFORM_VEND_DRESS_UNIFORM, UNIFORM_VEND_DRESS_JACKET, UNIFORM_VEND_DRESS_GLOVES, UNIFORM_VEND_DRESS_SHOES),
	"DRESS HEADWEAR" = list(UNIFORM_VEND_DRESS_HEAD),
	"DRESS EXTRAS" = list(UNIFORM_VEND_DRESS_EXTRA)
)
//=================================================


// SMARTPACK RELATED
#define SMARTPACK_MAX_POWER_STORED 200

// Autolathe defines

#define AUTOLATHE_MAX_QUEUE 6
#define AUTOLATHE_FAILED 0
#define AUTOLATHE_START_PRINTING 1
#define AUTOLATHE_QUEUED 2


// Storage flags
#define STORAGE_ALLOW_EMPTY (1<<0) // Whether the storage object has the 'empty' verb, which dumps all the contents on the floor
#define STORAGE_QUICK_EMPTY (1<<1) // Whether the storage object can quickly be emptied (no delay)
#define STORAGE_QUICK_GATHER (1<<2) // Whether the storage object can quickly collect all items from a tile via the 'toggle mode' verb
#define STORAGE_ALLOW_DRAWING_METHOD_TOGGLE (1<<3) // Whether this storage object can have its items drawn (pouches)
#define STORAGE_USING_DRAWING_METHOD (1<<4) // Whether this storage object has its items drawn (versus just opening it)
#define STORAGE_USING_FIFO_DRAWING (1<<5) // Wether the storage object can have items in it's leftmost slot be drawn
#define STORAGE_CLICK_EMPTY (1<<6) // Whether you can click to empty an item
#define STORAGE_CLICK_GATHER (1<<7) // Whether it is possible to use this storage object in an inverse way,
													// so you can have the item in your hand and click items on the floor to pick them up
#define STORAGE_SHOW_FULLNESS (1<<8) // Whether our storage object on hud changes color when full
#define STORAGE_CONTENT_NUM_DISPLAY (1<<9) // Whether the storage object groups contents of the same type and displays them as a number. Only works for slot-based storage objects.
#define STORAGE_GATHER_SIMULTAENOUSLY (1<<10) // Whether the storage object can pick up all the items in a tile
#define STORAGE_ALLOW_QUICKDRAW (1<<11) // Whether the storage can be drawn with E or Holster verb

#define STORAGE_FLAGS_DEFAULT (STORAGE_SHOW_FULLNESS|STORAGE_GATHER_SIMULTAENOUSLY|STORAGE_ALLOW_EMPTY)
#define STORAGE_FLAGS_BOX (STORAGE_FLAGS_DEFAULT^STORAGE_ALLOW_EMPTY)
#define STORAGE_FLAGS_BAG (STORAGE_QUICK_GATHER|STORAGE_QUICK_EMPTY|STORAGE_CLICK_GATHER|STORAGE_FLAGS_DEFAULT)
#define STORAGE_FLAGS_POUCH (STORAGE_FLAGS_DEFAULT|STORAGE_ALLOW_DRAWING_METHOD_TOGGLE)


//Radios
#define RADIO_FILTER_TYPE_ALL 0
#define RADIO_FILTER_TYPE_INTERCOM 1
#define RADIO_FILTER_TYPE_INTERCOM_AND_BOUNCER 2
#define RADIO_FILTER_TYPE_ANTAG_RADIOS 3
//=================================================

//=================================================
#define PHONE_RTO "RTO"
#define PHONE_MARINE "Marine"
#define PHONE_UPP_SOLDIER "Soldier"
#define PHONE_IO "IO"
