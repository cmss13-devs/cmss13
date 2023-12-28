// A receptionist's bell

/obj/item/desk_bell
	name = "desk bell"
	desc = "The cornerstone of any customer service job. You feel an unending urge to ring it. It looks like it can be wrenched or screwdrivered."
	icon = 'icons/obj/objects.dmi'
	icon_state = "desk_bell"
	/// The amount of times this bell has been rang, used to check the chance it breaks
	var/times_rang = 0
	/// Is this bell broken?
	var/broken_ringer = FALSE
	/// Holds the time that the bell can next be rang.
	var/ring_cooldown = 0
	/// The length of the cooldown. Setting it to 0 will skip all cooldowns alltogether.
	var/ring_cooldown_length = 0.5 SECONDS // This is here to protect against tinnitus.
	/// The sound the bell makes
	var/ring_sound = 'sound/misc/desk_bell.ogg'

/obj/item/desk_bell/attack_hand(mob/living/user)
	if(!ishuman(user))
		return FALSE
	if(!anchored)
		return ..()
	if(ring_cooldown > world.time)
		return FALSE
	if(!ring_bell(user))
		to_chat(user, "<span class='notice'>[src] is silent. Some idiot broke it.</span>")
		return FALSE
	ring_cooldown = world.time + ring_cooldown_length
	return TRUE

/obj/item/desk_bell/MouseDrop(atom/over_object)
	var/mob/mob = usr
	if(!Adjacent(mob) || anchored)
		return
	if(!ishuman(mob))
		return

	if(over_object == mob)
		mob.put_in_hands(src)

	add_fingerprint(mob)

/obj/item/desk_bell/attackby(obj/item/item, mob/user)
	if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
		if(broken_ringer)
			visible_message("<span class='notice'>[user] begins repairing [src]...</span>", "<span class='notice'>You begin repairing [src]...</span>")
			if(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				user.visible_message("<span class='notice'>[user] repairs [src].</span>", "<span class='notice'>You repair [src].</span>")
				playsound(user, 'sound/items/Screwdriver.ogg', 50, vary = TRUE)
				broken_ringer = FALSE
				times_rang = 0
				return TRUE
			return FALSE

	// Return at this point so we don't anchor, unanchor or
	if(isstorage(loc))
		return

	if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
		if(user.a_intent == INTENT_HARM)
			visible_message("<span class='notice'>[user] begins taking apart [src]...</span>", "<span class='notice'>You begin taking apart [src]...</span>")
			if(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				visible_message("<span class='notice'>[user] takes apart [src].</span>", "<span class='notice'>You take apart [src].</span>")
				playsound(user, 'sound/items/deconstruct.ogg', 50, vary = TRUE)
				new /obj/item/stack/sheet/metal(get_turf(src))
				qdel(src)
				return TRUE
		else
			user.visible_message("[user] begins [anchored ? "un" : ""]securing [src]...", "You begin [anchored ? "un" : ""]securing [src]...")
			if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				return FALSE
			anchored = !anchored
			return TRUE


/// Check if the clapper breaks, and if it does, break it chance to break is 1% for every 100 rings of the bell
/obj/item/desk_bell/proc/check_clapper(mob/living/user)
	if(prob(times_rang / 100) && ring_cooldown_length)
		to_chat(user, "<span class='notice'>You hear [src]'s clapper fall off of its hinge. Nice job, you broke it.</span>")
		broken_ringer = TRUE

/// Ring the bell
/obj/item/desk_bell/proc/ring_bell(mob/living/user)
	if(broken_ringer)
		return FALSE
	check_clapper(user)
	// The lack of varying is intentional. The only variance occurs on the strike the bell breaks.
	playsound(src, ring_sound, 70, vary = broken_ringer)
	flick("desk_bell_activate", src)
	times_rang++
	return TRUE
