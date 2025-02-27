/* eslint-disable func-style */
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

const JOBS_RU = {
  // MARK: Squads
  Alpha: 'Альфа',
  Bravo: 'Браво',
  Charlie: 'Чарли',
  Delta: 'Дельта',
  Echo: 'Эхо',
  Foxtrot: 'Фокстрот',
  Intel: 'Интел',
  SOF: 'SOF',
  CBRN: 'CBRN',
  FORECON: 'РАЗВЕДКА',
  'Solar Devils': 'Дьяволы Солнца',
  Provost: 'Проректор',
  Akula: 'Акула',
  Bizon: 'Бизон',
  Chayka: 'Чайка',
  Delfin: 'Дельфин',
  UPPKdo: 'СПНКом',
  Corporate: 'Корпораты',
  Other: 'Другое',
  // MARK: Factions
  Marines: 'Морпехи',
  Humans: 'Люди',
  Xenomorphs: 'Ксеноморфы',
  Survivors: 'Выжившие',
  'ERT Members': 'Члены ОБР',
  Synthetics: 'Синтетики',
  'Union of Progressive Peoples': 'Союз Прогрессивных Народов',
  'Colonial Liberation Front': 'Колониальный Освободительный Фронт',
  'Weyland Yutani': 'Вейланд Ютани',
  'Royal Marines Commando': 'Королевские Морпехи-Коммандос',
  Freelancers: 'Freelancers',
  Mercenaries: 'Mercenaries',
  'Military Contractors': 'Military Contractors',
  'Hunted Personnel': 'Hunted Personnel',
  'Dutchs Dozen': 'Дюжина Датча',
  'Colonial Marshal Bureau': 'Colonial Marshal Bureau',
  'Fax Responders': 'Секретари на Факсе',
  Predators: 'Хищники',
  Escaped: 'Сбежавшие',
  Vehicles: 'Техника',
  Animals: 'Животные',
  Dead: 'Мёртвые',
  Ghosts: 'Призраки',
  Misc: 'Прочие',
  NPCs: 'НИПы',
  // MARK: Roles
  Rifleman: 'Стрелок',
  'Squad Leader': 'Командир Отряда',
  'Combat Technician': 'Полевой Техник',
  'Hospital Corpsman': 'Полевой Санитар',
  'Weapons Specialist': 'Оружейный Специалист',
  'Fireteam Leader': 'Командир Боевой Группы',
  Smartgunner: 'Смартганнер',
  // Survivors
  Colonist: 'Колонист',
  Passenger: 'Пассажир',
  Survivor: 'Выживший',
  'Synth Survivor': 'Выживший Синтетик',
  'CO Survivor': 'Выживший КО',
  'Any Survivor': 'Любой Выживший',
  'Civilian Survivor': 'Выживший Гражданский',
  'Security Survivor': 'Выживший Безопасник',
  'Scientist Survivor': 'Выживший Ученый',
  'Medical Survivor': 'Выживший Медик',
  'Engineering Survivor': 'Выживший Инженер',
  'Corporate Survivor': 'Выживший Корпорат',
  'Hostile Survivor': 'Враждебный Выживший',

  // Medical roles
  'Chief Medical Officer': 'Главрач',
  Doctor: 'Доктор',
  Surgeon: 'Хирург',
  'Field Doctor': 'Полевой Врач',
  Nurse: 'Медработник',
  Researcher: 'Исследователь',

  // Civil roles
  'Corporate Liaison': 'Связной Корпорации',
  'Combat Correspondent': 'Полевой Корреспондент',
  'Civilian Correspondent': 'Гражданский Корреспондент',
  'Military Correspondent': 'Военный Корреспондент',

  // Synthetic roles
  Synthetic: 'Синтетик',
  'Synthetic K9': 'Синтетик K9',
  'Working Joe': 'Рабочий Джо',
  'Hazmat Joe': 'Хазмат Джо',

  // Command roles
  'Commanding Officer': 'Коммандующий Офицер',
  'Executive Officer': 'Исполнительный Офицер',
  'Staff Officer': 'Штаб-Офицер',
  'Auxiliary Support Officer': 'Офицер Поддержки',

  // Dropship roles
  'Gunship Pilot': 'Боевой Пилот',
  'Dropship Pilot': 'Десантный Пилот',
  'Tank Crew': 'Экипаж Танка',
  'Dropship Crew Chief': 'Экипаж Десантного Корабля',
  'Intelligence Officer': 'Офицер Разведки',

  // Police roles
  'Military Police': 'Военная Полиция',
  'Military Warden': 'Военный Смотритель',
  'Chief MP': 'Шеф Военной Полиции',

  // Engineering roles
  'Chief Engineer': 'Старший Инженер',
  'Maintenance Technician': 'Техник Обслуживания',
  'Ordnance Technician': 'Оружейный Техник',

  // Requisition roles
  Quartermaster: 'Квартирмейстер',
  'Cargo Technician': 'Грузовой Техник',

  // Marine Raider roles
  'Marine Raider': 'Морпех Рейдер',
  'Marine Raider Team Lead': 'Морпех Рейдер Командир',
  'Marine Raider Platoon Lead': 'Морпех Рейдер Командир Взвода',

  // Other roles
  Stowaway: 'Безбилетник',
  'USCM Marine': 'ККМП Морпех',
  'USCM Colonel': 'ККМП Полковник',
  'USCM Observer': 'ККМП Наблюдатель',
  'USCM General': 'ККМП Генерал',
  'Assistant Commandant of the Marine Corps':
    'Помощник коменданта Корпуса Морской Пехоты',
  'Commandant of the Marine Corps': 'Комендант Корпуса Морской Пехоты',
  'Platoon Corpsman': 'Санитар Взвода',
  'Platoon Squad Leader': 'Командир Взвода',
  'Reconnaissance Support Technician': 'Техник Поддержки Разведки',

  // WO roles
  'Ground Commander': 'Полевой Командующий',
  'Lieutenant Commander': 'Лейтенант Командующий',
  'Honor Guard Squad Leader': 'Командир Почетного Караула',
  'Veteran Honor Guard': 'Ветеран Почетного Караула',
  'Honor Guard Weapons Specialist': 'Оружейный Специалист Почетного Караула',
  'Honor Guard': 'Почетный Караул',
  'Mortar Crew': 'Минометный Расчет',
  'Bunker Crew Master': 'Начальник Бункера',
  'Bunker Crew': 'Техник Бункера',
  'Bunker Quartermaster': 'Интендант Бункера',
  'Bunker Crew Logistics': 'Снабженец Бункера',
  'Head Surgeon': 'Главный Хирург',
  Chemist: 'Химик',
  'Combat Reporter': 'Военный Репортер',
  'Support Synthetic': 'Синтетик Поддержки',
  'Dust Raider Squad Rifleman': 'Стрелок Пыльных Рейдеров',
  'Dust Raider Squad Hospital Corpsman': 'Полевой Санитар Пыльных Рейдеров',
  'Dust Raider Squad Combat Technician': 'Полевой Техник Пыльных Рейдеров',
  'Dust Raider Squad Smartgunner': 'Смартганнер Пыльных Рейдеров',
  'Dust Raider Squad Weapons Specialist':
    'Оружейный Специалист Пыльных Рейдеров',
  'Dust Raider Squad Leader': 'Командир Отряда Полевых Рейдеров',

  // PMC roles
  'PMC Operator': 'ЧВК Оператор',
  'PMC Corporate Technician': 'ЧВК Техник Корпорации',
  'PMC Corporate Medic': 'ЧВК Медик Корпорации',
  'PMC Trauma Surgeon': 'ЧВК Хирург-травматолог',
  'PMC Medical Investigator': 'ЧВК Медицинский Следователь',
  'PMC Security Enforcer': 'ЧВК Безопасник',
  'PMC Support Weapons Specialist': 'ЧВК Оружейный Специалист Поддержки',
  'PMC Weapons Specialist': 'ЧВК Оружейник Специалист',
  'PMC Vehicle Crewman': 'ЧВК Экипаж',
  'PMC Xeno Handler': 'ЧВК Ксено-Исследователь',
  'PMC Leader': 'ЧВК Командир',
  'PMC Lead Investigator': 'ЧВК Ведущий Следователь',
  'PMC Site Director': 'ЧВК Директор Объекта',
  'PMC Support Synthetic': 'ЧВК Синтетик Поддержки',

  // WY roles
  'Corporate Trainee': 'Стажер Корпорации',
  'Corporate Junior Executive': 'Младший Исполнитель Корпорации',
  'Corporate Executive': 'Исполнитель Корпорации',
  'Corporate Senior Executive': 'Старший Исполнитель Корпорации',
  'Corporate Executive Specialist': 'Специалист-Исполнитель Корпорации',
  'Corporate Executive Supervisor': 'Исполнитель-Наблюдатель Корпорации',
  'Corporate Assistant Manager': 'Помощник Управляющего Корпорации',
  'Corporate Division Manager': 'Управляющий Дивизией Корпорации',
  'Corporate Chief Executive': 'Руководитель Корпорации',
  'WY Deputy Director': 'В-Ю Заместитель Директора',
  'WY Director': 'В-Ю Директор',

  // WY Goons roles
  'WY Corporate Security': 'ВЮ Безопасник Корпорации',
  'WY Corporate Security Medic': 'ВЮ Медик Безопасник Корпорации',
  'WY Corporate Security Technician': 'ВЮ Технический Безопасник Корпорации',
  'WY Corporate Security Lead': 'ВЮ Шеф-Безопасник Корпорации',
  'WY Research Consultant': 'ВЮ Исследовательский Консультант',

  // Contractors roles
  'VAIPO Mercenary': 'ВЭИЧВК Контрактник',
  'VAIMS Medical Specialist': 'ВЭИМС Медик-Специалист',
  'VAIPO Engineering Specialist': 'ВЭИЧВК Инженер-Специалист',
  'VAIPO Automatic Rifleman': 'ВЭИЧВК Стрелок',
  'VAIPO Team Leader': 'ВЭИЧВК Командир',
  'VAIPO Support Synthetic': 'ВЭИЧВК Синтетик Поддержки',
  'VAISO Mercenary': 'ВЭИОФ Контрактник',
  // 'VAIMS Medical Specialist': 'ВЭИМС Медик-Специалист',
  'VAISO Engineering Specialist': 'ВЭИОФ Инженер-Специалист',
  'VAISO Automatic Rifleman': 'ВЭИОФ Стрелок',
  'VAISO Team Leader': 'ВЭИОФ Team Leader',
  'VAISO Support Synthetic': 'ВЭИОФ Синтетик Поддержки',

  // CMB roles
  'CMB Deputy': 'КМБ Оперумолномоченный',
  'CMB Marshal': 'КМБ Маршал',
  'CMB Investigative Synthetic': 'КМБ Синтетик Расследования',
  'Interstellar Commerce Commission Corporate Liaison':
    'Представитель Корпорации по Комиссии Межзвездной Торговли',
  'Interstellar Human Rights Observer': 'Межзвездный Наблюдатель Прав Человека',
  'CMB Riot Control Officer': 'КМБ Офицер-Блюститель Порядка',
  'CMB Medical Technician': 'КМБ Медицинский Техник',
  'CMB Breaching Technician': 'КМБ Техник Прорыва',
  'CMB SWAT Specialist': 'КМБ Спецназ',
  'CMB Riot Control Synthetic': 'КМБ Синтетик-Блюститель Порядка',

  // NSPA roles
  'NSPA Constable': 'ПКНС Констебль',
  'NSPA Senior Constable': 'ПКНС Старший Констебль',
  'NSPA Sergeant': 'ПКНС Сержант',
  'NSPA Inspector': 'ПКНС Инспектор',
  'NSPA Chief Inspector': 'ПКНС Главный Инспектор',
  'NSPA Commander': 'ПКНС Коммандор',
  'NSPA Deputy Commissioner': 'ПКНС Заместитель Комиссара',
  'NSPA Commissioner': 'ПКНС Комиссар',

  // FORECON roles
  'Reconnaissance Commander': 'Коммандор Разведки',
  'Reconnaissance Squad Leader': 'Командир Отряда Разведки',
  'Reconnaissance Synthetic': 'Синтетик Разведки',
  'Reconnaissance Sniper': 'Снайпер Разведки',
  'Reconnaissance Marksman': 'Старший Стрелок Разведки',
  'Reconnaissance Rifleman': 'Стрелок Разведки',
  'Reconnaissance Smartgunner': 'Смартганнер Разведки',

  // UPP roles
  'UPP Ryadovoy': 'СПН Рядовой',
  'UPP Conscript': 'СПН Призывник',
  'UPP MSzht Engineer': 'СПН Инженер',
  'UPP MSzht Medic': 'СПН Санитар',
  'UPP Serzhant': 'СПН Сержант',
  'UPP Starshiy Serzhant': 'СПН Старший Сержант',
  'UPP Politsiya': 'СПН Полиция',
  'UPP Mladshiy Leytenant': 'СПН Младший Лейтенант',
  'UPP Logistics Technician': 'СПН Техник Снабжения',
  'UPP Leytenant Doktor': 'СПН Военный Врач',
  'UPP Pilot': 'СПН Пилот',
  'UPP Starshiy Leytenant': 'СПН Старший Лейтенант',
  'UPP Kapitan': 'СПН Капитан',
  'UPP Komandir': 'СПН Командир',
  'UPP Mayjor': 'СПН Майор',
  'UPP Podpolkovnik': 'СПН Подполковник',
  'UPP Polkovnik': 'СПН Полковник',
  'UPP General Mayjor': 'СПН Генерал-Майор',
  'UPP General Leytenant': 'СПН Генерал-Лейтенант',
  'UPP General Polkovnik': 'СПН Генерал-Полковник',
  'UPP General Armii': 'СПН Генерал Армии',
  'UPP Combat Synthetic': 'СПН Боевой Синтетик',
  'UPP Support Synthetic': 'СПН Синтетик Поддержки',
  'Dzho Automaton': 'Автоматон Серёга',
  'UPP Junior Kommando': 'СПН Младший Коммандос',
  'UPP 2nd Kommando': 'СПН Коммандос',
  'UPP 1st Kommando': 'СПН Старший Коммандос',
  'UPP Representative': 'СПН Представитель',
  'UPP Tank Crewman': 'СПН Экипаж Танка',
  'UPP Political Commissar': 'СПН Политрук',

  // CLF roles
  'CLF Guerilla': 'КОФ Партизан',
  'CLF Field Technician': 'КОФ Полевой Технарь',
  'CLF Field Medic': 'КОФ Полевой Врач',
  'CLF Field Specialist': 'КОФ Полевой Специалист',
  'CLF Cell Leader': 'КОФ Лидер Ячейки',
  'CLF Cell Commander': 'КОФ Командир Ячейки',
  'CLF Multipurpose Synthetic': 'КОФ Многозадачный Синтетик',

  // TWE roles
  'TWE Representative': 'ИТМ Представитель',
  'RMC Rifleman': 'КМК Стрелок',
  'RMC Marksman': 'КМК Старший Стрелок',
  'RMC Smartgunner': 'КМК Смартганнер',
  'RMC Breacher': 'КМК Прорывник',
  'RMC Corpsman': 'КМК Санитар',
  'RMC Team Leader': 'КМК Командир',
  'RMC Lieutenant': 'КМК Лейтенант',
  'RMC Captain': 'КМК Капитан',
  'RMC Major': 'КМК Майор',
  'RMC Commander': 'КМК Коммандор',
  'TWE Seaman': 'ИТМ Матрос',
  'TWE Leading Seaman': 'ИТМ Мичман',
  'TWE Standing Officer': 'ИТМ Капитан 3-го ранга',
  'TWE Warrant Officer': 'ИТМ Капитан 2-го ранга',
  'TWE Captain': 'ИТМ Капитан 1-го ранга',
  'TWE Admiral': 'ИТМ Адмирал',
  'TWE Grand Admiral': 'ИТМ Адмирал Флота',
  'TWE Emperor': 'ИТМ Император',

  // PROVOST roles
  'Provost Enforcer': 'Проректор-Исполнитель',
  'Provost Team Leader': 'Проректор-Командования',
  'Provost Advisor': 'Проректор-Советник',
  'Provost Inspector': 'Проректор-Инспектор',
  'Provost Chief Inspector': 'Ректор-Инспектор',
  'Provost Undercover Inspector': 'Проректор-Инспектор Прикрытия',
  'Provost Deputy Marshal': 'Проректор-Маршал',
  'Provost Marshal': 'Ректор-Маршал',
  'Provost Sector Marshal': 'Проректор-Маршал Сектора',
  'Provost Chief Marshal': 'Ректор-Маршал Сектора',

  // Riot Control roles
  'Riot Control': 'Блюститель Порядка',
  'Chief Riot Control': 'Шеф Блюстителей Порядка',

  // CIA roles
  'Intelligence Analyst': 'Аналитик Разведки',
  'Intelligence Liaison Officer': 'Офицер Связи Аналитик',

  // Dutch's Dozen roles
  "Dutch's Dozen - Dutch": 'Дюжина Датча - Датч',
  "Dutch's Dozen - Rifleman": 'Дюжина Датча - Стрелок',
  "Dutch's Dozen - Minigunner": 'Дюжина Датча - Миниганнер',
  "Dutch's Dozen - Flamethrower": 'Дюжина Датча - Огнеметчик',
  "Dutch's Dozen - Medic": 'Дюжина Датча - Медик',

  // Responders roles
  'Fax Responder': 'Секретарь на Факсе',
  'USCM-HC Communications Officer': 'ККМП-ВК Офицер Связи',
  'Provost Communications Officer': 'Проректор-Офицер Связи',
  'WY Communications Executive': 'ВЮ Связной Исполнитель',
  'UPP Communications Officer': 'СПН Офицер Связи',
  'TWE Communications Officer': 'ИТМ Офицер Связи',
  'CLF Information Correspondant': 'КОФ Информационный Корреспондент',
  'CMB Deputy Operations Officer': 'КМБ Заместитель Офицера Операций',
  'Free Press Relay Operator': 'Оператор Свободной Прессы',

  // Antagonist roles
  Predator: 'Хищник',
  Xenomorph: 'Ксеноморф',
  Queen: 'Королева',

  // Observer role
  Observer: 'Наблюдатель',
};

export function JobsRu(value: string) {
  return JOBS_RU[value] || value;
}

const REVERSED_JOBS_RU = Object.entries(JOBS_RU).reduce(
  (reversed_castes, [key, value]) => {
    reversed_castes[value] = key;
    return reversed_castes;
  },
  {},
);

export function ReverseJobsRu(value: string) {
  return REVERSED_JOBS_RU[value] || value;
}
