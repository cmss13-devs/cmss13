/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's thick and gooey. This probably isn't a safe place to be."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = ABOVE_WEED_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/effects/blood.dmi'
	icon_state = "mfloor1"
	random_icon_states = list("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7")
	cleanable_type = CLEANABLE_BLOOD
	overlay_on_initialize = FALSE
	color= "#830303" // Color when wet.
	var/base_icon = 'icons/effects/blood.dmi'
	var/list/viruses
	var/amount = 3
	var/drying_time = 30 SECONDS
	var/dry_start_time // If this dries, track the dry start time for footstep drying
	garbage = FALSE // Keep for atmosphere

/obj/effect/decal/cleanable/blood/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	viruses = null
	return ..()

/obj/effect/decal/cleanable/blood/Initialize(mapload, b_color)
	. = ..()
	if(b_color)
		color = b_color
	update_icon()

	if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/blood_optimization))
		amount = 0
		return

	if(drying_time)
		if(mapload) // Don't use timer at all in mapload - as deleting long running timers during MC init causes issues (see /tg/ issue #56292)
			dry()
			return
		dry_start_time = world.time
		addtimer(CALLBACK(src, PROC_REF(dry)), drying_time * (amount+1))

/obj/effect/decal/cleanable/blood/Crossed(atom/movable/AM)
	. = ..()
	// Check if the blood is dry and only humans
	// can make footprints
	if(!amount || !ishuman(AM) || QDELETED(AM))
		return

	if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/blood_optimization))
		return

	var/mob/living/carbon/human/H = AM
	H.add_blood(color, BLOOD_FEET)

	var/dry_time_left = 0
	if(drying_time)
		dry_time_left = max(0, drying_time - (world.time - dry_start_time))

	if(GLOB.perf_flags & PERF_TOGGLE_NOBLOODPRINTS)
		return

	if(!H.bloody_footsteps)
		H.AddElement(/datum/element/bloody_feet, dry_time_left, H.shoes, amount, color)
	else
		SEND_SIGNAL(H, COMSIG_HUMAN_BLOOD_CROSSED, amount, color, dry_time_left)

/obj/effect/decal/cleanable/blood/proc/dry()
	amount = 0
	if(cleanable_turf)
		create_overlay()
	else
		cleanup_cleanable()

/obj/effect/decal/cleanable/blood/can_place_cleanable(obj/effect/decal/cleanable/old_cleanable)
	. = ..()

	var/obj/effect/decal/cleanable/blood/B = old_cleanable
	if(istype(B) && B.amount > amount)
		return FALSE

/obj/effect/decal/cleanable/blood/yautja
	color = BLOOD_COLOR_YAUTJA

/obj/effect/decal/cleanable/blood/splatter
	random_icon_states = list("mgibbl1", "mgibbl2", "mgibbl3", "mgibbl4", "mgibbl5")
	amount = 1
	cleanable_type = CLEANABLE_BLOOD_SPLATTER

/obj/effect/decal/cleanable/blood/splatter/yautja
	color = BLOOD_COLOR_YAUTJA

/obj/effect/decal/cleanable/blood/drip
	name = "drips of blood"
	desc = "Some small drips of blood."
	gender = PLURAL
	icon = 'icons/effects/drip.dmi'
	icon_state = "1"
	random_icon_states = list("1","2","3","4","5")
	amount = 0
	cleanable_type = CLEANABLE_BLOOD_DRIP
	var/drips

/obj/effect/decal/cleanable/blood/drip/yautja
	color = BLOOD_COLOR_YAUTJA

/obj/effect/decal/cleanable/blood/writing
	icon_state = "tracks"
	desc = "It looks like a writing in blood."
	gender = NEUTER
	random_icon_states = list("writing1","writing2","writing3","writing4","writing5")
	amount = 0
	var/message

/obj/effect/decal/cleanable/blood/writing/New()
	..()
	if(length(random_icon_states))
		for(var/obj/effect/decal/cleanable/blood/writing/W in loc)
			random_icon_states.Remove(W.icon_state)
		icon_state = pick(random_icon_states)
	else
		icon_state = "writing1"

/obj/effect/decal/cleanable/blood/writing/get_examine_text(mob/user)
	. = ..()
	. += "It reads: <font color='[color]'>\"[message]\"<font>"

/obj/effect/decal/cleanable/blood/writing/yautja
	color = BLOOD_COLOR_YAUTJA

/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = ABOVE_WEED_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = "gib1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	cleanable_type = CLEANABLE_BLOOD_GIBS
	color = "#830303"

/obj/effect/decal/cleanable/blood/gibs/update_icon()
	overlays.Cut()

	var/image/giblets = new(base_icon, "[icon_state]_flesh", dir)
	giblets.color = color

	overlays += giblets

/obj/effect/decal/cleanable/blood/gibs/yautja
	color = BLOOD_COLOR_YAUTJA

/obj/effect/decal/cleanable/blood/gibs/up
	icon_state = "gibup1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gibup1", "gibup1", "gibup1")

/obj/effect/decal/cleanable/blood/gibs/up/yautja
	color = BLOOD_COLOR_YAUTJA

/obj/effect/decal/cleanable/blood/gibs/down
	icon_state = "gibdown1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gibdown1", "gibdown1", "gibdown1")

/obj/effect/decal/cleanable/blood/gibs/down/yautja
	color = BLOOD_COLOR_YAUTJA

/obj/effect/decal/cleanable/blood/gibs/body
	icon_state = "gibhead"
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/body/yautja
	color = BLOOD_COLOR_YAUTJA

/obj/effect/decal/cleanable/blood/gibs/limb
	icon_state = "gibleg"
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/limb/yautja
	color = BLOOD_COLOR_YAUTJA

/obj/effect/decal/cleanable/blood/gibs/core
	icon_state = "gibmid1"
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

/obj/effect/decal/cleanable/blood/gibs/core/yautja
	color = BLOOD_COLOR_YAUTJA


/obj/effect/decal/cleanable/blood/gibs/proc/streak(list/directions)
	var/direction = pick(directions)
	for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
		sleep(3)
		if (i > 0)
			var/obj/effect/decal/cleanable/blood/b = new /obj/effect/decal/cleanable/blood/splatter(src.loc)
			b.color = src.color
			b.update_icon()
			for(var/datum/disease/D in src.viruses)
				var/datum/disease/ND = D.Copy(1)
				LAZYADD(b.viruses, ND)
				ND.holder = b

		if (step_to(src, get_step(src, direction), 0))
			break
