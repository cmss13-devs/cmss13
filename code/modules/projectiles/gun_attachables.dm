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
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_righthand.dmi'
	)
	var/attach_icon //the sprite to show when the attachment is attached when we want it different from the icon_state.
	var/pixel_shift_x = 16 //Determines the amount of pixels to move the icon state for the overlay.
	var/pixel_shift_y = 16 //Uses the bottom left corner of the item.

	flags_atom = FPRINT|CONDUCT|MAP_COLOR_INDEX
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
	var/projectile_max_range_mod = 0 //Modifier to how far the projectile can travel in tiles.
	var/melee_mod = 0 //Changing to a flat number so this actually doesn't screw up the calculations.
	var/scatter_mod = 0 //Increases or decreases scatter chance.
	var/scatter_unwielded_mod = 0 //same as above but for onehanded firing.
	var/bonus_proj_scatter_mod = 0 //Increses or decrease scatter for bonus projectiles. Mainly used for shotguns.
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
	if(flags_attach_features & ATTACH_RELOADABLE)
		if(user.get_inactive_hand() != src)
			to_chat(user, SPAN_WARNING("You have to hold [src] to do that!"))
		else
			reload_attachment(I, user)
		return TRUE
	else
		. = ..()

/obj/item/attachable/proc/can_be_attached_to_gun(mob/user, obj/item/weapon/gun/G)
	if(G.attachable_allowed && !(type in G.attachable_allowed) )
		to_chat(user, SPAN_WARNING("[src] doesn't fit on [G]!"))
		return FALSE
	return TRUE

/obj/item/attachable/proc/Attach(obj/item/weapon/gun/G)
	if(!istype(G))
		return //Guns only

	/*
	This does not check if the attachment can be removed.
	Instead of checking individual attachments, I simply removed
	the specific guns for the specific attachments so you can't
	attempt the process in the first place if a slot can't be
	removed on a gun. can_be_removed is instead used when they
	try to strip the gun.
	*/
	if(G.attachments[slot])
		var/obj/item/attachable/A = G.attachments[slot]
		A.Detach(detaching_gun = G)

	if(ishuman(loc))
		var/mob/living/carbon/human/M = src.loc
		M.drop_held_item(src)
	forceMove(G)

	G.attachments[slot] = src
	G.recalculate_attachment_bonuses()

	G.setup_firemodes()
	G.update_force_list() //This updates the gun to use proper force verbs.

	var/mob/living/living
	if(isliving(G.loc))
		living = G.loc

	if(attachment_action_type)
		var/given_action = FALSE
		if(living && (G == living.l_hand || G == living.r_hand))
			give_action(living, attachment_action_type, src, G)
			given_action = TRUE
		if(!given_action)
			new attachment_action_type(src, G)

	// Sharp attachments (bayonet) make weapons sharp as well.
	if(sharp)
		G.sharp = sharp

	for(var/trait in gun_traits)
		ADD_TRAIT(G, trait, TRAIT_SOURCE_ATTACHMENT(slot))
	for(var/entry in traits_to_give)
		if(!G.in_chamber)
			break
		var/list/L
		// Check if this is an ID'd bullet trait
		if(istext(entry))
			L = traits_to_give[entry].Copy()
		else
			// Prepend the bullet trait to the list
			L = list(entry) + traits_to_give[entry]
		// Apply bullet traits from attachment to gun's current projectile
		G.in_chamber.apply_bullet_trait(L)

/obj/item/attachable/proc/Detach(mob/user, obj/item/weapon/gun/detaching_gun)
	if(!istype(detaching_gun))
		return //Guns only

	if(user)
		detaching_gun.on_detach(user, src)

	if(flags_attach_features & ATTACH_ACTIVATION)
		activate_attachment(detaching_gun, null, TRUE)

	detaching_gun.attachments[slot] = null
	detaching_gun.recalculate_attachment_bonuses()

	for(var/X in detaching_gun.actions)
		var/datum/action/DA = X
		if(DA.target == src)
			qdel(X)
			break

	forceMove(get_turf(detaching_gun))

	if(sharp)
		detaching_gun.sharp = 0

	for(var/trait in gun_traits)
		REMOVE_TRAIT(detaching_gun, trait, TRAIT_SOURCE_ATTACHMENT(slot))
	for(var/entry in traits_to_give)
		if(!detaching_gun.in_chamber)
			break
		var/list/L
		if(istext(entry))
			L = traits_to_give[entry].Copy()
		else
			L = list(entry) + traits_to_give[entry]
		// Remove bullet traits of attachment from gun's current projectile
		detaching_gun.in_chamber._RemoveElement(L)

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

// ======== Muzzle Attachments ======== //

/obj/item/attachable/suppressor
	name = "suppressor"
	desc = "A small tube with exhaust ports to expel noise and gas.\n Does not completely silence a weapon, but does make it much quieter and a little more accurate and stable at the cost of slightly reduced damage."
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "suppressor"
	slot = "muzzle"
	pixel_shift_y = 15
	attach_icon = "suppressor_a"
	hud_offset_mod = -3
	gun_traits = list(TRAIT_GUN_SILENCED)

/obj/item/attachable/suppressor/New()
	..()
	damage_falloff_mod = 0.1
	attach_icon = pick("suppressor_a","suppressor2_a")

/obj/item/attachable/suppressor/xm40_integral
	name = "\improper XM40 integral suppressor"
	icon_state = "m40sd_suppressor"
	attach_icon = "m40sd_suppressor_a"

/obj/item/attachable/suppressor/xm40_integral/New()
	..()
	attach_icon = "m40sd_suppressor_a"

/obj/item/attachable/bayonet
	name = "\improper M5 'Night Raider' bayonet"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "bayonet"
	item_state = "combat_knife"
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/objects.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/knives_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/knives_righthand.dmi'
	)
	desc = "The standard-issue bayonet of the Colonial Marines. You can slide this knife into your boots, or attach it to the end of a rifle."
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_NORMAL
	throwforce = MELEE_FORCE_NORMAL
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_speed = 9
	flags_equip_slot = SLOT_FACE
	flags_armor_protection = SLOT_FACE
	flags_item = CAN_DIG_SHRAPNEL


	attach_icon = "bayonet_a"
	melee_mod = 20
	slot = "muzzle"
	pixel_shift_x = 14 //Below the muzzle.
	pixel_shift_y = 18
	hud_offset_mod = -4
	var/pry_delay = 3 SECONDS

/obj/item/attachable/bayonet/Initialize(mapload, ...)
	. = ..()
	if(flags_equip_slot & SLOT_FACE)
		AddElement(/datum/element/mouth_drop_item)

/obj/item/attachable/bayonet/New()
	..()
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/bayonet/upp_replica
	name = "\improper Type 80 bayonet"
	icon_state = "upp_bayonet"
	item_state = "combat_knife"
	attach_icon = "upp_bayonet_a"
	desc = "The standard-issue bayonet of the UPP, it's dulled from heavy use."

/obj/item/attachable/bayonet/upp
	name = "\improper Type 80 bayonet"
	desc = "The standard-issue bayonet of the UPP, the Type 80 is balanced to also function as an effective throwing knife."
	icon_state = "upp_bayonet"
	item_state = "combat_knife"
	attach_icon = "upp_bayonet_a"
	throwforce = MELEE_FORCE_TIER_10 //doubled by throwspeed to 100
	throw_speed = SPEED_REALLY_FAST
	throw_range = 7
	pry_delay = 1 SECONDS

/obj/item/attachable/bayonet/co2
	name = "\improper M8 cartridge bayonet"
	desc = "A back issue USCM approved exclusive for Boots subscribers found in issue #255 'Inside the Night Raider - morale breaking alternatives with 2nd LT. Juliane Gerd'. A pressurized tube runs along the inside of the blade, and a button allows one to inject compressed CO2 into the stab wound. It feels cheap to the touch. Faulty even."
	icon_state = "co2_knife"
	attach_icon = "co2_bayonet_a"
	var/filled = FALSE

/obj/item/attachable/bayonet/rmc
	name = "\improper L5 bayonet"
	desc = "The standard-issue bayonet of the RMC, the L5 is balanced to also function as an effective throwing knife."
	icon_state = "twe_bayonet"
	item_state = "combat_knife"
	attach_icon = "twe_bayonet_a"
	throwforce = MELEE_FORCE_TIER_10 //doubled by throwspeed to 100
	throw_speed = SPEED_REALLY_FAST
	throw_range = 7
	pry_delay = 1 SECONDS

/obj/item/attachable/bayonet/antique
	name = "\improper antique bayonet"
	desc = "An antique-style bayonet, has a long blade, wooden handle with brass fittings, reflecting historical craftsmanship."
	icon_state = "antique_bayonet"
	item_state = "combat_knife"
	attach_icon = "antique_bayonet_a"

/obj/item/attachable/bayonet/rmc_replica
	name = "\improper L5 bayonet"
	desc = "The standard-issue bayonet of the RMC, it's dulled from heavy use."
	icon_state = "twe_bayonet"
	item_state = "combat_knife"
	attach_icon = "twe_bayonet_a"

/obj/item/attachable/bayonet/custom
	name = "\improper M5 'Raven's Claw' tactical bayonet"
	desc = "A prototype bayonet-combat knife hybrid, engineered for close-quarters engagements and urban operations. Its rugged construction, quick-detach mechanism and deadly versatility make it a formidable tool."
	icon_state = "bayonet_custom"
	item_state = "combat_knife"
	attach_icon = "bayonet_custom_a"

/obj/item/attachable/bayonet/custom/red
	desc = "A prototype bayonet-combat knife hybrid, engineered for close-quarters engagements and urban operations. Its rugged construction, quick-detach mechanism and deadly versatility make it a formidable tool. This version has been customized with a red grip and gold detailing, giving it a unique and distinctive appearance."
	icon_state = "bayonet_custom_red"
	item_state = "combat_knife"
	attach_icon = "bayonet_custom_red_a"

/obj/item/attachable/bayonet/custom/blue
	desc = "A prototype bayonet-combat knife hybrid, engineered for close-quarters engagements and urban operations. Its rugged construction, quick-detach mechanism and deadly versatility make it a formidable tool. This version has been customized with a blue grip and gold detailing, giving it a unique and distinctive appearance."
	icon_state = "bayonet_custom_blue"
	item_state = "combat_knife"
	attach_icon = "bayonet_custom_blue_a"

/obj/item/attachable/bayonet/custom/black
	desc = "A prototype bayonet-combat knife hybrid, engineered for close-quarters engagements and urban operations. Its rugged construction, quick-detach mechanism and deadly versatility make it a formidable tool. This version has been customized with a black grip and gold detailing, giving it a unique and distinctive appearance."
	icon_state = "bayonet_custom_black"
	item_state = "combat_knife"
	attach_icon = "bayonet_custom_black_a"

/obj/item/attachable/bayonet/tanto
	name = "\improper T9 tactical bayonet"
	desc = "Preferred by TWE colonial military forces in the Neroid Sector, the T9 is designed for urban combat with a durable tanto blade and quick-attach system, reflecting traditional Japanese blade influences. Occasionally seen in the hands of Colonial Liberation Front (CLF) forces, often stolen from TWE detatchments and outposts across the sector."
	icon_state = "bayonet_tanto"
	item_state = "combat_knife"
	attach_icon = "bayonet_tanto_a"

/obj/item/attachable/bayonet/tanto/blue
	icon_state = "bayonet_tanto_alt"
	item_state = "combat_knife"
	attach_icon = "bayonet_tanto_alt_a"

/obj/item/attachable/bayonet/van_bandolier
	name = "\improper Fairbairn-Sykes fighting knife"
	desc = "This isn't for dressing game or performing camp chores. It's almost certainly not an original. Almost."

/obj/item/attachable/bayonet/co2/update_icon()
	icon_state = "co2_knife[filled ? "-f" : ""]"
	attach_icon = "co2_bayonet[filled ? "-f" : ""]_a"

/obj/item/attachable/bayonet/co2/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/co2_cartridge))
		if(!filled)
			filled = TRUE
			user.visible_message(SPAN_NOTICE("[user] slots a CO2 cartridge into [src]. A second later, \he apparently looks dismayed."), SPAN_WARNING("You slot a fresh CO2 cartridge into [src] and snap the slot cover into place. Only then do you realize [W]'s valve broke inside [src]. Fuck."))
			playsound(src, 'sound/machines/click.ogg')
			qdel(W)
			update_icon()
			return
		else
			user.visible_message(SPAN_WARNING("[user] fiddles with [src]. \He looks frustrated."), SPAN_NOTICE("No way man! You can't seem to pry the existing container out of [src]... try a screwdriver?"))
			return
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) && do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		user.visible_message(SPAN_WARNING("[user] screws with [src], using \a [W]. \He looks very frustrated."), SPAN_NOTICE("You try to pry the cartridge out of [src], but it's stuck damn deep. Piece of junk..."))
		return
	..()

/obj/item/co2_cartridge //where tf else am I gonna put this?
	name = "\improper CO2 cartridge"
	desc = "A cartridge of compressed CO2 for the M8 cartridge bayonet. Do not consume or puncture."
	icon = 'icons/obj/items/tank.dmi'
	icon_state = "co2_cartridge"
	item_state = ""
	w_class = SIZE_TINY

/obj/item/attachable/extended_barrel
	name = "extended barrel"
	desc = "The lengthened barrel speeds up and stabilizes the bullet, increasing velocity and accuracy."
	slot = "muzzle"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "ebarrel"
	attach_icon = "ebarrel_a"
	hud_offset_mod = -3
	wield_delay_mod = WIELD_DELAY_FAST

/obj/item/attachable/extended_barrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	velocity_mod = AMMO_SPEED_TIER_1

/obj/item/attachable/heavy_barrel
	name = "barrel charger"
	desc = "A hyper threaded barrel extender that fits to the muzzle of most firearms. Increases bullet speed and velocity.\nGreatly increases projectile damage at the cost of accuracy and firing speed."
	slot = "muzzle"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "hbarrel"
	attach_icon = "hbarrel_a"
	hud_offset_mod = -3

/obj/item/attachable/heavy_barrel/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	damage_mod = BULLET_DAMAGE_MULT_TIER_6
	delay_mod = FIRE_DELAY_TIER_11

	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_7

/obj/item/attachable/heavy_barrel/Attach(obj/item/weapon/gun/G)
	if(G.gun_category == GUN_CATEGORY_SHOTGUN)
		damage_mod = BULLET_DAMAGE_MULT_TIER_1
	else
		damage_mod = BULLET_DAMAGE_MULT_TIER_6
	..()

/obj/item/attachable/compensator
	name = "recoil compensator"
	desc = "A muzzle attachment that reduces recoil by diverting expelled gasses upwards. \nIncreases accuracy and reduces recoil, at the cost of a small amount of weapon damage."
	slot = "muzzle"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "comp"
	attach_icon = "comp_a"
	pixel_shift_x = 17
	hud_offset_mod = -3

/obj/item/attachable/compensator/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	damage_mod = -BULLET_DAMAGE_MULT_TIER_2
	recoil_mod = -RECOIL_AMOUNT_TIER_3

	damage_falloff_mod = 0.1
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_4

/obj/item/attachable/shotgun_choke
	name = "shotgun choke"
	desc = "A modified choke for the M37A2 pump shotgun. It tightens the spread, accuracy, speed and max range of fired shells. The cyclic rate of the weapon is also increased. In exchange, projectile damage and force is greatly reduced, with the weapon also having higher recoil. Not recommended for use with slugs."
	slot = "muzzle"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "choke"
	attach_icon = "choke_a"
	pixel_shift_x = 16
	pixel_shift_y = 17
	hud_offset_mod = -2

/obj/item/attachable/shotgun_choke/New()
	..()
	recoil_mod = RECOIL_AMOUNT_TIER_4
	accuracy_mod = HIT_ACCURACY_MULT_TIER_5
	damage_mod = -BULLET_DAMAGE_MULT_TIER_4
	velocity_mod = AMMO_SPEED_TIER_1
	delay_mod = -FIRE_DELAY_TIER_2
	bonus_proj_scatter_mod = -SCATTER_AMOUNT_TIER_6
	projectile_max_range_mod = 1
	damage_falloff_mod = -0.3

/obj/item/attachable/shotgun_choke/Attach(obj/item/weapon/gun/shotgun/pump/attaching_gun)
	if(!istype(attaching_gun, /obj/item/weapon/gun/shotgun/pump))
		return ..()
	attaching_gun.pump_delay -= FIRE_DELAY_TIER_5
	attaching_gun.add_bullet_trait(BULLET_TRAIT_ENTRY_ID("knockback_disabled", /datum/element/bullet_trait_knockback_disabled))
	attaching_gun.fire_sound = 'sound/weapons/gun_shotgun_choke.ogg'

	return ..()

/obj/item/attachable/shotgun_choke/Detach(mob/user, obj/item/weapon/gun/shotgun/pump/detaching_gun)
	if(!istype(detaching_gun, /obj/item/weapon/gun/shotgun/pump))
		return ..()
	detaching_gun.pump_delay += FIRE_DELAY_TIER_5
	detaching_gun.remove_bullet_trait("knockback_disabled")
	detaching_gun.fire_sound = initial(detaching_gun.fire_sound)

	return ..()

/obj/item/attachable/slavicbarrel
	name = "sniper barrel"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "slavicbarrel"
	desc = "A heavy barrel. CANNOT BE REMOVED."
	slot = "muzzle"

	pixel_shift_x = 20
	pixel_shift_y = 16
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -4

/obj/item/attachable/slavicbarrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/f90_dmr_barrel
	name = "f90 barrel"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "aug_dmr_barrel_a"
	attach_icon = "aug_dmr_barrel_a"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

/obj/item/attachable/f90_shotgun_barrel
	name = "f90 barrel"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "aug_mkey_barrel_a"
	attach_icon = "aug_mkey_barrel_a"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

/obj/item/attachable/l56a2_smartgun
	name = "l56a2 barrel"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "magsg_barrel_a"
	attach_icon = "magsg_barrel_a"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

/obj/item/attachable/sniperbarrel
	name = "sniper barrel"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "sniperbarrel"
	desc = "A heavy barrel. CANNOT BE REMOVED."
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -3

/obj/item/attachable/sniperbarrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/pmc_sniperbarrel
	name = "sniper barrel"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "pmc_sniperbarrel"
	desc = "A heavy barrel. CANNOT BE REMOVED."
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -3

/obj/item/attachable/pmc_sniperbarrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/sniperbarrel/vulture
	name = "\improper M707 barrel"
	icon_state = "vulture_barrel"
	hud_offset_mod = -1

/obj/item/attachable/m60barrel
	name = "M60 barrel"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "m60barrel"
	desc = "A heavy barrel. CANNOT BE REMOVED."
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -6

/obj/item/attachable/m60barrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/mar50barrel
	name = "MAR-50 barrel"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "mar50barrel"
	desc = "A heavy barrel. CANNOT BE REMOVED."
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -6

/obj/item/attachable/mar50barrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/smartbarrel
	name = "smartgun barrel"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "m56_barrel"
	desc = "The very end of the M56 smart gun, featuring a compensator. CANNOT BE REMOVED."
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	pixel_shift_x = 14
	hud_offset_mod = -4

// Mateba barrels

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

/obj/item/attachable/mateba/Detach(mob/user, obj/item/weapon/gun/detaching_gun)
	..()
	detaching_gun.attachable_offset["muzzle_x"] = 20

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
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/misc.dmi',
	)
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
			attached_gun.set_light_color(COLOR_WHITE)
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

/obj/item/attachable/flashlight/attackby(obj/item/I, mob/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		to_chat(user, SPAN_NOTICE("You strip the rail flashlight of its mount, converting it to a normal flashlight."))
		if(isstorage(loc))
			var/obj/item/storage/S = loc
			S.remove_from_storage(src)
		if(loc == user)
			user.temp_drop_inv_item(src)
		var/obj/item/device/flashlight/F = new(user)
		user.put_in_hands(F) //This proc tries right, left, then drops it all-in-one.
		qdel(src) //Delete da old flashlight
	else
		. = ..()

/obj/item/attachable/flashlight/grip //Grip Light is here because it is a child object. Having it further down might cause a future coder a headache.
	name = "underbarrel flashlight grip"
	desc = "Holy smokes RO man, they put a grip on a flashlight! \nReduces recoil and scatter by a tiny amount. Boosts accuracy by a tiny amount. Works as a light source."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "flashgrip"
	attach_icon = "flashgrip_a"
	slot = "under"
	original_state = "flashgrip"
	original_attach = "flashgrip_a"

/obj/item/attachable/flashlight/grip/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/flashlight/grip/attackby(obj/item/I, mob/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		to_chat(user, SPAN_NOTICE("Hold on there cowboy, that grip is bolted on. You are unable to modify it."))
	return

/obj/item/attachable/flashlight/laser_light_combo //Unique attachment for the VP78 based on the fact it has a Laser-Light Module in AVP2010
	name = "VP78 Laser-Light Module"
	desc = "A Laser-Light module for the VP78 Service Pistol which is currently undergoing limited field testing as part of the USCMs next generation pistol program. All VP78 pistols come equipped with the module."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "vplaserlight"
	attach_icon = "vplaserlight_a"
	slot = "under"
	original_state = "vplaserlight"
	original_attach = "vplaserlight_a"

/obj/item/attachable/flashlight/laser_light_combo/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_9
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/flashlight/laser_light_combo/attackby(obj/item/combo_light, mob/user)
	if(HAS_TRAIT(combo_light, TRAIT_TOOL_SCREWDRIVER))
		to_chat(user, SPAN_NOTICE("You are unable to modify it."))
	return

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

/obj/item/attachable/magnetic_harness/Detach(mob/user, obj/item/weapon/gun/detaching_gun)
	. = ..()
	detaching_gun.RemoveElement(/datum/element/drop_retrieval/gun, retrieval_slot)

/obj/item/attachable/magnetic_harness/lever_sling
	name = "R4T magnetic sling" //please don't make this attachable to any other guns...
	desc = "A custom sling designed for comfortable holstering of a 19th century lever action rifle, for some reason. Contains magnets specifically built to make sure the lever-action rifle never drops from your back, however they somewhat get in the way of the grip."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "r4t-sling"
	attach_icon = "r4t-sling_a"
	slot = "under"
	wield_delay_mod = WIELD_DELAY_VERY_FAST
	retrieval_slot = WEAR_BACK

/obj/item/attachable/magnetic_harness/lever_sling/New()
	..()
	select_gamemode_skin(type)

/obj/item/attachable/magnetic_harness/lever_sling/Attach(obj/item/weapon/gun/G) //this is so the sling lines up correctly
	. = ..()
	G.attachable_offset["under_x"] = 15
	G.attachable_offset["under_y"] = 12


/obj/item/attachable/magnetic_harness/lever_sling/Detach(mob/user, obj/item/weapon/gun/detaching_gun)
	. = ..()
	detaching_gun.attachable_offset["under_x"] = 24
	detaching_gun.attachable_offset["under_y"] = 16

/obj/item/attachable/magnetic_harness/lever_sling/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..() // We are forcing attach_icon skin
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
			. = TRUE
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
			. = TRUE
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
			. = TRUE
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon
			. = TRUE
	return .

/obj/item/attachable/alt_iff_scope
	name = "B8 Smart-Scope"
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "iffbarrel"
	attach_icon = "iffbarrel_a"
	desc = "An experimental B8 Smart-Scope. Based on the technologies used in the Smart Gun by ARMAT, this sight has integrated IFF systems. It can only attach to the M4RA Battle Rifle, the M44 Combat Revolver, and the M41A MK2 Pulse Rifle."
	desc_lore = "An experimental fire-control optic capable of linking into compatible IFF systems on certain weapons, designated the XAN/PVG-110 Smart Scope. Experimental technology developed by Armat, who have assured that all previously reported issues with false-negative IFF recognitions have been solved. Make sure to check the sight after every deployment, just in case."
	slot = "rail"
	pixel_shift_y = 15

/obj/item/attachable/alt_iff_scope/New()
	..()
	damage_mod = -BULLET_DAMAGE_MULT_TIER_2
	damage_falloff_mod = 0.2

/obj/item/attachable/alt_iff_scope/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/attachable/alt_iff_scope/Attach(obj/item/weapon/gun/attaching_gun)
	. = ..()
	if(!GetComponent(attaching_gun, /datum/component/iff_fire_prevention))
		attaching_gun.AddComponent(/datum/component/iff_fire_prevention, 5)
	SEND_SIGNAL(attaching_gun, COMSIG_GUN_ALT_IFF_TOGGLED, TRUE)

/obj/item/attachable/alt_iff_scope/Detach(mob/user, obj/item/weapon/gun/detaching_gun)
	. = ..()
	SEND_SIGNAL(detaching_gun, COMSIG_GUN_ALT_IFF_TOGGLED, FALSE)
	detaching_gun.GetExactComponent(/datum/component/iff_fire_prevention).RemoveComponent()

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

/obj/item/attachable/scope/Detach(mob/user, obj/item/weapon/gun/detaching_gun)
	. = ..()
	UnregisterSignal(detaching_gun, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES)


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

/obj/item/attachable/scope/variable_zoom/twe
	name = "S10 variable zoom telescopic scope"
	icon_state = "3we_scope"
	attach_icon = "3we_scope_a"
	desc = "An ARMAT S10 telescopic eye piece. Can be switched between 2x zoom, which allows the user to move while scoped in, and 4x zoom. Press the 'use rail attachment' HUD icon or use the verb of the same name to zoom."

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
	. = ..() // We are forcing attach_icon skin
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
			. = TRUE
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
			. = TRUE
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
			. = TRUE
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon
			. = TRUE
	return .

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

// ======== Stock attachments ======== //


/obj/item/attachable/stock //Generic stock parent and related things.
	name = "default stock"
	desc = "If you can read this, someone screwed up. Go Gitlab this and bug a coder."
	icon_state = "stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_VERY_FAST
	melee_mod = 5
	size_mod = 2
	pixel_shift_x = 30
	pixel_shift_y = 14

	var/collapsible = FALSE
	var/stock_activated = TRUE
	var/collapse_delay  = 0
	var/list/deploy_message = list("collapse", "extend")

/obj/item/attachable/stock/proc/apply_on_weapon(obj/item/weapon/gun/gun)
	return TRUE

/obj/item/attachable/stock/activate_attachment(obj/item/weapon/gun/gun, mob/living/carbon/user, turn_off)
	. = ..()

	if(!collapsible)
		return .

	if(turn_off && stock_activated)
		stock_activated = FALSE
		apply_on_weapon(gun)
		return TRUE

	if(!user)
		return TRUE

	if(gun.flags_item & WIELDED)
		to_chat(user, SPAN_NOTICE("You need a free hand to adjust [src]."))
		return TRUE

	if(!do_after(user, collapse_delay, INTERRUPT_INCAPACITATED|INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC, gun, INTERRUPT_DIFF_LOC))
		return FALSE

	stock_activated = !stock_activated
	apply_on_weapon(gun)
	playsound(user, activation_sound, 15, 1)
	var/message = deploy_message[1 + stock_activated]
	to_chat(user, SPAN_NOTICE("You [message] [src]."))

	for(var/X in gun.actions)
		var/datum/action/A = X
		if(istype(A, /datum/action/item_action/toggle))
			A.update_button_icon()

/obj/item/attachable/stock
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'

/obj/item/attachable/stock/shotgun
	name = "\improper M37 wooden stock"
	desc = "A non-standard heavy wooden stock for the M37 Shotgun. More cumbersome than the standard issue stakeout, but reduces recoil and improves accuracy. Allegedly makes a pretty good club in a fight too."
	slot = "stock"
	icon_state = "stock"
	wield_delay_mod = WIELD_DELAY_FAST
	pixel_shift_x = 32
	pixel_shift_y = 15
	hud_offset_mod = 6 //*Very* long sprite.

/obj/item/attachable/stock/shotgun/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8
	//but at the same time you are slow when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_med)

	select_gamemode_skin(type)

/obj/item/attachable/stock/double
	name = "\improper double barrel shotgun stock"
	desc = "A chunky piece of wood coated in varnish and age."
	slot = "stock"
	icon_state = "db_stock"
	wield_delay_mod = WIELD_DELAY_NONE//part of the gun's base stats
	flags_attach_features = NO_FLAGS
	pixel_shift_x = 32
	pixel_shift_y = 15
	hud_offset_mod = 2

/obj/item/attachable/stock/double/New()
	..()

/obj/item/attachable/stock/mou53
	name = "\improper MOU53 tactical stock"
	desc = "A metal stock fitted specifically for the MOU53 break action shotgun."
	icon_state = "ou_stock"
	hud_offset_mod = 5

/obj/item/attachable/stock/mou53/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/r4t
	name = "\improper R4T scouting stock"
	desc = "A wooden stock designed for the R4T lever-action rifle, designed to withstand harsh environments. It increases weapon stability but really gets in the way."
	icon_state = "r4t-stock"
	wield_delay_mod = WIELD_DELAY_SLOW
	hud_offset_mod = 6

/obj/item/attachable/stock/r4t/New()
	..()
	select_gamemode_skin(type)
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_4

/obj/item/attachable/stock/xm88
	name = "\improper XM88 padded stock"
	desc = "A specially made compound polymer stock reinforced with aluminum rods and thick rubber padding to shield the user from recoil. Fitted specifically for the XM88 Heavy Rifle."
	icon_state = "boomslang-stock"
	wield_delay_mod = WIELD_DELAY_NORMAL
	hud_offset_mod = 6

/obj/item/attachable/stock/xm88/New()
	..()
	select_gamemode_skin(type)
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_4

/obj/item/attachable/stock/vulture
	name = "\improper M707 heavy stock"
	icon_state = "vulture_stock"
	attach_icon = "vulture_stock"
	hud_offset_mod = 3

/obj/item/attachable/stock/vulture/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(type)
	// Doesn't give any stat additions due to the gun already having really good ones, and this is unremovable from the gun itself

/obj/item/attachable/stock/vulture/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..() // We are forcing attach_icon skin
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
			. = TRUE
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
			. = TRUE
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
			. = TRUE
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon
			. = TRUE
	return .

/obj/item/attachable/stock/tactical
	name = "\improper MK221 tactical stock"
	desc = "A metal stock made for the MK221 tactical shotgun."
	icon_state = "tactical_stock"
	hud_offset_mod = 6

/obj/item/attachable/stock/tactical/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/type23
	name = "\improper Type 23 standard stock"
	desc = "A stamped metal stock with internal recoil springs designed to absorb the ridiculous kick the 8 Gauge shotgun causes when fired. Not recommended to remove."
	icon_state = "type23_stock"
	pixel_shift_x = 15
	pixel_shift_y = 15
	hud_offset_mod = 2

/obj/item/attachable/stock/type23/New()
	..()
	//2h
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//1h
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/slavic
	name = "wooden stock"
	desc = "A non-standard heavy wooden stock for Slavic firearms."
	icon_state = "slavicstock"
	pixel_shift_x = 32
	pixel_shift_y = 13
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 0 //Already attached to base sprite.

/obj/item/attachable/stock/slavic/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	delay_mod = FIRE_DELAY_TIER_7
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/hunting
	name = "wooden stock"
	desc = "The non-detachable stock of a Basira-Armstrong rifle."
	icon_state = "huntingstock"
	pixel_shift_x = 41
	pixel_shift_y = 10
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 6

/obj/item/attachable/stock/hunting/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8

/obj/item/attachable/stock/hg3712
	name = "hg3712 stock"
	desc = "The non-detachable stock of a HG 37-12 pump shotgun."
	icon_state = "hg3712_stock"
	pixel_shift_x = 41
	pixel_shift_y = 10
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 6

/obj/item/attachable/stock/hg3712/New()
	..()

	//HG stock is purely aesthetics, any changes should be done to the gun itself
	accuracy_mod = 0
	recoil_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	recoil_unwielded_mod = 0
	scatter_unwielded_mod = 0
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NONE

/obj/item/attachable/stock/hg3712/m3717
	name = "hg3717 stock"
	desc = "The non-detachable stock of a M37-17 pump shotgun."
	icon_state = "hg3717_stock"

/obj/item/attachable/stock/rifle
	name = "\improper M41A solid stock"
	desc = "A rare stock distributed in small numbers to USCM forces. Compatible with the M41A, this stock reduces recoil and improves accuracy, but at a reduction to handling and agility. Also enhances the thwacking of things with the stock-end of the rifle."
	slot = "stock"
	melee_mod = 10
	size_mod = 1
	icon_state = "riflestock"
	attach_icon = "riflestock_a"
	pixel_shift_x = 40
	pixel_shift_y = 10
	wield_delay_mod = WIELD_DELAY_FAST
	hud_offset_mod = 3

/obj/item/attachable/stock/rifle/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_5
	recoil_mod = -RECOIL_AMOUNT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_7
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8
	//but at the same time you are slow when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_med)

/obj/item/attachable/stock/rifle/collapsible
	name = "\improper M41A folding stock"
	desc = "The standard back end of any gun starting with \"M41\". Compatible with the M41A series, this stock reduces recoil and improves accuracy, but at a reduction to handling and agility. Also enhances the thwacking of things with the stock-end of the rifle."
	slot = "stock"
	melee_mod = 5
	size_mod = 1
	icon_state = "m41_folding"
	attach_icon = "m41_folding_a"
	pixel_shift_x = 40
	pixel_shift_y = 14
	hud_offset_mod = 3
	collapsible = TRUE
	stock_activated = FALSE
	wield_delay_mod = WIELD_DELAY_NONE //starts collapsed so no delay mod
	collapse_delay = 0.5 SECONDS
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle

/obj/item/attachable/stock/rifle/collapsible/New()
	..()

	//rifle stock starts collapsed so we zero out everything
	accuracy_mod = 0
	recoil_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	recoil_unwielded_mod = 0
	scatter_unwielded_mod = 0
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NONE

/obj/item/attachable/stock/rifle/collapsible/apply_on_weapon(obj/item/weapon/gun/gun)
	if(stock_activated)
		accuracy_mod = HIT_ACCURACY_MULT_TIER_2
		recoil_mod = -RECOIL_AMOUNT_TIER_5
		scatter_mod = -SCATTER_AMOUNT_TIER_9
		//it makes stuff worse when one handed
		movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
		accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
		recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
		scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8
		aim_speed_mod = CONFIG_GET(number/slowdown_med)
		hud_offset_mod = 5
		icon_state = "m41_folding_on"
		attach_icon = "m41_folding_a_on"
		wield_delay_mod = WIELD_DELAY_VERY_FAST //added 0.2 seconds for wield, basic solid stock adds 0.4

	else
		accuracy_mod = 0
		recoil_mod = 0
		scatter_mod = 0
		movement_onehanded_acc_penalty_mod = 0
		accuracy_unwielded_mod = 0
		recoil_unwielded_mod = 0
		scatter_unwielded_mod = 0
		aim_speed_mod = 0
		hud_offset_mod = 3
		icon_state = "m41_folding"
		attach_icon = "m41_folding_a"
		wield_delay_mod = WIELD_DELAY_NONE //stock is folded so no wield delay

	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")

/obj/item/attachable/stock/m16
	name = "\improper M16 bump stock"
	desc = "Technically illegal in the state of California."
	icon_state = "m16_stock"
	attach_icon = "m16_stock"
	wield_delay_mod = WIELD_DELAY_MIN
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 3

/obj/item/attachable/stock/m16/New()//no stats, its cosmetic
	..()

/obj/item/attachable/stock/m16/m16a5
	name = "\improper M16A5 bump stock"
	icon_state = "m16a5_stock"
	attach_icon = "m16a5_stock"

/obj/item/attachable/stock/m16/xm177
	name = "\improper collapsible M16 stock"
	desc = "Very illegal in the state of California."
	icon_state = "m16_folding"
	attach_icon = "m16_folding"
	hud_offset_mod = 3
	collapsible = TRUE
	stock_activated = FALSE
	wield_delay_mod = WIELD_DELAY_NONE //starts collapsed so no delay mod
	collapse_delay = 0.5 SECONDS
	flags_attach_features = ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/base_icon = "m16_folding"

/obj/item/attachable/stock/m16/xm177/Initialize()
	.=..()
	accuracy_mod = 0
	recoil_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	recoil_unwielded_mod = 0
	scatter_unwielded_mod = 0
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NONE

/obj/item/attachable/stock/m16/xm177/apply_on_weapon(obj/item/weapon/gun/gun)
	if(stock_activated)
		accuracy_mod = HIT_ACCURACY_MULT_TIER_2
		recoil_mod = -RECOIL_AMOUNT_TIER_5
		scatter_mod = -SCATTER_AMOUNT_TIER_9
		aim_speed_mod = CONFIG_GET(number/slowdown_med)
		hud_offset_mod = 5
		icon_state = base_icon
		attach_icon = "[base_icon]_on"
		wield_delay_mod = WIELD_DELAY_VERY_FAST

	else
		accuracy_mod = 0
		recoil_mod = 0
		scatter_mod = 0
		movement_onehanded_acc_penalty_mod = 0
		accuracy_unwielded_mod = 0
		recoil_unwielded_mod = 0
		scatter_unwielded_mod = 0
		aim_speed_mod = 0
		hud_offset_mod = 3
		icon_state = base_icon
		attach_icon = base_icon
		wield_delay_mod = WIELD_DELAY_NONE //stock is folded so no wield delay
	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")


/obj/item/attachable/stock/m16/xm177/car15a3
	name = "\improper collapsible CAR-15A3 stock"
	icon_state = "car_folding"
	attach_icon = "car_folding"
	base_icon = "car_folding"

/obj/item/attachable/stock/ar10
	name = "\improper AR10 wooden stock"
	desc = "The spring's in here, don't take it off!"
	icon_state = "ar10_stock"
	attach_icon = "ar10_stock"
	wield_delay_mod = WIELD_DELAY_MIN
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 3

/obj/item/attachable/stock/ar10/New()//no stats, its cosmetic
	..()

/obj/item/attachable/stock/m79
	name = "\improper M79 hardened polykevlon stock"
	desc = "Helps to mitigate the recoil of launching a 40mm grenade. Fits only to the M79."
	icon_state = "m79_stock"
	icon_state = "m79_stock_a"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 2

/obj/item/attachable/stock/xm51
	name = "\improper XM51 stock"
	desc = "A specialized stock designed for XM51 breaching shotguns. Helps the user absorb the recoil of the weapon while also reducing scatter. Integrated mechanisms inside the stock allow use of a devastating two-shot burst. This comes at a cost of the gun becoming too unwieldy to holster, worse handling and mobility."
	icon_state = "xm51_stock"
	attach_icon = "xm51_stock_a"
	wield_delay_mod = WIELD_DELAY_FAST
	hud_offset_mod = 3
	melee_mod = 10

/obj/item/attachable/stock/xm51/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(type)
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	//and allows for burst-fire
	burst_mod = BURST_AMOUNT_TIER_2
	//but it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_5
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_6
	//and makes you slower
	aim_speed_mod = CONFIG_GET(number/slowdown_med)

/obj/item/attachable/stock/xm51/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..() // We are forcing attach_icon skin
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
			. = TRUE
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
			. = TRUE
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
			. = TRUE
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon
			. = TRUE
	return .

/obj/item/attachable/stock/mod88
	name = "\improper Mod 88 burst stock"
	desc = "Increases the fire rate and burst amount on the Mod 88. Some versions act as a holster for the weapon when un-attached. This is a test item and should not be used in normal gameplay (yet)."
	icon_state = "mod88_stock"
	attach_icon = "mod88_stock_a"
	wield_delay_mod = WIELD_DELAY_FAST
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 4
	size_mod = 2
	melee_mod = 5

/obj/item/attachable/stock/mod88/New()
	..()
	//2h
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	recoil_mod = -RECOIL_AMOUNT_TIER_2
	scatter_mod = -SCATTER_AMOUNT_TIER_7
	burst_scatter_mod = -1
	burst_mod = BURST_AMOUNT_TIER_2
	delay_mod = -FIRE_DELAY_TIER_11
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	//1h
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/carbine
	name = "\improper L42 synthetic stock"
	desc = "A special issue stock made of sturdy, yet lightweight materials. Attaches to the L42A Battle Rifle. Not effective as a blunt force weapon."
	slot = "stock"
	size_mod = 1
	icon_state = "l42stock"
	attach_icon = "l42stock_a"
	pixel_shift_x = 37
	pixel_shift_y = 8
	wield_delay_mod = WIELD_DELAY_NORMAL
	hud_offset_mod = 2

/obj/item/attachable/stock/carbine/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_6
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8

/obj/item/attachable/stock/carbine/wood
	name = "\improper ABR-40 \"wooden\" stock"
	desc = "The default \"wooden\" stock for the ABR-40 hunting rifle, the civilian version of the military L42A battle rifle. Theoretically compatible with an L42. Wait, did you just take the stock out of a weapon with no grip...? Great job, genius."
	icon_state = "abr40stock"
	attach_icon = "abr40stock_a"
	melee_mod = 6
	wield_delay_mod = WIELD_DELAY_FAST

/obj/item/attachable/stock/carbine/wood/Initialize() // The gun is meant to be effectively unusable without the attachment.
	. = ..()
	accuracy_mod = (HIT_ACCURACY_MULT_TIER_6) + HIT_ACCURACY_MULT_TIER_10
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = (-SCATTER_AMOUNT_TIER_8) - SCATTER_AMOUNT_TIER_5

/obj/item/attachable/stock/carbine/wood/tactical
	name = "\improper ABR-40 tactical stock"
	desc = "An ABR-40 stock with a sleek paintjob. Wait, did you just take the stock out of a weapon with no grip...? Great job, genius."
	icon_state = "abr40stock_tac"
	attach_icon = "abr40stock_tac_a"

/obj/item/attachable/stock/carbine/l42a3
	name = "\improper L42A3 synthetic stock"
	desc = "A standard issue stock made of sturdy, yet lightweight materials. Attaches to the L42A3 Battle Rifle. Not effective as a blunt force weapon."
	icon_state = "l42a3stock"
	attach_icon = "l42a3stock_a"

/obj/item/attachable/stock/carbine/l42a3/marksman
	name = "\improper L42A3 marksman stock"
	desc = "A special issue stock made of sturdy, yet lightweight materials. Attaches to the L42A3 Battle Rifle. Not effective as a blunt force weapon."

	wield_delay_mod = WIELD_DELAY_FAST

/obj/item/attachable/stock/rifle/marksman
	name = "\improper M41A marksman stock"
	icon_state = "m4markstock"
	attach_icon = "m4markstock"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 2

/obj/item/attachable/stock/twobore
	name = "heavy wooden stock"
	icon_state = "twobore_stock"
	attach_icon = "twobore_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0
	pixel_shift_x = 24
	pixel_shift_y = 16
	hud_offset_mod = 10 //A sprite long enough to touch the Moon.

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
	. = ..() // We are forcing attach_icon skin
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
			. = TRUE
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
			. = TRUE
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
			. = TRUE
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon
			. = TRUE
	return .

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
	. = ..() // We are forcing attach_icon skin
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
			. = TRUE
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
			. = TRUE
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
			. = TRUE
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon
			. = TRUE
	return .

/obj/item/attachable/upp_rpg_breech
	name = "HJRA-12 Breech"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "hjra_breech"
	attach_icon = "hjra_breech"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0

/obj/item/attachable/pkpbarrel
	name = "QYJ-72 Barrel"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "uppmg_barrel"
	attach_icon = "uppmg_barrel"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0

/obj/item/attachable/stock/pkpstock
	name = "QYJ-72 Stock"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "uppmg_stock"
	attach_icon = "uppmg_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 20 //the thought of a upp spec beating people to death with a pk makes me laugh
	size_mod = 0

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

/obj/item/attachable/type73suppressor
	name = "Type 73 Integrated Suppressor"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "type73_suppressor"
	attach_icon = "type73_suppressor"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0

/obj/item/attachable/stock/type71
	name = "Type 71 Stock"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "type71_stock"
	attach_icon = "type71_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 15
	size_mod = 0

/obj/item/attachable/stock/type71/New()
	..()

/obj/item/attachable/stock/m60
	name = "M60 stock"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "m60_stock"
	attach_icon = "m60_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 15
	size_mod = 0


/obj/item/attachable/stock/ppsh
	name = "PPSh-17b stock"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "ppsh17b_stock"
	attach_icon = "ppsh17b_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 10
	size_mod = 0



/obj/item/attachable/stock/smg
	name = "submachinegun stock"
	desc = "A rare ARMAT stock distributed in small numbers to USCM forces. Compatible with the M39, this stock reduces recoil and improves accuracy, but at a reduction to handling and agility. Seemingly a bit more effective in a brawl"
	slot = "stock"
	melee_mod = 15
	size_mod = 1
	icon_state = "smgstock"
	attach_icon = "smgstock_a"
	pixel_shift_x = 42
	pixel_shift_y = 11
	wield_delay_mod = WIELD_DELAY_FAST
	hud_offset_mod = 5

/obj/item/attachable/stock/smg/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_7
	recoil_mod = -RECOIL_AMOUNT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_6
	delay_mod = 0
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	aim_speed_mod = CONFIG_GET(number/slowdown_low)


/obj/item/attachable/stock/smg/collapsible
	name = "submachinegun folding stock"
	desc = "A Kirchner brand K2 M39 folding stock, standard issue in the USCM. The stock, when extended, reduces recoil and improves accuracy, but at a reduction to handling and agility. Seemingly a bit more effective in a brawl. This stock can collapse in, removing all positive and negative effects."
	slot = "stock"
	melee_mod = 10
	size_mod = 1
	icon_state = "smgstockc"
	attach_icon = "smgstockc_a"
	pixel_shift_x = 43
	pixel_shift_y = 11
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	hud_offset_mod = 5
	collapsible = TRUE
	var/base_icon = "smgstockc"


/obj/item/attachable/stock/smg/collapsible/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	wield_delay_mod = WIELD_DELAY_FAST
	delay_mod = 0
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10
	//but at the same time you are slowish when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_low)


/obj/item/attachable/stock/smg/collapsible/apply_on_weapon(obj/item/weapon/gun/gun)
	if(stock_activated)
		accuracy_mod = HIT_ACCURACY_MULT_TIER_3
		recoil_mod = -RECOIL_AMOUNT_TIER_4
		scatter_mod = -SCATTER_AMOUNT_TIER_8
		scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10
		size_mod = 1
		aim_speed_mod = CONFIG_GET(number/slowdown_low)
		wield_delay_mod = WIELD_DELAY_FAST
		movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
		accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
		recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
		hud_offset_mod = 5
		icon_state = base_icon
		attach_icon = "[base_icon]_a"

	else
		accuracy_mod = 0
		recoil_mod = 0
		scatter_mod = 0
		scatter_unwielded_mod = 0
		size_mod = 0
		aim_speed_mod = 0
		wield_delay_mod = 0
		movement_onehanded_acc_penalty_mod = 0
		accuracy_unwielded_mod = 0
		recoil_unwielded_mod = 0
		hud_offset_mod = 3
		icon_state = "[base_icon]c"
		attach_icon = "[base_icon]c_a"

	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")

/obj/item/attachable/stock/smg/collapsible/mp5a5
	name = "MP5A5 folding stock"
	icon_state = "mp5_stockc"
	base_icon = "mp5_stockc"
	attach_icon = "mp5_stockc_a"
	flags_attach_features = ATTACH_ACTIVATION
	stock_activated = FALSE

/obj/item/attachable/stock/smg/collapsible/brace
	name = "\improper submachinegun arm brace"
	desc = "A specialized stock for use on an M39 submachine gun. It makes one handing more accurate at the expense of burst amount. Wielding the weapon with this stock attached confers a major inaccuracy and recoil debuff."
	size_mod = 1
	icon_state = "smg_brace"
	base_icon = "smg_brace"
	attach_icon = "smg_brace_a"
	pixel_shift_x = 43
	pixel_shift_y = 11
	collapse_delay = 2.5 SECONDS
	stock_activated = FALSE
	deploy_message = list("unlock","lock")
	hud_offset_mod = 4

/obj/item/attachable/stock/smg/collapsible/brace/New()
	..()
	//Emulates two-handing an SMG.
	burst_mod = -BURST_AMOUNT_TIER_3 //2 shots instead of 5.

	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	scatter_mod = SCATTER_AMOUNT_TIER_8
	recoil_mod = RECOIL_AMOUNT_TIER_2
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NORMAL//you shouldn't be wielding it anyways

/obj/item/attachable/stock/smg/collapsible/brace/apply_on_weapon(obj/item/weapon/gun/G)
	if(stock_activated)
		G.flags_item |= NODROP|FORCEDROP_CONDITIONAL
		accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
		scatter_mod = SCATTER_AMOUNT_TIER_8
		recoil_mod = RECOIL_AMOUNT_TIER_2 //Hurts pretty bad if it's wielded.
		accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_4
		recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_4
		movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4 //Does well if it isn't.
		hud_offset_mod = 5
		icon_state = "smg_brace_on"
		attach_icon = "smg_brace_a_on"
	else
		G.flags_item &= ~(NODROP|FORCEDROP_CONDITIONAL)
		accuracy_mod = 0
		scatter_mod = 0
		recoil_mod = 0
		accuracy_unwielded_mod = 0
		recoil_unwielded_mod = 0
		movement_onehanded_acc_penalty_mod = 0 //Does pretty much nothing if it's not activated.
		hud_offset_mod = 4
		icon_state = "smg_brace"
		attach_icon = "smg_brace_a"

	G.recalculate_attachment_bonuses()
	G.update_overlays(src, "stock")

/obj/item/attachable/stock/revolver
	name = "\improper M44 magnum sharpshooter stock"
	desc = "A wooden stock modified for use on a 44-magnum. Increases accuracy and reduces recoil at the expense of handling and agility. Less effective in melee as well."
	slot = "stock"
	melee_mod = -5
	size_mod = 1
	icon_state = "44stock"
	pixel_shift_x = 35
	pixel_shift_y = 19
	wield_delay_mod = WIELD_DELAY_FAST
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	hud_offset_mod = 7 //Extremely long.
	var/folded = FALSE
	var/list/allowed_hat_items = list(
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver/marksman,
					/obj/item/ammo_magazine/revolver/heavy)

/obj/item/attachable/stock/revolver/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_7
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8
	//but at the same time you are slow when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_med)


/obj/item/attachable/stock/revolver/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	var/obj/item/weapon/gun/revolver/m44/R = G
	if(!istype(R))
		return 0

	if(!user)
		return 1

	if(user.action_busy)
		return

	if(R.flags_item & WIELDED)
		if(folded)
			to_chat(user, SPAN_NOTICE("You need a free hand to unfold [src]."))
		else
			to_chat(user, SPAN_NOTICE("You need a free hand to fold [src]."))
		return 0

	if(!do_after(user, 15, INTERRUPT_INCAPACITATED|INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC, G, INTERRUPT_DIFF_LOC))
		return

	playsound(user, activation_sound, 15, 1)

	if(folded)
		to_chat(user, SPAN_NOTICE("You unfold [src]."))
		R.flags_equip_slot &= ~SLOT_WAIST
		R.folded = FALSE
		icon_state = "44stock"
		size_mod = 1
		hud_offset_mod = 7
		G.recalculate_attachment_bonuses()
	else
		to_chat(user, SPAN_NOTICE("You fold [src]."))
		R.flags_equip_slot |= SLOT_WAIST // Allow to be worn on the belt when folded
		R.folded = TRUE // We can't shoot anymore, its folded
		icon_state = "44stock_folded"
		size_mod = 0
		hud_offset_mod = 4
		G.recalculate_attachment_bonuses()
	folded = !folded
	G.update_overlays(src, "stock")

// If it is activated/folded when we attach it, re-apply the things
/obj/item/attachable/stock/revolver/Attach(obj/item/weapon/gun/G)
	..()
	var/obj/item/weapon/gun/revolver/m44/R = G
	if(!istype(R))
		return 0

	if(folded)
		R.flags_equip_slot |= SLOT_WAIST
		R.folded = TRUE
	else
		R.flags_equip_slot &= ~SLOT_WAIST //Can't wear it on the belt slot with stock on when we attach it first time.

// When taking it off we want to undo everything not statwise
/obj/item/attachable/stock/revolver/Detach(mob/user, obj/item/weapon/gun/detaching_gun)
	..()
	var/obj/item/weapon/gun/revolver/m44/R = detaching_gun
	if(!istype(R))
		return 0

	if(folded)
		R.folded = FALSE
	else
		R.flags_equip_slot |= SLOT_WAIST

/obj/item/attachable/stock/nsg23
	name = "NSG 23 stock"
	desc = "If you can read this, someone screwed up. Go Github this and bug a coder."
	icon_state = "nsg23_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	melee_mod = 5
	size_mod = 2
	pixel_shift_x = 21
	pixel_shift_y = 20
	hud_offset_mod = 2

/obj/item/attachable/stock/l23
	name = "L23 stock"
	desc = "If you can read this, someone screwed up. Go Github this and bug a coder."
	icon_state = "l23_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	melee_mod = 5
	size_mod = 2
	pixel_shift_x = 21
	pixel_shift_y = 20
	hud_offset_mod = 2

// ======== Underbarrel Attachments ======== //


/obj/item/attachable/attached_gun
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	attachment_action_type = /datum/action/item_action/toggle
	// Some attachments may be fired. So here are the variables related to that.
	/// Ammo to fire the attachment with
	var/datum/ammo/ammo = null
	var/max_range = 0 //Determines # of tiles distance the attachable can fire, if it's not a projectile.
	var/last_fired //When the attachment was last fired.
	var/attachment_firing_delay = 0 //the delay between shots, for attachments that fires stuff
	var/fire_sound = null //Sound to play when firing it alternately
	var/gun_deactivate_sound = 'sound/weapons/handling/gun_underbarrel_deactivate.ogg'//allows us to give the attached gun unique activate and de-activate sounds. Not used yet.
	var/gun_activate_sound  = 'sound/weapons/handling/gun_underbarrel_activate.ogg'
	var/unload_sound = 'sound/weapons/gun_shotgun_shell_insert.ogg'

	/// An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	/// that will be given to the projectiles of the attached gun
	var/list/list/traits_to_give_attached
	/// Current target we're firing at
	var/mob/target

/obj/item/attachable/attached_gun/Initialize(mapload, ...) //Let's make sure if something needs an ammo type, it spawns with one.
	. = ..()
	if(ammo)
		ammo = GLOB.ammo_list[ammo]


/obj/item/attachable/attached_gun/Destroy()
	ammo = null
	target = null
	return ..()

/// setter for target
/obj/item/attachable/attached_gun/proc/set_target(atom/object)
	if(object == target)
		return
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = object
	if(target)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clean_target))

///Set the target to its turf, so we keep shooting even when it was qdeled
/obj/item/attachable/attached_gun/proc/clean_target()
	SIGNAL_HANDLER
	target = get_turf(target)

/obj/item/attachable/attached_gun/proc/reset_damage_mult(obj/item/weapon/gun/gun)
	SIGNAL_HANDLER
	gun.damage_mult = 1

/obj/item/attachable/attached_gun/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	if(G.active_attachable == src)
		if(user)
			to_chat(user, SPAN_NOTICE("You are no longer using [src]."))
			playsound(user, gun_deactivate_sound, 30, 1)
		G.active_attachable = null
		icon_state = initial(icon_state)
		UnregisterSignal(G, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES)
		G.recalculate_attachment_bonuses()
	else if(!turn_off)
		if(user)
			to_chat(user, SPAN_NOTICE("You are now using [src]."))
			playsound(user, gun_activate_sound, 60, 1)
		G.active_attachable = src
		G.damage_mult = 1
		RegisterSignal(G, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES, PROC_REF(reset_damage_mult))
		icon_state += "-on"

	SEND_SIGNAL(G, COMSIG_GUN_INTERRUPT_FIRE)

	for(var/X in G.actions)
		var/datum/action/A = X
		A.update_button_icon()
	return 1



//The requirement for an attachable being alt fire is AMMO CAPACITY > 0.
/obj/item/attachable/attached_gun/grenade
	name = "U1 grenade launcher"
	desc = "A weapon-mounted, reloadable grenade launcher."
	icon_state = "grenade"
	attach_icon = "grenade_a"
	w_class = SIZE_MEDIUM
	current_rounds = 0
	max_rounds = 3
	max_range = 7
	slot = "under"
	fire_sound = 'sound/weapons/gun_m92_attachable.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	var/grenade_pass_flags
	var/list/loaded_grenades //list of grenade types loaded in the UGL
	var/breech_open = FALSE // is the UGL open for loading?
	var/cocked = TRUE // has the UGL been cocked via opening and closing the breech?
	var/open_sound = 'sound/weapons/handling/ugl_open.ogg'
	var/close_sound = 'sound/weapons/handling/ugl_close.ogg'

/obj/item/attachable/attached_gun/grenade/Initialize()
	. = ..()
	grenade_pass_flags = PASS_HIGH_OVER|PASS_MOB_THRU|PASS_OVER

/obj/item/attachable/attached_gun/grenade/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_4 * 3
	loaded_grenades = list()

/obj/item/attachable/attached_gun/grenade/get_examine_text(mob/user)
	. = ..()
	if(current_rounds) . += "It has [current_rounds] grenade\s left."
	else . += "It's empty."

/obj/item/attachable/attached_gun/grenade/unique_action(mob/user)
	if(!ishuman(usr))
		return
	if(user.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(user, SPAN_WARNING("Not right now."))
		return

	var/obj/item/weapon/gun/G = user.get_held_item()
	if(!istype(G))
		G = user.get_inactive_hand()
	if(!istype(G) && G != null)
		G = user.get_active_hand()
	if(!G)
		to_chat(user, SPAN_WARNING("You need to hold \the [src] to do that"))
		return

	pump(user)

/obj/item/attachable/attached_gun/grenade/update_icon()
	. = ..()
	attach_icon = initial(attach_icon)
	icon_state = initial(icon_state)
	if(breech_open)
		attach_icon += "-open"
		icon_state += "-open"
	if(istype(loc, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/gun = loc
		gun.update_attachable(slot)

/obj/item/attachable/attached_gun/grenade/proc/pump(mob/user) //for want of a better proc name
	if(breech_open) // if it was ALREADY open
		breech_open = FALSE
		cocked = TRUE // by closing the gun we have cocked it and readied it to fire
		to_chat(user, SPAN_NOTICE("You close \the [src]'s breech, cocking it!"))
		playsound(src, close_sound, 15, 1)
	else
		breech_open = TRUE
		cocked = FALSE
		to_chat(user, SPAN_NOTICE("You open \the [src]'s breech!"))
		playsound(src, open_sound, 15, 1)
	update_icon()

/obj/item/attachable/attached_gun/grenade/reload_attachment(obj/item/explosive/grenade/G, mob/user)
	if(!breech_open)
		to_chat(user, SPAN_WARNING("\The [src]'s breech must be open to load grenades! (use unique-action)"))
		return
	if(!istype(G) || istype(G, /obj/item/explosive/grenade/spawnergrenade/))
		to_chat(user, SPAN_WARNING("[src] doesn't accept that type of grenade."))
		return
	if(!G.active) //can't load live grenades
		if(!G.underslug_launchable)
			to_chat(user, SPAN_WARNING("[src] doesn't accept that type of grenade."))
			return
		if(current_rounds >= max_rounds)
			to_chat(user, SPAN_WARNING("[src] is full."))
		else
			playsound(user, 'sound/weapons/grenade_insert.wav', 25, 1)
			current_rounds++
			loaded_grenades += G
			to_chat(user, SPAN_NOTICE("You load \the [G] into \the [src]."))
			user.drop_inv_item_to_loc(G, src)

/obj/item/attachable/attached_gun/grenade/unload_attachment(mob/user, reload_override = FALSE, drop_override = FALSE, loc_override = FALSE)
	. = TRUE //Always uses special unloading.
	if(!breech_open)
		to_chat(user, SPAN_WARNING("\The [src] is closed! You must open it to take out grenades!"))
		return
	if(!current_rounds)
		to_chat(user, SPAN_WARNING("It's empty!"))
		return

	var/obj/item/explosive/grenade/nade = loaded_grenades[length(loaded_grenades)] //Grab the last-inserted one. Or the only one, as the case may be.
	loaded_grenades.Remove(nade)
	current_rounds--

	if(drop_override || !user)
		nade.forceMove(get_turf(src))
	else
		user.put_in_hands(nade)

	user.visible_message(SPAN_NOTICE("[user] unloads \a [nade] from \the [src]."),
	SPAN_NOTICE("You unload \a [nade] from \the [src]."), null, 4, CHAT_TYPE_COMBAT_ACTION)
	playsound(user, unload_sound, 30, 1)

/obj/item/attachable/attached_gun/grenade/fire_attachment(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	if(!(gun.flags_item & WIELDED))
		if(user)
			to_chat(user, SPAN_WARNING("You must hold [gun] with two hands to use \the [src]."))
		return
	if(breech_open)
		if(user)
			to_chat(user, SPAN_WARNING("You must close the breech to fire \the [src]!"))
			playsound(user, 'sound/weapons/gun_empty.ogg', 50, TRUE, 5)
		return
	if(!cocked)
		if(user)
			to_chat(user, SPAN_WARNING("You must cock \the [src] to fire it! (open and close the breech)"))
			playsound(user, 'sound/weapons/gun_empty.ogg', 50, TRUE, 5)
		return
	if(get_dist(user,target) > max_range)
		to_chat(user, SPAN_WARNING("Too far to fire the attachment!"))
		playsound(user, 'sound/weapons/gun_empty.ogg', 50, TRUE, 5)
		return

	if(current_rounds > 0 && ..())
		prime_grenade(target,gun,user)

/obj/item/attachable/attached_gun/grenade/proc/prime_grenade(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	set waitfor = 0
	var/obj/item/explosive/grenade/G = loaded_grenades[1]

	if(G.antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(G, user))
		to_chat(user, SPAN_WARNING("\The [name]'s safe-area accident inhibitor prevents you from firing!"))
		msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
		return

	playsound(user.loc, fire_sound, 50, 1)
	msg_admin_attack("[key_name_admin(user)] fired an underslung grenade launcher [ADMIN_JMP_USER(user)]")
	log_game("[key_name_admin(user)] used an underslung grenade launcher.")

	var/pass_flags = NO_FLAGS
	pass_flags |= grenade_pass_flags
	G.det_time = min(15, G.det_time)
	G.throw_range = max_range
	G.activate(user, FALSE)
	G.forceMove(get_turf(gun))
	G.throw_atom(target, max_range, SPEED_VERY_FAST, user, null, NORMAL_LAUNCH, pass_flags)
	current_rounds--
	cocked = FALSE // we have fired so uncock the gun
	loaded_grenades.Cut(1,2)

//For the Mk1
/obj/item/attachable/attached_gun/grenade/mk1
	name = "\improper MK1 underslung grenade launcher"
	desc = "An older version of the classic underslung grenade launcher. Can store five grenades, and fire them farther, but fires them slower."
	icon_state = "grenade-mk1"
	attach_icon = "grenade-mk1_a"
	current_rounds = 0
	max_rounds = 5
	max_range = 10
	attachment_firing_delay = 30

/obj/item/attachable/attached_gun/grenade/m203 //M16 GL, only DD have it.
	name = "\improper M203 Grenade Launcher"
	desc = "An antique underbarrel grenade launcher. Adopted in 1969 for the M16, it was made obsolete centuries ago; how its ended up here is a mystery to you. Holds only one propriatary 40mm grenade, does not have modern IFF systems, it won't pass through your friends."
	icon_state = "grenade-m203"
	attach_icon = "grenade-m203_a"
	current_rounds = 0
	max_rounds = 1
	max_range = 14
	attachment_firing_delay = 5 //one shot, so if you can reload fast you can shoot fast

/obj/item/attachable/attached_gun/grenade/m203/Initialize()
	. = ..()
	grenade_pass_flags = NO_FLAGS


/obj/item/attachable/attached_gun/grenade/u1rmc
	name = "\improper H34 underslung grenade launcher"
	desc = "A W-Y take on an underslung grenade launcher system, made for the NSG23 line of weapons. Can store up to five grenades and fires them about as far as your U1 UGL for M41A Mk2."
	icon_state = "u1rmc"
	attach_icon = "u1rmc_a"
	current_rounds = 0
	max_rounds = 5
	max_range = 10
	attachment_firing_delay = 24

//"ammo/flamethrower" is a bullet, but the actual process is handled through fire_attachment, linked through Fire().
/obj/item/attachable/attached_gun/flamer
	name = "mini flamethrower"
	icon_state = "flamethrower"
	attach_icon = "flamethrower_a"
	desc = "A weapon-mounted refillable flamethrower attachment. It has a secondary setting for a more intense flame with far less propulsion ability and heavy fuel usage."
	w_class = SIZE_MEDIUM
	current_rounds = 40
	max_rounds = 40
	max_range = 5
	slot = "under"
	fire_sound = 'sound/weapons/gun_flamethrower3.ogg'
	gun_activate_sound = 'sound/weapons/handling/gun_underbarrel_flamer_activate.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	var/burn_level = BURN_LEVEL_TIER_1
	var/burn_duration = BURN_TIME_TIER_1
	var/round_usage_per_tile = 1
	var/intense_mode = FALSE

/obj/item/attachable/attached_gun/flamer/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_4 * 5

/obj/item/attachable/attached_gun/flamer/get_examine_text(mob/user)
	. = ..()
	if(intense_mode)
		. += "It is currently using a more intense and volatile flame."
	else
		. += "It is using a normal and stable flame."
	if(current_rounds > 0)
		. += "It has [current_rounds] unit\s of fuel left."
	else
		. += "It's empty."

/obj/item/attachable/attached_gun/flamer/unique_action(mob/user)
	..()
	playsound(user,'sound/weapons/handling/flamer_ignition.ogg', 25, 1)
	if(intense_mode)
		to_chat(user, SPAN_WARNING("You change \the [src] back to using a normal and more stable flame."))
		round_usage_per_tile = 1
		burn_level = BURN_LEVEL_TIER_1
		burn_duration = BURN_TIME_TIER_1
		max_range = 5
		intense_mode = FALSE
	else
		to_chat(user, SPAN_WARNING("You change \the [src] to use a more intense and volatile flame."))
		round_usage_per_tile = 5
		burn_level = BURN_LEVEL_TIER_5
		burn_duration = BURN_TIME_TIER_2
		max_range = 2
		intense_mode = TRUE

/obj/item/attachable/attached_gun/flamer/handle_pre_break_attachment_description(base_description_text as text)
	return base_description_text + " It is on [intense_mode ? "intense" : "normal"] mode."

/obj/item/attachable/attached_gun/flamer/reload_attachment(obj/item/ammo_magazine/flamer_tank/fuel_holder, mob/user)
	if(istype(fuel_holder))
		var/amt_to_refill = max_rounds - current_rounds
		if(!amt_to_refill)
			to_chat(user, SPAN_WARNING("[src] is full."))
			return

		if(!fuel_holder.reagents || length(fuel_holder.reagents.reagent_list) < 1)
			to_chat(user, SPAN_WARNING("[fuel_holder] is empty!"))
			return

		var/datum/reagent/to_remove = fuel_holder.reagents.reagent_list[1]

		var/flamer_chem = "utnapthal"
		if(!istype(to_remove) || flamer_chem != to_remove.id || length(fuel_holder.reagents.reagent_list) > 1)
			to_chat(user, SPAN_WARNING("You can't mix fuel mixtures!"))
			return

		var/fuel_amt
		if(to_remove)
			fuel_amt = to_remove.volume < amt_to_refill ? to_remove.volume : amt_to_refill

		if(!fuel_amt)
			to_chat(user, SPAN_WARNING("[fuel_holder] is empty!"))
			return

		playsound(user, 'sound/effects/refill.ogg', 25, 1, 3)
		to_chat(user, SPAN_NOTICE("You refill [src] with [fuel_holder]."))
		current_rounds += fuel_amt
		fuel_holder.reagents.remove_reagent(to_remove.id, fuel_amt)
		fuel_holder.update_icon()
	else
		to_chat(user, SPAN_WARNING("[src] can only be refilled with an incinerator tank."))

/obj/item/attachable/attached_gun/flamer/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	if(get_dist(user,target) > max_range+4)
		to_chat(user, SPAN_WARNING("Too far to fire the attachment!"))
		return

	if(!istype(loc, /obj/item/weapon/gun))
		to_chat(user, SPAN_WARNING("\The [src] must be attached to a gun!"))
		return

	var/obj/item/weapon/gun/attached_gun = loc

	if(!(attached_gun.flags_item & WIELDED))
		to_chat(user, SPAN_WARNING("You must wield [attached_gun] to fire [src]!"))
		return

	if(current_rounds > round_usage_per_tile && ..())
		unleash_flame(target, user)
		if(attached_gun.last_fired < world.time)
			attached_gun.last_fired = world.time

/obj/item/attachable/attached_gun/flamer/proc/unleash_flame(atom/target, mob/living/user)
	set waitfor = 0
	var/list/turf/turfs = get_line(user,target)
	var/distance = 0
	var/turf/prev_T
	var/stop_at_turf = FALSE
	playsound(user, 'sound/weapons/gun_flamethrower2.ogg', 50, 1)
	for(var/turf/T in turfs)
		if(T == user.loc)
			prev_T = T
			continue
		if(!current_rounds || current_rounds < round_usage_per_tile)
			break
		if(distance >= max_range)
			break

		current_rounds -= round_usage_per_tile
		var/datum/cause_data/cause_data = create_cause_data(initial(name), user)
		if(T.density)
			T.flamer_fire_act(0, cause_data)
			stop_at_turf = TRUE
		else if(prev_T)
			var/atom/movable/temp = new/obj/flamer_fire()
			var/atom/movable/AM = LinkBlocked(temp, prev_T, T)
			qdel(temp)
			if(AM)
				AM.flamer_fire_act(0, cause_data)
				if (AM.flags_atom & ON_BORDER)
					break
				stop_at_turf = TRUE
		flame_turf(T, user)
		if (stop_at_turf)
			break
		distance++
		prev_T = T
		sleep(1)


/obj/item/attachable/attached_gun/flamer/proc/flame_turf(turf/T, mob/living/user)
	if(!istype(T))
		return

	if(!locate(/obj/flamer_fire) in T) // No stacking flames!
		var/datum/reagent/napalm/ut/R = new()

		R.intensityfire = burn_level
		R.durationfire = burn_duration

		new/obj/flamer_fire(T, create_cause_data(initial(name), user), R)

/obj/item/attachable/attached_gun/flamer/advanced
	name = "advanced mini flamethrower"
	current_rounds = 50
	max_rounds = 50
	max_range = 6
	burn_level = BURN_LEVEL_TIER_5
	burn_duration = BURN_TIME_TIER_2

/obj/item/attachable/attached_gun/flamer/advanced/unique_action(mob/user)
	return	//No need for volatile mode, it already does high damage by default

/obj/item/attachable/attached_gun/flamer/advanced/integrated
	name = "integrated flamethrower"

/obj/item/attachable/attached_gun/shotgun //basically, a masterkey
	name = "\improper U7 underbarrel shotgun"
	icon_state = "masterkey"
	attach_icon = "masterkey_a"
	desc = "An ARMAT U7 tactical shotgun. Attaches to the underbarrel of most weapons. Only capable of loading up to five buckshot shells. Specialized for breaching into buildings."
	w_class = SIZE_MEDIUM
	max_rounds = 5
	current_rounds = 5
	ammo = /datum/ammo/bullet/shotgun/buckshot/masterkey
	slot = "under"
	fire_sound = 'sound/weapons/gun_shotgun_u7.ogg'
	gun_activate_sound = 'sound/weapons/handling/gun_u7_activate.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_PROJECTILE|ATTACH_RELOADABLE|ATTACH_WEAPON

/obj/item/attachable/attached_gun/shotgun/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_5*3

/obj/item/attachable/attached_gun/shotgun/get_examine_text(mob/user)
	. = ..()
	if(current_rounds > 0) . += "It has [current_rounds] shell\s left."
	else . += "It's empty."

/obj/item/attachable/attached_gun/shotgun/set_bullet_traits()
	LAZYADD(traits_to_give_attached, list(
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 5, GLOB.damage_boost_turfs),
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 10.8, GLOB.damage_boost_breaching),
		BULLET_TRAIT_ENTRY_ID("pylons", /datum/element/bullet_trait_damage_boost, 5, GLOB.damage_boost_pylons)
	))

/obj/item/attachable/attached_gun/shotgun/reload_attachment(obj/item/ammo_magazine/handful/mag, mob/user)
	if(istype(mag) && mag.flags_magazine & AMMUNITION_HANDFUL)
		if(mag.default_ammo == /datum/ammo/bullet/shotgun/buckshot)
			if(current_rounds >= max_rounds)
				to_chat(user, SPAN_WARNING("[src] is full."))
			else
				current_rounds++
				mag.current_rounds--
				mag.update_icon()
				to_chat(user, SPAN_NOTICE("You load one shotgun shell in [src]."))
				playsound(user, 'sound/weapons/gun_shotgun_shell_insert.ogg', 25, 1)
				if(mag.current_rounds <= 0)
					user.temp_drop_inv_item(mag)
					qdel(mag)
			return
	to_chat(user, SPAN_WARNING("[src] only accepts shotgun buckshot."))

/obj/item/attachable/attached_gun/shotgun/af13 //NSG underslung shottie
	name = "\improper AF13 underbarrel shotgun"
	icon_state = "masterkey_af13"
	attach_icon = "masterkey_af13_a"
	desc = "A Weyland-Yutani AF13 underslung shotgun. Attaches to the underbarrel of NSG23 line of weapons. Only capable of loading up to six buckshot shells. Specialized for breaching into buildings."
	w_class = SIZE_MEDIUM
	max_rounds = 6
	current_rounds = 6
	ammo = /datum/ammo/bullet/shotgun/buckshot/masterkey
	slot = "under"
	fire_sound = 'sound/weapons/gun_shotgun_u7.ogg'
	gun_activate_sound = 'sound/weapons/handling/gun_u7_activate.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_PROJECTILE|ATTACH_RELOADABLE|ATTACH_WEAPON

/obj/item/attachable/attached_gun/shotgun/af13/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_5*3

/obj/item/attachable/attached_gun/shotgun/af13/get_examine_text(mob/user)
	. = ..()
	if(current_rounds > 0) . += "It has [current_rounds] shell\s left."
	else . += "It's empty."

/obj/item/attachable/attached_gun/shotgun/af13/set_bullet_traits()
	LAZYADD(traits_to_give_attached, list(
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 5, GLOB.damage_boost_turfs),
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 10.8, GLOB.damage_boost_breaching),
		BULLET_TRAIT_ENTRY_ID("pylons", /datum/element/bullet_trait_damage_boost, 5, GLOB.damage_boost_pylons)
	))

/obj/item/attachable/attached_gun/shotgun/af13/reload_attachment(obj/item/ammo_magazine/handful/mag, mob/user)
	if(istype(mag) && mag.flags_magazine & AMMUNITION_HANDFUL)
		if(mag.default_ammo == /datum/ammo/bullet/shotgun/buckshot)
			if(current_rounds >= max_rounds)
				to_chat(user, SPAN_WARNING("[src] is full."))
			else
				current_rounds++
				mag.current_rounds--
				mag.update_icon()
				to_chat(user, SPAN_NOTICE("You load one shotgun shell in [src]."))
				playsound(user, 'sound/weapons/gun_shotgun_shell_insert.ogg', 25, 1)
				if(mag.current_rounds <= 0)
					user.temp_drop_inv_item(mag)
					qdel(mag)
			return
	to_chat(user, SPAN_WARNING("[src] only accepts shotgun buckshot."))

/obj/item/attachable/attached_gun/shotgun/af13b //NSG underslung shottie for Breacher gun
	name = "\improper AF13-B underbarrel shotgun"
	icon_state = "masterkey_af13"
	attach_icon = "masterkey_af13_a"
	desc = "A Weyland-Yutani AF13-B underslung shotgun, heavily modified by RMC Armourers. Attaches to the underbarrel of NSG23 line of weapons. Only capable of loading up to six buckshot shells. Specialized for breaching into buildings."
	w_class = SIZE_MEDIUM
	max_rounds = 6
	current_rounds = 6
	ammo = /datum/ammo/bullet/shotgun/buckshot/masterkey
	slot = "under"
	fire_sound = 'sound/weapons/gun_shotgun_u7.ogg'
	gun_activate_sound = 'sound/weapons/handling/gun_u7_activate.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_PROJECTILE|ATTACH_RELOADABLE|ATTACH_WEAPON|ATTACH_WIELD_OVERRIDE

/obj/item/attachable/attached_gun/shotgun/af13b/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_5*3

/obj/item/attachable/attached_gun/shotgun/af13b/get_examine_text(mob/user)
	. = ..()
	if(current_rounds > 0) . += "It has [current_rounds] shell\s left."
	else . += "It's empty."

/obj/item/attachable/attached_gun/shotgun/af13b/set_bullet_traits()
	LAZYADD(traits_to_give_attached, list(
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 2*5, GLOB.damage_boost_turfs), // 3 hits to break down regular walls, about 6 to break down r-walls
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 3*10.8, GLOB.damage_boost_breaching), // 2-taps the R doors
		BULLET_TRAIT_ENTRY_ID("pylons", /datum/element/bullet_trait_damage_boost, 2*5, GLOB.damage_boost_pylons)
	))

/obj/item/attachable/attached_gun/shotgun/af13b/reload_attachment(obj/item/ammo_magazine/handful/mag, mob/user)
	if(istype(mag) && mag.flags_magazine & AMMUNITION_HANDFUL)
		if(mag.default_ammo == /datum/ammo/bullet/shotgun/buckshot)
			if(current_rounds >= max_rounds)
				to_chat(user, SPAN_WARNING("[src] is full."))
			else
				current_rounds++
				mag.current_rounds--
				mag.update_icon()
				to_chat(user, SPAN_NOTICE("You load one shotgun shell in [src]."))
				playsound(user, 'sound/weapons/gun_shotgun_shell_insert.ogg', 25, 1)
				if(mag.current_rounds <= 0)
					user.temp_drop_inv_item(mag)
					qdel(mag)
			return
	to_chat(user, SPAN_WARNING("[src] only accepts shotgun buckshot."))


/obj/item/attachable/attached_gun/extinguisher
	name = "HME-12 underbarrel extinguisher"
	icon_state = "extinguisher"
	attach_icon = "extinguisher_a"
	desc = "A Taiho-Technologies HME-12 underbarrel extinguisher. Attaches to the underbarrel of most weapons. Point at flame before applying pressure."
	w_class = SIZE_MEDIUM
	slot = "under"
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_WEAPON|ATTACH_MELEE
	var/obj/item/tool/extinguisher/internal_extinguisher
	current_rounds = 1 //This has to be done to pass the fire_attachment check.

/obj/item/attachable/attached_gun/extinguisher/get_examine_text(mob/user)
	. = ..()
	if(internal_extinguisher)
		. += SPAN_NOTICE("It has [floor(internal_extinguisher.reagents.total_volume)] unit\s of water left!")
		return
	. += SPAN_WARNING("It's empty.")

/obj/item/attachable/attached_gun/extinguisher/handle_attachment_description(slot)
	return "It has a [icon2html(src)] [name] ([floor(internal_extinguisher.reagents.total_volume)]/[internal_extinguisher.max_water]) mounted underneath.<br>"

/obj/item/attachable/attached_gun/extinguisher/New()
	..()
	initialize_internal_extinguisher()

/obj/item/attachable/attached_gun/extinguisher/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	if(!internal_extinguisher)
		return
	if(..())
		return internal_extinguisher.afterattack(target, user)

/obj/item/attachable/attached_gun/extinguisher/proc/initialize_internal_extinguisher()
	internal_extinguisher = new /obj/item/tool/extinguisher/mini/integrated_flamer()
	internal_extinguisher.safety = FALSE
	internal_extinguisher.create_reagents(internal_extinguisher.max_water)
	internal_extinguisher.reagents.add_reagent("water", internal_extinguisher.max_water)

/obj/item/attachable/attached_gun/extinguisher/pyro
	name = "HME-88B underbarrel extinguisher"
	desc = "An experimental Taiho-Technologies HME-88B underbarrel extinguisher integrated with a select few gun models. It is capable of putting out the strongest of flames. Point at flame before applying pressure."
	flags_attach_features = ATTACH_ACTIVATION|ATTACH_WEAPON|ATTACH_MELEE //not removable

/obj/item/attachable/attached_gun/extinguisher/pyro/initialize_internal_extinguisher()
	internal_extinguisher = new /obj/item/tool/extinguisher/pyro()
	internal_extinguisher.safety = FALSE
	internal_extinguisher.create_reagents(internal_extinguisher.max_water)
	internal_extinguisher.reagents.add_reagent("water", internal_extinguisher.max_water)

/obj/item/attachable/attached_gun/flamer_nozzle
	name = "XM-VESG-1 flamer nozzle"
	desc = "A special nozzle designed to alter flamethrowers to be used in a more offense orientated manner. As the inside of the nozzle is coated in a special gel and resin substance that takes the fuel that passes through and hardens it. Upon exiting the barrel, a cluster of burning gel is projected instead of a stream of burning naphtha."
	desc_lore = "The Experimental Volatile-Exothermic-Sphere-Generator clip-on nozzle attachment for the M240A1 incinerator unit was specifically designed to allow marines to launch fireballs into enemy foxholes and bunkers. Despite the gel and resin coating, the flaming ball of naptha tears apart due the drag caused by launching it through the air, leading marines to use the attachment as a makeshift firework launcher during shore leave."
	icon_state = "flamer_nozzle"
	attach_icon = "flamer_nozzle_a_1"
	w_class = SIZE_MEDIUM
	slot = "under"
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_WEAPON|ATTACH_MELEE|ATTACH_IGNORE_EMPTY
	pixel_shift_x = 4
	pixel_shift_y = 14

	max_range = 6
	last_fired = 0
	attachment_firing_delay = 2 SECONDS

	var/projectile_type = /datum/ammo/flamethrower
	var/fuel_per_projectile = 3

	var/static/list/fire_sounds = list(
		'sound/weapons/gun_flamethrower1.ogg',
		'sound/weapons/gun_flamethrower2.ogg',
		'sound/weapons/gun_flamethrower3.ogg'
	)

/obj/item/attachable/attached_gun/flamer_nozzle/handle_attachment_description(slot)
	return "It has a [icon2html(src)] [name] mounted beneath the barrel.<br>"

/obj/item/attachable/attached_gun/flamer_nozzle/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	. = ..()
	attach_icon = "flamer_nozzle_a_[G.active_attachable == src ? 0 : 1]"
	G.update_icon()

/obj/item/attachable/attached_gun/flamer_nozzle/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	. = ..()

	if(world.time < gun.last_fired + gun.get_fire_delay())
		return

	if((gun.flags_gun_features & GUN_WIELDED_FIRING_ONLY) && !(gun.flags_item & WIELDED))
		to_chat(user, SPAN_WARNING("You must wield [gun] to fire [src]!"))
		return

	if(gun.flags_gun_features & GUN_TRIGGER_SAFETY)
		to_chat(user, SPAN_WARNING("\The [gun] isn't lit!"))
		return

	if(!istype(gun.current_mag, /obj/item/ammo_magazine/flamer_tank))
		to_chat(user, SPAN_WARNING("\The [gun] needs a flamer tank installed!"))
		return

	if(!length(gun.current_mag.reagents.reagent_list))
		to_chat(user, SPAN_WARNING("\The [gun] doesn't have enough fuel to launch a projectile!"))
		return

	var/datum/reagent/flamer_reagent = gun.current_mag.reagents.reagent_list[1]
	if(flamer_reagent.volume < FLAME_REAGENT_USE_AMOUNT * fuel_per_projectile)
		to_chat(user, SPAN_WARNING("\The [gun] doesn't have enough fuel to launch a projectile!"))
		return

	if(istype(flamer_reagent, /datum/reagent/foaming_agent/stabilized))
		to_chat(user, SPAN_WARNING("This chemical will clog the nozzle!"))
		return

	if(istype(gun.current_mag, /obj/item/ammo_magazine/flamer_tank/smoke)) // you can't fire smoke like a projectile!
		to_chat(user, SPAN_WARNING("[src] can't be used with this fuel tank!"))
		return

	gun.last_fired = world.time
	gun.current_mag.reagents.remove_reagent(flamer_reagent.id, FLAME_REAGENT_USE_AMOUNT * fuel_per_projectile)

	var/obj/projectile/P = new(src, create_cause_data(initial(name), user, src))
	var/datum/ammo/flamethrower/ammo_datum = new projectile_type
	ammo_datum.flamer_reagent_id = flamer_reagent.id
	P.generate_bullet(ammo_datum)
	P.icon_state = "naptha_ball"
	P.color = flamer_reagent.burncolor
	P.hit_effect_color = flamer_reagent.burncolor
	P.fire_at(target, user, user, max_range, AMMO_SPEED_TIER_2, null)
	var/turf/user_turf = get_turf(user)
	playsound(user_turf, pick(fire_sounds), 50, TRUE)

	to_chat(user, SPAN_WARNING("The gauge reads: <b>[floor(gun.current_mag.get_ammo_percent())]</b>% fuel remaining!"))

/obj/item/attachable/verticalgrip
	name = "vertical grip"
	desc = "A vertical foregrip that offers better accuracy, less recoil, and less scatter, especially during burst fire. \nHowever, it also increases weapon size."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "verticalgrip"
	attach_icon = "verticalgrip_a"
	size_mod = 1
	slot = "under"
	pixel_shift_x = 20

/obj/item/attachable/verticalgrip/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	burst_scatter_mod = -2
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10

/obj/item/attachable/angledgrip
	name = "angled grip"
	desc = "An angled foregrip that improves weapon ergonomics resulting in faster wielding time. \nHowever, it also increases weapon size."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "angledgrip"
	attach_icon = "angledgrip_a"
	wield_delay_mod = -WIELD_DELAY_FAST
	size_mod = 1
	slot = "under"
	pixel_shift_x = 20

/obj/item/attachable/gyro
	name = "gyroscopic stabilizer"
	desc = "A set of weights and balances to stabilize the weapon when fired with one hand. Slightly decreases firing speed."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "gyro"
	attach_icon = "gyro_a"
	slot = "under"

/obj/item/attachable/gyro/New()
	..()
	delay_mod = FIRE_DELAY_TIER_11
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	burst_scatter_mod = -2
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_3
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_6
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_3

/obj/item/attachable/gyro/Attach(obj/item/weapon/gun/G)
	if(istype(G, /obj/item/weapon/gun/shotgun))
		accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_10 + HIT_ACCURACY_MULT_TIER_1
	else
		accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_3
	..()


/obj/item/attachable/lasersight
	name = "laser sight"
	desc = "A laser sight that attaches to the underside of most weapons. Increases accuracy and decreases scatter, especially while one-handed."
	desc_lore = "A standard visible-band laser module designated as the AN/PEQ-42 Laser Sight. Can be mounted onto any firearm that has a lower rail large enough to accommodate it."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "lasersight"
	attach_icon = "lasersight_a"
	slot = "under"
	pixel_shift_x = 17
	pixel_shift_y = 17

/obj/item/attachable/lasersight/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_9
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1


/obj/item/attachable/bipod
	name = "bipod"
	desc = "A simple set of telescopic poles to keep a weapon stabilized during firing. \nGreatly increases accuracy and reduces recoil when properly placed, but also increases weapon size and slows firing speed."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "bipod"
	attach_icon = "bipod_a"
	slot = "under"
	size_mod = 2
	melee_mod = -10
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/initial_mob_dir = NORTH // the dir the mob faces the moment it deploys the bipod
	var/bipod_deployed = FALSE
	/// If this should anchor the user while in use
	var/heavy_bipod = FALSE
	// Are switching to full auto when deploying the bipod
	var/full_auto_switch = FALSE
	// Store our old firemode so we can switch to it when undeploying the bipod
	var/old_firemode = null

/obj/item/attachable/bipod/New()
	..()

	delay_mod = FIRE_DELAY_TIER_11
	wield_delay_mod = WIELD_DELAY_FAST
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_5
	scatter_mod = SCATTER_AMOUNT_TIER_9
	recoil_mod = RECOIL_AMOUNT_TIER_5

/obj/item/attachable/bipod/Attach(obj/item/weapon/gun/gun, mob/user)
	..()

	if((GUN_FIREMODE_AUTOMATIC in gun.gun_firemode_list) || (gun.flags_gun_features & GUN_SUPPORT_PLATFORM))
		var/given_action = FALSE
		if(user && (gun == user.l_hand || gun == user.r_hand))
			give_action(user, /datum/action/item_action/bipod/toggle_full_auto_switch, src, gun)
			given_action = TRUE
		if(!given_action)
			new /datum/action/item_action/bipod/toggle_full_auto_switch(src, gun)

	RegisterSignal(gun, COMSIG_ITEM_DROPPED, PROC_REF(handle_drop))

/obj/item/attachable/bipod/Detach(mob/user, obj/item/weapon/gun/detaching_gun)
	UnregisterSignal(detaching_gun, COMSIG_ITEM_DROPPED)

	//clear out anything related to full auto switching
	full_auto_switch = FALSE
	old_firemode = null
	for(var/item_action in detaching_gun.actions)
		var/datum/action/item_action/bipod/toggle_full_auto_switch/target_action = item_action
		if(target_action.target == src)
			qdel(item_action)
			break

	if(bipod_deployed)
		undeploy_bipod(detaching_gun, user)
	..()

/obj/item/attachable/bipod/update_icon()
	if(bipod_deployed)
		icon_state = "[icon_state]-on"
		attach_icon = "[attach_icon]-on"
	else
		icon_state = initial(icon_state)
		attach_icon = initial(attach_icon)

	if(istype(loc, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/gun = loc
		gun.update_attachable(slot)
		for(var/datum/action/item_action as anything in gun.actions)
			if(!istype(item_action, /datum/action/item_action/bipod/toggle_full_auto_switch))
				item_action.update_button_icon()

/obj/item/attachable/bipod/proc/handle_drop(obj/item/weapon/gun/gun, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	UnregisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK)

	if(bipod_deployed)
		undeploy_bipod(gun, user)
		user.apply_effect(1, SUPERSLOW)
		user.apply_effect(2, SLOW)

/obj/item/attachable/bipod/proc/undeploy_bipod(obj/item/weapon/gun/gun, mob/user)
	REMOVE_TRAIT(gun, TRAIT_GUN_BIPODDED, "attached_bipod")
	bipod_deployed = FALSE
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_5
	scatter_mod = SCATTER_AMOUNT_TIER_9
	recoil_mod = RECOIL_AMOUNT_TIER_5
	burst_scatter_mod = 0
	delay_mod = FIRE_DELAY_TIER_12
	//if we are no longer on full auto, don't bother switching back to the old firemode
	if(full_auto_switch && gun.gun_firemode == GUN_FIREMODE_AUTOMATIC && gun.gun_firemode != old_firemode)
		gun.do_toggle_firemode(user, null, old_firemode)

	gun.recalculate_attachment_bonuses()
	gun.stop_fire()
	SEND_SIGNAL(user, COMSIG_MOB_UNDEPLOYED_BIPOD)
	UnregisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK)

	if(gun.flags_gun_features & GUN_SUPPORT_PLATFORM)
		gun.remove_firemode(GUN_FIREMODE_AUTOMATIC)

	if(heavy_bipod)
		user.anchored = FALSE

	if(!QDELETED(gun))
		playsound(user,'sound/items/m56dauto_rotate.ogg', 55, 1)
		update_icon()

/obj/item/attachable/bipod/activate_attachment(obj/item/weapon/gun/gun, mob/living/user, turn_off)
	if(turn_off)
		if(bipod_deployed)
			undeploy_bipod(gun, user)
	else
		var/obj/support = check_bipod_support(gun, user)
		if(!support&&!bipod_deployed)
			to_chat(user, SPAN_NOTICE("You start deploying [src] on the ground."))
			if(!do_after(user, 15, INTERRUPT_ALL, BUSY_ICON_HOSTILE, gun, INTERRUPT_DIFF_LOC))
				return FALSE

		bipod_deployed = !bipod_deployed
		if(user)
			if(bipod_deployed)
				ADD_TRAIT(gun, TRAIT_GUN_BIPODDED, "attached_bipod")
				to_chat(user, SPAN_NOTICE("You deploy [src] [support ? "on [support]" : "on the ground"]."))
				SEND_SIGNAL(user, COMSIG_MOB_DEPLOYED_BIPOD)
				playsound(user,'sound/items/m56dauto_rotate.ogg', 55, 1)
				accuracy_mod = HIT_ACCURACY_MULT_TIER_5
				scatter_mod = -SCATTER_AMOUNT_TIER_10
				recoil_mod = -RECOIL_AMOUNT_TIER_4
				burst_scatter_mod = -SCATTER_AMOUNT_TIER_8
				if(istype(gun, /obj/item/weapon/gun/rifle/sniper/M42A))
					delay_mod = -FIRE_DELAY_TIER_7
				else
					delay_mod = -FIRE_DELAY_TIER_12
				gun.recalculate_attachment_bonuses()
				gun.stop_fire()

				initial_mob_dir = user.dir
				RegisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(handle_mob_move_or_look))

				if(gun.flags_gun_features & GUN_SUPPORT_PLATFORM)
					gun.add_firemode(GUN_FIREMODE_AUTOMATIC)

				if(heavy_bipod)
					user.anchored = TRUE

				old_firemode = gun.gun_firemode
				if(full_auto_switch && gun.gun_firemode != GUN_FIREMODE_AUTOMATIC)
					gun.do_toggle_firemode(user, null, GUN_FIREMODE_AUTOMATIC)

			else
				to_chat(user, SPAN_NOTICE("You retract [src]."))
				undeploy_bipod(gun, user)

	update_icon()

	return 1

/obj/item/attachable/bipod/proc/handle_mob_move_or_look(mob/living/mover, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(!actually_moving && (specific_direction & initial_mob_dir)) // if you're facing north, but you're shooting north-east and end up facing east, you won't lose your bipod
		return
	undeploy_bipod(loc, mover)
	mover.apply_effect(1, SUPERSLOW)
	mover.apply_effect(2, SLOW)


//when user fires the gun, we check if they have something to support the gun's bipod.
/obj/item/attachable/proc/check_bipod_support(obj/item/weapon/gun/gun, mob/living/user)
	return 0

/obj/item/attachable/bipod/check_bipod_support(obj/item/weapon/gun/gun, mob/living/user)
	var/turf/T = get_turf(user)
	for(var/obj/O in T)
		if(O.throwpass && O.density && O.dir == user.dir && O.flags_atom & ON_BORDER)
			return O
	var/turf/T2 = get_step(T, user.dir)

	for(var/obj/O2 in T2)
		if(O2.throwpass && O2.density)
			return O2
	return 0

//item actions for handling deployment to full auto.
/datum/action/item_action/bipod/toggle_full_auto_switch/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Full Auto Switch"
	action_icon_state = "full_auto_switch"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/bipod/toggle_full_auto_switch/action_activate()
	. = ..()
	var/obj/item/weapon/gun/holder_gun = holder_item
	var/obj/item/attachable/bipod/attached_bipod = holder_gun.attachments["under"]

	attached_bipod.full_auto_switch = !attached_bipod.full_auto_switch
	to_chat(owner, SPAN_NOTICE("[icon2html(holder_gun, owner)] You will [attached_bipod.full_auto_switch? "<B>start</b>" : "<B>stop</b>"] switching to full auto when deploying the bipod."))
	playsound(owner, 'sound/weapons/handling/gun_burst_toggle.ogg', 15, 1)

	if(attached_bipod.full_auto_switch)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)


/obj/item/attachable/bipod/m60
	name = "bipod"
	desc = "A simple set of telescopic poles to keep a weapon stabilized during firing. This one looks rather old.\nGreatly increases accuracy and reduces recoil when properly placed, but also increases weapon size and slows firing speed."
	icon_state = "bipod_m60"
	attach_icon = "bipod_m60_a"

	flags_attach_features = ATTACH_ACTIVATION

/obj/item/attachable/bipod/pkp
	name = "pkp bipod"
	desc = "A simple set of telescopic poles to keep a weapon stabilized during firing."
	icon_state = "qjy72_bipod"
	attach_icon = "qjy72_bipod"

/obj/item/attachable/bipod/vulture
	name = "heavy bipod"
	desc = "A set of rugged telescopic poles to keep a weapon stabilized during firing."
	icon_state = "bipod_m60"
	attach_icon = "vulture_bipod"
	heavy_bipod = TRUE
	// Disable gamemode skin for item state, but we explicitly force attach_icon gamemode skins
	flags_atom = FPRINT|CONDUCT|NO_GAMEMODE_SKIN

/obj/item/attachable/bipod/vulture/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(type)

/obj/item/attachable/bipod/vulture/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..() // We are forcing attach_icon skin
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
			. = TRUE
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
			. = TRUE
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
			. = TRUE
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon
			. = TRUE
	return .

/obj/item/attachable/burstfire_assembly
	name = "burst fire assembly"
	desc = "A small angled piece of fine machinery that increases the burst count on some weapons, and grants the ability to others. \nIncreases weapon scatter."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "rapidfire"
	attach_icon = "rapidfire_a"
	slot = "under"

/obj/item/attachable/burstfire_assembly/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	burst_mod = BURST_AMOUNT_TIER_2

	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_4

/obj/item/attachable/eva_doodad
	name = "RXF-M5 EVA beam projector"
	desc = "A strange little doodad that projects an invisible beam that the EVA pistol's actual laser travels in, used as a focus that slightly weakens the laser's intensity. Or at least that's what the manual said."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "rxfm5_eva_doodad"
	attach_icon = "rxfm5_eva_doodad_a"
	slot = "under"

/obj/item/attachable/eva_doodad/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_5
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_5
	damage_mod -= BULLET_DAMAGE_MULT_TIER_4
