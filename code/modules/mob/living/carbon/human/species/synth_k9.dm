//woof!
/datum/species/synthetic/synth_k9
	name = SPECIES_SYNTHETIC_K9
	uses_ethnicity = FALSE

	//Scent tracking
	var/datum/radar/scenttracker/radar
	var/faction = FACTION_MARINE

	slowdown = -1.75 //Faster than Human run, slower than rooney run

	icobase = 'icons/mob/humans/species/synth_k9/r_k9.dmi'
	deform = 'icons/mob/humans/species/synth_k9/r_k9.dmi'
	eyes = "blank_eyes_s"
	blood_mask = 'icons/mob/humans/species/synth_k9/r_k9.dmi'
	unarmed_type = /datum/unarmed_attack/bite/synthetic
	secondary_unarmed_type = /datum/unarmed_attack
	death_message = "lets out a faint whimper as it collapses and stops moving..."

	flags = IS_WHITELISTED|NO_BREATHE|NO_CLONE_LOSS|NO_BLOOD|NO_POISON|IS_SYNTHETIC|NO_CHEM_METABOLIZATION|NO_NEURO|NO_OVERLAYS

	inherent_verbs = list(
		/mob/living/carbon/human/synthetic/proc/toggle_HUD,
		/mob/living/carbon/human/proc/toggle_inherent_nightvison,
		/mob/living/carbon/human/synthetic/synth_k9/proc/toggle_scent_tracking,
		/mob/living/carbon/human/synthetic/synth_k9/proc/toggle_binocular_vision,
	)

//Lets have a place for radar data to live
/datum/species/synthetic/synth_k9/handle_post_spawn(mob/living/carbon/human/spawned_k9)
	. = ..()
	radar = new /datum/radar/scenttracker(spawned_k9, faction)

/datum/emote/living/carbon/human/synthetic/synth_k9/New()  //K9's are blacklisted from human emotes on emote.dm, we need to not block the new emotes below
	species_type_blacklist_typecache -= /datum/species/synthetic/synth_k9
	. = ..()

//Synth K9 Emotes
/datum/emote/living/carbon/human/synthetic/synth_k9
	species_type_allowed_typecache = list(/datum/species/synthetic/synth_k9)
	keybind_category = CATEGORY_SYNTH_EMOTE
	volume = 75

//Standard Bark
/datum/emote/living/carbon/human/synthetic/synth_k9/bark
	key = "bark"
	key_third_person = "barks"
	message = "barks."
	audio_cooldown = 3 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/synth_k9/bark/get_sound(mob/living/user)
	return pick('sound/voice/barkstrong1.ogg','sound/voice/barkstrong2.ogg','sound/voice/barkstrong3.ogg')

//Threatening Growl
/datum/emote/living/carbon/human/synthetic/synth_k9/growl
	key = "growl"
	key_third_person = "growls"
	message = "growls."
	audio_cooldown = 3 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/synth_k9/growl/get_sound(mob/living/user)
	return pick('sound/voice/growl1.ogg','sound/voice/growl2.ogg','sound/voice/growl3.ogg','sound/voice/growl4.ogg')
