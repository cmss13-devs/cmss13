/datum/crime_incident
	var/UID // The unique identifier for this incident

	var/notes = "" // The written explanation of the crime

	var/list/charges = list() // What laws were broken in this incident
	var/list/evidence = list()
	var/list/witnesses = list()

	var/criminal_name = null// The person who committed the crimes
	var/criminal_gid = 0	// Unique identifier for person

	var/brig_sentence = 0 // How long do they stay in the brig on the station, PERMABRIG_SENTENCE minutes = permabrig
	var/time_served = 0  // How long have they served of this sentence already
	var/time_to_release = 0 // What time are they set to be released, for jail
	var/active_timer = FALSE

	var/sentence_served = FALSE

	var/pardoned = FALSE

/datum/crime_incident/New()
	UID = md5("[world.realtime][rand(0, 1000000)]")

	..()

/datum/crime_incident/proc/refresh_sentences()
	brig_sentence = calculate_sentence()

/datum/crime_incident/proc/calculate_sentence()
	var/sentence_length = 0
	var/optional_time = 0
	for(var/datum/law/L in charges)
		if(istype(L, /datum/law/optional_law))
			optional_time += L.brig_time
			continue

		if(L.brig_time > sentence_length)
			sentence_length = L.brig_time

	sentence_length += optional_time
	
	if(sentence_length > PERMABRIG_SENTENCE)
		sentence_length = PERMABRIG_SENTENCE

	return sentence_length

/datum/crime_incident/proc/charges_to_string()
	var/charge_list = ""
	for(var/datum/law/L in charges)
		charge_list += L.name
		charge_list += ", "
	return copytext(charge_list, 1, length(charge_list)-1)