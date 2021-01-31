GLOBAL_LIST_INIT(wy_ranks, list(
	"division_code" = list(
		"X" = "",

		"1" = "Spc Serv.",
		"2" = "C.R.",
		"3" = "Comms.",
		"4" = "PMC Disp.",
		"5" = "R&D",
		"6" = "Eco",
		"7" = "Psi"
	),
	"job_code" = list(
		"X" = "",

		"A" = "Trainee",
		"B" = "Junior Executive",
		"C" = "Executive",
		"D" = "Senior Executive",
		"E" = "Executive Specialist",
		"F" = "Executive Supervisor",
		"G" = "Assistant Manager",
		"H" = "Division Manager",
		"I" = "Chief Executive",
		"J" = "Director"
	),
	"job_code_prefix" = list(
		"X" = "",

		"A" = "Trn",
		"B" = "Jr. Exec",
		"C" = "Exec",
		"D" = "Sr. Exec",
		"E" = "Exec. Spc",
		"F" = "Exec. Suvp",
		"G" = "Assis. Mng",
		"H" = "Div. Mng",
		"I" = "Chief. Exec",
		"J" = "Director"
	)
))

/mob/living/carbon/human/proc/apply_wy_rank_code(var/code, var/assignment, var/c_title)

	if(c_title)
		comm_title = c_title
	else
		comm_title = trim(get_paygrades(code, TRUE))

	var/obj/item/card/id/I = wear_id

	if(istype(I))
		I.paygrade = code
		I.rank = code

		if(!assignment)
			I.assignment = get_paygrades(code)
		else
			I.assignment = assignment

		I.name = "[I.registered_name]'s ID Card ([I.assignment])"

/proc/get_named_wy_ranks(var/code)
	if(!GLOB.wy_ranks[code])
		return
	var/named_ranks = list()

	for(var/rank in GLOB.wy_ranks[code])
		var/rank_name = GLOB.wy_ranks[code][rank]
		if(rank == "X")
			named_ranks += list("None" = rank)
			continue

		named_ranks += list("[rank_name]" = rank)

	return named_ranks
