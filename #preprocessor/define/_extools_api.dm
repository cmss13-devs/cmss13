#define EXTOOLS			(world.system_type == MS_WINDOWS ? "byond-extools.dll" : "byond-extools")
#define EXTOOLS_SUCCESS	"SUCCESS"
#define EXTOOLS_FAILED	"FAIL"
#define GLOBAL_PROC		"magic BS"

/*
	Core - Provides necessary functionality for other modules.

	Initializing any other modules also initializes this so it shouldn't be necessary to call this.

*/

/proc/extools_initialize()
	return call(EXTOOLS, "core_initialize")() == EXTOOLS_SUCCESS

/*
	TFFI - Threaded FFI

	All DLL calls are automatically threaded off.
	Black magic is used to suspend (sleep) the currently executing proc, allowing non-blocking FFI.

	You may call a DLL function and sleep until it returns, pass a callback to be called with the result,
	or call resolve() on the /datum/promise to receive the return value at any time.

	Example:


	var/x = call_wait("sample.dll", "do_work", "arg1", "arg2", "arg3")

	 - Calls the do_work function from sample.dll with 3 arguments. The proc sleeps until do_work returns.



	var/datum/promise/P = call_async("sample.dll", "do_work", "arg1")
	... do something else ...
	var/result = P.resolve()

	 - Calls do_work with 1 argument. Returns a promise object. Runs some other code before calling P.resolve() to obtain the result.



	/proc/print_result(result)
		world << result

	call_cb("sample.dll", "do_work", /proc/print_result, "arg1", "arg2")

	 - Calls do_work with 2 arguments. The callback is invoked with the result as the single argument. Execution resumes immediately.


*/

/proc/tffi_initialize()
	return call(EXTOOLS, "tffi_initialize")() == EXTOOLS_SUCCESS

/proc/maptick_initialize()
	return call(EXTOOLS, "maptick_initialize")() == EXTOOLS_SUCCESS

/proc/optimizer_initialize()
	return call(EXTOOLS, "optimizer_initialize")() == EXTOOLS_SUCCESS

var/fallback_alerted = FALSE
var/next_promise_id = 0

/datum/promise
	var/completed = FALSE
	var/result = ""
	var/callback_context = GLOBAL_PROC
	var/callback_proc = null
	var/__id = 0

/datum/promise/New()
	__id = next_promise_id++ //please don't create more than 10^38 promises in a single tick

//This proc's bytecode is overwritten to allow suspending and resuming on demand.
//None of the code here should run.
/datum/promise/proc/__internal_resolve(ref, id)
	if(!fallback_alerted && world.system_type != UNIX) // the rewriting is currently broken on Linux.
		world << "<b>TFFI: __internal_resolve has not been rewritten, the TFFI DLL was not loaded correctly.</b>"
		world.log << "<b>TFFI: __internal_resolve has not been rewritten, the TFFI DLL was not loaded correctly.</b>"
		fallback_alerted = TRUE
	while(!completed)
		sleep(1)
		//It might be better to just fail and notify the user that something went wrong.

/datum/promise/proc/__resolve_callback()
	__internal_resolve("\ref[src]", __id)
	if(callback_context == GLOBAL_PROC)
		call(callback_proc)(result)
	else
		call(callback_context, callback_proc)(result)

/datum/promise/proc/resolve()
	__internal_resolve("\ref[src]", __id)
	return result

/proc/call_async()
	RETURN_TYPE(/datum/promise)
	var/list/arguments = args.Copy()
	var/datum/promise/P = new
	arguments.Insert(1, "\ref[P]")
	call(EXTOOLS, "call_async")(arglist(arguments))
	return P

/proc/call_cb()
	var/list/arguments = args.Copy()
	var/context = arguments[3]
	var/callback = arguments[4]
	arguments.Cut(3, 5)
	var/datum/promise/P = new
	P.callback_context = context
	P.callback_proc = callback
	arguments.Insert(1, "\ref[P]")
	call(EXTOOLS, "call_async")(arglist(arguments))
	spawn(0)
		P.__resolve_callback()

/proc/call_wait()
	return call_async(arglist(args)).resolve()
	
/*
	Extended Profiling - High precision in-depth performance profiling.
	
	Turning on extended profiling for a proc will cause each execution of it to generate a file in the ./profiles directory
	containing a breakdown of time spent executing the proc and each sub-proc it calls. Import the file into https://www.speedscope.app/ to
	view a good visual representation.
	
	Be aware that sleeping counts as stopping and restarting the execution of the proc, which will generate multiple files, one between each sleep.
	
	For large procs the profiles may become unusably large. Optimizations pending.
	
	Example:
		
		start_profiling(/datum/explosion/New)
		
		- Enables profiling for /datum/explosion/New(), which will produce a detailed breakdown of each explosion that occurs afterwards.
		
		stop_profiling(/datum/explosion/New)
		
		- Disables profiling for explosions. Any currently running profiles will stop when the proc finishes executing or enters a sleep.
		
*/

/proc/profiling_initialize()
	return call(EXTOOLS, "extended_profiling_initialize")() == EXTOOLS_SUCCESS

/proc/start_profiling(procpath)
	call(EXTOOLS, "enable_extended_profiling")("[procpath]")
	
/proc/stop_profiling(procpath)
	call(EXTOOLS, "disable_extended_profiling")("[procpath]")
	
/*

	Debug Server - High and low level debugging of DM code.
	
	Calling debugger_initialize will start a debug server that allows connections from frontends,
	such as SpaceManiac's VSCode extension for line-by-line debugging (and more), or Steamport's
	Somnium for bytecode inspection.
	
	Call with pause = TRUE to wait until the debugger connected and immediately break on the next instruction after the call.
	
*/

/proc/debugger_initialize(pause = FALSE)
	return call(EXTOOLS, "debug_initialize")(pause ? "pause" : "") == EXTOOLS_SUCCESS
	
/*

	Misc
	
*/

//Programatically enable and disable the built-in byond profiler. Useful if you want to, for example, profile subsystem initializations.
/proc/enable_profiling()
	return call(EXTOOLS, "enable_profiling")() == EXTOOLS_SUCCESS
	
/proc/disable_profiling()
	return call(EXTOOLS, "disable_profiling")() == EXTOOLS_SUCCESS

// Will dump the server's in-depth memory profile into the file specified.
/proc/dump_memory_profile(file_name)
	return call(EXTOOLS, "dump_memory_usage")(file_name) == EXTOOLS_SUCCESS