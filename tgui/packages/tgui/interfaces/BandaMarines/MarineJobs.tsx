/* eslint-disable func-style */
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const MARINES_STATES_RU = {
  Dead: 'Мёртв',
  Conscious: 'В сознании',
  'Conscious (SSD)': 'В сознании (КРС)',
  Unconscious: 'Без сознания',
};

export const JOBS_RU = {
  // MARK: Mutiny
  MUTINY: 'МЯТЕЖНИКИ',
  LOYALIST: 'ЛОЯЛИСТЫ',
  'NON-COMBAT': 'НЕКОМБАТАНТЫ',
  // MARK: Squads
  Alpha: 'Альфа',
  Bravo: 'Браво',
  Charlie: 'Чарли',
  Delta: 'Дельта',
  Echo: 'Эхо',
  Foxtrot: 'Фокстрот',
  Intel: 'Интел',
  Command: 'Командование',
  Security: 'Охрана',
  SOF: 'ССО',
  CBRN: 'РХБЗ',
  FORECON: 'РАЗВЕДКА',
  'Solar Devils': 'Дьяволы солнца',
  Provost: 'Военной Прокуратуры',
  ProvostCategory: 'Военная Прокуратура',
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
  'Squad Leader': 'Командир отряда',
  'Combat Technician': 'Полевой техник',
  'Hospital Corpsman': 'Полевой санитар',
  'Weapons Specialist': 'Оружейный специалист',
  'Fireteam Leader': 'Командир боевой группы',
  Smartgunner: 'Смартганнер',
  // Survivors
  Colonist: 'Колонист',
  Passenger: 'Пассажир',
  Survivor: 'Выживший',
  'Synth Survivor': 'Выживший-синтетик',
  'CO Survivor': 'Выживший КО',
  'Any Survivor': 'Любой выживший',
  'Civilian Survivor': 'Выживший гражданский',
  'Security Survivor': 'Выживший охраны',
  'Scientist Survivor': 'Выживший учёный',
  'Medical Survivor': 'Выживший медик',
  'Engineering Survivor': 'Выживший инженер',
  'Corporate Survivor': 'Выживший корпорат',
  'Hostile Survivor': 'Враждебный выживший',

  // Medical roles
  'Chief Medical Officer': 'Главврач',
  Doctor: 'Врач',
  Surgeon: 'Хирург',
  'Field Doctor': 'Полевой врач',
  Nurse: 'Медработник',
  Researcher: 'Исследователь',

  // Civil roles
  'Corporate Liaison': 'Связной корпорации',
  'Combat Correspondent': 'Полевой корреспондент',
  'Civilian Correspondent': 'Гражданский корреспондент',
  'Military Correspondent': 'Военный корреспондент',

  // Synthetic roles
  'Mess Technician': 'Кок',
  Synthetic: 'Синтетик',
  'Synthetic K9': 'Синтетик K9',
  'Working Joe': 'Рабочий Джо',
  'Hazmat Joe': 'Хазмат Джо',

  // Command roles
  'Commanding Officer': 'Командующий офицер',
  'Executive Officer': 'Исполнительный офицер',
  'Staff Officer': 'Штаб-офицер',
  'Auxiliary Support Officer': 'Офицер поддержки',

  // Dropship roles
  'Gunship Pilot': 'Боевой пилот',
  'Dropship Pilot': 'Десантный пилот',
  'Tank Crew': 'Экипаж бронетехники',
  'Dropship Crew Chief': 'Экипаж десантного корабля',
  'Intelligence Officer': 'Офицер разведки',

  // Police roles
  'Military Police': 'Военная полиция',
  'Military Warden': 'Военный смотритель',
  'Chief MP': 'Начальник военной полиции',

  // SEA
  'Senior Enlisted Advisor': 'Старший инструктор',

  // Engineering roles
  'Chief Engineer': 'Главный инженер',
  'Maintenance Technician': 'Техник обслуживания',
  'Ordnance Technician': 'Оружейный техник',

  // Requisition roles
  Quartermaster: 'Квартирмейстер',
  'Cargo Technician': 'Грузовой техник',

  // Marine Raider roles
  'Marine Raider': 'Рейдер',
  'Marine Raider Team Lead': 'Комотряда-рейдер',
  'Marine Raider Platoon Lead': 'Комгруппы-рейдер',

  // Other roles
  Stowaway: 'Безбилетник',
  'USCM Marine': 'Морпех ККМП',
  'USCM Colonel': 'Полковник ККМП',
  'USCM Observer': 'Наблюдатель ККМП',
  'USCM General': 'Генерал ККМП',
  'Assistant Commandant of the Marine Corps': 'Заместитель коменданта КМП',
  'Commandant of the Marine Corps': 'Комендант КМП',
  'Platoon Corpsman': 'Санитар отряда',
  'Platoon Squad Leader': 'Командир отряда',
  'Reconnaissance Support Technician': 'Специалист по рекогносцировке',

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
  'Dust Raider Squad Leader': 'Командир Отряда Пыльных Рейдеров',

  // PMC roles
  'PMC Operator': 'ЧВК Вейланд-Ютани Оперативник',
  'PMC Corporate Technician': 'ЧВК Вейланд-Ютани Полевой Техник',
  'PMC Corporate Medic': 'ЧВК Вейланд-Ютани Полевой Медик',
  'PMC Trauma Surgeon': 'ЧВК Вейланд-Ютани Полевой Хирург',
  'PMC Medical Investigator': 'ЧВК Вейланд-Ютани Медицинский Следователь',
  'PMC Security Enforcer': 'ЧВК Вейланд-Ютани Безопасник',
  'PMC Support Weapons Specialist': 'ЧВК Вейланд-Ютани Смартганнер',
  'PMC Weapons Specialist': 'ЧВК Вейланд-Ютани Оружейный Специалист',
  'PMC Vehicle Crewman': 'ЧВК Вейланд-Ютани Экипаж',
  'PMC Xeno Handler': 'ЧВК Вейланд-Ютани Ксено-Исследователь',
  'PMC Leader': 'ЧВК Вейланд-Ютани Лидер Группы',
  'PMC Lead Investigator': 'ЧВК Вейланд-Ютани Ведущий Следователь',
  'PMC Crowd Control Specialist': 'ЧВК Вейланд-Ютани Спецназ Правопорядка',
  'PMC Site Director': 'ЧВК Вейланд-Ютани Директор Подразделения',
  'PMC Support Synthetic': 'ЧВК Вейланд-Ютани Синтетик',

  // WY Commandos roles
  'W-Y Commando': 'Вейланд-Ютани Коммандос',
  'W-Y Commando Leader': 'Вейланд-Ютани Лидер Коммандос',
  'W-Y Commando Gunner': 'Вейланд-Ютани Смартганнер Коммандос',
  'W-Y Commando Dog Catcher': 'Вейланд-Ютани Отловщик Коммандос',

  // WY roles
  'Corporate Trainee': 'Стажер Корпорации',
  'Corporate Junior Executive': 'Младший Администратор Корпорации',
  'Corporate Executive': 'Администратор Корпорации',
  'Corporate Senior Executive': 'Старший Администратор Корпорации',
  'Corporate Executive Specialist': 'Исполнительный Специалист Корпорации',
  'Corporate Executive Supervisor': 'Исполнительный Супервайзер Корпорации',
  'Corporate Assistant Manager':
    'Помощник Руководителя Подразделения Корпорации',
  'Corporate Division Manager': 'Руководитель Подразделения Корпорации',
  'Corporate Chief Executive': 'Исполнительный Директор Корпорации',
  'WY Deputy Director': 'Заместитель Директора Корпорации Вейланд-Ютани',
  'WY Director': 'Директор Корпорации Вейланд-Ютани',

  // WY Goons roles
  'WY Corporate Security': 'Оперативник Службы Безопасности Вейланд-Ютани',
  'WY Corporate Security Medic': 'Парамедик Службы Безопасности Вейланд-Ютани',
  'WY Corporate Security Technician':
    'Техник Службы Безопасности Вейланд-Ютани',
  'WY Corporate Security Lead':
    'Лидер Группы Службы Безопасности Вейланд-Ютани',
  'WY Research Consultant': 'Исследовательский Консультант Вейланд-Ютани',

  // Contractors roles
  'VAIPO Mercenary': 'ВЭИЧВК Контрактник',
  'VAIMS Medical Specialist': 'ВЭИЧМС Медицинский Специалист',
  'VAIPO Engineering Specialist': 'ВЭИЧВК Инженерный Специалист',
  'VAIPO Automatic Rifleman': 'ВЭИЧВК Пулеметчик',
  'VAIPO Team Leader': 'ВЭИЧВК Лидер Группы',
  'VAIPO Support Synthetic': 'ВЭИЧВК Синтетик Поддержки',
  'VAISO Mercenary': 'ВЭИОФ Контрактник',
  'VAISO Medical Specialist': 'ВЭИЧМС Медицинский Специалист',
  'VAISO Engineering Specialist': 'ВЭИОФ Инженерный Специалист',
  'VAISO Automatic Rifleman': 'ВЭИОФ Пулеметчик',
  'VAISO Team Leader': 'ВЭИОФ Лидер Группы',
  'VAISO Support Synthetic': 'ВЭИОФ Синтетик Поддержки',

  // CMB roles
  'CMB Deputy': 'КМБ Оперумолномоченный',
  'CMB Marshal': 'КМБ Маршал',
  'CMB Investigative Synthetic': 'КМБ Синтетик-Следователь',
  'Interstellar Commerce Commission Corporate Liaison':
    'Представитель Комиссии по Межзвездной Торговле',
  'Interstellar Human Rights Observer': 'Межзвездный Наблюдатель Прав Человека',
  'CMB Riot Control Officer': 'КМБ Силовик',
  'CMB Medical Technician': 'КМБ Медик',
  'CMB Breaching Technician': 'КМБ Специалист-Прорывник',
  'CMB SWAT Specialist': 'КМБ Спецназ',
  'CMB Riot Control Synthetic': 'КМБ Синтетик-Силовик',

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
  'UPP Politsiya': 'СПН Милиция',
  'UPP Mladshiy Leytenant': 'СПН Младший Лейтенант',
  'UPP Logistics Technician': 'СПН Техник Снабжения',
  'UPP Leytenant Doktor': 'СПН Военврач',
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
  'UPP Junior Kommando': 'СПН Боец Спецназа',
  'UPP 2nd Kommando': 'СПН Военврач Спецназа',
  'UPP 1st Kommando': 'СПН Командир Отряда Спецназа',
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
  'Provost Enforcer': 'Силовик Военной Прокуратуры',
  'Provost Team Leader': 'Командир Отряда Военной Прокуратуры',
  'Provost Advisor': 'Внештатный Советник Военной Прокуратуры',
  'Provost Inspector': 'Инспектор Военной Прокуратуры',
  'Provost Chief Inspector': 'Старший Инспектор Военной Прокуратуры',
  'Provost Undercover Inspector': 'Инспектор Под Прикрытием',
  'Provost Deputy Marshal': 'Заместитель Маршала Военной Прокуратуры',
  'Provost Marshal': 'Маршал Военной Прокуратуры',
  'Provost Sector Marshal': 'Секторальный Маршал Военной Прокуратуры',
  'Provost Chief Marshal': 'Главный Маршал Военной Прокуратуры',

  // Riot Control roles
  'Riot Control': 'Блюститель Порядка',
  'Chief Riot Control': 'Шеф Блюстителей Порядка',

  // CIA roles
  'Intelligence Analyst': 'Агент ЦРУ',
  'Intelligence Liaison Officer': 'Представитель Командования ККМП',

  // Dutch's Dozen roles
  "Dutch's Dozen - Dutch": 'Дюжина Датча - Датч',
  "Dutch's Dozen - Rifleman": 'Дюжина Датча - Стрелок',
  "Dutch's Dozen - Minigunner": 'Дюжина Датча - Миниганнер',
  "Dutch's Dozen - Flamethrower": 'Дюжина Датча - Огнеметчик',
  "Dutch's Dozen - Medic": 'Дюжина Датча - Медик',

  // Responders roles
  'Fax Responder': 'Секретарь на Факсе',
  'USCM-HC Communications Officer': 'ККМП-ВК Офицер Связи',
  'Provost Communications Officer': 'Офицер Связи Военной Прокуратуры',
  'WY Communications Executive': 'ВЮ Связной Исполнитель',
  'UPP Communications Officer': 'СПН Офицер Связи',
  'TWE Communications Officer': 'ИТМ Офицер Связи',
  'CLF Information Correspondant': 'КОФ Связной Агент',
  'CMB Deputy Operations Officer': 'КМБ Заместитель Офицера Операций',
  'Free Press Relay Operator': 'Оператор Свободной Прессы',

  // Antagonist roles
  Predator: 'Хищник',
  Xenomorph: 'Ксеноморф',
  Queen: 'Королева',

  // Observer role
  Observer: 'Наблюдатель',

  // Other
  Infected: 'Заражённые',

  Unemployed: 'Неизвестно',
};

export function JobsRu(value: string) {
  return JOBS_RU[value] || value;
}

export function MarinesStatesRu(value: string) {
  return MARINES_STATES_RU[value] || value;
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
