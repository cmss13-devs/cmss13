/**
*	This is for mobs, assigned to their water_config variable. It tells the water_overlay code what overlay to use
*/
/datum/water_overlay_config
	/// Whether it creates splashes or not
	var/use_splash = TRUE
	/// size of the mob's sprite (32, 48, 64, 88) --> should be exact match to the mob's icon_size
	var/icon_size = 32
	/// this is what is used to key into the correct icon_states, needs to be defined if using resting icons
	var/icon_state_key = null	//for example: "human" corresponds to "culling_human" or "culling_human_resting_coast_e"
	/// does it use a special culling mask or not for the overlay while standing?
	var/special_culling_mask = FALSE
	/// Whether this mob has resting textures made for it(coastlines and shallow/intermediate)
	var/resting_behavior = WATER_OVERLAY_CONFIG_RESTING_NONE
	/// when to start checking for immersal
	var/immerse_behavior = WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_DEPTHED
	/// When should this mob get completely covered in the overlay
	var/immerse_at_depth = DEPTH_DEEP

/datum/water_overlay_config/human
	icon_state_key = "human"
	resting_behavior = WATER_OVERLAY_CONFIG_RESTING_ANGLED

/datum/water_overlay_config/large
	icon_size = 64

/datum/water_overlay_config/xeno
	resting_behavior = WATER_OVERLAY_CONFIG_RESTING_NONE

/datum/water_overlay_config/xeno/larva
	use_splash = FALSE
	special_culling_mask = TRUE
	icon_state_key = "larva"
	resting_behavior = WATER_OVERLAY_CONFIG_RESTING_USE_DEFAULT
	immerse_behavior = WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_ALWAYS

/datum/water_overlay_config/xeno/small
	icon_size = 48

/datum/water_overlay_config/xeno/small/facehugger
	use_splash = FALSE
	resting_behavior = WATER_OVERLAY_CONFIG_RESTING_IMMERSE
	immerse_behavior = WATER_OVERLAY_CONFIG_IMMERSE_DEPTHED
	immerse_at_depth = DEPTH_SHALLOW

/datum/water_overlay_config/xeno/medium
	icon_size = 64

/datum/water_overlay_config/xeno/large
	icon_size = 88
