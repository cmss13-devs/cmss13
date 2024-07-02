/datum/relations_action
	var/name = "TELL A DEV"
	var/desc = "TELL A DEV"

	var/act_name = "Set name"
	var/act_desc = "Set description"
	var/act_additional_info = "Set additional info"

	var/accepted = FALSE
	var/datum/faction/target_faction
	var/confirmed = FALSE
	var/datum/faction/initiator_faction

	var/time_delegated
	var/time_given = 5 MINUTES

	var/completion_initialy = FALSE

	var/expirable = FALSE
	var/start_acting_time
	var/expiring

/datum/relations_action/New(datum/faction/target_faction_to_set, datum/faction/initiator_faction_to_set)
	target_faction = target_faction_to_set
	initiator_faction = initiator_faction_to_set
	time_delegated = world.time

/datum/relations_action/Destroy()
	target_faction = null
	initiator_faction = null
	. = ..()

/datum/relations_action/proc/offer()

/datum/relations_action/proc/check_completion()

/datum/relations_action/proc/can_accept()

/datum/relations_action/proc/accept()

/datum/relations_action/proc/can_confirm()

/datum/relations_action/proc/confirmation()

/datum/relations_action/proc/start_acting()
	if(expirable)
		start_acting_time = world.time

	if(completion_initialy)
		completion()

/datum/relations_action/proc/completion()

/datum/relations_action/proc/expire()

//////////////
/datum/relations_action/alliance_request
	name = "Пакт для создания союза"
	desc = "Две стороны становятся союзниками, тем самым до момента разрыва договора не мешают друг другу"

	completion_initialy = TRUE

/datum/relations_action/alliance_request/completion()
	initiator_faction.relations_datum.allies[target_faction.faction_name] = target_faction
	target_faction.relations_datum.allies[initiator_faction.faction_name] = initiator_faction
	initiator_faction.relations_datum.gain_opinion(target_faction, 200)
	target_faction.relations_datum.gain_opinion(initiator_faction, 200)

/datum/relations_action/


/*
оскорблеения

*/
