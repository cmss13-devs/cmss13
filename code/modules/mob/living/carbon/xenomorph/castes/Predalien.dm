/datum/caste_datum/predalien
	caste_type = XENO_CASTE_PREDALIEN
	display_name = "Abomination"

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_5
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_TIER_9
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	evolution_allowed = FALSE
	minimum_evolve_time = 0

	tackle_min = 3
	tackle_max = 6
	tacklestrength_min = 6
	tacklestrength_max = 10

	is_intelligent = TRUE
	tier = 1
	attack_delay = -2
	can_be_queen_healed = FALSE

	behavior_delegate_type = /datum/behavior_delegate/predalien_base

	minimap_icon = "predalien"

/mob/living/carbon/xenomorph/predalien
	AUTOWIKI_SKIP(TRUE)

	caste_type = XENO_CASTE_PREDALIEN
	name = "Abomination" //snowflake name
	desc = "A strange looking creature with fleshy strands on its head. It appears like a mixture of armor and flesh, smooth, but well carapaced."
	icon = 'icons/mob/xenos/castes/tier_4/predalien.dmi'
	icon_xeno = 'icons/mob/xenos/castes/tier_4/predalien.dmi'
	icon_xenonid = 'icons/mob/xenos/castes/tier_4/predalien.dmi'
	icon_state = "Predalien Walking"
	speaking_noise = 'sound/voice/predalien_click.ogg'
	plasma_types = list(PLASMA_CATECHOLAMINE)
	faction = FACTION_PREDALIEN
	claw_type = CLAW_TYPE_VERY_SHARP
	wall_smash = TRUE
	hardcore = FALSE
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 1
	organ_value = 20000
	age = XENO_NO_AGE //Predaliens are already in their ultimate form, they don't get even better
	show_age_prefix = FALSE
	small_explosives_stun = FALSE

	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/feralrush,
		/datum/action/xeno_action/onclick/predalien_roar,
		/datum/action/xeno_action/activable/feral_smash,
		/datum/action/xeno_action/activable/feralfrenzy,
		/datum/action/xeno_action/onclick/toggle_gut_targeting,
	)

	skull = /obj/item/skull/abomination
	pelt = /obj/item/pelt/abomination

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Predalien_1","Predalien_2","Predalien_3")
	weed_food_states_flipped = list("Predalien_1","Predalien_2","Predalien_3")

	var/smashing = FALSE
	/// If the pred alert/player notif should happen when the predalien spawns
	var/should_announce_spawn = TRUE



/mob/living/carbon/xenomorph/predalien/Initialize(mapload, mob/living/carbon/xenomorph/oldxeno, h_number)
	. = ..()
	if(should_announce_spawn)
		addtimer(CALLBACK(src, PROC_REF(announce_spawn)), 3 SECONDS)
		hunter_data.dishonored = TRUE
		hunter_data.dishonored_reason = "An abomination upon the honor of us all!"
		hunter_data.dishonored_set = src
		hud_set_hunter()

	AddComponent(/datum/component/footstep, 4, 25, 11, 2, "alien_footstep_medium")

/mob/living/carbon/xenomorph/predalien/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	death(cause, gibbed = TRUE)

/mob/living/carbon/xenomorph/predalien/proc/announce_spawn()
	if(!loc)
		return FALSE

	var/datum/game_mode/predator_round = SSticker.mode
	if(!(predator_round.flags_round_type & MODE_PREDATOR) && (hivenumber != XENO_HIVE_NORMAL))
		var/datum/job/pred_job = GLOB.RoleAuthority.roles_for_mode[JOB_PREDATOR]
		if(istype(pred_job) && !pred_job.spawn_positions)
			pred_job.set_spawn_positions(GLOB.players_preassigned)
		predator_round.flags_round_type |= MODE_PREDATOR
		REDIS_PUBLISH("byond.round", "type" = "predator-round", "map" = SSmapping.configs[GROUND_MAP].map_name)

	elder_overseer_message("An abomination has been detected at [get_area_name(loc)]. Exterminate it immediately. Heavy Armory unlocked.")
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_YAUTJA_ARMORY_OPENED)

	to_chat(src, {"
<span class='role_body'>|______________________|</span>
<span class='role_header'>You are a yautja-alien hybrid!</span>
<span class='role_body'>You are a xenomorph born from the body of your natural enemy, you are considered an abomination to all of the yautja race and they will do WHATEVER it takes to kill you.
However, being born from one you also harbor their intelligence and strength. You are built to be able to take them on but that does not mean you are invincible. Stay with your hive and overwhelm them with your numbers. Your sisters have sacrificed a lot for you; Do not just wander off and die.
You must still listen to the queen.
</span>
<span class='role_body'>|______________________|</span>
"})
	emote("roar")

/mob/living/carbon/xenomorph/predalien/get_organ_icon()
	return "heart_t3"


/mob/living/carbon/xenomorph/predalien/resist_fire()
	..()
	SetKnockDown(0.1 SECONDS)

/mob/living/carbon/xenomorph/predalien/get_examine_text(mob/user)
	. = ..()
	var/datum/behavior_delegate/predalien_base/predalienkills = behavior_delegate
	. += "It has [predalienkills.kills] kills to its name!"

/mob/living/carbon/xenomorph/predalien/tutorial
	AUTOWIKI_SKIP(TRUE)

	should_announce_spawn = FALSE

/mob/living/carbon/xenomorph/predalien/tutorial/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	death(cause, gibbed = TRUE)

/mob/living/carbon/xenomorph/predalien/noannounce /// To not alert preds
	should_announce_spawn = FALSE

/datum/behavior_delegate/predalien_base
	name = "Base Predalien Behavior Delegate"

	var/kills = 0
	var/max_kills = 10

/datum/behavior_delegate/predalien_base/append_to_stat()
	. = list()
	. += "Kills: [kills]/[max_kills]"

/datum/behavior_delegate/predalien_base/on_kill_mob(mob/target_mob)
	. = ..()

	kills = min(kills + 1, max_kills)

/datum/behavior_delegate/predalien_base/melee_attack_modify_damage(original_damage, mob/living/carbon/attacked_mob)
	if(ishuman(attacked_mob))
		var/mob/living/carbon/human/attacked_human = attacked_mob
		if(isspeciesyautja(attacked_human))
			original_damage *= 1.5

	return original_damage + kills * 2.5

/datum/action/xeno_action/onclick/predalien_roar/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	playsound(xeno.loc, pick(predalien_roar), 75, 0, status = 0)
	xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a guttural roar!"))
	xeno.create_shriekwave(7) //Adds the visual effect. Wom wom wom, 7 shriekwaves
	FOR_DVIEW(var/mob/living/carbon/target_carbon, 7, xeno, HIDE_INVISIBLE_OBSERVER)
		if(ishuman(target_carbon))
			var/mob/living/carbon/human/target_human = target_carbon
			target_human.disable_special_items()

			var/obj/item/clothing/gloves/yautja/hunter/yautja_glove = locate(/obj/item/clothing/gloves/yautja/hunter) in target_human
			if(isyautja(target_human) && yautja_glove)
				if(HAS_TRAIT(target_human, TRAIT_CLOAKED))
					yautja_glove.decloak(target_human, TRUE, DECLOAK_PREDALIEN)
					target_human.add_filter("uncloack", 1, list("type" = "outline", "color" = "#32fff58c", "size" = 1.5))
					addtimer(CALLBACK(src, PROC_REF(disable_filter), target_human), 3 SECONDS)
					playsound(target_human.loc, 'sound/effects/pred_force_decloak.ogg', 100, 1, 10)

				yautja_glove.cloak_timer = xeno_cooldown * 0.1
		else if(isxeno(target_carbon) && xeno.can_not_harm(target_carbon))
			var/datum/behavior_delegate/predalien_base/behavior = xeno.behavior_delegate
			if(!istype(behavior))
				continue
			new /datum/effects/xeno_buff(target_carbon, xeno, ttl = (0.25 SECONDS * behavior.kills + 3 SECONDS), bonus_damage = bonus_damage_scale * behavior.kills, bonus_speed = (bonus_speed_scale * behavior.kills))
	FOR_DVIEW_END

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/predalien_roar/proc/disable_filter(mob/living/carbon/human/target_human)
	target_human.remove_filter("uncloack")

/datum/action/xeno_action/activable/feralfrenzy/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.action_busy)
		return

	XENO_ACTION_CHECK(xeno)

	var/datum/behavior_delegate/predalien_base/predalienbehavior = xeno.behavior_delegate
	if(!istype(predalienbehavior))
		return
	if(targeting == AOETARGETGUT)
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] begins digging in for a massive strike!"), SPAN_XENOHIGHDANGER("We begin digging in for a massive strike!"))
		ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Eviscerate"))
		xeno.anchored = TRUE
		if(do_after(xeno, (activation_delay_aoe), INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			xeno.emote("roar")
			xeno.spin_circle()

			for(var/mob/living/carbon/target_carbon in orange(xeno, range))
				if(!isliving(target_carbon) || xeno.can_not_harm(target_carbon))
					continue

				if(target_carbon.stat == DEAD)
					continue

				if(!check_clear_path_to_target(xeno, target_carbon))
					continue

				xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] rips open the guts of [target_carbon]!"), SPAN_XENOHIGHDANGER("We rip open the guts of [target_carbon]!"))
				target_carbon.spawn_gibs()
				xeno.animation_attack_on(target_carbon)
				xeno.spin_circle()
				xeno.flick_attack_overlay(target_carbon, "tail")
				playsound(get_turf(target_carbon), 'sound/effects/gibbed.ogg', 30, 1)
				target_carbon.apply_effect(get_xeno_stun_duration(target_carbon, 0.5), WEAKEN)
				playsound(get_turf(target_carbon), "alien_claw_flesh", 30, 1)
				target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, base_damage_aoe + damage_scale_aoe * predalienbehavior.kills), ARMOR_MELEE, BRUTE, "chest", 20)
			playsound(owner, 'sound/voice/predalien_death.ogg', 75, 0, status = 0)
		REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Eviscerate"))
		xeno.anchored = FALSE
		apply_cooldown()
		return ..()

	//single target checks
	if(xeno.can_not_harm(target_atom))
		to_chat(xeno, SPAN_XENOWARNING("We must target a hostile!"))
		return

	if(!isliving(target_atom))
		return

	if(get_dist_sqrd(target_atom, xeno) > 2)
		to_chat(xeno, SPAN_XENOWARNING("[target_atom] is too far away!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if(target_carbon.stat == DEAD)
		to_chat(xeno, SPAN_XENOWARNING("[target_carbon] is dead, why would we want to touch them?"))
		return
	if(targeting == SINGLETARGETGUT) // single target
		ADD_TRAIT(target_carbon, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Devastate"))
		apply_cooldown()

		ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Devastate"))
		xeno.anchored = TRUE

		if(do_after(xeno, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] rips open the guts of [target_carbon]!"), SPAN_XENOHIGHDANGER("We rapidly slice into [target_carbon]!"))
			target_carbon.spawn_gibs()
			playsound(get_turf(target_carbon), 'sound/effects/gibbed.ogg', 50, 1)
			target_carbon.apply_effect(get_xeno_stun_duration(target_carbon, 0.5), WEAKEN)
			target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, base_damage + damage_scale * predalienbehavior.kills), ARMOR_MELEE, BRUTE, "chest", 20)

			xeno.animation_attack_on(target_carbon)
			xeno.spin_circle()
			xeno.flick_attack_overlay(target_carbon, "tail")

		playsound(owner, 'sound/voice/predalien_growl.ogg', 50, 0, status = 0)

		REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Devastate"))
		xeno.anchored = FALSE
		unroot_human(target_carbon, TRAIT_SOURCE_ABILITY("Devastate"))

	return ..()


/datum/action/xeno_action/onclick/feralrush/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(armor_buff && speed_buff)
		to_chat(xeno, SPAN_XENOHIGHDANGER("We cannot stack this!"))
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	addtimer(CALLBACK(src, PROC_REF(remove_rush_effects)), speed_duration)
	addtimer(CALLBACK(src, PROC_REF(remove_armor_effects)), armor_duration) // calculate armor and speed differently, so it's a bit more armored while trying to get out
	xeno.add_filter("predalien_toughen", 1, list("type" = "outline", "color" = "#421313", "size" = 1))
	to_chat(xeno, SPAN_XENOWARNING("We feel our muscles tense as our speed and armor increase!"))
	speed_buff = TRUE
	armor_buff = TRUE
	xeno.speed_modifier -= speed_buff_amount
	xeno.armor_modifier += armor_buff_amount
	xeno.recalculate_speed()
	xeno.recalculate_armor()
	playsound(xeno, 'sound/voice/predalien_growl.ogg', 75, 0, status = 0)
	apply_cooldown()
	return ..()


/datum/action/xeno_action/onclick/feralrush/proc/remove_rush_effects()
	SIGNAL_HANDLER
	var/mob/living/carbon/xenomorph/xeno = owner
	if(speed_buff == TRUE)
		to_chat(xeno, SPAN_XENOWARNING("Our muscles relax as we feel our speed wane."))
		xeno.remove_filter("predalien_toughen")
		xeno.speed_modifier += speed_buff_amount
		xeno.recalculate_speed()
		speed_buff = FALSE


/datum/action/xeno_action/onclick/feralrush/proc/remove_armor_effects()
	SIGNAL_HANDLER
	var/mob/living/carbon/xenomorph/xeno = owner
	if(armor_buff)
		to_chat(xeno, SPAN_XENOWARNING("We are no longer armored."))
		xeno.armor_modifier -= armor_buff_amount
		xeno.recalculate_armor()
		armor_buff = FALSE


/datum/action/xeno_action/onclick/toggle_gut_targeting/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/action_icon_result

	XENO_ACTION_CHECK(xeno)

	var/datum/action/xeno_action/activable/feralfrenzy/guttype = get_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	if(!guttype)
		return

	if(guttype.targeting == SINGLETARGETGUT)
		action_icon_result = "rav_scissor_cut"
		guttype.targeting = AOETARGETGUT
		to_chat(xeno, SPAN_XENOWARNING("We will now attack everyone around us during a Feral Frenzy."))
	else
		action_icon_result = "rav_shard_shed"
		guttype.targeting = SINGLETARGETGUT
		to_chat(xeno, SPAN_XENOWARNING("We will now focus our Feral Frenzy on one person!"))

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)
	return ..()

/datum/action/xeno_action/activable/feral_smash/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check())
		if(twitch_message_cooldown < world.time)
			xeno.visible_message(SPAN_XENOWARNING("[xeno]'s muscles twitch."), SPAN_XENOWARNING("Our claws twitch as we try to grab onto the target but lack the strength. Wait a moment to try again."))
			twitch_message_cooldown = world.time + 5 SECONDS
		return //this gives a little feedback on why your lunge didn't hit other than the lunge button going grey. Plus, it might spook marines that almost got lunged if they know why the message appeared, and extra spookiness is always good.

	if(!affected_atom)
		return

	if(!isturf(xeno.loc))
		to_chat(xeno, SPAN_XENOWARNING("We can't lunge from here!"))
		return

	if(xeno.can_not_harm(affected_atom) || !ismob(affected_atom))
		return

	var/mob/living/carbon/target_carbon = affected_atom
	if(target_carbon.stat == DEAD)
		return

	if(!isliving(affected_atom))
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	apply_cooldown()

	xeno.throw_atom(get_step_towards(affected_atom, xeno), grab_range, SPEED_FAST, xeno, tracking=TRUE)

	if(xeno.Adjacent(target_carbon) && xeno.start_pulling(target_carbon, TRUE))
		playsound(target_carbon.pulledby, 'sound/voice/predalien_growl.ogg', 75, 0, status = 0) // bang and roar for dramatic effect
		playsound(target_carbon, 'sound/effects/bang.ogg', 25, 0)
		animate(target_carbon, pixel_y = target_carbon.pixel_y + 32, time = 4, easing = SINE_EASING)
		addtimer(CALLBACK(src, PROC_REF(second_smash_part), target_carbon, xeno), 4 DECISECONDS)
	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno]'s claws twitch."), SPAN_XENOWARNING("We couldn't grab our target. Wait a moment to try again."))

	return ..()

/datum/action/xeno_action/activable/feral_smash/proc/second_smash_part(mob/living/carbon/target_carbon, mob/living/carbon/xenomorph/xeno)
	var/datum/behavior_delegate/predalien_base/predalienbehavior = xeno.behavior_delegate

	playsound(target_carbon, 'sound/effects/bang.ogg', 25, 0)
	playsound(target_carbon,"slam", 50, 1)
	animate(target_carbon, pixel_y = 0, time = 4, easing = BOUNCE_EASING) //animates the smash
	target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, smash_damage + smash_scale * predalienbehavior.kills), ARMOR_MELEE, BRUTE, "chest", 20)

/mob/living/carbon/xenomorph/predalien/stop_pulling()
	if(isliving(pulling) && smashing)
		smashing = FALSE // To avoid extreme cases of stopping a lunge then quickly pulling and stopping to pull someone else
		var/mob/living/smashed = pulling
		smashed.set_effect(0, STUN)
		smashed.set_effect(0, WEAKEN)
	return ..()

/mob/living/carbon/xenomorph/predalien/start_pulling(atom/movable/movable_atom, feral_smash)
	if(!check_state())
		return FALSE

	if(!isliving(movable_atom))
		return FALSE
	var/mob/living/living_mob = movable_atom
	var/should_neckgrab = !(src.can_not_harm(living_mob)) && feral_smash


	. = ..(living_mob, feral_smash, should_neckgrab)

	if(.) //successful pull
		if(isxeno(living_mob))
			var/mob/living/carbon/xenomorph/xeno = living_mob
			if(xeno.tier >= 2) // Tier 2 castes or higher immune to warrior grab stuns
				return

		if(should_neckgrab && living_mob.mob_size < MOB_SIZE_BIG)
			visible_message(SPAN_XENOWARNING("[src] grabs [living_mob] by the back of their leg and slams them onto the ground!"),
			SPAN_XENOWARNING("We grab [living_mob] by the back of their leg and slam them onto the ground!")) // more flair
			smashing = TRUE
			living_mob.drop_held_items()
			var/duration = get_xeno_stun_duration(living_mob, 1)
			living_mob.KnockDown(duration)
			living_mob.Stun(duration)
			addtimer(VARSET_CALLBACK(src, smashing, FALSE), duration)
