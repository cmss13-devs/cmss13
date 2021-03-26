/datum/species/human
	name = "Human"
	name_plural = "Humans"
	primitive = /mob/living/carbon/human/monkey
	unarmed_type = /datum/unarmed_attack/punch
	flags = HAS_SKIN_TONE|HAS_LIPS|HAS_UNDERWEAR|HAS_HARDCRIT
	mob_flags = KNOWS_TECHNOLOGY
	uses_ethnicity = TRUE

//Tougher humans, basically action movie protagonists.
/datum/species/human/hero
	name = "Human Hero"
	name_plural = "Human Heroes"
	brute_mod = 0.5
	burn_mod = 0.5
	unarmed_type = /datum/unarmed_attack/punch/strong
	pain_type = /datum/pain/human_hero
	darksight = 5
	cold_level_1 = 220
	cold_level_2 = 180
	cold_level_3 = 80
	heat_level_1 = 390
	heat_level_2 = 480
	heat_level_3 = 1100
	knock_down_reduction = 2
	stun_reduction = 2

/datum/species/human/hero/handle_post_spawn(var/mob/living/carbon/human/H)
	H.universal_understand = TRUE
	H.status_flags |= NO_PERMANENT_DAMAGE //John Wick doesn't get internal bleeding from a grazing gunshot
	H.status_flags &= ~(CANSLOW|CANKNOCKOUT|CANDAZE|CANSTUN)
	return ..()

//Various horrors that spawn in and haunt the living.
/datum/species/human/spook
	name = "Horror"
	name_plural = "Horrors"
	icobase = 'icons/mob/humans/species/r_spooker.dmi'
	deform = 'icons/mob/humans/species/r_spooker.dmi'
	brute_mod = 0.15
	burn_mod = 1.50
	reagent_tag = IS_HORROR
	flags = HAS_SKIN_COLOR|NO_BREATHE|NO_POISON|HAS_LIPS|NO_CLONE_LOSS|NO_POISON|NO_BLOOD|NO_SLIP|NO_CHEM_METABOLIZATION
	unarmed_type = /datum/unarmed_attack/punch/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
	death_message = "doubles over, unleashes a horrible, ear-shattering scream, then falls motionless and still..."
	death_sound = 'sound/voice/scream_horror1.ogg'

	darksight = 8
	slowdown = 0.3
	insulated = 1
	has_fine_manipulation = 0

	heat_level_1 = 1000
	heat_level_2 = 1500
	heat_level_3 = 2000

	cold_level_1 = 100
	cold_level_2 = 50
	cold_level_3 = 20

	//To show them we mean business.
	handle_unique_behavior(var/mob/living/carbon/human/H)
		//if(prob(25)) animation_horror_flick(H)

		//Organ damage will likely still take them down eventually.
		H.apply_damage(-3, BRUTE)
		H.apply_damage(-3, BURN)
		H.apply_damage(-15, OXY)
		H.apply_damage(-15, TOX)


/datum/species/human/spook/handle_post_spawn(mob/living/carbon/human/H)
	H.set_languages(list("Drrrrrrr"))
	return ..()