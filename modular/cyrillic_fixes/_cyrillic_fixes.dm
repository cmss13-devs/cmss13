/datum/modpack/cyrillic_fixes
	name = "Cyrillic Fixes"
	desc = "Adds Cyrillic support"
	author = "larentoun, ROdenFL"

/datum/modpack/cyrillic_fixes/initialize()
	. = ..()
	update_cyrillic_radio()
	update_cyrillic_languages()

/datum/modpack/cyrillic_fixes/proc/update_cyrillic_radio()
	GLOB.department_radio_keys |= list(
		":ш" = RADIO_CHANNEL_INTERCOM, 		".ш" = RADIO_CHANNEL_INTERCOM, 		"#ш" = RADIO_CHANNEL_INTERCOM,		"№ш" = RADIO_CHANNEL_INTERCOM,
		":р" = RADIO_CHANNEL_DEPARTMENT, 	".р" = RADIO_CHANNEL_DEPARTMENT, 	"#р" = RADIO_CHANNEL_DEPARTMENT,	"№р" = RADIO_CHANNEL_DEPARTMENT,
		":ц" = RADIO_MODE_WHISPER, 			".ц" = RADIO_MODE_WHISPER, 			"#ц" = RADIO_MODE_WHISPER,			"№ц" = RADIO_MODE_WHISPER,
		":=" = RADIO_CHANNEL_SPECIAL, 		".=" = RADIO_CHANNEL_SPECIAL, 		"#=" = RADIO_CHANNEL_SPECIAL,		"№=" = RADIO_CHANNEL_SPECIAL,

		":ь" = RADIO_CHANNEL_MEDSCI, 		".ь" = RADIO_CHANNEL_MEDSCI, 		"#ь" = RADIO_CHANNEL_UPP_MED,		"№ь" = RADIO_CHANNEL_UPP_MED,
		":т" = RADIO_CHANNEL_ENGI, 			".т" = RADIO_CHANNEL_ENGI, 			"#т" = RADIO_CHANNEL_UPP_ENGI,		"№т" = RADIO_CHANNEL_UPP_ENGI,
		":п" = RADIO_CHANNEL_ALMAYER, 		".п" = RADIO_CHANNEL_ALMAYER, 		"#п" = RADIO_CHANNEL_CLF_GEN,		"№п" = RADIO_CHANNEL_CLF_GEN,
		":м" = RADIO_CHANNEL_COMMAND , 		".м" = RADIO_CHANNEL_COMMAND , 		"#м" = RADIO_CHANNEL_UPP_CMD,		"№м" = RADIO_CHANNEL_UPP_CMD,
		":ф" = SQUAD_MARINE_1, 				".ф" = SQUAD_MARINE_1, 				"#ф" = RADIO_CHANNEL_CLF_MED,		"№ф" = RADIO_CHANNEL_CLF_MED,
		":и" = SQUAD_MARINE_2, 				".и" = SQUAD_MARINE_2, 				"#и" = RADIO_CHANNEL_CLF_ENGI,		"№и" = RADIO_CHANNEL_CLF_ENGI,
		":с" = SQUAD_MARINE_3, 				".с" = SQUAD_MARINE_3, 				"#с" = RADIO_CHANNEL_CLF_CMD,		"№с" = RADIO_CHANNEL_CLF_CMD,
		":в" = SQUAD_MARINE_4, 				".в" = SQUAD_MARINE_4, 				"#в" = RADIO_CHANNEL_CLF_CCT,		"№в" = RADIO_CHANNEL_CLF_CCT,
		":у" = SQUAD_MARINE_5, 				".у" = SQUAD_MARINE_5, 				"#у" = RADIO_CHANNEL_PMC_ENGI,		"№у" = RADIO_CHANNEL_PMC_ENGI,
		":а" = SQUAD_MARINE_CRYO, 			".а" = SQUAD_MARINE_CRYO, 			"#а" = RADIO_CHANNEL_PMC_MED,		"№а" = RADIO_CHANNEL_PMC_MED,
		":з" = RADIO_CHANNEL_MP , 			".з" = RADIO_CHANNEL_MP , 			"#з" = RADIO_CHANNEL_PMC_GEN,		"№з" = RADIO_CHANNEL_PMC_GEN,
		":г" = RADIO_CHANNEL_REQ, 			".г" = RADIO_CHANNEL_REQ, 			"#г" = RADIO_CHANNEL_UPP_GEN,		"№г" = RADIO_CHANNEL_UPP_GEN,
		":о" = RADIO_CHANNEL_JTAC, 			".о" = RADIO_CHANNEL_JTAC, 			"#о" = RADIO_CHANNEL_UPP_CCT,		"№о" = RADIO_CHANNEL_UPP_CCT,
		":е" = RADIO_CHANNEL_INTEL, 		".е" = RADIO_CHANNEL_INTEL, 		"#е" = RADIO_CHANNEL_UPP_KDO,		"№е" = RADIO_CHANNEL_UPP_KDO,
		":н" = RADIO_CHANNEL_WY, 			".н" = RADIO_CHANNEL_WY, 			"#н" = RADIO_CHANNEL_WY,			"№н" = RADIO_CHANNEL_WY,
		":щ" = RADIO_CHANNEL_COLONY, 		".щ" = RADIO_CHANNEL_COLONY, 		"#щ" = RADIO_CHANNEL_PMC_CCT,		"№щ" = RADIO_CHANNEL_PMC_CCT,
		":я" = RADIO_CHANNEL_HIGHCOM,		".я" = RADIO_CHANNEL_HIGHCOM, 		"#я" = RADIO_CHANNEL_PMC_CMD,		"№я" = RADIO_CHANNEL_PMC_CMD,
		":л" = SQUAD_SOF, 					".л" = SQUAD_SOF, 					"#л" = RADIO_CHANNEL_WY_WO,			"№л" = RADIO_CHANNEL_WY_WO,
		":й" = RADIO_CHANNEL_ROYAL_MARINE, 	".й" = RADIO_CHANNEL_ROYAL_MARINE,
		":к" = RADIO_CHANNEL_PROVOST, 		".к" = RADIO_CHANNEL_PROVOST, 		"#к" = RADIO_CHANNEL_PROVOST, 		"№к" = RADIO_CHANNEL_PROVOST,
		":ы" = RADIO_CHANNEL_CIA, 			".ы" = RADIO_CHANNEL_CIA,

		":Ш" = RADIO_CHANNEL_INTERCOM, 		".Ш" = RADIO_CHANNEL_INTERCOM, 		"#Ш" = RADIO_CHANNEL_INTERCOM, 		"№Ш" = RADIO_CHANNEL_INTERCOM,
		":Р" = RADIO_CHANNEL_DEPARTMENT, 	".Р" = RADIO_CHANNEL_DEPARTMENT, 	"#Р" = RADIO_CHANNEL_DEPARTMENT, 	"№Р" = RADIO_CHANNEL_DEPARTMENT,
		":Ц" = RADIO_MODE_WHISPER, 			".Ц" = RADIO_MODE_WHISPER, 			"#Ц" = RADIO_MODE_WHISPER, 			"№Ц" = RADIO_MODE_WHISPER,

		":Ь" = RADIO_CHANNEL_MEDSCI, 		".Ь" = RADIO_CHANNEL_MEDSCI, 		"#Ь" = RADIO_CHANNEL_UPP_MED, 		"№Ь" = RADIO_CHANNEL_UPP_MED,
		":Т" = RADIO_CHANNEL_ENGI, 			".Т" = RADIO_CHANNEL_ENGI, 			"#Т" = RADIO_CHANNEL_UPP_ENGI, 		"№Т" = RADIO_CHANNEL_UPP_ENGI,
		":П" = RADIO_CHANNEL_ALMAYER, 		".П" = RADIO_CHANNEL_ALMAYER, 		"#П" = RADIO_CHANNEL_CLF_GEN, 		"№П" = RADIO_CHANNEL_CLF_GEN,
		":М" = RADIO_CHANNEL_COMMAND, 		".М" = RADIO_CHANNEL_COMMAND, 		"#М" = RADIO_CHANNEL_UPP_CMD, 		"№М" = RADIO_CHANNEL_UPP_CMD,
		":Ф" = SQUAD_MARINE_1, 				".Ф" = SQUAD_MARINE_1, 				"#Ф" = RADIO_CHANNEL_CLF_MED, 		"№Ф" = RADIO_CHANNEL_CLF_MED,
		":И" = SQUAD_MARINE_2, 				".И" = SQUAD_MARINE_2, 				"#И" = RADIO_CHANNEL_CLF_ENGI, 		"№И" = RADIO_CHANNEL_CLF_ENGI,
		":С" = SQUAD_MARINE_3, 				".С" = SQUAD_MARINE_3, 				"#С" = RADIO_CHANNEL_CLF_CMD, 		"№С" = RADIO_CHANNEL_CLF_CMD,
		":В" = SQUAD_MARINE_4, 				".В" = SQUAD_MARINE_4, 				"#В" = RADIO_CHANNEL_CLF_CCT, 		"№В" = RADIO_CHANNEL_CLF_CCT,
		":У" = SQUAD_MARINE_5, 				".У" = SQUAD_MARINE_5, 				"#У" = RADIO_CHANNEL_PMC_ENGI,		"№У" = RADIO_CHANNEL_PMC_ENGI,
		":А" = SQUAD_MARINE_CRYO, 			".А" = SQUAD_MARINE_CRYO, 			"#А" = RADIO_CHANNEL_PMC_MED, 		"№А" = RADIO_CHANNEL_PMC_MED,
		":З" = RADIO_CHANNEL_MP, 			".З" = RADIO_CHANNEL_MP, 			"#З" = RADIO_CHANNEL_PMC_GEN, 		"№З" = RADIO_CHANNEL_PMC_GEN,
		":Г" = RADIO_CHANNEL_REQ, 			".Г" = RADIO_CHANNEL_REQ, 			"#Г" = RADIO_CHANNEL_UPP_GEN, 		"№Г" = RADIO_CHANNEL_UPP_GEN,
		":О" = RADIO_CHANNEL_JTAC, 			".О" = RADIO_CHANNEL_JTAC, 			"#О" = RADIO_CHANNEL_UPP_CCT, 		"№О" = RADIO_CHANNEL_UPP_CCT,
		":Е" = RADIO_CHANNEL_INTEL, 		".Е" = RADIO_CHANNEL_INTEL, 		"#Е" = RADIO_CHANNEL_UPP_KDO, 		"№Е" = RADIO_CHANNEL_UPP_KDO,
		":Н" = RADIO_CHANNEL_WY, 			".Н" = RADIO_CHANNEL_WY, 			"#Н" = RADIO_CHANNEL_WY, 			"№Н" = RADIO_CHANNEL_WY,
		":Щ" = RADIO_CHANNEL_COLONY, 		".Щ" = RADIO_CHANNEL_COLONY, 		"#Щ" = RADIO_CHANNEL_PMC_CCT, 		"№Щ" = RADIO_CHANNEL_PMC_CCT,
		":Я" = RADIO_CHANNEL_HIGHCOM,		".Я" = RADIO_CHANNEL_HIGHCOM, 		"#Я" = RADIO_CHANNEL_PMC_CMD, 		"№Я" = RADIO_CHANNEL_PMC_CMD,
		":Л" = SQUAD_SOF, 					".Л" = SQUAD_SOF, 					"#Л" = RADIO_CHANNEL_WY_WO, 		"№Л" = RADIO_CHANNEL_WY_WO,
		":Й" = RADIO_CHANNEL_ROYAL_MARINE, 	".Й" = RADIO_CHANNEL_ROYAL_MARINE,
		":К" = RADIO_CHANNEL_PROVOST, 		".К" = RADIO_CHANNEL_PROVOST, 		"#К" = RADIO_CHANNEL_PROVOST, 		"№К" = RADIO_CHANNEL_PROVOST,
		":Ы" = RADIO_CHANNEL_CIA, 			".Ы" = RADIO_CHANNEL_CIA
	)

/datum/modpack/cyrillic_fixes/proc/update_cyrillic_languages()
	for(var/language_name in GLOB.all_languages)
		var/datum/language/L = GLOB.all_languages[language_name]
		GLOB.language_keys[":[lowertext(convert_en_key_to_ru_key(L.key))]"] = initial(L.name)
		GLOB.language_keys[".[lowertext(convert_en_key_to_ru_key(L.key))]"] = initial(L.name)
		GLOB.language_keys["#[lowertext(convert_en_key_to_ru_key(L.key))]"] = initial(L.name)
		GLOB.language_keys["№[lowertext(convert_en_key_to_ru_key(L.key))]"] = initial(L.name)

		GLOB.language_keys["№[lowertext(L.key)]"] = initial(L.name)
