/mob/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_EXPLODE, "Trigger Explosion")
	VV_DROPDOWN_OPTION(VV_HK_EMPULSE, "Trigger EM Pulse")
	VV_DROPDOWN_OPTION(VV_HK_SETMATRIX, "Set Base Matrix")
	VV_DROPDOWN_OPTION("", "-----MOB-----")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_DISEASE, "Give Disease")
	VV_DROPDOWN_OPTION(VV_HK_GODMODE, "Toggle God")
	VV_DROPDOWN_OPTION(VV_HK_BUILDMODE, "Give Build Mode")
	VV_DROPDOWN_OPTION(VV_HK_GIB, "Gib")
	VV_DROPDOWN_OPTION(VV_HK_DROP_ALL, "Drop All")
	VV_DROPDOWN_OPTION(VV_HK_DIRECT_CONTROL, "Assume Direct Control")
	VV_DROPDOWN_OPTION(VV_HK_PLAYER_PANEL, "Open Player Panel")
	VV_DROPDOWN_OPTION(VV_HK_ADD_VERB, "Add Verb")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_VERB, "Remove Verb")
	VV_DROPDOWN_OPTION(VV_HK_SELECT_EQUIPMENT, "Select Equipment")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_SKILL, "Edit Skills")
	VV_DROPDOWN_OPTION(VV_HK_ADD_LANGUAGE, "Add Language")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_LANGUAGE, "Remove Language")
	VV_DROPDOWN_OPTION(VV_HK_REGEN_ICONS, "Regenerate Icons")
	VV_DROPDOWN_OPTION(VV_HK_ADD_ORGAN, "Add Organ")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_ORGAN, "Remove Organ")
	VV_DROPDOWN_OPTION(VV_HK_ADD_LIMB, "Add Limb")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_LIMB, "Remove Limb")

/mob/vv_do_topic(list/href_list)
	. = ..()

	if(href_list[VV_HK_SETMATRIX])
		if(!check_rights(R_DEBUG|R_ADMIN|R_VAREDIT))
			return

		var/atom/A = locate(href_list[VV_HK_SETMATRIX])
		if(!isobj(A) && !ismob(A))
			to_chat(usr, "This can only be done to instances of type /obj and /mob")
			return

		if(!LAZYLEN(usr.client.stored_matrices))
			to_chat(usr, "You don't have any matrices stored!")
			return

		var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (usr.client.stored_matrices + "Revert to Default" + "Cancel"))
		if(!matrix_name || matrix_name == "Cancel")
			return
		else if (matrix_name == "Revert to Default")
			A.base_transform = null
			A.transform = matrix()
			A.disable_pixel_scaling()
			return

		var/matrix/MX = LAZYACCESS(usr.client.stored_matrices, matrix_name)
		if(!MX)
			return

		A.base_transform = MX
		A.transform = MX

		if (alert(usr, "Would you like to enable pixel scaling?", "Confirm", "Yes", "No") == "Yes")
			A.enable_pixel_scaling()

	if(href_list[VV_HK_GIVE_DISEASE])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list[VV_HK_GIVE_DISEASE])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		usr.client.give_disease(M)

	if(href_list[VV_HK_BUILDMODE])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list[VV_HK_BUILDMODE])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(!M.client || !M.client.admin_holder || !(M.client.admin_holder.rights & R_MOD))
			to_chat(usr, "This can only be used on people with +MOD permissions")
			return

		log_admin("[key_name(usr)] has toggled buildmode on [key_name(M)]")
		message_staff("[key_name_admin(usr)] has toggled buildmode on [key_name_admin(M)]")

		togglebuildmode(M)

	if(href_list[VV_HK_GIB])
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list[VV_HK_GIB])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		usr.client.cmd_admin_gib(M)

	if(href_list[VV_HK_DROP_ALL])
		if(!check_rights(R_DEBUG|R_ADMIN))
			return

		var/mob/M = locate(href_list[VV_HK_DROP_ALL])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_admin_drop_everything(M)

	if(href_list[VV_HK_DIRECT_CONTROL])
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list[VV_HK_DIRECT_CONTROL])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_assume_direct_control(M)

	if(href_list[VV_HK_PLAYER_PANEL])
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list[VV_HK_PLAYER_PANEL])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

	if(href_list[VV_HK_ADD_VERB])
		if(!check_rights(R_DEBUG))
			return

		var/mob/living/H = locate(href_list[VV_HK_ADD_VERB])

		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living")
			return
		var/list/possibleverbs = list()
		possibleverbs += "Cancel" // One for the top...
		possibleverbs += typesof(/mob/proc,/mob/verb,/mob/living/proc,/mob/living/verb)
		switch(H.type)
			if(/mob/living/carbon/human)
				possibleverbs += typesof(/mob/living/carbon/proc,/mob/living/carbon/verb,/mob/living/carbon/human/verb,/mob/living/carbon/human/proc)
			if(/mob/living/silicon/robot)
				possibleverbs += typesof(/mob/living/silicon/proc,/mob/living/silicon/robot/proc,/mob/living/silicon/robot/verb)
			if(/mob/living/silicon/ai)
				possibleverbs += typesof(/mob/living/silicon/proc,/mob/living/silicon/ai/proc)
		possibleverbs -= H.verbs
		possibleverbs += "Cancel" // ...And one for the bottom

		var/verb = tgui_input_list(usr, "Select a verb!", "Verbs", possibleverbs)
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb || verb == "Cancel")
			return
		else
			add_verb(H, verb)

	if(href_list[VV_HK_SELECT_EQUIPMENT])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list[VV_HK_SELECT_EQUIPMENT])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		usr.client.cmd_admin_dress(H)

	if(href_list[VV_HK_ADD_LANGUAGE])
		if(!check_rights(R_SPAWN))
			return

		var/mob/H = locate(href_list[VV_HK_ADD_LANGUAGE])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return

		var/new_language = tgui_input_list(usr, "Please choose a language to add.","Language", GLOB.all_languages)

		if(!new_language)
			return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.add_language(new_language))
			to_chat(usr, "Added [new_language] to [H].")
		else
			to_chat(usr, "Mob already knows that language.")

	if(href_list[VV_HK_REMOVE_LANGUAGE])
		if(!check_rights(R_SPAWN))
			return

		var/mob/H = locate(href_list[VV_HK_REMOVE_LANGUAGE])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return

		if(!H.languages.len)
			to_chat(usr, "This mob knows no languages.")
			return

		var/datum/language/rem_language = tgui_input_list(usr, "Please choose a language to remove.","Language", H.languages)

		if(!rem_language)
			return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.remove_language(rem_language.name))
			to_chat(usr, "Removed [rem_language] from [H].")
		else
			to_chat(usr, "Mob doesn't know that language.")

	if(href_list[VV_HK_REMOVE_VERB])
		if(!check_rights(R_DEBUG))
			return

		var/mob/H = locate(href_list[VV_HK_REMOVE_VERB])

		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		var/verb = tgui_input_list(usr, "Please choose a verb to remove.","Verbs", H.verbs)
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb)
			return
		else
			remove_verb(H, verb)

	if(href_list[VV_HK_REGEN_ICONS])
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list[VV_HK_REGEN_ICONS])
		if(!ismob(M))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		M.regenerate_icons()

	if(href_list[VV_HK_ADD_ORGAN])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/M = locate(href_list[VV_HK_ADD_ORGAN])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/new_organ = tgui_input_list(usr, "Please choose an organ to add.","Organ",null, typesof(/datum/internal_organ)-/datum/internal_organ)

		if(!new_organ)
			return FALSE

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(locate(new_organ) in M.internal_organs)
			to_chat(usr, "Mob already has that organ.")
			return

		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/datum/internal_organ/I = new new_organ(H)

			var/organ_slot = input(usr, "Which slot do you want the organ to go in ('default' for default)?")  as text|null

			if(!organ_slot)
				return

			if(organ_slot != "default")
				organ_slot = sanitize(copytext(organ_slot,1,MAX_MESSAGE_LEN))
			else
				if(I.removed_type)
					var/obj/item/organ/O = new I.removed_type()
					organ_slot = O.organ_tag
					qdel(O)
				else
					organ_slot = "unknown organ"

			if(H.internal_organs_by_name[organ_slot])
				to_chat(usr, "[H] already has an organ in that slot.")
				qdel(I)
				return

			H.internal_organs_by_name[organ_slot] = I
			to_chat(usr, "Added new [new_organ] to [H] as slot [organ_slot].")
		else
			new new_organ(M)
			to_chat(usr, "Added new [new_organ] to [M].")

	if(href_list[VV_HK_REMOVE_ORGAN])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/M = locate(href_list[VV_HK_REMOVE_ORGAN])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/rem_organ = tgui_input_list(usr, "Please choose an organ to remove.","Organ",null, M.internal_organs)

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(!(locate(rem_organ) in M.internal_organs))
			to_chat(usr, "Mob does not have that organ.")
			return

		to_chat(usr, "Removed [rem_organ] from [M].")
		qdel(rem_organ)

	if(href_list[VV_HK_ADD_LIMB])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/M = locate(href_list[VV_HK_ADD_LIMB])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/new_limb = tgui_input_list(usr, "Please choose an organ to add.","Organ", typesof(/obj/limb)-/obj/limb)

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		var/obj/limb/EO = locate(new_limb) in M.limbs
		if(!EO)
			return
		if(!(EO.status & LIMB_DESTROYED))
			to_chat(usr, "Mob already has that organ.")
			return

		EO.status = NO_FLAGS
		EO.perma_injury = 0
		EO.reset_limb_surgeries()
		M.update_body(0)
		M.updatehealth()
		M.UpdateDamageIcon()

	if(href_list[VV_HK_REMOVE_LIMB])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/M = locate(href_list[VV_HK_REMOVE_LIMB])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/rem_limb = tgui_input_list(usr, "Please choose a limb to remove.","Organ", M.limbs)

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		var/obj/limb/EO = locate(rem_limb) in M.limbs
		if(!EO)
			return
		if(EO.status & LIMB_DESTROYED)
			to_chat(usr, "Mob doesn't have that limb.")
			return
		EO.droplimb()

/mob/proc/has_disease(var/datum/disease/virus)
	for(var/datum/disease/D in viruses)
		if(D.IsSame(virus))
			//error("[D.name]/[D.type] is the same as [virus.name]/[virus.type]")
			return 1
	return 0

// This proc has some procs that should be extracted from it. I believe we can develop some helper procs from it - Rockdtben
/mob/proc/contract_disease(var/datum/disease/virus, var/skip_this = 0, var/force_species_check=1, var/spread_type = -5)
	if(stat == DEAD)
		return
	if(istype(virus, /datum/disease/advance))
		var/datum/disease/advance/A = virus
		if(A.GetDiseaseID() in resistances)
			return
		if(count_by_type(viruses, /datum/disease/advance) >= 3)
			return

	else
		if(src.resistances.Find(virus.type))
			return

	if(has_disease(virus))
		return

	if(force_species_check)
		var/fail = TRUE
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			for(var/vuln_species in virus.affected_species)
				if(H.species.name == vuln_species)
					fail = FALSE
					break

		if(fail) return

	if(skip_this == 1)
		//if(src.virus) < -- this used to replace the current disease. Not anymore!
			//src.virus.cure(0)
		var/datum/disease/v = virus.Copy()
		src.viruses += v
		v.affected_mob = src
		v.strain_data = v.strain_data.Copy()
		v.holder = src
		if(v.can_carry && prob(5))
			v.carrier = 1
		return

	if(prob(15/virus.permeability_mod)) return //the power of immunity compels this disease! but then you forgot resistances
	var/passed = 1

	//chances to target this zone
	var/head_ch
	var/body_ch
	var/hands_ch
	var/feet_ch

	if(spread_type == -5)
		spread_type = virus.spread_type

	switch(spread_type)
		if(CONTACT_HANDS)
			head_ch = 0
			body_ch = 0
			hands_ch = 100
			feet_ch = 0
		if(CONTACT_FEET)
			head_ch = 0
			body_ch = 0
			hands_ch = 0
			feet_ch = 100
		else
			head_ch = 100
			body_ch = 100
			hands_ch = 25
			feet_ch = 25


	var/target_zone = pick(head_ch;1,body_ch;2,hands_ch;3,feet_ch;4)//1 - head, 2 - body, 3 - hands, 4- feet

	passed = check_disease_pass_clothes(target_zone)

	if(!passed && spread_type == AIRBORNE && !internal)
		passed = (prob((50*virus.permeability_mod) - 1))

	if(passed)
		AddDisease(virus)

/mob/living/carbon/human/contract_disease(datum/disease/virus, skip_this = 0, force_species_check=1, spread_type = -5)
	if(species.flags & IS_SYNTHETIC) return //synthetic species are immune
	..(virus, skip_this, force_species_check, spread_type)

/mob/proc/AddDisease(datum/disease/D, var/roll_for_carrier = TRUE)
	var/datum/disease/DD = new D.type(1, D)
	viruses += DD
	DD.affected_mob = src
	DD.strain_data = DD.strain_data.Copy()
	DD.holder = src
	if(DD.can_carry && roll_for_carrier && prob(5))
		DD.carrier = 1

	return DD

/mob/living/carbon/human/AddDisease(datum/disease/D)
	. = ..()
	med_hud_set_status()

//returns whether the mob's clothes stopped the disease from passing through
/mob/proc/check_disease_pass_clothes(target_zone)
	return 1

/mob/living/carbon/human/check_disease_pass_clothes(target_zone)
	var/obj/item/clothing/Cl
	switch(target_zone)
		if(1)
			if(isobj(head) && !istype(head, /obj/item/paper))
				Cl = head
				. = prob((Cl.permeability_coefficient*100) - 1)
			if(. && wear_mask)
				. = prob((Cl.permeability_coefficient*100) - 1)
		if(2)//arms and legs included
			if(isobj(wear_suit))
				Cl = wear_suit
				. = prob((Cl.permeability_coefficient*100) - 1)
			if(. && isobj(WEAR_BODY))
				Cl = WEAR_BODY
				. = prob((Cl.permeability_coefficient*100) - 1)
		if(3)
			if(isobj(wear_suit) && wear_suit.flags_armor_protection & BODY_FLAG_HANDS)
				Cl = wear_suit
				. = prob((Cl.permeability_coefficient*100) - 1)

			if(. && isobj(gloves))
				Cl = gloves
				. = prob((Cl.permeability_coefficient*100) - 1)
		if(4)
			if(isobj(wear_suit) && wear_suit.flags_armor_protection & BODY_FLAG_FEET)
				Cl = wear_suit
				. = prob((Cl.permeability_coefficient*100) - 1)

			if(. && isobj(shoes))
				Cl = shoes
				. = prob((Cl.permeability_coefficient*100) - 1)
		else
			to_chat(src, "Something bad happened with disease target zone code, tell a dev or admin ")

