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
#define REAGENTS_METABOLISM 0.2
// By defining the effect multiplier this way, it'll exactly adjust
// all effects according to how they originally were with the 0.4 metabolism
#define REAGENTS_EFFECT_MULTIPLIER REAGENTS_METABOLISM / 0.4

#define REM REAGENTS_EFFECT_MULTIPLIER
// Reagent metabolism defines.
#define FOOD_METABOLISM 0.4
#define ALCOHOL_METABOLISM 0.1
#define RAPID_METABOLISM 1.0

// Factor of how fast mob nutrition decreases
#define HUNGER_FACTOR 0.05

// Nutrition levels
#define NUTRITION_MAX		550
#define NUTRITION_NORMAL	400
#define NUTRITION_LOW		250
#define NUTRITION_VERYLOW	50

//Metabolization mods
#define REAGENT_EFFECT			"effectiveness"
#define REAGENT_BOOST			"boost"
#define REAGENT_PURGE			"purge"
#define REAGENT_FORCE			"force"
#define REAGENT_CANCEL			"cancel"

//Reagent generation classifications
#define CHEM_CLASS_NONE             0 //Default. Chemicals not used in the chem generator
#define CHEM_CLASS_BASIC            1 //Chemicals that can be dispensed directly from the dispenser (iron, oxygen)
#define CHEM_CLASS_COMMON           2 //Chemicals which recipe is commonly known and made (bicardine, alkysine, salt)
#define CHEM_CLASS_UNCOMMON         3 //Chemicals which recipe is uncommonly known and made (spacedrugs, foaming agent)
#define CHEM_CLASS_RARE             4 //Chemicals without a recipe but can be obtained on the Almayer, or requires rare components
#define CHEM_CLASS_SPECIAL          5 //Chemicals without a recipe and can't be obtained on the Almayer, or requires special components
#define CHEM_CLASS_ULTRA            6 //Randomly generated chemicals

//chem effect flags, used to quickly check if the mob has a chem that provides a special effect
#define CHEM_EFFECT_RESIST_FRACTURE		1
#define CHEM_EFFECT_RESIST_NEURO		2
#define CHEM_EFFECT_HYPER_THROTTLE		4 //universal understand but not speech

//Blood plasma
#define PLASMA_PURPLE 			"purpleplasma"
#define PLASMA_PHEROMONE 		"pheromoneplasma"
#define PLASMA_CHITIN 			"chitinplasma"
#define PLASMA_CATECHOLAMINE 	"catecholamineplasma"
#define PLASMA_EGG 				"eggplasma"
#define PLASMA_NEUROTOXIN 		"neurotoxinplasma"
#define PLASMA_ROYAL 			"royalplasma"

// Flags for Reagent
#define REAGENT_TYPE_MEDICAL	1 // Used to restrict recipes in the generator from employing all reagents of this type
#define REAGENT_SCANNABLE		2 // Whether the reagent shows up on health analysers.
#define REAGENT_NOT_INGESTIBLE	4 // Whether the reagent canNOT be ingested and must be delivered through injection. Used by electrogenetic property.
#define REAGENT_CANNOT_OVERDOSE	8 // Whether the reagent canNOT trigger its overdose effects. Used by regulating property. For ordinary reagents with no overdose effect, instead keep var/overdose at 0.

/*
	properties defines
*/
//Negative
#define PROPERTY_HYPOXEMIC 			"hypoxemic"
#define PROPERTY_TOXIC 				"toxic"
#define PROPERTY_CORROSIVE 			"corrosive"
#define PROPERTY_BIOCIDIC			"biocidic"
#define PROPERTY_HEMOLYTIC			"hemolytic"
#define PROPERTY_HEMORRAGING		"hemorrhaging"
#define PROPERTY_CARCINOGENIC		"carcinogenic"
#define PROPERTY_HEPATOTOXIC		"hepatotoxic"
#define PROPERTY_NEPHROTOXIC		"nephrotoxic"
#define PROPERTY_PNEUMOTOXIC		"pneumotoxic"
#define PROPERTY_OCULOTOXIC 		"oculotoxic"
#define PROPERTY_CARDIOTOXIC 		"cardiotoxic"
#define PROPERTY_NEUROTOXIC			"neurotoxic"
#define PROPERTY_HYPERMETABOLIC		"hypermetabolic"
//Neutral
#define PROPERTY_NUTRITIOUS 		"nutritious"
#define PROPERTY_KETOGENIC			"ketogenic"
#define PROPERTY_PAINING 			"paining"
#define PROPERTY_NEUROINHIBITING 	"neuroinhibiting"
#define PROPERTY_ALCOHOLIC			"alcoholic"
#define PROPERTY_HALLUCINOGENIC		"hallucinogenic"
#define PROPERTY_RELAXING			"relaxing"
#define PROPERTY_HYPERTHERMIC		"hyperthermic"
#define PROPERTY_HYPOTHERMIC		"hypothermic"
#define PROPERTY_BALDING			"balding"
#define PROPERTY_FLUFFING 			"fluffing"
#define PROPERTY_ALLERGENIC 		"allergenic"
#define PROPERTY_CRYOMETABOLIZING 	"cryometabolizing"
#define PROPERTY_EUPHORIC			"euphoric"
#define PROPERTY_EMETIC				"emetic"
#define PROPERTY_PSYCHOSTIMULATING	"psychostimulating"
#define PROPERTY_ANTIHALLUCINOGENIC	"anti-hallucinogenic"
#define PROPERTY_EXCRETING			"excreting"
#define PROPERTY_HYPOMETABOLIC		"hypometabolic"
#define PROPERTY_SEDATIVE			"sedative"
//Positive
#define PROPERTY_ANTITOXIC			"anti-toxic"
#define PROPERTY_ANTICORROSIVE		"anti-corrosive"
#define PROPERTY_NEOGENETIC			"neogenetic"
#define PROPERTY_REPAIRING 			"repairing"
#define PROPERTY_HEMOGENIC 			"hemogenic"
#define PROPERTY_NERVESTIMULATING 	"nerve-stimulating"
#define PROPERTY_MUSCLESTIMULATING	"muscle-stimulating"
#define PROPERTY_PAINKILLING		"painkilling"
#define PROPERTY_HEPATOPEUTIC		"hepatopeutic"
#define PROPERTY_NEPHROPEUTIC		"nephropeutic"
#define PROPERTY_PNEUMOPEUTIC		"pneumopeutic"
#define PROPERTY_OCULOPEUTIC		"oculopeutic"
#define PROPERTY_CARDIOPEUTIC		"cardiopeutic"
#define PROPERTY_NEUROPEUTIC		"neuropeutic"
#define PROPERTY_BONEMENDING 		"bonemending"
#define PROPERTY_FLUXING 			"fluxing"
#define PROPERTY_NEUROCRYOGENIC		"neurocryogenic"
#define PROPERTY_ANTIPARASITIC		"anti-parasitic"
#define PROPERTY_ELECTROGENETIC		"electrogenetic"
//Rare Combo, made by combining other properties
#define PROPERTY_DEFIBRILLATING		"defibrillating"
#define PROPERTY_THANATOMETABOL		"thanatometabolizing"
#define PROPERTY_HYPERDENSIFICATING	"hyperdensificating"
#define PROPERTY_HYPERTHROTTLING	"hyperthrottling"
#define PROPERTY_NEUROSHIELDING		"neuroshielding"
#define PROPERTY_ANTIADDICTIVE		"anti-addictive"
#define PROPERTY_ADDICTIVE			"addictive"
//Legendary, only in gen_tier 3+
#define PROPERTY_HYPERGENETIC		"hypergenetic"
#define PROPERTY_BOOSTING			"boosting"
#define PROPERTY_DNA_DISINTEGRATING	"DNA-Disintegrating"
#define PROPERTY_REGULATING			"regulating"
#define PROPERTY_CIPHERING			"ciphering"
#define PROPERTY_CIPHERING_PREDATOR "cross-ciphering"
//Admin Only Properties
#define PROPERTY_CROSSMETABOLIZING	"cross-metabolizing"
#define PROPERTY_EMBRYONIC			"embryonic"
#define PROPERTY_TRANSFORMING		"transforming"
#define PROPERTY_RAVENING			"ravening"
#define PROPERTY_CURING				"curing"
#define PROPERTY_OMNIPOTENT			"omnipotent"
#define PROPERTY_RADIUS				"radius" // Fire related admin property
#define PROPERTY_INTENSITY			"intensity" // Fire related admin property
#define PROPERTY_DURATION			"duration" // Fire related admin property
#define PROPERTY_FIRE_PENETRATING	"fire-penetrating" // Fire related admin property
//Reaction Properties
#define PROPERTY_FUELING			"fueling"
#define PROPERTY_OXIDIZING			"oxidizing"
#define PROPERTY_FLOWING			"flowing"
#define PROPERTY_VISCOUS			"viscous"
#define PROPERTY_EXPLOSIVE			"explosive"
//Generation Disabled Properties
#define PROPERTY_CARDIOSTABILIZING	"cardio-stabilizing"
#define PROPERTY_AIDING				"aiding"
#define PROPERTY_THERMOSTABILIZING	"themo-stabilizing"
#define PROPERTY_OXYGENATING		"oxygenating"
#define PROPERTY_FOCUSING			"focusing"
#define PROPERTY_ANTICARCINOGENIC	"anti-carcinogenic"
#define PROPERTY_UNKNOWN			"unknown" //just has an OD effect
#define PROPERTY_HEMOSITIC			"hemositic"


//Property rarity
#define PROPERTY_DISABLED			0 //the property is disabled and can't spawn anywhere, however is still functional
#define PROPERTY_COMMON				1 //can be generated anywhere and available in round start chems
#define PROPERTY_UNCOMMON			2 //can be generated anywhere, but not available in round start chems
#define PROPERTY_RARE				3 //can only be generated at specific gen_tiers, but can also be made through specific property combinations
#define PROPERTY_LEGENDARY			4 //can strictly only be generated at specific gen_tiers
#define PROPERTY_ADMIN				5 //can only be spawned through admin powers

//Property category
#define PROPERTY_TYPE_ALL				0
#define PROPERTY_TYPE_MEDICINE			1
#define PROPERTY_TYPE_TOXICANT			2
#define PROPERTY_TYPE_STIMULANT			4
#define PROPERTY_TYPE_REACTANT			8
#define PROPERTY_TYPE_IRRITANT			16
#define PROPERTY_TYPE_METABOLITE		32
#define PROPERTY_TYPE_ANOMALOUS			64
#define PROPERTY_TYPE_UNADJUSTABLE		128
#define PROPERTY_TYPE_CATALYST 			256

// Defines for pain applied pr tick by chems
#define PROPERTY_PAINING_PAIN 		0.5
#define PROPERTY_PAINING_PAIN_OD 	1
#define PROPERTY_DEFIBRILLATING_PAIN_OD	1
#define PROPERTY_CARDIOPEUTIC_PAIN_CRITICAL	3