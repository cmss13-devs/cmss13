/datum/xeno_strain/healer
	name = DRONE_HEALER
	description = "You lose your choice of resin secretions, a chunk of your slash damage, and you will experience a slighty-increased difficulty in tackling hosts in exchange for strong pheromones, the ability to use a bit of your health to plant a maximum of three lesser resin fruits, and the ability to heal your sisters' wounds by secreting a regenerative resin salve by using your vital fluids and a fifth of your plasma. Be wary, this is a dangerous process; overexert yourself and you may exhaust yourself to unconsciousness, or die..."
	flavor_description = "Divided we fall, united we win. We live for the hive, we die for the hive."
	icon_state_prefix = "Healer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/transfer_plasma,
		/datum/action/xeno_action/activable/place_construction, // so it doesn't use fifth macro
		/datum/action/xeno_action/onclick/plant_weeds, // so it doesn't break order
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/place_construction/not_primary, // so it doesn't use fifth macro
		/datum/action/xeno_action/onclick/plant_weeds, // so it doesn't break order
		/datum/action/xeno_action/onclick/plant_resin_fruit, // Second macro. Resin fruits belong to Gardener, but Healer has a minor variant.
		/datum/action/xeno_action/activable/apply_salve, //Third macro, heal over time ability.
		/datum/action/xeno_action/activable/transfer_plasma/healer, //Fourth macro, an improved plasma transfer.
		/datum/action/xeno_action/activable/healer_sacrifice, //Fifth macro, the ultimate ability to sacrifice yourself
	)

	behavior_delegate_type = /datum/behavior_delegate/drone_healer

/datum/xeno_strain/healer/apply_strain(mob/living/carbon/xenomorph/drone/drone)
	drone.phero_modifier += XENO_PHERO_MOD_LARGE
	drone.plasma_types += PLASMA_PHEROMONE
	drone.damage_modifier -= XENO_DAMAGE_MOD_VERY_SMALL
	drone.tackle_chance_modifier -= 5

	drone.max_placeable = 3
	drone.available_fruits = list(/obj/effect/alien/resin/fruit)
	drone.selected_fruit = /obj/effect/alien/resin/fruit

	drone.recalculate_everything()

/*
	Improved Plasma Transfer
*/

/datum/action/xeno_action/activable/transfer_plasma/healer //Improved plasma transfer, but not as much as Hivey.
	ability_primacy = XENO_PRIMARY_ACTION_4
	plasma_transfer_amount = 100
	transfer_delay = 15
	max_range = 1

/*
	Apply Resin Salve
*/

/datum/action/xeno_action/activable/apply_salve
	name = "Apply Resin Salve"
	action_icon_state = "apply_salve"
	ability_name = "Apply Resin Salve"
	var/health_transfer_amount = 100
	var/max_range = 1
	var/damage_taken_mod = 0.75
	macro_path = /datum/action/xeno_action/verb/verb_apply_salve
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/apply_salve/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.xeno_apply_salve(target_atom, health_transfer_amount, max_range, damage_taken_mod)
	return ..()

/datum/action/xeno_action/verb/verb_apply_salve()
	set category = "Alien"
	set name = "Apply Resin Salve"
	set hidden = TRUE
	var/action_name = "Apply Resin Salve"
	handle_xeno_macro(src, action_name)

/mob/living/carbon/xenomorph/proc/xeno_apply_salve(mob/living/carbon/xenomorph/target_xeno, amount = 100, max_range = 1, damage_taken_mod = 0.75)

	if(!check_plasma(amount * 2))
		return

	if(!istype(target_xeno))
		return

	if(target_xeno == src)
		to_chat(src, SPAN_XENOWARNING("We can't heal ourself with our own resin salve!"))
		return

	if(!check_state())
		return

	if(SEND_SIGNAL(target_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		to_chat(src, SPAN_XENOWARNING("Extinguish [target_xeno] first or the flames will burn our resin salve away!"))
		return

	if(!can_not_harm(target_xeno)) //We don't wanna heal hostile hives, but we do want to heal our allies!
		to_chat(src, SPAN_XENOWARNING("[target_xeno] is hostile to our hive!"))
		return

	if(!isturf(loc))
		to_chat(src, SPAN_XENOWARNING("We can't apply our resin salve from here!"))
		return

	if(get_dist(src, target_xeno) > max_range)
		to_chat(src, SPAN_XENOWARNING("We need to be closer to [target_xeno] to apply our resin salve!"))
		return

	if(target_xeno.stat == DEAD)
		to_chat(src, SPAN_XENOWARNING("[target_xeno] is dead!"))
		return

	if(target_xeno.health >= target_xeno.maxHealth)
		to_chat(src, SPAN_XENOWARNING("[target_xeno] is already at max health!"))
		return

	//Tiny xenos (Larva and Facehuggers), don't need as much health so don't cost as much.
	if(target_xeno.mob_size == MOB_SIZE_SMALL)
		amount = amount * 0.15
		damage_taken_mod = 1

	//Forces an equivalent exchange of health between healers so they do not spam heal each other to full health.
	var/target_is_healer = istype(target_xeno.strain, /datum/xeno_strain/healer)
	if(target_is_healer)
		damage_taken_mod = 1

	face_atom(target_xeno)
	adjustBruteLoss(amount * damage_taken_mod)
	use_plasma(amount * 2)
	updatehealth()
	new /datum/effects/heal_over_time(target_xeno, amount, 10, 1)
	target_xeno.xeno_jitter(1 SECONDS)
	target_xeno.flick_heal_overlay(10 SECONDS, "#00be6f")
	to_chat(target_xeno, SPAN_XENOWARNING("[src] covers our wounds with a regenerative resin salve. We feel reinvigorated!"))
	to_chat(src, SPAN_XENOWARNING("We regurgitate our vital fluids and some plasma to create a regenerative resin salve and apply it to [target_xeno]'s wounds. We feel weakened..."))
	playsound(src, "alien_drool", 25)
	var/datum/behavior_delegate/drone_healer/healer_delegate = behavior_delegate
	healer_delegate.salve_applied_recently = TRUE
	if(!target_is_healer && !isfacehugger(target_xeno)) // no cheap grinding
		healer_delegate.modify_transferred(amount * damage_taken_mod)
	update_icons()
	addtimer(CALLBACK(healer_delegate, /datum/behavior_delegate/drone_healer/proc/un_salve), 10 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)

/datum/behavior_delegate/drone_healer
	name = "Healer Drone Behavior Delegate"

	var/salve_applied_recently = FALSE
	var/mutable_appearance/salve_applied_icon

	var/transferred_amount = 0
	var/required_transferred_amount = 7500

/datum/behavior_delegate/drone_healer/on_update_icons()
	if(!salve_applied_icon)
		salve_applied_icon = mutable_appearance('icons/mob/xenos/drone_strain_overlays.dmi',"Healer Drone Walking")

	bound_xeno.overlays -= salve_applied_icon
	salve_applied_icon.overlays.Cut()

	if(!salve_applied_recently)
		return

	if(bound_xeno.stat == DEAD)
		salve_applied_icon.icon_state = "Healer Drone Dead"
	else if(bound_xeno.body_position == LYING_DOWN)
		if(!HAS_TRAIT(bound_xeno, TRAIT_INCAPACITATED) && !HAS_TRAIT(bound_xeno, TRAIT_FLOORED))
			salve_applied_icon.icon_state = "Healer Drone Sleeping"
		else
			salve_applied_icon.icon_state = "Healer Drone Knocked Down"
	else
		salve_applied_icon.icon_state = "Healer Drone Walking"

	bound_xeno.overlays += salve_applied_icon

/datum/behavior_delegate/drone_healer/proc/un_salve()
	salve_applied_recently = FALSE
	bound_xeno.update_icons()

/*
	SACRIFICE
*/

/datum/behavior_delegate/drone_healer/proc/modify_transferred(amount)
	transferred_amount += amount

/datum/behavior_delegate/drone_healer/append_to_stat()
	. = list()
	. += "Transferred health amount: [transferred_amount]/[required_transferred_amount]"
	if(transferred_amount >= required_transferred_amount)
		. += "Sacrifice will grant you new life."

/datum/behavior_delegate/drone_healer/on_life()
	if(!bound_xeno)
		return
	if(bound_xeno.stat == DEAD)
		return
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_transferred = min(round((transferred_amount / required_transferred_amount) * 100, 10), 100)
	if(percentage_transferred)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_transferred]")

/datum/behavior_delegate/drone_healer/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/action/xeno_action/activable/healer_sacrifice
	name = "Sacrifice"
	action_icon_state = "screech"
	ability_name = "sacrifice"
	var/max_range = 1
	var/transfer_mod = 0.75 // only transfers 75% of current healer's health
	macro_path = /datum/action/xeno_action/verb/verb_healer_sacrifice
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/verb/verb_healer_sacrifice()
	set category = "Alien"
	set name = "Sacrifice"
	set hidden = TRUE
	var/action_name = "Sacrifice"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/healer_sacrifice/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/xenomorph/target = atom

	if(!istype(target))
		return

	if(target == xeno)
		to_chat(xeno, "We can't heal ourself!")
		return

	if(isfacehugger(target) || islesserdrone(target))
		to_chat(xeno, "It would be a waste...")
		return

	if(!xeno.check_state())
		return

	if(!xeno.can_not_harm(target)) //so we can heal only allies
		to_chat(xeno, SPAN_WARNING("[target] is an enemy of our hive!"))
		return

	if(target.stat == DEAD)
		to_chat(xeno, SPAN_WARNING("[target] is already dead!"))
		return

	if(target.health >= target.maxHealth)
		to_chat(xeno, SPAN_WARNING("[target] is already at max health!"))
		return

	if(!isturf(xeno.loc))
		to_chat(xeno, SPAN_WARNING("We cannot transfer health from here!"))
		return

	if(get_dist(xeno, target) > max_range)
		to_chat(xeno, SPAN_WARNING("We need to be closer to [target]."))
		return

	xeno.say(";MY LIFE FOR THE QUEEN!!!")

	target.gain_health(xeno.health * transfer_mod)
	target.updatehealth()

	target.xeno_jitter(1 SECONDS)
	target.flick_heal_overlay(3 SECONDS, "#44253d")

	target.visible_message(SPAN_XENONOTICE("[xeno] explodes in a deluge of regenerative resin salve, covering [target] in it!"))
	xeno_message(SPAN_XENOANNOUNCE("[xeno] sacrifices itself to heal [target]!"), 2, target.hive.hivenumber)

	var/datum/behavior_delegate/drone_healer/behavior_delegate = xeno.behavior_delegate
	if(istype(behavior_delegate) && behavior_delegate.transferred_amount >= behavior_delegate.required_transferred_amount && xeno.client && xeno.hive)
		var/datum/hive_status/hive_status = xeno.hive
		var/turf/spawning_turf = get_turf(xeno)
		if(!hive_status.hive_location)
			addtimer(CALLBACK(xeno.hive, TYPE_PROC_REF(/datum/hive_status, respawn_on_turf), xeno.client, spawning_turf), 0.5 SECONDS)
		else
			addtimer(CALLBACK(xeno.hive, TYPE_PROC_REF(/datum/hive_status, free_respawn), xeno.client), 5 SECONDS)

	xeno.gib(create_cause_data("sacrificing itself", src))

/datum/action/xeno_action/activable/healer_sacrifice/action_activate()
	..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.selected_ability != src)
		return
	var/datum/behavior_delegate/drone_healer/behavior_delegate = xeno.behavior_delegate
	if(!istype(behavior_delegate))
		return
	if(behavior_delegate.transferred_amount < behavior_delegate.required_transferred_amount)
		to_chat(xeno, SPAN_HIGHDANGER("Warning: [name] is a last measure skill. Using it will kill us."))
	else
		to_chat(xeno, SPAN_HIGHDANGER("Warning: [name] is a last measure skill. Using it will kill us, but new life will be granted for our hard work for the hive."))
