/*
* Health scanning of living mobs
* Uses a datum like player panels
* Tgui mostly
* can be done by a variety of sources - health scanners, body scanners, ghost verb
*/

GLOBAL_LIST_INIT(known_implants, subtypesof(/obj/item/implant))

/// vars reffing this on /mob/dead/observer, /obj/item/device/healthanalyzer, /obj/structure/machinery/cm_vending/sorted/medical, /obj/structure/machinery/body_scanconsole are called last_health_display
/datum/health_scan
	var/mob/living/target_mob
	var/detail_level = DETAIL_LEVEL_FULL

/datum/health_scan/New(mob/target)
	. = ..()
	target_mob = target

/datum/health_scan/Destroy(force, ...)
	target_mob = null
	SStgui.close_uis(src)
	return ..()

/// This is the proc for interacting with, or looking at, a mob's health display. Also contains skillchecks and the like. You may NOT call tgui interact directly, and you MUST set the detail level.
/datum/health_scan/proc/look_at(mob/user, detail = DETAIL_LEVEL_FULL, bypass_checks = FALSE, ignore_delay = TRUE, alien = FALSE, datum/tgui/ui = null)
	if(!bypass_checks)
		if(HAS_TRAIT(target_mob, TRAIT_FOREIGN_BIO) && !alien)
			to_chat(user, SPAN_WARNING("ERROR: Unknown biology detected."))
			return
		if(!(ishuman(user) || SSticker?.mode.name == "monkey"))
			to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this!"))
			return
		if(!ignore_delay && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("You start fumbling around with [target_mob]..."))
			var/fduration = 60
			if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_DEFAULT))
				fduration = 30
			if(!do_after(user, fduration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY) || !user.Adjacent(target_mob))
				return
		if(!istype(target_mob, /mob/living/carbon) || isxeno(target_mob))
			to_chat(user, SPAN_WARNING("The scanner can't make sense of this creature."))
			return

	detail_level = detail
	tgui_interact(user, ui)

/datum/health_scan/ui_state(mob/user)
	if(isobserver(user))
		return GLOB.always_state
	else
		return GLOB.not_incapacitated_state

/datum/health_scan/tgui_interact(mob/user, datum/tgui/ui)
	if(!target_mob)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HealthScan", "Health Scan")
		ui.open()
		ui.set_autoupdate(FALSE)

/**
 * Returns TRUE if the target is either dead or appears to be dead.
 */
/datum/health_scan/proc/get_death_value(mob/target_mob)
	if(target_mob.stat == DEAD || target_mob.status_flags & FAKEDEATH)
		return TRUE
	return FALSE
/**
 * Returns the oxygen value, unless they have FAKEDEATH - in which case it will instead make up a number to return.
 */
/datum/health_scan/proc/get_oxy_value(mob/target_mob)
	if(!(target_mob.status_flags & FAKEDEATH))
		return target_mob.getOxyLoss()

	var/total_mob_damage = target_mob.getBruteLoss() + target_mob.getFireLoss() + target_mob.getToxLoss() + target_mob.getCloneLoss()

	// Fake death will make the scanner think they died of oxygen damage, thus it returns enough damage to kill minus already received damage.
	return floor(POSITIVE(200 - total_mob_damage))

/datum/health_scan/proc/get_holo_card_color(mob/living/target_mob)
	if(!ishuman(target_mob))
		return
	var/mob/living/carbon/human/human_mob = target_mob
	return human_mob.holo_card_color

/datum/health_scan/proc/get_health_value(mob/living/target_mob)
	if(!(target_mob.status_flags & FAKEDEATH))
		return target_mob.health

	return min(-100, target_mob.health)

/datum/health_scan/ui_data(mob/user, data_detail_level = null)
	var/list/data = list(
		"patient" = target_mob.name,
		"dead" = get_death_value(target_mob),
		"health" = get_health_value(target_mob),
		"total_brute" = floor(target_mob.getBruteLoss()),
		"total_burn" = floor(target_mob.getFireLoss()),
		"toxin" = floor(target_mob.getToxLoss()),
		"oxy" = get_oxy_value(target_mob),
		"clone" = floor(target_mob.getCloneLoss()),
		"blood_type" = target_mob.blood_type,
		"blood_amount" = target_mob.blood_volume,
		"holocard" = get_holo_card_color(target_mob),
		"hugged" = (locate(/obj/item/alien_embryo) in target_mob),
	)

	var/internal_bleeding = FALSE //do they have internal bleeding anywhere

	if(!isnull(data_detail_level))
		detail_level = data_detail_level
	data["detail_level"] = detail_level

	// chems data
	data["has_unknown_chemicals"] = FALSE
	data["has_chemicals"] = 0
	var/list/chemicals_lists = list()
	if(target_mob.reagents)
		data["has_chemicals"] = length(target_mob.reagents.reagent_list)
		for(var/datum/reagent/reagent in target_mob.reagents.reagent_list)
			if(!(reagent.flags & REAGENT_SCANNABLE) && detail_level == DETAIL_LEVEL_HEALTHANALYSER)
				data["has_unknown_chemicals"] = TRUE
				continue
			chemicals_lists["[reagent.id]"] = list(
				"name" = reagent.name,
				"amount" = round(reagent.volume, 0.1),
				"od" = reagent.overdose != 0 && reagent.volume > reagent.overdose && !(reagent.flags & REAGENT_CANNOT_OVERDOSE),
				"dangerous" = reagent.overdose != 0 && reagent.volume > reagent.overdose && !(reagent.flags & REAGENT_CANNOT_OVERDOSE) || istype(reagent, /datum/reagent/toxin),
				"color" = reagent.color
			)

	data["chemicals_lists"] = chemicals_lists

	var/list/limb_data_lists = list()
	// human data
	if(ishuman(target_mob))
		var/mob/living/carbon/human/human_target_mob = target_mob

		// blood and species
		var/has_blood = TRUE
		if(human_target_mob.species.flags & NO_BLOOD)
			has_blood = FALSE
		data["has_blood"] = has_blood
		data["species"] = human_target_mob.species.group

		// permadeadness
		var/permadead = FALSE
		if(human_target_mob.is_dead())
			if(!human_target_mob.is_revivable())
				permadead = TRUE
			else if(!human_target_mob.check_tod() && !issynth(human_target_mob))
				permadead = TRUE
			if(issynth(target_mob))
				permadead = FALSE

		data["permadead"] = permadead

		//snowflake :3
		data["lung_ruptured"] = human_target_mob.is_lung_ruptured()
		data["heart_broken"] = human_target_mob.is_heart_broken()

		//shrapnel, limbs, limb damage, limb statflags, cyber limbs
		var/core_fracture_detected = FALSE
		var/unknown_implants = 0
		for(var/obj/limb/limb in human_target_mob.limbs)
			var/internal_bleeding_check = FALSE //do they have internal bleeding in this limb
			for(var/datum/effects/bleeding/internal/ib in limb.bleeding_effects_list)
				internal_bleeding = TRUE
				internal_bleeding_check = TRUE
				break
			if(limb.hidden)
				unknown_implants++
			var/implant = FALSE
			if(length(limb.implants))
				for(var/I in limb.implants)
					if(is_type_in_list(I, GLOB.known_implants))
						continue
					unknown_implants++
					implant = TRUE

			var/bleeding_check = FALSE
			for(var/datum/effects/bleeding/external/E in limb.bleeding_effects_list)
				bleeding_check = TRUE
				break

			if((!limb.brute_dam && !limb.burn_dam && !(limb.status & LIMB_DESTROYED)) && !bleeding_check && !internal_bleeding_check && !(implant && detail_level >= DETAIL_LEVEL_BODYSCAN ) && !(limb.status & LIMB_UNCALIBRATED_PROSTHETIC) && !(limb.status & LIMB_BROKEN) && !(limb.status & LIMB_SPLINTED) && !(limb.status & LIMB_SPLINTED_INDESTRUCTIBLE) && !(limb.get_incision_depth()))
				continue
			var/list/core_body_parts = list("head", "chest", "groin")
			var/list/current_list = list(
				"name" = limb.display_name,
				"brute" = floor(limb.brute_dam),
				"burn" = floor(limb.burn_dam),
				"bandaged" = limb.is_bandaged(),
				"salved" = limb.is_salved(),
				"missing" = (limb.status & LIMB_DESTROYED),
				"limb_status" = null,
				"bleeding" = bleeding_check,
				"implant" = implant,
				"internal_bleeding" = internal_bleeding_check
			)
			//broken-ness and splints
			var/limb_status = null
			if(limb.status & LIMB_BROKEN)
				if(detail_level == DETAIL_LEVEL_HEALTHANALYSER && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
					if(limb.name in core_body_parts) // sigh... le snowflake
						var/showmessage = FALSE
						switch(limb.name)
							if("head")
								core_fracture_detected = TRUE
								if(limb.brute_dam > 40 || human_target_mob.getBrainLoss() >= 20)
									limb_status = "Possible Fracture"
									showmessage = TRUE
							if("chest")
								core_fracture_detected = TRUE
								if(limb.brute_dam > 40 || human_target_mob.getOxyLoss() >= 50)
									limb_status = "Possible Fracture"
									showmessage = TRUE
							if("groin")
								core_fracture_detected = TRUE
								if(limb.brute_dam > 40 || human_target_mob.getToxLoss() >= 50)
									limb_status = "Possible Fracture"
									showmessage = TRUE
						if(!(!limb.brute_dam && !limb.burn_dam && !(limb.status & LIMB_DESTROYED) && !bleeding_check && !(implant && detail_level >= DETAIL_LEVEL_BODYSCAN ) && !(limb.status & LIMB_UNCALIBRATED_PROSTHETIC) && !(limb.status & LIMB_SPLINTED) && !(limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)))
							showmessage = TRUE
						if(!showmessage)
							continue
					else
						limb_status = "Fracture"
				else
					limb_status = "Fracture"
			if(limb_status)
				current_list["limb_status"] = limb_status

			var/limb_splint = null

			if((limb.status & LIMB_SPLINTED))
				limb_splint = "Splinted"
			else if((limb.status & LIMB_SPLINTED_INDESTRUCTIBLE))
				limb_splint = "Nanosplinted"
			if(limb_splint)
				current_list["limb_splint"] = limb_splint

			/// for checking if limbs are robot limbs
			var/limb_type = null
			if(limb.status & LIMB_ROBOT)
				if(limb.status & LIMB_UNCALIBRATED_PROSTHETIC)
					limb_type = "Nonfunctional Cybernetic"
				else
					limb_type = "Cybernetic"
			else if(limb.status & LIMB_SYNTHSKIN)
				limb_type = "Synthskin"
			if(limb_type)
				current_list["limb_type"] = limb_type

			//checking for open incisions, but since eyes and mouths incisions are "head incisions" but not "head surgeries" gotta do some snowflake
			if(limb.name == "head")
				if(human_target_mob.active_surgeries["head"])
					current_list["open_incision"] = TRUE

				var/zone
				if(human_target_mob.active_surgeries["eyes"])
					zone = "eyes"
				if(human_target_mob.active_surgeries["mouth"])
					if(zone)
						zone = "eyes and mouth"
					else
						zone = "mouth"
				current_list["open_zone_incision"] = capitalize(zone)

			else
				current_list["open_incision"] = limb.get_incision_depth()

			limb_data_lists["[limb.name]"] = current_list

		data["limb_data_lists"] = limb_data_lists
		data["limbs_damaged"] = length(limb_data_lists)
		data["internal_bleeding"] = internal_bleeding
		data["body_temperature"] = "[round(human_target_mob.bodytemperature-T0C, 0.1)]℃ ([round(human_target_mob.bodytemperature*1.8-459.67, 0.1)]℉)" // METRIC RULES IMPERIAL DROOLS
		data["pulse"] = "[human_target_mob.get_pulse(GETPULSE_TOOL)] bpm"
		data["implants"] = unknown_implants
		data["core_fracture"] = core_fracture_detected

		//organs
		var/damaged_organs = list()
		for(var/datum/internal_organ/organ in human_target_mob.internal_organs)
			if(!organ.damage)
				continue
			var/current_organ = list(
				"name" = organ.name,
				"damage" = organ.damage,
				"status" = organ.organ_status == ORGAN_BROKEN ? "Broken" : "Bruised",
				"robotic" = organ.robotic
			)
			damaged_organs += list(current_organ)
		data["damaged_organs"] = damaged_organs

		//advice!
		var/list/advice = list()
		var/list/temp_advice = list()
		if(!permadead)
			if(human_target_mob.getBruteLoss(robotic_only = TRUE) > 20)
				advice += list(list(
					"advice" = "Use a blowtorch or nanopaste to repair the damaged areas.",
					"icon" = "tools",
					"color" = "red" //BRI'ISH????
					))
			if(human_target_mob.getFireLoss(robotic_only = TRUE) > 20)
				advice += list(list(
					"advice" = "Use a cable coil or nanopaste to repair the burned areas.",
					"icon" = "plug",
					"color" = "orange"
					))
			if(unknown_implants)
				advice += list(list(
					"advice" = "Recommend that the patient does not move - embedded objects.",
					"icon" = "window-close",
					"color" = "red"
					))
			if(human_target_mob.stat == DEAD)
				if((human_target_mob.health + 20) > HEALTH_THRESHOLD_DEAD)
					advice += list(list(
						"advice" = "Apply shock via defibrillator!",
						"icon" = "bolt",
						"color" = "yellow"
						))
				else
					if(human_target_mob.getBruteLoss(organic_only = TRUE) > 30)
						advice += list(list(
							"advice" = "Use trauma kits or surgical line to repair the lacerated areas.",
							"icon" = "band-aid",
							"color" = "green" //BRI'ISH????
							))
					if(human_target_mob.getFireLoss(organic_only = TRUE) > 30)
						advice += list(list(
							"advice" = "Use burn kits or synth-graft to repair the burned areas.",
							"icon" = "band-aid",
							"color" = "orange" //BRI'ISH????
							))
					if(((human_target_mob.health + 50) < HEALTH_THRESHOLD_DEAD) && !issynth(human_target_mob))
						advice += list(list(
							"advice" = "Administer a single dose of epinephrine.",
							"icon" = "syringe",
							"color" = "olive"
							))
			if(!issynth(human_target_mob))
				if(human_target_mob.blood_volume <= 500 && !chemicals_lists["nutriment"])
					advice += list(list(
						"advice" = "Administer food or recommend that the patient eat.",
						"icon" = "pizza-slice",
						"color" = "white"
						))
				if(human_target_mob.getToxLoss() > 10)
					temp_advice = list(list(
						"advice" = "Administer a single dose of dylovene.",
						"icon" = "syringe",
						"color" = "green"
						))
					if(chemicals_lists["anti_toxin"])
						if(chemicals_lists["anti_toxin"]["amount"] < 5)
							advice += temp_advice
					else
						advice += temp_advice
				if((human_target_mob.getToxLoss() > 50 || (human_target_mob.getOxyLoss() > 50 && human_target_mob.blood_volume > 400) || human_target_mob.getBrainLoss() >= 10))
					temp_advice = list(list(
						"advice" = "Administer a single dose of peridaxon.",
						"icon" = "syringe",
						"color" = "grey"
						))
					if(chemicals_lists["peridaxon"])
						if(chemicals_lists["peridaxon"]["amount"] < 5)
							advice += temp_advice
					else
						advice += temp_advice
				if(human_target_mob.getOxyLoss() > 50)
					temp_advice = list(list(
						"advice" = "Administer a single dose of dexalin.",
						"icon" = "syringe",
						"color" = "blue"
						))
					if(chemicals_lists["dexalin"])
						if(chemicals_lists["dexalin"]["amount"] < 3)
							advice += temp_advice
					else
						advice += temp_advice
				if(human_target_mob.getFireLoss(organic_only = TRUE) > 30)
					temp_advice = list(list(
						"advice" = "Administer a single dose of kelotane.",
						"icon" = "syringe",
						"color" = "yellow"
						))
					if(chemicals_lists["kelotane"])
						if(chemicals_lists["kelotane"]["amount"] < 3)
							advice += temp_advice
					else
						advice += temp_advice
				if(human_target_mob.getBruteLoss(organic_only = TRUE) > 30)
					temp_advice = list(list(
						"advice" = "Administer a single dose of bicaridine.",
						"icon" = "syringe",
						"color" = "red"
						))
					if(chemicals_lists["bicaridine"])
						if(chemicals_lists["bicaridine"]["amount"] < 3)
							advice += temp_advice
					else
						advice += temp_advice
				if(human_target_mob.health < 0)
					temp_advice = list(list(
						"advice" = "Administer a single dose of inaprovaline.",
						"icon" = "syringe",
						"color" = "purple"
						))
					if(chemicals_lists["inaprovaline"])
						if(chemicals_lists["inaprovaline"]["amount"] < 5)
							advice += temp_advice
					else
						advice += temp_advice
				var/has_pain = FALSE
				for(var/datum/effects/pain/P in target_mob.effects_list)
					has_pain = TRUE
					break

				if(has_pain && !chemicals_lists["paracetamol"])
					temp_advice = list(list(
						"advice" = "Administer a single dose of tramadol.",
						"icon" = "syringe",
						"color" = "white"
						))
					if(chemicals_lists["tramadol"])
						if(chemicals_lists["tramadol"]["amount"] < 3)
							advice += temp_advice
					else
						advice += temp_advice

				if(chemicals_lists["paracetamol"])
					advice += list(list(
						"advice" = "Do NOT administer tramadol.",
						"icon" = "window-close",
						"color" = "red"
						))
		if(length(advice))
			data["advice"] = advice
		else
			data["advice"] = null // interstingly even if we don't set data at all, re-using UI that had this data still has it

		//diseases
		var/list/diseases = list()
		for(var/datum/disease/disease in target_mob.viruses)
			if(!disease.hidden[SCANNER] || detail_level >= DETAIL_LEVEL_FULL)
				var/current_disease = list(
					"name" = disease.name,
					"form" = disease.form,
					"type" = disease.spread,
					"stage" = disease.stage,
					"max_stage" = disease.max_stages,
					"cure" = disease.cure
				)
				diseases += list(current_disease)
		if(length(diseases))
			data["diseases"] = diseases
		else
			data["diseases"] = null // interstingly even if we don't set data at all, re-using UI that had this data still has it

	data["ssd"] = null //clear the data in case we have an old input from a previous scan
	if(target_mob.getBrainLoss() >= 100 || !target_mob.has_brain())
		data["ssd"] = "Subject has taken extreme amounts of brain damage."
	else if(target_mob.has_brain() && target_mob.stat != DEAD && ishuman(target_mob))
		if(!target_mob.key)
			data["ssd"] = "No soul detected." // they ghosted
		else if(!target_mob.client)
			data["ssd"] = "SSD detected." // SSD

	return data

/datum/health_scan/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("change_holo_card")
			if(ishuman(target_mob))
				var/mob/living/carbon/human/target_human = target_mob
				target_human.change_holo_card(ui.user)
				return TRUE

/// legacy proc for to_chat messages on health analysers
/mob/living/proc/health_scan(mob/living/carbon/human/user, ignore_delay = FALSE, show_limb_damage = TRUE, show_browser = TRUE, alien = FALSE, do_checks = TRUE) // ahem. FUCK WHOEVER CODED THIS SHIT AS NUMBERS AND NOT DEFINES.
	if(do_checks)
		if((user.getBrainLoss() >= 60) && prob(50))
			to_chat(user, SPAN_WARNING("You try to analyze the floor's vitals!"))
			for(var/mob/O in viewers(src, null))
				O.show_message(SPAN_WARNING("[user] has analyzed the floor's vitals!"), 1)
			user.show_message(SPAN_NOTICE("Health Analyzer results for The floor:\n\t Overall Status: Healthy"), 1)
			user.show_message(SPAN_NOTICE("\t Damage Specifics: [0]-[0]-[0]-[0]"), 1)
			user.show_message(SPAN_NOTICE("Key: Suffocation/Toxin/Burns/Brute"), 1)
			user.show_message(SPAN_NOTICE("Body Temperature: ???"), 1)
			return
		if(HAS_TRAIT(src, TRAIT_FOREIGN_BIO) && !alien)
			to_chat(user, SPAN_WARNING("ERROR: Unknown biology detected."))
			return
		if(!(ishuman(user) || SSticker?.mode.name == "monkey"))
			to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this!"))
			return
		if(!ignore_delay && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("You start fumbling around with [src]..."))
			var/fduration = 60
			if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_DEFAULT))
				fduration = 30
			if(!do_after(user, fduration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY) || !user.Adjacent(src))
				return
		if(isxeno(src))
			to_chat(user, SPAN_WARNING("[src] can't make sense of this creature."))
			return
		// Doesn't work on non-humans
		if(!istype(src, /mob/living/carbon))
			user.show_message("\nHealth Analyzer results for ERROR:\n\t Overall Status: ERROR")
			user.show_message("\tType: [SET_CLASS("Oxygen", INTERFACE_BLUE)]-[SET_CLASS("Toxin", INTERFACE_GREEN)]-[SET_CLASS("Burns", INTERFACE_ORANGE)]-[SET_CLASS("Brute", INTERFACE_RED)]", 1)
			user.show_message("\tDamage: [SET_CLASS("?", INTERFACE_BLUE)] - [SET_CLASS("?", INTERFACE_GREEN)] - [SET_CLASS("?", INTERFACE_ORANGE)] - [SET_CLASS("?", INTERFACE_RED)]")
			user.show_message(SPAN_NOTICE("Body Temperature: [src.bodytemperature-T0C]&deg;C ([src.bodytemperature*1.8-459.67]&deg;F)"), 1)
			user.show_message(SPAN_DANGER("<b>Warning: Blood Level ERROR: --% --cl.Type: ERROR"))
			user.show_message(SPAN_NOTICE("Subject's pulse: [SET_CLASS("-- bpm", INTERFACE_RED)]"))
			return

	var/dat = ""
	// Calculate damage amounts
	var/fake_oxy = max(rand(1,40), src.getOxyLoss(), (300 - (src.getToxLoss() + src.getFireLoss() + src.getBruteLoss())))
	var/OX = src.getOxyLoss() > 50 ? "<b>[src.getOxyLoss()]</b>" : src.getOxyLoss()
	var/TX = src.getToxLoss() > 50 ? "<b>[src.getToxLoss()]</b>" : src.getToxLoss()
	var/BU = src.getFireLoss() > 50 ? "<b>[src.getFireLoss()]</b>" : src.getFireLoss()
	var/BR = src.getBruteLoss() > 50 ? "<b>[src.getBruteLoss()]</b>" : src.getBruteLoss()

	// Show overall
	if(src.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? "<b>[fake_oxy]</b>" : fake_oxy
		dat += "\nHealth Analyzer for [src]:\n\tOverall Status: <b>DEAD</b>\n"
	else
		dat += "\nHealth Analyzer results for [src]:\n\tOverall Status: [src.stat > 1 ? "<b>DEAD</b>" : "<b>[src.health - src.halloss]% healthy"]</b>\n"
	dat += "\tType: [SET_CLASS("Oxygen", INTERFACE_BLUE)]-[SET_CLASS("Toxin", INTERFACE_GREEN)]-[SET_CLASS("Burns", INTERFACE_ORANGE)]-[SET_CLASS("Brute", INTERFACE_RED)]\n"
	dat += "\tDamage: \t[SET_CLASS(OX, INTERFACE_BLUE)] - [SET_CLASS(TX, INTERFACE_GREEN)] - [SET_CLASS(BU, INTERFACE_ORANGE)] - [SET_CLASS(BR, INTERFACE_RED)]\n"
	dat += "\tUntreated: {B}=Burns,{T}=Trauma,{F}=Fracture\n"

	var/unrevivable = 0

	// Show specific limb damage
	if(istype(src, /mob/living/carbon/human) && show_limb_damage)
		var/mob/living/carbon/human/H = src
		for(var/obj/limb/org in H.limbs)
			var/brute_treated = TRUE
			var/burn_treated = TRUE
			var/open_incision = org.get_incision_depth() ? " <span class='scanner'>Open surgical incision</span>" : ""

			if((org.brute_dam > 0 && !org.is_bandaged()) || open_incision)
				brute_treated = FALSE
			if(org.burn_dam > 0 && !org.is_salved())
				burn_treated = FALSE
			if(org.status & LIMB_DESTROYED)
				dat += "\t\t [capitalize(org.display_name)]: <span class='scannerb'>Missing!</span>\n"
				continue

			var/bleeding_check = FALSE
			for(var/datum/effects/bleeding/external/E in org.bleeding_effects_list)
				bleeding_check = TRUE
				break
			var/show_limb = (org.burn_dam > 0 || org.brute_dam > 0 || (org.status & LIMB_SPLINTED) || open_incision || bleeding_check)

			var/org_name = "[capitalize(org.display_name)]"
			if(org.status & LIMB_ROBOT)
				if(org.status & LIMB_UNCALIBRATED_PROSTHETIC)
					org_name += " (Nonfunctional Cybernetic)]"
					show_limb = TRUE
				else
					org_name += " (Cybernetic)"
			else if(org.status & LIMB_SYNTHSKIN)
				org_name += " (Synthskin)"

			var/burn_info = org.burn_dam > 0 ? "<span class='scannerburnb'> [floor(org.burn_dam)]</span>" : "<span class='scannerburn'>0</span>"
			burn_info += "[burn_treated ? "" : "{B}"]"
			var/brute_info =  org.brute_dam > 0 ? "<span class='scannerb'> [floor(org.brute_dam)]</span>" : "<span class='scanner'>0</span>"
			brute_info += "[brute_treated ? "" : "{T}"]"
			var/fracture_info = ""
			if(org.status & LIMB_BROKEN)
				fracture_info = "{F}"
				show_limb = 1

			var/org_bleed = ""
			if(bleeding_check)
				org_bleed = SPAN_SCANNERB("(Bleeding)")

			var/org_advice = ""
			if(do_checks && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				switch(org.name)
					if("head")
						fracture_info = ""
						if(org.brute_dam > 40 || src.getBrainLoss() >= 20)
							org_advice = " Possible Skull Fracture."
							show_limb = 1
					if("chest")
						fracture_info = ""
						if(org.brute_dam > 40 || src.getOxyLoss() > 50)
							org_advice = " Possible Chest Fracture."
							show_limb = 1
					if("groin")
						fracture_info = ""
						if(org.brute_dam > 40 || src.getToxLoss() > 50)
							org_advice = " Possible Groin Fracture."
							show_limb = 1
			if(show_limb)
				dat += "\t\t [org_name]: \t [burn_info] - [brute_info] [fracture_info][org_bleed][open_incision][org_advice]"
				if(org.status & LIMB_SPLINTED_INDESTRUCTIBLE)
					dat += "(Nanosplinted)"
				else if(org.status & LIMB_SPLINTED)
					dat += "(Splinted)"
				dat += "\n"

	// Show red messages - broken bokes, etc
	if (src.getCloneLoss())
		dat += "\t<span class='scanner'> *Subject appears to have been imperfectly cloned.</span>\n"
	for(var/datum/disease/D in src.viruses)
		if(!D.hidden[SCANNER])
			dat += "\t<span class='scannerb'> *Warning: [D.form] Detected</span><span class='scanner'>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]</span>\n"
	if (src.getBrainLoss() >= 100 || !src.has_brain())
		dat += "\t<span class='scanner'> *Subject has taken extreme amounts of <b>brain damage</b></span>.\n"

	if(src.has_brain() && src.stat != DEAD && ishuman(src))
		if(!src.key)
			dat += SPAN_WARNING("\tNo soul detected.\n") // they ghosted
		else if(!src.client)
			dat += SPAN_WARNING("\tSSD detected.\n") // SSD

	var/internal_bleed_detected = FALSE
	var/embedded_item_detected = FALSE
	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if(length(H.embedded_items) > 0)
			embedded_item_detected = TRUE

		var/core_fracture = 0
		for(var/X in H.limbs)
			var/obj/limb/e = X
			for(var/datum/effects/bleeding/internal/I in e.bleeding_effects_list)
				internal_bleed_detected = TRUE
				break
			if(e.status & LIMB_BROKEN)
				if(!((e.name == "l_arm") || (e.name == "r_arm") || (e.name == "l_leg") || (e.name == "r_leg") || (e.name == "l_hand") || (e.name == "r_hand") || (e.name == "l_foot") || (e.name == "r_foot")))
					core_fracture = 1
		if(core_fracture)
			dat += "\t[SPAN_SCANNER("*<b>Bone fractures</b> detected. Advanced scanner required for location.")]\n"
		if(internal_bleed_detected)
			dat += "\t[SPAN_SCANNER("*<b>Internal bleeding</b> detected. Advanced scanner required for location.")]\n"
		if(embedded_item_detected)
			dat += "\t[SPAN_SCANNER("*<b>Embedded object</b> detected. Advanced scanner required for location.")]\n"

	var/reagents_in_body[0] // yes i know -spookydonut
	if(istype(src, /mob/living/carbon))
		// Show helpful reagents
		if(src.reagents && (src.reagents.total_volume > 0))
			var/unknown = 0
			var/reagentdata[0]
			for(var/A in src.reagents.reagent_list)
				var/datum/reagent/R = A
				reagents_in_body["[R.id]"] = R.volume
				if(R.flags & REAGENT_SCANNABLE)
					reagentdata["[R.id]"] = "[R.overdose != 0 && R.volume > R.overdose && !(R.flags & REAGENT_CANNOT_OVERDOSE) ? SPAN_WARNING("<b>OD: </b>") : ""] <font color='#9773C4'><b>[round(R.volume, 1)]u [R.name]</b></font>"
				else
					unknown++
			if(length(reagentdata))
				dat += "\n\tBeneficial reagents:\n"
				for(var/d in reagentdata)
					dat += "\t\t [reagentdata[d]]\n"
			if(unknown)
				dat += "\t<span class='scanner'> Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.</span>\n"

	// Show body temp
	dat += "\n\tBody Temperature: [src.bodytemperature-T0C]&deg;C ([src.bodytemperature*1.8-459.67]&deg;F)\n"

	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		// Show blood level
		var/blood_volume = BLOOD_VOLUME_NORMAL
		if(!(H.species && H.species.flags & NO_BLOOD))
			blood_volume = floor(H.blood_volume)

			var/blood_percent =  blood_volume / 560
			var/blood_type = H.blood_type
			blood_percent *= 100
			if(blood_volume <= 500 && blood_volume > 336)
				dat += "\t<span class='scanner'> <b>Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl.</span> [SET_CLASS("Type: [blood_type]", INTERFACE_BLUE)]\n"
			else if(blood_volume <= 336)
				dat += "\t<span class='scanner'> <b>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl.</span> [SET_CLASS("Type: [blood_type]", INTERFACE_BLUE)]\n"
			else
				dat += "\tBlood Level normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]\n"
		// Show pulse
		dat += "\tPulse: <span class='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? INTERFACE_RED : ""]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</span>\n"
		if((H.stat == DEAD && !H.client))
			unrevivable = 1
		if(!unrevivable)
			var/advice = ""
			if(blood_volume <= 500 && !reagents_in_body["nutriment"])
				advice += "<span class='scanner'>Administer food or recommend the patient eat.</span>\n"
			if(H.getToxLoss() > 10 && reagents_in_body["anti_toxin"] < 5)
				advice += "<span class='scanner'>Administer a single dose of dylovene.</span>\n"
			if((H.getToxLoss() > 50 || (H.getOxyLoss() > 50 && blood_volume > 400) || H.getBrainLoss() >= 10) && reagents_in_body["peridaxon"] < 5)
				advice += "<span class='scanner'>Administer a single dose of peridaxon.</span>\n"
			if(H.getOxyLoss() > 50 && reagents_in_body["dexalin"] < 5)
				advice += "<span class='scanner'>Administer a single dose of dexalin.</span>\n"
			if(H.getFireLoss(1) > 30 && reagents_in_body["kelotane"] < 3)
				advice += "<span class='scanner'>Administer a single dose of kelotane.</span>\n"
			if(H.getBruteLoss(1) > 30 && reagents_in_body["bicaridine"] < 3)
				advice += "<span class='scanner'>Administer a single dose of bicaridine.</span>\n"
			if(H.health < 0 && reagents_in_body["inaprovaline"] < 5)
				advice += "<span class='scanner'>Administer a single dose of inaprovaline.</span>\n"

			var/has_pain = FALSE
			for(var/datum/effects/pain/P in H.effects_list)
				has_pain = TRUE
				break

			if(has_pain && reagents_in_body["tramadol"] < 3 && !reagents_in_body["paracetamol"])
				advice += "<span class='scanner'>Administer a single dose of tramadol.</span>\n"
			if(advice != "")
				dat += "\t<span class='scanner'> <b>Medication Advice:</b></span>\n"
				dat += advice
			advice = ""
			if(reagents_in_body["paracetamol"])
				advice += "<span class='scanner'>DO NOT administer tramadol.</span>\n"
			if(advice != "")
				dat += "\t<span class='scanner'> <b>Contradictions:</b></span>\n"
				dat += advice

	if(show_browser)
		dat = replacetext(dat, "\n", "<br>")
		dat = replacetext(dat, "\t", "&emsp;")
		dat = replacetext(dat, "class='warning'", "class='[INTERFACE_RED]'")
		dat = replacetext(dat, "class='scanner'", "class='[INTERFACE_RED]'")
		dat = replacetext(dat, "class='scannerb'", "style='font-weight: bold;' class='[INTERFACE_RED]'")
		dat = replacetext(dat, "class='scannerburn'", "class='[INTERFACE_ORANGE]'")
		dat = replacetext(dat, "class='scannerburnb'", "style='font-weight: bold;' class='[INTERFACE_ORANGE]'")
		show_browser(user, dat, name, "handscanner", "size=500x400")
	else
		user.show_message(dat, 1)

	return dat
