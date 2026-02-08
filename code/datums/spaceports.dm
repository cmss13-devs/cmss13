/datum/spaceport
	/// The name that will be displayed while on route to this destination
	var/name = ""

	/// The message that will be sent when docking is initiated
	var/docking_message = "Attention, USCM vessel. We are launching umbilical cords and deploying a squad to investigate the nature of your distress."

	/// The allies that will be spawned by arriving at this station (only one entry chosen randomly per call)
	var/list/allies

/datum/spaceport/uscm
	name = "Mont-Blanc 41 LG Station"
	allies = list(
		/datum/emergency_call/solar_devils_full,
	)

/datum/spaceport/cmb
	name = "Anchorpoint Station"
	docking_message = "This is the Anchorpoint Colonial Marshals Bureau, we're initiating boarding procedure to investigate your distress signal."
	allies = list(
		/datum/emergency_call/cmb,
	)

/datum/spaceport/upp
	name = "Znoy Outpost"
	docking_message = "Attention, USCM vessel. You have encroached on UPP territory. We are launching umbilical cords and deploying a squad to investigate the nature of your distress."
	allies = list(
		/datum/emergency_call/upp/friendly,
	)

/datum/spaceport/freelancers
	name = "Irkala Station"
	docking_message = "Attention, USCM vessel. We are launching umbilical cords and deploying a squad to investigate the nature of your distress in accordance with the Military Aid Act of 2177."
	allies = list(
		/datum/emergency_call/contractors,
		/datum/emergency_call/heavy_mercs/friendly,
	)
