/datum/action/human_action/synth_bracer/reflex_overclock
	name = "Reflex Overclock"
	action_icon_state = "agility_on"
	cooldown = 20 SECONDS
	charge_cost = 75

	var/ability_duration = 15 SECONDS

/datum/action/human_action/synth_bracer/reflex_overclock/action_activate()
	..()

	to_chat(synth, SPAN_BOLDNOTICE("Your reflexes go into overdrive!"))
	RegisterSignal(synth, COMSIG_HUMAN_PRE_BULLET_ACT, .proc/handle_reflex_overclock)
	synth.add_filter("reflex_overclock_on", 1, list("type" = "outline", "color" = "#d9ffd93b", "size" = 1))

	addtimer(CALLBACK(src, .proc/disable_reflex_overclock), ability_duration)

/datum/action/human_action/synth_bracer/reflex_overclock/proc/handle_reflex_overclock(var/mob/signal_owner, var/obj/item/projectile/projectile)
	SIGNAL_HANDLER

	projectile.handle_miss(synth)
	return COMPONENT_CANCEL_BULLET_ACT

/datum/action/human_action/synth_bracer/reflex_overclock/proc/disable_reflex_overclock()
	to_chat(synth, SPAN_BOLDNOTICE("Your programming returns to normal clock speeds."))
	UnregisterSignal(synth, COMSIG_HUMAN_PRE_BULLET_ACT)
	synth.remove_filter("reflex_overclock_on")
