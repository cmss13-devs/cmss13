
/obj/item/device/encryptionkey
	name = "Standard Encryption Key"
	desc = "An encryption key for a radio headset."
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = 1
	var/translate_binary = 0
	var/translate_hive = 0
	var/syndie = 0
	var/list/channels = list()


/obj/item/device/encryptionkey/syndicate
	icon_state = "cypherkey"
	channels = list("Syndicate" = 1)
	origin_tech = "syndicate=3"
	syndie = 1//Signifies that it de-crypts Syndicate transmissions

/obj/item/device/encryptionkey/binary
	icon_state = "binary_key"
	translate_binary = 1
	origin_tech = "syndicate=3"



/obj/item/device/encryptionkey/ai_integrated
	name = "AI Integrated Encryption Key"
	desc = "Integrated encryption key"
	icon_state = "cap_key"
	channels = list("Almayer" = 1, "Command" = 1, "MP" = 1, "Engi" = 1, "MedSci" = 1, "Req" = 1, "Alpha" = 1, "Bravo" = 1, "Charlie" = 1, "Delta" = 1)

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
	channels = list("Engi" = 1, "Command" = 1)

/obj/item/device/encryptionkey/cmo
	name = "Chief Medical Officer's Encryption Key"
	icon_state = "cmo_key"
	channels = list("MedSci" = 1, "Command" = 1)

/obj/item/device/encryptionkey/req
	name = "Supply Radio Encryption Key"
	icon_state = "req_key"
	channels = list("Req" = 1)

/obj/item/device/encryptionkey/mmpo
	name = "\improper Military Police radio encryption key"
	icon_state = "sec_key"
	channels = list("MP" = 1, "Command" = 1)

//MARINE ENCRYPTION KEYS

/obj/item/device/encryptionkey/cmpcom
	name = "\improper Marine Chief MP radio encryption key"
	icon_state = "cmp_key"
	channels = list("Command" = 1, "MP" = 1, "Alpha" = 0, "Bravo" = 0, "Charlie" = 0, "Delta" = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1 )

/obj/item/device/encryptionkey/cmpcom/cdrcom
	name = "\improper Marine Commanding Officer radio encryption key"

/obj/item/device/encryptionkey/mcom
	name = "\improper Marine Command radio encryption key"
	icon_state = "cap_key"
	channels = list("Command" = 1, "Alpha" = 0, "Bravo" = 0, "Charlie" = 0, "Delta" = 0, "Engi" = 1, "MedSci" = 1, "Req" = 1 )

/obj/item/device/encryptionkey/mcom/ai //AI only.
	channels = list("Command" = 1, "MP" = 1, "Alpha" = 1, "Bravo" = 1, "Charlie" = 1, "Delta" = 1, "Engi" = 1, "MedSci" = 1, "Req" = 1 )

/obj/item/device/encryptionkey/jtac
	name = "\improper JTAC radio encryption key"
	icon_state = sec_key
	channels = list("JTAC" = 1)

/obj/item/device/encryptionkey/squadlead
	name = "\improper Squad Leader encryption key"
	icon_state = "sl_key"
	channels = list("Command" = 1)

/obj/item/device/encryptionkey/alpha
	name = "\improper Alpha Squad radio encryption key"
	icon_state = "alpha_key"
	channels = list("Alpha" = 1)

/obj/item/device/encryptionkey/bravo
	name = "\improper Bravo Squad radio encryption key"
	icon_state = "bravo_key"
	channels = list("Bravo" = 1)

/obj/item/device/encryptionkey/charlie
	name = "\improper Charlie Squad radio encryption key"
	icon_state = "charlie_key"
	channels = list("Charlie" = 1)

/obj/item/device/encryptionkey/delta
	name = "\improper Delta Squad radio encryption key"
	icon_state = "delta_key"
	channels = list("Delta" = 1)

/* For cryo-squad, to be implemented
/obj/item/device/encryptionkey/echo
	name = "\improper Echo Squad radio encryption key"
	icon_state = "echo_key"
	channels = list("Echo" = 1)
*/

//ERT, PMC

/obj/item/device/encryptionkey/ert
	name = "W-Y Radio Encryption Key"
	icon_state = "wy_key"
	channels = list("Response Team" = 1, "Command" = 1, "MedSci" = 1, "Engi" = 1)

/obj/item/device/encryptionkey/dutch
	name = "\improper Colonist encryption key"
	icon_state = "stripped_key"
	channels = list("Colonist" = 1)

/obj/item/device/encryptionkey/PMC
	name = "\improper Weyland Yutani encryption key"
	icon_state = "wy_key"
	channels = list("WY PMC" = 1)

/obj/item/device/encryptionkey/bears
	name = "\improper UPP encryption key"
	icon_state = "upp_key"
	syndie = 1
	channels = list("UPP" = 1)

/obj/item/device/encryptionkey/commando
	name = "\improper WY commando encryption key"
	icon_state = "wy_key"
	channels = list("SpecOps" = 1)
