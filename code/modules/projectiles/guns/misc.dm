//-------------------------------------------------------
//This gun is very powerful, but also has a kick.

/obj/item/weapon/gun/minigun
	name = "\improper Ol' Painless"
	desc = "An enormous multi-barreled rotating gatling gun. This thing will no doubt pack a punch."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/event.dmi'
	icon_state = "painless"
	item_state = "painless"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/guns_by_type/machineguns.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/guns_by_type/machineguns.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/machineguns_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/machineguns_righthand.dmi'
	)
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'

	fire_sound = 'sound/weapons/gun_minigun.ogg'
	cocked_sound = 'sound/weapons/gun_minigun_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/minigun
	w_class = SIZE_HUGE
	force = 20
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_RECOIL_BUILDUP|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_HEAVY
	start_semiauto = FALSE
	start_automatic = TRUE

/obj/item/weapon/gun/minigun/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/minigun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3

	scatter = SCATTER_AMOUNT_TIER_9 // Most of the scatter should come from the recoil

	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_buildup_limit = RECOIL_AMOUNT_TIER_3 / RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER

/obj/item/weapon/gun/minigun/handle_starting_attachment()
	..()
	//invisible mag harness
	var/obj/item/attachable/magnetic_harness/Integrated = new(src)
	Integrated.hidden = TRUE
	Integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	Integrated.Attach(src)
	update_attachable(Integrated.slot)

//Minigun UPP
/obj/item/weapon/gun/minigun/upp
	name = "\improper GSh-7.62 rotary machine gun"
	desc = "A gas-operated rotary machine gun used by UPP heavies. Its enormous volume of fire and ammunition capacity allows the suppression of large concentrations of enemy forces. Heavy weapons training is required control its recoil."
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_RECOIL_BUILDUP|GUN_CAN_POINTBLANK

/obj/item/weapon/gun/minigun/upp/able_to_fire(mob/living/user)
	. = ..()
	if(!. || !istype(user)) //Let's check all that other stuff first.
		return 0
	if(!skillcheck(user, SKILL_FIREARMS, SKILL_FIREARMS_TRAINED))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return 0
	if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_UPP)
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return 0


//M60
/obj/item/weapon/gun/m60
	name = "\improper M60 General Purpose Machine Gun"
	desc = "The M60. The Pig. The Action Hero's wet dream. \n<b>Alt-click it to open the feed cover and allow for reloading.</b>"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony/machineguns.dmi'
	icon_state = "m60"
	item_state = "m60"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/guns_by_type/machineguns.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/guns_by_type/machineguns.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/machineguns_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/machineguns_righthand.dmi'
	)
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'

	fire_sound = 'sound/weapons/gun_m60.ogg'
	cocked_sound = 'sound/weapons/gun_m60_cocked.ogg'

	current_mag = /obj/item/ammo_magazine/m60
	w_class = SIZE_LARGE
	force = 25
	flags_gun_features = GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_HEAVY
	attachable_allowed = list(
		/obj/item/attachable/m60barrel,
		/obj/item/attachable/bipod/m60,
	)
	starting_attachment_types = list(
		/obj/item/attachable/m60barrel,
		/obj/item/attachable/bipod/m60,
		/obj/item/attachable/stock/m60,
	)
	start_semiauto = FALSE
	start_automatic = TRUE

	var/cover_open = FALSE //if the gun's feed-cover is open or not.

/obj/item/weapon/gun/m60/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/m60/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 37, "muzzle_y" = 16, "rail_x" = 0, "rail_y" = 0, "under_x" = 27, "under_y" = 12, "stock_x" = 10, "stock_y" = 14)

/obj/item/weapon/gun/m60/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	set_burst_amount(BURST_AMOUNT_TIER_5)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	empty_sound = 'sound/weapons/gun_empty.ogg'

/obj/item/weapon/gun/m60/clicked(mob/user, list/mods)
	if(!mods["alt"] || !CAN_PICKUP(user, src))
		return ..()
	else
		if(!locate(src) in list(user.get_active_hand(), user.get_inactive_hand()))
			return TRUE
		if(user.get_active_hand() && user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("You can't do that with your hands full!"))
			return TRUE
		if(!cover_open)
			playsound(src.loc, 'sound/handling/smartgun_open.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You open [src]'s feed cover, allowing the belt to be removed."))
			cover_open = TRUE
		else
			playsound(src.loc, 'sound/handling/smartgun_close.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You close [src]'s feed cover."))
			cover_open = FALSE
		update_icon()
		return TRUE

/obj/item/weapon/gun/m60/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]'s feed cover is closed! You can't put a new belt in! <b>(alt-click to open it)</b>"))
		return
	return ..()

/obj/item/weapon/gun/m60/unload(mob/user, reload_override, drop_override, loc_override)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]'s feed cover is closed! You can't take out the belt! <b>(alt-click to open it)</b>"))
		return
	return ..()

/obj/item/weapon/gun/m60/update_icon()
	. = ..()
	if(cover_open)
		overlays += image("+[base_gun_icon]_cover_open", pixel_x = -2, pixel_y = 8)
	else
		overlays += image("+[base_gun_icon]_cover_closed", pixel_x = -10, pixel_y = 0)

/obj/item/weapon/gun/m60/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(cover_open)
			to_chat(user, SPAN_WARNING("You can't fire [src] with the feed cover open! <b>(alt-click to close)</b>"))
			return FALSE


/obj/item/weapon/gun/pkp
	name = "\improper QYJ-72 General Purpose Machine Gun"
	desc = "The QYJ-72 is the standard GPMG of the Union of Progressive Peoples, chambered in 7.62x54mmR, it fires a hard-hitting cartridge with a high rate of fire. With an extremely large box at 250 rounds, the QJY-72 is designed with suppressing fire and accuracy by volume of fire at its forefront. \n<b>Alt-click it to open the feed cover and allow for reloading.</b>"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/UPP/machineguns.dmi'
	icon_state = "qjy72"
	item_state = "qjy72"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/guns_by_type/machineguns.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/guns_by_type/machineguns.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/machineguns_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/machineguns_righthand.dmi'
	)
	fire_sound = 'sound/weapons/gun_mg.ogg'
	cocked_sound = 'sound/weapons/gun_m60_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/pkp
	w_class = SIZE_LARGE
	force = 30 //the image of a upp machinegunner beating someone to death with a gpmg makes me laugh
	start_semiauto = FALSE
	start_automatic = TRUE
	flags_gun_features = GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK|GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_AMMO_COUNTER
	gun_category = GUN_CATEGORY_HEAVY
	attachable_allowed = list(
		/obj/item/attachable/pkpbarrel,
		/obj/item/attachable/stock/pkpstock,
		/obj/item/attachable/bipod/pkp,
	)
	var/cover_open = FALSE //if the gun's feed-cover is open or not.



/obj/item/weapon/gun/pkp/handle_starting_attachment()
	..()
	var/obj/item/attachable/attachie = new /obj/item/attachable/pkpbarrel(src)
	attachie.flags_attach_features &= ~ATTACH_REMOVABLE
	attachie.Attach(src)
	update_attachable(attachie.slot)

	var/obj/item/attachable/pkpstock = new /obj/item/attachable/stock/pkpstock(src)
	pkpstock.flags_attach_features &= ~ATTACH_REMOVABLE
	pkpstock.Attach(src)
	update_attachable(pkpstock.slot)

	//invisible mag harness
	var/obj/item/attachable/magnetic_harness/harness = new(src)
	harness.hidden = TRUE
	harness.flags_attach_features &= ~ATTACH_REMOVABLE
	harness.Attach(src)
	update_attachable(harness.slot)

	var/obj/item/attachable/bipod/pkp/bipod = new /obj/item/attachable/bipod/pkp(src)
	bipod.flags_attach_features &= ~ATTACH_REMOVABLE
	bipod.Attach(src)
	update_attachable(bipod.slot)


/obj/item/weapon/gun/pkp/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/pkp/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 34, "muzzle_y" = 18,"rail_x" = 5, "rail_y" = 5, "under_x" = 26, "under_y" = 15, "stock_x" = 10, "stock_y" = 13)


/obj/item/weapon/gun/pkp/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_6
	burst_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	fa_max_scatter = SCATTER_AMOUNT_TIER_8
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	empty_sound = 'sound/weapons/gun_empty.ogg'

/obj/item/weapon/gun/pkp/clicked(mob/user, list/mods)
	if(!mods["alt"] || !CAN_PICKUP(user, src))
		return ..()
	else
		if(!locate(src) in list(user.get_active_hand(), user.get_inactive_hand()))
			return TRUE
		if(user.get_active_hand() && user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("You can't do that with your hands full!"))
			return TRUE
		if(!cover_open)
			playsound(src.loc, 'sound/handling/smartgun_open.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You open [src]'s feed cover, allowing the belt to be removed."))
			cover_open = TRUE
		else
			playsound(src.loc, 'sound/handling/smartgun_close.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You close [src]'s feed cover."))
			cover_open = FALSE
		update_icon()
		return TRUE

/obj/item/weapon/gun/pkp/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]'s feed cover is closed! You can't put a new belt in! <b>(alt-click to open it)</b>"))
		return
	return ..()

/obj/item/weapon/gun/pkp/unload(mob/user, reload_override, drop_override, loc_override)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]'s feed cover is closed! You can't take out the belt! <b>(alt-click to open it)</b>"))
		return
	return ..()

/obj/item/weapon/gun/pkp/update_icon()
	. = ..()
	if(cover_open)
		overlays += "+[base_gun_icon]_cover_open"
	else
		overlays += "+[base_gun_icon]_cover_closed"

/obj/item/weapon/gun/pkp/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(cover_open)
			to_chat(user, SPAN_WARNING("You can't fire [src] with the feed cover open! <b>(alt-click to close)</b>"))
			return FALSE
	if(!skillcheck(user, SKILL_FIREARMS, SKILL_FIREARMS_TRAINED))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return 0
	if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_UPP)
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return 0

