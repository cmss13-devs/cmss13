#define VALUE_MODE_NUM 0
#define VALUE_MODE_TEXT 1
#define VALUE_MODE_FLAG 2

#define KEY_MODE_TEXT 0
#define KEY_MODE_TYPE 1
#define KEY_MODE_TEXT_UNALTERED 2

SET_PROTECTED_DATUM(/datum/config_entry)

/datum/config_entry
	/// Do not instantiate if type matches this
	var/abstract_type = /datum/config_entry
	/// Read-only, this is determined by the last portion of the derived entry type
	var/name
	/// The configured value for this entry. This shouldn't be initialized in code, instead set default
	var/config_entry_value
	/// Read-only default value for this config entry, used for resetting value to defaults when necessary. This is what config_entry_value is initially set to
	var/default
	/// The file which this was loaded from, if any
	var/resident_file
	/// Set to TRUE if the default has been overridden by a config entry
	var/modified = FALSE
	/// The config name of a configuration type that depricates this, if it exists
	var/deprecated_by
	/// The /datum/config_entry type that supersedes this one
	var/protection = NONE
	/// Force validate and set on VV. VAS proccall guard will run regardless.
	var/vv_VAS = TRUE
	/// Controls if error is thrown when duplicate configuration values for this entry type are encountered
	var/dupes_allowed = FALSE

/datum/config_entry/New()
	if(type == abstract_type)
		CRASH("Abstract config entry [type] instantiated!")
	name = lowertext(type2top(type))
	if(islist(config_entry_value))
		var/list/L = config_entry_value
		default = L.Copy()
	else
		default = config_entry_value

/datum/config_entry/Destroy()
	config.RemoveEntry(src)
	return ..()

/datum/config_entry/can_vv_get(var_name)
	. = ..()
	if(var_name == NAMEOF(src, config_entry_value) || var_name == NAMEOF(src, default))
		. &= !(protection & CONFIG_ENTRY_HIDDEN)

/datum/config_entry/vv_edit_var(var_name, var_value)
	var/static/list/banned_edits = list(NAMEOF_STATIC(src, name), NAMEOF_STATIC(src, vv_VAS), NAMEOF_STATIC(src, default), NAMEOF_STATIC(src, resident_file), NAMEOF_STATIC(src, protection), NAMEOF_STATIC(src, abstract_type), NAMEOF_STATIC(src, modified), NAMEOF_STATIC(src, dupes_allowed))
	if(var_name == NAMEOF(src, config_entry_value))
		if(protection & CONFIG_ENTRY_LOCKED)
			return FALSE
		if(vv_VAS)
			. = ValidateAndSet("[var_value]")
			if(.)
				datum_flags |= DF_VAR_EDITED
			return
		else
			return ..()
	if(var_name in banned_edits)
		return FALSE
	return ..()

/datum/config_entry/proc/VASProcCallGuard(str_val)
	. = !((protection & CONFIG_ENTRY_LOCKED) && IsAdminAdvancedProcCall())
	if(!.)
		log_admin_private("[key_name(usr)] attempted to set locked config entry [type] to '[str_val]'")

/datum/config_entry/proc/ValidateAndSet(str_val)
	VASProcCallGuard(str_val)
	CRASH("Invalid config entry type!")

/datum/config_entry/proc/ValidateListEntry(key_name, key_value)
	return TRUE

/datum/config_entry/proc/DeprecationUpdate(value)
	return

/datum/config_entry/string
	config_entry_value = ""
	abstract_type = /datum/config_entry/string
	var/auto_trim = TRUE

/datum/config_entry/string/vv_edit_var(var_name, var_value)
	return var_name != NAMEOF(src, auto_trim) && ..()

/datum/config_entry/string/ValidateAndSet(str_val)
	if(!VASProcCallGuard(str_val))
		return FALSE
	config_entry_value = auto_trim ? trim(str_val) : str_val
	return TRUE

/datum/config_entry/number
	config_entry_value = 0
	abstract_type = /datum/config_entry/number
	var/integer = TRUE
	var/max_val = INFINITY
	var/min_val = -INFINITY

/datum/config_entry/number/ValidateAndSet(str_val)
	if(!VASProcCallGuard(str_val))
		return FALSE
	var/temp = text2num(trim(str_val))
	if(!isnull(temp))
		config_entry_value = clamp(integer ? floor(temp) : temp, min_val, max_val)
		if(config_entry_value != temp && !(datum_flags & DF_VAR_EDITED))
			log_config("Changing [name] from [temp] to [config_entry_value]!")
		return TRUE
	return FALSE

/datum/config_entry/number/vv_edit_var(var_name, var_value)
	var/static/list/banned_edits = list(NAMEOF_STATIC(src, max_val), NAMEOF_STATIC(src, min_val), NAMEOF_STATIC(src, integer))
	return !(var_name in banned_edits) && ..()

/datum/config_entry/flag
	config_entry_value = FALSE
	abstract_type = /datum/config_entry/flag

/datum/config_entry/flag/ValidateAndSet(str_val)
	if(!VASProcCallGuard(str_val))
		return FALSE
	config_entry_value = text2num(trim(str_val)) != 0
	return TRUE

/// List config entry, used for configuring a list of strings
/datum/config_entry/str_list
	abstract_type = /datum/config_entry/str_list
	config_entry_value = list()
	dupes_allowed = TRUE

/datum/config_entry/str_list/ValidateAndSet(str_val)
	if (!VASProcCallGuard(str_val))
		return FALSE
	str_val = trim(str_val)
	if (str_val != "")
		config_entry_value += str_val
	return TRUE

/datum/config_entry/number_list
	abstract_type = /datum/config_entry/number_list
	config_entry_value = list()

/datum/config_entry/number_list/ValidateAndSet(str_val)
	if(!VASProcCallGuard(str_val))
		return FALSE
	str_val = trim(str_val)
	var/list/new_list = list()
	var/list/values = splittext(str_val," ")
	for(var/I in values)
		var/temp = text2num(I)
		if(isnull(temp))
			return FALSE
		new_list += temp
	if(!length(new_list))
		return FALSE
	config_entry_value = new_list
	return TRUE

/datum/config_entry/keyed_list
	abstract_type = /datum/config_entry/keyed_list
	config_entry_value = list()
	dupes_allowed = TRUE
	vv_VAS = FALSE //VAS will not allow things like deleting from lists, it'll just bug horribly.
	var/key_mode
	var/value_mode
	var/splitter = " "

/datum/config_entry/keyed_list/New()
	. = ..()
	if(isnull(key_mode) || isnull(value_mode))
		CRASH("Keyed list of type [type] created with null key or value mode!")

/datum/config_entry/keyed_list/ValidateAndSet(str_val)
	if(!VASProcCallGuard(str_val))
		return FALSE

	str_val = trim(str_val)
	var/key_pos = findtext(str_val, splitter)
	var/key_name = null
	var/key_value = null

	if(key_pos || value_mode == VALUE_MODE_FLAG)
		key_name = copytext(str_val, 1, key_pos)
		if(key_mode != KEY_MODE_TEXT_UNALTERED)
			key_name = lowertext(key_name)
		if(key_pos)
			key_value = copytext(str_val, key_pos + length(str_val[key_pos]))
		var/new_key
		var/new_value
		var/continue_check_value
		var/continue_check_key
		switch(key_mode)
			if(KEY_MODE_TEXT, KEY_MODE_TEXT_UNALTERED)
				new_key = key_name
				continue_check_key = new_key
			if(KEY_MODE_TYPE)
				new_key = key_name
				if(!ispath(new_key))
					new_key = text2path(new_key)
				continue_check_key = ispath(new_key)
		switch(value_mode)
			if(VALUE_MODE_FLAG)
				new_value = TRUE
				continue_check_value = TRUE
			if(VALUE_MODE_NUM)
				new_value = text2num(key_value)
				continue_check_value = !isnull(new_value)
			if(VALUE_MODE_TEXT)
				new_value = key_value
				continue_check_value = new_value
		if(continue_check_value && continue_check_key && ValidateListEntry(new_key, new_value))
			config_entry_value[new_key] = new_value
			return TRUE
	return FALSE

/datum/config_entry/keyed_list/vv_edit_var(var_name, var_value)
	return var_name != NAMEOF(src, splitter) && ..()
