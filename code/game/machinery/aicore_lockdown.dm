/obj/structure/machinery/aicore_lockdown
	name = "AI Core Lockdown"
	icon_state = "big_red_button_tablev"
	unslashable = TRUE
	unacidable = TRUE

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

	if(!COOLDOWN_FINISHED(GLOB.ares_datacore, aicore_lockdown))
		to_chat(user, SPAN_BOLDWARNING("AI Core Lockdown procedures are on cooldown! They will be ready in [COOLDOWN_SECONDSLEFT(GLOB.ares_datacore, aicore_lockdown)] seconds!"))
		return FALSE

	add_fingerprint(user)
	aicore_lockdown(user)

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown
	name = "ARES Emergency Lockdown Shutter"
	density = FALSE
	open_layer = 1.9
	plane = FLOOR_PLANE

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/aicore
	icon_state = "aidoor1"
	base_icon_state = "aidoor"

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/aicore/white
	icon_state = "w_aidoor1"
	base_icon_state = "w_aidoor"

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/white
	icon_state = "w_almayer_pdoor1"
	base_icon_state = "w_almayer_pdoor"

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_AICORE_LOCKDOWN, PROC_REF(close))
	RegisterSignal(SSdcs, COMSIG_GLOB_AICORE_LIFT, PROC_REF(open))


/client/proc/admin_aicore_alert()
	set name = "AI Core Lockdown"
	set category = "Admin.Ship"

	if(!admin_holder ||!check_rights(R_EVENT))
		return FALSE

	var/prompt = "Are you sure you want to trigger an AI Core lockdown? This will raise to red alert, and lockdown the AI Core."

	if(GLOB.ares_datacore.ai_lockdown_active == TRUE)
		prompt = "Are you sure you want to lift the AI Core lockdown? This will lower to blue alert."

	var/choice = tgui_alert(src, prompt, "Choose.", list("Yes", "No"), 20 SECONDS)
	if(choice != "Yes")
		return FALSE

	choice = tgui_alert(src, "Do you want to use a custom announcement?", "Choose.", list("Yes", "No"), 20 SECONDS)
	if(choice == "Yes")
		var/message = tgui_input_text(src, "Please enter announcement text.", "what?")
		aicore_lockdown(usr, message, admin = TRUE)
	else
		aicore_lockdown(usr, admin = TRUE)
	return TRUE

/proc/aicore_lockdown(mob/user, message, admin = FALSE)
	if(IsAdminAdvancedProcCall())
		return PROC_BLOCKED

	var/log = "[key_name(user)] triggered AI core lockdown!"
	var/ares_log = "Triggered triggered AI Core Emergency Lockdown."
	var/person = user.name
	if(message)
		log = "[key_name(user)] triggered AI core emergency lockdown! (Using a custom announcement)."
	if(admin)
		log += " (Admin Triggered)."
		person = MAIN_AI_SYSTEM

	if(GLOB.ares_datacore.ai_lockdown_active)
		GLOB.ares_datacore.ai_lockdown_active = FALSE
		if(!message)
			message = "ATTENTION! \n\nAI CORE EMERGENCY LOCKDOWN LIFTED."
		log = "[key_name(user)] lifted AI core lockdown!"
		ares_log = "Lifted AI Core Emergency Lockdown."
		if(admin)
			log += " (Admin Triggered)."
			person = MAIN_AI_SYSTEM

		if(GLOB.security_level > SEC_LEVEL_GREEN)
			set_security_level(SEC_LEVEL_BLUE, TRUE, FALSE)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_AICORE_LIFT)
	else
		GLOB.ares_datacore.ai_lockdown_active = TRUE
		if(!message)
			message = "ATTENTION! \n\nCORE SECURITY ALERT. \n\nAI CORE UNDER LOCKDOWN."
		if(GLOB.security_level < SEC_LEVEL_RED)
			set_security_level(SEC_LEVEL_RED, TRUE, FALSE)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_AICORE_LOCKDOWN)

	COOLDOWN_START(GLOB.ares_datacore, aicore_lockdown, 2 MINUTES)
	shipwide_ai_announcement(message, MAIN_AI_SYSTEM, 'sound/effects/biohazard.ogg')
	message_admins(log)
	log_ares_security("AI Core Lockdown", ares_log, person)
