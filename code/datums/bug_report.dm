// Datum for handling bug reports, giving Harry the motivation to set up the config to get this functional.

/datum/tgui_bug_report_form
	// contains all the body text for the bug report.
	var/list/bug_report_data = null

	// client of user who created the initial report
	var/client/initial_user = null

	// value to determine if the bug report is submitted and awaiting admin approval, used for state purposes in tgui.
	var/awaiting_admin_approval = FALSE

/datum/tgui_bug_report_form/New(mob/user)
	if(!user.client) // nope.
		qdel(src)
		return
	initial_user = user.client

/datum/tgui_bug_report_form/proc/external_link_prompt(user)
	tgui_alert(initial_user, "Unable to create a bug report at this time, please create the issue directly through our GitHub repository instead")
	var/url = CONFIG_GET(string/githuburl)

	if(!url)
		to_chat(user, SPAN_WARNING("The configuration is not properly set, unable to open external link"))
		return

	if(tgui_alert(initial_user, "This will open the GitHub in your browser. Are you sure?", "Confirm", list("Yes", "No")) == "Yes")
		initial_user << link(url)

/datum/tgui_bug_report_form/ui_state()
	return GLOB.always_state

/datum/tgui_bug_report_form/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BugReportForm")
		ui.open()

/datum/tgui_bug_report_form/ui_close(mob/user)
	. = ..()

/datum/tgui_bug_report_form/Destroy()
	GLOB.bug_reports -= src
	return ..()

// returns the body payload
/datum/tgui_bug_report_form/proc/create_form()
	var/list/testmerges = world.TgsTestMerges()
	var/text_output_tm = ""
	for(var/tm in testmerges)
		text_output_tm += "[tm]"

	var/desc = {"
### Testmerges
[text_output_tm]

### Round ID
[GLOB.round_id]

### Description of the bug
[bug_report_data["description"]]

### What's the difference with what should have happened?
[bug_report_data["expected_behavior"]]

### How do we reproduce this bug?
[bug_report_data["steps"]]
	"}

	return desc

// the real deal, we are sending the request through the api.
/datum/tgui_bug_report_form/proc/send_request(payload_body, mob/user)
	var/repo_name = CONFIG_GET(string/repo_name)
	var/org = CONFIG_GET(string/org)
	var/token = CONFIG_GET(string/github_app_api)

	if(!token || !org || !repo_name)
		tgui_alert(user, "The configuration is not set for the external api", "Issue not reported!")
		external_link_prompt(user)
		qdel(src)
		return

	var/url = "https://api.github.com/repos/[org]/[repo_name]/issues"
	var/list/headers = list()

	headers["Authorization"] = "Bearer [token]"
	headers["Content-Type"] = "text/markdown; charset=utf-8"
	headers["Accept"] = "application/vnd.github+json"

	var/datum/http_request/request = new

	var/list/payload = list(
		"title" = bug_report_data["title"],
		"body" = payload_body,
	)

	request.prepare(RUSTG_HTTP_METHOD_POST, url, json_encode(payload), headers)
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()

	if(response.errored)
		tgui_alert(user, "There has been an issue with reporting your bug, please try again later!", "Issue not reported!")
		external_link_prompt(user)
	else
		message_admins("[user.key] has approved a bug report from [initial_user.ckey] titled [bug_report_data["title"]] at [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")].")

	qdel(src)// approved and submitted, we no longer need the datum.

// proc that creates a ticket for an admin to approve or deny a bug report request
/datum/tgui_bug_report_form/proc/bug_report_request()
	to_chat(initial_user, SPAN_WARNING("Your bug report has been submitted, thank you!"))

	GLOB.bug_reports += src
	var/general_message = "[initial_user.ckey] has created a bug report, you may modify the report to your liking before submitting it to Github"
	GLOB.admin_help_ui_handler.perform_adminhelp(initial_user, general_message, urgent = FALSE)
	var/href_message = ADMIN_VIEW_BUG_REPORT(src)
	initial_user.current_ticket.AddInteraction(href_message)

/datum/tgui_bug_report_form/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if (.)
		return
	var/mob/user = ui.user
	switch(action)
		if("confirm")
			bug_report_data = params
			ui.close()
			// bug report request is now waiting for admin approval
			if(!awaiting_admin_approval)
				bug_report_request()
				awaiting_admin_approval = TRUE
			else // otherwise it's been approved
				if(!CLIENT_IS_STAFF(user.client))
					return
				var/payload_body = create_form()
				send_request(payload_body, user)
		if("cancel")
			ui.close()
			if(awaiting_admin_approval) // admin has chosen to reject the bug report
				reject(user)
	. = TRUE

/datum/tgui_bug_report_form/ui_data(mob/user)
	. = list()
	.["report_details"] = bug_report_data // only filled out once the user as submitted the form
	.["awaiting_admin_approval"] = awaiting_admin_approval

/datum/tgui_bug_report_form/proc/reject(mob/user)
	message_admins("[user.key] has rejected a bug report from [initial_user.ckey] titled [bug_report_data["title"]] at [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")].")
	qdel(src)
