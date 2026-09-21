/**
 * A catalog entry for one wound family (e.g. "primary_fouling"). Every instance is
 * auto-collected by part_slot into GLOB.hardpoint_wound_families_by_slot.
 */
/datum/hardpoint_wound_family
	/// HDPT_* slot this family applies to, or WOUND_SLOT_HULL for the two vehicle-frame families.
	var/part_slot
	/// WOUND_DAMTYPE_ACID, WOUND_DAMTYPE_BRUTE, or WOUND_DAMTYPE_UNIFIED (fuel_tank_leak only).
	var/damage_type
	/// TRUE for neurotoxin "_gunked" families. Only reachable via the neuro alt-trigger roll.
	var/neuro_alt_trigger_only = FALSE
	/**
	 * Ordered list of tier data, index 1 = tier 1. Each entry is an assoc list with keys:
	 * * wound_name: short display name.
	 * * marine_feedback_red, xeno_feedback: examine blurbs shown to marines and xenos.
	 * * bold_feedback: TRUE renders both blurbs bold, marking a clear weak point.
	 * * repair_method, repair_skill: fallback repair text and the skill needed.
	 * * unmount_required: TRUE means this tier only repairs after being removed from the vehicle.
	 * * repair_steps: ordered list of required steps, a tool trait, "welder", or a material step
	 *   list("material", stack_type_path, amount).
	 * * repair_step_verbs: one verb phrase per repair_steps entry, used in the repair info text.
	 * * repair_reverts_to_tier: null clears the wound, or a lower tier number to revert to.
	 * * repair_required_skill: set only when repair_skill needs more than the base engineer skill.
	 * * min_health_threshold_pct, damage_to_chance_pct, max_roll_chance_pct: gating/roll formula.
	 * * neuro_alt_trigger_chance_pct: stored but unused this round.
	 * * Optional effect fields: accuracy_mult, scatter_mult, projectile_speed_mult, damage_mult,
	 *   turn_rate_mult, vision_impair_add, incoming_damage_mult, incoming_damage_type,
	 *   passive_leak_rate, aura_reduction_add, iff_disabled, module_disabled, performance_mult.
	 *
	 * Multiple active wounds setting the same numeric key compound multiplicatively.
	 */
	var/list/tiers

// Feedback strings below underline and color-code the damage type word: red for
// mechanical, green for corrosive, gold for neurotoxin.

/// Human-readable family name derived from this datum's type path.
/datum/hardpoint_wound_family/proc/get_display_label()
	var/static/prefix_length = length("[/datum/hardpoint_wound_family]/")
	var/family_id = copytext("[type]", prefix_length + 1)
	var/list/words = splittext(family_id, "_")
	var/list/capitalized_words = list()
	for(var/word in words)
		capitalized_words += capitalize(word)
	return jointext(capitalized_words, " ")

/datum/hardpoint_wound_family/primary_fouling
	part_slot = HDPT_PRIMARY
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Light Fouling", "marine_feedback_red" = "A light film of <u><span class='green'>acid fouling</span></u> coats the barrel's bore.",
			"xeno_feedback" = "<u><span class='green'>Acid grime</span></u> dulls the insides of the boom-tube to a sickly color.", "bold_feedback" = FALSE,
			"repair_method" = "Wipe down with a rag OR burn with a welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the fouling away"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 90, "neuro_alt_trigger_chance_pct" = null,
			"accuracy_mult" = 0.9, "scatter_mult" = 1.2, "damage_mult" = 0.95),
		list("wound_name" = "Heavy Fouling", "marine_feedback_red" = "Thick, caked carbon chunks choke the chamber, built up from repeated <u><span class='green'>acid exposure</span></u>.",
			"xeno_feedback" = "<u><span class='green'>Acid buildup</span></u> clogs the primary fire-spitter's throat.", "bold_feedback" = FALSE,
			"repair_method" = "Pry the caked carbon chunks loose with a crowbar (Reverts to Tier 1)", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR), "repair_step_verbs" = list("prying the carbon chunks loose"), "repair_reverts_to_tier" = 1,
			"min_health_threshold_pct" = 70, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 55, "neuro_alt_trigger_chance_pct" = null,
			"accuracy_mult" = 0.75, "scatter_mult" = 1.5, "projectile_speed_mult" = 0.8, "damage_mult" = 0.85),
		list("wound_name" = "Severe Fouling", "marine_feedback_red" = "Hardened, <u><span class='green'>acid-eaten</span></u> carbon buildup chokes the breach solid.",
			"xeno_feedback" = "Partially-molten <u><span class='green'>acid-steel slag</span></u> fills the primary barrel solid.", "bold_feedback" = TRUE,
			"repair_method" = "Unmount the barrel and fully scrape out the breach (Unmount, crowbar + welder)", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR, "welder"), "repair_step_verbs" = list("scraping the breach clean", "welding it smooth"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 60, "damage_to_chance_pct" = 2, "max_roll_chance_pct" = 30, "neuro_alt_trigger_chance_pct" = null,
			"accuracy_mult" = 0.55, "scatter_mult" = 2.0, "projectile_speed_mult" = 0.5, "damage_mult" = 0.65),
	)

/**
 * Neurotoxin's parallel to primary_fouling. Half as severe per tier, rolls about twice as often.
 */
/datum/hardpoint_wound_family/primary_gunked
	part_slot = HDPT_PRIMARY
	damage_type = WOUND_DAMTYPE_ACID
	neuro_alt_trigger_only = TRUE
	tiers = list(
		list("wound_name" = "Light Gunk", "marine_feedback_red" = "A tacky film of <u><font color='#E8C547'>neurotoxin residue</font></u> coats the barrel's bore.",
			"xeno_feedback" = "A sticky film of <u><font color='#E8C547'>neurotoxin</font></u> clings to the insides of the boom-tube.", "bold_feedback" = FALSE,
			"repair_method" = "Wipe down with a rag OR burn with a welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the gunk away"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 90, "neuro_alt_trigger_chance_pct" = 40,
			"accuracy_mult" = 0.95, "scatter_mult" = 1.1, "damage_mult" = 0.975),
		list("wound_name" = "Heavy Gunk", "marine_feedback_red" = "Thick, tacky <u><font color='#E8C547'>neurotoxin residue</font></u> chokes the chamber.",
			"xeno_feedback" = "Globs of sticky <u><font color='#E8C547'>neurotoxin</font></u> residue gum the primary fire-spitter's throat shut.", "bold_feedback" = FALSE,
			"repair_method" = "Pry the caked residue loose with a crowbar (Reverts to Tier 1)", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR), "repair_step_verbs" = list("prying the caked residue loose"), "repair_reverts_to_tier" = 1,
			"min_health_threshold_pct" = 70, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 55, "neuro_alt_trigger_chance_pct" = 24,
			"accuracy_mult" = 0.875, "scatter_mult" = 1.25, "projectile_speed_mult" = 0.9, "damage_mult" = 0.925),
		list("wound_name" = "Severe Gunk", "marine_feedback_red" = "Hardened, web-like <u><font color='#E8C547'>neurotoxin residue</font></u> chokes the breach solid.",
			"xeno_feedback" = "A hardened web of <u><font color='#E8C547'>neurotoxin residue</font></u> packs the primary barrel solid.", "bold_feedback" = TRUE,
			"repair_method" = "Unmount the barrel and fully scrape out the breach (Unmount, crowbar + welder)", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR, "welder"), "repair_step_verbs" = list("scraping the breach clean", "welding it smooth"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 60, "damage_to_chance_pct" = 2, "max_roll_chance_pct" = 30, "neuro_alt_trigger_chance_pct" = 12,
			"accuracy_mult" = 0.775, "scatter_mult" = 1.5, "projectile_speed_mult" = 0.75, "damage_mult" = 0.825),
	)

/datum/hardpoint_wound_family/primary_bent_barrel
	part_slot = HDPT_PRIMARY
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Minor Bend", "marine_feedback_red" = "A slight <u><span class='red'>kink</span></u> runs along the barrel.",
			"xeno_feedback" = "A faint <u><span class='red'>kink</span></u> mars the barrel's line.", "bold_feedback" = FALSE,
			"repair_method" = "Hammer it straight in place with a wrench", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("wrenching it back into shape"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 90, "neuro_alt_trigger_chance_pct" = null,
			"accuracy_mult" = 0.9, "scatter_mult" = 1.2, "damage_mult" = 0.95),
		list("wound_name" = "Warped Barrel", "marine_feedback_red" = "The barrel is visibly <u><span class='red'>warped</span></u> out of true.",
			"xeno_feedback" = "Our strikes have left the weapon's silhouette <u><span class='red'>crooked</span></u>.", "bold_feedback" = FALSE,
			"repair_method" = "Unmount and straighten with a crowbar", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR), "repair_step_verbs" = list("straightening it with the crowbar"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 80, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 55, "neuro_alt_trigger_chance_pct" = null,
			"accuracy_mult" = 0.75, "scatter_mult" = 1.5, "projectile_speed_mult" = 0.8, "damage_mult" = 0.85),
		list("wound_name" = "Severely Bent Barrel", "marine_feedback_red" = "The barrel is <u><span class='red'>bent</span></u> badly enough it's a wonder it still fires straight at all.",
			"xeno_feedback" = "The boom-tube is so <u><span class='red'>misshapen</span></u> that it points almost completely to the side.", "bold_feedback" = TRUE,
			"repair_method" = "Unmount, soften metal with a welder, straighten with a crowbar, weaken again, straighten with a wrench.", "repair_skill" = "Maintenance Tech or Combat Technician", "unmount_required" = TRUE,
			"repair_steps" = list("welder", TRAIT_TOOL_CROWBAR, "welder", TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("softening the metal with a welder", "straightening it with a crowbar", "weakening the metal again", "straightening it true with a wrench"), "repair_reverts_to_tier" = null, "repair_required_skill" = SKILL_ENGINEER_ENGI,
			"min_health_threshold_pct" = 75, "damage_to_chance_pct" = 2, "max_roll_chance_pct" = 30, "neuro_alt_trigger_chance_pct" = null,
			"accuracy_mult" = 0.55, "scatter_mult" = 2.0, "projectile_speed_mult" = 0.5, "damage_mult" = 0.65),
	)

/datum/hardpoint_wound_family/secondary_sticky_feed
	part_slot = HDPT_SECONDARY
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Light Residue", "marine_feedback_red" = "A light film of <u><span class='green'>acid residue</span></u> coats the feed tray.",
			"xeno_feedback" = "<u><span class='green'>Acid buildup</span></u> clogs the secondary fire-spitter's throat.", "bold_feedback" = FALSE,
			"repair_method" = "Wipe down the feed tray with a rag OR burn the residue off with a welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the residue off"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 80, "neuro_alt_trigger_chance_pct" = null,
			"damage_mult" = 0.95),
		list("wound_name" = "Gummed Feed", "marine_feedback_red" = "The feed tray is thickly gummed, sticky with hardened <u><span class='green'>acid residue</span></u>.",
			"xeno_feedback" = "Partially-molten <u><span class='green'>acid-steel slag</span></u> fills the secondary barrel solid.", "bold_feedback" = TRUE,
			"repair_method" = "Pry the chunks off with a crowbar (Reverts to Tier 1)", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR), "repair_step_verbs" = list("prying the chunks off"), "repair_reverts_to_tier" = 1,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 50, "neuro_alt_trigger_chance_pct" = null,
			"damage_mult" = 0.8),
	)

/// Neurotoxin's parallel to secondary_sticky_feed. Half as severe, rolls about twice as often.
/datum/hardpoint_wound_family/secondary_gunked
	part_slot = HDPT_SECONDARY
	damage_type = WOUND_DAMTYPE_ACID
	neuro_alt_trigger_only = TRUE
	tiers = list(
		list("wound_name" = "Light Gunk", "marine_feedback_red" = "A tacky film of <u><font color='#E8C547'>neurotoxin residue</font></u> coats the feed tray.",
			"xeno_feedback" = "Sticky <u><font color='#E8C547'>neurotoxin</font></u> residue gums the secondary fire-spitter's throat shut.", "bold_feedback" = FALSE,
			"repair_method" = "Wipe down the feed tray with a rag OR burn the residue off with a welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the residue off"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 80, "neuro_alt_trigger_chance_pct" = 30,
			"damage_mult" = 0.975),
		list("wound_name" = "Gunked Feed", "marine_feedback_red" = "The feed tray is thickly webbed with hardened <u><font color='#E8C547'>neurotoxin residue</font></u>.",
			"xeno_feedback" = "A hardened web of <u><font color='#E8C547'>neurotoxin residue</font></u> packs the secondary barrel solid.", "bold_feedback" = TRUE,
			"repair_method" = "Pry the chunks off with a crowbar (Reverts to Tier 1)", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR), "repair_step_verbs" = list("prying the chunks off"), "repair_reverts_to_tier" = 1,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 50, "neuro_alt_trigger_chance_pct" = 16,
			"damage_mult" = 0.9),
	)

/datum/hardpoint_wound_family/secondary_cracked_mount
	part_slot = HDPT_SECONDARY
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Loose Mount", "marine_feedback_red" = "Our strikes have left the mount visibly <u><span class='red'>loose</span></u>, rattling in its bolts.",
			"xeno_feedback" = "The weapon mount rattles <u><span class='red'>loose</span></u> every time we strike it.", "bold_feedback" = FALSE,
			"repair_method" = "Re-torque the mounting bolts", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("wrenching the mounting bolts tight"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 80, "neuro_alt_trigger_chance_pct" = null,
			"accuracy_mult" = 0.9, "scatter_mult" = 1.2, "damage_mult" = 0.95),
		list("wound_name" = "Cracked Mount", "marine_feedback_red" = "A <u><span class='red'>crack</span></u> runs clean through the mount housing.",
			"xeno_feedback" = "The secondary weapon mount hangs <u><span class='red'>cracked</span></u> and barely functional.", "bold_feedback" = TRUE,
			"repair_method" = "Unmount, weld the cracked housing. (reverts to t1)", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the cracked housing shut"), "repair_reverts_to_tier" = 1,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 50, "neuro_alt_trigger_chance_pct" = null,
			"accuracy_mult" = 0.7, "scatter_mult" = 1.6, "damage_mult" = 0.8),
	)

/datum/hardpoint_wound_family/turret_melted
	part_slot = HDPT_TURRET
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Molten Plating", "marine_feedback_red" = "<u><span class='green'>Acid residue</span></u> coats and weakens the turret's plating.",
			"xeno_feedback" = "Our <u><span class='green'>acid</span></u> has left the turret's hide soft and vulnerable!", "bold_feedback" = FALSE,
			"repair_method" = "Burn off the acid damage with a welder, or with a rag", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the acid damage away"), "repair_reverts_to_tier" = null,
			// Hull/Turret tiers trigger easier so they wound fast and unlock the internal cascade.
			"min_health_threshold_pct" = 98, "damage_to_chance_pct" = 8, "max_roll_chance_pct" = 85, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 1.5),
		list("wound_name" = "Molten Support Beams", "marine_feedback_red" = "<u><span class='green'>Acid</span></u> has eaten into the turret's internal structures.",
			"xeno_feedback" = "The turret <u><span class='green'>melts</span></u> away before us! An inviting target!", "bold_feedback" = TRUE,
			"repair_method" = "Attach 10 sheets of steel. Weld it.", "repair_skill" = "Maintenance Tech or Combat Technician", "unmount_required" = TRUE,
			"repair_steps" = list(list("material", /obj/item/stack/sheet/metal, 10), "welder"), "repair_step_verbs" = list("attaching sheets of steel", "welding them into place"), "repair_reverts_to_tier" = null, "repair_required_skill" = SKILL_ENGINEER_ENGI,
			"min_health_threshold_pct" = 70, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 60, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 2.5),
	)

/datum/hardpoint_wound_family/turret_hole
	part_slot = HDPT_TURRET
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Dented Plating", "marine_feedback_red" = "The turret's outer plating is <u><span class='red'>dented</span></u> and scraped raw.",
			"xeno_feedback" = "Our blows have left the turret's armor <u><span class='red'>battered</span></u> and weak!", "bold_feedback" = FALSE,
			"repair_method" = "Repair it using a welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the dents out"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 98, "damage_to_chance_pct" = 8, "max_roll_chance_pct" = 85, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 1.5),
		list("wound_name" = "Gaping Hole", "marine_feedback_red" = "A <u><span class='red'>gaping hole</span></u> exposes the turret's delicate internals.",
			"xeno_feedback" = "A <u><span class='red'>gaping wound</span></u> bares the turret's guts to us! Strike true!", "bold_feedback" = TRUE,
			"repair_method" = "Attach 10 sheets of steel. Weld it.", "repair_skill" = "Maintenance Tech or Combat Technician", "unmount_required" = TRUE,
			"repair_steps" = list(list("material", /obj/item/stack/sheet/metal, 10), "welder"), "repair_step_verbs" = list("attaching sheets of steel", "welding them into place"), "repair_reverts_to_tier" = null, "repair_required_skill" = SKILL_ENGINEER_ENGI,
			"min_health_threshold_pct" = 70, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 60, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 2.5),
	)

/datum/hardpoint_wound_family/hull_melted
	part_slot = WOUND_SLOT_HULL
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Molten Plating", "marine_feedback_red" = "<u><span class='green'>Acid residue</span></u> coats and weakens the hull's plating.",
			"xeno_feedback" = "Our <u><span class='green'>acid</span></u> has left the hull's hide soft and vulnerable!", "bold_feedback" = FALSE,
			"repair_method" = "Burn off the acid damage with a welder, or with a rag", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the acid damage away"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 98, "damage_to_chance_pct" = 8, "max_roll_chance_pct" = 85, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 1.5),
		list("wound_name" = "Molten Support Beams", "marine_feedback_red" = "<u><span class='green'>Acid</span></u> has eaten deep into the hull, severely weakening it.",
			"xeno_feedback" = "The hull <u><span class='green'>melts</span></u> and bubbles wildly. The steel parts like butter before us.", "bold_feedback" = TRUE,
			"repair_method" = "Attach 10 sheets of steel. Weld it.", "repair_skill" = "Maintenance Tech or Combat Technician", "unmount_required" = FALSE,
			"repair_steps" = list(list("material", /obj/item/stack/sheet/metal, 10), "welder"), "repair_step_verbs" = list("attaching sheets of steel", "welding them into place"), "repair_reverts_to_tier" = null, "repair_required_skill" = SKILL_ENGINEER_ENGI,
			"min_health_threshold_pct" = 70, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 60, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 2.5),
	)

/datum/hardpoint_wound_family/hull_hole
	part_slot = WOUND_SLOT_HULL
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Dented Plating", "marine_feedback_red" = "The hull's outer plating is <u><span class='red'>dented</span></u> and scraped raw.",
			"xeno_feedback" = "Our blows have left the hull's armor <u><span class='red'>loose</span></u> and dislodged!", "bold_feedback" = FALSE,
			"repair_method" = "Repair it using a welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the dents out"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 98, "damage_to_chance_pct" = 8, "max_roll_chance_pct" = 85, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 1.5),
		list("wound_name" = "Gaping Hole", "marine_feedback_red" = "<u><span class='red'>Gaping holes</span></u> tear through the hull, straight into the modules beneath.",
			"xeno_feedback" = "<u><span class='red'>Torn</span></u> panels bare the hull's delicate innards to us. Rip away at its metal guts!", "bold_feedback" = TRUE,
			"repair_method" = "Attach 10 sheets of steel. Weld it.", "repair_skill" = "Maintenance Tech or Combat Technician", "unmount_required" = FALSE,
			"repair_steps" = list(list("material", /obj/item/stack/sheet/metal, 10), "welder"), "repair_step_verbs" = list("attaching sheets of steel", "welding them into place"), "repair_reverts_to_tier" = null, "repair_required_skill" = SKILL_ENGINEER_ENGI,
			"min_health_threshold_pct" = 70, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 60, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 2.5),
	)

/datum/hardpoint_wound_family/turret_ring_gummed_bearings
	part_slot = HDPT_TURRET_RING
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Light Grime", "marine_feedback_red" = "A light film of <u><span class='green'>acid grime</span></u> coats the turret ring.",
			"xeno_feedback" = "<u><span class='green'>Acid buildup</span></u> makes the turret struggle to rotate.", "bold_feedback" = FALSE,
			"repair_method" = "Wipe down with a rag OR burn with a welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the grime off"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"turn_rate_mult" = 0.67),
		list("wound_name" = "Gummed Bearings", "marine_feedback_red" = "The turret ring grinds and catches, its bearings gummed with hardened <u><span class='green'>acid slag</span></u>.",
			"xeno_feedback" = "The turret's rotation visibly stutters, its guts clogged with <u><span class='green'>acid slag</span></u>.", "bold_feedback" = TRUE,
			"repair_method" = "Unmount the turret first, then pry the caked carbon chunks loose from the ring with a crowbar (Reverts to Tier 1)", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR), "repair_step_verbs" = list("prying the caked carbon chunks loose"), "repair_reverts_to_tier" = 1,
			"min_health_threshold_pct" = 75, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = null,
			"turn_rate_mult" = 0.33),
	)

/datum/hardpoint_wound_family/turret_ring_warped_gear
	part_slot = HDPT_TURRET_RING
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Ring Chatter", "marine_feedback_red" = "The ring gear <u><span class='red'>chatters</span></u> faintly as it turns.",
			"xeno_feedback" = "Our blows have left the turret <u><span class='red'>grinding</span></u>, rotating slow and rough.", "bold_feedback" = FALSE,
			"repair_method" = "Adjust it with a wrench", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("wrenching it back into alignment"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"turn_rate_mult" = 0.67),
		list("wound_name" = "Warped Ring Gear", "marine_feedback_red" = "The ring gear's teeth sit visibly <u><span class='red'>warped</span></u> where they mesh.",
			"xeno_feedback" = "The turret occasionally seizes <u><span class='red'>locked</span></u> entirely mid-turn.", "bold_feedback" = TRUE,
			"repair_method" = "Unmount the turret first, then crowbar the ring off, and wrench + weld it", "repair_skill" = "Maintenance Tech or Combat Technician", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_WRENCH, "welder"), "repair_step_verbs" = list("wrenching it back into shape", "welding it solid"), "repair_reverts_to_tier" = null, "repair_required_skill" = SKILL_ENGINEER_ENGI,
			"min_health_threshold_pct" = 75, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = null,
			"turn_rate_mult" = 0.33),
	)

/datum/hardpoint_wound_family/armor_corroded_plating
	part_slot = HDPT_ARMOR
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Surface Corrosion", "marine_feedback_red" = "A light film of <u><span class='green'>corrosion</span></u> discolors the plating.",
			"xeno_feedback" = "A faint <u><span class='green'>acid</span></u> scar discolors the armor plate.", "bold_feedback" = FALSE,
			"repair_method" = "Rag Or Welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the corrosion off"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 1.25),
		list("wound_name" = "Corroded Plating", "marine_feedback_red" = "The plating sits visibly pitted and thinning from <u><span class='green'>corrosion</span></u>.",
			"xeno_feedback" = "Our <u><span class='green'>acid</span></u> has already eaten deep pits into this plate.", "bold_feedback" = TRUE,
			"repair_method" = "Crowbar out. Fix with 5 sheets of plasteel.", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(list("material", /obj/item/stack/sheet/plasteel, 5)), "repair_step_verbs" = list("patching it with plasteel sheets"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 2.0),
	)

/datum/hardpoint_wound_family/armor_cracked_plating
	part_slot = HDPT_ARMOR
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Spalling", "marine_feedback_red" = "Our blows have <u><span class='red'>flaked</span></u> chunks off the armor's inner face.",
			"xeno_feedback" = "Small gaps open as the armor plates work <u><span class='red'>loose</span></u> under our strikes.", "bold_feedback" = FALSE,
			"repair_method" = "Welder and Wrench", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder", TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("welding the flaking plate back", "wrenching it tight"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 1.25),
		// This tier's incoming multiplier also covers Acid hits, not just Brute, on the same panel.
		list("wound_name" = "Cracked Plating", "marine_feedback_red" = "A structural <u><span class='red'>crack</span></u> runs clean through the plating.",
			"xeno_feedback" = "Massive <u><span class='red'>cracks</span></u> split the external armor wide open.", "bold_feedback" = TRUE,
			"repair_method" = "Crowbar out. Fix with 5 sheets of plasteel.", "repair_skill" = "Maintenance Tech or Combat Technician", "unmount_required" = TRUE,
			"repair_steps" = list(list("material", /obj/item/stack/sheet/plasteel, 5)), "repair_step_verbs" = list("patching it with plasteel sheets"), "repair_reverts_to_tier" = null, "repair_required_skill" = SKILL_ENGINEER_ENGI,
			"min_health_threshold_pct" = 50, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = null,
			"incoming_damage_mult" = 2.0, "incoming_damage_type" = "all"),
	)

/datum/hardpoint_wound_family/treads_acid_fouled_pins
	part_slot = HDPT_TREADS
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Gritty Pins", "marine_feedback_red" = "The track pins feel gritty and dry, etched by <u><span class='green'>acid grit</span></u>.",
			"xeno_feedback" = "<u><span class='green'>Acid grit</span></u> grinds faintly between the treads with every turn.", "bold_feedback" = FALSE,
			"repair_method" = "Rag Or Welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the grit away"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"performance_mult" = 0.9),
		list("wound_name" = "Acid-Fouled Pins", "marine_feedback_red" = "The track pins sit crusted in hardened <u><span class='green'>acid buildup</span></u> and seizing up.",
			"xeno_feedback" = "The treads visibly grind and hitch, <u><span class='green'>acid-fouled</span></u> with every rotation.", "bold_feedback" = TRUE,
			"repair_method" = "Unmount, Wrench, Welder.", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_WRENCH, "welder"), "repair_step_verbs" = list("wrenching the pins loose", "welding them clean"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = null,
			"performance_mult" = 0.6),
	)

/// Neurotoxin's parallel to treads_acid_fouled_pins. Half as severe, rolls about twice as often.
/datum/hardpoint_wound_family/treads_neuro_gunked_pins
	part_slot = HDPT_TREADS
	damage_type = WOUND_DAMTYPE_ACID
	neuro_alt_trigger_only = TRUE
	tiers = list(
		list("wound_name" = "Tacky Pins", "marine_feedback_red" = "The track pins feel tacky, coated in a thin film of <u><font color='#E8C547'>neurotoxin residue</font></u>.",
			"xeno_feedback" = "<u><font color='#E8C547'>Neurotoxin residue</font></u> clings faintly between the treads with every turn.", "bold_feedback" = FALSE,
			"repair_method" = "Rag Or Welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the residue away"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = 30,
			"performance_mult" = 0.95),
		list("wound_name" = "Neuro-Gunked Pins", "marine_feedback_red" = "The track pins sit webbed in hardened, sticky <u><font color='#E8C547'>neurotoxin residue</font></u> and seizing up.",
			"xeno_feedback" = "The treads visibly grind and hitch, <u><font color='#E8C547'>neuro-gunked</font></u> with every rotation.", "bold_feedback" = TRUE,
			"repair_method" = "Unmount, Wrench, Welder.", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_WRENCH, "welder"), "repair_step_verbs" = list("wrenching the pins loose", "welding them clean"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = 16,
			"performance_mult" = 0.8),
	)

/datum/hardpoint_wound_family/treads_jammed_sprocket
	part_slot = HDPT_TREADS
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Jammed Sprocket", "marine_feedback_red" = "The drive sprocket <u><span class='red'>jams</span></u> and grinds with every rotation.",
			"xeno_feedback" = "Our strikes have left the tank <u><span class='red'>lurching</span></u>, its stride broken.", "bold_feedback" = FALSE,
			"repair_method" = "Free the sprocket with a wrench", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("wrenching the sprocket free"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"performance_mult" = 0.85),
		list("wound_name" = "Thrown Track", "marine_feedback_red" = "The track has slipped <u><span class='red'>thrown</span></u> partway off its guide wheels.",
			"xeno_feedback" = "One of its treads hangs almost completely <u><span class='red'>thrown</span></u> loose!", "bold_feedback" = TRUE,
			"repair_method" = "Unmount, Crowbar, Wrench", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR, TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("prying the track back into its guide", "wrenching it taut"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 45, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 40, "neuro_alt_trigger_chance_pct" = null,
			"performance_mult" = 0.5),
	)

/datum/hardpoint_wound_family/engine_fouled_injector
	part_slot = HDPT_ENGINE
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Fouled Carburator", "marine_feedback_red" = "<u><span class='green'>Acid fouling</span></u> in the injector makes the engine sputter unevenly under load.",
			"xeno_feedback" = "The engine's note stutters, <u><span class='green'>acid-fouled</span></u> from within.", "bold_feedback" = FALSE,
			"repair_method" = "Crowbar, Wrench, Wrench", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR, TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("prying the injector loose", "wrenching it back into place"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"performance_mult" = 0.85),
		list("wound_name" = "Acid Intake", "marine_feedback_red" = "The engine bogs down and runs hot, its intake choked with <u><span class='green'>acid residue</span></u>.",
			"xeno_feedback" = "Thick exhaust smoke pours out under acceleration. Our <u><span class='green'>acid</span></u> has corroded this metal beast from the inside.", "bold_feedback" = TRUE,
			"repair_method" = "Engine must be removed. Screwdriver, Crowbar, Wrench, Crowbar, Welding Tool, Wrench, Screwdriver", "repair_skill" = "Maintenance Tech or Chief Engineer", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_SCREWDRIVER, TRAIT_TOOL_CROWBAR, TRAIT_TOOL_WRENCH, TRAIT_TOOL_CROWBAR, "welder", TRAIT_TOOL_WRENCH, TRAIT_TOOL_SCREWDRIVER),
			"repair_step_verbs" = list("unscrewing the housing", "prying the injector free", "wrenching the manifold loose", "prying the seal away", "welding the injector body", "wrenching it back into place", "screwing the housing shut"),
			"repair_reverts_to_tier" = null, "repair_required_skill" = SKILL_ENGINEER_MASTER,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = null,
			"performance_mult" = 0.6),
	)

/datum/hardpoint_wound_family/engine_cracked_block
	part_slot = HDPT_ENGINE
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		// Overheat trigger lives separately in check_overheat_wound_trigger().
		list("wound_name" = "Blown Gasket", "marine_feedback_red" = "A <u><span class='red'>blown gasket</span></u> leaves milky sludge on the dipstick and white smoke pouring from the exhaust.",
			"xeno_feedback" = "It exhales white smoke through its exhaust, <u><span class='red'>wounded</span></u> and moving with lethargy.", "bold_feedback" = FALSE,
			"repair_method" = "Crowbar, Wrench, Welder, Wrench", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR, TRAIT_TOOL_WRENCH, "welder", TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("prying the block open", "wrenching it steady", "welding the crack shut", "wrenching it back together"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"performance_mult" = 0.85),
		list("wound_name" = "Cracked Block", "marine_feedback_red" = "A hairline <u><span class='red'>crack</span></u> spreads clean through the block casing.",
			"xeno_feedback" = "Fluid pools visibly beneath the engine compartment, <u><span class='red'>cracked</span></u> open. This metal beast, too, can bleed.", "bold_feedback" = TRUE,
			"repair_method" = "Engine must be removed. Screwdriver, Crowbar, Wrench, Crowbar, Welding Tool, Welding Tool, Wrench, Screwdriver", "repair_skill" = "Maintenance Tech or Chief Engineer", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_SCREWDRIVER, TRAIT_TOOL_CROWBAR, TRAIT_TOOL_WRENCH, TRAIT_TOOL_CROWBAR, "welder", TRAIT_TOOL_WRENCH, TRAIT_TOOL_SCREWDRIVER),
			"repair_step_verbs" = list("unscrewing the housing", "prying the block open", "wrenching it steady", "prying the crack wider to clean it", "welding the crack shut", "wrenching it back together", "screwing the housing shut"),
			"repair_reverts_to_tier" = null, "repair_required_skill" = SKILL_ENGINEER_MASTER,
			"min_health_threshold_pct" = 45, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 40, "neuro_alt_trigger_chance_pct" = null,
			"performance_mult" = 0.55),
	)

/datum/hardpoint_wound_family/fuel_tank_leak
	part_slot = HDPT_FUEL_TANK
	damage_type = WOUND_DAMTYPE_UNIFIED
	tiers = list(
		// Responds to both acid and brute damage cumulatively, so flavor text stays purely mechanical.
		list("wound_name" = "Slow Leak", "marine_feedback_red" = "Fuel visibly weeps from a seam torn in the tank.",
			"xeno_feedback" = "A faint fuel smell seeps from a fresh wound in the tank's hull.", "bold_feedback" = FALSE,
			"repair_method" = "Crowbar, Weld", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR, "welder"), "repair_step_verbs" = list("prying the hole closed", "welding the crack"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"passive_leak_rate" = 0.5),
		list("wound_name" = "Cracked Manifold", "marine_feedback_red" = "The fuel manifold has split open, weeping fuel in a steady stream.",
			"xeno_feedback" = "A steady stream of fuel pools beneath the tank, bleeding out from within.", "bold_feedback" = TRUE,
			"repair_method" = "Crowbar, Wrench, Weld", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR, TRAIT_TOOL_WRENCH, "welder"), "repair_step_verbs" = list("prying the manifold open", "wrenching the fitting tight", "welding the crack shut"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 40, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 40, "neuro_alt_trigger_chance_pct" = null,
			"passive_leak_rate" = 3),
	)

/datum/hardpoint_wound_family/radiator_clogged_fins
	part_slot = HDPT_RADIATOR
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Dusty Fins", "marine_feedback_red" = "A light layer of <u><span class='green'>acid grime</span></u> coats the radiator fins.",
			"xeno_feedback" = "A faint film of <u><span class='green'>acid residue</span></u> dusts its metal gills.", "bold_feedback" = FALSE,
			"repair_method" = "Rag Or Welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the grime off"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null),
		list("wound_name" = "Clogged Fins", "marine_feedback_red" = "The radiator fins sit caked solid with <u><span class='green'>acid grime</span></u>.",
			"xeno_feedback" = "Its metal gills are caked with <u><span class='green'>acid residue</span></u>. It will soon suffocate.", "bold_feedback" = TRUE,
			"repair_method" = "Crowbar, Welder", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR, "welder"), "repair_step_verbs" = list("prying the fins clear", "welding the residue away"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = null),
	)

/datum/hardpoint_wound_family/radiator_cracked_core
	part_slot = HDPT_RADIATOR
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Hairline Crack", "marine_feedback_red" = "A hairline <u><span class='red'>crack</span></u> runs across the radiator core.",
			"xeno_feedback" = "A faint <u><span class='red'>crack</span></u> hisses softly where we struck its gills.", "bold_feedback" = FALSE,
			"repair_method" = "Welder and Wrench", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder", TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("welding the crack shut", "wrenching the housing tight"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"passive_leak_rate" = 0.3),
		list("wound_name" = "Cracked Core", "marine_feedback_red" = "The radiator core sits visibly <u><span class='red'>cracked</span></u>, weeping coolant.",
			"xeno_feedback" = "A hiss of steam escapes its <u><span class='red'>cracked</span></u> vents. It cooks itself from the inside.", "bold_feedback" = TRUE,
			"repair_method" = "Welder, Wrench, Welder", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list("welder", TRAIT_TOOL_WRENCH, "welder"), "repair_step_verbs" = list("welding the crack shut", "wrenching the housing tight", "welding the seam smooth"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 45, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 40, "neuro_alt_trigger_chance_pct" = null,
			"passive_leak_rate" = 1.8),
	)

/datum/hardpoint_wound_family/battery_corroded_terminals
	part_slot = HDPT_BATTERY
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Corroded Terminals", "marine_feedback_red" = "The battery terminals sit crusted with <u><span class='green'>corrosion</span></u>.",
			"xeno_feedback" = "A faint chemical tang seeps from somewhere deep in its guts, <u><span class='green'>acid-eaten</span></u> from within.", "bold_feedback" = FALSE,
			"repair_method" = "Welder to burn the film", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the corrosion off"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 80, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = null),
	)

/datum/hardpoint_wound_family/battery_cracked_cell
	part_slot = HDPT_BATTERY
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Cracked Casing", "marine_feedback_red" = "The battery casing sits <u><span class='red'>cracked</span></u> open, its internals bared.",
			"xeno_feedback" = "A dull rattle answers our blows - something <u><span class='red'>cracked</span></u> loose deep inside it.", "bold_feedback" = FALSE,
			"repair_method" = "Welder to fix the casing", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the casing shut"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 65, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 40, "neuro_alt_trigger_chance_pct" = null),
	)

/datum/hardpoint_wound_family/hatch_sticky_latch
	part_slot = HDPT_HATCH
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Sticky Latch", "marine_feedback_red" = "The hatch latch sticks, gummed with <u><span class='green'>acid residue</span></u>, and needs a hard shove to move.",
			"xeno_feedback" = "Somewhere beneath its shell, <u><span class='green'>acid</span></u> has gummed a seam shut.", "bold_feedback" = FALSE,
			"repair_method" = "Welder to burn the sticky film", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the sticky film off"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 90, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 60, "neuro_alt_trigger_chance_pct" = null),
	)

/datum/hardpoint_wound_family/hatch_bent_frame
	part_slot = HDPT_HATCH
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Bent Frame", "marine_feedback_red" = "The hatch frame sits <u><span class='red'>bent</span></u>, no longer flush.",
			"xeno_feedback" = "A dull clunk answers our blows - the hatch frame has <u><span class='red'>bent</span></u> out of true beneath its shell.", "bold_feedback" = FALSE,
			"repair_method" = "Weld it, then hammer it with a wrench", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder", TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("welding it straight", "wrenching it back into shape"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 90, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 70, "neuro_alt_trigger_chance_pct" = null),
	)

/datum/hardpoint_wound_family/iff_static_interference
	part_slot = HDPT_IFF_MODULE
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Molten Antenna", "marine_feedback_red" = "The IFF antennae have <u><span class='green'>melted</span></u> down to useless slag.",
			"xeno_feedback" = "A thin wisp of smoke curls from a <u><span class='green'>melted</span></u> antenna stub, hidden beneath its shell.", "bold_feedback" = FALSE,
			"repair_method" = "Welding tool", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the antenna back into shape"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 55, "neuro_alt_trigger_chance_pct" = null,
			"iff_disabled" = TRUE),
	)

/datum/hardpoint_wound_family/iff_corrupted_transponder
	part_slot = HDPT_IFF_MODULE
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Cracked Transponder", "marine_feedback_red" = "The transponder's <u><span class='red'>cracked</span></u> casing reports garbled, inconsistent IDs.",
			"xeno_feedback" = "A faint electronic whine leaks from a <u><span class='red'>cracked</span></u> housing, hidden beneath its shell.", "bold_feedback" = FALSE,
			"repair_method" = "Screwdriver, wirecutter, welder", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_SCREWDRIVER, TRAIT_TOOL_WIRECUTTERS, "welder"), "repair_step_verbs" = list("unscrewing the housing", "cutting away the frayed wiring", "welding the transponder casing shut"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 55, "neuro_alt_trigger_chance_pct" = null,
			"iff_disabled" = TRUE),
	)

/datum/hardpoint_wound_family/visual_sensors_obscured
	part_slot = HDPT_VISUAL_SENSORS
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Light Smear", "marine_feedback_red" = "A light smear of <u><span class='green'>acid residue</span></u> streaks the external camera lens.",
			"xeno_feedback" = "The metal beast struggles to aim up far. <u><span class='green'>Acid</span></u> covers its eyes.", "bold_feedback" = FALSE,
			"repair_method" = "Quick wipe with a rag or welding tool", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the smear off"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 8, "max_roll_chance_pct" = 90, "neuro_alt_trigger_chance_pct" = null,
			"vision_impair_add" = 1),
		list("wound_name" = "Heavy Smear", "marine_feedback_red" = "The external camera lens sits smeared thick with <u><span class='green'>acid residue</span></u>, hard to see through.",
			"xeno_feedback" = "Gunks of <u><span class='green'>acid slag</span></u> clog up the metal turtle's eyes.", "bold_feedback" = FALSE,
			"repair_method" = "Longer wipe with a rag or welding tool.", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the smear off thoroughly"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 90, "damage_to_chance_pct" = 6, "max_roll_chance_pct" = 70, "neuro_alt_trigger_chance_pct" = null,
			"vision_impair_add" = 2),
		list("wound_name" = "Fully Obscured", "marine_feedback_red" = "The lens sits caked thick with <u><span class='green'>acid slag</span></u>. It obstructs your vision almost entirely.",
			"xeno_feedback" = "A buildup of <u><span class='green'>acid slag</span></u> completely covers its lenses. It is effectively blind!", "bold_feedback" = TRUE,
			"repair_method" = "Unmount. Remove caked chunks with a crowbar. Reverts to stage 2 where it can be cleaned with a rag/welding tool", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR), "repair_step_verbs" = list("prying the caked chunks free"), "repair_reverts_to_tier" = 2,
			"min_health_threshold_pct" = 85, "damage_to_chance_pct" = 4, "max_roll_chance_pct" = 50, "neuro_alt_trigger_chance_pct" = null,
			"vision_impair_add" = 4),
	)

/// Neurotoxin's parallel to visual_sensors_obscured. Both can be active at once.
/datum/hardpoint_wound_family/visual_sensors_gunked
	part_slot = HDPT_VISUAL_SENSORS
	damage_type = WOUND_DAMTYPE_ACID
	neuro_alt_trigger_only = TRUE
	tiers = list(
		list("wound_name" = "Light Gunk", "marine_feedback_red" = "A tacky film of <u><font color='#E8C547'>neurotoxin residue</font></u> streaks the external camera lens.",
			"xeno_feedback" = "The metal beast struggles to aim up far. Sticky <u><font color='#E8C547'>neurotoxin</font></u> clings to its eyes.", "bold_feedback" = FALSE,
			"repair_method" = "Quick wipe with a rag or welding tool", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the gunk off"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 8, "max_roll_chance_pct" = 90, "neuro_alt_trigger_chance_pct" = 40,
			"vision_impair_add" = 1),
		list("wound_name" = "Heavy Gunk", "marine_feedback_red" = "The external camera lens sits thickly gummed with <u><font color='#E8C547'>neurotoxin residue</font></u>, hard to see through.",
			"xeno_feedback" = "Globs of sticky <u><font color='#E8C547'>neurotoxin</font></u> residue clog up the metal turtle's eyes.", "bold_feedback" = FALSE,
			"repair_method" = "Longer wipe with a rag or welding tool.", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the gunk off thoroughly"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 90, "damage_to_chance_pct" = 6, "max_roll_chance_pct" = 70, "neuro_alt_trigger_chance_pct" = 24,
			"vision_impair_add" = 2),
		list("wound_name" = "Fully Gunked", "marine_feedback_red" = "The lens sits sealed thick with hardened <u><font color='#E8C547'>neurotoxin residue</font></u>. You can barely make out shapes through it.",
			"xeno_feedback" = "A web of hardened <u><font color='#E8C547'>neurotoxin residue</font></u> completely seals its lenses shut. It is effectively blind!", "bold_feedback" = TRUE,
			"repair_method" = "Unmount. Remove caked chunks with a crowbar. Reverts to stage 2 where it can be cleaned with a rag/welding tool", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_CROWBAR), "repair_step_verbs" = list("prying the caked chunks free"), "repair_reverts_to_tier" = 2,
			"min_health_threshold_pct" = 85, "damage_to_chance_pct" = 4, "max_roll_chance_pct" = 50, "neuro_alt_trigger_chance_pct" = 12,
			"vision_impair_add" = 4),
	)

/datum/hardpoint_wound_family/visual_sensors_cracked_lens
	part_slot = HDPT_VISUAL_SENSORS
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Scratched Lens", "marine_feedback_red" = "Small <u><span class='red'>scratches</span></u> runs across the surface of the lenses.",
			"xeno_feedback" = "Its eyes have gained <u><span class='red'>scars</span></u> from our repeated strikes.", "bold_feedback" = FALSE,
			"repair_method" = "Welder", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the crack shut"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 90, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null,
			"vision_impair_add" = 1),
		list("wound_name" = "Cracked Lens", "marine_feedback_red" = "The camera lensses have been <u><span class='red'>cracked</span></u>, and will require a replacement.",
			"xeno_feedback" = "Its camera lenses lie <u><span class='red'>shattered</span></u>. It struggles to see!", "bold_feedback" = TRUE,
			"repair_method" = "Replace the lenses with 5 units of glass.", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(list("material", /obj/item/stack/sheet/glass, 5)), "repair_step_verbs" = list("fitting the new glass lenses"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = null,
			"vision_impair_add" = 2),
	)

/datum/hardpoint_wound_family/air_filter_clogged
	part_slot = HDPT_AIR_FILTER
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Dusty Filter", "marine_feedback_red" = "A light layer of <u><span class='green'>acid dust</span></u> coats the air filter cartridge.",
			"xeno_feedback" = "<u><span class='green'>Acid globs</span></u> are drawn in through the filter with every breath it takes.", "bold_feedback" = FALSE,
			"repair_method" = "Unmount and dust off the filter by using it in hand", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("dusting off the filter"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null),
		list("wound_name" = "Clogged Filter", "marine_feedback_red" = "The air filter cartridge sits visibly caked with <u><span class='green'>acid particulate</span></u>.",
			"xeno_feedback" = "<u><span class='green'>Acid</span></u> pours freely in through the clogged, ruined air filter!", "bold_feedback" = TRUE,
			"repair_method" = "Unmount and apply welding tool to the filter to burn the residue off", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the residue away"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = null),
	)

/// Neurotoxin's parallel to air_filter_clogged. No severity to halve, only trigger chance doubled.
/datum/hardpoint_wound_family/air_filter_gunked
	part_slot = HDPT_AIR_FILTER
	damage_type = WOUND_DAMTYPE_ACID
	neuro_alt_trigger_only = TRUE
	tiers = list(
		list("wound_name" = "Tacky Filter", "marine_feedback_red" = "A light, tacky film of <u><font color='#E8C547'>neurotoxin residue</font></u> coats the air filter cartridge.",
			"xeno_feedback" = "Sticky <u><font color='#E8C547'>neurotoxin</font></u> globs are drawn in through the filter with every breath it takes.", "bold_feedback" = FALSE,
			"repair_method" = "Unmount and dust off the filter by using it in hand", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("dusting off the filter"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = 30),
		list("wound_name" = "Gunked Filter", "marine_feedback_red" = "The air filter cartridge sits visibly webbed with hardened <u><font color='#E8C547'>neurotoxin residue</font></u>.",
			"xeno_feedback" = "Thick, sticky <u><font color='#E8C547'>neurotoxin residue</font></u> pours in through the gunked-up air filter!", "bold_feedback" = TRUE,
			"repair_method" = "Unmount and apply welding tool to the filter to burn the residue off", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list("welder"), "repair_step_verbs" = list("welding the residue away"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 55, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 45, "neuro_alt_trigger_chance_pct" = 16),
	)

/datum/hardpoint_wound_family/air_filter_cracked_housing
	part_slot = HDPT_AIR_FILTER
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Hairline Crack", "marine_feedback_red" = "A hairline <u><span class='red'>crack</span></u> runs along the filter housing seam.",
			"xeno_feedback" = "A <u><span class='red'>cracked</span></u> seam lets acid and neurotoxin globs alike seep into the fighting compartment.", "bold_feedback" = FALSE,
			"repair_method" = "Unmount and apply wrench to the filter.", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list(TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("wrenching the housing back together"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 75, "neuro_alt_trigger_chance_pct" = null),
		list("wound_name" = "Cracked Housing", "marine_feedback_red" = "The filter housing sits <u><span class='red'>cracked</span></u> wide open at the seam.",
			"xeno_feedback" = "The air filter hangs <u><span class='red'>shattered</span></u>. Acid and neurotoxic smoke pour freely in through the gaps!", "bold_feedback" = TRUE,
			"repair_method" = "Unmount, weld, wrench.", "repair_skill" = "Any Marine", "unmount_required" = TRUE,
			"repair_steps" = list("welder", TRAIT_TOOL_WRENCH), "repair_step_verbs" = list("welding the crack shut", "wrenching the housing tight"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 40, "damage_to_chance_pct" = 3, "max_roll_chance_pct" = 40, "neuro_alt_trigger_chance_pct" = null),
	)

/**
 * Shared by every Support-slot module. A single tier that just sets module_disabled = TRUE, which
 * is_functional() reads to gate whether the module's own effect is currently active.
 */
/datum/hardpoint_wound_family/support_module_disabled
	part_slot = HDPT_SUPPORT
	damage_type = WOUND_DAMTYPE_UNIFIED
	tiers = list(
		list("wound_name" = "Malfunctioning", "marine_feedback_red" = "Something inside the module sparks and seizes - it's gone completely dead.",
			"xeno_feedback" = "A sharp crackle bursts from the small metal box. It has gone dark and still.", "bold_feedback" = TRUE,
			"repair_method" = "Wrench the housing back into place, then weld the internals shut.", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WRENCH, "welder"), "repair_step_verbs" = list("wrenching the housing back into place", "welding the internals shut"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 80, "damage_to_chance_pct" = 5, "max_roll_chance_pct" = 70, "neuro_alt_trigger_chance_pct" = null,
			"module_disabled" = TRUE),
	)

/**
 * Physical tearing of the mounted UA flag's fabric. Keyed under HDPT_UA_FLAG, not
 * HDPT_SECONDARY, so its wounds reference the banner itself.
 *
 * aura_reduction_add scales with tier and stacks additively with other active wounds.
 */
/datum/hardpoint_wound_family/flag_ripped_fabric
	part_slot = HDPT_UA_FLAG
	damage_type = WOUND_DAMTYPE_BRUTE
	tiers = list(
		list("wound_name" = "Torn Seam", "marine_feedback_red" = "A seam along the flag's edge has <u><span class='red'>torn</span></u> loose, fluttering free.",
			"xeno_feedback" = "The banner hangs <u><span class='red'>torn</span></u> at its edge, snapping weakly.", "bold_feedback" = FALSE,
			"repair_method" = "Wirecutters - snip the frayed threads and stitch the tear shut", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WIRECUTTERS), "repair_step_verbs" = list("cutting away the frayed threads and stitching the tear shut"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 8, "max_roll_chance_pct" = 90, "neuro_alt_trigger_chance_pct" = null,
			"aura_reduction_add" = 1),
		list("wound_name" = "Ragged Tear", "marine_feedback_red" = "A ragged <u><span class='red'>tear</span></u> runs halfway across the flag's face.",
			"xeno_feedback" = "The banner flaps in <u><span class='red'>torn</span></u> ribbons, half-shredded.", "bold_feedback" = FALSE,
			"repair_method" = "Wirecutters - snip the frayed threads and stitch the tear shut", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WIRECUTTERS), "repair_step_verbs" = list("cutting away the frayed threads and stitching the tear shut"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 90, "damage_to_chance_pct" = 6, "max_roll_chance_pct" = 70, "neuro_alt_trigger_chance_pct" = null,
			"aura_reduction_add" = 2),
		list("wound_name" = "Shredded Banner", "marine_feedback_red" = "The flag hangs in <u><span class='red'>shredded</span></u> tatters, barely recognizable.",
			"xeno_feedback" = "Only <u><span class='red'>shredded</span></u> scraps of the banner remain, snapping uselessly.", "bold_feedback" = TRUE,
			"repair_method" = "Wirecutters - snip the frayed threads and stitch the tear shut", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WIRECUTTERS), "repair_step_verbs" = list("cutting away the frayed threads and stitching the tear shut"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 85, "damage_to_chance_pct" = 4, "max_roll_chance_pct" = 50, "neuro_alt_trigger_chance_pct" = null,
			"aura_reduction_add" = 3),
	)

/// Chemical/acid damage to the flag's fabric. Mirrors flag_ripped_fabric, just Acid-typed.
/datum/hardpoint_wound_family/flag_melted_fabric
	part_slot = HDPT_UA_FLAG
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Scorched Threads", "marine_feedback_red" = "A patch of <u><span class='green'>acid</span></u> has scorched and stiffened the fabric.",
			"xeno_feedback" = "<u><span class='green'>Acid</span></u> has scorched a stiff, blackened patch into the banner.", "bold_feedback" = FALSE,
			"repair_method" = "Wirecutters - snip away the scorched fabric and patch it over", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WIRECUTTERS), "repair_step_verbs" = list("cutting away the scorched fabric and patching it over"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 8, "max_roll_chance_pct" = 90, "neuro_alt_trigger_chance_pct" = null,
			"aura_reduction_add" = 1),
		list("wound_name" = "Melted Patch", "marine_feedback_red" = "<u><span class='green'>Acid</span></u> has melted clean through a section of the flag.",
			"xeno_feedback" = "A section of the banner has <u><span class='green'>melted</span></u> away into a dripping, ragged hole.", "bold_feedback" = FALSE,
			"repair_method" = "Wirecutters - snip away the scorched fabric and patch it over", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WIRECUTTERS), "repair_step_verbs" = list("cutting away the scorched fabric and patching it over"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 90, "damage_to_chance_pct" = 6, "max_roll_chance_pct" = 70, "neuro_alt_trigger_chance_pct" = null,
			"aura_reduction_add" = 2),
		list("wound_name" = "Dissolving Fabric", "marine_feedback_red" = "The flag's <u><span class='green'>acid-eaten</span></u> fabric is actively dissolving, more hole than banner.",
			"xeno_feedback" = "<u><span class='green'>Acid</span></u> has all but dissolved the banner into dripping scraps.", "bold_feedback" = TRUE,
			"repair_method" = "Wirecutters - snip away the scorched fabric and patch it over", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WIRECUTTERS), "repair_step_verbs" = list("cutting away the scorched fabric and patching it over"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 85, "damage_to_chance_pct" = 4, "max_roll_chance_pct" = 50, "neuro_alt_trigger_chance_pct" = null,
			"aura_reduction_add" = 3),
	)

/// Neurotoxin's parallel to flag_melted_fabric. Both can be active at once.
/datum/hardpoint_wound_family/flag_neurotoxin_stained
	part_slot = HDPT_UA_FLAG
	damage_type = WOUND_DAMTYPE_ACID
	tiers = list(
		list("wound_name" = "Faint Stain", "marine_feedback_red" = "A faint <u><font color='#E8C547'>neurotoxin</font></u> stain discolors part of the flag.",
			"xeno_feedback" = "A faint <u><font color='#E8C547'>neurotoxin</font></u> residue clings to the banner's fabric.", "bold_feedback" = FALSE,
			"repair_method" = "Wirecutters - snip away the stained fabric and patch it over", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WIRECUTTERS), "repair_step_verbs" = list("cutting away the stained fabric and patching it over"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 95, "damage_to_chance_pct" = 8, "max_roll_chance_pct" = 90, "neuro_alt_trigger_chance_pct" = 40,
			"aura_reduction_add" = 1),
		list("wound_name" = "Spreading Stain", "marine_feedback_red" = "A spreading <u><font color='#E8C547'>neurotoxin</font></u> stain has soaked deep into the fabric.",
			"xeno_feedback" = "<u><font color='#E8C547'>Neurotoxin</font></u> residue has soaked deep into the banner, spreading further.", "bold_feedback" = FALSE,
			"repair_method" = "Wirecutters - snip away the stained fabric and patch it over", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WIRECUTTERS), "repair_step_verbs" = list("cutting away the stained fabric and patching it over"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 90, "damage_to_chance_pct" = 6, "max_roll_chance_pct" = 70, "neuro_alt_trigger_chance_pct" = 24,
			"aura_reduction_add" = 2),
		list("wound_name" = "Saturated Fabric", "marine_feedback_red" = "The flag's fabric is fully <u><font color='#E8C547'>neurotoxin</font></u>-saturated, stiff and reeking.",
			"xeno_feedback" = "<u><font color='#E8C547'>Neurotoxin</font></u> has fully saturated the banner's fabric, stiff and foul.", "bold_feedback" = TRUE,
			"repair_method" = "Wirecutters - snip away the stained fabric and patch it over", "repair_skill" = "Any Marine", "unmount_required" = FALSE,
			"repair_steps" = list(TRAIT_TOOL_WIRECUTTERS), "repair_step_verbs" = list("cutting away the stained fabric and patching it over"), "repair_reverts_to_tier" = null,
			"min_health_threshold_pct" = 85, "damage_to_chance_pct" = 4, "max_roll_chance_pct" = 50, "neuro_alt_trigger_chance_pct" = 12,
			"aura_reduction_add" = 3),
	)

/// part_slot -> list of every wound family instance for that slot.
GLOBAL_LIST_INIT(hardpoint_wound_families_by_slot, build_hardpoint_wound_family_index())

/// Family type path -> the singleton instance, for O(1) reverse lookup.
GLOBAL_LIST_INIT(hardpoint_wound_families_by_type, build_hardpoint_wound_family_type_index())

/// Instantiates every wound family subtype once and groups the instances by part_slot.
/proc/build_hardpoint_wound_family_index()
	. = list()
	for(var/family_type in subtypesof(/datum/hardpoint_wound_family))
		var/datum/hardpoint_wound_family/family = new family_type()
		var/list/slot_families = LAZYACCESS(., family.part_slot)
		if(!slot_families)
			slot_families = list()
			.[family.part_slot] = slot_families
		slot_families += family

/// Flattens GLOB.hardpoint_wound_families_by_slot into a type path -> instance map.
/proc/build_hardpoint_wound_family_type_index()
	. = list()
	for(var/part_slot in GLOB.hardpoint_wound_families_by_slot)
		for(var/datum/hardpoint_wound_family/family in GLOB.hardpoint_wound_families_by_slot[part_slot])
			.[family.type] = family
