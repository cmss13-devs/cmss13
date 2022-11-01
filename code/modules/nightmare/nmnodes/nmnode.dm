/// Decriptive nightmare config nodes loaded from config files
/datum/nmnode
	/// Unique identifier for referencing in JSON configuration
	var/id = "abstract"
	/// User provided name for debugging
	var/name
	/// Original JSON object that was used to create this
	var/list/raw

/datum/nmnode/New(list/spec)
	. = ..()
	src.raw = spec
	src.name = id
	if(spec["name"])
		src.name = spec["name"]
	if(isnum(spec["chance"]))
		AddElement(/datum/element/nmnode_prob, spec["chance"])
	var/list/conds = spec["when"]
	if(islist(conds))
		for(var/pname in conds)
			var/pvalue = conds[pname]
			var/modifier = copytext(pname, 1, 2)
			var/negate = FALSE
			if(modifier == "!")
				negate = TRUE
				pname = copytext(pname, 2)
			AddComponent(/datum/component/nmnode_cond, pname, pvalue, negate)

/// Implementation of the node, resolving into tasks in the given context
/datum/nmnode/proc/resolve(datum/nmcontext/context)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)
	. = TRUE
	if(SEND_SIGNAL(src, COMSIG_NIGHTMARE_APPLYING_NODE, context) & COMPONENT_ABORT_NMNODE)
		. = FALSE

/// Call wrapper for resolving nodes
/datum/nmnode/proc/invoke(datum/nmcontext/context)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = resolve(context)
	if(.)
		context.trace += src

