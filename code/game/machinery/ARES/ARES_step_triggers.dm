/obj/effect/step_trigger/ares_alert
	name = "ARES Apollo Sensor"
	layer = 5
	/// Link alerts to ARES Link
	var/datum/ares_link/link
	/// Alert message to report unless area based.
	var/alert_message = "ALERT: Unauthorized movement detected in ARES Core!"
	/// Connect alerts to use same cooldowns
	var/alert_id
	/// Set to true if it should report area name and not specific alert.
	var/area_based = FALSE
	/// Cooldown duration and next time.
	var/cooldown_duration = COOLDOWN_ARES_SENSOR
	COOLDOWN_DECLARE(sensor_cooldown)
	/// The job on a mob to enter
	var/list/pass_jobs = list(JOB_WORKING_JOE, JOB_CHIEF_ENGINEER, JOB_CO)
	/// The accesses on an ID card to enter
	var/pass_accesses = list(ACCESS_MARINE_AI, ACCESS_ARES_DEBUG)

/obj/effect/step_trigger/ares_alert/Crossed(mob/living/passer)
	if(!COOLDOWN_FINISHED(src, sensor_cooldown))//Don't want alerts spammed.
		return FALSE
	if(!passer)
		return FALSE
	if(!(ishuman(passer) || isxeno(passer)))
		return FALSE
	if(HAS_TRAIT(passer, TRAIT_CLOAKED))
		return FALSE
	if(pass_jobs)
		if(passer.job in pass_jobs)
			return FALSE
		if(isxeno(passer) && (JOB_XENOMORPH in pass_jobs))
			return FALSE
	if(ishuman(passer))
		var/mob/living/carbon/human/trespasser = passer
		var/obj/item/card/id/card = trespasser.get_idcard()
		if(pass_accesses && card)
			for(var/tag in pass_accesses)
				if(tag in card.access)
					return FALSE
	Trigger(passer)
	return TRUE


/obj/effect/step_trigger/ares_alert/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/effect/step_trigger/ares_alert/Destroy()
	delink()
	return ..()

/obj/effect/step_trigger/ares_alert/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	if(new_link)
		link = new_link
		new_link.linked_alerts += src
		return TRUE
/obj/effect/step_trigger/ares_alert/proc/delink()
	if(link)
		link.linked_alerts -= src
		link = null


/obj/effect/step_trigger/ares_alert/Trigger(mob/living/passer)
	var/broadcast_message = alert_message
	if(area_based)
		var/area_name = get_area_name(src, TRUE)
		broadcast_message = "ALERT: Unauthorized movement detected in [area_name]!"

	var/datum/ares_link/link = GLOB.ares_link
	if(!ares_can_apollo())
		return FALSE

	to_chat(passer, SPAN_BOLDWARNING("You hear a soft beeping sound as you cross the threshold."))
	ares_apollo_talk(broadcast_message)
	COOLDOWN_START(src, sensor_cooldown, cooldown_duration)
	if(alert_id && link)
		for(var/obj/effect/step_trigger/ares_alert/sensor in link.linked_alerts)
			if(sensor.alert_id == src.alert_id)
				COOLDOWN_START(sensor, sensor_cooldown, cooldown_duration)
	return TRUE

/obj/effect/step_trigger/ares_alert/public
	pass_accesses = list(ACCESS_MARINE_AI_TEMP, ACCESS_MARINE_AI, ACCESS_ARES_DEBUG)
/obj/effect/step_trigger/ares_alert/core
	alert_id = "AresCore"
	pass_accesses = list(ACCESS_MARINE_AI_TEMP, ACCESS_MARINE_AI, ACCESS_ARES_DEBUG)

/obj/effect/step_trigger/ares_alert/mainframe
	alert_id = "AresMainframe"
	alert_message = "ALERT: Unauthorized movement detected in ARES Mainframe!"

/obj/effect/step_trigger/ares_alert/terminals
	alert_id = "AresTerminals"
	alert_message = "ALERT: Unauthorized movement detected in ARES' Operations Center!"

/obj/effect/step_trigger/ares_alert/comms
	area_based = TRUE
	alert_id = "TComms"
	pass_accesses = list(ACCESS_MARINE_CE)


/// Trigger will remove ACCESS_MARINE_AI_TEMP unless ACCESS_MARINE_AI is also present.
/obj/effect/step_trigger/ares_alert/access_control
	name = "ARES Access Control Sensor"
	alert_message = "HARDCODED"
	alert_id = "ARES Access"
	cooldown_duration = COOLDOWN_ARES_ACCESS_CONTROL


/obj/effect/step_trigger/ares_alert/access_control/Crossed(atom/passer as mob|obj)
	if(isobserver(passer) || isxeno(passer))
		return FALSE
	if(!passer)
		return FALSE
	if(HAS_TRAIT(passer, TRAIT_CLOAKED))//Can't be seen/detected to trigger alert.
		return FALSE
	var/area/pass_area = get_area(get_step(passer, passer.dir))
	if(istype(pass_area, /area/almayer/command/airoom))//Don't want it to freak out over someone /entering/ the area. Only leaving.
		return FALSE
	var/obj/item/card/id/idcard
	var/check_contents = TRUE
	if(ishuman(passer))
		var/mob/living/carbon/human/human_passer = passer
		idcard = human_passer.get_idcard()
		if(idcard)
			check_contents = FALSE

	if(istype(passer, /obj/item/card/id))
		idcard = passer
		check_contents = FALSE

	if(check_contents)
		idcard = locate(/obj/item/card/id) in passer
		if(!idcard)
			for(var/obj/item/holder in passer.contents)
				idcard = locate(/obj/item/card/id) in holder.contents
				if(idcard)
					break
	if(!istype(idcard) && ismob(passer))
		Trigger(passer, failure = TRUE)
		return FALSE
	if(!(ACCESS_MARINE_AI_TEMP in idcard.access))//No temp access, don't care
		return FALSE
	if((ACCESS_MARINE_AI in idcard.access) || (ACCESS_ARES_DEBUG in idcard.access))//Permanent access prevents loss of temporary
		return FALSE
	Trigger(passer, idcard)
	return TRUE

/obj/effect/step_trigger/ares_alert/access_control/Trigger(atom/passer, obj/item/card/id/idcard, failure = FALSE)
	var/broadcast_message = get_broadcast(passer, idcard, failure)

	var/datum/ares_link/link = GLOB.ares_link
	if(!ares_can_apollo())
		return FALSE

	to_chat(passer, SPAN_BOLDWARNING("You hear a harsh buzzing sound as you cross the threshold!"))
	if(COOLDOWN_FINISHED(src, sensor_cooldown))//Don't want alerts spammed.
		ares_apollo_talk(broadcast_message)
	if(idcard)
		/// Removes the access from the ID and updates the ID's modification log.
		for(var/obj/item/card/id/identification in link.active_ids)
			if(identification != idcard)
				continue
			idcard.access -= ACCESS_MARINE_AI_TEMP
			link.active_ids -= idcard
			idcard.modification_log += "Temporary AI access revoked by [MAIN_AI_SYSTEM]"
		/// Updates the related access ticket.
		for(var/datum/ares_ticket/access/access_ticket in link.tickets_access)
			if(access_ticket.user_id_num != idcard.registered_gid)
				continue
			access_ticket.ticket_status = TICKET_REVOKED
	COOLDOWN_START(src, sensor_cooldown, COOLDOWN_ARES_ACCESS_CONTROL)
	if(alert_id && link)
		for(var/obj/effect/step_trigger/ares_alert/sensor in link.linked_alerts)
			if(sensor.alert_id == src.alert_id)
				COOLDOWN_START(sensor, sensor_cooldown, COOLDOWN_ARES_ACCESS_CONTROL)
	return TRUE

/obj/effect/step_trigger/ares_alert/access_control/proc/get_broadcast(atom/passer, obj/item/card/id/idcard, failure = FALSE)
	if(isxeno(passer))
		return "Unidentified lifeform detected departing AI Chamber."
	if(ishuman(passer))
		var/mob/living/carbon/human/human_passer = passer
		if(failure)
			return "CAUTION: [human_passer.name] left the AI Chamber without a locatable ID card."
		return "ALERT: [human_passer.name] left the AI Chamber with a temporary access ticket. Removing access."

	if(idcard)
		return "ALERT: ID Card assigned to [idcard.registered_name] left the AI Chamber with a temporary access ticket. Removing access."

	log_debug("ARES ERROR 337: Passer: '[passer]', ID: '[idcard]', F Status: '[failure]'")
	return "Warning: Error 337 - Access Control Anomaly."
