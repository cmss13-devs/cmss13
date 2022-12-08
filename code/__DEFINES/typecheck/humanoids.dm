//Typechecks should be AVOIDED whenever possible. Instead of using them, try properties of what you're checking, such as the flags of clothing.
#define ishuman(A) (istype(A, /mob/living/carbon/human) )

//Check if the mob is an actual human (and not Yautja or Synth)
#define isHumanStrict(A) (ishuman(A) && istype(A?:species, /datum/species/human))

//Check if the mob is an actual human or Synth
#define isHumanSynthStrict(A)   (ishuman(A) && (istype(A?:species, /datum/species/human) || istype(A?:species, /datum/species/synthetic)))

#define iszombie(A) (ishuman(A) && istype(A?:species, /datum/species/zombie))
#define ismonkey(A) (ishuman(A) && istype(A?:species, /datum/species/monkey))
#define isYautja(A) (ishuman(A) && istype(A?:species, /datum/species/yautja))
#define isResearcher(A) (ishuman(A) && A.job == "Researcher")
#define isSEA(A) (ishuman(A) && A.job == "Senior Enlisted Advisor")
#define isSynth(A)  (ishuman(A) && istype(A?:species, /datum/species/synthetic))
#define isColonySynthetic(A) (ishuman(A) && istype(A?:species, /datum/species/synthetic/colonial))
#define isWorkingJoe(A) (isColonySynthetic(A) && A.job == JOB_WORKING_JOE)
#define isInfiltratorSynthetic(A) (ishuman(A) && istype(A?:species, /datum/species/synthetic/infiltrator))
#define hasorgans(A) ishuman(A)

//Specic group checks, use instead of typechecks (but use traits instead)
#define isSameSpecies(A, B) (A.species?.group == B.species?.group)
#define isSpeciesHuman(A) (A.species?.group == SPECIES_HUMAN)
#define isSpeciesMonkey(A) (A.species?.group == SPECIES_MONKEY)
#define isSpeciesYautja(A) (A.species?.group == SPECIES_YAUTJA)
#define isSpeciesSynth(A) (A.species?.group == SPECIES_SYNTHETIC)

//Size checks for carbon to use instead of typechecks. (Hellhounds are deprecated)
#define isCarbonSizeXeno(A) (A.mob_size >= MOB_SIZE_XENO_SMALL)
#define isCarbonSizeHuman(A) (A.mob_size <= MOB_SIZE_HUMAN)

//job/role helpers
#define ismarinejob(J) (istype(J, /datum/job/marine))
#define issurvivorjob(J) (J == JOB_SURVIVOR)
