//Life variables
#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_CRIT_MAX_OXYLOSS 1 //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 50HP to get through, so (1/6)*last_tick_duration per second. Breaths however only happen every 3 ticks.

///////////////////HUMAN BLOODTYPES///////////////////
#define HUMAN_BLOODTYPES list("O-","O+","A-","A+","B-","B+","AB-","AB+")

#define HUMAN_MAX_PALENESS	30 //this is added to human skin tone to get value of pale_max variable

#define HUMAN_STRIP_DELAY 40 //takes 40ds = 4s to strip someone.
#define POCKET_STRIP_DELAY 20

///////////////////LIMB DEFINES///////////////////

#define LIMB_ORGANIC 	(1<<0)
#define LIMB_ROBOT 		(1<<1)
#define LIMB_SYNTHSKIN	(1<<2) // not completely robot, but pseudohuman
#define LIMB_BROKEN 	(1<<3)
#define LIMB_DESTROYED	(1<<4) //limb is missing
#define LIMB_SPLINTED 	(1<<5)
#define LIMB_MUTATED 	(1<<6) //limb is deformed by mutations
#define LIMB_AMPUTATED 	(1<<7) //limb was amputated cleanly or destroyed limb was cleaned up, thus causing no pain
#define LIMB_SPLINTED_INDESTRUCTIBLE (1<<8) // Splint is indestructible
#define LIMB_UNCALIBRATED_PROSTHETIC (1<<9) //A prosthetic that's been attached to the body but not connected to the brain.

///////////////////WOUND DEFINES///////////////////
//wound flags. Different examine text + bandage overlays + whether various medical items can be used.
#define WOUND_BANDAGED (1<<0)
#define WOUND_SUTURED (1<<1)

//return values for suturing.
#define SUTURED (1<<0)
#define SUTURED_FULLY (1<<1)

//return values for bandaging/salving.
#define WOUNDS_BANDAGED (1<<0) //Relevant wounds exist, bandaged them.
#define WOUNDS_ALREADY_TREATED (1<<1) //Relevant wounds exist, but they're already bandaged.

///////////////OLD SURGERY DEFINES, USED BY AUTODOC///////////////
#define HEMOSTAT_MIN_DURATION 20
#define HEMOSTAT_MAX_DURATION 40

#define BONESETTER_MIN_DURATION 40
#define BONESETTER_MAX_DURATION 60

#define BONEGEL_REPAIR_MIN_DURATION 20
#define BONEGEL_REPAIR_MAX_DURATION 40

#define FIXVEIN_MIN_DURATION 40
#define FIXVEIN_MAX_DURATION 60

#define FIX_ORGAN_MIN_DURATION 40
#define FIX_ORGAN_MAX_DURATION 60

#define RETRACTOR_MIN_DURATION 10
#define RETRACTOR_MAX_DURATION 20

#define CIRCULAR_SAW_MIN_DURATION 40
#define CIRCULAR_SAW_MAX_DURATION 60

#define INCISION_MANAGER_MIN_DURATION 40
#define INCISION_MANAGER_MAX_DURATION 60

#define SCALPEL_MIN_DURATION 20
#define SCALPEL_MAX_DURATION 40

#define CAUTERY_MIN_DURATION 40
#define CAUTERY_MAX_DURATION 60

#define AMPUTATION_MIN_DURATION 70
#define AMPUTATION_MAX_DURATION 90

#define SURGICAL_DRILL_MIN_DURATION 70
#define SURGICAL_DRILL_MAX_DURATION 90

#define IMPLANT_MIN_DURATION 40
#define IMPLANT_MAX_DURATION 60

#define REMOVE_OBJECT_MIN_DURATION 40
#define REMOVE_OBJECT_MAX_DURATION 60

#define BONECHIPS_MAX_DAMAGE 20

#define LIMB_PRINTING_TIME 550
#define LIMB_METAL_AMOUNT 125

// ORDERS
#define COMMAND_ORDER_RANGE		7
#define COMMAND_ORDER_COOLDOWN 	800
#define COMMAND_ORDER_MOVE 		"move"
#define COMMAND_ORDER_FOCUS 	"focus"
#define COMMAND_ORDER_HOLD 		"hold"

#define ORDER_HOLD_MAX_LEVEL    15
#define ORDER_HOLD_CALC_LEVEL	20
#define ORDER_MOVE_MAX_LEVEL    50
#define ORDER_FOCUS_MAX_LEVEL   50

//Human Overlays Indexes used in update_icons/////////
#define UNDERWEAR_LAYER			40
#define UNDERSHIRT_LAYER		39
#define MUTANTRACE_LAYER		38
#define FLAY_LAYER 				37 //For use by Hunter Flay
#define DAMAGE_LAYER			36
#define UNIFORM_LAYER			35
#define TAIL_LAYER				34	//bs12 specific. this hack is probably gonna come back to haunt me
#define ID_LAYER				33
#define SHOES_LAYER				32
#define GLOVES_LAYER			31
#define MEDICAL_LAYER			30	//For splint and gauze overlays
#define SUIT_LAYER				29
#define SUIT_GARB_LAYER			28
#define SUIT_SQUAD_LAYER		27
#define GLASSES_LAYER			26
#define BELT_LAYER				25
#define SUIT_STORE_LAYER		24
#define BACK_LAYER				23
#define HAIR_LAYER				22
#define FACIAL_LAYER			21
#define EARS_LAYER				20
#define FACEMASK_LAYER			19
#define HEADSHOT_LAYER			18 //Unrevivable headshot overlays, suicide/execution.
#define HEAD_LAYER				17
#define HEAD_SQUAD_LAYER		16
#define HEAD_GARB_LAYER_2		15	// These actual defines are unused but this space within the overlays list is
#define HEAD_GARB_LAYER_3		14	//  |
#define HEAD_GARB_LAYER_4		13	//  |
#define HEAD_GARB_LAYER_5		12	// End here
#define HEAD_GARB_LAYER			11
#define BACK_FRONT_LAYER        10 // For backpacks when mob is facing north
#define COLLAR_LAYER			9
#define HANDCUFF_LAYER			8
#define LEGCUFF_LAYER			7
#define L_HAND_LAYER			6
#define R_HAND_LAYER			5
#define BURST_LAYER				4	//Chestburst overlay
#define TARGETED_LAYER			3	//for target sprites when held at gun point, and holo cards.
#define FIRE_LAYER				2	//If you're on fire		//BS12: Layer for the target overlay from weapon targeting system
#define EFFECTS_LAYER			1  //If you're hit by an acid DoT
#define TOTAL_LAYERS			40
//////////////////////////////////

//Synthetic Defines
#define SYNTH_COLONY	"Third Generation Colonial Synthetic"
#define SYNTH_COLONY_GEN_TWO	"First Generation Colonial Synthetic"
#define SYNTH_COLONY_GEN_ONE	"Second Generation Colonial Synthetic"
#define SYNTH_COMBAT	"Combat Synthetic"
#define SYNTH_WORKING_JOE	"Working Joe"
#define SYNTH_GEN_ONE	"First Generation Synthetic"
#define SYNTH_GEN_TWO	"Second Generation Synthetic"
#define SYNTH_GEN_THREE	"Third Generation Synthetic"

#define PLAYER_SYNTHS list(SYNTH_GEN_ONE, SYNTH_GEN_TWO, SYNTH_GEN_THREE)
#define SYNTH_TYPES list(SYNTH_COLONY, SYNTH_COMBAT, SYNTH_WORKING_JOE, SYNTH_GEN_ONE, SYNTH_GEN_TWO, SYNTH_GEN_THREE)

// Human religion defines
#define RELIGION_PROTESTANT		 		"Christianity (Protestant)"
#define RELIGION_CATHOLIC				"Christianity (Catholic)"
#define RELIGION_ORTHODOX		 		"Christianity (Orthodox)"
#define RELIGION_MORMONISM			 	"Christianity (Mormonism)"
#define RELIGION_CHRISTIANITY_OTHER 	"Christianity (Other)"
#define RELIGION_JUDAISM				"Judaism"
#define RELIGION_SHIA					"Islam (Shia)"
#define RELIGION_SUNNI					"Islam (Sunni)"
#define RELIGION_BUDDHISM				"Buddhism"
#define RELIGION_HINDUISM				"Hinduism"
#define RELIGION_SIKHISM				"Sikhism"
#define RELIGION_SHINTOISM				"Shintoism"
#define RELIGION_WICCANISM				"Wiccanism"
#define RELIGION_PAGANISM				"Paganism (Wicca)"
#define RELIGION_MINOR					"Minor Religion"
#define RELIGION_ATHEISM				"Atheism"
#define RELIGION_AGNOSTICISM			"Agnostic"
