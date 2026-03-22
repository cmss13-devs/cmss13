// Rifles

/obj/item/weapon/gun/rifle/halo
	name = "Halo rifle holder"
	mouse_pointer = 'icons/halo/effects/mouse_pointer/ma5c.dmi'
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_weapons.dmi'
	icon_state = null
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/guns_by_type/rifles_32.dmi',
		WEAR_J_STORE = 'icons/halo/mob/humans/onmob/clothing/suit_storage/suit_storage_by_faction/suit_slot_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi'
	)

/obj/item/weapon/gun/rifle/halo/ma5c
	name = "MA5C ICWS assault rifle"
	desc = "Belonging to the MA5 individual combat weapons system platform and produced by Misriah Armory, the MA5C is a staple weapon among the UNSC marine corps. It uses a box magazine capable of holding 32 7.62x51mm full-metal-jacket rounds."
	icon_state = "ma5c"
	item_state = "ma5c"
	caliber = "7.62x51mm"

	fire_sound = "gun_ma5c"
	reload_sound = 'sound/weapons/halo/gun_ma5c_reload.ogg'
	cocked_sound = 'sound/weapons/halo/gun_ma5c_cocked.ogg'
	unload_sound = 'sound/weapons/halo/gun_ma5c_unload.ogg'
	empty_sound = null

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_AUTO_EJECTOR
	start_automatic = TRUE
	map_specific_decoration = FALSE

	starting_attachment_types = list(/obj/item/attachable/flashlight/ma5c)
	current_mag = /obj/item/ammo_magazine/rifle/halo/ma5c
	attachable_allowed = list(
		/obj/item/attachable/ma5c_muzzle,
		/obj/item/attachable/attached_gun/grenade/ma5c,
		/obj/item/attachable/flashlight/ma5c,
	)

/obj/item/weapon/gun/rifle/halo/ma5c/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 48, "muzzle_y" = 16,"rail_x" = 0, "rail_y" = 0, "under_x" = 27, "under_y" = 16, "stock_x" = 0, "stock_y" = 0, "special_x" = 48, "special_y" = 16)

/obj/item/weapon/gun/rifle/halo/ma5c/handle_starting_attachment()
	..()
	var/obj/item/attachable/ma5c_muzzle/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)

/obj/item/weapon/gun/rifle/halo/ma5c/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 + 2*HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_2
	burst_scatter_mult = SCATTER_AMOUNT_TIER_2
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	recoil = RECOIL_AMOUNT_TIER_3
	fa_scatter_peak = 30
	fa_max_scatter = 2

/obj/item/weapon/gun/rifle/halo/ma5c/unloaded
	current_mag = null

/obj/item/weapon/gun/rifle/halo/ma5b
	name = "MA5B ICWS assault rifle"
	desc = "The MA5B is an older member of the MA5 line produced by Misriah Armory, though still in use by the Marine Corps and Army. Fires a standard 7.62x51mm round in 60 round magazines, with superior firerate to the MA5C, though less stability and accuracy."
	desc_lore = "While the MA5C was developed to meet many of the issues the UNSC Marine Corps found with the MA5B rifle, primarily its unreliable magazines and poor long-range performance, it remains popular among veterans and close quarter specialists. Especially when paired with 'shredder' ammunition."
	icon_state = "ma5b"
	item_state = "ma5b"
	caliber = "7.62x51mm"
	mouse_pointer = 'icons/halo/effects/mouse_pointer/ma5b.dmi'

	fire_sound = "gun_ma5b"
	fire_rattle = "gun_ma5b"
	firesound_volume = 20
	reload_sound = 'sound/weapons/halo/ma5b/gun_ma5b_reload.ogg'
	cocked_sound = 'sound/weapons/halo/ma5b/gun_ma5b_cock.ogg'
	unload_sound = 'sound/weapons/halo/ma5b/gun_ma5b_unload.ogg'
	empty_sound = null

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_AUTO_EJECTOR
	start_automatic = TRUE
	map_specific_decoration = FALSE
	current_mag = /obj/item/ammo_magazine/rifle/halo/ma5b
	attachable_allowed = list(
		/obj/item/attachable/ma5b_muzzle,
		/obj/item/attachable/flashlight/ma5b,
	)

/obj/item/weapon/gun/rifle/halo/ma5b/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 0, "rail_y" = 0, "under_x" = 48, "under_y" = 16, "stock_x" = 0, "stock_y" = 0, "special_x" = 48, "special_y" = 16)

/obj/item/weapon/gun/rifle/halo/ma5b/handle_starting_attachment()
	..()
	var/obj/item/attachable/ma5b_muzzle/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)
	var/obj/item/attachable/flashlight/ma5b/integrated2 = new(src)
	integrated2.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated2.Attach(src)
	update_attachable(integrated2.slot)

/obj/item/weapon/gun/rifle/halo/ma5b/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	set_burst_amount(BURST_AMOUNT_TIER_5)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 + 2*HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT * 0.55
	recoil_unwielded = RECOIL_AMOUNT_TIER_3
	recoil = RECOIL_AMOUNT_TIER_5
	fa_scatter_peak = 60
	fa_max_scatter = SCATTER_AMOUNT_TIER_7
	effective_range_max = EFFECTIVE_RANGE_MAX_TIER_2

/obj/item/weapon/gun/rifle/halo/ma5b/unloaded
	current_mag = null

/obj/item/weapon/gun/rifle/halo/ma3a
	name = "MA3A assault rifle"
	desc = "An old predecessor to the MA5 line, the MA3A had a notably short service history before being replaced by the more comprehensively designed MA5 series, nonetheless, enough were made to feed the private-security and would-be rebel markets for decades to come. Lacking the integrated combat suite of the MA5 rifles, the MA3A instead most commonly featured a over-designed and prone to malfunction multi-mode conventional computer optic. While robust in its capabilities, the constant adjustments and poor battery-life led to its quick abandonment by mainline UNSCDF units."
	icon_state = "ma3a"
	item_state = "ma5c"
	caliber = "7.62x51mm"

	fire_sound = "gun_ma5c"
	reload_sound = 'sound/weapons/halo/gun_ma5c_reload.ogg'
	cocked_sound = 'sound/weapons/halo/gun_ma5c_cocked.ogg'
	unload_sound = 'sound/weapons/halo/gun_ma5c_unload.ogg'
	empty_sound = null

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	start_automatic = TRUE
	map_specific_decoration = FALSE

	starting_attachment_types = list(/obj/item/attachable/flashlight/ma5c/ma3a, /obj/item/attachable/ma3a_barrel, /obj/item/attachable/scope/mini/ma3a)
	current_mag = /obj/item/ammo_magazine/rifle/halo/ma3a
	attachable_allowed = list(
		/obj/item/attachable/ma3a_shroud,
		/obj/item/attachable/flashlight/ma5c/ma3a,
		/obj/item/attachable/ma3a_barrel,
		/obj/item/attachable/scope/mini/ma3a,
	)

/obj/item/weapon/gun/rifle/halo/ma3a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16, "rail_x" = 16, "rail_y" = 16, "under_x" = 32, "under_y" = 16, "stock_x" = 0, "stock_y" = 0, "special_x" = 32, "special_y" = 16)

/obj/item/weapon/gun/rifle/halo/ma3a/handle_starting_attachment()
	..()
	var/obj/item/attachable/ma3a_shroud/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)

/obj/item/weapon/gun/rifle/halo/ma3a/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	set_burst_delay(FIRE_DELAY_TIER_10)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_8
	scatter = SCATTER_AMOUNT_TIER_2
	burst_scatter_mult = SCATTER_AMOUNT_TIER_3
	scatter_unwielded = SCATTER_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_3
	recoil = RECOIL_AMOUNT_TIER_4
	fa_scatter_peak = 30
	fa_max_scatter = 2

/obj/item/weapon/gun/rifle/halo/ma3a/unloaded
	current_mag = null

/obj/item/weapon/gun/rifle/halo/vk78
	name = "VK78 surplus rifle"
	desc = "The Colonial-Military-Authorities replacement for the ageing HMG-38, this 6.5x48mm rifle spent more of its life-time shooting targets than it had any combatant. Benefiting from a more ergonomically conventional layout, and exceptional mechanical simplicity, the Vk78 has long survived the CMA's downfall in the hands of militia-men, criminals, homesteaders and rebels alike. Listen for that distinct bark on patrol, it's probably not friendly."
	icon_state = "vk78"
	item_state = "vk78"
	caliber = "6.5x48mm"

	fire_sound = "gun_ma5c"
	reload_sound = 'sound/weapons/halo/gun_ma5c_reload.ogg'
	cocked_sound = 'sound/weapons/halo/gun_ma5c_cocked.ogg'
	unload_sound = 'sound/weapons/halo/gun_ma5c_unload.ogg'
	empty_sound = null

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	start_automatic = TRUE
	map_specific_decoration = FALSE

	starting_attachment_types = list(/obj/item/attachable/vk78_barrel, /obj/item/attachable/scope/mini/vk78)
	current_mag = /obj/item/ammo_magazine/rifle/halo/vk78
	attachable_allowed = list(
		/obj/item/attachable/vk78_front,
		/obj/item/attachable/vk78_barrel,
		/obj/item/attachable/scope/mini/vk78,
	)

/obj/item/weapon/gun/rifle/halo/vk78/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 16, "rail_y" = 16, "under_x" = 32, "under_y" = 16, "stock_x" = 0, "stock_y" = 0, "special_x" = 32, "special_y" = 16)


/obj/item/weapon/gun/rifle/halo/vk78/handle_starting_attachment()
	..()
	var/obj/item/attachable/vk78_front/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)


/obj/item/weapon/gun/rifle/halo/vk78/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	set_burst_delay(FIRE_DELAY_TIER_10)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_2
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_3
	burst_scatter_mult = SCATTER_AMOUNT_TIER_2
	scatter_unwielded = SCATTER_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_3
	recoil = RECOIL_AMOUNT_TIER_4
	fa_scatter_peak = 30
	fa_max_scatter = 2


/obj/item/weapon/gun/rifle/halo/vk78/unloaded
	current_mag = null


/obj/item/weapon/gun/rifle/halo/br55
	name = "BR55 battle rifle"
	desc = "A standard-issue marksman rifle in use by the UNSC Marine Corps, the BR55 battle rifle has a reasonably high power, acceptable rate of fire, and high accuracy. It comes with a standard 36-round detachable box magazine of 9.5x40mm experimental HP-SAP-HE rounds, allowing it to reach higher velocities than the MA5 series despite the smaller propellant."
	icon_state = "br55"
	item_state = "br55"
	caliber = "9.5x40mm"

	fire_sound = "gun_br55"
	reload_sound = 'sound/weapons/halo/gun_br55_reload.ogg'
	cocked_sound = 'sound/weapons/halo/gun_br55_cocked.ogg'
	unload_sound = 'sound/weapons/halo/gun_br55_unload.ogg'
	empty_sound = null
	mouse_pointer = 'icons/halo/effects/mouse_pointer/br55.dmi'

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_AUTO_EJECTOR
	start_automatic = FALSE
	map_specific_decoration = FALSE

	starting_attachment_types = list(/obj/item/attachable/br55_barrel, /obj/item/attachable/scope/mini/br55)
	current_mag = /obj/item/ammo_magazine/rifle/halo/br55
	attachable_allowed = list(
		/obj/item/attachable/br55_barrel,
		/obj/item/attachable/br55_muzzle,
		/obj/item/attachable/scope/mini/br55,
	)

/obj/item/weapon/gun/rifle/halo/br55/Initialize()
	. = ..()
	do_toggle_firemode(null, null, GUN_FIREMODE_BURSTFIRE)

/obj/item/weapon/gun/rifle/halo/br55/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 22, "rail_y" = 20, "under_x" = 32, "under_y" = 16, "stock_x" = 0, "stock_y" = 0, "special_x" = 32, "special_y" = 16)

/obj/item/weapon/gun/rifle/halo/br55/handle_starting_attachment()
	..()
	var/obj/item/attachable/br55_muzzle/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)

/obj/item/weapon/gun/rifle/halo/br55/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_5
	burst_scatter_mult = SCATTER_AMOUNT_TIER_5
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_3
	recoil = RECOIL_AMOUNT_TIER_4
	fa_scatter_peak = 16
	fa_max_scatter = 2

/obj/item/weapon/gun/rifle/halo/br55/unloaded
	current_mag = null

/obj/item/weapon/gun/rifle/halo/dmr
	name = "M392 DMR"
	desc = "The M392 Designated-Marksman-Rifle is a 7.62x51mm bullpup rifle featuring a 15 round magazine and commonly, a scope. The weapon was most notably used by UNSCDF Army units and the defunct Colonial-Military-Authority before and during the Insurrection. The rifle is mechanically simple compared to its contemporary brethren and this has led to its popularity on the black market, alongside its greater availability ever since the shuttering of the CMA."
	icon_state = "dmr"
	item_state = "dmr"
	caliber = "7.62x51mm"


	fire_sound = null
	fire_sounds = list('sound/weapons/halo/gun_m392_1.ogg', 'sound/weapons/halo/gun_m392_2.ogg', 'sound/weapons/halo/gun_m392_3.ogg')
	reload_sound = 'sound/weapons/halo/gun_br55_reload.ogg'
	cocked_sound = 'sound/weapons/halo/gun_br55_cocked.ogg'
	unload_sound = 'sound/weapons/halo/gun_br55_unload.ogg'
	empty_sound = null
	mouse_pointer = 'icons/halo/effects/mouse_pointer/br55.dmi'

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_AUTO_EJECTOR
	start_automatic = FALSE
	map_specific_decoration = FALSE


	starting_attachment_types = list(/obj/item/attachable/dmr_front, /obj/item/attachable/dmr_barrel, /obj/item/attachable/scope/mini/dmr)
	current_mag = /obj/item/ammo_magazine/rifle/halo/dmr
	attachable_allowed = list(
		/obj/item/attachable/dmr_front,
		/obj/item/attachable/dmr_barrel,
		/obj/item/attachable/scope/mini/dmr,
	)


/obj/item/weapon/gun/rifle/halo/dmr/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 48, "muzzle_y" = 16,"rail_x" = 28, "rail_y" = 16, "under_x" = 32, "under_y" = 16, "stock_x" = 0, "stock_y" = 0, "special_x" = 32, "special_y" = 16)


/obj/item/weapon/gun/rifle/halo/dmr/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6)
	set_burst_amount(0)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_4
	recoil = RECOIL_AMOUNT_TIER_5
	fa_scatter_peak = 16
	fa_max_scatter = 2


/obj/item/weapon/gun/rifle/halo/dmr/unloaded
	current_mag = null

// SMGs

/obj/item/weapon/gun/smg/halo
	name = "halo smg holder"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_weapons.dmi'
	icon_state = null
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/guns_by_type/smgs_32.dmi',
		WEAR_J_STORE = 'icons/halo/mob/humans/onmob/clothing/suit_storage/suit_storage_by_faction/suit_slot_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi',
		WEAR_WAIST = 'icons/halo/mob/humans/onmob/clothing/suit_storage/suit_storage_by_faction/suit_slot_unsc.dmi'
	)

/obj/item/weapon/gun/smg/halo/m7
	name = "M7 submachine gun"
	desc = "The M7 SMG is a relatively small caseless SMG that fires 5mm rounds. Coming with a folding stock and foldable grip, the M7 SMG has found its home in boarding action and special operations units for its compact size and low caliber."
	icon_state = "m7"
	item_state = "m7"
	caliber = "5x23mm"

	fire_sound = "gun_m7"
	fire_rattle = "gun_m7"
	reload_sound = 'sound/weapons/halo/gun_m7_reload.ogg'
	cocked_sound = 'sound/weapons/halo/gun_m7_cocked.ogg'
	unload_sound = 'sound/weapons/halo/gun_m7_unload.ogg'
	empty_sound = null
	w_class = SIZE_LARGE
	mouse_pointer = 'icons/halo/effects/mouse_pointer/ma5b.dmi'

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AUTO_EJECTOR
	start_automatic = TRUE
	map_specific_decoration = FALSE
	current_mag = /obj/item/ammo_magazine/smg/halo/m7
	starting_attachment_types = list(/obj/item/attachable/stock/m7, /obj/item/attachable/stock/m7/grip/folded_down)
	attachable_allowed = list(
		/obj/item/attachable/stock/m7,
		/obj/item/attachable/stock/m7/grip,
		/obj/item/attachable/flashlight/m7,
		/obj/item/attachable/reddot/m7,
		/obj/item/attachable/suppressor/m7,
	)

/obj/item/weapon/gun/smg/halo/m7/folded_up
	starting_attachment_types = list(/obj/item/attachable/stock/m7, /obj/item/attachable/stock/m7/grip)

/obj/item/weapon/gun/smg/halo/m7/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 15,"rail_x" = 16, "rail_y" = 16, "under_x" = 30, "under_y" = 15, "stock_x" = 13, "stock_y" = 14, "special_x" = 11, "special_y" = 16)

/obj/item/weapon/gun/smg/halo/m7/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	set_burst_delay(FIRE_DELAY_TIER_12)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	fa_scatter_peak = 40
	fa_max_scatter = 3

/obj/item/weapon/gun/smg/halo/m7/socom
	name = "M7 submachine gun"
	starting_attachment_types = list(
		/obj/item/attachable/stock/m7,
		/obj/item/attachable/stock/m7/grip/folded_down,
		/obj/item/attachable/flashlight/m7,
		/obj/item/attachable/reddot/m7,
		/obj/item/attachable/suppressor/m7,
	)

/obj/item/weapon/gun/smg/halo/m7/socom/folded_up
	starting_attachment_types = list(
		/obj/item/attachable/stock/m7,
		/obj/item/attachable/stock/m7/grip,
		/obj/item/attachable/flashlight/m7,
		/obj/item/attachable/reddot/m7,
		/obj/item/attachable/suppressor/m7,
	)

// shotguns

/obj/item/weapon/gun/shotgun/pump/halo
	name = "Halo shotgun holder"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_weapons.dmi'
	icon_state = null
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/guns_by_type/shotguns_32.dmi',
		WEAR_J_STORE = 'icons/halo/mob/humans/onmob/clothing/suit_storage/suit_storage_by_faction/suit_slot_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi'
	)

/obj/item/weapon/gun/shotgun/pump/halo/m90
	name = "\improper M90 CAWS"
	desc = "Built and produced by Weapon System Technology, the M90 CAWS is a contemporary pump-action shotgun employed by the UNSC for CQC scenarios. It feeds twelve 8-gauge shotgun shells from it's internal tubular magazine."
	icon_state = "m90"
	item_state = "m90"
	fire_sound = "gun_m90"
	pump_sound = 'sound/weapons/halo/gun_m90_pump.ogg'
	reload_sound = 'sound/weapons/halo/gun_m90_reload.ogg'
	current_mag = /obj/item/ammo_magazine/internal/shotgun/m90
	attachable_allowed = list(/obj/item/attachable/flashlight/m90)
	starting_attachment_types = list(/obj/item/attachable/flashlight/m90)
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG
	flags_equip_slot = SLOT_BACK
	map_specific_decoration = FALSE
	mouse_pointer = 'icons/halo/effects/mouse_pointer/shotgun.dmi'
	gauge = "8g"

/obj/item/weapon/gun/shotgun/pump/halo/m90/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 13, "rail_y" = 21, "under_x" = 29, "under_y" = 15, "stock_x" = 16, "stock_y" = 15, "special_x" = 27, "special_y" = 16)

/obj/item/weapon/gun/shotgun/pump/halo/m90/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SHOTGUN_BASE)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_4
	scatter_unwielded = SCATTER_AMOUNT_TIER_1
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_1
	recoil_unwielded = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/shotgun/pump/halo/m90/handle_starting_attachment()
	..()
	var/obj/item/attachable/m90_muzzle/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)

/obj/item/weapon/gun/shotgun/pump/halo/m90/unloaded
	current_mag = /obj/item/ammo_magazine/internal/shotgun/m90/unloaded

/obj/item/weapon/gun/shotgun/pump/halo/m90/police
	name = "\improper WMT Law Enforcement Shotgun"
	desc = "Made and produced by WMT, it is a civilian variation of the M90 CAWS for use by Law Enforcement... though can sometimes be found in the hands of civilians."
	icon_state = "m90_police"
	attachable_allowed = list(/obj/item/attachable/flashlight/m90/police)
	starting_attachment_types = list(/obj/item/attachable/flashlight/m90/police)
	current_mag = /obj/item/ammo_magazine/internal/shotgun/m90/police

// snipers

/obj/item/weapon/gun/rifle/sniper/halo
	name = "SRS99-AM sniper rifle"
	desc = "The SRS99-AM sniper rifle is the standard issue sniper rifle across all branches of the UNSC due to it's extreme capabilities. It has a 4 round detachable box magazine of 14.5x114mm APFSDS ammunition and modularity allowing the entire barrel system to be removed and replaced with alternative variants."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_weapons.dmi'
	icon_state = "srs99"
	item_state = "srs99"
	caliber = "14.5x114mm"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	worn_x_dimension = 64
	worn_y_dimension = 64
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/guns_by_type/marksman_rifles_64.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo_64.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo_64.dmi'
	)

	mouse_pointer = 'icons/halo/effects/mouse_pointer/srs99.dmi'
	fire_sound = "gun_srs99"
	reload_sound = 'sound/weapons/halo/gun_srs99_reload.ogg'
	cocked_sound = 'sound/weapons/halo/gun_srs99_cocked.ogg'
	unload_sound = 'sound/weapons/halo/gun_srs99_unload.ogg'
	empty_sound = null

	unacidable = TRUE
	explo_proof = TRUE
	current_mag = /obj/item/ammo_magazine/rifle/halo/sniper
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE
	flags_equip_slot = SLOT_BLOCK_SUIT_STORE|SLOT_BACK
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/srs_assembly, /obj/item/attachable/scope/variable_zoom/oracle, /obj/item/attachable/srs_barrel, /obj/item/attachable/bipod/srs_bipod)
	starting_attachment_types = list(/obj/item/attachable/scope/variable_zoom/oracle, /obj/item/attachable/srs_barrel, /obj/item/attachable/bipod/srs_bipod)
	flags_gun_features = GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_AUTO_EJECTOR
	map_specific_decoration = FALSE
	skill_locked = TRUE
	flags_item = TWOHANDED
	var/can_change_barrel = TRUE

/obj/item/weapon/gun/rifle/sniper/halo/Initialize()
	. = ..()
	AddComponent(/datum/component/iff_fire_prevention, 15)
	SEND_SIGNAL(src, COMSIG_GUN_ALT_IFF_TOGGLED, TRUE)

/obj/item/weapon/gun/rifle/sniper/halo/verb/toggle_scope_zoom_level()
	set name = "Toggle Scope Zoom Level"
	set category = "Weapons"
	set src in usr
	var/obj/item/attachable/scope/variable_zoom/S = attachments["rail"]
	S.toggle_zoom_level()

/obj/item/weapon/gun/rifle/sniper/halo/handle_starting_attachment()
	..()
	var/obj/item/attachable/srs_assembly/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/sniper/halo/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 38, "muzzle_y" = 21,"rail_x" = 21, "rail_y" = 24, "under_x" = 32, "under_y" = 14, "special_x" = 48, "special_y" = 17)


/obj/item/weapon/gun/rifle/sniper/halo/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SNIPER)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/sniper/halo/unloaded
	current_mag = null

/obj/item/weapon/mateba_key/halo_sniper
	name = "SRS99 barrel key"
	desc = "A key for the SRS99 barrel, used to unlock the mechanism and allow the user to remove the barrel."

/obj/item/weapon/gun/rifle/sniper/halo/attackby(obj/item/subject, mob/user)
	if(istype(subject, /obj/item/weapon/mateba_key/halo_sniper) && can_change_barrel)
		if(attachments["muzzle"])
			var/obj/item/attachable/attachment = attachments["special"]
			visible_message(SPAN_NOTICE("[user] begins stripping [attachment] from [src]."),
			SPAN_NOTICE("You begin stripping [attachment] from [src]."), null, 4)

			if(!do_after(usr, 35, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				return

			if(!(attachment == attachments[attachment.slot]))
				return

			visible_message(SPAN_NOTICE("[user] unlocks and removes [attachment] from [src]."),
			SPAN_NOTICE("You unlocks removes [attachment] from [src]."), null, 4)
			attachment.Detach(user, src)
			playsound(src, 'sound/handling/attachment_remove.ogg', 15, 1, 4)
			update_icon()
	. = ..()

/obj/item/weapon/gun/rifle/sniper/halo/able_to_fire(mob/living/user)
	if(!attachments["muzzle"])
		to_chat(user, SPAN_WARNING("You can't fire the [src] without a barrel!"))
		return
	. = ..()



// rocket launchers

/obj/item/weapon/gun/halo_launcher // im a lazy bastard and dont want to deal with killing all of the dumb procs sorry :)
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_weapons.dmi'
	icon_state = null

/obj/item/weapon/gun/halo_launcher/spnkr
	name = "\improper M41 SPNKr"
	desc = "The M41 SPNKr is a reusable rocket launcher system with multi-role capabilities, including the ability to lock onto air and ground targets. Commonly referred to as the Jackhammer by the UNSC forces equipped with it."
	icon_state = "spnkr"
	item_state = "spnkr"
	unacidable = TRUE
	explo_proof = TRUE
	layer = ABOVE_OBJ_LAYER
	flags_equip_slot = SLOT_BACK
	bonus_overlay_x = -2
	bonus_overlay_y = 1
	var/cover_open = FALSE
	current_mag = /obj/item/ammo_magazine/spnkr
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	mouse_pointer = 'icons/halo/effects/mouse_pointer/spnkr.dmi'
	flags_gun_features = GUN_WIELDED_FIRING_ONLY
	fire_sound = "gun_spnkr"
	reload_sound = 'sound/weapons/halo/gun_spnkr_reload.ogg'
	unload_sound = 'sound/weapons/halo/gun_spnkr_unload.ogg'
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/guns_by_type/heavy_weapons_32.dmi',
		WEAR_J_STORE = 'icons/halo/mob/humans/onmob/clothing/back/guns_by_type/heavy_weapons_32.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi'
	)
	var/skill_locked = TRUE
	w_class = SIZE_LARGE

/obj/item/weapon/gun/halo_launcher/spnkr/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_5)
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/halo_launcher/spnkr/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/spnkr/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)

/obj/item/weapon/gun/halo_launcher/spnkr/clicked(mob/user, list/mods)
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
			to_chat(user, SPAN_NOTICE("You open [src]'s tube cover, allowing the tubes to be removed."))
			cover_open = TRUE
		else
			playsound(src.loc, 'sound/handling/smartgun_close.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You close [src]'s tube cover."))
			cover_open = FALSE
		update_icon()
		return TRUE

/obj/item/weapon/gun/halo_launcher/spnkr/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]'s cover is closed! You can't put a new [current_mag ? current_mag.name : "rocket"] tube in! <b>(alt-click to open it)</b>"))
		return
	return ..()

/obj/item/weapon/gun/halo_launcher/spnkr/unload(mob/user, reload_override, drop_override, loc_override)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]'s cover is closed! You can't take out the [current_mag ? current_mag.name : "rocket tubes"]! <b>(alt-click to open it)</b>"))
		return

	else if(in_chamber)
		to_chat(user, SPAN_WARNING("The safety mechanism prevents you from removing the [current_mag ? current_mag.name : "rocket tubes"] from the [src] until all rounds have been fired."))
		return

	return ..()

/obj/item/weapon/gun/halo_launcher/spnkr/update_icon()
	. = ..()
	if(cover_open)
		overlays += image("+[base_gun_icon]_cover_open")
	else
		overlays += image("+[base_gun_icon]_cover_closed")

/obj/item/weapon/gun/halo_launcher/spnkr/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(cover_open)
			to_chat(user, SPAN_WARNING("You can't fire [src] with the feed cover open! <b>(alt-click to close)</b>"))
			return FALSE
		if(istype(user) && skill_locked)
			if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SNIPER)
				to_chat(user, SPAN_WARNING("You don't know how to use \the [src]..."))
				return FALSE


/obj/item/weapon/gun/halo_launcher/spnkr/unloaded
	current_mag = null
	flags_gun_features = GUN_WIELDED_FIRING_ONLY


// Pistols

/obj/item/weapon/gun/pistol/halo
	name = "Halo pistol holder"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_weapons.dmi'
	icon_state = null
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/guns_by_type/pistols_32.dmi',
		WEAR_J_STORE = 'icons/halo/mob/humans/onmob/clothing/suit_storage/suit_storage_by_faction/suit_slot_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi'
	)
	mouse_pointer = 'icons/halo/effects/mouse_pointer/magnum.dmi'
	reload_sound = 'sound/weapons/halo/gun_magnum_reload.ogg'
	unload_sound = 'sound/weapons/halo/gun_magnum_unload.ogg'
	cocked_sound = 'sound/weapons/halo/gun_magnum_cocked.ogg'
	drop_sound = 'sound/items/halo/drop_lightweapon.ogg'
	pickup_sound = 'sound/items/halo/grab_lightweapon.ogg'
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AUTO_EJECTOR
	empty_sound = null

/obj/item/weapon/gun/pistol/halo/m6c
	name = "M6C service magnum"
	desc = "The M6C is a semi-automatic 12.7x40mm recoil-operated handgun with a standard 12 round magazine. It's set apart from other M6 platform sidearms in that it does not come equipped with a smart-link scope attached to the top of it. Some marines reportedly prefer it due to the less cumbersome nature."
	icon_state = "m6c"
	item_state = "m6"
	caliber = "12.7x40mm"
	current_mag = /obj/item/ammo_magazine/pistol/halo/m6c
	attachable_allowed = list(/obj/item/attachable/scope/mini/smartscope/m6c, /obj/item/attachable/flashlight/m6)
	fire_sound = "gun_m6c"
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AUTO_EJECTOR

/obj/item/weapon/gun/pistol/halo/m6c/unloaded
	current_mag = null

/obj/item/weapon/gun/pistol/halo/m6c/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 21,"rail_x" = 16, "rail_y" = 16, "under_x" = 16, "under_y" = 16, "stock_x" = 18, "stock_y" = 15)

/obj/item/weapon/gun/pistol/halo/m6c/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/pistol/halo/m6c/socom
	name = "M6C/SOCOM \"Automag\" pistol"
	desc = "A Special Operations Command modified M6C, otherwise known as the M6C/SOCOM. This sidearm features a variety of fine-tuned adjustments to better improve its performance in the field, while also receiving a slick new paintjob."
	icon_state = "m6c_socom"
	current_mag = /obj/item/ammo_magazine/pistol/halo/m6c/socom
	attachable_allowed = list(/obj/item/attachable/flashlight/m6c_socom, /obj/item/attachable/suppressor/m6c_socom)
	starting_attachment_types = list(/obj/item/attachable/flashlight/m6c_socom, /obj/item/attachable/suppressor/m6c_socom)

/obj/item/weapon/gun/pistol/halo/m6c/socom/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 19, "muzzle_y" = 15,"rail_x" = 16, "rail_y" = 16, "under_x" = 19, "under_y" = 16, "stock_x" = 0, "stock_y" = 0)


/obj/item/weapon/gun/pistol/halo/m6c/socom/unloaded
	current_mag = null

/obj/item/weapon/gun/pistol/halo/m6c/m4a
	name = "M4A pistol"
	desc = "An antiquated 12.7x40mm pistol, popular among civilians and criminals alike. The M4A is a predecessor to the more commonly recognized M6 series of pistols by Misriah, removed from official service in 2414 when the M6 took stage.  It's regarded as being inaccurate with a blinding muzzle flash and deafening report, making it unsuited for most practical purposes, features that make it even more attractive to its most common users."
	icon_state = "m4a"
	current_mag = /obj/item/ammo_magazine/pistol/halo/m6c
	attachable_allowed = list(/obj/item/attachable/flashlight/m6)
	fire_sound = "gun_m6c"

/obj/item/weapon/gun/pistol/halo/m6c/m4a/unloaded
	current_mag = null

/obj/item/weapon/gun/pistol/halo/m6c/m4a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 21,"rail_x" = 16, "rail_y" = 16, "under_x" = 16, "under_y" = 16, "stock_x" = 18, "stock_y" = 15)

/obj/item/weapon/gun/pistol/halo/m6c/m4a/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_8)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_2
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT - BULLET_DAMAGE_MULT_TIER_1

/obj/item/weapon/gun/pistol/halo/m6g
	name = "M6G service magnum"
	desc = "The M6G service magnum is a high-power sidearm utilized by the UNSC, using 12.7x40mm rounds held in a 8 round magazine. With a longer barrel, the M6G is more accurate and has a higher velocity than the M6C."
	icon_state = "m6g"
	item_state = "m6"
	caliber = "12.7x40mm"
	current_mag = /obj/item/ammo_magazine/pistol/halo/m6g
	attachable_allowed = list(/obj/item/attachable/scope/mini/smartscope/m6g, /obj/item/attachable/flashlight/m6)
	fire_sound = "gun_m6g"

/obj/item/weapon/gun/pistol/halo/m6g/unloaded
	current_mag = null

/obj/item/weapon/gun/pistol/halo/m6g/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 21,"rail_x" = 16, "rail_y" = 16, "under_x" = 16, "under_y" = 16, "stock_x" = 18, "stock_y" = 15)

/obj/item/weapon/gun/pistol/halo/m6g/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4
	velocity_add = AMMO_SPEED_TIER_1

/obj/item/weapon/gun/pistol/halo/m6a
	name = "M6A service magnum"
	desc = "The M6A is a semi-automatic 12.7x40mm recoil-operated handgun with a standard 12 round magazine. This variation is often given out to security and law enforcement firms as a more compact version of the standard template, though with less stopping power."
	icon_state = "m6a"
	item_state = "m6"
	caliber = "12.7x40mm"
	current_mag = /obj/item/ammo_magazine/pistol/halo/m6a
	attachable_allowed = list(/obj/item/attachable/flashlight/m6)
	fire_sound = "gun_m6c"

/obj/item/weapon/gun/pistol/halo/m6a/unloaded
	current_mag = null

/obj/item/weapon/gun/pistol/halo/m6a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 21,"rail_x" = 16, "rail_y" = 16, "under_x" = 16, "under_y" = 16, "stock_x" = 18, "stock_y" = 15)


/obj/item/weapon/gun/pistol/halo/m6a/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_2
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult =  BASE_BULLET_DAMAGE_MULT - BULLET_DAMAGE_MULT_TIER_4

/obj/item/weapon/gun/pistol/halo/m6d
	name = "M6D service magnum"
	desc = "The M6D service magnum is a high-power sidearm in use by the UNSC, particularly with officers and some special forces troops. Fires 12.7x40mm Semi-Armour-Piercing-High-Explosive (SAPHE) rounds out of a 12 round magazine."
	desc_lore = "Its extended magazine and custom grip give it a striking profile which many consider unwieldy and bulky, though others will swear on the weapons power and accuracy with its integrated KFA-2 scope."
	icon_state = "m6d"
	item_state = "m6"
	caliber = "12.7x40mm"
	current_mag = /obj/item/ammo_magazine/pistol/halo/m6d
	attachable_allowed = list(/obj/item/attachable/scope/variable_zoom/m6d, /obj/item/attachable/flashlight/m6)
	fire_sound = "gun_m6d"
	unload_sound = 'sound/weapons/halo/m6d/gun_m6d_unload.ogg'
	reload_sound = 'sound/weapons/halo/m6d/gun_m6d_reload.ogg'
	cocked_sound = 'sound/weapons/halo/m6d/gun_m6d_cock.ogg'

/obj/item/weapon/gun/pistol/halo/m6g/unloaded
	current_mag = null

/obj/item/weapon/gun/pistol/halo/m6d/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 21,"rail_x" = 16, "rail_y" = 16, "under_x" = 16, "under_y" = 16, "stock_x" = 18, "stock_y" = 15)

/obj/item/weapon/gun/pistol/halo/m6d/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_6
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_6
	scatter = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_9
	damage_mult = BASE_BULLET_DAMAGE_MULT * 2
	velocity_add = AMMO_SPEED_TIER_2

/obj/item/weapon/gun/pistol/halo/m6d/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/variable_zoom/m6d/scope = new(src)
	scope.flags_attach_features &= ~ATTACH_REMOVABLE
	scope.Attach(src)
	scope.hidden = TRUE
	update_attachable(scope.slot)
