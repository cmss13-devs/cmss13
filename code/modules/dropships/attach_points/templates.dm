/obj/effect/attach_point/weapon/dropship1
	ship_tag = DROPSHIP_ALAMO

/obj/effect/attach_point/weapon/dropship1/left_wing
	name = "port wing weapon attach point"
	icon_state = "equip_base_l_wing"
	attach_id = 1
	dir = WEST
	firing_arc_min = -3
	firing_arc_max =  3
	transverse  = -3
	long    =  0

/obj/effect/attach_point/weapon/dropship1/left_fore
	name = "port fore weapon attach point"
	attach_id = 2
	dir = NORTH
	firing_arc_min = -6
	firing_arc_max =  0
	transverse  =  0
	long    =  0

/obj/effect/attach_point/weapon/dropship1/right_fore
	name = "starboard fore weapon attach point"
	attach_id = 3
	dir = NORTH
	firing_arc_min =  0
	firing_arc_max =  6
	transverse  =  0
	long    =  0

/obj/effect/attach_point/weapon/dropship1/right_wing
	name = "starboard wing weapon attach point"
	icon_state = "equip_base_r_wing";
	attach_id = 4
	dir = EAST
	firing_arc_min = -3
	firing_arc_max =  3
	transverse  =  3
	long    =  0

/obj/effect/attach_point/weapon/dropship2
	ship_tag = DROPSHIP_NORMANDY

/obj/effect/attach_point/weapon/dropship2/left_wing
	name = "port wing weapon attach point"
	icon_state = "equip_base_l_wing"
	attach_id = 1
	dir = WEST
	firing_arc_min = -3
	firing_arc_max =  3
	transverse  = -3
	long    =  0

/obj/effect/attach_point/weapon/dropship2/left_fore
	name = "port fore weapon attach point"
	attach_id = 2
	dir = NORTH
	firing_arc_min = -6
	firing_arc_max =  0
	transverse  =  0
	long    =  0

/obj/effect/attach_point/weapon/dropship2/right_fore
	name = "starboard fore weapon attach point"
	attach_id = 3
	dir = NORTH
	firing_arc_min =  0
	firing_arc_max =  6
	transverse  =  0
	long    =  0

/obj/effect/attach_point/weapon/dropship2/right_wing
	name = "starboard wing weapon attach point"
	icon_state = "equip_base_r_wing";
	attach_id = 4
	dir = EAST
	firing_arc_min = -3
	firing_arc_max =  3
	transverse  =  3
	long    =  0

/obj/effect/attach_point/crew_weapon
	name = "crew compartment attach point"
	base_category = DROPSHIP_CREW_WEAPON

/obj/effect/attach_point/crew_weapon/dropship1
	ship_tag = DROPSHIP_ALAMO

/obj/effect/attach_point/crew_weapon/dropship2
	ship_tag = DROPSHIP_NORMANDY

/obj/effect/attach_point/electronics
	name = "electronic system attach point"
	base_category = DROPSHIP_ELECTRONICS
	icon_state = "equip_base_front"

/obj/effect/attach_point/electronics/dropship1
	ship_tag = DROPSHIP_ALAMO

/obj/effect/attach_point/electronics/dropship2
	ship_tag = DROPSHIP_NORMANDY

/obj/effect/attach_point/fuel
	name = "engine system attach point"
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "fuel_base"
	base_category = DROPSHIP_FUEL_EQP

/obj/effect/attach_point/fuel/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))

/obj/effect/attach_point/fuel/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)

/obj/effect/attach_point/fuel/proc/on_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	log_debug("fuel attach [old_dir] [new_dir]")
	switch(new_dir)
		if(NORTH)
			pixel_x = 0
			pixel_y = 0
		if(SOUTH)
			pixel_x = -32
			pixel_y = -8

/obj/effect/attach_point/fuel/dropship1
	ship_tag = DROPSHIP_ALAMO

/obj/effect/attach_point/fuel/dropship2
	ship_tag = DROPSHIP_NORMANDY

/obj/effect/attach_point/computer
	base_category = DROPSHIP_COMPUTER

/obj/effect/attach_point/computer/dropship1
	ship_tag = DROPSHIP_ALAMO

/obj/effect/attach_point/computer/dropship2
	ship_tag = DROPSHIP_NORMANDY
