/*
 * In scenario mode we just handle pre-setup of global choices
 */


/// Sets a value in scenario variables, mainly for use with 'when'
/datum/nmnode/scenario/def
	name = "Scenario Def"
	var/list/hash = list()
/datum/nmnode/scenario/def/New(datum/nmreader/parser, list/nodespec)
	. = ..()
	var/list/params = nodespec["values"]
	if(islist(params))
		hash = params.Copy()
/datum/nmnode/scenario/def/Destroy()
	hash = null
	return ..()
/datum/nmnode/scenario/def/resolve(datum/nmcontext/context)
	. = ..()
	if(!.) return
	for(var/key in hash)
		context.scenario[key] = hash[key]
