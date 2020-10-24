#define SURVIVOR_TO_MARINES_SPAWN_RATIO 1/15

/datum/job/civilian/survivor
	title = JOB_SURVIVOR
	selection_class = "job_special"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_CUSTOM_SPAWN
	late_joinable = FALSE
	var/intro_text
	var/story_text

/datum/job/civilian/survivor/set_spawn_positions(var/count)
	spawn_positions = Clamp((count * SURVIVOR_TO_MARINES_SPAWN_RATIO), 0, 8)
	total_positions = spawn_positions

/datum/job/civilian/survivor/equip_job(mob/living/M)
	return

/datum/job/civilian/survivor/spawn_in_player(var/mob/new_player/NP)
	. = ..()
	var/mob/living/carbon/human/H = .

	var/obj/effect/landmark/survivor_spawner/spawner = pick(surv_spawn)
	if(istype(spawner))
		H.loc = spawner.loc
	else
		H.loc = spawner

	if(istype(spawner) && spawner.equipment)
		arm_equipment(H, spawner.equipment, FALSE, TRUE)
	else
		survivor_old_equipment(H)

	if(istype(spawner) && spawner.roundstart_damage_max > 0)
		for(var/i in 0 to spawner.roundstart_damage_times)
			H.take_limb_damage(rand(spawner.roundstart_damage_min, spawner.roundstart_damage_max), 0)

	H.name = H.get_visible_name()

	if(istype(spawner) && spawner.intro_text && length(spawner.intro_text))
		intro_text = spawner.intro_text

	if(istype(spawner) && spawner.story_text)
		story_text = spawner.story_text

	new /datum/cm_objective/move_mob/almayer/survivor(H)

/datum/job/civilian/survivor/generate_entry_message(var/mob/living/carbon/human/H)
	if(intro_text)
		for(var/line in intro_text)
			to_chat(H, line)
	else
		to_chat(H, "<h2>You are a survivor!</h2>")
		switch(map_tag)
			if(MAP_PRISON_STATION)
				to_chat(H, SPAN_NOTICE(" You are a survivor of the attack on Fiorina Orbital Penitentiary. You worked or lived on the prison station, and managed to avoid the alien attacks... until now."))
			if(MAP_CORSAT)
				to_chat(H, SPAN_NOTICE("You are a survivor of the containment breach on the Corporate Orbital Research Station for Advanced Technology (CORSAT). You worked or lived on the station, and managed to avoid the alien attacks... until now."))
			if(MAP_ICE_COLONY)
				to_chat(H, SPAN_NOTICE("You are a survivor of the attack on the ice habitat. You worked or lived on the colony, and managed to avoid the alien attacks... until now."))
			else
				to_chat(H, SPAN_NOTICE("You are a survivor of the attack on the colony. You worked or lived in the archaeology colony, and managed to avoid the alien attacks... until now."))
		to_chat(H, SPAN_NOTICE("You are fully aware of the xenomorph threat and are able to use this knowledge as you see fit."))
		to_chat(H, SPAN_NOTICE("You are NOT aware of the marines or their intentions. "))

	if(story_text)
		to_chat(H, story_text)
		H.mind.memory += story_text
	else
		tell_survivor_story(H)

/datum/job/civilian/survivor/proc/tell_survivor_story(var/mob/living/carbon/human/H)
	var/list/survivor_story = list(
								"You watched as a larva burst from the chest of your friend, {name}. You tried to capture the alien thing, but it escaped through the ventilation.",
								"{name} was attacked by a facehugging alien, which impregnated them with an alien lifeform. {name}'s chest exploded in gore as some creature escaped.",
								"You watched in horror as {name} got the alien lifeform's acid on their skin, melting away their flesh. You can still hear the screaming and panic.",
								"The Colony Marshal, {name}, made an announcement that the hostile lifeforms killed many, and that everyone should hide or stay behind closed doors.",
								"You were there when the alien lifeforms broke into the mess hall and dragged away the others. It was a terrible sight, and you have tried avoid large open areas since.",
								"It was horrible, as you watched your friend, {name}, get mauled by the horrible monsters. Their screams of agony hunt you in your dreams, leading to insomnia.",
								"You tried your best to hide, and you have seen the creatures travel through the underground tunnels and ventilation shafts. They seem to like the dark.",
								"When you woke up, it felt like you've slept for years. You don't recall much about your old life, except maybe your name. Just what the hell happened to you?",
								"You were on the front lines, trying to fight the aliens. You have seen them hatch more monsters from other humans, and you know better than to fight against death.",
								"You found something, something incredible. But your discovery was cut short when the monsters appeared and began taking people. Damn the beasts!",
								"{name} protected you when the aliens came. You don't know what happened to them, but that was some time ago, and you haven't seen them since. Maybe they are alive."
								)

	/*
	var/list/survivor_multi_story = list(
										"You were separated from your friend, {surv}. You hope they're still alive.",
										"You were having some drinks at the bar with {surv} and {name} when an alien crawled out of the vent and dragged {name} away. You and {surv} split up to find help.",
										"Something spooked you when you were out with {surv} scavenging. You took off in the opposite direction from them, and you haven't seen them since.",
										"When {name} became infected, you and {surv} argued over what to do with the afflicted. You nearly came to blows before walking away, leaving them behind.",
										"You ran into {surv} when out looking for supplies. After a tense stand off, you agreed to stay out of each other's way. They didn't seem so bad.",
										"A lunatic by the name of {name} was preaching doomsday to anyone who would listen. {surv} was there too, and you two shared a laugh before the creatures arrived.",
										"Your last decent memory before everything went to hell is of {surv}. They were generally a good person to have around, and they helped you through tough times.",
										"When {name} called for evacuation, {surv} came with you. The aliens appeared soon after and everyone scattered. You hope your friend {surv} is alright.",
										"You remember an explosion. Then everything went dark. You can only recall {name} and {surv}, who were there. Maybe they know what really happened?",
										"The aliens took your mutual friend, {name}. {surv} helped with the rescue. When you got to the alien hive, your friend was dead. You took different passages out.",
										"You were playing basketball with {surv} when the creatures descended. You bolted in opposite directions, and actually managed to lose the monsters, somehow."
										)
										*/

	var/random_name = pick(random_name(FEMALE), random_name(MALE))
	var/temp_story = "<b>Your story thus far</b>: " + replacetext(pick(survivor_story), "{name}", "[random_name]")
	to_chat(H, temp_story)
	H.mind.memory += temp_story

	return TRUE

/datum/job/civilian/survivor/proc/survivor_old_equipment(var/mob/living/carbon/human/H)
	var/list/survivor_types
	switch(map_tag)
		if(MAP_PRISON_STATION)
			survivor_types = list(
				"Survivor - Scientist",
				"Survivor - Doctor",
				"Survivor - Corporate Liaison",
				"Survivor - Security",
				"Survivor - Prisoner",
				"Survivor - Prisoner",
				"Survivor - Gang Leader",
				"Survivor - Engineer"
			)
		if(MAP_LV_624, MAP_BIG_RED,MAP_DESERT_DAM, MAP_KUTJEVO)
			survivor_types = list(
				"Survivor - Scientist",
				"Survivor - Doctor",
				"Survivor - Chef",
				"Survivor - Chaplain",
				"Survivor - Miner",
				"Survivor - Engineer",
				"Survivor - Trucker",
				"Survivor - Colonial Marshall",
			)
		if(MAP_ICE_COLONY)
			survivor_types = list(
				"Survivor - Scientist",
				"Survivor - Doctor",
				"Survivor - Security",
				"Survivor - Trucker",
				"Survivor - Engineer"
			)
		if (MAP_SOROKYNE_STRATA)
			survivor_types = list(
				"Survivor - Scientist",
				"Survivor - Doctor",
				"Survivor - Security",
				"Survivor - Engineer"
			)
		if(MAP_CORSAT)
			survivor_types = list(
				"Survivor - Scientist",
				"Survivor - Scientist",
				"Survivor - Scientist",
				"Survivor - Doctor",
				"Survivor - Security",
				"Survivor - Corporate Liaison",
				"Survivor - Engineer"
			)
		else
			survivor_types = list(
				"Survivor - Scientist",
				"Survivor - Doctor",
				"Survivor - Chef",
				"Survivor - Chaplain",
				"Survivor - Miner",
				"Survivor - Colonial Marshall",
				"Survivor - Engineer"
				)

	arm_equipment(H, pick(survivor_types), FALSE, TRUE)

/datum/job/civilian/survivor/synth
	title = JOB_SYNTH_SURVIVOR
	selection_class = "job_synth"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_SYNTHETIC
	total_positions = 1
	spawn_positions = 1

/datum/job/civilian/survivor/synth/set_spawn_positions(var/count)
	return spawn_positions

/datum/job/civilian/survivor/synth/survivor_old_equipment(var/mob/living/carbon/human/H)
	var/list/survivor_types = list(
			"Survivor - Synthetic",
		)

	arm_equipment(H, pick(survivor_types), FALSE, TRUE)

AddTimelock(/datum/job/civilian/survivor, list(
	JOB_SQUAD_ROLES = HOURS_3
))