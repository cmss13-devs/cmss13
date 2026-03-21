/datum/spaceport
	/// The name that will be displayed while on route to this destination
	var/name = ""

	/// The message that will be sent when docking is initiated
	var/docking_message = "Attention, USCM vessel. We are launching umbilical cords and deploying a squad to investigate the nature of your distress."

	/// The allies that will be spawned by arriving at this station (only one entry chosen randomly per call)
	var/list/allies

/datum/spaceport/uscm
	name = "Chinook Station"
	allies = list(
		/datum/emergency_call/marsoc,
	)

/datum/spaceport/predator
	name = "Yautja Prime"
	docking_message = "Invaders! Repel them!."
	allies = list(
		/datum/emergency_call/yautja_mcaste,
		/datum/emergency_call/young_bloods/six_members
	)

/datum/spaceport/upp
	name = "Znoy Outpost"
	docking_message = "Attention, USCM vessel. You have encroached on UPP territory. We are launching umbilical cords and deploying a squad to investigate the nature of your distress."
	allies = list(
		/datum/emergency_call/upp_commando
	)

/datum/spaceport/freelancers
	name = "Super Secret Illegal WY Station"
	docking_message = "What? How did you find this place? You will not live to tell the tale."
	allies = list(
		/datum/emergency_call/death,
		/datum/emergency_call/wy_commando/deathsquad
	)
