#define CHOISE_HIJACK "Хиджак"
#define CHOISE_MINOR "Минор"

/datum/game_mode
	var/queen_choise_is_made = FALSE

/datum/game_mode/proc/queen_minor_choice(mob/living/carbon/xenomorph/queen)
	if(SSticker.mode.queen_choise_is_made)
		return TRUE

	var/choise = tgui_alert(queen, "Угонять ли шаттл? Если вы решите не угонять шаттл, то раунд закончится минор победой ксено.", "Выбор исхода раунда", list(CHOISE_HIJACK, CHOISE_MINOR))
	if(!choise)
		return FALSE

	if(choise == CHOISE_HIJACK)
		SSticker.mode.queen_choise_is_made = TRUE
		xeno_announcement("Королева приняла решение, мы захватим их улей!", queen.hivenumber, "Решение королевы")
		return TRUE

	if(choise == CHOISE_MINOR)
		var/count = SSticker.mode.count_humans_and_xenos(SSmapping.levels_by_trait(ZTRAIT_GROUND))
		if(count[1] > count[2])
			to_chat(queen, SPAN_XENOANNOUNCE("На земле слишком много хостов, чтобы заявить о нашей победе!"))
			return FALSE

		SSticker.mode.queen_choise_is_made = TRUE
		xeno_announcement("Королева приняла решение, мы отстояли наш улей, мы остаемся!", queen.hivenumber, "Решение королевы")
		message_admins("[key_name(queen)] decided to end round early - [MODE_INFESTATION_X_MINOR].")
		SSticker.force_ending = TRUE
		SSticker.mode.round_finished = MODE_INFESTATION_X_MINOR
		return FALSE

/client/proc/toggle_queen_minor()
	set name = "Toggle Queen Minor"
	set desc = "Enables/Disables Queen Ability to Minor"
	set category = "Server.Round"

	if(!check_rights(R_SERVER))
		return

	if(SSticker.current_state != GAME_STATE_PLAYING)
		return

	SSticker.mode.queen_choise_is_made = !SSticker.mode.queen_choise_is_made
	message_admins("[key_name(usr)] [SSticker.mode.queen_choise_is_made ? "disabled" : "enabled"] queen ability to minor")

#undef CHOISE_HIJACK
#undef CHOISE_MINOR
