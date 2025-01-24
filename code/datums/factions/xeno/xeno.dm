/datum/faction/xenomorph
	name = "Xenomorphs"
	desc = "Unknow biological weapon, no know place where it begun, but we all know place where it ends. For additional information required access 6X-X / XC-X or higher..."
	code_identificator = FACTION_XENOMORPH

	color = null
	ui_color = null

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph
	relations_pregen = RELATIONS_FACTION_XENOMORPH

/datum/faction/xenomorph/New()
	faction_modules[FACTION_MODULE_HIVE_MIND] = new /datum/faction_module/hive_mind(src)
	. = ..()

/datum/faction/xenomorph/faction_is_ally(datum/faction/faction)
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	if(!faction_module.living_xeno_queen)
		return FALSE
	. = ..()

/datum/faction/xenomorph/can_delay_round_end(mob/living/carbon/carbon)
	if(!faction_is_ally(GLOB.faction_datums[FACTION_MARINE]))
		return TRUE
	return FALSE

/datum/faction/xenomorph/get_join_status(mob/new_player/user)
	if(SSticker.mode.check_xeno_late_join(user))
		var/mob/new_xeno = SSticker.mode.attempt_to_join_as_xeno(user, FALSE)
		if(!new_xeno && tgui_alert(user, "Are you sure you wish to observe to be a xeno candidate?\nWhen you observe, you will not be able to join as marine.\nIt might also take some time to become a xeno or responder!", "Confirmation", list("Yes", "No"), 10 SECONDS) == "Yes")
			user.observe_for_xeno()
		else if(!istype(new_xeno, /mob/living/carbon/xenomorph/larva))
			SSticker.mode.transfer_xeno(user, new_xeno)
		return TRUE
