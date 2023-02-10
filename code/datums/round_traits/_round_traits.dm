///Base class of round traits. These are used to influence rounds in one way or the other by influencing the levers of the round.

/datum/round_trait
	///Name of the trait
	var/name = "unnamed round trait"
	///The type of this trait. Used to classify how this trait influences the round
	var/trait_type = ROUND_TRAIT_NEUTRAL
	///Whether or not this trait uses process()
	var/trait_processes = FALSE
	///Whether this trait is always enabled; generally used for debugging
	var/force = FALSE
	///Chance relative to other traits of its type to be picked
	var/weight = 10
	///Does this trait show in the human report?
	var/show_in_human_report = FALSE
	///Does this trait show in the xeno report?
	var/show_in_xeno_report = FALSE
	///What message to show in the human report?
	var/human_report_message
	///What message to show in the xeno report?
	var/xeno_report_message
	///What trait does this round trait give? gives none if null
	var/trait_to_give
	///What traits are incompatible with this one?
	var/blacklist
	///Extra flags for round traits such as it being abstract
	var/trait_flags
	/// Whether or not this trait can be reverted by an admin
	var/can_revert = TRUE


/datum/round_trait/New()
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(on_round_start)))
	setup_report_messages()
	if(trait_processes)
		START_PROCESSING(SSround, src)
	if(trait_to_give)
		ADD_TRAIT(SSround, trait_to_give, TRAIT_SOURCE_ROUND)

/datum/round_trait/Destroy()
	SSround.round_traits -= src
	return ..()

///Proc ran when round starts. Use this for roundstart effects.
/datum/round_trait/proc/on_round_start()
	return

///type of info the human report has on this trait, if any.
/datum/round_trait/proc/get_report()
	return "[name] - [human_report_message]"

/// prepares the relevant report messages, stub
/datum/round_trait/proc/setup_report_messages()
	return

/// Will attempt to revert the round trait, used by admins.
/datum/round_trait/proc/revert()
	if(!can_revert)
		CRASH("revert() was called on [type], which can't be reverted!")

	if(trait_to_give)
		REMOVE_TRAIT(SSround, trait_to_give, TRAIT_SOURCE_ROUND)

	qdel(src)
