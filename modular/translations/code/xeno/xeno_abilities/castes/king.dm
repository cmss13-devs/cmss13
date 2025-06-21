/datum/action/xeno_action/onclick/rend
	desc = "Наносит %DAMAGE% урона всем противникам вокруг вас."

/datum/action/xeno_action/onclick/rend/apply_replaces_in_desc()
	replace_in_desc("%DAMAGE%", damage)

/datum/action/xeno_action/activable/doom
	desc = "Замедляет (%SLOWTIME%) и дезориентирует (%DAZETIME%) всех в области видимости, а также гасит все источники освещения. Выводит реагенты из тел носителей."

/datum/action/xeno_action/activable/doom/apply_replaces_in_desc()
	replace_in_desc("%SLOWTIME%", slow_length_seconds, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DAZETIME%", daze_length_seconds, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/destroy
	desc = "После небольшой задержки в %DELAY%, вы упадёте на указанную местность на расстоянии %DISTANCE%, уничтожая барикады и противников на месте падения и вокруг неё."

/datum/action/xeno_action/activable/destroy/apply_replaces_in_desc()
	replace_in_desc("%DELAY%", 2, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DISTANCE%", range, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/onclick/king_shield
	desc = "Даёт всем ксеноморфам вашего улья щит размером %SHIELD% на расстоянии %DISTANCE% на %TIME%"

/datum/action/xeno_action/onclick/king_shield/apply_replaces_in_desc()
	replace_in_desc("%SHIELD%", shield_amount)
	replace_in_desc("%DISTANCE%", area_of_effect, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%TIME%", shield_duration / 10, DESCRIPTION_REPLACEMENT_TIME)
