/datum/entity/login_triplet
	var/ckey
	var/ip1
	var/ip2
	var/ip3
	var/ip4

	var/last_known_cid
	var/login_date

/datum/entity_meta/login_triplet
	entity_type = /datum/entity/login_triplet
	table_name = "login_triplets"
	field_typepaths = list(
		"ckey" = DB_FIELDTYPE_STRING_MEDIUM,
		"ip1" = DB_FIELDTYPE_INT,
		"ip2" = DB_FIELDTYPE_INT,
		"ip3" = DB_FIELDTYPE_INT,
		"ip4" = DB_FIELDTYPE_INT,
		"last_known_cid" = DB_FIELDTYPE_STRING_SMALL,
		"login_date" = DB_FIELDTYPE_DATE,
	)

/datum/view_record/login_triplet
	var/ckey
	var/ip1
	var/ip2
	var/ip3
	var/ip4

	var/last_known_cid
	var/login_date

/datum/entity_view_meta/login_triplet
	root_record_type = /datum/entity/login_triplet
	destination_entity = /datum/view_record/login_triplet
	fields = list(
		"ckey",
		"ip1",
		"ip2",
		"ip3",
		"ip4",
		"last_known_cid",
		"login_date",
	)
	order_by = list("ckey" = DB_ORDER_BY_ASC)

/proc/analyze_ckey(ckey)
	for(var/ip in ips_by_ckey(ckey))
		LAZYOR(., ckeys_by_ip(ip) - ckey)

	for(var/cid in cids_by_ckey(ckey))
		LAZYOR(., ckeys_by_cid(cid) - ckey)

/proc/cids_by_ckey(ckey)
	for(var/datum/view_record/login_triplet/triplet in search_login_triplet_by_ckey(ckey))
		LAZYOR(., triplet.last_known_cid)

/proc/ips_by_ckey(ckey)
	for(var/datum/view_record/login_triplet/triplet in search_login_triplet_by_ckey(ckey))
		LAZYOR(., "[triplet.ip1].[triplet.ip2].[triplet.ip3].[triplet.ip4]")

/proc/ckeys_by_ip(ip)
	for(var/datum/view_record/login_triplet/triplet in search_login_triplet_by_ip(ip))
		LAZYOR(., triplet.ckey)

/proc/ckeys_by_cid(cid)
	for(var/datum/view_record/login_triplet/triplet in search_login_triplet_by_cid(cid))
		LAZYOR(., triplet.ckey)

/proc/search_login_triplet_by_ckey(ckey)
	if(!ckey)
		CRASH("No ckey passed to /proc/search_login_triplet_by_ckey")

	return DB_VIEW(/datum/view_record/login_triplet, DB_COMP("ckey", DB_EQUALS, ckey))

/proc/search_login_triplet_by_ip(ip)
	if(!ip)
		CRASH("No IP passed to /proc/search_login_triplet_by_ip")

	var/split_ip = splittext(ip, ".")
	if(length(split_ip) != 4)
		CRASH("Invalid IP passed to /proc/search_login_triplet_by_ip")

	return DB_VIEW(/datum/view_record/login_triplet,
		DB_AND(
			DB_COMP("ip1", DB_EQUALS, split_ip[1]),
			DB_COMP("ip2", DB_EQUALS, split_ip[2]),
			DB_COMP("ip3", DB_EQUALS, split_ip[3]),
			DB_COMP("ip4"), DB_EQUALS, split_ip[4]
		))

/proc/search_login_triplet_by_cid(cid)
	if(!cid)
		CRASH("No CID passed to /proc/search_login_triplet_by_cid")

	return DB_VIEW(/datum/view_record/login_triplet, DB_COMP("last_known_cid", DB_EQUALS, cid))

/proc/record_login_triplet(ckey, last_known_ip, last_known_cid)
	var/datum/entity/login_triplet/LT = DB_ENTITY(/datum/entity/login_triplet)
	LT.ckey = ckey
	if(!last_known_ip) // debugging has no ip
		last_known_ip = "127.0.0.1"
	var/list/ips = splittext(last_known_ip,".")
	LT.ip1 = text2num(ips[1])
	LT.ip2 = text2num(ips[2])
	LT.ip3 = text2num(ips[3])
	LT.ip4 = text2num(ips[4])
	LT.last_known_cid = last_known_cid
	LT.login_date = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	LT.save()
	LT.detach()
