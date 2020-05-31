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
	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/view_publications)
	req_skill = SKILL_MEDICAL
	req_skill_level = SKILL_MEDICAL_MEDIC

/datum/action/item_action/view_publications/New(Target)
	..()
	name = "View Research Publications"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/obj/structures/machinery/computer.dmi', button, "research")
	IMG.pixel_x = 0
	IMG.pixel_y = -5
	button.overlays += IMG

/datum/action/item_action/view_publications/update_button_icon()
	return

/datum/action/item_action/view_publications/can_use_action()
	if(owner && !owner.is_mob_incapacitated() && !owner.lying && owner.faction != FACTION_SURVIVOR)
		return TRUE

/datum/action/item_action/view_publications/action_activate()
	var/obj/item/clothing/glasses/hud/health/hud = holder_item
	hud.ui_interact(owner)

/obj/item/clothing/glasses/hud/health/verb/view_publications()
	set category = "Object"
	set name = "View Research Publications"
	set src in usr

	if(!usr.stat && !usr.is_mob_restrained() && usr.faction != FACTION_SURVIVOR)
		ui_interact(usr)

/obj/item/clothing/glasses/hud/health/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data = list(
		"published_documents" = chemical_research_data.research_publications,
		"terminal_view" = FALSE
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "research_data.tmpl", "Research Publications", 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/item/clothing/glasses/hud/health/Topic(href, href_list)
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return

	if(href_list["read_document"])
		var/obj/item/paper/research_report/report = chemical_research_data.research_documents[href_list["print_type"]][href_list["print_title"]]
		if(report)
			report.read_paper(user)

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
