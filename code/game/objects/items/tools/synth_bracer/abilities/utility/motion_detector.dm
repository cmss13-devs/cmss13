/obj/item/clothing/gloves/synth
	var/obj/item/device/motiondetector/integrated/motion_detector
	var/motion_detector_active = FALSE
	var/motion_detector_recycle = 120
	var/motion_detector_cooldown = 2
	var/motion_detector_cost = 2

/obj/item/clothing/gloves/synth/Initialize(mapload, ...)
	. = ..()
	motion_detector = new(src)
	motion_detector.iff_signal = faction

/obj/item/clothing/gloves/synth/process()
	if(!ishuman(loc))
		STOP_PROCESSING(SSobj, src)
		return
	if(!motion_detector_active)
		STOP_PROCESSING(SSobj, src)
		return
	if(battery_charge <= 1)
		motion_detector_active = FALSE
		STOP_PROCESSING(SSobj, src)
		return
	if(motion_detector_active)
		motion_detector_recycle--
		if(!motion_detector_recycle)
			motion_detector_recycle = initial(motion_detector_recycle)
			motion_detector.refresh_blip_pool()

		motion_detector_cooldown--
		if(motion_detector_cooldown)
			return
		motion_detector_cooldown = initial(motion_detector_cooldown)
		motion_detector.scan()
		drain_charge(loc, 2, FALSE)

/obj/item/clothing/gloves/synth/dropped(mob/user)
	. = ..()
	if(motion_detector && motion_detector_active)
		toggle_motion_detector(user)

/obj/item/clothing/gloves/synth/Destroy()
	QDEL_NULL(motion_detector)
	. = ..()

/obj/item/clothing/gloves/synth/proc/toggle_motion_detector(mob/user)
	if(!motion_detector)
		to_chat(user, SPAN_WARNING("No motion detector located!"))
		return FALSE
	to_chat(user, SPAN_NOTICE("You [motion_detector_active? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s motion detector."))
	if(COOLDOWN_FINISHED(src, sound_cooldown))
		playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 35, TRUE)
		COOLDOWN_START(src, sound_cooldown, 5 SECONDS)
	motion_detector_active = !motion_detector_active
	var/datum/action/human_action/synth_bracer/motion_detector/TMD = locate(/datum/action/human_action/synth_bracer/motion_detector) in actions_list_actions
	TMD.update_icon()
	update_icon()

	if(!motion_detector_active)
		STOP_PROCESSING(SSobj, src)
	else
		START_PROCESSING(SSobj, src)
	return TRUE

/datum/action/human_action/synth_bracer/motion_detector
	name = "Toggle Motion Detector"
	action_icon_state = "motion_detector"
	handles_charge_cost = TRUE
	handles_cooldown = TRUE
	charge_cost = 2
	human_adaptable = TRUE

/datum/action/human_action/synth_bracer/motion_detector/action_activate()
	..()
	synth_bracer.toggle_motion_detector(synth)

/datum/action/human_action/synth_bracer/motion_detector/proc/update_icon()
	if(!synth_bracer)
		return

	if(synth_bracer.motion_detector_active)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"
