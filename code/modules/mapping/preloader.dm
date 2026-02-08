// global datum that will preload variables on atoms instanciation
GLOBAL_VAR_INIT(use_preloader, FALSE)
GLOBAL_LIST_INIT(_preloader_attributes, null)
GLOBAL_LIST_INIT(_preloader_path, null)

/// Preloader datum
/datum/map_preloader
	var/list/attributes
	var/target_path

/world/proc/preloader_setup(list/the_attributes, path)
	if(length(the_attributes))
		GLOB.use_preloader = TRUE
		GLOB._preloader_attributes = the_attributes
		GLOB._preloader_path = path

/world/proc/preloader_load(atom/what)
	GLOB.use_preloader = FALSE
	var/list/attributes = GLOB._preloader_attributes
	for(var/attribute in attributes)
		var/value = attributes[attribute]
		if(islist(value))
			value = deep_copy_list(value)
		#ifdef TESTING
		if(what.vars[attribute] == value)
			var/message = "<font color=green>[what.type]</font> at [AREACOORD(what)] - <b>VAR:</b> <font color=red>[attribute] = [isnull(value) ? "null" : (isnum(value) ? value : "\"[value]\"")]</font>"
			log_mapping("DIRTY VAR: [message]")
			GLOB.dirty_vars += message
		#endif
		what.vars[attribute] = value

/// Template noop (no operation) is used to skip an area when the template is loaded this allows for template transparency
/// ex. if a ship has gaps in it's design, you would use template_noop to fill these in so that when the ship moves z-level, any
/// tiles these gaps land on will not be deleted and replaced with the ships (empty) tiles
/area/template_noop
	name = "Area Passthrough"
	icon_state = "noop"

/// A conditional template noop (no operation) only if the trigger_area_type matches the existing area (or there wasn't an existing area)
/area/template_noop/conditional
	/// If the existing area is this type, then we convert to resulting_area_type
	var/trigger_area_type = /area/space
	/// The area to convert to if the existing area type matched trigger_area_type
	var/resulting_area_type = /area/misc

/// Template noop (no operation) is used to skip a turf when the template is loaded this allows for template transparency
/// ex. if a ship has gaps in it's design, you would use template_noop to fill these in so that when the ship moves z-level, any
/// tiles these gaps land on will not be deleted and replaced with the ships (empty) tiles
/turf/template_noop
	name = "Turf Passthrough"
	icon_state = "noop"
