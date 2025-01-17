
/obj/item/techtree_advanced_weapon_kit
	name = "advanced weapon kit"
	desc = "It seems to be a kit to choose an advanced weapon"

	icon = 'icons/obj/items/tools.dmi'
	icon_state = "wrench"

	var/gun_type = /obj/item/weapon/gun/shotgun/pump
	var/ammo_type = /obj/item/ammo_magazine/shotgun/buckshot
	var/ammo_type_count = 3


/obj/item/techtree_advanced_weapon_kit/attack_self(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user

	new gun_type(get_turf(H))
	for (var/i in 1 to ammo_type_count)
		new ammo_type(get_turf(H))

	qdel(src)

/obj/item/techtree_advanced_weapon_kit/railgun
	name = "advanced weapon kit"
	desc = "It seems to be a kit to choose an advanced weapon"

	icon = 'icons/obj/items/tools.dmi'
	icon_state = "wrench"

	gun_type = /obj/item/weapon/gun/rifle/techweb_railgun
	ammo_type = /obj/item/ammo_magazine/techweb_railgun
	ammo_type_count = 5


/obj/item/weapon/gun/rifle/techweb_railgun
	name = "\improper Railgun"
	desc = "A poggers hellbliterator"
	icon_state = "m42a"
	item_state = "m42a"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/marksman_rifles.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/guns_by_type/marksman_rifles.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/guns_by_type/marksman_rifles.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/marksman_rifles_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/marksman_rifles_righthand.dmi'
	)
	unacidable = TRUE
	explo_proof = TRUE

	fire_sound = 'sound/weapons/gun_sniper.ogg'
	current_mag = /obj/item/ammo_magazine/techweb_railgun
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list()
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY
	map_specific_decoration = TRUE
	actions_types = list(/datum/action/item_action/techweb_railgun_start_charge, /datum/action/item_action/techweb_railgun_abort_charge)

	// Hellpullverizer ready or not??
	var/charged = FALSE

/obj/item/weapon/gun/rifle/techweb_railgun/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/rifle/techweb_railgun/able_to_fire()
	return charged

/obj/item/weapon/gun/rifle/techweb_railgun/proc/start_charging(user)
	if (charged)
		to_chat(user, SPAN_WARNING("Your railgun is already charged."))
		return

	to_chat(user, SPAN_WARNING("You start charging your railgun."))
	if (!do_after(user, 8 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(user, SPAN_WARNING("You stop charging your railgun."))
		return

	to_chat(user, SPAN_WARNING("You finish charging your railgun."))

	charged = TRUE
	return

/obj/item/weapon/gun/rifle/techweb_railgun/on_enter_storage()
	if (charged)
		abort_charge()
	. = ..()

/obj/item/weapon/gun/rifle/techweb_railgun/proc/abort_charge(user)
	if (!charged)
		return
	charged = FALSE
	if (user)
		to_chat(user, SPAN_WARNING("You depower your railgun to store it."))
	return

/obj/item/weapon/gun/rifle/techweb_railgun/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/techweb_railgun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6*5)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/techweb_railgun/unique_action(mob/user)
	if (in_chamber)
		to_chat(user, SPAN_WARNING("There's already a round chambered!"))
		return

	var/result = load_into_chamber()
	if (result)
		to_chat(user, SPAN_WARNING("You run the bolt on [src], chambering a round!"))
	else
		to_chat(user, SPAN_WARNING("You run the bolt on [src], but it's out of rounds!"))

// normally, ready_in_chamber gets called by this proc. However, it never gets called because we override.
// so we don't need to override ready_in_chamber, which is what makes the bullet and puts it in the chamber var.
/obj/item/weapon/gun/rifle/techweb_railgun/reload_into_chamber(mob/user)
	charged = FALSE
	in_chamber = null // blackpilled again
	return null

/datum/action/item_action/techweb_railgun_start_charge
	name = "Start Charging"

/datum/action/item_action/techweb_railgun_start_charge/action_activate()
	. = ..()
	if (target)
		var/obj/item/weapon/gun/rifle/techweb_railgun/TR = target
		TR.start_charging(owner)

/datum/action/item_action/techweb_railgun_abort_charge
	name = "Abort Charge"

/datum/action/item_action/techweb_railgun_abort_charge/action_activate()
	. = ..()
	if (target)
		var/obj/item/weapon/gun/rifle/techweb_railgun/TR = target
		TR.abort_charge(owner)

/obj/item/ammo_magazine/techweb_railgun
	name = "\improper Railgun Ammunition (5 rounds)"
	desc = "A magazine ammo for the poggers Railgun."
	caliber = "14mm"
	icon_state = "m42c" //PLACEHOLDER
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/marksman_rifles.dmi'
	w_class = SIZE_MEDIUM
	max_rounds = 5
	default_ammo = /datum/ammo/bullet/sniper/railgun
	gun_type = /obj/item/weapon/gun/rifle/techweb_railgun

/datum/ammo/bullet/sniper/railgun
	name = "railgun bullet"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER
	accurate_range_min = 4

	accuracy = HIT_ACCURACY_TIER_8
	accurate_range = 32
	max_range = 32
	scatter = 0
	damage = 3*100
	penetration= ARMOR_PENETRATION_TIER_10
	shell_speed = AMMO_SPEED_TIER_6
	damage_falloff = 0

/datum/ammo/bullet/sniper/railgun/on_hit_mob(mob/M, _unused)
	if (isxeno(M))
		M.apply_effect(1, SLOW)
