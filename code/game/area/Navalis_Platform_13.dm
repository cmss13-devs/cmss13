/area/navalis
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY

//Parent Types

/area/navalis/oob
	name = "Navalis - Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_UNWEEDABLE

//Water Types

/area/navalis/oob/water
	name = "Water - Near"
	icon_state = "iso1"
	ceiling = CEILING_NONE
	requires_power = FALSE
	base_lighting_alpha = 20

/area/navalis/oob/water/mid
	name = "Water - Middle"
	icon_state = "iso2"
	base_lighting_alpha = 30

/area/navalis/oob/water/far
	name = "Water - Far"
	icon_state = "iso3"
	base_lighting_alpha = 35

//Additional Out Of Bounds

/area/navalis/oob/powered
	requires_power = FALSE

