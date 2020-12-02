/*
	Custom runtime handling

	Right now, only used to run a script that posts the runtimes to gitlab
*/

// Used to store hashes for runtimes that've occured. Runtimes will not be reported twice
var/global/runtime_hashes = list()

/world/Error(var/exception/E)
	..()

	// Runtime was already reported once
	var/hash = md5("[E.name]@[E.file]@[E.line]")
	if(hash in runtime_hashes)
		runtime_hashes[hash] += 1
		// Repeat runtimes aren't logged every time
		if(!(runtime_hashes[hash] % 100))
			GLOB.STUI.runtime.Add("\[[time_stamp()]]RUNTIME: [E.name] - [E.file]@[E.line] ([runtime_hashes[hash]] total)<br>")
		return
	runtime_hashes[hash] = 1

	// Log it in STUI
	GLOB.STUI.runtime.Add("\[[time_stamp()]]RUNTIME: [E.name] - [E.file]@[E.line]<br>")
	GLOB.STUI.processing |= STUI_LOG_RUNTIME

	// Report the runtime on gitlab if the script is enabled
	if(!CONFIG_GET(flag/report_runtimes))
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
