/obj/structure/vehicle_intercom
	name = "vehicle intercom"
	desc = "A wall-mounted intercom wired into the vehicle's hull, relaying speech between the crew compartment and the outside world."
	icon = 'icons/obj/structures/phone.dmi'
	icon_state = "wall_phone"
	anchored = TRUE
	density = FALSE
	layer = 3.2

	unacidable = TRUE
	unslashable = TRUE
	explo_proof = TRUE

	flags_atom = USES_HEARING

	var/obj/vehicle/multitile/vehicle = null
	var/obj/item/phone/handset

	// Mic = picks up interior speech to broadcast outside. Speaker = plays exterior speech inside.
	var/mic_muted = FALSE
	var/speaker_muted = FALSE

/obj/structure/vehicle_intercom/Initialize(mapload, ...)
	. = ..()
	handset = new /obj/item/phone(src)

/obj/structure/vehicle_intercom/Destroy()
	QDEL_NULL(handset)
	vehicle = null
	return ..()

/obj/structure/vehicle_intercom/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	var/choice = tgui_input_list(user, "Adjust the intercom's microphone and speaker.", "Vehicle Intercom",
		list("Toggle Microphone ([mic_muted ? "Muted" : "Live"])", "Toggle Speaker ([speaker_muted ? "Muted" : "Live"])", "Cancel"))

	if(!choice || choice == "Cancel" || !Adjacent(user))
		return

	if(findtext(choice, "Microphone"))
		mic_muted = !mic_muted
		to_chat(user, SPAN_NOTICE("You [mic_muted ? "mute" : "unmute"] the intercom's microphone. [mic_muted ? "Nobody outside will hear the crew compartment." : "The crew compartment can be heard outside again."]"))
	else if(findtext(choice, "Speaker"))
		speaker_muted = !speaker_muted
		to_chat(user, SPAN_NOTICE("You [speaker_muted ? "mute" : "unmute"] the intercom's speaker. [speaker_muted ? "The crew compartment will no longer hear the outside." : "The crew compartment can hear the outside again."]"))

// anyone speaking near the inttercom inside the interior gets relayed outside.
/obj/structure/vehicle_intercom/hear_talk(mob/living/M, msg, verb = "says", datum/language/speaking, italics = 0)
	if(!mic_muted)
		relay_to_exterior(M, msg, verb, speaking, italics)
	..()

/obj/structure/vehicle_intercom/proc/relay_to_exterior(mob/living/M, msg, verb, datum/language/speaking, italics)
	if(!vehicle)
		return
	var/turf/exterior_turf = get_turf(vehicle)
	if(!exterior_turf)
		return
	var/list/listeners = get_mobs_in_view(7, exterior_turf)
	if(!length(listeners))
		return
	for(var/mob/L in listeners)
		L.hear_radio(msg, verb, speaking, part_a = "<span class='purple'><span class='name'>",
			part_b = "</span><span class='message'> ", vname = "[vehicle] Intercom",
			speaker = M, no_paygrade = TRUE)
	vehicle.langchat_speech(msg, listeners, speaking, M.langchat_color, FALSE, LANGCHAT_FAST_POP, list(M.langchat_styles))

// Called by /obj/vehicle/multitile/hear_talk() when someone speaks near the vehicle's exterior.
/obj/structure/vehicle_intercom/proc/relay_exterior_speech(mob/living/M, msg, verb, datum/language/speaking, italics)
	if(speaker_muted || !vehicle || !vehicle.interior)
		return
	var/list/listeners = vehicle.interior.get_passengers()
	if(!length(listeners))
		return
	for(var/mob/L in listeners)
		L.hear_radio(msg, verb, speaking, part_a = "<span class='purple'><span class='name'>",
			part_b = "</span><span class='message'> ", vname = "Intercom",
			speaker = M, no_paygrade = TRUE)
	langchat_speech(msg, listeners, speaking, M.langchat_color, FALSE, LANGCHAT_FAST_POP, list(M.langchat_styles))
