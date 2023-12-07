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
	"PvI",
	PAY_SHORT_NO7,
	PAY_SHORT_MO7,
	PAY_SHORT_NO8,
	PAY_SHORT_MO8,
	PAY_SHORT_NO9,
	PAY_SHORT_MO9,
	PAY_SHORT_NO10,
	PAY_SHORT_MO10,
	PAY_SHORT_NO10C,
	PAY_SHORT_MO10C,
	"PvO8",
	"PvO9",
	"PvCM"
))

GLOBAL_LIST_INIT(co_paygrades, list(
	PAY_SHORT_NO6,
	PAY_SHORT_NO6E,
	PAY_SHORT_NO6C,
	PAY_SHORT_NO5,
	PAY_SHORT_NO4,
	PAY_SHORT_MO6,
	PAY_SHORT_MO6E,
	PAY_SHORT_MO6C,
	PAY_SHORT_MO5,
	PAY_SHORT_MO4
))

GLOBAL_LIST_INIT(wy_paygrades, list(
	PAY_SHORT_WYC8,
	PAY_SHORT_WYC9,
	PAY_SHORT_WYC10
))
