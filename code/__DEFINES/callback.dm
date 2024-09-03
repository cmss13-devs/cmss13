#define CALLBACK new /datum/callback
#define DYNAMIC new /datum/callback/dynamic
#define INVOKE_ASYNC ImmediateInvokeAsync
#define INVOKE_NEXT_TICK(arguments...) addtimer(CALLBACK(##arguments), 1)

///Per the DM reference, spawn(-1) will execute the spawned code immediately until a block is met.
#define MAKE_SPAWN_ACT_LIKE_WAITFOR -1
///Create a codeblock that will not block the callstack if a block is met.
#define ASYNC spawn(MAKE_SPAWN_ACT_LIKE_WAITFOR)

#define INVOKE_ASYNC_DIRECT(proc_owner, proc_path, proc_arguments...) \
	if ((proc_owner) == GLOBAL_PROC) { \
		ASYNC { \
			call(proc_path)(##proc_arguments); \
		}; \
	} \
	else { \
		ASYNC { \
			/* Written with `0 ||` to avoid the compiler seeing call("string"), and thinking it's a deprecated DLL */ \
			call(0 || proc_owner, proc_path)(##proc_arguments); \
		}; \
	}


#define TRUE_CALLBACK CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_callback_true))
#define FALSE_CALLBACK CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_callback_false))
