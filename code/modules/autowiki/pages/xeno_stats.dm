/datum/autowiki/xeno_stats
	generate_multiple = TRUE
	page = "Template:Autowiki/Content/XenoStats"

/datum/autowiki/xeno_stats/generate_multiple()
	var/output = list()

	for(var/datum/caste_datum/caste as anything in subtypesof(/datum/caste_datum))
		if(caste.autowiki_skip)
			continue

		var/xeno_data = list(
			"Name" = caste.caste_type,
			"Health" = caste.max_health,
			"Armor" = caste.armor_deflection,
			"Plasma" = caste.plasma_max,
			"Damage Range" = "[caste.melee_damage_lower]\u2014[caste.melee_damage_upper]",
			"Evasion" = caste.evasion,
			// Speed is relatively unintuitive, so we convert it into a form
			// that makes sense for the wiki.
			"Speed" = caste.speed * -1 + 1,
		)

		var/sanitized_name = url_encode(caste.caste_type)
		var/template = list(title = "Tempalte:AutoWiki/Content/XenoStats/[sanitized_name]", text = include_template("Autowiki/XenoStats", xeno_data))

		output += list(template)

		qdel(caste)

	return output
