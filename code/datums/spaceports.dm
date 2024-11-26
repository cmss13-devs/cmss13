/datum/spaceport

	/// The name that will be displayed while on route to this destination
	var/name = ""

	/// The message that will be sent when docking is initiated
	var/docking_message = ""

	/// The allies that will be spawned by arriving at this station
	var/list/allies

/datum/spaceport/uscm
	name = "Mont-Blanc 41 LG Station"
	docking_message = "Attention, USCM vessel. We are launching umbilical cords and deploying a squad to investigate the nature of your distress."
	allies = list(
		/datum/emergency_call/solar_devils_full
	)
