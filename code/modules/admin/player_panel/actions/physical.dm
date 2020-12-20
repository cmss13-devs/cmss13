/datum/player_action/delimb
	action_tag = "mob_delimb"
	name = "Delimb"
	permissions_required = R_VAREDIT

/datum/player_action/delimb/act(var/client/user, var/mob/target, var/list/params)
	if(!params["limbs"] || !ishuman(target))
		return

	var/mob/living/carbon/human/H = target

	for(var/limb in params["limbs"])
		if(!limb)
			continue

		if(!H.has_limb(limb))
			continue

		var/obj/limb/L = H.get_limb(limb)
		L.droplimb(cause = user.key)

	playsound(target, "bone_break", 45, TRUE)
	target.emote("scream")

	return TRUE

/datum/player_action/relimb
	action_tag = "mob_relimb"
	name = "Relimb"
	permissions_required = R_VAREDIT

/datum/player_action/relimb/act(var/client/user, var/mob/target, var/list/params)
	if(!params["limbs"] || !ishuman(target))
		return

	var/mob/living/carbon/human/H = target

	// These will always be last, because they get appended after.
	for(var/limb in params["limbs"])
		switch(limb)
			if("r_leg")
				params["limbs"] += "r_foot"
			if("l_leg")
				params["limbs"] += "l_foot"
			if("r_arm")
				params["limbs"] += "r_hand"
			if("l_arm")
				params["limbs"] += "l_hand"

	for(var/limb in params["limbs"])
		if(!limb)
			continue

		if(H.has_limb(limb))
			continue

		var/obj/limb/L = H.get_limb(limb)

		L.rejuvenate()

	H.pain.recalculate_pain()

	to_chat(target, SPAN_HELPFUL("You feel your limbs regrow back."))

	return TRUE

/datum/player_action/cryo_human
	action_tag = "cryo_human"
	name = "Cryo Human"


/datum/player_action/cryo_human/act(var/client/user, var/mob/target, var/list/params)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.assigned_squad)
			var/datum/squad/S = H.assigned_squad
			if(H.job == JOB_SQUAD_SPECIALIST)
				//we make the set this specialist took if any available again
				if(H.skills)
					var/set_name
					switch(H.skills.get_skill_level(SKILL_SPEC_WEAPONS))
						if(SKILL_SPEC_ROCKET)
							set_name = "Demolitionist Set"
						if(SKILL_SPEC_GRENADIER)
							set_name = "Heavy Grenadier Set"
						if(SKILL_SPEC_PYRO)
							set_name = "Pyro Set"
						if(SKILL_SPEC_SCOUT)
							set_name = "Scout Set"
						if(SKILL_SPEC_SNIPER)
							set_name = "Sniper Set"

					if(set_name && !available_specialist_sets.Find(set_name))
						available_specialist_sets += set_name
			S.forget_marine_in_squad(H)

	SSticker.mode.latejoin_tally-- //Cryoing someone out removes someone from the Marines, blocking further larva spawns until accounted for

	//Handle job slot/tater cleanup.
	RoleAuthority.free_role(RoleAuthority.roles_for_mode[target.job], TRUE)

	//Delete them from datacore.
	for(var/datum/data/record/R in GLOB.data_core.medical)
		if((R.fields["name"] == target.real_name))
			GLOB.data_core.medical -= R
			qdel(R)
	for(var/datum/data/record/T in GLOB.data_core.security)
		if((T.fields["name"] == target.real_name))
			GLOB.data_core.security -= T
			qdel(T)
	for(var/datum/data/record/G in GLOB.data_core.general)
		if((G.fields["name"] == target.real_name))
			GLOB.data_core.general -= G
			qdel(G)

	if(target.key)
		target.ghostize(FALSE)

	qdel(target)
	return TRUE


/datum/player_action/set_speed
	action_tag = "set_speed"
	name = "Set Speed"
	permissions_required = R_VAREDIT

/datum/player_action/set_speed/act(var/client/user, var/mob/target, var/list/params)
	if(isnull(params["speed"]))
		return

	target.speed = text2num(params["speed"])

	return TRUE

/datum/player_action/set_status_flags
	action_tag = "set_status_flags"
	name = "Set Status Flags"
	permissions_required = R_VAREDIT

/datum/player_action/set_status_flags/act(var/client/user, var/mob/target, var/list/params)
	if(isnull(params["status_flags"]))
		return

	target.status_flags = text2num(params["status_flags"])

	return TRUE

/datum/player_action/set_pain
	action_tag = "set_pain"
	name = "Set Pain"
	permissions_required = R_VAREDIT

/datum/player_action/set_pain/act(var/client/user, var/mob/target, var/list/params)
	if(isnull(params["feels_pain"]))
		return

	if(!isliving(target))
		return

	var/mob/living/L = target
	L.pain?.feels_pain = params["feels_pain"]

	return TRUE

/datum/player_action/select_equipment
	action_tag = "select_equipment"
	name = "Select Equipment"
	permissions_required = R_SPAWN

/datum/player_action/select_equipment/act(var/client/user, var/mob/target, var/list/params)
	user.cmd_admin_dress_human(target)
	return TRUE

/datum/player_action/strip_equipment
	action_tag = "strip_equipment"
	name = "Strip Equipment"
	permissions_required = R_SPAWN

/datum/player_action/strip_equipment/act(var/client/user, var/mob/target, var/list/params)
	for (var/obj/item/I in target)
		if(params["drop_items"])
			target.drop_inv_item_to_loc(I, target.loc, FALSE, TRUE)
		else
			qdel(I)

	message_staff("[key_name_admin(user)] stripped [target] of their items.")
	return TRUE
