// Northpoint Props

// Concrete Wall

/obj/structure/prop/northpoint/concrete_wall
	name = "concrete quarantine wall"
	desc = "A massive concrete wall. Constructed to keep something out. Its unlikely anything will bring this wall down anytime soon."
	icon = 'icons/obj/structures/props/northpoint/concrete_wall.dmi'
	icon_state = "concrete_wall"
	layer = 6
	density = TRUE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
//	bound_height = 64

/obj/structure/prop/northpoint/concrete_wall/wired
	icon_state = "concrete_wall_wire"

/obj/structure/prop/northpoint/concrete_wall/alt
	icon_state = "concrete_wall_cmb"


/obj/structure/prop/northpoint/iasf_soldier_prop
	name = "IASF Paratrooper"
	desc = "Imperial Army Space Force paratrooper. Attached to the 12th Light Brigade, 4th Battalion. They are trying to forget the screams they heard from the other side of the quarantine wall."
	icon = 'icons/obj/structures/props/northpoint/iasf_human_prop.dmi'
	icon_state = "twe_empty"
	layer = 6
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	density = TRUE

/obj/structure/prop/northpoint/iasf_soldier_prop/alt
	icon_state = "twe_rifle"
