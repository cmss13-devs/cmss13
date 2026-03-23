// Areas

/area/shuttle/pelican
	name = "\improper D77H-TCE \"Pelican\" dropship"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	soundscape_interval = 30
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL


/area/shuttle/pelican/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE


/area/shuttle/pelican/echo
	name = "\improper D77H-TCE \"Pelican\" dropship Echo-530"


/area/shuttle/pelican/sierra
	name = "\improper D77H-TCE \"Pelican\" dropship Sierra-822"


/area/shuttle/pelican/whiskey
	name = "\improper D77H-TCE \"Pelican\" dropship Whiskey-194"



// Weapons Computers

/obj/structure/machinery/computer/dropship_weapons/pelican
	name = "\improper D77H-TCE \"Pelican\" dropship weapons controls"
	icon = 'icons/halo/obj/structures/machinery/64x64computer.dmi'
	icon_state = "pelican_shooty"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_FLIGHT)
	firemission_envelope = new /datum/cas_fire_envelope/uscm_dropship()
	density = FALSE
	layer = 4.1


/obj/structure/machinery/computer/dropship_weapons/pelican/echo
	name = "\improper D77H-TCE \"Pelican\" Echo-530 dropship weapons controls"
	shuttle_tag = DROPSHIP_PELICAN_ECHO


/obj/structure/machinery/computer/dropship_weapons/pelican/sierra
	name = "\improper D77H-TCE \"Pelican\" Sierra-822 dropship weapons controls"
	shuttle_tag = DROPSHIP_PELICAN_SIERRA


/obj/structure/machinery/computer/dropship_weapons/pelican/whiskey
	name = "\improper D77H-TCE \"Pelican\" Whiskey-194 dropship weapons controls"
	shuttle_tag = DROPSHIP_PELICAN_WHISKEY



// Flight Computers


/obj/structure/machinery/computer/shuttle/dropship/flight/pelican
	icon = 'icons/halo/obj/structures/machinery/64x64computer.dmi'
	icon_state = "pelican_drive"



// Transit Turf

/turf/open/space/transit/dropship/pelican
	dir = SOUTH


/turf/open/space/transit/dropship/pelican/echo
	shuttle_tag = DROPSHIP_PELICAN_ECHO


/turf/open/space/transit/dropship/pelican/sierra
	shuttle_tag = DROPSHIP_PELICAN_SIERRA


/turf/open/space/transit/dropship/pelican/whiskey
	shuttle_tag = DROPSHIP_PELICAN_WHISKEY



// Docking ports
// Mobile

/obj/docking_port/mobile/marine_dropship/pelican
	name = "D77H-TCE \"Pelican\" dropship"
	width = 21
	height = 25

	dwidth = 10
	dheight = 17

	callTime = 50 SECONDS
	rechargeTime = 1 MINUTES
	ignitionTime = DROPSHIP_WARMUP_TIME
	prearrivalTime = DROPSHIP_WARMUP_TIME


/obj/docking_port/mobile/marine_dropship/pelican/get_transit_path_type()
	return /turf/open/space/transit/dropship/pelican


/obj/docking_port/mobile/marine_dropship/pelican/echo
	name = "D77H-TCE \"Pelican\" dropship Echo-530"
	id = DROPSHIP_PELICAN_ECHO


/obj/docking_port/mobile/marine_dropship/pelican/echo/get_transit_path_type()
	return /turf/open/space/transit/dropship/pelican/echo


/obj/docking_port/mobile/marine_dropship/pelican/sierra
	name = "D77H-TCE \"Pelican\" dropship Sierra-822"
	id = DROPSHIP_PELICAN_SIERRA


/obj/docking_port/mobile/marine_dropship/pelican/sierra/get_transit_path_type()
	return /turf/open/space/transit/dropship/pelican/sierra


/obj/docking_port/mobile/marine_dropship/pelican/whiskey
	name = "D77H-TCE \"Pelican\" dropship Whiskey-194"
	id = DROPSHIP_PELICAN_WHISKEY


/obj/docking_port/mobile/marine_dropship/pelican/whiskey/get_transit_path_type()
	return /turf/open/space/transit/dropship/pelican/whiskey


// Stationary

/obj/docking_port/stationary/marine_dropship/pelican_lz
	name = "Pelican LZ"
	auto_open = TRUE
	height = 25
	width = 21
	dheight = 17
	dwidth = 10


/obj/docking_port/stationary/marine_dropship/pelican_lz/hangar1
	name = "UNSC Valley Forge Hangar Bay 1"
	id = ALMAYER_DROPSHIP_LZ1
	roundstart_template = /datum/map_template/shuttle/echo


/obj/docking_port/stationary/marine_dropship/pelican_lz/hangar2
	name = "UNSC Valley Forge Hangar Bay 2"
	id = ALMAYER_DROPSHIP_LZ2
	roundstart_template = /datum/map_template/shuttle/sierra



// Map Templates

/datum/map_template/shuttle/echo
	name = "D77H-TCE \"Pelican\" dropship Echo-530"
	shuttle_id = DROPSHIP_PELICAN_ECHO


/datum/map_template/shuttle/sierra
	name = "D77H-TCE \"Pelican\" dropship Sierra-822"
	shuttle_id = DROPSHIP_PELICAN_SIERRA


/datum/map_template/shuttle/whiskey
	name = "D77H-TCE \"Pelican\" dropship Whiskey-194"
	shuttle_id = DROPSHIP_PELICAN_WHISKEY



// Turfs
// Walls

/obj/structure/shuttle/part/pelican
	name = "D77H-TCE \"Pelican\" dropship"
	desc = "A D77H-TCE \"Pelican\" dropship, used by all branches of the UNSC. This one belongs to the \"troop carrier\" family of dropships. Being the TCE variant, this pelican comes with additional seating so that it may fit an entire squad, with the sacrifice of no capability for DCC personnel being aboard in most cases."
	icon = 'icons/halo/turf/pelican.dmi'
	icon_state = null
	layer = 2.02


/obj/structure/shuttle/part/pelican/no_dense
	density = FALSE

/obj/structure/shuttle/part/pelican/no_dense/opacity_false
	opacity = FALSE

/obj/structure/shuttle/part/pelican/opacity_false
	opacity = FALSE

/obj/structure/shuttle/part/pelican/directional_density
	flags_atom = ON_BORDER

// Floors

/turf/open/shuttle/pelican
	name = "D77H-TCE \"Pelican\" dropship flooring"
	desc = "Flooring belonging to a D77H-TCE \"Pelican\" dropship."
	icon = 'icons/halo/turf/pelican_floors.dmi'
	icon_state = "plating"

/turf/open/shuttle/pelican/cockpit_seat
	icon_state = "cockpit_seat"

/turf/open/shuttle/pelican/directional/south
	icon_state = "plating_alt"
	dir = SOUTH

/turf/open/shuttle/pelican/directional/north
	icon_state = "plating_alt"
	dir = NORTH

/turf/open/shuttle/pelican/directional/east
	icon_state = "plating_alt"
	dir = EAST

/turf/open/shuttle/pelican/directional/west
	icon_state = "plating_alt"
	dir = WEST

/turf/open/shuttle/pelican/paneling
	icon_state = "paneling"

/turf/open/shuttle/pelican/paneling/left
	dir = EAST

/turf/open/shuttle/pelican/paneling/right
	dir = WEST

/turf/open/shuttle/pelican/paneling/sideways
	dir = NORTH

/turf/open/shuttle/pelican/paneling/smooth
	icon_state = "smooth_paneling"



// Doors
// Cockpit

/obj/structure/machinery/door/airlock/hatch/unsc/pelican/cockpit
	name = "\improper D77H-TCE \"Pelican\" cockpit door"
	desc = "The cockpit door to a pelican."
	icon = 'icons/halo/obj/structures/doors/pelican_cockpit.dmi'
	openspeed = 7
	req_access = list(ACCESS_MARINE_DROPSHIP)
	req_one_access = list()
	unslashable = TRUE
	unacidable = TRUE
	no_panel = TRUE
	not_weldable = TRUE
	glass = TRUE
	opacity = FALSE


/obj/structure/machinery/door/airlock/hatch/unsc/pelican/cockpit/echo
	name = "\improper D77H-TCE \"Pelican\" Echo-530 cockpit door"


/obj/structure/machinery/door/airlock/hatch/unsc/pelican/cockpit/sierra
	name = "\improper D77H-TCE \"Pelican\" Siera-822 cockpit door"


/obj/structure/machinery/door/airlock/hatch/unsc/pelican/cockpit/whiskey
	name = "\improper D77H-TCE \"Pelican\" Whiskey-194 cockpit door"


// Rear

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/pelican
	name = "\improper D77H-TCE \"Pelican\" rear hatch"
	desc = "The rear hatch to a pelican."
	icon = 'icons/halo/obj/structures/doors/pelican_hatch.dmi'

	id = "aft_door"
	opacity = FALSE
	openspeed = 7
	width = 4
	glass = TRUE
	pixel_y = -32
	layer = 3.1
	open_layer = 3.1
	closed_layer = 3.1


/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/pelican/echo
	name = "\improper D77H-TCE \"Pelican\" Echo-530 rear hatch"


/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/pelican/sierra
	name = "\improper D77H-TCE \"Pelican\" Sierra-822 rear hatch"


/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/pelican/whiskey
	name = "\improper D77H-TCE \"Pelican\" Whiskey-194 rear hatch"



// Special Chairs

/obj/structure/bed/chair/dropship/pelican
	name = "pelican seat"
	desc = "A sturdy metal chair with a brace that lowers over your body. Holds you in place during high altitude drops and high-G maneuvers."
	icon = 'icons/halo/obj/objects.dmi'
	icon_state = "pelican_seat"
	var/image/chairbar = null
	buildstacktype = 0
	unslashable = TRUE
	unacidable = TRUE
	buckling_sound = 'sound/effects/metal_close.ogg'


/obj/structure/bed/chair/dropship/pelican/east
	dir = EAST
	buckling_x = 3


/obj/structure/bed/chair/dropship/pelican/west
	dir = WEST
	buckling_x = -3


/obj/structure/bed/chair/dropship/pelican/handle_rotation()
	if(dir == NORTH)
		layer = north_layer
	else
		layer = non_north_layer
	if(buckled_mob)
		buckled_mob.setDir(dir)


/obj/structure/bed/chair/dropship/pelican/Initialize()
	. = ..()
	chairbar = image('icons/halo/obj/objects.dmi', "hotseat_bars")
	chairbar.layer = 4.2


/obj/structure/bed/chair/dropship/pelican/afterbuckle()
	. = ..()
	if(buckled_mob)
		icon_state = initial(icon_state) + "_buckled"
		overlays += chairbar
		if(dir == NORTH)
			buckled_mob.layer = north_layer - 0.1
		else
			buckled_mob.layer = layer + 0.01
	else
		icon_state = initial(icon_state)
		overlays -= chairbar


/obj/structure/bed/chair/dropship/pelican/unbuckle()
	if(buckled_mob && buckled_mob.buckled == src)
		buckled_mob.layer = MOB_LAYER
	return ..()



// Props and Roof

/obj/structure/platform/pelican
	name = "tandem seat steps"
	icon = 'icons/halo/obj/structures/pelican_structures.dmi'
	icon_state = "platform"
	dir = WEST
	plane = FLOOR_PLANE

/obj/structure/prop/pelican_holotank
	name = "pelican holotank"
	desc = "A small holotank capable of projecting a hologram, and rarely the avatar of an AI."
	icon = 'icons/halo/obj/structures/pelican_structures.dmi'
	icon_state = "holotank"

/obj/structure/roof/pelican_roof
	icon = 'icons/halo/obj/structures/pelican.dmi'
	icon_state = "pelican"
	unslashable = TRUE
	unacidable = TRUE
	lazy_nodes = FALSE
	mouse_opacity = FALSE
	plane = 900
	alpha = 255
	pixel_y = -413
	pixel_x = -320

/obj/structure/roof/pelican_roof/ex_act(severity, direction)
	return

/obj/structure/roof/pelican_roof/Initialize()
	. = ..()
	normal_image = image(icon, src, "cutout-alt2", layer = layer)
	under_image = image(icon, src, "cutout", layer = layer)
	under_image.plane = 900
	normal_image.plane = 900
	under_image.alpha = 75


/obj/effect/roof_node/pelican
	icon = 'icons/halo/landmarks.dmi'
	icon_state = "roof"



// Directional Invis Wall

/obj/structure/blocker/invisible_wall/directional
	name = "directional blocker"
	icon_state = "invisible_wall_directional"
	flags_atom = ON_BORDER



// Intercoms

/obj/item/device/radio/intercom/pelican/echo
	name = "pelican Echo-530 intercom"
	frequency = DSP1_FREQ

/obj/item/device/radio/intercom/pelican/sierra
	name = "pelican Sierra-522 intercom"
	frequency = DSP2_FREQ

/obj/item/device/radio/intercom/pelican/whiskey
	name = "pelican Whiskey-194 intercom"
	frequency = DSP3_FREQ



// Weapon Hardpoints
// Echo

/obj/effect/attach_point/weapon/pelican_echo
	ship_tag = DROPSHIP_PELICAN_ECHO


/obj/effect/attach_point/weapon/pelican_echo/left_wing
	name = "port wing weapon attach point"
	icon_state = "equip_base_l_wing"
	attach_id = 1
	dir = WEST
	firing_arc_min = -3
	firing_arc_max =  3
	transverse  = -3
	long    =  0


/obj/effect/attach_point/weapon/pelican_echo/left_fore
	name = "port fore weapon attach point"
	attach_id = 2
	dir = NORTH
	firing_arc_min = -6
	firing_arc_max =  0
	transverse  =  0
	long    =  0


/obj/effect/attach_point/weapon/pelican_echo/right_fore
	name = "starboard fore weapon attach point"
	attach_id = 3
	dir = NORTH
	firing_arc_min =  0
	firing_arc_max =  6
	transverse  =  0
	long    =  0


/obj/effect/attach_point/weapon/pelican_echo/right_wing
	name = "starboard wing weapon attach point"
	icon_state = "equip_base_r_wing";
	attach_id = 4
	dir = EAST
	firing_arc_min = -3
	firing_arc_max =  3
	transverse  =  3
	long    =  0


/obj/effect/attach_point/electronics/pelican_echo
	ship_tag = DROPSHIP_PELICAN_ECHO


/obj/effect/attach_point/electronics/pelican_echo/left
	attach_id = 5


/obj/effect/attach_point/electronics/pelican_echo/right
	attach_id = 6


/obj/effect/attach_point/fuel/pelican_echo
	ship_tag = DROPSHIP_PELICAN_ECHO
	layer = 4.13

// Sierra

/obj/effect/attach_point/weapon/pelican_sierra
	ship_tag = DROPSHIP_PELICAN_SIERRA


/obj/effect/attach_point/weapon/pelican_sierra/left_wing
	name = "port wing weapon attach point"
	icon_state = "equip_base_l_wing"
	attach_id = 1
	dir = WEST
	firing_arc_min = -3
	firing_arc_max =  3
	transverse  = -3
	long    =  0


/obj/effect/attach_point/weapon/pelican_sierra/left_fore
	name = "port fore weapon attach point"
	attach_id = 2
	dir = NORTH
	firing_arc_min = -6
	firing_arc_max =  0
	transverse  =  0
	long    =  0


/obj/effect/attach_point/weapon/pelican_sierra/right_fore
	name = "starboard fore weapon attach point"
	attach_id = 3
	dir = NORTH
	firing_arc_min =  0
	firing_arc_max =  6
	transverse  =  0
	long    =  0


/obj/effect/attach_point/weapon/pelican_sierra/right_wing
	name = "starboard wing weapon attach point"
	icon_state = "equip_base_r_wing";
	attach_id = 4
	dir = EAST
	firing_arc_min = -3
	firing_arc_max =  3
	transverse  =  3
	long    =  0


/obj/effect/attach_point/electronics/pelican_sierra
	ship_tag = DROPSHIP_PELICAN_SIERRA


/obj/effect/attach_point/electronics/pelican_sierra/left
	attach_id = 5


/obj/effect/attach_point/electronics/pelican_sierra/right
	attach_id = 6


/obj/effect/attach_point/fuel/pelican_sierra
	ship_tag = DROPSHIP_PELICAN_SIERRA
	layer = 4.13

// Whiskey

/obj/effect/attach_point/weapon/pelican_whiskey
	ship_tag = DROPSHIP_PELICAN_WHISKEY


/obj/effect/attach_point/weapon/pelican_whiskey/left_wing
	name = "port wing weapon attach point"
	icon_state = "equip_base_l_wing"
	attach_id = 1
	dir = WEST
	firing_arc_min = -3
	firing_arc_max =  3
	transverse  = -3
	long    =  0


/obj/effect/attach_point/weapon/pelican_whiskey/left_fore
	name = "port fore weapon attach point"
	attach_id = 2
	dir = NORTH
	firing_arc_min = -6
	firing_arc_max =  0
	transverse  =  0
	long    =  0


/obj/effect/attach_point/weapon/pelican_whiskey/right_fore
	name = "starboard fore weapon attach point"
	attach_id = 3
	dir = NORTH
	firing_arc_min =  0
	firing_arc_max =  6
	transverse  =  0
	long    =  0


/obj/effect/attach_point/weapon/pelican_whiskey/right_wing
	name = "starboard wing weapon attach point"
	icon_state = "equip_base_r_wing";
	attach_id = 4
	dir = EAST
	firing_arc_min = -3
	firing_arc_max =  3
	transverse  =  3
	long    =  0


/obj/effect/attach_point/electronics/pelican_whiskey
	ship_tag = DROPSHIP_PELICAN_WHISKEY


/obj/effect/attach_point/electronics/pelican_whiskey/left
	attach_id = 5


/obj/effect/attach_point/electronics/pelican_whiskey/right
	attach_id = 6


/obj/effect/attach_point/fuel/pelican_whiskey
	ship_tag = DROPSHIP_PELICAN_WHISKEY
	layer = 4.13
