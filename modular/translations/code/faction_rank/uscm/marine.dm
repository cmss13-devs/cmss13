// ККМП - Корпус Колониальной Морской Пехоты
// При это это морпехи, но морские звания моряков находятся в navydm

/datum/paygrade/marine
	name = "Морпех"

// ENLISTED PAYGRADES

/datum/paygrade/marine/e1
	name = "Рядовой"
	prefix = "Ряд."

/datum/paygrade/marine/e2	// Медики, техники, каргонцы, повышенные рядовые
	name = "Рядовой 1 класса"
	prefix = "Ряд. 1 класса"

/datum/paygrade/marine/e3	// Промежуточный, повышение
	name = "Младший капрал"
	prefix = "Мл.к-л"

/datum/paygrade/marine/e4	// Выдается крювманам, SG, ФТЛ, Спекам, корреспонденту, военной полиции
	name = "Капрал"
	prefix = "К-л"

/datum/paygrade/marine/e5	// Выдается сквадным, Вардену
	name = "Сержант"
	prefix = "С-т"

/datum/paygrade/marine/e6	// Промежуточный
	name = "Штаб-сержант"
	prefix = "Ш/с-т"

/datum/paygrade/marine/e7	// Квартирмейстер, советник
	name = "Комендор-сержант"
	prefix = "К/с-т"

/datum/paygrade/marine/e8	// Синты-поддержки, старшие квартирмейстеры
	name = "Мастер-сержант"
	prefix = "М/с-т"

/datum/paygrade/marine/e8e	// Ивент, щитспавн-советники
	name = "Первый сержант"
	prefix = "П/с-т"

/datum/paygrade/marine/e9	// Ивент, щитспавн
	name = "Старший комендор-сержант"
	prefix = "Ст.К/с-т"

/datum/paygrade/marine/e9e	// Ивент, щитспавн
	name = "Сержант-майор"
	prefix = "С-м"

/datum/paygrade/marine/e9c	// Не используется
	name = "Сержант-майор Корпуса Морпехов"
	prefix = "С-м КМ"

// COMMISSIONED PAYGRADES

/datum/paygrade/marine/o1	// Офицеры: Медбей, ГСБ, СЕ, Пилоты, ИО,
	name = "Второй лейтенант"
	prefix = "В/Л-т"

/datum/paygrade/marine/o2	// Офицеры поддержки, FAX'еры
	name = "Первый лейтенант"
	prefix = "П/л-т"

/datum/paygrade/marine/o3	// XO (Executive), Офицер, повышенный офицер поддержки
	name = "Капитан"
	prefix = "К-н"

/datum/paygrade/marine/o4	// CO (Commanding), ВЛ
	name = "Майор"
	prefix = "М-р"

/datum/paygrade/marine/o5	// CO+, щитспавн
	name = "Лейтенант полковник"
	prefix = "Л-т/п-к"

//Platoon Commander
/datum/paygrade/marine/o6	// CO++, щитспавн, ивент
	name = "Полковник"
	prefix = "П-к"

/datum/paygrade/marine/o6e	// Ивент
	name = "Старший полковник"
	prefix = "Ст.п-к"

/datum/paygrade/marine/o6c	// Ивент
	name = "Полковник дивизии"
	prefix = "Див.п-к"

//High Command	----  Ивенты
/datum/paygrade/marine/o7
	name = "Бригадный генерал"
	prefix = "Бриг.ген."

/datum/paygrade/marine/o8
	name = "Генерал-майор"
	prefix = "Ген.м-р"

/datum/paygrade/marine/o9
	name = "Генерал-лейтенант"
	prefix = "Ген.л-т"

/datum/paygrade/marine/o10
	name = "Генерал"
	prefix = "Ген."

/datum/paygrade/marine/o10c
	name = "Заместитель коменданта Корпуса Морпехов"
	prefix = "Зам.к-т КМП"

/datum/paygrade/marine/o10s
	name = "Комендант Корпуса Морпехов"
	prefix = "К-т КМП"

// Historical Background: Боевым собакам присвоено самое низкое офицерское звание из возможных,
// у них нет формального командования, но если кто-то жестоко обращался с животным,
// нарушителю могло быть предъявлено обвинение в нападении на офицера
/datum/paygrade/marine/k9	// Ивент
	name = "Второй лейтенант, боевой санитар"
	prefix = "В/л-т, боевой санитар"
