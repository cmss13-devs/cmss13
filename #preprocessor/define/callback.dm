#define CALLBACK new /datum/callback 
#define DYNAMIC new /datum/callback/dynamic
#define INVOKE_ASYNC ImmediateInvokeAsync

#define TRUE_CALLBACK CALLBACK(GLOBAL_PROC, .proc/_callback_true)
#define FALSE_CALLBACK CALLBACK(GLOBAL_PROC, .proc/_callback_false)
