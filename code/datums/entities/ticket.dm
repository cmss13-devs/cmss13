/datum/entity/ticket
	var/ticket
	var/action
	var/message
	var/recipient
	var/sender
	var/round_id
	var/time
	var/urgent

BSQL_PROTECT_DATUM(/datum/entity/ticket)

/datum/entity_meta/ticket
	entity_type = /datum/entity/ticket
	table_name = "ticket"
	field_types = list(
		"ticket"=DB_FIELDTYPE_BIGINT,
		"action"=DB_FIELDTYPE_STRING_LARGE,
		"message"=DB_FIELDTYPE_STRING_MAX,
		"recipient"=DB_FIELDTYPE_STRING_MAX,
		"sender"=DB_FIELDTYPE_STRING_MAX,
		"round_id"=DB_FIELDTYPE_BIGINT,
		"time"=DB_FIELDTYPE_DATE,
		"urgent"=DB_FIELDTYPE_INT,
	)

/proc/log_ahelp(ticket, action, message, recipient, sender, urgent = FALSE)
	var/datum/entity/ticket/ticket_ent = DB_ENTITY(/datum/entity/ticket)
	ticket_ent.ticket = ticket
	ticket_ent.action = action
	ticket_ent.message = message
	ticket_ent.recipient = recipient
	ticket_ent.sender = sender
	ticket_ent.urgent = urgent
	ticket_ent.time = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
	ticket_ent.round_id = SSperf_logging.round?.id
	ticket_ent.save()
	ticket_ent.detach()
