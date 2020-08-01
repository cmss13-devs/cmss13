#define BELL_TOWER_RANGE 2
#define BELL_TOWER_EFFECT 4

/obj/structure/machinery/defenses/bell_tower
	name = "\improper R-1NG bell tower"
	desc = "A tactical advanced version of a normal alarm. Designed to trigger an old instinct ingrained in humans when they hear a wake-up alarm, for fast response."
	var/list/tripwires_placed = list()
	var/mob/last_mob_activated
	var/image/flick_image
	handheld_type = /obj/item/defenses/handheld/bell_tower

/obj/structure/machinery/defenses/bell_tower/Initialize()
	. = ..()

	if(turned_on)
		setup_tripwires()
	update_icon()

/obj/structure/machinery/defenses/bell_tower/update_icon()
	..()

	overlays.Cut()
	if(stat == DEFENSE_DAMAGED)
		overlays += "bell_tower_destroyed"
		return

	overlays += "bell_tower"

/obj/structure/machinery/defenses/bell_tower/power_on_action()
	clear_tripwires()
	setup_tripwires()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("The [name] gives a short ring, as it comes alive.")]")

/obj/structure/machinery/defenses/bell_tower/power_off_action()
	clear_tripwires()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("The [name] gives a beep and powers down.")]")

/obj/structure/machinery/defenses/bell_tower/proc/clear_tripwires()
	for(var/obj/effect/bell_tripwire/FE in tripwires_placed)
		qdel(FE)

/obj/structure/machinery/defenses/bell_tower/proc/setup_tripwires()
	clear_tripwires()
	for(var/turf/T in orange(BELL_TOWER_RANGE, loc))
		if(T.density)
			continue

		var/obj/effect/bell_tripwire/FE = new /obj/effect/bell_tripwire(T, belonging_to_faction)
		FE.linked_bell = src
		tripwires_placed += FE

/obj/structure/machinery/defenses/bell_tower/Dispose()
	. = ..()

	if(last_mob_activated)
		last_mob_activated = null
	if(flick_image)
		flick_image = null
	clear_tripwires()


/obj/effect/bell_tripwire
	name = "flag effect"
	anchored = TRUE
	mouse_opacity = 0
	invisibility = 101
	unacidable = TRUE
	var/obj/structure/machinery/defenses/bell_tower/linked_bell
	var/faction = FACTION_LIST_MARINE

/obj/effect/bell_tripwire/New(var/turf/T, var/faction = null)
	..(T)
	if(faction)
		src.faction = faction

/obj/effect/bell_tripwire/Dispose()
	if(linked_bell)
		linked_bell.tripwires_placed -= src
		linked_bell = null
	. = ..()

/obj/effect/bell_tripwire/Crossed(var/atom/movable/A)
	if(!linked_bell)
		qdel(src)
		return

	if(!isXeno(A) && !ishuman(A))
		return

	var/mob/M = A
	if(ishuman(M)) 
		var/mob/living/carbon/human/H = M
		if(H.faction in faction)
			return
	
	if(linked_bell.last_mob_activated == M)
		return
	linked_bell.last_mob_activated = M
	if(!linked_bell.flick_image)
		linked_bell.flick_image = image('icons/obj/structures/machinery/defenses.dmi', icon_state = "bell_tower_alert")
	linked_bell.flick_image.flick_overlay(linked_bell, 11)
	playsound(loc, 'sound/misc/bell.wav', 50, 0, 50)
	M.AdjustSuperslowed(BELL_TOWER_EFFECT)
	to_chat(M, SPAN_DANGER("The frequence of the noise slows you down!"))


#undef BELL_TOWER_RANGE
#undef BELL_TOWER_EFFECT
