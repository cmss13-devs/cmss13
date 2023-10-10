// Essentially the same as decorators but that apply to the whole game state instead of individual atoms
SUBSYSTEM_DEF(game_decorator)
	name = "Game Decorator"
	init_order = SS_INIT_DECORATOR
	flags = SS_NO_FIRE

/datum/controller/subsystem/game_decorator/Initialize()
	. = ..()
	for(var/decorator_type in subtypesof(/datum/game_decorator))
		var/datum/game_decorator/decorator = new decorator_type()
		if(!decorator.is_active_decor())
			continue
		decorator.decorate()
		CHECK_TICK

	return SS_INIT_SUCCESS

/datum/game_decorator
/datum/game_decorator/proc/is_active_decor()
	return FALSE
/datum/game_decorator/proc/decorate()
	return
