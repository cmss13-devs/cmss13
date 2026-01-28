// All reagents related to medicine

/datum/reagent/medical
	flags = REAGENT_TYPE_MEDICAL | REAGENT_SCANNABLE

/datum/reagent/medical/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a weak synaptic stimulant and cardiostimulant used to stabilize patients under cardiac arrest by allowing respiration when the lungs are functional. Though the body can tolerate unusually high doses of the medication, as a cardiostimulant, the side effects of overdosing at include involuntary body jerks, limb seizures, and collapsing. Critical overdoses damage cardiac tissue."
	reagent_state = LIQUID
	color = "#e688b7" // rgb: 230, 136, 183 //changed to differentiate from Tramadol in autoinjectors and bottles
	overdose = HIGH_REAGENTS_OVERDOSE
	overdose_critical = HIGH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_CARDIOSTABILIZING = 3)

/datum/reagent/medical/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn repairs genetic and ocular defects, mutations, and abnormalities through a catalytic process. Side effects of ryetalyn overdoses include confusion and toxin damage. Critical overdoses cause paralysis and damage to DNA strands."
	reagent_state = SOLID
	color = "#E4D2EE" // rgb: 228, 210, 238
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_AIDING = 2)

/datum/reagent/medical/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Also known as Tylenol, this is a moderate long lasting painkiller that has been commonly available since 1950. Paracetamol is capable of both analgesic and antipyretic activity but no anti-inflammatory action. Overdosing on paracetamol is toxic, may induce hallucinations, and cause acute liver failure. Side effects of Paracetamol overdoses include: Opiate Receptor Deficiency, hallucinations, and toxin damage. Critical overdoses become neurotoxic, hepatotoxic, and cause extreme difficulties in breathing."
	reagent_state = LIQUID
	color = "#C855DC" // rgb: 200, 85, 220
	custom_metabolism = AMOUNT_PER_TIME(15, 10 MINUTES) // Lasts 10 minutes for 15 units
	overdose = HIGH_REAGENTS_OVERDOSE
	overdose_critical = HIGH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 1)

/datum/reagent/medical/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "Tramadol is a centrally acting analgesic. The analgesic potency is claimed to be about one-tenth that of morphine. It is used to treat both acute and chronic pain of moderate to (moderately) severe intensity. Tramadol is generally considered a medicinal drug with a low potential for dependence relative to morphine. Side effects of Tramadol overdoses include: Opiate Receptor Deficiency, hallucinations, and toxin damage. Critical overdoses become neurotoxic, hepatotoxic, and cause extreme difficulties in breathing."
	reagent_state = LIQUID
	color = "#d7c7e0" // rgb: 215, 199, 224
	custom_metabolism = AMOUNT_PER_TIME(15, 10 MINUTES) // Lasts 10 minutes for 15 units
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 2.5)

//Changed to Common so turing will dispense. definition of common chem class "Chemicals which recipe is commonly known and made". Oxycodone is such being available from med dispenser
/datum/reagent/medical/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "Oxycodone is an opioid agonist with addiction potential similar to that of morphine. It is approved for the treatment of patients with moderate to severe pain who are expected to need continuous opioids for an extended period of time. Side effects of oxycodone overdoses include: Opiate Receptor Deficiency, hallucinations, and toxin damage. Critical overdoses become neurotoxic, hepatotoxic, and cause extreme difficulties in breathing."
	reagent_state = LIQUID
	color = "#1cc282" // rgb: 28, 194, 130
	custom_metabolism = AMOUNT_PER_TIME(15, 5 MINUTES) // Lasts 5 minutes for 15 units
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 4)

/datum/reagent/medical/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "A sterilizer used to clean wounds in preparation for surgery. Its use has mostly been outclassed to the cheaper alternative of space cleaner."
	reagent_state = LIQUID
	color = "#b8d2f5" // rgb: 184, 210, 245
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/medical/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "A drug used to treat hypothermia and hyperthermia. Stabilizes patient body temperature. Prevents the use of cryogenics. Overdoses cause drowsiness and paralysis."
	reagent_state = LIQUID
	color = "#a03919" // rgb: 160, 57, 25
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_THERMOSTABILIZING = 2)

/datum/reagent/medical/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a common anticorrosive drug used to treat corrosive and caustic burn trauma. Overdoses are ironically caustic and toxic, damaging skin and muscle tissues."
	reagent_state = LIQUID
	color = "#d8b343" // rgb: 216, 179, 67
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_ANTICORROSIVE = 2)

/datum/reagent/medical/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is a more potent anticorrosive drug used to treat severe burn trauma. It enables the body to restore damaged tissue even after accruing fourth-degree burns, down to the bone. Overdoses are ironically caustic and toxic, damaging skin and muscle tissues."
	reagent_state = LIQUID
	color = "#e2972e" // 226, 151, 46
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_ANTICORROSIVE = 3)

/datum/reagent/medical/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation by feeding oxygen to red blood cells directly inside the bloodstream. Overdoses are toxic and can severely damage skin and muscle tissues."
	reagent_state = LIQUID
	color = "#1f28a7" // rgb: 31, 40, 167
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_OXYGENATING = 4)

/datum/reagent/medical/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is an upgraded form of Dexalin with added iron and carbon to expedite the rate at which oxygen binds to the hemoglobin in red blood cells. One unit can immediately and completely cleanse the body of excessive carbon dioxide. However, overdoses are toxic and can severely damage skin and muscle tissues."
	reagent_state = LIQUID
	color = "#4d5cdb" // rgb: 77, 92, 219
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_OXYGENATING = 6)

/datum/reagent/medical/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. It is a wide-spectrum medication that treats all types of skin and muscle damage, replenishes the body with oxygen, and neutralizes toxins. It is extremely toxic when overdosing, however, causing widespread toxin, tissue, and organ damage."
	reagent_state = LIQUID
	color = "#d87f2b" // rgb: 216, 127, 43
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEOGENETIC = 1, PROPERTY_ANTICORROSIVE = 1, PROPERTY_ANTITOXIC = 1, PROPERTY_OXYGENATING = 1)

/datum/reagent/medical/anti_toxin
	name = "Dylovene"
	id = "anti_toxin"
	description = "General-use antitoxin that neutralizes most toxins in the bloodstream. Commonly used in many advanced chemicals. It can be used as a mild anti-hallucinogen and to reduce tiredness. A patient overdosing on dylovene will not accumulate toxins, but they will be drowsy and accrue ocular damage."
	reagent_state = LIQUID
	color = "#3EA72A" // rgb: 62, 167, 42 changed to be slightly darker to differentiate from oxycodone autoinjectors
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_ANTITOXIC = 2, PROPERTY_ANTIHALLUCINOGENIC = 2)

/datum/reagent/medical/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "A magical substance created by gods to dissolve extreme amounts of salt."
	reagent_state = LIQUID
	color = "#dae63b" // rgb: 218, 230, 59
	properties = list(PROPERTY_OMNIPOTENT = 2)
	flags = REAGENT_TYPE_MEDICAL

/datum/reagent/medical/thwei //OP yautja chem
	name = "Thwei"
	id = "thwei"
	description = "A strange, alien liquid."
	reagent_state = LIQUID
	color = "#41c498" // rgb: 65, 196, 152
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_HIGH_VALUE
	properties = list(
		PROPERTY_CROSSMETABOLIZING = 1,
		PROPERTY_ANTITOXIC = 1,
		PROPERTY_YAUTJA_HEMOGENIC = 9,
		PROPERTY_OXYGENATING = 6,
		PROPERTY_ANTICARCINOGENIC = 6,
		PROPERTY_BONEMENDING = 6,
		PROPERTY_AIDING = 1,
		PROPERTY_ANTIHALLUCINOGENIC = 2,
		PROPERTY_FOCUSING = 6,
		PROPERTY_CURING = 4,
		PROPERTY_OCULOPEUTIC = 2,
		PROPERTY_NEUROPEUTIC = 2,
	)
	flags = REAGENT_TYPE_MEDICAL

/datum/reagent/medical/thwei/human
	name = "Dathwei"
	id = "dathwei"
	color = "#c46b41" // rgb: 77, 42, 25
	properties = list(
		PROPERTY_CARDIOSTABILIZING = 4,
		PROPERTY_ORGANSTABILIZE = 1,
		PROPERTY_PAINKILLING = 4,
		PROPERTY_ANTITOXIC = 1,
		PROPERTY_YAUTJA_HEMOGENIC = 3,
		PROPERTY_OXYGENATING = 6,
		PROPERTY_ANTICARCINOGENIC = 6,
		PROPERTY_BONEMENDING = 6,
		PROPERTY_AIDING = 1,
		PROPERTY_ANTIHALLUCINOGENIC = 2,
		PROPERTY_FOCUSING = 6,
		PROPERTY_CURING = 4,
		PROPERTY_OCULOPEUTIC = 2,
		PROPERTY_NEUROPEUTIC = 2,
	)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_NO_GENERATION

/datum/reagent/medical/neuraline //injected by neurostimulator implant
	name = "Neuraline"
	id = "neuraline"
	description = "A chemical cocktail tailored to enhance or dampen specific neural processes."
	reagent_state = LIQUID
	color = "#a244d8" // rgb: 162, 68, 216
	custom_metabolism = AMOUNT_PER_TIME(1, 5 SECONDS)
	overdose = 2
	overdose_critical = 3
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NERVESTIMULATING = 5)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_NO_GENERATION

/datum/reagent/medical/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "A stabilized variant of dylovene with the side effect of damaging skin and muscle tissue as it cleanses the body of toxins. Its toxin-cleansing properties are weakened, but it does not react with other compounds to create toxins. The body has a low tolerance to this medication, with side effects after an overdose including drowsiness and eye damage."
	reagent_state = LIQUID
	color = "#3c8529" // rgb: 60, 133, 41
	custom_metabolism = AMOUNT_PER_TIME(1, 40 SECONDS)
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_ANTITOXIC = 1, PROPERTY_BIOCIDIC = 1)

/datum/reagent/medical/russianred
	name = "Russian Red"
	id = "russianred"
	description = "An emergency radiation treatment. The list of potential side effects includes retinal damage and unconsciousness."
	reagent_state = LIQUID
	color = "#ce2727" // rgb: 206, 39, 39
	custom_metabolism = AMOUNT_PER_TIME(1, 2 SECONDS)
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_ANTITOXIC = 1, PROPERTY_BIOCIDIC = 2)

/datum/reagent/medical/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen and heal the damage to neurological tissue after a catastrophic injury. Alkysine is toxic upon overdosing, and critical overdoses are neurotoxic and sever the connection between nerve endings in the spine, causing paralysis in the limbs."
	reagent_state = LIQUID
	color = "#e9d191" // rgb: 233, 209, 145
	custom_metabolism = AMOUNT_PER_TIME(1, 40 SECONDS)
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEUROPEUTIC = 2)

/datum/reagent/medical/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Used for treating non-genetic eye trauma. Generally prescribed as treatment for most cases of eye trauma instead of performing a surgical operation. Imidazoline is toxic during an overdose, and is neurotoxic at critical overdosing."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_OCULOPEUTIC = 2)

/datum/reagent/medical/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Prevents symptoms caused by damaged internal organs while in the bloodstream, but does not fix the organ damage. Recommended for patients awaiting internal organ surgery. Overdosing on peridaxon at damages external tissues, and critical overdoses ironically damage internal organs."
	reagent_state = LIQUID
	color = "#403142" // rgb: 64, 49, 66
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	custom_metabolism = AMOUNT_PER_TIME(1, 40 SECONDS)
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_ORGANSTABILIZE = 4)

/datum/reagent/medical/bicaridine // no, it no longer cures IB while overdosing.
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat severe external blunt trauma and to stabilize patients. Overdosing on Bicaridine will cause caustic burns and it is toxic with critical overdoses."
	reagent_state = LIQUID
	color = "#e7554a" // rgb: 231, 85, 74
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NEOGENETIC = 2)

/datum/reagent/medical/meralyne
	name = "Meralyne"
	id = "meralyne"
	description = "Advanced analgesic medication used to treat extremely severe blunt trauma. Allows the body to quickly repair damaged tissue. Overdosing on Meralyne will cause severe corrosion to cell membranes and is toxic at critical overdoses."
	reagent_state = LIQUID
	color = "#b40000"  // rgb: 180, 0, 0
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEOGENETIC = 3)

/datum/reagent/medical/adrenaline
	name = "Epinephrine"
	id = "adrenaline"
	description = "Known commonly as the natural muscle and heart stimulant 'adrenaline,' low doses of this medication help restart the heart after defibrillation. It also acts as a mild painkiller. Overdosing on epinephrine will stress the heart and cause tissue damage."
	reagent_state = LIQUID
	color = "#FFF0B9"  // rgb: 255, 240, 185
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL
	custom_metabolism = AMOUNT_PER_TIME(1, 5 SECONDS)
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 0.75, PROPERTY_ELECTROGENETIC = 2, PROPERTY_INTRAVENOUS = 1)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_SCANNABLE

/datum/reagent/medical/ultrazine
	name = "Ultrazine"
	id = "ultrazine"
	description = "A highly-potent, long-lasting combination CNS and muscle stimulant. Extremely addictive. Overdosing on Ultrazine is cardiotoxic and will cause heart damage."
	reagent_state = LIQUID
	color = "#ffe043" // rgb: 255, 224, 67
	custom_metabolism = 0.0167 //5 units will last approximately 10 minutes
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_MUSCLESTIMULATING = 40, PROPERTY_ADDICTIVE = 8)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_NO_GENERATION

/datum/reagent/medical/stimulant
	name = "Stimulant"
	id = "antag_stimulant"
	description = "A highly-potent, long-lasting combination CNS and muscle stimulant."
	reagent_state = LIQUID
	color = "#2bd4d4" // rgb: 43, 212, 212
	custom_metabolism = AMOUNT_PER_TIME(1, 40 SECONDS) // 4x longer
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_UNKNOWN = 1)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_NO_GENERATION

/datum/reagent/medical/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "Industrial grade cryogenic medicine. Treats most types of tissue damage. Its main limitation is that the patient's body temperature must be under 170K to metabolize correctly."
	reagent_state = LIQUID
	color = "#4acaca" // rgb: 74, 202, 202
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CRYOMETABOLIZING = 2, PROPERTY_NEOGENETIC = 1, PROPERTY_ANTICORROSIVE = 1, PROPERTY_ANTITOXIC = 1, PROPERTY_ANTICARCINOGENIC = 1)

/datum/reagent/medical/cryoxadone/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	if(M.bodytemperature < BODYTEMP_CRYO_LIQUID_THRESHOLD)
		M.adjustCloneLoss(-1)
		M.apply_damage(-1, OXY)
		M.heal_limb_damage(1,1)
		M.apply_damage(-1, TOX)

/datum/reagent/medical/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "Advanced cryogenic medicine made from cryoxadone. Treats most types of tissue damage. Requires temperatures below 170K to metabolize correctly."
	reagent_state = LIQUID
	color = "#51b4db" // rgb: 81, 180, 219
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CRYOMETABOLIZING = 6, PROPERTY_NEOGENETIC = 3, PROPERTY_ANTICORROSIVE = 3, PROPERTY_ANTITOXIC = 3, PROPERTY_ANTICARCINOGENIC = 3)

/datum/reagent/medical/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder derived from fish toxin, this substance can effectively treat genetic damage in humanoids. Causes toxin damage. Excessive consumption may cause disastrous side effects."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_NEOGENETIC = 1, PROPERTY_AIDING = 3, PROPERTY_TOXIC = 2, PROPERTY_ANTICARCINOGENIC = 2)

/datum/reagent/medical/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "General use theta-lactam antibiotic. Prevents and cures mundane infections."
	reagent_state = LIQUID
	color = "#9749c4" // rgb: 151, 73, 196
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_UNKNOWN = 1)

/datum/reagent/medical/ethylredoxrazine // FUCK YOU, ALCOHOL
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "Neutralizes the effects of alcohol in the bloodstream, by oxidizing it into water molecules. However, it does not stop immediate intoxication. Ethylredoxrazine, ironically, becomes toxic upon overdosing."
	reagent_state = SOLID
	color = "#605048" // rgb: 96, 80, 72
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_FOCUSING = 3)

///////ANTIDEPRESSANTS///////
/datum/reagent/medical/antidepressant/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "A commonly prescribed psychostimulant that increases activity of the central nervous system. Often used to treat attention deficit hyperactivity disorder (ADHD) and narcolepsy. This drug improves performance primarily in the executive function in the prefrontal cortex (reasoning, inhibiting behaviors, organizing, problem solving, planning, etc.)"
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 4)

/datum/reagent/medical/antidepressant/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Citalopram is a drug used to treat depression, obsessive-compulsive disorder, and panic disorder. It is considered safe for consumption and has been commonly available since 1998."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 2)

/datum/reagent/medical/antidepressant/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Very powerful antidepressant used to treat major depressive disorder (MDD), obsessive-compulsive disorder (OCD), social anxiety disorder (SAD), panic disorder, posttraumatic stress disorder (PTSD), generalized anxiety disorder (GAD) and premenstrual dysphoric disorder (PMDD). Prolonged use may have side effects."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 6, PROPERTY_HALLUCINOGENIC = 6)

/datum/reagent/medical/antized
	name = "Anti-Zed"
	id = "antiZed"
	description = "An experimental drug that destroys the zombie virus in living humans and prevents regeneration for those who have already turned."
	reagent_state = LIQUID
	color = "#41D4FB"
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	data = 0
	properties = list(PROPERTY_CURING = 2)

/datum/reagent/medical/host_stabilizer
	name = "Xenomorph embryotic secretion"
	id = "host_stabilizer"
	description = "A strange and unknown concoction of hormones and chemicals that xenomorph embryos secrete as they grow inside hosts to stabilize them."
	reagent_state = LIQUID
	color = BLOOD_COLOR_XENO
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_CRITICALSTABILIZE = 1, PROPERTY_CROSSMETABOLIZING = 2)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_NO_GENERATION

