/// When the `AUTOWIKI` define is enabled, will generate an output file for tools/autowiki/autowiki.js to consume.
/// Autowiki code intentionally still *exists* even without the define, to ensure developers notice
/// when they break it immediately, rather than until CI or worse, call time.
#if defined(AUTOWIKI) || defined(UNIT_TESTS)
/proc/setup_autowiki()
	Master.sleep_offline_after_initializations = FALSE
	UNTIL(SSticker.current_state == GAME_STATE_PREGAME)

	//trigger things to run the whole process
	SSticker.request_start()
	CONFIG_SET(number/round_end_countdown, 0)
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(generate_autowiki)))

/proc/generate_autowiki()
	var/output = generate_autowiki_output()
	rustg_file_write(output, "data/autowiki_edits.txt")
	qdel(world)
#endif

/// Returns a string of the autowiki output file
/proc/generate_autowiki_output()
	var/total_output = ""

	for (var/datum/autowiki/autowiki_type as anything in subtypesof(/datum/autowiki))
		var/datum/autowiki/autowiki = new autowiki_type

		if(autowiki.generate_multiple)
			var/output = autowiki.generate_multiple()

			if (!islist(output))
				CRASH("[autowiki_type] does not generate a proper output when generate_multiple is set!")

			for(var/list in output)
				total_output += json_encode(list) + "\n"

			if(!autowiki.page)
				continue

			var/list/all_page_names = list()
			for(var/list in output)
				all_page_names += autowiki.include_template(list["title"])

			total_output += json_encode(list("title" = autowiki.page, "text" = all_page_names.Join(" "))) + "\n"
			continue

		var/output = autowiki.generate()

		if (!istext(output))
			CRASH("[autowiki_type] does not generate a proper output!")

		total_output += json_encode(list(
			"title" = autowiki.page,
			"text" = output,
		)) + "\n"

	return total_output
