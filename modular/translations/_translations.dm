GLOBAL_LIST_EMPTY(ru_attack_verbs)
GLOBAL_LIST_EMPTY(ru_eat_verbs)
GLOBAL_LIST_EMPTY(ru_say_verb)
GLOBAL_LIST_EMPTY(ru_emote_names)
GLOBAL_LIST_EMPTY(ru_emote_messages)
GLOBAL_LIST_EMPTY(ru_wound_descs)
GLOBAL_LIST_EMPTY(ru_reagent_names)

/datum/modpack/translations
	name = "Переводы"
	desc = "Добавляет переводы."
	author = "Vallat, larentoun, pavlovvn, ROdenFL, PhantomRU"

/datum/modpack/translations/post_initialize()
	// Verbs
	var/toml_path = "[PATH_TO_TRANSLATE_DATA]/ru_verbs.toml"
	if(fexists(file(toml_path)))
		var/list/verbs_toml_list = rustg_read_toml_file(toml_path)

		var/list/attack_verbs = verbs_toml_list["attack_verbs"]
		for(var/attack_key in attack_verbs)
			GLOB.ru_attack_verbs += list("[attack_key]" = attack_verbs[attack_key])

		var/list/eat_verbs = verbs_toml_list["eat_verbs"]
		for(var/eat_key in eat_verbs)
			GLOB.ru_eat_verbs += list("[eat_key]" = eat_verbs[eat_key])

		var/list/say_verbs = verbs_toml_list["say_verbs"]
		for(var/say_key in say_verbs)
			GLOB.ru_say_verb += list("[say_key]" = say_verbs[say_key])

	// Emotes
	var/emote_path = "[PATH_TO_TRANSLATE_DATA]/ru_emotes.toml"
	if(fexists(file(emote_path)))
		var/list/emotes_toml_list = rustg_read_toml_file(emote_path)

		var/list/emote_messages = emotes_toml_list["emote_messages"]
		for(var/emote_message_key in emote_messages)
			GLOB.ru_emote_messages += list("[emote_message_key]" = emote_messages[emote_message_key])

		var/list/emote_names = emotes_toml_list["emote_names"]
		for(var/emote_name_key in emote_names)
			GLOB.ru_emote_names += list("[emote_name_key]" = emote_names[emote_name_key])

		for(var/emote_key as anything in GLOB.emote_list)
			var/list/emote_list = GLOB.emote_list[emote_key]
			for(var/datum/emote/emote in emote_list)
				emote.update_to_ru()
		for(var/emote_kb_key as anything in GLOB.keybindings_by_name)
			var/datum/keybinding/emote/emote_kb = GLOB.keybindings_by_name[emote_kb_key]
			if(!istype(emote_kb))
				continue
			emote_kb.update_to_ru()

	// Vendors
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_engi)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_engi)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_leader)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_leader)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_medic)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_medic)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_marine_snowflake)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_marine)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_smartgun)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_smartgun)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_spec)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_spec_heavy)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_specialist)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_tl)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_tl)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_synth)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_synth_upp)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_k9_synth)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_combat_correspondent)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_commanding_officer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_commanding_officer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_upp_commanding_officer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_upp_commanding_officer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_corporate_liaison)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_maintenance_technician)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_nurse)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_researcher)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_doctor)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_military_police)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_military_police_warden)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_military_police_chief)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_dropship_crew_chief)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_pilot_officer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_sea)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_sea)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_staff_officer_armory)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_staff_officer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_vehicle_crew)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_intelligence_officer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_intelligence_officer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_xo)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_xo)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_chief_engineer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_req_officer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_cmo)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_auxiliary_officer)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_tutorial)
	translate_vendor_entries_to_ru(GLOB.cm_vending_gear_medic_sandbox)
	translate_vendor_entries_to_ru(GLOB.cm_vending_clothing_medic_sandbox)
