//config files
#define CONFIG_GET(X) global.config.Get(/datum/config_entry/##X)
#define CONFIG_SET(X, Y) global.config.Set(/datum/config_entry/##X, ##Y)

#define CONFIG_GROUND_MAPS_FILE "maps.txt"
#define CONFIG_SHIP_MAPS_FILE "shipmaps.txt"

//flags
#define CONFIG_ENTRY_LOCKED (1<<0) //can't edit
#define CONFIG_ENTRY_HIDDEN (1<<1) //can't see value

#define ON_CONFIG_LOAD(type) \
##type/New() { \
	. = ..(); \
	RegisterSignal(SSdcs, COMSIG_GLOB_CONFIG_LOADED, PROC_REF(__on_config_load)); \
}; \
##type/proc/__on_config_load()
