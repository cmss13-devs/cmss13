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
	field_types = list("ckey" = DB_FIELDTYPE_STRING_MEDIUM,
		"ip1" = DB_FIELDTYPE_INT,
		"ip2" = DB_FIELDTYPE_INT,
		"ip3" = DB_FIELDTYPE_INT,
		"ip4" = DB_FIELDTYPE_INT,
		"last_known_cid" = DB_FIELDTYPE_STRING_SMALL,
		"login_date" = DB_FIELDTYPE_DATE)

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
