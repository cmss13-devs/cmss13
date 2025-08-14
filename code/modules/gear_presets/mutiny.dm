/datum/equipment_preset/other/mutiny/mutineer
	name = "Mutineer"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mutiny/mutineer/load_status(mob/living/carbon/human/new_human)
	. = ..()
	new_human.mob_flags |= MUTINY_MUTINEER
	new_human.hud_set_squad()

	to_chat(new_human, SPAN_HIGHDANGER("<hr>You are now a Mutineer!"))
	to_chat(new_human, SPAN_DANGER("Please check the rules to see what you can and can't do as a mutineer.<hr>"))
	log_game("MUTINY - [key_name(new_human)] became a [name]")

/datum/equipment_preset/other/mutiny/mutineer/leader
	name = "Mutineer Leader"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mutiny/mutineer/leader/load_status(mob/living/carbon/human/new_human)
	for(var/datum/action/human_action/activable/mutineer/A in new_human.actions)
		A.remove_from(new_human)

	var/list/abilities = subtypesof(/datum/action/human_action/activable/mutineer)
	for(var/type in abilities)
		give_action(new_human, type)

/datum/equipment_preset/other/mutiny/loyalist
	name = "Loyalist"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mutiny/loyalist/load_status(mob/living/carbon/human/new_human)
	. = ..()
	new_human.mob_flags |= MUTINY_LOYALIST
	new_human.hud_set_squad()

	to_chat(new_human, SPAN_HIGHDANGER("<hr>You are now a Loyalist!"))
	to_chat(new_human, SPAN_DANGER("Please check the rules to see what you can and can't do as a loyalist.<hr>"))
	log_game("MUTINY - [key_name(new_human)] became a [name]")

/datum/equipment_preset/other/mutiny/noncombat
	name = "Non-Combatant"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mutiny/noncombat/load_status(mob/living/carbon/human/new_human)
	. = ..()
	new_human.mob_flags |= MUTINY_NONCOMBAT
	new_human.hud_set_squad()

	to_chat(new_human, SPAN_HIGHDANGER("<hr>You are now a Non-Combatant!"))
	to_chat(new_human, SPAN_DANGER("You are not to get involved in the mutiny. You can heal either side, but must not engage or be engaged in combat.<hr>"))
	log_game("MUTINY - [key_name(new_human)] became a [name]")
