/datum/keybinding/client/communication
	category = CATEGORY_COMMUNICATION

/datum/keybinding/client/communication/say
	hotkey_keys = list("T")
	classic_keys = list("F3")
	name = SAY_CHANNEL
	full_name = "IC Say"
	keybind_signal = COMSIG_KB_CLIENT_SAY_DOWN

/datum/keybinding/client/communication/say/down(client/user)
	. = ..()
	if(.)
		return
	if(!user.prefs.tgui_say)
		return
	winset(user, null, "command=[user.tgui_say_create_open_command(SAY_CHANNEL)]")
	return TRUE

/datum/keybinding/client/communication/ooc
	hotkey_keys = list("O")
	classic_keys = list("F2")
	name = OOC_CHANNEL
	full_name = "Out Of Character Say (OOC)"
	keybind_signal = COMSIG_KB_CLIENT_OOC_DOWN

/datum/keybinding/client/communication/ooc/down(client/user)
	. = ..()
	if(.)
		return
	if(!user.prefs.tgui_say)
		return
	winset(user, null, "command=[user.tgui_say_create_open_command(OOC_CHANNEL)]")
	return TRUE

/datum/keybinding/client/communication/looc
	hotkey_keys = list("L")
	classic_keys = list("Unbound")
	name = LOOC_CHANNEL
	full_name = "Local Out Of Character Say (OOC)"
	keybind_signal = COMSIG_KB_CLIENT_LOOC_DOWN

/datum/keybinding/client/communication/looc/down(client/user)
	. = ..()
	if(.)
		return
	if(!user.prefs.tgui_say)
		return
	winset(user, null, "command=[user.tgui_say_create_open_command(LOOC_CHANNEL)]")
	return TRUE

/datum/keybinding/client/communication/me
	hotkey_keys = list("M")
	classic_keys = list("F4")
	name = ME_CHANNEL
	full_name = "Custom Emote (/Me)"
	keybind_signal = COMSIG_KB_CLIENT_ME_DOWN

/datum/keybinding/client/communication/me/down(client/user)
	. = ..()
	if(.)
		return
	if(!user.prefs.tgui_say)
		return
	winset(user, null, "command=[user.tgui_say_create_open_command(ME_CHANNEL)]")
	return TRUE

/datum/keybinding/client/communication/whisper
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = WHISPER_CHANNEL
	full_name = "IC Whisper"
	keybind_signal = COMSIG_KB_CLIENT_WHISPER_DOWN

/datum/keybinding/client/communication/radiochannels
	hotkey_keys = list("Y")
	name = COMMS_CHANNEL
	full_name = "IC Comms (;)"
	keybind_signal = COMSIG_KG_CLIENT_RADIO_DOWN

/datum/keybinding/client/communication/radiochannels/down(client/user)
	. = ..()
	if(.)
		return
	if(!user.prefs.tgui_say)
		return
	winset(user, null, "command=[user.tgui_say_create_open_command(COMMS_CHANNEL)]")
	return TRUE

/datum/keybinding/client/communication/asay
	hotkey_keys = list("F3")
	classic_keys = list("F5")
	name = ADMIN_CHANNEL
	full_name = "Admin Say"
	description = "Talk with other admins."
	keybind_signal = COMSIG_KB_ADMIN_ASAY_DOWN

/datum/keybinding/client/communication/asay/down(client/user)
	. = ..()
	if(.)
		return
	if(!user.prefs.tgui_say)
		return
	if(!user.admin_holder?.check_for_rights(R_MOD))
		return
	winset(user, null, "command=[user.tgui_say_create_open_command(ADMIN_CHANNEL)]")
	return TRUE

/datum/keybinding/client/communication/mentor_say
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = MENTOR_CHANNEL
	full_name = "Mentor Say"
	description = "Talk with other mentors."
	keybind_signal = COMSIG_KB_ADMIN_MENTORSAY_DOWN

/datum/keybinding/client/communication/mentor_say/down(client/user)
	. = ..()
	if(.)
		return
	if(!user.prefs.tgui_say)
		return
	if(!user.admin_holder?.check_for_rights(R_MENTOR))
		return
	winset(user, null, "command=[user.tgui_say_create_open_command(MENTOR_CHANNEL)]")
	return TRUE
