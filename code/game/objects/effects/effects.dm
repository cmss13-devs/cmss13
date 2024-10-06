//objects in /obj/effect should never be things that are attackable, use obj/structure instead.
//Effects are mostly temporary visual effects like sparks, smoke, as well as decals, etc...
/obj/effect
	icon = 'icons/effects/effects.dmi'
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	unacidable = TRUE

/obj/effect/ex_act(severity)
	return

//they're not hittable, and prevents recursions
/obj/effect/add_debris_element()
	return

///The abstract effect ignores even more effects and is often typechecked for atoms that should truly not be fucked with.
/obj/effect/abstract
