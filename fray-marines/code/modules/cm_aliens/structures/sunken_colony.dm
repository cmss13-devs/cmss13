#define SUNKEN_DELAY_PER_RANGE 0.2 SECONDS
#define SUNKEN_MAX_RANGE 24
#define SUNKEN_MIN_RANGE 2
#define SUNKEN_COOLDOWN 5 SECONDS

/datum/construction_template/xenomorph/sunken_colony
	name = XENO_STRUCTURE_SUNKEN
	build_type = /obj/effect/alien/resin/special/sunken_colony
	build_icon_state = "sunken"

	pixel_y = -8
	pixel_x = -24

/datum/construction_template/xenomorph/sunken_colony/set_structure_image()
	build_icon = 'fray-marines/icons/obj/structures/alien/Buildings.dmi'

//Sunken Colony - funny zerg reference
/obj/effect/alien/resin/special/sunken_colony
	name = XENO_STRUCTURE_SUNKEN
	desc = "A living stationary organism that strikes from below with its powerful claw. Fiercely territorial."
	icon = 'fray-marines/icons/obj/structures/alien/Buildings.dmi'
	icon_state = "sunken"
	health = 600

	pixel_y = -8
	pixel_x = -24

	var/damage = 110
	var/next_strike = 0
	var/strike_sound = 'fray-marines/sound/effects/burrower_attack1.ogg'
	var/datum/shape/rectangle/range_bounds

	appearance_flags = KEEP_TOGETHER
	layer = FACEHUGGER_LAYER

/obj/effect/alien/resin/special/sunken_colony/Initialize(mapload, hive_ref)
	. = ..()
	range_bounds = RECT(x, y, SUNKEN_MAX_RANGE, SUNKEN_MAX_RANGE)

/obj/effect/alien/resin/special/sunken_colony/process()
	if (world.time > next_strike)
		check_targets()

/obj/effect/alien/resin/special/sunken_colony/proc/check_targets()
	if (!range_bounds)
		range_bounds = RECT(x, y, SUNKEN_MAX_RANGE, SUNKEN_MAX_RANGE)

	var/list/targets = SSquadtree.players_in_range(range_bounds, z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	if (isnull(targets) || !length(targets))
		return

	var/target = pick(targets)
	if (isnull(target))
		return

	HasProximity(target)

/obj/effect/alien/resin/special/sunken_colony/HasProximity(atom/movable/AM as mob|obj)
	if (!linked_hive)
		return

	if (!is_ground_level(AM.z))
		return

	var/distance = get_dist(src, AM)
	if (distance <= SUNKEN_MIN_RANGE)
		return

	if (iscarbon(AM))
		var/mob/living/carbon/C = AM
		if (ismonkey(C)) // lesser hosts arent dangerous to us
			return
		if (C.stat == DEAD || linked_hive.is_ally(C) || C.status_flags & XENO_HOST)
			return

	flick("s_hitting", src)

	var/strike_delay = SUNKEN_DELAY_PER_RANGE * distance

	next_strike = world.time + SUNKEN_COOLDOWN
	spawn(0.2 SECONDS)
		distance = get_dist(src, AM)
		if(distance > SUNKEN_MIN_RANGE && !AM?:stat == DEAD)
			playsound(loc, strike_sound, 25, 1)
			new /obj/effect/impale(get_turf(AM), damage, strike_delay)

//Underground strike effect
/obj/effect/impale
	name = "impaling chitin"
	icon = 'fray-marines/icons/obj/structures/alien/effects.dmi'
	icon_state = "ground_spike"
	var/appearing_sound = 'fray-marines/sound/effects/burrower_attack1.ogg'
	var/strike_sound = "alien_bite"

/obj/effect/impale/New(loc, damage, strike_delay)
	. = ..()
	visible_message(SPAN_HIGHDANGER("Ground starts to rumble!"))
	playsound(loc, appearing_sound, 25, 1)
	var/image/J = new(icon = 'fray-marines/icons/obj/structures/alien/Buildings.dmi', icon_state = "warning", layer = ABOVE_FLY_LAYER)
	overlays += J

	addtimer(CALLBACK(src, PROC_REF(strike), damage), strike_delay)

/obj/effect/impale/proc/strike(damage, strike_delay)
	flick("spike_strike", src)
	spawn(strike_delay + SUNKEN_DELAY_PER_RANGE)
		for(var/mob/living/carbon/C in loc) // Yes, yes indeed you can FF benos with this
			to_chat(C, SPAN_DANGER("You've been struck by [src] from the ground!</span>"))
			var/limbs_to_pick = ALL_LIMBS - "head"
			var/obj/limb/affecting = C.get_limb(pick(limbs_to_pick))
			var/armor = 0
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				armor = H.getarmor_organ(affecting, ARMOR_MELEE)
			var/damage_result = armor_damage_reduction(GLOB.marine_melee, damage, armor, 0)
			C.apply_damage(damage_result, BRUTE, affecting, 0) // This should slicey dicey
			C.updatehealth()

		playsound(loc, strike_sound, 25, 1)

		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), 0.5 SECONDS)

#undef SUNKEN_COOLDOWN
#undef SUNKEN_MIN_RANGE
#undef SUNKEN_MAX_RANGE
#undef SUNKEN_DELAY_PER_RANGE
