#define LOCKDOWN_READY 0
#define LOCKDOWN_ACTIVE 1
GLOBAL_VAR_INIT(ai_lockdown_state, LOCKDOWN_READY)

/obj/structure/machinery/aicore_lockdown
	name = "Emergency Containment Breach"
	icon_state = "big_red_button_tablev"
	unslashable = TRUE
	unacidable = TRUE
	COOLDOWN_DECLARE(containment_lockdown)

/obj/structure/machinery/aicore_lockdown/ex_act(severity)
	return FALSE

/obj/structure/machinery/aicore_lockdown/attack_remote(mob/user as mob)
	return FALSE

/obj/structure/machinery/aicore_lockdown/attack_alien(mob/user as mob)
	return FALSE

/obj/structure/machinery/aicore_lockdown/attackby(obj/item/attacking_item, mob/user)
	return attack_hand(user)

/obj/structure/machinery/aicore_lockdown/attack_hand(mob/living/user)
	if(isxeno(user))
		return FALSE
	if(!allowed(user))
		to_chat(user, SPAN_DANGER("Access Denied"))
		flick(initial(icon_state) + "-denied", src)
		return FALSE

	if(!COOLDOWN_FINISHED(src, containment_lockdown))
		to_chat(user, SPAN_BOLDWARNING("AI Core Lockdown procedures are on cooldown! They will be ready in [COOLDOWN_SECONDSLEFT(src, containment_lockdown)] seconds!"))
		return FALSE

	add_fingerprint(user)
	aicore_lockdown(user)
	COOLDOWN_START(src, containment_lockdown, 5 MINUTES)

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown
	name = "ARES Emergency Lockdown Shutter"
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/aicore
	icon_state = "aidoor1"
	base_icon_state = "aidoor"

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_AICORE_LOCKDOWN, PROC_REF(close))
	RegisterSignal(SSdcs, COMSIG_GLOB_AICORE_LIFT, PROC_REF(open))

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/white
	icon_state = "w_almayer_pdoor1"
	base_icon_state = "w_almayer_pdoor"

/client/proc/admin_aicore_alert()
	set name = "AI Core Lockdown"
	set category = "Admin.Ship"

	if(!admin_holder ||!check_rights(R_EVENT))
		return FALSE

	var/prompt = tgui_alert(src, "Are you sure you want to trigger an AI Core lockdown alert? This will force red alert, and lockdown the AI Core.", "Choose.", list("Yes", "No"), 20 SECONDS)
	if(prompt != "Yes")
		return FALSE

	prompt = tgui_alert(src, "Do you want to use a custom announcement?", "Choose.", list("Yes", "No"), 20 SECONDS)
	if(prompt == "Yes")
		var/whattoannounce = tgui_input_text(src, "Please enter announcement text.", "what?")
		aicore_lockdown(usr, whattoannounce, TRUE)
	else
		aicore_lockdown(usr, admin = TRUE)
	return TRUE

/proc/aicore_lockdown(mob/user, message, admin = FALSE)
	if(IsAdminAdvancedProcCall())
		return PROC_BLOCKED

	var/log = "[key_name(user)] triggered research AI core lockdown!"
	var/ares_log = "[user.name] triggered triggered AI Core Emergency Lockdown."
	if(!message)
		message = "ATTENTION! \n\nCORE SECURITY ALERT. \n\nAI CORE UNDER LOCKDOWN."
	else
		log = "[key_name(user)] triggered AI core emergency lockdown! (Using a custom announcement)."
	if(admin)
		log += " (Admin Triggered)."
		ares_log = "[MAIN_AI_SYSTEM] triggered AI Core Emergency Lockdown."

	switch(GLOB.ai_lockdown_state)
		if(LOCKDOWN_READY)
			GLOB.ai_lockdown_state = LOCKDOWN_ACTIVE
			set_security_level(SEC_LEVEL_RED, TRUE, FALSE)
			SEND_GLOBAL_SIGNAL(COMSIG_GLOB_AICORE_LOCKDOWN)
		if(LOCKDOWN_ACTIVE)
			GLOB.ai_lockdown_state = LOCKDOWN_READY
			message = "ATTENTION! \n\nAI CORE EMERGENCY LOCKDOWN LIFTED."
			log = "[key_name(user)] lifted AI core lockdown!"
			ares_log = "[user.name] lifted AI Core Emergency Lockdown."
			if(admin)
				log += " (Admin Triggered)."
				ares_log = "[MAIN_AI_SYSTEM] lifted AI Core Emergency Lockdown."

			set_security_level(SEC_LEVEL_BLUE, TRUE, FALSE)
			SEND_GLOBAL_SIGNAL(COMSIG_GLOB_AICORE_LIFT)

	shipwide_ai_announcement(message, MAIN_AI_SYSTEM, 'sound/effects/biohazard.ogg')
	message_admins(log)
	log_ares_security("AI Core Lockdown", ares_log)

#undef LOCKDOWN_READY
#undef LOCKDOWN_ACTIVE
