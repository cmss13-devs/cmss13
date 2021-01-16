
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
#define ATTACH_REMOVABLE	1
#define ATTACH_ACTIVATION	2
#define ATTACH_PROJECTILE	4
#define ATTACH_RELOADABLE	8
#define ATTACH_WEAPON		16
*/

/obj/item/attachable
	name = "attachable item"
	desc = "It's the very theoretical concept of an attachment. You should never see this."
	icon = 'icons/obj/items/weapons/guns/attachments.dmi'
	icon_state = null
	item_state = null
	var/attach_icon //the sprite to show when the attachment is attached when we want it different from the icon_state.
	var/pixel_shift_x = 16 //Determines the amount of pixels to move the icon state for the overlay.
	var/pixel_shift_y = 16 //Uses the bottom left corner of the item.

	flags_atom =  FPRINT|CONDUCT
	matter = list("metal" = 2000)
	w_class = SIZE_SMALL
	force = 1.0
	var/slot = null //"muzzle", "rail", "under", "stock", "special"

	/*
	Anything that isn't used as the gun fires should be a flat number, never a percentange. It screws with the calculations,
	and can mean that the order you attach something/detach something will matter in the final number. It's also completely
	inaccurate. Don't worry if force is ever negative, it won't runtime.
	*/
	//These bonuses are applied only as the gun fires a projectile.

	//These are flat bonuses applied and are passive, though they may be applied at different points.
	var/accuracy_mod 	= 0 //Modifier to firing accuracy, works off a multiplier.
	var/accuracy_unwielded_mod = 0 //same as above but for onehanded.
	var/damage_mod 		= 0 //Modifer to the damage mult, works off a multiplier.
	var/damage_falloff_mod = 0 //Modifier to damage falloff, works off a multiplier.
	var/damage_buildup_mod = 0 //Modifier to damage buildup, works off a multiplier.
	var/range_min_mod = 0 //Modifier to minimum effective range, tile value.
	var/range_max_mod = 0 //Modifier to maximum effective range, tile value.
	var/melee_mod 		= 0 //Changing to a flat number so this actually doesn't screw up the calculations.
	var/scatter_mod 	= 0 //Increases or decreases scatter chance.
	var/scatter_unwielded_mod = 0 //same as above but for onehanded firing.
	var/recoil_mod 		= 0 //If positive, adds recoil, if negative, lowers it. Recoil can't go below 0.
	var/recoil_unwielded_mod = 0 //same as above but for onehanded firing.
	var/burst_scatter_mod = 0 //Modifier to scatter from wielded burst fire, works off a multiplier.
	var/silence_mod 	= 0 //Adds silenced to weapon
	var/light_mod 		= 0 //Adds an x-brightness flashlight to the weapon, which can be toggled on and off.
	var/delay_mod 		= 0 //Changes firing delay. Cannot go below 0.
	var/burst_mod 		= 0 //Changes burst rate. 1 == 0.
	var/size_mod 		= 0 //Increases the weight class.
	var/aim_speed_mod	= 0 //Changes the aiming speed slowdown of the wearer by this value.
	var/wield_delay_mod	= 0 //How long ADS takes (time before firing)
	var/movement_acc_penalty_mod = 0 //Modifies accuracy/scatter penalty when firing onehanded while moving.

	var/activation_sound = 'sound/weapons/handling/gun_underbarrel_activate.ogg'
	var/deactivation_sound = 'sound/weapons/handling/gun_underbarrel_deactivate.ogg'

	var/flags_attach_features = ATTACH_REMOVABLE

	var/current_rounds 	= 0 //How much it has.
	var/max_rounds 		= 0 //How much ammo it can store

	var/attachment_action_type

	var/hidden = FALSE //Render on gun?

	/// An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	/// that will be given to a projectile with the current ammo datum
	var/list/list/traits_to_give

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

/obj/item/attachable/proc/Attach(var/obj/item/weapon/gun/G)
	if(!istype(G)) return //Guns only

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
		A.Detach(G)
		vending_stat_bump(A.type, G.type, -1) // reduce so there can't be a gain in stats if you attach/detach same thing many times. Also helps with underbarrel GL

	if(ishuman(loc))
		var/mob/living/carbon/human/M = src.loc
		M.drop_held_item(src)
	forceMove(G)

	G.attachments[slot] = src
	G.recalculate_attachment_bonuses()
	vending_stat_bump(type, G.type)

	if(G.burst_amount <= 1)
		G.flags_gun_features &= ~GUN_BURST_ON //Remove burst if they can no longer use it.
	G.update_force_list() //This updates the gun to use proper force verbs.

	if(silence_mod)
		G.flags_gun_features |= GUN_SILENCED
		G.muzzle_flash = null
		G.fire_sound = "gun_silenced"

	if(attachment_action_type)
		var/datum/action/A = new attachment_action_type(src, G)
		if(isliving(G.loc))
			var/mob/living/L = G.loc
			if(G == L.l_hand || G == L.r_hand)
				A.give_action(G.loc)

	// Sharp attachments (bayonet) make weapons sharp as well.
	if(sharp)
		G.sharp = sharp

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
		// Need to use the proc instead of the wrapper because each entry is a list
		G.in_chamber._AddElement(L)

/obj/item/attachable/proc/Detach(var/obj/item/weapon/gun/G)
	if(!istype(G)) return //Guns only

	if(flags_attach_features & ATTACH_ACTIVATION)
		activate_attachment(G, null, TRUE)

	G.attachments[slot] = null
	G.recalculate_attachment_bonuses()

	for(var/X in G.actions)
		var/datum/action/DA = X
		if(DA.target == src)
			qdel(X)
			break

	forceMove(get_turf(G))

	if(sharp)
		G.sharp = 0

	for(var/entry in traits_to_give)
		if(!G.in_chamber)
			break
		var/list/L
		if(istext(entry))
			L = traits_to_give[entry].Copy()
		else
			L = list(entry) + traits_to_give[entry]
		// Remove bullet traits of attachment from gun's current projectile
		G.in_chamber._RemoveElement(L)

/obj/item/attachable/ui_action_click(mob/living/user, obj/item/weapon/gun/G)
	if(G == user.get_active_hand())
		if(activate_attachment(G, user)) //success
			return
	else
		to_chat(user, SPAN_WARNING("[G] must be in our active hand to do this."))

/obj/item/attachable/proc/activate_attachment(atom/target, mob/user) //This is for activating stuff like flamethrowers, or switching weapon modes.
	return

/obj/item/attachable/proc/reload_attachment(obj/item/I, mob/user)
	return

/obj/item/attachable/proc/fire_attachment(atom/target,obj/item/weapon/gun/gun, mob/user) //For actually shooting those guns.
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN_ATTACHMENT, src) // Because of this, the . = ..() check should be called last, just before firing
	return TRUE


/////////// Muzzle Attachments /////////////////////////////////

/obj/item/attachable/suppressor
	name = "suppressor"
	desc = "A small tube with exhaust ports to expel noise and gas.\nDoes not completely silence a weapon, but does make it much quieter and a little more accurate and stable at the cost of slightly reduced damage."
	icon_state = "suppressor"
	slot = "muzzle"
	silence_mod = 1
	pixel_shift_y = 16
	attach_icon = "suppressor_a"

/obj/item/attachable/suppressor/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	damage_mod = -BULLET_DAMAGE_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	attach_icon = pick("suppressor_a","suppressor2_a")

	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10
	damage_falloff_mod = 0.4

/obj/item/attachable/bayonet
	name = "\improper M5 'Night Raider' bayonet"
	icon_state = "bayonet"
	item_state = "combat_knife"
	desc = "The standard-issue bayonet of the Colonial Marines. You can slide this knife into your boots, or attach it to the end of a rifle."
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_NORMAL
	throwforce = MELEE_FORCE_NORMAL
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	flags_equip_slot = SLOT_FACE
	flags_armor_protection = SLOT_FACE

	attach_icon = "bayonet_a"
	melee_mod = 20
	slot = "muzzle"
	pixel_shift_x = 14 //Below the muzzle.
	pixel_shift_y = 18

/obj/item/attachable/bayonet/New()
	..()
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/bayonet/attack(mob/living/target, mob/living/carbon/human/user)
	if(!dig_out_shrapnel_check(target,user))
		..()

/obj/item/attachable/bayonet/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	if(!hasorgans(user))
		return

	dig_out_shrapnel(user)

/obj/item/attachable/bayonet/upp
	name = "\improper Type 80 bayonet"
	icon_state = "upp_bayonet"
	item_state = "combat_knife"
	desc = "The standard-issue bayonet of the UPP, the Type 80 is balanced to also function as an effective throwing knife."
	throwforce = MELEE_FORCE_TIER_10 //doubled by throwspeed to 100
	throw_speed = SPEED_INSTANT
	throw_range = 7

/obj/item/attachable/extended_barrel
	name = "extended barrel"
	desc = "A lengthened barrel allows for greater accuracy, particularly at long range.\nHowever, natural resistance also slows the bullet, leading to slightly reduced damage."
	slot = "muzzle"
	icon_state = "ebarrel"
	attach_icon = "ebarrel_a"

/obj/item/attachable/extended_barrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	damage_mod = -BULLET_DAMAGE_MULT_TIER_1



/obj/item/attachable/heavy_barrel
	name = "barrel charger"
	desc = "A hyper threaded barrel extender that fits to the muzzle of most firearms. Increases bullet speed and velocity.\nGreatly increases projectile damage at the cost of accuracy and firing speed."
	slot = "muzzle"
	icon_state = "hbarrel"
	attach_icon = "hbarrel_a"

/obj/item/attachable/heavy_barrel/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	damage_mod = BULLET_DAMAGE_MULT_TIER_6
	delay_mod = FIRE_DELAY_TIER_9

	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_7

/obj/item/attachable/heavy_barrel/Attach(obj/item/weapon/gun/G)
	if(istype(G, /obj/item/weapon/gun/shotgun))
		damage_mod = BULLET_DAMAGE_MULT_TIER_1
	else if(istype(G, /obj/item/weapon/gun/rifle/m41a))
		damage_mod = BULLET_DAMAGE_MULT_TIER_3
	else
		damage_mod = BULLET_DAMAGE_MULT_TIER_6
	..()

/obj/item/attachable/compensator
	name = "recoil compensator"
	desc = "A muzzle attachment that reduces recoil by diverting expelled gasses upwards. \nIncreases accuracy and reduces recoil, at the cost of a small amount of weapon damage."
	slot = "muzzle"
	icon_state = "comp"
	attach_icon = "comp_a"
	pixel_shift_x = 17

/obj/item/attachable/compensator/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	damage_mod = -BULLET_DAMAGE_MULT_TIER_2
	recoil_mod = -RECOIL_AMOUNT_TIER_3

	damage_falloff_mod = 0.1
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_4


/obj/item/attachable/slavicbarrel
	name = "sniper barrel"
	icon_state = "slavicbarrel"
	desc = "A heavy barrel. CANNOT BE REMOVED."
	slot = "muzzle"

	pixel_shift_x = 20
	pixel_shift_y = 16
	flags_attach_features = NO_FLAGS

/obj/item/attachable/slavicbarrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/sniperbarrel
	name = "sniper barrel"
	icon_state = "sniperbarrel"
	desc = "A heavy barrel. CANNOT BE REMOVED."
	slot = "muzzle"
	flags_attach_features = NO_FLAGS

/obj/item/attachable/sniperbarrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/m60barrel
	name = "M60 barrel"
	icon_state = "m60barrel"
	desc = "A heavy barrel. CANNOT BE REMOVED."
	slot = "muzzle"
	flags_attach_features = NO_FLAGS

/obj/item/attachable/m60barrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/smartbarrel
	name = "smartgun barrel"
	icon_state = "m56_barrel"
	desc = "The very end of the M56 smart gun, featuring a compensator. CANNOT BE REMOVED."
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	pixel_shift_x = 14

// Mateba barrels

/obj/item/attachable/mateba
	name = "standard mateba barrel"
	icon_state = "mateba_medium"
	desc = "A standard mateba barrel. Offers a balance between accuracy and firerate."
	slot = "special"
	flags_attach_features = NO_FLAGS

/obj/item/attachable/mateba/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3

/obj/item/attachable/mateba/Attach(obj/item/weapon/gun/G)
	..()
	G.attachable_offset["muzzle_x"] = 27

/obj/item/attachable/mateba/Detach(obj/item/weapon/gun/G)
	..()
	G.attachable_offset["muzzle_x"] = 20

/obj/item/attachable/mateba/dark
	icon_state = "mateba_medium_a"

/obj/item/attachable/mateba/long
	name = "marksman mateba barrel"
	icon_state = "mateba_long"
	desc = "A marksman mateba barrel. Offers a greater accuracy at the cost of firerate."
	flags_attach_features = NO_FLAGS

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
	desc = "A snubnosed mateba barrel. Offers a fast firerate at the cost of accuracy."

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

///////////// Rail attachments ////////////////////////

/obj/item/attachable/reddot
	name = "S5 red-dot sight"
	desc = "An ARMAT S5 red-dot sight. A zero magnification optic that offers faster, and more accurate target aquisition."
	icon_state = "reddot"
	attach_icon = "reddot_a"
	slot = "rail"

/obj/item/attachable/reddot/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	movement_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5

/obj/item/attachable/reflex
	name = "S6 reflex sight"
	desc = "An ARMAT S6 reflex sight. A zero magnification alternative to iron sights with a more open optic window when compared to the S5 red-dot. Helps to reduce scatter during automated fire."
	icon_state = "reflex"
	attach_icon = "reflex_a"
	slot = "rail"

/obj/item/attachable/reflex/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	burst_scatter_mod = -1
	movement_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5


/obj/item/attachable/flashlight
	name = "rail flashlight"
	desc = "A flashlight, for rails, on guns. Can be toggled on and off. A better light source than standard M3 pattern armor lights."
	icon_state = "flashlight"
	attach_icon = "flashlight_a"
	light_mod = 7
	slot = "rail"
	matter = list("metal" = 50,"glass" = 20)
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	activation_sound = 'sound/handling/light_on_1.ogg'
	deactivation_sound = 'sound/handling/click_2.ogg'
	var/original_state = "flashlight"
	var/original_attach = "flashlight_a"

/obj/item/attachable/flashlight/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	if(turn_off && !(G.flags_gun_features & GUN_FLASHLIGHT_ON))
		return FALSE
	var/flashlight_on = (G.flags_gun_features & GUN_FLASHLIGHT_ON) ? -1 : 1
	var/atom/movable/light_source =  ismob(G.loc) ? G.loc : G
	light_source.SetLuminosity(light_mod * flashlight_on)
	G.flags_gun_features ^= GUN_FLASHLIGHT_ON

	if(G.flags_gun_features & GUN_FLASHLIGHT_ON)
		icon_state += "-on"
		attach_icon += "-on"
		playsound(user, deactivation_sound, 15, 1)
	else
		icon_state = original_state
		attach_icon = original_attach
		playsound(user, activation_sound, 15, 1)
	G.update_attachable(slot)

	for(var/X in G.actions)
		var/datum/action/A = X
		A.update_button_icon()
	return TRUE




/obj/item/attachable/flashlight/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/tool/screwdriver))
		to_chat(user, SPAN_NOTICE("You strip the the rail flashlight of its mount, converting it to a normal flashlight."))
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
	if(istype(I,/obj/item/tool/screwdriver))
		to_chat(user, SPAN_NOTICE("Hold on there cowboy, that grip is bolted on. You are unable to modify it."))
	return

/obj/item/attachable/quickfire
	name = "quickfire adapter"
	desc = "An enhanced and upgraded autoloading mechanism to fire rounds more quickly. \nHowever, it also reduces accuracy and the number of bullets fired on burst."
	slot = "rail"
	icon_state = "autoloader"
	attach_icon = "autoloader_a"

/obj/item/attachable/quickfire/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_5
	scatter_mod = SCATTER_AMOUNT_TIER_9
	delay_mod = -FIRE_DELAY_TIER_9
	burst_mod = -BURST_AMOUNT_TIER_1
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_6


/obj/item/attachable/magnetic_harness
	name = "magnetic harness"
	desc = "A magnetically attached harness kit that attaches to the rail mount of a weapon. When dropped, the weapon will sling to any set of USCM armor."
	icon_state = "magnetic"
	attach_icon = "magnetic_a"
	slot = "rail"
	pixel_shift_x = 13

/obj/item/attachable/magnetic_harness/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_1
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/magnetic_harness/Attach(var/obj/item/weapon/gun/G)
	. = ..()
	G.AddElement(/datum/element/magharness)

/obj/item/attachable/magnetic_harness/Detach(var/obj/item/weapon/gun/G)
	. = ..()
	G.RemoveElement(/datum/element/magharness)

/obj/item/attachable/scope
	name = "S8 4x telescopic scope"
	icon_state = "sniperscope"
	attach_icon = "sniperscope_a"
	desc = "An ARMAT S8 telescopic eye piece. Fixed at 4x zoom. Press the 'use rail attachment' HUD icon or use the verb of the same name to zoom."
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

/obj/item/attachable/scope/New()
	..()
	delay_mod = FIRE_DELAY_TIER_10
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_1
	movement_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	accuracy_unwielded_mod = 0

	accuracy_scoped_buff = HIT_ACCURACY_MULT_TIER_7 + HIT_ACCURACY_MULT_TIER_1 //to compensate initial debuff
	delay_scoped_nerf = FIRE_DELAY_TIER_8 - FIRE_DELAY_TIER_10 //to compensate initial debuff. We want "high_fire_delay"
	damage_falloff_scoped_buff = -0.4 //has to be negative

/obj/item/attachable/scope/proc/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	if(G.zoom)
		G.accuracy_mult += accuracy_scoped_buff
		G.fire_delay += delay_scoped_nerf
		G.damage_falloff_mult += damage_falloff_scoped_buff
		RegisterSignal(user, COMSIG_LIVING_ZOOM_OUT, .proc/remove_scoped_buff)

/obj/item/attachable/scope/proc/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	SIGNAL_HANDLER
	UnregisterSignal(user, COMSIG_LIVING_ZOOM_OUT)
	G.accuracy_mult -= accuracy_scoped_buff
	G.fire_delay -= delay_scoped_nerf
	G.damage_falloff_mult -= damage_falloff_scoped_buff

/obj/item/attachable/scope/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(turn_off)
		if(G.zoom)
			G.zoom(user, zoom_offset, zoom_viewsize, allows_movement)
		return 1

	if(!G.zoom && !(G.flags_item & WIELDED))
		if(user)
			to_chat(user, SPAN_WARNING("You must hold [G] with two hands to use [src]."))
		return 0
	else
		G.zoom(user, zoom_offset, zoom_viewsize, allows_movement)
		apply_scoped_buff(G,user)
	return 1

/obj/item/attachable/scope/mini
	name = "S4 2x telescopic mini-scope"
	icon_state = "miniscope"
	attach_icon = "miniscope_a"
	desc = "An ARMAT S4 telescoping eye piece. Fixed at a modest 2x zoom. Press the 'use rail attachment' HUD icon or use the verb of the same name to zoom."
	slot = "rail"
	zoom_offset = 6
	zoom_viewsize = 7
	var/dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC

/obj/item/attachable/scope/mini/New()
	..()
	damage_falloff_scoped_buff = -0.2 //has to be negative

/obj/item/attachable/scope/mini/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(istype(G, /obj/item/weapon/gun/launcher/rocket) || istype(G, /obj/item/weapon/gun/launcher/m92))
		zoom_offset = 3
		allows_movement	= 0
		if(do_after(user, 25, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			. = ..()
	else
		zoom_offset = initial(zoom_offset)
		allows_movement	= 1
		. = ..()

/obj/item/attachable/scope/mini/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	. = ..()
	if(G.zoom)
		G.slowdown += dynamic_aim_slowdown
		if(istype(G, /obj/item/weapon/gun/launcher/m92))
			G.fire_delay += FIRE_DELAY_TIER_4

/obj/item/attachable/scope/mini/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	G.slowdown -= dynamic_aim_slowdown
	if(istype(G, /obj/item/weapon/gun/launcher/m92))
		G.fire_delay -= FIRE_DELAY_TIER_4
	..()

/obj/item/attachable/scope/mini/hunting //can only be attached to the hunting rifle to prevent vending hunting rifles to cannibalize scopes
	name = "2x hunting mini-scope"
	icon_state = "huntingscope"
	attach_icon = "huntingscope"
	desc = "While the Basira-Armstrong rifle is compatible with most telescopic devices, its accompanying scope is usable only with the Basira-Armstrong. Fixed at a modest 2x zoom. Press the 'use rail attachment' HUD icon or use the verb of the same name to zoom."


/obj/item/attachable/scope/mini_iff
	name = "B8 Smart-Scope"
	icon_state = "iffbarrel"
	attach_icon = "iffbarrel_a"
	desc = "An experimental B8 Smart-Scope. Based on the technologies used in the Smart Gun by ARMAT, this sight has integrated IFF systems. It can only attach to the L42A Battle Rifle, M44 Combat Revolver, and M46C Pulse Rifle."
	slot = "rail"
	zoom_offset = 6
	zoom_viewsize = 7
	pixel_shift_y = 15
	var/dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC

/obj/item/attachable/scope/mini_iff/New()
	..()
	damage_mod = -BULLET_DAMAGE_MULT_TIER_4
	movement_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_6
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
		allows_movement	= 1
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



//////////// Stock attachments ////////////////////////////


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

/obj/item/attachable/stock/shotgun
	name = "\improper M37 wooden stock"
	desc = "A non-standard heavy wooden stock for the M37 Shotgun. More cumbersome than the standard issue stakeout, but reduces recoil and improves accuracy. Allegedly makes a pretty good club in a fight too.."
	slot = "stock"
	icon_state = "stock"
	wield_delay_mod = WIELD_DELAY_FAST
	pixel_shift_x = 32
	pixel_shift_y = 15

/obj/item/attachable/stock/shotgun/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8
	//but at the same time you are slow when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_med)


	matter = list("wood" = 2000)

	select_gamemode_skin(type)

/obj/item/attachable/stock/mou53
	name = "\improper MOU53 tactical stock"
	desc = "A metal stock fitted specifically for the MOU53 break action shotgun."
	icon_state = "ou_stock"

/obj/item/attachable/stock/mou53/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/tactical
	name = "\improper MK221 tactical stock"
	desc = "A metal stock made for the MK221 tactical shotgun."
	icon_state = "tactical_stock"

/obj/item/attachable/stock/tactical/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
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

/obj/item/attachable/stock/slavic/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	delay_mod = FIRE_DELAY_TIER_7
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
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

/obj/item/attachable/stock/hunting/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8

/obj/item/attachable/stock/rifle
	name = "\improper M41A solid stock"
	desc = "A rare stock distributed in small numbers to USCM forces. Compatible with the M41A, this stock reduces recoil and improves accuracy, but at a reduction to handling and agility. Also enhances the thwacking of things with the stock-end of the rifle."
	slot = "stock"
	melee_mod = 5
	size_mod = 1
	icon_state = "riflestock"
	attach_icon = "riflestock_a"
	pixel_shift_x = 40
	pixel_shift_y = 10
	wield_delay_mod = WIELD_DELAY_FAST

/obj/item/attachable/stock/rifle/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8
	//but at the same time you are slow when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_med)

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

/obj/item/attachable/stock/carbine/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_6
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8


/obj/item/attachable/stock/rifle/marksman
	name = "\improper M41A marksman stock"
	icon_state = "m4markstock"
	attach_icon = "m4markstock"
	flags_attach_features = NO_FLAGS


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

/obj/item/attachable/stock/smg/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_7
	recoil_mod = -RECOIL_AMOUNT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_6
	delay_mod = 0
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	aim_speed_mod = CONFIG_GET(number/slowdown_low)


/obj/item/attachable/stock/smg/collapsible
	name = "submachinegun folding stock"
	desc = "A Kirchner brand K2 M39 folding stock, standard issue in the USCM. The stock, when extended, reduces recoil and improves accuracy, but at a reduction to handling and agility. Seemingly a bit more effective in a brawl. This stock can collapse in, removing almost all positive and negative effects, however it slightly increases spread due to weapon being off-balanced by the collapsed stock."
	slot = "stock"
	melee_mod = 10
	size_mod = 1
	icon_state = "smgstockc"
	attach_icon = "smgstockc_a"
	pixel_shift_x = 43
	pixel_shift_y = 11
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/activated = TRUE
	var/collapse_delay = 0
	var/list/deploy_message = list("collapse","extend")


/obj/item/attachable/stock/smg/collapsible/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	wield_delay_mod = WIELD_DELAY_FAST
	delay_mod = 0
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10
	//but at the same time you are slowish when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_low)


/obj/item/attachable/stock/smg/collapsible/proc/apply_on_weapon(obj/item/weapon/gun/G)
	if(activated)
		scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10
		size_mod = 1
		aim_speed_mod = CONFIG_GET(number/slowdown_low)
		wield_delay_mod = WIELD_DELAY_FAST
		movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
		accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
		recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
		icon_state = "smgstockc"
		attach_icon = "smgstockc_a"

	else

		scatter_unwielded_mod = 0
		size_mod = 0
		aim_speed_mod = 0
		wield_delay_mod = 0
		movement_acc_penalty_mod = 0
		accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1
		recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
		icon_state = "smgstockcc"
		attach_icon = "smgstockcc_a"

	//don't *= -1 on debuffs, you'd actually be making than without stock when it's collapsed.
	accuracy_mod *= -1
	recoil_mod *= -1
	scatter_mod *= -1

	G.recalculate_attachment_bonuses()
	G.update_overlays(src, "stock")

/obj/item/attachable/stock/smg/collapsible/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(turn_off && activated)
		activated = FALSE
		apply_on_weapon(G)
		return 1

	if(!user)
		return 1

	if(G.flags_item & WIELDED)
		to_chat(user, SPAN_NOTICE("You need a free hand to adjust [src]."))
		return 0

	if(!do_after(user, collapse_delay, INTERRUPT_INCAPACITATED|INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC, G, INTERRUPT_DIFF_LOC))
		return 0

	activated = !activated
	apply_on_weapon(G)
	playsound(user, activation_sound, 15, 1)
	var/message = deploy_message[1 + activated]
	to_chat(user, SPAN_NOTICE("You [message] [src]."))

/obj/item/attachable/stock/smg/collapsible/brace
	name = "\improper submachinegun arm brace"
	desc = "A specialized stock for use on an M39 submachine gun. It makes one handing more accurate at the expense of fire rate. Wielding the weapon with this stock attached confers a major inaccuracy and recoil debuff."
	size_mod = 1
	icon_state = "smg_brace"
	attach_icon = "smg_brace_a"
	pixel_shift_x = 43
	pixel_shift_y = 11
	collapse_delay = 15
	activated = FALSE
	deploy_message = list("unlock","lock")

/obj/item/attachable/stock/smg/collapsible/brace/New()
	..()
	//Makes stuff better when one handed by a LOT.
	burst_scatter_mod = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_3
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4

	delay_mod = FIRE_DELAY_TIER_9
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	scatter_mod = SCATTER_AMOUNT_TIER_8
	recoil_mod = RECOIL_AMOUNT_TIER_2
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NORMAL//you shouldn't be wielding it anyways

/obj/item/attachable/stock/smg/collapsible/brace/apply_on_weapon(obj/item/weapon/gun/G)
	if(activated)
		G.flags_item |= NODROP
		icon_state = "smg_brace_on"
		attach_icon = "smg_brace_a_on"
	else
		G.flags_item &= ~NODROP
		icon_state = "smg_brace"
		attach_icon = "smg_brace_a"

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
		G.recalculate_attachment_bonuses()
	else
		to_chat(user, SPAN_NOTICE("You fold [src]."))
		R.flags_equip_slot |= SLOT_WAIST	// Allow to be worn on the belt when folded
		R.folded = TRUE		// We can't shoot anymore, its folded
		icon_state = "44stock_folded"
		size_mod = 0
		G.recalculate_attachment_bonuses()
	folded = !folded
	G.update_overlays(src, "stock")

// If it is activated/folded when we attach it, re-apply the things
/obj/item/attachable/stock/revolver/Attach(var/obj/item/weapon/gun/G)
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
/obj/item/attachable/stock/revolver/Detach(var/obj/item/weapon/gun/G)
	..()
	var/obj/item/weapon/gun/revolver/m44/R = G
	if(!istype(R))
		return 0

	if(folded)
		R.folded = FALSE
	else
		R.flags_equip_slot |= SLOT_WAIST


////////////// Underbarrel Attachments ////////////////////////////////////


/obj/item/attachable/attached_gun
	attachment_action_type = /datum/action/item_action/toggle
	//Some attachments may be fired. So here are the variables related to that.
	var/datum/ammo/ammo = null //If it has a default bullet-like ammo.
	var/max_range 		= 0 //Determines # of tiles distance the attachable can fire, if it's not a projectile.
	var/attachment_firing_delay = 0 //the delay between shots, for attachments that fires stuff
	var/fire_sound = null //Sound to play when firing it alternately
	var/gun_original_damage_mult = 1 //so you don't buff the underbarrell gun with charger for the wrong weapon
	var/gun_deactivate_sound = 'sound/weapons/handling/gun_underbarrel_deactivate.ogg'//allows us to give the attached gun unique activate and de-activate sounds. Not used yet.
	var/gun_activate_sound  = 'sound/weapons/handling/gun_underbarrel_activate.ogg'

/obj/item/attachable/attached_gun/New() //Let's make sure if something needs an ammo type, it spawns with one.
	..()
	if(ammo)
		ammo = GLOB.ammo_list[ammo]


/obj/item/attachable/attached_gun/Destroy()
	ammo = null
	. = ..()



/obj/item/attachable/attached_gun/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	if(G.active_attachable == src)
		if(user)
			to_chat(user, SPAN_NOTICE("You are no longer using [src]."))
			playsound(user, gun_deactivate_sound, 30, 1)
		G.active_attachable = null
		var/diff = G.damage_mult - 1 //so that if we buffed gun in process, it still does stuff
		//yeah you can cheat by placing BC after switching to underbarrell, but that is one time and we can skip it for sake of optimization
		G.damage_mult = gun_original_damage_mult + diff
		icon_state = initial(icon_state)
	else if(!turn_off)
		if(user)
			to_chat(user, SPAN_NOTICE("You are now using [src]."))
			playsound(user, gun_activate_sound, 45, 1)
		G.active_attachable = src
		gun_original_damage_mult = G.damage_mult
		G.damage_mult = 1
		icon_state += "-on"

	for(var/X in G.actions)
		var/datum/action/A = X
		A.update_button_icon()
	return 1



//The requirement for an attachable being alt fire is AMMO CAPACITY > 0.
/obj/item/attachable/attached_gun/grenade
	name = "underslung grenade launcher"
	desc = "A weapon-mounted, reloadable grenade launcher."
	icon_state = "grenade"
	attach_icon = "grenade_a"
	w_class = SIZE_MEDIUM
	current_rounds = 0
	max_rounds = 1
	max_range = 7
	slot = "under"
	fire_sound = 'sound/weapons/gun_m92_attachable.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	var/grenade_pass_flags
	var/list/loaded_grenades //list of grenade types loaded in the UGL

/obj/item/attachable/attached_gun/grenade/Initialize()
	. = ..()
	grenade_pass_flags = PASS_HIGH_OVER|PASS_MOB_THRU

/obj/item/attachable/attached_gun/grenade/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_4 * 3
	loaded_grenades = list()

/obj/item/attachable/attached_gun/grenade/examine(mob/user)
	..()
	if(current_rounds) 	to_chat(user, "It has [current_rounds] grenade\s left.")
	else 				to_chat(user, "It's empty.")





/obj/item/attachable/attached_gun/grenade/reload_attachment(obj/item/explosive/grenade/G, mob/user)
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
			playsound(user, 'sound/weapons/gun_shotgun_shell_insert.ogg', 25, 1)
			current_rounds++
			loaded_grenades += G
			to_chat(user, SPAN_NOTICE("You load [G] in [src]."))
			user.drop_inv_item_to_loc(G, src)

/obj/item/attachable/attached_gun/grenade/fire_attachment(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	if(!(gun.flags_item & WIELDED))
		if(user)
			to_chat(user, SPAN_WARNING("You must hold [gun] with two hands to use [src]."))
		return
	if(get_dist(user,target) > max_range)
		to_chat(user, SPAN_WARNING("Too far to fire the attachment!"))
		return

	if(current_rounds > 0 && ..())
		prime_grenade(target,gun,user)

/obj/item/attachable/attached_gun/grenade/proc/prime_grenade(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	set waitfor = 0
	var/obj/item/explosive/grenade/G = loaded_grenades[1]

	if(grenade_grief_check(G))
		to_chat(user, SPAN_WARNING("\The [name]'s IFF inhibitor prevents you from firing!"))
		msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)")
		return

	playsound(user.loc, fire_sound, 50, 1)
	msg_admin_attack("[key_name_admin(user)] fired an underslung grenade launcher (<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[user]'>JMP</A>)")
	log_game("[key_name_admin(user)] used an underslung grenade launcher.")

	var/pass_flags = NO_FLAGS
	pass_flags |= grenade_pass_flags
	G.det_time = min(15, G.det_time)
	G.throw_range = max_range
	G.activate(user, FALSE)
	G.forceMove(get_turf(gun))
	G.throw_atom(target, max_range, SPEED_VERY_FAST, user, null, NORMAL_LAUNCH, pass_flags)
	current_rounds--
	loaded_grenades.Cut(1,2)

//For the Mk1
/obj/item/attachable/attached_gun/grenade/mk1
	name = "MK1 underslung grenade launcher"
	desc = "An older version of the classic underslung grenade launcher. Does not have IFF capabilities but can store three grenades."
	icon_state = "grenade-mk1"
	attach_icon = "grenade-mk1_a"
	current_rounds = 0
	max_rounds = 3
	max_range = 10

/obj/item/attachable/attached_gun/grenade/mk1/Initialize()
	. = ..()
	grenade_pass_flags = PASS_HIGH_OVER

//"ammo/flamethrower" is a bullet, but the actual process is handled through fire_attachment, linked through Fire().
/obj/item/attachable/attached_gun/flamer
	name = "mini flamethrower"
	icon_state = "flamethrower"
	attach_icon = "flamethrower_a"
	desc = "A weapon-mounted refillable flamethrower attachment.\nIt is designed for short bursts."
	w_class = SIZE_MEDIUM
	current_rounds = 20
	max_rounds = 20
	max_range = 4
	slot = "under"
	fire_sound = 'sound/weapons/gun_flamethrower3.ogg'
	activation_sound = 'sound/weapons/handling/gun_underbarrel_flamer_activate.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON

/obj/item/attachable/attached_gun/flamer/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_4 * 5

/obj/item/attachable/attached_gun/flamer/examine(mob/user)
	..()
	if(current_rounds > 0) to_chat(user, "It has [current_rounds] unit\s of fuel left.")
	else to_chat(user, "It's empty.")

/obj/item/attachable/attached_gun/flamer/reload_attachment(obj/item/ammo_magazine/flamer_tank/FT, mob/user)
	if(istype(FT))
		if(current_rounds >= max_rounds)
			to_chat(user, SPAN_WARNING("[src] is full."))
		else if(FT.current_rounds <= 0)
			to_chat(user, SPAN_WARNING("[FT] is empty!"))
		else
			playsound(user, 'sound/effects/refill.ogg', 25, 1, 3)
			to_chat(user, SPAN_NOTICE("You refill [src] with [FT]."))
			var/transfered_rounds = min(max_rounds - current_rounds, FT.current_rounds)
			current_rounds += transfered_rounds
			FT.current_rounds -= transfered_rounds
	else
		to_chat(user, SPAN_WARNING("[src] can only be refilled with an incinerator tank."))

/obj/item/attachable/attached_gun/flamer/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	if(get_dist(user,target) > max_range+4)
		to_chat(user, SPAN_WARNING("Too far to fire the attachment!"))
		return
	if(current_rounds && ..())
		unleash_flame(target, user)


/obj/item/attachable/attached_gun/flamer/proc/unleash_flame(atom/target, mob/living/user)
	set waitfor = 0
	var/list/turf/turfs = getline2(user,target)
	var/distance = 0
	var/turf/prev_T
	var/stop_at_turf = FALSE
	playsound(user, 'sound/weapons/gun_flamethrower2.ogg', 50, 1)
	for(var/turf/T in turfs)
		if(T == user.loc)
			prev_T = T
			continue
		if(!current_rounds)
			break
		if(distance >= max_range)
			break

		current_rounds--
		if(T.density)
			T.flamer_fire_act()
			stop_at_turf = TRUE
		else if(prev_T)
			var/atom/movable/temp = new/obj/flamer_fire()
			var/atom/movable/AM = LinkBlocked(temp, prev_T, T)
			qdel(temp)
			if(AM)
				AM.flamer_fire_act()
				if (AM.flags_atom & ON_BORDER)
					break
				stop_at_turf = TRUE
		flame_turf(T)
		if (stop_at_turf)
			break
		distance++
		prev_T = T
		sleep(1)


/obj/item/attachable/attached_gun/flamer/proc/flame_turf(turf/T, mob/living/user)
	if(!istype(T)) return

	if(!locate(/obj/flamer_fire) in T) // No stacking flames!
		var/datum/reagent/napalm/ut/R = new()

		R.intensityfire = BURN_LEVEL_TIER_1
		R.durationfire = BURN_TIME_TIER_1

		new/obj/flamer_fire(T, initial(name), user, R)


/obj/item/attachable/attached_gun/shotgun
	name = "\improper U7 underbarrel shotgun"
	icon_state = "masterkey"
	attach_icon = "masterkey_a"
	desc = "An ARMAT U7 tactical shotgun. Attaches to the underbarrel of most weapons. Only capable of loading up to three buckshot shells."
	w_class = SIZE_MEDIUM
	max_rounds = 3
	current_rounds = 3
	ammo = /datum/ammo/bullet/shotgun/buckshot/masterkey
	slot = "under"
	fire_sound = 'sound/weapons/gun_shotgun_u7.ogg'
	activation_sound = 'sound/weapons/handling/gun_u7_activate.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_PROJECTILE|ATTACH_RELOADABLE|ATTACH_WEAPON

/obj/item/attachable/attached_gun/shotgun/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_5*3

/obj/item/attachable/attached_gun/shotgun/examine(mob/user)
	..()
	if(current_rounds > 0) 	to_chat(user, "It has [current_rounds] shell\s left.")
	else 					to_chat(user, "It's empty.")

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

/obj/item/attachable/attached_gun/extinguisher/examine(mob/user)
	..()
	if(internal_extinguisher)
		to_chat(user, "It contains [internal_extinguisher.reagents.total_volume] units of water left!")
		return
	to_chat(user, "It's empty.")

/obj/item/attachable/attached_gun/extinguisher/New()
	..()
	initialize_internal_extinguisher()

/obj/item/attachable/attached_gun/extinguisher/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	if(!internal_extinguisher)
		return
	if(..())
		return internal_extinguisher.afterattack(target, user)

/obj/item/attachable/attached_gun/extinguisher/proc/initialize_internal_extinguisher()
	internal_extinguisher = new /obj/item/tool/extinguisher/mini()
	internal_extinguisher.safety = FALSE
	internal_extinguisher.create_reagents(internal_extinguisher.max_water)
	internal_extinguisher.reagents.add_reagent("water", internal_extinguisher.max_water)

/obj/item/attachable/attached_gun/extinguisher/pyro
	name = "HME-88B underbarrel extinguisher"
	desc = "An experimental Taiho-Technologies HME-88B underbarrel extinguisher integrated with a select few gun models. It is capable of putting out the strongest of flames. Point at flame before applying pressure."
	flags_attach_features = ATTACH_ACTIVATION|ATTACH_WEAPON|ATTACH_MELEE

/obj/item/attachable/attached_gun/extinguisher/pyro/initialize_internal_extinguisher()
	internal_extinguisher = new /obj/item/tool/extinguisher/pyro()
	internal_extinguisher.safety = FALSE
	internal_extinguisher.create_reagents(internal_extinguisher.max_water)
	internal_extinguisher.reagents.add_reagent("water", internal_extinguisher.max_water)

/obj/item/attachable/verticalgrip
	name = "vertical grip"
	desc = "A vertical foregrip that offers better accuracy, less recoil, and less scatter, especially during burst fire. \nHowever, it also increases weapon size."
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
	movement_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10


/obj/item/attachable/angledgrip
	name = "angled grip"
	desc = "An angled foregrip that improves weapon ergonomics and offers less recoil, and faster wielding time. \nHowever, it also increases weapon size."
	icon_state = "angledgrip"
	attach_icon = "angledgrip_a"
	wield_delay_mod = -WIELD_DELAY_FAST
	size_mod = 1
	slot = "under"
	pixel_shift_x = 20

/obj/item/attachable/angledgrip/New()
	..()
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10



/obj/item/attachable/gyro
	name = "gyroscopic stabilizer"
	desc = "A set of weights and balances to stabilize the weapon when fired with one hand. Slightly decreases firing speed."
	icon_state = "gyro"
	attach_icon = "gyro_a"
	slot = "under"

/obj/item/attachable/gyro/New()
	..()
	delay_mod = FIRE_DELAY_TIER_9
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	burst_scatter_mod = -2
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_3
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
	icon_state = "lasersight"
	attach_icon = "lasersight_a"
	slot = "under"
	pixel_shift_x = 17
	pixel_shift_y = 17

/obj/item/attachable/lasersight/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	movement_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_9
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1


/datum/event_handler/bipod_movement
	var/obj/item/attachable/bipod/attachment
	var/obj/item/weapon/gun/G
	handle(mob/living/sender, datum/event_args/mob_movement/ev_args)
		if(attachment.bipod_deployed)
			attachment.activate_attachment(G, sender)

/obj/item/attachable/bipod
	name = "bipod"
	desc = "A simple set of telescopic poles to keep a weapon stabilized during firing. \nGreatly increases accuracy and reduces recoil when properly placed, but also increases weapon size and slows firing speed."
	icon_state = "bipod"
	attach_icon = "bipod_a"
	slot = "under"
	size_mod = 2
	melee_mod = -10
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/datum/event_handler/bipod_movement/bipod_movement
	var/bipod_deployed = FALSE

/obj/item/attachable/bipod/New()
	..()

	delay_mod = FIRE_DELAY_TIER_9
	wield_delay_mod = WIELD_DELAY_FAST
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_5
	scatter_mod = SCATTER_AMOUNT_TIER_9
	recoil_mod = RECOIL_AMOUNT_TIER_5

/obj/item/attachable/bipod/Detach(obj/item/weapon/gun/G)
	if(bipod_deployed)
		undeploy_bipod(G)
	..()

/obj/item/attachable/bipod/proc/undeploy_bipod(obj/item/weapon/gun/G)
	bipod_deployed = FALSE
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_5
	scatter_mod = SCATTER_AMOUNT_TIER_9
	recoil_mod = RECOIL_AMOUNT_TIER_5
	burst_scatter_mod = 0
	delay_mod = FIRE_DELAY_TIER_10
	G.recalculate_attachment_bonuses()

/obj/item/attachable/bipod/activate_attachment(obj/item/weapon/gun/G,mob/living/user, turn_off)
	if(turn_off)
		if(bipod_deployed)
			undeploy_bipod(G)
			if(bipod_movement)
				user.remove_movement_handler(bipod_movement)
				bipod_movement = null
	else
		var/obj/support = check_bipod_support(G, user)
		if(!support&&!bipod_deployed)
			to_chat(user, SPAN_NOTICE("You start deploying [src] on the ground."))
			if(!do_after(user, 15, INTERRUPT_ALL, BUSY_ICON_HOSTILE, G,INTERRUPT_DIFF_LOC))
				return FALSE

		bipod_deployed = !bipod_deployed
		if(user)
			if(bipod_deployed)
				to_chat(user, SPAN_NOTICE("You deploy [src][support ? " on [support]" : "on the ground"]."))
				playsound(user,'sound/items/m56dauto_rotate.ogg', 55, 1)
				accuracy_mod = HIT_ACCURACY_MULT_TIER_5
				scatter_mod = -SCATTER_AMOUNT_TIER_10
				recoil_mod = -RECOIL_AMOUNT_TIER_4
				burst_scatter_mod = -SCATTER_AMOUNT_TIER_8
				if(istype(G,/obj/item/weapon/gun/rifle/sniper/M42A))
					delay_mod = -FIRE_DELAY_TIER_7
				else
					delay_mod = -FIRE_DELAY_TIER_10
				G.recalculate_attachment_bonuses()

				if(!bipod_movement)
					bipod_movement = new /datum/event_handler/bipod_movement()
					bipod_movement.attachment = src
					bipod_movement.G = G
					user.add_movement_handler(bipod_movement)

			else
				to_chat(user, SPAN_NOTICE("You retract [src]."))
				undeploy_bipod(G,user)
				user.apply_effect(1, SUPERSLOW)
				user.apply_effect(2, SLOW)
				playsound(user,'sound/items/m56dauto_rotate.ogg', 55, 1)
				if(bipod_movement)
					user.remove_movement_handler(bipod_movement)
					bipod_movement = null

	if(bipod_deployed)
		icon_state = "[icon_state]-on"
		attach_icon = "[attach_icon]-on"
	else
		icon_state = initial(icon_state)
		attach_icon = initial(attach_icon)

	G.update_attachable(slot)

	for(var/X in G.actions)
		var/datum/action/A = X
		A.update_button_icon()
	return 1



//when user fires the gun, we check if they have something to support the gun's bipod.
/obj/item/attachable/proc/check_bipod_support(obj/item/weapon/gun/G, mob/living/user)
	return 0

/obj/item/attachable/bipod/check_bipod_support(obj/item/weapon/gun/G, mob/living/user)
	var/turf/T = get_turf(user)
	for(var/obj/O in T)
		if(O.throwpass && O.density && O.dir == user.dir && O.flags_atom & ON_BORDER)
			return O
	var/turf/T2 = get_step(T, user.dir)

	for(var/obj/O2 in T2)
		if(O2.throwpass && O2.density)
			return O2
	return 0


/obj/item/attachable/bipod/m60
	name = "bipod"
	desc = "A simple set of telescopic poles to keep a weapon stabilized during firing. This one looks rather old.\nGreatly increases accuracy and reduces recoil when properly placed, but also increases weapon size and slows firing speed."
	icon_state = "bipod_m60"
	attach_icon = "bipod_m60_a"

	flags_attach_features = ATTACH_ACTIVATION


/obj/item/attachable/burstfire_assembly
	name = "burst fire assembly"
	desc = "A small angled piece of fine machinery that increases the burst count on some weapons, and grants the ability to others. \nIncreases weapon scatter."
	icon_state = "rapidfire"
	attach_icon = "rapidfire_a"
	slot = "under"

/obj/item/attachable/burstfire_assembly/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	burst_mod = BURST_AMOUNT_TIER_2

	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_4
