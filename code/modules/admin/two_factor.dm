/datum/entity/twofactor_request
	var/ip
	var/cid
	var/ckey

	var/approved

/datum/entity/twofactor_request/New(ip, cid, ckey)
	src.ip = ip
	src.cid = cid
	src.ckey = ckey

/datum/entity_meta/twofactor_request
	entity_type = /datum/entity/twofactor_request
	table_name = "twofactor"
	field_types = list(
		"ip" = DB_FIELDTYPE_STRING_MEDIUM,
		"cid" = DB_FIELDTYPE_STRING_MEDIUM,
		"ckey" = DB_FIELDTYPE_STRING_LARGE,
		"approved" = DB_FIELDTYPE_INT,
	)

/datum/view_record/twofactor_request
	var/ip
	var/cid
	var/ckey

	var/approved

/datum/entity_view_meta/twofactor_request
	root_record_type = /datum/entity/twofactor_request
	destination_entity = /datum/view_record/twofactor_request
	fields = list(
		"ip",
		"cid",
		"ckey",
		"approved"
	)

/proc/check_or_create_twofactor_request(client/user)
	var/url = CONFIG_GET(string/twofactor_admins_url)
	if(!url)
		return TRUE

	var/datum/view_record/twofactor_request/twofactor_view = locate() in DB_VIEW(
		/datum/view_record/twofactor_request,
		DB_AND(
			DB_COMP("ip", DB_EQUALS, user.address),
			DB_COMP("cid", DB_EQUALS, user.computer_id),
			DB_COMP("ckey", DB_EQUALS, user.ckey),
		)
	)

	if(twofactor_view.approved)
		return TRUE
	else if(twofactor_view)
		return FALSE

	var/datum/entity/twofactor_request/twofactor_request = new(user.address, user.computer_id, user.ckey)
	twofactor_request.save()
	twofactor_request.detach()

	to_chat(user, SPAN_BIGNOTICE("You will not be able to connect until you perform two factor authentication. <a href='[url][user.computer_id]'>Log in here</a>."))

	return FALSE

