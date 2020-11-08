#include "code/database.dm"

#ifdef NDATABASE_RUSTG_BRSQL_SUPPORT
#include "code/brsql_persistent_connection.dm"
#include "code/brsql_persistent_query.dm"
#include "code/brsql_adapter.dm"
#include "code/brsql_connection_settings.dm"
#endif

#include "code/native_persistent_connection.dm"
#include "code/native_persistent_query.dm"
#include "code/native_adapter.dm"
#include "code/native_connection_settings.dm"

#include "code/query_response.dm"
#include "code/entity/entity.dm"
#include "code/entity/entity_meta.dm"
#include "code/entity/link.dm"
#include "code/entity/entity_view.dm"
#include "code/entity/index.dm"

#include "code/interfaces/adapter.dm"
#include "code/interfaces/connection.dm"
#include "code/interfaces/connection_settings.dm"
#include "code/interfaces/filter.dm"
#include "code/interfaces/native_function.dm"
#include "code/interfaces/query.dm"

#include "tests/test_entity.dm"
#include "subsystems/database_query_manager.dm"
#include "subsystems/entity_manager.dm"
