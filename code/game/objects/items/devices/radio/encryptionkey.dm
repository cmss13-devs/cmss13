/obj/item/device/encryptionkey
	name = "Standard Encryption Key"
	desc = "An encryption key for a radio headset."
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = SIZE_TINY
	var/translate_binary = FALSE
	var/translate_hive = FALSE
	var/syndie = FALSE //Signifies that it de-crypts Syndicate transmissions
	var/list/channels = list()
	var/abstract = FALSE

/obj/item/device/encryptionkey/binary
	icon_state = "binary_key"
	translate_binary = 1



/obj/item/device/encryptionkey/public
	name = "Public Radio Encryption Key"
	icon_state = "stripped_key"
	channels = list("Almayer" = 1)
	abstract = TRUE

/obj/item/device/encryptionkey/colony
	name = "Colony Radio Encryption Key"
	icon_state = "stripped_key"
	channels = list("Colony" = 1)

/obj/item/device/encryptionkey/ai_integrated
	name = "AI Integrated Encryption Key"
	desc = "Integrated encryption key"
	icon_state = "cap_key"
	channels = list("Almayer" = 1, "Command" = 1, "MP" = 1, "Engi" = 1, "MedSci" = 1, "Req" = 1, SQUAD_MARINE_1 = 1, SQUAD_MARINE_2 = 1, SQUAD_MARINE_3 = 1, SQUAD_MARINE_4 = 1, SQUAD_MARINE_5 = 1, SQUAD_MARINE_CRYO = 0, "JTAC" = 1, "Tactics" = 1)

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
	channels = list("Engi" = 1, "Command" = 1, "MedSci" = 1, "Req" = 1, SQUAD_MARINE_1 = 0, SQUAD_MARINE_2 = 0, SQUAD_MARINE_3 = 0, SQUAD_MARINE_4 = 0, SQUAD_MARINE_5 = 0, SQUAD_MARINE_CRYO = 0)

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
	channels = list("Req" = 1, "Command" = 1, "Engi" = 0, "MedSci" = 0, SQUAD_MARINE_1 = 0, SQUAD_MARINE_2 = 0, SQUAD_MARINE_3 = 0, SQUAD_MARINE_4 = 0, SQUAD_MARINE_5 = 0, SQUAD_MARINE_CRYO = 0)

/obj/item/device/encryptionkey/req
	name = "Supply Radio Encryption Key"
	icon_state = "req_key"
	channels = list("Req" = 1)

/obj/item/device/encryptionkey/req/ct
	name = "Supply Radio Encryption Key"
	icon_state = "req_key"
	channels = list("Req" = 1, "Command" = 0, "Engi" = 0, SQUAD_MARINE_1 = 0, SQUAD_MARINE_2 = 0, SQUAD_MARINE_3 = 0, SQUAD_MARINE_4 = 0, SQUAD_MARINE_5 = 0, SQUAD_MARINE_CRYO = 0)

/obj/item/device/encryptionkey/mmpo
	name = "\improper Military Police Radio Encryption Key"
	icon_state = "sec_key"
	channels = list("Command" = 1, "MP" = 1, SQUAD_MARINE_1 = 1, SQUAD_MARINE_2 = 1, SQUAD_MARINE_3 = 1, SQUAD_MARINE_4 = 1, SQUAD_MARINE_5 = 1, SQUAD_MARINE_CRYO = 0, "Engi" = 1, "MedSci" = 1,)

//MARINE ENCRYPTION KEYS

/obj/item/device/encryptionkey/cmpcom
	name = "\improper Marine Chief MP Radio Encryption Key"
	icon_state = "cmp_key"
	channels = list("Command" = 1, "MP" = 1, "Engi" = 1, "MedSci" = 1, "Req" = 1, SQUAD_MARINE_1 = 0, SQUAD_MARINE_2 = 0, SQUAD_MARINE_3 = 0, SQUAD_MARINE_4 = 0, SQUAD_MARINE_5 = 0, SQUAD_MARINE_CRYO = 0)

/obj/item/device/encryptionkey/cmpcom/cdrcom
	name = "\improper Marine Senior Command Radio Encryption Key"
	channels = list("Command" = 1, "MP" = 1, SQUAD_MARINE_1 = 1, SQUAD_MARINE_2 = 1, SQUAD_MARINE_3 = 1, SQUAD_MARINE_4 = 1, SQUAD_MARINE_5 = 1, SQUAD_MARINE_CRYO = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1, "JTAC" = 1, "Tactics" = 1)

/obj/item/device/encryptionkey/cmpcom/synth
	name = "\improper Marine Synth Radio Encryption Key"
	channels = list("Command" = 1, "MP" = 1, SQUAD_MARINE_1 = 1, SQUAD_MARINE_2 = 1, SQUAD_MARINE_3 = 1, SQUAD_MARINE_4 = 1, SQUAD_MARINE_5 = 1, SQUAD_MARINE_CRYO = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1, "JTAC" = 1, "Tactics" = 1)

/obj/item/device/encryptionkey/mcom
	name = "\improper Marine Command Radio Encryption Key"
	icon_state = "cap_key"
	channels = list("Command" = 1, SQUAD_MARINE_1 = 1, SQUAD_MARINE_2 = 1, SQUAD_MARINE_3 = 1, SQUAD_MARINE_4 = 1, SQUAD_MARINE_5 = 1, SQUAD_MARINE_CRYO = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1, "JTAC" = 1, "Tactics" = 1)

/obj/item/device/encryptionkey/mcom/cl
	name = "\improper Corporate Liaison radio encryption key"
	icon_state = "cap_key"
	channels = list("Command" = 1, SQUAD_MARINE_1 = 0, SQUAD_MARINE_2 = 0, SQUAD_MARINE_3 = 0, SQUAD_MARINE_4 = 0, SQUAD_MARINE_5 = 0, SQUAD_MARINE_CRYO = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1, "JTAC" = 1, "Tactics" = 1, "WY" = 1)

/obj/item/device/encryptionkey/mcom/rep
	name = "\improper Representative radio encryption key"
	icon_state = "cap_key"
	channels = list("Command" = 1, "Almayer" = 1)

/obj/item/device/encryptionkey/po
	name = "\improper Marine Pilot Officer Radio Encryption Key"
	icon_state = "cap_key"
	channels = list("Command" = 1, SQUAD_MARINE_1 = 0, SQUAD_MARINE_2 = 0, SQUAD_MARINE_3 = 0, SQUAD_MARINE_4 = 0, SQUAD_MARINE_5 = 0, SQUAD_MARINE_CRYO = 0, "JTAC" = 1, "Tactics" = 1)

/obj/item/device/encryptionkey/io
	name = "\improper Marine Intelligence Officer Radio Encryption Key"
	icon_state = "cap_key"
	channels = list("Command" = 1, SQUAD_MARINE_1 = 0, SQUAD_MARINE_2 = 0, SQUAD_MARINE_3 = 0, SQUAD_MARINE_4 = 0, SQUAD_MARINE_5 = 0, SQUAD_MARINE_CRYO = 0, "Tactics" = 1)

/obj/item/device/encryptionkey/mcom/ai //AI only.
	channels = list("Command" = 1, "MP" = 1, SQUAD_MARINE_1 = 1, SQUAD_MARINE_2 = 1, SQUAD_MARINE_3 = 1, SQUAD_MARINE_4 = 1, SQUAD_MARINE_5 = 1, SQUAD_MARINE_CRYO = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1, "JTAC" = 1, "Tactics" = 1)

/obj/item/device/encryptionkey/jtac
	name = "\improper JTAC Radio Encryption Key"
	icon_state = "jtac_key"
	channels = list("JTAC" = 1, "Req" = 1)

/obj/item/device/encryptionkey/tactics
	name = "\improper Tactics Radio Encryption Key"
	icon_state = "jtac_key"
	channels = list("Tactics" = 1)

/obj/item/device/encryptionkey/cct
	name = "\improper CCT Radio Encryption Key"
	icon_state = "jtac_key"
	channels = list("CCT" = 1)

/obj/item/device/encryptionkey/squadlead
	name = "\improper Squad Leader Radio Encryption Key"
	icon_state = "sl_key"
	channels = list("Command" = 1, "JTAC" = 1)

/obj/item/device/encryptionkey/squadlead/acting
	abstract = TRUE

/obj/item/device/encryptionkey/alpha
	name = "\improper Alpha Squad Radio Encryption Key"
	icon_state = "alpha_key"
	channels = list(SQUAD_MARINE_1 = 1)

/obj/item/device/encryptionkey/bravo
	name = "\improper Bravo Squad Radio Encryption Key"
	icon_state = "bravo_key"
	channels = list(SQUAD_MARINE_2 = 1)

/obj/item/device/encryptionkey/charlie
	name = "\improper Charlie Squad Radio Encryption Key"
	icon_state = "charlie_key"
	channels = list(SQUAD_MARINE_3 = 1)

/obj/item/device/encryptionkey/delta
	name = "\improper Delta Squad Radio Encryption Key"
	icon_state = "delta_key"
	channels = list(SQUAD_MARINE_4 = 1)

/obj/item/device/encryptionkey/echo
	name = "\improper Echo Squad Radio Encryption Key"
	icon_state = "echo_key"
	channels = list(SQUAD_MARINE_5 = 1)

/obj/item/device/encryptionkey/cryo
	name = "\improper Reserves Squad Radio Encryption Key"
	icon_state = "cryo_key"
	channels = list(SQUAD_MARINE_CRYO = 1)

/obj/item/device/encryptionkey/soc
	name = "\improper MARSOC Radio Encryption Key"
	icon_state = "binary_key"
	channels = list("Command" = 1, "Req" = 1, "MedSci" = 1, "Engi" = 1, "Tactics" = 1, "JTAC" = 1, SQUAD_MARINE_1 = 0, SQUAD_MARINE_2 = 0, SQUAD_MARINE_3 = 0, SQUAD_MARINE_4 = 0, SQUAD_MARINE_5 = 0, SQUAD_MARINE_CRYO = 0)

//For CL and their Marine goons
/obj/item/device/encryptionkey/WY
	name = "\improper Weyland-Yutani encryption key"
	icon_state = "wy_key"
	channels = list("WY" = 1)
//ERT, PMC

/obj/item/device/encryptionkey/ert
	name = "Wey-Yu Radio Encryption Key"
	icon_state = "cypherkey"
	channels = list("Response Team" = 1, "Command" = 1, "MedSci" = 1, "Engi" = 1, "WY" = 1)

/obj/item/device/encryptionkey/dutch
	name = "\improper Dutch's Dozen Radio Encryption Key"
	icon_state = "stripped_key"
	channels = list("DD" = 1)

/obj/item/device/encryptionkey/PMC
	name = "\improper Weyland-Yutani PMC Radio Encryption Key"
	icon_state = "pmc_key"
	channels = list("WY PMC" = 1, "WY" = 1)

/obj/item/device/encryptionkey/bears
	name = "\improper UPP Radio Encryption Key"
	icon_state = "upp_key"
	syndie = 1
	channels = list("UPP" = 1)

/obj/item/device/encryptionkey/commando
	name = "\improper WY Commando Radio Encryption Key"
	icon_state = "pmc_key"
	channels = list("SpecOps" = 1, "WY" = 1)

/obj/item/device/encryptionkey/highcom
	name = "\improper USCM High Command Radio Encryption Key"
	icon_state = "binary_key"
	channels = list("HighCom" = 1, SQUAD_MARSOC = 1, "Command" = 1, "MP" = 1, SQUAD_MARINE_1 = 1, SQUAD_MARINE_2 = 1, SQUAD_MARINE_3 = 1, SQUAD_MARINE_4 = 1, SQUAD_MARINE_5 = 1, SQUAD_MARINE_CRYO = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1, "JTAC" = 1, "Tactics" = 1)

/// Used by the Mortar Crew in WO game mode - intently has no squad radio access
/obj/item/device/encryptionkey/mortar
	name = "\improper Mortar Crew Radio Encryption Key"
	icon_state = "eng_key"
	channels = list("Engi" = 1, "JTAC" = 1, "Tactics" = 1, "Req" = 1)
