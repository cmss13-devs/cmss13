/datum/element/traitbound/gun_silenced
	associated_trait = TRAIT_GUN_SILENCED
	compatible_types = list(/obj/item/weapon/gun)

/datum/element/traitbound/gun_silenced/Attach(datum/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	var/obj/item/weapon/gun/G = target
	G.flags_gun_features |= GUN_SILENCED
	G.muzzle_flash = null
	if(!HAS_TRAIT_FROM(G, TRAIT_GUN_SILENCED, TRAIT_SOURCE_INHERENT))
		G.fire_sound = "gun_silenced"

/datum/element/traitbound/gun_silenced/Detach(datum/target)
	var/obj/item/weapon/gun/G = target
	G.flags_gun_features &= ~GUN_SILENCED
	G.muzzle_flash = initial(G.muzzle_flash)
	G.fire_sound = initial(G.fire_sound)
	return ..()
