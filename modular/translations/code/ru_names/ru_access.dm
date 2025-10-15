/proc/translate_get_access_desc(A)
	switch(A)
		if(ACCESS_MARINE_CMP)
			return "Офис CMP"
		if(ACCESS_MARINE_BRIG)
			return "Бриг"
		if(ACCESS_MARINE_ARMORY)
			return "Оружейная"
		if(ACCESS_MARINE_CMO)
			return "Офис CMO"
		if(ACCESS_MARINE_FIELD_DOC)
			return "Офис полевого врача"
		if(ACCESS_MARINE_MEDBAY)
			return "Медотсек, [MAIN_SHIP_NAME]"
		if(ACCESS_MARINE_RESEARCH)
			return "Отдел исследований, [MAIN_SHIP_NAME]"
		if(ACCESS_MARINE_CHEMISTRY)
			return "Химлаборатория, [MAIN_SHIP_NAME]"
		if(ACCESS_MARINE_MORGUE)
			return "Морг, [MAIN_SHIP_NAME]"
		if(ACCESS_MARINE_CE)
			return "Офис CE"
		if(ACCESS_MARINE_RO)
			return "Офис RO"
		if(ACCESS_MARINE_ENGINEERING)
			return "Инженерный отдел, [MAIN_SHIP_NAME]"
		if(ACCESS_MARINE_OT)
			return "Оружейная мастерская, [MAIN_SHIP_NAME]"
		if(ACCESS_MARINE_GENERAL)
			return "Общий, [MAIN_SHIP_NAME]Общий, [MAIN_SHIP_NAME]"
		if(ACCESS_MARINE_DATABASE)
			return "База данных, [MAIN_SHIP_NAME]"
		if(ACCESS_MARINE_SENIOR)
			return "Старшее командование, [MAIN_SHIP_NAME]"
		if(ACCESS_MARINE_CO)
			return "Офис СО"
		if(ACCESS_MARINE_COMMAND)
			return "Командование, [MAIN_SHIP_NAME]"
		if(ACCESS_MARINE_CREWMAN)
			return "Экипаж танка"
		if(ACCESS_MARINE_PREP)
			return "Подготовка морпехов"
		if(ACCESS_MARINE_ENGPREP)
			return "Инженер"
		if(ACCESS_MARINE_MEDPREP)
			return "Санитар"
		if(ACCESS_MARINE_SPECPREP)
			return "Оружейный специалист"
		if(ACCESS_MARINE_SMARTPREP)
			return "Смартганнер"
		if(ACCESS_MARINE_TL_PREP)
			return "Командир группы"
		if(ACCESS_MARINE_LEADER)
			return "Командир отряда"
		if(ACCESS_MARINE_ALPHA)
			return "отряд Альфа"
		if(ACCESS_MARINE_BRAVO)
			return "отряд Браво"
		if(ACCESS_MARINE_CHARLIE)
			return "отряд Чарли"
		if(ACCESS_MARINE_DELTA)
			return "отряд Дельта"
		if(ACCESS_MARINE_CARGO)
			return "Грузовой техник"
		if(ACCESS_MARINE_DROPSHIP)
			return "Десантный пилот"
		if(ACCESS_MARINE_PILOT)
			return "Боевой пилот"
		if(ACCESS_MARINE_MAINT)
			return "Техник обслуживания, [MAIN_SHIP_NAME]"
		if(ACCESS_CIVILIAN_RESEARCH)
			return "Выживший исследователь"
		if(ACCESS_CIVILIAN_COMMAND)
			return "Командование выживших"
		if(ACCESS_CIVILIAN_MEDBAY)
			return "Выживший медик"
		if(ACCESS_CIVILIAN_LOGISTICS)
			return "Выживший техник"
		if(ACCESS_CIVILIAN_ENGINEERING)
			return "Выживший инженер"
		if(ACCESS_CIVILIAN_BRIG)
			return "Бриг выживших"
		if(ACCESS_CIVILIAN_PUBLIC)
			return "Выжившие"
		if(ACCESS_MARINE_SEA)
			return "Офис SEA"
		if(ACCESS_MARINE_KITCHEN)
			return "Кухня"
		if(ACCESS_MARINE_SYNTH)
			return "Хранилище синтетиков"
		if(ACCESS_MARINE_AI)
			return "Ядро ИИ"
		if(ACCESS_MARINE_AI_TEMP)
			return "Временный доступ ИИ"
		if(ACCESS_ARES_DEBUG)
			return "Отладка ARES"
		else
			return ""
