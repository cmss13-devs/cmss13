/datum/caste_datum/lesser_drone
	behavior_delegate_type = /datum/behavior_delegate/lesser_base
	available_strains = list(
		/datum/xeno_strain/sacrificer,
		/datum/xeno_strain/scout,
		/datum/xeno_strain/slave,
		)

/datum/behavior_delegate/lesser_base
	name = "Base Lesser Behavior Delegate"

/mob/living/carbon/xenomorph/lesser_drone
	icon_xeno = 'core_ru/icons/mob/xenos/lesser_drone_new.dmi'
	icon_xenonid = 'core_ru/icons/mob/xenos/lesser_drone_new.dmi'

/datum/xeno_strain/sacrificer
	name = "Sacrificer"
	description = "You lose your plasma pool, on it you get ability to sacrifice your own life for heal sisters. Also, you get ability to be invincible for 5 seconds with dead end."
	flavor_description = "Life for Ner... ugh... Queen!"
	icon_state_prefix = "Sacrificer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/onclick/plant_weeds/lesser,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/lesser_sacrifice,
		/datum/action/xeno_action/onclick/lesser_shield,
	)

/datum/xeno_strain/sacrificer/apply_strain(mob/living/carbon/xenomorph/lesser_drone/lesser)
	lesser.health_modifier -= XENO_HEALTH_MOD_MED
	lesser.speed_modifier += XENO_SPEED_FASTMOD_TIER_2

	lesser.recalculate_everything()

//	Способности
/datum/action/xeno_action/activable/lesser_sacrifice
	name = "Sacrifice"
	action_icon_state = "warden_heal"
	macro_path = /datum/action/xeno_action/verb/verb_lesser_sacrifice
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1

/datum/action/xeno_action/verb/verb_lesser_sacrifice()
	set category = "Alien"
	set name = "Sacrifice"
	set hidden = TRUE
	var/action_name = "lesser_sacrifice"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/lesser_sacrifice/use_ability(atom/atom_target)
	. = ..()

	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/xenomorph/target = atom_target

	if(!istype(target))
		return

	if(target == xeno)
		to_chat(xeno, "You can't transfer your life to yourself!")
		return

	if(isfacehugger(target) || islesserdrone(target))
		to_chat(xeno, "He don't deserver this...")
		return

	if(!xeno.check_state())
		return

	if(!xeno.can_not_harm(target))
		to_chat(xeno, SPAN_WARNING("[target] enemy for the hive!"))
		return

	if(target.stat == DEAD)
		to_chat(xeno, SPAN_WARNING("[target] already dead!"))
		return

	if(!isturf(xeno.loc))
		to_chat(xeno, SPAN_WARNING("You need to be free!"))
		return

	if(get_dist(xeno, target) > 1)
		to_chat(xeno, SPAN_WARNING("You need be near!"))
		return

	xeno.say(";ЗА КОРОЛЕВУ!!!")

	target.gain_health(target.maxHealth/5)
	target.updatehealth()
	target.add_xeno_shield(target.maxHealth/5, XENO_SHIELD_SACRIFICE)
	target.overlay_shields()

	target.xeno_jitter(1 SECONDS)
	target.flick_heal_overlay(3 SECONDS, "#c51c1c")

	target.visible_message(SPAN_XENONOTICE("[xeno] blows up with purple fog and covering [target]!"))
	xeno_message(SPAN_XENOANNOUNCE("[xeno] sacrifice own life to heal [target]!"), 2, target.hive.hivenumber)

	xeno.gib(create_cause_data("sacrificing itself", src))

///////////////

/datum/action/xeno_action/onclick/lesser_shield
	name = "Sacrificer shield"
	action_icon_state = "empower"
	macro_path = /datum/action/xeno_action/verb/verb_lesser_shield
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 50
	xeno_cooldown = 26 SECONDS
	var/shield_amount = 300

/datum/action/xeno_action/verb/verb_lesser_shield()
	set category = "Alien"
	set name = "Sacrificer shield"
	set hidden = TRUE
	var/action_name = "lesser_shield"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/onclick/lesser_shield/use_ability(atom/Target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("hide of [xeno] foams and cover itself purple fog!"), SPAN_XENOHIGHDANGER("We need to do this for sisters, FOR THE HIVE!!!"))
	button.icon_state = "template_active"

	xeno.say(";ЗА КОРОЛЕВУ!!!")

	xeno.create_lesser_shield()
	xeno.melee_damage_lower = 0
	xeno.melee_damage_upper = 0
	xeno.melee_vehicle_damage = 0

	xeno.add_xeno_shield(shield_amount, XENO_SHIELD_SACRIFICE)
	xeno.overlay_shields()

	addtimer(CALLBACK(src, PROC_REF(remove_lesser_shield)), 100, TIMER_UNIQUE|TIMER_OVERRIDE)

	apply_cooldown()

	return ..()

/mob/living/carbon/xenomorph/proc/create_lesser_shield()
	remove_overlay(LESSER_SHIELD_OVERLAY)

	var/image/shield = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state" = "shield2", pixel_x = - 16, pixel_y = -8)
	shield.color = "#cf1d1d"
	overlays_standing[LESSER_SHIELD_OVERLAY] = shield
	apply_overlay(LESSER_SHIELD_OVERLAY)
	addtimer(CALLBACK(src, PROC_REF(remove_overlay), LESSER_SHIELD_OVERLAY), 100)


/datum/action/xeno_action/onclick/lesser_shield/proc/remove_lesser_shield()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	var/datum/xeno_shield/found
	for (var/datum/xeno_shield/shield in xeno.xeno_shields)
		if (shield.shield_source == XENO_SHIELD_SACRIFICE)
			found = shield
			break

	if (istype(found))
		found.on_removal()
		qdel(found)
		to_chat(xeno, SPAN_XENOHIGHDANGER("That's end?..."))
		button.icon_state = "template"

	xeno.overlay_shields()

	xeno.gib(create_cause_data("sacrificing itself", src))
