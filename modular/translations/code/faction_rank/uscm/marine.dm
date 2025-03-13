// ККМП - Корпус Колониальной Морской Пехоты
// При это это морпехи, но морские звания моряков находятся в navydm

/datum/paygrade/marine
	name = "Морпех"

// ENLISTED PAYGRADES

/datum/paygrade/marine/e1
	name = "Рядовой"
	prefix = "Ряд"

/datum/paygrade/marine/e2	// Медики, техники, каргонцы, повышенные рядовые
	name = "Рядовой Первого Класса"
	prefix = "РядПк"

/datum/paygrade/marine/e3	// Промежуточный, повышение
	name = "Младший Капрал"
	prefix = "МлКпл"

/datum/paygrade/marine/e4	// Выдается крювманам, SG, ФТЛ, Спекам, корреспонденту, военной полиции
	name = "Капрал"
	prefix = "Кпл"

/datum/paygrade/marine/e5	// Выдается сквадным, Вардену
	name = "Сержант"
	prefix = "Серж"

/datum/paygrade/marine/e6	// Промежуточный
	name = "Старший Сержант"
	prefix = "СтСерж"

/datum/paygrade/marine/e7	// Квартирмейстер, советник
	name = "Орудийный-Сержант"
	prefix = "Орд-Серж"

/datum/paygrade/marine/e8	// Синты-поддержки, старшие квартирмейстеры
	name = "Мастер-Сержант"
	prefix = "Мст-Серж"

/datum/paygrade/marine/e8e	// Ивент, щитспавн-советники
	name = "Младший Лейтенант"
	prefix = "МлЛейт"

/datum/paygrade/marine/e9	// Ивент, щитспавн
	name = "Капитан"
	prefix = "Капитан"

/datum/paygrade/marine/e9e	// Ивент, щитспавн
	name = "Майор"
	prefix = "Майор"

/datum/paygrade/marine/e9c	// Не используется
	name = "Майор Корпуса Колонильных Морпехов"
	prefix = "Майор ККМ"

// COMMISSIONED PAYGRADES

/datum/paygrade/marine/o1	// Офицеры: Медбей, ГСБ, СЕ, Пилоты, ИО,
	name = "Лейтенант"
	prefix = "Лейт"

/datum/paygrade/marine/o2	// Офицеры поддержки, FAX'еры
	name = "Старший Лейтенант"
	prefix = "Старлей"

/datum/paygrade/marine/o3	// XO (Executive), Офицер, повышенный офицер поддержки
	name = "Капитан"
	prefix = "Капитан"

/datum/paygrade/marine/o4	// CO (Commanding), ВЛ
	name = "Майор"
	prefix = "Майор"

/datum/paygrade/marine/o5	// CO+, щитспавн
	name = "Подполковник"
	prefix = "Подполк"

//Platoon Commander
/datum/paygrade/marine/o6	// CO++, щитспавн, ивент
	name = "Полковник"
	prefix = "Полк"

/datum/paygrade/marine/o6e	// Ивент
	name = "Старший Полковник"
	prefix = "СтПолк"

/datum/paygrade/marine/o6c	// Ивент
	name = "Полковник Дивизии"
	prefix = "ПолкДив"

//High Command	----  Ивенты
/datum/paygrade/marine/o7
	name = "Генерал-Бригадир"
	prefix = "Ген-Бриг"

/datum/paygrade/marine/o8
	name = "Генерал-Майор"
	prefix = "Ген-Майор"

/datum/paygrade/marine/o9
	name = "Генерал-Лейтенант"
	prefix = "Ген-Лейт"

/datum/paygrade/marine/o10
	name = "Генерал"
	prefix = "Ген"

/datum/paygrade/marine/o10c
	name = "Помощник коменданта Корпуса Морской Пехоты"
	prefix = "ПомККМП"

/datum/paygrade/marine/o10s
	name = "Комендант Корпуса Морской Пехота"
	prefix = "ККМП"

// Historical Background: Боевым собакам присвоено самое низкое офицерское звание из возможных,
// у них нет формального командования, но если кто-то жестоко обращался с животным,
// нарушителю могло быть предъявлено обвинение в нападении на офицера
/datum/paygrade/marine/k9	// Ивент
	name = "Младший лейтенант, Боевой Спаситель"
	prefix = "МлЛейт, Боевой Спаситель"
