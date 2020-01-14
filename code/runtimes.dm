/*
	Custom runtime handling

	Right now, only used to run a script that posts the runtimes to gitlab
*/

var/global/report_runtimes = FALSE
// Used to store hashes for runtimes that've occured. Runtimes will not be reported twice
var/global/runtime_hashes = list()

/hook/startup/proc/loadRuntimeConfig()
	var/list/lines = file2list("config/runtime_reports.txt")

	if(!lines || !length(lines))
		return 1

	for(var/line in lines)
		// Ignore empty lines
		if(!length(line))
			continue
		// Ignore comment lines
		if(copytext(line,1,2) == "#")
			continue

		// Get the config option
		var/list/config = splittext(line, " ")
		if(!config || length(config) < 2)
			continue

		if(config[1] == "report_runtimes")
			report_runtimes = config[2] == "1" ? TRUE : FALSE

	return 1

/world/Error(var/exception/E)
	..()

	// Runtime was already reported once
	var/hash = md5("[E.name]@[E.file]@[E.line]")
	if(hash in runtime_hashes)
		runtime_hashes[hash] += 1
		// Repeat runtimes aren't logged every time
		if(!(runtime_hashes[hash] % 100))
			STUI.runtime.Add("\[[time_stamp()]]RUNTIME: [E.name] - [E.file]@[E.line] ([runtime_hashes[hash]] total)<br>")
		return
	runtime_hashes[hash] = 1

	// Log it in STUI
	STUI.runtime.Add("\[[time_stamp()]]RUNTIME: [E.name] - [E.file]@[E.line]<br>")
	STUI.processing |= STUI_LOG_RUNTIME

	// Report the runtime on gitlab if the script is enabled
	if(!report_runtimes)
		return

	// Ensure that all the information is wrapped properly as separate arguments
	var/name = replacetext(E.name, "\"", "\\\"")
	var/file = replacetext(E.file, "\"", "\\\"")
	var/line = replacetext("[E.line]", "\"", "\\\"")

	var/desc = replacetext(E.desc, "\"", "\\\"")
	// This is converted back into a newline by the script
	desc = replacetext(desc, "\n", ";")

	var/command = "handle_runtime.bat \"[name]\" \"[file]\" \"[line]\" \"[desc]\""
	shell(command)
