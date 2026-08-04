/**
 * Maps a vehicle-level damage-type literal down to the coarser Acid/Brute wound split.
 *
 * Arguments:
 * * type = One of "acid"/"slash"/"bullet"/"explosive"/"blunt"/"abstract".
 *
 * Returns:
 * * WOUND_DAMTYPE_ACID for "acid", WOUND_DAMTYPE_BRUTE for other kinetic types, or null.
 */
/proc/wound_damage_type_for(type)
	switch(type)
		if("acid")
			return WOUND_DAMTYPE_ACID
		if("slash", "bullet", "explosive", "blunt")
			return WOUND_DAMTYPE_BRUTE
	return null

// The screeches ended up receiving negative feedback, so, now you get thuds and impacts
/proc/play_metal_screech(atom/source)
	if(prob(1))
		// hell yeah
		playsound(source, 'sound/effects/slam_rare_1.ogg', 65, TRUE)
		return
	playsound(source, pick(list(
		'sound/vehicles/metalimpact1.ogg',
		'sound/vehicles/metalimpact2.ogg',
		'sound/vehicles/metalimpact3.ogg',
		'sound/vehicles/metalimpact4.ogg',
		'sound/vehicles/metalimpact5.ogg',
		'sound/vehicles/metalimpact6.ogg',
	)), 65, TRUE)

/// Plays a random acid-sizzle one-shot at `source`, the audible cue for gaining an Acid-type wound.
/proc/play_acid_sizzle(atom/source)
	playsound(source, pick(list(
		'sound/vehicles/acidsizzle1.ogg',
		'sound/vehicles/acidsizzle2.ogg',
		'sound/vehicles/acidsizzle3.ogg',
		'sound/vehicles/acidsizzle4.ogg',
		'sound/vehicles/acidsizzle5.ogg',
		'sound/vehicles/acidsizzle6.ogg',
		'sound/vehicles/acidsizzle7.ogg',
	)), 45, TRUE)

/**
 * Audio and visual cue for a part gaining a wound tier. Brute wounds get a metal-screech,
 * shrapnel, and sparks. Acid wounds get a sizzle and heavier sparks, no shrapnel.
 *
 * Arguments:
 * * epicenter_atom = Where to center the effects.
 * * damage_type = WOUND_DAMTYPE_ACID or WOUND_DAMTYPE_BRUTE.
 * * attacker = Whoever dealt the hit, if known. Null bursts shrapnel in every direction.
 */
/proc/play_wound_gain_effects(atom/epicenter_atom, damage_type, atom/attacker)
	var/turf/epicenter = get_turf(epicenter_atom)
	if(!epicenter)
		return

	if(damage_type == WOUND_DAMTYPE_BRUTE)
		play_metal_screech(epicenter_atom)

		var/shrapnel_dir
		var/turf/attacker_turf = get_turf(attacker)
		if(attacker_turf && attacker_turf != epicenter)
			shrapnel_dir = get_dir(epicenter, attacker_turf)
		var/turf/shrapnel_origin = get_shrapnel_spawn_turf(epicenter_atom, epicenter, shrapnel_dir)
		create_shrapnel(shrapnel_origin, 4, shrapnel_dir, 40, /datum/ammo/bullet/shrapnel/tank_wound, null, TRUE, 0)

		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(3, 0, epicenter)
		sparks.start()

	else if(damage_type == WOUND_DAMTYPE_ACID)
		play_acid_sizzle(epicenter_atom)

		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(8, 0, epicenter)
		sparks.start()

/**
 * Finds a turf just outside the vehicle's own footprint to spawn wound-gain shrapnel from, so it
 * doesn't immediately collide with the vehicle's own dense hitbox.
 *
 * Arguments:
 * * epicenter_atom = The wounded hardpoint, or the vehicle itself for Hull.
 * * epicenter = get_turf(epicenter_atom), passed in since the caller already computed it.
 * * shrapnel_dir = Direction shrapnel should cone toward, or null for an omnidirectional burst.
 */
/proc/get_shrapnel_spawn_turf(atom/epicenter_atom, turf/epicenter, shrapnel_dir)
	var/obj/vehicle/multitile/vehicle
	if(istype(epicenter_atom, /obj/vehicle/multitile))
		vehicle = epicenter_atom
	else if(istype(epicenter_atom, /obj/item/hardpoint))
		var/obj/item/hardpoint/hardpoint = epicenter_atom
		vehicle = hardpoint.owner

	if(!vehicle || length(vehicle.locs) <= 1)
		return epicenter

	var/walk_dir = shrapnel_dir || vehicle.dir
	var/turf/walking = epicenter
	for(var/i in 1 to 5)
		if(!(walking in vehicle.locs))
			return walking
		var/turf/next_turf = get_step(walking, walk_dir)
		if(!next_turf)
			break
		walking = next_turf
	return walking

/**
 * Rolls every candidate wound family for this hardpoint's slot against one hit.
 * Advances at most one tier per family per hit.
 *
 * Arguments:
 * * hit_damage = Post-damage_multiplier damage this specific hit dealt.
 * * damage_type = WOUND_DAMTYPE_ACID or WOUND_DAMTYPE_BRUTE.
 * * attacker = Whoever dealt this hit, if known. Used for the shrapnel cone on gaining a wound.
 * * chance_mult = Multiplies the wound-roll chance computed off this hit. 1 (no change) by default.
 */
/// The slot key to look up this hardpoint's own candidate wound families under.
/obj/item/hardpoint/proc/get_wound_family_slot()
	return wound_family_slot || slot

/obj/item/hardpoint/proc/roll_wounds(hit_damage, damage_type, atom/attacker, chance_mult = 1)
	var/effective_slot = get_wound_family_slot()
	if(!effective_slot || hit_damage <= 0)
		return
	var/list/candidate_families = GLOB.hardpoint_wound_families_by_slot[effective_slot]
	if(!candidate_families)
		return
	for(var/datum/hardpoint_wound_family/family in candidate_families)
		if(family.neuro_alt_trigger_only)
			continue
		if(family.damage_type != damage_type && family.damage_type != WOUND_DAMTYPE_UNIFIED)
			continue
		try_advance_wound_family(family, hit_damage, attacker, chance_mult)

/**
 * Gates and rolls one wound family's next tier, advancing if it passes.
 * No-ops at max tier, below the health gate, or on a failed roll.
 *
 * Arguments:
 * * family = The wound family to try advancing.
 * * hit_damage = Post-multiplier damage from the hit that triggered this roll.
 * * attacker = Whoever dealt this hit, if known.
 * * chance_mult = Multiplies the roll chance before the tier's own max_roll_chance_pct cap applies.
 */
/obj/item/hardpoint/proc/try_advance_wound_family(datum/hardpoint_wound_family/family, hit_damage, atom/attacker, chance_mult = 1)
	var/current_tier = LAZYACCESS(wound_tiers, family.type) || 0
	var/next_tier = current_tier + 1
	if(next_tier > length(family.tiers))
		return

	var/list/tier_data = family.tiers[next_tier]
	var/gate_pct = get_wound_gate_health_pct(family.damage_type)
	if(gate_pct > tier_data["min_health_threshold_pct"])
		return

	var/chance = min(tier_data["max_roll_chance_pct"], hit_damage * tier_data["damage_to_chance_pct"] * chance_mult)
	if(!prob(chance))
		return

	LAZYSET(wound_tiers, family.type, next_tier)
	notify_crew_of_wound(tier_data["marine_feedback_red"], tier_data["xeno_feedback"], tier_data["bold_feedback"])
	play_wound_gain_effects(src, family.damage_type, attacker)
	recalculate_wound_effects()

/**
 * Alternate trigger for neurotoxin "_gunked" wound families. Advances a tier on its own
 * roll, skipping the health-threshold gate.
 *
 * Arguments:
 * * family = The wound family to try advancing.
 * * chance_scale = Multiplies the tier's neuro trigger chance before rolling.
 */
/obj/item/hardpoint/proc/try_advance_wound_family_via_neuro(datum/hardpoint_wound_family/family, chance_scale = 1)
	var/current_tier = LAZYACCESS(wound_tiers, family.type) || 0
	var/next_tier = current_tier + 1
	if(next_tier > length(family.tiers))
		return

	var/list/tier_data = family.tiers[next_tier]
	var/base_chance = tier_data["neuro_alt_trigger_chance_pct"]
	if(!base_chance)
		return
	var/chance = min(TANK_GLOB_NEURO_CHANCE_CAP_PCT, base_chance * chance_scale)
	if(!prob(chance))
		return

	LAZYSET(wound_tiers, family.type, next_tier)
	notify_crew_of_wound(tier_data["marine_feedback_red"], tier_data["xeno_feedback"], tier_data["bold_feedback"])
	play_wound_gain_effects(src, family.damage_type, null)
	recalculate_wound_effects()

/**
 * The health% a wound family's gate is checked against: the matching Acid/Brute
 * sub-pool's health%, or combined integrity% for a WOUND_DAMTYPE_UNIFIED family.
 *
 * Arguments:
 * * family_damage_type = The wound family's own damage_type.
 *
 * Returns:
 * * A percentage, 100 (undamaged) down to 0 (destroyed) or below.
 */
/obj/item/hardpoint/proc/get_wound_gate_health_pct(family_damage_type)
	if(family_damage_type == WOUND_DAMTYPE_UNIFIED)
		return get_integrity_percent()
	if(!initial(health))
		return 100
	var/relevant_damage = (family_damage_type == WOUND_DAMTYPE_ACID) ? acid_damage_taken : brute_damage_taken
	return 100 - (relevant_damage / initial(health) * 100)

/// This hardpoint's active wound tier data for one family, or null if unwounded.
/obj/item/hardpoint/proc/get_wound_tier_data(family_type)
	var/tier = LAZYACCESS(wound_tiers, family_type)
	if(!tier)
		return null
	var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
	if(!family || tier > length(family.tiers))
		return null
	return family.tiers[tier]

/**
 * Combines one named effect field (e.g. "accuracy_mult") across every active wound
 * family by multiplying them together.
 *
 * Arguments:
 * * key = The tier-data field to combine (e.g. "accuracy_mult", "scatter_mult").
 */
/obj/item/hardpoint/proc/get_wound_effect_multiplier(key)
	. = 1
	for(var/family_type in wound_tiers)
		var/list/tier_data = get_wound_tier_data(family_type)
		var/value = tier_data?[key]
		if(isnull(value))
			continue
		. *= value

/**
 * How much of this hardpoint's normal performance is retained purely from its raw integrity%. Full
 * performance above WEAPON_DEGRADE_GRACE_THRESHOLD_PCT, ramping down toward 0 below it.
 *
 * Returns:
 * * 0-1 scale, or 0 if uninstalled.
 */
/obj/item/hardpoint/proc/get_own_health_scale()
	if(!owner)
		return 0
	return owner.get_health_scale_with_grace(get_integrity_percent(), WEAPON_DEGRADE_GRACE_THRESHOLD_PCT)

/// Combines wound compounding with raw-health degradation, floored at `floor_value`.
/obj/item/hardpoint/proc/get_combined_weapon_mult(key, floor_value = 0)
	return max(get_wound_effect_multiplier(key) * get_own_health_scale(), floor_value)

/// Whether any active wound family sets a truthy value for a boolean effect field.
/obj/item/hardpoint/proc/get_wound_effect_flag(key)
	for(var/family_type in wound_tiers)
		var/list/tier_data = get_wound_tier_data(family_type)
		if(tier_data?[key])
			return TRUE
	return FALSE

/// Additively combines one named effect field across every active wound family.
/obj/item/hardpoint/proc/get_wound_effect_sum(key)
	. = 0
	for(var/family_type in wound_tiers)
		var/list/tier_data = get_wound_tier_data(family_type)
		var/value = tier_data?[key]
		if(!isnull(value))
			. += value

/**
 * How much extra damage this hardpoint should take of a given type right now, from any active
 * Turret/Hull/Armor "melted"/"hole"/"plating" wound. Takes the single worst active multiplier
 * rather than compounding multiple wound families together.
 *
 * Arguments:
 * * type = WOUND_DAMTYPE_ACID or WOUND_DAMTYPE_BRUTE, the incoming hit's mapped type.
 *
 * Returns:
 * * A multiplier, 1 (no active wound affecting this type) or higher.
 */
/obj/item/hardpoint/proc/get_incoming_damage_wound_multiplier(type)
	. = 1
	for(var/family_type in wound_tiers)
		var/list/tier_data = get_wound_tier_data(family_type)
		var/mult = tier_data?["incoming_damage_mult"]
		if(isnull(mult))
			continue
		var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
		var/applies_to = tier_data["incoming_damage_type"] || family.damage_type
		if(applies_to == "all" || applies_to == type)
			. = max(., mult)

/**
 * How much of this hardpoint's normal performance is retained, given its active wound tiers.
 * Only used by engine/locomotion hardpoints. Multiplies every active tier's
 * "performance_mult" together.
 *
 * Returns:
 * * A multiplier, 1 (no active wound affecting performance) or lower.
 */
/obj/item/hardpoint/proc/get_wound_performance_multiplier()
	. = 1
	for(var/family_type in wound_tiers)
		var/list/tier_data = get_wound_tier_data(family_type)
		var/mult = tier_data?["performance_mult"]
		if(isnull(mult))
			continue
		. *= mult

/// List of {"name": wound_name, "tier": current_tier} for every active wound. Empty if none.
/obj/item/hardpoint/proc/get_wound_tgui_data()
	var/list/data = list()
	for(var/family_type in wound_tiers)
		var/list/tier_data = get_wound_tier_data(family_type)
		if(tier_data)
			data += list(list("name" = tier_data["wound_name"], "tier" = wound_tiers[family_type]))
	return data

/// Whether `tool` satisfies a wound tier's repair_tool_trait.
/proc/hardpoint_tool_matches_trait(obj/item/tool, required_trait)
	if(!tool || !required_trait)
		return FALSE
	if(required_trait == "welder")
		return iswelder(tool)
	if(required_trait == TRAIT_TOOL_WIRECUTTERS && istype(tool, /obj/item/attachable/bayonet))
		return TRUE
	return HAS_TRAIT(tool, required_trait)

/// Whether `tool` satisfies one repair_steps entry: a trait/tool marker or a material step.
/proc/wound_repair_step_matches_tool(step, obj/item/tool)
	if(islist(step))
		var/list/material_step = step
		if(length(material_step) < 3 || material_step[1] != "material" || !istype(tool, /obj/item/stack))
			return FALSE
		var/obj/item/stack/stack = tool
		return istype(stack, material_step[2]) && stack.amount >= material_step[3]
	return hardpoint_tool_matches_trait(tool, step)

/// Player-facing tool name for one repair_steps entry.
/proc/get_wound_repair_step_tool_name(step)
	if(islist(step))
		var/list/material_step = step
		var/obj/item/stack/stack_type = material_step[2]
		return "[material_step[3]]x [initial(stack_type.name)]"
	if(step == "welder")
		return "Welding Tool"
	if(step == TRAIT_TOOL_WRENCH)
		return "Wrench"
	if(step == TRAIT_TOOL_CROWBAR)
		return "Crowbar"
	if(step == TRAIT_TOOL_SCREWDRIVER)
		return "Screwdriver"
	if(step == TRAIT_TOOL_WIRECUTTERS)
		return "Wirecutters"
	return "Unknown Tool"

/// Consumes a material step's required stack amount. No-op for trait/tool steps.
/proc/consume_wound_repair_step_material(step, obj/item/tool)
	if(!islist(step))
		return TRUE
	var/list/material_step = step
	var/obj/item/stack/stack = tool
	return stack.use(material_step[3])

/**
 * Pre-flight check and tool sound for one wound-repair step, called before its do_after() starts.
 *
 * Arguments:
 * * step = The repair_steps entry this attempt is for.
 * * tool = The tool being used.
 * * user = Whoever's using it, shown the failure message if any.
 *
 * Returns:
 * * FALSE if a welder step's lit/fuelled pre-check failed. TRUE otherwise.
 */
/proc/precheck_wound_repair_step_tool(step, obj/item/tool, mob/user)
	if(step == "welder")
		var/obj/item/tool/weldingtool/WT = tool
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("You need to light \the [WT] first."))
			return FALSE
		if(WT.get_fuel() < 1)
			to_chat(user, SPAN_WARNING("You need to refuel \the [WT] first."))
			return FALSE
		playsound(get_turf(user), 'sound/items/weldingtool_weld.ogg', 25)
	else if(step == TRAIT_TOOL_WRENCH)
		playsound(get_turf(user), 'sound/items/Ratchet.ogg', 25)
	else if(step == TRAIT_TOOL_CROWBAR)
		playsound(get_turf(user), 'sound/items/Crowbar.ogg', 25)
	else if(step == TRAIT_TOOL_WIRECUTTERS)
		playsound(get_turf(user), 'sound/items/Wirecutter.ogg', 25)
	else if(step == TRAIT_TOOL_SCREWDRIVER)
		playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 25)
	return TRUE

/**
 * Applies a welder step's fuel cost and eye-protection check right as it completes. No-op for every
 * other tool.
 *
 * Returns:
 * * FALSE if a welder went out or ran dry between the precheck and now. TRUE otherwise.
 */
/proc/apply_wound_repair_step_welder_cost(step, obj/item/tool, mob/user)
	if(step != "welder")
		return TRUE
	var/obj/item/tool/weldingtool/WT = tool
	return WT.isOn() && WT.remove_fuel(1, user)

/**
 * Turns a tier's repair_step_verbs into one sentence, each verb bolded with its tool named
 * after. Falls back to raw repair_method text if there are no structured steps.
 *
 * Adds a callout for unmount_required tiers and for a stricter repair_required_skill.
 */
/proc/format_repair_info_sentence(list/tier_data)
	var/unmount_notice = tier_data["unmount_required"] ? "[SPAN_BOLD("This part must be unmounted (crowbar) first.")] " : ""

	var/skill_notice = ""
	if(tier_data["repair_required_skill"])
		skill_notice = "[SPAN_BOLD("Requires:")] [tier_data["repair_skill"]]. "

	var/list/verbs = tier_data["repair_step_verbs"]
	if(!length(verbs))
		return "[unmount_notice][skill_notice][tier_data["repair_method"]]"

	var/list/steps = tier_data["repair_steps"]
	var/list/formatted = list()
	for(var/i in 1 to length(verbs))
		var/phrase = verbs[i]
		var/space_pos = findtext(phrase, " ")
		var/bolded_phrase = space_pos ? "[SPAN_BOLD(copytext(phrase, 1, space_pos))][copytext(phrase, space_pos)]" : SPAN_BOLD(phrase)
		var/tool_name = (length(steps) >= i) ? get_wound_repair_step_tool_name(steps[i]) : null
		formatted += tool_name ? "[bolded_phrase] ([tool_name])" : bolded_phrase
	return "[unmount_notice][skill_notice]This can be fixed by [jointext(formatted, ", then ")]."

/**
 * Sends a wound tier's repair instructions to `user` alone, resolving the "(Repair Info)" link.
 *
 * Arguments:
 * * user = Whoever clicked the link, the only one who sees the output.
 * * family_type_text = A wound family's type path, as text.
 */
/obj/item/hardpoint/proc/show_wound_repair_info(mob/user, family_type_text)
	var/list/tier_data = get_wound_tier_data(text2path(family_type_text))
	if(!tier_data)
		return
	to_chat(user, SPAN_NOTICE("[SPAN_BOLD(tier_data["wound_name"])]: [format_repair_info_sentence(tier_data)]"))

/// This hardpoint's progress on one wound family's current tier, or 0 if none.
/obj/item/hardpoint/proc/get_wound_repair_step(family_type)
	var/list/progress = LAZYACCESS(wound_repair_progress, family_type)
	if(!progress || progress["tier"] != LAZYACCESS(wound_tiers, family_type))
		return 0
	return progress["step"]

/**
 * Attempts one step of a wound tier's repair_steps sequence. Clears the wound once every
 * step is done. Only for unmount_required = FALSE tiers, still mounted.
 *
 * Arguments:
 * * user = Whoever is attempting the repair.
 * * tool = The tool used. Must match the next unfinished step.
 * * family_type = A wound family's type path.
 */
/obj/item/hardpoint/proc/fix_wound(mob/living/user, obj/item/tool, family_type)
	if(!ishuman(user) || user.is_mob_incapacitated())
		return
	if(!owner || get_dist(owner, user) > 2) // vehicle is 3x3, Adjacent() alone forces standing on its unreachable centre tile
		return

	var/starting_tier = LAZYACCESS(wound_tiers, family_type)
	if(!starting_tier)
		return
	var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
	if(!family || starting_tier > length(family.tiers))
		return
	var/list/tier_data = family.tiers[starting_tier]
	if(tier_data["unmount_required"])
		return
	var/list/steps = tier_data["repair_steps"]
	if(!length(steps))
		return
	var/starting_step = get_wound_repair_step(family_type)
	if(starting_step >= length(steps))
		return
	var/required_step = steps[starting_step + 1]
	if(!wound_repair_step_matches_tool(required_step, tool))
		return
	if(required_step == "welder")
		var/obj/item/tool/weldingtool/WT = tool
		if(!HAS_TRAIT(WT, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
	if(!skillcheck(user, SKILL_ENGINEER, tier_data["repair_required_skill"] || SKILL_ENGINEER_NOVICE))
		to_chat(user, SPAN_WARNING("This task is beyond you!"))
		return
	if(!precheck_wound_repair_step_tool(required_step, tool, user))
		return

	var/is_final_step = (starting_step + 1) >= length(steps)
	user.visible_message(SPAN_NOTICE("[user] starts working on \the [src]'s [tier_data["wound_name"]]."), SPAN_NOTICE("You start fixing \the [src]'s [tier_data["wound_name"]]."))
	if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return
	if(!owner || get_dist(owner, user) > 2 || tool != user.get_active_hand() || get_wound_repair_step(family_type) != starting_step || LAZYACCESS(wound_tiers, family_type) != starting_tier || !wound_repair_step_matches_tool(required_step, tool))
		return
	if(!apply_wound_repair_step_welder_cost(required_step, tool, user))
		to_chat(user, SPAN_WARNING("You need to keep \the [tool] lit and fuelled to finish this."))
		return
	consume_wound_repair_step_material(required_step, tool)

	if(!is_final_step)
		LAZYSET(wound_repair_progress, family_type, list("tier" = starting_tier, "step" = starting_step + 1))
		user.visible_message(SPAN_NOTICE("[user] finishes a step on \the [src]'s [tier_data["wound_name"]]."), SPAN_NOTICE("You finish a step. [length(steps) - starting_step - 1] more to go."))
		return

	var/revert_tier = tier_data["repair_reverts_to_tier"]
	if(revert_tier)
		LAZYSET(wound_tiers, family_type, revert_tier)
	else
		LAZYREMOVE(wound_tiers, family_type)
	LAZYREMOVE(wound_repair_progress, family_type)
	recalculate_wound_effects()
	user.visible_message(SPAN_NOTICE("[user] fixes \the [src]'s [tier_data["wound_name"]]."), SPAN_NOTICE("You fix \the [src]'s [tier_data["wound_name"]]."))

/**
 * The detached counterpart to fix_wound(), attempted while this hardpoint is crowbarred
 * off the vehicle.
 *
 * Arguments:
 * * user = Whoever is attempting the repair.
 * * tool = The tool used. Must match the next unfinished step.
 * * family_type = A wound family's type path.
 */
/obj/item/hardpoint/proc/fix_detached_wound(mob/living/user, obj/item/tool, family_type)
	if(!ishuman(user) || user.is_mob_incapacitated())
		return
	if(owner || !Adjacent(user))
		return

	var/starting_tier = LAZYACCESS(wound_tiers, family_type)
	if(!starting_tier)
		return
	var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
	if(!family || starting_tier > length(family.tiers))
		return
	var/list/tier_data = family.tiers[starting_tier]
	var/list/steps = tier_data["repair_steps"]
	if(!length(steps))
		return
	var/starting_step = get_wound_repair_step(family_type)
	if(starting_step >= length(steps))
		return
	var/required_step = steps[starting_step + 1]
	if(!wound_repair_step_matches_tool(required_step, tool))
		return
	if(required_step == "welder")
		var/obj/item/tool/weldingtool/WT = tool
		if(!HAS_TRAIT(WT, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
	if(!skillcheck(user, SKILL_ENGINEER, tier_data["repair_required_skill"] || SKILL_ENGINEER_NOVICE))
		to_chat(user, SPAN_WARNING("This task is beyond you!"))
		return
	if(!precheck_wound_repair_step_tool(required_step, tool, user))
		return

	var/is_final_step = (starting_step + 1) >= length(steps)
	user.visible_message(SPAN_NOTICE("[user] starts working on \the [src]'s [tier_data["wound_name"]]."), SPAN_NOTICE("You start fixing \the [src]'s [tier_data["wound_name"]]."))
	if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return
	if(owner || !Adjacent(user) || tool != user.get_active_hand() || get_wound_repair_step(family_type) != starting_step || LAZYACCESS(wound_tiers, family_type) != starting_tier || !wound_repair_step_matches_tool(required_step, tool))
		return
	if(!apply_wound_repair_step_welder_cost(required_step, tool, user))
		to_chat(user, SPAN_WARNING("You need to keep \the [tool] lit and fuelled to finish this."))
		return
	consume_wound_repair_step_material(required_step, tool)

	if(!is_final_step)
		LAZYSET(wound_repair_progress, family_type, list("tier" = starting_tier, "step" = starting_step + 1))
		user.visible_message(SPAN_NOTICE("[user] finishes a step on \the [src]'s [tier_data["wound_name"]]."), SPAN_NOTICE("You finish a step. [length(steps) - starting_step - 1] more to go."))
		return

	var/revert_tier2 = tier_data["repair_reverts_to_tier"]
	if(revert_tier2)
		LAZYSET(wound_tiers, family_type, revert_tier2)
	else
		LAZYREMOVE(wound_tiers, family_type)
	LAZYREMOVE(wound_repair_progress, family_type)
	recalculate_wound_effects()
	user.visible_message(SPAN_NOTICE("[user] fixes \the [src]'s [tier_data["wound_name"]]."), SPAN_NOTICE("You fix \the [src]'s [tier_data["wound_name"]]."))

/**
 * Every active wound whose next unfinished repair_steps entry matches `tool`.
 *
 * Returns:
 * * An assoc list, "Fix <wound name>" -> a family_type path. Empty if nothing matches.
 */
/obj/item/hardpoint/proc/get_detached_wound_fix_candidates(obj/item/tool)
	. = list()
	for(var/family_type in wound_tiers)
		var/list/tier_data = get_wound_tier_data(family_type)
		if(!tier_data)
			continue
		var/list/steps = tier_data["repair_steps"]
		if(!length(steps))
			continue
		var/current_step = get_wound_repair_step(family_type)
		if(current_step >= length(steps))
			continue
		if(!wound_repair_step_matches_tool(steps[current_step + 1], tool))
			continue
		.["Fix [tier_data["wound_name"]]"] = family_type

/**
 * Wound-fix / integrity-repair dispatch for this hardpoint's attackby() while detached.
 * Offers a combined picker since a welder can do either.
 *
 * Returns:
 * * TRUE if anything was offered/attempted, caller should skip its own fallback.
 */
/obj/item/hardpoint/proc/try_fix_detached_wound_with_tool(obj/item/tool, mob/living/user)
	var/list/wound_candidates = get_detached_wound_fix_candidates(tool)
	var/can_repair_integrity = iswelder(tool) && HAS_TRAIT(tool, TRAIT_TOOL_BLOWTORCH) && health > 0 && health < initial(health)
	if(!length(wound_candidates) && !can_repair_integrity)
		return FALSE

	var/list/labels = list()
	for(var/label in wound_candidates)
		labels += label
	if(can_repair_integrity)
		labels += "Repair integrity"

	var/chosen_label = length(labels) == 1 ? labels[1] : tgui_input_list(user, "What would you like to fix?", "Part Repair", labels + list("Cancel"))
	if(!chosen_label || chosen_label == "Cancel")
		return TRUE

	if(QDELETED(user) || user.is_mob_incapacitated() || !Adjacent(user) || tool != user.get_active_hand())
		return TRUE

	if(chosen_label == "Repair integrity")
		handle_repair(tool, user)
		return TRUE

	var/family_type = wound_candidates[chosen_label]
	if(!family_type)
		return TRUE
	fix_detached_wound(user, tool, family_type)
	return TRUE

/// Broadcasts a wound-gain notice. No-op if this hardpoint isn't installed on a vehicle.
/obj/item/hardpoint/proc/notify_crew_of_wound(marine_text, xeno_text, bold)
	if(!owner)
		return
	owner.broadcast_wound_notice(marine_text, xeno_text, bold)

/**
 * Called once right after a wound tier changes. Recalculates hardpoint bonuses and refreshes
 * the vehicle's sprite.
 */
/obj/item/hardpoint/proc/recalculate_wound_effects()
	if(!owner)
		return
	recalculate_hardpoint_bonuses()
	owner.update_icon()

/**
 * Rolls the engine_cracked_block family's overheat wound progression, throttled to once per
 * ENGINE_OVERHEAT_WOUND_ROLL_INTERVAL. Never fires while the engine is off.
 *
 * Arguments:
 * * vehicle = The vehicle this engine is installed on.
 */
/obj/item/hardpoint/engine/proc/check_overheat_wound_trigger(obj/vehicle/multitile/vehicle)
	if(!vehicle.engine_on)
		return
	if(world.time < next_overheat_wound_roll)
		return
	next_overheat_wound_roll = world.time + ENGINE_OVERHEAT_WOUND_ROLL_INTERVAL

	var/current_temp_pct = get_temperature_percent()
	if(current_temp_pct < ENGINE_OVERHEAT_WOUND_TIER1_THRESHOLD_PCT)
		return

	var/datum/hardpoint_wound_family/engine_cracked_block/family = GLOB.hardpoint_wound_families_by_type[/datum/hardpoint_wound_family/engine_cracked_block]
	if(!family)
		return

	var/current_tier = LAZYACCESS(wound_tiers, family.type) || 0
	var/severe = current_temp_pct >= ENGINE_OVERHEAT_WOUND_TIER2_THRESHOLD_PCT

	var/next_tier
	if(current_tier == 0 && prob(severe ? ENGINE_OVERHEAT_WOUND_TIER1_CHANCE_PCT_HIGH : ENGINE_OVERHEAT_WOUND_TIER1_CHANCE_PCT))
		next_tier = 1
	else if(severe && current_tier == 1 && prob(ENGINE_OVERHEAT_WOUND_TIER2_ADVANCE_CHANCE_PCT))
		next_tier = 2

	if(!next_tier || next_tier > length(family.tiers))
		return

	var/list/tier_data = family.tiers[next_tier]
	LAZYSET(wound_tiers, family.type, next_tier)
	notify_crew_of_wound(tier_data["marine_feedback_red"], tier_data["xeno_feedback"], tier_data["bold_feedback"])
	play_wound_gain_effects(src, WOUND_DAMTYPE_BRUTE, null) // engine_cracked_block is always Brute; overheat has no directional attacker
	recalculate_wound_effects()

/// Every hardpoint slot with a dedicated neurotoxin "_gunked" wound family.
GLOBAL_LIST_INIT(neuro_foulable_slots, list(HDPT_VISUAL_SENSORS, HDPT_AIR_FILTER, HDPT_PRIMARY, HDPT_SECONDARY, HDPT_TREADS))

/// Multiplier applied to every neurotoxin wound-chance roll on this vehicle. 1 by default.
/obj/vehicle/multitile/proc/get_neuro_wound_chance_scale()
	return 1

/**
 * Rolls the neuro alt-trigger for whichever hardpoint currently occupies `slot`, if it has an
 * Acid-type wound family with that trigger set. No-op for a slot with nothing installed.
 *
 * Arguments:
 * * chance_scale = Passed straight through to try_advance_wound_family_via_neuro().
 */
/obj/vehicle/multitile/proc/roll_neuro_wound_at_slot(slot, chance_scale = 1)
	var/obj/item/hardpoint/H = get_hardpoint_by_slot(slot)
	if(!H)
		return
	var/list/candidate_families = GLOB.hardpoint_wound_families_by_slot[H.get_wound_family_slot()]
	if(!candidate_families)
		return
	for(var/datum/hardpoint_wound_family/family in candidate_families)
		if(family.damage_type != WOUND_DAMTYPE_ACID)
			continue
		H.try_advance_wound_family_via_neuro(family, chance_scale)

/// Rolls the neuro alt-trigger for every neuro-foulable hardpoint. Used for ambient gas exposure.
/obj/vehicle/multitile/proc/expose_to_boiler_gas()
	var/chance_scale = get_neuro_wound_chance_scale()
	for(var/slot in GLOB.neuro_foulable_slots)
		roll_neuro_wound_at_slot(slot, chance_scale)

/**
 * A neurotoxin spit hitting this vehicle. Rolls only the slot the attacker aimed at. A
 * turret-aimed spit instead gets a chance to bleed into the Air Filter's neuro family.
 *
 * Arguments:
 * * attacker = Whoever fired the spit, read for aim.
 * * ignore_aim = TRUE for scattered ammo, picks a random neuro-foulable slot instead.
 */
/obj/vehicle/multitile/proc/expose_to_neurotoxin_spit(atom/attacker, ignore_aim = FALSE)
	if(ignore_aim)
		roll_neuro_wound_at_slot(pick(GLOB.neuro_foulable_slots), get_neuro_wound_chance_scale())
		return

	var/aimed_slot = get_attack_target_slot(attacker)
	if(aimed_slot == HDPT_TURRET)
		if(prob(TURRET_NEURO_SPIT_AIR_FILTER_BLEED_CHANCE_PCT))
			roll_neuro_wound_at_slot(HDPT_AIR_FILTER, get_neuro_wound_chance_scale())
		return

	roll_neuro_wound_at_slot(aimed_slot, get_neuro_wound_chance_scale())

//-----------------------------
// Vehicle-frame ("Hull") wounds. hull_melted/hull_hole track the vehicle's health directly.
//-----------------------------

/**
 * Rolls hull_melted/hull_hole against one hit to the vehicle's own frame.
 *
 * Arguments:
 * * hit_damage = Damage that was just subtracted from this vehicle's own health.
 * * damage_type = WOUND_DAMTYPE_ACID or WOUND_DAMTYPE_BRUTE.
 * * attacker = Whoever dealt this hit, if known.
 * * chance_mult = Multiplies the roll chance before the tier's own max_roll_chance_pct cap applies.
 */
/obj/vehicle/multitile/proc/roll_hull_wounds(hit_damage, damage_type, atom/attacker, chance_mult = 1)
	if(hit_damage <= 0)
		return
	var/list/candidate_families = GLOB.hardpoint_wound_families_by_slot[WOUND_SLOT_HULL]
	if(!candidate_families)
		return
	for(var/datum/hardpoint_wound_family/family in candidate_families)
		if(family.damage_type != damage_type)
			continue
		var/current_tier = LAZYACCESS(hull_wound_tiers, family.type) || 0
		var/next_tier = current_tier + 1
		if(next_tier > length(family.tiers))
			continue

		var/list/tier_data = family.tiers[next_tier]
		var/relevant_damage = (damage_type == WOUND_DAMTYPE_ACID) ? hull_acid_damage_taken : hull_brute_damage_taken
		var/health_pct = initial(health) ? 100 - (relevant_damage / initial(health) * 100) : 100
		if(health_pct > tier_data["min_health_threshold_pct"])
			continue

		var/chance = min(tier_data["max_roll_chance_pct"], hit_damage * tier_data["damage_to_chance_pct"] * chance_mult)
		if(!prob(chance))
			continue

		LAZYSET(hull_wound_tiers, family.type, next_tier)
		notify_crew_of_hull_wound(tier_data["marine_feedback_red"], tier_data["xeno_feedback"], tier_data["bold_feedback"])
		play_wound_gain_effects(src, family.damage_type, attacker)

/// How much extra damage the vehicle's frame takes of a given type from an active hull wound.
/obj/vehicle/multitile/proc/get_hull_incoming_damage_wound_multiplier(type)
	. = 1
	for(var/family_type in hull_wound_tiers)
		var/tier = hull_wound_tiers[family_type]
		var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
		if(!family || tier > length(family.tiers))
			continue
		var/list/tier_data = family.tiers[tier]
		var/mult = tier_data["incoming_damage_mult"]
		if(isnull(mult))
			continue
		if(tier_data["incoming_damage_type"] == "all" || family.damage_type == type)
			. = max(., mult)

/// Broadcasts a hull-wound-gain notice.
/obj/vehicle/multitile/proc/notify_crew_of_hull_wound(marine_text, xeno_text, bold)
	broadcast_wound_notice(marine_text, xeno_text, bold)

//-----------------------------
// Single-target damage resolution. Every vehicle type routes take_damage_type() through here.
//-----------------------------

/// Names whichever module `attacker` is currently aimed at, for use in attack flavor messages.
/obj/vehicle/multitile/get_attack_desc(atom/attacker)
	var/target_slot = get_attack_target_slot(attacker)
	var/obj/item/hardpoint/target = resolve_targeted_hardpoint(target_slot)
	return "\the [src]'s <b>[target ? target.name : "hull"]</b>"

/**
 * Which of HIT_ZONE_FRONT/HIT_ZONE_SIDE/HIT_ZONE_REAR a hit from `attacker` counts as, relative to the hull's own facing.
 * Front and rear are each a 90 degree cone, the rest counts as side. Defaults to HIT_ZONE_FRONT if there's no meaningful bearing to compute.
 */
/obj/vehicle/multitile/proc/get_hit_direction_zone(atom/attacker)
	var/turf/attacker_turf = get_turf(attacker)
	var/turf/own_turf = get_turf(src)
	if(!attacker_turf || !own_turf || attacker_turf == own_turf)
		return HIT_ZONE_FRONT

	var/bearing_to_attacker = Get_Angle(src, attacker)
	var/relative_angle = abs(angle_delta(bearing_to_attacker, dir2angle(dir)))
	if(relative_angle <= 45)
		return HIT_ZONE_FRONT
	if(relative_angle >= 135)
		return HIT_ZONE_REAR
	return HIT_ZONE_SIDE

/// Fraction of Armor's own damage reduction a hit from this hit_zone ignores outright. 0 for HIT_ZONE_FRONT.
/obj/vehicle/multitile/proc/get_armor_bypass_fraction(hit_zone)
	switch(hit_zone)
		if(HIT_ZONE_SIDE)
			return ARMOR_BYPASS_FRACTION_SIDE
		if(HIT_ZONE_REAR)
			return ARMOR_BYPASS_FRACTION_REAR
	return 0

/// Percent chance bonus to internal module damage for a hit from this hit_zone. 0 for HIT_ZONE_FRONT.
/obj/vehicle/multitile/proc/get_internal_leak_chance_bonus(hit_zone)
	switch(hit_zone)
		if(HIT_ZONE_SIDE)
			return ARMOR_BYPASS_INTERNAL_CHANCE_BONUS_SIDE
		if(HIT_ZONE_REAR)
			return ARMOR_BYPASS_INTERNAL_CHANCE_BONUS_REAR
	return 0

/**
 * Directional counterpart to get_dmg_multi(). Isolates Armor's own contribution and bypasses a fraction of it.
 * The hull's baseline toughness stays untouched by hit direction.
 *
 * Arguments:
 * * type = One of "acid"/"slash"/"bullet"/"explosive"/"blunt"/"abstract".
 * * hit_zone = HIT_ZONE_FRONT/HIT_ZONE_SIDE/HIT_ZONE_REAR.
 */
/obj/vehicle/multitile/proc/get_directional_dmg_multi(type, hit_zone)
	var/base_mult = get_dmg_multi(type)
	var/bypass_fraction = get_armor_bypass_fraction(hit_zone)
	if(!bypass_fraction)
		return base_mult

	var/obj/item/hardpoint/armor/installed_armor = get_hardpoint_by_slot(HDPT_ARMOR)
	if(!installed_armor)
		return base_mult

	var/armor_type_mult = LAZYACCESS(installed_armor.type_multipliers, type)
	if(isnull(armor_type_mult))
		armor_type_mult = 1
	var/armor_all_mult = LAZYACCESS(installed_armor.type_multipliers, "all")
	if(isnull(armor_all_mult))
		armor_all_mult = 1
	var/armor_contribution = max(armor_type_mult * armor_all_mult, 0.0001) // guards the division below; armor mults are never actually 0 today

	var/other_mult = base_mult / armor_contribution
	var/bypassed_armor_contribution = armor_contribution + bypass_fraction * (1 - armor_contribution)
	return other_mult * bypassed_armor_contribution

/**
 * Directional counterpart to get_internal_dmg_multi(). Lerps that value toward 1 (no protection) by `bypass_fraction`.
 *
 * Arguments:
 * * type = One of "acid"/"slash"/"bullet"/"explosive"/"blunt"/"abstract".
 * * hit_zone = HIT_ZONE_FRONT/HIT_ZONE_SIDE/HIT_ZONE_REAR.
 */
/obj/vehicle/multitile/proc/get_directional_internal_dmg_multi(type, hit_zone)
	var/base_mult = get_internal_dmg_multi(type)
	var/bypass_fraction = get_armor_bypass_fraction(hit_zone)
	if(!bypass_fraction)
		return base_mult
	return base_mult + bypass_fraction * (1 - base_mult)

/**
 * The internal-module counterpart to get_dmg_multi(). What fraction of incoming damage should reach an internal module.
 * Only reduces damage if the installed Armor hardpoint opts into protecting internal modules.
 *
 * Arguments:
 * * type = One of "acid"/"slash"/"bullet"/"explosive"/"blunt"/"abstract".
 *
 * Returns:
 * * A multiplier, same shape as get_dmg_multi(). 1 means no reduction.
 */
/obj/vehicle/multitile/proc/get_internal_dmg_multi(type)
	var/obj/item/hardpoint/armor/installed_armor = get_hardpoint_by_slot(HDPT_ARMOR)
	if(!installed_armor || !installed_armor.protects_internal_modules || !LAZYLEN(installed_armor.type_multipliers))
		return 1
	var/list/mults = installed_armor.type_multipliers
	var/type_mult = LAZYACCESS(mults, type)
	if(isnull(type_mult))
		type_mult = 1
	var/all_mult = LAZYACCESS(mults, "all")
	if(isnull(all_mult))
		all_mult = 1
	return type_mult * all_mult

/**
 * Armor takes a splash of damage from any hit that lands on an external module, since every armor type protects every external module.
 * This is Armor's only route to taking damage, uses ARMOR_SPLASH_FRACTION, and rolls real wounds (Corroded Plating/Cracked Plating) over time.
 *
 * Arguments:
 * * external_scaled_damage = The hit's damage after external mitigation, or raw if unmitigated.
 * * type = One of "acid"/"slash"/"bullet"/"explosive"/"blunt"/"abstract".
 * * attacker = Whoever dealt this hit, if known.
 * * unmitigated = Passed straight through to Armor's own take_damage().
 */
/obj/vehicle/multitile/proc/apply_armor_splash_damage(external_scaled_damage, type, atom/attacker, unmitigated)
	var/obj/item/hardpoint/armor/installed_armor = get_hardpoint_by_slot(HDPT_ARMOR)
	if(!installed_armor)
		return
	installed_armor.take_damage(floor(external_scaled_damage * ARMOR_SPLASH_FRACTION), type, attacker, unmitigated = unmitigated)

/**
 * Guaranteed, armor-bypassing hit to the Hatch hardpoint on every HIT_ZONE_REAR strike.
 * No-ops if no Hatch is installed or it's already destroyed.
 *
 * Arguments:
 * * damage = Raw incoming damage, pre-type-multiplier.
 * * type = One of "acid"/"slash"/"bullet"/"explosive"/"blunt"/"abstract".
 * * attacker = Whoever dealt this hit, if known.
 */
/obj/vehicle/multitile/proc/apply_guaranteed_rear_hatch_damage(damage, type, atom/attacker)
	var/obj/item/hardpoint/hatch/installed_hatch = get_hardpoint_by_slot(HDPT_HATCH)
	if(!installed_hatch || installed_hatch.health <= 0)
		return
	installed_hatch.take_damage(floor(damage), type, attacker, unmitigated = TRUE)

/**
 * Resolves a single hit against one module, picked by the attacker's aimed zone and redirected up the hierarchy if missing or destroyed.
 * Rolls hull/turret internal damage, applies directional armor, and splashes damage onto Armor and adjacent modules.
 *
 * Arguments:
 * * damage = Raw incoming damage, pre-type-multiplier.
 * * type = One of "acid"/"slash"/"bullet"/"explosive"/"blunt"/"abstract".
 * * attacker = Whoever dealt this hit, if known.
 * * unmitigated = Skips directional and Armor splash mitigation entirely. Used by xeno abilities meant to land as one full hit.
 */
/obj/vehicle/multitile/proc/take_damage_type(damage, type, atom/attacker, unmitigated = FALSE)
	if(type == "slash" && istype(attacker, /mob/living/carbon/xenomorph))
		var/mob/living/carbon/xenomorph/attacker_xeno = attacker
		// must actually be on top of THIS vehicle (exterior), same z, and standing on one of our tiles
		if(attacker_xeno.get_tank_on_top_of() == src && attacker_xeno.z == z)
			var/turf/xturf = get_turf(attacker_xeno)
			if(xturf && (xturf in src.locs))
				damage *= 0.7

	var/hit_zone = get_hit_direction_zone(attacker)
	var/external_scaled_damage = unmitigated ? damage : (damage * get_directional_dmg_multi(type, hit_zone))
	var/internal_scaled_damage = unmitigated ? damage : (damage * get_directional_internal_dmg_multi(type, hit_zone))
	var/internal_chance_bonus = get_internal_leak_chance_bonus(hit_zone)
	var/target_slot = get_attack_target_slot(attacker)
	var/obj/item/hardpoint/target = resolve_targeted_hardpoint(target_slot)
	var/hit_name = "hull"

	if(!target)
		apply_hull_damage(external_scaled_damage, type, attacker, unmitigated = unmitigated)
		roll_internal_module_damage(WOUND_SLOT_HULL, internal_scaled_damage, type, attacker, internal_chance_bonus)
		bleed_external_modules(WOUND_SLOT_HULL, external_scaled_damage)
	else if(target.slot == HDPT_TURRET)
		hit_name = target.name
		target.take_damage(floor(external_scaled_damage), type, attacker, unmitigated = unmitigated)
		// Air Filter is weighted 3x over Turret Ring in this cascade, it's a far more exposed target.
		roll_internal_module_damage(HDPT_TURRET, internal_scaled_damage, type, attacker, internal_chance_bonus, favored_slot = HDPT_AIR_FILTER)
		bleed_external_modules(HDPT_TURRET, external_scaled_damage)
	else
		hit_name = target.name
		target.take_damage(floor(external_scaled_damage), type, attacker, unmitigated = unmitigated)
		var/parent_slot = GLOB.hardpoint_target_parent[target.slot]
		if(parent_slot == WOUND_SLOT_HULL)
			apply_hull_damage(external_scaled_damage * HARDPOINT_BLEED_THROUGH_FRACTION, type, attacker, no_wound_roll = TRUE)
		else if(parent_slot)
			var/obj/item/hardpoint/parent = get_hardpoint_by_slot(parent_slot)
			parent?.deal_raw_damage(external_scaled_damage * HARDPOINT_BLEED_THROUGH_FRACTION)
		// A directly-targeted external module has no route to the parent's internal pool unless side/rear opens one up.
		if(parent_slot && internal_chance_bonus)
			roll_internal_module_damage(parent_slot, internal_scaled_damage, type, attacker, internal_chance_bonus, favored_slot = (parent_slot == HDPT_TURRET) ? HDPT_AIR_FILTER : null)

	// Every branch above lands on an external module, so Armor takes its own small splash from each one.
	apply_armor_splash_damage(external_scaled_damage, type, attacker, unmitigated)

	// The hatch sits at the rear, a hit from directly behind always finds it regardless of the resolved target above.
	if(hit_zone == HIT_ZONE_REAR)
		apply_guaranteed_rear_hatch_damage(damage, type, attacker)

	// The attack's own flavor message can't know what part actually got hit, so show that separately here.
	visible_message(SPAN_DANGER("\The [src]'s <b>[hit_name]</b> is struck!"))

	if(ismob(attacker))
		var/mob/M = attacker
		log_attack("[src] took [damage] [type] damage (aimed at [target_slot]) from [M] ([M.client ? M.client.ckey : "disconnected"]).")
	else
		log_attack("[src] took [damage] [type] damage (aimed at [target_slot]) from [attacker].")
	update_icon()

/// Child slot -> parent slot, the redirect chain used when the aimed part is missing or destroyed.
GLOBAL_LIST_INIT(hardpoint_target_parent, list(
	(HDPT_TREADS) = WOUND_SLOT_HULL,
	(HDPT_PRIMARY) = HDPT_TURRET,
	(HDPT_SECONDARY) = HDPT_TURRET,
	(HDPT_IFF_MODULE) = HDPT_TURRET,
	(HDPT_VISUAL_SENSORS) = HDPT_TURRET,
	(HDPT_TURRET) = WOUND_SLOT_HULL,
))

/// Parent slot -> its internal, organ-style random-damage pool.
GLOBAL_LIST_INIT(hardpoint_internal_pool, list(
	(WOUND_SLOT_HULL) = list(HDPT_ENGINE, HDPT_BATTERY, HDPT_RADIATOR, HDPT_FUEL_TANK, HDPT_HATCH, HDPT_SUPPORT),
	(HDPT_TURRET) = list(HDPT_TURRET_RING, HDPT_AIR_FILTER),
))

/// What slot an incoming hit should be aimed at, read from the attacker's selected zone.
/obj/vehicle/multitile/proc/get_attack_target_slot(atom/attacker)
	if(!ismob(attacker))
		return WOUND_SLOT_HULL
	var/mob/attacker_mob = attacker
	return attacker_mob.vehicle_zone_selected || WOUND_SLOT_HULL

/// Finds the installed hardpoint occupying the given slot, top-level or holder-nested.
/obj/vehicle/multitile/proc/get_hardpoint_by_slot(slot)
	for(var/obj/item/hardpoint/H in hardpoints)
		if(H.slot == slot)
			return H
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/holder_hp = H
			for(var/obj/item/hardpoint/sub in holder_hp.hardpoints)
				if(sub.slot == slot)
					return sub
	return null

/**
 * Resolves an aimed-at slot into the actual hardpoint that should take a hit right now, walking the
 * redirect chain up through parents whenever the aimed part doesn't exist or is already destroyed.
 *
 * Arguments:
 * * slot = One of the 7 targetable slots. Anything else falls back to WOUND_SLOT_HULL immediately.
 *
 * Returns:
 * * The hardpoint to damage, or null if the resolved target is the hull itself.
 */
/obj/vehicle/multitile/proc/resolve_targeted_hardpoint(slot)
	var/current_slot = slot
	while(current_slot && current_slot != WOUND_SLOT_HULL)
		var/obj/item/hardpoint/H = get_hardpoint_by_slot(current_slot)
		if(H && H.health > 0)
			return H
		current_slot = GLOB.hardpoint_target_parent[current_slot]
	return null

/**
 * Applies damage straight to the vehicle's own frame health, tracking the acid/brute sub-pool and
 * rolling hull_melted/hull_hole. Shared by both a direct Hull hit and a redirected-to-Hull hit.
 *
 * Arguments:
 * * damage = Type-scaled incoming damage, pre-hull_damage_multiplier.
 * * type = One of "acid"/"slash"/"bullet"/"explosive"/"blunt"/"abstract".
 * * attacker = Whoever dealt this hit, if known.
 * * no_wound_roll = TRUE for a bleed-through splash. Still reduces health, no wound roll.
 * * unmitigated = Skips hull_damage_multiplier and the incoming wound multiplier entirely.
 * * wound_chance_mult = Passed straight through to roll_hull_wounds().
 */
/obj/vehicle/multitile/proc/apply_hull_damage(damage, type, atom/attacker, no_wound_roll = FALSE, unmitigated = FALSE, wound_chance_mult = 1)
	if(damage <= 0)
		return
	var/mapped_hull_type = wound_damage_type_for(type)
	var/hull_damage = damage
	if(!unmitigated)
		var/hull_multiplier = get_hull_incoming_damage_wound_multiplier(mapped_hull_type)
		hull_damage = damage * hull_damage_multiplier * hull_multiplier
	health = max(0, health - hull_damage)
	if(mapped_hull_type == WOUND_DAMTYPE_ACID)
		hull_acid_damage_taken += hull_damage
	else if(mapped_hull_type == WOUND_DAMTYPE_BRUTE)
		hull_brute_damage_taken += hull_damage
	if(mapped_hull_type && !no_wound_roll)
		roll_hull_wounds(hull_damage, mapped_hull_type, attacker, wound_chance_mult)
	if(!health)
		on_hull_destroyed()

/// Fires once when hull health first reaches 0. No-op by default; a vehicle that wants the ammo-cookoff finale (multitile_cookoff.dm) overrides this to call start_hull_cookoff_sequence().
/obj/vehicle/multitile/proc/on_hull_destroyed()
	return

/**
 * Organ-style random internal-module damage: a hit to an external part has a chance to also
 * land on a random internal part behind it, rising as the parent gets more damaged. Picks
 * one installed, non-destroyed hardpoint and hits it with a real take_damage() call.
 *
 * Arguments:
 * * parent_slot = WOUND_SLOT_HULL or HDPT_TURRET, whose internal pool to roll against.
 * * hit_damage = The type-scaled incoming hit that struck the parent.
 * * type = One of "acid"/"slash"/"bullet"/"explosive"/"blunt"/"abstract".
 * * attacker = Whoever dealt this hit, if known.
 * * chance_bonus_pct = Flat percent added onto the computed chance, capped at 100.
 * * favored_slot = A member of the internal pool to weight the victim pick toward.
 */
/obj/vehicle/multitile/proc/roll_internal_module_damage(parent_slot, hit_damage, type, atom/attacker, chance_bonus_pct = 0, favored_slot = null)
	if(hit_damage <= 0)
		return
	var/list/candidates = list()
	for(var/internal_slot in GLOB.hardpoint_internal_pool[parent_slot])
		var/obj/item/hardpoint/candidate = get_hardpoint_by_slot(internal_slot)
		if(candidate && candidate.health > 0)
			candidates += candidate
			if(internal_slot == favored_slot)
				candidates += list(candidate, candidate) // extra weight toward the favored slot
	if(!length(candidates))
		return

	var/wound_count
	var/integrity_pct
	if(parent_slot == WOUND_SLOT_HULL)
		wound_count = LAZYLEN(hull_wound_tiers)
		integrity_pct = initial(health) ? (100 * health / initial(health)) : 100
	else
		var/obj/item/hardpoint/parent = get_hardpoint_by_slot(parent_slot)
		wound_count = parent ? LAZYLEN(parent.wound_tiers) : 0
		integrity_pct = parent ? parent.get_integrity_percent() : 100

	var/chance = min(HARDPOINT_ORGAN_DAMAGE_CHANCE_CAP, hit_damage * HARDPOINT_ORGAN_DAMAGE_CHANCE_PER_DAMAGE)
	chance += wound_count * HARDPOINT_ORGAN_DAMAGE_WOUND_BONUS
	if(integrity_pct < HARDPOINT_ORGAN_DAMAGE_INTEGRITY_THRESHOLD)
		chance += (HARDPOINT_ORGAN_DAMAGE_INTEGRITY_THRESHOLD - integrity_pct) * HARDPOINT_ORGAN_DAMAGE_INTEGRITY_SCALE
	chance += chance_bonus_pct
	chance = min(chance, 100)

	if(!prob(chance))
		return

	var/obj/item/hardpoint/victim = pick(candidates)
	victim.take_damage(floor(hit_damage), type, attacker)

/**
 * Guaranteed counterpart to roll_internal_module_damage(). Skips the chance roll and
 * always lands, unmitigated.
 *
 * Arguments:
 * * parent_slot = WOUND_SLOT_HULL or HDPT_TURRET, whose internal pool to pick from.
 * * damage = Damage to deal to the chosen victim.
 * * type = One of "acid"/"slash"/"bullet"/"explosive"/"blunt"/"abstract".
 * * attacker = Whoever dealt this hit, if known.
 *
 * Returns:
 * * TRUE if a candidate existed and was hit, FALSE if the parent's internal pool is empty.
 */
/obj/vehicle/multitile/proc/force_internal_module_damage(parent_slot, damage, type, atom/attacker)
	var/list/candidates = list()
	for(var/internal_slot in GLOB.hardpoint_internal_pool[parent_slot])
		var/obj/item/hardpoint/candidate = get_hardpoint_by_slot(internal_slot)
		if(candidate && candidate.health > 0)
			candidates += candidate
	if(!length(candidates))
		return FALSE

	var/obj/item/hardpoint/victim = pick(candidates)
	victim.take_damage(damage, type, attacker, unmitigated = TRUE)
	return TRUE

/**
 * Deals normal, single-layer-mitigated damage to one randomly-picked part of this tank,
 * weighted toward the attacker's aimed slot. Used for xeno ammo with no real aim, and
 * melee/environmental acid exposure.
 *
 * A genuinely aimed, single-target hit should use apply_targeted_acid_hit() instead.
 *
 * Arguments:
 * * damage = Raw incoming damage for whichever part ends up picked.
 * * type = "acid" (or a brute-mapping type string).
 * * attacker = Whoever dealt this hit, if known. Used to weight the pick toward their aim.
 * * ignore_aim = Skip the aimed-slot weighting and pick uniformly among installed parts.
 * * wound_chance_mult = Passed through to apply_hull_damage()/take_damage().
 */
/obj/vehicle/multitile/tank/proc/apply_weighted_module_hit(damage, type, atom/attacker, ignore_aim = FALSE, wound_chance_mult = 1)
	var/aimed_slot = ignore_aim ? null : get_attack_target_slot(attacker)
	var/list/weighted_candidates = list(null) // null = Hull
	if(aimed_slot == WOUND_SLOT_HULL)
		weighted_candidates += list(null, null) // extra weight toward the aimed slot

	for(var/obj/item/hardpoint/H in get_hardpoints_copy())
		if(H.health <= 0)
			continue
		weighted_candidates += H
		if(H.slot == aimed_slot)
			weighted_candidates += list(H, H) // extra weight toward the aimed slot

	var/picked = pick(weighted_candidates)
	var/hit_name = "hull"
	if(!picked)
		apply_hull_damage(damage, type, attacker, wound_chance_mult = wound_chance_mult)
	else
		var/obj/item/hardpoint/victim = picked
		hit_name = victim.name
		victim.take_damage(damage, type, attacker, wound_chance_mult = wound_chance_mult)

	visible_message(SPAN_DANGER("\The [src]'s <b>[hit_name]</b> is struck!"))

/**
 * Same damage resolution as apply_weighted_module_hit(), but to the exact slot the attacker
 * is aiming at. Used for a directed acid spit.
 *
 * Arguments:
 * * damage = Raw incoming damage for whichever part this resolves to.
 * * type = "acid" (or a brute-mapping type string).
 * * attacker = Whoever fired the spit, read for aim.
 * * wound_chance_mult = Passed straight through to apply_hull_damage()/take_damage().
 */
/obj/vehicle/multitile/tank/proc/apply_targeted_acid_hit(damage, type, atom/attacker, wound_chance_mult = 1)
	var/target_slot = get_attack_target_slot(attacker)
	var/obj/item/hardpoint/target = resolve_targeted_hardpoint(target_slot)
	var/hit_name = "hull"
	if(!target)
		apply_hull_damage(damage, type, attacker, wound_chance_mult = wound_chance_mult)
	else
		hit_name = target.name
		target.take_damage(damage, type, attacker, wound_chance_mult = wound_chance_mult)
		// Gives a directed acid spit the same Air-Filter-favored organ cascade chance a normal hit gets.
		if(target.slot == HDPT_TURRET)
			roll_internal_module_damage(HDPT_TURRET, damage, type, attacker, favored_slot = HDPT_AIR_FILTER)

	visible_message(SPAN_DANGER("\The [src]'s <b>[hit_name]</b> is struck!"))

/**
 * Acid Ball-specific resolution. Ignores aim and picks uniformly among external modules
 * only, never Hull/Turret.
 *
 * Arguments:
 * * damage = Raw incoming damage for whichever module ends up picked.
 * * attacker = Whoever dealt this hit, if known.
 */
/obj/vehicle/multitile/tank/proc/apply_random_external_acid_hit(damage, atom/attacker)
	var/list/candidates = list()
	for(var/slot in list(HDPT_TREADS, HDPT_PRIMARY, HDPT_SECONDARY, HDPT_IFF_MODULE, HDPT_VISUAL_SENSORS))
		var/obj/item/hardpoint/H = get_hardpoint_by_slot(slot)
		if(H && H.health > 0)
			candidates += H
	if(!length(candidates))
		return

	var/obj/item/hardpoint/victim = pick(candidates)
	victim.take_damage(damage, "acid", attacker)
	visible_message(SPAN_DANGER("\The [src]'s <b>[victim.name]</b> is struck!"))

/**
 * Deterministic splash damage to every external module mounted on the given parent.
 * Always a small fixed fraction of the parent's incoming hit.
 *
 * Arguments:
 * * parent_slot = WOUND_SLOT_HULL or HDPT_TURRET.
 * * hit_damage = The type-scaled incoming hit that struck the parent.
 */
/obj/vehicle/multitile/proc/bleed_external_modules(parent_slot, hit_damage)
	if(hit_damage <= 0)
		return
	var/bleed_amount = hit_damage * HARDPOINT_BLEED_THROUGH_FRACTION
	for(var/child_slot in GLOB.hardpoint_target_parent)
		if(GLOB.hardpoint_target_parent[child_slot] != parent_slot)
			continue
		var/obj/item/hardpoint/child = get_hardpoint_by_slot(child_slot)
		if(child && child.health > 0)
			child.deal_raw_damage(bleed_amount)

/**
 * Broadcasts a wound-gain notice to seated crew and nearby marines/xenos. Bold-tier wounds
 * get a font-size bump.
 *
 * Arguments:
 * * marine_text = tier_data["marine_feedback_red"]. Null-safe, no-ops the marine side if absent.
 * * xeno_text = tier_data["xeno_feedback"]. Null-safe, no-ops the xeno side if absent.
 * * bold = tier_data["bold_feedback"].
 */
/obj/vehicle/multitile/proc/broadcast_wound_notice(marine_text, xeno_text, bold)
	var/marine_line = marine_text ? (bold ? "<span style='font-size: 1.15em'>[SPAN_BOLDWARNING(marine_text)]</span>" : SPAN_WARNING(marine_text)) : null
	var/xeno_line = xeno_text ? (bold ? "<span style='font-size: 1.15em'>[SPAN_XENOBOLDNOTICE(xeno_text)]</span>" : SPAN_XENOWARNING(xeno_text)) : null

	if(marine_line)
		for(var/seat_key in seats)
			var/mob/seated_mob = seats[seat_key]
			if(seated_mob)
				to_chat(seated_mob, marine_line)

	if(!marine_line && !xeno_line)
		return

	for(var/mob/living/viewer in viewers(src))
		if(marine_line && ishuman(viewer))
			to_chat(viewer, marine_line)
		else if(xeno_line && isxeno(viewer))
			to_chat(viewer, xeno_line)

/// This vehicle's progress on one Hull wound family's current tier, or 0 if none.
/obj/vehicle/multitile/proc/get_hull_wound_repair_step(family_type)
	var/list/progress = LAZYACCESS(hull_wound_repair_progress, family_type)
	if(!progress || progress["tier"] != LAZYACCESS(hull_wound_tiers, family_type))
		return 0
	return progress["step"]

/**
 * Attempts one step of a Hull wound tier's repair_steps sequence, the frame's own counterpart to
 * fix_wound(). Every Hull tier is unmount_required = FALSE, so this is the only Hull repair path.
 *
 * Arguments:
 * * user = Whoever is attempting the repair.
 * * tool = The tool used. Must match the next unfinished step.
 * * family_type = A wound family's type path.
 */
/obj/vehicle/multitile/proc/fix_hull_wound(mob/living/user, obj/item/tool, family_type)
	if(!ishuman(user) || user.is_mob_incapacitated())
		return
	if(get_dist(src, user) > 2) // vehicle is 3x3, Adjacent() alone forces standing on its unreachable centre tile
		return

	var/starting_tier = LAZYACCESS(hull_wound_tiers, family_type)
	if(!starting_tier)
		return
	var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
	if(!family || starting_tier > length(family.tiers))
		return
	var/list/tier_data = family.tiers[starting_tier]
	var/list/steps = tier_data["repair_steps"]
	if(!length(steps))
		return
	var/starting_step = get_hull_wound_repair_step(family_type)
	if(starting_step >= length(steps))
		return
	var/required_step = steps[starting_step + 1]
	if(!wound_repair_step_matches_tool(required_step, tool))
		return
	if(required_step == "welder")
		var/obj/item/tool/weldingtool/WT = tool
		if(!HAS_TRAIT(WT, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
	if(!skillcheck(user, SKILL_ENGINEER, tier_data["repair_required_skill"] || SKILL_ENGINEER_NOVICE))
		to_chat(user, SPAN_WARNING("This task is beyond you!"))
		return

	var/is_final_step = (starting_step + 1) >= length(steps)
	user.visible_message(SPAN_NOTICE("[user] starts working on \the [src]'s [tier_data["wound_name"]]."), SPAN_NOTICE("You start fixing \the [src]'s [tier_data["wound_name"]]."))
	if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return
	if(get_dist(src, user) > 2 || tool != user.get_active_hand() || get_hull_wound_repair_step(family_type) != starting_step || LAZYACCESS(hull_wound_tiers, family_type) != starting_tier || !wound_repair_step_matches_tool(required_step, tool))
		return
	consume_wound_repair_step_material(required_step, tool)

	if(!is_final_step)
		LAZYSET(hull_wound_repair_progress, family_type, list("tier" = starting_tier, "step" = starting_step + 1))
		user.visible_message(SPAN_NOTICE("[user] finishes a step on \the [src]'s [tier_data["wound_name"]]."), SPAN_NOTICE("You finish a step. [length(steps) - starting_step - 1] more to go."))
		return

	var/revert_tier = tier_data["repair_reverts_to_tier"]
	if(revert_tier)
		LAZYSET(hull_wound_tiers, family_type, revert_tier)
	else
		LAZYREMOVE(hull_wound_tiers, family_type)
	LAZYREMOVE(hull_wound_repair_progress, family_type)
	user.visible_message(SPAN_NOTICE("[user] fixes \the [src]'s [tier_data["wound_name"]]."), SPAN_NOTICE("You fix \the [src]'s [tier_data["wound_name"]]."))
