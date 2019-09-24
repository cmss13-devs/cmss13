/*
	Custom runtime handling

	Right now, only used to run a script that posts the runtimes to gitlab
*/

/world/Error(var/exception/E)
	..()

	// Ensure that all the information is wrapped properly as separate arguments
	var/name = replacetext(E.name, "\"", "\\\"")
	var/file = replacetext(E.file, "\"", "\\\"")
	var/line = replacetext("[E.line]", "\"", "\\\"")

	var/desc = replacetext(E.desc, "\"", "\\\"")
	// This is converted back into a newline by the script
	desc = replacetext(desc, "\n", ";")

	var/command = "handle_runtime.bat \"[name]\" \"[file]\" \"[line]\" \"[desc]\""
	shell(command)
