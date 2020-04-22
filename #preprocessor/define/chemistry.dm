/*
	reagents defines
*/

#define SOLID 1
#define LIQUID 2
#define GAS 3

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
#define NUTRITION_MAX		450
#define NUTRITION_NORMAL	400
#define NUTRITION_LOW		250
#define NUTRITION_VERYLOW	50


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

//Chemical properties
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
//Neutral
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
#define PROPERTY_HYPERMETABOLIC		"hypermetabolic"
#define PROPERTY_SEDATIVE			"sedative"
//Positive
#define PROPERTY_NUTRITIOUS 		"nutritious"
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
//Combo, made by combining other properties
#define PROPERTY_DEFIBRILLATING		"defibrillating"
#define PROPERTY_THANATOMETABOL		"thanatometabolizing"
#define PROPERTY_HYPERDENSIFICATING	"hyperdensificating"
#define PROPERTY_HYPERTHROTTLING	"hyper throttling"
#define PROPERTY_NEUROSHIELDING		"neuroshielding"
#define PROPERTY_ANTIADDICTIVE		"anti-addictive"
#define PROPERTY_ADDICTIVE			"addictive"
//Rare, only in gen_tier 3+
#define PROPERTY_HYPERGENETIC		"hypergenetic"
#define PROPERTY_BOOSTING			"boosting"
#define PROPERTY_DNA_DISINTEGRATING	"DNA-Disintegrating"
#define PROPERTY_REGULATING			"regulating"
//Admin Only Properties
#define PROPERTY_CROSSMETABOLIZING	"cross-metabolizing"
#define PROPERTY_EMBRYONIC			"embryonic"
#define PROPERTY_TRANSFORMING		"transforming"
#define PROPERTY_RAVENING			"ravening"
#define PROPERTY_CURING				"curing"
#define PROPERTY_OMNIPOTENT			"omnipotent"
//Reaction Properties
#define PROPERTY_FUELING			"fueling"
#define PROPERTY_OXIDIZING			"oxidizing"
#define PROPERTY_FLOWING			"flowing"
#define PROPERTY_VISCOUS			"viscous"
#define PROPERTY_EXPLOSIVE			"explosive"

