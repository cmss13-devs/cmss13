//-------------------------------------------------------
//SMARTGUN

//Come get some.
/obj/item/weapon/gun/smartgun
	name = "\improper M56A2 smartgun"
	desc = "The actual firearm in the 4-piece M56A2 Smartgun System. Essentially a heavy, mobile machinegun."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/machineguns.dmi'
	icon_state = "m56"
	item_state = "m56"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/suit_storage/guns_by_type/smartguns.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/guns_by_type/smartguns.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/smartguns_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/smartguns_righthand.dmi'
	)
	mouse_pointer = 'icons/effects/mouse_pointer/smartgun_mouse.dmi'

	fire_sound = "gun_smartgun"
	fire_rattle = "gun_smartgun_rattle"
	reload_sound = 'sound/weapons/handling/gun_sg_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_sg_unload.ogg'

	//Onmob is huge there
	worn_x_dimension = 64
	inhand_x_dimension = 64
	hud_offset = -8
	pixel_x = -8

	current_mag = /obj/item/ammo_magazine/smartgun
	flags_equip_slot = NO_FLAGS
	w_class = SIZE_HUGE
	force = 20
	wield_delay = WIELD_DELAY_FAST
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	unacidable = TRUE
	explo_proof = TRUE

	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	gun_category = GUN_CATEGORY_HEAVY
	auto_retrieval_slot = WEAR_J_STORE
	start_semiauto = FALSE
	start_automatic = TRUE

	ammo = /datum/ammo/bullet/smartgun
	actions_types = list(
		/datum/action/item_action/smartgun/toggle_accuracy_improvement,
		/datum/action/item_action/smartgun/toggle_ammo_type,
		/datum/action/item_action/smartgun/toggle_auto_fire,
		/datum/action/item_action/smartgun/toggle_frontline_mode,
		/datum/action/item_action/smartgun/toggle_lethal_mode,
		/datum/action/item_action/smartgun/toggle_motion_detector,
		/datum/action/item_action/smartgun/toggle_recoil_compensation,
	)
	attachable_allowed = list()

	var/obj/item/smartgun_battery/battery = null
	/// Whether the smartgun drains the battery (Ignored if requires_battery is false)
	var/requires_power = TRUE
	/// Whether the smartgun requires a battery
	var/requires_battery = TRUE
	/// Whether the smartgun requires a harness to use
	var/requires_harness = TRUE

	/// The current normal ammo datum
	var/datum/ammo/ammo_primary //Toggled ammo type
	/// The current AP ammo datum
	var/datum/ammo/ammo_secondary //Toggled ammo type
	/// Non-Frontline mode normal ammo datum
	var/datum/ammo/ammo_primary_def = /datum/ammo/bullet/smartgun
	/// Non-Frontline mode AP ammo datum
	var/datum/ammo/ammo_secondary_def = /datum/ammo/bullet/smartgun/armor_piercing
	/// Frontline mode normal ammo datum
	var/datum/ammo/ammo_primary_alt = /datum/ammo/bullet/smartgun/alt
	/// Frontline mode AP ammo datum
	var/datum/ammo/ammo_secondary_alt = /datum/ammo/bullet/smartgun/armor_piercing/alt
	/// Whether IFF mode is toggled on
	var/iff_enabled = TRUE //Begin with the safety on.
	/// Whether Frontline mode is toggled on
	var/frontline_enabled = FALSE //Begin with Frontline mode off.
	/// Whether we are using AP ammo currently
	var/secondary_toggled = FALSE
	/// If the gun should have custom overlay for cover depending on whether it has a drum or not
	var/drum_cover_overlay = TRUE
	/// If the gun has switchable ammo types
	var/can_change_ammo = TRUE
	/// If the gun has a cover that should be opened in order to reload
	var/has_cover = TRUE
	/// IFF and motion detector faction of the gun
	var/gun_faction = FACTION_MARINE
	var/recoil_compensation = 0
	var/accuracy_improvement = 0
	var/auto_fire = 0
	var/motion_detector = 0
	var/drain = 11
	var/range = 7
	var/angle = 2
	var/list/angle_list = list(180,135,90,60,30)
	var/obj/item/device/motiondetector/sg/MD
	var/long_range_cooldown = 2
	var/recycletime = 120
	var/cover_open = FALSE

	var/lock_range = 2
	var/aim_assist = FALSE
	var/image/autoshot_image

/obj/item/weapon/gun/smartgun/Initialize(mapload, ...)
	ammo_primary_def = GLOB.ammo_list[ammo_primary_def] //Gun initialize calls replace_ammo() so we need to set these first.
	ammo_secondary_def = GLOB.ammo_list[ammo_secondary_def]
	ammo_primary_alt = GLOB.ammo_list[ammo_primary_alt]
	ammo_secondary_alt = GLOB.ammo_list[ammo_secondary_alt]
	ammo_primary = ammo_primary_def
	ammo_secondary = ammo_secondary_def
	MD = new(src)
	MD.iff_signal = gun_faction
	battery = new /obj/item/smartgun_battery(src)
	muzzle_flash = "muzzle_flash_blue"
	muzzle_flash_color = COLOR_MUZZLE_BLUE
	autoshot_image = image('icons/effects/effects.dmi', null, "lock")
	autoshot_image.layer = ABOVE_XENO_LAYER
	autoshot_image.plane = GAME_PLANE
	autoshot_image.appearance_flags = RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM|KEEP_APART
	autoshot_image.alpha = 190
	. = ..()
	if(has_cover)
		desc += SPAN_INFO("\nAlt-click it to open the feed cover and allow for reloading.")
	desc += SPAN_INFO("\nYou may toggle firing restrictions by using a special action.")
	AddComponent(/datum/component/iff_fire_prevention)
	update_icon()

/obj/item/weapon/gun/smartgun/Destroy()
	ammo_primary = null
	ammo_secondary = null
	QDEL_NULL(MD)
	QDEL_NULL(battery)
	. = ..()

/obj/item/weapon/gun/smartgun/cock(mob/user)
	to_chat(user, SPAN_WARNING("You can't manually unload a smartgun's chamber!"))
	return

/obj/item/weapon/gun/smartgun/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 17, "rail_y" = 18, "under_x" = 22, "under_y" = 14, "stock_x" = 22, "stock_y" = 14)

/obj/item/weapon/gun/smartgun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SG)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_8
	fa_max_scatter = SCATTER_AMOUNT_TIER_9
	if(accuracy_improvement)
		accuracy_mult += HIT_ACCURACY_MULT_TIER_3
	else
		accuracy_mult += HIT_ACCURACY_MULT_TIER_1
	if(recoil_compensation)
		scatter = SCATTER_AMOUNT_TIER_10
		recoil = RECOIL_OFF
	else
		scatter = SCATTER_AMOUNT_TIER_6
		recoil = RECOIL_AMOUNT_TIER_3
		damage_mult = BASE_BULLET_DAMAGE_MULT
	if(!iff_enabled || frontline_enabled)
		ammo_primary = ammo_primary_alt
		ammo_secondary = ammo_secondary_alt
	else
		ammo_primary = ammo_primary_def
		ammo_secondary = ammo_secondary_def
	ammo = secondary_toggled ? ammo_secondary : ammo_primary

/obj/item/weapon/gun/smartgun/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/smartgun/get_examine_text(mob/user)
	. = ..()
	var/rounds = 0
	if(current_mag && current_mag.current_rounds)
		rounds = current_mag.current_rounds
	var/message = "[rounds ? "Ammo counter shows [rounds] round\s remaining." : "It's dry."]"
	. += message
	. += "Frontline mode is [frontline_enabled ?  "<B>on</b>" : "<B>off</b>"]."
	. += "The restriction system is [iff_enabled ? "<B>on</b>" : "<B>off</b>"]."

	if(battery && get_dist(user, src) <= 1)
		. += "A small gauge on [battery] reads: Power: [battery.power_cell.charge] / [battery.power_cell.maxcharge]."

/obj/item/weapon/gun/smartgun/clicked(mob/user, list/mods)
	if(mods[ALT_CLICK])
		if(!CAN_PICKUP(user, src))
			return ..()
		if(!locate(src) in list(user.get_active_hand(), user.get_inactive_hand()))
			return TRUE
		if(user.get_active_hand() && user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("You can't do that with your hands full!"))
			return TRUE
		if(has_cover)
			if(!cover_open)
				playsound(src.loc, 'sound/handling/smartgun_open.ogg', 50, TRUE, 3)
				to_chat(user, SPAN_NOTICE("You open \the [src]'s feed cover, allowing the drum to be removed."))
				cover_open = TRUE
			else
				playsound(src.loc, 'sound/handling/smartgun_close.ogg', 50, TRUE, 3)
				to_chat(user, SPAN_NOTICE("You close \the [src]'s feed cover."))
				cover_open = FALSE
		update_icon()
		return TRUE
	else
		return ..()

/obj/item/weapon/gun/smartgun/attackby(obj/item/attacking_object, mob/user)
	if(istype(attacking_object, /obj/item/smartgun_battery))
		var/obj/item/smartgun_battery/new_cell = attacking_object
		visible_message(SPAN_NOTICE("[user] swaps out the power cell in [src]."),
			SPAN_NOTICE("You swap out the power cell in [src] and drop the old one."))
		to_chat(user, SPAN_NOTICE("The new cell contains: [new_cell.power_cell.charge] power."))
		battery.update_icon()
		battery.forceMove(get_turf(user))
		battery = new_cell
		user.drop_inv_item_to_loc(new_cell, src)
		playsound(src, 'sound/machines/click.ogg', 25, 1)
		return

	return ..()

/obj/item/weapon/gun/smartgun/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	if(!cover_open && has_cover)
		to_chat(user, SPAN_WARNING("\The [src]'s feed cover is closed! You can't put a new drum in! (alt-click to open it)"))
		return
	. = ..()

/obj/item/weapon/gun/smartgun/unload(mob/user, reload_override, drop_override, loc_override)
	if(!cover_open && has_cover)
		to_chat(user, SPAN_WARNING("\The [src]'s feed cover is closed! You can't take out the drum! (alt-click to open it)"))
		return
	. = ..()

/obj/item/weapon/gun/smartgun/get_ammo_type_chambered(mob/user)
	return ammo_primary

/obj/item/weapon/gun/smartgun/update_icon()
	. = ..()
	if(!has_cover)
		return //No cover, no overlay.
	if(!cover_open)
		if(current_mag && drum_cover_overlay)
			overlays += "+[base_gun_icon]_cover_closed_a"
		else
			overlays += "+[base_gun_icon]_cover_closed"
	else
		overlays += "+[base_gun_icon]_cover_open"

//---ability actions--\\

/datum/action/item_action/smartgun/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.is_mob_incapacitated() || G.get_active_firearm(H, FALSE) != holder_item)
		return

/datum/action/item_action/smartgun/update_button_icon()
	return

/datum/action/item_action/smartgun/toggle_motion_detector/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Motion Detector"
	button.name = name

/datum/action/item_action/smartgun/toggle_motion_detector/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_motion_detector(usr)

/datum/action/item_action/smartgun/toggle_motion_detector/update_button_icon()
	if(!holder_item)
		return
	var/obj/item/weapon/gun/smartgun/G = holder_item
	if(G.motion_detector)
		action_icon_state = "motion_detector_off"
	else
		action_icon_state = "motion_detector"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)


/datum/action/item_action/smartgun/toggle_auto_fire/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Auto Fire"
	action_icon_state = "autofire"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_auto_fire/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_auto_fire(usr)

/datum/action/item_action/smartgun/toggle_auto_fire/proc/update_icon()
	if(!holder_item)
		return
	var/obj/item/weapon/gun/smartgun/G = holder_item
	if(G.auto_fire)
		action_icon_state = "autofire_off"
	else
		action_icon_state = "autofire"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_aim_assist/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Aim Assist"

	update_icon()
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_aim_assist/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/smortgun = holder_item
	smortgun.toggle_aim_assist(usr)

/datum/action/item_action/smartgun/toggle_aim_assist/proc/update_icon()
	if(!holder_item)
		return
	var/obj/item/weapon/gun/smartgun/smortgun = holder_item
	if(smortgun.aim_assist)
		action_icon_state = "aimassist"
	else
		action_icon_state = "aimassist_off"

/datum/action/item_action/smartgun/toggle_accuracy_improvement/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Accuracy Improvement"
	action_icon_state = "accuracy_improvement"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_accuracy_improvement/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_accuracy_improvement(usr)
	if(G.accuracy_improvement)
		action_icon_state = "accuracy_improvement_off"
	else
		action_icon_state = "accuracy_improvement"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_recoil_compensation/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Recoil Compensation"
	action_icon_state = "recoil_compensation"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_recoil_compensation/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_recoil_compensation(usr)
	if(G.recoil_compensation)
		action_icon_state = "recoil_compensation_off"
	else
		action_icon_state = "recoil_compensation"
	button.overlays.Cut()
	button.overlays += image ('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_frontline_mode/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Frontline Mode"
	action_icon_state = "frontline_toggle_off"
	listen_signal = COMSIG_KB_HUMAN_WEAPON_TOGGLE_FRONTLINE_MODE
	button.name = name
	button.overlays.Cut()
	button.overlays += image ('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_frontline_mode/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/gun = holder_item
	gun.toggle_frontline_mode(owner)
	if(gun.frontline_enabled)
		action_icon_state = "frontline_toggle_on"
	else
		action_icon_state = "frontline_toggle_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_lethal_mode/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle IFF"
	action_icon_state = "iff_toggle_on"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_lethal_mode/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_lethal_mode(usr)
	if(G.iff_enabled)
		action_icon_state = "iff_toggle_on"
	else
		action_icon_state = "iff_toggle_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_ammo_type/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Ammo Type"
	action_icon_state = "ammo_swap_normal"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_ammo_type/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_ammo_type(usr)

/datum/action/item_action/smartgun/toggle_ammo_type/proc/update_icon()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	if(G.secondary_toggled)
		action_icon_state = "ammo_swap_ap"
	else
		action_icon_state = "ammo_swap_normal"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

//more general procs

/obj/item/weapon/gun/smartgun/proc/toggle_frontline_mode(mob/user, silent)
	to_chat(user, "[icon2html(src, user)] You [frontline_enabled? "<B>disable</b>" : "<B>enable</b>"] [src]'s frontline mode. You will now [frontline_enabled ? "be able to shoot through friendlies" : "deal increased damage but be unable to shoot through friendlies"].")
	if(!silent)
		balloon_alert(user, "frontline mode [frontline_enabled ? "disabled" : "enabled"]")
		playsound(loc,'sound/machines/click.ogg', 25, 1)
	frontline_enabled = !frontline_enabled
///Determines the color of the muzzle flash, depending on whether frontline mode is enabled or not.
	if (!frontline_enabled)
		muzzle_flash = "muzzle_flash_blue"
		muzzle_flash_color = COLOR_MUZZLE_BLUE
	else
		muzzle_flash = "muzzle_flash"
		muzzle_flash_color = COLOR_VERY_SOFT_YELLOW

	SEND_SIGNAL(src, COMSIG_GUN_ALT_IFF_TOGGLED, frontline_enabled)
	recalculate_attachment_bonuses()
///Having the SG check it's config after toggling frontline mode & IFF is essential, or it won't update properly.
///e.g. turning IFF off, firing once, turning IFF on will let the user fire frontline bullets over friendlies if the gun doesn't check.
	set_gun_config_values()

/obj/item/weapon/gun/smartgun/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user))
			return FALSE
		var/mob/living/carbon/human/H = user
		if(!skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_SMARTGUN) && !skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL))
			balloon_alert(user, "insufficient skills")
			return FALSE
		if(requires_harness)
			if(!H.wear_suit || !(H.wear_suit.flags_inventory & SMARTGUN_HARNESS))
				balloon_alert(user, "harness required")
				return FALSE
		if(cover_open)
			to_chat(H, SPAN_WARNING("You can't fire \the [src] with the feed cover open! (alt-click to close)"))
			balloon_alert(user, "cannot fire; feed cover open")
			return FALSE

/obj/item/weapon/gun/smartgun/unique_action(mob/user)
	if(isobserver(usr) || isxeno(usr))
		return
	if(can_change_ammo)
		toggle_ammo_type(usr)

/obj/item/weapon/gun/smartgun/proc/toggle_ammo_type(mob/user)
	secondary_toggled = !secondary_toggled
	to_chat(user, "[icon2html(src, user)] You changed [src]'s ammo preparation procedures. You now fire [secondary_toggled ? "armor piercing rounds" : "highly precise rounds"].")
	balloon_alert(user, "firing [secondary_toggled ? "armor piercing" : "highly precise"]")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	ammo = secondary_toggled ? ammo_secondary : ammo_primary
	var/datum/action/item_action/smartgun/toggle_ammo_type/TAT = locate(/datum/action/item_action/smartgun/toggle_ammo_type) in actions
	TAT.update_icon()

/obj/item/weapon/gun/smartgun/replace_ammo()
	..()
	ammo = secondary_toggled ? ammo_secondary : ammo_primary

/obj/item/weapon/gun/smartgun/proc/toggle_lethal_mode(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [iff_enabled? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s fire restriction. You will [iff_enabled ? "harm anyone in your way" : "target through IFF"].")
	balloon_alert(user, "[iff_enabled ? "disabled" : "enabled"] IFF")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	iff_enabled = !iff_enabled
	ammo = ammo_primary
	secondary_toggled = FALSE
	if(iff_enabled)
		add_bullet_trait(BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff))
		drain += 10
		MD.iff_signal = gun_faction
		SEND_SIGNAL(src, COMSIG_GUN_ALT_IFF_TOGGLED, frontline_enabled)
	if(!iff_enabled)
		remove_bullet_trait("iff")
		drain -= 10
		MD.iff_signal = null
		SEND_SIGNAL(src, COMSIG_GUN_ALT_IFF_TOGGLED, FALSE)
		recalculate_attachment_bonuses()
///Having the SG check it's config after toggling frontline mode & IFF is essential, or it won't update properly.
///e.g. turning IFF off, firing once, turning IFF on will let the user fire frontline bullets over friendlies if the gun doesn't check.
	set_gun_config_values()

/obj/item/weapon/gun/smartgun/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	if(aim_assist && !auto_fire)
		target = get_assist_target(user, target)

	if(!requires_battery)
		return ..()

	if(battery)
		if(!requires_power)
			return ..()
		if(drain_battery())
			return ..()

/obj/item/weapon/gun/smartgun/proc/drain_battery(override_drain)

	var/actual_drain = (rand(drain / 2, drain) / 25)

	if(override_drain)
		actual_drain = (rand(override_drain / 2, override_drain) / 25)

	if(battery && battery.power_cell.charge > 0)
		if(battery.power_cell.charge > actual_drain)
			battery.power_cell.charge -= actual_drain
		else
			battery.power_cell.charge = 0
			to_chat(usr, SPAN_WARNING("[src] emits a low power warning and immediately shuts down!"))
			return FALSE
		return TRUE
	if(!battery || battery.power_cell.charge == 0)
		balloon_alert(usr, "low power")
		return FALSE
	return FALSE

/obj/item/weapon/gun/smartgun/proc/toggle_recoil_compensation(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [recoil_compensation? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s recoil compensation.")
	balloon_alert(user, "recoil compensation [recoil_compensation ? "disabled" : "enabled"]")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	recoil_compensation = !recoil_compensation
	if(recoil_compensation)
		drain += 50
	else
		drain -= 50
	recalculate_attachment_bonuses() //Includes set_gun_config_values() as well as attachments.

/obj/item/weapon/gun/smartgun/proc/toggle_accuracy_improvement(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [accuracy_improvement? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s accuracy improvement.")
	balloon_alert(user, "accuracy improvement [accuracy_improvement ? "disabled" : "enabled"]")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	accuracy_improvement = !accuracy_improvement
	if(accuracy_improvement)
		drain += 50
	else
		drain -= 50
	recalculate_attachment_bonuses()

/obj/item/weapon/gun/smartgun/proc/toggle_auto_fire(mob/user)
	if(!(flags_item & WIELDED))
		to_chat(user, "[icon2html(src, usr)] You need to wield \the [src] to enable autofire.")
		return //Have to be actually be wielded.
	to_chat(user, "[icon2html(src, usr)] You [auto_fire? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s auto fire mode.")
	balloon_alert(user, "autofire [auto_fire ? "disabled" : "enabled"]")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	auto_fire = !auto_fire
	var/datum/action/item_action/smartgun/toggle_auto_fire/TAF = locate(/datum/action/item_action/smartgun/toggle_auto_fire) in actions
	TAF.update_icon()
	auto_fire()

/obj/item/weapon/gun/smartgun/proc/toggle_aim_assist(mob/user, silent)
	if(!silent)
		to_chat(user, "[icon2html(src, user)] You [aim_assist ? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s aim assist.")
		balloon_alert(user, "aim assist [aim_assist? "disabled" : "enabled"]")
		playsound(loc,'sound/machines/click.ogg', 25, 1)

	aim_assist = !aim_assist

	if(aim_assist)
		enable_auto_aim(user)
	else
		disable_auto_aim(user)

/obj/item/weapon/gun/smartgun/proc/enable_auto_aim(mob/user)
	drain += 50
	START_PROCESSING(SSobj, src)
	var/datum/action/item_action/smartgun/toggle_aim_assist/aim_assist_action = locate(/datum/action/item_action/smartgun/toggle_aim_assist) in actions
	aim_assist_action.update_icon()
	recalculate_attachment_bonuses()

/obj/item/weapon/gun/smartgun/proc/disable_auto_aim(mob/user)
	drain -= 50
	var/datum/action/item_action/smartgun/toggle_aim_assist/aim_assist_action = locate(/datum/action/item_action/smartgun/toggle_aim_assist) in actions
	aim_assist_action.update_icon()
	recalculate_attachment_bonuses()

/obj/item/weapon/gun/smartgun/proc/reset_autoshot_image()
	autoshot_image.loc = null
	autoshot_image.pixel_x = 0
	autoshot_image.pixel_y = 0

/obj/item/weapon/gun/smartgun/proc/set_autoshot_image(mob/living/target)
	autoshot_image.loc = target
	autoshot_image.pixel_x = -target.pixel_x // -16 is counted by -(-16)
	autoshot_image.pixel_y = -target.pixel_y

/obj/item/weapon/gun/smartgun/proc/auto_fire()
	if(auto_fire)
		drain += 150
		START_PROCESSING(SSobj, src)
	else
		drain -= 150

/obj/item/weapon/gun/smartgun/process()
	if(!auto_fire && !motion_detector && !aim_assist)
		STOP_PROCESSING(SSobj, src)
	if(aim_assist && last_fired + 1 SECONDS <= world.time)
		reset_autoshot_image()
	if(auto_fire)
		auto_prefire()
	if(motion_detector)
		recycletime--
		if(!recycletime)
			recycletime = initial(recycletime)
			MD.refresh_blip_pool()

		long_range_cooldown--
		if(long_range_cooldown)
			return
		long_range_cooldown = initial(long_range_cooldown)
		MD.scan()

/obj/item/weapon/gun/smartgun/proc/auto_prefire(warned) //To allow the autofire delay to properly check targets after waiting.
	if(ishuman(loc) && (flags_item & WIELDED))
		var/human_user = loc
		target = get_target(human_user)
		process_shot(human_user, warned)
	else
		auto_fire = FALSE
		var/datum/action/item_action/smartgun/toggle_auto_fire/TAF = locate(/datum/action/item_action/smartgun/toggle_auto_fire) in actions
		TAF.update_icon()
		auto_fire()

/obj/item/weapon/gun/smartgun/proc/get_assist_target(mob/living/user, target)
	if(!aim_assist)
		return target

	var/dist_unconscious = 9999
	var/dist_conscious = 9999

	var/mob/living/unconscious_target = null
	var/mob/living/conscious_target = null
	for(var/mob/living/targetted_mob in range(lock_range, target) & oviewers(user.get_maximum_view_range(), user))
		if(targetted_mob.invisibility)
			continue
		if(HAS_TRAIT(targetted_mob, TRAIT_ABILITY_BURROWED))
			continue
		if(targetted_mob.is_ventcrawling)
			continue
		if(targetted_mob.stat == DEAD)
			continue // No dead or non living.

		if(iff_enabled && targetted_mob.get_target_lock(user.faction_group))
			continue

		var/dist = get_dist_sqrd(user, targetted_mob)

		if(targetted_mob.stat == UNCONSCIOUS && dist_unconscious > dist)
			dist_unconscious = dist
			unconscious_target = targetted_mob
		else if(dist_conscious > dist)
			dist_conscious = dist
			conscious_target = targetted_mob

	if(conscious_target)
		set_autoshot_image(conscious_target)
		. = conscious_target
	else if(unconscious_target)
		set_autoshot_image(unconscious_target)
		. = unconscious_target
	else
		. = target
		reset_autoshot_image()

/obj/item/weapon/gun/smartgun/wield(mob/living/user)
	. = ..()
	user.client.images |= autoshot_image

/obj/item/weapon/gun/smartgun/unwield(mob/user)
	. = ..()
	user.client?.images -= autoshot_image
	reset_autoshot_image()

/obj/item/weapon/gun/smartgun/proc/get_target(mob/living/user)
	var/list/conscious_targets = list()
	var/list/unconscious_targets = list()
	var/list/turf/path = list()
	var/turf/T

	for(var/mob/living/M in orange(range, user)) // orange allows sentry to fire through gas and darkness
		if((M.stat & DEAD))
			continue // No dead or non living.

		if(M.get_target_lock(user.faction_group))
			continue
		if(angle > 0)
			var/opp
			var/adj

			switch(user.dir)
				if(NORTH)
					opp = user.x-M.x
					adj = M.y-user.y
				if(SOUTH)
					opp = user.x-M.x
					adj = user.y-M.y
				if(EAST)
					opp = user.y-M.y
					adj = M.x-user.x
				if(WEST)
					opp = user.y-M.y
					adj = user.x-M.x

			var/r = 9999
			if(adj != 0)
				r = abs(opp/adj)
			var/angledegree = arcsin(r/sqrt(1+(r*r)))
			if(adj < 0)
				continue

			if((angledegree*2) > angle_list[angle])
				continue

		path = get_line(user, M)

		if(length(path))
			var/blocked = FALSE
			for(T in path)
				if(T.density || T.opacity)
					blocked = TRUE
					break
				for(var/obj/structure/S in T)
					if(S.opacity)
						blocked = TRUE
						break
				for(var/obj/structure/machinery/MA in T)
					if(MA.opacity)
						blocked = TRUE
						break
				if(blocked)
					break
			if(blocked)
				continue
			if(M.stat & UNCONSCIOUS)
				unconscious_targets += M
			else
				conscious_targets += M

	if(length(conscious_targets))
		. = pick(conscious_targets)
	else if(length(unconscious_targets))
		. = pick(unconscious_targets)

/obj/item/weapon/gun/smartgun/proc/process_shot(mob/living/user, warned)
	set waitfor = 0


	if(!target)
		return //Acquire our victim.

	if(!ammo)
		return

	if(target && (world.time-last_fired >= 3)) //Practical firerate is limited mainly by process delay; this is just to make sure it doesn't fire too soon after a manual shot or slip a shot into an ongoing burst.
		if(world.time-last_fired >= 300 && !warned) //if we haven't fired for a while, beep first
			playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
			addtimer(CALLBACK(src, /obj/item/weapon/gun/smartgun/proc/auto_prefire, TRUE), 3)
			return

		Fire(target,user)

	target = null

/obj/item/weapon/gun/smartgun/proc/toggle_motion_detector(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [motion_detector? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s motion detector.")
	balloon_alert(user, "motion detector [motion_detector ? "disabled" : "enabled"]")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	motion_detector = !motion_detector
	var/datum/action/item_action/smartgun/toggle_motion_detector/TMD = locate(/datum/action/item_action/smartgun/toggle_motion_detector) in actions
	TMD.update_button_icon()
	motion_detector()

/obj/item/weapon/gun/smartgun/proc/motion_detector()
	if(motion_detector)
		drain += 15
		START_PROCESSING(SSobj, src)
	else
		drain -= 15

//CO SMARTGUN
/obj/item/weapon/gun/smartgun/co
	name = "\improper M56A2C 'Cavalier' smartgun"
	desc = "The actual firearm in the 4-piece M56A2C Smartgun system. Back order only. Besides a more robust weapons casing, an ID lock system and a fancy paintjob, the gun's performance is identical to the standard-issue M56A2.\nAlt-click it to open the feed cover and allow for reloading."
	icon_state = "m56c"
	item_state = "m56c"
	random_cosmetic_chance = 10
	random_spawn_cosmetic = list(
		/obj/item/attachable/cosmetic/uscm_flag,
	)
	var/mob/living/carbon/human/linked_human
	var/is_locked = TRUE

/obj/item/weapon/gun/smartgun/co/Initialize(mapload, ...)
	LAZYADD(actions_types, /datum/action/item_action/co_sg/toggle_id_lock)
	. = ..()

/obj/item/weapon/gun/smartgun/co/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 17, "rail_y" = 18, "under_x" = 22, "under_y" = 14, "stock_x" = 22, "stock_y" = 14, "cosmetic_x" = 16, "cosmetic_y" = 16)

/obj/item/weapon/gun/smartgun/co/update_icon()
	. = ..()
	if(locate(/obj/item/attachable/cosmetic/uscm_flag) in src)
		item_state = "m56c_flag"
		item_state_slots[WEAR_J_STORE] ="m56c_flag"
		item_state_slots[WEAR_BACK] ="m56c_flag"

/obj/item/weapon/gun/smartgun/co/able_to_fire(mob/user)
	. = ..()
	if(is_locked && linked_human && linked_human != user)
		if(linked_human.is_revivable() || linked_human.stat != DEAD)
			to_chat(user, SPAN_WARNING("[icon2html(src, usr)] Trigger locked by [src]. Unauthorized user."))
			playsound(loc,'sound/weapons/gun_empty.ogg', 25, 1)
			return FALSE

		UnregisterSignal(linked_human, COMSIG_PARENT_QDELETING)
		linked_human = null
		is_locked = FALSE

// ID lock action \\

/datum/action/item_action/co_sg/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/co/protag_gun = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/protagonist = owner
	if(protagonist.is_mob_incapacitated() || protag_gun.get_active_firearm(protagonist, FALSE) != holder_item)
		return

/datum/action/item_action/co_sg/update_button_icon()
	return

/datum/action/item_action/co_sg/toggle_id_lock/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle ID lock"
	action_icon_state = "id_lock_locked"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/co_sg/toggle_id_lock/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/co/protag_gun = holder_item
	protag_gun.toggle_lock()
	if(protag_gun.is_locked)
		action_icon_state = "id_lock_locked"
	else
		action_icon_state = "id_lock_unlocked"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/obj/item/weapon/gun/smartgun/co/proc/toggle_lock(mob/user)
	if(linked_human && usr != linked_human)
		to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] Action denied by \the [src]. Unauthorized user."))
		return
	else if(!linked_human)
		name_after_co(usr)

	is_locked = !is_locked
	to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] You [is_locked? "lock": "unlock"] \the [src]."))
	playsound(loc,'sound/machines/click.ogg', 25, 1)

// action end \\

/obj/item/weapon/gun/smartgun/co/pickup(user)
	. = ..()
	if(!linked_human)
		src.name_after_co(user, src)
		to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] You pick up \the [src], registering yourself as its owner."))

/obj/item/weapon/gun/smartgun/co/proc/name_after_co(mob/living/carbon/human/H, obj/item/weapon/gun/smartgun/co/I)
	linked_human = H
	RegisterSignal(linked_human, COMSIG_PARENT_QDELETING, PROC_REF(remove_idlock))

/obj/item/weapon/gun/smartgun/co/get_examine_text()
	. = ..()
	if(linked_human)
		if(is_locked)
			. += SPAN_NOTICE("It is registered to [linked_human].")
		else
			. += SPAN_NOTICE("It is registered to [linked_human] but has its fire restrictions unlocked.")
	else
		. += SPAN_NOTICE("It's unregistered. Pick it up to register yourself as its owner.")
	if(!iff_enabled)
		. += SPAN_WARNING("Its IFF restrictions are disabled.")

/obj/item/weapon/gun/smartgun/co/proc/remove_idlock()
	SIGNAL_HANDLER
	linked_human = null

// Normal smartgun but with autoaim option
/obj/item/weapon/gun/smartgun/autoaim
	desc = "The actual firearm in the 4-piece M56A2 Smartgun System. Essentially a heavy, mobile machinegun. This upgraded variant features new, updated tracking software."
	actions_types = list(
		/datum/action/item_action/smartgun/toggle_accuracy_improvement,
		/datum/action/item_action/smartgun/toggle_ammo_type,
		/datum/action/item_action/smartgun/toggle_aim_assist,
		/datum/action/item_action/smartgun/toggle_frontline_mode,
		/datum/action/item_action/smartgun/toggle_lethal_mode,
		/datum/action/item_action/smartgun/toggle_motion_detector,
		/datum/action/item_action/smartgun/toggle_recoil_compensation,
	)

/obj/item/weapon/gun/smartgun/autoaim/Initialize(mapload, ...)
	. = ..()
	toggle_aim_assist(null, TRUE)

//TERMINATOR SMARTGUN
/obj/item/weapon/gun/smartgun/terminator
	name = "\improper M57R 'Terminator' smartgun"
	desc = "The actual experimental firearm in the 4-piece M57R Smartgun System. Essentially a heavy, mobile machinegun. This one looks slightly outdated, but far more menacing."
	icon_state = "m50r"
	item_state = "m50r"
	can_change_ammo = FALSE //Only one ammo type, no toggling.
	current_mag = /obj/item/ammo_magazine/smartgun/heap
	ammo_primary_def = /datum/ammo/bullet/smartgun/heap
	actions_types = list(
		/datum/action/item_action/smartgun/toggle_accuracy_improvement,
		/datum/action/item_action/smartgun/toggle_frontline_mode,
		/datum/action/item_action/smartgun/toggle_aim_assist,
		/datum/action/item_action/smartgun/toggle_lethal_mode,
		/datum/action/item_action/smartgun/toggle_motion_detector,
		/datum/action/item_action/smartgun/toggle_recoil_compensation,
	)

/obj/item/weapon/gun/smartgun/terminator/Initialize(mapload, ...)
	. = ..()
	toggle_aim_assist(null, TRUE)

/obj/item/weapon/gun/smartgun/terminator/low_threat
	current_mag = /obj/item/ammo_magazine/smartgun
	ammo_primary_def = /datum/ammo/bullet/smartgun

/obj/item/weapon/gun/smartgun/l56a2
	name = "\improper L56A2 smartgun"
	desc = "The actual firearm in the 4-piece L56A2 Smartgun System. If you have this, you're about to bring some serious pain to anyone in your way."
	desc_lore = "Originally produced for the Three World Empires Royal Marines forces, it mostly ended up in hands of W-Y PMCs and other affiliated forces, with Three World Empire giving preference for other design, that is still produced by W-Y regardless. Compared to more commonly used M56A2, it has improved recoil control, better electronics and advanced tracking software."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/WY/machineguns.dmi'
	icon_state = "l56d"
	item_state = "l56d"
	flags_gun_features = GUN_WY_RESTRICTED|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	drum_cover_overlay = FALSE
	gun_faction = FACTION_PMC
	has_cover = FALSE
	actions_types = list(
		/datum/action/item_action/smartgun/toggle_accuracy_improvement,
		/datum/action/item_action/smartgun/toggle_ammo_type,
		/datum/action/item_action/smartgun/toggle_aim_assist,
		/datum/action/item_action/smartgun/toggle_frontline_mode,
		/datum/action/item_action/smartgun/toggle_lethal_mode,
		/datum/action/item_action/smartgun/toggle_motion_detector,
		/datum/action/item_action/smartgun/toggle_recoil_compensation,
	)

/obj/item/weapon/gun/smartgun/l56a2/Initialize(mapload, ...)
	. = ..()
	toggle_aim_assist(null, TRUE)
	AddElement(/datum/element/corp_label/wy)

/obj/item/weapon/gun/smartgun/l56a2/elite
	name = "\improper L56A2D 'Dirty' smartgun"
	desc = "The actual firearm in the 4-piece L56A2D Smartgun System. If you have this, you're about to bring some serious pain to anyone in your way."
	desc_lore = "Essentially a reuse of a proof of concept originally made as M57D, utilizing depleted uranium rounds, this one reuses same ideas on a basis of a more robust L56A2 smartgun."
	current_mag = /obj/item/ammo_magazine/smartgun/dirty
	ammo = /obj/item/ammo_magazine/smartgun/dirty
	ammo_primary_def = /datum/ammo/bullet/smartgun/dirty
	ammo_secondary_def = /datum/ammo/bullet/smartgun/dirty/armor_piercing
	ammo_primary_alt = /datum/ammo/bullet/smartgun/dirty/alt
	ammo_secondary_alt = /datum/ammo/bullet/smartgun/dirty/armor_piercing/alt

/obj/item/weapon/gun/smartgun/l56a2/elite/set_gun_config_values()
	..()
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	if(!recoil_compensation)
		scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_10
	fa_max_scatter = SCATTER_AMOUNT_NONE


// CLF SMARTGUN

#define CLF_SMARTGUN_UNJAM_CHANCE 20

/obj/item/weapon/gun/smartgun/clf
	name = "\improper scavenged M56 'Freedom' smartgun"
	desc = "A smartgun abomination made from salvaged-parts sloppily wired and welded together, it appears to be rusted across it's frame. As whoever made this thing, clearly had no resources or proper tools to assemble it to an efficient usable state."
	desc_lore = {"After long-fiery battles that partook within the Neroid Sector of the frontier, the United States Colonial Marines were pushed out by Colonial Liberation Front cells. Through a set of tactics, utilizing guerilla warfare mostly based around hit-and runs to compensate for the lack of proper logistics.

		On it's aftermath gear unrecovered was left on the way, which the front proceeded to use to their own advantage. Taking what they could from the corpses of the infantry left behind to cover their needs, the mechanisms and electronics from the M56A2's were extracted from the broken-down exemplarys. Then placed into a makeshift frame although primitive and rudimentary due to no detailed schematics or resources at hand. Then issued out as  a desperate measure of giving an equal fire-support weapon to it's troops.

		After studys done on this frankenstein of a weapon by the USCM, it reportedly was using parts from the slightly outdated M56, mainly it's barrel to outfit it, as  an unintentioned flaw it jams constantly requiring extensive  and frequent maintenance making it almost unreliable. The M57 and L56A2 were also scrapped for spare-parts to put it together, as the rarity of parts themselves was a prominent fabrication issue for the insurgency cells."}
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony/machineguns.dmi'
	icon_state = "m56f"
	item_state = "m56f"
	random_spawn_chance = 100
	random_cosmetic_chance = 100
	current_mag = /obj/item/ammo_magazine/smartgun/rusty
	random_spawn_cosmetic = list(
		/obj/item/attachable/cosmetic/clf_flag,
		/obj/item/attachable/cosmetic/clf_rags,
		/obj/item/attachable/cosmetic/clf_sling,
	)
	gun_faction = FACTION_CLF
	var/jammed = FALSE

/obj/item/weapon/gun/smartgun/clf/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT - BULLET_DAMAGE_MULT_TIER_1 //Rusty, salvaged and worn, what did you expect?

/obj/item/weapon/gun/smartgun/clf/update_icon()
	. = ..()
	if(locate(/obj/item/attachable/cosmetic/clf_flag) in src)
		item_state = "m56f_flag"
		item_state_slots[WEAR_J_STORE] ="m56f_flag"
		item_state_slots[WEAR_BACK] ="m56f_flag"
	else if(locate(/obj/item/attachable/cosmetic/clf_rags) in src)
		item_state = "m56f_rags"
		item_state_slots[WEAR_J_STORE] ="m56f_rags"
		item_state_slots[WEAR_BACK] ="m56f_rags"
	else if(locate(/obj/item/attachable/cosmetic/clf_sling) in src)
		item_state = "m56f_sling"
		item_state_slots[WEAR_J_STORE] ="m56f_sling"
		item_state_slots[WEAR_BACK] ="m56f_sling"
	else
		item_state = "m56f"
		item_state_slots[WEAR_J_STORE] ="m56f"
		item_state_slots[WEAR_BACK] ="m56f"

/obj/item/weapon/gun/smartgun/clf/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 17, "rail_y" = 18, "under_x" = 22, "under_y" = 14, "stock_x" = 22, "stock_y" = 14, "cosmetic_x" = 16, "cosmetic_y" = 16)

/obj/item/weapon/gun/smartgun/clf/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	if(jammed)
		if(world.time % 3)
			playsound(src, 'sound/weapons/handling/gun_jam_click.ogg', 35, TRUE)
			to_chat(user, SPAN_WARNING("Your gun is jammed! Mash Unique-Action to unjam it!"))
			balloon_alert(user, "*jammed*")
		return NONE
	else if(prob(0.6)) //0.6% chance to jam on fire
		jammed = TRUE
		playsound(src, 'sound/weapons/handling/gun_jam_initial_click.ogg', 50, FALSE)
		user.visible_message(SPAN_DANGER("[src] makes a noticeable clicking noise!"), SPAN_HIGHDANGER("\The [src] suddenly jams and refuses to fire! Mash Unique-Action to unjam it."))
		balloon_alert(user, "*jammed*")
		return NONE
	else if(prob(0.8)) //0.8% chance to malfunction on fire
		switch(rand(1, 7))
			if(1)
				toggle_accuracy_improvement(user)
			if(2)
				toggle_auto_fire(user)
			if(3)
				toggle_frontline_mode(user)
			if(4)
				toggle_motion_detector(user)
			if(5)
				toggle_recoil_compensation(user)
			if(6)
				toggle_ammo_type(user)
			if(7)
				toggle_lethal_mode(user)
		to_chat(user, SPAN_HIGHDANGER("The [src] electronics malfunctions!"))
		var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
		sparks.set_up(5, 3, src)
		sparks.start()
		playsound(src, pick('sound/machines/resource_node/node_marine_die_2.ogg', 'sound/machines/resource_node/node_marine_die.ogg'), 50, FALSE)
	else
		return ..()

/obj/item/weapon/gun/smartgun/clf/unique_action(mob/user)
	if(jammed)
		if(prob(CLF_SMARTGUN_UNJAM_CHANCE))
			to_chat(user, SPAN_GREEN("You successfully unjam \the [src]!"))
			playsound(src, 'sound/weapons/handling/gun_jam_rack_success.ogg', 50, FALSE)
			jammed = FALSE
			cock_cooldown += 1 SECONDS //so they don't accidentally cock a bullet away
			balloon_alert(user, "*unjammed!*")
		else
			to_chat(user, SPAN_NOTICE("You start wildly racking the bolt back and forth attempting to unjam \the [src]!"))
			playsound(src, "gun_jam_rack", 50, FALSE)
			balloon_alert(user, "*rack*")
		return
	. = ..()

/obj/item/weapon/gun/smartgun/clf/plain
	name = "\improper scavenged M56 smartgun"
	random_spawn_chance = 0
	random_cosmetic_chance = 0

/obj/item/weapon/gun/smartgun/clf/no_flag
	random_spawn_cosmetic = list(
		/obj/item/attachable/cosmetic/clf_rags,
		/obj/item/attachable/cosmetic/clf_sling,
	)

/obj/item/weapon/gun/smartgun/clf/flag
	starting_attachment_types = list(/obj/item/attachable/cosmetic/clf_flag)
	random_spawn_chance = 0
	random_cosmetic_chance = 0

#undef CLF_SMARTGUN_UNJAM_CHANCE

/obj/item/weapon/gun/smartgun/admin
	requires_power = FALSE
	requires_battery = FALSE
	requires_harness = FALSE

/obj/item/smartgun_battery
	name = "\improper DV9 smartgun battery"
	desc = "A standard-issue 9-volt lithium dry-cell battery, most commonly used within the USCMC to power smartguns. Per the manual, one battery is good for up to 50000 rounds and plugs directly into the smartgun's power receptacle, which is only compatible with this type of battery. Various auxiliary modes usually bring the round count far lower. While this cell is incompatible with most standard electrical system, it can be charged by common rechargers in a pinch. USCMC smartgunners often guard them jealously."

	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "smartguncell"

	force = 5
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL

	var/obj/item/cell/high/power_cell

/obj/item/smartgun_battery/Initialize(mapload)
	. = ..()

	power_cell = new(src)

/obj/item/smartgun_battery/Destroy()
	QDEL_NULL(power_cell)
	return ..()

/obj/item/smartgun_battery/get_examine_text(mob/user)
	. = ..()

	. += SPAN_NOTICE("The power indicator reads [power_cell.charge] charge out of [power_cell.maxcharge] total.")

/obj/item/weapon/gun/smartgun/rmc
	name = "\improper L56A1 smartgun"
	desc = "The actual firearm in the 2-piece L56A2 Smartgun System. This variant is used by the Three World Empires Royal Marines Commando units."
	desc_lore = "The L56A1 is a W-Y licensed copy of the original M56 developed for the USMC, this version was marketed to the 3WE's Royal Marines as having a lighter weight construction and as being more reliable then the LMG's in service at the time."
	current_mag = /obj/item/ammo_magazine/smartgun/holo_targetting
	ammo = /obj/item/ammo_magazine/smartgun/holo_targetting
	ammo_primary_def = /datum/ammo/bullet/smartgun/holo_target
	ammo_secondary_def = /datum/ammo/bullet/smartgun/holo_target/ap
	ammo_primary_alt = /datum/ammo/bullet/smartgun/holo_target/alt
	ammo_secondary_alt = /datum/ammo/bullet/smartgun/holo_target/ap/alt
	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/TWE/machineguns.dmi'
	icon_state = "la56"
	item_state = "la56"
	gun_faction = FACTION_TWE

/obj/item/weapon/gun/smartgun/rmc/Initialize()
	. = ..()
	AddElement(/datum/element/corp_label/wy)

/obj/item/weapon/gun/smartgun/upp
	name = "\improper RFVS37 smartgun"
	desc = "The actual firearm in the 2-piece RFVS37 Smartgun System. This experimental variant is used by the Union of Progressive Peoples units."
	desc_lore = "Seeing the successful use of the M56 and L56 by the UA and 3WE Militaries during military conflicts such as the linna 349 campaign and the the australia wars, the UPP SOF saw a need for a similar self aiming LMG for their own units, following extensive trials the NORCOMM RFVS-37 was chosen, fulfilling all of the SOF's criteria."
	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/UPP/machineguns.dmi'
	icon_state = "rfvs37"
	item_state = "rfvs37"
	current_mag = /obj/item/ammo_magazine/smartgun/upp
	mouse_pointer = 'icons/effects/mouse_pointer/upp_smartgun_mouse.dmi'
	gun_faction = FACTION_UPP

/obj/item/weapon/gun/smartgun/upp/Initialize()
	. = ..()
	AddElement(/datum/element/corp_label/norcomm)

//  Solar devils SG, frontline mode only

/obj/item/weapon/gun/smartgun/pve
	desc = "The actual firearm in the 4-piece M56A2 Smartgun System. This is a variant used by the Solar Devils Batallion, utilizing a 'frontline only' IFF system that refuses to fire if a friendly would be hit."
	actions_types = list(
		/datum/action/item_action/smartgun/toggle_accuracy_improvement,
		/datum/action/item_action/smartgun/toggle_ammo_type,
		/datum/action/item_action/smartgun/toggle_auto_fire,
		/datum/action/item_action/smartgun/toggle_lethal_mode,
		/datum/action/item_action/smartgun/toggle_motion_detector,
		/datum/action/item_action/smartgun/toggle_recoil_compensation,
	)

/obj/item/weapon/gun/smartgun/pve/Initialize(mapload, ...)
	. = ..()
	toggle_frontline_mode(null, TRUE)

/obj/item/weapon/gun/smartgun/pve/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_3
