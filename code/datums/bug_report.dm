// Datum for handling bug reports, giving Harry the motivation to set up the config to get this functional.

/datum/tgui_bug_report_form
	// contains all the body text for the bug report.
	var/list/bug_report_data = null

	// client of user who created the initial report
	var/client/initial_user = null

	// value to determine if the bug report is submitted and awaiting admin approval, used for state purposes in tgui.
	var/awaiting_admin_approval = FALSE

/datum/tgui_bug_report_form/New(mob/user)
	// we should also test if the api is functional here, once the maintainers get the api is token.
	if(!user.client) // nope.
		qdel(src)
		return
	initial_user = user.client

/datum/tgui_bug_report_form/proc/external_link_prompt()
	tgui_alert(initial_user, "Unable to create a bug report at this time, please create the issue directly through our GitHub repository instead")

	if(tgui_alert(initial_user, "This will open the GitHub in your browser. Are you sure?", "Confirm", list("Yes", "No")) == "Yes")
		initial_user << link(CONFIG_GET(string/githuburl))

/datum/tgui_bug_report_form/ui_state()
	return GLOB.always_state

/datum/tgui_bug_report_form/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BugReportForm")
		ui.open()

/datum/tgui_bug_report_form/ui_close(mob/user)
	. = ..()

// used by the admin to create the issue via the github api.
/datum/tgui_bug_report_form/proc/submit_form(mob/ui_user)
	if(awaiting_admin_approval) // already submitted, and is approved by an admin
		if(!CLIENT_IS_STAFF(ui_user.client))
			return

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
		message_admins("[ui_user.key] has approved a bug report from [initial_user.ckey] titled [bug_report_data["title"]] at [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")].")
		qdel(src) // approved and submitted, we no longer need the datum.

// proc that creates a ticket for an admin to approve or deny a bug report request
/datum/tgui_bug_report_form/proc/bug_report_request()
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
				submit_form()

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
	if(!CLIENT_IS_STAFF(user.client))
		return
	message_admins("[user.key] has rejected a bug report from [initial_user.ckey] titled [bug_report_data["title"]] at [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")].")
	GLOB.bug_reports -= src
	qdel(src)
