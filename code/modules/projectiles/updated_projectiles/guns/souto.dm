/obj/item/weapon/gun/souto
	name = "\improper Souto Slinger Supremo"
	desc = "The most feared weapon in the galaxy."
	icon_state = "supremo_w"
	item_state = "supremo_w"
	w_class = SIZE_SMALL
	fire_sound = 'sound/items/syringeproj.ogg'
	attachable_allowed = list()
	has_empty_icon = 0
	ammo = /datum/ammo/souto
	var/range = 6 // This var is used as range for the weapon/toy.
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_INTERNAL_MAG|GUN_AMMO_COUNTER
	var/obj/item/storage/backpack/souto/soutopack
	current_mag = null

/obj/item/weapon/gun/souto/set_gun_config_values()
	. = ..()
	accuracy_mult = config.base_hit_accuracy_mult + 2*config.max_hit_accuracy_mult
	scatter = config.min_scatter_value
	burst_scatter_mult = config.min_scatter_value
	
/obj/item/weapon/gun/souto/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	if(!soutopack)
		if(!link_soutopack(user))
			to_chat(user, "You must equip the specialized Backpack Souto vending machine to use this Souto Slinger Supremo!")
			click_empty(user)
			unlink_soutopack()
			return
	if(soutopack)
		if(!current_mag)
			current_mag = soutopack.internal_mag
		// Check we're actually firing the right fuel tank
		if(current_mag != soutopack.internal_mag)
			current_mag = soutopack.internal_mag
		..()

/obj/item/weapon/gun/souto/reload(mob/user, obj/item/ammo_magazine/magazine)
	to_chat(user, SPAN_WARNING("The [src] feed system cannot be reloaded manually."))
	return

/obj/item/weapon/gun/souto/unload(mob/user, reload_override = 0, drop_override = 0, loc_override = 0)
	to_chat(user, SPAN_WARNING("You cannot unload the [src]."))
	return

/obj/item/weapon/gun/souto/able_to_fire(mob/user)
	. = ..()
	if(.)
		if(!current_mag || !current_mag.current_rounds)
			return
		if(!skillcheck(user, SKILL_SPEC_WEAPONS,  SKILL_SPEC_TRAINED))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return FALSE

		var/mob/living/carbon/human/H = user
		if(!istype(H))
			return FALSE
		if(!istype(H.back, /obj/item/storage/backpack/souto))
			click_empty(H)
			return FALSE
		if(current_mag)
			var/datum/ammo/souto/S = ammo
			S.can_type = new S.shrapnel_type
			if(!in_chamber)
				load_into_chamber()
			in_chamber.icon_state = S.can_type.icon_state
			S.can_type.loc = in_chamber
			S.can_type.sharp = 1

/obj/item/weapon/gun/souto/proc/link_soutopack(var/mob/user)
	if(user.back)	
		if(istype(user.back, /obj/item/storage/backpack/souto))
			soutopack = user.back
			return TRUE
	return FALSE

/obj/item/weapon/gun/souto/proc/unlink_soutopack()
	soutopack = null

/obj/item/weapon/gun/souto/harness_check(mob/living/carbon/human/user)
	harness_return(user)

/obj/item/weapon/gun/souto/harness_return(mob/living/carbon/human/user)
	set waitfor = 0
	sleep(3)
	if(loc && user)
		if(istype(user.back, /obj/item/storage/backpack/souto) && isturf(loc))
			var/obj/item/I = user.back
			user.equip_to_slot_if_possible(src, WEAR_IN_BACK)
			if(src in user.back)
				to_chat(user, SPAN_WARNING("[src] snaps into the [I]."))
			user.update_inv_back()

/obj/item/ammo_magazine/internal/souto
	name = "\improper Souto Slinger Supremo internal magazine"
	caliber = "Cans"
	max_rounds = 100
	default_ammo = /datum/ammo/souto
	gun_type = /obj/item/weapon/gun/souto
