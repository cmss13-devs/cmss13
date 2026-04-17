/// HORDE MODE PROPS
/obj/structure/prop/horde_mode
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/horde_mode/ex_act(severity, direction)
	return

/obj/structure/prop/horde_mode/bullet_act(obj/projectile/bullet)
	bullet_ping(bullet)

/obj/structure/prop/horde_mode/tracks
	name = "tracks"
	icon = 'icons/effects/blood.dmi'
	icon_state = "tracks"

/obj/structure/prop/horde_mode/comms_relay
	name = "TC-3T static telecommunications tower"
	desc = "A static heavy-duty TC-3T telecommunications tower. Used to set up subspace communications lines between planetary and extra-planetary locations. Your last hope. "
	icon = 'icons/obj/structures/machinery/comm_tower3.dmi'
	icon_state = "static1"
	density = TRUE
	layer = ABOVE_XENO_LAYER

/obj/structure/prop/horde_mode/comms_relay/window_frame
	name = "window frame"
	icon = 'icons/turf/walls/window_frames.dmi'
	icon_state = "col_window0_frame"

/obj/structure/prop/horde_mode/light_fixture
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "tube1"
	layer = ABOVE_XENO_LAYER
	light_range = 5
	light_power = 2

/obj/structure/prop/horde_mode/light_fixture/Initialize(mapload, ...)
	. = ..()
	set_light(light_range, light_power, light_color)

/obj/structure/prop/horde_mode/light_fixture/yellow
	light_color = LIGHT_COLOR_ORANGE

/obj/structure/prop/horde_mode/light_fixture/blue
	icon_state = "btube1"
	light_color = LIGHT_COLOR_BLUE

/obj/structure/prop/horde_mode/light_fixture/small
	icon_state = "bulb1"
	light_range = 3
	light_power = 1

/obj/structure/prop/horde_mode/light_fixture/small/blue
	icon_state = "bbulb1"
	light_color = LIGHT_COLOR_BLUE

/obj/structure/prop/horde_mode/light_fixture/small/yellow
	light_color = LIGHT_COLOR_ORANGE

/obj/structure/prop/horde_mode/light_fixture/small/red
	icon_state = "firelight1"
	light_color = COLOR_VIVID_RED

/obj/structure/prop/horde_mode/light_fixture/small/purple
	color = COLOR_PURPLE
	light_color = LIGHT_COLOR_PURPLE

/obj/structure/prop/horde_mode
	icon = 'icons/obj/structures/props/misc.dmi'

/obj/structure/prop/horde_mode/chair
	name = "chair"
	icon = 'icons/obj/structures/props/furniture/chairs.dmi'
	icon_state = "chair"

/obj/structure/prop/horde_mode/smes
	name = "smes"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "smes"

/obj/structure/prop/horde_mode/reactor
	name = "reactor"
	icon = 'icons/obj/structures/machinery/geothermal.dmi'
	icon_state = "on-25"

/obj/structure/prop/horde_mode/reactor/Initialize(mapload, ...)
	. = ..()
	icon_state = pick("off", "on-10", "weld", "wire", "wrench", "on-25")

/obj/structure/prop/horde_mode/chair/on_ground
	name = "chair"
	icon = 'icons/obj/structures/props/furniture/chairs.dmi'
	icon_state = "folding_chair"

/obj/structure/prop/horde_mode/grave
	name = "grave"
	icon = 'icons/obj/structures/props/furniture/crosses.dmi'
	icon_state = "cross1"

/obj/structure/prop/horde_mode/grave/Initialize(mapload, ...)
	. = ..()
	var/image/dogtags = image(icon, "cross_overlay")
	var/obj/item/clothing/head/W = new /obj/item/clothing/head/helmet/marine(src)
	var/image/helmet = W.get_mob_overlay(null, WEAR_HEAD)
	qdel(W)
	helmet.pixel_y = -10
	overlays += list(dogtags, helmet)

/obj/structure/prop/horde_mode/burying_shovel
	name = "entrenching tool"
	desc = "It was a perfect day to die."
	icon_state = "entrenching_buried"

/obj/structure/prop/horde_mode/dirt_mound
	name = "dirt mound"
	desc = "...here rests in honored glory, an American soldier..."
	icon_state = "dirt_mound"

/obj/structure/prop/horde_mode/ascend_from_darkness
	name = "strange writing"
	desc = "Weird. You don't remember anyone from your squad writing this... is that blood?"
	icon = 'icons/obj/structures/props/64x64.dmi'
	icon_state = "ascend_from_darkness"

/obj/structure/prop/horde_mode/vent_spawn
	name = "vent"
	desc = "You wish you had a blowtorch. You really do."
	icon = 'icons/obj/pipes/vent_scrubber.dmi'
	icon_state = "map_vent"
	var/is_spawning = FALSE

/obj/structure/prop/horde_mode/vent_spawn/Initialize(mapload, ...)
	. = ..()
	SShorde_mode.vent_spawns += src
	var/area/horde_mode/current_area = get_area(src)
	current_area.vents_in_area += src

/obj/structure/prop/horde_mode/vent_spawn/proc/animate_vent()
	playsound(src, pick('sound/effects/alien_ventpass1.ogg', 'sound/effects/alien_ventpass2.ogg'), 50, 1, sound_range = 7)
	animate(src, pixel_x = rand(-2,2), pixel_y = rand(-2,2), time = 1 SECONDS, loop = 4, easing = JUMP_EASING)
	for(var/i = 1 to 4)
		animate(pixel_x = rand(-2,2), pixel_y = rand(-2,2), time = 1 SECONDS, easing = JUMP_EASING)
