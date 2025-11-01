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

/* do note that the above comments are outdated and are just kept for record,
and that most of the ejection procedures utilize image matrices for randomization
that said, the icon_states in the dmi files aren't culled for use by mappers - nihi
*/

/obj/effect/decal/ammo_casing
	name = "spent casing"
	desc = "Empty and useless now."
	icon = 'icons/obj/items/weapons/casings.dmi'
	icon_state = "casing"
	garbage = TRUE
	appearance_flags = PIXEL_SCALE
	layer = ABOVE_WEED_LAYER
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/image/actual_casing //the actual image of the casing, for manipulation

/obj/effect/decal/ammo_casing/Initialize()
	. = ..()

	actual_casing = image(icon, icon_state)
	actual_casing.appearance_flags = PIXEL_SCALE

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
