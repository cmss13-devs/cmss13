// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
#define ishuman(A) (istype(A, /mob/living/carbon/human) )

//Check if the mob is an actual human (and not Yautja or Synth)
#define isHumanStrict(A) (ishuman(A) && istype(A?:species, /datum/species/human))

//Check if the mob is an actual human or Synth
#define isHumanSynthStrict(A)   (ishuman(A) && (istype(A?:species, /datum/species/human) || istype(A?:species, /datum/species/synthetic)))

#define iszombie(A) (ishuman(A) && istype(A?:species, /datum/species/zombie))
#define ismonkey(A) (ishuman(A) && istype(A?:species, /datum/species/monkey))
#define isYautja(A) (isHellhound(A) || (ishuman(A) && istype(A?:species, /datum/species/yautja)))
#define isResearcher(A) (ishuman(A) && A.job == "Researcher")
#define isSynth(A)  (ishuman(A) && istype(A?:species, /datum/species/synthetic))
#define isEarlySynthetic(A) (ishuman(A) && istype(A?:species, /datum/species/synthetic/early_synthetic))
#define hasorgans(A) ishuman(A)
