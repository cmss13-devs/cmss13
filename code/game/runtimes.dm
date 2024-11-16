/*
	Custom runtime handling
*/

// Early errors handling:
//  For all these cases were errors might occur before logging/debugguer is ready, we stash them away
//  Can't trust static initializers here so default/values must be handled at runtime
//  Do NOT convert these to GLOB because errors can happen BEFORE GLOB exists,
//  which would cause /world/Error handler to also crash and make them all silent!

GLOBAL_REAL(stui_init_runtimes, /list) //! Shorthand of Static Initializer errors only, for use in STUI
GLOBAL_REAL(full_init_runtimes, /list) //! Full text of all Static Initializer + World Init errors, for log backfilling
GLOBAL_REAL_VAR(runtime_logging_ready) //! Truthy when init is done and we don't need these shenanigans anymore

// Deduplication of errors via hash to reduce spamming
GLOBAL_REAL(runtime_hashes, /list)
GLOBAL_REAL_VAR(total_runtimes)

/world/Error(exception/E)
	..()
	if(!runtime_hashes)
		runtime_hashes = list()
	if(!total_runtimes)
		total_runtimes = 0
	total_runtimes += 1
	if(!stui_init_runtimes)
		stui_init_runtimes = list()
	if(!full_init_runtimes)
		full_init_runtimes = list()

	// If this occurred during early init, we store the full error to write it to world.log when it's available
	if(!runtime_logging_ready)
		full_init_runtimes += E.desc

	// Runtime was already reported once, dedup it for STUI
	var/hash = md5("[E.name]@[E.file]@[E.line]")
	if(hash in runtime_hashes)
		runtime_hashes[hash]++
		// Repeat runtimes aren't logged every time
		if(!(runtime_hashes[hash] % 100))
			var/text = "\[[time_stamp()]]RUNTIME: [E.name] - [E.file]@[E.line] ([runtime_hashes[hash]] total)"
			if(GLOB?.STUI?.runtime)
				GLOB.STUI.runtime.Add(text)
				GLOB.STUI.processing |= STUI_LOG_RUNTIME
			else
				stui_init_runtimes.Add(text)
		return
	runtime_hashes[hash] = 1

	// Single error logging to STUI
	var/text = "\[[time_stamp()]]RUNTIME: [E.name] - [E.file]@[E.line]"
	if(GLOB?.STUI?.runtime)
		GLOB.STUI.runtime.Add(text)
		GLOB.STUI.processing |= STUI_LOG_RUNTIME
	else
		stui_init_runtimes.Add(text)

	log_runtime("runtime error: [E.name]\n[E.desc]")
