/datum/autowiki/xeno_stats
	generate_multiple = TRUE
	page = "Template:Autowiki/Content/XenoStats"

/datum/autowiki/xeno_stats/generate_multiple()
	var/output = list()

	for(var/mob/living/carbon/xenomorph/xeno as anything in subtypesof(/mob/living/carbon/xenomorph))
		if(IS_AUTOWIKI_SKIP(xeno))
			continue

		var/mob/living/carbon/xenomorph/xeno_instance = new xeno()

		var/strains = list(null) + xeno_instance.caste.available_strains
		for(var/datum/xeno_strain/strain as anything in strains)
			var/datum/xeno_strain/strain_instance = null
			if(!isnull(strain))
				strain_instance = new strain()

			output += template_from_xeno(xeno_instance, strain_instance)

			qdel(strain_instance)

		qdel(xeno_instance)

	return output

/datum/autowiki/xeno_stats/proc/template_from_xeno(mob/living/carbon/xenomorph/xeno, datum/xeno_strain/strain)
	var/name = xeno.caste_type
	if(!isnull(strain))
		strain.apply_strain(xeno)
		name = "[strain.name] [name]"

	var/xeno_data = list(
		"name" = name,
		"health" = xeno.maxHealth,
		"armor" = xeno.armor_deflection,
		"plasma" = xeno.plasma_max,
		"plasma_regeneration" = xeno.plasma_gain,
		"minimum_slash_damage" = xeno.melee_damage_lower,
		"maximum_slash_damage" = xeno.melee_damage_upper,
		"claw_strength" = xeno.claw_type,
		"evasion" = xeno.evasion,
		// Mob speed is relatively non-obvious, we we convert it into a very intuitive
		// range for wiki-readability.
		"speed" = humanize_speed(xeno.speed),
		"explosion_resistance" = xeno.caste.xeno_explosion_resistance,
	)

	var/sanitized_name = url_encode(replacetext(name, " ", "_"))
	return list(list(title = "Template:Autowiki/Content/XenoStats/[sanitized_name]", text = include_template("Autowiki/XenoStats", xeno_data)))

/datum/autowiki/xeno_stats/proc/humanize_speed(speed)
	return speed * -1 + 1
