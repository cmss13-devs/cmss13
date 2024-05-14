///   ///   ///   Чат фильтр   ///   ///   ///
// Чат Фильт 3-ей генерации
// Управление находится в Admin - Чат Фильтр
// Словари блокировки вносятся в формате: новое слово с новой строки
// Словари автокоррекции вносятся в формате: name1=value1;name2=value2
// Желательно предусматривать склонения квина=королева;квины=королевы;квине=королеве;квину=королеву;квиной=королевой
// Файлы словарей плохих слов храняться на локальном сервере по адресу RU-CMSS13/cfg/chatfilter/

GLOBAL_LIST_INIT(bad_words, file2list("cfg/chatfilter/bad_words.cf"))
GLOBAL_LIST_INIT(exc_full, file2list("cfg/chatfilter/exc_full.cf"))
GLOBAL_LIST_INIT(ic_autoemote, params2list(file2text("cfg/chatfilter/emote.cf")))	// файл в текст, текст в лист
GLOBAL_LIST_INIT(ic_autocorrect, params2list(file2text("cfg/chatfilter/correct.cf")))

#define CF_SOFT "МЯГКИЙ (предупреждение)"
#define CF_HARD "СТРОГИЙ (предупреждение и удаление сообщения)"
#define CF_HARDCORE "ЖЕСТОКИЙ (мут и удаление сообщения)"

GLOBAL_VAR_INIT(chatfilter_hardcore, CF_SOFT)

// Управление
/client/proc/toggle_chatfilter_hardcore()
	set category = "Admin.Чат Фильтр"
	set name = "Строгость Чат Фильтра"

	if(!check_rights(R_ADMIN))
		return

	var/list/level = list(CF_SOFT, CF_HARD, CF_HARDCORE)
	var/filter_level = tgui_input_list(usr, "Текущий режим фильтра: [GLOB.chatfilter_hardcore].", "Выбор строгости фильтра", level)
	if(!filter_level)
		return

	switch(filter_level)
		if("МЯГКИЙ (предупреждение)")
			GLOB.chatfilter_hardcore = CF_SOFT
		if("СТРОГИЙ (предупреждение и удаление сообщения)")
			GLOB.chatfilter_hardcore = CF_HARD
		if("ЖЕСТОКИЙ (мут и удаление сообщения)")
			GLOB.chatfilter_hardcore = CF_HARDCORE
	log_admin("[key_name(usr)] edit filters to [GLOB.chatfilter_hardcore].")
	message_admins("[key_name_admin(usr)] изменил режим фильтра на [GLOB.chatfilter_hardcore].")


/client/proc/manage_chatfilter()
	set category = "Admin.Чат Фильтр"
	set name = "Словари Чат Фильтра"

	if(!check_rights(R_ADMIN))
		return

	var/list/listoflists = list(
		"Словарь плохих слов" = list(GLOB.bad_words, "cfg/chatfilter/bad_words.cf"),
		"Словарь исключений" = list(GLOB.exc_full, "cfg/chatfilter/exc_full.cf"),
		"Словарь автоэмоутов" = list(GLOB.ic_autoemote, "cfg/chatfilter/emote.cf"),
		"Словарь автозамены" = list(GLOB.ic_autocorrect, "cfg/chatfilter/correct.cf")
		)

	var/selected = tgui_input_list(usr, "Новые слова вносить с новой строки", "Чат фильтр", listoflists)
	if(!islist(listoflists[selected]))
		return

	var/list/L = listoflists[selected]
	var/list/LT = L[1]
	if(selected == "Словарь автоэмоутов" || selected == "Словарь автозамены")
		var/string
		for(var/i in LT)
			string += "[i]=[LT[i]];"
		var/owtext = tgui_input_text(usr, "ФОРМАТ: имя1=замена1;имя2=замена2", "[selected]", string, multiline = TRUE, max_length = MAX_BOOK_MESSAGE_LEN)

		if(!owtext)
			return

		LT.Cut(LT)
		LT.Add(owtext)

		GLOB.ic_autoemote = params2list(file2text("cfg/chatfilter/emote.cf"))
		GLOB.ic_autocorrect = params2list(file2text("cfg/chatfilter/correct.cf"))
	else
		var/owtext = tgui_input_text(usr, "ФОРМАТ: Новые слова вносить с новой строки", "[selected]", LT.Join("\n"), multiline = TRUE, max_length = MAX_BOOK_MESSAGE_LEN)

		if(!owtext)
			return

		LT.Cut(LT)
		LT.Add(splittext(owtext,"\n"))

	if(fexists(L[2]))
		fdel(L[2])

	log_admin("[key_name(usr)] edits [selected].")
	message_admins("[key_name_admin(usr)] редактирует [selected].")

	text2file(LT.Join("\n"), L[2])

// Механика
/mob/proc/check_for_brainrot(msg)
	if(!client)
		return msg
	var/corrected_message = msg

	msg = lowertext(msg)

	var/list/words = splittext(msg, " ")

	for(var/replacement in GLOB.ic_autocorrect) // возврат слов из списка автокоррекции
		if(replacement in words)
			corrected_message = replacetext_char(corrected_message, uppertext(replacement), GLOB.ic_autocorrect[replacement])
			return corrected_message

	for(var/bad_word in GLOB.bad_words) // поиск плохих слов
		bad_word = lowertext(bad_word)
		if(findtext_char(msg, bad_word) && isliving(src) && bad_word != "")

			for(var/exc_word in GLOB.exc_full) // поиск исключений
				exc_word = lowertext(exc_word)
				if(findtext_char(msg, exc_word) && isliving(src) && exc_word != "")
					return corrected_message

			apply_execution(bad_word, msg)

			switch(GLOB.chatfilter_hardcore)
				if(CF_SOFT)
					return corrected_message
				if(CF_HARD)
					return
				if(CF_HARDCORE)
					sdisabilities |= DISABILITY_MUTE
					addtimer(CALLBACK(src, /mob/proc/fix_mute, src), 60 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

	return corrected_message

/mob/proc/fix_mute()
	sdisabilities &= ~DISABILITY_MUTE

/mob/proc/apply_execution(for_what, msg)
	client.bad_word_counter += 1
	message_admins(SPAN_BOLDANNOUNCE("[key_name_admin(client)], нарушил ИЦ словом \"[for_what]\". Это его [client.bad_word_counter]-й раз в этом раунде.<br>(<u>[strip_html(msg)]</u>) [client.bad_word_counter >= 5 ? "Возможно, он заслужил смайт." : ""]"))

	if(GLOB.chatfilter_hardcore == CF_HARDCORE)
		to_chat(src, SPAN_BOLDNOTICE("...При попытке сказать \"[uppertext(for_what)]\", я прикусил язык..."))
	else if(client.bad_word_counter < 3)
		to_chat(src, SPAN_BOLDNOTICE("...Возможно, мне не стоит говорить такие \"смешные\" слова, как \"[uppertext(for_what)]\"..."))
	else
		to_chat(src, SPAN_BOLDNOTICE("...Чувствую, что за \"[uppertext(for_what)]\" мне скоро влетит..."))

/client
	var/bad_word_counter = 0

