// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || buckled)
		to_chat(src, "You cannot tackle someone in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = tgui_input_list(src,"Who do you wish to tackle?", "Tackle", choices)

	if(!T || !src || stat || !Adjacent(T))
		return

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || buckled)
		to_chat(src, "You cannot tackle in your current state.")
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.apply_effect(rand(0.5,3), WEAKEN)
	else
		apply_effect(rand(2,4), WEAKEN)
		failed = 1

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1)
	if(failed)
		apply_effect(rand(2,4), WEAKEN)

	for(var/mob/O in viewers(src, null))
		if((O.client && !( O.blinded )))
			O.show_message(SPAN_DANGER("<B>[src] [failed ? "tried to tackle" : "has tackled"] down [T]!</B>"), SHOW_MESSAGE_VISIBLE)

/mob/living/carbon/human/proc/leap()
	set category = "Abilities"
	set name = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || body_position != STANDING_UP || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(6,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = tgui_input_list(src,"Who do you wish to leap at?", "Leap", choices)

	if(!T || !src || stat || get_dist(get_turf(T), get_turf(src)) > 6)
		return

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || body_position != STANDING_UP || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return

	last_special = world.time + 75
	status_flags |= LEAPING

	visible_message(SPAN_WARNING("<b>[src]</b> leaps at [T]!"))
	var/target = get_step(get_turf(T), get_dir(src, T))
	throw_atom(target, 5, SPEED_VERY_FAST, src)
	playsound(loc, 'sound/voice/shriek1.ogg', 25, 1)

	addtimer(CALLBACK(src, PROC_REF(finish_leap), T), 5)

/mob/living/carbon/human/proc/finish_leap(mob/living/T)
	if(status_flags & LEAPING)
		status_flags &= ~LEAPING

	if(!Adjacent(T))
		to_chat(src, SPAN_DANGER("You miss!"))
		return

	T.apply_effect(5, WEAKEN)

	if(T == src || T.anchored)
		return FALSE

	start_pulling(T)

/mob/living/carbon/human/proc/gut()
	set category = "Abilities"
	set name = "Gut"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || body_position != STANDING_UP)
		to_chat(src, SPAN_DANGER("You cannot do that in your current state."))
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, SPAN_DANGER("You are not grabbing anyone."))
		return

	if(usr.grab_level < GRAB_AGGRESSIVE)
		to_chat(src, SPAN_DANGER("You must have an aggressive grab to gut your prey!"))
		return

	last_special = world.time + 50

	visible_message(SPAN_WARNING("<b>[src]</b> rips viciously at [G.grabbed_thing]'s body with its claws!"))

	if(istype(G.grabbed_thing,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.grabbed_thing
		H.apply_damage(50,BRUTE)
		if(H.stat == 2)
			H.gib(create_cause_data("gutting", usr))
	else
		var/mob/living/M = G.grabbed_thing
		if(!istype(M))
			return //wut
		M.apply_damage(50,BRUTE)
		if(M.stat == 2)
			M.gib(create_cause_data("gutting", usr))

/mob/living/carbon/human/proc/commune()
	set category = "Abilities.Psychic"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = tgui_input_list(usr, "Select a creature!", "Speak to creature", targets)

	if(!target)
		return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = trim(strip_html(text))

	if(!text)
		return

	var/mob/M = targets[target]

	if(istype(M, /mob/dead/observer) || M.stat == DEAD)
		to_chat(src, "Not even a [species.name] can speak to the dead.")
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text] (AREA: [get_area_name(loc)])")

	to_chat(M, SPAN_NOTICE(" Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]"))
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == species.name)
			return
		to_chat(H, SPAN_DANGER("Your nose begins to bleed..."))
		H.drip(1)

/mob/living/carbon/human/proc/psychic_whisper(mob/target_mob as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities.Psychic"

	if(stat == DEAD)
		to_chat(src, SPAN_WARNING("You cannot talk while dead."))
		return FALSE

	var/whisper = tgui_input_text(src, "What do you wish to say?", "Psychic Whisper")
	if(whisper)
		log_say("PsychicWhisper: [key_name(src)]->[target_mob.key] : [whisper] (AREA: [get_area_name(loc)])")
		if(!istype(target_mob, /mob/living/carbon/xenomorph))
			to_chat(target_mob, SPAN_XENOQUEEN("You hear a strange, alien voice in your head... \"[SPAN_PSYTALK(whisper)]\""))
		else
			to_chat(target_mob, SPAN_XENOQUEEN("You hear the voice of [src] resonate in your head... \"[SPAN_PSYTALK(whisper)]\""))
		to_chat(src, SPAN_XENOWARNING("You said: \"[whisper]\" to [target_mob]"))
		FOR_DVIEW(var/mob/dead/observer/ghost, 12, src, SEE_INVISIBLE_OBSERVER)
			if(!isobserver(ghost) || !ghost.client)
				continue
			if(ghost.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
				var/rendered_message
				var/human_track = "(<a href='byond://?src=\ref[ghost];track=\ref[src]'>F</a>)"
				var/target_track = "(<a href='byond://?src=\ref[ghost];track=\ref[target_mob]'>F</a>)"
				rendered_message = SPAN_XENOLEADER("PsychicWhisper: [real_name][human_track] to [target_mob.real_name][target_track], <span class='normal'>'[SPAN_PSYTALK(whisper)]'</span>")
				ghost.show_message(rendered_message, SHOW_MESSAGE_AUDIBLE)
	return FALSE

/mob/living/carbon/human/proc/psychic_radiance()
	set name = "Psychic Radiance"
	set desc = "Whisper silently to multiple people over a distance."
	set category = "Abilities.Psychic"

	if(stat == DEAD)
		to_chat(src, SPAN_WARNING("You cannot talk while dead."))
		return FALSE

	var/whisper = tgui_input_text(src, "What do you wish to say?", "Psychic Radiance")
	var/list/target_list = list()
	if(!whisper)
		return FALSE
	FOR_DVIEW(var/mob/living/possible_target, 12, src, HIDE_INVISIBLE_OBSERVER)
		if(possible_target == src || !possible_target.client)
			continue
		target_list += possible_target
		if(!istype(possible_target, /mob/living/carbon/xenomorph))
			to_chat(possible_target, SPAN_XENOQUEEN("You hear a strange, alien voice in your head... \"[SPAN_PSYTALK(whisper)]\""))
		else
			to_chat(possible_target, SPAN_XENOQUEEN("You hear the voice of [src] resonate in your head... \"[SPAN_PSYTALK(whisper)]\""))
	FOR_DVIEW_END
	if(!length(target_list))
		to_chat(src, SPAN_XENOWARNING("There is no one around to hear you..."))
		return FALSE
	var/targetstring = english_list(target_list)
	to_chat(src, SPAN_XENONOTICE("You said: \"[whisper]\" to [targetstring]"))
	log_say("PsychicRadiance: [key_name(src)]->[targetstring] : [whisper] (AREA: [get_area_name(src)])")
	FOR_DVIEW(var/mob/dead/observer/ghost, 12, src, SEE_INVISIBLE_OBSERVER)
		if(!isobserver(ghost) || !ghost.client)
			continue
		if(ghost.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
			var/rendered_message
			var/human_track = "(<a href='byond://?src=\ref[ghost];track=\ref[src]'>F</a>)"
			rendered_message = SPAN_XENOLEADER("PsychicRadiance: [real_name][human_track] to [targetstring], <span class='normal'>'[SPAN_PSYTALK(whisper)]'</span>")
			ghost.show_message(rendered_message, SHOW_MESSAGE_AUDIBLE)
	return TRUE

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"
	set_resting(!resting, FALSE, TRUE)

///Proc to hook behavior to the change of value in the resting variable.
/mob/living/proc/set_resting(new_resting, silent = TRUE, instant = FALSE)
	if(!(mobility_flags & MOBILITY_REST))
		return
	if(new_resting == resting)
		return
	if(!COOLDOWN_FINISHED(src, rest_cooldown))
		to_chat(src, SPAN_WARNING("[isxeno(src) ? "We" : "You"] can't 'rest' that fast. Take a breather!"))
		return
	COOLDOWN_START(src, rest_cooldown, 1 SECONDS)

	. = resting
	resting = new_resting
	if(new_resting)
		if(body_position == LYING_DOWN)
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "We" : "You"] will now try to stay lying down on the floor."))
		else if(HAS_TRAIT(src, TRAIT_FORCED_STANDING) || (buckled && buckled.buckle_lying != NO_BUCKLE_LYING))
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "We" : "You"] will now lay down as soon as [isxeno(src) ? "we" : "you"] are able to."))
		else
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "We" : "You"] lay down."))
			set_lying_down()
	else
		if(body_position == STANDING_UP)
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "We" : "You"] will now try to remain standing up."))
		else if(HAS_TRAIT(src, TRAIT_FLOORED) || (buckled && buckled.buckle_lying != NO_BUCKLE_LYING))
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "We" : "You"] will now stand up as soon as [isxeno(src) ? "we" : "you"] are able to."))
		else
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "We" : "You"] stand up."))
			get_up(instant)

//	SEND_SIGNAL(src, COMSIG_LIVING_RESTING, new_resting, silent, instant)
//	update_resting() // HUD icons

/mob/living/carbon/human/proc/toggle_inherent_nightvison()
	set category = "Synthetic"
	set name = "Toggle Nightvision"
	set desc = "Toggles inherent nightvision."

	if(usr.is_mob_incapacitated())
		return

	default_lighting_alpha = default_lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE ? LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE : LIGHTING_PLANE_ALPHA_VISIBLE
	update_sight()

	to_chat(src, SPAN_NOTICE("Your vision is now set to <b>[default_lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE ? "Normal Vision" : "Nightvision"]</b>."))

// Used for synthetics
/mob/living/carbon/human/synthetic/proc/toggle_HUD()
	set category = "Synthetic"
	set name = "Toggle HUDs"
	set desc = "Toggles various HUDs."

	if(!issynth(usr) || usr.is_mob_incapacitated())
		return

	var/hud_choice = tgui_input_list(usr, "Choose a HUD to toggle", "Toggle HUD", list("Medical HUD", "Security HUD"))
	if(usr.is_mob_incapacitated())
		return

	var/datum/mob_hud/the_hud
	var/chosen_HUD = INHERENT_HUD_MEDICAL
	switch(hud_choice)
		if("Medical HUD")
			the_hud = GLOB.huds[MOB_HUD_MEDICAL_ADVANCED]
		if("Security HUD")
			the_hud = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
			chosen_HUD = INHERENT_HUD_SECURITY
		else
			return

	if(inherent_huds_toggled[chosen_HUD])
		inherent_huds_toggled[chosen_HUD] = FALSE
		the_hud.remove_hud_from(src, src)
		to_chat(src, SPAN_INFO("<B>[hud_choice] Disabled</B>"))
	else
		inherent_huds_toggled[chosen_HUD] = TRUE
		the_hud.add_hud_to(src, src)
		to_chat(src, SPAN_INFO("<B>[hud_choice] Enabled</B>"))

/mob/living/carbon/human/synthetic/synth_k9/proc/toggle_scent_tracking()
	set category = "Synthetic"
	set name = "Track Scent"
	set desc = "Activates the K9's keen sense of smell."

	if(usr.is_mob_incapacitated())
		return

	if(!isk9synth(usr))
		return

	var/datum/species/synthetic/synth_k9/speciesk9 = species

	speciesk9.radar.tgui_interact(src)

/mob/living/carbon/human/synthetic/synth_k9/proc/toggle_binocular_vision()
	set category = "Synthetic"
	set name = "Binocular Vision"
	set desc = "Activates the K9's keen sense of sight."

	if(usr.is_mob_incapacitated())
		return

	if(!is_zoomed)
		enable_zoom()
		visible_message(SPAN_NOTICE("[src] starts looking off into the distance."),
			SPAN_NOTICE("You start focusing your sight to look off into the distance."), null, 5)
		return

	if(is_zoomed)
		disable_zoom()
		return

/mob/living/carbon/human/proc/enable_zoom()
	var/viewsize = 12
	var/tileoffset = 11

	if(is_zoomed || !client)
		return
	is_zoomed = TRUE
	RegisterSignal(src, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(disable_zoom))
	client.change_view(viewsize)
	var/viewoffset = 32 * tileoffset
	switch(dir)
		if(NORTH)
			client.pixel_x = 0
			client.pixel_y = viewoffset
		if(SOUTH)
			client.pixel_x = 0
			client.pixel_y = -viewoffset
		if(EAST)
			client.pixel_x = viewoffset
			client.pixel_y = 0
		if(WEST)
			client.pixel_x = -viewoffset
			client.pixel_y = 0

/mob/living/carbon/human/proc/disable_zoom()
	SIGNAL_HANDLER
	if(!client)
		return
	UnregisterSignal(src, COMSIG_MOB_MOVE_OR_LOOK)
	client.change_view(GLOB.world_view_size)
	client.pixel_x = 0
	client.pixel_y = 0
	is_zoomed = FALSE
