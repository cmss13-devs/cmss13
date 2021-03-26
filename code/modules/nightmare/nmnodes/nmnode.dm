/// A nmnode represents an entry from the JSON configuration, which can be an action, control flow, etc
/datum/nmnode
	/// Node name - optional
	var/name = "Abstract Node"
	/// Chance to occur as a factor of 1, if not rolled the node is skipped
	var/chance
	/// Chaos - global randomness modifier, usually used as power of non-occurence
	var/chaos
	/// Conditions - an associative list of required values in scenario storage to apply
	var/list/conditions

/**
 * nodespec are parsed JSON hash values read from file
 * attributes:
 *  - name: optional
 *  - chance: p-value of this node being entierly skipped
 *  - when: hash of values required for this to be used
 */
/datum/nmnode/New(datum/nmreader/reader, list/nodespec)
	. = ..()
	if(nodespec["name"])
		name  = nodespec["name"]
	if(isnum(nodespec["chance"]))
		chance = nodespec["chance"]
	if(nodespec["when"])
		conditions = nodespec["when"]

/datum/nmnode/Destroy()
	conditions = null
	return ..()

/**
 * Go through any child nodes if applicable,
 * and queue actions as needed
 */
/datum/nmnode/proc/resolve(datum/nmcontext/context)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(isnum(chance))
		var/eff_chance = Clamp(chance, 0, 1)
		if(isnum(context.scenario["chaos"]))
			eff_chance = 1 - (1 - eff_chance) ** context.scenario["chaos"]
		if(eff_chance < rand())
			return
	if(conditions)
		for(var/key in conditions)
			if(conditions[key] != context.scenario[key])
				return
	return TRUE

/// Convenience wrapper for logging
/datum/nmnode/proc/logself(message, critical = FALSE, prefix)
	if(!critical && !CONFIG_GET(flag/nightmare_debug))
		return
	if(prefix)
		log_debug("NMNODE \[[prefix]\] \[[name]\]: [message]")
		return
	log_debug("NMNODE \[[name]\]: [message]")
