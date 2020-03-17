#define BSQL_EXTERNAL_CONFIGURATION
#define BSQL_DEL_PROC(path) ##path/Dispose()
#define BSQL_DEL_CALL(obj) qdel(##obj)
#define BSQL_IS_DELETED(obj) (QDELETED(obj))
#define BSQL_PROTECT_DATUM(path) \
##Path/can_vv_get(){\
    return FALSE;\
}
#define BSQL_ERROR(message) world.log<<message