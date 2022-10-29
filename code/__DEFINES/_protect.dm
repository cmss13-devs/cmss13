#define GENERAL_PROTECT_DATUM(Path)\
##Path/can_vv_get(var_name){\
	return FALSE;\
}\
##path/is_datum_protected(){\
    return TRUE;\
}\
##Path/CanProcCall(procname){\
	return FALSE;\
}
