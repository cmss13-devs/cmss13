DEFINE_ENTITY(ticket, "ticket")
FIELD_BIGINT(ticket, ticket)
FIELD_STRING_LARGE(ticket, action)
FIELD_STRING_MAX(ticket, message)
FIELD_STRING_MAX(ticket, recipient)
FIELD_STRING_MAX(ticket, sender)
FIELD_BIGINT(ticket, round_id)
FIELD_DATE(ticket, time)
FIELD_INT(ticket, urgent)

BSQL_PROTECT_DATUM(/datum/entity/ticket)

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

	REDIS_PUBLISH("byond.ticket", "ticket-id" = ticket, "action" = action, "message" = message, "recipient" = recipient, "sender" = sender, "urgent" = urgent)

