/proc/translate_time2text(time, format = "DD Month YYYY")
	var/day = time2text(time, "Day")
	var/month = time2text(time, "Month")

	// Перевод дней
	var/static/list/translate_days = list(
		"Monday" = "Понедельник",
		"Tuesday" = "Вторник",
		"Wednesday" = "Среда",
		"Thursday" = "Четверг",
		"Friday" = "Пятница",
		"Saturday" = "Суббота",
		"Sunday" = "Воскресенье"
	)

	// Перевод месяцев
	var/static/list/translate_months = list(
		"January" = "Января",
		"February" = "Февраля",
		"March" = "Марта",
		"April" = "Апреля",
		"May" = "Мая",
		"June" = "Июня",
		"July" = "Июля",
		"August" = "Августа",
		"September" = "Сентября",
		"October" = "Октября",
		"November" = "Ноября",
		"December" = "Декабря"
	)

	var/translate_day = translate_days[day] || day
	var/translate_month = translate_months[month] || month
	var/day_num = time2text(time, "DD")
	var/year = time2text(time, "YYYY")

	return "[translate_day], [day_num] [translate_month] [year]"
