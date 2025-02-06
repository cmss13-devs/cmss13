/datum/job/marine
	supervisors = "the acting squad leader"
	selection_class = "job_marine"
	total_positions = 8
	spawn_positions = 8
	allow_additional = 1

/datum/job/marine/generate_entry_message(mob/living/carbon/human/current_human)
	if(current_human.assigned_squad)
		entry_message_intro = "Вы [disp_title]!<br>Вы причислены к: <b><font size=3 color=[current_human.assigned_squad.equipment_color]>[lowertext(current_human.assigned_squad.name)] отряду</font></b>.[Check_WO() ? "" : " Отправляйтесь в кафетерий, чтобы подкрепиться после криосна, а затем приведите снарядитесь и вооружитесь в комнате для подготовки." ]" // SS220 EDIT TRANSLATE
	return ..()

/datum/job/marine/generate_entry_conditions(mob/living/carbon/human/current_human)
	..()
	if(!Check_WO())
		current_human.nutrition = rand(NUTRITION_VERYLOW, NUTRITION_LOW) //Start hungry for the default marine.

/datum/timelock/squad
	name = "Squad Roles"

/datum/timelock/squad/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_SQUAD_ROLES_LIST
