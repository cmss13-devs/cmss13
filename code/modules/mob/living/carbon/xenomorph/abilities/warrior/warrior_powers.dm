/datum/action/xeno_action/activable/lunge/use_ability(atom/target_atom)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		if(twitch_message_cooldown < world.time )
			X.visible_message(SPAN_XENOWARNING("\The [X]'s claws twitch."), SPAN_XENOWARNING("Your claws twitch as you try to lunge but lack the strength. Wait a moment to try again."))
			twitch_message_cooldown = world.time + 5 SECONDS
		return //this gives a little feedback on why your lunge didn't hit other than the lunge button going grey. Plus, it might spook marines that almost got lunged if they know why the message appeared, and extra spookiness is always good.

	if (!target_atom)
		return

	if (!isturf(X.loc))
		to_chat(X, SPAN_XENOWARNING("You can't lunge from here!"))
		return

	if (!X.check_state() || X.agility)
		return

	if(X.can_not_harm(target_atom) || !ismob(target_atom))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/H = target_atom
	if(H.stat == DEAD)
		return

	if (!check_and_use_plasma_owner())
		return

	apply_cooldown()
	..()

	X.visible_message(SPAN_XENOWARNING("\The [X] lunges towards [H]!"), SPAN_XENOWARNING("You lunge at [H]!"))

	X.throw_atom(get_step_towards(target_atom, X), grab_range, SPEED_FAST, X)

	if (X.Adjacent(H))
		X.start_pulling(H,1)
	else
		X.visible_message(SPAN_XENOWARNING("\The [X]'s claws twitch."), SPAN_XENOWARNING("Your claws twitch as you lunge but are unable to grab onto your target. Wait a moment to try again."))

	return TRUE

/datum/action/xeno_action/onclick/toggle_agility/use_ability(atom/target_atom)
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


/datum/action/xeno_action/activable/fling/use_ability(atom/target_atom)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!isXenoOrHuman(target_atom) || X.can_not_harm(target_atom))
		return

	if (!X.check_state() || X.agility)
		return

	if (!X.Adjacent(target_atom))
		return

	var/mob/living/carbon/H = target_atom
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
	var/turf/var_turf = X.loc
	var/turf/temp = X.loc

	for (var/x in 0 to fling_distance-1)
		temp = get_step(var_turf, facing)
		if (!temp)
			break
		var_turf = temp

	H.throw_atom(var_turf, fling_distance, SPEED_VERY_FAST, X, TRUE)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/warrior_punch/use_ability(atom/target_atom)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!isXenoOrHuman(target_atom) || X.can_not_harm(target_atom))
		return

	if (!X.check_state() || X.agility)
		return

	var/distance = get_dist(X, target_atom)

	if (distance > 2)
		return

	var/mob/living/carbon/H = target_atom

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
			playsound(get_turf(H), 'sound/items/splintbreaks.ogg', 20)
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

/datum/action/xeno_action/activable/tail_stab/tail_trip/ability_act(var/mob/living/carbon/Xenomorph/stabbing_xeno, var/mob/living/carbon/target)

	stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] trips [target] with its tail!"), SPAN_XENOWARNING("You swipe your tail into [target]'s legs, tripping it!"))
	stabbing_xeno.spin_circle()
	stabbing_xeno.emote("tail")

	stabbing_xeno.animation_attack_on(target)
	stabbing_xeno.flick_attack_overlay(target, "disarm")

	target.apply_effect(trip_dur, WEAKEN)
	new /datum/effects/xeno_slow(target, stabbing_xeno, null, null, trip_dur * 2 SECONDS)

	shake_camera(target, 2, 1)

	return target

/datum/action/xeno_action/activable/pike/use_ability(atom/target_atom)
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

	var/facing = Get_Compass_Dir(zenomorf, target_atom)
	var/turf/var_turf = zenomorf.loc
	var/turf/temp = zenomorf.loc
	var/list/telegraph_atom_list = list()

	for (var/x in 1 to pike_len)
		temp = get_step(var_turf, facing)
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
			if(S.opacity || (istype(S, /obj/structure/barricade) && S.density))
				blocked = TRUE
				break
		if(blocked)
			break

		var_turf = temp

		if (var_turf in target_turfs)
			break

		facing = get_dir(var_turf, target_atom)
		target_turfs += var_turf
		if(x == pike_len && knight_delegate.abilities_enhanced == TRUE) //If we reach the last tile and are enhanced, apply unique effects.
			telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/silver(var_turf, 0.25 SECONDS)
		else
			var/obj/effect/xenomorph/xeno_telegraph/silver/telegraf = new(var_turf, 0.25 SECONDS)
			telegraf.color = knight_delegate.enhanced_color
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
		for (var/mob/living/carbon/carbone in target_turf)
			if (carbone.stat == DEAD || zenomorf.can_not_harm(carbone))
				continue

			if(knight_delegate.abilities_enhanced == TRUE && tile_count == pike_len)
				special_hit_targets |= carbone
			amount_of_targets |= carbone

	var/cd_mod = 1
	for(var/mob/living/carbon/carbone as anything in amount_of_targets)
		var/extra_dmg = 0
		if(carbone in special_hit_targets) // IF they hit a carbone in the special silver telegraph, deal a bit more damage and halve the ability's cd later on.
			extra_dmg = pike_damage * 0.5
			zenomorf.flick_attack_overlay(carbone, "tail")
			playsound(get_turf(carbone), "alien_bite", 30, TRUE)
			cd_mod = 0.5 // halve CD if they hit the final tile
		else
			zenomorf.flick_attack_overlay(carbone, "slash")
			playsound(get_turf(carbone), "alien_claw_flesh", 30, TRUE)
		carbone.apply_armoured_damage(pike_damage + extra_dmg, ARMOR_MELEE, BRUTE)

	apply_cooldown(cd_mod)
	..()
	return

#define ALPHA_SHIELD_FULL_ENHANCED 0.85
#define ALPHA_SHIELD_FULL 0.75
#define ALPHA_SHIELD_CRACKED 0.6
#define ALPHA_SHIELD_SHATTERED 0.55

/datum/action/xeno_action/onclick/bulwark/use_ability(atom/target_atom)
	var/mob/living/carbon/Xenomorph/Warrior/Knight = owner

	if (!action_cooldown_check())
		return

	if (!Knight.check_state())
		return

	if(Knight.mutation_type != WARRIOR_KNIGHT)
		return

	var/datum/behavior_delegate/warrior_knight/knight_delegate = Knight.behavior_delegate

	var/img_alpha_mult
	if(knight_delegate.abilities_enhanced)
		knight_delegate.clarity_stacks = 2
		img_alpha_mult = ALPHA_SHIELD_FULL_ENHANCED
		knight_delegate.current_color = knight_delegate.enhanced_color
		Knight.balloon_alert_to_viewers(SPAN_XENODANGER("[Knight] forms an enhanced defensive shell!"), SPAN_XENODANGER("You form an enhanced defensive shell!"), text_color = knight_delegate.current_color)
	else
		knight_delegate.clarity_stacks = 1
		knight_delegate.current_color = knight_delegate.un_enhanced_color
		img_alpha_mult = ALPHA_SHIELD_FULL
		Knight.balloon_alert_to_viewers(SPAN_XENODANGER("[Knight] forms a defensive shell!"), SPAN_XENODANGER("You form a defensive shell!"), text_color = knight_delegate.current_color)

	RegisterSignal(Knight, COMSIG_XENO_BULLET_ACT, PROC_REF(reduce_bullet_damage))
	RegisterSignal(Knight, list(COMSIG_LIVING_APPLY_EFFECT, COMSIG_LIVING_ADJUST_EFFECT, COMSIG_LIVING_SET_EFFECT), PROC_REF(reduce_stuns))
	RegisterSignal(Knight, COMSIG_ITEM_ATTEMPT_ATTACK, PROC_REF(resist_melee))
	button.icon_state = "template_active"
	button.color = knight_delegate.current_color
	current_shield_image = Knight.create_bulwark_image(img_alpha_mult, "full")
	addtimer(CALLBACK(src, PROC_REF(remove_shield), shield_duration))

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/bulwark/proc/reduce_bullet_damage(var/mob/xeno_byproduct_param, var/list/projectiledata)
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

/datum/action/xeno_action/onclick/bulwark/proc/reduce_stuns(var/mob/xeno_byproduct_param, var/effect_amount, var/effect_type, var/effect_flags)
	SIGNAL_HANDLER
	var/mob/living/carbon/Xenomorph/xeno = owner

	if(xeno.mutation_type != WARRIOR_KNIGHT)
		return

	// Effect checks: Needs to be a stun that immobilizes, needs to be above 0 (Won't absorb stun reduction!).
	if(!(effect_type in list(STUN, WEAKEN, PARALYZE)) || !(effect_amount > 0))
		return
	// Clarity check.
	if(shatter_shield())
		return COMPONENT_CANCEL_EFFECT
	else
		return


/datum/action/xeno_action/onclick/bulwark/proc/resist_melee(var/mob/Knight, var/mob/living/attacker, var/obj/item/hitting_item)
	SIGNAL_HANDLER
	attacker.animation_attack_on(Knight)
	attacker.flick_attack_overlay(Knight, "punch") //"shield"
	if(hitting_item.force < MELEE_FORCE_NORMAL)
		attacker.balloon_alert(attacker, "your attack bounces right off!")
		var/picked_attack_verb = pick(hitting_item.attack_verb)
		picked_attack_verb = deconjugate(picked_attack_verb)
		if(isnull(picked_attack_verb))
			picked_attack_verb = "attack"
		attacker.visible_message(SPAN_DANGER("[attacker] tries to [picked_attack_verb] [Knight] with \the [hitting_item], but the attack bounces right off its defensive shield!"),\
		SPAN_DANGER("You try to [picked_attack_verb] [Knight] with \the [hitting_item], but your attack bounces right off its defensive shield!"), message_flags = CHAT_TYPE_MELEE_HIT)
		return

	if(!shatter_shield())
		return
	return COMPONENT_CANCEL_ATTACK

/datum/action/xeno_action/onclick/bulwark/proc/shatter_shield()
	var/mob/living/carbon/Xenomorph/Warrior/Knight = owner
	var/datum/behavior_delegate/warrior_knight/knight_delegate = Knight.behavior_delegate
	if(!(knight_delegate.clarity_stacks > 0))
		return FALSE
	knight_delegate.clarity_stacks--
	if(knight_delegate.clarity_stacks)
		playsound(Knight, "ballistic_shield_hit", 25, TRUE)
		to_chat(Knight, SPAN_XENOWARNING("Your bulwark glows and cracks as you resist an attack. You have [knight_delegate.clarity_stacks] clarity left."))
		Knight.balloon_alert_to_viewers("the shell cracks!", "your shell cracks!", text_color = knight_delegate.current_color)
		Knight.create_bulwark_image(ALPHA_SHIELD_CRACKED, "cracked")
	else
		playsound(Knight, "shield_shatter", 25, TRUE)
		to_chat(Knight, SPAN_XENOWARNING("Your bulwark shatters you resist an attack! You have no clarity left."))
		Knight.balloon_alert_to_viewers("the shell shatters!", "your shell shatters!", text_color = knight_delegate.current_color)
		Knight.create_bulwark_image(ALPHA_SHIELD_SHATTERED, "shattered")
	return TRUE

#define X_HEAD_LAYER			9

/datum/action/xeno_action/onclick/bulwark/proc/remove_shield()
	var/mob/living/carbon/Xenomorph/xeno = owner

	if(xeno.mutation_type != WARRIOR_KNIGHT)
		return

	var/datum/behavior_delegate/warrior_knight/knight_delegate = xeno.behavior_delegate

	knight_delegate.clarity_stacks = 0

	button.icon_state = "template"

	xeno.remove_head_layer()
	qdel(current_shield_image)

	UnregisterSignal(xeno, COMSIG_XENO_BULLET_ACT)
	UnregisterSignal(xeno, list(COMSIG_LIVING_APPLY_EFFECT, COMSIG_LIVING_ADJUST_EFFECT, COMSIG_LIVING_SET_EFFECT))
	UnregisterSignal(xeno, COMSIG_ITEM_ATTEMPT_ATTACK)

	to_chat(xeno, SPAN_XENODANGER("You feel your defensive shell dissipate!"))
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
		knight_delegate.owned = FALSE
		if(knight_delegate.abilities_enhanced)
			zenomorf.visible_message(SPAN_XENODANGER("The [zenomorf] slams directly onto [L], stunning and throwing them back!"), SPAN_XENODANGER("You slam directly onto [L], stunning and throwing them back!"))
			L.apply_effect(leap_knock_dur, WEAKEN)
			L.apply_armoured_damage(get_xeno_damage_slash(L, zenomorf.melee_damage_upper), ARMOR_MELEE, BRUTE)
			xeno_throw_human(L, zenomorf, zenomorf.dir, 2)
		else
			zenomorf.visible_message(SPAN_XENODANGER("The [zenomorf] leaps directly onto [L], throwing them back!"), SPAN_XENODANGER("You leap directly onto [L], throwing them back!"))
			L.apply_armoured_damage(get_xeno_damage_slash(L, zenomorf.melee_damage_lower), ARMOR_MELEE, BRUTE)
			xeno_throw_human(L, zenomorf, zenomorf.dir, 1)
		if(isXeno(L))
			L.emote("roar")
		else
			L.emote("scream")
		knockdown = FALSE
	return
