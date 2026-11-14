/obj/structure/roof/cargocrane_tracks
	name = "cargo crane track"
	desc = "A track for a cargo crane to move along."
	icon = 'icons/obj/structures/props/cargocrane_tracks.dmi'
	icon_state = "vertical"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = INTERIOR_ROOF_LAYER

/obj/structure/roof/cargocrane_tracks/Initialize()
	var/image/source_image = image(icon, icon_state = "[icon_state]-s")
	source_image.pixel_y = -32
	source_image.plane = FLOOR_PLANE
	source_image.layer = ANIMAL_HIDING_LAYER
	overlays += source_image
	return ..()

/obj/structure/roof/cargocrane_tracks/horizontal
	icon_state = "horizontal"

/obj/structure/roof/cargocrane_tracks/horizontal/endcap1
	icon_state = "horizontal_endcap1"

/obj/structure/roof/cargocrane_tracks/horizontal/endcap2
	icon_state = "horizontal_endcap2"

/obj/structure/roof/cargocrane_tracks/vertical
	icon_state = "vertical"

/obj/structure/roof/cargocrane_tracks/corner
	icon_state = "corner"

/obj/structure/roof/cargocrane_tracks/tjoint
	icon_state = "t-joint"

/obj/structure/roof/cargocrane_tracks/tjoint2
	icon_state = "t-joint2"

/obj/structure/roof/cargocrane_tracks/tjoint3
	icon_state = "t-joint3"

/obj/structure/prop/invuln/joey/normal
	name = "Working Joe"
	desc = "A Seegson-brand Working Joe, stored in the synthetic maintenance station to be called upon whenever you need. If only you had the keys."
	icon_state = "joe"

/obj/structure/bed/chair/comfy/ai_interface
	icon_state = "ai_interface_chair"
	name = "AI interface chair"
	desc = "A functional chair designed for comfortably sitting a single person with intent to facilitate interactions with the ship AI."
	can_rotate = FALSE
	dir = NORTH

/obj/structure/machinery/prop/almayer/computer/PC/large
	icon_state = "largecomp"

/obj/structure/machinery/prop/almayer/computer/PC/large/dark
	icon_state = "largecomp_dark"

/obj/structure/machinery/prop/almayer/computer/midway_remote_control
	name = "Midway Remote Control Console"
	desc = "A flight computer that can be used to control the Midway remotely. The Midway is currently in storage."
	icon_state = "cameras_old"

/obj/structure/prop/almayer/whiteboard
	name = "whiteboard"
	desc = "A blank white surface where thoughts turn to plans. It's blank, all of the markers having dried out from the constant inappropriate drawings."
	icon = 'icons/obj/structures/props/almayer/almayer_props64.dmi'
	icon_state = "whiteboard"
	bound_width = 64

/obj/structure/prop/almayer/whiteboard/clear
	name = "glass whiteboard"
	desc = "A clear pane of glass used as a whiteboard."
	icon_state = "whiteboard_clear"

/obj/structure/prop/almayer/ai_wallmonitor
	name = "AI interface wall monitor"
	desc = "A monitor embedded into the wall, providing detailed readouts of various different systems."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "ai_wallmonitor"
	density = FALSE
	pixel_y = 32
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/prop/almayer/ai_wallmonitor/east
	icon_state = "ai_wallmonitor_e"
	pixel_x = 32
	pixel_y = 0

/obj/structure/prop/almayer/ai_wallmonitor/west
	icon_state = "ai_wallmonitor_w"
	pixel_x = -32
	pixel_y = 0

/obj/item/storage/cabinet
	name = "cabinet"
	desc = "A cabinet securely fastened to the wall, capable of storing a variety of smaller items."
	icon = 'icons/obj/structures/props/almayer/almayer_props.dmi'
	icon_state = "cabinet"
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = FALSE
	w_class = SIZE_MASSIVE
	storage_slots = 12
	max_w_class = SIZE_TINY
	max_storage_space = 40
	use_sound = null
	bypass_w_limit = list(
		/obj/item/reagent_container/glass,
		/obj/item/reagent_container/food,
		/obj/item/tool/kitchen,
	)

/obj/item/storage/cabinet/attack_hand(mob/user)
	if(CAN_PICKUP(user, src))
		open(user)

/obj/item/storage/cabinet/update_icon()
	icon_state = length(content_watchers) ? "[initial(icon_state)]_open" : initial(icon_state)

/obj/item/storage/cabinet/cups
	name = "cups cabinet"

/obj/item/storage/cabinet/cups/fill_preset_inventory()
	for(var/i in 1 to 12)
		new /obj/item/reagent_container/food/drinks/coffee/marine(src)

/obj/item/storage/cabinet/cups/flip
	icon_state = "cabinet2"

/obj/item/storage/cabinet/utensils
	name = "utensils cabinet"

/obj/item/storage/cabinet/utensils/fill_preset_inventory()
	for(var/i in 1 to 12)
		new /obj/item/tool/kitchen/utensil/fork(src)

/obj/item/storage/cabinet/utensils/flip
	icon_state = "cabinet2"

/obj/structure/closet/secure_closet/forecon_uniform
	name = "FORECON uniform locker"
	desc = "A locker containing spare Force Recon uniforms and combat boots."
	icon_state = "secure"
	locked = FALSE
	storage_capacity = 40

/obj/structure/closet/secure_closet/forecon_uniform/Initialize()
	. = ..()
	for(var/i in 1 to 8)
		var/obj/item/clothing/under/marine/uniform = new(src)
		uniform.add_forecon_patches()
		new /obj/item/clothing/shoes/marine(src)

/obj/structure/closet/secure_closet/forecon_equipment
	name = "FORECON field equipment locker"
	desc = "A locker containing M3-R armor and specialist clothing."
	icon_state = "secure"
	locked = FALSE
	storage_capacity = 100

/obj/structure/closet/secure_closet/forecon_equipment/Initialize()
	. = ..()
	for(var/i in 1 to 12)
		new /obj/item/clothing/suit/storage/marine/light/recon/bug_hunt(src)
	for(var/i in 1 to 2)
		new /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber(src)
		new /obj/item/clothing/head/beret/cm/tan(src)
	new /obj/item/clothing/under/marine/officer/engi(src)
	new /obj/item/clothing/shoes/red(src)
	new /obj/item/clothing/gloves/marine/insulated/black(src)
	new /obj/item/clothing/accessory/patch/uscmpatch(src)
	new /obj/item/clothing/accessory/patch/forecon(src)

/obj/structure/closet/secure_closet/forecon_weapons
	name = "FORECON weapons locker"
	desc = "A locker containing camouflage M41A rifles, M39 submachineguns, and M4RA battle rifles."
	icon_state = "secure"
	locked = FALSE
	storage_capacity = 50

/obj/structure/closet/secure_closet/forecon_weapons/Initialize()
	. = ..()
	for(var/i in 1 to 8)
		new /obj/item/weapon/gun/rifle/m41aMK1/forecon(src)
	for(var/i in 1 to 4)
		new /obj/item/weapon/gun/smg/m39(src)
	for(var/i in 1 to 2)
		new /obj/item/weapon/gun/rifle/m4ra(src)

/obj/structure/closet/secure_closet/forecon_ammunition
	name = "FORECON ammunition locker"
	desc = "A locker containing spare magazines for FORECON firearms."
	icon_state = "secure"
	locked = FALSE
	storage_capacity = 100

/obj/structure/closet/secure_closet/forecon_ammunition/Initialize()
	. = ..()
	for(var/i in 1 to 24)
		new /obj/item/ammo_magazine/rifle/m41aMK1(src)
	for(var/i in 1 to 12)
		new /obj/item/ammo_magazine/smg/m39/extended(src)
		new /obj/item/ammo_magazine/rifle/m4ra/extended(src)

/obj/item/ammo_box/rounds/smartgun
	name = "\improper smartgun ammunition box (10x28mm)"
	desc = "A 10x28mm ammunition box. Used to refill smartgun drum magazines. It comes with a leather strap that allows you to wear it on your back."
	overlay_gun_type = "_sg"
	default_ammo = /datum/ammo/bullet/smartgun
	caliber = "10x28mm"
	bullet_amount = 1000
	max_bullet_amount = 1000

/turf/open/floor/almayer/flooredgesmooth/corner
	icon_state = "floor_edge_smooth_corner"

/turf/open/floor/almayer/flooredgesmooth/corner/north
	dir = NORTH

/turf/open/floor/almayer/flooredgesmooth/corner/east
	dir = EAST

/turf/open/floor/almayer/flooredgesmooth/corner/west
	dir = WEST
