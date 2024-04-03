/*
	Datum-based species. Should make for much cleaner and easier to maintain mutantrace code.
*/

/datum/species
	///Used for isx(y) checking of species groups
	var/group

	var/name  // Species name.
	var/name_plural

	var/icobase = 'icons/mob/humans/species/r_human.dmi' // Normal icon set.
	var/deform = 'icons/mob/humans/species/r_def_human.dmi' // Mutated icon set.
	var/icobase_source // if we want to use sourcing system
	var/deform_source
	var/eyes = "eyes_s"   // Icon for eyes.
	var/uses_skin_color = FALSE  //Set to TRUE to load proper skin_colors and what have you
	var/special_body_types = FALSE

	var/primitive   // Lesser form, if any (ie. monkey for humans)
	var/tail    // Name of tail image in species effects icon file.
	var/datum/unarmed_attack/unarmed    // For empty hand harm-intent attack
	var/datum/unarmed_attack/secondary_unarmed // For empty hand harm-intent attack if the first fails.
	var/slowdown = 0
	var/gluttonous // Can eat some mobs. 1 for monkeys, 2 for people.
	var/rarity_value = 1  // Relative rarity/collector value for this species. Only used by ninja and cultists atm.
	var/unarmed_type =    /datum/unarmed_attack
	var/secondary_unarmed_type = /datum/unarmed_attack/bite
	var/pain_type   = /datum/pain/human
	var/stamina_type    = /datum/stamina

	var/timed_hug = TRUE

	var/list/speech_sounds // A list of sounds to potentially play when speaking.
	var/list/speech_chance
	var/has_fine_manipulation = 1 // Can use small items.
	var/can_emote = TRUE
	var/insulated  // Immune to electrocution and glass shards to the feet.

	// Some species-specific gibbing data.
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/remains_type = /obj/effect/decal/remains/xeno
	var/bloodsplatter_type = /obj/effect/temp_visual/dir_setting/bloodsplatter/human
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."

	var/breath_type = "oxygen"   // Non-oxygen gas breathed, if any.
	var/poison_type = "phoron"   // Poisonous air.
	var/exhale_type = "carbon_dioxide"   // Exhaled gas type.

	var/total_health = 100  //new maxHealth

	var/cold_level_1 = 260  // Cold damage level 1 below this point.
	var/cold_level_2 = 240  // Cold damage level 2 below this point.
	var/cold_level_3 = 120  // Cold damage level 3 below this point.

	var/heat_level_1 = 360  // Heat damage level 1 above this point.
	var/heat_level_2 = 400  // Heat damage level 2 above this point.
	var/heat_level_3 = 1000 // Heat damage level 2 above this point.

	var/body_temperature = 310.15 //non-IS_SYNTHETIC species will try to stabilize at this temperature. (also affects temperature processing)
	var/reagent_tag  //Used for metabolizing reagents.

	var/darksight = 2
	var/default_lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	var/flags_sight = 0

	var/brute_mod = null // Physical damage reduction/malus.
	var/burn_mod = null  // Burn damage reduction/malus.

	var/flags = 0    // Various specific features.

	var/list/abilities = list() // For species-derived or admin-given powers

	var/blood_color = BLOOD_COLOR_HUMAN //Red.
	var/flesh_color = "#FFC896" //Pink.
	var/base_color   //Used when setting species.
	var/hair_color   //If the species only has one hair color

	//Used in icon caching.
	var/race_key = 0
	var/icon_template = 'icons/mob/humans/template.dmi'

	// Species-specific abilities.
	var/list/inherent_verbs
	var/list/has_organ = list(
		"heart" = /datum/internal_organ/heart,
		"lungs" = /datum/internal_organ/lungs,
		"liver" = /datum/internal_organ/liver,
		"kidneys" =  /datum/internal_organ/kidneys,
		"brain" = /datum/internal_organ/brain,
		"eyes" =  /datum/internal_organ/eyes
		)

	/// Factor of reduction of  KnockDown duration.
	var/knock_down_reduction = 1
	/// Factor of reduction of Stun duration.
	var/stun_reduction = 1
	/// Factor of reduction of  KnockOut duration.
	var/knock_out_reduction = 1

	/// If different from 1, a signal is registered on post_spawn().
	var/weed_slowdown_mult = 1

	var/acid_blood_dodge_chance = 0

	var/list/slot_equipment_priority = DEFAULT_SLOT_PRIORITY
	var/list/equip_adjust = list()
	var/list/equip_overlays = list()

	var/blood_mask = 'icons/effects/blood.dmi'

	var/mob_flags = NO_FLAGS // The mob flags to give their mob
	/// Status traits to give to the mob.
	var/list/mob_inherent_traits

	var/ignores_stripdrag_flag = FALSE

	var/has_species_tab_items = FALSE

/datum/species/New()
	if(unarmed_type)
		unarmed = new unarmed_type()
	if(secondary_unarmed_type)
		secondary_unarmed = new secondary_unarmed_type()

/datum/species/proc/larva_impregnated(obj/item/alien_embryo/embryo)
	return

/// Override to add an emote panel to a species
/datum/species/proc/open_emote_panel()
	return

/datum/species/proc/handle_npc(mob/living/carbon/human/H)
	set waitfor = FALSE
	return

/datum/species/proc/create_organs(mob/living/carbon/human/H) //Handles creation of mob organs and limbs.
	//In case of pre-existing limbs/organs, we remove the old ones.
	QDEL_LIST(H.limbs)
	QDEL_LIST(H.internal_organs)
	H.internal_organs_by_name.Cut()

	//This is a basic humanoid limb setup.
	var/obj/limb/chest/C = new(H, null, H)
	H.limbs += C
	var/obj/limb/groin/G = new(H, C, H)
	H.limbs += G
	var/obj/limb/arm/l_arm/LA = new(H, C, H)
	H.limbs += LA
	H.limbs += new /obj/limb/hand/l_hand(H, LA, H)
	var/obj/limb/arm/r_arm/RA = new(H, C, H)
	H.limbs += RA
	H.limbs += new /obj/limb/hand/r_hand(H, RA, H)
	var/obj/limb/leg/l_leg/LL = new(H, G, H)
	H.limbs += LL
	H.limbs += new /obj/limb/foot/l_foot(H, LL, H)
	var/obj/limb/leg/r_leg/RL = new(H, G, H)
	H.limbs += RL
	H.limbs += new /obj/limb/foot/r_foot(H, RL, H)
	H.limbs += new /obj/limb/head(H, C, H)

	for(var/organ in has_organ)
		var/organ_type = has_organ[organ]
		H.internal_organs_by_name[organ] = new organ_type(H)

	if(flags & IS_SYNTHETIC)
		C.robotize(synth_skin = TRUE) //Also gets all other limbs, as those are attached.
		for(var/datum/internal_organ/I in H.internal_organs)
			I.mechanize()

	// We just deleted the legs so they fell down.
	// Update again now that the legs are back so they can stand properly during rest of species code and before outside updates kick in.
	// I hate this code.
	H.update_leg_status()
	// While we're deep in shitcode we also force instant transition so this nonsense isn't visually noticeable
	H.update_transform(instant_update = TRUE)

/datum/species/proc/initialize_pain(mob/living/carbon/human/H)
	if(pain_type)
		QDEL_NULL(H.pain)
		H.pain = new pain_type(H)

/datum/species/proc/initialize_stamina(mob/living/carbon/human/H)
	if(stamina_type)
		QDEL_NULL(H.stamina)
		H.stamina = new stamina_type(H)

/datum/species/proc/hug(mob/living/carbon/human/H, mob/living/carbon/target, target_zone = "chest")
	if(H.flags_emote)
		return
	var/t_him = target.p_them()

	if(target_zone == "head")
		attempt_rock_paper_scissors(H, target)
		return
	else if(target_zone in list("l_arm", "r_arm"))
		attempt_high_five(H, target)
		return
	else if(target_zone in list("l_hand", "r_hand"))
		attempt_fist_bump(H, target)
		return
	else if(H.body_position == LYING_DOWN) // Keep other interactions above lying check for maximum awkwardness potential
		H.visible_message(SPAN_NOTICE("[H] waves at [target] to make [t_him] feel better!"), \
			SPAN_NOTICE("You wave at [target] to make [t_him] feel better!"), null, 4)
	else if(target_zone == "groin")
		H.visible_message(SPAN_NOTICE("[H] hugs [target] to make [t_him] feel better!"), \
			SPAN_NOTICE("You hug [target] to make [t_him] feel better!"), null, 4)
	else
		H.visible_message(SPAN_NOTICE("[H] pats [target] on the back to make [t_him] feel better!"), \
			SPAN_NOTICE("You pat [target] on the back to make [t_him] feel better!"), null, 4)
	playsound(target, 'sound/weapons/thudswoosh.ogg', 25, 1, 5)

/datum/species/proc/attempt_rock_paper_scissors(mob/living/carbon/human/H, mob/living/carbon/human/target)
	if(!H.get_limb("r_hand") && !H.get_limb("l_hand"))
		to_chat(H, SPAN_WARNING("You have no hands!"))
		return

	if(!target.get_limb("r_hand") && !target.get_limb("l_hand"))
		to_chat(H, SPAN_WARNING("They have no hands!"))
		return

	//Responding to a raised hand
	if(target.flags_emote & EMOTING_ROCK_PAPER_SCISSORS && do_after(H, 5, INTERRUPT_MOVED, EMOTE_ICON_ROCK_PAPER_SCISSORS))
		if(!(target.flags_emote & EMOTING_ROCK_PAPER_SCISSORS)) //Additional check for if the target moved or was already high fived.
			to_chat(H, SPAN_WARNING("Too slow!"))
			return
		target.flags_emote &= ~EMOTING_ROCK_PAPER_SCISSORS
		var/static/list/game_quips = list("Rock...", "Paper...", "Scissors...", "Shoot!")
		for(var/quip in game_quips)
			if(!H.Adjacent(target))
				to_chat(list(H, target), SPAN_WARNING("You need to be standing next to each other to play!"))
				return
			to_chat(list(H, target), SPAN_NOTICE(quip))
			sleep(5)
		var/static/list/intent_to_play = list(
			"[INTENT_HELP]" = "random",
			"[INTENT_DISARM]" = "scissors",
			"[INTENT_GRAB]" = "paper",
			"[INTENT_HARM]" = "rock"
		)
		var/static/list/play_to_emote = list(
			"rock" = EMOTE_ICON_ROCK,
			"paper" = EMOTE_ICON_PAPER,
			"scissors" = EMOTE_ICON_SCISSORS
		)
		var/protagonist_plays = intent_to_play["[H.a_intent]"] == "random" ? pick("rock", "paper", "scissors") : intent_to_play["[H.a_intent]"]
		var/antagonist_plays = intent_to_play["[target.a_intent]"] == "random" ? pick("rock", "paper", "scissors") : intent_to_play["[target.a_intent]"]
		var/winner_text = " It's a draw!"
		if(protagonist_plays != antagonist_plays)
			var/static/list/what_beats_what = list("rock" = "scissors", "scissors" = "paper", "paper" = "rock")
			if(antagonist_plays == what_beats_what[protagonist_plays])
				winner_text = " [H] wins!"
			else
				winner_text = " [target] wins!"
		H.visible_message(SPAN_NOTICE("[H] plays <b>[protagonist_plays]</b>![winner_text]"), SPAN_NOTICE("You play <b>[protagonist_plays]</b>![winner_text]"), max_distance = 5)
		target.visible_message(SPAN_NOTICE("[target] plays <b>[antagonist_plays]</b>![winner_text]"), SPAN_NOTICE("You play <b>[antagonist_plays]</b>![winner_text]"), max_distance = 5)
		playsound(target, "clownstep", 35, TRUE)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(do_after), H, 8, INTERRUPT_NONE, play_to_emote[protagonist_plays])
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(do_after), target, 8, INTERRUPT_NONE, play_to_emote[antagonist_plays])
		H.animation_attack_on(target)
		target.animation_attack_on(H)
		H.start_audio_emote_cooldown(5 SECONDS)
		target.start_audio_emote_cooldown(5 SECONDS)
		return

	//Initiate high five
	if(H.recent_audio_emote)
		to_chat(H, "You just did an audible emote. Wait a while.")
		return

	H.visible_message(SPAN_NOTICE("[H] challenges [target] to a game of rock paper scissors!"), SPAN_NOTICE("You challenge [target] to a game of rock paper scissors!"), null, 4)
	H.flags_emote |= EMOTING_ROCK_PAPER_SCISSORS
	if(do_after(H, 50, INTERRUPT_ALL|INTERRUPT_EMOTE, EMOTE_ICON_ROCK_PAPER_SCISSORS) && H.flags_emote & EMOTING_ROCK_PAPER_SCISSORS)
		to_chat(H, SPAN_NOTICE("You were left hanging!"))
	H.flags_emote &= ~EMOTING_ROCK_PAPER_SCISSORS

/datum/species/proc/attempt_high_five(mob/living/carbon/human/H, mob/living/carbon/human/target)
	if(!H.get_limb("r_hand") && !H.get_limb("l_hand"))
		to_chat(H, SPAN_NOTICE("You have no hands!"))
		return

	if(!target.get_limb("r_hand") && !target.get_limb("l_hand"))
		to_chat(H, SPAN_NOTICE("They have no hands!"))
		return

	//Responding to a raised hand
	if(target.flags_emote & EMOTING_HIGH_FIVE && do_after(H, 5, INTERRUPT_MOVED, EMOTE_ICON_HIGHFIVE))
		if(!(target.flags_emote & EMOTING_HIGH_FIVE)) //Additional check for if the target moved or was already high fived.
			to_chat(H, SPAN_NOTICE("Too slow!"))
			return
		target.flags_emote &= ~EMOTING_HIGH_FIVE
		var/extra_quip = ""
		if(prob(10))
			extra_quip = pick(" Down low!", " Eiffel Tower!")
		H.visible_message(SPAN_NOTICE("[H] gives [target] a high five![extra_quip]"), \
			SPAN_NOTICE("You give [target] a high five![extra_quip]"), null, 4)
		playsound(target, 'sound/effects/snap.ogg', 25, 1)
		H.animation_attack_on(target)
		target.animation_attack_on(H)
		H.start_audio_emote_cooldown()
		target.start_audio_emote_cooldown()
		return

	//Initiate high five
	if(H.recent_audio_emote)
		to_chat(H, "You just did an audible emote. Wait a while.")
		return

	var/h_his = "their"
	switch(H.gender)
		if(MALE)
			h_his = "his"
		if(FEMALE)
			h_his = "her"

	H.visible_message(SPAN_NOTICE("[H] raises [h_his] hand out for a high five from [target]."), \
		SPAN_NOTICE("You raise your hand out for a high five from [target]."), null, 4)
	H.flags_emote |= EMOTING_HIGH_FIVE
	if(do_after(H, 50, INTERRUPT_ALL|INTERRUPT_EMOTE, EMOTE_ICON_HIGHFIVE) && H.flags_emote & EMOTING_HIGH_FIVE)
		to_chat(H, SPAN_NOTICE("You were left hanging!"))
	H.flags_emote &= ~EMOTING_HIGH_FIVE

/datum/species/proc/attempt_fist_bump(mob/living/carbon/human/H, mob/living/carbon/human/target)
	if(!H.get_limb("r_hand") && !H.get_limb("l_hand"))
		to_chat(H, SPAN_NOTICE("You have no hands!"))
		return

	if(!target.get_limb("r_hand") && !target.get_limb("l_hand"))
		to_chat(H, SPAN_NOTICE("They have no hands!"))
		return

	//Responding to a raised fist
	if(target.flags_emote & EMOTING_FIST_BUMP && do_after(H, 5, INTERRUPT_MOVED, EMOTE_ICON_FISTBUMP))
		if(!(target.flags_emote & EMOTING_FIST_BUMP)) //Additional check for if the target moved or was already fistbumped.
			to_chat(H, SPAN_NOTICE("Too slow!"))
			return
		target.flags_emote &= ~EMOTING_FIST_BUMP
		H.visible_message(SPAN_NOTICE("[H] gives [target] a fistbump!"), \
			SPAN_NOTICE("You give [target] a fistbump!"), null, 4)
		playsound(target, 'sound/effects/thud.ogg', 40, 1)
		H.animation_attack_on(target)
		target.animation_attack_on(H)
		H.start_audio_emote_cooldown()
		target.start_audio_emote_cooldown()
		return

	//Initiate fistbump
	if(H.recent_audio_emote)
		to_chat(H, "You just did an audible emote. Wait a while.")
		return
	var/h_his = "their"
	switch(H.gender)
		if(MALE)
			h_his = "his"
		if(FEMALE)
			h_his = "her"

	H.visible_message(SPAN_NOTICE("[H] raises [h_his] fist out for a fistbump from [target]."), \
		SPAN_NOTICE("You raise your fist out for a fistbump from [target]."), null, 4)
	H.flags_emote |= EMOTING_FIST_BUMP
	if(do_after(H, 50, INTERRUPT_ALL|INTERRUPT_EMOTE, EMOTE_ICON_FISTBUMP) && H.flags_emote & EMOTING_FIST_BUMP)
		to_chat(H, SPAN_NOTICE("You were left hanging!"))
	H.flags_emote &= ~EMOTING_FIST_BUMP

//things to change after we're no longer that species
/datum/species/proc/post_species_loss(mob/living/carbon/human/H)
	for(var/T in mob_inherent_traits)
		REMOVE_TRAIT(src, T, TRAIT_SOURCE_SPECIES)

/datum/species/proc/remove_inherent_verbs(mob/living/carbon/human/H)
	if(inherent_verbs)
		remove_verb(H, inherent_verbs)

/datum/species/proc/add_inherent_verbs(mob/living/carbon/human/H)
	if(inherent_verbs)
		add_verb(H, inherent_verbs)

/datum/species/proc/handle_post_spawn(mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	add_inherent_verbs(H)
	apply_signals(H)

/// Apply signals to the human
/datum/species/proc/apply_signals(mob/living/carbon/human/H)
	return

/datum/species/proc/handle_death(mob/living/carbon/human/H) //Handles any species-specific death events.
/*
	if(flags & IS_SYNTHETIC)
		H.h_style = ""
		spawn(100)
			if(!H) return
			H.update_hair()
	return
*/

/datum/species/proc/handle_dead_death(mob/living/carbon/human/H, gibbed)

/datum/species/proc/handle_cryo(mob/living/carbon/human/H)

/datum/species/proc/get_offset_overlay_image(spritesheet, mob_icon, mob_state, color, slot)
	// If we don't actually need to offset this, don't bother with any of the generation/caching.
	if(!spritesheet && equip_adjust.len && equip_adjust[slot] && LAZYLEN(equip_adjust[slot]))

		// Check the cache for previously made icons.
		var/image_key = "[mob_icon]-[mob_state]-[color]"
		if(!equip_overlays[image_key])

			var/icon/final_I = new(icon_template)
			var/list/shifts = equip_adjust[slot]

			// Apply all pixel shifts for each direction.
			for(var/shift_facing in shifts)
				var/list/facing_list = shifts[shift_facing]
				var/use_dir = text2num(shift_facing)
				var/icon/equip = new(mob_icon, icon_state = mob_state, dir = use_dir)
				var/icon/canvas = new(icon_template)
				canvas.Blend(equip, ICON_OVERLAY, facing_list["x"]+1, facing_list["y"]+1)
				final_I.Insert(canvas, dir = use_dir)
			equip_overlays[image_key] = overlay_image(final_I, color = color, flags = RESET_COLOR)
		return equip_overlays[image_key]
	return overlay_image(mob_icon, mob_state, color, RESET_COLOR)

//Only used by horrors at the moment. Only triggers if the mob is alive and not dead.
/datum/species/proc/handle_unique_behavior(mob/living/carbon/human/H)
	return

// Used to update alien icons for aliens.
/datum/species/proc/handle_login_special(mob/living/carbon/human/H)
	return

// As above.
/datum/species/proc/handle_logout_special(mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/datum/species/proc/build_hud(mob/living/carbon/human/H)
	return

// Grabs the window received when you click-drag someone onto you.
/datum/species/proc/get_inventory_dialogue(mob/living/carbon/human/H)
	return

//Used by xenos understanding larvae and dionaea understanding nymphs.
/datum/species/proc/can_understand(mob/other)
	return

/datum/species/proc/get_bodytype(mob/living/carbon/human/H)
	return name

/datum/species/proc/get_tail(mob/living/carbon/human/H)
	return tail

// Called when using the shredding behavior.
/datum/species/proc/can_shred(mob/living/carbon/human/H)

	if(H.a_intent != INTENT_HARM)
		return 0

	if(unarmed.is_usable(H))
		if(unarmed.shredding)
			return 1
	else if(secondary_unarmed.is_usable(H))
		if(secondary_unarmed.shredding)
			return 1

	return 0

/datum/species/proc/get_hairstyle(style)
	return GLOB.hair_styles_list[style]

// Used for checking on how each species would scream when they are burning
/datum/species/proc/handle_on_fire(humanoidmob)
	// call this for each species so each has their own unique scream options when burning alive
	// heebie-jebies made me do all this effort, I HATE YOU
	return

/datum/species/proc/handle_blood_splatter(mob/living/carbon/human/human, splatter_dir)
	var/color_override
	if(human.special_blood)
		var/datum/reagent/D = GLOB.chemical_reagents_list[human.special_blood]
		if(D)
			color_override = D.color

	var/obj/effect/temp_visual/dir_setting/bloodsplatter/bloodsplatter = new bloodsplatter_type(human.loc, splatter_dir, 5, color_override)
	return bloodsplatter

/datum/species/proc/get_status_tab_items()
	return list()

/datum/species/proc/handle_head_loss(mob/living/carbon/human/human)
	return

/datum/species/proc/handle_paygrades(paygrade, size, gender)
	return get_paygrades(paygrade, size, gender)
