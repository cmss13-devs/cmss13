//Life variables

/// Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_MAX_OXYLOSS 1
/// The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 50HP to get through, so (1/6)*last_tick_duration per second. Breaths however only happen every 3 ticks.
#define HUMAN_CRIT_MAX_OXYLOSS 1

///////////////////HUMAN BLOODTYPES///////////////////
#define HUMAN_BLOODTYPES list("O-","O+","A-","A+","B-","B+","AB-","AB+")

/// this is added to human skin tone to get value of pale_max variable
#define HUMAN_MAX_PALENESS 30

/// takes 40ds = 4s to strip someone.
#define HUMAN_STRIP_DELAY 40
#define POCKET_STRIP_DELAY 20

///////////////////LIMB FLAGS///////////////////

#define LIMB_ORGANIC (1<<0)
#define LIMB_ROBOT (1<<1)

/// not completely robot, but pseudohuman
#define LIMB_SYNTHSKIN (1<<2)

#define LIMB_BROKEN (1<<3)

/// limb is missing
#define LIMB_DESTROYED (1<<4)
#define LIMB_SPLINTED (1<<5)

/// limb is deformed by mutations
#define LIMB_MUTATED (1<<6)
/// limb was amputated cleanly or destroyed limb was cleaned up, thus causing no pain
#define LIMB_AMPUTATED (1<<7)
/// Splint is indestructible
#define LIMB_SPLINTED_INDESTRUCTIBLE (1<<8)
/// A prosthetic that's been attached to the body but not connected to the brain.
#define LIMB_UNCALIBRATED_PROSTHETIC (1<<9)

///////////////////WOUND DEFINES///////////////////

//wound flags. Different examine text + bandage overlays + whether various medical items can be used.
#define WOUND_BANDAGED (1<<0)
#define WOUND_SUTURED (1<<1)

//return values for suturing.
#define SUTURED (1<<0)
#define SUTURED_FULLY (1<<1)

//return values for bandaging/salving.

/// Relevant wounds exist, bandaged them.
#define WOUNDS_BANDAGED (1<<0)
/// Relevant wounds exist, but they're already bandaged.
#define WOUNDS_ALREADY_TREATED (1<<1)

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
#define COMMAND_ORDER_RANGE 7
#define COMMAND_ORDER_COOLDOWN 800
#define COMMAND_ORDER_MOVE "move"
#define COMMAND_ORDER_FOCUS "focus"
#define COMMAND_ORDER_HOLD "hold"

#define ORDER_HOLD_MAX_LEVEL 15
#define ORDER_HOLD_CALC_LEVEL 20
#define ORDER_MOVE_MAX_LEVEL 50
#define ORDER_FOCUS_MAX_LEVEL   50

//Human Overlays Indexes used in update_icons/////////
#define BODYPARTS_LAYER 42
#define DAMAGE_LAYER 41

#define UNDERWEAR_LAYER 40
#define UNDERSHIRT_LAYER 39
#define MUTANTRACE_LAYER 38

/// For use by Hunter Flay
#define FLAY_LAYER 37
#define UNIFORM_LAYER 36

/// bs12 specific. this hack is probably gonna come back to haunt me
#define TAIL_LAYER 35

#define ID_LAYER 34
#define SHOES_LAYER 33
#define GLOVES_LAYER 32

/// For splint and gauze overlays
#define MEDICAL_LAYER 31

#define SUIT_LAYER 30
#define SUIT_GARB_LAYER 29
#define SUIT_SQUAD_LAYER 28
#define GLASSES_LAYER 27
#define BELT_LAYER 26
#define SUIT_STORE_LAYER 25
#define BACK_LAYER 24
#define HAIR_LAYER 23
#define HAIR_GRADIENT_LAYER 22
#define FACIAL_LAYER 21
#define EARS_LAYER 20
#define FACEMASK_LAYER 19

/// Unrevivable headshot overlays, suicide/execution.
#define HEADSHOT_LAYER 18
#define HEAD_LAYER 17
#define HEAD_SQUAD_LAYER 16
#define HEAD_GARB_LAYER_2 15 // These actual defines are unused but this space within the overlays list is
#define HEAD_GARB_LAYER_3 14 //  |
#define HEAD_GARB_LAYER_4 13 //  |
#define HEAD_GARB_LAYER_5 12 // End here
#define HEAD_GARB_LAYER 11

/// For backpacks when mob is facing north
#define BACK_FRONT_LAYER 10
#define COLLAR_LAYER 9
#define HANDCUFF_LAYER 8
#define LEGCUFF_LAYER 7
#define L_HAND_LAYER 6
#define R_HAND_LAYER 5

/// Chestburst overlay
#define BURST_LAYER 4
/// for target sprites when held at gun point, and holo cards.
#define TARGETED_LAYER 3
/// If you're on fire
#define FIRE_LAYER 2
/// If you're hit by an acid DoT
#define EFFECTS_LAYER 1

#define TOTAL_LAYERS 42
//////////////////////////////////

//Synthetic Defines
#define SYNTH_COLONY "Third Generation Colonial Synthetic"
#define SYNTH_COLONY_GEN_TWO "Second Generation Colonial Synthetic"
#define SYNTH_COLONY_GEN_ONE "First Generation Colonial Synthetic"
#define SYNTH_COMBAT "Combat Synthetic"
#define SYNTH_INFILTRATOR "Infiltrator Synthetic"
#define SYNTH_WORKING_JOE "Working Joe"
#define SYNTH_HAZARD_JOE "Hazard Joe"
#define SYNTH_GEN_ONE "First Generation Synthetic"
#define SYNTH_GEN_TWO "Second Generation Synthetic"
#define SYNTH_GEN_THREE "Third Generation Synthetic"

#define PLAYER_SYNTHS list(SYNTH_GEN_ONE, SYNTH_GEN_TWO, SYNTH_GEN_THREE)
#define SYNTH_TYPES list(SYNTH_COLONY, SYNTH_COLONY_GEN_ONE, SYNTH_COLONY_GEN_TWO, SYNTH_COMBAT, SYNTH_INFILTRATOR, SYNTH_WORKING_JOE, SYNTH_GEN_ONE, SYNTH_GEN_TWO, SYNTH_GEN_THREE)

// Human religion defines
#define RELIGION_PROTESTANT "Christianity (Protestant)"
#define RELIGION_CATHOLIC "Christianity (Catholic)"
#define RELIGION_ORTHODOX "Christianity (Orthodox)"
#define RELIGION_MORMONISM "Christianity (Mormonism)"
#define RELIGION_CHRISTIANITY_OTHER "Christianity (Other)"
#define RELIGION_JUDAISM "Judaism"
#define RELIGION_SHIA "Islam (Shia)"
#define RELIGION_SUNNI "Islam (Sunni)"
#define RELIGION_BUDDHISM "Buddhism"
#define RELIGION_HINDUISM "Hinduism"
#define RELIGION_SIKHISM "Sikhism"
#define RELIGION_SHINTOISM "Shintoism"
#define RELIGION_WICCANISM "Wiccanism"
#define RELIGION_PAGANISM "Paganism (Wicca)"
#define RELIGION_MINOR "Minor Religion"
#define RELIGION_ATHEISM "Atheism"
#define RELIGION_AGNOSTICISM "Agnostic"

#define MAXIMUM_DROPPED_OBJECTS_REMEMBERED 2

// DEFINES FOR RECORD SYSTEM STAT TYPES, arguably pointless to create defines for these, could of just renamed the string but eh, who cares.
// --------------------------------------------------------------------------------------------------------------- //

// general records
#define MOB_NAME "name"
#define RECORD_UNIQUE_ID "id"
#define MOB_SHOWN_RANK "rank"
#define MOB_REAL_RANK "real_rank"
#define MOB_SEX "sex"
#define MOB_AGE "age"
#define MOB_ETHNICITY "ethnicity"
#define MOB_HEALTH_STATUS "p_stat"
#define MOB_MENTAL_STATUS "m_stat"
#define MOB_SPECIES "species"
#define MOB_ORIGIN "origin"
#define MOB_SHOWN_FACTION "faction"
#define MOB_REAL_FACTION "mob_faction"
#define MOB_RELIGION "religion"
#define MOB_SQUAD "squad"
#define MOB_GENERAL_NOTES "g_notes"
#define MOB_EXPLOIT_RECORD "mob_exploit_record"
#define MOB_WEAKREF "ref"

#define GENERAL_RECORD_LIST list(MOB_NAME, RECORD_UNIQUE_ID, MOB_SHOWN_RANK, MOB_REAL_RANK, MOB_SEX, MOB_AGE, MOB_ETHNICITY, MOB_HEALTH_STATUS, MOB_MENTAL_STATUS, MOB_SPECIES, MOB_ORIGIN, MOB_SHOWN_FACTION, MOB_REAL_FACTION, MOB_RELIGION, MOB_SQUAD, MOB_GENERAL_NOTES, MOB_EXPLOIT_RECORD, MOB_WEAKREF)

// security record stat types
#define MOB_INCIDENTS "incidents"
#define MOB_CRIMINAL_STATUS "criminal"
#define MOB_SECURITY_COMMENT_LOG "comments"
#define MOB_SECURITY_NOTES "s_notes"

#define SECURITY_RECORD_LIST list(MOB_INCIDENTS, MOB_CRIMINAL_STATUS, MOB_SECURITY_COMMENT_LOG, MOB_SECURITY_NOTES)

// medical record stat types
#define MOB_BLOOD_TYPE "b_type"
#define MOB_DISABILITIES "mi_dis"
#define MOB_AUTOPSY_NOTES "a_stat"
#define MOB_MEDICAL_NOTES "m_notes"
#define MOB_DISEASES "cdi"
#define MOB_CAUSE_OF_DEATH "d_stat"
#define MOB_AUTOPSY_SUBMISSION "aut_sub"
#define MOB_LAST_SCAN_TIME "last_scan_time"
#define MOB_LAST_SCAN_RESULT "last_scan_result"
#define MOB_AUTODOC_DATA "autodoc_data"
#define MOB_AUTODOC_MANUAL "autodoc_manual"

#define MEDICAL_RECORD_LIST list(MOB_BLOOD, MOB_DISABILITIES, MOB_AUTOPSY_NOTES, MOB_MEDICAL_NOTES, MOB_DISEASES, MOB_CAUSE_OF_DEATH, MOB_AUTOPSY_SUBMISSION, MOB_LAST_SCAN_TIME, MOB_LAST_SCAN_RESULT, MOB_AUTODOC_DATA, MOB_AUTODOC_MANUAL)

// --------------------------------------------------------------------------------------------------------------- //

// The actual stat that is set, for now we reduce the useless bullshit no one cares about and keep it minimal.
// --------------------------------------------------------------------------------------------------------------- //

// gender/sex stats
#define MOB_STAT_SEX_MALE "Male"
#define MOB_STAT_SEX_FEMALE "Female"

#define MOB_STAT_GENDER_LIST list(MOB_STAT_SEX_MALE, MOB_STAT_SEX_FEMALE)

// health stats
#define MOB_STAT_HEALTH_DECEASED "Deceased"
#define MOB_STAT_HEALTH_ACTIVE "Active"
#define MOB_STAT_HEALTH_UNFIT "Unfit"

#define MOB_STAT_HEALTH_LIST list(MOB_STAT_SEX_MALE, MOB_STAT_SEX_FEMALE)

// Mental stats
#define MOB_STAT_MENTAL_STATUS_STABLE "Stable"
#define MOB_STAT_MENTAL_STATUS_ON_WATCH "Watch"  // i.e. potentailly unstable
#define MOB_STAT_MENTAL_STATUS_UNSTABLE "Insane"

#define MOB_STAT_MENTAL_STATUS_LIST list(MOB_STAT_MENTAL_STATUS_STABLE, MOB_STAT_MENTAL_STATUS_ON_WATCH, MOB_STAT_MENTAL_STATUS_UNSTABLE)

// crime stats
#define MOB_STAT_CRIME_NONE "None"
#define MOB_STAT_CRIME_ARREST "Arrest"
#define MOB_STAT_CRIME_INCARCERATED "Incarcerated"

#define MOB_STAT_CRIME_STATUS_LIST list(MOB_STAT_CRIME_NONE, MOB_STAT_CRIME_ARREST, MOB_STAT_CRIME_INCARCERATED)
// ------------------------------------------------------------------------------------------------------------------ //

// types of records
#define RECORD_TYPE_GENERAL "general"
#define RECORD_TYPE_SECURITY "security"
#define RECORD_TYPE_MEDICAL "medical"
#define RECORD_TYPE_STATIC "locked" // immutable records, keeping it for now I guess.

#define RECORD_TYPE_LIST list(RECORD_TYPE_GENERAL, RECORD_TYPE_SECURITY,  RECORD_TYPE_MEDICAL, RECORD_TYPE_STATIC )
