/datum/autowiki/xeno_stats
	generate_multiple = TRUE
	page = "Template:Autowiki/Content/XenoStats"

/datum/autowiki/xeno_stats/generate_multiple()
	var/output = list()

	for(var/datum/caste_datum/caste as anything in subtypesof(/datum/caste_datum))
		if(caste.autowiki_skip)
			continue

		output += template_from_xeno(caste)

		qdel(caste)

	return output

/datum/autowiki/xeno_stats/proc/template_from_xeno(datum/caste_datum/caste)
	// Base stats
	var/xeno_data = list(
		"Name" = caste.caste_type,
		"Health" = caste.max_health,
		"Armor" = caste.armor_deflection,
		"Plasma" = caste.plasma_max,
		"Damage Range" = "[caste.melee_damage_lower]\u2014[caste.melee_damage_upper]",
		"Evasion" = caste.evasion,
		// Speed is relatively unintuitive, so we convert it into a form
		// that makes sense for the wiki.
		"Speed" = humanize_speed(caste.speed),
	)

	var/sanitized_name = url_encode(replacetext(caste.caste_type, " ", "_"))
	return list(list(title = "Tempalte:AutoWiki/Content/XenoStats/[sanitized_name]", text = include_template("Autowiki/XenoStats", xeno_data)))

/datum/autowiki/xeno_stats/proc/humanize_speed(speed)
	return speed * -1 + 1
