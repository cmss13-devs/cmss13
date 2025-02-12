/datum/xeno_strain/steel_crest
	name = DEFENDER_STEELCREST
	description = "You trade your tail sweep and a small amount of your slash damage for slightly increased headbutt knockback and damage and the ability to slowly move and headbutt while fortified. Along with this, you gain a unique ability to accumulate damage, and use it to recover a slight amount of health and refresh your tail slam."
	flavor_description = "This one, like my will, is indomitable. It will become my steel crest against all that defy me."
	icon_state_prefix = "Steelcrest"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/onclick/tail_sweep,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/headbutt/steel_crest,
		/datum/action/xeno_action/onclick/soak,
		/datum/action/xeno_action/activable/fortify/steel_crest,
	)

/datum/xeno_strain/steel_crest/apply_strain(mob/living/carbon/xenomorph/defender/defender)
	defender.damage_modifier -= XENO_DAMAGE_MOD_VERY_SMALL
	if(defender.fortify)
		defender.ability_speed_modifier += 2.5
	defender.recalculate_stats()



// Steel crest override
/datum/action/xeno_action/activable/fortify/steel_crest/apply_modifiers(mob/living/carbon/xenomorph/xeno, fortify_state)
	if(fortify_state)
		xeno.armor_deflection_buff += 10
		xeno.armor_explosive_buff += 60
		xeno.ability_speed_modifier += 3
		xeno.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	else
		xeno.armor_deflection_buff -= 10
		xeno.armor_explosive_buff -= 60
		xeno.ability_speed_modifier -= 3
		xeno.damage_modifier += XENO_DAMAGE_MOD_SMALL

/datum/action/xeno_action/activable/fortify/proc/check_directional_armor(mob/living/carbon/xenomorph/defendy, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	// If the defender is facing the projectile.
	if(defendy.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += frontal_armor

/datum/action/xeno_action/activable/fortify/proc/unconscious_check()
	SIGNAL_HANDLER

	if(QDELETED(owner))
		return

	UnregisterSignal(owner, COMSIG_XENO_ENTER_CRIT)
	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	fortify_switch(owner, FALSE)

/datum/action/xeno_action/onclick/soak/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/steelcrest = owner

	if (!action_cooldown_check())
		return

	if (!steelcrest.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	RegisterSignal(steelcrest, COMSIG_XENO_TAKE_DAMAGE, PROC_REF(damage_accumulate))
	addtimer(CALLBACK(src, PROC_REF(stop_accumulating)), 6 SECONDS)

	steelcrest.balloon_alert(steelcrest, "begins to tank incoming damage!")

	to_chat(steelcrest, SPAN_XENONOTICE("We begin to tank incoming damage!"))

	steelcrest.add_filter("steelcrest_enraging", 1, list("type" = "outline", "color" = "#421313", "size" = 1))

	apply_cooldown()
	return ..()


/datum/action/xeno_action/onclick/soak/proc/damage_accumulate(owner, damage_data, damage_type)
	SIGNAL_HANDLER

	damage_accumulated += damage_data["damage"]

	if(damage_accumulated >= damage_threshold)
		addtimer(CALLBACK(src, PROC_REF(enraged), owner))
		UnregisterSignal(owner, COMSIG_XENO_TAKE_DAMAGE) // Two Unregistersignal because if the enrage proc doesnt happen, then it needs to stop counting

/datum/action/xeno_action/onclick/soak/proc/stop_accumulating()
	UnregisterSignal(owner, COMSIG_XENO_TAKE_DAMAGE)

	damage_accumulated = 0
	to_chat(owner, SPAN_XENONOTICE("We stop taking incoming damage."))
	owner.remove_filter("steelcrest_enraging")

/datum/action/xeno_action/onclick/soak/proc/enraged()

	owner.remove_filter("steelcrest_enraging")
	owner.add_filter("steelcrest_enraged", 1, list("type" = "outline", "color" = "#ad1313", "size" = 1))
	owner.visible_message(SPAN_XENOWARNING("[owner] gets enraged after being damaged enough!"), SPAN_XENOWARNING("We feel enraged after taking in oncoming damage! Our tail slam's cooldown is reset and we heal!"))

	var/mob/living/carbon/xenomorph/enraged_mob = owner
	enraged_mob.gain_health(75) // pretty reasonable amount of health recovered

	// Check actions list for tail slam and reset it's cooldown if it's there
	var/datum/action/xeno_action/activable/tail_stab/slam/slam_action = locate() in owner.actions

	if (slam_action && !slam_action.action_cooldown_check())
		slam_action.end_cooldown()


	addtimer(CALLBACK(src, PROC_REF(remove_enrage), owner), 3 SECONDS)


/datum/action/xeno_action/onclick/soak/proc/remove_enrage()
	owner.remove_filter("steelcrest_enraged")

