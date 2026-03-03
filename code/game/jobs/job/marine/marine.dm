/datum/job/marine
	supervisors = "the acting squad leader"
	selection_class = "job_marine"
	total_positions = 8
	spawn_positions = 8
	allow_additional = 1

/datum/job/marine/generate_entry_message(mob/living/carbon/human/current_human)
	if(current_human.assigned_squad)
		entry_message_intro = "You are a [title]!<br>You have been assigned to: <b><font size=3 color=[current_human.assigned_squad.equipment_color]>[lowertext(current_human.assigned_squad.name)] squad</font></b>.[Check_WO() ? "" : " Make your way to the cafeteria for some post-cryosleep chow, and then get equipped in your squad's prep room." ]"
	return ..()

/datum/job/marine/generate_entry_conditions(mob/living/carbon/human/current_human)
	..()
	if(!Check_WO())
		current_human.nutrition = rand(NUTRITION_VERYLOW, NUTRITION_LOW) //Start hungry for the default marine.

/datum/job/marine/proc/calculate_extra_slots(latejoin, slots)
	var/extra_slots = 0

	for(var/datum/squad/target_squad in GLOB.RoleAuthority.squads)
		if(!target_squad)
			continue

		if(target_squad.pop_lock && target_squad.pop_lock < length(GLOB.clients))
			target_squad.roles_cap = target_squad.initial_roles_cap

		if(target_squad.dynamic_scaling)
			if(latejoin)
				target_squad.roles_cap[title] = slots
		else
			extra_slots += target_squad.roles_cap[title]

	return extra_slots

/datum/timelock/squad
	name = "Squad Roles"

/datum/timelock/squad/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_SQUAD_ROLES_LIST
