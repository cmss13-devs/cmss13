/datum/action/human_action/activable/synth_bracer/rescue_hook
	name = "Rescue Hook"
	action_icon_state = "hook"
	cooldown = 5 SECONDS
	charge_cost = 65

	handles_cooldown = TRUE
	handles_charge_cost = TRUE

	// Config
	var/max_distance = 3
	var/windup = 10
	human_adaptable = TRUE
	ability_tag = SIMI_SECONDARY_HOOK

/datum/action/human_action/activable/synth_bracer/rescue_hook/use_ability(atom/atom_target)
	. = ..()
	if(!.)
		return FALSE

	if(!atom_target || atom_target.layer >= FLY_LAYER || !isturf(synth.loc))
		return FALSE

	if(!action_cooldown_check() || synth.action_busy)
		return FALSE

	set_active(category, ability_tag)
	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(synth, atom_target)
	var/turf/T = synth.loc
	var/turf/temp = synth.loc
	for(var/x in 0 to max_distance)
		temp = get_step(T, facing)
		if(facing in GLOB.diagonals) // check if it goes through corners
			var/reverse_face = GLOB.reverse_dir[facing]
			var/turf/back_left = get_step(temp, turn(reverse_face, 45))
			var/turf/back_right = get_step(temp, turn(reverse_face, -45))
			if((!back_left || back_left.density) && (!back_right || back_right.density))
				break
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in temp)
			if(S.opacity || ((istype(S, /obj/structure/barricade) || istype(S, /obj/structure/machinery/door)) && S.density))
				blocked = TRUE
				break
		if(blocked)
			break

		T = temp

		if (T in turflist)
			break

		turflist += T
		facing = get_dir(T, atom_target)
		telegraph_atom_list += new /obj/effect/simi_hook(T, windup)

	if(!length(turflist))
		to_chat(synth, SPAN_WARNING("You don't have any room to launch your hook!"))
		set_inactive(category)
		return FALSE

	synth.visible_message(SPAN_DANGER("[synth] prepares to launch a rescue hook at [atom_target]!"), SPAN_DANGER("You prepare to launch a rescue hook at [atom_target]!"))

	var/throw_target_turf = get_step(synth.loc, facing)
	var/pre_frozen = FALSE
	if(HAS_TRAIT(synth, TRAIT_IMMOBILIZED))
		pre_frozen = TRUE
	else
		ADD_TRAIT(synth, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_HANDS))
	if(!do_after(synth, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, null, null, FALSE, 1, FALSE, 1))
		to_chat(synth, SPAN_WARNING("You cancel your launch."))

		for (var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
			telegraph_atom_list -= XT
			qdel(XT)
		if(!pre_frozen)
			REMOVE_TRAIT(synth, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_HANDS))
		set_inactive(category)

		return FALSE

	enter_cooldown()
	synth_bracer.drain_charge(synth, charge_cost)

	if(!pre_frozen)
		REMOVE_TRAIT(synth, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_HANDS))

	playsound(get_turf(synth), 'sound/items/rappel.ogg', 75, FALSE)

	var/mob/living/carbon/human/marine_target
	for(var/turf/target_turf in turflist)
		for(var/mob/living/carbon/human/marine in target_turf)
			marine_target = marine
			continue

	if(marine_target)
		to_chat(marine_target, SPAN_DANGER("You are pulled towards [synth]!"))
		marine_target.KnockDown(0.2)
		shake_camera(marine_target, 10, 1)
		marine_target.throw_atom(throw_target_turf, get_dist(throw_target_turf, marine_target)-1, SPEED_VERY_FAST)
	set_inactive(category)

/obj/effect/simi_hook
	icon = 'icons/obj/items/synth/bracer.dmi'
	icon_state = "holo_hook_telegraph_anim"

/obj/effect/simi_hook/Initialize(mapload, ttl = 1 SECONDS)
	. = ..()
	QDEL_IN(src, ttl)
