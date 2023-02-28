GLOBAL_REFERENCE_LIST_INDEXED(adminreplies, /datum/autoreply/admin, title)

/datum/autoreply
	var/title = "Blank"
	var/message = "Lorem ipsum dolor sit amit."
	var/closer = TRUE

/// Admin Replies
/datum/autoreply/admin/icissue
	title = "IC Issue"
	message = "Your issue has been determined by an administrator to be an in character issue and does NOT require administrator intervention at this time. For further resolution you should pursue options that are in character."

/datum/autoreply/admin/bug
	title = "Bug Report"
	message = "Please report all bugs on our Github. Administrative staff are unable to fix most bugs on a round to round basis and only round critical bugs, or exploits, should be ahelped."
