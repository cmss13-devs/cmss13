/**
 * Ship Memorial
 *
 * Lists all dead marines whose dog tags were recovered.
 * Allows personnel, while alone, to inspect the memorial and see ghosts of the fallen.
 * Squad marines have the ability to have a final goodbye with their squad if enough dog tags were collected.
 */

/obj/structure/prop/almayer/ship_memorial
	name = "slab of victory"
	desc = "A ship memorial dedicated to the triumphs of the USCM and the fallen marines of this ship. On the left there are grand tales of victory etched into the slab. On the right there is a list of famous marines who have fallen in combat serving the USCM."
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
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
	///All mobs that are on a temporary cooldown from using the slab again.
	var/list/users_on_cooldown = list()
	///Mob references to the owners of the dogtags that are placed on the slab.
	var/list/fallen_personnel = list()

/obj/structure/prop/almayer/ship_memorial/centcomm
	name = "slab of remembrance"
	desc = "A memorial to all Maintainer Team members that have retired from working on CM. No mentor names are present."

/obj/structure/prop/almayer/ship_memorial/centcomm/admin
	desc = "A memorial to all Admins and Moderators who have retired from CM. No mentor names are present."

/obj/structure/prop/almayer/ship_memorial/Destroy()
	QDEL_NULL_LIST(went_through_flashback)
	QDEL_NULL_LIST(users_on_cooldown)
	QDEL_NULL_LIST(fallen_personnel)
	return ..()

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

#define FLASHBACK_DEFAULT 1
#define FLASHBACK_SQUAD 2
#define REQUIRED_DEAD_SQUADDIES 4

/obj/structure/prop/almayer/ship_memorial/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(user.action_busy)
		return ..()

	if(user in went_through_flashback)
		to_chat(user, SPAN_NOTICE("It's all in the past now. You need to keep looking forward. It's what they would have wanted."))
		return ..()

	if(user in users_on_cooldown)
		to_chat(user, SPAN_DANGER("You can't bring yourself to look at this right now."))
		return ..()

	if(!length(fallen_personnel) || user.faction != FACTION_MARINE)
		to_chat(user, SPAN_NOTICE("You start looking through the names on the slab but nothing catches your attention."))
		return ..()

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

	fallen_personnel = shuffle(fallen_personnel)

	var/list/voicelines = hallucination_sounds.Copy()
	var/list/voicelines_female = hallucination_sounds_female.Copy()
	///Did a flashback event trigger?
	var/had_flashback = FALSE
	for(var/i = 1 in 1 to clamp(length(fallen_personnel), 1, 8))
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

		var/mob/living/carbon/human/person = fallen_personnel[i]

		//There is a chance for special flashback events to trigger, and a guaranteed one for squad marines
		//if they recover enough dogtags from their squad.
		if(!interrupted_by_mob && !had_flashback)
			var/flashback_type = TRUE
			//If the user is part of a squad, check the memorial for dogtags belonging to their squad.
			//If there are enough (equal or greater than REQUIRED_DEAD_SQUADDIES), trigger a special flashback sequence.
			if(user.assigned_squad)
				///Every squad member of the user that is listed on the memorial.
				var/list/squad_members = list()
				for(var/mob/living/carbon/human/squad_member in fallen_personnel)
					if(squad_member.assigned_squad == user.assigned_squad)
						squad_members += squad_member

				if(length(squad_members) >= REQUIRED_DEAD_SQUADDIES)
					flashback_type = FLASHBACK_SQUAD
					INVOKE_ASYNC(src, PROC_REF(flashback_trigger), user, flashback_type, squad_members)
					return

			if(prob(i*2) && length(fallen_personnel) >= 5)
				had_flashback = TRUE
				INVOKE_ASYNC(src, PROC_REF(flashback_trigger), user, flashback_type)

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
		add_to_cooldown(user, 60 SECONDS)

	///A sentence that's displayed at the end of the slab interaction.
	var/list/realization_text = list("Those people were your family.",
		"You'll never forget. Even if it hurts to remember.",
		"They're gone. And you'll never see them again.",
		"You say your goodbyes silently.",
		"Nothing good lasts forever.")
	to_chat(user, SPAN_NOTICE("<b>[pick(realization_text)]</b>"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), user, SPAN_NOTICE("<b>[pick(realization_text)]</b>"))

///Proc for adding mobs to the users_on_cooldown list.
/obj/structure/prop/almayer/ship_memorial/proc/add_to_cooldown(mob/user, length)
	users_on_cooldown.Add(user)
	addtimer(CALLBACK(src, PROC_REF(remove_from_cooldown), user), length)

///Proc for removing mobs from the users_on_cooldown list.
/obj/structure/prop/almayer/ship_memorial/proc/remove_from_cooldown(mob/user)
	users_on_cooldown.Remove(user)

///Proc for canceling memorial interaction. Used when interrupted by a mob or when the do_after() is cancelled.
/obj/structure/prop/almayer/ship_memorial/proc/cancel_flashback(mob/user, list/ghosts, flashback_type)
	switch(flashback_type)
		if(FLASHBACK_DEFAULT)
			to_chat(user, SPAN_DANGER("<b>You turn away from the slab. You turn away from them all...</b>"))
			add_to_cooldown(user, 25 SECONDS)
		if(FLASHBACK_SQUAD)
			to_chat(user, SPAN_DANGER("<b>You turn your back on your squad. You just can't. Not now.</b>"))
			add_to_cooldown(user, 10 SECONDS)
		else
			to_chat(user, SPAN_NOTICE("...maybe it's better to forget."))

	if(length(ghosts))
		for(var/obj/effect/client_image_holder/memorial_ghost/ghost in ghosts)
			ghost.disappear()

///Proc for generating a ghost image of a mob.
/obj/structure/prop/almayer/ship_memorial/proc/generate_ghost(person, mob/living/user, range = 3)
	if(!person)
		return

	var/obj/effect/client_image_holder/memorial_ghost/ghost = new(user, user, person)

	///All acceptable turfs where the ghost could spawn.
	var/list/ghost_turf = list()
	for(var/turf/turf in range(user.loc, range))
		var/bad_turf = FALSE
		if(turf.density || istype(turf, /turf/open/space))
			continue

		if(!(user in view(3, turf)))
			continue

		for(var/obj/object in turf)
			if(object.density || (object != ghost && istype(object, /obj/effect/client_image_holder/memorial_ghost)))
				bad_turf = TRUE
				break

		for(var/mob/mob in turf)
			bad_turf = TRUE
			break

		if(bad_turf)
			continue

		ghost_turf += turf

	if(!length(ghost_turf))
		qdel(ghost)
		return

	ghost.loc = pick(ghost_turf)
	ghost.dir = get_dir(ghost.loc, user.loc)

	return ghost

///Proc that handles special flashback events.
/obj/structure/prop/almayer/ship_memorial/proc/flashback_trigger(mob/living/carbon/human/user, flashback_type = FLASHBACK_DEFAULT, list/squad_members)
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
			var/list/personnel_copy = fallen_personnel.Copy()
			for(var/i = clamp(length(fallen_personnel), 1, 16), i > 0, i--)
				if(!do_after(user, 0.1 SECONDS, INTERRUPT_ALL_OUT_OF_RANGE))
					cancel_flashback(user, all_ghosts, FLASHBACK_DEFAULT)
					return

				for(var/times_to_generate = rand(1, 2), times_to_generate > 0, times_to_generate--)
					all_ghosts += generate_ghost(pick_n_take(personnel_copy), user, 4)

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
			for(var/i = clamp(length(squad_members), 1, 12), i > 0, i--)
				if(!do_after(user, 4 SECONDS, INTERRUPT_ALL_OUT_OF_RANGE))
					cancel_flashback(user, all_ghosts, FLASHBACK_SQUAD)
					return

				for(var/mob/living/mob in view(src, 6))
					if(mob != user && mob.stat == CONSCIOUS)
						cancel_flashback(user, all_ghosts, FLASHBACK_SQUAD)
						return

				var/mob/living/carbon/human/picked_member = pick_n_take(squad_members)
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
			sleep(4 SECONDS)
			to_chat(user, SPAN_NOTICE("<b>It feels final. Maybe it's time to look forward now.</b>"))

#undef FLASHBACK_DEFAULT
#undef FLASHBACK_SQUAD
#undef REQUIRED_DEAD_SQUADDIES

/obj/effect/client_image_holder/memorial_ghost
	var/mob/living/mob_reference

/obj/effect/client_image_holder/memorial_ghost/proc/disappear()
	var/time_to_disappear = rand(0.4 SECONDS, 0.8 SECONDS)
	animate(shown_image, alpha = 0, QUAD_EASING, time = time_to_disappear)
	sleep(time_to_disappear)
	qdel(src)

/obj/effect/client_image_holder/memorial_ghost/Initialize(mapload, list/mobs_which_see_us, mob/living/reference = null)
	mob_reference = reference
	if(!mob_reference)
		return INITIALIZE_HINT_QDEL

	. = ..()
	name = mob_reference.name
	desc = "May we never forget freedom isn't free."

/obj/effect/client_image_holder/memorial_ghost/Destroy(force)
	QDEL_NULL(mob_reference)
	return ..()

/obj/effect/client_image_holder/memorial_ghost/generate_image()
	var/image/created = image(null, src, null, image_layer, dir = src.dir)
	created.appearance = mob_reference.appearance
	created.transform = matrix(mob_reference.base_transform)
	created.pixel_x = image_pixel_x
	created.pixel_y = image_pixel_y
	created.alpha = 0
	if(image_color)
		created.color = image_color
	animate(created, alpha = 120, QUAD_EASING, time = rand(0.3 SECONDS, 0.5 SECONDS))
	return created
