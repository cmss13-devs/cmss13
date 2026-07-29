/obj/item/magazine_clip/rifle
	name = "\improper Rifle magazine clip"
	desc = "A 3D printed magazine clip for rifles, can secure two magazines."

	icon_state = "m41a_clip"
	foreground_icon_state = "m41a_clip_fore" //Storing foreground sprite; TODO: clean it up and move to m41a mag clip after finish with testing
	magazine_icon_reference = list(list(-2, 0), list(4, 2)) //Stores x and y offsets for putting magazine onto the overlay

	compatible_magazines = list(/obj/item/ammo_magazine/rifle)
