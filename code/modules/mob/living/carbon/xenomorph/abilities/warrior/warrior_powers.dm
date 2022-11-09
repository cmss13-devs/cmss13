/datum/action/xeno_action/activable/lunge/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		if(twitch_message_cooldown < world.time )
			X.visible_message(SPAN_XENOWARNING("\The [X]'s claws twitch."), SPAN_XENOWARNING("Your claws twitch as you try to lunge but lack the strength. Wait a moment to try again."))
			twitch_message_cooldown = world.time + 5 SECONDS
		return //this gives a little feedback on why your lunge didn't hit other than the lunge button going grey. Plus, it might spook marines that almost got lunged if they know why the message appeared, and extra spookiness is always good.

	if (!A)
		return

	if (!isturf(X.loc))
		to_chat(X, SPAN_XENOWARNING("You can't lunge from here!"))
		return

	if (!X.check_state() || X.agility)
		return

	if(X.can_not_harm(A) || !ismob(A))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/H = A
	if(H.stat == DEAD)
		return

	if (!check_and_use_plasma_owner())
		return

	apply_cooldown()
	..()

	X.visible_message(SPAN_XENOWARNING("\The [X] lunges towards [H]!"), SPAN_XENOWARNING("You lunge at [H]!"))

	X.throw_atom(get_step_towards(A, X), grab_range, SPEED_FAST, X)

	if (X.Adjacent(H))
		X.start_pulling(H,1)
	else
		X.visible_message(SPAN_XENOWARNING("\The [X]'s claws twitch."), SPAN_XENOWARNING("Your claws twitch as you lunge but are unable to grab onto your target. Wait a moment to try again."))

	return TRUE

/datum/action/xeno_action/onclick/toggle_agility/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!X.check_state(1))
		return

	X.agility = !X.agility
	if (X.agility)
		to_chat(X, SPAN_XENOWARNING("You lower yourself to all fours."))
	else
		to_chat(X, SPAN_XENOWARNING("You raise yourself to stand on two feet."))
	X.update_icons()

	apply_cooldown()
	..()


/datum/action/xeno_action/activable/fling/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!isXenoOrHuman(A) || X.can_not_harm(A))
		return

	if (!X.check_state() || X.agility)
		return

	if (!X.Adjacent(A))
		return

	var/mob/living/carbon/H = A
	if(H.stat == DEAD) return
	if(HAS_TRAIT(H, TRAIT_NESTED))
		return

	if(H == X.pulling)
		X.stop_pulling()

	if(H.mob_size >= MOB_SIZE_BIG)
		to_chat(X, SPAN_XENOWARNING("[H] is too big for you to fling!"))
		return

	if (!check_and_use_plasma_owner())
		return

	X.visible_message(SPAN_XENOWARNING("\The [X] effortlessly flings [H] to the side!"), SPAN_XENOWARNING("You effortlessly fling [H] to the side!"))
	playsound(H,'sound/weapons/alien_claw_block.ogg', 75, 1)
	if(stun_power)
		H.apply_effect(get_xeno_stun_duration(H, stun_power), STUN)
	if(weaken_power)
		H.apply_effect(weaken_power, WEAKEN)
	if(slowdown)
		if(H.slowed < slowdown)
			H.apply_effect(slowdown, SLOW)
	H.last_damage_data = create_cause_data(initial(X.caste_type), X)
	shake_camera(H, 2, 1)

	var/facing = get_dir(X, H)
	var/turf/T = X.loc
	var/turf/temp = X.loc

	for (var/x in 0 to fling_distance-1)
		temp = get_step(T, facing)
		if (!temp)
			break
		T = temp

	H.throw_atom(T, fling_distance, SPEED_VERY_FAST, X, TRUE)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/warrior_punch/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!isXenoOrHuman(A) || X.can_not_harm(A))
		return

	if (!X.check_state() || X.agility)
		return

	var/distance = get_dist(X, A)

	if (distance > 2)
		return

	var/mob/living/carbon/H = A

	if (!X.Adjacent(H))
		return

	if(H.stat == DEAD) return
	if(HAS_TRAIT(H, TRAIT_NESTED)) return

	var/obj/limb/L = H.get_limb(check_zone(X.zone_selected))

	if (ishuman(H) && (!L || (L.status & LIMB_DESTROYED)))
		return


	if (!check_and_use_plasma_owner())
		return

	H.last_damage_data = create_cause_data(initial(X.caste_type), X)

	X.visible_message(SPAN_XENOWARNING("\The [X] hits [H] in the [L? L.display_name : "chest"] with a devastatingly powerful punch!"), \
	SPAN_XENOWARNING("You hit [H] in the [L? L.display_name : "chest"] with a devastatingly powerful punch!"))
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)
	do_base_warrior_punch(H, L)
	apply_cooldown()
	..()

/datum/action/xeno_action/activable/warrior_punch/proc/do_base_warrior_punch(mob/living/carbon/H, obj/limb/L)
	var/mob/living/carbon/Xenomorph/X = owner
	var/damage = rand(base_damage, base_damage + damage_variance)

	if(ishuman(H))
		if((L.status & LIMB_SPLINTED) && !(L.status & LIMB_SPLINTED_INDESTRUCTIBLE)) //If they have it splinted, the splint won't hold.
			L.status &= ~LIMB_SPLINTED
			playsound(get_turf(H), 'sound/items/splintbreaks.ogg')
			to_chat(H, SPAN_DANGER("The splint on your [L.display_name] comes apart!"))
			H.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)

		if(isHumanStrict(H))
			H.apply_effect(3, SLOW)
		if(isYautja(H))
			damage = rand(base_punch_damage_pred, base_punch_damage_pred + damage_variance)
		else if(L.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			damage = rand(base_punch_damage_synth, base_punch_damage_synth + damage_variance)


	H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE, L? L.name : "chest")

	shake_camera(H, 2, 1)
	step_away(H, X, 2)

/datum/action/xeno_action/activable/pike/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/zenomorf = owner

	if (!action_cooldown_check())
		return

	if (!zenomorf.check_state())
		return

	if(zenomorf.mutation_type != WARRIOR_KNIGHT)
		return

	var/datum/behavior_delegate/warrior_knight/knight_delegate = zenomorf.behavior_delegate

	// Get line of turfs
	var/list/turf/target_turfs = list()

	var/facing = Get_Compass_Dir(zenomorf, A)
	var/turf/T = zenomorf.loc
	var/turf/temp = zenomorf.loc
	var/list/telegraph_atom_list = list()

	for (var/x in 1 to pike_len) // 0 actually adds an extra tile - funny bug that is now a feature for the other 'reach' abilities.
		temp = get_step(T, facing)
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in temp)
			if(istype(S, /obj/structure/window/framed))
				var/obj/structure/window/framed/W = S
				if(!W.unslashable)
					W.shatter_window(TRUE)

			if(S.opacity)
				blocked = TRUE
				break
		if(blocked)
			break

		T = temp
		target_turfs += T
		if(x == pike_len && knight_delegate.abilities_enhanced == TRUE) //If we reach the last tile and are enhanced, apply unique effects.
			telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/silver(T, 0.25 SECONDS)
		else
			var/obj/effect/xenomorph/xeno_telegraph/silver/telegraf = new(T, 0.25 SECONDS)
			telegraf.color = "#4ADBC1"
			telegraph_atom_list += telegraf

	// Extract our 'optimal' turf, if it exists
	if (target_turfs.len >= 2)
		zenomorf.animation_attack_on(target_turfs[target_turfs.len], 15)

	zenomorf.visible_message(SPAN_XENODANGER("[zenomorf] quickly uncoils its tail to attack in front of it!"), SPAN_XENODANGER("You quickly uncoil your tail, attacking in front of you!"))
	zenomorf.emote("tail")

	// Loop through our turfs, finding any carbones there and dealing damage to them
	var/list/mob/living/carbon/amount_of_targets = list()
	var/list/mob/living/carbon/special_hit_targets = list()
	var/tile_count
	for (var/turf/target_turf as anything in target_turfs)
		tile_count++
		for (var/mob/living/carbon/C in target_turf)
			if (C.stat == DEAD || zenomorf.can_not_harm(C))
				continue

			if(knight_delegate.abilities_enhanced == TRUE && tile_count == pike_len)
				special_hit_targets |= C
			amount_of_targets |= C

	var/cd_mod = 1
	for(var/mob/living/carbon/C as anything in amount_of_targets)
		var/bonus = length(amount_of_targets)
		var/bonus_max = 3
		var/bonus_dmg = 10
		if(C in special_hit_targets) // IF they hit a carbone in the special silver telegraph, gain +1 to 'bonus' and halve the ability's cd later on.
			bonus++
			bonus_max++
			zenomorf.flick_attack_overlay(C, "tail")
			playsound(get_turf(C), "alien_bite", 30, TRUE)
			cd_mod = 0.5 // halve CD if they hit the final tile
		else
			zenomorf.flick_attack_overlay(C, "slash")
			playsound(get_turf(C), "alien_claw_flesh", 30, TRUE)
		var/extra_dmg = bonus_dmg * max(bonus_max, bonus - 1) // 1 - 0 bonus dmg / 2 - 10 bonus dmg / 3 - 20 bonus dmg / ENHANCED 4 - 30 bonus dmg. I don't expect any of these to be common, but it's soulful and immersive*
		C.apply_armoured_damage(pike_damage + extra_dmg, ARMOR_MELEE, BRUTE)
		switch(bonus)
			if(1)
				new /datum/effects/xeno_slow(C, zenomorf, ttl = slow_dur)
			if(2)
				new /datum/effects/xeno_slow/superslow(C, zenomorf, ttl = sslow_dur)
//			if(3 to INF)
//				new /datum/effects/boiler_trap(C, zenomorf, ttl = paralyze_dur) BLUH.
			if(3 to INFINITY)
				C.frozen = TRUE
				C.update_canmove()
				if (ishuman(C))
					var/mob/living/carbon/human/Hu = C
					Hu.update_xeno_hostile_hud()

				addtimer(CALLBACK(GLOBAL_PROC, .proc/unroot_human, C), paralyze_dur)


	apply_cooldown(cd_mod)
	..()
	return

/datum/action/xeno_action/onclick/bulwark/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if(xeno.mutation_type != WARRIOR_KNIGHT)
		return

	var/datum/behavior_delegate/warrior_knight/knight_delegate = xeno.behavior_delegate

	var/img_color
	if(knight_delegate.abilities_enhanced)
		knight_delegate.clarity_stacks = 3
		xeno.visible_message(SPAN_XENODANGER("[xeno] forms an enhanced defensive shell!"), SPAN_XENODANGER("You form an enhanced defensive shell!"))
		img_color = "#FFFFFF"
	else
		knight_delegate.clarity_stacks = 1
		xeno.visible_message(SPAN_XENODANGER("[xeno] forms a defensive shell!"), SPAN_XENODANGER("You form a defensive shell!"))
		img_color = "#4ADBC1"

	RegisterSignal(xeno, COMSIG_XENO_BULLET_ACT, .proc/reduce_damage)
	RegisterSignal(xeno, list(COMSIG_MOB_APPLY_EFFECT, COMSIG_MOB_ADJUST_EFFECT, COMSIG_MOB_SET_EFFECT), .proc/reduce_stuns)

	button.icon_state = "template_active"
	button.color = img_color
	xeno.create_custom_shield_image(dmg_reduc_duration, img_color, alpha_mult = 0.85)
	addtimer(CALLBACK(src, .proc/remove_shield), dmg_reduc_duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/bulwark/proc/reduce_damage(var/mob/xeno_byproduct_param, var/list/projectiledata)
	SIGNAL_HANDLER
	var/mob/living/carbon/Xenomorph/zenomorf = owner

	if(zenomorf.mutation_type != WARRIOR_KNIGHT) //why do we need these checks again? it's not like it wouldnt be a bug that needs looking into if they didnt exist. if anything this removes helpful runtimes
		return

	var/datum/behavior_delegate/warrior_knight/knight_delegate = zenomorf.behavior_delegate

	if(projectiledata["ammo_flags"] & AMMO_DIRECT_HIT)
		return
	else if(knight_delegate.abilities_enhanced)
		projectiledata["damage_result"] *= enhanced_damage_reduction
	else
		projectiledata["damage_result"] *= normal_damage_reduction

/datum/action/xeno_action/onclick/bulwark/proc/reduce_stuns(var/mob/xeno_byproduct_param, var/effect_amount, var/effect_type, var/effect_forced)
	SIGNAL_HANDLER
	var/mob/living/carbon/Xenomorph/xeno = owner

	if(xeno.mutation_type != WARRIOR_KNIGHT)
		return

	var/datum/behavior_delegate/warrior_knight/knight_delegate = xeno.behavior_delegate

	// Effect checks: Needs to be a stun that immobilizes, needs to not be forced, needs to be above 0.
	if(!(effect_type in list(STUN, WEAKEN, PARALYZE)) || effect_forced || !(effect_amount > 0))
		return
	// Clarity check.
	if(!(knight_delegate.clarity_stacks > 0))
		return
	knight_delegate.clarity_stacks--
	if(knight_delegate.clarity_stacks)
		playsound(xeno, "ballistic_shield_hit", 25, TRUE)
		to_chat(xeno, SPAN_XENOWARNING("Your bulwark glows and faintly cracks as you resist an attack. You have [knight_delegate.clarity_stacks] clarity left."))
	else
		playsound(xeno, "shield_shatter", 25, TRUE)
		to_chat(xeno, SPAN_XENOWARNING("Your bulwark shatters you resist an attack! You have no clarity left."))
	return COMPONENT_CANCEL_EFFECT

/datum/action/xeno_action/onclick/bulwark/proc/remove_shield()
	var/mob/living/carbon/Xenomorph/xeno = owner

	if(xeno.mutation_type != WARRIOR_KNIGHT)
		return

	var/datum/behavior_delegate/warrior_knight/knight_delegate = xeno.behavior_delegate

	knight_delegate.clarity_stacks = 0

	button.icon_state = "template"

	UnregisterSignal(xeno, COMSIG_XENO_BULLET_ACT)
	UnregisterSignal(xeno, list(COMSIG_MOB_APPLY_EFFECT, COMSIG_MOB_ADJUST_EFFECT, COMSIG_MOB_SET_EFFECT))

	to_chat(xeno, SPAN_XENODANGER("You feel your defensive shell dissipate!"))
	xeno.overlay_shields()
	return

	// this is seriously the only thing i could think of. i hate pounce code!!
/datum/action/xeno_action/activable/pounce/leap/use_ability(atom/t_atom)
	pounce_to = t_atom
	pounce_from = get_turf(owner)
	..()

/datum/action/xeno_action/activable/pounce/leap/pre_pounce_additional_effects(mob/living/L)
	var/mob/living/carbon/Xenomorph/zenomorf = owner

	if(zenomorf.mutation_type != WARRIOR_KNIGHT)
		return

	var/datum/behavior_delegate/warrior_knight/knight_delegate = zenomorf.behavior_delegate

	//credit - tmtmtl30 and coderbus
	if(get_dist(pounce_from, pounce_to) == 2) //ensuring it's at the proper distance
		//getting the absolute distance of both values (2 - 4 = -2 into 2)
		var/to_x = abs(pounce_to.x - pounce_from.x)
		var/from_y = abs(pounce_to.y - pounce_from.y)

		//ensure neither are 0 (as that would be a straight line) or identical (as that would be a clean diagonal)
		if(to_x && from_y && (to_x != from_y) && \
		//then make sure we're targeting the mob or its turf directly, otherwise we could aim an L-leap colliding with someone diagonally next to us and own them
		(ismob(pounce_to) || locate(/mob/living) in get_turf(pounce_to)))
			//and now we have a knight leap!
			knight_delegate.owned = TRUE //followed up on in the next proc
			knockdown = TRUE

/datum/action/xeno_action/activable/pounce/leap/post_pounce_additional_effects(mob/living/L)
	var/mob/living/carbon/Xenomorph/zenomorf = owner

	if(zenomorf.mutation_type != WARRIOR_KNIGHT)
		return

	var/datum/behavior_delegate/warrior_knight/knight_delegate = zenomorf.behavior_delegate

	if(knight_delegate.owned)
		playsound(get_turf(zenomorf), 'sound/effects/bang.ogg', 25, FALSE)
		zenomorf.create_stomp()
		zenomorf.visible_message(SPAN_XENODANGER("The [zenomorf] slams directly on top of [L], stomping on them heavily!"), SPAN_XENODANGER("You use your shield to bash [L] as you charge at them!"))
		L.apply_armoured_damage(rand(zenomorf.melee_damage_lower, zenomorf.melee_damage_upper) * 2, ARMOR_MELEE, BRUTE)
		L.apply_effect(3, WEAKEN)
		knight_delegate.owned = FALSE

		L.apply_effect(leap_knock_dur, WEAKEN)
		new /datum/effects/xeno_slow(L, zenomorf, ttl = leap_slow_dur)
		knockdown = FALSE
	return

/datum/action/xeno_action/activable/plant_holdfast/use_ability(atom/t_atom)
	var/mob/living/carbon/Xenomorph/zenomorf = owner
	if(!action_cooldown_check())
		return
	if(!zenomorf.check_state())
		return

	if(zenomorf.mutation_type != WARRIOR_KNIGHT)
		return

	var/datum/behavior_delegate/warrior_knight/knight_delegate = zenomorf.behavior_delegate

	if(knight_delegate.bound_node)
		to_chat(zenomorf, SPAN_WARNING("You've already placed a holdfast node. Destroy it?"))
		//var/answer = tgui_input_list(zenomorf, "Destroy your current holdfast node?", "Select", list("Yes", "No"), theme = "hive_status")
		var/answer = tgui_alert(zenomorf, "This message will self-destruct in three seconds", "Destroy your current holdfast node?", list("Yes", "No"), 3 SECONDS)
		if(answer == "Yes")
			QDEL_NULL(knight_delegate.bound_node)
		return

	if(get_dist(t_atom, zenomorf) > 1)
		to_chat(zenomorf, SPAN_WARNING("That's too far away! It must be next to you."))
		return

	var/turf/t_turf = get_turf(t_atom)

	if(!istype(t_turf))
		to_chat(zenomorf, SPAN_WARNING("You can't place a holdfast node on \the [t_atom]!"))
		return

	var/obj/effect/alien/weeds/t_weeds = locate() in t_turf
	if(!t_weeds)
		to_chat(zenomorf, SPAN_WARNING("You need weeds to place your node."))
		return

	if(!do_after(zenomorf, 1.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_BUILD))
		return

	zenomorf.apply_damage(zenomorf.health * 0.25) //immersive
	knight_delegate.bound_node = new(t_turf, zenomorf.hive)
	knight_delegate.bound_node.bound_knight = zenomorf

	playsound(zenomorf.loc, 'sound/effects/splat.ogg', 25, TRUE)
	zenomorf.visible_message(SPAN_XENONOTICE("\The [zenomorf] coughs up and regurgitates an eerie pillar and plants it on the ground!"), \
	SPAN_XENONOTICE("You cough up and regurgitate a holdfast node, giving some of yourself to the hive. It will weakly heal others and boost your abilities if nearby."), null, 5)

	apply_cooldown()

	..()
	return
