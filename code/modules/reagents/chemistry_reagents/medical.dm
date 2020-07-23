
// All reagents related to medicine



/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients. If the lungs are functional, inaprovaline will allow respiration while under cardiac arrest. Slows down bleeding and acts as a weak painkiller. Overdosing may cause severe damage to cardiac tissue."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = HIGH_REAGENTS_OVERDOSE
	overdose_critical = HIGH_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_CARDIOSTABILIZING = 3)

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn repairs genetic defects, mutations and abnormalities through a catalytic process. Used to treat genetic eye and vision problems. Overdosing on ryetalyn is very toxic and can impair sense of balance."
	reagent_state = SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_AIDING = 2)

/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Also known as Tylenol, this is a moderate long lasting painkiller that has been commonly available since 1950. Paracetamol is capable of both analgesic and antipyretic activity but no anti-inflammatory action. Overdosing on paracetamol is toxic, may induce hallucinations, and cause acute liver failure."
	reagent_state = LIQUID
	color = "#C855DC"
	scannable = 1
	custom_metabolism = 0.025 // Lasts 10 minutes for 15 units
	overdose = HIGH_REAGENTS_OVERDOSE
	overdose_critical = HIGH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 2)

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "Tramadol is a centrally acting analgesic and is considered to be a relatively safe. The analgesic potency is claimed to be about one tenth that of morphine. It is used to treat both acute and chronic pain of moderate to (moderately) severe intensity. Tramadol is generally considered as a medicinal drug with a low potential for dependence relative to morphine. Overdosing on tramadol is highly toxic."
	reagent_state = LIQUID
	color = "#C8A5DC"
	scannable = 1
	custom_metabolism = 0.1 // Lasts 10 minutes for 15 units
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 5)

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "Oxycodone is an opioid agonist with addiction potential similar to that of morphine. It is approved for the treatment of patients with moderate to severe pain who are expected to need continuous opioids for an extended period of time. Overdosing on oxycodone can cause hallucinations, brain damage and be highly toxic."
	reagent_state = LIQUID
	color = "#C805DC"
	scannable = 1
	custom_metabolism = 0.2 // Lasts 5 minutes for 15 units
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 8)

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "A sterilizer used to clean wounds in preparation for surgery. Its use has mostly been outclassed to the cheaper alternative of space cleaner."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "A drug used to treat hypothermia and hyperthermia. Stabilizes patient body temperture. Prevents the use of cryogenics. Overdosing on leporazine can cause extreme drowsyness."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_THERMOSTABILIZING = 2)

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Common medicine used to treat burns, caustic and corrosive trauma. Overdosing on kelotane can cause internal tissue damage."
	reagent_state = LIQUID
	color = "#D8C58C"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_ANTICORROSIVE = 2)

/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Advanced medicine used to treat severe burn trauma. Enables the body to restore even the direst heat-damaged tissue. Overdosing on dermaline can cause severe internal tissue damage."
	reagent_state = LIQUID
	color = "#F8C57C"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_ANTICORROSIVE = 3)

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation by feeding oxygen to red blood cells directly inside the bloodstream. Used as an antidote to lexorin poisoning."
	reagent_state = LIQUID
	color = "#C865FC"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_OXYGENATING = 4)

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is an upgraded form of Dexalin with added iron and carbon to quicken the rate which oxygen binds to the hemoglobin in red blood cells."
	reagent_state = LIQUID
	color = "#C8A5FC"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_OXYGENATING = 6)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	reagent_state = LIQUID
	color = "#B865CC"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEOGENETIC = 1, PROPERTY_ANTICORROSIVE = 1, PROPERTY_ANTITOXIC = 1, PROPERTY_OXYGENATING = 1)

/datum/reagent/anti_toxin
	name = "Dylovene"
	id = "anti_toxin"
	description = "General use anti-toxin, that neutralizes most toxins in the bloodstream. Commonly used in many advanced chemicals. Can be used as a mild anti-hallucinogen and to reduce tiredness."
	reagent_state = LIQUID
	color = "#A8F59C"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_ANTITOXIC = 2, PROPERTY_ANTIHALLUCINOGENIC = 2)

/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "A magical substance created by gods to dissolve extreme amounts of salt."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	properties = list(PROPERTY_OMNIPOTENT = 2)

/datum/reagent/thwei //OP yautja chem
	name = "Thwei"
	id = "thwei"
	description = "A strange, alien liquid."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(	PROPERTY_CROSSMETABOLIZING = 1,
						PROPERTY_HYPERGENETIC = 1,
						PROPERTY_ANTICORROSIVE = 1,
						PROPERTY_ANTITOXIC = 1,
						PROPERTY_OXYGENATING = 6,
						PROPERTY_ANTICARCINOGENIC = 6,
						PROPERTY_BONEMENDING = 6,
						PROPERTY_AIDING = 1,
						PROPERTY_ANTIHALLUCINOGENIC = 2,
						PROPERTY_FOCUSING = 6,
						PROPERTY_CURING = 4)

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "A controlled nervestimulant that treats hallucinations, drowsiness, improves reaction time and acts as a weak painkiller. Is mildly toxic and overdosing will cause extreme toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.1
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 1, PROPERTY_NERVESTIMULATING = 2, PROPERTY_ANTIHALLUCINOGENIC = 2, PROPERTY_TOXIC = 1)

/datum/reagent/neuraline //injected by neurostimulator implant
	name = "Neuraline"
	id = "neuraline"
	description = "A chemical cocktail tailored to enhance or dampen specific neural processes."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.4
	overdose = 2
	overdose_critical = 3
	scannable = 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NERVESTIMULATING = 5)

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "A stabilized variant of dylovene. Its toxin-cleansing properties are weakened and there are harmful side effects, but it does not react with other compounds to create toxin."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_ANTITOXIC = 1, PROPERTY_BIOCIDIC = 1)

/datum/reagent/russianred
	name = "Russian Red"
	id = "russianred"
	description = "An emergency radiation treatment, however it has extreme side effects."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 1
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	properties = list(PROPERTY_ANTITOXIC = 1, PROPERTY_BIOCIDIC = 2)

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen and heal the damage to neurological tissue after a catastrophic injury. Small amounts can repair extensive brain trauma. Functions as a very weak painkiller. Overdosing on alkysine is extremely toxic."
	reagent_state = LIQUID
	color = "#E89599"
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEUROPEUTIC = 2)

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Used for treating non-genetic eye trauma. Generally prescribed as treatment for most cases of eye trauma instead of performing a surgical operation."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_OCULOPEUTIC = 2)

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Prevents symptoms caused by damaged internal organs while in the bloodstream, but does not fix the organ damage. Recommended for patients awaiting internal organ surgery. Overdosing on peridaxon will cause internal tissue damage."
	reagent_state = LIQUID
	color = "#C845DC"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	custom_metabolism = 0.05
	scannable = 1
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_UNKNOWN = 4) //handled by organ code

/datum/reagent/bicaridine // yes it cures IB, it's located in some other part of wound code for whatever reason
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat severe external blunt trauma and to stabilize patients. Overdosing will cause caustic burns, but can mend internal broken bloodvessels."
	reagent_state = LIQUID
	color = "#E8756C"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NEOGENETIC = 2)

/datum/reagent/quickclot
	name = "Quick Clot"
	id = "quickclot"
	description = "Vastly improves the blood's natural ability to coagulate and stop bleeding by hightening platelet production and effectiveness. Overdosing will cause extreme blood clotting, resulting in severe tissue damage."
	reagent_state = LIQUID
	color = "#CC00FF"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1 //scannable now.  HUZZAH.
	custom_metabolism = 0.05
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_UNKNOWN = 6) //handled by blood code

/datum/reagent/adrenaline
	name = "Epinephrine"
	id = "adrenaline"
	description = "A natural muscle and heart stimulant. Useful for restarting the heart. Overdosing may stress the heart and cause tissue damage."
	reagent_state = LIQUID
	ingestible = FALSE
	color = "FFE703" // Yellow-ish
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	custom_metabolism = 0.4
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 1.5, PROPERTY_MUSCLESTIMULATING = 1, PROPERTY_ELECTROGENETIC = 4)

/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "A potent long lasting muscle stimulant. Increases heart rate dramatically, which may damage cardiac tissue. Highly addictive. Controlled substance."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.2
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_MUSCLESTIMULATING = 2, PROPERTY_CARDIOTOXIC = 1)

/datum/reagent/ultrazine
	name = "Ultrazine"
	id = "ultrazine"
	description = "A highly-potent, long-lasting combination CNS and muscle stimulant. Extremely addictive."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.0167 //5 units will last approximately 10 minutes
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_MUSCLESTIMULATING = 40, PROPERTY_ADDICTIVE = 8)

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "Industrial grade cryogenic medicine. Treats most types of tissue damage. Its main limitation is that the patient's body temperature must be under 170K to metabolise correctly."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CRYOMETABOLIZING = 2, PROPERTY_NEOGENETIC = 1, PROPERTY_ANTICORROSIVE = 1, PROPERTY_ANTITOXIC = 1, PROPERTY_ANTICARCINOGENIC = 1)

/datum/reagent/cryoxadone/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-1)
		M.apply_damage(-1, OXY)
		M.heal_limb_damage(1,1)
		M.apply_damage(-1, TOX)

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "Advanced cryogenic medicine made from cryoxadone. Treats most types of tissue damage. Requires temperatures below 170K to to metabolise correctly."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CRYOMETABOLIZING = 6, PROPERTY_NEOGENETIC = 3, PROPERTY_ANTICORROSIVE = 3, PROPERTY_ANTITOXIC = 3, PROPERTY_ANTICARCINOGENIC = 3)

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder derived from fish toxin, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	properties = list(PROPERTY_NEOGENETIC = 1, PROPERTY_AIDING = 3, PROPERTY_TOXIC = 2, PROPERTY_ANTICARCINOGENIC = 2)

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "General use theta-lactam antibiotic. Prevents and cures mundane infections."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	properties = list(PROPERTY_UNKNOWN = 1)

/datum/reagent/ethylredoxrazine	// FUCK YOU, ALCOHOL
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "Neutralizes the effects of alcohol in the blood stream, by oxidizing it into water molecules. However, it does not stop immediate intoxication. Ethylredoxrazine being a powerful oxidizer, it becomes toxic in high doses."
	reagent_state = SOLID
	color = "#605048" // rgb: 96, 80, 72
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_FOCUSING = 3)

///////ANTIDEPRESSANTS///////
/datum/reagent/antidepressant/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "A commonly prescribed psychostimulant that increases activity of the central nervous system. Often used to treat attention deficit hyperactivity disorder (ADHD) and narcolepsy. This drug improves performance primarily in the executive function in the prefrontal cortex (reasoning, inhibiting behaviors, organizing, problem solving, planning ect.)"
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 4)

/datum/reagent/antidepressant/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Citalopram is a drug used to treat depression, obsessive-compulsive disorder and panic disorder. It is considered safe for consumption and has been commonly available since 1998."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 2)

/datum/reagent/antidepressant/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Very powerful antidepressant used to treat: major depressive disorder (MDD), obsessive-compulsive disorder (OCD), social anxiety disorder (SAD), panic disorder, posttraumatic stress disorder (PTSD), generalized anxiety disorder (GAD) and prenmenstrual dysphoric disorder (PMDD). Prolonged use may have side effects."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 6, PROPERTY_HALLUCINOGENIC = 6)

/datum/reagent/antized
	name = "Anti-Zed"
	id = "antiZed"
	description = "Destroy the zombie virus in living humans and prevents regeneration for those who have already turned."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0
	properties = list(PROPERTY_CURING = 2)

// Surgery muscle relaxant & painkiller in one
// Uses paralyze - cannot move, talk, or emote but can hear; patient is safe to operate on
/datum/reagent/suxamorycin
	name = "Suxamorycin"
	id = "suxamorycin"
	description = "A fairly new, powerful muscle relaxant, engineered from suxamethonium chloride. Weston-Yamada takes great pride in its quick effect and short duration, albeit its long-term effects are not tested yet."
	reagent_state = LIQUID
	custom_metabolism = 0.5
	color = "#32a852"
	scannable = 1
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	data = 0
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_SEDATIVE = 4, PROPERTY_HALLUCINOGENIC = 1)