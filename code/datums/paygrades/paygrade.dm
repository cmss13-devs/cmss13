GLOBAL_LIST_EMPTY(uscm_highcom_paygrades)
GLOBAL_LIST_EMPTY(uscm_officer_paygrades)
GLOBAL_LIST_EMPTY(wy_highcom_paygrades)
GLOBAL_LIST_INIT_TYPED(paygrades, /datum/paygrade, setup_paygrades())

/datum/paygrade
	var/paygrade
	var/name
	var/prefix
	/// Factional prefix, currently only used by PMCs. In essence, a pre-prefix.
	var/fprefix

	var/rank_pin
	var/ranking = 0

	/// Actually gives you the fucking money from your paygrade in your ATM account. Multiplier of 1 equals PFC pay.
	var/pay_multiplier = 1

	/// The faction this paygrade is usually assigned to.
	var/default_faction
	/// If the grade refers to an officer equivalent or not.
	var/officer_grade = GRADE_ENLISTED

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

/datum/paygrade/New()
	. = ..()
	switch(default_faction)
		if(FACTION_MARINE)
			if(officer_grade)
				GLOB.uscm_officer_paygrades += paygrade
			if(officer_grade >= GRADE_FLAG)
				GLOB.uscm_highcom_paygrades += paygrade
		if(FACTION_WY,FACTION_PMC)
			if(officer_grade >= GRADE_FLAG)
				GLOB.wy_highcom_paygrades += paygrade

/proc/setup_paygrades()
	. = list()
	for(var/datum/paygrade/PG as anything in subtypesof(/datum/paygrade))
		var/pg_id = initial(PG.paygrade)
		if(pg_id)
			if(pg_id in .)
				log_debug("Duplicate paygrade: '[pg_id]'.")
			else
				.[pg_id] = new PG
