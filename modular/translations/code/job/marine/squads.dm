//This datum keeps track of individual squads. New squads can be added without any problem but to give them
//access you must add them individually to access.dm with the other squads. Just look for "access_alpha" and add the new one

/*
/datum/squad_type //Majority of this is for a follow-on PR to fully flesh the system out and add more bits for other factions.
	var/name = "Squad Type"
	var/lead_name
	var/lead_icon
	var/sub_squad
	var/sub_leader
*/

/datum/squad_type/marine_squad
	name = "Squad"
	lead_name = "Squad Leader"
	lead_icon = "leader"
	sub_squad = "Fireteam"
	sub_leader = "Fireteam Leader"

/datum/squad_type/marsoc_team
	name = "Team"
	lead_name = "Team Leader"
	lead_icon = "soctl"
	sub_squad = "Strike Team"
	sub_leader = "Strike Leader"


/datum/squad/marine
	name = "Root"
	usable = TRUE
	active = TRUE
	faction = FACTION_MARINE
	lead_icon = "leader"

/datum/squad/marine/alpha
	name = SQUAD_MARINE_1
	equipment_color = "#e61919"
	chat_color = "#e67d7d"
	access = list(ACCESS_MARINE_ALPHA)
	radio_freq = ALPHA_FREQ
	minimap_color = MINIMAP_SQUAD_ALPHA
	background_icon = "background_alpha"

/datum/squad/marine/bravo
	name = SQUAD_MARINE_2
	equipment_color = "#ffc32d"
	chat_color = "#ffe650"
	access = list(ACCESS_MARINE_BRAVO)
	radio_freq = BRAVO_FREQ
	minimap_color = MINIMAP_SQUAD_BRAVO
	background_icon = "background_bravo"

/datum/squad/marine/charlie
	name = SQUAD_MARINE_3
	equipment_color = "#c864c8"
	chat_color = "#ff96ff"
	access = list(ACCESS_MARINE_CHARLIE)
	radio_freq = CHARLIE_FREQ
	minimap_color = MINIMAP_SQUAD_CHARLIE
	background_icon = "background_charlie"

/datum/squad/marine/delta
	name = SQUAD_MARINE_4
	equipment_color = "#4148c8"
	chat_color = "#828cff"
	access = list(ACCESS_MARINE_DELTA)
	radio_freq = DELTA_FREQ
	minimap_color = MINIMAP_SQUAD_DELTA
	background_icon = "background_delta"

/datum/squad/marine/echo
	name = SQUAD_MARINE_5
	equipment_color = "#67d692"
	chat_color = "#67d692"
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	radio_freq = ECHO_FREQ
	omni_squad_vendor = TRUE
	minimap_color = MINIMAP_SQUAD_ECHO
	background_icon = "background_echo"

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/cryo
	name = SQUAD_MARINE_CRYO
	equipment_color = "#c47a50"
	chat_color = "#c47a50"
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	minimap_color = MINIMAP_SQUAD_FOXTROT
	background_icon = "background_foxtrot"

	omni_squad_vendor = TRUE
	radio_freq = CRYO_FREQ

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/intel
	name = SQUAD_MARINE_INTEL
	use_stripe_overlay = FALSE
	equipment_color = "#053818"
	minimap_color = MINIMAP_SQUAD_INTEL
	radio_freq = INTEL_FREQ
	background_icon = "background_intel"

	roundstart = FALSE
	prepend_squad_name_to_assignment = FALSE

	roles_cap = list(
		JOB_SQUAD_MARINE = null,
		JOB_SQUAD_ENGI = 0,
		JOB_SQUAD_MEDIC = 0,
		JOB_SQUAD_SMARTGUN = 0,
		JOB_SQUAD_SPECIALIST = 0,
		JOB_SQUAD_TEAM_LEADER = 0,
		JOB_SQUAD_LEADER = 0,
	)

/datum/squad/marine/sof
	name = SQUAD_SOF
	equipment_color = "#400000"
	chat_color = "#400000"
	radio_freq = SOF_FREQ
	squad_type = "Team"
	lead_icon = "soctl"
	minimap_color = MINIMAP_SQUAD_SOF
	background_icon = "background_sof"

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/cbrn
	name = SQUAD_CBRN
	equipment_color = "#3B2A7B" //Chemical Corps Purple
	chat_color = "#553EB2"
	radio_freq = CBRN_FREQ
	minimap_color = "#3B2A7B"
	background_icon = "background_cbrn"

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/forecon
	name = SQUAD_FORECON
	equipment_color = "#32CD32"
	chat_color = "#32CD32"
	radio_freq = FORECON_FREQ
	minimap_color = "#32CD32"
	background_icon = "background_forecon"

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/solardevils
	name = SQUAD_SOLAR
	equipment_color = "#5a2c2c"
	chat_color = "#5a2c2c"
	radio_freq = SOF_FREQ
	minimap_color = "#5a2c2c"
	background_icon = "background_civillian"

	active = FALSE
	roundstart = FALSE
	locked = TRUE


//############################### UPP Squads
/datum/squad/upp
	name = "Root"
	usable = TRUE
	omni_squad_vendor = TRUE
	faction = FACTION_UPP
	radio_freq = UPP_FREQ
	roles_cap = list(
		JOB_UPP_ENGI = 3,
		JOB_UPP_MEDIC = 4,
		JOB_UPP_SPECIALIST = 1,
		JOB_UPP_LEADER = 1,
	)

/datum/squad/upp/one
	name = SQUAD_UPP_1
	equivalent_name = SQUAD_MARINE_1
	equipment_color = "#e61919"
	chat_color = "#e67d7d"
	background_icon = "background_upp_alpha"

/datum/squad/upp/two
	name = SQUAD_UPP_2
	equivalent_name = SQUAD_MARINE_2
	equipment_color = "#ffc32d"
	chat_color = "#ffe650"
	background_icon = "background_upp_bravo"

/datum/squad/upp/three
	name = SQUAD_UPP_3
	equivalent_name = SQUAD_MARINE_3
	equipment_color = "#c864c8"
	chat_color = "#ff96ff"
	background_icon = "background_upp_charlie"

/datum/squad/upp/four
	name = SQUAD_UPP_4
	equivalent_name = SQUAD_MARINE_4
	equipment_color = "#4148c8"
	chat_color = "#828cff"
	background_icon = "background_upp_delta"

/datum/squad/upp/kdo
	name = SQUAD_UPP_5
	equipment_color = "#c47a50"
	chat_color = "#c47a50"
	squad_type = "Team"
	locked = TRUE
	usable = FALSE

//###############################
/datum/squad/pmc
	name = "Root"
	squad_type = "Team"
	faction = FACTION_PMC
	usable = TRUE
	omni_squad_vendor = TRUE

/datum/squad/pmc/one
	name = "Team Upsilon"
	equipment_color = "#c864c8"
	chat_color = "#ff96ff"

/datum/squad/pmc/two
	name = "Team Gamma"
	equipment_color = "#c47a50"
	chat_color = "#c47a50"

/datum/squad/pmc/wo
	name = "Taskforce White"
	locked = TRUE
	faction = FACTION_WY_DEATHSQUAD
//###############################
/datum/squad/clf
	name = "Root"
	squad_type = "Cell"
	faction = FACTION_CLF
	usable = TRUE
	omni_squad_vendor = TRUE

/datum/squad/clf/one
	name = "Python"

/datum/squad/clf/two
	name = "Viper"

/datum/squad/clf/three
	name = "Cobra"

/datum/squad/clf/four
	name = "Boa"
