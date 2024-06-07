// Datum for handling bug reports, giving Harry the motivation to set up the config to get this functional.

/datum/tgui_bug_report_form
	// contains all the body text for the bug report.
	var/list/bug_report_data = null

	// user making the bug report
	var/mob/user = null

/datum/tgui_bug_report_form/New(mob/user)
	// we should also test if the api is functional here, once the maintainers get the api is token.
	if(!user.client) // nope.
		external_link_prompt()
		qdel(src)
	src.user = user

/datum/tgui_bug_report_form/proc/external_link_prompt()
	tgui_alert(user, "Unable to create a bug report at this time, please create the issue directly through our GitHub repository instead")

	if(tgui_alert(user, "This will open the GitHub in your browser. Are you sure?", "Confirm", list("Yes", "No")) == "Yes")
		user << link(CONFIG_GET(string/githuburl))

/datum/tgui_bug_report_form/ui_state()
	return GLOB.always_state

/datum/tgui_bug_report_form/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BugReportForm")
		ui.open()

/datum/tgui_bug_report_form/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tgui_bug_report_form/proc/submit_form()
	return TRUE
	/*var/desc = {"

		### Testmerges
		blah blah

		### Round ID
		[GLOB.round_id]

		### Description of the bug
		[bug_report_data["description"]]

		### What's the difference with what should have happened?
		[bug_report_data["expected_behavior"]]

		### How do we reproduce this bug?
		[bug_report_data["steps"]]

	"}

	// rustg export, copy pasta from goon
	var/api_response = some_proc("issue", list(
		"title" = data["title"],
		"body" = desc,
	))
	//
	if(api_message != some_success_response)
		tgui_alert(user, "There has been an issue with reporting your bug, please try again later!", "Issue not reported!")
		return FALSE
	return TRUE
	*/
/datum/tgui_bug_report_form/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if (.)
		return
	var/mob/user = ui.user
	switch(action)
		if("confirm")
			bug_report_data = params
			ui_close(src)
			if(!submit_form())
				message_admins("[user.key] has attempted to submit a bug report at [worldtime2text()].")
				external_link_prompt()
			to_chat(user, SPAN_WARNING("Bug report has successfully been submitted, thank you!"))
			message_admins("[user.key] has submitted a bug report at [worldtime2text()].")
		if("cancel")
			ui_close(src)
	. = TRUE
