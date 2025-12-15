SUBSYSTEM_DEF(polls)
	name = "Polls"
	flags = SS_NO_FIRE

	/// Stores the polls that have not expired, and set as active
	var/list/datum/poll/active_polls

	/// Stores the polls that have expired, and set as active
	var/list/datum/poll/concluded_polls

	/// For storing messages to remind people to vote, that we do not want to get lost in the mess of a server starting
	VAR_PRIVATE/list/datum/callback/to_send_at_lobby = list()

/datum/controller/subsystem/polls/Initialize()
	setup_polls()

	for(var/id in active_polls)
		var/list/datum/view_record/player_poll_vote/votes = DB_VIEW(
			/datum/view_record/player_poll_vote,
			DB_COMP("polL_id", DB_EQUALS, id)
		)

		var/voted_ids = list()
		for(var/datum/view_record/player_poll_vote/vote as anything in votes)
			voted_ids += "[vote.player_id]"

		var/datum/poll/active_poll = active_polls[id]

		for(var/client/client as anything in GLOB.clients)
			if(client.player_data.id in voted_ids)
				continue

			to_send_at_lobby += CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), client, SPAN_LARGE("You have not voted in the '[active_poll.question]' poll. Click <a href='byond://?src=\ref[client.mob];poll=1'>here</a> to vote."))

	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PREGAME_LOBBY, PROC_REF(handle_lobby))
	RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_LOGGED_IN, PROC_REF(handle_new_user))

	return SS_INIT_SUCCESS

/// Clear and populate the poll lists with fresh data
/datum/controller/subsystem/polls/proc/setup_polls()
	active_polls = list()

	var/list/datum/view_record/poll/all_active_polls = DB_VIEW(
		/datum/view_record/poll,
		DB_AND(
			DB_COMP("active", DB_EQUALS, TRUE),
			DB_COMP("expiry", DB_GREATER_EQUAL, time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"))
		)
	)

	for(var/datum/view_record/poll/poll as anything in all_active_polls)
		var/datum/poll/new_poll = new(poll.question, poll.expiry)

		var/list/datum/view_record/poll_answer/poll_answers = DB_VIEW(
			/datum/view_record/poll_answer,
			DB_COMP("poll_id", DB_EQUALS, poll.id)
		)

		for(var/datum/view_record/poll_answer/answer as anything in poll_answers)
			new_poll.answers["[answer.id]"] = answer.answer

		active_polls["[poll.id]"] = new_poll

	concluded_polls = list()

	var/list/datum/view_record/poll/all_concluded_polls = DB_VIEW(
		/datum/view_record/poll,
		DB_AND(
			DB_COMP("active", DB_EQUALS, TRUE),
			DB_COMP("expiry", DB_LESS, time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"))
		)
	)

	for(var/datum/view_record/poll/poll as anything in all_concluded_polls)
		var/datum/poll/concluded/concluded_poll = new(poll.question)

		var/list/datum/view_record/poll_answer/poll_answers = DB_VIEW(
			/datum/view_record/poll_answer,
			DB_COMP("poll_id", DB_EQUALS, poll.id)
		)

		for(var/datum/view_record/poll_answer/answer as anything in poll_answers)
			var/total = length(DB_VIEW(/datum/view_record/player_poll_vote, DB_COMP("answer_id", DB_EQUALS, answer.id)))

			concluded_poll.answer_totals[answer.answer] = total

		concluded_polls["[poll.id]"] = concluded_poll

	update_static_data_for_all_viewers()

/// Sends all the queued messages when we enter the
/// lobby mode, so the messages do not get lost
/datum/controller/subsystem/polls/proc/handle_lobby(source)
	SIGNAL_HANDLER

	for(var/datum/callback/callback as anything in to_send_at_lobby)
		callback.InvokeAsync()

/datum/controller/subsystem/polls/proc/handle_new_user(source, client/new_client)
	SIGNAL_HANDLER

	remind_new_user(new_client)

/// Reminds new users logging in of any uncompleted polls.
/datum/controller/subsystem/polls/proc/remind_new_user(client/new_client)
	set waitfor = FALSE

	UNTIL(new_client.player_data)

	for(var/id in active_polls)
		var/voted = length(DB_VIEW(
			/datum/view_record/player_poll_vote,
			DB_AND(
				DB_COMP("player_id", DB_EQUALS, new_client.player_data.id),
				DB_COMP("poll_id", DB_EQUALS, id)
			)
		))

		if(voted)
			continue

		var/datum/poll/active_poll = active_polls[id]

		to_chat(new_client, SPAN_LARGE("You have not voted in the '[active_poll.question]' poll. Click <a href='byond://?src=\ref[new_client.mob];poll=1'>here</a> to vote."))

/datum/controller/subsystem/polls/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Poll", name)
		ui.open()

/datum/controller/subsystem/polls/ui_static_data(mob/user)
	. = ..()

	.["polls"] = list()
	for(var/id in active_polls)
		var/datum/poll/poll = active_polls[id]
		.["polls"] += list(
			list("id" = id, "question" = poll.question, "answers" = poll.answers, "expiry" = poll.expiry)
		)

	.["concluded_polls"] = list()
	for(var/id in concluded_polls)
		var/datum/poll/concluded/concluded = concluded_polls[id]
		.["concluded_polls"] += list(
			list("id" = id, "question" = concluded.question, "answers" = concluded.answer_totals)
		)

	.["is_poll_maker"] = CLIENT_HAS_RIGHTS(user.client, R_PERMISSIONS)

/datum/controller/subsystem/polls/ui_data(mob/user)
	. = ..()

	var/datum/entity/player/player = user.client?.player_data
	if(!player)
		return

	.["voted_polls"] = list()
	for(var/datum/view_record/player_poll_vote/answer in DB_VIEW(/datum/view_record/player_poll_vote, DB_COMP("player_id", DB_EQUALS, player.id)))
		.["voted_polls"] += answer.answer_id

/datum/controller/subsystem/polls/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/entity/player/player = ui.user.client?.player_data
	if(!player)
		return

	switch(action)
		if("vote")
			var/voting_in = params["poll_id"]

			if(!isnum(text2num(voting_in)))
				return

			var/datum/poll/selected_poll = active_polls[voting_in]
			if(!selected_poll)
				return

			var/selected_answer = params["answer_id"]
			if(!isnum(text2num(selected_answer)) || !selected_poll.answers[selected_answer])
				return

			var/list/datum/view_record/player_poll_vote/existing_votes = DB_VIEW(
				/datum/view_record/player_poll_vote,
				DB_AND(
					DB_COMP("player_id", DB_EQUALS, player.id),
					DB_COMP("poll_id", DB_EQUALS, text2num(voting_in))
				)
			)

			if(length(existing_votes))
				if(tgui_alert(ui.user, "Change existing vote?", "Change Vote", list("Yes", "No")) != "Yes")
					return

				for(var/datum/view_record/player_poll_vote/existing_vote as anything in existing_votes)
					var/datum/entity/player_poll_vote/vote = DB_ENTITY(/datum/entity/player_poll_vote, existing_vote.id)
					vote.sync()

					vote.answer_id = text2num(selected_answer)
					vote.save()
				return

			var/datum/entity/player_poll_vote/vote = DB_ENTITY(/datum/entity/player_poll_vote)
			vote.player_id = player.id
			vote.answer_id = text2num(selected_answer)
			vote.poll_id = text2num(voting_in)
			vote.save()
			vote.detach()

		if("create")
			if(!CLIENT_HAS_RIGHTS(ui.user.client, R_PERMISSIONS))
				return

			var/poll_question = tgui_input_text(ui.user, "What's the question?", "Poll Question", encode = FALSE)
			if(!poll_question)
				return

			var/list/answers = list()

			var/answers_to_add = tgui_input_text(ui.user, "What answers should be added? Separate answers with ;", "Poll Answers", encode = FALSE, multiline = TRUE)
			if(!answers_to_add)
				return

			answers = splittext(answers_to_add, ";")

			if(length(answers) <= 1)
				to_chat(ui.user, SPAN_WARNING("Poll creation cancelled - not enough added."))
				return

			var/expiry = tgui_input_number(ui.user, "How many days should this poll run for?", "Poll Length", 14)
			if(!expiry || expiry <= 0)
				return

			if(tgui_alert(ui.user, "Confirm creating poll with question: '[poll_question]', answers: [english_list(answers)] and duration: [expiry] days.", "BuildAPoll", list("Confirm", "Cancel")) != "Confirm")
				return

			var/datum/entity/poll/poll = DB_ENTITY(/datum/entity/poll)
			poll.active = TRUE
			poll.question = poll_question
			poll.expiry = time2text(world.realtime + (expiry * 24 HOURS), "YYYY-MM-DD hh:mm:ss")
			poll.save()
			poll.sync()

			for(var/answer in answers)
				var/datum/entity/poll_answer/new_answer = DB_ENTITY(/datum/entity/poll_answer)
				new_answer.answer = answer // ...
				new_answer.poll_id = poll.id
				new_answer.save()
				new_answer.sync()

			to_chat(ui.user, SPAN_ALERT("Poll '[poll_question]' created successfully."))
			setup_polls()

		if("delete")
			if(!CLIENT_HAS_RIGHTS(ui.user.client, R_PERMISSIONS))
				return

			var/to_delete = params["poll_id"]
			if(!isnum(text2num(to_delete)))
				return

			var/datum/poll/delete_poll = active_polls[to_delete]
			if(!delete_poll)
				delete_poll = concluded_polls[to_delete]

			if(!delete_poll)
				return

			if(tgui_alert(ui.user, "Confirm deletion of \"[delete_poll.question]\"?", "Delete Poll", list("Confirm", "Cancel")) != "Confirm")
				return

			var/datum/entity/poll/poll = DB_ENTITY(/datum/entity/poll, text2num(to_delete))
			poll.sync()

			poll.active = FALSE
			poll.save()
			poll.sync()

			to_chat(ui.user, SPAN_ALERT("Poll deleted."))

			setup_polls()

		if("edit-title")
			if(!CLIENT_HAS_RIGHTS(ui.user.client, R_PERMISSIONS))
				return

			var/to_edit = params["poll_id"]
			if(!isnum(text2num(to_edit)))
				return

			var/datum/poll/edit_poll = active_polls[to_edit]
			if(!edit_poll)
				return

			var/new_question = params["question"]
			if(!length(new_question))
				return

			var/datum/entity/poll/poll = DB_ENTITY(/datum/entity/poll, text2num(to_edit))
			poll.sync()

			poll.question = new_question
			poll.save()
			poll.sync()

			to_chat(ui.user, SPAN_ALERT("Question updated to [new_question]."))

			edit_poll.question = new_question

		if("add-answer")
			if(!CLIENT_HAS_RIGHTS(ui.user.client, R_PERMISSIONS))
				return

			var/to_edit = params["poll_id"]
			if(!isnum(text2num(to_edit)))
				return

			var/datum/poll/edit_poll = active_polls[to_edit]
			if(!edit_poll)
				return

			var/answer = tgui_input_text(ui.user, "What's the new answer?", "New Answer")
			if(!length(answer))
				return

			var/datum/entity/poll_answer/new_answer = DB_ENTITY(/datum/entity/poll_answer)
			new_answer.answer = answer
			new_answer.poll_id = text2num(to_edit)
			new_answer.save()
			new_answer.sync()

			setup_polls()

			to_chat(ui.user, SPAN_ALERT("New answer ([answer]) added to poll \"[edit_poll.question]\"."))

		if("edit-time")
			if(!CLIENT_HAS_RIGHTS(ui.user.client, R_PERMISSIONS))
				return

			var/to_edit = params["poll_id"]
			if(!isnum(text2num(to_edit)))
				return

			var/datum/poll/edit_poll = active_polls[to_edit]
			if(!edit_poll)
				return

			var/time
			var/alert = tgui_alert(ui.user, "Conclude now, or specify a time?", "Time Picker", list("Now", "Custom Time"))

			switch(alert)
				if("Now")
					time = time2text(world.realtime - 1 SECONDS, "YYYY-MM-DD hh:mm:ss")

				if("Custom Time")
					var/hours = tgui_input_number(ui.user, "Conclude in how many hours?", "Time Picker", 24, 1000, 1)
					time = time2text(world.realtime + (hours * 1 HOURS), "YYYY-MM-DD hh:mm:ss")

			if(!time)
				return

			var/datum/entity/poll/poll = DB_ENTITY(/datum/entity/poll, text2num(to_edit))
			poll.sync()

			poll.expiry = time
			poll.save()
			poll.sync()

			to_chat(ui.user, SPAN_ALERT("Time updated to [time]."))
			setup_polls()

	return TRUE

/datum/controller/subsystem/polls/ui_state(mob/user)
	return GLOB.always_state

/datum/poll
	var/question
	var/expiry
	var/list/answers = list()

/datum/poll/New(question, expiry)
	src.question = question
	src.expiry = expiry

/datum/poll/concluded
	var/answer_totals = list()

/datum/entity/poll
	var/question
	var/active
	var/expiry

/datum/entity_meta/poll
	entity_type = /datum/entity/poll
	table_name = "polls"
	field_types = list(
		"question" = DB_FIELDTYPE_STRING_LARGE,
		"active" = DB_FIELDTYPE_INT,
		"expiry" = DB_FIELDTYPE_DATE,
	)

/datum/view_record/poll
	var/id
	var/question
	var/active
	var/expiry

/datum/entity_view_meta/poll
	root_record_type = /datum/entity/poll
	destination_entity = /datum/view_record/poll
	fields = list(
		"id",
		"question",
		"active",
		"expiry",
	)

/datum/entity/poll_answer
	var/poll_id
	var/answer

/datum/entity_meta/poll_answer
	entity_type = /datum/entity/poll_answer
	table_name = "poll_answers"
	field_types = list(
		"poll_id" = DB_FIELDTYPE_BIGINT,
		"answer" = DB_FIELDTYPE_STRING_LARGE,
	)

/datum/view_record/poll_answer
	var/id
	var/poll_id
	var/answer

/datum/entity_view_meta/poll_answer
	root_record_type = /datum/entity/poll_answer
	destination_entity = /datum/view_record/poll_answer
	fields = list(
		"id",
		"poll_id",
		"answer",
	)

/datum/entity/player_poll_vote
	var/player_id
	var/poll_id
	var/answer_id

/datum/entity_meta/player_poll_vote
	entity_type = /datum/entity/player_poll_vote
	table_name = "player_poll_votes"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"poll_id" = DB_FIELDTYPE_BIGINT,
		"answer_id" = DB_FIELDTYPE_BIGINT,
	)

/datum/view_record/player_poll_vote
	var/id
	var/player_id
	var/poll_id
	var/answer_id

/datum/entity_view_meta/player_poll_vote
	root_record_type = /datum/entity/player_poll_vote
	destination_entity = /datum/view_record/player_poll_vote
	fields = list(
		"id",
		"player_id",
		"poll_id",
		"answer_id",
	)
