// llcm.dm - DM API for llcm extension library
//
// To configure, create a `llcm.config.dm` and set what you care about from
// the following options:
//
// #define LLCM "path/to/llcm"
// Override the .dll/.so detection logic with a fixed path or with detection
// logic of your own.
//
// #define LLCM_OVERRIDE_BUILTINS
// Enable replacement rust-g functions for certain builtins. Off by default.

#ifndef LLCM
// Default automatic LLCM detection.
// On Windows, looks in the standard places for `llcm.dll`.
// On Linux, looks in `.`, `$LD_LIBRARY_PATH`, and `~/.byond/bin` for either of
// `libllcm.so` (preferred) or `llcm` (old).

/* This comment bypasses grep checks */ /var/__llcm

/proc/__detect_llcm()
	var/arch_suffix = null
	#ifdef OPENDREAM
	arch_suffix = "64"
	#endif
	if (world.system_type == UNIX)
		if (fexists("./libllcm[arch_suffix].so"))
			// No need for LD_LIBRARY_PATH badness.
			return __llcm = "./libllcm[arch_suffix].so"
		else if (fexists("./llcm[arch_suffix]"))
			// Old dumb filename.
			return __llcm = "./llcm[arch_suffix]"
		else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/llcm[arch_suffix]"))
			// Old dumb filename in `~/.byond/bin`.
			return __llcm = "llcm[arch_suffix]"
		else
			// It's not in the current directory, so try others
			return __llcm = "libllcm[arch_suffix].so"
	else
		return __llcm = "llcm[arch_suffix]"

#define LLCM (__llcm || __detect_llcm())
#endif

// Handle 515 call() -> call_ext() changes
#if DM_VERSION >= 515
#define LLCM_CALL call_ext
#else
#define LLCM_CALL call
#endif

/// Gets the version of llcm
/proc/llcm_get_version() return LLCM_CALL(LLCM, "get_version")()
