/obj/structure/shuttle/part
	opacity = TRUE
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE
	breakable = FALSE
	explo_proof = TRUE

// USCM Dropship Alamo

/obj/structure/shuttle/part/dropship1
	name = "\improper Alamo"
	icon = 'icons/turf/dropship.dmi'
	icon_state = "1"

/obj/structure/shuttle/part/dropship1/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/dropship1/transparent
	opacity = FALSE

/obj/structure/shuttle/part/dropship1/transparent/nose_top_right
	icon_state = "102"

/obj/structure/shuttle/part/dropship1/transparent/nose_center
	icon_state = "101"

/obj/structure/shuttle/part/dropship1/transparent/nose_top_left
	icon_state = "100"

/obj/structure/shuttle/part/dropship1/nose_front_left
	icon_state = "95"

/obj/structure/shuttle/part/dropship1/nose_front_right
	icon_state = "99"

/obj/structure/shuttle/part/dropship1/transparent/inner_right_weapons
	icon_state = "90"

/obj/structure/shuttle/part/dropship1/transparent/outer_right_weapons
	icon_state = "91"

/obj/structure/shuttle/part/dropship1/transparent/inner_left_weapons
	icon_state = "85"

/obj/structure/shuttle/part/dropship1/transparent/outer_left_weapons
	icon_state = "84"

/obj/structure/shuttle/part/dropship1/transparent/upper_right_wing
	icon_state = "74"

/obj/structure/shuttle/part/dropship1/transparent/middle_right_wing
	icon_state = "70"

/obj/structure/shuttle/part/dropship1/transparent/lower_right_wing
	icon_state = "65"

/obj/structure/shuttle/part/dropship1/transparent/upper_left_wing
	icon_state = "71"

/obj/structure/shuttle/part/dropship1/transparent/middle_left_wing
	icon_state = "66"

/obj/structure/shuttle/part/dropship1/transparent/lower_left_wing
	icon_state = "61"

/obj/structure/shuttle/part/dropship1/lower_left_wall
	icon_state = "46"

/obj/structure/shuttle/part/dropship1/lower_right_wall
	icon_state = "49"

/obj/structure/shuttle/part/dropship1/transparent/engine_left_cap
	icon_state = "40"

/obj/structure/shuttle/part/dropship1/transparent/engine_right_cap
	icon_state = "41"

/obj/structure/shuttle/part/dropship1/transparent/engine_left_exhaust
	icon_state = "16"

/obj/structure/shuttle/part/dropship1/transparent/engine_right_exhaust
	icon_state = "17"

/obj/structure/shuttle/part/dropship1/bottom_left_wall
	icon_state = "9"

/obj/structure/shuttle/part/dropship1/bottom_right_wall
	icon_state = "15"

/obj/structure/shuttle/part/dropship1/left_inner_wing_connector
	icon_state = "7"

/obj/structure/shuttle/part/dropship1/right_inner_wing_connector
	icon_state = "8"

/obj/structure/shuttle/part/dropship1/left_outer_wing_connector
	icon_state = "3"

/obj/structure/shuttle/part/dropship1/right_outer_wing_connector
	icon_state = "4"

/obj/structure/shuttle/part/dropship1/transparent/left_inner_bottom_wing
	icon_state = "1"

/obj/structure/shuttle/part/dropship1/transparent/left_outer_bottom_wing
	icon_state = "2"

/obj/structure/shuttle/part/dropship1/transparent/right_inner_bottom_wing
	icon_state = "5"

/obj/structure/shuttle/part/dropship1/transparent/right_outer_bottom_wing
	icon_state = "6"

/obj/structure/shuttle/part/dropship_omaha
	name = "\improper Omaha"
	icon = 'icons/turf/mohawk/mohawk-facade.dmi'
	icon_state = "15,16"

/obj/structure/shuttle/part/dropship_omaha/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/dropship_omaha/transparent
	opacity = FALSE

/obj/structure/shuttle/part/dropship_omaha/transparent/lateShuttleMove()
	.=..()
	for(var/turf/open_space/transparent_turf in locs)
		transparent_turf.update_vis_contents()

/obj/structure/shuttle/part/dropship_omaha/transparent/lower_left_wing
	icon = 'icons/obj/structures/machinery/mohawk/mohawk-windshield-64x64.dmi'
	icon_state = "wingpoint-left"

/obj/structure/shuttle/part/dropship_omaha/transparent/lower_right_wing
	icon = 'icons/obj/structures/machinery/mohawk/mohawk-windshield-64x64.dmi'
	icon_state = "wingpoint-right"

//// BOTTOM STUFF////

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_00
	icon_state = "5,0"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_01
	icon_state = "6,0"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_02
	icon_state = "7,0"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_03
	icon_state = "8,0"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_04
	icon_state = "9,0"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_05
	icon_state = "10,0"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_06
	icon_state = "11,0"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_10
	icon_state = "5,1"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_11
	icon_state = "6,1"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_12
	icon_state = "7,1"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_13
	icon_state = "8,1"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_14
	icon_state = "9,1"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_15
	icon_state = "10,1"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_16
	icon_state = "11,1"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_30
	icon_state = "4,3"

/obj/structure/shuttle/part/dropship_omaha/transparent/bottom/bottom_36
	icon_state = "12,3"

/// WINGS LEFT ////

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_00
	icon_state = "2,14"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_01
	icon_state = "3,14"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_03 // this goes over wall
	icon_state = "4,14"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_10
	icon_state = "0,15"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_11
	icon_state = "1,15"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_12
	icon_state = "2,15"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_13
	icon_state = "3,15"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_14
	icon_state = "4,15"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_20
	icon_state = "0,16"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_21
	icon_state = "1,16"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_22
	icon_state = "2,16"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_23
	icon_state = "3,16"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_30
	icon_state = "0,17"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_31
	icon_state = "1,17"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_32
	icon_state = "2,17"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/left_33
	icon_state = "3,17"

/// WINGS RIGHT ///

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_00
	icon_state = "12,14"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_01
	icon_state = "13,14"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_02
	icon_state = "14,14"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_10
	icon_state = "12,15"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_11
	icon_state = "13,15"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_12
	icon_state = "14,15"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_13
	icon_state = "15,15"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_14
	icon_state = "16,15"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_20
	icon_state = "13,16"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_21
	icon_state = "14,16"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_22
	icon_state = "15,16"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_23
	icon_state = "16,16"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_30
	icon_state = "13,17"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_31
	icon_state = "14,17"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_32
	icon_state = "15,17"

/obj/structure/shuttle/part/dropship_omaha/transparent/wings/right_33
	icon_state = "16,17"

/// NOSE LEFT ///
/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_01
	icon_state = "1,18"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_02
	icon_state = "2,18"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_03
	icon_state = "3,18"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_04
	icon_state = "4,18"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_11
	icon_state = "2,19"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_12
	icon_state = "3,19"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_13
	icon_state = "4,19"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_14
	icon_state = "5,19"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_21
	icon_state = "2,20"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_22
	icon_state = "3,20"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_23
	icon_state = "4,20"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/left_24
	icon_state = "5,20"

/// NOSE RIGHT ///

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_01
	icon_state = "12,18"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_02
	icon_state = "13,18"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_03
	icon_state = "14,18"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_04
	icon_state = "15,18"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_11
	icon_state = "11,19"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_12
	icon_state = "12,19"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_13
	icon_state = "13,19"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_14
	icon_state = "14,19"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_21
	icon_state = "11,20"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_22
	icon_state = "12,20"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_23
	icon_state = "13,20"

/obj/structure/shuttle/part/dropship_omaha/transparent/nose/right_24
	icon_state = "14,20"

/// COCKPIT ////
/obj/structure/shuttle/part/dropship_omaha/transparent/cockpit
	icon = 'icons/turf/mohawk/mohawk-walls.dmi'

/obj/structure/shuttle/part/dropship_omaha/transparent/cockpit/nose_00
	icon_state = "2,19"

/obj/structure/shuttle/part/dropship_omaha/transparent/cockpit/nose_01
	icon_state = "3,19"
	density = FALSE
	layer = OBJ_LAYER - 0.05

/obj/structure/shuttle/part/dropship_omaha/transparent/cockpit/nose_02
	icon_state = "5,19"
	density = FALSE
	layer = OBJ_LAYER - 0.05

/obj/structure/shuttle/part/dropship_omaha/transparent/cockpit/nose_03
	icon_state = "6,19"

/obj/structure/shuttle/part/dropship_omaha/transparent/cockpit/nose_10
	icon_state = "2,20"

/obj/structure/shuttle/part/dropship_omaha/transparent/cockpit/nose_11
	icon_state = "3,20"

/obj/structure/shuttle/part/dropship_omaha/transparent/cockpit/nose_12
	icon_state = "4,20"

/obj/structure/shuttle/part/dropship_omaha/transparent/cockpit/nose_13
	icon_state = "5,20"

/obj/structure/shuttle/part/dropship_omaha/transparent/cockpit/nose_14
	icon_state = "6,20"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals
	name = "Platform"
	icon = 'icons/turf/mohawk/mohawk-ramp.dmi'
	density = FALSE

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_00
	icon_state = "0,0"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_01
	icon_state = "1,0"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_02
	icon_state = "2,0"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_10
	icon_state = "0,1"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_11
	icon_state = "2,1"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_20
	icon_state = "0,2"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_21
	icon_state = "2,2"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_30
	icon_state = "0,3"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_30
	icon_state = "0,3"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_31
	icon_state = "1,3"

/obj/structure/shuttle/part/dropship_omaha/ramp_decals/border_32
	icon_state = "2,3"

// USCM Dropship Normandy

/obj/structure/shuttle/part/dropship2
	name = "\improper Normandy"
	icon = 'icons/turf/dropship2.dmi'
	icon_state = "1"
	opacity = TRUE

/obj/structure/shuttle/part/dropship2/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/dropship2/transparent
	opacity = FALSE

/obj/structure/shuttle/part/dropship2/transparent/nose_top_right
	icon_state = "102"

/obj/structure/shuttle/part/dropship2/transparent/nose_center
	icon_state = "101"

/obj/structure/shuttle/part/dropship2/transparent/nose_top_left
	icon_state = "100"

/obj/structure/shuttle/part/dropship2/nose_front_left
	icon_state = "95"

/obj/structure/shuttle/part/dropship2/nose_front_right
	icon_state = "99"

/obj/structure/shuttle/part/dropship2/transparent/inner_right_weapons
	icon_state = "90"

/obj/structure/shuttle/part/dropship2/transparent/outer_right_weapons
	icon_state = "91"

/obj/structure/shuttle/part/dropship2/transparent/inner_left_weapons
	icon_state = "85"

/obj/structure/shuttle/part/dropship2/transparent/outer_left_weapons
	icon_state = "84"

/obj/structure/shuttle/part/dropship2/transparent/upper_right_wing
	icon_state = "74"

/obj/structure/shuttle/part/dropship2/transparent/middle_right_wing
	icon_state = "70"

/obj/structure/shuttle/part/dropship2/transparent/lower_right_wing
	icon_state = "65"

/obj/structure/shuttle/part/dropship2/transparent/upper_left_wing
	icon_state = "71"

/obj/structure/shuttle/part/dropship2/transparent/middle_left_wing
	icon_state = "66"

/obj/structure/shuttle/part/dropship2/transparent/lower_left_wing
	icon_state = "61"

/obj/structure/shuttle/part/dropship2/lower_left_wall
	icon_state = "46"

/obj/structure/shuttle/part/dropship2/lower_right_wall
	icon_state = "49"

/obj/structure/shuttle/part/dropship2/transparent/engine_left_cap
	icon_state = "40"

/obj/structure/shuttle/part/dropship2/transparent/engine_right_cap
	icon_state = "41"

/obj/structure/shuttle/part/dropship2/transparent/engine_left_exhaust
	icon_state = "16"

/obj/structure/shuttle/part/dropship2/transparent/engine_right_exhaust
	icon_state = "17"

/obj/structure/shuttle/part/dropship2/bottom_left_wall
	icon_state = "9"

/obj/structure/shuttle/part/dropship2/bottom_right_wall
	icon_state = "15"

/obj/structure/shuttle/part/dropship2/left_inner_wing_connector
	icon_state = "7"

/obj/structure/shuttle/part/dropship2/right_inner_wing_connector
	icon_state = "8"

/obj/structure/shuttle/part/dropship2/left_outer_wing_connector
	icon_state = "3"

/obj/structure/shuttle/part/dropship2/right_outer_wing_connector
	icon_state = "4"

/obj/structure/shuttle/part/dropship2/transparent/left_outer_bottom_wing
	icon_state = "1"

/obj/structure/shuttle/part/dropship2/transparent/left_outer_inner_wing
	icon_state = "2"

/obj/structure/shuttle/part/dropship2/transparent/right_inner_bottom_wing
	icon_state = "5"

/obj/structure/shuttle/part/dropship2/transparent/right_outer_bottom_wing
	icon_state = "6"

// USCM Dropship Saipan

/obj/structure/shuttle/part/dropship3
	name = "\improper Saipan"
	icon = 'icons/turf/dropship3.dmi'
	icon_state = "1"
	opacity = TRUE

/obj/structure/shuttle/part/dropship3/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/dropship3/transparent
	opacity = FALSE

/obj/structure/shuttle/part/dropship3/transparent/nose_top_right
	icon_state = "102"

/obj/structure/shuttle/part/dropship3/transparent/nose_center
	icon_state = "101"

/obj/structure/shuttle/part/dropship3/transparent/nose_top_left
	icon_state = "100"

/obj/structure/shuttle/part/dropship3/nose_front_left
	icon_state = "95"

/obj/structure/shuttle/part/dropship3/nose_front_right
	icon_state = "99"

/obj/structure/shuttle/part/dropship3/transparent/inner_right_weapons
	icon_state = "90"

/obj/structure/shuttle/part/dropship3/transparent/outer_right_weapons
	icon_state = "91"

/obj/structure/shuttle/part/dropship3/transparent/inner_left_weapons
	icon_state = "85"

/obj/structure/shuttle/part/dropship3/transparent/outer_left_weapons
	icon_state = "84"

/obj/structure/shuttle/part/dropship3/transparent/upper_right_wing
	icon_state = "74"

/obj/structure/shuttle/part/dropship3/transparent/middle_right_wing
	icon_state = "70"

/obj/structure/shuttle/part/dropship3/transparent/lower_right_wing
	icon_state = "65"

/obj/structure/shuttle/part/dropship3/transparent/upper_left_wing
	icon_state = "71"

/obj/structure/shuttle/part/dropship3/transparent/middle_left_wing
	icon_state = "66"

/obj/structure/shuttle/part/dropship3/transparent/lower_left_wing
	icon_state = "61"

/obj/structure/shuttle/part/dropship3/lower_left_wall
	icon_state = "46"

/obj/structure/shuttle/part/dropship3/lower_right_wall
	icon_state = "49"

/obj/structure/shuttle/part/dropship3/transparent/engine_left_cap
	icon_state = "40"

/obj/structure/shuttle/part/dropship3/transparent/engine_right_cap
	icon_state = "41"

/obj/structure/shuttle/part/dropship3/transparent/engine_left_exhaust
	icon_state = "16"

/obj/structure/shuttle/part/dropship3/transparent/engine_right_exhaust
	icon_state = "17"

/obj/structure/shuttle/part/dropship3/bottom_left_wall
	icon_state = "9"

/obj/structure/shuttle/part/dropship3/bottom_right_wall
	icon_state = "15"

/obj/structure/shuttle/part/dropship3/left_inner_wing_connector
	icon_state = "7"

/obj/structure/shuttle/part/dropship3/right_inner_wing_connector
	icon_state = "8"

/obj/structure/shuttle/part/dropship3/left_outer_wing_connector
	icon_state = "3"

/obj/structure/shuttle/part/dropship3/right_outer_wing_connector
	icon_state = "4"

/obj/structure/shuttle/part/dropship3/transparent/left_outer_bottom_wing
	icon_state = "1"

/obj/structure/shuttle/part/dropship3/transparent/left_outer_inner_wing
	icon_state = "2"

/obj/structure/shuttle/part/dropship3/transparent/right_inner_bottom_wing
	icon_state = "5"

/obj/structure/shuttle/part/dropship3/transparent/right_outer_bottom_wing
	icon_state = "6"

// UPP Dropship Morana

/obj/structure/shuttle/part/dropship_upp
	name = "\improper Morana"
	icon = 'icons/turf/dropship_upp.dmi'
	icon_state = "1"
	opacity = TRUE

/obj/structure/shuttle/part/dropship_upp/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/dropship_upp/transparent
	opacity = FALSE

/obj/structure/shuttle/part/dropship_upp/transparent/nose_top_right
	icon_state = "102"

/obj/structure/shuttle/part/dropship_upp/transparent/nose_center
	icon_state = "101"

/obj/structure/shuttle/part/dropship_upp/transparent/nose_top_left
	icon_state = "100"

/obj/structure/shuttle/part/dropship_upp/nose_front_left
	icon_state = "95"

/obj/structure/shuttle/part/dropship_upp/nose_front_right
	icon_state = "99"

/obj/structure/shuttle/part/dropship_upp/transparent/inner_right_weapons
	icon_state = "90"

/obj/structure/shuttle/part/dropship_upp/transparent/outer_right_weapons
	icon_state = "91"

/obj/structure/shuttle/part/dropship_upp/transparent/inner_left_weapons
	icon_state = "85"

/obj/structure/shuttle/part/dropship_upp/transparent/outer_left_weapons
	icon_state = "84"

/obj/structure/shuttle/part/dropship_upp/transparent/upper_right_wing
	icon_state = "74"

/obj/structure/shuttle/part/dropship_upp/transparent/middle_right_wing
	icon_state = "70"

/obj/structure/shuttle/part/dropship_upp/transparent/lower_right_wing
	icon_state = "65"

/obj/structure/shuttle/part/dropship_upp/transparent/upper_left_wing
	icon_state = "71"

/obj/structure/shuttle/part/dropship_upp/transparent/middle_left_wing
	icon_state = "66"

/obj/structure/shuttle/part/dropship_upp/transparent/lower_left_wing
	icon_state = "61"

/obj/structure/shuttle/part/dropship_upp/lower_left_wall
	icon_state = "46"

/obj/structure/shuttle/part/dropship_upp/lower_right_wall
	icon_state = "49"

/obj/structure/shuttle/part/dropship_upp/transparent/engine_left_cap
	icon_state = "40"

/obj/structure/shuttle/part/dropship_upp/transparent/engine_right_cap
	icon_state = "41"

/obj/structure/shuttle/part/dropship_upp/transparent/engine_left_exhaust
	icon_state = "16"

/obj/structure/shuttle/part/dropship_upp/transparent/engine_right_exhaust
	icon_state = "17"

/obj/structure/shuttle/part/dropship_upp/bottom_left_wall
	icon_state = "9"

/obj/structure/shuttle/part/dropship_upp/bottom_right_wall
	icon_state = "15"

/obj/structure/shuttle/part/dropship_upp/left_inner_wing_connector
	icon_state = "7"

/obj/structure/shuttle/part/dropship_upp/right_inner_wing_connector
	icon_state = "8"

/obj/structure/shuttle/part/dropship_upp/left_outer_wing_connector
	icon_state = "3"

/obj/structure/shuttle/part/dropship_upp/right_outer_wing_connector
	icon_state = "4"

/obj/structure/shuttle/part/dropship_upp/transparent/left_outer_bottom_wing
	icon_state = "1"

/obj/structure/shuttle/part/dropship_upp/transparent/left_outer_inner_wing
	icon_state = "2"

/obj/structure/shuttle/part/dropship_upp/transparent/right_inner_bottom_wing
	icon_state = "5"

/obj/structure/shuttle/part/dropship_upp/transparent/right_outer_bottom_wing
	icon_state = "6"

// UPP Dropship Devana

/obj/structure/shuttle/part/dropship_upp2
	name = "\improper Devana"
	icon = 'icons/turf/dropship_upp.dmi'
	icon_state = "1"
	opacity = TRUE

/obj/structure/shuttle/part/dropship_upp2/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/dropship_upp2/transparent
	opacity = FALSE

/obj/structure/shuttle/part/dropship_upp2/transparent/nose_top_right
	icon_state = "102"

/obj/structure/shuttle/part/dropship_upp2/transparent/nose_center
	icon_state = "101"

/obj/structure/shuttle/part/dropship_upp2/transparent/nose_top_left
	icon_state = "100"

/obj/structure/shuttle/part/dropship_upp2/nose_front_left
	icon_state = "95"

/obj/structure/shuttle/part/dropship_upp2/nose_front_right
	icon_state = "99"

/obj/structure/shuttle/part/dropship_upp2/transparent/inner_right_weapons
	icon_state = "90"

/obj/structure/shuttle/part/dropship_upp2/transparent/outer_right_weapons
	icon_state = "91"

/obj/structure/shuttle/part/dropship_upp2/transparent/inner_left_weapons
	icon_state = "85"

/obj/structure/shuttle/part/dropship_upp2/transparent/outer_left_weapons
	icon_state = "84"

/obj/structure/shuttle/part/dropship_upp2/transparent/upper_right_wing
	icon_state = "74"

/obj/structure/shuttle/part/dropship_upp2/transparent/middle_right_wing
	icon_state = "70"

/obj/structure/shuttle/part/dropship_upp2/transparent/lower_right_wing
	icon_state = "65"

/obj/structure/shuttle/part/dropship_upp2/transparent/upper_left_wing
	icon_state = "71"

/obj/structure/shuttle/part/dropship_upp2/transparent/middle_left_wing
	icon_state = "66"

/obj/structure/shuttle/part/dropship_upp2/transparent/lower_left_wing
	icon_state = "61"

/obj/structure/shuttle/part/dropship_upp2/lower_left_wall
	icon_state = "46"

/obj/structure/shuttle/part/dropship_upp2/lower_right_wall
	icon_state = "49"

/obj/structure/shuttle/part/dropship_upp2/transparent/engine_left_cap
	icon_state = "40"

/obj/structure/shuttle/part/dropship_upp2/transparent/engine_right_cap
	icon_state = "41"

/obj/structure/shuttle/part/dropship_upp2/transparent/engine_left_exhaust
	icon_state = "16"

/obj/structure/shuttle/part/dropship_upp2/transparent/engine_right_exhaust
	icon_state = "17"

/obj/structure/shuttle/part/dropship_upp2/bottom_left_wall
	icon_state = "9"

/obj/structure/shuttle/part/dropship_upp2/bottom_right_wall
	icon_state = "15"

/obj/structure/shuttle/part/dropship_upp2/left_inner_wing_connector
	icon_state = "7"

/obj/structure/shuttle/part/dropship_upp2/right_inner_wing_connector
	icon_state = "8"

/obj/structure/shuttle/part/dropship_upp2/left_outer_wing_connector
	icon_state = "3"

/obj/structure/shuttle/part/dropship_upp2/right_outer_wing_connector
	icon_state = "4"

/obj/structure/shuttle/part/dropship_upp2/transparent/left_outer_bottom_wing
	icon_state = "1"

/obj/structure/shuttle/part/dropship_upp2/transparent/left_outer_inner_wing
	icon_state = "2"

/obj/structure/shuttle/part/dropship_upp2/transparent/right_inner_bottom_wing
	icon_state = "5"

/obj/structure/shuttle/part/dropship_upp2/transparent/right_outer_bottom_wing
	icon_state = "6"

// UPP-SOF Ship

/obj/structure/shuttle/part/upp_sof
	name = "\improper UPP-DS-3 'Voron'"
	icon = 'icons/turf/dropship_upp_sof.dmi'
	icon_state = "0,0"
	opacity = TRUE

/obj/structure/shuttle/part/upp_sof/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/upp_sof/transparent
	opacity = FALSE

/obj/structure/shuttle/part/upp_sof_alt
	name = "\improper UPP-DS-3 'Volk'"
	icon = 'icons/turf/dropship_upp_sof_alt.dmi'
	icon_state = "0,0"
	opacity = TRUE

/obj/structure/shuttle/part/upp_sof_alt/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/upp_sof_alt/transparent
	opacity = FALSE

// TWE Ship

/obj/structure/shuttle/part/dropship_twe
	name = "\improper UD4-UK"
	icon = 'icons/turf/dropship_twe.dmi'
	icon_state = "0,0"
	opacity = TRUE

/obj/structure/shuttle/part/dropship_twe/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/dropship_twe/transparent
	opacity = FALSE

// WY Ship

/obj/structure/shuttle/part/dropship_wy
	name = "\improper WY-LWI StarGlider SG-200"
	desc = "The WY-LWI StarGlider SG-200, a product of the collaborative ingenuity between Weyland Yutani and Lunnar-Welsun Industries, This small dropship is designed for short-range commercial transport."
	icon = 'icons/turf/dropship_wy.dmi'
	icon_state = "1"

/obj/structure/shuttle/part/dropship_wy/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/dropship_wy/transparent
	opacity = FALSE

/obj/structure/shuttle/part/dropship_wy/transparent/nose_top_right
	icon_state = "102"

/obj/structure/shuttle/part/dropship_wy/transparent/nose_center
	icon_state = "101"

/obj/structure/shuttle/part/dropship_wy/transparent/nose_top_left
	icon_state = "100"

/obj/structure/shuttle/part/dropship_wy/nose_front_left
	icon_state = "95"

/obj/structure/shuttle/part/dropship_wy/nose_front_right
	icon_state = "99"

/obj/structure/shuttle/part/dropship_wy/transparent/inner_right_weapons
	icon_state = "90"

/obj/structure/shuttle/part/dropship_wy/transparent/outer_right_weapons
	icon_state = "91"

/obj/structure/shuttle/part/dropship_wy/transparent/inner_left_weapons
	icon_state = "85"

/obj/structure/shuttle/part/dropship_wy/transparent/outer_left_weapons
	icon_state = "84"

/obj/structure/shuttle/part/dropship_wy/transparent/upper_right_wing
	icon_state = "74"

/obj/structure/shuttle/part/dropship_wy/transparent/middle_right_wing
	icon_state = "70"

/obj/structure/shuttle/part/dropship_wy/transparent/lower_right_wing
	icon_state = "65"

/obj/structure/shuttle/part/dropship_wy/transparent/upper_left_wing
	icon_state = "71"

/obj/structure/shuttle/part/dropship_wy/transparent/middle_left_wing
	icon_state = "66"

/obj/structure/shuttle/part/dropship_wy/transparent/lower_left_wing
	icon_state = "61"

/obj/structure/shuttle/part/dropship_wy/lower_left_wall
	icon_state = "46"

/obj/structure/shuttle/part/dropship_wy/lower_right_wall
	icon_state = "49"

/obj/structure/shuttle/part/dropship_wy/transparent/engine_left_cap
	icon_state = "40"

/obj/structure/shuttle/part/dropship_wy/transparent/engine_right_cap
	icon_state = "41"

/obj/structure/shuttle/part/dropship_wy/transparent/engine_left_exhaust
	icon_state = "16"

/obj/structure/shuttle/part/dropship_wy/transparent/engine_right_exhaust
	icon_state = "17"

/obj/structure/shuttle/part/dropship_wy/bottom_left_wall
	icon_state = "9"

/obj/structure/shuttle/part/dropship_wy/bottom_right_wall
	icon_state = "15"

/obj/structure/shuttle/part/dropship_wy/left_inner_wing_connector
	icon_state = "7"

/obj/structure/shuttle/part/dropship_wy/right_inner_wing_connector
	icon_state = "8"

/obj/structure/shuttle/part/dropship_wy/left_outer_wing_connector
	icon_state = "3"

/obj/structure/shuttle/part/dropship_wy/right_outer_wing_connector
	icon_state = "4"

/obj/structure/shuttle/part/dropship_wy/transparent/left_outer_bottom_wing
	icon_state = "1"

/obj/structure/shuttle/part/dropship_wy/transparent/left_outer_inner_wing
	icon_state = "2"

/obj/structure/shuttle/part/dropship_wy/transparent/right_inner_bottom_wing
	icon_state = "5"

/obj/structure/shuttle/part/dropship_wy/transparent/right_outer_bottom_wing
	icon_state = "6"

/obj/structure/shuttle/part/dropship_wy/transparent/left_engine
	icon_state = "leftengine_1"

/obj/structure/shuttle/part/dropship_wy/transparent/right_engine
	icon_state = "rightengine_1"

// CLF Ship

/obj/structure/shuttle/part/dropship_clf
	name = "\improper UD-9M 'Dogbite'"
	desc = "The UD-9M 'Dogbite' is a repurposed utility dropship, originally designed for short-haul cargo operations across colonial systems. Stolen and heavily modified by the Colonial Liberation Front, it's now a rugged smuggler and strike craft, capable of dropping a full fireteam through tight patrol nets. Its hull is scarred with gunfire, rust, and graffiti — a patchwork of rebellion held together by grit and stolen parts."
	icon = 'icons/turf/dropship_clf.dmi'
	icon_state = "1"

/obj/structure/shuttle/part/dropship_clf/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/dropship_clf/transparent
	opacity = FALSE

/obj/structure/shuttle/part/dropship_clf/transparent/nose_top_right
	icon_state = "102"

/obj/structure/shuttle/part/dropship_clf/transparent/nose_center
	icon_state = "101"

/obj/structure/shuttle/part/dropship_clf/transparent/nose_top_left
	icon_state = "100"

/obj/structure/shuttle/part/dropship_clf/nose_front_left
	icon_state = "95"

/obj/structure/shuttle/part/dropship_clf/nose_front_right
	icon_state = "99"

/obj/structure/shuttle/part/dropship_clf/transparent/inner_right_weapons
	icon_state = "90"

/obj/structure/shuttle/part/dropship_clf/transparent/outer_right_weapons
	icon_state = "91"

/obj/structure/shuttle/part/dropship_clf/transparent/inner_left_weapons
	icon_state = "85"

/obj/structure/shuttle/part/dropship_clf/transparent/outer_left_weapons
	icon_state = "84"

/obj/structure/shuttle/part/dropship_clf/transparent/upper_right_wing
	icon_state = "74"

/obj/structure/shuttle/part/dropship_clf/transparent/middle_right_wing
	icon_state = "70"

/obj/structure/shuttle/part/dropship_clf/transparent/lower_right_wing
	icon_state = "65"

/obj/structure/shuttle/part/dropship_clf/transparent/upper_left_wing
	icon_state = "71"

/obj/structure/shuttle/part/dropship_clf/transparent/middle_left_wing
	icon_state = "66"

/obj/structure/shuttle/part/dropship_clf/transparent/lower_left_wing
	icon_state = "61"

/obj/structure/shuttle/part/dropship_clf/lower_left_wall
	icon_state = "46"

/obj/structure/shuttle/part/dropship_clf/lower_right_wall
	icon_state = "49"

/obj/structure/shuttle/part/dropship_clf/transparent/engine_left_cap
	icon_state = "40"

/obj/structure/shuttle/part/dropship_clf/transparent/engine_right_cap
	icon_state = "41"

/obj/structure/shuttle/part/dropship_clf/transparent/engine_left_exhaust
	icon_state = "16"

/obj/structure/shuttle/part/dropship_clf/transparent/engine_right_exhaust
	icon_state = "17"

/obj/structure/shuttle/part/dropship_clf/bottom_left_wall
	icon_state = "9"

/obj/structure/shuttle/part/dropship_clf/bottom_right_wall
	icon_state = "15"

/obj/structure/shuttle/part/dropship_clf/left_inner_wing_connector
	icon_state = "7"

/obj/structure/shuttle/part/dropship_clf/right_inner_wing_connector
	icon_state = "8"

/obj/structure/shuttle/part/dropship_clf/left_outer_wing_connector
	icon_state = "3"

/obj/structure/shuttle/part/dropship_clf/right_outer_wing_connector
	icon_state = "4"

/obj/structure/shuttle/part/dropship_clf/transparent/left_outer_bottom_wing
	icon_state = "1"

/obj/structure/shuttle/part/dropship_clf/transparent/left_outer_inner_wing
	icon_state = "2"

/obj/structure/shuttle/part/dropship_clf/transparent/right_inner_bottom_wing
	icon_state = "5"

/obj/structure/shuttle/part/dropship_clf/transparent/right_outer_bottom_wing
	icon_state = "6"

/obj/structure/shuttle/part/dropship_clf/transparent/left_engine
	icon_state = "leftengine_1"

/obj/structure/shuttle/part/dropship_clf/transparent/right_engine
	icon_state = "rightengine_1"

// ERT Ship

/obj/structure/shuttle/part/ert
	name = "wall"
	icon = 'icons/turf/ert_shuttle.dmi'
	icon_state = "stan4"
	opacity = TRUE

/obj/structure/shuttle/part/ert/ex_act(severity, direction)
	return FALSE

/obj/structure/shuttle/part/ert/transparent
	opacity = FALSE

/obj/structure/shuttle/part/ert/front_left_stan
	icon_state = "stan20"

/obj/structure/shuttle/part/ert/front_right_stan
	icon_state = "stan25"

/obj/structure/shuttle/part/ert/front_left_upp
	icon_state = "upp20"

/obj/structure/shuttle/part/ert/front_right_upp
	icon_state = "upp25"

/obj/structure/shuttle/part/ert/front_left_wy
	icon_state = "wy20"

/obj/structure/shuttle/part/ert/front_right_wy
	icon_state = "wy25"

/obj/structure/shuttle/part/ert/front_left_twe
	icon_state = "twe20"

/obj/structure/shuttle/part/ert/front_right_twe
	icon_state = "twe25"

/obj/structure/shuttle/part/ert/transparent/left_engine
	icon_state = "leftengine_1"

/obj/structure/shuttle/part/ert/transparent/right_engine
	icon_state = "rightengine_1"
