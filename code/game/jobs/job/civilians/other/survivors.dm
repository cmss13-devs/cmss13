#define SURVIVOR_TO_TOTAL_SPAWN_RATIO 1/9

/datum/job/civilian/survivor
	title = JOB_SURVIVOR
	selection_class = "job_special"
	// For the roundstart precount, then gets further limited by set_spawn_positions.
	total_positions = 8
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_CUSTOM_SPAWN
	late_joinable = FALSE
	job_options = SURVIVOR_VARIANT_LIST
	var/intro_text
	var/story_text
	/// Whether or not the survivor is an inherently hostile to marines.
	var/hostile = FALSE

/datum/job/civilian/survivor/set_spawn_positions(count)
	spawn_positions = clamp((floor(count * SURVIVOR_TO_TOTAL_SPAWN_RATIO)), 2, 8)
	total_positions = spawn_positions

/datum/job/civilian/survivor/equip_job(mob/living/survivor)
	var/generated_account = generate_money_account(survivor)
	addtimer(CALLBACK(src, PROC_REF(announce_entry_message), survivor, generated_account), 2 SECONDS)
	return

/datum/job/civilian/survivor/announce_entry_message(mob/living/carbon/human/survivor, datum/money_account/account, whitelist_status) //The actual message that is displayed to the mob when they enter the game as a new player.
	if(survivor?.loc && survivor.client)
		//Document syntax cannot have tabs for proper formatting.	// SS220 EDIT TRANSLATE
		var/entrydisplay = " \
			[SPAN_ROLE_BODY("|______________________|")] \n\
			[SPAN_ROLE_BODY("[generate_entry_message(survivor)]<br>[account ? "Ваш номер аккаунта: <b>[account.account_number]</b>. Ваш пинкод: <b>[account.remote_access_pin]</b>." : "У вас нет банковского счета."]")] \n\
			[SPAN_ROLE_BODY("|______________________|")] \
		"
		to_chat_spaced(survivor, html = entrydisplay)

/datum/job/civilian/survivor/spawn_in_player(mob/new_player/NP)
	. = ..()
	var/mob/living/carbon/human/H = .

	var/list/potential_spawners = list()
	for(var/priority = 1 to LOWEST_SPAWN_PRIORITY)
		if(length(GLOB.survivor_spawns_by_priority["[priority]"]))
			for(var/obj/effect/landmark/survivor_spawner/spawner as anything in GLOB.survivor_spawns_by_priority["[priority]"])
				if(spawner.check_can_spawn(H))
					potential_spawners += spawner
			if(length(potential_spawners))
				break
	var/obj/effect/landmark/survivor_spawner/picked_spawner = pick(potential_spawners)
	H.forceMove(get_turf(picked_spawner))

	handle_equip_gear(H, picked_spawner)

	if(picked_spawner.roundstart_damage_max > 0)
		if(istype(picked_spawner) && picked_spawner.roundstart_damage_max > 0)
			for(var/i in 0 to picked_spawner.roundstart_damage_times)
			H.take_limb_damage(rand(picked_spawner.roundstart_damage_min, picked_spawner.roundstart_damage_max), 0)

	H.name = H.get_visible_name()

	if(length(picked_spawner.intro_text))
		intro_text = picked_spawner.intro_text

	if(picked_spawner.story_text)
		story_text = picked_spawner.story_text

	if(picked_spawner.hostile)
		hostile = TRUE

	new /datum/cm_objective/move_mob/almayer/survivor(H)

/datum/job/civilian/survivor/generate_entry_message(mob/living/carbon/human/survivor)
	if(intro_text)
		for(var/line in intro_text)
			to_chat(survivor, line)
	else
		to_chat(survivor, "<h2>Вы - выживший!</h2>")	// SS220 EDIT TRANSLATE
		to_chat(survivor, SPAN_NOTICE(SSmapping.configs[GROUND_MAP].survivor_message))
		to_chat(survivor, SPAN_NOTICE("Вы полностью осознаете угрозу ксеноморфов и можете использовать эти знания по своему усмотрению."))
		to_chat(survivor, SPAN_NOTICE("Вы НЕ знаете о морпехах и их намерениях."))

	if(story_text)
		to_chat(survivor, story_text)
		survivor.mind.memory += story_text
	else
		tell_survivor_story(survivor)

	if(hostile)
		to_chat(survivor, SPAN_HIGHDANGER("Вы ВРАЖДЕБНЫ к ККМП!"))	// SS220 EDIT TRANSLATE
	else if(survivor.faction == FACTION_CLF)
		to_chat(survivor, SPAN_HIGHDANGER("Вы ВРАЖДЕБНЫ к ККМП, но НЕ к другим выжившим!"))
	else
		to_chat(survivor, SPAN_XENOHIGHDANGER("Вы НЕ ВРАЖДЕБНЫ к ККМП!"))

/datum/job/civilian/survivor/proc/tell_survivor_story(mob/living/carbon/human/H)	// SS220 EDIT TRANSLATE
	var/list/survivor_story = list(
								"Вы наблюдали, как личинка вырвалась из груди вашего друга, {name}. Вы пытались поймать инопланетное существо, но оно сбежало через вентиляцию.",
								"{name} подвергся нападению инопланетянина, который оплодотворил его инопланетной формой жизни. Грудь {name} взорвалась с брызгами крови, когда какое-то существо сбежало.",
								"Вы с ужасом наблюдали, как кислота инопланетной формы жизни попала на кожу {name}, расплавив его плоть. Вы все еще можете слышать эти крики и панику.",
								"Маршал колонии, {name}, сделал заявление о том, что враждебные формы жизни убили многих, и что все должны прятаться или оставаться за закрытыми дверями.",
								"Вы были там, когда инопланетные формы жизни ворвались в столовую и утащили остальных. Это было ужасное зрелище, и с тех пор вы старались избегать больших открытых пространств.",
								"Это было ужасно, когда вы наблюдали, как вашего друга, {name}, терзают ужасные монстры. Их крики агонии преследуют вас во сне, что приводит к бессонница.",
								"Вы изо всех сил старались спрятаться и видели, как существа путешествуют по подземным туннелям и вентиляционным шахтам. Кажется, им нравится темнота.",
								"Когда вы проснулись, у вас было такое чувство, будто вы спали много лет. Вы не помните ничего о своей прежней жизни, кроме, может быть, своего имени. Что, черт возьми, с вами произошло?",
								"Вы были на передовой, пытаясь сражаться с инопланетянами. Вы видели, как они вылупляли больше монстров из других людей, и вы знаете, что лучше не бороться со смертью.",
								"Вы нашли что-то, что-то невероятное. Но ваше открытие было прервано, когда появились монстры и начали забирать людей. Черт побери, звери!",
								"{имя} защитил вас, когда пришли инопланетяне. Вы не знаете, что с ними случилось, но это было некоторое время назад, и с тех пор вы их не видели. Может, они живы."
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
	var/temp_story = "<b>Ваша история на данный момент</b>: " + replacetext(pick(survivor_story), "{name}", "[random_name]")	// SS220 EDIT TRANSLATE
	to_chat(H, temp_story)
	H.mind.memory += temp_story

	return TRUE

/datum/job/civilian/survivor/proc/handle_equip_gear(mob/living/carbon/human/equipping_human, obj/effect/landmark/survivor_spawner/picked_spawner)
	if(picked_spawner.equipment)
		arm_equipment(equipping_human, picked_spawner.equipment, FALSE, TRUE)
	else
		var/preferred_variant = ANY_SURVIVOR
		if(equipping_human.client?.prefs?.pref_special_job_options[JOB_SURVIVOR] != ANY_SURVIVOR)
			preferred_variant = equipping_human.client?.prefs?.pref_special_job_options[JOB_SURVIVOR]
			if(MAX_SURVIVOR_PER_TYPE[preferred_variant] != -1 && SSticker.mode.survivors_by_type_amounts[preferred_variant] && SSticker.mode.survivors_by_type_amounts[preferred_variant] >= MAX_SURVIVOR_PER_TYPE[preferred_variant])
				preferred_variant = ANY_SURVIVOR

		var/list/survivor_types = preferred_variant != ANY_SURVIVOR && length(SSmapping.configs[GROUND_MAP].survivor_types_by_variant[preferred_variant]) ? SSmapping.configs[GROUND_MAP].survivor_types_by_variant[preferred_variant] : SSmapping.configs[GROUND_MAP].survivor_types
		arm_equipment(equipping_human, pick(survivor_types), FALSE, TRUE)

		SSticker.mode.survivors_by_type_amounts[preferred_variant] += 1

AddTimelock(/datum/job/civilian/survivor, list(
	JOB_SQUAD_ROLES = 5 HOURS,
	JOB_ENGINEER_ROLES = 5 HOURS,
	JOB_MEDIC_ROLES = 5 HOURS
))

/datum/job/civilian/survivor/synth
	title = JOB_SYNTH_SURVIVOR
	selection_class = "job_synth"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_SYNTHETIC
	total_positions = 1
	spawn_positions = 1
	job_options = null

/datum/job/civilian/survivor/synth/set_spawn_positions(count)
	return spawn_positions

/datum/job/civilian/survivor/synth/handle_equip_gear(mob/living/carbon/human/equipping_human, obj/effect/landmark/survivor_spawner/picked_spawner)
	if(picked_spawner.synth_equipment)
		arm_equipment(equipping_human, picked_spawner.synth_equipment, FALSE, TRUE)
	else
		var/preferred_variant = ANY_SURVIVOR
		if(equipping_human.client?.prefs?.pref_special_job_options[JOB_SURVIVOR] != ANY_SURVIVOR)
			preferred_variant = equipping_human.client?.prefs?.pref_special_job_options[JOB_SURVIVOR]
			if(MAX_SURVIVOR_PER_TYPE[preferred_variant] != -1 && SSticker.mode.survivors_by_type_amounts[preferred_variant] && SSticker.mode.survivors_by_type_amounts[preferred_variant] >= MAX_SURVIVOR_PER_TYPE[preferred_variant])
				preferred_variant = ANY_SURVIVOR

		var/list/synth_survivor_types = preferred_variant != ANY_SURVIVOR && length(SSmapping.configs[GROUND_MAP].synth_survivor_types_by_variant[preferred_variant]) ? SSmapping.configs[GROUND_MAP].synth_survivor_types_by_variant[preferred_variant] : SSmapping.configs[GROUND_MAP].synth_survivor_types
		arm_equipment(equipping_human, pick(synth_survivor_types), FALSE, TRUE)

		SSticker.mode.survivors_by_type_amounts[preferred_variant] += 1

/datum/job/civilian/survivor/commanding_officer
	title = JOB_CO_SURVIVOR
	selection_class = "job_co"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_COMMANDER
	total_positions = 0
	spawn_positions = 0
	job_options = null

/datum/job/civilian/survivor/commanding_officer/set_spawn_positions()
	var/list/CO_survivor_types = SSmapping.configs[GROUND_MAP].CO_survivor_types
	if(length(CO_survivor_types))
		total_positions = 1
		spawn_positions = 1
	return spawn_positions

/datum/job/civilian/survivor/commanding_officer/handle_equip_gear(mob/living/carbon/human/equipping_human, obj/effect/landmark/survivor_spawner/picked_spawner)
	if(picked_spawner.CO_equipment)
		arm_equipment(equipping_human, picked_spawner.CO_equipment, FALSE, TRUE)
		return
	else
		var/list/CO_survivor_types = SSmapping.configs[GROUND_MAP].CO_survivor_types
		arm_equipment(equipping_human, pick(CO_survivor_types), FALSE, TRUE)
		return
