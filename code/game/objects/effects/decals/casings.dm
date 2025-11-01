/*
Generated per the various mags, and then changed based on the number of
casings. .dir is the main thing that controls the icon. It modifies
the icon_state to look like more casings are hitting the ground.
There are 8 directions, 8 bullets are possible so after that it tries to grab the next
icon_state while reseting the direction. After 16 casings, it just ignores new
ones. At that point there are too many anyway. Shells and bullets leave different
items, so they do not intersect. This is far more efficient than using Bl*nd() or
Turn() or Shift() as there is virtually no overhead. ~N
*/
// do note that most of these comments are likely outdated - nihi

/obj/effect/decal/ammo_casing
	name = "spent casing"
	desc = "Empty and useless now."
	icon = 'icons/obj/items/weapons/casings.dmi'
	icon_state = "casing"
	dir = NORTH //Always north when it spawns.
	var/current_casings = 1 //This is manipulated in the procs that use these.
	var/max_casings = 16
	var/current_icon = 0
	var/number_of_states = 10 //How many variations of this item there are.
	garbage = TRUE
	appearance_flags = PIXEL_SCALE
	layer = ABOVE_WEED_LAYER
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/ammo_casing/Initialize()
	. = ..()
	pixel_x = rand(-0.9, 0.9) // just enough randomization but not more that it creates another turf instance
	pixel_y = rand(-0.9, 0.9)
	var/matrix/rotate = matrix()
	rotate.Turn(rand(0, 359))
	transform = rotate
	icon_state += "_[rand(1,number_of_states)]" //Set the icon to it.

//This does most of the heavy lifting. It updates the icon and name if needed, then changes .dir to simulate new casings.
/obj/effect/decal/ammo_casing/update_icon()
	if(max_casings >= current_casings)
		if(current_casings == 2) name += "s" //In case there is more than one.
		if(floor((current_casings-1)/8) > current_icon)
			current_icon++
			icon_state += "_[current_icon]"

		var/base_direction = current_casings - (current_icon * 8)
		setDir(base_direction + floor(base_direction)/3)

//Making child objects so that locate() and istype() doesn't screw up.
/obj/effect/decal/ammo_casing/cartridge
	name = "spent cartridge"
	icon_state = "cartridge"

/obj/effect/decal/ammo_casing/shell
	name = "spent shell"
	icon_state = "red_shell" //placeholder for now

/obj/effect/decal/ammo_casing/shell/green_shell
	name = "spent shell"
	icon_state = "green_shell"

/obj/effect/decal/ammo_casing/shell/red_shell
	name = "spent shell"
	icon_state = "red_shell"

/obj/effect/decal/ammo_casing/shell/blue_shell
	name = "spent shell"
	icon_state = "blue_shell"

/obj/effect/decal/ammo_casing/shell/twobore_shell
	name = "comedically sized spent shell"
	icon_state = "twobore_shell"
