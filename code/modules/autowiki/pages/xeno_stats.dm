/datum/autowiki/xeno_stats
	generate_multiple = TRUE
	page = "Template:Autowiki/Content/XenoStats"

/datum/autowiki/xeno_stats/generate_multiple()
	var/output = list()

	for(var/mob/living/carbon/xeno as anything in subtypesof(/mob/living/carbon/xenomorph))
		if(IS_AUTOWIKI_SKIP(xeno))
			continue

		var/xeno_instance = new xeno()

		output += template_from_xeno(xeno_instance)

		qdel(xeno)

	return output

/datum/autowiki/xeno_stats/proc/template_from_xeno(mob/living/carbon/xenomorph/xeno)
	// Base stats
	var/xeno_data = list(
		"Name" = xeno.caste_type,
		"Health" = xeno.maxHealth,
		"Armor" = xeno.armor_deflection,
		"Plasma" = xeno.plasma_max,
		"Damage Range" = "[xeno.melee_damage_lower]\u2014[xeno.melee_damage_upper]",
		"Evasion" = xeno.evasion,
		// Speed is relatively unintuitive, so we convert it into a form
		// that makes sense for the wiki.
		"Speed" = humanize_speed(xeno.speed),
	)

	var/sanitized_name = url_encode(replacetext(xeno.caste_type, " ", "_"))
	return list(list(title = "Tempalte:AutoWiki/Content/XenoStats/[sanitized_name]", text = include_template("Autowiki/XenoStats", xeno_data)))

/datum/autowiki/xeno_stats/proc/humanize_speed(speed)
	return speed * -1 + 1
