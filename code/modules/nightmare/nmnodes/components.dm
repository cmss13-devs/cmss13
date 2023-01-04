/// Applies to a /datum/nmnode to enforce scenario constraints
/datum/component/nmnode_cond
	/// Parameter from scenario storage to check for
	var/pname
	/// Value to check the parameter against
	var/pvalue
	/// By default, the condition is required. If true, invert the check
	var/negate = FALSE

/datum/component/nmnode_cond/Initialize(pname, pvalue, negate = FALSE)
	. = ..()
	src.pname = pname
	src.pvalue = pvalue
	src.negate = negate

/datum/component/nmnode_cond/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_NIGHTMARE_APPLYING_NODE, PROC_REF(check_for_cond))

/datum/component/nmnode_cond/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_NIGHTMARE_APPLYING_NODE)

/datum/component/nmnode_cond/proc/check_for_cond(datum/nmnode/source, datum/nmcontext/context)
	SIGNAL_HANDLER
	var/value = context.get_scenario_value(src.pname)
	if(!(negate ^ (value == pvalue)))
		return COMPONENT_ABORT_NMNODE


/// Adds a probability to skip the node
/datum/element/nmnode_prob
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 1
	var/probvalue = 1 // factor

/datum/element/nmnode_prob/Attach(target, probvalue)
	. = ..()
	src.probvalue = probvalue
	RegisterSignal(target, COMSIG_NIGHTMARE_APPLYING_NODE, PROC_REF(check_prob))

/datum/element/nmnode_prob/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, COMSIG_NIGHTMARE_APPLYING_NODE)

/datum/element/nmnode_prob/proc/check_prob(datum/nmnode/source)
	SIGNAL_HANDLER
	if(rand() > probvalue)
		return COMPONENT_ABORT_NMNODE
