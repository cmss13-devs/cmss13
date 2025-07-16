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
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/fling,
		/datum/action/xeno_action/onclick/tacmap,
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
	var/lunging = FALSE // whether or not the warrior is currently lunging (holding) a target

/mob/living/carbon/xenomorph/warrior/throw_item(atom/target)
	toggle_throw_mode(THROW_MODE_OFF)

/mob/living/carbon/xenomorph/warrior/stop_pulling()
	var/datum/behavior_delegate/warrior_base/warrior_delegate = behavior_delegate
	if(isliving(pulling) && warrior_delegate.lunging)
		warrior_delegate.lunging = FALSE // To avoid extreme cases of stopping a lunge then quickly pulling and stopping to pull someone else
		var/mob/living/lunged = pulling
		lunged.set_effect(0, STUN)
		lunged.set_effect(0, WEAKEN)
	return ..()

/mob/living/carbon/xenomorph/warrior/start_pulling(atom/movable/movable_atom, lunge)
	var/datum/behavior_delegate/warrior_base/warrior_delegate = behavior_delegate
	if (!check_state())
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
			var/mob/living/carbon/xenomorph/xeno = living_mob
			if(xeno.tier >= 2) // Tier 2 castes or higher immune to warrior grab stuns
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
			warrior_delegate.lunging = TRUE
			addtimer(CALLBACK(src, PROC_REF(stop_lunging)), get_xeno_stun_duration(living_mob, 2) SECONDS + 1 SECONDS)

/mob/living/carbon/xenomorph/warrior/proc/stop_lunging(world_time)
	var/datum/behavior_delegate/warrior_base/warrior_delegate = behavior_delegate
	warrior_delegate.lunging = FALSE

/mob/living/carbon/xenomorph/warrior/hitby(atom/movable/movable_atom)
	if(ishuman(movable_atom))
		return
	..()


/datum/behavior_delegate/warrior_base/melee_attack_additional_effects_target(mob/living/carbon/carbon)
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

// This part is then outside the for loop
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

/datum/behavior_delegate/warrior_base/override_intent(mob/living/carbon/target_carbon)
	. = ..()
	if(!isxeno_human(target_carbon))
		return


	if(lunging && target_carbon)
		return INTENT_HARM


/datum/behavior_delegate/warrior_base/proc/lifesteal_lock()
	bound_xeno.remove_filter("empower_rage")


/// Warrior specific behaviour for increasing pull power, limb rip.
/mob/living/carbon/xenomorph/warrior/pull_power(mob/mob)
	if(!ripping_limb && mob.stat != DEAD)
		if(mob.status_flags & XENO_HOST)
			to_chat(src, SPAN_XENOWARNING("This would harm the embryo!"))
			return
		ripping_limb = TRUE
		if(rip_limb(mob))
			stop_pulling()
		ripping_limb = FALSE


/// Warrior Rip Limb - called by pull_power()
/mob/living/carbon/xenomorph/warrior/proc/rip_limb(mob/mob)
	if(!istype(mob, /mob/living/carbon/human))
		return FALSE

	if(action_busy) //can't stack the attempts
		return FALSE

	var/mob/living/carbon/human/human = mob
	var/obj/limb/limb = human.get_limb(check_zone(zone_selected))

	if(can_not_harm(human))
		to_chat(src, SPAN_XENOWARNING("We can't harm this host!"))
		return

	if(!limb || limb.body_part == BODY_FLAG_CHEST || limb.body_part == BODY_FLAG_GROIN || (limb.status & LIMB_DESTROYED)) //Only limbs and head.
		to_chat(src, SPAN_XENOWARNING("We can't rip off that limb."))
		return FALSE

	var/limb_time = rand(40,60)
	if(limb.body_part == BODY_FLAG_HEAD)
		limb_time = rand(90,110)

	visible_message(SPAN_XENOWARNING("[src] begins pulling on [mob]'s [limb.display_name] with incredible strength!"),
	SPAN_XENOWARNING("We begin to pull on [mob]'s [limb.display_name] with incredible strength!"))

	if(!do_after(src, limb_time, INTERRUPT_ALL|INTERRUPT_DIFF_SELECT_ZONE, BUSY_ICON_HOSTILE) || mob.stat == DEAD || mob.status_flags & XENO_HOST)
		to_chat(src, SPAN_NOTICE("We stop ripping off the limb."))
		return FALSE

	if(mob.status_flags & XENO_HOST)
		to_chat(src, SPAN_NOTICE("We detect an embryo inside [mob] which overwhelms our instinct to rip."))
		return FALSE

	if(limb.status & LIMB_DESTROYED)
		return FALSE

	if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		limb.take_damage(rand(30,40), 0, 0) // just do more damage
		visible_message(SPAN_XENOWARNING("You hear [mob]'s [limb.display_name] being pulled beyond its load limits!"),
		SPAN_XENOWARNING("[mob]'s [limb.display_name] begins to tear apart!"))
	else
		visible_message(SPAN_XENOWARNING("We hear the bones in [mob]'s [limb.display_name] snap with a sickening crunch!"),
		SPAN_XENOWARNING("[mob]'s [limb.display_name] bones snap with a satisfying crunch!"))
		limb.take_damage(rand(15,25), 0, 0)
		limb.fracture(100)
	mob.last_damage_data = create_cause_data(initial(caste_type), src)
	src.attack_log += text("\[[time_stamp()]\] <font color='red'>ripped the [limb.display_name] off of [mob.name] ([mob.ckey]) 1/2 progress</font>")
	mob.attack_log += text("\[[time_stamp()]\] <font color='orange'>had their [limb.display_name] ripped off by [src.name] ([src.ckey]) 1/2 progress</font>")
	log_attack("[src.name] ([src.ckey]) ripped the [limb.display_name] off of [mob.name] ([mob.ckey]) 1/2 progress")

	if(!do_after(src, limb_time, INTERRUPT_ALL|INTERRUPT_DIFF_SELECT_ZONE, BUSY_ICON_HOSTILE)  || mob.stat == DEAD || iszombie(mob))
		to_chat(src, SPAN_NOTICE("We stop ripping off the limb."))
		return FALSE

	if(mob.status_flags & XENO_HOST)
		to_chat(src, SPAN_NOTICE("We detect an embryo inside [mob] which overwhelms our instinct to rip."))
		return FALSE

	if(limb.status & LIMB_DESTROYED)
		return FALSE

	visible_message(SPAN_XENOWARNING("[src] rips [mob]'s [limb.display_name] away from their body!"),
	SPAN_XENOWARNING("[mob]'s [limb.display_name] rips away from their body!"))
	src.attack_log += text("\[[time_stamp()]\] <font color='red'>ripped the [limb.display_name] off of [mob.name] ([mob.ckey]) 2/2 progress</font>")
	mob.attack_log += text("\[[time_stamp()]\] <font color='orange'>had their [limb.display_name] ripped off by [src.name] ([src.ckey]) 2/2 progress</font>")
	log_attack("[src.name] ([src.ckey]) ripped the [limb.display_name] off of [mob.name] ([mob.ckey]) 2/2 progress")

	limb.droplimb(0, 0, initial(name))

	return TRUE

/datum/action/xeno_action/activable/lunge/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/lunge_user = owner

	if (!action_cooldown_check())
		if(twitch_message_cooldown < world.time )
			lunge_user.visible_message(SPAN_XENOWARNING("[lunge_user]'s claws twitch."), SPAN_XENOWARNING("Our claws twitch as we try to lunge but lack the strength. Wait a moment to try again."))
			twitch_message_cooldown = world.time + 5 SECONDS
		return //this gives a little feedback on why your lunge didn't hit other than the lunge button going grey. Plus, it might spook marines that almost got lunged if they know why the message appeared, and extra spookiness is always good.

	if (!affected_atom)
		return

	if (!isturf(lunge_user.loc))
		to_chat(lunge_user, SPAN_XENOWARNING("We can't lunge from here!"))
		return

	if (!lunge_user.check_state() || lunge_user.agility)
		return

	if(lunge_user.can_not_harm(affected_atom) || !ismob(affected_atom))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/carbon = affected_atom
	if(carbon.stat == DEAD)
		return

	if (!check_and_use_plasma_owner())
		return

	apply_cooldown()
	..()

	lunge_user.visible_message(SPAN_XENOWARNING("[lunge_user] lunges towards [carbon]!"), SPAN_XENOWARNING("We lunge at [carbon]!"))

	lunge_user.throw_atom(get_step_towards(affected_atom, lunge_user), grab_range, SPEED_FAST, lunge_user, tracking=TRUE)

	if (lunge_user.Adjacent(carbon))
		lunge_user.start_pulling(carbon,1)
		if(ishuman(carbon))
			INVOKE_ASYNC(carbon, TYPE_PROC_REF(/mob, emote), "scream")
	else
		lunge_user.visible_message(SPAN_XENOWARNING("[lunge_user]'s claws twitch."), SPAN_XENOWARNING("Our claws twitch as we lunge but are unable to grab onto our target. Wait a moment to try again."))

	return TRUE

/datum/action/xeno_action/activable/fling/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/fling_user = owner

	if (!action_cooldown_check())
		return

	if (!isxeno_human(affected_atom) || fling_user.can_not_harm(affected_atom))
		return

	if (!fling_user.check_state() || fling_user.agility)
		return

	if (!fling_user.Adjacent(affected_atom))
		return

	var/mob/living/carbon/carbon = affected_atom
	if(carbon.stat == DEAD)
		return

	if(HAS_TRAIT(carbon, TRAIT_NESTED))
		return

	if(carbon == fling_user.pulling)
		fling_user.stop_pulling()

	if(carbon.mob_size >= MOB_SIZE_BIG)
		to_chat(fling_user, SPAN_XENOWARNING("[carbon] is too big for us to fling!"))
		return

	if (!check_and_use_plasma_owner())
		return

	fling_user.visible_message(SPAN_XENOWARNING("[fling_user] effortlessly flings [carbon] to the side!"), SPAN_XENOWARNING("We effortlessly fling [carbon] to the side!"))
	playsound(carbon,'sound/weapons/alien_claw_block.ogg', 75, 1)
	if(stun_power)
		carbon.Stun(get_xeno_stun_duration(carbon, stun_power))
	if(weaken_power)
		carbon.KnockDown(get_xeno_stun_duration(carbon, weaken_power))
	if(slowdown)
		if(carbon.slowed < slowdown)
			carbon.apply_effect(slowdown, SLOW)
	carbon.last_damage_data = create_cause_data(initial(fling_user.caste_type), fling_user)

	var/facing = get_dir(fling_user, carbon)

	// Hmm today I will kill a marine while looking away from them
	fling_user.face_atom(carbon)
	fling_user.animation_attack_on(carbon)
	fling_user.flick_attack_overlay(carbon, "disarm")
	fling_user.throw_carbon(carbon, facing, fling_distance, SPEED_VERY_FAST, shake_camera = TRUE, immobilize = TRUE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/warrior_punch/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/punch_user = owner

	if (!action_cooldown_check())
		return

	if (!isxeno_human(affected_atom) || punch_user.can_not_harm(affected_atom))
		return

	if (!punch_user.check_state() || punch_user.agility)
		return

	var/distance = get_dist(punch_user, affected_atom)

	if (distance > 2)
		return

	var/mob/living/carbon/carbon = affected_atom

	if (!punch_user.Adjacent(carbon))
		return

	if(carbon.stat == DEAD)
		return
	if(HAS_TRAIT(carbon, TRAIT_NESTED))
		return

	var/obj/limb/target_limb = carbon.get_limb(check_zone(punch_user.zone_selected))

	if (ishuman(carbon) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = carbon.get_limb("chest")

	if (!check_and_use_plasma_owner())
		return

	carbon.last_damage_data = create_cause_data(initial(punch_user.caste_type), punch_user)

	punch_user.visible_message(SPAN_XENOWARNING("[punch_user] hits [carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"),
	SPAN_XENOWARNING("We hit [carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"))
	var/sound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg',)
	playsound(carbon, sound, 50, 1)
	do_base_warrior_punch(carbon, target_limb)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/warrior_punch/proc/do_base_warrior_punch(mob/living/carbon/carbon, obj/limb/target_limb)
	var/mob/living/carbon/xenomorph/warrior = owner
	var/damage = rand(base_damage, base_damage + damage_variance)

	if(ishuman(carbon))
		if((target_limb.status & LIMB_SPLINTED) && !(target_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)) //If they have it splinted, the splint won't hold.
			target_limb.status &= ~LIMB_SPLINTED
			playsound(get_turf(carbon), 'sound/items/splintbreaks.ogg', 20)
			to_chat(carbon, SPAN_DANGER("The splint on your [target_limb.display_name] comes apart!"))
			carbon.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)

		if(ishuman_strict(carbon))
			carbon.apply_effect(3, SLOW)

		if(isyautja(carbon))
			damage = rand(base_punch_damage_pred, base_punch_damage_pred + damage_variance)
		else if(target_limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			damage = rand(base_punch_damage_synth, base_punch_damage_synth + damage_variance)


	carbon.apply_armoured_damage(get_xeno_damage_slash(carbon, damage), ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")

	// Hmm today I will kill a marine while looking away from them
	warrior.face_atom(carbon)
	warrior.animation_attack_on(carbon)
	warrior.flick_attack_overlay(carbon, "punch")
	shake_camera(carbon, 2, 1)
	step_away(carbon, warrior, 2)
