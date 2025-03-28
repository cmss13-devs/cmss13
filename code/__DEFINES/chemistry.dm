/*
 * Chemistry defines
 */

/// Amount of bottle icon variations in total
#define BOTTLE_ICON_CHOICES 4
/// Amount of random icon variations for pills in total
#define PILL_ICON_CHOICES 22
/* Pill icon classes to generate mappings for */
#define PILL_ICON_CLASSES list("bica", "kelo", "dex", "para", "tram", "atox", "tox", "inap", "peri", "spac", "drug", "stim", "alky", "imi", "qc", "tric", "psych", "oxy")

/*
	reagents defines
*/

#define SOLID 1
#define LIQUID 2
#define GAS 3

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

// OVERDOSES for Chems
#define LOW_REAGENTS_OVERDOSE 6
#define LOW_REAGENTS_OVERDOSE_CRITICAL 10
#define LOWM_REAGENTS_OVERDOSE 10.5
#define LOWM_REAGENTS_OVERDOSE_CRITICAL 20
#define LOWH_REAGENTS_OVERDOSE 15
#define LOWH_REAGENTS_OVERDOSE_CRITICAL 25
#define MED_REAGENTS_OVERDOSE 20
#define MED_REAGENTS_OVERDOSE_CRITICAL 30
#define REAGENTS_OVERDOSE 30
#define REAGENTS_OVERDOSE_CRITICAL 50
#define HIGH_REAGENTS_OVERDOSE 60
#define HIGH_REAGENTS_OVERDOSE_CRITICAL 100


// How many units of reagent are consumed per tick, by default.
#define REAGENTS_METABOLISM AMOUNT_PER_TIME(1, 10 SECONDS)
// By defining the effect multiplier this way, it'll exactly adjust
// all effects according to how they originally were with the 0.4 metabolism
#define REAGENTS_EFFECT_MULTIPLIER REAGENTS_METABOLISM / 0.4

#define REM REAGENTS_EFFECT_MULTIPLIER
// Reagent metabolism defines.
#define FOOD_METABOLISM AMOUNT_PER_TIME(1, 5 SECONDS)
#define ALCOHOL_METABOLISM AMOUNT_PER_TIME(1, 5 SECONDS)
#define RAPID_METABOLISM AMOUNT_PER_TIME(1, 2 SECONDS)

/// How fast mob nutrition normally decreases
#define HUNGER_FACTOR 0.05
/// Additional mob nutrition cost when regenerating blood
#define BLOOD_NUTRITION_COST 0.25
/// Additional mob nutrition cost when cold
#define COLD_NUTRITION_COST 1

// Nutrition levels
#define NUTRITION_MAX 550
#define NUTRITION_HIGH 540
#define NUTRITION_NORMAL 400
#define NUTRITION_LOW 250
#define NUTRITION_VERYLOW 50

//Metabolization mods
#define REAGENT_EFFECT "effectiveness"
#define REAGENT_BOOST "boost"
#define REAGENT_PURGE "purge"
#define REAGENT_FORCE "force"
#define REAGENT_CANCEL "cancel"

//Reagent generation classifications

/// Default. Chemicals not used in the chem generator
#define CHEM_CLASS_NONE 0
/// Chemicals that can be dispensed directly from the dispenser (iron, oxygen)
#define CHEM_CLASS_BASIC 1
/// Chemicals which recipe is commonly known and made (bicaridine, alkysine, salt)
#define CHEM_CLASS_COMMON 2
/// Chemicals which recipe is uncommonly known and made (spacedrugs, foaming agent)
#define CHEM_CLASS_UNCOMMON 3
/// Chemicals without a recipe but can be obtained on the Almayer, or requires rare components
#define CHEM_CLASS_RARE 4
/// Chemicals without a recipe and can't be obtained on the Almayer, or requires special components
#define CHEM_CLASS_SPECIAL 5
/// Randomly generated chemicals
#define CHEM_CLASS_ULTRA 6

//chem_effect_flags, used to quickly check if the mob has a chem that provides a special effect
#define CHEM_EFFECT_RESIST_FRACTURE (1<<0)
#define CHEM_EFFECT_RESIST_NEURO (1<<1)
#define CHEM_EFFECT_HYPER_THROTTLE (1<<2) //universal understand but not speech
#define CHEM_EFFECT_ORGAN_STASIS (1<<3) //peri stabiliser
#define CHEM_EFFECT_NO_BLEEDING (1<<4) //replacement for quickclot


//Blood plasma
#define PLASMA_PURPLE "purpleplasma"
#define PLASMA_PHEROMONE "pheromoneplasma"
#define PLASMA_CHITIN "chitinplasma"
#define PLASMA_CATECHOLAMINE "catecholamineplasma"
#define PLASMA_EGG "eggplasma"
#define PLASMA_NEUROTOXIN "neurotoxinplasma"
#define PLASMA_ROYAL "royalplasma"

// Flags for Reagent

/// Used to restrict recipes in the generator from employing all reagents of this type
#define REAGENT_TYPE_MEDICAL (1<<0)
/// Whether the reagent shows up on health analysers.
#define REAGENT_SCANNABLE (1<<1)
/// Whether the reagent canNOT be ingested and must be delivered through injection. Used by electrogenetic property.
#define REAGENT_NOT_INGESTIBLE (1<<2)
/// Whether the reagent canNOT trigger its overdose effects. Used by regulating property. For ordinary reagents with no overdose effect, instead keep var/overdose at 0.
#define REAGENT_CANNOT_OVERDOSE (1<<3)

#define REAGENT_TYPE_STIMULANT (1<<4)

/// Reagent doesn't randomly generate in chemicals
#define REAGENT_NO_GENERATION (1<<5)

/*
	properties defines
*/
//Negative
#define PROPERTY_HYPOXEMIC "hypoxemic"
#define PROPERTY_TOXIC "toxic"
#define PROPERTY_CORROSIVE "corrosive"
#define PROPERTY_BIOCIDIC "biocidic"
#define PROPERTY_HEMOLYTIC "hemolytic"
#define PROPERTY_HEMORRAGING "hemorrhaging"
#define PROPERTY_CARCINOGENIC "carcinogenic"
#define PROPERTY_HEPATOTOXIC "hepatotoxic"
#define PROPERTY_INTRAVENOUS "intravenous"
#define PROPERTY_NEPHROTOXIC "nephrotoxic"
#define PROPERTY_PNEUMOTOXIC "pneumotoxic"
#define PROPERTY_OCULOTOXIC "oculotoxic"
#define PROPERTY_CARDIOTOXIC "cardiotoxic"
#define PROPERTY_NEUROTOXIC "neurotoxic"
#define PROPERTY_HYPERMETABOLIC "hypermetabolic"
#define PROPERTY_IGNITING "igniting"
//Neutral
#define PROPERTY_NUTRITIOUS "nutritious"
#define PROPERTY_KETOGENIC "ketogenic"
#define PROPERTY_PAINING "paining"
#define PROPERTY_NEUROINHIBITING "neuroinhibiting"
#define PROPERTY_ALCOHOLIC "alcoholic"
#define PROPERTY_HALLUCINOGENIC "hallucinogenic"
#define PROPERTY_RELAXING "relaxing"
#define PROPERTY_HYPERTHERMIC "hyperthermic"
#define PROPERTY_HYPOTHERMIC "hypothermic"
#define PROPERTY_BALDING "balding"
#define PROPERTY_FLUFFING "fluffing"
#define PROPERTY_ALLERGENIC "allergenic"
#define PROPERTY_CRYOMETABOLIZING "cryometabolizing"
#define PROPERTY_EUPHORIC "euphoric"
#define PROPERTY_EMETIC "emetic"
#define PROPERTY_PSYCHOSTIMULATING "psychostimulating"
#define PROPERTY_ANTIHALLUCINOGENIC "anti-hallucinogenic"
#define PROPERTY_EXCRETING "excreting"
#define PROPERTY_HYPOMETABOLIC "hypometabolic"
#define PROPERTY_SEDATIVE "sedative"
#define PROPERTY_TRANSFORMATIVE "transformative"
//Positive
#define PROPERTY_ANTITOXIC "anti-toxic"
#define PROPERTY_ANTICORROSIVE "anti-corrosive"
#define PROPERTY_NEOGENETIC "neogenetic"
#define PROPERTY_REPAIRING "repairing"
#define PROPERTY_HEMOGENIC "hemogenic"
#define PROPERTY_YAUTJA_HEMOGENIC "yautja-hemogenic"
#define PROPERTY_HEMOSTATIC "hemostatic"
#define PROPERTY_NERVESTIMULATING "nerve-stimulating"
#define PROPERTY_MUSCLESTIMULATING "muscle-stimulating"
#define PROPERTY_PAINKILLING "painkilling"
#define PROPERTY_HEPATOPEUTIC "hepatopeutic"
#define PROPERTY_NEPHROPEUTIC "nephropeutic"
#define PROPERTY_PNEUMOPEUTIC "pneumopeutic"
#define PROPERTY_OCULOPEUTIC "oculopeutic"
#define PROPERTY_CARDIOPEUTIC "cardiopeutic"
#define PROPERTY_NEUROPEUTIC "neuropeutic"
#define PROPERTY_BONEMENDING "bonemending"
#define PROPERTY_FLUXING "fluxing"
#define PROPERTY_NEUROCRYOGENIC "neurocryogenic"
#define PROPERTY_CRYSTALLIZATION "crystallization"
#define PROPERTY_PHOTOSENSITIVE "photosensitive"
#define PROPERTY_NEUTRALIZING "neutralizing"
#define PROPERTY_DISRUPTING "disrupting"
#define PROPERTY_ANTIPARASITIC "anti-parasitic"
#define PROPERTY_ELECTROGENETIC "electrogenetic"
#define PROPERTY_ORGANSTABILIZE "organ-stabilizing"
//Rare Combo, made by combining other properties
#define PROPERTY_DEFIBRILLATING "defibrillating"
#define PROPERTY_THANATOMETABOL "thanatometabolizing"
#define PROPERTY_HYPERDENSIFICATING "hyperdensificating"
#define PROPERTY_HYPERTHROTTLING "hyperthrottling"
#define PROPERTY_NEUROSHIELDING "neuroshielding"
#define PROPERTY_ANTIADDICTIVE "anti-addictive"
#define PROPERTY_ADDICTIVE "addictive"
#define PROPERTY_ENCEPHALOPHRASIVE "encephalophrasive"
//Legendary, only in gen_tier 3+
#define PROPERTY_HYPERGENETIC "hypergenetic"
#define PROPERTY_BOOSTING "boosting"
#define PROPERTY_DNA_DISINTEGRATING "DNA-Disintegrating"
#define PROPERTY_REGULATING "regulating"
#define PROPERTY_CIPHERING "ciphering"
#define PROPERTY_CIPHERING_PREDATOR "cross-ciphering"
#define PROPERTY_FIRE_PENETRATING "fire-penetrating"
//Admin Only Properties
#define PROPERTY_ORGAN_HEALING "organ-healing"
#define PROPERTY_CROSSMETABOLIZING "cross-metabolizing"
#define PROPERTY_EMBRYONIC "embryonic"
#define PROPERTY_TRANSFORMING "transforming"
#define PROPERTY_RAVENING "ravening"
#define PROPERTY_CURING "curing"
#define PROPERTY_OMNIPOTENT "omnipotent"
#define PROPERTY_RADIUS "radius" // Fire related admin property
#define PROPERTY_INTENSITY "intensity" // Fire related admin property
#define PROPERTY_DURATION "duration" // Fire related admin property
//Reaction Properties
#define PROPERTY_FUELING "fueling"
#define PROPERTY_OXIDIZING "oxidizing"
#define PROPERTY_FLOWING "flowing"
#define PROPERTY_VISCOUS "viscous"
#define PROPERTY_EXPLOSIVE "explosive"
//Generation Disabled Properties
#define PROPERTY_CARDIOSTABILIZING "cardio-stabilizing"
#define PROPERTY_AIDING "aiding"
#define PROPERTY_THERMOSTABILIZING "themo-stabilizing"
#define PROPERTY_OXYGENATING "oxygenating"
#define PROPERTY_FOCUSING "focusing"
#define PROPERTY_ANTICARCINOGENIC "anti-carcinogenic"
#define PROPERTY_UNKNOWN "unknown" //just has an OD effect
#define PROPERTY_HEMOSITIC "hemositic"


//Property rarity

/// the property is disabled and can't spawn anywhere, however is still functional
#define PROPERTY_DISABLED 0
/// can be generated anywhere and available in round start chems
#define PROPERTY_COMMON 1
/// can be generated anywhere, but not available in round start chems
#define PROPERTY_UNCOMMON 2
/// can only be generated at specific gen_tiers, but can also be made through specific property combinations
#define PROPERTY_RARE 3
/// can strictly only be generated at specific gen_tiers
#define PROPERTY_LEGENDARY 4
/// can only be spawned through admin powers
#define PROPERTY_ADMIN 5

//Property category
#define PROPERTY_TYPE_ALL 0
#define PROPERTY_TYPE_MEDICINE 1
#define PROPERTY_TYPE_TOXICANT 2
#define PROPERTY_TYPE_STIMULANT 4
#define PROPERTY_TYPE_REACTANT 8
#define PROPERTY_TYPE_IRRITANT 16
#define PROPERTY_TYPE_METABOLITE 32
#define PROPERTY_TYPE_ANOMALOUS 64
#define PROPERTY_TYPE_UNADJUSTABLE 128
#define PROPERTY_TYPE_CATALYST 256
#define PROPERTY_TYPE_COMBUSTIBLE 512

// Defines for pain applied pr tick by chems
#define PROPERTY_PAINING_PAIN 1
#define PROPERTY_PAINING_PAIN_OD 2
#define PROPERTY_DEFIBRILLATING_PAIN_OD 2
#define PROPERTY_CARDIOPEUTIC_PAIN_CRITICAL 3

// Injectors
#define INJECTOR_USES 3
#define INJECTOR_PERCENTAGE_OF_OD 0.5

//defines for research level multipliers

/// Scales cost of increasing clearance using credits
#define RESEARCH_LEVEL_INCREASE_MULTIPLIER 3
/// Scales tech level to max amplification level
#define TECHTREE_LEVEL_MULTIPLIER 2

//Property cost multipliers for the chemical simulator
#define PROPERTY_COST_MAX 8
#define PROPERTY_MULTIPLIER_RARE 2
#define PROPERTY_MULTIPLIER_ANOMALOUS 5

/*
	For minimum potencies for properties
	Create maxes are what can be reached in create mode at a given tech level
	Potency maxes are what can be reached in amplify mode (with unlimited levels at T3)
*/
#define CREATE_MAX_TIER_1 2
#define CREATE_MAX_TIER_2 4
#define CREATE_MAX_TIER_3 5
#define POTENCY_MAX_TIER_1 3
#define POTENCY_MAX_TIER_2 5

//for scaling chem effects based on potency
#define POTENCY_MULTIPLIER_VVLOW 0.1
#define POTENCY_MULTIPLIER_VLOW 0.25
#define POTENCY_MULTIPLIER_LOW 0.5
#define POTENCY_MULTIPLIER_MEDIUM 2
#define POTENCY_MULTIPLIER_HIGH 3
#define POTENCY_MULTIPLIER_VHIGH 5
#define POTENCY_MULTIPLIER_HIGHEXTREMEINTER 7.5
#define POTENCY_MULTIPLIER_EXTREME 10

//used in speed_modifier component
#define HUMAN_STAMINA_MULTIPLIER 5

/*
	Chemical explosions/fires
*/

/// The minimum amount of a fire penetrating chemical required to turn a fire into fire penetrating
#define CHEM_FIRE_PENETRATION_THRESHOLD 10
/// An intensity greater than this will cause a fire to be star shape
#define CHEM_FIRE_STAR_THRESHOLD 30

#define CHEM_FIRE_IRREGULAR_THRESHOLD 15

/// Amount of phosphorus that equals 1 radius of white phosphorus smoke
#define CHEM_FIRE_PHOSPHORUS_PER_RADIUS 10
/// The minimum amount of chems required to turn shrapnel into a special type
#define EXPLOSION_PHORON_THRESHOLD 10
#define EXPLOSION_ACID_THRESHOLD 10
#define EXPLOSION_NEURO_THRESHOLD 30

#define EXPLOSION_MIN_FALLOFF 25
#define EXPLOSION_BASE_SHARDS 4

/// The maximum amount of shards is divided by this number if the shards are of special type
#define INCENDIARY_SHARDS_MAX_REDUCTION	2
#define HORNET_SHARDS_MAX_REDUCTION 2
#define NEURO_SHARDS_MAX_REDUCTION 2

#define LEVEL_TO_POTENCY_MULTIPLIER 0.5
