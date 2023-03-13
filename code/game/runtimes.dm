/*
	Custom runtime handling
*/

// Early errors handling:
//  for all these cases were errors might occur before code/logging is ready, we stash them away
//  can't trust initializers here so default/values must be handled at runtime
GLOBAL_REAL(static_init_runtimes, /list) //! Errors text encountered during static init.
GLOBAL_REAL(early_init_runtimes, /list) //! Errors text encountered during early runtime init.
GLOBAL_REAL_VAR(init_runtimes_stage) //! Init stage: null/0=static init, 1=early runtime init, 2=regular logging is ready

// Deduplication of errors via hash to reduce spamming
GLOBAL_REAL(runtime_hashes, /list)
GLOBAL_VAR_INIT(total_runtimes, GLOB.total_runtimes || 0)
GLOBAL_VAR_INIT(total_runtimes_skipped, 0)

/world/Error(exception/E)
	GLOB.total_runtimes++

	..()
	if(!runtime_hashes)
		runtime_hashes = list()
	if(!init_runtimes_stage)
		init_runtimes_stage = 0
	if(init_runtimes_stage < 2)
		if(!static_init_runtimes)
			static_init_runtimes = list()
		if(!early_init_runtimes)
			early_init_runtimes = list()

	// Runtime was already reported once
	var/hash = md5("[E.name]@[E.file]@[E.line]")
	if(hash in runtime_hashes)
		runtime_hashes[hash]++
		// Repeat runtimes aren't logged every time
		if(!(runtime_hashes[hash] % 100))
			var/text = "\[[time_stamp()]]RUNTIME: [E.name] - [E.file]@[E.line] ([runtime_hashes[hash]] total)"
			switch(init_runtimes_stage)
				if(0)
					static_init_runtimes.Add(text)
				if(1)
					early_init_runtimes.Add(text)
				else
					GLOB.STUI.runtime.Add(text)
		return
	runtime_hashes[hash] = 1

	// Log it
	var/text = "\[[time_stamp()]]RUNTIME: [E.name] - [E.file]@[E.line]"
	switch(init_runtimes_stage)
		if(0)
			static_init_runtimes.Add(text)
		if(1)
			early_init_runtimes.Add(text)
		else
			GLOB.STUI.runtime.Add(text)
	if(GLOB?.STUI?.runtime)
		GLOB.STUI.processing |= STUI_LOG_RUNTIME
