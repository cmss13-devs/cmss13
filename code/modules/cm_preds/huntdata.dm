/datum/huntdata
	var/mob/living/carbon/owner
	var/name = "Hunter Data"

	//vars for Hunters targeting prey.
	var/hunted = FALSE
	var/mob/living/carbon/hunter //Target has their hunter variable linked to the Hunter.
	var/mob/living/carbon/prey //Hunter has their prey variable linked to their target.


	//Vars for Hunters marking someone as dishonorable.
	var/dishonored = FALSE
	var/mob/living/carbon/dishonored_set //The Hunter who marked the target as Dishonorable.
	var/list/dishonored_targets = list() //The list of people a specific Hunter has marked as Dishonorable.
	var/dishonored_reason //The Reason the target was set as dishonorable.

	var/honored = FALSE
	var/mob/living/carbon/honored_set //The Hunter who marked the target as Honorable.
	var/list/honored_targets = list() //The list of people a specific Hunter has marked as Honorable.
	var/honored_reason //The Reason the target was set as Honorable.

	var/gear = FALSE
	var/mob/living/carbon/gear_set //The Hunter who marked the target as having Hunter Gear.
	var/list/gear_targets = list() //The list of people a specific Hunter has marked as having Hunter Gear.

	var/thralled = FALSE
	var/mob/living/carbon/thralled_set //The Hunter who marked a target as their Thrall.
	var/thralled_reason //The Reason the target was Thralled.
	var/mob/living/carbon/thrall //The Thrall the Hunter marked.


/datum/huntdata/proc/clean_data()
	if(dishonored)
		if(dishonored_set)
			dishonored_set.hunter_data.dishonored_targets -= owner
			dishonored_set = null
		dishonored_reason = null
		dishonored = FALSE
	for(var/mob/living/carbon/M in dishonored_targets)
		M.hunter_data.dishonored_set = null
		dishonored_targets -= M

	if(honored)
		if(honored_set)
			honored_set.hunter_data.honored_targets -= owner
			honored_set = null
		honored_reason = null
		honored = FALSE
	for(var/mob/living/carbon/M in honored_targets)
		M.hunter_data.honored_set = null
		honored_targets -= M

	if(gear)
		if(gear_set)
			gear_set.hunter_data.gear_targets -= owner
			gear_set = null
		gear = FALSE
	for(var/mob/living/carbon/M in gear_targets)
		M.hunter_data.gear_set = null
		gear_targets -= M

	if(hunted)
		if(hunter)
			hunter.hunter_data.prey = null
			to_chat(hunter, SPAN_YAUTJABOLD("Your Prey has been utterly destroyed!"))
			hunter = null
		hunted = FALSE
	if(prey)
		prey.hunter_data.hunter = null
		prey.hunter_data.hunted = FALSE
		prey = null

	if(thralled)
		if(thralled_set)
			thralled_set.hunter_data.thrall = null
			to_chat(thralled_set, SPAN_YAUTJABOLD("Your Thrall has been utterly destroyed!"))
			message_all_yautja("[thralled_set.real_name]'s Thrall, [owner.real_name], has been utterly destroyed!")
			thralled_set = null
		thralled = FALSE
	if(thrall)
		thrall.hunter_data.thralled_set = null
		thrall = null

	if(owner)
		owner = null
