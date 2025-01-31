/datum/controller/configuration
	var/brainrot_notifications = list(
		"Почему у меня такой скудный словарный запас? Стоит сходить в библиотеку и прочесть книгу...",
		"Что, черт побери, я несу?",
		"Я в своём уме? Надо следить за языком.",
		"Неужели я не могу подобрать нужных слов? Позор мне..."
	)
	var/brainrot_regex

/datum/controller/configuration/proc/filter_speech(client/user, message)
	if(!length(message))
		return TRUE

	if(message[1] == "*")
		return TRUE

	if(!brainrot_regex)
		return TRUE

	var/original_message = copytext(message, 1)
	message = rustutils_regex_replace(message, brainrot_regex, "i", "цветочек")
	if(original_message == message)
		return TRUE

	to_chat(user,
		html = "\n<font color='red' size='3'><b>-- Фильтр Плохих Выражений --</b></font>",
		)
	to_chat(user,
		type = MESSAGE_TYPE_ADMINPM,
		html = "\n<font color='red' size='2'><b>Ваше сообщение было автоматически отфильтровано из-за его содержания. Попытка обойти этот фильтр приведет к бану.</b></font>",
		)
	SEND_SOUND(user, sound('sound/effects/adminhelp_new.ogg'))
	log_admin("[user.ckey] попытался сказать запретное слово: [original_message].")

	if(ishuman(user))
		var/mob/living/L = user
		L.apply_stamina_damage(80)
		L.adjustOxyLoss(30)
		L.adjustBrainLoss(1)
		L.emote("drool")
		to_chat(L, SPAN_PSYTALK(pick(brainrot_notifications)))

	return FALSE

/datum/controller/configuration/proc/load_ss220_filters()
	if(!fexists("[directory]/word_filter.txt"))
		return FALSE

	log_config("Loading config file word_filter.txt...")

	var/list/filters
	if(!filters)
		filters = file2list("[directory]/word_filter.txt")

	if(!brainrot_regex)
		var/list/unique_filters = list()
		unique_filters |= filters
		brainrot_regex = unique_filters.Join("|")
