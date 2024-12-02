//woof!
/datum/species/synthetic/synth_k9
	name = SPECIES_SYNTHETIC_K9

	slowdown = -1.75 //Faster than Human run, slower than rooney run

	icobase = 'icons/mob/humans/species/synth_k9/r_k9.dmi'
	deform = 'icons/mob/humans/species/synth_k9/r_k9.dmi'
	eyes = "blank_eyes_s"
	blood_mask = 'icons/mob/humans/species/synth_k9/r_k9.dmi'
	unarmed_type = /datum/unarmed_attack/bite/synthetic
	secondary_unarmed_type = /datum/unarmed_attack
	death_message = "lets out a faint whimper as it collapses and stops moving..."
	flags = IS_WHITELISTED|NO_BREATHE|NO_CLONE_LOSS|NO_BLOOD|NO_POISON|IS_SYNTHETIC|NO_CHEM_METABOLIZATION|NO_NEURO|NO_OVERLAYS

	mob_inherent_traits = list(TRAIT_SUPER_STRONG, TRAIT_IRON_TEETH, TRAIT_EMOTE_CD_EXEMPT)

	fire_sprite_prefix = "k9"
	fire_sprite_sheet = 'icons/mob/humans/onmob/OnFire.dmi'

	inherent_verbs = list(
		/mob/living/carbon/human/synthetic/proc/toggle_HUD,
		/mob/living/carbon/human/proc/toggle_inherent_nightvison,
		/mob/living/carbon/human/synthetic/synth_k9/proc/toggle_scent_tracking,
		/mob/living/carbon/human/synthetic/synth_k9/proc/toggle_binocular_vision,
	)

	//Scent tracking
	var/datum/radar/scenttracker/radar
	var/faction = FACTION_MARINE

//Lets have a place for radar data to live
/datum/species/synthetic/synth_k9/handle_post_spawn(mob/living/carbon/human/spawned_k9)
	. = ..()
	radar = new /datum/radar/scenttracker(spawned_k9, faction)

/datum/species/synthetic/synth_k9/Destroy()
	. = ..()
	qdel(radar)
	faction = null
