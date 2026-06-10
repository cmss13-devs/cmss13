/datum/spaceport
	/// The name that will be displayed while on route to this destination
	var/name = ""

	/// The message that will be sent when docking is initiated
	var/docking_message = "Attention, USCM vessel. We are launching umbilical cords and deploying a squad to investigate the nature of your distress."

	/// The allies that will be spawned by arriving at this station (only one entry chosen randomly per call)
	var/list/allies

/datum/spaceport/uscm
	name = "Mont-Blanc 41 LG Station"
	docking_message = "Attention, USS Almayer. This is Captain Pereira with the Solar Devils Battalion, for a ship from the Falcons you're far off course.. Initiate docking procedures, we're sending in a team now."
	allies = list(
		/datum/emergency_call/solar_devils,
		/datum/emergency_call/solar_devils_full,
	)

/datum/spaceport/cmb
	name = "Anchorpoint Station"
	docking_message = "This is Chief Deputy Marshal Whittaker with the Colonial Marshal Bureau, Anchorpoint Station. We're investigating the nature of your distress signal. Initiate docking procedures at tower four."
	allies = list(
		/datum/emergency_call/cmb/riot_control,
		/datum/emergency_call/cmb,
	)

/datum/spaceport/upp
	name = "Znoy Outpost"
	docking_message = "Attention, USCM vessel. You have encroached on UPP territory. We are launching umbilical cords and deploying a squad to investigate the nature of your distress."
	allies = list(
		/datum/emergency_call/upp/friendly,
	)

/datum/spaceport/vanguard
	name = "Irkala Station"
	docking_message = "Attention, USCM vessel. We are launching umbilical cords and deploying a squad to investigate the nature of your distress in accordance with the Military Aid Act of 2177."
	allies = list(
		/datum/emergency_call/contractors,
		/datum/emergency_call/contractors/covert,
	)

/datum/spaceport/vanguard/lancer
	name = "Geldmann Outpost"
	allies = list(
		/datum/emergency_call/mercs/friendly, //left out elite since they're way too OP.
	)

/datum/spaceport/royal_commandos
	name = "Port Yamanashi"
	docking_message = "Attention, USCM vessel. Initiate docking procedures immediately, we are deploying a squad to investigate the nature of your distress in accordance with the Military Aid Act of 2177." //i liked the idea of the almayer docking itself to a port
	allies = list(
		/datum/emergency_call/royal_marines,
	)

/datum/spaceport/pmc
	name = "Tenshoku Station"
	docking_message = "Attention, USCM vessel. Initiate docking procedures immediately, we are deploying a squad to investigate the nature of your distress in accordance with the Military Aid Act of 2177."
	allies = list(
		/datum/emergency_call/pmc,
	)
