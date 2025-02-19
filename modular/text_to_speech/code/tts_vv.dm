/mob/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_MODIFY_TTS_TRAITS])
		if(!check_rights(R_VAREDIT))
			return
		usr.change_tts_seed(src, TRUE, TRUE)

/atom/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_TTS_TRAITS, "Change TTS")
