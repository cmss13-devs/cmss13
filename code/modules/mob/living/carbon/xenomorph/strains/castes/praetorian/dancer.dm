/datum/xeno_strain/dancer
	// My name is Cuban Pete, I'm the King of the Rumba Beat
	name = PRAETORIAN_DANCER
	description = "You lose all acid-based abilities and a small amount of your armor in exchange for increased movement speed, evasion, and unparalleled agility. This strain excels at rapid repositioning, bullet dodging, and phasing effortlessly through enemies and allies alike. Slashing enemies applies a red tag, altering how your tail abilities function. Tagged enemies cause Impale to strike twice and transform Tail Trip into a powerful knockdown instead of a brief stun. Your new Tail Stab adapts to your intent. When used in Disarm mode, it becomes a Blunt, armor-piercing strike. When enemies are brought close to death, yellow tags will spread to nearby foes. Slashing yellow-tagged enemies reduces the cooldown of your tail abilities, and using a tail trip or impale ability on a yellow-tagged target grants no cooldown penalty."
	flavor_description = "A performance fit for a Queen, this one will become my instrument of death."
	icon_state_prefix = "Dancer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/xeno_spit/praetorian,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab/harpoon_tail,
		/datum/action/xeno_action/activable/prae_impale,
		/datum/action/xeno_action/onclick/prae_dodge,
		/datum/action/xeno_action/activable/prae_tail_trip,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_dancer

/datum/xeno_strain/dancer/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.armor_modifier -= XENO_ARMOR_MOD_VERY_SMALL
	prae.speed_modifier += XENO_SPEED_FASTMOD_TIER_5
	prae.regeneration_multiplier = XENO_REGEN_MULTIPLIER_TIER_7
	prae.plasma_types = list(PLASMA_CATECHOLAMINE)
	prae.claw_type = CLAW_TYPE_SHARP
	prae.dodge_threshold = 6
	prae.received_phero_caps["recovery"] = 3 //need to be limited, regens too fast with high strength phermones.

	prae.recalculate_everything()

#define DANCER_YELLOW_TAG_SPREAD_DURATION 7 SECONDS
#define DANCER_YELLOW_TAG_SPREAD_CD 20 SECONDS
#define DANCER_YELLOW_TAG_SPREAD_DIST 5
#define DANCER_TAG_SPREAD_COUNT 5

/datum/behavior_delegate/praetorian_dancer
	name = "Praetorian Dancer Behavior Delegate"

	/// How much time is left on timer. (used for status)
	var/time_left = null

	/// Timer to prevent dancer from spreading yellow tags.
	var/last_dancer_spread_time = 0

/datum/behavior_delegate/praetorian_dancer/append_to_stat()
	. = list()
	. += "Guaranteed Dodge every [bound_xeno.dodge_threshold] bullet\s."
	. += "Yellow Tag Spread Delay: 5 seconds."

	var/datum/action/xeno_action/activable/tail_stab/harpoon_tail/harpoon_action = get_action(bound_xeno, /datum/action/xeno_action/activable/tail_stab/harpoon_tail)
	harpoon_action.intent_detection()
	. += "Tail Lance Intent: [harpoon_action.tail_mode]"
	if(harpoon_action.tail_mode == "Blunt")
		. += "Damage: [harpoon_action.blunt_damage] AP"
		. += "Cooldown: 3 seconds."

	var/datum/action/xeno_action/onclick/prae_dodge/dodge_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/prae_dodge)
	if(dodge_action.dodge_start_time != -1)
		time_left = (DANCER_DODGE_TIME - (world.time - dodge_action.dodge_start_time)) / 10
		. += "Dodge Remaining: [time_left] second\s."
		return

/datum/behavior_delegate/praetorian_dancer/melee_attack_additional_effects_self()
	..()

	if(!HAS_TRAIT(bound_xeno, TRAIT_ABILITY_YELLOW_TAG))
		return

	REMOVE_TRAIT(bound_xeno, TRAIT_ABILITY_YELLOW_TAG, TRAIT_SOURCE_ABILITY("yellow_tag"))

	var/datum/action/xeno_action/activable/prae_impale/impale_action = get_action(bound_xeno, /datum/action/xeno_action/activable/prae_impale)
	if(!impale_action.action_cooldown_check())
		impale_action.apply_cooldown_override()

	var/datum/action/xeno_action/activable/prae_tail_trip/tail_trip_action = get_action(bound_xeno, /datum/action/xeno_action/activable/prae_tail_trip)
	if(!tail_trip_action.action_cooldown_check())
		tail_trip_action.apply_cooldown_override()

/datum/behavior_delegate/praetorian_dancer/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if(!isxeno_human(target_carbon))
		return

	// Clean up all tags to 'refresh' our TTL
	for(var/datum/effects/dancer_tag/normal/target_tag in target_carbon.effects_list)
		qdel(target_tag)

	new /datum/effects/dancer_tag/normal(target_carbon, bound_xeno, , , 35)

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/target_human = target_carbon
		target_human.update_xeno_hostile_hud()

	var/consumed_spread = FALSE
	for(var/datum/effects/dancer_tag/spread/spread_tag in target_carbon.effects_list)
		qdel(spread_tag)
		consumed_spread = TRUE
		break

	if(consumed_spread)
		ADD_TRAIT(bound_xeno, TRAIT_ABILITY_YELLOW_TAG, TRAIT_SOURCE_ABILITY("yellow_tag"))

	if(target_carbon.health <= 0)
		try_spread_tags_from(target_carbon)

/datum/behavior_delegate/praetorian_dancer/proc/try_spread_tags_from(mob/living/carbon/human/target_human)
	if(!ishuman(target_human))
		return

	var/turf/origin = get_turf(target_human)
	if(!origin)
		return

	if(world.time < last_dancer_spread_time + DANCER_YELLOW_TAG_SPREAD_DURATION)
		return

	if(world.time < target_human.last_target_spread_time + DANCER_YELLOW_TAG_SPREAD_CD)
		return
	target_human.last_target_spread_time = world.time

	var/spread_count = 0

	for(var/mob/living/carbon/human/human_target in view(DANCER_YELLOW_TAG_SPREAD_DIST))
		if(human_target == target_human)
			continue
		if(human_target.stat == DEAD || human_target.stat == UNCONSCIOUS)
			continue
		if(locate(/datum/effects/dancer_tag) in human_target.effects_list)
			continue

		new /datum/effects/dancer_tag/spread(human_target, bound_xeno)
		human_target.update_xeno_hostile_hud()
		spread_count++

		if(spread_count >= DANCER_TAG_SPREAD_COUNT)
			break

	if(spread_count)
		last_dancer_spread_time = world.time

	if(spread_count >= 0)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("Fear spreads among the prey, their weakness fuels your instincts to strike them down!"))



/datum/action/xeno_action/activable/tail_stab/harpoon_tail/ability_act(mob/living/carbon/xenomorph/xeno, mob/living/carbon/target_carbon, obj/limb/limb)
	if(!istype(xeno) || !istype(target_carbon))
		return

	if(xeno.a_intent == INTENT_DISARM)
		target_carbon.last_damage_data = create_cause_data(initial(xeno.caste_type), xeno)

		xeno.visible_message(
			SPAN_XENOWARNING("[xeno] smash [target_carbon] with flat side of its tail!"),
			SPAN_XENOWARNING("We smash [target_carbon] with flat side of our tail!")
		)
		xeno.animation_attack_on(target_carbon)
		xeno.flick_attack_overlay(target_carbon, "slam")

		if(xeno.behavior_delegate)
			xeno.behavior_delegate.melee_attack_additional_effects_target(target_carbon)

		playsound(target_carbon, "punch", 25, TRUE)
		target_carbon.apply_damage(blunt_damage, BRUTE, "chest")
		apply_cooldown(cooldown_modifier = 0.3)
		update_button_icon()
		return target_carbon

	return ..()

/datum/action/xeno_action/activable/tail_stab/harpoon_tail/proc/intent_detection()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno && xeno.a_intent == INTENT_DISARM)
		tail_mode = "Blunt"
	else
		tail_mode = "Normal"




/datum/action/xeno_action/activable/prae_impale/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	XENO_ACTION_CHECK(dancer_user)

	if(!ismob(target_atom))
		apply_cooldown_override(impale_click_miss_cooldown)
		update_button_icon()
		return

	if(!isxeno_human(target_atom) || dancer_user.can_not_harm(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("We must target a hostile!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if(target_carbon.stat == DEAD)
		to_chat(dancer_user, SPAN_XENOWARNING("[target_atom] is dead, why would we want to attack it?"))
		return

	var/dist = get_dist(dancer_user, target_carbon)

	if(dist > range)
		to_chat(dancer_user, SPAN_WARNING("[target_carbon] is too far away!"))
		return

	if(dist > 1)
		var/turf/target_turf = get_step(dancer_user, get_dir(dancer_user, target_carbon))
		if(target_turf.density)
			to_chat(dancer_user, SPAN_WARNING("We can't attack through [target_turf]!"))
			return
		else
			for(var/atom/atom_in_turf in target_turf)
				if(atom_in_turf.density && !atom_in_turf.throwpass && !istype(atom_in_turf, /obj/structure/barricade) && !istype(atom_in_turf, /mob/living))
					to_chat(dancer_user, SPAN_WARNING("We can't attack through [atom_in_turf]!"))
					return

	XENO_ACTION_CHECK_USE_PLASMA(dancer_user)

	apply_cooldown()
	REMOVE_TRAIT(dancer_user, TRAIT_ABILITY_RED_TAG, TRAIT_SOURCE_ABILITY("red_tag"))
	for(var/datum/effects/dancer_tag/spread/tag_spread in target_carbon.effects_list)
		ADD_TRAIT(dancer_user, TRAIT_ABILITY_RED_TAG, TRAIT_SOURCE_ABILITY("red_tag"))
		qdel(tag_spread)
		apply_cooldown_override()
		break

	for(var/datum/effects/dancer_tag/normal/dancer_tag_effect in target_carbon.effects_list)
		ADD_TRAIT(dancer_user, TRAIT_ABILITY_RED_TAG, TRAIT_SOURCE_ABILITY("red_tag"))
		qdel(dancer_tag_effect)
		break

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/human_target = target_carbon
		human_target.update_xeno_hostile_hud()

	// Hmm today visible_message(SPAN_DANGER("\The [dancer_user] violently slices [target_atom] with its tail[buffed?" twice":""]!"),
	dancer_user.face_atom(target_atom)

	var/damage = get_xeno_damage_slash(target_carbon, rand(dancer_user.melee_damage_lower, dancer_user.melee_damage_upper))
	var/buffed = HAS_TRAIT(dancer_user, TRAIT_ABILITY_RED_TAG)
	dancer_user.visible_message(SPAN_DANGER("\The [dancer_user] violently slices [target_atom] with its tail[buffed?" twice":""]!"),
					SPAN_DANGER("We slice [target_atom] with our tail[buffed?" twice":""]!"))

	impale_strike(dancer_user, target_carbon, damage)

	if(buffed)
		dancer_user.emote("roar") // Feedback for the player that we got the magic double impale
		addtimer(CALLBACK(src, PROC_REF(impale_strike), dancer_user, target_carbon, damage), 4 DECISECONDS)

	return ..()



/datum/action/xeno_action/activable/prae_impale/proc/impale_strike(mob/living/carbon/xenomorph/dancer_user, mob/living/carbon/target_carbon, damage)
	if(!dancer_user || !target_carbon || target_carbon.stat == DEAD || QDELETED(dancer_user) || QDELETED(target_carbon))
		return

	dancer_user.animation_attack_on(target_carbon)
	dancer_user.flick_attack_overlay(target_carbon, "tail")

	target_carbon.last_damage_data = create_cause_data(initial(dancer_user.caste_type), dancer_user)
	target_carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 10)
	playsound(target_carbon, 'sound/weapons/alien_tail_attack.ogg', 30, TRUE)



/datum/action/xeno_action/onclick/prae_dodge/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dodge_user = owner
	if(!istype(dodge_user))
		return

	if(HAS_TRAIT(dodge_user, TRAIT_ABILITY_DODGE))
		remove_effects()
		return

	XENO_ACTION_CHECK(dodge_user)

	if(!check_and_use_plasma_owner(200))
		return

	ADD_TRAIT(dodge_user, TRAIT_ABILITY_DODGE, TRAIT_SOURCE_ABILITY("dodge"))
	dodge_start_time = world.time
	safe_click_cooldown = world.time + 1 SECONDS
	button.icon_state = "template_active"
	dodge_user.speed_modifier -= speed_buff_amount
	dodge_user.dodge_threshold -= 3
	dodge_user.add_temp_pass_flags(PASS_MOB_THRU)
	dodge_user.recalculate_speed()
	dodge_user.balloon_alert(dodge_user, "we start our evasive stance!", text_color = "#7d32bb", delay = 1 SECONDS)

	INVOKE_ASYNC(src, PROC_REF(create_afterimage_sequence), dodge_user, duration)

	if(dodge_timer != TIMER_ID_NULL)
		deltimer(dodge_timer)

	dodge_timer = addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration, TIMER_STOPPABLE)

	return ..()

/datum/action/xeno_action/onclick/prae_dodge/proc/remove_effects()
	var/mob/living/carbon/xenomorph/dodge_remove = owner
	if(!istype(dodge_remove))
		return

	if(!HAS_TRAIT(dodge_remove, TRAIT_ABILITY_DODGE))
		return

	if(world.time < safe_click_cooldown)
		to_chat(dodge_remove, SPAN_XENOWARNING("We need a moment before breaking our evasive stance!"))
		return

	REMOVE_TRAIT(dodge_remove, TRAIT_ABILITY_DODGE, TRAIT_SOURCE_ABILITY("dodge"))
	button.icon_state = "template_xeno"
	dodge_remove.speed_modifier += speed_buff_amount
	dodge_remove.dodge_threshold += 3
	dodge_remove.remove_temp_pass_flags(PASS_MOB_THRU)
	dodge_remove.recalculate_speed()
	dodge_remove.reset_position_to_initial()
	dodge_remove.balloon_alert(dodge_remove, "our evasive stance fades", text_color = "#bb5d32", delay = 1 SECONDS)

	if(dodge_timer != TIMER_ID_NULL)
		deltimer(dodge_timer)
		dodge_timer = TIMER_ID_NULL

	if(dodge_start_time > 0)
		var/used_ratio = round((world.time - dodge_start_time) / duration, 0.1)
		recharge_time = max(DANCER_DODGE_TIME * used_ratio * refund_multiplier, 5 SECONDS)

	dodge_start_time = -1
	apply_cooldown_override(recharge_time)

/datum/action/xeno_action/onclick/prae_dodge/proc/create_afterimage_sequence(mob/living/carbon/xenomorph/dodge_user, duration)
	if(!dodge_user || !dodge_user.loc)
		return

	var/afterimage_count = round(duration / afterimage_interval)

	var/datum/afterimage_state/state = new
	state.owner = dodge_user
	state.remaining = afterimage_count
	state.last_turf = get_turf(dodge_user.loc)

	addtimer(CALLBACK(src, PROC_REF(process_afterimage_tick), state), afterimage_interval)

/datum/action/xeno_action/onclick/prae_dodge/proc/process_afterimage_tick(datum/afterimage_state/state)
	if(!state || !state.owner || !state.owner.loc)
		return

	var/mob/living/carbon/xenomorph/dodge_user = state.owner
	if(!HAS_TRAIT(dodge_user, TRAIT_ABILITY_DODGE))
		return
	var/turf/current_position = get_turf(dodge_user.loc)

	if(current_position && current_position != state.last_turf)
		var/random_offset_x = rand(-4, 4)
		var/random_offset_y = rand(-4, 4)

		dodge_user.reset_position_to_initial()
		dodge_user.apply_offset(random_offset_x, random_offset_y)

		create_afterimage(dodge_user, random_offset_x, random_offset_y)
		state.last_turf = current_position

	state.remaining--

	if(state.remaining > 0)
		addtimer(CALLBACK(src, PROC_REF(process_afterimage_tick), state), afterimage_interval)
	else
		addtimer(CALLBACK(dodge_user, TYPE_PROC_REF(/atom/movable, reset_position_to_initial)), 2 DECISECONDS)

/datum/action/xeno_action/onclick/prae_dodge/proc/create_afterimage(mob/living/carbon/xenomorph/dodge_user, random_offset_x, random_offset_y)
	if(!dodge_user || !dodge_user.loc)
		return

	var/turf/afterimage_location = get_turf(dodge_user.loc)
	if(!afterimage_location)
		return

	var/directional_offset_x = 0
	var/directional_offset_y = 0

	switch(dodge_user.dir)
		if(NORTH)
			directional_offset_y = -16
		if(SOUTH)
			directional_offset_y = 16
		if(EAST)
			directional_offset_x = -16
		if(WEST)
			directional_offset_x = 16

	var/obj/effect/overlay/afterimage = new /obj/effect/overlay/afterimage(afterimage_location)
	afterimage.icon = dodge_user.icon
	afterimage.icon_state = dodge_user.icon_state
	afterimage.color = dodge_user.color
	afterimage.layer = dodge_user.layer
	afterimage.dir = dodge_user.dir
	afterimage.alpha = 200
	afterimage.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	afterimage.pixel_x = dodge_user.pixel_x + directional_offset_x
	afterimage.pixel_y = dodge_user.pixel_y + directional_offset_y

	addtimer(CALLBACK(afterimage, TYPE_PROC_REF(/obj/effect/overlay/afterimage, fade_out_afterimage)))



/obj/effect/overlay/afterimage/proc/fade_out_afterimage()
	if(!src)
		return

	fade_step = 1
	addtimer(CALLBACK(src, PROC_REF(handle_fade_tick)), fade_delay)

/obj/effect/overlay/afterimage/proc/handle_fade_tick()
	if(!src)
		return

	alpha = round(200 * (1 - (fade_step / fade_max_steps)))

	if(fade_step >= fade_max_steps)
		qdel(src)
	else
		fade_step++
		addtimer(CALLBACK(src, PROC_REF(handle_fade_tick)), fade_delay)

/atom/movable/proc/reset_position_to_initial()
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)

/atom/movable/proc/apply_offset(dir_x, dir_y)
	pixel_x += dir_x
	pixel_y += dir_y

/datum/afterimage_state
	var/mob/living/carbon/xenomorph/owner
	var/remaining
	var/turf/last_turf

/obj/effect/overlay/afterimage
	name = "Dancer Afterimage"
	icon = 'icons/mob/xenos/castes/tier_3/praetorian.dmi'
	layer = MOB_LAYER
	var/fade_step = 0
	var/fade_max_steps = 3
	var/fade_delay = 1 DECISECONDS



/datum/action/xeno_action/activable/prae_tail_trip/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	if(!istype(dancer_user))
		return

	XENO_ACTION_CHECK(dancer_user)

	if(!ismob(target_atom))
		apply_cooldown_override(tail_click_miss_cooldown)
		update_button_icon()
		return

	if(!isxeno_human(target_atom) || dancer_user.can_not_harm(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("We must target a hostile!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if(target_carbon.stat == DEAD)
		to_chat(dancer_user, SPAN_XENOWARNING("[target_atom] is dead, why would we want to attack it?"))
		return

	XENO_ACTION_CHECK_USE_PLASMA(dancer_user)

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/target_human = target_carbon
		target_human.update_xeno_hostile_hud()

	var/dist = get_dist(dancer_user, target_carbon)

	if(dist > range)
		to_chat(dancer_user, SPAN_WARNING("[target_carbon] is too far away!"))
		return

	if(dist > 1)
		var/turf/target_turf = get_step(dancer_user, get_dir(dancer_user, target_carbon))
		if(target_turf.density)
			to_chat(dancer_user, SPAN_WARNING("We can't attack through [target_turf]!"))
			return
		else
			for(var/atom/atom_in_turf in target_turf)
				if(atom_in_turf.density && !atom_in_turf.throwpass && !istype(atom_in_turf, /obj/structure/barricade) && !istype(atom_in_turf, /mob/living))
					to_chat(dancer_user, SPAN_WARNING("We can't attack through [atom_in_turf]!"))
					return

	// Hmm today I will kill a marine while looking away from them
	dancer_user.face_atom(target_carbon)
	dancer_user.flick_attack_overlay(target_carbon, "disarm")

	REMOVE_TRAIT(dancer_user, TRAIT_ABILITY_RED_TAG, TRAIT_SOURCE_ABILITY("red_tag"))

	var/datum/effects/dancer_tag/normal/dancer_tag_effect = locate() in target_carbon.effects_list
	var/datum/effects/dancer_tag/spread/tag_spread = locate() in target_carbon.effects_list

	if(tag_spread)
		ADD_TRAIT(dancer_user, TRAIT_ABILITY_RED_TAG, TRAIT_SOURCE_ABILITY("red_tag"))
		qdel(tag_spread)
		apply_cooldown_override()

	if(dancer_tag_effect)
		ADD_TRAIT(dancer_user, TRAIT_ABILITY_RED_TAG, TRAIT_SOURCE_ABILITY("red_tag"))
		qdel(dancer_tag_effect)

	if(!HAS_TRAIT(dancer_user, TRAIT_ABILITY_RED_TAG))
		new /datum/effects/xeno_slow(target_carbon, dancer_user, null, null, get_xeno_stun_duration(target_carbon, slow_duration))

	var/stun_duration = stun_duration_default
	var/daze_duration = 0

	if(HAS_TRAIT(dancer_user, TRAIT_ABILITY_RED_TAG))
		stun_duration = stun_duration_buffed
		daze_duration = daze_duration_buffed

	var/xeno_smashed = FALSE

	if(isxeno(target_carbon))
		var/mob/living/carbon/xenomorph/target_xeno = target_carbon
		if(target_xeno.mob_size >= MOB_SIZE_BIG)
			xeno_smashed = TRUE
			shake_camera(target_xeno, 10, 1)
			dancer_user.visible_message(SPAN_XENODANGER("[dancer_user] smashes [target_xeno] with it's tail!"), SPAN_XENODANGER("We smash [target_xeno] with your tail!"))
			to_chat(target_xeno, SPAN_XENOHIGHDANGER("You feel dizzy as [dancer_user] smashes you with their tail!"))
			dancer_user.animation_attack_on(target_xeno)

	if(!xeno_smashed)
		if(stun_duration > 0)
			target_carbon.apply_effect(stun_duration, WEAKEN)
		dancer_user.visible_message(SPAN_XENODANGER("[dancer_user] trips [target_atom] with it's tail!"), SPAN_XENODANGER("We trip [target_atom] with our tail!"))
		dancer_user.spin_circle()
		dancer_user.emote("tail")
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You are swept off your feet by [dancer_user]!"))
	if(daze_duration > 0)
		target_carbon.apply_effect(daze_duration, DAZE)
	playsound(dancer_user, 'sound/effects/hit_kick.ogg', 75, 1)

	apply_cooldown()
	return ..()
