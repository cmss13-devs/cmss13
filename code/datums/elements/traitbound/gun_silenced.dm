/datum/element/traitbound/gun_silenced
	associated_trait = TRAIT_GUN_SILENCED
	compatible_types = list(/obj/item/weapon/gun)

/datum/element/traitbound/gun_silenced/Attach(datum/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	var/obj/item/weapon/gun/Gun = target
	Gun.flags_gun_features |= GUN_SILENCED
	Gun.muzzle_flash = null
	if(!HAS_TRAIT_FROM(Gun, TRAIT_GUN_SILENCED, TRAIT_SOURCE_INHERENT))
		Gun.fire_sound = "gun_silenced"

/datum/element/traitbound/gun_silenced/Detach(datum/target)
	var/obj/item/weapon/gun/Gun = target
	Gun.flags_gun_features &= ~GUN_SILENCED
	Gun.muzzle_flash = initial(Gun.muzzle_flash)
	Gun.fire_sound = initial(Gun.fire_sound)
	return ..()

/datum/element/traitbound/gun_silenced/alt
	associated_trait = TRAIT_GUN_SILENCED_ALT
	compatible_types = list(/obj/item/weapon/gun)

/datum/element/traitbound/gun_silenced/alt/Attach(datum/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	var/obj/item/weapon/gun/Gun = target
	Gun.flags_gun_features |= GUN_SILENCED
	Gun.muzzle_flash = null
	if(!HAS_TRAIT_FROM(Gun, TRAIT_GUN_SILENCED_ALT, TRAIT_SOURCE_INHERENT))
		Gun.fire_sound = "gun_silenced_alt"

/datum/element/traitbound/gun_silenced/alt/Detach(datum/target)
	var/obj/item/weapon/gun/Gun = target
	Gun.flags_gun_features &= ~GUN_SILENCED
	Gun.muzzle_flash = initial(Gun.muzzle_flash)
	Gun.fire_sound = initial(Gun.fire_sound)
	return ..()
