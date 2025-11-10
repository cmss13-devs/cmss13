/mob/living/carbon/human/proc/issue_order(order)
	if(!HAS_TRAIT(src, TRAIT_LEADERSHIP))
		to_chat(src, SPAN_WARNING("Вы не можете отдавать приказы!"))
		return

	if(stat)
		to_chat(src, SPAN_WARNING("Вы не можете отдать приказ в вашем текущем состоянии."))
		return

	if(!command_aura_available)
		to_chat(src, SPAN_WARNING("Вы недавно отдали приказ. Подождите немного."))
		return

	if(!skills)
		return FALSE
	var/order_level = skills.get_skill_level(SKILL_LEADERSHIP)
	if(!order_level)
		order_level = SKILL_LEAD_TRAINED

	if(!order)
		order = tgui_input_list(src, "Choose an order", "Order to send", list(COMMAND_ORDER_MOVE, COMMAND_ORDER_HOLD, COMMAND_ORDER_FOCUS, "help", "cancel"))
		if(order == "help")
			to_chat(src, SPAN_NOTICE("<br>Приказы ненадолго дают бонусы ближайшим морпехам:<br><B>Вперёд</B> - Повышает скорость передвижения и шанс уклонения.<br><B>Держать позицию</B> - Повышает устойчивость к боли и ранениям.<br><B>Сосредоточить огонь</B> - Повышает точность и эффективную дальность стрельбы.<br>"))
			return
		if(!order || order == "cancel")
			return

		if(!command_aura_available)
			to_chat(src, SPAN_WARNING("Вы недавно отдали приказ. Подождите немного."))
			return

	command_aura_available = FALSE
	var/command_aura_strength = order_level
	var/command_aura_duration = (order_level + 1) * 10 SECONDS

	var/turf/T = get_turf(src)
	for(var/mob/living/carbon/human/H in range(COMMAND_ORDER_RANGE, T))
		if(H.stat == DEAD)
			continue
		if(!ishumansynth_strict(H))
			continue
		H.activate_order_buff(order, command_aura_strength, command_aura_duration)

	if(loc != T) //if we were inside something, the range() missed us.
		activate_order_buff(order, command_aura_strength, command_aura_duration)

	for(var/datum/action/A in actions)
		A.update_button_icon()

	// 1min cooldown on orders
	addtimer(CALLBACK(src, PROC_REF(make_aura_available)), COMMAND_ORDER_COOLDOWN)

	if(src.client?.prefs?.toggle_prefs & TOGGLE_LEADERSHIP_SPOKEN_ORDERS)
		var/spoken_order = ""
		switch(order)
			if(COMMAND_ORDER_MOVE)
				spoken_order = pick("ДВИГАЕМ БУЛКАМИ!", "ШЕВЕЛИМСЯ!", "ДВИГАЕМСЯ, ДВИГАЕМСЯ!", "ПОШЁЛ, ПОШЁЛ, ПОШЁЛ!", "ВПЕРЁД! БЫСТРЕЕ!", "ДВИГАЙ, ДВИГАЙ, ДВИГАЙ!", "БЕГОМ, МАРШ!", "ШИРЕ ШАГ!", "ШЕВЕЛИМ ЛАСТАМИ!", "ШЕВЕЛИМ НОЖКАМИ, ДАМЫ!", "НЕ РАССЛАБЛЯЕМСЯ!", "БЕГОМ, БЕГОМ!", "ЧОП ЧОП!", "УСКОРЯЕМСЯ!", "ВПЕРЁД!", "ВЫДВИГАЕМСЯ!", "ЗА МНОЙ!", "ПОДНАЖМЕМ!", "СОБРАТЬСЯ, ЗА МНОЙ!", "ДВИГАЕМСЯ!", "УСКОРЯЕМ ТЕМП!", "ДВИГАЕМ БУЛКАМИ, ДАМЫ!", "НОГИ В ЗУБЫ И ВПЕРЁД!", "БЕГИ ФОРЕСТ, БЕГИ!", "ЗА МНОЙ ПАРНИ, ВПЕРЁД!", "ШЕВЕЛИМ ПОРШНЯМИ!", "ЛЕТИМ ОТСЮДА!", "В ТЕМПЕ ВАЛЬСА!", "РВЁМ КОГТИ!", "ШНЕЛЛЕ-ШНЕЛЛЕ!")
			if(COMMAND_ORDER_HOLD)
				spoken_order = pick("ДЕРЖИМ УДАР!", "БЕРЕЧЬ ГОЛОВУ!", "ПРИГОТОВИТЬСЯ К СТОЛКНОВЕНИЮ!", "ДЕРЖАТЬСЯ!", "ДЕРЖАТЬ СТРОЙ!", "НЕ СДАВАТЬСЯ!", "ПРИГОТОВИТЬСЯ К УДАРУ!", "УДЕРЖИВАЕМ!", "НИ ШАГУ НАЗАД!", "НЕ ОТСТУПАТЬ!", "ЗАКРЕПИТЬСЯ!", "ЗАКРЕПЛЯЕМСЯ!", "ОКОПАТЬСЯ!", "УДЕРЖИВАЕМ ПОЗИЦИЮ!", "СТОИМ И СРАЖАЕМСЯ!", "СТОИМ ДО ПОСЛЕДНЕГО!", "СТОИМ ДО КОНЦА!", "ОБОРОНИТЕЛЬНАЯ ПОЗИЦИЯ!", "ОКАПЫВАЕМСЯ!", "ЗАНЯТЬ ПОЗИЦИИ!", "СТОИМ!", "ОБОРОНЯЕМСЯ!", "ЗАНЯТЬ ОБОРОНУ!", "ВСЕМ БЫТЬ НАЧЕКУ!", "ВСПЫШКА!", "ДЕРЖАТЬ ПОЗИЦИИ!", "ПОДНЯТЬ ЩИТЫ!", "БОЙ ЕЩЁ НЕ ОКОНЧЕН, ДАМЫ!", "УХОДИМ В ОБОРОНУ!", "ДЕРЖИМСЯ ЗА МНОЙ!", "ОБОРОНЯЕМ ПОЗИЦИИ!", "ЗА БАРИКАДЫ, ОТКРЫТЬ ОГОНЬ!", "В ОБОРОНУ!", "ОНИ НЕ СЛОМЯТ НАШ ДУХ!", "СОМКНУТЬ РЯДЫ!", "ЗА БАРИКАДЫ!", "ЗАТЯНИТЕ ПОЯСА, МОРПЕХИ!", "ЗА НАМИ ФОБ, ОГОНЬ!", "НЕ СДАВАТЬСЯ, ОСТАЛОСЬ НЕМНОГО!")
			if(COMMAND_ORDER_FOCUS)
				spoken_order = pick("ЗАДАДИМ ИМ!", "СОСРЕДОТОЧИТЬ ОГОНЬ!", "СТРЕЛЬБА НА ПОРАЖЕНИЕ!", "ПРИМКНУТЬ ШТЫКИ!", "ОГОНЬ ПО ГОТОВНОСТИ!", "ОРУЖИЕ НА ИЗГОТОВКУ!", "ЦЕЛЬСЯ!", "ВНИМАНИЕ!", "ОГОНЬ!", "ПРИГОТОВИТЬСЯ К БОЮ!", "НАКОРМИМ ИХ СВИНЦОМ!", "УНИЧТОЖИТЬ ЦЕЛЬ!", "ЗАДАДИМ ИМ ЖАРУ!", "ЦЕЛЬСЯ, ОГОНЬ!", "РАЗОРВЕМ ИХ!", "ПУСКАЙ ЛОВЯТ МАСЛИНЫ!", "НЕ ДАЕМ ИМ ВЫСУНУТЬСЯ!", "СОСРЕДОТОЧИТЬ ШКВАЛ ОГНЯ!", "ЗАШИБЕМ!", "НЕ ПАЛИТЕ ПО СВОИМ!", "ОГОНЬ ПО МОЕЙ КОМАНДЕ!", "ВЕДЁМ ПЛОТНЫЙ ОГОНЬ!", "ЗАЛЬЁМ ИХ СВИНЦОМ!", "УБИТЬ ИХ ВСЕХ!", "ОГОНЬ, ОГОНЬ, ОГОНЬ!", "КРЕПЧЕ ДЕРЖИМ СТВОЛЫ!", "ЦЕЛЬТЕСЬ В СЛАБЫЕ МЕСТА!", "ОГОНЬ ПО ВРАГУ!", "НЕ ЖАЛЕЕМ ПАТРОНЫ!", "ЗАДАВИМ ИХ ОГНЁМ!", "ВЕДЁМ ПЕРЕКРЁСТНЫЙ ОГОНЬ!", "ГОТОВЬТЕСЬ К БОЮ!")   
		say(spoken_order) // if someone thinks about adding new lines, it'll be better to split the current ones we have into two different lists per order for readability, and have a coin flip pick between spoken_orders 1 or 2
	else
		visible_message(SPAN_BOLDNOTICE("[src] gives an order to [order]!"), SPAN_BOLDNOTICE("You give an order to [order]!"))

/mob/living/carbon/human/proc/make_aura_available()
	to_chat(src, SPAN_NOTICE("Вы можете отдать приказ ещё раз."))
	command_aura_available = TRUE
	for(var/datum/action/A in actions)
		A.update_button_icon()


/mob/living/carbon/human/verb/issue_order_verb()
	set name = "Issue Order"
	set desc = "Issue an order to nearby humans, using your authority to strengthen their resolve."
	set category = "IC"

	issue_order()


/mob/living/carbon/human/proc/activate_order_buff(order, strength, duration)
	if(!order || !strength)
		return

	switch(order)
		if(COMMAND_ORDER_MOVE)
			mobility_aura_count++
			mobility_aura = clamp(mobility_aura, strength, ORDER_MOVE_MAX_LEVEL)
		if(COMMAND_ORDER_HOLD)
			protection_aura_count++
			protection_aura = clamp(protection_aura, strength, ORDER_HOLD_MAX_LEVEL)
			pain.apply_pain_reduction(protection_aura * PAIN_REDUCTION_AURA)
		if(COMMAND_ORDER_FOCUS)
			marksman_aura_count++
			marksman_aura = clamp(marksman_aura, strength, ORDER_FOCUS_MAX_LEVEL)

	hud_set_order()

	if(duration)
		addtimer(CALLBACK(src, PROC_REF(deactivate_order_buff), order), duration)


/mob/living/carbon/human/proc/deactivate_order_buff(order)
	switch(order)
		if(COMMAND_ORDER_MOVE)
			if(mobility_aura_count > 1)
				mobility_aura_count--
			else
				mobility_aura_count = 0
				mobility_aura = 0
		if(COMMAND_ORDER_HOLD)
			if(protection_aura_count > 1)
				protection_aura_count--
			else
				pain.reset_pain_reduction()
				protection_aura_count = 0
				protection_aura = 0
		if(COMMAND_ORDER_FOCUS)
			if(marksman_aura_count > 1)
				marksman_aura_count--
			else
				marksman_aura_count = 0
				marksman_aura = 0

	hud_set_order()

/mob/living/carbon/human/proc/cycle_voice_level()
	if(!HAS_TRAIT(src, TRAIT_LEADERSHIP)) // just in case
		to_chat(src, SPAN_WARNING("You don't particularly understand how to speak... 'authoritatively .'"))
		return

	switch(langchat_styles)
		if("", null)
			langchat_styles = "langchat_smaller_bolded"
			to_chat(src, SPAN_NOTICE("You will now speak authoritatively ."))
			return

		if("langchat_smaller_bolded")
			langchat_styles = "langchat_bolded"
			to_chat(src, SPAN_NOTICE("You will now speak loudly and authoritatively ."))
			return

		if("langchat_bolded")
			langchat_styles = ""
			to_chat(src, SPAN_NOTICE("You will now speak normally."))
			return
