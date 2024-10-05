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

/obj/item/attachable/suppressor/Initialize(mapload, ...)
	. = ..()
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
	icon_state = "upp_bayonet" // PLACEHOLDER PLEASE REPLACE
	item_state = "combat_knife"
	attach_icon = "upp_bayonet_a" // PLACEHOLDER PLEASE REPLACE
	throwforce = MELEE_FORCE_TIER_10 //doubled by throwspeed to 100
	throw_speed = SPEED_REALLY_FAST
	throw_range = 7
	pry_delay = 1 SECONDS

/obj/item/attachable/bayonet/van_bandolier
	name = "\improper Fairbairn-Sykes fighting knife"
	desc = "This isn't for dressing game or performing camp chores. It's almost certainly not an original. Almost."

/obj/item/attachable/bayonet/co2/update_icon()
	icon_state = "co2_knife[filled ? "-f" : ""]"
	attach_icon = "co2_bayonet[filled ? "-f" : ""]_a"

/obj/item/attachable/bayonet/co2/attackby(obj/item/W, mob/user)
	. = ..()
	if (. & ATTACK_HINT_BREAK_ATTACK)
		return

	if(istype(W, /obj/item/co2_cartridge))
		. |= ATTACK_HINT_NO_TELEGRAPH
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
		. |= ATTACK_HINT_NO_TELEGRAPH
		user.visible_message(SPAN_WARNING("[user] screws with [src], using \a [W]. \He looks very frustrated."), SPAN_NOTICE("You try to pry the cartridge out of [src], but it's stuck damn deep. Piece of junk..."))
		return

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
