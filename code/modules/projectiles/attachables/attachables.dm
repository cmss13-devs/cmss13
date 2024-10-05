//Gun attachable items code. Lets you add various effects to firearms.
//Some attachables are hardcoded in the projectile firing system, like grenade launchers, flamethrowers.
/*
When you are adding new guns into the attachment list, or even old guns, make sure that said guns
properly accept overlays. You can find the proper offsets in the individual gun dms, so make sure
you set them right. It's a pain to go back to find which guns are set incorrectly.
To summarize: rail attachments should go on top of the rail. For rifles, this usually means the middle of the gun.
For handguns, this is usually toward the back of the gun. SMGs usually follow rifles.
Muzzle attachments should connect to the barrel, not sit under or above it. The only exception is the bayonet.
Underrail attachments should just fit snugly, that's about it. Stocks are pretty obvious.

All attachment offsets are now in a list, including stocks. Guns that don't take attachments can keep the list null.
~N

Defined in conflicts.dm of the #defines folder.
#define ATTACH_REMOVABLE 1
#define ATTACH_ACTIVATION 2
#define ATTACH_PROJECTILE 4
#define ATTACH_RELOADABLE 8
#define ATTACH_WEAPON 16
*/

/obj/item/attachable
	name = "attachable item"
	desc = "It's the very theoretical concept of an attachment. You should never see this."
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = null
	item_state = null
	var/attach_icon //the sprite to show when the attachment is attached when we want it different from the icon_state.
	var/pixel_shift_x = 16 //Determines the amount of pixels to move the icon state for the overlay.
	var/pixel_shift_y = 16 //Uses the bottom left corner of the item.

	flags_atom =  FPRINT|CONDUCT
	matter = list("metal" = 100)
	w_class = SIZE_SMALL
	force = 1
	var/slot = null //"muzzle", "rail", "under", "stock", "special"

	/*
	Anything that isn't used as the gun fires should be a flat number, never a percentange. It screws with the calculations,
	and can mean that the order you attach something/detach something will matter in the final number. It's also completely
	inaccurate. Don't worry if force is ever negative, it won't runtime.
	*/
	//These bonuses are applied only as the gun fires a projectile.

	//These are flat bonuses applied and are passive, though they may be applied at different points.
	var/accuracy_mod = 0 //Modifier to firing accuracy, works off a multiplier.
	var/accuracy_unwielded_mod = 0 //same as above but for onehanded.
	var/damage_mod = 0 //Modifer to the damage mult, works off a multiplier.
	var/damage_falloff_mod = 0 //Modifier to damage falloff, works off a multiplier.
	var/damage_buildup_mod = 0 //Modifier to damage buildup, works off a multiplier.
	var/range_min_mod = 0 //Modifier to minimum effective range, tile value.
	var/range_max_mod = 0 //Modifier to maximum effective range, tile value.
	var/melee_mod = 0 //Changing to a flat number so this actually doesn't screw up the calculations.
	var/scatter_mod = 0 //Increases or decreases scatter chance.
	var/scatter_unwielded_mod = 0 //same as above but for onehanded firing.
	var/recoil_mod = 0 //If positive, adds recoil, if negative, lowers it. Recoil can't go below 0.
	var/recoil_unwielded_mod = 0 //same as above but for onehanded firing.
	var/burst_scatter_mod = 0 //Modifier to scatter from wielded burst fire, works off a multiplier.
	var/light_mod = 0 //Adds an x-brightness flashlight to the weapon, which can be toggled on and off.
	var/delay_mod = 0 //Changes firing delay. Cannot go below 0.
	var/burst_mod = 0 //Changes burst rate. 1 == 0.
	var/size_mod = 0 //Increases the weight class.
	var/aim_speed_mod = 0 //Changes the aiming speed slowdown of the wearer by this value.
	var/wield_delay_mod = 0 //How long ADS takes (time before firing)
	var/movement_onehanded_acc_penalty_mod = 0 //Modifies accuracy/scatter penalty when firing onehanded while moving.
	var/velocity_mod = 0 // Added velocity to bullets
	var/hud_offset_mod  = 0 //How many pixels to adjust the gun's sprite coords by. Ideally, this should keep the gun approximately centered.

	var/activation_sound = 'sound/weapons/handling/gun_underbarrel_activate.ogg'
	var/deactivation_sound = 'sound/weapons/handling/gun_underbarrel_deactivate.ogg'

	var/flags_attach_features = ATTACH_REMOVABLE

	var/current_rounds = 0 //How much it has.
	var/max_rounds = 0 //How much ammo it can store

	var/attachment_action_type

	var/hidden = FALSE //Render on gun?

	/// An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	/// that will be given to a projectile with the current ammo datum
	var/list/list/traits_to_give
	/// List of traits to be given to the gun itself.
	var/list/gun_traits

/obj/item/attachable/Initialize(mapload, ...)
	. = ..()
	set_bullet_traits()

/obj/item/attachable/proc/set_bullet_traits()
	return

/obj/item/attachable/attackby(obj/item/I, mob/user)
	. = ..()
	if (. & ATTACK_HINT_BREAK_ATTACK)
		return

	if(flags_attach_features & ATTACH_RELOADABLE)
		. |= ATTACK_HINT_NO_TELEGRAPH|ATTACK_HINT_NO_AFTERATTACK
		if(user.get_inactive_hand() != src)
			to_chat(user, SPAN_WARNING("You have to hold [src] to do that!"))
		else
			reload_attachment(I, user)

/obj/item/attachable/proc/can_be_attached_to_gun(mob/user, obj/item/weapon/gun/G)
	if(G.attachable_allowed && !(type in G.attachable_allowed) )
		to_chat(user, SPAN_WARNING("[src] doesn't fit on [G]!"))
		return FALSE
	return TRUE

/obj/item/attachable/proc/Attach(obj/item/weapon/gun/to_attach_to)
	SHOULD_CALL_PARENT(TRUE)
	ASSERT(istype(to_attach_to), "Called Attach on [src] with a non-gun argument ([to_attach_to])")

	/*
	This does not check if the attachment can be removed.
	Instead of checking individual attachments, I simply removed
	the specific guns for the specific attachments so you can't
	attempt the process in the first place if a slot can't be
	removed on a gun. can_be_removed is instead used when they
	try to strip the gun.
	*/
	if(to_attach_to.attachments[slot])
		var/obj/item/attachable/A = to_attach_to.attachments[slot]
		A.Detach(detaching_gub = to_attach_to)

	if(ishuman(loc))
		var/mob/living/carbon/human/M = src.loc
		M.drop_held_item(src)
	forceMove(to_attach_to)

	to_attach_to.attachments[slot] = src
	to_attach_to.recalculate_attachment_bonuses()

	to_attach_to.setup_firemodes()
	to_attach_to.update_force_list() //This updates the gun to use proper force verbs.

	var/mob/living/living
	if(isliving(to_attach_to.loc))
		living = to_attach_to.loc

	if(attachment_action_type)
		var/given_action = FALSE
		if(living && (to_attach_to == living.l_hand || to_attach_to == living.r_hand))
			give_action(living, attachment_action_type, src, to_attach_to)
			given_action = TRUE
		if(!given_action)
			new attachment_action_type(src, to_attach_to)

	// Sharp attachments (bayonet) make weapons sharp as well.
	if(sharp)
		to_attach_to.sharp = sharp

	for(var/trait in gun_traits)
		ADD_TRAIT(to_attach_to, trait, TRAIT_SOURCE_ATTACHMENT(slot))
	for(var/entry in traits_to_give)
		if(!to_attach_to.in_chamber)
			break
		var/list/L
		// Check if this is an ID'd bullet trait
		if(istext(entry))
			L = traits_to_give[entry].Copy()
		else
			// Prepend the bullet trait to the list
			L = list(entry) + traits_to_give[entry]
		// Apply bullet traits from attachment to gun's current projectile
		to_attach_to.in_chamber.apply_bullet_trait(L)

/obj/item/attachable/proc/Detach(mob/user, obj/item/weapon/gun/detaching_gub)
	SHOULD_CALL_PARENT(TRUE)
	ASSERT(istype(detaching_gub), "Called Detach on [src] with a non-gun argument ([detaching_gub])")

	SEND_SIGNAL(src, COMSIG_ATTACHABLE_DETACH, detaching_gub)

	if(user)
		detaching_gub.on_detach(user, src)

	if(flags_attach_features & ATTACH_ACTIVATION)
		activate_attachment(detaching_gub, null, TRUE)

	detaching_gub.attachments[slot] = null
	detaching_gub.recalculate_attachment_bonuses()

	for(var/X in detaching_gub.actions)
		var/datum/action/DA = X
		if(DA.target == src)
			qdel(X)
			break

	forceMove(get_turf(detaching_gub))

	if(sharp)
		detaching_gub.sharp = 0

	for(var/trait in gun_traits)
		REMOVE_TRAIT(detaching_gub, trait, TRAIT_SOURCE_ATTACHMENT(slot))
	for(var/entry in traits_to_give)
		if(!detaching_gub.in_chamber)
			break
		var/list/L
		if(istext(entry))
			L = traits_to_give[entry].Copy()
		else
			L = list(entry) + traits_to_give[entry]
		// Remove bullet traits of attachment from gun's current projectile
		detaching_gub.in_chamber._RemoveElement(L)

/obj/item/attachable/ui_action_click(mob/living/user, obj/item/weapon/gun/G)
	activate_attachment(G, user)
	return //success

/obj/item/attachable/proc/activate_attachment(atom/target, mob/user) //This is for activating stuff like flamethrowers, or switching weapon modes.
	return

/obj/item/attachable/proc/reload_attachment(obj/item/I, mob/user)
	return

/obj/item/attachable/proc/unique_action(mob/user)
	return

///Returns TRUE if its functionality is successfully used, FALSE if gun's own unloading should proceed instead.
/obj/item/attachable/proc/unload_attachment(mob/user, reload_override = 0, drop_override = 0, loc_override = 0)
	return FALSE

/obj/item/attachable/proc/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/user) //For actually shooting those guns.
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN_ATTACHMENT, src) // Because of this, the . = ..() check should be called last, just before firing
	return TRUE

/obj/item/attachable/proc/handle_attachment_description()
	var/base_attachment_desc
	switch(slot)
		if("rail")
			base_attachment_desc = "It has a [icon2html(src)] [name] mounted on the top."
		if("muzzle")
			base_attachment_desc = "It has a [icon2html(src)] [name] mounted on the front."
		if("stock")
			base_attachment_desc = "It has a [icon2html(src)] [name] for a stock."
		if("under")
			var/output = "It has a [icon2html(src)] [name]"
			if(flags_attach_features & ATTACH_WEAPON)
				output += " ([current_rounds]/[max_rounds])"
			output += " mounted underneath."
			base_attachment_desc = output
		else
			base_attachment_desc = "It has a [icon2html(src)] [name] attached."
	return handle_pre_break_attachment_description(base_attachment_desc) + "<br>"

/obj/item/attachable/proc/handle_pre_break_attachment_description(base_description_text as text)
	return base_description_text

/obj/item/co2_cartridge //where tf else am I gonna put this?
	name = "\improper CO2 cartridge"
	desc = "A cartridge of compressed CO2 for the M8 cartridge bayonet. Do not consume or puncture."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "co2_cartridge"
	item_state = ""
	w_class = SIZE_TINY

/obj/item/attachable/mateba
	name = "standard mateba barrel"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "mateba_medium"
	desc = "A standard mateba barrel. Offers a balance between accuracy and fire rate."
	slot = "special"
	flags_attach_features = NO_FLAGS

/obj/item/attachable/mateba/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3

/obj/item/attachable/mateba/Attach(obj/item/weapon/gun/G)
	..()
	G.attachable_offset["muzzle_x"] = 27

/obj/item/attachable/mateba/Detach(mob/user, obj/item/weapon/gun/detaching_gub)
	..()
	detaching_gub.attachable_offset["muzzle_x"] = 20

/obj/item/attachable/mateba/dark
	icon_state = "mateba_medium_a"

/obj/item/attachable/mateba/long
	name = "marksman mateba barrel"
	icon_state = "mateba_long"
	desc = "A marksman mateba barrel. Offers a greater accuracy at the cost of fire rate."
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -1

/obj/item/attachable/mateba/long/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_6
	delay_mod = FIRE_DELAY_TIER_7

/obj/item/attachable/mateba/long/Attach(obj/item/weapon/gun/G)
	..()
	G.attachable_offset["muzzle_x"] = 27

/obj/item/attachable/mateba/long/dark
	icon_state = "mateba_long_a"

/obj/item/attachable/mateba/short
	name = "snubnose mateba barrel"
	icon_state = "mateba_short"
	desc = "A snubnosed mateba barrel. Offers a fast fire rate at the cost of accuracy."
	hud_offset_mod = 2

/obj/item/attachable/mateba/short/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_4
	scatter_mod = SCATTER_AMOUNT_TIER_6
	delay_mod = -FIRE_DELAY_TIER_7

/obj/item/attachable/mateba/short/Attach(obj/item/weapon/gun/G)
	..()
	G.attachable_offset["muzzle_x"] = 27

/obj/item/attachable/mateba/short/dark
	icon_state = "mateba_short_a"

// ======== Rail attachments ======== //

/obj/item/attachable/m4ra_barrel
	name = "M4RA barrel"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "m4ra_barrel"
	attach_icon = "m4ra_barrel"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

/obj/item/attachable/m4ra_barrel/New()
	..()
	select_gamemode_skin(type)

/obj/item/attachable/m4ra_barrel/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon

/obj/item/attachable/m4ra_barrel_custom
	name = "custom M4RA barrel"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "m4ra_custom_barrel"
	attach_icon = "m4ra_custom_barrel"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

/obj/item/attachable/m4ra_barrel_custom/New()
	..()
	select_gamemode_skin(type)

/obj/item/attachable/m4ra_barrel_custom/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon

/obj/item/attachable/type88_barrel
	name = "Type-88 Barrel"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "type88_barrel"
	attach_icon = "type88_barrel"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0
