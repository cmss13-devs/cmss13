#define CALLBACK new /datum/callback
#define DYNAMIC new /datum/callback/dynamic
#define INVOKE_ASYNC ImmediateInvokeAsync
#define INVOKE_NEXT_TICK(arguments...) addtimer(CALLBACK(##arguments), 1)

#define TRUE_CALLBACK CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_callback_true))
#define FALSE_CALLBACK CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_callback_false))

// I have no idea what this is and it's terrifying. used for spartan slop
///Per the DM reference, spawn(-1) will execute the spawned code immediately until a block is met.
#define MAKE_SPAWN_ACT_LIKE_WAITFOR -1
///Create a codeblock that will not block the callstack if a block is met.
#define ASYNC spawn(MAKE_SPAWN_ACT_LIKE_WAITFOR)
