/obj/item/device/encryptionkey
	name = "Standard Encryption Key"
	desc = "An encryption key for a radio headset."
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = SIZE_TINY
	var/translate_apollo = FALSE
	var/translate_hive = FALSE
	var/list/channels = list()
	var/list/tracking_options
	var/abstract = FALSE

/obj/item/device/encryptionkey/binary
	icon_state = "binary_key"
	translate_apollo = TRUE

/obj/item/device/encryptionkey/public
	name = "Public Radio Encryption Key"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_ALMAYER = TRUE)
	abstract = TRUE

/obj/item/device/encryptionkey/colony
	name = "Colony Radio Encryption Key"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_COLONY= TRUE)

// MARINE ONE CHANNEL

/obj/item/device/encryptionkey/command
	name = "Command Encryption Key"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE)

/obj/item/device/encryptionkey/jtac
	name = "\improper JTAC Radio Encryption Key"
	icon_state = "jtac_key"
	channels = list(RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_REQ = TRUE)

/obj/item/device/encryptionkey/intel
	name = "\improper Intel Radio Encryption Key"
	icon_state = "jtac_key"
	channels = list(RADIO_CHANNEL_INTEL = TRUE)

//MARINE ENCRYPTION KEYS

/obj/item/device/encryptionkey/sentry_laptop
	name = "Sentry Network Status Encryption Key"
	desc = "Automated channel to broadcast sentry gun updates"
	icon_state = "eng_key"
	channels = list(RADIO_CHANNEL_SENTRY = TRUE)

// MARINE COMMAND

/obj/item/device/encryptionkey/cmpcom/cdrcom
	name = "\improper Marine Senior Command Radio Encryption Key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/mcom
	name = "\improper Marine Command Radio Encryption Key"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/mcom/alt
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE)

// MARINE ENGINEERING

/obj/item/device/encryptionkey/ce
	name = "Chief Engineer's Encryption Key"
	icon_state = "ce_key"
	channels = list(RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE)

/obj/item/device/encryptionkey/engi
	name = "Engineering Radio Encryption Key"
	icon_state = "eng_key"
	channels = list(RADIO_CHANNEL_ENGI = TRUE)

// MARINE MEDICAL

/obj/item/device/encryptionkey/cmo
	name = "Chief Medical Officer's Encryption Key"
	icon_state = "cmo_key"
	channels = list(RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_INTEL = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE, RADIO_CHANNEL_ENGI = TRUE)

/obj/item/device/encryptionkey/med
	name = "Medical Radio Encryption Key"
	icon_state = "med_key"
	channels = list(RADIO_CHANNEL_MEDSCI = TRUE)

/obj/item/device/encryptionkey/medres
	name = "Research Radio Encryption Key"
	icon_state = "med_key"
	channels = list(RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_INTEL = TRUE)

// MARINE MILITARY POLICE

/obj/item/device/encryptionkey/cmpcom
	name = "\improper Marine Chief MP Radio Encryption Key"
	icon_state = "cmp_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE)

/obj/item/device/encryptionkey/mmpo
	name = "\improper Military Police Radio Encryption Key"
	icon_state = "sec_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE,)

/obj/item/device/encryptionkey/sec
	name = "Security Radio Encryption Key"
	icon_state = "sec_key"
	channels = list(RADIO_CHANNEL_MP = TRUE)

// MARINE REQUISTIONS

/obj/item/device/encryptionkey/qm
	name = "Requisition Officer's Encryption Key"
	icon_state = "ce_key"
	channels = list(RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ENGI = FALSE, RADIO_CHANNEL_MEDSCI = FALSE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE)

/obj/item/device/encryptionkey/req/ct
	name = "Supply Radio Encryption Key"
	icon_state = "req_key"
	channels = list(RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_COMMAND = FALSE, RADIO_CHANNEL_ENGI = FALSE)

/obj/item/device/encryptionkey/req
	name = "Supply Radio Encryption Key"
	icon_state = "req_key"
	channels = list(RADIO_CHANNEL_REQ = TRUE)

// MARINE SUPPORT

/obj/item/device/encryptionkey/cmpcom/synth
	name = "\improper Marine Synth Radio Encryption Key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/mcom/cl
	name = "\improper Corporate Liaison radio encryption key"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_ALMAYER = TRUE, RADIO_CHANNEL_WY = TRUE)

/obj/item/device/encryptionkey/mcom/rep
	name = "\improper Representative radio encryption key"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ALMAYER = TRUE)

/obj/item/device/encryptionkey/po
	name = "\improper Marine Pilot Officer Radio Encryption Key"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/io
	name = "\improper Marine Intelligence Officer Radio Encryption Key"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_ALMAYER = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE)

/obj/item/device/encryptionkey/vc
	name = "\improper Marine Vehicle Crewman Radio Encryption Key"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE)

/obj/item/device/encryptionkey/req/mst
	name = "Supply Radio Encryption Key"
	icon_state = "req_key"
	channels = list(RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_COMMAND = FALSE)

/obj/item/device/encryptionkey/cmpcom/synth/ai //AI only.
	name = "AI Integrated Radio Encryption Key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_WY = TRUE)
	translate_apollo = TRUE

// MARINE SQUADS

/obj/item/device/encryptionkey/squadlead
	name = "\improper Squad Leader Radio Encryption Key"
	icon_state = "sl_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_JTAC = TRUE)

/obj/item/device/encryptionkey/squadlead/acting
	abstract = TRUE

/obj/item/device/encryptionkey/alpha
	name = "\improper Alpha Squad Radio Encryption Key"
	icon_state = "alpha_key"
	channels = list(SQUAD_MARINE_1 = TRUE)

/obj/item/device/encryptionkey/bravo
	name = "\improper Bravo Squad Radio Encryption Key"
	icon_state = "bravo_key"
	channels = list(SQUAD_MARINE_2 = TRUE)

/obj/item/device/encryptionkey/charlie
	name = "\improper Charlie Squad Radio Encryption Key"
	icon_state = "charlie_key"
	channels = list(SQUAD_MARINE_3 = TRUE)

/obj/item/device/encryptionkey/delta
	name = "\improper Delta Squad Radio Encryption Key"
	icon_state = "delta_key"
	channels = list(SQUAD_MARINE_4 = TRUE)

/obj/item/device/encryptionkey/echo
	name = "\improper Echo Squad Radio Encryption Key"
	icon_state = "echo_key"
	channels = list(SQUAD_MARINE_5 = TRUE)

/obj/item/device/encryptionkey/cryo
	name = "\improper Foxtrot Squad Radio Encryption Key"
	icon_state = "cryo_key"
	channels = list(SQUAD_MARINE_CRYO = TRUE)

/obj/item/device/encryptionkey/soc
	name = "\improper SOF Radio Encryption Key"
	icon_state = "binary_key"
	channels = list(SQUAD_SOF = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_JTAC = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE)

/obj/item/device/encryptionkey/soc/forecon
	channels = list(SQUAD_SOF = TRUE, RADIO_CHANNEL_COLONY = TRUE)

//ERT, PMC

/obj/item/device/encryptionkey/dutch
	name = "\improper Dutch's Dozen Radio Encryption Key"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_DUTCH_DOZEN = TRUE)

//---------------------------------------------------
//Weyland-Yutani Keys

///For CL and their Marine goons
/obj/item/device/encryptionkey/WY
	name = "\improper Weyland-Yutani encryption key"
	icon_state = "wy_key"
	channels = list(RADIO_CHANNEL_WY = TRUE)
	tracking_options = list("Corporate Liaison" = TRACKER_CL)

/obj/item/device/encryptionkey/pmc
	name = "\improper Weyland-Yutani PMC Radio Encryption Key"
	icon_state = "pmc_key"
	channels = list(RADIO_CHANNEL_PMC_GEN = TRUE, RADIO_CHANNEL_WY = TRUE)

/obj/item/device/encryptionkey/pmc/engi
	name = "\improper WY PMC Engineering Radio Encryption Key"
	icon_state = "pmc_key"
	channels = list(RADIO_CHANNEL_PMC_GEN = TRUE, RADIO_CHANNEL_WY = TRUE, RADIO_CHANNEL_PMC_ENGI = TRUE, RADIO_CHANNEL_PMC_CCT = TRUE)

/obj/item/device/encryptionkey/pmc/medic
	name = "\improper WY PMC Medical Radio Encryption Key"
	icon_state = "pmc_key"
	channels = list(RADIO_CHANNEL_PMC_GEN = TRUE, RADIO_CHANNEL_WY = TRUE, RADIO_CHANNEL_PMC_MED = TRUE)

/obj/item/device/encryptionkey/pmc/command
	name = "\improper WY PMC Command Radio Encryption Key"
	icon_state = "pmc_key"
	channels = list(RADIO_CHANNEL_PMC_CMD = TRUE, RADIO_CHANNEL_PMC_GEN = TRUE, RADIO_CHANNEL_WY = TRUE, RADIO_CHANNEL_PMC_ENGI = TRUE, RADIO_CHANNEL_PMC_CCT = TRUE, RADIO_CHANNEL_PMC_MED = TRUE)

/obj/item/device/encryptionkey/commando
	name = "\improper WY Commando Radio Encryption Key"
	icon_state = "pmc_key"
	channels = list(RADIO_CHANNEL_WY_WO = TRUE, RADIO_CHANNEL_WY = TRUE)

//---------------------------------------------------
//UPP Keys
/obj/item/device/encryptionkey/upp
	name = "\improper UPP Radio Encryption Key"
	icon_state = "upp_key"
	channels = list(RADIO_CHANNEL_UPP_GEN = TRUE)

/obj/item/device/encryptionkey/upp/engi
	name = "\improper UPP Engineering Radio Encryption Key"
	channels = list(RADIO_CHANNEL_UPP_GEN = TRUE, RADIO_CHANNEL_UPP_ENGI = TRUE, RADIO_CHANNEL_UPP_CCT = TRUE)

/obj/item/device/encryptionkey/upp/medic
	name = "\improper UPP Medical Radio Encryption Key"
	channels = list(RADIO_CHANNEL_UPP_GEN = TRUE, RADIO_CHANNEL_UPP_MED = TRUE)

/obj/item/device/encryptionkey/upp/kdo
	name = "\improper UPP Kommando Radio Encryption Key"
	channels = list(RADIO_CHANNEL_UPP_KDO = TRUE, RADIO_CHANNEL_UPP_GEN = TRUE, RADIO_CHANNEL_UPP_CCT = TRUE)

/obj/item/device/encryptionkey/upp/command
	name = "\improper UPP Command Radio Encryption Key"
	channels = list(RADIO_CHANNEL_UPP_CMD = TRUE, RADIO_CHANNEL_UPP_GEN = TRUE, RADIO_CHANNEL_UPP_ENGI = TRUE, RADIO_CHANNEL_UPP_MED = TRUE, RADIO_CHANNEL_UPP_CCT = TRUE)

/obj/item/device/encryptionkey/upp/command/acting
	abstract = TRUE
//---------------------------------------------------
//CLF Keys
/obj/item/device/encryptionkey/clf
	name = "\improper CLF Radio Encryption Key"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_CLF_GEN = TRUE)

/obj/item/device/encryptionkey/clf/engi
	name = "\improper CLF Engineering Radio Encryption Key"
	channels = list(RADIO_CHANNEL_CLF_GEN = TRUE, RADIO_CHANNEL_CLF_ENGI = TRUE, RADIO_CHANNEL_CLF_CCT = TRUE)

/obj/item/device/encryptionkey/clf/medic
	name = "\improper CLF Medical Radio Encryption Key"
	channels = list(RADIO_CHANNEL_CLF_GEN = TRUE, RADIO_CHANNEL_CLF_MED = TRUE)

/obj/item/device/encryptionkey/clf/command
	name = "\improper CLF Command Radio Encryption Key"
	channels = list(RADIO_CHANNEL_CLF_CMD = TRUE, RADIO_CHANNEL_CLF_GEN = TRUE, RADIO_CHANNEL_CLF_ENGI = TRUE, RADIO_CHANNEL_CLF_MED = TRUE, RADIO_CHANNEL_CLF_CCT = TRUE)
//---------------------------------------------------
/obj/item/device/encryptionkey/highcom
	name = "\improper USCM High Command Radio Encryption Key"
	icon_state = "binary_key"
	channels = list(RADIO_CHANNEL_HIGHCOM = TRUE, SQUAD_SOF = TRUE, RADIO_CHANNEL_PROVOST = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = FALSE, RADIO_CHANNEL_JTAC = FALSE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_ALMAYER = TRUE)

/obj/item/device/encryptionkey/provost
	name = "\improper USCM Provost Radio Encryption Key"
	icon_state = "sec_key"
	channels = list(RADIO_CHANNEL_PROVOST = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = FALSE, RADIO_CHANNEL_JTAC = FALSE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_ALMAYER = TRUE)


/obj/item/device/encryptionkey/contractor
	name = "\improper Vanguard's Arrow Incorporated Radio Encryption Key"
	icon_state = "sl_key"
	channels = list("Command" = TRUE, "Engi" = TRUE, "MedSci" = TRUE, "Req" = TRUE, "JTAC" = TRUE, "Intel" = TRUE, "Almayer" = TRUE)

/obj/item/device/encryptionkey/royal_marine
	name = "\improper Royal Marine Radio Encryption Key"
	icon_state = "sl_key"
	channels = list("Command" = TRUE, "Almayer" = TRUE,)

/obj/item/device/encryptionkey/cia
	icon_state = "sl_key"
	channels = list(RADIO_CHANNEL_CIA = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = FALSE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/cmb
	name = "\improper Colonial Marshal Bureau Radio Encryption Key"
	icon_state = "cmb_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_ALMAYER = TRUE, RADIO_CHANNEL_COLONY = TRUE)
/// Used by the Mortar Crew in WO game mode - intently has no squad radio access
/obj/item/device/encryptionkey/mortar
	name = "\improper Mortar Crew Radio Encryption Key"
	icon_state = "eng_key"
	channels = list(RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_REQ = TRUE)
