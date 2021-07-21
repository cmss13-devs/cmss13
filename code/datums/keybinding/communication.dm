/datum/keybinding/client/communication
	category = CATEGORY_COMMUNICATION

/datum/keybinding/client/communication/say
	hotkey_keys = list("T")
	classic_keys = list("F3")
	name = "Say"
	full_name = "IC Say"
	keybind_signal = COMSIG_KB_CLIENT_SAY_DOWN

/datum/keybinding/client/communication/ooc
	hotkey_keys = list("O")
	classic_keys = list("F2")
	name = "OOC"
	full_name = "Out Of Character Say (OOC)"
	keybind_signal = COMSIG_KB_CLIENT_OOC_DOWN

/datum/keybinding/client/communication/me
	hotkey_keys = list("M")
	classic_keys = list("F4")
	name = "Me"
	full_name = "Custom Emote (/Me)"
	keybind_signal = COMSIG_KB_CLIENT_ME_DOWN

/datum/keybinding/client/communication/whisper
	hotkey_keys = list()
	classic_keys = list()
	name = "Whisper"
	full_name = "IC Whisper"
	keybind_signal = COMSIG_KB_CLIENT_WHISPER_DOWN
