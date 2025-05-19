#define STATE_ON "on"
#define STATE_OFF "off"
#define STATE_DEPLETED "depleted"

/obj/structure/machinery/backup_generator
	name = "\improper UE-11 Generator Unit"
	desc = "Special power module designed to be a backup generator in the event of a transformer malfunction. This generator can only provide power for a short time before being used up."
	icon_state = "backup_generator"
	icon = 'icons/obj/structures/machinery/fob_machinery/backup_generator.dmi'
	density = TRUE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	needs_power = FALSE
	var/has_power_remaining = TRUE
	var/power_duration = 5 MINUTES
	var/state = STATE_OFF
	var/timer

/obj/structure/machinery/backup_generator/proc/is_active()
	return state == STATE_ON

/obj/structure/machinery/backup_generator/attackby(obj/item/attack_item, mob/user)
	if(state == STATE_ON)
		return

	if(istype(attack_item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/clamp = attack_item
		if(!clamp.loaded)
			clamp.grab_object(user, src, "ds_gear", 'sound/machines/hydraulics_1.ogg')
			return

/obj/structure/machinery/backup_generator/attack_hand(mob/user)
	if(state == STATE_DEPLETED)
		to_chat(user, SPAN_WARNING("[src] is depleted, use a different generator or activate the main transformer."))
		return

	if(ROUND_TIME < 35 MINUTES)
		to_chat(user, SPAN_WARNING("Turning on [src] right now would be a waste, attempt to secure the transformer first."))
		return

	var/verify = tgui_input_list(user, "Are you SURE you want to turn on the backup generator? (One-time use)", "Confirm", list("Yes", "No"))
	if(verify != "Yes")
		return

	if(GLOB.transformer.is_active())
		to_chat(user, SPAN_WARNING("The main transformer is already active, activating [src] now would be a waste."))
		return

	to_chat(user, SPAN_WARNING("You begin activating [src]."))
	if(!do_after(user, 10 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(user, SPAN_WARNING("You were interrupted."))
		return

	if(GLOB.transformer.is_active())
		to_chat(user, SPAN_WARNING("The main transformer is already active, activating [src] now would be a waste."))
		return

	to_chat(user, SPAN_WARNING("You activate [src]."))
	if(!GLOB.transformer.is_active())
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TRASNFORMER_ON)
	GLOB.transformer.backup = src
	state = STATE_ON
	update_icon()
	marine_announcement("Power Alert: \nBackup generator online. Power grid operational.", "ARES Power Grid Monitor")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts have activated a backup power source!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
	timer = addtimer(CALLBACK(src, PROC_REF(turn_off)), 5 MINUTES, TIMER_STOPPABLE)

/obj/structure/machinery/backup_generator/proc/turn_off()
	state = STATE_DEPLETED
	update_icon()
	GLOB.transformer.backup = null
	if(!GLOB.transformer.is_active())
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TRASNFORMER_OFF)

	marine_announcement("Power Alert: \nBackup generator offline.", "ARES Power Grid Monitor")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts have ran out of backup power!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)

/obj/structure/machinery/backup_generator/update_icon()
	switch(state)
		if(STATE_ON)
			icon_state = "backup_generator_on"
		if(STATE_OFF)
			icon_state = "backup_generator"
		if(STATE_DEPLETED)
			icon_state = "backup_generator_depleted"

/obj/structure/machinery/backup_generator/Destroy()
	if(GLOB.transformer && GLOB.transformer?.backup == src)
		GLOB.transformer.backup = null

	. = ..()

#undef STATE_ON
#undef STATE_OFF
#undef STATE_DEPLETED
