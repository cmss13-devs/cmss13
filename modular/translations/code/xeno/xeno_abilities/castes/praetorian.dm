/datum/action/xeno_action/activable/pierce
	desc = "Пронзающий удар хвостом на расстоянии %DISTANCE%, наносящий %DAMAGE% урона каждой цели на пути. Попадание по %SHIELD_TARGETS% целям возвращает ваш щит."

/datum/action/xeno_action/activable/pierce/apply_replaces_in_desc()
	replace_in_desc("%DISTANCE%", 3, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%DAMAGE%", damage)
	replace_in_desc("%SHIELD_TARGETS%", shield_regen_threshold)

/datum/action/xeno_action/activable/pounce/prae_dash

/datum/action/xeno_action/activable/pounce/prae_dash/apply_replaces_in_desc()
	. = ..()
	desc += "<br><br>Используйте повторно в течении %TIMEOUT%, чтобы нанести %DAMAGE% урона всем вокруг вас. Попадание по %SHIELD_TARGETS% целям возвращает ваш щит."
	replace_in_desc("%DAMAGE%", damage)
	replace_in_desc("%SHIELD_TARGETS%", shield_regen_threshold)
	replace_in_desc("%TIMEOUT%", time_until_timeout / 10, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/cleave
	desc = "Имеет два режима. Для усиления нужно иметь рабочий щит.\
		<br>Режим Root: не даёт двигаться цели %ROOT% (%ROOTBUFF% при усилении).\
		<br>Режим Fling: откидывает цель на %FLING% (%FLINGBUFF% при усилении)"

/datum/action/xeno_action/activable/cleave/apply_replaces_in_desc()
	replace_in_desc("%ROOT%", root_duration_unbuffed / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%ROOTBUFF%", root_duration_buffed / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%FLING%", fling_dist_unbuffed, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%FLINGBUFF%", fling_dist_buffed, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/onclick/toggle_cleave
	desc = "Переключает режимы способности Cleave."

// Handled by basic version
/datum/action/xeno_action/activable/tail_stab/tail_seize
	desc = "Удар хвостом на расстоянии %DISTANCE%, наносящий %DAMAGE% урона. При попадании притягивает цель, замедляет её (%SLOW%) и не даёт ей двигаться (%ROOT%)."

/datum/action/xeno_action/activable/tail_stab/tail_seize/apply_replaces_in_desc()
	replace_in_desc("%DISTANCE%", /datum/ammo/xeno/oppressor_tail::max_range - 1, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%DAMAGE%", /datum/ammo/xeno/oppressor_tail::damage)
	replace_in_desc("%SLOW%", 0.5, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%ROOT%", 0.5, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/prae_abduct
	desc = "Создаёт линию размером в %DISTANCE% После задержки в %WINDUP% притягивает всех, кто оказался на линии.\
		<br>Если поймана 1 цель, то она будет замедлена (%SLOW%);\
		<br>Если поймано 2 цели, то они не смогут двигаться (%ROOT%);\
		<br>Если поймана 3 цели, то они будут оглушены (%STUN%)."

/datum/action/xeno_action/activable/prae_abduct/apply_replaces_in_desc()
	replace_in_desc("%DISTANCE%", max_distance, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%WINDUP%", windup / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%SLOW%", 1, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%ROOT%", 2.5, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%STUN%", 1.3, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/oppressor_punch
	desc = "Удар рукой, наносящий %DAMAGE% урона. Уменьшает перезарядку удара хвостом и крюка на 5 секунд.\
		<br>Если цель обездвижена, лежит или замедлена, то она не сможет двигаться ещё %ROOT%"

/datum/action/xeno_action/activable/oppressor_punch/apply_replaces_in_desc()
	replace_in_desc("%DAMAGE%", damage)
	replace_in_desc("%ROOT%", 1.2, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/tail_lash
	desc = "Удар хвостом по области 2x3 с задержкой в %WINDUP% Все цели, оказавшиеся в области, будут откинуты на %FLING%, опрокинуты (%WEAKEN%) и замедлены (%SLOW%)."

/datum/action/xeno_action/activable/tail_lash/apply_replaces_in_desc()
	replace_in_desc("%FLING%", fling_dist, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%WINDUP%", windup / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%WEAKEN%", 0.5, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%SLOW%", 2.5, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/prae_impale
	desc = "Удар хвостом, наносящий %DAMAGE% урона. Если цель имеет метку, она получит этот урон дважды."

/datum/action/xeno_action/activable/prae_impale/apply_replaces_in_desc()
	var/mob/living/carbon/xenomorph/dancer_user = owner
	replace_in_desc("%DAMAGE%", round((dancer_user.melee_damage_lower + dancer_user.melee_damage_upper) / 2, 1))

/datum/action/xeno_action/onclick/prae_dodge
	desc = "Увеличивает вашу скорость движения и позволяет ходить сквозь существ на %TIME%."

/datum/action/xeno_action/onclick/prae_dodge/apply_replaces_in_desc()
	replace_in_desc("%TIME%", duration / 10, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/prae_tail_trip
	desc = "Подсечка хвостом на расстоянии %RANGE%, которая опрокидывает на %STUN% (%STUNBUFF% с меткой) и дезориентирует на %DAZE% (%DAZEBUFF%).\
		<br>Цель без метки также будет замедлена на %SLOW%"

/datum/action/xeno_action/activable/prae_tail_trip/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%SLOW%", slow_duration, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%STUN%", convert_effect_time(stun_duration_default, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%STUNBUFF%", convert_effect_time(stun_duration_buffed, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DAZE%", convert_effect_time(daze_duration_default, DAZE), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DAZEBUFF%", convert_effect_time(daze_duration_buffed, DAZE), DESCRIPTION_REPLACEMENT_TIME)

// Handled by basic version
/datum/action/xeno_action/activable/pounce/base_prae_dash

/datum/action/xeno_action/activable/prae_acid_ball
	desc = "После задержки в %DELAY%, запускает кислотную гранату, которая взорвётся после %PRIME%\
		<br>Наносит %DAMAGE% урона на расстоянии %RANGE%"

/datum/action/xeno_action/activable/prae_acid_ball/apply_replaces_in_desc()
	replace_in_desc("%DELAY%", activation_delay / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%PRIME%", prime_delay / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DAMAGE%", /datum/ammo/xeno/acid/prae_nade::damage)
	replace_in_desc("%RANGE%", /datum/ammo/xeno/acid/prae_nade::max_range, DESCRIPTION_REPLACEMENT_DISTANCE)

// Handled by basic version
/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid

/datum/action/xeno_action/activable/tail_stab/tail_fountain
	desc = "Спрей из хвоста, который тушит цель на расстоянии %RANGE%"

/datum/action/xeno_action/activable/tail_stab/tail_fountain/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", 2, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/activable/valkyrie_rage
	desc = "При использовании на союзника, вы входите в ярость и получаете %ARMOR% брони на %ARMOR_DUR%, а цель получает %TARGET_ARMOR% брони на %TARGET_DUR%\
		<br>Если целью является Крушитель или Опустошитель, вместо брони она ускоряется на %SPEED_DUR%\
		<br>Использует %COST% ярости."

/datum/action/xeno_action/activable/valkyrie_rage/apply_replaces_in_desc()
	replace_in_desc("%ARMOR%", armor_buff)
	replace_in_desc("%ARMOR_DUR%", armor_buffs_duration / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%TARGET_ARMOR%", target_armor_buff)
	replace_in_desc("%TARGET_DUR%", armor_buffs_targer_dur / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%SPEED_DUR%", speed_buff_dur / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%COST%", rage_cost)

/datum/action/xeno_action/activable/high_gallop
	desc = "Удар хвостом по области 2x3. Все цели в области будут опрокинуты (%WEAKEN%), а гранаты отброшены назад на %GRENADE_THROW%"

/datum/action/xeno_action/activable/high_gallop/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", gallop_range)
	replace_in_desc("%WEAKEN%", convert_effect_time(0.5, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%GRENADE_THROW%", 3, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/onclick/fight_or_flight
	desc = "Снимает все эффекты оглушения и замедления с союзников на расстоянии %RANGE% или %RANGEBUFF%, если имелось %COSTBUFF% ярости при использовании.\
		<br>Использует %COST% ярости."

/datum/action/xeno_action/onclick/fight_or_flight/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", low_rage_range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%RANGEBUFF%", high_rage_range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%COST%", rejuvenate_cost)
	replace_in_desc("%COSTBUFF%", rejuvenate_cost * 2)

/datum/action/xeno_action/activable/prae_retrieve
	desc = "Притягивает цель-сестру после задержки в %DELAY% на расстоянии %RANGE% Она будет подтянута, если она находилась в области после окончания задержки.\
		<br>Большие сёстры должны отдыхать или находиться без сознания, чтобы их подтянуть.\
		<br>Использует %COST% ярости."

/datum/action/xeno_action/activable/prae_retrieve/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", max_distance)
	replace_in_desc("%DELAY%", windup / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%COST%", retrieve_cost)
