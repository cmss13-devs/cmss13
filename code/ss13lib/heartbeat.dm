/// Sends the regular heartbeat to the hub, which will ping back with a Topic query
/datum/ss13lib/proc/perform_heartbeat()
	var/datum/ss13lib_http_response/response = perform_http_request(SS13LIB_HTTP_GET, "[SS13LIB_HUB_SERVER]/heartbeat?port=[SS13LIB_SERVER_PORT]")
	if(response.errored)
		return
	if(response.status_code == 209)
		if(!blacklist_warned)
			blacklist_warned = TRUE
			SS13LIB_WARNING_LOG("This server is currently hidden from the hub listing due to a content policy violation.")
#ifdef SS13LIB_MESSAGE_ADMINS
			SS13LIB_MESSAGE_ADMINS("SS13Hub: This server is currently hidden from the hub listing due to a content policy violation.")
#endif
	else if(blacklist_warned)
		blacklist_warned = FALSE
		SS13LIB_INFO_LOG("This server is now visible on the hub listing.")

	if(!response.body)
		return

	var/body
	try
		body = json_decode(response.body)
	catch
		return

	if(!islist(body))
		return

	var/list/announcements = body["announcements"]
	if(!islist(announcements) || !length(announcements))
		return

	for(var/list/announcement in announcements)
		var/id = announcement["id"]
		if(!id)
			continue
		if(id in seen_announcement_ids)
			continue
		seen_announcement_ids += id
		on_hub_announcement(id, announcement["title"], announcement["body"], announcement["kind"])

/// Called when a new hub announcement is received. Override this in your codebase
/// to display announcements to server operators.
/datum/ss13lib/proc/on_hub_announcement(id, title, body, kind)
#ifdef SS13LIB_MESSAGE_ADMINS
	SS13LIB_MESSAGE_ADMINS("SS13Hub Announcement: [title]")
#endif
	SS13LIB_INFO_LOG("Hub announcement ([kind]): [title] - [body]")
