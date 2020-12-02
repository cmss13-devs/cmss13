// CORSAT Monorail Console (largely a duplicate of shuttle code)
/obj/structure/machinery/computer/shuttle_control/monorail
	name = "monorail control console"
	desc = "The control system for the CORSAT monorail."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"

	shuttle_type = SHUTTLE_GROUND
	skip_time_lock = TRUE
	unacidable = 1
	exproof = 1

/obj/structure/machinery/computer/shuttle_control/monorail/New()
	..()
	shuttle_tag = "Ground Transport 1"

// Modified attack_hand to reduce the take-back time and some ID-locking stuff
/obj/structure/machinery/computer/shuttle_control/monorail/attack_hand(mob/user)
	if (stat & NOPOWER)
		return 1

	if((!allowed(user) || ismaintdrone(user)) && !isXeno(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return 1

	user.set_interaction(src)

	var/datum/shuttle/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]

	if(!isXeno(user) && (onboard || is_ground_level(z)))
		if(shuttle.queen_locked)
			if(onboard && (isSynth(user) || user.job == "Pilot Officer"))
				user.visible_message(SPAN_NOTICE("[user] starts to type on the [src]."),
				SPAN_NOTICE("You try to take back the control over the monorail. It will take around 1 minute."))
				if(do_after(user, MINUTES_1, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
					if(user.lying)
						return 0
					shuttle.last_locked = world.time
					shuttle.queen_locked = 0
					shuttle.last_door_override = world.time
					shuttle.door_override = 0
					user.visible_message(SPAN_NOTICE("The [src] blinks with blue lights."),
					SPAN_NOTICE("You have successfully taken back the control over the monorail."))
					ui_interact(user)
				return
			else
				if(world.time < shuttle.last_locked + MONORAIL_LOCK_COOLDOWN)
					to_chat(user, SPAN_WARNING("You can't seem to re-enable remote control, some sort of safety cooldown is in place. Please wait another [round((shuttle.last_locked + MONORAIL_LOCK_COOLDOWN - world.time)/MINUTES_1)] minutes before trying again."))
				else
					to_chat(user, SPAN_NOTICE("You interact with the pilot's console and re-enable remote control."))
					shuttle.last_locked = world.time
					shuttle.queen_locked = 0
		if(shuttle.door_override)
			if(world.time < shuttle.last_door_override + MONORAIL_LOCK_COOLDOWN)
				to_chat(user, SPAN_WARNING("You can't seem to reverse the door override. Please wait another [round((shuttle.last_door_override + MONORAIL_LOCK_COOLDOWN - world.time)/MINUTES_1)] minutes before trying again."))
			else
				to_chat(user, SPAN_NOTICE("You reverse the door override."))
				shuttle.last_door_override = world.time
				shuttle.door_override = 0
	ui_interact(user)

// Duplicated and much-stripped down topic/UI code for the monorail control consoles.
/obj/structure/machinery/computer/shuttle_control/monorail/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	var/data[0]
	var/datum/shuttle/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if (!istype(shuttle))
		return

	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE)
			shuttle_state = "idle"
		if(SHUTTLE_WARMUP)
			shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT)
			shuttle_state = "in_transit"
		if(SHUTTLE_CRASHED)
			shuttle_state = "crashed"

	var/shuttle_status
	switch (shuttle.process_state)
		if(IDLE_STATE)
			if (shuttle.in_use)
				shuttle_status = "Busy."
			else
				shuttle_status = "Standing by."
		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Monorail has received command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to destination."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	var/shuttle_status_message
	var/recharge_status = shuttle.recharge_time
	var/effective_recharge_time = shuttle.recharge_time

	data = list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.docking_controller? 1 : 0,
		"docking_status" = shuttle.docking_controller? shuttle.docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.docking_controller? shuttle.docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(),
		"can_cancel" = shuttle.can_cancel(),
		"can_force" = shuttle.can_force(),
		"can_optimize" = shuttle.can_optimize(),
		"optimize_allowed" = shuttle.can_be_optimized,
		"optimized" = shuttle.transit_optimized,
		"gun_mission_allowed" = shuttle.can_do_gun_mission,
		"shuttle_status_message" = shuttle_status_message,
		"recharging" = shuttle.recharging,
		"recharging_seconds" = round(shuttle.recharging/10),
		"flight_seconds" = round(shuttle.in_transit_time_left/10),
		"can_return_home" = shuttle.transit_gun_mission && shuttle.moving_status == SHUTTLE_INTRANSIT && shuttle.in_transit_time_left>abort_timer,
		"recharge_time" = effective_recharge_time,
		"recharge_status" = recharge_status,
		"human_user" = ishuman(user),
		"onboard" = onboard,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "monorail_control_console.tmpl", "Monorail Control", 550, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/structure/machinery/computer/shuttle_control/monorail/Topic(href, href_list)
	..()

	add_fingerprint(usr)

	var/datum/shuttle/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if (!istype(shuttle))
		return

	if(href_list["move"])
		if(shuttle.recharging) //Prevent the shuttle from moving again until it finishes recharging. This could be made to look better by using the shuttle computer's visual UI.
			to_chat(usr, SPAN_WARNING("The monorail is loading and unloading. Please hold."))

		if(shuttle.queen_locked && !isXenoQueen(usr))
			to_chat(usr, SPAN_WARNING("The monorail isn't responding to prompts, it looks like remote control was disabled."))
			return

		if(!skip_time_lock && world.time < ticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK && istype(shuttle, /datum/shuttle/ferry/marine))
			to_chat(usr, SPAN_WARNING("The monorail is still charging and cannot depart yet. Please wait another [round((ticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK-world.time)/600)] minutes before trying again."))
			return

		sleep(0)

		if(shuttle.moving_status == SHUTTLE_IDLE) //Multi consoles, hopefully this will work

			if(shuttle.locked)
				return

			//Alert code is the Queen is the one calling it, the shuttle is on the ground and the shuttle still allows alerts
			if(isXenoQueen(usr) && shuttle.location == 1 && shuttle.alerts_allowed)
				var/i = alert("Confirm hijack and launch?", "WARNING", "Yes", "No")

				if(shuttle.moving_status != SHUTTLE_IDLE || shuttle.locked || shuttle.location != 1 || !shuttle.alerts_allowed || !shuttle.queen_locked || shuttle.recharging)
					return

				if(istype(shuttle, /datum/shuttle/ferry/marine) && is_ground_level(z) && i == "Yes")

					var/datum/shuttle/ferry/marine/shuttle1 = shuttle
					shuttle1.transit_gun_mission = 0
					shuttle1.alerts_allowed--
					//round_statistics.count_hijack_mobs_for_statistics()
					marine_announcement("Unauthorized monorail departure detected", "CORSAT Monorail Authority Alert", 'sound/misc/notice2.ogg')
					to_chat(usr, SPAN_DANGER("A loud alarm erupts from [src]! The fleshy hosts must know that you can access it!"))
					var/mob/living/carbon/Xenomorph/Queen/Q = usr // typechecked above
					xeno_message(SPAN_XENOANNOUNCE("The Queen has commanded the metal crawler to depart! Rejoice!"), 3 ,Q.hivenumber)

					playsound(src, 'sound/misc/queen_alarm.ogg')
					shuttle1.launch(src)

				else if(i == "No")
					return
				else
					shuttle.launch(src)

			else
				shuttle.launch(src)

			msg_admin_niche("[usr] ([usr.key]) launched the monorail using [src].")

	ui_interact(usr)
