#define get_job_playtime(client, job) (client.player_data? LAZYACCESS(client.player_data.playtimes, job)? client.player_data.playtimes[job].total_minutes MINUTES_TO_DECISECOND : 0 : 0)
#define GET_MAPPED_ROLE(title) (GLOB.RoleAuthority?.role_mappings[title] ? GLOB.RoleAuthority.role_mappings[title] : GLOB.RoleAuthority.roles_by_name[title])
#define GET_DEFAULT_ROLE(title) (GLOB.RoleAuthority?.default_roles[title] ? GLOB.RoleAuthority.default_roles[title] : title)

// Squad name defines
#define SQUAD_MARINE_1 "Альфа"
#define SQUAD_MARINE_2 "Браво"
#define SQUAD_MARINE_3 "Чарли"
#define SQUAD_MARINE_4 "Дельта"
#define SQUAD_MARINE_5 "Эхо"
#define SQUAD_MARINE_CRYO "Фоксрот"
#define SQUAD_MARINE_INTEL "Интел"
#define SQUAD_SOF "SOF"
#define SQUAD_CBRN "CBRN"
#define SQUAD_FORECON "РАЗВЕДКА"
#define SQUAD_SOLAR "Дьяволы Солнца"

// Job name defines
#define JOB_SQUAD_MARINE "Стрелок"
#define JOB_SQUAD_LEADER "Командир Отряда"
#define JOB_SQUAD_ENGI "Полевой Техник"
#define JOB_SQUAD_MEDIC "Полевой Санитар"
#define JOB_SQUAD_SPECIALIST "Оружейный Специалист"
#define JOB_SQUAD_TEAM_LEADER "Командир Боевой Группы"
#define JOB_SQUAD_SMARTGUN "Смартганнер"
#define JOB_SQUAD_ROLES /datum/timelock/squad
#define JOB_SQUAD_ROLES_LIST list(JOB_SQUAD_MARINE, JOB_SQUAD_LEADER, JOB_SQUAD_ENGI, JOB_SQUAD_MEDIC, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_TEAM_LEADER)

GLOBAL_LIST_INIT(job_squad_roles, JOB_SQUAD_ROLES_LIST)

#define JOB_COLONIST "Колонист"
#define JOB_PASSENGER "Пассажир"
#define JOB_SURVIVOR "Выживший"
#define JOB_SYNTH_SURVIVOR "Выживший Синтетик"
#define JOB_CO_SURVIVOR "Выживший КО"

#define ANY_SURVIVOR "Любой Выживший"
#define CIVILIAN_SURVIVOR "Выживший Гражданский"
#define SECURITY_SURVIVOR "Выживший Безопасник"
#define SCIENTIST_SURVIVOR "Выживший Ученый"
#define MEDICAL_SURVIVOR "Выживший Медик"
#define ENGINEERING_SURVIVOR "Выживший Инженер"
#define CORPORATE_SURVIVOR "Выживший Корпорат"
#define HOSTILE_SURVIVOR "Враждебный Выживший" //AKA Marine Killers assuming they survive. Will do cultist survivor at some point.
#define SURVIVOR_VARIANT_LIST list(ANY_SURVIVOR = "Any", CIVILIAN_SURVIVOR = "Civ", SECURITY_SURVIVOR = "Sec", SCIENTIST_SURVIVOR = "Sci", MEDICAL_SURVIVOR = "Med", ENGINEERING_SURVIVOR = "Eng", CORPORATE_SURVIVOR = "W-Y", HOSTILE_SURVIVOR = "КОФ")

//-1 is infinite amount, these are soft caps and can be bypassed by randomization
#define MAX_SURVIVOR_PER_TYPE list(ANY_SURVIVOR = -1, CIVILIAN_SURVIVOR = -1, SECURITY_SURVIVOR = 2, SCIENTIST_SURVIVOR = 2, MEDICAL_SURVIVOR = 3, ENGINEERING_SURVIVOR = 4, CORPORATE_SURVIVOR = 2, HOSTILE_SURVIVOR = 1)

#define SPAWN_PRIORITY_VERY_HIGH 1
#define SPAWN_PRIORITY_HIGH 2
#define SPAWN_PRIORITY_MEDIUM 3
#define SPAWN_PRIORITY_LOW 4
#define SPAWN_PRIORITY_VERY_LOW 5
#define LOWEST_SPAWN_PRIORITY 5

#define JOB_CMO "Главрач"
#define JOB_DOCTOR "Доктор"
#define JOB_SURGEON "Хирург"

#define JOB_NURSE "Медработник" // т.к. нет зависимости от пола, из-за чего нельзя медсестра/медбрат
#define JOB_RESEARCHER "Исследователь"
#define JOB_MEDIC_ROLES  /datum/timelock/medic
#define JOB_MEDIC_ROLES_LIST list(JOB_SQUAD_MEDIC, JOB_CMO, JOB_DOCTOR, JOB_NURSE, JOB_RESEARCHER, JOB_SURGEON)

#define JOB_CORPORATE_LIAISON "Связной Корпорации"

#define JOB_COMBAT_REPORTER "Полевой Корреспондент"
#define JOB_CIVIL_ROLES    /datum/timelock/civil
#define JOB_CIVIL_ROLES_LIST   list(JOB_COMBAT_REPORTER)

#define JOB_MESS_SERGEANT "Обслуживающий Персонал"
#define JOB_SYNTH "Синтетик"
#define JOB_SYNTH_K9 "Синтетик K9"
#define JOB_WORKING_JOE "Рабочий Джо"

#define JOB_CO "Коммандующий Офицер"
#define JOB_XO "Исполнительный Офицер"
#define JOB_SO "Штаб-Офицер"
#define JOB_AUXILIARY_OFFICER "Офицер Поддержки"
#define JOB_COMMAND_ROLES /datum/timelock/command
#define JOB_COMMAND_ROLES_LIST   list(JOB_CO, JOB_XO, JOB_SO, JOB_AUXILIARY_OFFICER)
GLOBAL_LIST_INIT(job_command_roles, JOB_COMMAND_ROLES_LIST)

#define JOB_CAS_PILOT "Боевой Пилот"
#define JOB_DROPSHIP_PILOT "Десантный Пилот"
#define JOB_TANK_CREW "Экипаж Танка"
#define JOB_DROPSHIP_CREW_CHIEF "Экипаж Десантного Корабля"
#define JOB_INTEL "Офицер Разведки"
#define JOB_DROPSHIP_ROLES   /datum/timelock/dropship
#define JOB_DROPSHIP_ROLES_LIST   list(JOB_DROPSHIP_CREW_CHIEF, JOB_CAS_PILOT, JOB_DROPSHIP_PILOT)
#define JOB_AUXILIARY_ROLES    /datum/timelock/auxiliary
#define JOB_AUXILIARY_ROLES_LIST   list(JOB_CAS_PILOT, JOB_DROPSHIP_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_INTEL, JOB_TANK_CREW)

#define JOB_POLICE "Военная Полиция"
#define JOB_WARDEN "Военный Смотритель"
#define JOB_CHIEF_POLICE "Шеф Военной Полиции"
#define JOB_POLICE_ROLES /datum/timelock/mp
#define JOB_POLICE_ROLES_LIST    list(JOB_POLICE, JOB_WARDEN, JOB_CHIEF_POLICE, JOB_CO)

#define JOB_SEA "Старший Инструктор"

#define JOB_CHIEF_ENGINEER "Старший Инженер"
#define JOB_MAINT_TECH "Техник Обслуживания"
#define JOB_ORDNANCE_TECH "Оружейный Техник"
#define JOB_ENGINEER_ROLES   /datum/timelock/engineer
#define JOB_ENGINEER_ROLES_LIST  list(JOB_SQUAD_ENGI, JOB_MAINT_TECH, JOB_ORDNANCE_TECH, JOB_CHIEF_ENGINEER)

#define JOB_CHIEF_REQUISITION "Квартирмейстер"	// Можно "Индентант", но квартирмейстер у нас тоже используется
#define JOB_CARGO_TECH "Грузовой Техник"
#define JOB_REQUISITION_ROLES    /datum/timelock/requisition
#define JOB_REQUISITION_ROLES_LIST   list(JOB_CHIEF_REQUISITION, JOB_CARGO_TECH)

#define JOB_MARINE_RAIDER "Морпех Рейдер"
#define JOB_MARINE_RAIDER_SL "Морпех Рейдер Командир"
#define JOB_MARINE_RAIDER_CMD "Морпех Рейдер Командир Взвода"
#define JOB_MARINE_RAIDER_ROLES_LIST list(JOB_MARINE_RAIDER, JOB_MARINE_RAIDER_SL, JOB_MARINE_RAIDER_CMD)

#define JOB_HUMAN_ROLES  /datum/timelock/human

#define JOB_XENO_ROLES   /datum/timelock/xeno
#define JOB_DRONE_ROLES /datum/timelock/drone
#define JOB_T3_ROLES /datum/timelock/tier3

#define JOB_STOWAWAY "Безбилетник"

#define JOB_MARINE "ККМП Морпех" //generic marine
#define JOB_COLONEL "ККМП Полковник"
#define JOB_USCM_OBSV "ККМП Наблюдатель"
#define JOB_GENERAL "ККМП Генерал"
#define JOB_ACMC "Помощник коменданта Корпуса Морской Пехоты"
#define JOB_CMC "Комендант Корпуса Морской Пехота"
#define JOB_PLT_MED "Санитар Взвода"
#define JOB_PLT_SL "Командир Взвода"
#define JOB_SQUAD_TECH "Техник Поддержки Разведки"

// Used to add a timelock to a job. Will be passed onto derivatives
#define AddTimelock(Path, timelockList) \
##Path/setup_requirements(list/L){\
	L += timelockList;\
	. = ..(L);\
}

// Used to add a timelock to a job. Will be passed onto derivates. Will not include the parent's timelocks.
#define OverrideTimelock(Path, timelockList) \
##Path/setup_requirements(list/L){\
	L = timelockList;\
	. = ..(L);\
}

//-------------WO roles---------------

#define JOB_WO_CO "Полевой Командующий"
#define JOB_WO_XO "Лейтенант Командующий"
#define JOB_WO_CHIEF_POLICE "Командир Почетного Караула"
#define JOB_WO_SO "Ветеран Почетного Караула"
#define JOB_WO_CREWMAN "Оружейный Специалист Почетного Караула"
#define JOB_WO_POLICE "Почетный Караул"

#define JOB_WO_PILOT "Минометный Расчет"

#define JOB_WO_CHIEF_ENGINEER "Начальник Бункера"
#define JOB_WO_ORDNANCE_TECH "Техник Бункера"

#define JOB_WO_CHIEF_REQUISITION "Интендант Бункера"
#define JOB_WO_REQUISITION "Снабженец Бункера"

#define JOB_WO_CMO "Главный Хирург"
#define JOB_WO_DOCTOR "Полевой Врач"
#define JOB_WO_RESEARCHER "Химик"

#define JOB_WO_CORPORATE_LIAISON "Военный Репортер"
#define JOB_WO_SYNTH "Синтетик Поддержки"

#define JOB_WO_SQUAD_MARINE "Стрелок Пыльных Рейдеров"
#define JOB_WO_SQUAD_MEDIC "Полевой Санитар Пыльных Рейдеров"
#define JOB_WO_SQUAD_ENGINEER "Полевой Техник Пыльных Рейдеров"
#define JOB_WO_SQUAD_SMARTGUNNER "Смартганнер Пыльных Рейдеров"
#define JOB_WO_SQUAD_SPECIALIST "Оружейный Специалист Пыльных Рейдеров"
#define JOB_WO_SQUAD_LEADER "Командир Отряда Полевых Рейдеров"

//------------------------------------

//-------- PMC --------//
#define JOB_PMC_STANDARD "ЧВК Оператор"
#define JOB_PMC_ENGINEER "ЧВК Техник Корпорации"
#define JOB_PMC_MEDIC "ЧВК Медик Корпорации"
#define JOB_PMC_DOCTOR "ЧВК Хирург-травматолог"
#define JOB_PMC_INVESTIGATOR "ЧВК Медицинский Следователь"
#define JOB_PMC_DETAINER "ЧВК Безопасник"
#define JOB_PMC_GUNNER "ЧВК Оружейный Специалист Поддержки" //Renamed from Specialist to Support Specialist as it only has SG skills.
#define JOB_PMC_SNIPER "ЧВК Оружейник Специалист" //Renamed from Sharpshooter to specialist as it uses specialist skills.
#define JOB_PMC_CREWMAN "ЧВК Экипаж"
#define JOB_PMC_XENO_HANDLER "ЧВК Ксено-Исследователь"
#define JOB_PMC_LEADER "ЧВК Командир"
#define JOB_PMC_LEAD_INVEST "ЧВК Ведущий Следователь"
#define JOB_PMC_DIRECTOR "ЧВК Директор Объекта"
#define JOB_PMC_SYNTH "ЧВК Синтетик Поддержки"

#define ROLES_WY_PMC list(JOB_PMC_LEADER, JOB_PMC_SNIPER, JOB_PMC_GUNNER, JOB_PMC_ENGINEER, JOB_PMC_MEDIC, JOB_PMC_STANDARD)
#define ROLES_WY_PMC_AUX list(JOB_PMC_SYNTH, JOB_PMC_CREWMAN, JOB_PMC_XENO_HANDLER, JOB_PMC_DOCTOR)
#define ROLES_WY_PMC_INSPEC list(JOB_PMC_LEAD_INVEST, JOB_PMC_INVESTIGATOR, JOB_PMC_DETAINER)
#define ROLES_WY_PMC_ALL ROLES_WY_PMC + ROLES_WY_PMC_AUX + ROLES_WY_PMC_INSPEC

//-------- WY --------//

#define JOB_TRAINEE "Стажер Корпорации"
#define JOB_JUNIOR_EXECUTIVE "Младший Исполнитель Корпорации"
#define JOB_EXECUTIVE "Исполнитель Корпорации"
#define JOB_SENIOR_EXECUTIVE "Старший Исполнитель Корпорации"
#define JOB_EXECUTIVE_SPECIALIST "Специалист-Исполнитель Корпорации"
#define JOB_EXECUTIVE_SUPERVISOR "Исполнитель-Наблюдатель Корпорации"
#define JOB_ASSISTANT_MANAGER "Помощник Управляющего Корпорации"
#define JOB_DIVISION_MANAGER "Управляющий Дивизией Корпорации"
#define JOB_CHIEF_EXECUTIVE "Руководитель Корпорации"
#define JOB_DIRECTOR "В-Ю Директор"

#define ROLES_WY_CORPORATE list(JOB_EXECUTIVE_SUPERVISOR, JOB_EXECUTIVE_SPECIALIST, JOB_SENIOR_EXECUTIVE, JOB_EXECUTIVE, JOB_JUNIOR_EXECUTIVE, JOB_TRAINEE)
#define ROLES_WY_LEADERSHIP list(JOB_DIRECTOR, JOB_PMC_DIRECTOR, JOB_CHIEF_EXECUTIVE, JOB_DIVISION_MANAGER, JOB_ASSISTANT_MANAGER)

#define JOB_CORPORATE_ROLES /datum/timelock/corporate
#define JOB_CORPORATE_ROLES_LIST list(JOB_CORPORATE_LIAISON, JOB_WO_CORPORATE_LIAISON, JOB_DIRECTOR, JOB_PMC_DIRECTOR, JOB_CHIEF_EXECUTIVE, JOB_DIVISION_MANAGER, JOB_ASSISTANT_MANAGER, JOB_EXECUTIVE_SUPERVISOR, JOB_EXECUTIVE_SPECIALIST, JOB_SENIOR_EXECUTIVE, JOB_EXECUTIVE, JOB_JUNIOR_EXECUTIVE, JOB_TRAINEE)

//-------- WY Goons --------//
#define JOB_WY_GOON "ВЮ Безопасник Корпорации"
#define JOB_WY_GOON_TECH "ВЮ Технический Безопасник Корпорации"
#define JOB_WY_GOON_LEAD "ВЮ Шеф-Безопасник Корпорации"
#define JOB_WY_GOON_RESEARCHER "ВЮ Исследовательский Консультант"

#define ROLES_WY_GOONS list(JOB_WY_GOON_LEAD, JOB_WY_GOON_TECH, JOB_WY_GOON, JOB_WY_GOON_RESEARCHER)

//---- Contractors ----//
#define JOB_CONTRACTOR "ВЭИЧВК Наемник"
#define JOB_CONTRACTOR_ST "ВЭИЧВК Наемник"
#define JOB_CONTRACTOR_MEDIC "ВЭИМС Медик-Специалист"
#define JOB_CONTRACTOR_ENGI "ВЭИЧВК Инженер-Специалист"
#define JOB_CONTRACTOR_MG "ВЭИЧВК Стрелок"
#define JOB_CONTRACTOR_TL "ВЭИЧВК Командир"
#define JOB_CONTRACTOR_SYN "ВЭИЧВК Синтетик Поддержки"
#define JOB_CONTRACTOR_COV "ВЭИОФ Наемник"
#define JOB_CONTRACTOR_COVST "ВЭИОФ Наемник"
#define JOB_CONTRACTOR_COVMED "ВЭИМС Медик-Специалист"
#define JOB_CONTRACTOR_COVENG "ВЭИОФ Инженер-Специалист"
#define JOB_CONTRACTOR_COVMG "ВЭИОФ Стрелок"
#define JOB_CONTRACTOR_COVTL "ВЭИОФ Team Leader"
#define JOB_CONTRACTOR_COVSYN "ВЭИОФ Синтетик Поддержки"

#define CONTRACTOR_JOB_LIST list(JOB_CONTRACTOR, JOB_CONTRACTOR_ST, JOB_CONTRACTOR_MEDIC, JOB_CONTRACTOR_ENGI, JOB_CONTRACTOR_MG, JOB_CONTRACTOR_TL, JOB_CONTRACTOR_COV, JOB_CONTRACTOR_COVST, JOB_CONTRACTOR_COVMED, JOB_CONTRACTOR_COVENG, JOB_CONTRACTOR_COVTL)

//-------- CMB --------//
#define JOB_CMB "КМБ Оперумолномоченный"
#define JOB_CMB_TL "КМБ Маршал"
#define JOB_CMB_SYN "КМБ Синтетик Расследования"
#define JOB_CMB_ICC "Представитель Корпорации по Комиссии Межзвездной Торговли"
#define JOB_CMB_OBS "Межзвездный Наблюдатель Прав Человека"
#define JOB_CMB_RIOT "КМБ Офицер-Блюститель Порядка"
#define JOB_CMB_MED "КМБ Медицинский Техник"
#define JOB_CMB_ENG "КМБ Техник Прорыва"
#define JOB_CMB_SWAT "КМБ Спецназ"
#define JOB_CMB_RSYN "КМБ Синтетик-Блюститель Порядка"

#define CMB_GRUNT_LIST list(JOB_CMB, JOB_CMB_TL)
#define CMB_RIOT_LIST list(JOB_CMB_TL, JOB_CMB_RIOT, JOB_CMB_MED, JOB_CMB_ENG, JOB_CMB_SWAT)

//-------- NSPA --------//
#define JOB_NSPA_CST "ПКНС Констебль"
#define JOB_NSPA_SC "ПКНС Старший Констебль"
#define JOB_NSPA_SGT "ПКНС Сержант"
#define JOB_NSPA_INSP "ПКНС Инспектор"
#define JOB_NSPA_CINSP "ПКНС Главный Инспектор"
#define JOB_NSPA_CMD "ПКНС Коммандор"
#define JOB_NSPA_DCO "ПКНС Заместитель Комиссара"
#define JOB_NSPA_COM "ПКНС Комиссар"

#define NSPA_GRUNT_LIST list(JOB_NSPA_CST, JOB_NSPA_SC, JOB_NSPA_SGT)

//-------- FORECON --------//

#define JOB_FORECON_CO "Коммандор Разведки"
#define JOB_FORECON_SL "Командир Отряда Разведки"
#define JOB_FORECON_SYN "Синтетик Разведки"
#define JOB_FORECON_SNIPER "Снайпер Разведки"
#define JOB_FORECON_MARKSMAN "Старший Стрелок Разведки"
#define JOB_FORECON_SUPPORT "Техник Поддержки Разведки"
#define JOB_FORECON_RIFLEMAN "Стрелок Разведки"
#define JOB_FORECON_SMARTGUNNER "Смартганнер Разведки"

//-------- UPP --------//
#define JOB_UPP	"СПН Рядовой"
#define JOB_UPP_CONSCRIPT "СПН Призывник"
#define JOB_UPP_ENGI "СПН Инженер"
#define JOB_UPP_MEDIC "СПН Санитар"
#define JOB_UPP_SPECIALIST "СПН Сержант"
#define JOB_UPP_LEADER "СПН Старший Сержант"
#define JOB_UPP_POLICE "СПН Полиция"
#define JOB_UPP_LT_OFFICER "СПН Младший Лейтенант"
#define JOB_UPP_SUPPLY "СПН Техник Снабжения"
#define JOB_UPP_LT_DOKTOR "СПН Военный Врач"
#define JOB_UPP_PILOT "СПН Пилот"
#define JOB_UPP_SRLT_OFFICER "СПН Старший Лейтенант"
#define JOB_UPP_KPT_OFFICER "СПН Капитан"
#define JOB_UPP_CO_OFFICER "СПН Командир"
#define JOB_UPP_MAY_OFFICER "СПН Майор"
#define JOB_UPP_LTKOL_OFFICER "СПН Подполковник"
#define JOB_UPP_KOL_OFFICER "СПН Полковник"
#define JOB_UPP_BRIG_GENERAL "СПН Генерал-Майор"
#define JOB_UPP_MAY_GENERAL "СПН Генерал-Лейтенант"
#define JOB_UPP_LT_GENERAL "СПН Генерал-Полковник"
#define JOB_UPP_GENERAL "СПН Генерал Армии"
#define SQUAD_UPP_1 "Акула"
#define SQUAD_UPP_2 "Бизон"
#define SQUAD_UPP_3 "Чайка"
#define SQUAD_UPP_4 "Дельфик"
#define SQUAD_UPP_5 "СПНКом"

#define JOB_UPP_COMBAT_SYNTH "СПН Боевой Синтетик"
#define JOB_UPP_SUPPORT_SYNTH "СПН Синтетик Поддержки"
#define JOB_UPP_JOE "Автоматон Серёга"

#define UPP_JOB_LIST list(JOB_UPP, JOB_UPP_ENGI, JOB_UPP_MEDIC, JOB_UPP_SPECIALIST, JOB_UPP_LEADER, JOB_UPP_POLICE, JOB_UPP_LT_OFFICER, JOB_UPP_LT_DOKTOR, JOB_UPP_PILOT, JOB_UPP_SUPPLY, JOB_UPP_SRLT_OFFICER, JOB_UPP_KPT_OFFICER, JOB_UPP_CO_OFFICER, JOB_UPP_SUPPORT_SYNTH, JOB_UPP_JOE, JOB_UPP_COMMISSAR)
#define UPP_JOB_GRUNT_LIST list(JOB_UPP, JOB_UPP_ENGI, JOB_UPP_MEDIC, JOB_UPP_SPECIALIST, JOB_UPP_LEADER, JOB_UPP_POLICE, JOB_UPP_CREWMAN)

#define JOB_UPP_COMMANDO "СПН Младший Коммандос"
#define JOB_UPP_COMMANDO_MEDIC "СПН Коммандос"
#define JOB_UPP_COMMANDO_LEADER "СПН Старший Коммандос"

#define UPP_COMMANDO_JOB_LIST list(JOB_UPP_COMMANDO, JOB_UPP_COMMANDO_MEDIC, JOB_UPP_COMMANDO_LEADER)

#define JOB_UPP_REPRESENTATIVE "СПН Представитель"

#define JOB_UPP_CREWMAN "СПН Экипаж Танка"

#define JOB_UPP_COMMISSAR "СПН Политрук"

//-------- CLF --------//
#define JOB_CLF "КОФ Бугай"	// КОФ - Колониальный Освободительный Фронт
#define JOB_CLF_ENGI "КОФ Полевой Техник"
#define JOB_CLF_MEDIC "КОФ Полевой Медик"
#define JOB_CLF_SPECIALIST "КОФ Полевой Специалист"
#define JOB_CLF_LEADER "КОФ Лидер Ячейки"
#define JOB_CLF_COMMANDER "КОФ Командир Ячейки"
#define JOB_CLF_SYNTH "КОФ Многозадачный Синтетик"

#define CLF_JOB_LIST list(JOB_CLF, JOB_CLF_ENGI, JOB_CLF_MEDIC, JOB_CLF_SPECIALIST, JOB_CLF_LEADER, JOB_CLF_COMMANDER, JOB_CLF_SYNTH)

//-------- TWE --------//
#define JOB_TWE_REPRESENTATIVE "ИТМ Представитель"

//RMC	// Royal Marine Command - Королевский Морпех Командования
#define JOB_TWE_RMC_RIFLEMAN "КМК Стрелок"
#define JOB_TWE_RMC_MARKSMAN "КМК Старший Стрелок"
#define JOB_TWE_RMC_SMARTGUNNER "КМК Смартганнер"
#define JOB_TWE_RMC_BREACHER "КМК Прорывник"
#define JOB_TWE_RMC_MEDIC "КМК Санитар"
#define JOB_TWE_RMC_TEAMLEADER "КМК Командир"
#define JOB_TWE_RMC_LIEUTENANT "КМК Лейтенант"
#define JOB_TWE_RMC_CAPTAIN "КМК Капитан"
#define JOB_TWE_RMC_MAJOR "КМК Майор"
#define JOB_TWE_RMC_COMMANDER "КМК Коммандор"

#define TWE_COMMANDO_JOB_LIST list(JOB_TWE_RMC_RIFLEMAN, JOB_TWE_RMC_BREACHER, JOB_TWE_RMC_MEDIC, JOB_TWE_RMC_SMARTGUNNER,JOB_TWE_RMC_MARKSMAN ,JOB_TWE_RMC_TEAMLEADER, JOB_TWE_RMC_LIEUTENANT, JOB_TWE_RMC_CAPTAIN, JOB_TWE_RMC_MAJOR, JOB_TWE_RMC_COMMANDER)

#define JOB_TWE_SEAMAN "ИТМ Матрос"
#define JOB_TWE_LSEAMAN "ИТМ Мичман"
#define JOB_TWE_SO "ИТМ Капитан 3-го ранга"
#define JOB_TWE_WO "ИТМ Капитан 2-го ранга"
#define JOB_TWE_CPT "ИТМ Капитан 1-го ранга"
#define JOB_TWE_ADM "ИТМ Адмирал"
#define JOB_TWE_GADM "ИТМ Адмирал Флота"
#define JOB_TWE_ER "ИТМ Император"

#define TWE_OFFICER_JOB_LIST list(JOB_TWE_SEAMAN, JOB_TWE_LSEAMAN, JOB_TWE_SO, JOB_TWE_WO, JOB_TWE_CPT, JOB_TWE_ADM, JOB_TWE_GADM, JOB_TWE_ER)

//-------- PROVOST --------//
#define JOB_PROVOST_ENFORCER "Проректор-Исполнитель"
#define JOB_PROVOST_TML "Проректор-Командования"
#define JOB_PROVOST_ADVISOR "Проректор-Советник"
#define JOB_PROVOST_INSPECTOR "Проректор-Инспектор"
#define JOB_PROVOST_CINSPECTOR "Ректор-Инспектор"
#define JOB_PROVOST_UNDERCOVER "Проректор-Инспектор Прикрытия"

#define JOB_PROVOST_DMARSHAL "Проректор-Маршал"
#define JOB_PROVOST_MARSHAL "Ректор-Маршал"
#define JOB_PROVOST_SMARSHAL "Проректор-Маршал Сектора"
#define JOB_PROVOST_CMARSHAL "Ректор-Маршал Сектора"

#define PROVOST_JOB_LIST list(JOB_PROVOST_ENFORCER, JOB_PROVOST_TML, JOB_PROVOST_ADVISOR, JOB_PROVOST_INSPECTOR, JOB_PROVOST_CINSPECTOR, JOB_PROVOST_DMARSHAL, JOB_PROVOST_MARSHAL, JOB_PROVOST_SMARSHAL, JOB_PROVOST_CMARSHAL)

#define JOB_RIOT "Блюститель Порядка"
#define JOB_RIOT_CHIEF "Шеф Блюстителей Порядка"

#define RIOT_JOB_LIST list(JOB_RIOT, JOB_RIOT_CHIEF)
//-------- CIA --------//
#define JOB_CIA "Аналитик Разведки"
#define JOB_CIA_LIAISON "Офицер Связи Аналитик"

#define TIS_JOB_LIST list(JOB_TIS_SA, JOB_TIS_IO)
//-------- DUTCH'S DOZEN --------//
#define JOB_DUTCH_ARNOLD "Дюжина Датча - Датч"
#define JOB_DUTCH_RIFLEMAN "Дюжина Датча - Стрелок"
#define JOB_DUTCH_MINIGUNNER "Дюжина Датча - Миниганнер"
#define JOB_DUTCH_FLAMETHROWER "Дюжина Датча - Огнеметчик"
#define JOB_DUTCH_MEDIC "Дюжина Датча - Медик"

#define DUTCH_JOB_LIST list(JOB_DUTCH_ARNOLD, JOB_DUTCH_RIFLEMAN, JOB_DUTCH_MINIGUNNER, JOB_DUTCH_FLAMETHROWER, JOB_DUTCH_MEDIC)

//---------- RESPONDERS ----------//
/// This root job should never appear ingame, it's used to select the character slot.
#define JOB_FAX_RESPONDER "Секретарь на Факсе"
#define JOB_FAX_RESPONDER_USCM_HC "ККМП-ВК Офицер Связи"
#define JOB_FAX_RESPONDER_USCM_PVST "Проректор-Офицер Связи"
#define JOB_FAX_RESPONDER_WY "ВЮ Связной Исполнитель"
#define JOB_FAX_RESPONDER_UPP "СПН Офицер Связи"
#define JOB_FAX_RESPONDER_TWE "ИТМ Офицер Связи"
#define JOB_FAX_RESPONDER_CLF "КОФ Информационный Корреспондент"
#define JOB_FAX_RESPONDER_CMB "КМБ Заместитель Офицера Операций"
#define JOB_FAX_RESPONDER_PRESS "Оператор Свободной Прессы"

#define FAX_RESPONDER_JOB_LIST list(JOB_FAX_RESPONDER_USCM_HC, JOB_FAX_RESPONDER_USCM_PVST, JOB_FAX_RESPONDER_WY, JOB_FAX_RESPONDER_UPP, JOB_FAX_RESPONDER_TWE, JOB_FAX_RESPONDER_CLF, JOB_FAX_RESPONDER_CMB, JOB_FAX_RESPONDER_PRESS)


//---------- ANTAG ----------//
#define JOB_PREDATOR "Хищник"
#define JOB_XENOMORPH    "Ксеноморф"
#define JOB_XENOMORPH_QUEEN  "Королева"

// For coloring the ranks in the statistics menu
#define JOB_PLAYTIME_TIER_0  (0 HOURS)		// SS220 EDIT
#define JOB_PLAYTIME_TIER_1  (2 HOURS)		// SS220 EDIT
#define JOB_PLAYTIME_TIER_2  (5 HOURS)		// SS220 EDIT
#define JOB_PLAYTIME_TIER_3  (14 HOURS)		// SS220 EDIT
#define JOB_PLAYTIME_TIER_4  (32 HOURS)		// SS220 EDIT
#define JOB_PLAYTIME_TIER_5  (70 HOURS)		// SS220 EDIT
#define JOB_PLAYTIME_TIER_6  (150 HOURS)	// SS220 EDIT
#define JOB_PLAYTIME_TIER_7  (220 HOURS)	// SS220 EDIT
#define JOB_PLAYTIME_TIER_8  (440 HOURS)	// SS220 EDIT
#define JOB_PLAYTIME_TIER_9  (700 HOURS)	// SS220 EDIT
#define JOB_PLAYTIME_TIER_10 (1000 HOURS)	// SS220 EDIT

#define XENO_NO_AGE  -1
#define XENO_YOUNG 0
#define XENO_NORMAL 1
#define XENO_MATURE 2
#define XENO_ELDER 3
#define XENO_ANCIENT 4
#define XENO_PRIME 5

/// For monthly time tracking
#define JOB_OBSERVER "Наблюдатель"
#define TIMELOCK_JOB(role_id, hours) new/datum/timelock(role_id, hours, role_id)

//For displaying groups of jobs. Used by new player's latejoin menu and by crew manifest.
#define FLAG_SHOW_CIC 1
#define FLAG_SHOW_AUXIL_SUPPORT 2
#define FLAG_SHOW_MISC 4
#define FLAG_SHOW_POLICE 8
#define FLAG_SHOW_ENGINEERING 16
#define FLAG_SHOW_REQUISITION 32
#define FLAG_SHOW_MEDICAL 64
#define FLAG_SHOW_MARINES 128
#define FLAG_SHOW_ALL_JOBS FLAG_SHOW_CIC|FLAG_SHOW_AUXIL_SUPPORT|FLAG_SHOW_MISC|FLAG_SHOW_POLICE|FLAG_SHOW_ENGINEERING|FLAG_SHOW_REQUISITION|FLAG_SHOW_MEDICAL|FLAG_SHOW_MARINES

///For denying certain traits being applied to people. ie. bad leg
///'Grunt' lists are for people who wouldn't logically get the bad leg trait, ie. UPP marine counterparts.
#define JOB_ERT_GRUNT_LIST list(DUTCH_JOB_LIST, RIOT_JOB_LIST, PROVOST_JOB_LIST, CMB_GRUNT_LIST, CLF_JOB_LIST, UPP_JOB_GRUNT_LIST, UPP_COMMANDO_JOB_LIST, CONTRACTOR_JOB_LIST, ROLES_WY_GOONS, ROLES_WY_PMC_ALL, CMB_RIOT_LIST)
