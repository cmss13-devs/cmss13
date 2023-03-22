/datum/element/traitbound/gun_silenced
	associated_trait = TRAIT_GUN_SILENCED
	compatible_types = list(/obj/item/weapon/gun)

/datum/element/traitbound/gun_silenced/Attach(datum/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	var/obj/item/weapon/gun/gun = target
	gun.flags_gun_features |= GUN_SILENCED
	gun.muzzle_flash = null
	if(!HAS_TRAIT_FROM(gun, TRAIT_GUN_SILENCED, TRAIT_SOURCE_INHERENT))
		gun.fire_sound = "gun_silenced"

/datum/element/traitbound/gun_silenced/Detach(datum/target)
	var/obj/item/weapon/gun/gun = target
	gun.flags_gun_features &= ~GUN_SILENCED
	gun.muzzle_flash = initial(gun.muzzle_flash)
	gun.fire_sound = initial(gun.fire_sound)
	return ..()
