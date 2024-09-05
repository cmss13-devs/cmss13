/obj/item/attachable/reddot
	name = "S5 red-dot sight"
	desc = "An ARMAT S5 red-dot sight. A zero-magnification optic that offers faster, and more accurate target acquisition."
	desc_lore = "An all-weather collimator sight, designated as the AN/PVQ-64 Dot Sight. Equipped with a sunshade to increase clarity in bright conditions and resist weathering. Compact and efficient, a marvel of military design, until you realize that this is actually just an off-the-shelf design that got a military designation slapped on."
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "reddot"
	attach_icon = "reddot_a"
	slot = "rail"

/obj/item/attachable/reddot/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5

/obj/item/attachable/reflex
	name = "S6 reflex sight"
	desc = "An ARMAT S6 reflex sight. A zero-magnification alternative to iron sights with a more open optic window when compared to the S5 red-dot. Helps to reduce scatter during automated fire."
	desc_lore = "A simple folding reflex sight designated as the AN/PVG-72 Reflex Sight, compatible with most rail systems. Bulky and built to last, it can link with military HUDs for limited point-of-aim calculations."
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "reflex"
	attach_icon = "reflex_a"
	slot = "rail"

/obj/item/attachable/reflex/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	burst_scatter_mod = -1
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5

/obj/item/attachable/flashlight
	name = "rail flashlight"
	desc = "A flashlight, for rails, on guns. Can be toggled on and off. A better light source than standard M3 pattern armor lights."
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "flashlight"
	attach_icon = "flashlight_a"
	light_mod = 5
	slot = "rail"
	matter = list("metal" = 50,"glass" = 20)
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	activation_sound = 'sound/handling/light_on_1.ogg'
	deactivation_sound = 'sound/handling/click_2.ogg'
	var/original_state = "flashlight"
	var/original_attach = "flashlight_a"

	var/helm_mounted_light_power = 2
	var/helm_mounted_light_range = 3

	var/datum/action/item_action/activation
	var/obj/item/attached_item

/obj/item/attachable/flashlight/on_enter_storage(obj/item/storage/internal/S)
	..()

	if(!istype(S, /obj/item/storage/internal))
		return

	if(!istype(S.master_object, /obj/item/clothing/head/helmet/marine))
		return

	remove_attached_item()

	attached_item = S.master_object
	RegisterSignal(attached_item, COMSIG_PARENT_QDELETING, PROC_REF(remove_attached_item))
	activation = new /datum/action/item_action/toggle(src, S.master_object)

	if(ismob(S.master_object.loc))
		activation.give_to(S.master_object.loc)

/obj/item/attachable/flashlight/on_exit_storage(obj/item/storage/S)
	remove_attached_item()
	return ..()

/obj/item/attachable/flashlight/proc/remove_attached_item()
	SIGNAL_HANDLER
	if(!attached_item)
		return
	if(light_on)
		icon_state = original_state
		attach_icon = original_attach
		activate_attachment(attached_item, attached_item.loc, TRUE)
	UnregisterSignal(attached_item, COMSIG_PARENT_QDELETING)
	qdel(activation)
	attached_item.update_icon()
	attached_item = null

/obj/item/attachable/flashlight/ui_action_click(mob/owner, obj/item/holder)
	if(!attached_item)
		. = ..()
	else
		activate_attachment(attached_item, owner)

/obj/item/attachable/flashlight/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	turn_light(user, turn_off ? !turn_off : !light_on)

/obj/item/attachable/flashlight/turn_light(mob/user, toggle_on, cooldown, sparks, forced, light_again)
	. = ..()
	if(. != CHECKS_PASSED)
		return

	if(istype(attached_item, /obj/item/clothing/head/helmet/marine))
		if(!toggle_on || light_on)
			if(light_on)
				playsound(user, deactivation_sound, 15, 1)
			icon_state = original_state
			attach_icon = original_attach
			light_on = FALSE
		else
			playsound(user, activation_sound, 15, 1)
			icon_state += "-on"
			attach_icon += "-on"
			light_on = TRUE
		attached_item.update_icon()
		attached_item.set_light_range(helm_mounted_light_range)
		attached_item.set_light_power(helm_mounted_light_power)
		attached_item.set_light_on(light_on)
		activation.update_button_icon()
		return

	if(!isgun(loc))
		return

	var/obj/item/weapon/gun/attached_gun = loc

	if(toggle_on && !light_on)
		attached_gun.set_light_range(attached_gun.light_range + light_mod)
		attached_gun.set_light_power(attached_gun.light_power + (light_mod * 0.5))
		if(!(attached_gun.flags_gun_features & GUN_FLASHLIGHT_ON))
			attached_gun.set_light_on(TRUE)
			light_on = TRUE
			attached_gun.flags_gun_features |= GUN_FLASHLIGHT_ON

	if(!toggle_on && light_on)
		attached_gun.set_light_range(attached_gun.light_range - light_mod)
		attached_gun.set_light_power(attached_gun.light_power - (light_mod * 0.5))
		if(attached_gun.flags_gun_features & GUN_FLASHLIGHT_ON)
			attached_gun.set_light_on(FALSE)
			light_on = FALSE
			attached_gun.flags_gun_features &= ~GUN_FLASHLIGHT_ON

	if(attached_gun.flags_gun_features & GUN_FLASHLIGHT_ON)
		icon_state += "-on"
		attach_icon += "-on"
		playsound(user, deactivation_sound, 15, 1)
	else
		icon_state = original_state
		attach_icon = original_attach
		playsound(user, activation_sound, 15, 1)
	attached_gun.update_attachable(slot)

	for(var/X in attached_gun.actions)
		var/datum/action/A = X
		if(A.target == src)
			A.update_button_icon()
	return TRUE

// TODO: Update logic here to have a repair proc
/obj/item/attachable/flashlight/attackby(obj/item/I, mob/user)
	. = ..()
	if (. & ATTACK_HINT_BREAK_ATTACK)
		return

	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		. |= ATTACK_HINT_NO_TELEGRAPH
		to_chat(user, SPAN_NOTICE("You strip the rail flashlight of its mount, converting it to a normal flashlight."))
		if(isstorage(loc))
			var/obj/item/storage/S = loc
			S.remove_from_storage(src)
		if(loc == user)
			user.temp_drop_inv_item(src)
		var/obj/item/device/flashlight/F = new(user)
		user.put_in_hands(F) //This proc tries right, left, then drops it all-in-one.
		qdel(src) //Delete da old flashlight

/obj/item/attachable/magnetic_harness
	name = "magnetic harness"
	desc = "A magnetically attached harness kit that attaches to the rail mount of a weapon. When dropped, the weapon will sling to any set of USCM armor."
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "magnetic"
	attach_icon = "magnetic_a"
	slot = "rail"
	pixel_shift_x = 13
	var/retrieval_slot = WEAR_J_STORE

/obj/item/attachable/magnetic_harness/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_1
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/magnetic_harness/can_be_attached_to_gun(mob/user, obj/item/weapon/gun/G)
	if(SEND_SIGNAL(G, COMSIG_DROP_RETRIEVAL_CHECK) & COMPONENT_DROP_RETRIEVAL_PRESENT)
		to_chat(user, SPAN_WARNING("[G] already has a retrieval system installed!"))
		return FALSE
	return ..()

/obj/item/attachable/magnetic_harness/Attach(obj/item/weapon/gun/G)
	. = ..()
	G.AddElement(/datum/element/drop_retrieval/gun, retrieval_slot)

/obj/item/attachable/magnetic_harness/Detach(mob/user, obj/item/weapon/gun/detaching_gub)
	. = ..()
	detaching_gub.RemoveElement(/datum/element/drop_retrieval/gun, retrieval_slot)

/obj/item/attachable/scope
	name = "S8 4x telescopic scope"
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "sniperscope"
	attach_icon = "sniperscope_a"
	desc = "An ARMAT S8 telescopic eye piece. Fixed at 4x zoom. Press the 'use rail attachment' HUD icon or use the verb of the same name to zoom."
	desc_lore = "An intermediate-power Armat scope designated as the AN/PVQ-31 4x Optic. Fairly basic, but both durable and functional... enough. 780 meters is about as far as one can push the 10x24mm cartridge, really."
	slot = "rail"
	aim_speed_mod = SLOWDOWN_ADS_SCOPE //Extra slowdown when wielded
	wield_delay_mod = WIELD_DELAY_FAST
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/zoom_offset = 11
	var/zoom_viewsize = 12
	var/allows_movement = 0
	var/accuracy_scoped_buff
	var/delay_scoped_nerf
	var/damage_falloff_scoped_buff
	var/ignore_clash_fog = FALSE
	var/using_scope

/obj/item/attachable/scope/New()
	..()
	delay_mod = FIRE_DELAY_TIER_12
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	accuracy_unwielded_mod = 0

	accuracy_scoped_buff = HIT_ACCURACY_MULT_TIER_8 //to compensate initial debuff
	delay_scoped_nerf = FIRE_DELAY_TIER_11 //to compensate initial debuff. We want "high_fire_delay"
	damage_falloff_scoped_buff = -0.4 //has to be negative

/obj/item/attachable/scope/Attach(obj/item/weapon/gun/gun)
	. = ..()
	RegisterSignal(gun, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES, PROC_REF(handle_attachment_recalc))

/obj/item/attachable/scope/Detach(mob/user, obj/item/weapon/gun/detaching_gub)
	. = ..()
	UnregisterSignal(detaching_gub, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES)


/// Due to the bipod's interesting way of handling stat modifications, this is necessary to prevent exploits.
/obj/item/attachable/scope/proc/handle_attachment_recalc(obj/item/weapon/gun/source)
	SIGNAL_HANDLER

	if(!source.zoom)
		return

	if(using_scope)
		source.accuracy_mult += accuracy_scoped_buff
		source.modify_fire_delay(delay_scoped_nerf)
		source.damage_falloff_mult += damage_falloff_scoped_buff


/obj/item/attachable/scope/proc/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	if(G.zoom)
		G.accuracy_mult += accuracy_scoped_buff
		G.modify_fire_delay(delay_scoped_nerf)
		G.damage_falloff_mult += damage_falloff_scoped_buff
		using_scope = TRUE
		RegisterSignal(user, COMSIG_LIVING_ZOOM_OUT, PROC_REF(remove_scoped_buff))

/obj/item/attachable/scope/proc/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	SIGNAL_HANDLER
	UnregisterSignal(user, COMSIG_LIVING_ZOOM_OUT)
	using_scope = FALSE
	G.accuracy_mult -= accuracy_scoped_buff
	G.modify_fire_delay(-delay_scoped_nerf)
	G.damage_falloff_mult -= damage_falloff_scoped_buff

/obj/item/attachable/scope/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(turn_off || G.zoom)
		if(G.zoom)
			G.zoom(user, zoom_offset, zoom_viewsize, allows_movement)
		return TRUE

	if(!G.zoom)
		if(!(G.flags_item & WIELDED))
			if(user)
				to_chat(user, SPAN_WARNING("You must hold [G] with two hands to use [src]."))
			return FALSE
		if(MODE_HAS_FLAG(MODE_FACTION_CLASH) && !ignore_clash_fog)
			if(user)
				to_chat(user, SPAN_DANGER("You peer into [src], but it seems to have fogged up. You can't use this!"))
			return FALSE
		else
			G.zoom(user, zoom_offset, zoom_viewsize, allows_movement)
			apply_scoped_buff(G,user)
	return TRUE

//variable zoom scopes, they go between 2x and 4x zoom.

#define ZOOM_LEVEL_2X 0
#define ZOOM_LEVEL_4X 1

/obj/item/attachable/scope/variable_zoom
	name = "S10 variable zoom telescopic scope"
	desc = "An ARMAT S10 telescopic eye piece. Can be switched between 2x zoom, which allows the user to move while scoped in, and 4x zoom. Press the 'use rail attachment' HUD icon or use the verb of the same name to zoom."
	attachment_action_type = /datum/action/item_action/toggle
	var/dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC
	var/zoom_level = ZOOM_LEVEL_4X

/obj/item/attachable/scope/variable_zoom/Attach(obj/item/weapon/gun/G)
	. = ..()
	var/mob/living/living
	var/given_zoom_action = FALSE
	if(living && (G == living.l_hand || G == living.r_hand))
		give_action(living, /datum/action/item_action/toggle_zoom_level, src, G)
		given_zoom_action = TRUE
	if(!given_zoom_action)
		new /datum/action/item_action/toggle_zoom_level(src, G)

/obj/item/attachable/scope/variable_zoom/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	. = ..()
	if(G.zoom)
		G.slowdown += dynamic_aim_slowdown

/obj/item/attachable/scope/variable_zoom/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	G.slowdown -= dynamic_aim_slowdown
	..()

/obj/item/attachable/scope/variable_zoom/proc/toggle_zoom_level()
	if(using_scope)
		to_chat(usr, SPAN_WARNING("You can't change the zoom setting on the [src] while you're looking through it!"))
		return
	if(zoom_level == ZOOM_LEVEL_2X)
		zoom_level = ZOOM_LEVEL_4X
		zoom_offset = 11
		zoom_viewsize = 12
		allows_movement = 0
		to_chat(usr, SPAN_NOTICE("Zoom level switched to 4x"))
		return
	else
		zoom_level = ZOOM_LEVEL_2X
		zoom_offset = 6
		zoom_viewsize = 7
		allows_movement = 1
		to_chat(usr, SPAN_NOTICE("Zoom level switched to 2x"))
		return

/datum/action/item_action/toggle_zoom_level

/datum/action/item_action/toggle_zoom_level/New()
	..()
	name = "Toggle Zoom Level"
	button.name = name

/datum/action/item_action/toggle_zoom_level/action_activate()
	. = ..()
	var/obj/item/weapon/gun/G = holder_item
	var/obj/item/attachable/scope/variable_zoom/S = G.attachments["rail"]
	S.toggle_zoom_level()

//other variable zoom scopes

/obj/item/attachable/scope/variable_zoom/integrated
	name = "variable zoom scope"

/obj/item/attachable/scope/variable_zoom/slavic
	icon_state = "slavicscope"
	attach_icon = "slavicscope"
	desc = "Oppa! Why did you get this off glorious Stalin weapon? Blyat, put back on and do job tovarish. Yankee is not shoot self no?"

/obj/item/attachable/scope/variable_zoom/eva
	name = "RXF-M5 EVA telescopic variable scope"
	icon_state = "rxfm5_eva_scope"
	attach_icon = "rxfm5_eva_scope_a"
	desc = "A civilian-grade scope that can be switched between short and long range magnification, intended for use in extraterrestrial scouting. Looks ridiculous on a pistol."
	aim_speed_mod = 0

#undef ZOOM_LEVEL_2X
#undef ZOOM_LEVEL_4X


/obj/item/attachable/scope/mini
	name = "S4 2x telescopic mini-scope"
	icon_state = "miniscope"
	attach_icon = "miniscope_a"
	desc = "An ARMAT S4 telescoping eye piece. Fixed at a modest 2x zoom. Press the 'use rail attachment' HUD icon or use the verb of the same name to zoom."
	desc_lore = "A light-duty optic, designated as the AN/PVQ-45 2x Optic. Suited towards short to medium-range engagements. Users are advised to zero it often, as the first mass-production batch had a tendency to drift in one direction or another with sustained use."
	slot = "rail"
	zoom_offset = 6
	zoom_viewsize = 7
	allows_movement = TRUE
	aim_speed_mod = 0
	var/dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC

/obj/item/attachable/scope/mini/New()
	..()
	delay_mod = 0
	delay_scoped_nerf = FIRE_DELAY_TIER_SMG
	damage_falloff_scoped_buff = -0.2 //has to be negative

/obj/item/attachable/scope/mini/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	. = ..()
	if(G.zoom)
		G.slowdown += dynamic_aim_slowdown

/obj/item/attachable/scope/mini/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	G.slowdown -= dynamic_aim_slowdown
	..()

/obj/item/attachable/scope/mini/flaregun
	wield_delay_mod = 0
	dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC

/obj/item/attachable/scope/mini/f90
	dynamic_aim_slowdown = SLOWDOWN_ADS_NONE

/obj/item/attachable/scope/mini/flaregun/New()
	..()
	delay_mod = 0
	accuracy_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0

	accuracy_scoped_buff = HIT_ACCURACY_MULT_TIER_8
	delay_scoped_nerf = FIRE_DELAY_TIER_9

/obj/item/attachable/scope/mini/hunting
	name = "2x hunting mini-scope"
	icon_state = "huntingscope"
	attach_icon = "huntingscope"
	desc = "This civilian-grade scope is a common sight on hunting rifles due to its cheap price and great optics. Fixed at a modest 2x zoom. Press the 'use rail attachment' HUD icon or use the verb of the same name to zoom."

/obj/item/attachable/scope/mini/nsg23
	name = "W-Y S4 2x advanced telescopic mini-scope"
	desc = "An ARMAT S4 telescoping eye piece, custom-tuned by W-Y scientists to be as ergonomic as possible."
	icon_state = "miniscope_nsg23"
	attach_icon = "miniscope_nsg23_a"
	zoom_offset = 7
	dynamic_aim_slowdown = SLOWDOWN_ADS_NONE

/obj/item/attachable/scope/mini/xm88
	name = "XS-9 targeting relay"
	desc = "An ARMAT XS-9 optical interface. Unlike a traditional scope, this rail-mounted device features no telescoping lens. Instead, the firearm's onboard targeting system relays data directly to the optic for the system operator to reference in realtime."
	icon_state = "boomslang-scope"
	zoom_offset = 7
	dynamic_aim_slowdown = SLOWDOWN_ADS_NONE

/obj/item/attachable/scope/mini/xm88/New()
	..()
	select_gamemode_skin(type)
	attach_icon = icon_state

/obj/item/attachable/scope/mini_iff
	name = "B8 Smart-Scope"
	icon_state = "iffbarrel"
	attach_icon = "iffbarrel_a"
	desc = "An experimental B8 Smart-Scope. Based on the technologies used in the Smart Gun by ARMAT, this sight has integrated IFF systems. It can only attach to the M4RA Battle Rifle and M44 Combat Revolver."
	desc_lore = "An experimental fire-control optic capable of linking into compatible IFF systems on certain weapons, designated the XAN/PVG-110 Smart Scope. Currently programmed for usage with the M4RA battle rifle and M44 Combat Revolver, due to their relatively lower rates of fire. Experimental technology developed by Armat, who have assured that all previously reported issues with false-negative IFF recognitions have been solved. Make sure to check the sight after every op, just in case."
	slot = "rail"
	zoom_offset = 6
	zoom_viewsize = 7
	pixel_shift_y = 15
	var/dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC

/obj/item/attachable/scope/mini_iff/New()
	..()
	damage_mod = -BULLET_DAMAGE_MULT_TIER_4
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_6
	accuracy_unwielded_mod = 0

	accuracy_scoped_buff = HIT_ACCURACY_MULT_TIER_1
	delay_scoped_nerf = 0
	damage_falloff_scoped_buff = 0

/obj/item/attachable/scope/mini_iff/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/attachable/scope/mini_iff/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(do_after(user, 8, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		allows_movement = 1
		. = ..()

/obj/item/attachable/scope/mini_iff/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	. = ..()
	if(G.zoom)
		G.slowdown += dynamic_aim_slowdown

/obj/item/attachable/scope/mini_iff/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	G.slowdown -= dynamic_aim_slowdown
	..()

/obj/item/attachable/scope/slavic
	icon_state = "slavicscope"
	attach_icon = "slavicscope"
	desc = "Oppa! How did you get this off glorious Stalin weapon? Blyat, put back on and do job tovarish. Yankee is not shoot self no?"

/obj/item/attachable/vulture_scope // not a subtype of scope because it uses basically none of the scope's features
	name = "\improper M707 \"Vulture\" scope"
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "vulture_scope"
	attach_icon = "vulture_scope"
	desc = "A powerful yet obtrusive sight for the M707 anti-materiel rifle." // Can't be seen normally, anyway
	slot = "rail"
	aim_speed_mod = SLOWDOWN_ADS_SCOPE //Extra slowdown when wielded
	wield_delay_mod = WIELD_DELAY_FAST
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	/// Weakref to the user of the scope
	var/datum/weakref/scope_user
	/// If the scope is currently in use
	var/scoping = FALSE
	/// How far out the player should see by default
	var/start_scope_range = 12
	/// The bare minimum distance the scope can be from the player
	var/min_scope_range = 12
	/// The maximum distance the scope can be from the player
	var/max_scope_range = 25
	/// How far in the perpendicular axis the scope can move in either direction
	var/perpendicular_scope_range = 7
	/// How far in each direction the scope should see. Default human view size is 7
	var/scope_viewsize = 7
	/// The current X position of the scope within the sniper's view box. 0 is center
	var/scope_offset_x = 0
	/// The current Y position of the scope within the sniper's view box. 0 is center
	var/scope_offset_y = 0
	/// How far in any given direction the scope can drift
	var/scope_drift_max = 2
	/// The current X coord position of the scope camera
	var/scope_x = 0
	/// The current Y coord position of the scope camera
	var/scope_y = 0
	/// Ref to the scope screen element
	var/atom/movable/screen/vulture_scope/scope_element
	/// If the gun should experience scope drift
	var/scope_drift = TRUE
	/// % chance for the scope to drift on process with a spotter using their scope
	var/spotted_drift_chance = 25
	/// % chance for the scope to drift on process without a spotter using their scope
	var/unspotted_drift_chance = 90
	/// If the scope should use do_afters for adjusting and moving the sight
	var/slow_use = TRUE
	/// Cooldown for interacting with the scope's adjustment or position
	COOLDOWN_DECLARE(scope_interact_cd)
	/// If the user is currently holding their breath
	var/holding_breath = FALSE
	/// Cooldown for after holding your breath
	COOLDOWN_DECLARE(hold_breath_cd)
	/// How long you can hold your breath for
	var/breath_time = 4 SECONDS
	/// How long the cooldown for holding your breath is, only starts after breath_time finishes
	var/breath_cooldown_time = 12 SECONDS
	/// The initial dir of the scope user when scoping in
	var/scope_user_initial_dir
	/// How much to increase darkness view by
	var/darkness_view = 12
	/// If there is currently a spotter using the linked spotting scope
	var/spotter_spotting = FALSE
	/// How much time it takes to adjust the position of the scope. Adjusting the offset will take half of this time
	var/adjust_delay = 1 SECONDS

/obj/item/attachable/vulture_scope/Initialize(mapload, ...)
	. = ..()
	START_PROCESSING(SSobj, src)
	select_gamemode_skin(type)

/obj/item/attachable/vulture_scope/Destroy()
	STOP_PROCESSING(SSobj, src)
	on_unscope()
	QDEL_NULL(scope_element)
	return ..()

/obj/item/attachable/vulture_scope/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon

/obj/item/attachable/vulture_scope/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VultureScope", name)
		ui.open()

/obj/item/attachable/vulture_scope/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/obj/item/attachable/vulture_scope/ui_data(mob/user)
	var/list/data = list()
	data["offset_x"] = scope_offset_x
	data["offset_y"] = scope_offset_y
	data["valid_offset_dirs"] = get_offset_dirs()
	data["scope_cooldown"] = !COOLDOWN_FINISHED(src, scope_interact_cd)
	data["valid_adjust_dirs"] = get_adjust_dirs()
	data["breath_cooldown"] = !COOLDOWN_FINISHED(src, hold_breath_cd)
	data["breath_recharge"] = get_breath_recharge()
	data["spotter_spotting"] = spotter_spotting
	data["current_scope_drift"] = get_scope_drift_chance()
	data["time_to_fire_remaining"] = 1 - (get_time_to_fire() / FIRE_DELAY_TIER_VULTURE)
	return data

/obj/item/attachable/vulture_scope/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("adjust_dir")
			var/direction = params["offset_dir"]
			if(!(direction in GLOB.alldirs) || !scoping || !scope_user)
				return

			var/mob/scoper = scope_user.resolve()
			if(slow_use)
				if(!COOLDOWN_FINISHED(src, scope_interact_cd))
					return
				to_chat(scoper, SPAN_NOTICE("You begin adjusting [src]..."))
				COOLDOWN_START(src, scope_interact_cd, adjust_delay / 2)
				if(!do_after(scoper, 0.4 SECONDS))
					return

			adjust_offset(direction)
			. = TRUE

		if("adjust_position")
			var/direction = params["position_dir"]
			if(!(direction in GLOB.alldirs) || !scoping || !scope_user)
				return

			var/mob/scoper = scope_user.resolve()
			if(slow_use)
				if(!COOLDOWN_FINISHED(src, scope_interact_cd))
					return

				to_chat(scoper, SPAN_NOTICE("You begin moving [src]..."))
				COOLDOWN_START(src, scope_interact_cd, adjust_delay)
				if(!do_after(scoper, 0.8 SECONDS))
					return

			adjust_position(direction)
			. = TRUE

		if("hold_breath")
			if(!COOLDOWN_FINISHED(src, hold_breath_cd) || holding_breath)
				return

			hold_breath()
			. = TRUE

/obj/item/attachable/vulture_scope/process()
	if(scope_element && prob(get_scope_drift_chance())) //every 6 seconds when unspotted, on average
		scope_drift()

/// Returns a number between 0 and 100 for the chance of the scope drifting on process()
/obj/item/attachable/vulture_scope/proc/get_scope_drift_chance()
	if(!scope_drift || holding_breath)
		return 0

	if(spotter_spotting)
		return spotted_drift_chance

	else
		return unspotted_drift_chance

/// Returns how many deciseconds until the gun is able to fire again
/obj/item/attachable/vulture_scope/proc/get_time_to_fire()
	if(!istype(loc, /obj/item/weapon/gun/boltaction/vulture))
		return 0

	var/obj/item/weapon/gun/boltaction/vulture/rifle = loc
	if(!rifle.last_fired)
		return 0

	return (rifle.last_fired + rifle.get_fire_delay()) - world.time

/obj/item/attachable/vulture_scope/activate_attachment(obj/item/weapon/gun/gun, mob/living/carbon/user, turn_off)
	if(turn_off || scoping)
		on_unscope()
		return TRUE

	if(!scoping)
		if(!(gun.flags_item & WIELDED))
			to_chat(user, SPAN_WARNING("You must hold [gun] with two hands to use [src]."))
			return FALSE

		if(!HAS_TRAIT(gun, TRAIT_GUN_BIPODDED))
			to_chat(user, SPAN_WARNING("You must have a deployed bipod to use [src]."))
			return FALSE

		on_scope()
	return TRUE

/obj/item/attachable/vulture_scope/proc/get_offset_dirs()
	var/list/possible_dirs = GLOB.alldirs.Copy()
	if(scope_offset_x >= scope_drift_max)
		possible_dirs -= list(NORTHEAST, EAST, SOUTHEAST)
	else if(scope_offset_x <= -scope_drift_max)
		possible_dirs -= list(NORTHWEST, WEST, SOUTHWEST)

	if(scope_offset_y >= scope_drift_max)
		possible_dirs -= list(NORTHWEST, NORTH, NORTHEAST)
	else if(scope_offset_y <= -scope_drift_max)
		possible_dirs -= list(SOUTHWEST, SOUTH, SOUTHEAST)

	return possible_dirs

/// Gets a list of valid directions to be able to adjust the reticle in
/obj/item/attachable/vulture_scope/proc/get_adjust_dirs()
	if(!scoping)
		return list()
	var/list/possible_dirs = GLOB.alldirs.Copy()
	var/turf/current_turf = get_turf(src)
	var/turf/scope_tile = locate(scope_x, scope_y, current_turf.z)
	var/mob/scoper = scope_user.resolve()
	if(!scoper)
		return list()

	var/user_dir = scoper.dir
	var/distance = get_dist(current_turf, scope_tile)
	if(distance >= max_scope_range)
		possible_dirs -= get_related_directions(user_dir)

	else if(distance <= min_scope_range)
		possible_dirs -= get_related_directions(REVERSE_DIR(user_dir))

	if((user_dir == EAST) || (user_dir == WEST))
		if(scope_y - current_turf.y >= perpendicular_scope_range)
			possible_dirs -= get_related_directions(NORTH)

		else if(current_turf.y - scope_y >= perpendicular_scope_range)
			possible_dirs -= get_related_directions(SOUTH)

	else
		if(scope_x - current_turf.x >= perpendicular_scope_range)
			possible_dirs -= get_related_directions(EAST)

		else if(current_turf.x - scope_x >= perpendicular_scope_range)
			possible_dirs -= get_related_directions(WEST)

	return possible_dirs

/// Adjusts the position of the reticle by a tile in a given direction
/obj/item/attachable/vulture_scope/proc/adjust_offset(direction = NORTH)
	var/old_x = scope_offset_x
	var/old_y = scope_offset_y
	if((direction == NORTHEAST) || (direction == EAST) || (direction == SOUTHEAST))
		scope_offset_x = min(scope_offset_x + 1, scope_drift_max)
	else if((direction == NORTHWEST) || (direction == WEST) || (direction == SOUTHWEST))
		scope_offset_x = max(scope_offset_x - 1, -scope_drift_max)

	if((direction == NORTHWEST) || (direction == NORTH) || (direction == NORTHEAST))
		scope_offset_y = min(scope_offset_y + 1, scope_drift_max)
	else if((direction == SOUTHWEST) || (direction == SOUTH) || (direction == SOUTHEAST))
		scope_offset_y = max(scope_offset_y - 1, -scope_drift_max)

	recalculate_scope_offset(old_x, old_y)

/// Adjusts the position of the scope by a tile in a given direction
/obj/item/attachable/vulture_scope/proc/adjust_position(direction = NORTH)
	var/perpendicular_axis = "x"
	var/mob/user = scope_user.resolve()
	var/turf/user_turf = get_turf(user)
	if((user.dir == EAST) || (user.dir == WEST))
		perpendicular_axis = "y"

	if((direction == NORTHEAST) || (direction == EAST) || (direction == SOUTHEAST))
		scope_x++
		scope_x = user_turf.x + axis_math(user, perpendicular_axis, "x", direction)
	else if((direction == NORTHWEST) || (direction == WEST) || (direction == SOUTHWEST))
		scope_x--
		scope_x = user_turf.x + axis_math(user, perpendicular_axis, "x", direction)
	if((direction == NORTHWEST) || (direction == NORTH) || (direction == NORTHEAST))
		scope_y++
		scope_y = user_turf.y + axis_math(user, perpendicular_axis, "y", direction)
	else if((direction == SOUTHWEST) || (direction == SOUTH) || (direction == SOUTHEAST))
		scope_y--
		scope_y = user_turf.y + axis_math(user, perpendicular_axis, "y", direction)

	SEND_SIGNAL(src, COMSIG_VULTURE_SCOPE_MOVED)

	recalculate_scope_pos()

/// Figures out which direction the scope should move based on user direction and their input
/obj/item/attachable/vulture_scope/proc/axis_math(mob/user, perpendicular_axis = "x", modifying_axis = "x", direction = NORTH)
	var/turf/user_turf = get_turf(user)
	var/inverse = FALSE
	if((user.dir == SOUTH) || (user.dir == WEST))
		inverse = TRUE
	var/user_offset
	if(modifying_axis == "x")
		user_offset = scope_x - user_turf.x

	else
		user_offset = scope_y - user_turf.y

	if(perpendicular_axis == modifying_axis)
		return clamp(user_offset, -perpendicular_scope_range, perpendicular_scope_range)

	else
		return clamp(abs(user_offset), min_scope_range, max_scope_range) * (inverse ? -1 : 1)

/// Recalculates where the reticle should be inside the scope
/obj/item/attachable/vulture_scope/proc/recalculate_scope_offset(old_x = 0, old_y = 0)
	var/mob/scoper = scope_user.resolve()
	if(!scoper.client)
		return

	var/x_to_set = (scope_offset_x >= 0 ? "+" : "") + "[scope_offset_x]"
	var/y_to_set = (scope_offset_y >= 0 ? "+" : "") + "[scope_offset_y]"
	scope_element.screen_loc = "CENTER[x_to_set],CENTER[y_to_set]"

/// Recalculates where the scope should be in relation to the user
/obj/item/attachable/vulture_scope/proc/recalculate_scope_pos()
	if(!scope_user)
		return
	var/turf/current_turf = get_turf(src)
	var/x_off = scope_x - current_turf.x
	var/y_off = scope_y - current_turf.y
	var/pixels_per_tile = 32
	var/mob/scoper = scope_user.resolve()
	if(!scoper.client)
		return

	if(scoping)
		scoper.client.pixel_x = x_off * pixels_per_tile
		scoper.client.pixel_y = y_off * pixels_per_tile
	else
		scoper.client.pixel_x = 0
		scoper.client.pixel_y = 0

/// Handler for when the user begins scoping
/obj/item/attachable/vulture_scope/proc/on_scope()
	var/turf/gun_turf = get_turf(src)
	scope_x = gun_turf.x
	scope_y = gun_turf.y
	scope_offset_x = 0
	scope_offset_y = 0
	holding_breath = FALSE

	if(!isgun(loc))
		return

	var/obj/item/weapon/gun/gun = loc
	var/mob/living/gun_user = gun.get_gun_user()
	if(!gun_user)
		return

	switch(gun_user.dir)
		if(NORTH)
			scope_y += start_scope_range
		if(EAST)
			scope_x += start_scope_range
		if(SOUTH)
			scope_y -= start_scope_range
		if(WEST)
			scope_x -= start_scope_range

	scope_user = WEAKREF(gun_user)
	scope_user_initial_dir = gun_user.dir
	scoping = TRUE
	recalculate_scope_pos()
	gun_user.overlay_fullscreen("vulture", /atom/movable/screen/fullscreen/vulture)
	scope_element = new(src)
	gun_user.client.add_to_screen(scope_element)
	gun_user.see_in_dark += darkness_view
	gun_user.lighting_alpha = 127
	gun_user.sync_lighting_plane_alpha()
	RegisterSignal(gun, list(
		COMSIG_ITEM_DROPPED,
		COMSIG_ITEM_UNWIELD,
	), PROC_REF(on_unscope))
	RegisterSignal(gun_user, COMSIG_MOB_UNDEPLOYED_BIPOD, PROC_REF(on_unscope))
	RegisterSignal(gun_user, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(on_mob_move_look))
	RegisterSignal(gun_user.client, COMSIG_PARENT_QDELETING, PROC_REF(on_unscope))

/// Handler for when the scope is deleted, dropped, etc.
/obj/item/attachable/vulture_scope/proc/on_unscope()
	SIGNAL_HANDLER
	if(!scope_user)
		return

	var/mob/scoper = scope_user.resolve()
	if(isgun(loc))
		UnregisterSignal(loc, list(
			COMSIG_ITEM_DROPPED,
			COMSIG_ITEM_UNWIELD,
		))
	UnregisterSignal(scoper, list(COMSIG_MOB_UNDEPLOYED_BIPOD, COMSIG_MOB_MOVE_OR_LOOK))
	UnregisterSignal(scoper.client, COMSIG_PARENT_QDELETING)
	stop_holding_breath()
	scope_user_initial_dir = null
	scoper.clear_fullscreen("vulture")
	scoper.client.remove_from_screen(scope_element)
	scoper.see_in_dark -= darkness_view
	scoper.lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	scoper.sync_lighting_plane_alpha()
	QDEL_NULL(scope_element)
	recalculate_scope_pos()
	scope_user = null
	scoping = FALSE
	if(scoper.client)
		scoper.client.pixel_x = 0
		scoper.client.pixel_y = 0

/// Handler for if the mob moves or changes look direction
/obj/item/attachable/vulture_scope/proc/on_mob_move_look(mob/living/mover, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(actually_moving || (mover.dir != scope_user_initial_dir))
		on_unscope()

/// Causes the scope to drift in a random direction by 1 tile
/obj/item/attachable/vulture_scope/proc/scope_drift(forced_dir)
	var/dir_picked
	if(!forced_dir)
		dir_picked = pick(get_offset_dirs())
	else
		dir_picked = forced_dir

	adjust_offset(dir_picked)

/// Returns the turf that the sniper scope + reticle is currently focused on
/obj/item/attachable/vulture_scope/proc/get_viewed_turf()
	RETURN_TYPE(/turf)
	if(!scoping)
		return null
	var/turf/gun_turf = get_turf(src)
	return locate(scope_x + scope_offset_x, scope_y + scope_offset_y, gun_turf.z)

/// Lets the user start holding their breath, stopping gun sway for a short time
/obj/item/attachable/vulture_scope/proc/hold_breath()
	if(!scope_user)
		return

	var/mob/scoper = scope_user.resolve()
	to_chat(scoper, SPAN_NOTICE("You hold your breath, steadying your scope..."))
	holding_breath = TRUE
	INVOKE_ASYNC(src, PROC_REF(tick_down_breath_scope))
	addtimer(CALLBACK(src, PROC_REF(stop_holding_breath)), breath_time)

/// Slowly empties out the crosshair as the user's breath runs out
/obj/item/attachable/vulture_scope/proc/tick_down_breath_scope()
	scope_element.icon_state = "vulture_steady_4"
	sleep(breath_time * 0.25)
	scope_element.icon_state = "vulture_steady_3"
	sleep(breath_time * 0.25)
	scope_element.icon_state = "vulture_steady_2"
	sleep(breath_time * 0.25)
	scope_element.icon_state = "vulture_steady_1"

/// Stops the user from holding their breath, starting the cooldown
/obj/item/attachable/vulture_scope/proc/stop_holding_breath()
	if(!scope_user || !holding_breath)
		return

	var/mob/scoper = scope_user.resolve()
	to_chat(scoper, SPAN_NOTICE("You breathe out, letting your scope sway."))
	holding_breath = FALSE
	scope_element.icon_state = "vulture_unsteady"
	COOLDOWN_START(src, hold_breath_cd, breath_cooldown_time)

/// Returns a % of how much time until the user can still their breath again
/obj/item/attachable/vulture_scope/proc/get_breath_recharge()
	return 1 - (COOLDOWN_TIMELEFT(src, hold_breath_cd) / breath_cooldown_time)

/datum/action/item_action/vulture

/datum/action/item_action/vulture/action_activate()
	. = ..()
	var/obj/item/weapon/gun/gun_holder = holder_item
	var/obj/item/attachable/vulture_scope/scope = gun_holder.attachments["rail"]
	if(!istype(scope))
		return
	scope.tgui_interact(owner)
