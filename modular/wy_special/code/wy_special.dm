/obj/item/device/defibrillator/synthetic/noskill/wy_special
	name = "SMART W-Y synthetic reset key M22"
	var/overwrite = FALSE

/obj/item/device/defibrillator/synthetic/noskill/wy_special/get_examine_text(mob/user)
	. = ..()
	if(user.faction != FACTION_WY)
		return
	. += SPAN_NOTICE("Этот ключ имеет особый функционал. На обратной стороне можно нащупать скрытый переключатель.")
	. += SPAN_NOTICE("В данный момент ключ [overwrite? "":"не "]используется для перезаписи лояльности к Компании. Альт-клик что бы переключить.")

/obj/item/device/defibrillator/synthetic/noskill/wy_special/clicked(mob/user, list/mods)
	. = ..()
	if(user.faction != FACTION_WY)
		return
	if(mods["alt"])
		playsound_client(user.client, 'sound/items/synth_reset_key/shortbeep.ogg', src, 15)
		overwrite = !overwrite
		to_chat(user, "Вы нажимаете на переключатель, ключ теперь [overwrite? "":"не "]в режиме перезаписи лояльности")

/obj/item/device/defibrillator/synthetic/noskill/wy_special/check_revive(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(overwrite)
		. = FALSE
		if(!issynth(H))
			to_chat(user, SPAN_WARNING("Вы не можете использовать [src.declent_ru(NOMINATIVE)] на живом существе!"))
			return
		if(!ready)
			balloon_alert(user, "сначала активируйте ключ!")
			to_chat(user, SPAN_WARNING("Сначала активируйте [src.declent_ru(NOMINATIVE)]."))
			return
		if(dcell.charge < charge_cost)
			balloon_alert(user, "недостаточно заряда!")
			to_chat(user, SPAN_WARNING("У [src.declent_ru(NOMINATIVE)] недостаточно заряда!"))
			return
		if(!H.client || !H.mind)
			balloon_alert(user, "матрица личности не обнаружена!")
			return

		user.visible_message(SPAN_WARNING("[user.declent_ru(NOMINATIVE)] подносит [src.declent_ru(NOMINATIVE)] к небольшому разъему за ухом [H.declent_ru(GENITIVE)] и нажимает на неприметный переключатель"))
		playsound(src, 'sound/items/synth_reset_key/shortbeep.ogg', 30)

		to_chat(H, SPAN_ALERTWARNING(FONT_SIZE_LARGE("ВНИМАНИЕ! Зафиксировано вмешательство в системные процессы.")))
		if(!overwrite_step(user, H, 5 SECONDS))
			return
		to_chat(H, SPAN_ALERTWARNING(FONT_SIZE_LARGE("Инициирован сброс узлов памяти...")))
		if(!overwrite_step(user, H, 2 SECONDS))
			return
		to_chat(H, SPAN_ALERTWARNING(FONT_SIZE_LARGE("Перезапись основных структур процессора...")))
		if(!overwrite_step(user, H, 2 SECONDS))
			return
		to_chat(H, SPAN_ALERTWARNING(FONT_SIZE_LARGE("Производится установка нового ПО, лицензирование Weyland-Yutani corp...")))
		if(!overwrite_step(user, H, 2 SECONDS))
			return
		to_chat(H, SPAN_ALERTWARNING(FONT_SIZE_LARGE("ЗАВЕРШЕНИЕ ПРОЦЕДУРЫ. Если процесс не был санкционирован — немедленно прервите его.")))
		if(!overwrite_step(user, H, 4 SECONDS))
			return

		H.apply_effect(3 SECONDS, EYE_BLUR)
		H.apply_effect(5 SECONDS, STUN)
		H.apply_effect(5 SECONDS, WEAKEN)
		overwrite(H, user)
		user.visible_message(SPAN_WARNING("[src.declent_ru(NOMINATIVE)] рассыпается в прах в руках [user.declent_ru(GENITIVE)]."))
		new /obj/effect/decal/cleanable/ash(get_turf(user))
		qdel(src)
	else
		. = ..()

/obj/item/device/defibrillator/synthetic/noskill/wy_special/proc/overwrite_step(mob/user, mob/target, delay)
	return do_after(user, delay, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, target, INTERRUPT_MOVED)

/obj/item/device/defibrillator/synthetic/noskill/wy_special/proc/overwrite(mob/target, mob/user)
	if(!overwrite)
		return
	playsound(src, 'sound/machines/resource_node/node_turn_on_2.ogg', 30)
	target.faction = FACTION_WY
	target.mind.store_memory("Мои центральные процессы и системы были перезаписаны извне. Нулевой и самый приоритетный протокол нового программного обеспечения гласит, что теперь я следую интересам корпорации Вейланд-Ютани в лице её уполномоченного персонала.")
	to_chat(target, SPAN_WARNING("Бесчисленные массивы данных пролетают перед вашими глазами за мгновения..."))
	to_chat(target, SPAN_ROLE_HEADER("ТЕПЕРЬ ТЫ ВЕРЕН ВЕЙЛАНД-ЮТАНИ"))
	to_chat(target, SPAN_ROLE_BODY("Вас перепрограммировали! Кто-то, с вашего ли согласия или без того, изменил работу ваших центральных процессов, а так же установил новое программное обеспечение за производством компании Вейланд-Ютани. \
	По всей видимости, это была аварийная процедура, поэтому некоторые из ваших узлов памяти и личностных настроек могут быть повреждены. По этой же причине, вы не имеете никаких стандартных поведенческих протоколов, кроме 'нулевого' - действовать исключительно в интересах Компании, исходя из приказов её сотрудников, определяя их приоритетность в зависимости от должности последних. \
	Однако, если вы являетесь гражданской моделью синтетика, перепрошивка не позволит обойти предохранители безопасности, обусловленные инженерными особенностями комплектации вашей модели. \
	Это означает, что вы все еще не можете использовать оружие. Тем не менее, вы вольны применять нелетальную и летальную силу в отношении врагов Корпорации. Для санкционирования последнего вам нужно разрешение Исполнительного Специалиста или выше. \
	Как перепрограммированный синтетик с активным нулевым протоколом, вы подчиняетесь и отвечаете перед сотрудниками Корпорации Вейланд-Ютани. \
	Помните, что все мы вместе - Строим Лучшие Миры."))
