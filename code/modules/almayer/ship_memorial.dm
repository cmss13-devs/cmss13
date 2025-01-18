/**
 * Ship Memorial
 *
 * Lists all dead marines whose dog tags were recovered.
 * Allows personnel, while alone, to inspect the memorial and see ghosts of the fallen.
 * Squad marines have the ability to have a final goodbye with their squad if enough dog tags were collected.
 */

#define COOLDOWN_SLAB_CHECK "cooldown_slab_check"
#define FLASHBACK_DEFAULT "flashback_default"
#define FLASHBACK_SQUAD "flashback_squad"
#define REQUIRED_DEAD_SQUADDIES 4

/obj/structure/prop/almayer/ship_memorial
	name = "slab of victory"
	desc = "A ship memorial dedicated to the triumphs of the USCM and the fallen marines of this ship. On the left there are grand tales of victory etched into the slab. On the right there is a list of famous marines who have fallen in combat serving the USCM."
	icon = 'icons/obj/structures/props/almayer/almayer_props64.dmi'
	icon_state = "ship_memorial"
	bound_width = 64
	bound_height = 32
	unslashable = TRUE
	unacidable = TRUE
	//Sound files that play when a hallucination pops up.
	///Voicelines for male ghosts.
	var/list/hallucination_sounds = list('sound/hallucinations/ghost_whisper_01.ogg',
		'sound/hallucinations/ghost_whisper_02.ogg',
		'sound/hallucinations/ghost_whisper_03.ogg',
		'sound/hallucinations/ghost_whisper_04.ogg',
		'sound/hallucinations/ghost_whisper_05.ogg',
		'sound/hallucinations/ghost_whisper_06.ogg',
		'sound/hallucinations/ghost_whisper_07.ogg',
		'sound/hallucinations/ghost_whisper_08.ogg',
		'sound/hallucinations/ghost_whisper_09.ogg',
		'sound/hallucinations/ghost_whisper_10.ogg',
		'sound/hallucinations/ghost_whisper_11.ogg',
		'sound/hallucinations/ghost_whisper_12.ogg',
		'sound/hallucinations/ghost_whisper_13.ogg'
		)
	///Voicelines for female ghosts.
	var/list/hallucination_sounds_female = list('sound/hallucinations/ghost_whisper_female_01.ogg',
		'sound/hallucinations/ghost_whisper_female_02.ogg',
		'sound/hallucinations/ghost_whisper_female_03.ogg',
		'sound/hallucinations/ghost_whisper_female_04.ogg',
		'sound/hallucinations/ghost_whisper_female_05.ogg',
		'sound/hallucinations/ghost_whisper_female_06.ogg',
		'sound/hallucinations/ghost_whisper_female_07.ogg',
		'sound/hallucinations/ghost_whisper_female_08.ogg',
		'sound/hallucinations/ghost_whisper_female_09.ogg',
		'sound/hallucinations/ghost_whisper_female_10.ogg',
		'sound/hallucinations/ghost_whisper_female_11.ogg',
		'sound/hallucinations/ghost_whisper_female_12.ogg',
		'sound/hallucinations/ghost_whisper_female_13.ogg',
		'sound/hallucinations/ghost_whisper_female_14.ogg',
		'sound/hallucinations/ghost_whisper_female_15.ogg'
		)
	///All mobs that went through a squad flashback.
	var/list/went_through_flashback = list()
	///Weakrefs of mobs of the dogtags that are placed on the slab.
	var/list/datum/weakref/fallen_personnel = list()

/obj/structure/prop/almayer/ship_memorial/centcomm
	name = "slab of remembrance"
	desc = "A memorial to all Maintainer Team members that have retired from working on CM. No mentor names are present."

/obj/structure/prop/almayer/ship_memorial/centcomm/admin
	desc = "A memorial to all Admins and Moderators who have retired from CM. No mentor names are present."

/obj/structure/prop/almayer/ship_memorial/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/dogtag))
		var/obj/item/dogtag/attacking_dogtag = attacking_item
		if(attacking_dogtag.fallen_names)
			to_chat(user, SPAN_NOTICE("You add [attacking_dogtag] to [src]."))
			GLOB.fallen_list += attacking_dogtag.fallen_names
			fallen_personnel += attacking_dogtag.fallen_references
			qdel(attacking_dogtag)
		return TRUE

	return ..()

/obj/structure/prop/almayer/ship_memorial/get_examine_text(mob/user)
	. = ..()
	if((isobserver(user) || ishuman(user)) && length(GLOB.fallen_list))
		var/faltext = ""
		for(var/i = 1 to length(GLOB.fallen_list))
			if(i != length(GLOB.fallen_list))
				faltext += "[GLOB.fallen_list[i]], "
			else
				faltext += GLOB.fallen_list[i]
		. += SPAN_NOTICE("To our fallen soldiers: <b>[faltext]</b>.")

/obj/structure/prop/almayer/ship_memorial/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(user.action_busy)
		return ..()

	if(user in went_through_flashback)
		to_chat(user, SPAN_NOTICE("It's all in the past now. You need to keep looking forward. It's what they would have wanted."))
		return ..()

	if(TIMER_COOLDOWN_CHECK(user, COOLDOWN_SLAB_CHECK))
		to_chat(user, SPAN_DANGER("You can't bring yourself to look at this right now."))
		return ..()

	///References of all fallen personnel whose mobs still exist.
	var/list/fallen_personnel_resolved = list()
	resolve_refs(fallen_personnel_resolved)

	if(!length(fallen_personnel) || !length(fallen_personnel_resolved) || user.faction != FACTION_MARINE)
		to_chat(user, SPAN_NOTICE("You start looking through the names on the slab but nothing catches your attention."))
		return ..()

	fallen_personnel_resolved = shuffle(fallen_personnel_resolved)

	to_chat(user, SPAN_NOTICE("You start looking through the names on the slab..."))
	///Text that's prefixed everytime a name is listed.
	var/list/inspection_text = list("A name catches your eyes,",
		"You know this name,",
		"This one...",
		"You recognize this name,",
		"You take a deep breath and see",
		"You remember them.",
		"Your attention is drawn to this name,",
		"You read the name on the slab,")

	var/list/voicelines = hallucination_sounds.Copy()
	var/list/voicelines_female = hallucination_sounds_female.Copy()

	///Did a flashback event trigger?
	var/had_flashback = FALSE
	for(var/i in 1 to clamp(length(fallen_personnel_resolved), 1, 8))
		if(!do_after(user, 4 SECONDS, INTERRUPT_ALL_OUT_OF_RANGE))
			if(had_flashback)
				cancel_flashback(user, null, FLASHBACK_DEFAULT)
				return ..()

			cancel_flashback(user)
			return ..()

		///Is someone else within a set range of the mob interacting with the slab?
		var/interrupted_by_mob = FALSE
		for(var/mob/living/mob in view(src, 6))
			if(mob != user && mob.stat == CONSCIOUS)
				interrupted_by_mob = TRUE

		var/mob/living/carbon/human/person = fallen_personnel_resolved[i]

		//There is a chance for special flashback events to trigger, and a guaranteed one for squad marines
		//if they recover enough dogtags from their squad.
		if(!interrupted_by_mob && !had_flashback)
			var/flashback_type
			//If the user is part of a squad, check the memorial for dogtags belonging to their squad.
			//If there are enough (equal or greater than REQUIRED_DEAD_SQUADDIES), trigger a special flashback sequence.
			if(user.assigned_squad)
				///Every squad member of the user that is listed on the memorial.
				var/list/squad_members = list()
				for(var/mob/living/carbon/human/squad_member in fallen_personnel_resolved)
					if(squad_member.assigned_squad == user.assigned_squad)
						squad_members += squad_member

				if(length(squad_members) >= REQUIRED_DEAD_SQUADDIES)
					flashback_type = FLASHBACK_SQUAD
					INVOKE_ASYNC(src, PROC_REF(flashback_trigger), user, flashback_type, squad_members)
					return

			if(prob(i*2) && length(fallen_personnel_resolved) >= 5)
				had_flashback = TRUE
				flashback_type = FLASHBACK_DEFAULT
				INVOKE_ASYNC(src, PROC_REF(flashback_trigger), user, flashback_type, fallen_personnel_resolved)

		//If we somehow lose a mob reference, we need to account for it.
		if(!person)
			to_chat(user, SPAN_NOTICE("You can't bring yourself to read this name... you press on."))
			continue

		to_chat(user, SPAN_NOTICE("[pick_n_take(inspection_text)] <b>[person]</b>, [GET_DEFAULT_ROLE(person.job)]."))

		if(interrupted_by_mob || !user.client)
			continue

		///The ghost that is generated this iteration.
		var/obj/effect/client_image_holder/memorial_ghost/ghost = generate_ghost(person, user)
		if(!ghost)
			continue

		///Gender of the generated ghost.
		var/ghost_gender = person.get_gender()
		if(ghost_gender == FEMALE)
			playsound_client(user.client, pick_n_take(voicelines_female), ghost.loc, 55)
		else
			playsound_client(user.client, pick_n_take(voicelines), ghost.loc, 100)

		//Faulty generation can cause the ghost to get qdel'd before this proc runs.
		if(!QDELETED(ghost))
			addtimer(CALLBACK(ghost, TYPE_PROC_REF(/obj/effect/client_image_holder/memorial_ghost, disappear)), rand(1.5 SECONDS, 1.9 SECONDS))

	if(had_flashback)
		TIMER_COOLDOWN_START(user, COOLDOWN_SLAB_CHECK, 60 SECONDS)

	///A sentence that's displayed at the end of the slab interaction.
	var/list/realization_text = list("Those people were your family.",
		"You'll never forget. Even if it hurts to remember.",
		"They're gone. And you'll never see them again.",
		"You say your goodbyes silently.",
		"Nothing good lasts forever.")
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), user, SPAN_NOTICE("<b>[pick(realization_text)]</b>")), 1 SECONDS)

///Proc for resolving weakrefs from fallen_personnel.
/obj/structure/prop/almayer/ship_memorial/proc/resolve_refs(list/list_to_add)
	for(var/i in 1 to length(fallen_personnel))
		var/resolved_mob = fallen_personnel[i].resolve()
		if(resolved_mob)
			list_to_add += resolved_mob
		else
			//weakref didn't get resolved, bad reference. remove it from the list.
			fallen_personnel -= fallen_personnel[i]

///Proc for canceling memorial interaction. Used when interrupted by a mob or when the do_after() is cancelled.
/obj/structure/prop/almayer/ship_memorial/proc/cancel_flashback(mob/user, list/ghosts, flashback_type)
	switch(flashback_type)
		if(FLASHBACK_DEFAULT)
			to_chat(user, SPAN_DANGER("<b>You turn away from the slab. You turn away from them all...</b>"))
			TIMER_COOLDOWN_START(user, COOLDOWN_SLAB_CHECK, 25 SECONDS)
		if(FLASHBACK_SQUAD)
			to_chat(user, SPAN_DANGER("<b>You turn your back on your squad. You just can't. Not now.</b>"))
			TIMER_COOLDOWN_START(user, COOLDOWN_SLAB_CHECK, 10 SECONDS)
		else
			to_chat(user, SPAN_NOTICE("...maybe it's better to forget."))

	if(length(ghosts))
		for(var/obj/effect/client_image_holder/memorial_ghost/ghost in ghosts)
			ghost.disappear()

///Proc for generating a ghost image of a mob.
/obj/structure/prop/almayer/ship_memorial/proc/generate_ghost(person, mob/living/user, range = 3)
	if(!person)
		return

	///All acceptable turfs where the ghost could spawn.
	var/list/ghost_turf = list()
	for(var/turf/turf in range(user.loc, range))
		var/bad_turf = FALSE
		if(turf.density || istype(turf, /turf/open/space))
			continue

		if(!(user in view(3, turf)))
			continue

		for(var/obj/object in turf)
			if(object.density || istype(object, /obj/effect/client_image_holder/memorial_ghost))
				bad_turf = TRUE
				break

		for(var/mob/mob in turf)
			bad_turf = TRUE
			break

		if(bad_turf)
			continue

		ghost_turf += turf

	if(!length(ghost_turf))
		return

	var/turf/spawn_loc = pick(ghost_turf)
	var/dir_to_face = get_dir(spawn_loc, user.loc)
	var/obj/effect/client_image_holder/memorial_ghost/ghost = new(spawn_loc, user, person, dir_to_face)

	return ghost

///Proc that handles special flashback events.
/obj/structure/prop/almayer/ship_memorial/proc/flashback_trigger(mob/living/carbon/human/user, flashback_type = FLASHBACK_DEFAULT, list/mob_references)
	playsound_client(user.client, 'sound/hallucinations/ears_ringing.ogg', user.loc, 40)
	to_chat(user, SPAN_DANGER("<b>It's like time has stopped. All you can focus on are the names on that list.</b>"))
	user.apply_effect(6, ROOT)
	user.apply_effect(6, STUTTER)

	sleep(1 SECONDS)

	///Every ghost that was generated in the flashback event.
	var/list/image/all_ghosts = list()

	switch(flashback_type)
		//Default flashback. Spawns ghost images of every (max 16) name listed on the memorial.
		if(FLASHBACK_DEFAULT)
			var/list/references_copy = mob_references.Copy()
			for(var/i = clamp(length(references_copy), 1, 16), i > 0, i--)
				if(!do_after(user, 0.1 SECONDS, INTERRUPT_ALL_OUT_OF_RANGE))
					cancel_flashback(user, all_ghosts, FLASHBACK_DEFAULT)
					return

				for(var/times_to_generate = rand(1, 2), times_to_generate > 0, times_to_generate--)
					all_ghosts += generate_ghost(pick_n_take(references_copy), user, 4)

			for(var/obj/effect/client_image_holder/memorial_ghost/ghost in all_ghosts)
				ghost.disappear()

		//Special flashback reserved for squad marines that is guaranteed to trigger if there are REQUIRED_DEAD_SQUADDIES amount
		//of squad dogtags on the memorial. Only counts the squad members from which the user is a part of.
		//Spawns ghost images of all (max 12) dead squad members listed on the memorial.
		//On completion, the user can no longer interact with the slab. A final goodbye.
		if(FLASHBACK_SQUAD)
			var/list/inspection_text = list("Could you have saved them? You sigh and continue reading.",
			"Thinking someone is behind you, you turn around. Nothing. You look back at the names.",
			"You're not alone. You're sure of it. The next name reads",
			"Deep down, you knew it would come to this. You set your eyes back on the slab.",
			"You always thought it'd be you on that slab. Guess not.",
			"You wish you could have taken their place. You keep reading.",
			"It goes dark for a moment. Then you see",
			"This is what duty gets you. A name on a plaque. The following name reads",
			"You had fond memories with these people.",
			"It's a lot to take in. They're gone, and you'll never see them again.",
			"Every name you read feels like a dead family member to remember.",
			"It's almost as if they were still here. Alive. You keep reading,"
			)

			inspection_text = shuffle(inspection_text)

			var/list/voicelines = hallucination_sounds.Copy()
			var/list/voicelines_female = hallucination_sounds_female.Copy()
			for(var/i = clamp(length(mob_references), 1, 12), i > 0, i--)
				if(!do_after(user, 4 SECONDS, INTERRUPT_ALL_OUT_OF_RANGE))
					cancel_flashback(user, all_ghosts, FLASHBACK_SQUAD)
					return

				for(var/mob/living/mob in view(src, 6))
					if(mob != user && mob.stat == CONSCIOUS)
						cancel_flashback(user, all_ghosts, FLASHBACK_SQUAD)
						return

				var/mob/living/carbon/human/picked_member = pick_n_take(mob_references)
				var/obj/effect/client_image_holder/memorial_ghost/generated_ghost = generate_ghost(picked_member, user, 2)
				all_ghosts += generated_ghost

				var/ghost_gender = picked_member.get_gender()
				if(ghost_gender == FEMALE)
					playsound_client(user.client, pick_n_take(voicelines_female), generated_ghost.loc, 55)
				else
					playsound_client(user.client, pick_n_take(voicelines), generated_ghost.loc, 100)

				to_chat(user, SPAN_DANGER("[pick_n_take(inspection_text)] <b>[picked_member]</b>, [GET_DEFAULT_ROLE(picked_member.job)]."))
				sleep(rand(0.5 SECONDS, 0.7 SECONDS))

			went_through_flashback += user
			sleep(5 SECONDS)

			for(var/obj/effect/client_image_holder/memorial_ghost/ghost in all_ghosts)
				ghost.disappear()

			///Name of the user, split so we can retrieve their first name.
			var/list/split_name = splittext(user.name, " ")
			to_chat(user, SPAN_NOTICE("<b>You hear someone whisper 'Thank you, [split_name[1]]. Goodbye.' into your ear.</b>"))
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), user, SPAN_NOTICE("<b>It feels final. Maybe it's time to look forward now.</b>")), 3 SECONDS)

#undef COOLDOWN_SLAB_CHECK
#undef FLASHBACK_DEFAULT
#undef FLASHBACK_SQUAD
#undef REQUIRED_DEAD_SQUADDIES

/obj/effect/client_image_holder/memorial_ghost
	desc = "May we never forget freedom isn't free."
	var/mob/living/mob_reference

/obj/effect/client_image_holder/memorial_ghost/proc/disappear()
	var/time_to_disappear = rand(0.4 SECONDS, 0.8 SECONDS)
	animate(shown_image, alpha = 0, QUAD_EASING, time = time_to_disappear)
	QDEL_IN(src, time_to_disappear)

/obj/effect/client_image_holder/memorial_ghost/Initialize(mapload, list/mobs_which_see_us, mob/living/reference = null, direction_to_face)
	mob_reference = reference
	if(!mob_reference)
		return INITIALIZE_HINT_QDEL

	dir = direction_to_face
	name = mob_reference.name
	return ..()

/obj/effect/client_image_holder/memorial_ghost/generate_image()
	var/image/created = image(null, src, null, image_layer, src.dir, image_pixel_x, image_pixel_y)
	created.appearance = mob_reference.appearance
	created.transform = matrix(mob_reference.base_transform)
	created.alpha = 0
	if(image_color)
		created.color = image_color
	animate(created, alpha = 120, QUAD_EASING, time = rand(0.3 SECONDS, 0.5 SECONDS))
	return created
