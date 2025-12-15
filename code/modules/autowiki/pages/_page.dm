/// A representation of an automated wiki page.
/datum/autowiki
	/// The page on the wiki to be replaced.
	/// This should never be a user-facing page, like "Guide to circuits".
	/// It should always be a template that only Autowiki should touch.
	/// For example: "Template:Autowiki/CircuitInfo".
	var/page

	/// If the generation of this autowiki should call /generate_multiple(),
	/// which should return a list of list(title = "Page Title", contents)
	/// allowing for the generation of multiple pages in the same autowiki
	var/generate_multiple = FALSE

/// Override and return the new text of the page.
/// This proc can be impure, usually to call `upload_file`.
/datum/autowiki/proc/generate()
	SHOULD_CALL_PARENT(FALSE)
	CRASH("[type] does not implement generate()!")

/datum/autowiki/proc/generate_multiple()
	SHOULD_CALL_PARENT(FALSE)

/// Generates an auto formatted template user.
/// Your autowiki should ideally be a *lot* of these.
/// It lets wiki editors edit it much easier later, without having to enter repo.
/// Parameters will be passed in by name. That means your template should expect
/// something that looks like `{{ Autowiki_Circuit|name=Combiner|description=This combines }}`
/// Lists, which must be array-like (no keys), will be turned into a flat list with their key and a number,
/// such that list("food" = list("fruit", "candy")) -> food1=fruit|food2=candy
/// Your page should respect AUTOWIKI_SKIP, and check for this using IS_AUTOWIKI_SKIP
/datum/autowiki/proc/include_template(name, parameters)
	var/template_text = "{{[name]"

	var/list/prepared_parameters = list()
	for (var/key in parameters)
		var/value = parameters[key]
		if (islist(value))
			for (var/index in 1 to length(value))
				prepared_parameters["[key][index]"] = "[value[index]]"
		else
			prepared_parameters[key] = value

	for (var/parameter_name in prepared_parameters)
		template_text += "|[parameter_name]="
		template_text += "[prepared_parameters[parameter_name]]"

	template_text += "}}"

	return template_text

/// Takes an icon and uploads it to Autowiki-name.png.
/// Do your best to make sure this is unique, so it doesn't clash with other autowiki icons.
/// Specifying a center_width and center_height when centering (default) can pad/contrain the icon.
/datum/autowiki/proc/upload_icon(icon/icon, name, center=TRUE, center_width, center_height)
	// Fuck you
	if (IsAdminAdvancedProcCall())
		return

	if (center)
		center_icon(icon, center_width, center_height)

	fcopy(icon, "data/autowiki_files/[name].png")

/// Escape a parameter such that it can be correctly put inside a wiki output
/datum/autowiki/proc/escape_value(parameter)
	// | is a special character in MediaWiki, and must be escaped by...using another template.
	return replacetextEx(parameter, "|", "{{!}}")
