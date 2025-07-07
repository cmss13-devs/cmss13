/*
//======
					Default Ammo
//======
*/
//Only when things screw up do we use this as a placeholder.
/datum/ammo/bullet
	name = "default bullet"
	icon_state = "bullet"
	headshot_state = HEADSHOT_OVERLAY_LIGHT
	flags_ammo_behavior = AMMO_BALLISTIC
	sound_hit  = "ballistic_hit"
	sound_armor  = "ballistic_armor"
	sound_miss  = "ballistic_miss"
	sound_bounce = "ballistic_bounce"
	sound_shield_hit = "ballistic_shield_hit"

	accurate_range_min = 0
	damage = 10
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_1
	shrapnel_type = /obj/item/shard/shrapnel
	shell_speed = AMMO_SPEED_TIER_4

/datum/ammo/bullet/proc/handle_battlefield_execution(datum/ammo/firing_ammo, mob/living/hit_mob, obj/projectile/firing_projectile, mob/living/user, obj/item/weapon/gun/fired_from)
	SIGNAL_HANDLER

	if(!user || hit_mob == user || user.zone_selected != "head" || user.a_intent != INTENT_HARM || !ishuman_strict(hit_mob))
		return

	if(!skillcheck(user, SKILL_EXECUTION, SKILL_EXECUTION_TRAINED))
		to_chat(user, SPAN_DANGER("You don't know how to execute someone correctly."))
		return

	var/mob/living/carbon/human/execution_target = hit_mob

	if(execution_target.status_flags & PERMANENTLY_DEAD)
		to_chat(user, SPAN_DANGER("[execution_target] has already been executed!"))
		return

	INVOKE_ASYNC(src, PROC_REF(attempt_battlefield_execution), src, execution_target, firing_projectile, user, fired_from)

	return COMPONENT_CANCEL_AMMO_POINT_BLANK

/datum/ammo/bullet/proc/attempt_battlefield_execution(datum/ammo/firing_ammo, mob/living/carbon/human/execution_target, obj/projectile/firing_projectile, mob/living/user, obj/item/weapon/gun/fired_from)
	user.affected_message(execution_target,
		SPAN_HIGHDANGER("You aim \the [fired_from] at [execution_target]'s head!"),
		SPAN_HIGHDANGER("[user] aims \the [fired_from] directly at your head!"),
		SPAN_DANGER("[user] aims \the [fired_from] at [execution_target]'s head!"))

	user.next_move += 1.1 SECONDS //PB has no click delay; readding it here to prevent people accidentally queuing up multiple executions.

	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) || !user.Adjacent(execution_target))
		fired_from.delete_bullet(firing_projectile, TRUE)
		return

	if(!(fired_from.flags_gun_features & GUN_SILENCED))
		playsound(user, fired_from.fire_sound, fired_from.firesound_volume, FALSE)
	else
		playsound(user, fired_from.fire_sound, 25, FALSE)

	shake_camera(user, 1, 2)

	execution_target.apply_damage(damage * 3, BRUTE, "head", no_limb_loss = TRUE, permanent_kill = TRUE) //Apply gobs of damage and make sure they can't be revived later...
	execution_target.apply_damage(200, OXY) //...fill out the rest of their health bar with oxyloss...
	execution_target.death(create_cause_data("execution", user)) //...make certain they're properly dead...
	shake_camera(execution_target, 3, 4)
	execution_target.update_headshot_overlay(headshot_state) //...and add a gory headshot overlay.

	execution_target.visible_message(SPAN_HIGHDANGER(uppertext("[execution_target] WAS EXECUTED!")),
		SPAN_HIGHDANGER("You WERE EXECUTED!"))

	user.count_niche_stat(STATISTICS_NICHE_EXECUTION, 1, firing_projectile.weapon_cause_data?.cause_name)

	var/area/execution_area = get_area(execution_target)
	msg_admin_ff("[key_name(user)] [ADMIN_JMP_USER(user)] [ADMIN_PM(user)] has <b>battlefield executed</b> [key_name(execution_target)] [ADMIN_JMP(execution_target)] [ADMIN_PM(execution_target)] at [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]) using [fired_from].")
	log_attack("[key_name(usr)] battlefield executed [key_name(execution_target)] at [execution_area.name].")

	if(flags_ammo_behavior & AMMO_EXPLOSIVE)
		execution_target.gib()

