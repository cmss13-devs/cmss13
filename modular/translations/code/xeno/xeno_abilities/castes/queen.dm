/datum/action/xeno_action/onclick/remove_eggsac
	desc = "Убирает яйцеклад с задержкой в %TIME%"

/datum/action/xeno_action/onclick/remove_eggsac/apply_replaces_in_desc()
	replace_in_desc("%TIME%", 5, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/grow_ovipositor
	desc = "Позволяет вырастить яйцеклад с задержкой в %TIME%, если вы находитесь на траве своего улья.\
		<br>Будучи на яйцекладе, члены улья будут получать прогресс эволюции, лидеры распространять ваши феромоны, а также вы сможете строить."

/datum/action/xeno_action/onclick/grow_ovipositor/apply_replaces_in_desc()
	replace_in_desc("%TIME%", 20, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/set_xeno_lead
	desc = "Позволяет выдать/убрать лидера у наблюдаемого члена улья."

/datum/action/xeno_action/activable/queen_heal
	desc = "Лечит всех членов улья в радиусе %RANGE% вокруг выбранной цели на %HEAL_AMOUNT%% от их максимального здоровья в течении %TIME%"

/datum/action/xeno_action/activable/queen_heal/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", 4, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%HEAL_AMOUNT%", 30)
	replace_in_desc("%TIME%", 2, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/screech
	desc = "Оглушает всех в области видимости в радиусе %RANGE% на %STUN%, и в радиусе %RANGE_FAR% на %STUN_FAR%"

/datum/action/xeno_action/onclick/screech/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", 4, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%RANGE_FAR%", 6, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%STUN%", convert_effect_time(4, STUN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%STUN_FAR%", convert_effect_time(3, STUN), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/queen_tacmap

/datum/action/xeno_action/activable/queen_give_plasma
	desc = "Даёт выбранному члену улья 75% плазмы от их максимального хранилища."

/datum/action/xeno_action/onclick/queen_word
	desc = "Делает оповещение. Вас точно услышат."

/datum/action/xeno_action/activable/gut
	desc = "После задержки в %TIME% вы разрываете тело противника."

/datum/action/xeno_action/activable/gut/apply_replaces_in_desc()
	replace_in_desc("%TIME%", 8, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/expand_weeds
	desc = "Позволяет расширять траву, нажимая на область без травы, или создавать новые узлы на траве."

/datum/action/xeno_action/onclick/manage_hive
	desc = "Управление улья, включающее в себя: изгнание, возвращение, награждение, де-эволюцию, обмен грудоломов на эволюцию, а также покупку даров за королевскую смолу."

/datum/action/xeno_action/onclick/send_thoughts
	desc = "Позволяет шептать в разум одной цели, всем вокруг вас или приказать наблюдаемому члену улья."

/datum/action/xeno_action/activable/secrete_resin/remote/queen

/datum/action/xeno_action/onclick/eye
	desc = "Переводит вас в режим глаза. Глаз раздаёт феромоны наблюдаемому члену улья."

/datum/action/xeno_action/activable/bombard/queen

/datum/action/xeno_action/activable/place_queen_beacon

/datum/action/xeno_action/activable/blockade
