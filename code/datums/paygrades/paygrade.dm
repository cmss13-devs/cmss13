GLOBAL_LIST_INIT_TYPED(paygrades, /datum/paygrade, setup_paygrades())

/datum/paygrade
	var/paygrade
	var/name
	var/prefix
	///Factional prefix, currently only used by PMCs. In essence, a pre-prefix.
	var/fprefix

	var/rank_pin
	var/ranking = 0

/proc/setup_paygrades()
	. = list()
	for(var/I in subtypesof(/datum/paygrade))
		var/datum/paygrade/PG = I
		if(initial(PG.paygrade))
			.[initial(PG.paygrade)] += new PG
