#define CALLBACK new /datum/callback
#define DYNAMIC new /datum/callback/dynamic
#define INVOKE_ASYNC ImmediateInvokeAsync

#define TRUE_CALLBACK CALLBACK(GLOBAL_PROC, PROC_REF(_callback_true))
#define FALSE_CALLBACK CALLBACK(GLOBAL_PROC, PROC_REF(_callback_false))

/// like CALLBACK but specifically for verb callbacks
#define VERB_CALLBACK new /datum/callback/verb_callback
