GLOBAL_LIST_INIT_TYPED(paygrades, /datum/paygrade, setup_paygrades())

/datum/paygrade
	var/paygrade
	var/name
	var/prefix
	///Factional prefix, currently only used by PMCs. In essence, a pre-prefix.
	var/fprefix

	var/rank_pin
	var/ranking = 0

	/// Actually gives you the fucking money from your paygrade in your ATM account. Multiplier of 1 equals PFC pay.
	var/pay_multiplier = 1

/proc/setup_paygrades()
	. = list()
	for(var/I in subtypesof(/datum/paygrade))
		var/datum/paygrade/PG = I
		var/pg_id = initial(PG.paygrade)
		if(pg_id)
			if(pg_id in .)
				log_debug("Duplicate paygrade: '[pg_id]'.")
			else
				.[pg_id] = new PG

GLOBAL_LIST_INIT(highcom_paygrades, list(
	"NO7",
	"MO7",
	"NO8",
	"MO8",
	"NO9",
	"MO9",
	"NO10",
	"MO10",
	"NO10C",
	"MO10C",
	"PvO8",
	"PvO9",
	"PvCM"
))

GLOBAL_LIST_INIT(co_paygrades, list(
	"NO6",
	"NO6E",
	"NO6C",
	"NO5",
	"NO4",
	"MO6",
	"MO6E",
	"MO6C",
	"MO5",
	"MO4"
))
