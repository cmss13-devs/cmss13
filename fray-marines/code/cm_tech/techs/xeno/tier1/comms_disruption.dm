/datum/tech/xeno/powerup/disruption
	name = "Telecommunication Disruption"
	desc = "The Queen's releases a psychic field that temporarily disables telecommunications for a duration of time."
	icon_state = "beacon"

	flags = TREE_FLAG_XENO

	required_points = 5
	increase_per_purchase = 1
	tier = /datum/tier/one/additional

	var/duration = 10 MINUTES
	var/active = FALSE
	xenos_required = FALSE

/datum/tech/xeno/powerup/disruption/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Timed ([DisplayTimeText(duration, 1)])",
			"tooltip" = "Lasts for [DisplayTimeText(duration, 1)] before disabling once purchased.",
			"color" = "orange",
			"icon" = "clock"
		)
	)

/datum/tech/xeno/powerup/disruption/ui_data(mob/user)
	. = ..()
	.["stats_dynamic"] += list(
		list(
			"content" = active? "Active" : "Inactive",
			"color" = active? "green" : "red",
			"icon" = "lightbulb"
		)
	)

/datum/tech/xeno/powerup/disruption/can_unlock(mob/M, datum/techtree/tree)
	. = ..()
	if(!.)
		return
	if(active)
		to_chat(M, SPAN_WARNING("This tech is still active!"))
		return FALSE
	if(!hive.living_xeno_queen)
		return FALSE

/datum/tech/xeno/powerup/disruption/on_unlock(datum/techtree/tree)
	. = ..()
	addtimer(CALLBACK(src, .proc/end_disruption), duration)
	active = TRUE
	RegisterSignal(SSradio, COMSIG_SSRADIO_GET_AVAILABLE_TCOMMS_ZS, .proc/override_available_zlevel)
	for(var/h in GLOB.alive_human_list)
		var/mob/living/carbon/human/H = h
		if(H.z == hive.living_xeno_queen.z && H.get_type_in_ears(/obj/item/device/radio/headset))
			to_chat(H, SPAN_WARNING("Ты чувствуешь, что что-то не так. Вдруг, связь резко прерывается - а из гарнитуры доносится лишь белый шум..."))


/datum/tech/xeno/powerup/disruption/proc/override_available_zlevel(datum/source, list/target_zs)
	SIGNAL_HANDLER
	if(!hive.living_xeno_queen)
		return

	for(var/i in target_zs)
		if(i == hive.living_xeno_queen.z)
			target_zs -= i

/datum/tech/xeno/powerup/disruption/proc/end_disruption()
	active = FALSE
	UnregisterSignal(SSradio, COMSIG_SSRADIO_GET_AVAILABLE_TCOMMS_ZS)
