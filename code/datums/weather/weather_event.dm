// Each subtype of weather_event defines a distinct weather event type
// E.G. blizzard, snowstorm, dust storm, etc. 
// These are basically just "state holders"
// that hold state necessary for the weather event to 
// be handled across the world and by the weather subsystem

/datum/weather_event
    
    //// MANDATORY vars
    var/name = "set this" // Make this a copy of display name unless theres a good reason
    var/display_name = "set this" // The "display name" of this event
    var/length = 0 // Length of the event
    
    //// Optional vars
    var/fullscreen_type = null  // If this is set, display a fullscreen type to mobs
    var/effect_type = null // The subtype of /datum/effects/weather to apply to mobs
    var/turf_overlay_icon_state // The icon to set on the VFX holder instanced into every turf at round start

