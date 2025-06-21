

/obj/item/storage/large_holster
	name = "\improper Rifle Holster"
	desc = "holster"
	icon = 'icons/obj/items/storage/holsters.dmi'
	icon_state = ""
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	max_w_class = SIZE_LARGE
	storage_slots = 1
	max_storage_space = 4
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_USING_DRAWING_METHOD|STORAGE_ALLOW_QUICKDRAW|STORAGE_ALLOW_WHILE_HAULED
	///Icon/item states change based on contents; this stores base icon state.
	var/base_icon
	var/drawSound = 'sound/weapons/gun_rifle_draw.ogg'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/holster.dmi',
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/belts.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/belts.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_righthand.dmi'
	)

/obj/item/storage/large_holster/post_skin_selection()
	base_icon = icon_state

/obj/item/storage/large_holster/update_icon()
	if(length(contents))
		icon_state = "[base_icon]_full"
	else
		icon_state = base_icon

	item_state = icon_state

	var/mob/living/carbon/human/user = loc
	if(istype(user))
		if(src == user.back)
			user.update_inv_back()
		else if(src == user.belt)
			user.update_inv_belt()
		else if(src == user.s_store)
			user.update_inv_s_store()

/obj/item/storage/large_holster/equipped(mob/user, slot)
	if(slot == WEAR_BACK || slot == WEAR_WAIST || slot == WEAR_J_STORE)
		mouse_opacity = MOUSE_OPACITY_OPAQUE //so it's easier to click when properly equipped.
	..()

/obj/item/storage/large_holster/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()

/obj/item/storage/large_holster/_item_insertion(obj/item/W, prevent_warning = 0)
	..()
	if(drawSound)
		playsound(src, drawSound, 15, TRUE)

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/storage/large_holster/_item_removal(obj/item/W, atom/new_location)
	..()
	if(drawSound)
		playsound(src, drawSound, 15, TRUE)

/obj/item/storage/large_holster/m37
	name = "\improper L44 M37A2 scabbard"
	desc = "A large leather holster fitted for USCM-issue shotguns. It has harnesses that allow it to be secured to the back for easy storage."
	icon_state = "m37_holster"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/jungle.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/jungle.dmi'
	)
	max_w_class = SIZE_HUGE
	can_hold = list(
		/obj/item/weapon/gun/shotgun/pump,
		/obj/item/weapon/gun/shotgun/combat,
		/obj/item/weapon/gun/shotgun/double/mou53,
	)
	flags_atom = FPRINT // has gamemode skin

/obj/item/storage/large_holster/m37/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/jungle.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/jungle.dmi'
		if("classic")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/classic.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/classic.dmi'
		if("desert")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/desert.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/desert.dmi'
		if("snow")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/snow.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/snow.dmi'
		if("urban")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/urban.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/urban.dmi'

/obj/item/storage/large_holster/m37/full/fill_preset_inventory()
	new /obj/item/weapon/gun/shotgun/pump(src)

/obj/item/storage/large_holster/machete
	name = "\improper H5 pattern M2132 machete scabbard"
	desc = "A large leather scabbard used to carry a M2132 machete. It can be strapped to the back or the armor."
	icon_state = "machete_holster"
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	can_hold = list(/obj/item/weapon/sword/machete)
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/holster.dmi',
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/scabbards.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/belts.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/belts_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/belts_righthand.dmi'
	)

/obj/item/storage/large_holster/machete/full/fill_preset_inventory()
	new /obj/item/weapon/sword/machete(src)

/obj/item/storage/large_holster/machete/arnold
	name = "\improper QH20 pattern M2100 custom machete scabbard"
	desc = "A large leather scabbard used to carry a M2100 \"Ngájhe\" machete. It can be strapped to the back or the armor."
	icon_state = "arnold-machete-pouch"
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	can_hold = list(/obj/item/weapon/sword/machete)

/obj/item/storage/large_holster/machete/arnold/full/fill_preset_inventory()
	new /obj/item/weapon/sword/machete/arnold(src)

/obj/item/storage/large_holster/machete/smartgunner
	name = "\improper M56 harness machete scabbard"
	desc = "A scabbard that connects to the M56 combat harness for carrying a M2132 machete."
	icon_state = "smartgun_machete_holster"
	flags_equip_slot = SLOT_BACK
	flags_item = SMARTGUNNER_BACKPACK_OVERRIDE

/obj/item/storage/large_holster/machete/smartgunner/mob_can_equip(mob/equipping_mob, slot, disable_warning)
	. = ..()

	var/mob/living/carbon/human/user = equipping_mob
	if(!ishuman(user))
		return FALSE

	if(!user.wear_suit || !(user.wear_suit.flags_inventory & SMARTGUN_HARNESS))
		if(!disable_warning)
			to_chat(equipping_mob, SPAN_WARNING("You can't equip [src] without a harness."))
		return FALSE

/obj/item/storage/large_holster/machete/smartgunner/full/fill_preset_inventory()
	new /obj/item/weapon/sword/machete(src)

/obj/item/storage/large_holster/katana
	name = "\improper katana scabbard"
	desc = "A large, vibrantly colored katana scabbard used to carry a Japanese sword. It can be strapped to the back or worn at the belt. Because of the sturdy wood casing of the scabbard, it makes an okay defensive weapon in a pinch."
	icon_state = "katana_holster"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/holster.dmi',
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/scabbards.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/belts_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/belts_righthand.dmi'
	)
	force = 12
	attack_verb = list("bludgeoned", "struck", "cracked")
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	can_hold = list(/obj/item/weapon/sword/katana)

/obj/item/storage/large_holster/katana/full/fill_preset_inventory()
	new /obj/item/weapon/sword/katana(src)

/obj/item/storage/large_holster/ceremonial_sword
	name = "ceremonial sword scabbard"
	desc = "A large, old-styled scabbard used to carry a ceremonial sword."
	icon_state = "ceremonial_sword_holster"//object icon is duplicate of katana holster, needs new icon at some point.
	item_icons = list(
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/scabbards.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/belts_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/belts_righthand.dmi'
	)
	force = 12
	flags_equip_slot = SLOT_WAIST
	can_hold = list(/obj/item/weapon/sword/ceremonial)

/obj/item/storage/large_holster/ceremonial_sword/full/fill_preset_inventory()
	new /obj/item/weapon/sword/ceremonial(src)

/obj/item/storage/large_holster/m39
	name = "\improper M276 pattern M39 holster rig"
	desc = "The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This holster features a larger frame and stiff backboard to support a submachinegun. It's designed for the M39, but the clips are adjustable enough to fit most compact submachineguns. Due to its unorthodox design, it isn't a very common sight, and is only specially issued."
	icon_state = "m39_holster"
	icon = 'icons/obj/items/clothing/belts/belts.dmi'
	flags_equip_slot = SLOT_WAIST
	max_w_class = 5
	can_hold = list(
		/obj/item/weapon/gun/smg/m39,
		/obj/item/weapon/gun/smg/mp27,
		/obj/item/weapon/gun/smg/mac15,
		/obj/item/weapon/gun/pistol/skorpion,
		/obj/item/weapon/gun/pistol/m10,
	)
	///Guns have a hud offset that throws the vis_contents alignment off.
	var/gun_offset = 0
	///Whether the gun had pixel scaling set before being holstered.
	var/gun_scaling = FALSE

/obj/item/storage/large_holster/m39/_item_insertion(obj/item/W, prevent_warning)
	if(istype(W)) //Doing this before calling parent so that the gun isn't misaligned in the inventory screen.
		if(W.appearance_flags & PIXEL_SCALE)
			gun_scaling = TRUE
		else
			W.appearance_flags |= PIXEL_SCALE

		gun_offset = W.hud_offset
		W.hud_offset = 0
		W.pixel_x = 0
		W.transform = turn(matrix(0.82, MATRIX_SCALE), 90) //0.82x is the right size and gives reasonably accurate results with pixel scaling.

		W.vis_flags |= VIS_INHERIT_ID //Means the gun is just visual and doesn't block picking up or clicking on the holster.
		vis_contents += W

	..()

/obj/item/storage/large_holster/m39/_item_removal(obj/item/W, atom/new_location)
	if(gun_scaling)
		gun_scaling = FALSE
	else
		W.appearance_flags &= ~PIXEL_SCALE

	W.hud_offset = gun_offset
	W.pixel_x = gun_offset
	W.transform = null

	W.vis_flags &= ~VIS_INHERIT_ID
	vis_contents -= W

	..()

/obj/item/storage/large_holster/m39/update_icon()
	item_state = length(contents) ? "[base_icon]_full" : base_icon

	var/mob/living/carbon/human/user = loc
	if(istype(user))
		user.update_inv_belt()

/obj/item/storage/large_holster/m39/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/m39())

/obj/item/storage/large_holster/m39/full/elite/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/m39/elite/compact())

/obj/item/storage/large_holster/fuelpack
	name = "\improper Broiler-T flexible refueling system"
	desc = "A specialized back harness that carries the Broiler-T flexible refueling system. Designed by and for USCM Pyrotechnicians."
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/jungle.dmi'
	icon_state = "flamethrower_broiler"
	flags_atom = FPRINT|CONDUCT
	var/obj/item/ammo_magazine/flamer_tank/large/fuel
	var/obj/item/ammo_magazine/flamer_tank/large/B/fuelB
	var/obj/item/ammo_magazine/flamer_tank/large/X/fuelX
	var/obj/item/ammo_magazine/flamer_tank/large/active_fuel
	var/obj/item/weapon/gun/flamer/m240/spec/linked_flamer
	var/toggling = FALSE
	var/image/flamer_overlay
	actions_types = list(/datum/action/item_action/specialist/toggle_fuel)
	can_hold = list(/obj/item/weapon/gun/flamer/m240/spec)

/obj/item/storage/large_holster/fuelpack/Initialize()
	. = ..()
	fuel = new /obj/item/ammo_magazine/flamer_tank/large()
	fuelB = new /obj/item/ammo_magazine/flamer_tank/large/B()
	fuelX = new /obj/item/ammo_magazine/flamer_tank/large/X()
	active_fuel = fuel
	flamer_overlay = overlay_image('icons/obj/items/clothing/backpack/backpacks_by_map/jungle.dmi', "+m240t")

/obj/item/storage/large_holster/fuelpack/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/jungle.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/jungle.dmi'
		if("classic")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/classic.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/classic.dmi'
		if("desert")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/desert.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/desert.dmi'
		if("snow")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/snow.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/snow.dmi'
		if("urban")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/urban.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/urban.dmi'

/obj/item/storage/large_holster/fuelpack/Destroy()
	QDEL_NULL(active_fuel)
	QDEL_NULL(fuel)
	QDEL_NULL(fuelB)
	QDEL_NULL(fuelX)
	if(linked_flamer)
		linked_flamer.fuelpack = null
		linked_flamer = null
	QDEL_NULL(flamer_overlay)
	. = ..()

/obj/item/storage/large_holster/fuelpack/update_icon()
	overlays -= flamer_overlay
	if(length(contents))
		overlays += flamer_overlay

	var/mob/living/carbon/human/user = loc
	if(istype(user))
		user.update_inv_back()

/obj/item/storage/large_holster/fuelpack/dropped(mob/user)
	if(linked_flamer)
		linked_flamer.fuelpack = null
		if(linked_flamer.current_mag in list(fuel, fuelB, fuelX))
			linked_flamer.current_mag = null
		linked_flamer.update_icon()
		linked_flamer = null
	..()

// Get the right onmob icon when we have flamer holstered.
/obj/item/storage/large_holster/fuelpack/get_mob_overlay(mob/user_mob, slot, default_bodytype = "Default")
	var/image/ret = ..()
	if(slot == WEAR_BACK)
		if(length(contents))
			var/image/weapon_holstered = overlay_image('icons/mob/humans/onmob/clothing/back/guns_by_type/flamers.dmi', "+m240t", color, RESET_COLOR)
			ret.overlays += weapon_holstered

	return ret

/obj/item/storage/large_holster/fuelpack/attack_self(mob/user)
	..()
	do_toggle_fuel(user)

/obj/item/storage/large_holster/fuelpack/proc/do_toggle_fuel(mob/user)
	if(!ishuman(user) || user.is_mob_incapacitated())
		return FALSE

	if(user.back != src)
		to_chat(user, SPAN_WARNING("[src] must be equipped before you can switch types."))
		return

	if(!linked_flamer)
		to_chat(user, SPAN_WARNING("An incinerator unit must be linked in order to switch fuel types."))
		return

	if(user.get_active_hand() != linked_flamer)
		to_chat(user, SPAN_WARNING("You must be holding [linked_flamer] to use [src]."))
		return

	if(!active_fuel)
		return

	// Toggle to the next one

	// Handles toggling of fuel. Snowflake way of changing action icon. Change icon, update action icon, change icon back
	if(istype(active_fuel, /obj/item/ammo_magazine/flamer_tank/large/X))
		active_fuel = fuel
	else if(istype(active_fuel, /obj/item/ammo_magazine/flamer_tank/large/B))
		active_fuel = fuelX
	else
		active_fuel = fuelB

	for(var/datum/action/action_added as anything in actions)
		action_added.update_button_icon()

	to_chat(user, "You switch the fuel tank to <b>[active_fuel.caliber]</b>")
	playsound(src, 'sound/machines/click.ogg', 25, TRUE)
	linked_flamer.current_mag = active_fuel
	linked_flamer.update_icon()

	return TRUE

/obj/item/storage/large_holster/fuelpack/verb/toggle_fuel()
	set name = "Toggle Fuel Type"
	set desc = "Toggle between the fuel types."
	set category = "Pyro"
	set src in usr
	do_toggle_fuel(usr)


/obj/item/storage/large_holster/fuelpack/attackby(obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/ammo_magazine/flamer_tank/large/))
		switch_fuel(A, user)
		return

	var/obj/item/weapon/gun/flamer/m240/spec/F = A
	if(istype(F) && !(F.fuelpack))
		F.link_fuelpack(user)
		if(F.current_mag && !(F.current_mag in list(fuel,fuelB,fuelX)))
			to_chat(user, SPAN_WARNING("\The [F.current_mag] is ejected by the Broiler-T back harness and replaced with \the [active_fuel]!"))
			F.unload(user, drop_override = TRUE)
			F.current_mag = active_fuel
			F.update_icon()

	. = ..()

/obj/item/storage/large_holster/fuelpack/proc/switch_fuel(obj/item/ammo_magazine/flamer_tank/large/new_fuel, mob/user)
	// Switch out the currently stored fuel and drop it
	if(istype(new_fuel, /obj/item/ammo_magazine/flamer_tank/large/X/))
		fuelX.forceMove(get_turf(user))
		fuelX = new_fuel
	else if(istype(new_fuel, /obj/item/ammo_magazine/flamer_tank/large/B/))
		fuelB.forceMove(get_turf(user))
		fuelB = new_fuel
	else
		fuel.forceMove(get_turf(user))
		fuel = new_fuel
	visible_message("[user] swaps out the fuel tank in [src].","You swap out the fuel tank in [src] and drop the old one.")
	to_chat(user, "The newly inserted [new_fuel.caliber] contains: [floor(new_fuel.get_ammo_percent())]% fuel.")
	user.temp_drop_inv_item(new_fuel)
	new_fuel.moveToNullspace() //necessary to not confuse the storage system
	playsound(src, 'sound/machines/click.ogg', 25, TRUE)
	// If the fuel being switched is the active one, set it as new_fuel until it gets toggled
	if(istype(new_fuel, active_fuel))
		active_fuel = new_fuel


/obj/item/storage/large_holster/fuelpack/get_examine_text(mob/user)
	. = ..()
	if(length(contents))
		. += "It is storing a M240-T incinerator unit."
	if (get_dist(user, src) <= 1)
		if(fuel)
			. += "The [fuel.caliber] currently contains: [floor(fuel.get_ammo_percent())]% fuel."
		if(fuelB)
			. += "The [fuelB.caliber] currently contains: [floor(fuelB.get_ammo_percent())]% fuel."
		if(fuelX)
			. += "The [fuelX.caliber] currently contains: [floor(fuelX.get_ammo_percent())]% fuel."

/datum/action/item_action/specialist/toggle_fuel
	ability_primacy = SPEC_PRIMARY_ACTION_1

/datum/action/item_action/specialist/toggle_fuel/New(mob/living/user, obj/item/holder)
	..()
	name = "Toggle Fuel Type"
	button.name = name
	update_button_icon()

/datum/action/item_action/specialist/toggle_fuel/update_button_icon()
	var/obj/item/storage/large_holster/fuelpack/FP = holder_item
	if (!istype(FP))
		return

	var/icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/flamers.dmi'
	var/icon_state
	if(istype(FP.active_fuel, /obj/item/ammo_magazine/flamer_tank/large/X))
		icon_state = "flametank_large_blue"
	else if(istype(FP.active_fuel, /obj/item/ammo_magazine/flamer_tank/large/B))
		icon_state = "flametank_large_green"
	else
		icon_state = "flametank_large"

	button.overlays.Cut()
	var/image/IMG = image(icon, button, icon_state)
	button.overlays += IMG

/datum/action/item_action/specialist/toggle_fuel/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && H.body_position == STANDING_UP && holder_item == H.back)
		return TRUE

/datum/action/item_action/specialist/toggle_fuel/action_activate()
	. = ..()
	var/obj/item/storage/large_holster/fuelpack/FP = holder_item
	if (!istype(FP))
		return
	FP.toggle_fuel()
