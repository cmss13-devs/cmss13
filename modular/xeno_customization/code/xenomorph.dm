#define VV_HK_ADD_XENO_CUSTOMIZATION "add_xeno_customization"
#define VV_HK_REMOVE_XENO_CUSTOMIZATION "remove_xeno_customization"

/mob/living/carbon/xenomorph/update_icons()
	. = ..()
	SEND_SIGNAL(src, COMSIG_XENO_UPDATE_ICONS, icon_state)

/mob/living/carbon/xenomorph/alter_ghost(mob/dead/observer/ghost)
	. = ..()
	SEND_SIGNAL(src, COMSIG_ALTER_GHOST, ghost)

/mob/living/carbon/xenomorph/proc/apply_skin(mob/user, datum/xeno_customization_option/to_apply, force)
	if(!istype(to_apply))
		to_chat(user, SPAN_WARNING("Данная кастомизация не существует!"))
		return

	var/list/datum/component/xeno_customization/applied_customizations = GetComponents(/datum/component/xeno_customization)
	var/list/conflicting_names = list()
	for(var/datum/component/xeno_customization/applied_customization in applied_customizations)
		if(applied_customization.option.name == to_apply.name)
			to_chat(user, SPAN_NOTICE("Эта кастомизация уже имеется!"))
			return
		if(to_apply.slot & applied_customization.option.slot)
			conflicting_names += "[applied_customization.option.name]"
	if(length(conflicting_names))
		to_chat(user, SPAN_WARNING("У [to_apply.name] конфликт с: [english_list(conflicting_names)]"))
		return

	if(!force && to_apply.is_locked(user))
		return // Message is handled in proc/is_locked()

	AddComponent(/datum/component/xeno_customization, to_apply)

/mob/living/carbon/xenomorph/proc/apply_skin_from_vv(mob/user)
	var/list/available_skins = GLOB.xeno_customizations[caste.caste_type]
	if(!length(available_skins))
		to_chat(user, SPAN_NOTICE("Извините, нет доступных кастомизаций!"))
		return

	var/choice = tgui_input_list(user, "Какую кастомизацию добавить?", "Кастомизация Ксеноморфа", available_skins)
	if(!choice)
		return
	var/datum/xeno_customization_option/choosen_customization = GLOB.xeno_customizations[caste.caste_type][choice]

	apply_skin(user, choosen_customization, force = TRUE)

/mob/living/carbon/xenomorph/proc/remove_skin_from_vv(mob/user)
	var/list/datum/component/xeno_customization/applied_customizations = GetComponents(/datum/component/xeno_customization)
	if(!length(applied_customizations))
		to_chat(user, SPAN_WARNING("Не найдены задейственные кастомизации."))
		return
	var/list/options = list()
	for(var/datum/component/xeno_customization/applied_customization in applied_customizations)
		options["[applied_customization.option.name]"] = applied_customization
	var/choice = tgui_input_list(user, "Какую кастомизацию убрать?", "Кастомизация Ксеноморфа", options)
	if(!choice)
		return
	qdel(options["[choice]"])

/mob/living/carbon/xenomorph/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_ADD_XENO_CUSTOMIZATION, "Xeno Customization - Add")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_XENO_CUSTOMIZATION, "Xeno Customization - Remove")

/mob/living/carbon/xenomorph/vv_do_topic(list/href_list)
	. = ..()
	if(!.)
		return
	if(href_list[VV_HK_ADD_XENO_CUSTOMIZATION] && check_rights(R_VAREDIT))
		apply_skin_from_vv(usr)
	if(href_list[VV_HK_REMOVE_XENO_CUSTOMIZATION] && check_rights(R_VAREDIT))
		remove_skin_from_vv(usr)

#undef VV_HK_ADD_XENO_CUSTOMIZATION
#undef VV_HK_REMOVE_XENO_CUSTOMIZATION
