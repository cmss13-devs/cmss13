/*
	Custom runtime handling
*/


// /world/Error might be called during early static init, in which case we don't have
// GLOB and STUI facilities yet. Initializer expressions for the following globals may not
// even have been ran yet! In such a case we just log them to globals and let
// MC-init-time SSearlyruntimes pick them up.

GLOBAL_REAL(runtime_hashes, /list)
GLOBAL_REAL(early_init_runtimes, /list)
GLOBAL_REAL_VAR(early_init_runtimes_count)

GLOBAL_VAR_INIT(total_runtimes, GLOB.total_runtimes || 0)
GLOBAL_VAR_INIT(total_runtimes_skipped, 0)

/world/Error(exception/E)
	GLOB.total_runtimes++

	..()
	if(!runtime_hashes)
		runtime_hashes = list()
	if(!early_init_runtimes)
		early_init_runtimes = list()
	if(!early_init_runtimes_count)
		early_init_runtimes_count = 0
	if(!SSearlyruntimes?.initialized)
		early_init_runtimes_count++

	// Runtime was already reported once
	var/hash = md5("[E.name]@[E.file]@[E.line]")
	if(hash in runtime_hashes)
		runtime_hashes[hash]++
		// Repeat runtimes aren't logged every time
		if(!(runtime_hashes[hash] % 100))
			var/text = "\[[time_stamp()]]RUNTIME: [E.name] - [E.file]@[E.line] ([runtime_hashes[hash]] total)"
			if(GLOB?.STUI?.runtime)
				GLOB.STUI.runtime.Add(text)
			else
				early_init_runtimes.Add(text)
		return
	runtime_hashes[hash] = 1

	// Log it
	var/text = "\[[time_stamp()]]RUNTIME: [E.name] - [E.file]@[E.line]"
	if(GLOB?.STUI?.runtime)
		GLOB.STUI.runtime.Add(text)
		GLOB.STUI.processing |= STUI_LOG_RUNTIME
	else
		early_init_runtimes.Add(text)
