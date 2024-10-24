/obj/item/clothing/gloves/synth/wy
	name = "PK-130C SIMI wrist-mounted computer"
	desc = "Developed by a joint effort between Weyland-Yutani CIART and the USCM R&D Division, the SIMI portable computer is the ultimate solution for situational awareness, personnel monitoring and communication. This one has a corporate-white finish."

	icon_state = "bracer_white"
	base_item_slot_state = "bracer_white"
	item_state_slots = list(
		WEAR_HANDS = "bracer_white"
	)

	bracer_color = SIMI_COLOR_WHITE
	faction = FACTION_WY

/obj/item/clothing/gloves/synth/wy/pmc
	faction = FACTION_PMC

/obj/item/clothing/gloves/synth/wy/pmc/preset
	faction = FACTION_PMC
	actions_list_added = list(
		/datum/action/human_action/synth_bracer/repair_form,
		/datum/action/human_action/synth_bracer/motion_detector,
	)

/obj/item/clothing/gloves/synth/wy/pmc/preset/Initialize()
	. = ..()
	underglove = new /obj/item/clothing/gloves/marine/veteran/pmc(src)

	var/obj/item/device/simi_chip/motion_detector/new_md = new
	var/obj/item/device/simi_chip/repair/new_repair = new
	new_md.forceMove(src)
	ability_chips += new_md
	new_repair.forceMove(src)
	ability_chips += new_repair

/obj/item/clothing/gloves/synth/testing
	name = "XPK-140 SIMI wrist-mounted computer"
	desc = "Developed by a joint effort between Weyland-Yutani CIART and the USCM R&D Division, the SIMI portable computer is the ultimate solution for situational awareness, personnel monitoring and communication. This one is highly experimental and seems to be overclocked."
	ability_chips_max = 0

	actions_list_inherent = list(
		/datum/action/human_action/synth_bracer/crew_monitor,
		/datum/action/human_action/synth_bracer/deploy_binoculars,
		/datum/action/human_action/synth_bracer/tactical_map,
	)
	//pre-populated list for testing purposes.
	actions_list_added = list(
		/datum/action/human_action/synth_bracer/repair_form,
		/datum/action/human_action/synth_bracer/protective_form,
		/datum/action/human_action/synth_bracer/anchor_form,
		/datum/action/human_action/activable/synth_bracer/rescue_hook,
		/datum/action/human_action/synth_bracer/motion_detector,
	)
