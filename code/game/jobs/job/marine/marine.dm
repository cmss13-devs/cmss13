/datum/job/marine
	supervisors = "the acting squad leader"
	selection_class = "job_marine"
	total_positions = 8
	spawn_positions = 8
	allow_additional = 1

/datum/job/marine/generate_entry_message(mob/living/carbon/human/H)
	if(H.assigned_squad)
		entry_message_intro = "You are a [title]!<br>You have been assigned to: <b><font size=3 color=[squad_colors[H.assigned_squad.color]]>[lowertext(H.assigned_squad.name)] squad</font></b>.[flags_startup_parameters & ROLE_ADD_TO_MODE ? " Make your way to the cafeteria for some post-cryosleep chow, and then get equipped in your squad's prep room." : ""]"
	return ..()

/datum/job/marine/generate_entry_conditions(mob/living/carbon/human/H)
	entry_message_body = ..()
	if(flags_startup_parameters & ROLE_ADD_TO_MODE) H.nutrition = rand(NUTRITION_VERYLOW, NUTRITION_LOW) //Start hungry for the default marine.

/datum/timelock/squad
	name = "Squad Roles"

/datum/timelock/squad/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_SQUAD_ROLES_LIST