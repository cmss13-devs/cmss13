/datum/action/xeno_action/activable/pounce/crusher_charge

/datum/action/xeno_action/activable/pounce/crusher_charge/apply_replaces_in_desc()
	. = ..()
	desc += "<br><br>Увеличивается броня спереди (%ARMOR_CRUSH%) во время зарядки рывка. При прямом попадании наносит %DAMAGE_CRUSH% урона, опрокидывает цель (%KNOCKDOWN_CRUSH%) и отталкивает её (%THROW_CRUSH%). \
		Замедляет всех в точке остановки рывка (%SLOWDOWN_CRUSH%). \
		<br>ВНИМАНИЕ: рывок прерывается движением."
	replace_in_desc("%ARMOR_CRUSH%", 15) // Hardcoded
	replace_in_desc("%DAMAGE_CRUSH%", direct_hit_damage)
	replace_in_desc("%SLOWDOWN_CRUSH%", 3.5, DESCRIPTION_REPLACEMENT_TIME) // Hardcoded
	replace_in_desc("%KNOCKDOWN_CRUSH%", convert_effect_time(2, WEAKEN), DESCRIPTION_REPLACEMENT_TIME) // Hardcoded
	replace_in_desc("%THROW_CRUSH%", 3, DESCRIPTION_REPLACEMENT_DISTANCE) // Hardcoded

/datum/action/xeno_action/onclick/crusher_stomp
	desc = "Сильно топтать по земле вокруг. Носители, оказавшиеся под нами, получают огромный урон (%DAMAGE%). Опрокидывает цели (%KNOCKDOWN%) на расстоянии (%KNOCKDOWN_DISTANCE%) и замедляет (%SLOWTIME%)."

/datum/action/xeno_action/onclick/crusher_stomp/apply_replaces_in_desc()
	replace_in_desc("%DAMAGE%", 60)
	replace_in_desc("%SLOWTIME%", effect_duration / 10, DESCRIPTION_REPLACEMENT_TIME) // It's deciseconds
	replace_in_desc("%KNOCKDOWN%", convert_effect_time(0.2, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%KNOCKDOWN_DISTANCE%", distance, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/onclick/crusher_stomp/charger
	desc = "Сильно топтать по земле вокруг. Носители, оказавшиеся под нами, получают огромный урон (%DAMAGE%) и замедляются (%SLOWTIME%)."

/datum/action/xeno_action/onclick/crusher_shield
	desc = "Создаёт поглощающий урон щит (%SHIELD%, %TIME%). Щит снижает получаемый урон на %DEFENSE%. Даёт иммунитет к взрывам (%EXPL_IMM%)."

/datum/action/xeno_action/onclick/crusher_shield/apply_replaces_in_desc()
	replace_in_desc("%SHIELD%", shield_amount)
	replace_in_desc("%TIME%", 7, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DEFENSE%", 10) // Hardcoded
	replace_in_desc("%EXPL_IMM%", 2.5, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/fling/charger
	desc = "Кинуть цель вперёд от вас (%FLING_DISTANCE%). Замедляет цель (%FLING_SLOWDOWN%)."

/datum/action/xeno_action/onclick/charger_charge
	desc = "При активации мы будем ускоряться за каждую пройденную без остановки клетку и накапливать моментум, начиная с %STEPS_TO_CHARGE% \
		При увеличении моментума увеличивается расстояние, на которое мы отбрасываем носителей на пути (макс. %DIST_MAX%), а также наносимый им урон (макс. %DAMAGE_MAX%). \
		Максимальный размер моментума равен %MOMENTUM_MAX%"

/datum/action/xeno_action/onclick/charger_charge/apply_replaces_in_desc()
	replace_in_desc("%DIST_MAX%", max_momentum * 0.25, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%DAMAGE_MAX%", max_momentum * 6)
	replace_in_desc("%STEPS_TO_CHARGE%", steps_to_charge, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%MOMENTUM_MAX%", max_momentum, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/activable/tumble
	desc = "Сделать уворок в бок. Сбрасывает моментум, но после окончания уворот моментум начнёт накапливаться сразу же. При попадании опрокидывает цель (%WEAKEN%) и наносит %DAMAGE% урона."

/datum/action/xeno_action/activable/tumble/apply_replaces_in_desc()
	replace_in_desc("%WEAKEN%", convert_effect_time(1, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DAMAGE%", 15) // Hardcoded
