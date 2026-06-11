/obj/item/weapon/gun/flare
	name = "\improper M82-F flare gun"
	desc = "A flare gun issued to JTAC operators to use with flares. Comes with a miniscope. One shot, one... life saved?"
	icon_state = "m82f"
	item_state = "m82f"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/pistols.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/pistols_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/pistols_righthand.dmi'
	)
	current_mag = /obj/item/ammo_magazine/internal/flare
	reload_sound = 'sound/weapons/gun_shotgun_shell_insert.ogg'
	fire_sound = 'sound/weapons/gun_flare.ogg'
	aim_slowdown = 0
	flags_equip_slot = SLOT_WAIST
	wield_delay = WIELD_DELAY_VERY_FAST
	movement_onehanded_acc_penalty_mult = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	flags_gun_features = GUN_INTERNAL_MAG|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_HANDGUN
	attachable_allowed = list(/obj/item/attachable/scope/mini/flaregun)

	var/last_signal_flare_name


/obj/item/weapon/gun/flare/Initialize(mapload, spawn_empty)
	. = ..()
	if(spawn_empty)
		update_icon()

/obj/item/weapon/gun/flare/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/flaregun/scope = new(src)
	scope.hidden = TRUE
	scope.flags_attach_features &= ~ATTACH_REMOVABLE
	scope.Attach(src)
	update_attachables()


/obj/item/weapon/gun/flare/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 20, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/flare/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = 0
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/flare/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/flare/reload_into_chamber(mob/user)
	. = ..()
	to_chat(user, SPAN_WARNING("You pop out [src]'s tube!"))
	update_icon()

/obj/item/weapon/gun/flare/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/attacking_flare = attacking_item
		if(attacking_flare.on)
			to_chat(user, SPAN_WARNING("You can't put a lit flare in [src]!"))
			return
		if(!attacking_flare.fuel)
			to_chat(user, SPAN_WARNING("You can't put a burnt out flare in [src]!"))
			return
		if(current_mag && current_mag.current_rounds == 0)
			ammo = GLOB.ammo_list[attacking_flare.ammo_datum]
			playsound(user, reload_sound, 25, 1)
			to_chat(user, SPAN_NOTICE("You load [attacking_flare] into [src]."))
			current_mag.current_rounds++
			qdel(attacking_flare)
			update_icon()
		else
			to_chat(user, SPAN_WARNING("[src] is already loaded!"))
	else
		to_chat(user, SPAN_WARNING("That's not a flare!"))

/obj/item/weapon/gun/flare/unload(mob/user)
	if(flags_gun_features & GUN_BURST_FIRING)
		return
	unload_flare(user)

/obj/item/weapon/gun/flare/proc/unload_flare(mob/user)
	if(!current_mag)
		return
	if(current_mag.current_rounds)
		var/obj/item/device/flashlight/flare/unloaded_flare = new ammo.handful_type(get_turf(src))
		playsound(user, reload_sound, 25, TRUE)
		current_mag.current_rounds--
		if(user)
			to_chat(user, SPAN_NOTICE("You unload [unloaded_flare] from \the [src]."))
			user.put_in_hands(unloaded_flare)
		update_icon()

/obj/item/weapon/gun/flare/unique_action(mob/user)
	if(!user || !isturf(user.loc) || !current_mag || !current_mag.current_rounds)
		return

	var/turf/flare_turf = user.loc
	var/area/flare_area = flare_turf.loc

	if(flare_area.ceiling > CEILING_GLASS)
		to_chat(user, SPAN_NOTICE("The roof above you is too dense."))
		return

	if(!istype(ammo, /datum/ammo/flare))
		to_chat(user, SPAN_NOTICE("[src] jams as it is somehow loaded with incorrect ammo!"))
		return

	if(user.action_busy)
		return

	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	if(!current_mag || !current_mag.current_rounds)
		return

	current_mag.current_rounds--

	flare_turf.ceiling_debris()

	var/datum/ammo/flare/explicit_ammo = ammo

	var/obj/item/device/flashlight/flare/fired_flare = new explicit_ammo.flare_type(get_turf(src))
	to_chat(user, SPAN_NOTICE("You fire [fired_flare] into the air!"))
	fired_flare.visible_message(SPAN_WARNING("\A [fired_flare] bursts into brilliant light in the sky!"))
	fired_flare.invisibility = INVISIBILITY_MAXIMUM
	fired_flare.mouse_opacity = FALSE
	fired_flare.fuel = 3 MINUTES
	fired_flare.light_range = 6
	fired_flare.light_power = 3
	playsound(user.loc, fire_sound, 50, 1)

	var/obj/effect/flare_light/light_effect = new (fired_flare, fired_flare.light_range, fired_flare.light_power, fired_flare.light_color)
	light_effect.RegisterSignal(fired_flare, COMSIG_ATOM_SET_LIGHT_ON, TYPE_PROC_REF(/obj/effect/flare_light, flare_light_change))

	if(fired_flare.activate_signal(user))
		last_signal_flare_name = fired_flare.name

	update_icon()

/obj/item/weapon/gun/flare/get_examine_text(mob/user)
	. = ..()
	if(last_signal_flare_name)
		. += SPAN_NOTICE("The last signal flare fired has the designation: [last_signal_flare_name]")

/obj/effect/flare_light
	name = "flare light"
	desc = "You are not supposed to see this. Please report it."
	icon_state = "" //No sprite
	invisibility = INVISIBILITY_MAXIMUM
	light_system = MOVABLE_LIGHT

/obj/effect/flare_light/Initialize(mapload, light_range, light_power, light_color)
	. = ..()
	set_light(light_range, light_power, light_color)

/obj/effect/flare_light/proc/flare_light_change(original_flare, new_light_value)
	if(!new_light_value)
		qdel(original_flare)
		qdel(src)
