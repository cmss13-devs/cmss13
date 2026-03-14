GLOBAL_MULTIPLE(protected_sentry_procs)
#define SET_PROTECTED_PROC(proc) GLOBAL_MULTIPLE_UPDATE(protected_sentry_procs, proc)

GLOBAL_MULTIPLE(protected_sentry_datums)
#define SET_PROTECTED_DATUM(datum) GLOBAL_MULTIPLE_UPDATE(protected_sentry_datums, datum)

GLOBAL_LIST_EMPTY(protected_config_entries)

#define GENERAL_PROTECT_DATUM(Path)\
SET_PROTECTED_DATUM(Path)\
##Path/can_vv_get(var_name){\
	return FALSE;\
}\
##Path/vv_edit_var(var_name, var_value){\
	return FALSE;\
}\
##Path/CanProcCall(procname){\
	return FALSE;\
}
