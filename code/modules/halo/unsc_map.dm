// wall define
#define WALL_UNSC "unsc"

// doors
/obj/structure/machinery/door/poddoor/two_tile/four_tile/halo
	name = "heavy blast door"
	desc = "A heavy blast door meant to secure areas or provide wide access through a singular entrance."
	icon = 'icons/halo/obj/structures/doors/podlocks/4x1_blast_hor.dmi'
	icon_state = "blast1"
	base_icon_state = "blast"

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical/halo
	name = "heavy blast door"
	desc = "A heavy blast door meant to secure areas or provide wide access through a singular entrance."
	icon = 'icons/halo/obj/structures/doors/podlocks/4x1_blast_vert.dmi'
	icon_state = "blast1"
	base_icon_state = "blast"

/obj/structure/machinery/door/poddoor/two_tile/four_tile/five_tile
	name = "heavy blast door"
	desc = "A heavy blast door meant to secure areas or provide wide access through a singular entrance."
	icon = 'icons/halo/obj/structures/doors/podlocks/5x1_blast_hor.dmi'
	icon_state = "blast1"
	base_icon_state = "blast"
	var/obj/structure/machinery/door/poddoor/filler_object/f5

/obj/structure/machinery/door/poddoor/two_tile/four_tile/five_tile/Initialize()
	. = ..()
	f5 = new/obj/structure/machinery/door/poddoor/filler_object (get_step(f4,dir))
	f5.density = density
	f5.set_opacity(opacity)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/five_tile/Destroy()
	QDEL_NULL(f5)
	return ..()


/obj/structure/machinery/door/poddoor/two_tile/four_tile/five_tile/start_opening()
	. = ..()
	f5.set_opacity(0)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/five_tile/open_fully()
	. = ..()
	f5.density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/five_tile/start_closing()
	. = ..()
	f5.density = TRUE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/five_tile/close_fully()
	. = ..()
	f5.set_opacity(initial(opacity))

/obj/structure/machinery/door/airlock/multi_tile/unsc
	name = "\improper airlock"
	icon = 'icons/halo/obj/structures/doors/2x1_standard.dmi'
	openspeed = 8

/obj/structure/machinery/door/airlock/multi_tile/unsc/glass
	icon = 'icons/halo/obj/structures/doors/2x1_standard_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/unsc/blast_door
	name = "\improper blast door"
	icon = 'icons/halo/obj/structures/doors/3x1_standard.dmi'
	width = 3
	openspeed = 10

/obj/structure/machinery/door/airlock/multi_tile/unsc/blast_door/glass
	opacity = FALSE
	glass = TRUE
	icon = 'icons/halo/obj/structures/doors/3x1_standard_glass.dmi'


// UNSC airlocks

/obj/structure/machinery/door/airlock/unsc
	name = "\improper airlock"
	icon = 'icons/halo/obj/structures/doors/standard.dmi'
	opacity = TRUE
	glass = FALSE
	openspeed = 6


/obj/structure/machinery/door/airlock/unsc/glass
	icon = 'icons/halo/obj/structures/doors/standard_glass.dmi'
	opacity = FALSE
	glass = TRUE



// cryopods
/obj/structure/machinery/cryopod/big
	icon = 'icons/obj/structures/machinery/hypersleep.dmi'
	icon_state = "hypersleep_base"
	dir = EAST
	var/image/occupant_image
	var/occupant_angle = 270
	var/occupant_dir = 4
	var/occupant_x = 6
	var/occupant_y = 0

/obj/structure/machinery/cryopod/big/Initialize()
	. = ..()
	var/cover_image = image(icon, icon_state = "cover_fog", layer = 3.22)
	overlays += cover_image

/obj/structure/machinery/cryopod/big/update_icon()
	return

/obj/structure/machinery/cryopod/big/go_in_cryopod(mob/living/mob, silent = FALSE)
	..()
	overlays.Cut()
	occupant_image = image(mob.appearance, loc, layer = 3.21)
	occupant_image.pixel_x = occupant_x
	occupant_image.pixel_y = occupant_y
	occupant_image.dir = occupant_dir
	if(mob.body_position == STANDING_UP)
		occupant_image.transform = occupant.transform.Turn(occupant_angle)
	overlays += occupant_image
	var/cover_image = image(icon, icon_state = "cover", layer = 3.22)
	overlays += cover_image

/obj/structure/machinery/cryopod/big/go_out()
	..()
	overlays -= occupant_image
	occupant_image = null

/obj/structure/machinery/cryopod/big/despawn_occupant()
	..()
	overlays.Cut()
	occupant_image = null
	var/cover_image = image(icon, icon_state = "cover_fog", layer = 3.22)
	overlays += cover_image

/obj/structure/machinery/cryopod/big/flipped
	dir = WEST
	occupant_angle = 90
	occupant_dir = 8
	occupant_x = 10

// halo cryo

/obj/structure/machinery/cryopod/big/halo
	name = "cryo pod"
	icon = 'icons/halo/obj/structures/machinery/64x64cryogenics.dmi'
	icon_state = "map_tool"
	dir = WEST
	bound_height = 64
	bound_width = 64
	occupant_angle = 65
	occupant_x = 16
	occupant_y = 8

/obj/structure/machinery/cryopod/big/halo/flipped
	dir = EAST
	bound_x = -32
	pixel_x = -32
	occupant_angle = 295
	occupant_x = 16
	occupant_y = 8

/obj/structure/machinery/cryopod/big/halo/Initialize()
	. = ..()
	icon_state = "cryo_base"

// vendors

/obj/structure/machinery/vending/dinnerware/unsc
	name = "\improper military utensils dispenser"
	desc = "Paired with the food dispenser, the utensils machine is a much more simplistic design and only requires manual restocking."
	icon = 'icons/halo/obj/structures/machinery/vending.dmi'
	icon_state = "unsc_dinnerware"
	icon_vend = "unsc_dinnerware_vend"
	icon_deny = "unsc_dinnerware_deny"
	tiles_with = list(
		/obj/structure/window/framed/unsc,
		/obj/structure/machinery/door/airlock,
		/turf/closed/wall/unsc,
	)

// decals

/obj/effect/decal/unsc
	name = "informative decal"
	icon = 'icons/halo/effects/area_signs.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	unacidable = TRUE

/obj/effect/decal/unsc/armory
	icon_state = "armory"

/obj/effect/decal/unsc/commons
	icon_state = "commons"

/obj/effect/decal/unsc/infirmary
	icon_state = "infirmary"

/obj/effect/decal/unsc/umbilicals
	icon_state = "umbilicals"

/obj/effect/decal/unsc/tram
	icon_state = "tram"

/obj/effect/decal/unsc/shipping
	icon_state = "shipping"

/obj/effect/decal/unsc/security
	icon_state = "security"

/obj/effect/decal/unsc/recreation
	icon_state = "recreation"

/obj/effect/decal/unsc/maint
	icon_state = "maint"

/obj/effect/decal/unsc/lifepods
	icon_state = "lifepods"

/obj/effect/decal/unsc/hangar
	icon_state = "hangar"

/obj/effect/decal/unsc/firecontrol
	icon_state = "firecontrol"

/obj/effect/decal/unsc/engi
	icon_state = "engi"

/obj/effect/decal/unsc/airlock
	icon_state = "airlock"

/obj/effect/decal/unsc/bridge
	icon_state = "bridge"

/obj/effect/decal/unsc/cryo
	icon_state = "cryo"

/obj/effect/decal/unsc/cryo/a
	icon_state = "cryo_a"

/obj/effect/decal/unsc/cryo/b
	icon_state = "cryo_b"

/obj/effect/decal/unsc/cryo/c
	icon_state = "cryo_c"

// toolbox

/obj/item/storage/toolbox/traxus
	name = "traxus toolbox"
	desc = "A large red toolbox rounded at the top capable of holding a variety of tools and equipment for all manners of tasks. This one is produced by Traxus Heavy Industries and looks fairly...robust."
	icon = 'icons/halo/obj/items/storage/toolbox.dmi'
	icon_state = "traxus"
	force = 6
	storage_slots = 8

/obj/item/storage/toolbox/traxus/fill_preset_inventory()
	var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/stack/cable_coil(src,30,color)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/device/multitool(src)

/obj/item/storage/toolbox/traxus/alt
	desc = "A large red toolbox with an angular top capable of holding a variety of tools and equipment for all manners of tasks. This one is produced by Traxus Heavy Industries and looks fairly...robust."
	icon_state = "traxus_2"

/obj/item/storage/toolbox/traxus/big
	name = "traxus toolbox"
	desc = "A large red toolbox rounded at the top capable of holding a variety of tools and equipment for all manners of tasks. This one is produced by Traxus Heavy Industries and looks fairly...robust."
	icon = 'icons/halo/obj/items/storage/toolbox.dmi'
	icon_state = "traxus_big"
	force = 8
	throw_range = 3
	storage_slots = 10

/obj/item/storage/toolbox/traxus/big/fill_preset_inventory()
	var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/stack/cable_coil(src,30,color)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/device/multitool(src)
	new /obj/item/circuitboard/apc(src)
	new /obj/item/device/flashlight(src)

// crate

/obj/structure/closet/crate/supply
	name = "supply crate"
	desc = "A supply crate."
	icon_state = "closed_supply"
	icon_opened = "open_supply"
	icon_closed = "closed_supply"

//------------- UNSC CRATES -------------

/obj/structure/closet/crate/unsc
	name = "UNSC supply crate"
	desc = "Standard issue supply crate for UNSC forces capable of storing a variety of objects."
	icon = 'icons/halo/obj/structures/crates.dmi'
	icon_state = "closed_unsc"
	icon_opened = "open_unsc"
	icon_closed = "closed_unsc"

// containers

// unsc containers

/obj/structure/cargo_container/unsc
	name = "UNSC cargo container"
	desc = "A large olive drab cargo container. It's intended to store a whole lot of anything you can think of with a loading dock on one end and a pair of doors on the other."
	icon = 'icons/halo/obj/structures/props/containers.dmi'
	icon_state = "main_1"
	density = TRUE
	health = 400
	opacity = FALSE
	layer = 5

// container 1

/obj/structure/cargo_container/unsc/main_1
	icon_state = "main_1a"

/obj/structure/cargo_container/unsc/main_1/b
	icon_state = "main_1b"

/obj/structure/cargo_container/unsc/main_1/c
	icon_state = "main_1c"

/obj/structure/cargo_container/unsc/main_1/d
	icon_state = "main_1d"

/obj/structure/cargo_container/unsc/main_1/e
	icon_state = "main_1e"

// container 2

/obj/structure/cargo_container/unsc/main_2
	icon_state = "main_2a"

/obj/structure/cargo_container/unsc/main_2/b
	icon_state = "main_2b"

/obj/structure/cargo_container/unsc/main_2/c
	icon_state = "main_2c"

/obj/structure/cargo_container/unsc/main_2/d
	icon_state = "main_2d"

// container 3

/obj/structure/cargo_container/unsc/main_3
	icon_state = "main_3a"

/obj/structure/cargo_container/unsc/main_3/b
	icon_state = "main_3b"

/obj/structure/cargo_container/unsc/main_3/c
	icon_state = "main_3c"

/obj/structure/cargo_container/unsc/main_3/d
	icon_state = "main_3d"

/obj/structure/cargo_container/unsc/vertical // ACTUALLY THE RIGHT THING!!! NOOOT HORIZONTAL, ITS VEEERTICAL. HORIZONTAL IS LIKE HORIIIZON. VERTICAL IS LIKE WOOOOW THATS A REAL VERTICAL CLIFF. STUPID FUCKING CM DEV 9 YEARS AGO.
	bound_width = 64
	bound_height = 32

/obj/structure/cargo_container/unsc/vertical/south_1
	icon_state = "south_1"
	bound_height = 64

/obj/structure/cargo_container/unsc/vertical/south_1/alt
	icon_state = "south_1b"

/obj/structure/cargo_container/unsc/vertical/south_2
	icon_state = "south_2"

/obj/structure/cargo_container/unsc/vertical/south_3
	icon_state = "south_3"

/obj/structure/cargo_container/unsc/vertical/south_3/endcap_1
	icon_state = "south_3b"

/obj/structure/cargo_container/unsc/vertical/south_3/endcap_2
	icon_state = "south_3c"

/obj/structure/cargo_container/unsc/vertical/south_4
	icon_state = "south_4"

// props

// unsc prop

/obj/structure/prop/unsc_crate
	name = "UNSC crate"
	desc = "A military-grade crate. It doesn't look easy to open. And it looks...pink. You shouldn't be seeing this."
	icon = 'icons/halo/obj/structures/props/crates.dmi'
	icon_state = null
	density = TRUE

/obj/structure/prop/unsc_crate/stack
	name = "secured UNSC supply crates"
	desc = "Two supply crates fastened to each other with a strap. If only the strap wasn't stuck on."
	icon = 'icons/halo/obj/structures/crates.dmi'
	icon_state = "cratestack"

/obj/structure/prop/unsc_crate/standard
	desc = "A military-grade crate. It doesn't look easy to open."
	icon_state = "c1_greyscale"

/obj/structure/prop/unsc_crate/standard/blue
	icon_state = "c1_blue"

/obj/structure/prop/unsc_crate/standard/red
	icon_state = "c1_red"

/obj/structure/prop/unsc_crate/standard/green
	icon_state = "c1_green"

/obj/structure/prop/unsc_crate/standard/medical
	icon_state = "c1_medical"

/obj/structure/prop/unsc_crate/corrugated
	desc = "A military-grade crate with corrugated paneling. It doesn't look easy to open."
	icon_state = "c2_greyscale"

/obj/structure/prop/unsc_crate/corrugated/blue
	icon_state = "c2_blue"

/obj/structure/prop/unsc_crate/corrugated/red
	icon_state = "c2_red"

/obj/structure/prop/unsc_crate/corrugated/green
	icon_state = "c2_green"

/obj/structure/prop/unsc_crate/big
	name = "UNSC crate"
	desc = "A large military-grade crate. It doesn't look easy to open."
	icon = 'icons/halo/obj/structures/props/64x64crates.dmi'
	icon_state = "crate"
	bound_height = 64
	pixel_x = -5

/obj/structure/prop/unsc_crate/big/stack
	name = "UNSC crates"
	desc = "A stack of large military-grade crates. They don't look easy to open."
	icon_state = "pile"
	pixel_x = -3

/obj/structure/prop/unsc_crate/big/stack/alt
	icon_state = "pile2"

/obj/structure/reagent_dispensers/watertank/unsc
	name = "water barrel"
	desc = "An olive drab barrel containing water. Better not mix it up with the hydrogen tank."
	icon = 'icons/halo/obj/objects.dmi'
	icon_state = "barrel_water"
	anchored = TRUE

/obj/structure/reagent_dispensers/fueltank/liquidhydrogen
	name = "liquid hydrogen fuel barrel"
	desc = "A large barrel containing liquid hydrogen fuel, commonly used in vehicles and generators for power. A label on the front reads 'NOT FOR CONSUMPTION UNDERANY CIRCUMSTANCES'."
	icon = 'icons/halo/obj/objects.dmi'
	icon_state = "barrel_hydrogen"
	chemical = "liquidhydrogen"
	anchored = TRUE

/datum/reagent/hydrogen/liquid
	name = "Liquid Hydrogen"
	id = "liquidhydrogen"
	reagent_state = LIQUID

// window
/obj/structure/window/framed/unsc
	name = "reinforced window"
	desc = "A glass window with a special rod matrix inside a wall frame. It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/halo/turf/walls/unsc_window.dmi'
	icon_state = "unsc_window0"
	basestate = "unsc_window"
	health = 60
	reinf = TRUE
	window_frame = /obj/structure/window_frame/unsc

/obj/structure/window/framed/unsc/hull
	name = "hull window"
	desc = "A glass window with a special rod matrix inside a wall frame. This one was made out of exotic materials to prevent hull breaches. No way to get through here."
	//icon_state = "rwindow0_debug" //Uncomment to check hull in the map editor
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter

// window frame
// UNSC frames

/obj/structure/window_frame/unsc
	icon = 'icons/halo/turf/walls/unsc_window.dmi'
	icon_state = "unsc_window0_frame"
	basestate = "unsc_window"
	reinforced = TRUE
	window_type = /obj/structure/window/framed/unsc

// wall
/turf/closed/wall/unsc
	name = "interior ship wall"
	desc = "A bog-standard wall. It's not titanium-A, but it's pretty strong."
	icon = 'icons/halo/turf/walls/unsc.dmi'
	icon_state = "unsc"
	walltype = WALL_UNSC

/turf/closed/wall/unsc/reinforced
	name = "reinforced interior ship wall"
	icon_state = "unsc_reinforced"
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/unsc/reinforced/hull
	turf_flags = TURF_HULL
	icon_state = "unsc_hull"

/turf/closed/wall/unsc/reinforced/hull/titanium_a
	name = "Titanium-A hull plating"
	desc = "The best battle plating the UNSC has to offer to it's fleet of ships. It's starship grade and can take a helluva punch - nothing short of a ship to ship weapon is gonna puncture this."
	icon_state = "unsc_hull_ext"

// crewmon
/obj/structure/machinery/computer/crew/unsc
	faction = FACTION_MARINE

/obj/structure/machinery/computer/crew/unsc/alt
	icon_state = "cmonitor"
	density = FALSE

/obj/structure/machinery/computer/crew/unsc/big
	icon = 'icons/halo/obj/structures/machinery/64x64computer.dmi'
	bound_width = 64
