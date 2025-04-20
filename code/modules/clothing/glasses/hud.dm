/obj/item/clothing/glasses/hud
	name = "HUD"
	icon = 'icons/obj/items/clothing/glasses/huds.dmi'
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/huds.dmi',
	)
	gender = NEUTER
	desc = "A heads-up display that provides important info in (almost) real time."
	flags_atom = null //doesn't protect eyes because it's a monocle, duh


/obj/item/clothing/glasses/hud/health
	name = "\improper HealthMate HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	item_state = "healthhud"
	deactive_state = "degoggles"
	flags_armor_protection = 0
	toggleable = TRUE
	hud_type = MOB_HUD_MEDICAL_ADVANCED
	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/view_publications)
	req_skill = SKILL_MEDICAL
	req_skill_level = SKILL_MEDICAL_MEDIC

/obj/item/clothing/glasses/hud/health/prescription
	name = "\improper Prescription HealthMate HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status. Contains prescription lenses."
	prescription = TRUE

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
	if(owner && !owner.is_mob_incapacitated() && owner.faction != FACTION_SURVIVOR)
		return TRUE

/datum/action/item_action/view_publications/action_activate()
	. = ..()
	var/obj/item/clothing/glasses/hud/health/hud = holder_item
	hud.tgui_interact(owner)

/obj/item/clothing/glasses/hud/health/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/item/clothing/glasses/hud/health/ui_data(mob/user)
	var/list/data = list(
		"published_documents" = GLOB.chemical_data.research_publications,
		"terminal_view" = FALSE
	)
	return data

/obj/item/clothing/glasses/hud/health/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PublishedDocsHud", name)
		ui.open()

/obj/item/clothing/glasses/hud/health/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return

	switch(action)
		if ("read_document")
			var/print_type = params["print_type"]
			var/print_title = params["print_title"]
			var/obj/item/paper/research_report/report = GLOB.chemical_data.get_report(print_type, print_title)
			if(report)
				report.read_paper(user)
			return

/obj/item/clothing/glasses/hud/health/verb/view_publications()
	set category = "Object"
	set name = "View Research Publications"
	set src in usr

	if(!usr.stat && !usr.is_mob_restrained() && usr.faction != FACTION_SURVIVOR)
		tgui_interact(usr)

/obj/item/clothing/glasses/hud/health/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return

	if(href_list["read_document"])
		var/obj/item/paper/research_report/report = GLOB.chemical_data.research_documents[href_list["print_type"]][href_list["print_title"]]
		if(report)
			report.read_paper(user)

/obj/item/clothing/glasses/hud/health/basic
	name = "\improper Basic HealthMate HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status. This one is a simpler model."
	hud_type = MOB_HUD_MEDICAL_BASIC
	req_skill = NONE
	req_skill_level = NONE
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/hud/health/basic/prescription
	name = "\improper Prescription Basic HealthMate HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status. This simpler model contains prescription lenses."
	prescription = TRUE

/obj/item/clothing/glasses/hud/health/science
	name = "custom HealthMate HUD" // combined HealthMateHUD and Reagent Scanner HUD for CMO
	desc = "These HealthMate HUD googles are modified with a light-weight titantium-alloy frame that is custom fitted with extra wiring and low profile components from a reagent analyzer, allowing them to combine the functionality of a HealthMate and reagent scanner HUD without compromising on the form of the googles."
	req_skill = SKILL_RESEARCH
	req_skill_level = SKILL_RESEARCH_TRAINED
	clothing_traits = list(TRAIT_REAGENT_SCANNER)

/obj/item/clothing/glasses/hud/health/science/prescription
	name = "prescription custom HealthMate HUD" // combined HealthMateHUD and Reagent Scanner HUD for CMO but prescription
	desc = parent_type::desc + " This pair contains prescription lenses."
	prescription = TRUE

/obj/item/clothing/glasses/hud/sensor
	name = "\improper SensorMate HUD"
	desc = "A much older heads-up display that displays the last known biometric data from suit sensors of any given individual."
	icon_state = "sensorhud"
	deactive_state = "sensorhud_d"
	flags_armor_protection = 0
	toggleable = TRUE
	hud_type = MOB_HUD_MEDICAL_ADVANCED
	actions_types = list(/datum/action/item_action/toggle)
	req_skill = SKILL_MEDICAL
	req_skill_level = SKILL_MEDICAL_DEFAULT

/obj/item/clothing/glasses/hud/sensor/prescription
	name = "\improper Prescription SensorMate HUD"
	desc = "A much older heads-up display that displays the last known biometric data from suit sensors of any given individual. Contains prescription lenses."
	prescription = TRUE

/obj/item/clothing/glasses/hud/security
	name = "\improper PatrolMate HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	deactive_state = "degoggles"
	toggleable = TRUE
	flags_armor_protection = 0
	hud_type = MOB_HUD_SECURITY_ADVANCED
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/hud/security/prescription
	name = "\improper Prescription PatrolMate HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	prescription = TRUE

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "augmented shades"
	gender = PLURAL
	desc = "Polarized bioneural eyewear, designed to augment your vision. Why don't you try getting a job?"
	icon = 'icons/obj/items/clothing/glasses/misc.dmi'
	item_icons = list(
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/misc.dmi',
	)
	icon_state = "jensenshades"
	item_state = "jensenshades"
	vision_flags = SEE_MOBS
	invisa_view = 2
	toggleable = FALSE
	actions_types = list()
