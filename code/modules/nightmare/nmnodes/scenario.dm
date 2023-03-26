/datum/nmnode/scenario_def
	id = "def"
	var/list/values

/datum/nmnode/scenario_def/New(list/spec)
	. = ..()
	values = spec["values"]

/datum/nmnode/scenario_def/Destroy()
	values = null
	return ..()

/datum/nmnode/scenario_def/resolve(datum/nmcontext/context)
	. = ..()
	if(.)
		for(var/value in values)
			context.scenario[value] = values[value]
