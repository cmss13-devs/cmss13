//-----USS Almayer Machinery file -----//
// Put any new machines in here before map is released and everything moved to their proper positions.

/obj/structure/machinery/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, AHELP 'ART-P01' IF SEEN IN ROUND WITH LOCATION"

/obj/structure/machinery/prop/almayer/hangar/dropship_part_fabricator

/obj/structure/machinery/prop/almayer/computer/PC
	name = "personal desktop"
	desc = "A small computer hooked up into the ship's computer network."
	icon_state = "terminal1"

/obj/structure/machinery/prop/almayer/computer
	name = "systems computer"
	desc = "A small computer hooked up into the ship's systems."

	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20

	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "terminal"

/obj/structure/machinery/prop/almayer/computer/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				set_broken()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(25))
				deconstruct(FALSE)
				return
			if (prob(50))
				set_broken()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return
		else
			return

/obj/structure/machinery/prop/almayer/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/structure/machinery/prop/almayer/computer/power_change()
	..()
	update_icon()

/obj/structure/machinery/prop/almayer/computer/update_icon()
	..()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "0"

/obj/structure/machinery/prop/almayer/computer/NavCon
	name = "NavCon"
	desc = "Navigational console for plotting course and heading of the ship. Since the AI calculates all long-range navigation, this is only used for in-system course corrections and orbital maneuvers. Don't touch it!"

	icon_state = "retro"

/obj/structure/machinery/prop/almayer/computer/NavCon2
	name = "NavCon 2"
	desc = "Navigational console for plotting course and heading of the ship. Since the AI calculates all long-range navigation, this is only used for in-system course corrections and orbital maneuvers. Don't touch it!"

	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "retro2"

/obj/structure/machinery/prop/almayer/CICmap
	name = "map table"
	desc = "A table that displays a map of the current operation location."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "maptable"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	density = TRUE
	idle_power_usage = 2
	var/datum/tacmap/map
	///flags that we want to be shown when you interact with this table
	var/minimap_type = MINIMAP_FLAG_USCM
	///The faction that is intended to use this structure (determines type of tacmap used)
	var/faction = FACTION_MARINE

/obj/structure/machinery/prop/almayer/CICmap/Initialize()
	. = ..()

	if (faction == FACTION_MARINE)
		map = new /datum/tacmap/drawing(src, minimap_type)
	else
		map = new(src, minimap_type) // Non-drawing version

/obj/structure/machinery/prop/almayer/CICmap/Destroy()
	QDEL_NULL(map)
	return ..()

/obj/structure/machinery/prop/almayer/CICmap/attack_hand(mob/user)
	. = ..()

	map.tgui_interact(user)

/obj/structure/machinery/prop/almayer/CICmap/computer
	name = "map terminal"
	desc = "A terminal that displays a map of the current operation location."
	icon = 'icons/obj/vehicles/interiors/arc.dmi'
	icon_state = "cicmap_computer"
	density = FALSE

/obj/structure/machinery/prop/almayer/CICmap/upp
	minimap_type = MINIMAP_FLAG_UPP
	faction = FACTION_UPP

/obj/structure/machinery/prop/almayer/CICmap/clf
	minimap_type = MINIMAP_FLAG_CLF
	faction = FACTION_CLF

/obj/structure/machinery/prop/almayer/CICmap/pmc
	minimap_type = MINIMAP_FLAG_PMC
	faction = FACTION_PMC

//Nonpower using props

/obj/structure/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, AHELP 'ART-P02' IF SEEN IN ROUND WITH LOCATION"
	density = TRUE
	anchored = TRUE

/obj/structure/prop/almayer/minigun_crate
	name = "30mm ammo crate"
	desc = "A crate full of 30mm bullets used on one of the weapon pod types for the dropship. Moving this will require some sort of lifter."
	icon = 'icons/obj/structures/props/dropship_ammo.dmi'
	icon_state = "30mm_crate"

/obj/structure/prop/almayer/computers
	var/hacked = FALSE

/obj/structure/prop/almayer/computers/update_icon()
	. = ..()

	overlays.Cut()

	if(hacked)
		overlays += "+hacked"

/obj/structure/prop/almayer/computers/mission_planning_system
	name = "\improper MPS IV computer"
	desc = "The Mission Planning System IV (MPS IV), an enhancement in mission planning and charting for dropship pilots across the USCM. Fully capable of customizing their flight paths and loadouts to suit their combat needs."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "mps"

/obj/structure/prop/almayer/computers/mapping_computer
	name = "\improper CMPS II computer"
	desc = "The Common Mapping Production System version II allows for sensory input from satellites and ship systems to derive planetary maps in a standardized fashion for all USCM pilots."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "mapping_comp"

/obj/structure/prop/almayer/computers/sensor_computer1
	name = "sensor computer"
	desc = "The IBM series 10 computer retrofitted to work as a sensor computer for the ship. While somewhat dated it still serves its purpose."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp1"

/obj/structure/prop/almayer/computers/sensor_computer2
	name = "sensor computer"
	desc = "The IBM series 10 computer retrofitted to work as a sensor computer for the ship. While somewhat dated it still serves its purpose."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp2"

/obj/structure/prop/almayer/computers/sensor_computer3
	name = "sensor computer"
	desc = "The IBM series 10 computer retrofitted to work as a sensor computer for the ship. While somewhat dated it still serves its purpose."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp3"

/obj/structure/prop/almayer/missile_tube
	name = "\improper Mk 33 ASAT launcher system"
	desc = "Cold launch tubes that can fire a few varieties of missiles out of them, the most common being the ASAT-21 Rapier IV missile used against satellites and other spacecraft and the BGM-227 Sledgehammer missile which is used for ground attack."
	icon = 'icons/obj/structures/props/almayer_props96.dmi'
	icon_state = "missiletubenorth"
	bound_width = 32
	bound_height = 96
	unslashable = TRUE
	unacidable = TRUE

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

/obj/structure/prop/almayer/ship_memorial/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dogtag))
		var/obj/item/dogtag/D = I
		if(D.fallen_names)
			to_chat(user, SPAN_NOTICE("You add [D] to [src]."))
			GLOB.fallen_list += D.fallen_names
			fallen_personnel += D.fallen_references
			qdel(D)
		return TRUE
	else
		. = ..()

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
	///How much time it takes for a name to get read.
	var/time_to_remember = 4 SECONDS
	///Did a flashback event trigger?
	var/had_flashback = FALSE
	for(var/i = 1, i <= clamp(length(fallen_personnel), 1, 8), i++)
		if(!do_after(user, time_to_remember, INTERRUPT_ALL_OUT_OF_RANGE))
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

			if(prob(i*4))
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
		var/obj/effect/memorial_ghost/ghost = generate_ghost(person, user)
		///Gender of the generated ghost.
		var/ghost_gender = person.get_gender()
		if(ghost_gender == FEMALE)
			playsound_client(user.client, pick_n_take(voicelines_female), ghost.loc, 55)
		else
			playsound_client(user.client, pick_n_take(voicelines), ghost.loc, 70)

		addtimer(CALLBACK(ghost, TYPE_PROC_REF(/obj/effect/memorial_ghost, disappear)), rand(1.5 SECONDS, 1.9 SECONDS))
		time_to_remember -= 0.2 SECONDS

	if(had_flashback)
		add_to_cooldown(user, 60 SECONDS)

	sleep(1 SECONDS)

	///A sentence that's displayed at the end of the slab interaction.
	var/list/realization_text = list("Those people were your family.",
		"You'll never forget. Even if it hurts to remember.",
		"They're gone. And you'll never see them again.",
		"You say your goodbyes silently.",
		"Nothing good lasts forever.")
	to_chat(user, SPAN_NOTICE("<b>[pick(realization_text)]</b>"))

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
		for(var/obj/effect/memorial_ghost/ghost in ghosts)
			ghost.disappear()

///Proc for generating a ghost image of a mob.
/obj/structure/prop/almayer/ship_memorial/proc/generate_ghost(person, mob/living/user, range = 3)
	if(!person)
		return

	var/obj/effect/memorial_ghost/ghost = new(src, person)

	///All acceptable turfs where the ghost could spawn.
	var/list/ghost_turf = list()
	for(var/turf/turf in range(user.loc, range))
		var/bad_turf = FALSE
		if(turf.density || istype(turf, /turf/open/space))
			continue

		if(!(user in view(3, turf)))
			continue

		for(var/obj/object in turf)
			if(object.density || (object != ghost && istype(object, /obj/effect/memorial_ghost)))
				bad_turf = TRUE
				break

		for(var/mob/mob in turf)
			bad_turf = TRUE
			break

		if(bad_turf)
			continue

		ghost_turf += turf

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

			for(var/obj/effect/memorial_ghost/ghost in all_ghosts)
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
			///How long it takes for a ghost to get generated.
			var/time_to_remember = 4 SECONDS
			for(var/i = clamp(length(squad_members), 1, 12), i > 0, i--)
				if(!do_after(user, time_to_remember, INTERRUPT_ALL_OUT_OF_RANGE))
					cancel_flashback(user, all_ghosts, FLASHBACK_SQUAD)
					return

				for(var/mob/living/mob in view(src, 6))
					if(mob != user && mob.stat == CONSCIOUS)
						cancel_flashback(user, all_ghosts, FLASHBACK_SQUAD)
						return

				var/mob/living/carbon/human/picked_member = pick_n_take(squad_members)
				var/obj/effect/memorial_ghost/generated_ghost = generate_ghost(picked_member, user, 2)
				all_ghosts += generated_ghost

				var/ghost_gender = picked_member.get_gender()
				if(ghost_gender == FEMALE)
					playsound_client(user.client, pick_n_take(voicelines_female), generated_ghost.loc, 55)
				else
					playsound_client(user.client, pick_n_take(voicelines), generated_ghost.loc, 70)

				to_chat(user, SPAN_DANGER("[pick_n_take(inspection_text)] <b>[picked_member]</b>, [GET_DEFAULT_ROLE(picked_member.job)]."))
				sleep(rand(0.5 SECONDS, 0.7 SECONDS))

			went_through_flashback += user
			sleep(2 SECONDS)

			//Special sound for those who really treasure their squad.
			if(length(all_ghosts) >= 6)
				to_chat(user, SPAN_NOTICE("<b>There's a distinct sound in the air...<b>"))
				playsound_client(user.client, 'sound/hallucinations/ghost_taps.ogg', user.loc, 70)

			sleep(3 SECONDS)

			for(var/obj/effect/memorial_ghost/ghost in all_ghosts)
				ghost.disappear()

			///Name of the user, split so we can retrieve their first name.
			var/list/split_name = splittext(user.name, " ")
			to_chat(user, SPAN_NOTICE("<b>You hear someone whisper 'Thank you, [split_name[1]]. Goodbye.' into your ear.</b>"))
			sleep(4 SECONDS)
			to_chat(user, SPAN_NOTICE("<b>It feels final. Maybe it's time to look forward now.</b>"))

#undef FLASHBACK_DEFAULT
#undef FLASHBACK_SQUAD
#undef REQUIRED_DEAD_SQUADDIES

/obj/effect/memorial_ghost

/obj/effect/memorial_ghost/proc/disappear()
	var/time_to_disappear = rand(0.4 SECONDS, 0.8 SECONDS)
	animate(src, alpha = 0, QUAD_EASING, time = time_to_disappear)
	sleep(time_to_disappear)
	qdel(src)

/obj/effect/memorial_ghost/Initialize(mapload, mob/living/mob_reference = null)
	if(!mob_reference)
		. = ..()
		qdel(src)
		return

	name = mob_reference.name
	appearance = mob_reference.appearance
	base_transform = matrix(mob_reference.base_transform)
	apply_transform(matrix())
	alpha = 0
	desc = "May we never forget freedom isn't free."
	layer = MOB_LAYER
	animate(src, alpha = 120, QUAD_EASING, time = rand(0.3 SECONDS, 0.5 SECONDS))
	return ..()


/obj/structure/prop/almayer/particle_cannon
	name = "\improper 75cm/140 Mark 74 General Atomics railgun"
	desc = "The Mark 74 Railgun is top of the line for space-based weaponry. Capable of firing a round with a diameter of 3/4ths of a meter at 24 kilometers per second. It also is capable of using a variety of round types which can be interchanged at any time with its newly designed feed system."
	icon = 'icons/obj/structures/machinery/artillery.dmi'
	icon_state = "1"
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/particle_cannon/corsat
	name = "\improper CORSAT-PROTO-QUANTUM-CALCULATOR"
	desc = ""

/obj/structure/prop/almayer/name_stencil
	name = "USS Almayer"
	desc = "The name of the ship stenciled on the hull."
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "almayer0"
	density = FALSE //dunno who would walk on it, but you know.
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/hangar_stencil
	name = "floor"
	desc = "A large number stenciled on the hangar floor used to designate which dropship it is."
	icon = 'icons/obj/structures/props/almayer_props96.dmi'
	icon_state = "dropship1"
	density = FALSE
	layer = ABOVE_TURF_LAYER


/obj/structure/prop/almayer/cannon_cables
	name = "\improper Cannon cables"
	desc = "Some large cables."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "cannon_cables"
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = LADDER_LAYER
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/cannon_cables/ex_act()
	return

/obj/structure/prop/almayer/cannon_cables/bullet_act()
	return


/obj/structure/prop/almayer/cannon_cable_connector
	name = "\improper Cannon cable connector"
	desc = "A connector for the large cannon cables."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "cannon_cable_connector"
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/cannon_cable_connector/ex_act()
	return

/obj/structure/prop/almayer/cannon_cable_connector/bullet_act()
	return








//------- Cryobag Recycler -------//
// Wanted to put this in, but since we still have extra time until tomorrow and this is really simple thing. It just recycles opened cryobags to make it nice-r for medics.
// Also the lack of sleep makes me keep typing cyro instead of cryo. FFS ~Art

/obj/structure/machinery/cryobag_recycler
	name = "cryogenic bag recycler"
	desc = "A small tomb like structure. Capable of taking in used and opened cryobags and refill the liner and attach new sealants."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "recycler"

	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20

//What is this even doing? Why is it making a new item?
/obj/structure/machinery/cryobag_recycler/attackby(obj/item/W, mob/user) //Hope this works. Don't see why not.
	..()
	if (istype(W, /obj/item))
		if(W.name == "used stasis bag") //possiblity for abuse, but fairly low considering its near impossible to rename something without VV
			var/obj/item/bodybag/cryobag/R = new /obj/item/bodybag/cryobag //lets give them the bag considering having it unfolded would be a pain in the ass.
			R.add_fingerprint(user)
			user.temp_drop_inv_item(W)
			qdel(W)
			user.put_in_hands(R)
			return TRUE
	..()

/obj/structure/closet/basketball
	name = "athletic wardrobe"
	desc = "It's a storage unit for athletic wear."
	icon_state = "purple"
	icon_closed = "purple"
	icon_opened = "purple_open"

/obj/structure/closet/basketball/Initialize()
	. = ..()
	new /obj/item/clothing/under/shorts/grey(src)
	new /obj/item/clothing/under/shorts/black(src)
	new /obj/item/clothing/under/shorts/red(src)
	new /obj/item/clothing/under/shorts/blue(src)
	new /obj/item/clothing/under/shorts/green(src)
