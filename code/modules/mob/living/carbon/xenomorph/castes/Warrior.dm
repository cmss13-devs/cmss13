/datum/caste_datum/warrior
	caste_type = XENO_CASTE_WARRIOR
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_5
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_1
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	behavior_delegate_type = /datum/behavior_delegate/warrior_base

	available_strains = list(/datum/xeno_strain/bulwark)

	evolves_to = list(XENO_CASTE_PRAETORIAN, XENO_CASTE_CRUSHER)
	deevolves_to = list(XENO_CASTE_DEFENDER)
	caste_desc = "A powerful front line combatant."
	can_vent_crawl = 0

	tackle_min = 2
	tackle_max = 4

	agility_speed_increase = -0.9

	heal_resting = 1.4

	minimum_evolve_time = 9 MINUTES

	minimap_icon = "warrior"

/mob/living/carbon/xenomorph/warrior
	caste_type = XENO_CASTE_WARRIOR
	name = XENO_CASTE_WARRIOR
	desc = "A beefy alien with an armored carapace."
	icon = 'icons/mob/xenos/castes/tier_2/warrior.dmi'
	icon_size = 64
	icon_state = "Warrior Walking"
	plasma_types = list(PLASMA_CHITIN)
	pixel_x = -16
	old_x = -16
	tier = 2
	pull_speed = 2 // about what it was before, slightly faster
	organ_value = 2000
	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/fling,
	)

	claw_type = CLAW_TYPE_SHARP

	icon_xeno = 'icons/mob/xenos/castes/tier_2/warrior.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_2/warrior.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Warrior_1","Warrior_2","Warrior_3")
	weed_food_states_flipped = list("Warrior_1","Warrior_2","Warrior_3")

	skull = /obj/item/skull/warrior
	pelt = /obj/item/pelt/warrior

/datum/behavior_delegate/warrior_base
	name = "Base Warrior Behavior Delegate"

	var/lifesteal_percent = 7
	var/max_lifesteal = 9
	var/lifesteal_range =  3 // Marines within 3 tiles of range will give the warrior extra health
	var/lifesteal_lock_duration = 20 // This will remove the glow effect on warrior after 2 seconds
	var/color = "#6c6f24"
	var/emote_cooldown = 0

/mob/living/carbon/xenomorph/warrior/handle_special_state()
	return HAS_TRAIT(src, TRAIT_ABILITY_ENCLOSED_PLATES)

/mob/living/carbon/xenomorph/warrior/handle_special_wound_states(severity)
	if(HAS_TRAIT(src, TRAIT_ABILITY_ENCLOSED_PLATES))
		return "Warrior_plates_[severity]"

/mob/living/carbon/xenomorph/warrior/throw_item(atom/target_atom)
	toggle_throw_mode(THROW_MODE_OFF)

/mob/living/carbon/xenomorph/warrior/stop_pulling()
	var/datum/behavior_delegate/warrior_base/warrior_delegate = behavior_delegate
	if(isliving(pulling) && istype(warrior_delegate) && HAS_TRAIT(src, TRAIT_ABILITY_LUNGE))
		REMOVE_TRAIT(src, TRAIT_ABILITY_LUNGE, TRAIT_SOURCE_ABILITY("lunge"))
		var/mob/living/lunged = pulling
		lunged.set_effect(0, STUN)
		lunged.set_effect(0, WEAKEN)
	return ..()

/mob/living/carbon/xenomorph/warrior/start_pulling(atom/movable/movable_atom, lunge)
	if(!check_state())
		return FALSE

	if(!isliving(movable_atom))
		return FALSE
	var/mob/living/living_mob = movable_atom
	var/should_neckgrab = !(src.can_not_harm(living_mob)) && lunge

	if(!QDELETED(living_mob) && !QDELETED(living_mob.pulledby) && living_mob != src ) //override pull of other mobs
		visible_message(SPAN_WARNING("[src] has broken [living_mob.pulledby]'s grip on [living_mob]!"), null, null, 5)
		living_mob.pulledby.stop_pulling()

	. = ..(living_mob, lunge, should_neckgrab)

	if(.) //successful pull
		if(isxeno(living_mob))
			var/mob/living/carbon/xenomorph/target_xeno = living_mob
			if(target_xeno.tier >= 2) // Tier 2 castes or higher immune to warrior grab stuns
				return

		if(should_neckgrab && living_mob.mob_size < MOB_SIZE_BIG)
			living_mob.drop_held_items()
			var/duration = get_xeno_stun_duration(living_mob, 2)
			living_mob.KnockDown(duration)
			living_mob.Stun(duration)
			if(living_mob.pulledby != src)
				return // Grab was broken, probably as Stun side effect (eg. target getting knocked away from a manned M56D)
			visible_message(SPAN_XENOWARNING("[src] grabs [living_mob] by the throat!"),
			SPAN_XENOWARNING("We grab [living_mob] by the throat!"))
			ADD_TRAIT(src, TRAIT_ABILITY_LUNGE, TRAIT_SOURCE_ABILITY("lunge"))
			addtimer(CALLBACK(src, PROC_REF(stop_lunging)), get_xeno_stun_duration(living_mob, 2) SECONDS + 1 SECONDS)

/mob/living/carbon/xenomorph/warrior/proc/stop_lunging(world_time)
	REMOVE_TRAIT(src, TRAIT_ABILITY_LUNGE, TRAIT_SOURCE_ABILITY("lunge"))

/mob/living/carbon/xenomorph/warrior/hitby(atom/movable/movable_atom)
	if(ishuman(movable_atom))
		return
	..()


/datum/behavior_delegate/warrior_base/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	..()

	if(SEND_SIGNAL(bound_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		return

	var/final_lifesteal = lifesteal_percent
	var/list/mobs_in_range = oviewers(lifesteal_range, bound_xeno)

	for(var/mob/target_mob as anything in mobs_in_range)
		if(final_lifesteal >= max_lifesteal)
			break

		if(target_mob.stat == DEAD || HAS_TRAIT(target_mob, TRAIT_NESTED))
			continue

		if(bound_xeno.can_not_harm(target_mob))
			continue

		final_lifesteal++

// This part is then outside the for loop
		if(final_lifesteal >= max_lifesteal)
			bound_xeno.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 1, "alpha" = 90))
			bound_xeno.visible_message(SPAN_DANGER("[bound_xeno.name] glows as it heals even more from its injuries!"), SPAN_XENODANGER("We glow as we heal even more from our injuries!"))
			bound_xeno.flick_heal_overlay(2 SECONDS, "#00B800")
		if(istype(bound_xeno) && world.time > emote_cooldown && bound_xeno)
			bound_xeno.emote("roar")
			bound_xeno.xeno_jitter(1 SECONDS)
			emote_cooldown = world.time + 5 SECONDS
		addtimer(CALLBACK(src, PROC_REF(lifesteal_lock)), lifesteal_lock_duration/2)

	bound_xeno.gain_health(clamp(final_lifesteal / 100 * (bound_xeno.maxHealth - bound_xeno.health), 20, 40))

/datum/behavior_delegate/warrior_base/override_intent(mob/living/carbon/target_carbon)
	. = ..()
	if(!isxeno_human(target_carbon))
		return

	if(HAS_TRAIT(bound_xeno, TRAIT_ABILITY_LUNGE) && target_carbon)
		return INTENT_HARM


/datum/behavior_delegate/warrior_base/proc/lifesteal_lock()
	bound_xeno.remove_filter("empower_rage")


/datum/action/xeno_action/activable/lunge/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check())
		if(twitch_message_cooldown < world.time)
			xeno.visible_message(SPAN_XENOWARNING("[xeno]'s claws twitch."), SPAN_XENOWARNING("Our claws twitch as we try to lunge but lack the strength. Wait a moment to try again."))
			twitch_message_cooldown = world.time + 5 SECONDS
		return //this gives a little feedback on why your lunge didn't hit other than the lunge button going grey. Plus, it might spook marines that almost got lunged if they know why the message appeared, and extra spookiness is always good.

	if(!affected_atom)
		return

	if(!isturf(xeno.loc))
		to_chat(xeno, SPAN_XENOWARNING("We can't lunge from here!"))
		return

	if(xeno.can_not_harm(affected_atom) || !ismob(affected_atom))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/target_carbon = affected_atom
	if(target_carbon.stat == DEAD)
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	apply_cooldown()
	..()

	xeno.visible_message(SPAN_XENOWARNING("[xeno] lunges towards [target_carbon]!"), SPAN_XENOWARNING("We lunge at [target_carbon]!"))

	xeno.throw_atom(get_step_towards(affected_atom, xeno), grab_range, SPEED_FAST, xeno, tracking=TRUE)

	if(xeno.Adjacent(target_carbon))
		xeno.start_pulling(target_carbon,1)
		if(ishuman(target_carbon))
			INVOKE_ASYNC(target_carbon, TYPE_PROC_REF(/mob, emote), "scream")
	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno]'s claws twitch."), SPAN_XENOWARNING("Our claws twitch as we lunge but are unable to grab onto our target. Wait a moment to try again."))

	return TRUE

/datum/action/xeno_action/activable/fling/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!isxeno_human(affected_atom) || xeno.can_not_harm(affected_atom))
		return

	XENO_ACTION_CHECK(xeno)

	if(!xeno.Adjacent(affected_atom))
		return

	var/mob/living/carbon/target_carbon = affected_atom
	if(target_carbon.stat == DEAD)
		return

	if(HAS_TRAIT(target_carbon, TRAIT_NESTED))
		return

	if(target_carbon == xeno.pulling)
		xeno.stop_pulling()

	if(target_carbon.mob_size >= MOB_SIZE_BIG)
		to_chat(xeno, SPAN_XENOWARNING("[target_carbon] is too big for us to fling!"))
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	xeno.visible_message(SPAN_XENOWARNING("[xeno] effortlessly flings [target_carbon] to the side!"), SPAN_XENOWARNING("We effortlessly fling [target_carbon] to the side!"))
	playsound(target_carbon,'sound/weapons/alien_claw_block.ogg', 75, 1)
	if(stun_power)
		target_carbon.Stun(get_xeno_stun_duration(target_carbon, stun_power))
	if(weaken_power)
		target_carbon.KnockDown(get_xeno_stun_duration(target_carbon, weaken_power))
	if(slowdown)
		if(target_carbon.slowed < slowdown)
			target_carbon.apply_effect(slowdown, SLOW)
	target_carbon.last_damage_data = create_cause_data(initial(xeno.caste_type), xeno)

	var/facing = get_dir(xeno, target_carbon)

	// Hmm today I will kill a marine while looking away from them
	xeno.face_atom(target_carbon)
	xeno.animation_attack_on(target_carbon)
	xeno.flick_attack_overlay(target_carbon, "disarm")
	xeno.throw_carbon(target_carbon, facing, fling_distance, SPEED_VERY_FAST, shake_camera = TRUE, immobilize = TRUE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/warrior_punch/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	XENO_ACTION_CHECK(xeno)

	if(!isxeno_human(affected_atom) || xeno.can_not_harm(affected_atom))
		return

	var/distance = get_dist(xeno, affected_atom)

	if(distance > 2)
		return

	var/mob/living/carbon/target_carbon = affected_atom

	if(!xeno.Adjacent(target_carbon))
		return

	if(target_carbon.stat == DEAD)
		return
	if(HAS_TRAIT(target_carbon, TRAIT_NESTED))
		return

	var/obj/limb/target_limb = target_carbon.get_limb(check_zone(xeno.zone_selected))

	if(ishuman(target_carbon) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = target_carbon.get_limb("chest")

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	target_carbon.last_damage_data = create_cause_data(initial(xeno.caste_type), xeno)

	xeno.visible_message(SPAN_XENOWARNING("[xeno] hits [target_carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"),
	SPAN_XENOWARNING("We hit [target_carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"))
	var/sound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg',)
	playsound(target_carbon, sound, 50, 1)
	do_base_warrior_punch(target_carbon, target_limb)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/warrior_punch/proc/do_base_warrior_punch(mob/living/carbon/target_carbon, obj/limb/target_limb)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/damage = rand(base_damage, base_damage + damage_variance)

	if(ishuman(target_carbon))
		if((target_limb.status & LIMB_SPLINTED) && !(target_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)) //If they have it splinted, the splint won't hold.
			target_limb.status &= ~LIMB_SPLINTED
			playsound(get_turf(target_carbon), 'sound/items/splintbreaks.ogg', 20)
			to_chat(target_carbon, SPAN_DANGER("The splint on your [target_limb.display_name] comes apart!"))
			target_carbon.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)

		if(ishuman_strict(target_carbon))
			target_carbon.apply_effect(3, SLOW)

		if(isyautja(target_carbon))
			damage = rand(base_punch_damage_pred, base_punch_damage_pred + damage_variance)
		else if(target_limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			damage = rand(base_punch_damage_synth, base_punch_damage_synth + damage_variance)


	target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, damage), ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")

	// Hmm today I will kill a marine while looking away from them
	xeno.face_atom(target_carbon)
	xeno.animation_attack_on(target_carbon)
	xeno.flick_attack_overlay(target_carbon, "punch")
	shake_camera(target_carbon, 2, 1)
	step_away(target_carbon, xeno, 2)
