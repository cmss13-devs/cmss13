#define BSQL_EXTERNAL_CONFIGURATION
#define BSQL_DEL_PROC(path) ##path/Destroy()
#define BSQL_DEL_CALL(obj) qdel(##obj)
#define BSQL_IS_DELETED(obj) (QDELETED(obj))

#ifndef TESTING
#define BSQL_PROTECT_DATUM(path) \
##path/is_datum_protected(){\
    return TRUE;\
}
#else
#define BSQL_PROTECT_DATUM(path)
#endif

#define BSQL_ERROR(message) world.log<<message