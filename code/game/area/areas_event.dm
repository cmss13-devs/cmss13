/*
//Variants of characteristics:
// 1. Uses dynamic lightning ON/OFF (no dynamic lighting means area has constant light level, like LZ pads and thunderdome)
		if ON:
		a) is it lit or not (if area is lit, that means that, while area has dynamic lighting enabled, it's default light level is not darkness)
	2. Is it powered or not
	3. ceiling level
		a) CEILING_NONE
		b) CEILING_METAL
		c) CEILING_UNDERGROUND_ALLOW_CAS
		d) CEILING_UNDERGROUND_BLOCK_CAS
		e) CEILING_DEEP_UNDERGROUND


structure:
	CEILING_GLASS
		lighting_use_dynamic = FALSE
			powered
			not powered
		lighting_use_dynamic = TRUE
			lit
				powered
				not powered
			not lit
				powered
				not powered

	CEILING_METAL
		...
	CEILING_UNDERGROUND_ALLOW_CAS
		...
	CEILING_UNDERGROUND_BLOCK_CAS
		...
*/

//-----------------------CEILING_NONE--------------------------

//no dynamic lighting, powered.
/area/event
	name = "Open grounds (event P)"
	icon = 'icons/turf/areas_event.dmi'
	icon_state = "event"

	//no bioscan and no tunnels allowed
	flags_area = AREA_AVOID_BIOSCAN|AREA_NOTUNNEL

	//events are not part of regular gameplay, therefore, no statistics
	statistic_exempt = TRUE

	base_lighting_alpha = 255

	//always powered
	requires_power = FALSE
	unlimited_power = TRUE
	// ovi block timer is disabled so queens can do ovi stuff in event areas, namely USS runtime.
	unoviable_timer = FALSE

//no dynamic lighting, unpowered.
/area/event/unpowered
	name = "Open grounds (event)"
	icon_state = "event_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, powered.
/area/event/dynamic
	name = "Open grounds (event PD)"
	icon_state = "event_dyn"
	requires_power = TRUE
	unlimited_power = TRUE
	// Base lighting disabled so that normal lighting can function.
	base_lighting_alpha = 0

//dynamic lighting, unpowered.
/area/event/dynamic/unpowered
	name = "Open grounds (event D)"
	icon_state = "event_dyn_nopower"

	unlimited_power = FALSE

//dynamic lighting, lit, powered.
/area/event/dynamic/lit
	name = "Open grounds (event PDL)"
	icon_state = "event_dyn_lit"

	base_lighting_alpha = 255

//dynamic lighting, lit, unpowered.
/area/event/dynamic/lit/unpowered
	name = "Open grounds (event DL)"
	icon_state = "event_dyn_lit_nopower"

	unlimited_power = FALSE

//-----------------------CEILING_METAL--------------------------

//no dynamic lighting, powered.
/area/event/metal

	name = "Building interior (event P)"
	name = "Event interior area"
	icon_state = "metal"
	ceiling = CEILING_METAL

//no dynamic lighting, unpowered.
/area/event/metal/unpowered
	name = "Building interior (event)"
	icon_state = "metal_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, powered.
/area/event/metal/dynamic
	name = "Building interior (event PD)"
	icon_state = "metal_dyn"
	requires_power = TRUE
	unlimited_power = TRUE
	// Base lighting disabled so that normal lighting can function.
	base_lighting_alpha = 0

//dynamic lighting, unpowered.
/area/event/metal/dynamic/unpowered
	name = "Building interior (event D)"
	icon_state = "metal_dyn_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, lit, powered.
/area/event/metal/dynamic/lit
	name = "Building interior (event PDL)"
	icon_state = "metal_dyn_lit"

	base_lighting_alpha = 255

//dynamic lighting, lit, unpowered.
/area/event/metal/dynamic/lit/unpowered
	name = "Building interior (event DL)"
	icon_state = "metal_dyn_lit_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//-----------------------CEILING_UNDERGROUND_ALLOW_CAS--------------------------

//no dynamic lighting, powered.
/area/event/underground

	name = "Small caves (event P)"
	icon_state = "under"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25
	base_muffle = MUFFLE_HIGH

//no dynamic lighting, unpowered.
/area/event/underground/unpowered
	name = "Small caves (event)"
	icon_state = "under_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, powered.
/area/event/underground/dynamic
	name = "Small caves (event PD)"
	icon_state = "under_dyn"
	requires_power = TRUE
	unlimited_power = TRUE
	// Base lighting disabled so that normal lighting can function.
	base_lighting_alpha = 0

//dynamic lighting, unpowered.
/area/event/underground/dynamic/unpowered
	name = "Small caves (event D)"
	icon_state = "under_dyn_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, lit, powered.
/area/event/underground/dynamic/lit
	name = "Small caves (event PDL)"
	icon_state = "under_dyn_lit"

	base_lighting_alpha = 255

//dynamic lighting, lit, unpowered.
/area/event/underground/dynamic/lit/unpowered
	name = "Small caves (event DL)"
	icon_state = "under_dyn_lit_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//-----------------------CEILING_UNDERGROUND_BLOCK_CAS--------------------------

//no dynamic lighting, powered.
/area/event/underground_no_CAS

	name = "Caves (event P)"
	name = "Event underground area"
	icon_state = "undercas"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS

	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25
	base_muffle = MUFFLE_HIGH

//no dynamic lighting, unpowered.
/area/event/underground_no_CAS/unpowered
	name = "Caves (event)"
	icon_state = "undercas_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, powered.
/area/event/underground_no_CAS/dynamic
	name = "Caves (event PD)"
	icon_state = "undercas_dyn"
	requires_power = TRUE
	unlimited_power = TRUE
	// Base lighting disabled so that normal lighting can function.
	base_lighting_alpha = 0

//dynamic lighting, unpowered.
/area/event/underground_no_CAS/dynamic/unpowered
	name = "Caves (event D)"
	icon_state = "undercas_dyn_nopower"

	unlimited_power = FALSE

//dynamic lighting, lit, powered.
/area/event/underground_no_CAS/dynamic/lit
	name = "Caves (event PDL)"
	icon_state = "undercas_dyn_lit"

	base_lighting_alpha = 255

//dynamic lighting, lit, unpowered.
/area/event/underground_no_CAS/dynamic/lit/unpowered
	name = "Caves (event DL)"
	icon_state = "undercas_dyn_lit_nopower"

	unlimited_power = FALSE

//-----------------------CEILING_DEEP_UNDERGROUND--------------------------

//no dynamic lighting, powered.
/area/event/deep_underground

	name = "Deep underground (event P)"
	icon_state = "deep"

	ceiling = CEILING_DEEP_UNDERGROUND

	ceiling_muffle = FALSE
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25
	base_muffle = MUFFLE_HIGH

//no dynamic lighting, unpowered.
/area/event/deep_underground/unpowered
	name = "Deep underground (event)"
	icon_state = "deep_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, powered.
/area/event/deep_underground/dynamic
	name = "Deep underground (event PD)"
	icon_state = "deep_dyn"
	requires_power = TRUE
	unlimited_power = TRUE
	// Base lighting disabled so that normal lighting can function.
	base_lighting_alpha = 0

//dynamic lighting, unpowered.
/area/event/deep_underground/dynamic/unpowered
	name = "Deep underground (event D)"
	icon_state = "deep_dyn_nopower"

	requires_power = TRUE
	unlimited_power = FALSE

//dynamic lighting, lit, powered.
/area/event/deep_underground/dynamic/lit
	name = "Deep underground (event PDL)"
	icon_state = "deep_dyn_lit"

	base_lighting_alpha = 255

//dynamic lighting, lit, unpowered.
/area/event/deep_underground/dynamic/lit/unpowered
	name = "Deep underground (event DL)"
	icon_state = "deep_dyn_lit_nopower"

	requires_power = TRUE
	unlimited_power = FALSE
