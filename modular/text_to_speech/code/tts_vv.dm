/mob/vv_do_topic(list/href_list)
	. = ..()

	if(href_list[VV_HK_MODIFY_TTS_TRAITS])
		if(!check_rights(R_VAREDIT))
			return
		change_tts_seed(usr, TRUE, TRUE)

	if(href_list[VV_HK_MODIFY_TTS_TRAITS_PLAYER_CHOICE])
		if(!check_rights(R_VAREDIT))
			return
		if(!client)
			to_chat(usr, SPAN_WARNING("<b>У [src] нет клиента</b>"))
			return
		to_chat(usr, SPAN_NOTICE("<b>[src] предложен выбор голоса</b>"))
		change_tts_seed(src, TRUE, TRUE)

/atom/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_TTS_TRAITS, "Change TTS")
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_TTS_TRAITS_PLAYER_CHOICE, "Change TTS - Player Choice")
