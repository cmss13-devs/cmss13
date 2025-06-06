/datum/caste_datum/bruiser
	caste_type = XENO_CASTE_BRUISER
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_TIER_7
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_6
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_5

	behavior_delegate_type = /datum/behavior_delegate/bruiser_base

	evolves_to = list(XENO_CASTE_CRUSHER)
	deevolves_to = list(XENO_CASTE_DEFENDER)
	caste_desc = "A powerful front line combatant."
	can_vent_crawl = 0

	tackle_min = 2
	tackle_max = 4

	heal_resting = 1.4

	minimum_evolve_time = 9 MINUTES

	minimap_icon = "warrior"

/mob/living/carbon/xenomorph/bruiser
	caste_type = XENO_CASTE_BRUISER
	name = XENO_CASTE_BRUISER
	desc = "A beefy alien with an armored carapace."
	icon = 'icons/mob/xenos/castes/tier_2/bruiser.dmi'
	icon_size = 64
	icon_state = "Bruiser Walking"
	plasma_types = list(PLASMA_CHITIN)
	pixel_x = -16
	old_x = -16
	tier = 2
	pull_speed = 2
	organ_value = 2000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/bludgeon,
		/datum/action/xeno_action/activable/pounce/blitz,
		/datum/action/xeno_action/activable/fling/bash,
		/datum/action/xeno_action/activable/brutalize,
		/datum/action/xeno_action/onclick/tacmap,
	)

	claw_type = CLAW_TYPE_SHARP

	icon_xeno = 'icons/mob/xenos/castes/tier_2/bruiser.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_2/warrior.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Warrior_1","Warrior_2","Warrior_3")
	weed_food_states_flipped = list("Warrior_1","Warrior_2","Warrior_3")

	skull = /obj/item/skull/warrior
	pelt = /obj/item/pelt/warrior

/datum/behavior_delegate/bruiser_base
	name = "Base Bruiser Behavior Delegate"

	var/lifesteal_percent = 7
	var/max_lifesteal = 9
	var/lifesteal_range =  3 // Marines within 3 tiles of range will give the warrior extra health
	var/lifesteal_lock_duration = 20 // This will remove the glow effect on warrior after 2 seconds
	var/color = "#6c6f24"
	var/emote_cooldown = 0
	var/dashing = FALSE

/datum/behavior_delegate/bruiser_base/melee_attack_additional_effects_target(mob/living/carbon/carbon)
	..()

	if(SEND_SIGNAL(bound_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		return

	var/final_lifesteal = lifesteal_percent
	var/list/mobs_in_range = oviewers(lifesteal_range, bound_xeno)

	for(var/mob/mob as anything in mobs_in_range)
		if(final_lifesteal >= max_lifesteal)
			break

		if(mob.stat == DEAD || HAS_TRAIT(mob, TRAIT_NESTED))
			continue

		if(bound_xeno.can_not_harm(mob))
			continue

		final_lifesteal++

		if(final_lifesteal >= max_lifesteal)
			bound_xeno.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 1, "alpha" = 90))
			bound_xeno.visible_message(SPAN_DANGER("[bound_xeno.name] glows as it heals even more from its injuries!."), SPAN_XENODANGER("We glow as we heal even more from our injuries!"))
			bound_xeno.flick_heal_overlay(2 SECONDS, "#00B800")

		if(istype(bound_xeno) && world.time > emote_cooldown && bound_xeno)
			bound_xeno.emote("roar")
			bound_xeno.xeno_jitter(1 SECONDS)
			emote_cooldown = world.time + 5 SECONDS
		addtimer(CALLBACK(src, PROC_REF(lifesteal_lock)), lifesteal_lock_duration/2)

	bound_xeno.gain_health(clamp(final_lifesteal / 100 * (bound_xeno.maxHealth - bound_xeno.health), 20, 40))

/datum/behavior_delegate/bruiser_base/proc/lifesteal_lock()
	bound_xeno.remove_filter("empower_rage")

/datum/behavior_delegate/bruiser_base/override_intent(mob/living/carbon/target_carbon)
	. = ..()
	if(!isxeno_human(target_carbon))
		return

	if(dashing)
		return INTENT_HARM


// Bruiser Bludgeon
/datum/action/xeno_action/activable/bludgeon/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state() || xeno.agility)
		return

	if (!check_and_use_plasma_owner())
		return

	var/list/temp_turfs = list()
	var/list/target_turfs = list()

	// Code to get a 1x3 area of turfs
	var/turf/root = get_turf(xeno)
	var/facing = get_dir(xeno, affected_atom)
	var/turf/infront = get_step(root, facing)
	var/turf/infront_left = get_step(root, turn(facing, 45))
	var/turf/infront_right = get_step(root, turn(facing, -45))

	temp_turfs += infront
	if (!(!infront || infront.density))
		temp_turfs += infront_left
	if (!(!infront || infront.density))
		temp_turfs += infront_right

	for (var/turf/current_turf in temp_turfs)
		if (!istype(current_turf))
			continue

		if (current_turf.density)
			continue

		target_turfs += current_turf

	for(var/turf/current_turf in target_turfs)
		new /obj/effect/xenomorph/xeno_telegraph/red(current_turf, 2)
		for(var/mob/living/carbon/target in current_turf)
			var/obj/limb/limb_to_target = target.get_limb(check_zone(xeno.zone_selected))
			if (target.stat == DEAD)
				continue

			if (!isxeno_human(target) || xeno.can_not_harm(target))
				continue

			if (HAS_TRAIT(target, TRAIT_NESTED))
				continue

			if (ishuman(target) && (!limb_to_target || (limb_to_target.status & LIMB_DESTROYED)))
				limb_to_target = target.get_limb("chest")

			target.last_damage_data = create_cause_data(initial(xeno.caste_type), xeno)

			var/sound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg',)
			playsound(target, sound, 50, 1)
			var/damage = rand(base_damage, base_damage + damage_variance)

			if(ishuman(target))
				if((limb_to_target.status & LIMB_SPLINTED) && !(limb_to_target.status & LIMB_SPLINTED_INDESTRUCTIBLE))
					limb_to_target.status &= ~LIMB_SPLINTED
					playsound(get_turf(target), 'sound/items/splintbreaks.ogg', 20)
					to_chat(target, SPAN_DANGER("The splint on your [limb_to_target.display_name] comes apart!"))
					target.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)

				if(ishuman_strict(target))
					target.apply_effect(2, SLOW)

			target.apply_armoured_damage(get_xeno_damage_slash(target, damage), ARMOR_MELEE, BRUTE, limb_to_target ? limb_to_target.name : "chest")
			shake_camera(target, 2, 1)
			step_away(target, xeno, 2)

	xeno.face_atom(affected_atom)
	apply_cooldown()

	. = ..()

/datum/action/xeno_action/activable/pounce/blitz/initialize_pounce_pass_flags()
	pounce_pass_flags = PASS_MOB_THRU|PASS_OVER_THROW_MOB

/datum/action/xeno_action/activable/pounce/blitz/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	var/turf/before_turf = get_turf(xeno)
	. = ..()

	if(!.)
		return

	var/turf/after_turf = get_turf(xeno)
	var/list/turf/path = get_line(before_turf, after_turf)

	var/datum/behavior_delegate/bruiser_base/behavior = xeno.behavior_delegate
	behavior.dashing = TRUE
	var/did_reset = FALSE
	for(var/turf/current_turf in path)
		for(var/mob/living/carbon/target in current_turf)
			if(target.stat == DEAD || HAS_TRAIT(target, TRAIT_NESTED))
				continue

			if(xeno.can_not_harm(target))
				continue

			target.attack_alien(xeno, rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
			if(resets == max_resets)
				target.attack_alien(xeno, rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
			shake_camera(target, 2, 1)

			if(resets >= max_resets)
				continue

			if(did_reset)
				continue

			if(!length(unique_hits))
				unique_hits += WEAKREF(target)
				resets++
				did_reset = TRUE
				continue

			for(var/datum/weakref/weakref_mob in unique_hits)
				var/mob/living/carbon/hit_mob = weakref_mob.resolve()

				if(hit_mob == target)
					break

				unique_hits += WEAKREF(target)
				resets++
				did_reset = TRUE

	behavior.dashing = FALSE
	if(did_reset)
		reset_timer = addtimer(CALLBACK(src, PROC_REF(go_on_cooldown)), 4 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

		if(resets == max_resets)
			xeno.add_filter("empowered_blitz", 1, list("type" = "outline", "color" = "#8B0000", "size" = 1))
	else
		if(resets == max_resets)
			var/datum/action/xeno_action/activable/pounce/charge/bash_action = get_action(xeno, /datum/action/xeno_action/activable/fling/bash)
			var/datum/action/xeno_action/activable/pounce/charge/bludgeon_action = get_action(xeno, /datum/action/xeno_action/activable/bludgeon)
			bash_action.end_cooldown()
			bludgeon_action.end_cooldown()

		apply_cooldown()
		xeno.remove_filter("empowered_blitz")
		resets = 0
		unique_hits.Cut()

	button.overlays.Cut()
	action_icon_state = "blitz[resets + 1]"
	button.overlays += image(icon_file, button, action_icon_state)

/datum/action/xeno_action/activable/pounce/blitz/proc/go_on_cooldown()
	apply_cooldown()
	resets = 0
	unique_hits.Cut()
	button.overlays.Cut()
	action_icon_state = "blitz[resets + 1]"
	button.overlays += image(icon_file, button, action_icon_state)

/datum/action/xeno_action/activable/brutalize/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check())
		return

	if(!affected_atom)
		return

	if(!isturf(xeno.loc))
		return

	if(!xeno.check_state())
		return

	if(xeno.can_not_harm(affected_atom) || !ismob(affected_atom))
		return

	if(xeno.action_busy)
		return

	var/mob/living/carbon/carbon = affected_atom

	if(!carbon.Adjacent(xeno))
		return

	if(carbon.stat == DEAD)
		return

	if(!isliving(affected_atom))
		return

	if(!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] begins slowly lifting [carbon] into the air."),
	SPAN_XENOWARNING("You begin focusing your anger as you slowly lift [carbon] into the air."))

	if(!do_after(xeno, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	if(!carbon.Adjacent(xeno))
		return

	if(carbon.stat == DEAD)
		return

	if(!isliving(affected_atom))
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] brutally slams [carbon] into the ground!"),
	SPAN_XENOWARNING("You slam [carbon] brutally into the ground!"))

	apply_cooldown()
	playsound(carbon, 'sound/effects/bang.ogg', 25, 0)
	animate(carbon, pixel_y = carbon.pixel_y + 32, time = 4, easing = SINE_EASING)
	addtimer(CALLBACK(src, PROC_REF(slam), carbon), 0.4 SECONDS)

	. = ..()

/datum/action/xeno_action/activable/brutalize/proc/slam(mob/living/carbon/target)
	playsound(target, 'sound/effects/bang.ogg', 25, 0)
	playsound(target,"slam", 50, 1)
	animate(target, pixel_y = 0, time = 4, easing = BOUNCE_EASING)
	target.apply_armoured_damage(get_xeno_damage_slash(target, 45), ARMOR_MELEE, BRUTE, "chest", 20)

	if(!(HAS_TRAIT(target, TRAIT_KNOCKEDOUT) || target.stat == UNCONSCIOUS))
		return

	target.death(create_cause_data("brutalize", owner))
