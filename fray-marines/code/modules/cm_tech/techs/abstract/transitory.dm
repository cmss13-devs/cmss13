/datum/tech/transitory/ui_static_data(mob/user)
	. = ..()
	if(techs_to_unlock)
		.["stats"] += list(list(
			"content" = "Требования: Не менее [techs_to_unlock] технологий [initial(before.name)].",
			"color" = "red",
			"icon" = "lightbulb",
			"tooltip" = "Вам нужно открыть не менее [techs_to_unlock] технологий с [initial(before.name)] прежде чем вы сможете перейти на следующий уровень ветки."
		))
