/datum/action/human_action/activable/synth_bracer/rescue_hook
	name = "Rescue Hook"
	action_icon_state = "hook"
	cooldown = 5 SECONDS
	charge_cost = 90

	handles_cooldown = TRUE
	handles_charge_cost = TRUE

	// Config
	var/max_distance = 3
	var/windup = 8

/datum/action/human_action/activable/synth_bracer/rescue_hook/use_ability(atom/atom_target)
	. = ..()
	if(!.)
		return FALSE

	if(!atom_target || atom_target.layer >= FLY_LAYER || !isturf(synth.loc))
		return FALSE

	if(!action_cooldown_check() || synth.action_busy)
		return FALSE

	synth_bracer.active_utility = SIMI_SECONDARY_HOOK
	synth_bracer.update_icon()
	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(synth, atom_target)
	var/turf/T = synth.loc
	var/turf/temp = synth.loc
	for(var/x in 0 to max_distance)
		temp = get_step(T, facing)
		if(facing in diagonals) // check if it goes through corners
			var/reverse_face = reverse_dir[facing]
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
		return FALSE

	synth.visible_message(SPAN_DANGER("[synth] prepares to launch a rescue hook at [atom_target]!"), SPAN_DANGER("You prepare to launch a rescue hook at [atom_target]!"))

	var/throw_target_turf = get_step(synth.loc, facing)

	synth.frozen = TRUE
	synth.update_canmove()
	if(!do_after(synth, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, null, null, FALSE, 1, FALSE, 1))
		to_chat(synth, SPAN_WARNING("You cancel your launch."))

		for (var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
			telegraph_atom_list -= XT
			qdel(XT)

		synth.frozen = FALSE
		synth.update_canmove()
		synth_bracer.active_utility = SIMI_ACTIVE_NONE
		synth_bracer.update_icon()

		return FALSE

	enter_cooldown()
	synth_bracer.drain_charge(synth, charge_cost)

	synth.frozen = FALSE
	synth.update_canmove()

	playsound(get_turf(synth), 'sound/effects/bang.ogg', 25, 0)

	var/mob/living/carbon/human/marine_target
	if(ishuman(atom_target))
		marine_target = atom_target
	else
		for(var/turf/target_turf in turflist)
			for(var/mob/living/carbon/human/marine in target_turf)
				marine_target = marine
				continue

	if(marine_target)
		to_chat(marine_target, SPAN_DANGER("You are pulled towards [synth]!"))
		marine_target.KnockDown(0.2)
		shake_camera(marine_target, 10, 1)
		marine_target.throw_atom(throw_target_turf, get_dist(throw_target_turf, marine_target)-1, SPEED_VERY_FAST)
	synth_bracer.active_utility = SIMI_ACTIVE_NONE
	synth_bracer.update_icon()

/obj/effect/simi_hook
	icon = 'icons/obj/items/synth/bracer.dmi'
	icon_state = "holo_hook_telegraph_anim"

/obj/effect/simi_hook/New(loc, ttl = 10)
	..(loc)
	QDEL_IN(src, ttl)
