/// The base URL for the achievements API endpoint
/datum/config_entry/string/achievements_api_url
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_SENSITIVE

/// The API key for authenticating with the achievements service
/datum/config_entry/string/achievements_api_key
	protection = CONFIG_ENTRY_HIDDEN|CONFIG_ENTRY_LOCKED|CONFIG_ENTRY_SENSITIVE

/// Additional parameter passed to the backend service
/datum/config_entry/string/achievements_instance
	protection= CONFIG_ENTRY_LOCKED
