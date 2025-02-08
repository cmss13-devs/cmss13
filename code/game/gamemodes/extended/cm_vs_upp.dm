/datum/game_mode/extended/faction_clash/cm_vs_upp
	name = "Faction Clash UPP CM"
	config_tag = "Faction Clash UPP CM"
	flags_round_type = MODE_THUNDERSTORM|MODE_FACTION_CLASH
	starting_round_modifiers = list(
		/datum/gamemode_modifier/blood_optimization,
		/datum/gamemode_modifier/defib_past_armor,
		/datum/gamemode_modifier/disable_combat_cas,
		/datum/gamemode_modifier/disable_ib,
		/datum/gamemode_modifier/disable_ob,
		/datum/gamemode_modifier/disable_attacking_corpses,
		/datum/gamemode_modifier/disable_long_range_sentry,
		/datum/gamemode_modifier/disable_stripdrag_enemy,
		/datum/gamemode_modifier/indestructible_splints,
		/datum/gamemode_modifier/mortar_laser_warning,
		/datum/gamemode_modifier/no_body_c4,
		/datum/gamemode_modifier/weaker_explosions_fire,
	)

	taskbar_icon = 'icons/taskbar/gml_hvh.png'

/datum/game_mode/extended/faction_clash/cm_vs_upp/get_roles_list()
	return GLOB.ROLES_CM_VS_UPP

/datum/game_mode/extended/faction_clash/cm_vs_upp/post_setup()
	. = ..()
	SSweather.force_weather_holder(/datum/weather_ss_map_holder/faction_clash)
	for(var/area/area in GLOB.all_areas)
		area.base_lighting_alpha = 150
		area.update_base_lighting()

/datum/game_mode/extended/faction_clash/cm_vs_upp/announce()
	. = ..()
	marine_announcement("Из местной колонии поступил автоматический сигнал бедствия.\n\nВнимание! Сенсоры обнаружили военный корабль Союза Прогрессивных Людей на орбите колонии. Вражеское судно отклонило автоматические сигналы бедствия и выходит на нижнюю планетарную орбиту. Высока вероятность того, что вражеское судно готовится к отправке десанта в местную колонию. Получено разрешение на перехват и оттеснение вражеских сил с территории союзников. Проводится автоматическое пробуждение резерва морпехов из криостазиса.", "ARES 3.2", 'sound/AI/commandreport.ogg', FACTION_MARINE)
	marine_announcement("Тревога! Сенсоры обнаружили приближающееся судно КМП, идущее на встречу местной колонии.\n\nПо данным разведки, это корабль [MAIN_SHIP_NAME]. Есть большая уверенность, что силы КМП действуют вразрез с интересами Союза в этой области. Разрешение на развертывание наземных сил для пресечения попытки иностранной державы посягнуть на интересы Союза было получено. Проводится экстренное пробуждение резервов криостазиса.", "1VAN/3", 'sound/AI/commandreport.ogg', FACTION_UPP)
