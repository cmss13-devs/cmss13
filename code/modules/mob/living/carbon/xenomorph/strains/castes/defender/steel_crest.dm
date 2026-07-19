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


/datum/action/xeno_action/onclick/soak/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	RegisterSignal(xeno, COMSIG_MOB_TAKE_DAMAGE, PROC_REF(damage_accumulate))
	addtimer(CALLBACK(src, PROC_REF(stop_accumulating)), 6 SECONDS)
	start_duration_display(6 SECONDS)

	xeno.balloon_alert(xeno, "begins to tank incoming damage!")

	to_chat(xeno, SPAN_XENONOTICE("We begin to tank incoming damage!"))

	xeno.add_filter("steelcrest_enraging", 1, list("type" = "outline", "color" = "#421313", "size" = 1))

	apply_cooldown()
	return ..()


/datum/action/xeno_action/onclick/soak/proc/damage_accumulate(owner, damage_data, damage_type)
	SIGNAL_HANDLER

	damage_accumulated += damage_data["damage"]

	if(damage_accumulated >= damage_threshold)
		addtimer(CALLBACK(src, PROC_REF(enraged), owner))
		UnregisterSignal(owner, COMSIG_MOB_TAKE_DAMAGE) // Two Unregistersignal because if the enrage proc doesnt happen, then it needs to stop counting

/datum/action/xeno_action/onclick/soak/proc/stop_accumulating()
	UnregisterSignal(owner, COMSIG_MOB_TAKE_DAMAGE)

	end_duration_display()
	damage_accumulated = 0
	to_chat(owner, SPAN_XENONOTICE("We stop taking incoming damage."))
	owner.remove_filter("steelcrest_enraging")

/datum/action/xeno_action/onclick/soak/proc/enraged()

	end_duration_display()
	owner.remove_filter("steelcrest_enraging")
	owner.add_filter("steelcrest_enraged", 1, list("type" = "outline", "color" = "#ad1313", "size" = 1))
	owner.visible_message(SPAN_XENOWARNING("[owner] gets enraged and their carapace start to rapidly mend!"), SPAN_XENOWARNING("We feel enraged after taking in oncoming damage! Our tail slam's cooldown is reset and our carapace start to rapidly mend!"))
	owner.flick_heal_overlay(3 SECONDS, "#00B800")

	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.gain_health(75) // pretty reasonable amount of health recovered

	// Check actions list for tail slam and reset it's cooldown if it's there
	var/datum/action/xeno_action/activable/tail_stab/slam/slam_action = locate() in owner.actions

	if(slam_action && !slam_action.action_cooldown_check())
		slam_action.end_cooldown()


	addtimer(CALLBACK(src, PROC_REF(remove_enrage), owner), 3 SECONDS)


/datum/action/xeno_action/onclick/soak/proc/remove_enrage()
	owner.remove_filter("steelcrest_enraged")

