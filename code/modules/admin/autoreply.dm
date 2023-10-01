GLOBAL_REFERENCE_LIST_INDEXED(adminreplies, /datum/autoreply/admin, title)

/datum/autoreply
	/// What shows up in the list of replies, and the big red header on the reply itself.
	var/title = "Blank"
	/// The detailed message in the auto reply.
	var/message = "Lorem ipsum dolor sit amit."
	/// If the autoreply will automatically close the ahelp or not.
	var/closer = TRUE

/// Admin Replies
/datum/autoreply/admin/handled
	title = "Being Handled"
	message = "Staff are aware of this issue and it is being handled"
	closer = FALSE

/datum/autoreply/admin/icissue
	title = "IC Issue"
	message = "Your issue has been determined by an administrator to be an in character issue and does NOT require administrator intervention at this time. For further resolution you should pursue options that are in character."

/datum/autoreply/admin/bug
	title = "Bug Report"

ON_CONFIG_LOAD(/datum/autoreply/admin/bug)
	message = "Please report all bugs on our <a href='[CONFIG_GET(string/githuburl)]'>Github</a>. Administrative staff are unable to fix most bugs on a round to round basis and only round critical bugs, or exploits, should be ahelped."

/datum/autoreply/admin/marine
	title = "Marine Guide"

ON_CONFIG_LOAD(/datum/autoreply/admin/marine)
	message = "Your action can be answered by the <a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_MARINE_QUICKSTART]'>Marine Quickstart Guide</a>. If anything is unclear or you have another question please make a new mentorhelp or ahelp about it."

/datum/autoreply/admin/xeno
	title = "Xeno Guide"

ON_CONFIG_LOAD(/datum/autoreply/admin/xeno)
	message = "Your action can be answered by the <a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_XENO_QUICKSTART]'>Xeno Quickstart Guide</a>. If anything is unclear or you have another question please make a new mentorhelp or ahelp about it."

/datum/autoreply/admin/changelog
	title = "Changelog"
	message = "The answer to your question can be found in the Changelog. Click the changelog button at the top-right of the screen to view it in-game, alternatively go the the CM-SS13 discord server where you can look at the cm-changelog channel to find links to any merged changes to the server."

/datum/autoreply/admin/intended
	title = "Intended"
	message = "This is an intended feature and therefore does not need admin intervention."

/datum/autoreply/admin/event
	title = "Event"
	message = "There is currently a special event running and many things may be changed or different, however normal rules still apply unless you have been specifically instructed otherwise by a staff member."

/datum/autoreply/admin/whitelist
	title = "Whitelist Issue"

ON_CONFIG_LOAD(/datum/autoreply/admin/whitelist)
	message = "Staff are unable to handle most whitelist rulebreaks in-game, please make a player report on the forums, <a href='[CONFIG_GET(string/playerreport)]'>here</a>."
