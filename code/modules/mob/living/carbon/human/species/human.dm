// handles all blood related problems for humans and synthetics, moved from blood.dm
/mob/living/proc/handle_blood()
	return

// Takes care blood loss and regeneration
/mob/living/carbon/human/handle_blood()
	if((species.flags & NO_BLOOD) && !(species.flags & IS_SYNTHETIC))
		return

	if(stat != DEAD && bodytemperature >= BODYTEMP_CRYO_LIQUID_THRESHOLD) //Dead or cryosleep people do not pump the blood.
		//Blood regeneration if there is some space
		if(blood_volume < max_blood && nutrition >= BLOOD_NUTRITION_COST)
			blood_volume += 0.1 // regenerate blood VERY slowly
			nutrition -= BLOOD_NUTRITION_COST
		else if(blood_volume > max_blood)
			blood_volume -= 0.1 // The reverse in case we've gotten too much blood in our body
			if(blood_volume > limit_blood)
				blood_volume = limit_blood // This should never happen, but lets make sure

		var/b_volume = blood_volume

		// Damaged heart virtually reduces the blood volume, as the blood isn't
		// being pumped properly anymore.
		if(species && species.has_organ["heart"])
			var/datum/internal_organ/heart/heart = internal_organs_by_name["heart"]
			if(!heart)
				b_volume = 0
			else if(chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS)
				b_volume *= 1
			else if(heart.damage >= heart.organ_status >= ORGAN_BRUISED)
				b_volume *= clamp(100 - (2 * heart.damage), 30, 100) / 100

	//Effects of bloodloss
		if(b_volume <= BLOOD_VOLUME_SAFE)
			/// The blood volume turned into a %, with BLOOD_VOLUME_NORMAL being 100%
			var/blood_percentage = b_volume / (BLOOD_VOLUME_NORMAL / 100)
			/// How much oxyloss will there be from the next time blood processes
			var/additional_oxyloss = (100 - blood_percentage) / 5
			/// The limit of the oxyloss gained, ignoring oxyloss from the switch statement
			var/maximum_oxyloss = clamp((100 - blood_percentage) / 2, oxyloss, 100)
			if(oxyloss < maximum_oxyloss)
				oxyloss += floor(max(additional_oxyloss, 0))

		switch(b_volume)
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				if(species.flags & IS_SYNTHETIC)
					if(prob(1))
						to_chat(src, SPAN_DANGER("Subdermal damage detected in critical region. Operational impact minimal. Diagnosis queued for maintenance cycle."))
				else
					if(prob(1))
						var/word = pick("dizzy","woozy","faint")
						to_chat(src, SPAN_DANGER("You feel [word]."))
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				if(species.flags & IS_SYNTHETIC)
					if(prob(3))
						apply_effect(rand(1, 2), WEAKEN)
						to_chat(src, SPAN_DANGER("Internal power cell fault detected.\nSeek nearest recharging station."))
				else
					if(eye_blurry < 50)
						AdjustEyeBlur(6)
						oxyloss += 3
					if(prob(15))
						apply_effect(rand(1,3), PARALYZE)
						var/word = pick("dizzy","woozy","faint")
						to_chat(src, SPAN_DANGER("You feel very [word]."))
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				if(species.flags & IS_SYNTHETIC)
					if(prob(5))
						apply_effect(rand(1, 2), PARALYZE)
						to_chat(src, SPAN_DANGER("Critical power cell failure detected.\nSeek recharging station immediately."))
				else
					if(eye_blurry < 50)
						AdjustEyeBlur(6)
						oxyloss += 8
						toxloss += 3
					if(prob(15))
						apply_effect(rand(1, 3), PARALYZE)
						var/word = pick("dizzy", "woozy", "faint")
						to_chat(src, SPAN_DANGER("You feel extremely [word]."))
			if(0 to BLOOD_VOLUME_SURVIVE)
				death(create_cause_data(species.flags & IS_SYNTHETIC ? "power failure" : "blood loss"))

/datum/species/human
	group = SPECIES_HUMAN
	name = "Human"
	name_plural = "Humans"
	primitive = /mob/living/carbon/human/monkey
	unarmed_type = /datum/unarmed_attack/punch
	flags = HAS_SKIN_TONE|HAS_LIPS|HAS_UNDERWEAR|HAS_HARDCRIT|HAS_SKIN_COLOR
	mob_flags = KNOWS_TECHNOLOGY
	special_body_types = TRUE
	fire_sprite_prefix = "Standing"
	fire_sprite_sheet = 'icons/mob/humans/onmob/OnFire.dmi'

	burstscreams = list(MALE = "male_preburst", FEMALE = "female_preburst")

/datum/species/human/handle_on_fire(humanoidmob)
	. = ..()
	INVOKE_ASYNC(humanoidmob, TYPE_PROC_REF(/mob, emote), pick("pain", "scream"))

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
	weed_slowdown_mult = 0.5

/datum/species/human/hero/handle_post_spawn(mob/living/carbon/human/H)
	H.universal_understand = TRUE
	H.status_flags |= NO_PERMANENT_DAMAGE //John Wick doesn't get internal bleeding from a grazing gunshot
	H.status_flags &= ~STATUS_FLAGS_DEBILITATE
	return ..()


/datum/species/human/hero/thrall
	name = "Thrall"
	name_plural = "Thralls"
	weed_slowdown_mult = 0
	acid_blood_dodge_chance = 70

/datum/species/human/hero/thrall/handle_post_spawn(mob/living/carbon/human/thrall)
	thrall.universal_understand = FALSE
	return ..()

/datum/species/human/hero/thrall/handle_death(mob/living/carbon/human/thrall)
	GLOB.yautja_mob_list -= thrall

	message_all_yautja("[thrall.real_name] has died at \the [get_area_name(thrall)].")

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
/datum/species/human/spook/handle_unique_behavior(mob/living/carbon/human/H)
	//if(prob(25)) animation_horror_flick(H)

	//Organ damage will likely still take them down eventually.
	H.apply_damage(-3, BRUTE)
	H.apply_damage(-3, BURN)
	H.apply_damage(-15, OXY)
	H.apply_damage(-15, TOX)


/datum/species/human/spook/handle_post_spawn(mob/living/carbon/human/H)
	H.set_languages(list("Drrrrrrr"))
	return ..()

/datum/species/human/spook/handle_paygrades()
	return ""
