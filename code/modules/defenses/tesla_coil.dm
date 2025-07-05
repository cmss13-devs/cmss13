#define TESLA_COIL_FIREDELAY 20
#define TESLA_COIL_RANGE 3
#define TESLA_COIL_DAZE_EFFECT 5
#define TESLA_COIL_SLOW_EFFECT 3

/obj/structure/machinery/defenses/tesla_coil
	name = "\improper 21S tesla coil"
	icon = 'icons/obj/structures/machinery/defenses/tesla.dmi'
	desc = "A perfected way of producing high-voltage, low-current and high-frequency electricity. Minor modifications allow it to only hit hostile targets with a devastating shock."
	var/list/targets
	var/last_fired = 0
	var/tesla_range = TESLA_COIL_RANGE
	var/fire_delay = TESLA_COIL_FIREDELAY
	var/attack_defenses = TRUE
	handheld_type = /obj/item/defenses/handheld/tesla_coil
	disassemble_time = 10
	health = 150
	health_max = 150
	display_additional_stats = TRUE

	has_camera = FALSE

	choice_categories = list(
		SENTRY_CATEGORY_IFF = list(FACTION_MARINE, SENTRY_FACTION_WEYLAND, SENTRY_FACTION_HUMAN),
	)

	selected_categories = list(
		SENTRY_CATEGORY_IFF = FACTION_MARINE,
	)


/obj/structure/machinery/defenses/tesla_coil/Initialize()
	. = ..()

	if(turned_on)
		start_processing()
	update_icon()

/obj/structure/machinery/defenses/tesla_coil/update_icon()
	..()

	overlays.Cut()
	if(stat == DEFENSE_DAMAGED)
		overlays += image(icon, icon_state = "[defense_type] tesla_coil_destroyed", pixel_y = 3)
		return

	if(turned_on)
		overlays += image(icon, icon_state = "[defense_type] tesla_coil_on", pixel_y = 3)
	else
		overlays += image(icon, icon_state = "[defense_type] tesla_coil", pixel_y = 3)

/obj/structure/machinery/defenses/tesla_coil/power_on_action()
	set_light(7)
	start_processing()
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] gives a short zap, as it awakens.")]")

/obj/structure/machinery/defenses/tesla_coil/power_off_action()
	set_light(0)
	stop_processing()
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] dies out with a last spark.")]")

/obj/structure/machinery/defenses/tesla_coil/process()
	if(!anchored || !turned_on || stat)
		return

	get_target()
	if(!isnull(targets))
		fire(targets)
	return

/obj/structure/machinery/defenses/tesla_coil/proc/get_target()
	targets = list()

	FOR_DOVIEW(var/mob/living/M, tesla_range, src, HIDE_INVISIBLE_OBSERVER)
		if(M.stat == DEAD)
			continue
		if(HAS_TRAIT(M, TRAIT_CHARGING))
			to_chat(M, SPAN_WARNING("You ignore some weird noises as you charge."))
			continue

		if(M.get_target_lock(faction_group))
			continue

		targets += M
	FOR_DOVIEW_END

	if(!attack_defenses)
		return

	FOR_DOVIEW(var/obj/structure/machinery/defenses/D, tesla_range, src, HIDE_INVISIBLE_OBSERVER)
		if(D.turned_on)
			targets += D
	FOR_DOVIEW_END

/obj/structure/machinery/defenses/tesla_coil/proc/fire(atoms)
	if(!(world.time - last_fired >= fire_delay) || !turned_on)
		return

	last_fired = world.time

	if(QDELETED(owner_mob))
		owner_mob = src

	for(var/A in atoms)
		if(isliving(A))
			var/mob/living/M = A
			if(!check_path(M))
				continue

			apply_debuff(M)
		else if(istype(A, /obj/structure/machinery/defenses))
			var/obj/structure/machinery/defenses/D = A
			D.power_off()

		var/datum/effect_system/spark_spread/S = new()
		S.set_up(5, 0, A)
		S.attach(A)
		S.start()
		qdel(S)

		beam(A, "electric", 'icons/effects/beam.dmi', 5, 5)
		track_shot()

	targets = null

/obj/structure/machinery/defenses/tesla_coil/proc/apply_debuff(mob/living/M)
	M.apply_effect(TESLA_COIL_DAZE_EFFECT, DAZE)
	M.apply_effect(TESLA_COIL_SLOW_EFFECT, SUPERSLOW)

/obj/structure/machinery/defenses/tesla_coil/proc/check_path(mob/living/M)
	if(!istype(M))
		return FALSE

	var/list/turf/path = get_line(src, M, include_start_atom = FALSE)

	var/blocked = FALSE
	for(var/turf/T in path)
		if(T.density || T.opacity)
			blocked = TRUE
			break

		for(var/obj/structure/S in T)
			if(S.opacity)
				blocked = TRUE
				break
			if(S.layer >= DOOR_CLOSED_LAYER || istype(S, /obj/structure/window))
				if(S.density)
					blocked = TRUE
					break

		for(var/obj/effect/particle_effect/smoke/S in T)
			blocked = TRUE
			break

	if(blocked)
		return FALSE

	return TRUE

/obj/structure/machinery/defenses/tesla_coil/Destroy() //Clear these for safety's sake.
	if(targets)
		targets = null

	. = ..()

// For mapping
/obj/structure/machinery/defenses/tesla_coil/premade
	turned_on = TRUE
	static = TRUE

/obj/structure/machinery/defenses/tesla_coil/premade/attackby(obj/item/O, mob/user)
	return

/obj/structure/machinery/defenses/tesla_coil/premade/smart
	attack_defenses = FALSE

#define TESLA_COIL_STUN_FIRE_DELAY 3 SECONDS
#define TESLA_COIL_STUN_EFFECT 1
/obj/structure/machinery/defenses/tesla_coil/stun
	name = "21S overclocked tesla coil"
	desc = "A perfected way of producing high-voltage, low-current and high-frequency electricity. Minor modifications allow it to only hit hostile targets with a devastating shock. This one is significantly overclocked, providing a lot more voltage at the cost of speed."
	fire_delay = TESLA_COIL_STUN_FIRE_DELAY
	handheld_type = /obj/item/defenses/handheld/tesla_coil/stun
	defense_type = "Stun"

/obj/structure/machinery/defenses/tesla_coil/stun/apply_debuff(mob/living/M)
	if(M.mob_size >= MOB_SIZE_BIG)
		M.set_effect(TESLA_COIL_SLOW_EFFECT, SUPERSLOW)
	else
		M.set_effect(TESLA_COIL_STUN_EFFECT, WEAKEN)

	M.set_effect(TESLA_COIL_DAZE_EFFECT * 1.5, DAZE) // 1.5x as effective as normal tesla

#undef TESLA_COIL_STUN_FIRE_DELAY
#define TESLA_COIL_MICRO_FIRE_DELAY 1 SECONDS
/obj/structure/machinery/defenses/tesla_coil/micro
	name = "\improper 25S micro tesla coil"
	desc = "A perfected way of producing high-voltage, low-current and high-frequency electricity. Minor modifications allow it to only hit hostile targets with a devastating shock. This one is smaller and more lightweight."
	handheld_type = /obj/item/defenses/handheld/tesla_coil/micro
	disassemble_time = 0.5 SECONDS
	fire_delay = TESLA_COIL_MICRO_FIRE_DELAY
	density = FALSE
	defense_type = "Micro"

/obj/structure/machinery/defenses/tesla_coil/micro/apply_debuff(mob/living/M)
	M.set_effect(TESLA_COIL_SLOW_EFFECT, SUPERSLOW) // Only applies slowness

#undef TESLA_COIL_MICRO_FIRE_DELAY
#undef TESLA_COIL_FIREDELAY
#undef TESLA_COIL_RANGE
