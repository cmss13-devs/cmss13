
/obj/item/device/encryptionkey
	name = "Standard Encryption Key"
	desc = "An encryption key for a radio headset."
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = SIZE_TINY
	var/translate_binary = 0
	var/translate_hive = 0
	var/syndie = 0
	var/list/channels = list()


/obj/item/device/encryptionkey/syndicate
	icon_state = "cypherkey"
	channels = list("Syndicate" = 1)
	
	syndie = 1//Signifies that it de-crypts Syndicate transmissions

/obj/item/device/encryptionkey/binary
	icon_state = "binary_key"
	translate_binary = 1
	


/obj/item/device/encryptionkey/public
	name = "Public Radio Encryption Key"
	icon_state = "stripped_key"
	channels = list("Almayer" = 1)

/obj/item/device/encryptionkey/public_civ
	name = "Civillian Radio Encryption Key"
	icon_state = "stripped_key"
	channels = list("Common" = 1)

/obj/item/device/encryptionkey/ai_integrated
	name = "AI Integrated Encryption Key"
	desc = "Integrated encryption key"
	icon_state = "cap_key"
	channels = list("Almayer" = 1, "Command" = 1, "MP" = 1, "Engi" = 1, "MedSci" = 1, "Req" = 1, SQUAD_NAME_1 = 1, SQUAD_NAME_2 = 1, SQUAD_NAME_3 = 1, SQUAD_NAME_4 = 1, "JTAC" = 1, "Intel" = 1)

/obj/item/device/encryptionkey/engi
	name = "Engineering Radio Encryption Key"
	icon_state = "eng_key"
	channels = list("Engi" = 1)

/obj/item/device/encryptionkey/sec
	name = "Security Radio Encryption Key"
	icon_state = "sec_key"
	channels = list("MP" = 1)

/obj/item/device/encryptionkey/med
	name = "Medical Radio Encryption Key"
	icon_state = "med_key"
	channels = list("MedSci" = 1)

/obj/item/device/encryptionkey/ce
	name = "Chief Engineer's Encryption Key"
	icon_state = "ce_key"
	channels = list("Engi" = 1, "Command" = 1, "MedSci" = 1, "Req" = 1, SQUAD_NAME_1 = 0, SQUAD_NAME_2 = 0, SQUAD_NAME_3 = 0, SQUAD_NAME_4 = 0)

/obj/item/device/encryptionkey/cmo
	name = "Chief Medical Officer's Encryption Key"
	icon_state = "cmo_key"
	channels = list("MedSci" = 1, "Command" = 1)

/obj/item/device/encryptionkey/command
	name = "Command Encryption Key"
	icon_state = "cap_key"
	channels = list("Command" = 1)

/obj/item/device/encryptionkey/ro
	name = "Requisition Officer's Encryption Key"
	icon_state = "ce_key"
	channels = list("Req" = 1, "Command" = 1, "Engi" = 0, SQUAD_NAME_1 = 0, SQUAD_NAME_2 = 0, SQUAD_NAME_3 = 0, SQUAD_NAME_4 = 0)

/obj/item/device/encryptionkey/req
	name = "Supply Radio Encryption Key"
	icon_state = "req_key"
	channels = list("Req" = 1)

/obj/item/device/encryptionkey/req/ct
	name = "Supply Radio Encryption Key"
	icon_state = "req_key"
	channels = list("Req" = 1, "Command" = 0, "Engi" = 0, SQUAD_NAME_1 = 0, SQUAD_NAME_2 = 0, SQUAD_NAME_3 = 0, SQUAD_NAME_4 = 0)

/obj/item/device/encryptionkey/mmpo
	name = "\improper Military Police radio encryption key"
	icon_state = "sec_key"
	channels = list("MP" = 1, "Command" = 1)

//MARINE ENCRYPTION KEYS

/obj/item/device/encryptionkey/cmpcom
	name = "\improper Marine Chief MP radio encryption key"
	icon_state = "cmp_key"
	channels = list("Command" = 1, "MP" = 1, "MedSci" = 1, "Engi" = 1, SQUAD_NAME_1 = 0, SQUAD_NAME_2 = 0, SQUAD_NAME_3 = 0, SQUAD_NAME_4 = 0)

/obj/item/device/encryptionkey/cmpcom/cdrcom
	name = "\improper Marine Commanding Officer radio encryption key"
	channels = list("Command" = 1, "MP" = 1, SQUAD_NAME_1 = 0, SQUAD_NAME_2 = 0, SQUAD_NAME_3 = 0, SQUAD_NAME_4 = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1, "JTAC" = 1, "Intel" = 1)

/obj/item/device/encryptionkey/mcom
	name = "\improper Marine Command radio encryption key"
	icon_state = "cap_key"
	channels = list("Command" = 1, SQUAD_NAME_1 = 0, SQUAD_NAME_2 = 0, SQUAD_NAME_3 = 0, SQUAD_NAME_4 = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1, "JTAC" = 1, "Intel" = 1)

/obj/item/device/encryptionkey/mcom/cl
	name = "\improper Corporate Liaison radio encryption key"
	icon_state = "cap_key"
	channels = list("Command" = 1, SQUAD_NAME_1 = 0, SQUAD_NAME_2 = 0, SQUAD_NAME_3 = 0, SQUAD_NAME_4 = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1, "JTAC" = 1, "Intel" = 1, "WY" = 1)

/obj/item/device/encryptionkey/po
	name = "\improper Marine Pilot Officer radio encryption key"
	icon_state = "cap_key"
	channels = list("Command" = 1, SQUAD_NAME_1 = 0, SQUAD_NAME_2 = 0, SQUAD_NAME_3 = 0, SQUAD_NAME_4 = 0, "JTAC" = 1, "Intel" = 1)

/obj/item/device/encryptionkey/io
	name = "\improper Marine Intelligence Officer radio encryption key"
	icon_state = "cap_key"
	channels = list("Command" = 1, SQUAD_NAME_1 = 0, SQUAD_NAME_2 = 0, SQUAD_NAME_3 = 0, SQUAD_NAME_4 = 0, "Intel" = 1)

/obj/item/device/encryptionkey/mcom/ai //AI only.
	channels = list("Command" = 1, "MP" = 1, SQUAD_NAME_1 = 1, SQUAD_NAME_2 = 1, SQUAD_NAME_3 = 1, SQUAD_NAME_4 = 1, "Engi" = 1, "MedSci" = 1, "Req" = 1, "JTAC" = 1, "Intel" = 1)

/obj/item/device/encryptionkey/jtac
	name = "\improper JTAC radio encryption key"
	icon_state = "jtac_key"
	channels = list("JTAC" = 1, "Req" = 1)

/obj/item/device/encryptionkey/intel
	name = "\improper Intel radio encryption key"
	icon_state = "jtac_key"
	channels = list("Intel" = 1)

/obj/item/device/encryptionkey/squadlead
	name = "\improper Squad Leader encryption key"
	icon_state = "sl_key"
	channels = list("Command" = 1, "JTAC" = 1)

/obj/item/device/encryptionkey/alpha
	name = "\improper Alpha Squad radio encryption key"
	icon_state = "alpha_key"
	channels = list(SQUAD_NAME_1 = 1)

/obj/item/device/encryptionkey/bravo
	name = "\improper Bravo Squad radio encryption key"
	icon_state = "bravo_key"
	channels = list(SQUAD_NAME_2 = 1)

/obj/item/device/encryptionkey/charlie
	name = "\improper Charlie Squad radio encryption key"
	icon_state = "charlie_key"
	channels = list(SQUAD_NAME_3 = 1)

/obj/item/device/encryptionkey/delta
	name = "\improper Delta Squad radio encryption key"
	icon_state = "delta_key"
	channels = list(SQUAD_NAME_4 = 1)

//For CL and their Marine goons
/obj/item/device/encryptionkey/WY
	name = "\improper Weston-Yamada encryption key"
	icon_state = "wy_key"
	channels = list("WY" = 1)

/* For cryo-squad, to be implemented
/obj/item/device/encryptionkey/echo
	name = "\improper [SQUAD_NAME_5] Squad radio encryption key"
	icon_state = "echo_key"
	channels = list(SQUAD_NAME_5 = 1)
*/

//ERT, PMC

/obj/item/device/encryptionkey/ert
	name = "W-Y Radio Encryption Key"
	icon_state = "wy_key"
	channels = list("Response Team" = 1, "Command" = 1, "MedSci" = 1, "Engi" = 1, "WY" = 1)

/obj/item/device/encryptionkey/dutch
	name = "\improper Colonist encryption key"
	icon_state = "stripped_key"
	channels = list("Colonist" = 1)

/obj/item/device/encryptionkey/PMC
	name = "\improper Weston-Yamada encryption key"
	icon_state = "wy_key"
	channels = list("WY PMC" = 1, "WY" = 1)

/obj/item/device/encryptionkey/bears
	name = "\improper UPP encryption key"
	icon_state = "upp_key"
	syndie = 1
	channels = list("UPP" = 1)

/obj/item/device/encryptionkey/commando
	name = "\improper WY commando encryption key"
	icon_state = "wy_key"
	channels = list("SpecOps" = 1, "WY" = 1)
