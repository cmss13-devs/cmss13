// A receptionist's bell

/obj/item/desk_bell
	name = "desk bell"
	desc = "The cornerstone of any customer service job. You feel an unending urge to ring it."
	icon = 'icons/obj/items/table_decorations.dmi'
	icon_state = "desk_bell"
	w_class = SIZE_SMALL
	embeddable = FALSE
	/// The amount of times this bell has been rang, used to check the chance it breaks.
	var/times_rang = 0
	/// Is this bell broken?
	var/broken_ringer = FALSE
	/// Holds the time that the bell can next be rang.
	COOLDOWN_DECLARE(ring_cooldown)
	/// The length of the cooldown. Setting it to 0 will skip all cooldowns alltogether.
	var/ring_cooldown_length = 5 SECONDS // This is here to protect against tinnitus.
	/// The sound the bell makes.
	var/ring_sound = 'sound/misc/desk_bell.ogg'

/obj/item/desk_bell/attack_hand(mob/living/user)
	if(!ishuman(user))
		return FALSE
	if(!anchored)
		return ..()
	if(!COOLDOWN_FINISHED(src, ring_cooldown))
		return FALSE
	if(!ring_bell(user))
		to_chat(user, SPAN_NOTICE("[src] is silent. Some idiot broke it."))
		return FALSE
	return TRUE

/obj/item/desk_bell/MouseDrop(atom/over_object)
	var/mob/mob = usr
	if(!Adjacent(mob) || anchored)
		return
	if(!ishuman(mob))
		return

	if(over_object == mob)
		mob.put_in_hands(src)

/obj/item/desk_bell/attackby(obj/item/item, mob/user)
	//Repair the desk bell if its broken and we're using a screwdriver.
	if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
		if(broken_ringer)
			user.visible_message(SPAN_NOTICE("[user] begins repairing [src]..."), SPAN_NOTICE("You begin repairing [src]..."))
			if(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] repairs [src]."), SPAN_NOTICE("You repair [src]."))
				playsound(src, 'sound/items/Screwdriver.ogg', 50)
				broken_ringer = FALSE
				times_rang = 0
				return TRUE
			return FALSE

	//Return at this point if we're not on a turf so we don't anchor or unanchor inside our bag/hands or inventory.
	if(!isturf(loc))
		return

	//Wrenching down and unwrenching.
	if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
		if(user.a_intent == INTENT_HARM)
			visible_message(SPAN_NOTICE("[user] begins taking apart [src]..."), SPAN_NOTICE("You begin taking apart [src]..."))
			playsound(src, 'sound/items/deconstruct.ogg', 35)
			if(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				visible_message(SPAN_NOTICE("[user] takes apart [src]."), SPAN_NOTICE("You take apart [src]."))
				new /obj/item/stack/sheet/metal(get_turf(src))
				qdel(src)
				return TRUE
		else
			user.visible_message(SPAN_NOTICE("[user] begins [anchored ? "un" : ""]securing [src]..."), SPAN_NOTICE("You begin [anchored ? "un" : ""]securing [src]..."))
			playsound(src, 'sound/items/Ratchet.ogg', 35, TRUE)
			if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				return FALSE
			user.visible_message(SPAN_NOTICE("[user] [anchored ? "un" : ""]secures [src]."), SPAN_NOTICE("You [anchored ? "un" : ""]secure [src]."))
			anchored = !anchored
			return TRUE


/// Check if the clapper breaks, and if it does, break it. Chance to break is 1% for every 100 rings of the bell.
/obj/item/desk_bell/proc/check_clapper(mob/living/user)
	if(prob(times_rang / 100))
		to_chat(user, SPAN_NOTICE("You hear [src]'s clapper fall off of its hinge. Nice job hamfist, you broke it."))
		broken_ringer = TRUE

/// Ring the bell.
/obj/item/desk_bell/proc/ring_bell(mob/living/user)
	if(broken_ringer)
		return FALSE
	check_clapper(user)
	COOLDOWN_START(src, ring_cooldown, ring_cooldown_length)
	playsound(src, ring_sound, 80)
	flick("desk_bell_activate", src)
	times_rang++
	return TRUE

/obj/item/desk_bell/ares
	name = "AI core reception bell"
	desc = "The cornerstone of any customer service job. This one is linked to ARES and will notify any active Working Joes upon being rung."
	ring_cooldown_length = 60 SECONDS // Prevents spam

/obj/item/desk_bell/ares/ring_bell(mob/living/user)
	if(broken_ringer)
		return FALSE
	ares_apollo_talk("Attendence requested at AI Core Reception.")
	return ..()
