/datum/component/shield_slash
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/stat_name
	var/max_shield = 160
	var/shield_per_slash = 20
	var/stored_shield = 0

/datum/component/shield_slash/Initialize(var/max_shield = 160, var/shield_per_slash = 20, var/stat_name = "Shield")
	if(!isXeno(parent))
		return COMPONENT_INCOMPATIBLE

	src.max_shield = max_shield
	src.shield_per_slash = shield_per_slash
	src.stat_name = stat_name

/datum/component/shield_slash/RegisterWithParent()
	RegisterSignal(parent, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF, .proc/handle_shield_buildup)
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, .proc/handle_stat_display)

/datum/component/shield_slash/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF,
		COMSIG_XENO_APPEND_TO_STAT
	))

/datum/component/shield_slash/PostTransfer()
	if(!isXeno(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/shield_slash/proc/handle_stat_display(var/mob/living/carbon/Xenomorph/X, var/list/statdata)
	SIGNAL_HANDLER
	statdata += "Stored [stat_name]: [stored_shield]/[max_shield]"

/datum/component/shield_slash/proc/handle_shield_buildup(var/mob/living/carbon/Xenomorph/X)
	SIGNAL_HANDLER
	stored_shield += shield_per_slash
	if(stored_shield < max_shield)
		return
	X.add_xeno_shield(max_shield, XENO_SHIELD_SOURCE_GENERIC)
	X.visible_message(SPAN_XENOWARNING("[X] roars as it mauls its target, its exoskeleton shimmering for a second!"), SPAN_XENOHIGHDANGER("You feel your rage increase your resiliency to damage!"))
	X.xeno_jitter(1 SECONDS)
	X.flick_heal_overlay(2 SECONDS, "#FFA800")
	X.emote("roar")
	stored_shield = 0