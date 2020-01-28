/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	flags_atom = null //doesn't protect eyes because it's a monocle, duh


/obj/item/clothing/glasses/hud/health
	name = "\improper HealthMate HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	deactive_state = "degoggles"
	flags_armor_protection = 0
	toggleable = TRUE
	hud_type = MOB_HUD_MEDICAL_ADVANCED
	actions_types = list(/datum/action/item_action/toggle)
	req_skill = SKILL_MEDICAL
	req_skill_level = SKILL_MEDICAL_MEDIC

/obj/item/clothing/glasses/hud/sensor
	name = "\improper SensorMate HUD"
	desc = "A much older heads-up display that displays the last known biometric data from suit sensors of any given individual."
	icon_state = "sensorhud"
	deactive_state = "sensorhud_d"
	flags_armor_protection = 0
	toggleable = TRUE
	hud_type = MOB_HUD_MEDICAL_BASIC
	actions_types = list(/datum/action/item_action/toggle)
	req_skill = SKILL_MEDICAL
	req_skill_level = SKILL_MEDICAL_CHEM

/obj/item/clothing/glasses/hud/security
	name = "\improper PatrolMate HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	deactive_state = "degoggles"
	toggleable = TRUE
	flags_armor_protection = 0
	hud_type = MOB_HUD_SECURITY_ADVANCED
	actions_types = list(/datum/action/item_action/toggle)
	var/global/list/jobs[0]

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	icon_state = "jensenshades"
	item_state = "jensenshades"
	vision_flags = SEE_MOBS
	invisa_view = 2
	toggleable = FALSE
	actions_types = list()
