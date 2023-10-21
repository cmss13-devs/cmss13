/*
/datum/action/human_action/synth_bracer/reflex_overclock
	name = "Reflex Overclock"
	action_icon_state = "agility_on"
	cooldown = 20 SECONDS
	charge_cost = 75

	var/ability_duration = 15 SECONDS
	var/ability_timer

/datum/action/human_action/synth_bracer/reflex_overclock/action_activate()
	..()

	to_chat(synth, SPAN_BOLDNOTICE("Your reflexes go into overdrive!"))
	RegisterSignal(synth, COMSIG_HUMAN_PRE_BULLET_ACT, .proc/handle_reflex_overclock)
	synth.add_filter("reflex_overclock_on", 1, list("type" = "outline", "color" = "#d9ffd93b", "size" = 1))
	synth_bracer.icon_state = "bracer_protect"

	RegisterSignal(synth_bracer, COMSIG_ITEM_DROPPED, .proc/handle_dropped)
	ability_timer = addtimer(CALLBACK(src, .proc/disable_reflex_overclock, synth), ability_duration, TIMER_UNIQUE|TIMER_STOPPABLE)

/datum/action/human_action/synth_bracer/reflex_overclock/proc/handle_reflex_overclock(mob/signal_owner, obj/item/projectile/projectile)
	SIGNAL_HANDLER

	projectile.handle_miss(synth)
	return COMPONENT_CANCEL_BULLET_ACT

/datum/action/human_action/synth_bracer/reflex_overclock/proc/handle_dropped(obj/item/clothing/gloves/synth/bracer, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	deltimer(ability_timer)
	ability_timer = null

	disable_reflex_overclock(user, bracer)

/datum/action/human_action/synth_bracer/reflex_overclock/proc/disable_reflex_overclock(mob/living/carbon/human/synth_user, obj/item/clothing/gloves/synth/bracer)
	if(synth)
		synth_user = synth
	if(synth_bracer)
		bracer = synth_bracer
	to_chat(synth_user, SPAN_BOLDNOTICE("Your programming returns to normal clock speeds."))
	UnregisterSignal(synth_user, COMSIG_HUMAN_PRE_BULLET_ACT)
	UnregisterSignal(bracer, COMSIG_ITEM_DROPPED)
	synth_user.remove_filter("reflex_overclock_on")
	bracer.update_icon()
*/
