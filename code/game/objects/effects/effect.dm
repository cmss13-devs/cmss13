/obj/effect
	icon = 'icons/effects/effects.dmi'
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	flags_atom = NO_ZFALL //moving this here and hoping that there are not effects that are supposed to fall


	var/as_image = FALSE

/obj/effect/get_applying_acid_time()
	return -1
