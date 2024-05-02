#define LOCKDOWN_READY 0
#define LOCKDOWN_ACTIVE 1
GLOBAL_VAR_INIT(med_lockdown_state, LOCKDOWN_READY)

/obj/structure/machinery/biohazard_lockdown
	name = "Emergency Containment Breach"
	icon_state = "big_red_button_tablev"
	unslashable = TRUE
	unacidable = TRUE
	COOLDOWN_DECLARE(containment_lockdown)

/obj/structure/machinery/biohazard_lockdown/ex_act(severity)
	return FALSE

/obj/structure/machinery/biohazard_lockdown/attack_remote(mob/user as mob)
	return FALSE

/obj/structure/machinery/biohazard_lockdown/attack_alien(mob/user as mob)
	return FALSE

/obj/structure/machinery/biohazard_lockdown/attackby(obj/item/attacking_item, mob/user)
	return attack_hand(user)

/obj/structure/machinery/biohazard_lockdown/attack_hand(mob/living/user)
	if(isxeno(user))
		return FALSE
	if(!allowed(user))
		to_chat(user, SPAN_DANGER("Access Denied"))
		flick(initial(icon_state) + "-denied", src)
		return FALSE

	if(!COOLDOWN_FINISHED(src, containment_lockdown))
		to_chat(user, SPAN_BOLDWARNING("Biohazard Lockdown procedures are on cooldown! They will be ready in [COOLDOWN_SECONDSLEFT(src, containment_lockdown)] seconds!"))
		return FALSE

	add_fingerprint(user)
	biohazard_lockdown(user)
	COOLDOWN_START(src, containment_lockdown, 5 MINUTES)

/obj/structure/machinery/door/poddoor/almayer/biohazard
	name = "Biohazard Containment Airlock"
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/biohazard/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_RESEARCH_LOCKDOWN, PROC_REF(close))
	RegisterSignal(SSdcs, COMSIG_GLOB_RESEARCH_LIFT, PROC_REF(open))

/obj/structure/machinery/door/poddoor/almayer/biohazard/white
	icon_state = "w_almayer_pdoor1"
	base_icon_state = "w_almayer_pdoor"

/client/proc/admin_biohazard_alert()
	set name = "Research Containment Lockdown"
	set category = "Admin.Ship"

	if(!admin_holder ||!check_rights(R_EVENT))
		return FALSE

	var/prompt = tgui_alert(src, "Are you sure you want to trigger a containment breach alert? This will force red alert, and lockdown research.", "Choose.", list("Yes", "No"), 20 SECONDS)
	if(prompt != "Yes")
		return FALSE

	prompt = tgui_alert(src, "Do you want to use a custom announcement?", "Choose.", list("Yes", "No"), 20 SECONDS)
	if(prompt == "Yes")
		var/message = tgui_input_text(src, "Please enter announcement text.", "what?")
		biohazard_lockdown(usr, message, admin = TRUE)
	else
		biohazard_lockdown(usr, admin = TRUE)
	return TRUE

/proc/biohazard_lockdown(mob/user, message, admin = FALSE)
	if(IsAdminAdvancedProcCall())
		return PROC_BLOCKED

	var/log = "[key_name(user)] triggered research bio lockdown!"
	var/ares_log = "Triggered Medical Research Biohazard Containment Lockdown."
	var/person = user.name
	if(!message)
		message = "ATTENTION! \n\nBIOHAZARD CONTAINMENT BREACH. \n\nRESEARCH DEPARTMENT UNDER LOCKDOWN."
	else
		log = "[key_name(user)] triggered research bio lockdown! (Using a custom announcement)."
	if(admin)
		log += " (Admin Triggered)."
		person = MAIN_AI_SYSTEM

	switch(GLOB.med_lockdown_state)
		if(LOCKDOWN_READY)
			GLOB.med_lockdown_state = LOCKDOWN_ACTIVE
			if(GLOB.security_level < SEC_LEVEL_RED)
				set_security_level(SEC_LEVEL_RED, TRUE, FALSE)
			SEND_GLOBAL_SIGNAL(COMSIG_GLOB_RESEARCH_LOCKDOWN)
		if(LOCKDOWN_ACTIVE)
			GLOB.med_lockdown_state = LOCKDOWN_READY
			message = "ATTENTION! \n\nBIOHAZARD CONTAINMENT LOCKDOWN LIFTED."
			log = "[key_name(user)] lifted research bio lockdown!"
			ares_log = "Lifted Medical Research Biohazard Containment Lockdown."
			if(admin)
				log += " (Admin Triggered)."
				person = MAIN_AI_SYSTEM

			if(GLOB.security_level > SEC_LEVEL_GREEN)
				set_security_level(SEC_LEVEL_BLUE, TRUE, FALSE)
			SEND_GLOBAL_SIGNAL(COMSIG_GLOB_RESEARCH_LIFT)

	shipwide_ai_announcement(message, MAIN_AI_SYSTEM, 'sound/effects/biohazard.ogg')
	message_admins(log)
	log_ares_security("Containment Lockdown", ares_log, person)

#undef LOCKDOWN_READY
#undef LOCKDOWN_ACTIVE
