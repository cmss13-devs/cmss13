/datum/action/item_action/specialist
	var/ability_primacy = SPEC_NOT_PRIMARY_ACTION

/datum/action/item_action/specialist/proc/handle_spec_macro()
	if (can_use_action())
		action_activate()

/datum/action/item_action/specialist/update_button_icon()
	if(!action_cooldown_check())
		button.color = rgb(120,120,120,200)
	else
		button.color = rgb(255,255,255,255)

// Spec verb macros
/mob/living/carbon/human/verb/spec_activation_one()
	set name = "Specialist Activation One"
	set hidden = TRUE

	var/mob/living/carbon/human/H = src
	if (!istype(H))
		return
	for (var/datum/action/item_action/specialist/SA in H.actions)
		if (SA.ability_primacy == SPEC_PRIMARY_ACTION_1)
			SA.handle_spec_macro()

/mob/living/carbon/human/verb/spec_activation_two()
	set name = "Specialist Activation Two"
	set hidden = TRUE

	var/mob/living/carbon/human/H = src
	if (!istype(H))
		return
	for (var/datum/action/item_action/specialist/SA in H.actions)
		if (SA.ability_primacy == SPEC_PRIMARY_ACTION_2)
			SA.handle_spec_macro()

/// Get a specialist set datum typepath given a mob, returns null if they aren't a spec or haven't chosen a kit.
/proc/get_specialist_set(mob/living/spec)
	for(var/datum/specialist_set/path as anything in GLOB.specialist_set_datums)
		if(HAS_TRAIT(spec, TRAIT_SPEC(path::trait_to_give)))
			return path

/proc/setup_specialist_sets()
	var/list/set_list = list()
	for(var/datum/specialist_set/path as anything in subtypesof(/datum/specialist_set))
		var/datum/specialist_set/object = new path
		set_list[path] = object
		GLOB.specialist_set_name_dict[object.get_name()] = object
	return set_list

/datum/specialist_set
	/// Human-readable name for the specialist set
	VAR_PROTECTED/name = "" as text
	/// What is the role title that should go on ID cards
	VAR_PROTECTED/role_name = "" as text
	/// How many more of this spec set can be picked from spec vendors
	VAR_PROTECTED/available_vendor_num = 1 as num
	/// How many more of this spec set can be picked from /obj/item/spec_kit
	VAR_PROTECTED/available_kit_num = 2 as num
	/// What skill tier to give the person redeeming the set
	VAR_PROTECTED/skill_to_give = SKILL_SPEC_DEFAULT as num
	/// What trait to give the person redeeming the set
	VAR_PROTECTED/trait_to_give
	/// What typepath to spawn for the redeemer if from a kit
	VAR_PROTECTED/kit_typepath
	/// Icon to override on huds and minimaps
	VAR_PROTECTED/rank_icon = "spec"
	/// List of typepaths that are incompatible with this set, meaning it'll subtract 1 from their vendor/kit num as well
	VAR_PROTECTED/list/incompatible_sets = list()

/datum/specialist_set/New()
	. = ..()
	incompatible_sets += type
	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, PROC_REF(post_round_start))


/datum/specialist_set/proc/post_round_start()
	if(SSticker && MODE_HAS_MODIFIER(/datum/gamemode_modifier/heavy_specialists))
		available_vendor_num = 0
		available_kit_num = 0

/datum/specialist_set/proc/redeem_set(mob/living/carbon/human/redeemer, kit = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(!redeemer)
		return FALSE

	if(kit && (available_kit_num <= 0))
		to_chat(redeemer, SPAN_WARNING("No more kits of this type may be chosen."))
		return FALSE
	else if(!kit && (available_vendor_num <= 0))
		to_chat(redeemer, SPAN_WARNING("That set is already taken."))
		return FALSE

	if(skill_to_give != SKILL_SPEC_DEFAULT)
		redeemer.skills?.set_skill(SKILL_SPEC_WEAPONS, skill_to_give)

	if(kit)
		redeemer.put_in_any_hand_if_possible(new kit_typepath, FALSE)
		for(var/path in incompatible_sets)
			GLOB.specialist_set_datums[path].available_kit_num--
		ADD_TRAIT(redeemer, TRAIT_SPEC_KIT, TRAIT_SOURCE_INHERENT)
	else
		for(var/path in incompatible_sets)
			GLOB.specialist_set_datums[path].available_vendor_num--
		ADD_TRAIT(redeemer, TRAIT_SPEC_VENDOR, TRAIT_SOURCE_INHERENT)
	ADD_TRAIT(redeemer, TRAIT_SPEC(trait_to_give), TRAIT_SOURCE_INHERENT)

	redeemer.rank_override = rank_icon
	redeemer.hud_set_squad()
	var/obj/item/card/id/idcard = redeemer.get_idcard()
	if(idcard)
		idcard.set_assignment((redeemer.assigned_squad ? (redeemer.assigned_squad.name + " ") : "") + JOB_SQUAD_SPECIALIST + " ([role_name])")
		idcard.minimap_icon_override = rank_icon
		redeemer.update_minimap_icon()
		GLOB.data_core.manifest_modify(redeemer.real_name, WEAKREF(redeemer), idcard.assignment)
	return TRUE

/datum/specialist_set/proc/refund_set(mob/living/carbon/human/refunder)
	SHOULD_CALL_PARENT(TRUE)
	if(!refunder)
		return

	if(HAS_TRAIT(refunder, TRAIT_SPEC_KIT))
		for(var/path in incompatible_sets)
			GLOB.specialist_set_datums[path].available_kit_num++
	else if(HAS_TRAIT(refunder, TRAIT_SPEC_VENDOR))
		for(var/path in incompatible_sets)
			GLOB.specialist_set_datums[path].available_vendor_num++

/datum/specialist_set/proc/get_name() as text
	return name

/datum/specialist_set/proc/get_available_kit_num() as num
	return available_kit_num

/datum/specialist_set/proc/get_available_vendor_num() as num
	return available_vendor_num

/datum/specialist_set/sadar
	name = "Demolitionist Set"
	role_name = "Demo"
	skill_to_give = SKILL_SPEC_ROCKET
	trait_to_give = "demo"
	rank_icon = "spec_demo"
	kit_typepath = /obj/item/storage/box/spec/demolitionist

/datum/specialist_set/sadar/redeem_set(mob/living/redeemer, kit)
	. = ..()
	if(!.)
		return .

	if(!skillcheck(redeemer, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		redeemer.skills?.set_skill(SKILL_ENGINEER, SKILL_ENGINEER_TRAINED)
	return TRUE

/datum/specialist_set/scout
	name = "Scout Set"
	role_name = "Scout"
	skill_to_give = SKILL_SPEC_SCOUT
	trait_to_give = "scout"
	kit_typepath = /obj/item/storage/box/spec/scout

/datum/specialist_set/scout/redeem_set(mob/living/redeemer, kit)
	. = ..()
	if(!.)
		return .

	if(!skillcheck(redeemer, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
		redeemer.skills?.set_skill(SKILL_ENGINEER, SKILL_ENGINEER_NOVICE)
	return TRUE

/datum/specialist_set/sniper
	name = "Sniper Set"
	role_name = "Sniper"
	skill_to_give = SKILL_SPEC_SNIPER
	trait_to_give = "sniper"
	rank_icon = "spec_sniper"
	kit_typepath = /obj/item/storage/box/spec/sniper
	incompatible_sets = list(
		/datum/specialist_set/anti_mat_sniper,
	)

/datum/specialist_set/anti_mat_sniper
	name = "Anti-Materiel Sniper Set"
	role_name = "Heavy Sniper"
	skill_to_give = SKILL_SPEC_SNIPER
	trait_to_give = "antimat_sniper"
	rank_icon = "spec_sniper"
	kit_typepath = /obj/item/storage/box/spec/sniper/anti_materiel
	incompatible_sets = list(
		/datum/specialist_set/sniper,
	)

/datum/specialist_set/grenadier
	name = "Heavy Grenadier Set"
	role_name = "Grenadier"
	skill_to_give = SKILL_SPEC_GRENADIER
	trait_to_give = "grenadier"
	rank_icon = "spec_grenadier"
	kit_typepath = /obj/item/storage/box/spec/heavy_grenadier
	incompatible_sets = list(
		/datum/specialist_set/sharp_operator,
	)

/datum/specialist_set/sharp_operator
	name = "SHARP Operator Set"
	role_name = "SHARP Operator"
	skill_to_give = SKILL_SPEC_GRENADIER
	rank_icon = "spec_sharp"
	kit_typepath = /obj/item/storage/box/spec/sharp_operator
	incompatible_sets = list(
		/datum/specialist_set/grenadier,
	)

/datum/specialist_set/pyro
	name = "Pyro Set"
	role_name = "Pyro"
	skill_to_give = SKILL_SPEC_PYRO
	trait_to_give = "pyro"
	rank_icon = "spec_pyro"
	kit_typepath = /obj/item/storage/box/spec/pyro

/datum/specialist_set/heavy
	name = "Heavy Armor Set"
	role_name = "Heavy"
	skill_to_give = SKILL_SPEC_PYRO //we do not realy care atm
	trait_to_give = "heavy"
	kit_typepath = /obj/item/storage/box/spec/B18
	available_vendor_num = 0
	available_kit_num = 0


/datum/specialist_set/heavy/post_round_start()
	if(SSticker && MODE_HAS_MODIFIER(/datum/gamemode_modifier/heavy_specialists))
		available_vendor_num = 4
		available_kit_num = 5
