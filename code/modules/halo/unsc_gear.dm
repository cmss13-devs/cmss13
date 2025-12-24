// Rifles

/obj/item/weapon/gun/rifle/halo
	name = "Halo rifle holder"
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

	starting_attachment_types = list(/obj/item/attachable/flashlight/ma5c, /obj/item/attachable/ma5c_barrel)
	current_mag = /obj/item/ammo_magazine/rifle/halo/ma5c
	attachable_allowed = list(
		/obj/item/attachable/ma5c_shroud,
		/obj/item/attachable/attached_gun/grenade/ma5c,
		/obj/item/attachable/flashlight/ma5c,
		/obj/item/attachable/ma5c_barrel,
	)

/obj/item/weapon/gun/rifle/halo/ma5c/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 0, "rail_y" = 0, "under_x" = 32, "under_y" = 16, "stock_x" = 0, "stock_y" = 0, "special_x" = 32, "special_y" = 16)

/obj/item/weapon/gun/rifle/halo/ma5c/handle_starting_attachment()
	..()
	var/obj/item/attachable/ma5c_shroud/integrated = new(src)
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

// Grenades

/obj/item/explosive/grenade/high_explosive/unsc
	name = "M9 fragmentation grenade"
	desc = "A high explosive fragmentation grenade utilized by the UNSC."
	desc_lore = "Rumors spread about how every new posting someone gets, the design of the M9 fragmentation grenade looks different from the last ones they held."
	icon = 'icons/halo/obj/items/weapons/grenades.dmi'
	icon_state = "m9"
	item_state = "m9"
	shrapnel_count = 12
	underslug_launchable = FALSE

/obj/item/explosive/grenade/high_explosive/unsc/launchable
	name = "40mm explosive grenade"
	desc = "A 40mm explosive grenade. It's unable to be primed by hand and must be loaded into the bottom of a rifle's grenade launcher."
	icon = 'icons/halo/obj/items/weapons/grenades.dmi'
	icon_state = "he_40mm"
	item_state = "he_40mm"
	hand_throwable = FALSE
	has_arm_sound = FALSE
	dangerous = FALSE
	underslug_launchable = TRUE

// rifle magazines

/obj/item/ammo_magazine/rifle/halo
	name = "halo magazine"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	icon_state = null
	ammo_band_icon = null
	ammo_band_icon_empty = null

/obj/item/ammo_magazine/rifle/halo/ma5c
	name = "\improper MA5C magazine (7.62x51mm FMJ)"
	desc = "A rectangular box magazine for the MA5C holding 48 rounds of 7.62x51 FMJ ammunitions."
	icon_state = "ma5c"
	max_rounds = 48
	gun_type = /obj/item/weapon/gun/rifle/halo/ma5c
	default_ammo = /datum/ammo/bullet/rifle/ma5c
	caliber = "7.62x51"
	ammo_band_icon = "+ma5c_band"
	ammo_band_icon_empty = "+ma5c_band_e"

/obj/item/ammo_magazine/rifle/halo/ma5c/shredder
	name = "\improper Armor Piercing MA5C magazine (7.62x51mm Shredder)"
	desc = "A rectangular box magazine for the MA5C holding 48 rounds of 7.62x51 shredder ammunitions, a specialized ammunition that pierces armor and splinters in the target."
	max_rounds = 48
	gun_type = /obj/item/weapon/gun/rifle/halo/ma5c
	default_ammo = /datum/ammo/bullet/rifle/ma5c/shredder
	caliber = "7.62x51"
	ammo_band_color = "#994545"

/obj/item/ammo_magazine/rifle/halo/ma3a
	name = "\improper MA3A magazine (7.62x51mm FMJ)"
	desc = "A rectangular box magazine for the MA3A holding 32 rounds of 7.62x51 FMJ ammunitions."
	icon_state = "ma3a"
	max_rounds = 32
	gun_type = /obj/item/weapon/gun/rifle/halo/ma3a
	default_ammo = /datum/ammo/bullet/rifle/ma3a
	caliber = "7.62x51"

/obj/item/ammo_magazine/rifle/halo/vk78
	name = "\improper VK78 magazine (6.5x48mm FMJ)"
	desc = "An angular box magazine for the VK78 holding 20 rounds of 6.5x48mm FMJ ammunitions."
	icon_state = "vk78"
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/halo/vk78
	default_ammo = /datum/ammo/bullet/rifle/vk78
	caliber = "6.5x48"

/obj/item/ammo_magazine/rifle/halo/br55
	name = "\improper BR55 magazine (9.5x40mm X-HP SAP-HE)"
	desc = "A rectangular box magazine for the BR55 holding 36 rounds of 9.5x40mm X-HP SAP-HE ammunitions."
	icon_state = "br55"
	max_rounds = 36
	gun_type = /obj/item/weapon/gun/rifle/halo/br55
	default_ammo = /datum/ammo/bullet/rifle/br55
	caliber = "9.5x40mm"
	bonus_overlay = "br55_overlay"
	bonus_overlay_icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'

/obj/item/ammo_magazine/rifle/halo/br55/extended
	name = "\improper quad-stack BR55 magazine (9.5x40mm X-HP SAP-HE)"
	desc = "A quad-stack rectangular box magazine for the BR55 holding 60 rounds of 9.5x40mm X-HP SAP-HE ammunitions."
	icon_state = "br55_quadstack"
	max_rounds = 60
	bonus_overlay = "br55_ext_overlay"

/obj/item/ammo_magazine/rifle/halo/dmr
	name = "\improper M392 DMR magazine (7.62x51mm FMJ)"
	desc = "A rectangular 15 round box magazine for the M392 DMR filled with 7.62x51mm FMJ ammo."
	icon_state = "dmr"
	max_rounds = 15
	gun_type = /obj/item/weapon/gun/rifle/halo/dmr
	default_ammo = /datum/ammo/bullet/rifle/dmr
	caliber = "7.62x51"

// smg magazines
/obj/item/ammo_magazine/smg/halo
	name = "halo smg magazine"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	icon_state = null
	ammo_band_icon = null
	ammo_band_icon_empty = null

/obj/item/ammo_magazine/smg/halo/m7
	name = "\improper M7 magazine (5×23mm M443 Caseless FMJ)"
	desc = "A rectangular magazine to be inserted into the side of the M7 submachine gun. It holds 60 rounds of 5×23mm M443 Caseless FMJ."
	icon_state = "m7"
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/smg/halo/
	default_ammo = /datum/ammo/bullet/smg/m7
	caliber = "5x23mm"

// sniper magazines

/obj/item/ammo_magazine/rifle/halo/sniper
	name = "\improper SRS99-AM magazine (14.5x114mm APFSDS)"
	desc = "A rectangular box magazine for the SRS99-AM holding four rounds of 14.5x114mm armor-piercing, fin-stabilized, discarding sabot."
	icon_state = "srs99"
	max_rounds = 4
	gun_type = /obj/item/weapon/gun/rifle/sniper/halo
	default_ammo = /datum/ammo/bullet/rifle/srs99
	caliber = "14.5x114mm"

// shotgun internal magazines

/obj/item/ammo_magazine/internal/shotgun/m90
	caliber = "8g"
	max_rounds = 12
	current_rounds = 12
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/unsc

/obj/item/ammo_magazine/internal/shotgun/m90/unloaded
	current_rounds = 0

/obj/item/ammo_magazine/internal/shotgun/m90/police
	default_ammo = /datum/ammo/bullet/shotgun/beanbag/unsc

// shotgun shells

/obj/item/ammo_magazine/shotgun/buckshot/unsc
	name = "UNSC 8-gauge shotgun shell box"
	desc = "A box filled with 8-gauge MAG 15P-00B buckshot shells."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	icon_state = "8g"
	item_state = "8g"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/unsc
	transfer_handful_amount = 5
	max_rounds = 24
	caliber = "8g"

/obj/item/ammo_magazine/shotgun/beanbag/unsc
	name = "UNSC 8-gauge shotgun beanbag box"
	desc = "A box filled with 8-gauge MAG LLHB beanbag shells."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	icon_state = "8g_beanbag"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag/unsc
	transfer_handful_amount = 5
	max_rounds = 24
	caliber = "8g"

// rockets

/obj/item/ammo_magazine/spnkr
	name = "\improper M19 SSM tube assembly"
	desc = "A 102mm dual-tubed rocket assembly intended to be loaded into an M41 spnkr."
	caliber = "102mm"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/special.dmi'
	icon_state = "spnkr_rockets"
	bonus_overlay_icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/special.dmi'
	bonus_overlay = "spnkr_rockets"
	max_rounds = 2
	default_ammo = /datum/ammo/rocket/spnkr
	gun_type = /obj/item/weapon/gun/halo_launcher/spnkr
	reload_delay = 30
	w_class = SIZE_LARGE

/obj/item/ammo_magazine/spnkr/update_icon()
	..()
	if(current_rounds <= 0)
		name = "\improper spent M19 SSM tube assembly"
		desc = "A spent 102mm dual-tubed rocket assembly previously loaded into a spnkr. Of no use to you now..."
		icon_state = "spnkr_rockets_e"

// pistol magazines

/obj/item/ammo_magazine/pistol/halo
	name = "halo magazine"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	icon_state = null
	ammo_band_icon = null
	ammo_band_icon_empty = null
	caliber = "12.7x40mm"

/obj/item/ammo_magazine/pistol/halo/m6c
	name = "\improper M6C magazine (12.7x40mm SAP-HE)"
	desc = "A rectangular and slanted magazine for the M6C, holding 12 rounds of 12.7x40mm SAP-HE ammunition."
	icon_state = "m6c"
	gun_type = /obj/item/weapon/gun/pistol/halo/m6c
	default_ammo = /datum/ammo/bullet/pistol/magnum
	max_rounds = 12
	bonus_overlay_icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	bonus_overlay = "m6c_overlay"

/obj/item/ammo_magazine/pistol/halo/m6c/socom
	name = "\improper M6C/SOCOM magazine (12.7x40mm SAP-HE)"
	desc = "An extended capacity M6C magazine, capable of holding 16 rounds compared to the standard 12. Comes in special-ops black, for the true clandestine operative."
	max_rounds = 16
	icon_state = "m6c_socom"
	bonus_overlay = "m6c_ext_overlay"

/obj/item/ammo_magazine/pistol/halo/m6a
	name = "\improper M6A magazine (12.7x40mm SAP-HE)"
	desc = "A rectangular and slanted magazine for the M6A, holding 12 rounds of 12.7x40mm SAP-HE ammunition."
	icon_state = "m6c"
	gun_type = /obj/item/weapon/gun/pistol/halo/m6a
	default_ammo = /datum/ammo/bullet/pistol/magnum
	max_rounds = 12

/obj/item/ammo_magazine/pistol/halo/m6g
	name = "\improper M6G magazine (12.7x40mm SAP-HE)"
	desc = "A rectangular slanted magazine for the M6G, holding 8 rounds of 12.7x40mm SAP-HE ammunition"
	icon_state = "m6g"
	gun_type = /obj/item/weapon/gun/pistol/halo/m6g
	default_ammo = /datum/ammo/bullet/pistol/magnum
	max_rounds = 8



/obj/item/attachable/ma5c_shroud
	name = "\improper MA5C shroud"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "ma5c_shroud"
	attach_icon = "ma5c_shroud"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0
	hud_offset_mod = -3

/obj/item/attachable/attached_gun/grenade/ma5c
	name = "\improper M301C 40mm grenade launcher"
	desc = "A 40mm underslung grenade launcher. The C variant of the M301 is purpose built for the MA5C ICWS to serve as a grip for the weapon much like the standard-issue flashlight of the MA5C."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "ma5c_gl"
	attach_icon = "ma5c_gl"
	current_rounds = 0
	max_rounds = 1
	max_range = 10
	attachment_firing_delay = 5

/obj/item/attachable/attached_gun/grenade/ma5c/New()
	..()
	recoil_mod = -RECOIL_AMOUNT_TIER_4

/obj/item/attachable/ma3a_shroud
	name = "\improper MA3A shroud"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "ma3a_shroud"
	attach_icon = "ma3a_shroud"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0
	hud_offset_mod = -3

/obj/item/attachable/vk78_front
	name = "\improper VK78 fore"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "vk78_front"
	attach_icon = "vk78_front"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0
	hud_offset_mod = -3

/obj/item/attachable/vk78_front/New()
	..()
	recoil_mod = -RECOIL_AMOUNT_TIER_2

/obj/item/attachable/br55_muzzle
	name = "\improper BR55 muzzle"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "br55_muzzle"
	attach_icon = "br55_muzzle"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0
	hud_offset_mod = -7

/obj/item/attachable/m90_muzzle
	name = "\improper M90 CAWS muzzle"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "m90_muzzle"
	attach_icon = "m90_muzzle"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0
	hud_offset_mod = -7

/obj/item/attachable/dmr_front
	name = "\improper M392 DMR fore"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "dmr_front"
	attach_icon = "dmr_front"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0
	hud_offset_mod = -3

/obj/item/attachable/flashlight/ma5c
	name = "\improper MA5 integrated flashlight"
	desc = "The MA5 integrated flashlight, standard-issue to any MA5-model assault rifle and essential to handling it."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "ma5c_flashlight"
	attach_icon = "ma5c_flashlight"
	original_state = "ma5c_flashlight"
	original_attach = "ma5c_flashlight"
	slot = "under"

/obj/item/attachable/flashlight/ma5c/New()
	..()
	recoil_mod = -RECOIL_AMOUNT_TIER_4

/obj/item/attachable/flashlight/ma5c/ma3a
	name = "\improper MA3A integrated flashlight"
	desc = "An underbarrel grip for the MA3A, integrated as a flashlight."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "ma3a_flashlight"
	attach_icon = "ma3a_flashlight"
	original_state = "ma3a_flashlight"
	original_attach = "ma3a_flashlight"
	slot = "under"

/obj/item/attachable/flashlight/ma5c/ma3a/New()
	..()
	recoil_mod = -RECOIL_AMOUNT_TIER_4

/obj/item/attachable/flashlight/m90
	name = "\improper M90 integrated flashlight"
	desc = "The M90 integrated flashlight, standard-issue to any M90 series shotgun and built into the pump. You shouldn't see this, actually."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "m90_flashlight"
	attach_icon = "m90_flashlight_a"
	original_state = "m90_flashlight"
	original_attach = "m90_flashlight_a"
	slot = "under"

/obj/item/attachable/flashlight/m90/police
	icon_state = "m90_police_flashlight"
	attach_icon = "m90_police_flashlight_a"
	original_state = "m90_police_flashlight"
	original_attach = "m90_police_flashlight_a"

/obj/item/attachable/ma5c_barrel
	name = "\improper MA5C barrel"
	desc = "The barrel to an MA5C ICWS assault rifle. Better not leave without it."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "ma5c_barrel"
	attach_icon = "ma5c_barrel"
	slot = "muzzle"
	size_mod = 0

/obj/item/attachable/ma5c_barrel/New()
	..()
	scatter_mod = -SCATTER_AMOUNT_TIER_3
	burst_scatter_mod = -SCATTER_AMOUNT_TIER_3

/obj/item/attachable/vk78_barrel
	name = "\improper VK78 barrel"
	desc = "The barrel to an VK78 Commando rifle. Better not leave without it."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "vk78_barrel"
	attach_icon = "vk78_barrel"
	slot = "muzzle"
	size_mod = 0

/obj/item/attachable/vk78_barrel/New()
	..()
	scatter_mod = -SCATTER_AMOUNT_TIER_2
	burst_scatter_mod = -SCATTER_AMOUNT_TIER_3

/obj/item/attachable/ma3a_barrel
	name = "\improper MA3A barrel"
	desc = "The barrel to an MA3A ICWS assault rifle. Better not leave without it."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "ma3a_barrel"
	attach_icon = "ma3a_barrel"
	slot = "muzzle"
	size_mod = 0

/obj/item/attachable/br55_barrel
	name = "\improper BR55 barrel"
	desc = "The barrel to an BR55 battle rifle. Better not leave without it."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "br55_barrel"
	attach_icon = "br55_barrel"
	slot = "muzzle"
	size_mod = 0

/obj/item/attachable/br55_barrel/New()
	..()
	scatter_mod = -5
	burst_scatter_mod = -SCATTER_AMOUNT_TIER_3

/obj/item/attachable/dmr_barrel
	name = "\improper M392 DMR barrel"
	desc = "The barrel to an M392 DMR. Better not leave without it."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "dmr_barrel"
	attach_icon = "dmr_barrel"
	slot = "muzzle"
	size_mod = 0

/obj/item/attachable/dmr_barrel/New()
	..()
	scatter_mod = -SCATTER_AMOUNT_TIER_2
	burst_scatter_mod = -SCATTER_AMOUNT_TIER_3

/obj/item/attachable/scope/spnkr
	name = "\improper spnkr scope"
	desc = "This shouldn't be able to come off the spnkr..."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "spnkr_scope"
	attach_icon = null
	size_mod = 0
	hidden = TRUE

/obj/item/attachable/scope/mini/br55
	name = "\improper A2 scope"
	desc = "A telescopic sight with 2x zoom capability. While typically reliable, it often needs adjustment and fine tuning to maintain perfect accuracy."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "br55_scope"
	attach_icon = "br55_scope"
	size_mod = 0

/obj/item/attachable/scope/mini/vk78
	name = "\improper VK78 scope"
	desc = "An old telescopic sight, often paired with the VK78 Commando."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "vk78_scope"
	attach_icon = "vk78_scope"
	size_mod = 0

/obj/item/attachable/scope/mini/dmr
	name = "\improper M392 DMR scope"
	desc = "A x3 DMR scope commonly equipped upon the M392 DMR. Rather reliable by most accounts."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "dmr_scope"
	attach_icon = "dmr_scope"
	size_mod = 0

/obj/item/attachable/scope/mini/ma3a
	name = "\improper MA3A scope"
	desc = "An MA3A scope, unintregrated but often attached due to the accuracy increase."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "ma3a_scope"
	attach_icon = "ma3a_scope"
	size_mod = 0

/obj/item/attachable/scope/mini/ma3a/New()
	..()
	scatter_mod = -SCATTER_AMOUNT_TIER_3
	burst_scatter_mod = -SCATTER_AMOUNT_TIER_3
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_4

/obj/item/attachable/srs_barrel
	name = "\improper SRS99-AM sniper rifle barrel"
	desc = "The detachable barrel of an SRS-99AM sniper rifle featuring a large muzzle brake at the end. Essential to the operation of the rifle. It's detachable nature allows it to be swapped out with other barrels featuring alternative integrated attachments. "
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "srs_barrel"
	attach_icon = "srs_barrel"
	slot = "muzzle"
	size_mod = 0
	flags_attach_features = NO_FLAGS

/obj/item/attachable/srs_barrel/New()
	..()
	scatter_mod = -SCATTER_AMOUNT_TIER_1

/obj/item/attachable/scope/variable_zoom/oracle
	name = "\improper N-Variant oracle scope"
	desc= "One of the most common sniper optic systems utilized by the UNSC. Able to switch between different zoom modes. Some models even provide night vision optics."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "oracle_scope"
	attach_icon = "oracle_scope"
	slot = "rail"

/obj/item/attachable/srs_assembly
	name = "\improper SRS99-AM assembly"
	desc = "That's not supposed to come off. You should probably report it to your supervisor..."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "srs_assembly"
	attach_icon = "srs_assembly"
	slot = "special"
	flags_attach_features = NO_FLAGS

/obj/item/attachable/bipod/srs_bipod
	name = "\improper SRS99-AM bipod"
	desc = "A detachable bipod system belonging to the SRS99-AM sniper rifle. Why you would detach it from such an unwieldy rifle is a mystery."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "srs_bipod"
	attach_icon = "srs_bipod"
	flags_attach_features = NO_FLAGS

/obj/item/attachable/scope/mini/smartscope
	name = "\improper KFA-2 x2 smart-linked scope"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = null
	slot = "rail"
	zoom_offset = 3

/obj/item/attachable/scope/mini/smartscope/m6g
	name = "\improper KFA-2/G smart-linked scope"
	desc = "A smart-linked scope designed to attach to the M6G magnum, allowing for advanced magnification and linking with UNSC optics to provide the HUD a reticle and ammunition counter."
	icon_state = "m6c_smartscope_obj"
	attach_icon = "m6g_smartscope"

/obj/item/attachable/scope/mini/smartscope/m6c
	name = "\improper KFA-2/C smart-linked scope"
	desc = "A smart-linked scope designed to attach to the M6C magnum, allowing for advanced magnification and linking with UNSC optics to provide the HUD a reticle and ammunition counter."
	icon_state = "m6c_smartscope_obj"
	attach_icon = "m6c_smartscope"

/obj/item/attachable/flashlight/m6
	name = "\improper M6 flashlight"
	desc = "The M6 Flashlight. Not much can be said about it, it turns on and off."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "flashlight"
	attach_icon = "m6g_light"
	original_state = "flashlight"
	original_attach = "m6g_light"
	slot = "under"

/obj/item/attachable/flashlight/m6/Attach(obj/item/weapon/gun/subject)
	if(istype(subject, /obj/item/weapon/gun/pistol/halo/m6g))
		attach_icon = "m6g_light"
		original_attach = "m6g_light"
		..()
	if(istype(subject, /obj/item/weapon/gun/pistol/halo/m6c))
		attach_icon = "m6c_light"
		original_attach = "m6c_light"
		..()
	else return

/obj/item/attachable/flashlight/m6c_socom
	name = "\improper M6C/SOCOM flashlight/laser-sight"
	desc = "Standard to all M6C/SOCOM models, it is both a combination of the flashlight and laser-sight. Only able to be attached to the M6C/SOCOM series of pistols, due to its modified attachment points."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "socom_under"
	attach_icon = "socom_under"
	original_state = "socom_under"
	original_attach = "socom_under"
	slot = "under"

/obj/item/attachable/flashlight/m6c_socom/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_9
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/suppressor/m6c_socom
	name = "\improper M6C/SOCOM suppressor"
	desc = "An attachable suppressor, only able to be attached to the M6C/SOCOM series of pistols, due to its modified attachment points."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "socom_barrel"
	attach_icon = "socom_barrel"
	hud_offset_mod = -3

/obj/item/attachable/suppressor/m6c_socom/New()
	return

/obj/item/attachable/suppressor/m7
	name = "\improper M7/SOCOM suppressor"
	desc = "An attachable suppressor for the M7/SOCOM upgrade package."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "m7_suppressor"
	attach_icon = "m7_suppressor"
	hud_offset_mod = -3

/obj/item/attachable/suppressor/m7/New()
	return

/obj/item/attachable/reddot/m7
	name = "\improper M7/SOCOM red-dot sight"
	desc = "A red-dot sight for the M7/SOCOM upgrade package."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "m7_red_dot"
	attach_icon = "m7_red_dot"

/obj/item/attachable/flashlight/m7
	name = "\improper M7 flashlight"
	desc = "A side-mounted flashlight to attach to the M7 SMG."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "m7_flashlight"
	attach_icon = "m7_flashlight"
	original_state = "m7_flashlight"
	original_attach = "m7_flashlight"
	slot = "special"
/obj/item/attachable/stock/m7
	name = "M7 SMG collapsable stock"
	desc = "A collapsable stock for the M7 SMG. Extending it makes it more difficult to fire with one and unable to fit into belts, but improves the accuracy and scatter of the weapon."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "m7_stock"
	attach_icon = "m7_stock"
	w_class = SIZE_TINY
	flags_attach_features = ATTACH_ACTIVATION
	collapsible = TRUE
	stock_activated = FALSE
	collapse_delay  = 0.5 SECONDS
	attachment_action_type = /datum/action/item_action/toggle
	slot = "stock"

/obj/item/attachable/stock/m7/New()
	..()

	accuracy_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	scatter_unwielded_mod = 0
	wield_delay_mod = 0
	recoil_unwielded_mod = 0
	size_mod = 2

/obj/item/attachable/stock/m7/apply_on_weapon(obj/item/weapon/gun/gun)
	if(stock_activated)
		//folded up
		accuracy_mod = HIT_ACCURACY_MULT_TIER_2
		scatter_mod = -SCATTER_AMOUNT_TIER_9
		movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
		accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_4
		scatter_unwielded_mod = SCATTER_AMOUNT_TIER_6
		recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
		icon_state = "m7_stock-on"
		attach_icon = "m7_stock-on"
		size_mod = 2
		wield_delay_mod = WIELD_DELAY_VERY_FAST

	else
		accuracy_mod = 0
		recoil_mod = 0
		scatter_mod = 0
		movement_onehanded_acc_penalty_mod = 0
		accuracy_unwielded_mod = 0
		scatter_unwielded_mod = 0
		icon_state = "m7_stock"
		attach_icon = "m7_stock"
		size_mod = 0
		wield_delay_mod = WIELD_DELAY_NONE //stock is folded so no wield delay
		recoil_unwielded_mod = 0

	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")

/obj/item/attachable/stock/m7/grip
	name = "M7 SMG folding grip"
	desc = "A folding grip that comes standard with the M7 SMG. Folding it up makes it more portable and quicker to wield but as a downside becomes slightly less accurate and has worse scatter."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_attachments.dmi'
	icon_state = "m7_grip"
	attach_icon = "m7_grip-on"
	flags_attach_features = ATTACH_ACTIVATION
	collapsible = TRUE
	stock_activated = FALSE
	collapse_delay  = 0.5 SECONDS
	attachment_action_type = /datum/action/item_action/toggle
	slot = "under"

/obj/item/attachable/stock/m7/grip/New()
	..()

	accuracy_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	scatter_unwielded_mod = 0
	wield_delay_mod = 0
	recoil_unwielded_mod = 0
	size_mod = 0
	icon_state = "m7_grip-on"
	attach_icon = "m7_grip-on"

/obj/item/attachable/stock/m7/grip/apply_on_weapon(obj/item/weapon/gun/gun)
	if(stock_activated)
		//folded down
		accuracy_mod = HIT_ACCURACY_MULT_TIER_2
		scatter_mod = -SCATTER_AMOUNT_TIER_9
		movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
		accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
		scatter_unwielded_mod = SCATTER_AMOUNT_TIER_7
		recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
		icon_state = "m7_grip"
		attach_icon = "m7_grip"
		wield_delay_mod = WIELD_DELAY_NONE
		size_mod = 1

	else
		accuracy_mod = 0
		recoil_mod = 0
		scatter_mod = 0
		movement_onehanded_acc_penalty_mod = 0
		accuracy_unwielded_mod = 0
		scatter_unwielded_mod = 0
		icon_state = "m7_grip-on"
		attach_icon = "m7_grip-on"
		wield_delay_mod = 0 //stock is folded up so no wield delay
		recoil_unwielded_mod = 0
		size_mod = 0

	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "under")

/obj/item/attachable/stock/m7/grip/folded_down
	stock_activated = TRUE
	attach_icon = "m7_grip"

/obj/item/attachable/stock/m7/grip/folded_down/New()
	..()

	accuracy_mod = HIT_ACCURACY_MULT_TIER_2
	scatter_mod = -SCATTER_AMOUNT_TIER_9
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_7
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	icon_state = "m7_grip"
	attach_icon = "m7_grip"
	wield_delay_mod = WIELD_DELAY_NONE
	size_mod = 1


//========== PISTOL BELTS ==========
/obj/item/storage/belt/gun/m6
	name = "\improper M6 general pistol holster rig"
	desc = "The M276 is the standard load-bearing equipment of the UNSC. It consists of a modular belt with various clips. This version has a holster assembly that allows one to carry the most common pistols. It also contains side pouches that can store most pistol magazines."
	icon = 'icons/halo/obj/items/clothing/belts/belts_by_faction/belt_unsc.dmi'
	icon_state = "m6_holster"
	item_state = "s_marinebelt"
	item_icons = list(
		WEAR_WAIST = 'icons/halo/mob/humans/onmob/clothing/belts/belts_by_faction/belt_unsc.dmi',
		WEAR_J_STORE = 'icons/halo/mob/humans/onmob/clothing/suit_storage/suit_storage_by_faction/suit_slot_unsc.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_1.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_1.dmi')
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/pistol/halo,
		/obj/item/ammo_magazine/pistol/halo,
	)
	gun_has_gamemode_skin = FALSE
	holster_slots = list(
		"1" = list(
			"icon_x" = -5,
			"icon_y" = 0))

/obj/item/storage/belt/gun/m6/full_m6c/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/halo/m6c())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/halo/m6c(src)

/obj/item/storage/belt/gun/m6/full_m6g/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/halo/m6g())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/halo/m6g(src)

/obj/item/storage/belt/gun/m6/full_m6c/m4a/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/halo/m6c/m4a())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/halo/m6c(src)

/obj/item/storage/belt/gun/m6/full_m6a/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/halo/m6a())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/halo/m6a(src)
//========== SPECIAL BELTS ==========

/obj/item/storage/belt/gun/m7
	name = "\improper M7 holster rig"
	desc = "Special issue M7 holster rig, uncommonly issued to UNSC support and specialist personnel as a PDW."
	icon = 'icons/halo/obj/items/clothing/belts/belts_by_faction/belt_unsc.dmi'
	icon_state = "m7_holster"
	item_state = "s_marinebelt"
	storage_slots = 3
	max_w_class = 6
	can_hold = list(
		/obj/item/weapon/gun/smg/halo/m7,
		/obj/item/ammo_magazine/smg/halo/m7,
	)
	holster_slots = list(
		"1" = list(
			"icon_x" = 0,
			"icon_y" = 0))
	item_icons = list(
		WEAR_WAIST = 'icons/halo/mob/humans/onmob/clothing/belts/belts_by_faction/belt_unsc.dmi',
		WEAR_J_STORE = 'icons/halo/mob/humans/onmob/clothing/suit_storage/suit_storage_by_faction/suit_slot_unsc.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_1.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_1.dmi')

/obj/item/storage/belt/gun/m7/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/halo/m7/folded_up())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/smg/halo/m7(src)

/obj/item/storage/belt/gun/m7/full/socom/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/halo/m7/socom/folded_up())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/smg/halo/m7(src)
//========== POUCHES ==========

/obj/item/storage/pouch/pistol/unsc
	name = "\improper M6 pistol holster"
	icon = 'icons/halo/obj/items/clothing/pouches.dmi'
	icon_state = "m6"
	icon_x = 5
	icon_y = 0
	can_hold = list(
		/obj/item/weapon/gun/pistol/halo,
		/obj/item/ammo_magazine/pistol/halo,
	)

/obj/item/storage/pouch/magazine/pistol/unsc
	name = "pistol magazine pouch"
	icon = 'icons/halo/obj/items/clothing/pouches.dmi'
	icon_state = "pistolmag"
	can_hold = list(/obj/item/ammo_magazine/pistol/halo)

/obj/item/storage/pouch/magazine/pistol/unsc/large
	name = "large pistol magazine pouch"
	icon_state = "pistolmag_large"
	storage_slots = 6

//========== BACKPACKS ==========

/obj/item/storage/backpack/marine/satchel/rto/unsc
	name = "UNSC radio backpack"
	icon = 'icons/halo/obj/items/clothing/back/back_by_faction/back_unsc.dmi'
	icon_state = "radiopack"
	item_state = "radiopack"
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/back_by_faction/back_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi')
	networks_receive = list(FACTION_MARINE)
	networks_transmit = list(FACTION_MARINE)
	phone_category = PHONE_MARINE
	flags_atom = FPRINT|NO_GAMEMODE_SKIN

/obj/item/storage/backpack/marine/satchel/unsc
	name = "UNSC buttpack"
	desc = "A standard-issue buttpack for the infantry of the UNSC."
	icon = 'icons/halo/obj/items/clothing/back/back_by_faction/back_unsc.dmi'
	icon_state = "buttpack"
	item_state = "buttpack"
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/back_by_faction/back_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi')
	flags_atom = FPRINT|NO_GAMEMODE_SKIN

/obj/item/storage/backpack/marine/unsc
	name = "UNSC rucksack"
	desc = "A large tan rucksack that attaches directly to the M52B armor's attachment points. Standard issue, used by just about every UNSC branch since the 25th century."
	icon = 'icons/halo/obj/items/clothing/back/back_by_faction/back_unsc.dmi'
	icon_state = "rucksack"
	item_state = "rucksack"
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/back_by_faction/back_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi')
	flags_atom = FPRINT|NO_GAMEMODE_SKIN

/obj/item/storage/backpack/marine/ammo_rack/spnkr
	name = "SPNKr tube storage backpack"
	desc = "Two individual cloth bags, each capable of storing one M19 twin-tube unit for the M41 SPNKr."
	icon = 'icons/halo/obj/items/clothing/back/back_by_faction/back_unsc.dmi'
	icon_state = "spnkrpack_0"
	base_icon_state = "spnkrpack"
	item_state = "spnkrpack"
	storage_slots = 2
	can_hold = list(/obj/item/ammo_magazine/spnkr)
	item_icons = list(
		WEAR_BACK = 'icons/halo/mob/humans/onmob/clothing/back/back_by_faction/back_unsc.dmi',
		WEAR_L_HAND = 'icons/halo/mob/humans/onmob/items_lefthand_halo.dmi',
		WEAR_R_HAND = 'icons/halo/mob/humans/onmob/items_righthand_halo.dmi')
	flags_atom = FPRINT|NO_GAMEMODE_SKIN
	bypass_w_limit = list(/obj/item/ammo_magazine/spnkr)

/obj/item/storage/backpack/marine/ammo_rack/spnkr/filled/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/spnkr(src)
	update_icon()

//========== BOXES ==========

/obj/item/storage/unsc_speckit
	name = "UNSC specialist kit box"
	desc = "An unlabeled, unmarked specialist equipment box. You can only wonder as to what the contents are."
	icon = 'icons/halo/obj/items/storage/spec_kits.dmi'
	icon_state = "template"
	var/open_state = "template_o"
	var/icon_full = "template" //icon state to use when kit is full
	var/possible_icons_full
	can_hold = list()
	max_w_class = SIZE_MASSIVE
	storage_flags = STORAGE_FLAGS_BOX

/obj/item/storage/unsc_speckit/Initialize()
	. = ..()

	if(possible_icons_full)
		icon_full = pick(possible_icons_full)
	else
		icon_full = initial(icon_state)

	update_icon()

/obj/item/storage/unsc_speckit/update_icon()
	if(content_watchers || !length(contents))
		icon_state = open_state
	else
		icon_state = icon_full

/obj/item/storage/unsc_speckit/attack_self(mob/living/user)
	..()

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.swap_hand()
		open(user)

/obj/item/storage/unsc_speckit/spnkr
	name = "SPNKr equipment case"
	desc = "A case containing the essentials for a UNSC weapons specialist. This one has the emblem of a SPNKr on its lid."
	icon_state = "spnkr"
	open_state = "spnkr_o"
	icon_full = "spnkr"
	can_hold = list(/obj/item/ammo_magazine/spnkr, /obj/item/storage/backpack/marine/ammo_rack/spnkr, /obj/item/weapon/gun/halo_launcher/spnkr)
	storage_slots = 5

/obj/item/storage/unsc_speckit/spnkr/fill_preset_inventory()
	new /obj/item/ammo_magazine/spnkr(src)
	new /obj/item/ammo_magazine/spnkr(src)
	new /obj/item/ammo_magazine/spnkr(src)
	new /obj/item/storage/backpack/marine/ammo_rack/spnkr(src)
	new /obj/item/weapon/gun/halo_launcher/spnkr/unloaded(src)

/obj/item/storage/unsc_speckit/srs99
	name = "SRS99-AM equipment case"
	desc = "A case containing the essentials for a UNSC weapons specialist. This one has the emblem of an SRS99-AM on its lid."
	icon_state = "srs99"
	open_state = "srs99_o"
	icon_full = "srs99"
	can_hold = list(/obj/item/weapon/gun/rifle/sniper/halo/unloaded, /obj/item/ammo_magazine/rifle/halo/sniper)
	storage_slots = 7

/obj/item/storage/unsc_speckit/srs99/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/sniper/halo/unloaded(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)
	new /obj/item/ammo_magazine/rifle/halo/sniper(src)

// rifle ammo

/datum/ammo/bullet/rifle/ma5c
	name = "FMJ bullet"

/datum/ammo/bullet/rifle/ma5c/shredder
	name = "shredder bullet"
	damage = 30
	penetration = ARMOR_PENETRATION_TIER_8

/datum/ammo/bullet/rifle/ma3a
	name = "FMJ bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	damage = 35
	penetration = ARMOR_PENETRATION_TIER_2

/datum/ammo/bullet/rifle/vk78
	name = "FMJ bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	damage = 35
	penetration = ARMOR_PENETRATION_TIER_1
	accurate_range = 14
	scatter = SCATTER_AMOUNT_TIER_7
	shell_speed = AMMO_SPEED_TIER_5
	damage_falloff = DAMAGE_FALLOFF_TIER_5
	max_range = 22

/datum/ammo/bullet/rifle/br55
	name = "X-HP SAP-HE bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	penetration = ARMOR_PENETRATION_TIER_3
	accurate_range = 16
	scatter = SCATTER_AMOUNT_TIER_10
	shell_speed = 1.5*AMMO_SPEED_TIER_6
	effective_range_max = 16

/datum/ammo/bullet/rifle/dmr
	name = "FMJ bullet"
	headshot_state = HEADSHOT_OVERLAY_HEAVY
	damage = 55
	penetration = ARMOR_PENETRATION_TIER_4
	accurate_range = 24
	scatter = SCATTER_AMOUNT_TIER_10
	shell_speed = AMMO_SPEED_TIER_6
	effective_range_max = 12
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	max_range = 36

// smg ammo
/datum/ammo/bullet/smg/m7
	name = "5×23mm M443 FMJ"
	penetration = 0
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_1
	scatter = SCATTER_AMOUNT_TIER_8
	accuracy = HIT_ACCURACY_TIER_4

// shotgun ammo

/datum/ammo/bullet/shotgun/buckshot/unsc
	name = "MAG 15P-00B"
	handful_state = "buckshot_shell"
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/spread/unsc

/datum/ammo/bullet/shotgun/spread/unsc
	name = "additional buckshot, USCM special type"

/datum/ammo/bullet/shotgun/beanbag/unsc
	name = "MAG LLHB"
	handful_state = "8g_beanbag"
	accurate_range = 10
	max_range = 10
	stamina_damage = 75
	damage = 35

// rocket ammo

/datum/ammo/rocket/spnkr
	name = "M19 missile"
	icon = 'icons/halo/obj/items/weapons/halo_projectiles.dmi'
	icon_state = "spnkr_missile"
	damage = 200
	shell_speed = AMMO_SPEED_TIER_6
	accuracy = HIT_ACCURACY_TIER_4
	accurate_range = 14
	max_range = 14


// sniper ammo

/datum/ammo/bullet/rifle/srs99
	name = "APFSDS bullet"
	headshot_state = HEADSHOT_OVERLAY_HEAVY
	damage = 200
	penetration = ARMOR_PENETRATION_TIER_8
	accurate_range = 24
	accuracy = HIT_ACCURACY_TIER_10
	scatter = SCATTER_AMOUNT_TIER_10
	effective_range_max = 24
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	max_range = 48
	shell_speed = AMMO_SPEED_TIER_6 + AMMO_SPEED_TIER_2

// pistol ammo

/datum/ammo/bullet/pistol/magnum
	name = "SAP-HE bullet"
	headshot_state = HEADSHOT_OVERLAY_HEAVY
	accuracy = HIT_ACCURACY_TIER_4
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	damage = 40
	penetration= ARMOR_PENETRATION_TIER_2
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

/datum/ammo/energy/plasma
	name = "plasma bolt"
	icon = 'icons/halo/obj/items/weapons/halo_projectiles.dmi'
	shell_speed = AMMO_SPEED_TIER_3
	flags_ammo_behavior = AMMO_BALLISTIC
	sound_hit = "plasma_impact"
	sound_miss = "plasma_miss"

/datum/ammo/energy/plasma/plasma_pistol
	name = "light plasma bolt"
	icon_state = "plasma_teal"
	accurate_range = 10
	max_range = 20
	damage = 28
	accuracy = HIT_ACCURACY_TIER_3
	scatter = SCATTER_AMOUNT_TIER_10

/datum/ammo/energy/plasma/plasma_pistol/overcharge
	name = "overcharged light plasma bolt"
	damage = 80
	shell_speed = AMMO_SPEED_TIER_4

/datum/ammo/energy/plasma/plasma_rifle
	name = "plasma bolt"
	icon_state = "plasma_blue"
	shell_speed = AMMO_SPEED_TIER_4
	accurate_range = 14
	max_range = 24
	damage = 38

/datum/ammo/bullet/rifle/carbine
	name = "carbine bullet"
	icon = 'icons/halo/obj/items/weapons/halo_projectiles.dmi'
	icon_state = "carbine"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	damage = 50
	penetration = ARMOR_PENETRATION_TIER_3
	accurate_range = 24
	scatter = SCATTER_AMOUNT_TIER_10
	shell_speed = 1.5*AMMO_SPEED_TIER_6
	effective_range_max = 24
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	max_range = 32
	shrapnel_chance = null


/obj/structure/magazine_box/unsc
	icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	icon_state = "base"
	text_markings_icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/text.dmi'
	magazines_icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/magazines.dmi'



//-----------------------Halo Boxes-----------------------

/obj/item/ammo_box/magazine/misc/unsc
	name = "\improper UNSC storage crate"
	desc = "A generic storage crate for the UNSC. Looks like it holds...nothing? You shouldn't be seeing this..."
	icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	magazines_icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/magazines.dmi'
	icon_state = "base"
	magazine_type = null
	limit_per_tile = 1
	num_of_magazines = 0
	overlay_content = null
	deployed_object = /obj/structure/magazine_box/unsc

/obj/item/ammo_box/magazine/misc/unsc/mre
	name = "\improper UNSC storage crate - (MRE x 14)"
	desc = "A generic storage crate for the UNSC holding MREs."
	icon_state = "base_mre"
	magazine_type = /obj/item/storage/box/mre
	num_of_magazines = 14
	overlay_content = "_mre"

/obj/item/ammo_box/magazine/misc/unsc/mre/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/flare
	name = "\improper UNSC storage crate  (Flares x 14)"
	desc = "A generic storage crate for the UNSC holding flares."
	icon_state = "base_flare"
	magazine_type = /obj/item/storage/box/m94
	num_of_magazines = 14
	overlay_content = "_flare"

/obj/item/ammo_box/magazine/misc/unsc/flare/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/flare/signal
	name = "\improper UNSC storage crate - (Signal Flares x 14)"
	desc = "A generic storage crate for the UNSC holding signal flares."
	icon_state = "base_flare"
	magazine_type = /obj/item/storage/box/m94/signal
	num_of_magazines = 14
	overlay_content = "_signal"

/obj/item/ammo_box/magazine/misc/unsc/flare/signal/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/grenade
	name = "\improper UNSC storage crate - (Grenades x 9)"
	desc = "A generic storage crate for the UNSC holding fragmentation grenades."
	icon_state = "base_frag"
	magazine_type = /obj/item/explosive/grenade/high_explosive/unsc
	num_of_magazines = 9
	overlay_content = "_frag"

/obj/item/ammo_box/magazine/misc/unsc/grenade/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/grenade/launchable
	name = "\improper UNSC storage crate - (40mm Grenades x 30)"
	desc = "A generic storage crate for the UNSC holding 40MM grenades."
	icon_state = "base_40mm"
	magazine_type = /obj/item/explosive/grenade/high_explosive/unsc/launchable
	num_of_magazines = 30
	overlay_content = "_40mm"

/obj/item/ammo_box/magazine/misc/unsc/grenade/launchable/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/medical_packets
	name = "\improper UNSC storage crate - (First Aid Packets x 10)"
	desc = "A generic storage crate for the UNSC holding MREs."
	icon_state = "base_medpack"
	magazine_type = /obj/item/storage/box/tear_packet/medical_packet
	num_of_magazines = 10
	overlay_content = "_medpack"

/obj/item/ammo_box/magazine/misc/unsc/medical_packets/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/unsc/m7_ammo
	name = "UNSC storage crate - (M7 Magazine Packets x 16)"
	desc = "A generic UNSC storage crate for holding M7 magazine packets."
	magazine_type = /obj/item/storage/box/tear_packet/m7
	num_of_magazines = 16
	overlay_content = "_riflepack"

/obj/item/ammo_box/magazine/misc/unsc/m7_ammo/empty
	empty = TRUE

//-----------------------Halo Mag Box-----------------------

/obj/item/ammo_box/magazine/unsc
	name = "UNSC magazine box"
	desc = "A generic ammo box for UNSC weapons."
	icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	icon_state = "base_ammo"
	magazines_icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/magazines.dmi'
	text_markings_icon = 'icons/halo/obj/items/weapons/guns/ammo_boxes/text.dmi'
	limit_per_tile = 1
	deployed_object = /obj/structure/magazine_box/unsc

/obj/item/ammo_box/magazine/unsc/ma5c
	name = "UNSC magazine box (MA5C x 48)"
	desc = "An ammo box storing 48 magazines of MA5C ammunition"
	icon_state = "base_ammo"
	overlay_gun_type = "_ma5c"
	magazine_type = /obj/item/ammo_magazine/rifle/halo/ma5c
	num_of_magazines = 48

/obj/item/ammo_box/magazine/unsc/ma5c/shredder
	name = "UNSC magazine box (MA5C x 24, AP shredder)"
	desc = "An ammo box storing 24 magazines of MA5C ammunition"
	overlay_ammo_type = "_shred"
	magazine_type = /obj/item/ammo_magazine/rifle/halo/ma5c/shredder
	num_of_magazines = 24

/obj/item/ammo_box/magazine/unsc/br55
	name = "UNSC magazine box (BR55 x 32)"
	desc = "An ammo box storing 32 magazines of BR55 ammunition"
	icon_state = "base_ammo"
	overlay_gun_type = "_br55"
	magazine_type = /obj/item/ammo_magazine/rifle/halo/br55
	num_of_magazines = 32

/obj/item/ammo_box/magazine/unsc/br55/extended
	name = "UNSC magazine box (BR55 x 32, extended)"
	desc = "An ammo box storing 32 magazines of BR55 ammunition"
	overlay_ammo_type = "_ext"
	magazine_type = /obj/item/ammo_magazine/rifle/halo/br55/extended

/obj/item/ammo_box/magazine/unsc/small
	name = "UNSC magazine box"
	icon_state = "base_ammosmall"
	limit_per_tile = 2
	overlay_gun_type = null
	overlay_content = "_small"

/obj/item/ammo_box/magazine/unsc/small/m6c
	name = "UNSC magazine box (M6C x 22)"
	desc = "An ammo box storing 22 magazines of M6C ammunition."
	icon_state = "base_ammosmall"
	magazine_type = /obj/item/ammo_magazine/pistol/halo/m6c
	num_of_magazines = 22

/obj/item/ammo_box/magazine/unsc/small/m6c/socom
	name = "UNSC magazine box (M6C/SOCOM x 22)"
	desc = "An ammo box storing 22 magazines of M6C/SOCOM ammunition."
	overlay_ammo_type = "_extsmall"
	magazine_type = /obj/item/ammo_magazine/pistol/halo/m6c/socom

/obj/item/ammo_box/magazine/unsc/small/m6g
	name = "UNSC magazine box (M6G x 22)"
	desc = "An ammo box storing 22 magazines of M6G ammunition."
	icon_state = "base_ammosmall2"
	magazine_type = /obj/item/ammo_magazine/pistol/halo/m6g
	num_of_magazines = 22

//===========================//CUSTOM ARMOR WEBBING\\================================\\

/obj/item/clothing/accessory/storage/webbing/m52b
	name = "\improper M52B Pattern Webbing"
	desc = "A sturdy mess of synthcotton belts and buckles designed to attach to the M52B body armor armor standard for the UNSC. This one is the slimmed down model designed for general purpose storage."
	icon = 'icons/halo/obj/items/clothing/accessories/accessories.dmi'
	icon_state = "m52b_webbing"
	hold = /obj/item/storage/internal/accessory/webbing/m3generic
	worn_accessory_slot = ACCESSORY_SLOT_M3UTILITY
	flags_atom = NO_GAMEMODE_SKIN
	accessory_icons = list(WEAR_BODY = 'icons/halo/mob/humans/onmob/clothing/accessories/accessories.dmi', WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/accessories/accessories.dmi')

/obj/item/clothing/accessory/storage/webbing/m52b/Initialize(mapload)
	. = ..()


/obj/item/storage/internal/accessory/webbing/m3generic
	cant_hold = list(
		/obj/item/ammo_magazine/handful/shotgun,
		/obj/item/ammo_magazine/rifle,
	)

/obj/item/clothing/accessory/storage/webbing/m52b/mag
	name = "\improper M52B Pattern Magazine Webbing"
	desc = "A variant of the M52B pattern webbing that features pouches for pulse rifle magazines."
	icon_state = "m52b_magwebbing"
	hold = /obj/item/storage/internal/accessory/webbing/m3mag

/obj/item/storage/internal/accessory/webbing/m3mag
	storage_slots = 3
	can_hold = list(
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight/flare,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
	)

//Partial Pre-load For Props

/obj/item/clothing/accessory/storage/webbing/m52b/mag/ma5c
	hold = /obj/item/storage/internal/accessory/webbing/m3mag/ma5c

/obj/item/storage/internal/accessory/webbing/m3mag/ma5c/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/halo/ma5c(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5c(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5c(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5c(src)
	new /obj/item/ammo_magazine/rifle/halo/ma5c(src)

//===

/obj/item/clothing/accessory/storage/webbing/m52b/shotgun
	name = "\improper M52B Pattern Shell Webbing"
	desc = "A slightly modified variant of the M52B pattern webbing, fitted for 12 gauge shotgun shells."
	icon_state = "m52b_shotgunwebbing"
	hold = /obj/item/storage/internal/accessory/black_vest/m3shotgun

/obj/item/storage/internal/accessory/black_vest/m3shotgun
	can_hold = list(
		/obj/item/ammo_magazine/handful,
	)

/obj/item/clothing/accessory/storage/webbing/m52b/small
	name = "\improper M52B Pattern Small Pouch Webbing"
	desc = "A set of M52B pattern webbing fully outfitted with pouches and pockets to carry a while array of small items."
	icon_state = "m52b_smallwebbing"
	hold = /obj/item/storage/internal/accessory/black_vest/m3generic
	worn_accessory_slot = ACCESSORY_SLOT_M3UTILITY

/obj/item/storage/internal/accessory/black_vest/m3generic
	cant_hold = list(
		/obj/item/ammo_magazine/handful/shotgun,
	)

/obj/item/clothing/accessory/storage/webbing/m52b/grenade
	name = "\improper M52B Pattern Grenade Webbing"
	desc = "A variation of the M52B pattern webbing fitted with loops for storing M40 grenades."
	icon_state = "m52b_grenadewebbing"
	hold = /obj/item/storage/internal/accessory/black_vest/m3grenade

/obj/item/storage/internal/accessory/black_vest/m3grenade
	storage_slots = 5
	can_hold = list(
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/smokebomb,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/slug/baton,
	)

/obj/item/clothing/accessory/storage/webbing/m52b/grenade/m9_frag
	hold = /obj/item/storage/internal/accessory/black_vest/m3grenade/unsc

/obj/item/storage/internal/accessory/black_vest/m3grenade/unsc/fill_preset_inventory()
	new /obj/item/explosive/grenade/high_explosive/unsc(src)
	new /obj/item/explosive/grenade/high_explosive/unsc(src)
	new /obj/item/explosive/grenade/high_explosive/unsc(src)
	new /obj/item/explosive/grenade/high_explosive/unsc(src)
	new /obj/item/explosive/grenade/high_explosive/unsc(src)

/obj/item/clothing/accessory/storage/webbing/m52b/recon
	name = "\improper M52B-R Pattern Magazine Webbing"
	desc = "A set of magazine webbing made in an alternative configuration for standard M3 Pattern armor. This one is exclusively issued to Force Reconnoissance units."
	icon_state = "m52b_r_webbing"
	hold = /obj/item/storage/internal/accessory/webbing/m3mag/recon

/obj/item/storage/internal/accessory/webbing/m3mag/recon
	storage_slots = 4

//===========================//CUSTOM ARMOR COSMETIC PLATES\\================================\\

/obj/item/clothing/accessory/pads
	name = "\improper M52B Shoulder Pads"
	desc = "A set shoulder pads attachable to the M52B armor set worn by the UNSC."
	icon = 'icons/halo/obj/items/clothing/accessories/accessories.dmi'
	icon_state = "pads"
	item_state = "pads"
	worn_accessory_slot = ACCESSORY_SLOT_DECORARMOR
	flags_atom = NO_GAMEMODE_SKIN
	accessory_icons = list(WEAR_BODY = 'icons/halo/mob/humans/onmob/clothing/accessories/accessories.dmi', WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/accessories/accessories.dmi')

/obj/item/clothing/accessory/pads/Initialize(mapload)
	. = ..()

/obj/item/clothing/accessory/pads/bracers
	name = "\improper M52B Arm Bracers"
	desc = "A set arm bracers worn in conjunction to the M52B body armor of the UNSC."
	icon_state = "bracers"
	item_state = "bracers"
	worn_accessory_slot = ACCESSORY_SLOT_DECORBRACER
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/accessory/pads/bracers/police
	name = "\improper Police Shoulder Bracers"
	desc = "A set arm bracers worn in conjunction to an armoured vest, commonly issued to Police forces."
	icon_state = "bracers_police"
	item_state = "bracers_police"

/obj/item/clothing/accessory/pads/neckguard
	name = "\improper M52B Neck Guard"
	desc = "An attachable neck guard option for the M52B body armor worn by the UNSC."
	icon_state = "neckguard"
	item_state = "neckguard"
	worn_accessory_slot = ACCESSORY_SLOT_DECORNECK
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/accessory/pads/neckguard/police
	name = "\improper Police Neck Guard"
	desc = "An attachable neck guard option for basic ballistic vests, commonly issued to the Police."
	icon_state = "neckguard_police"
	item_state = "neckguard_police"

/obj/item/clothing/accessory/pads/greaves
	name = "\improper M52B Shin Guards"
	desc = "A set shinguards designed to be worn in conjuction with M52B body armor."
	icon_state = "shinguards"
	item_state = "shinguards"
	worn_accessory_slot = ACCESSORY_SLOT_DECORSHIN
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/accessory/pads/groin
	name = "\improper M52B Groin Plate"
	desc = "A plate designed to attach to M52B body armor to protect the babymakers of the Corps. Standardized protection of the UNSC often seen worn more often than not."
	icon_state = "groinplate"
	item_state = "groinplate"
	worn_accessory_slot = ACCESSORY_SLOT_DECORGROIN
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/accessory/pads/groin/police
	name = "\improper Police Groin Plate"
	desc = "A plate designed to attach to an armoured Vest to protect the babymakers. Most commonly attached to Police Vests."
	icon_state = "groinplate_police"
	item_state = "groinplate_police"

/obj/item/clothing/accessory/pads/insurrection
	icon_state = "pads_insurgent"
	item_state = "pads_insurgent"

/obj/item/clothing/accessory/pads/bracers/insurrection
	icon_state = "bracers_insurgent"
	item_state = "bracers_insurgent"

/obj/item/clothing/accessory/pads/neckguard/insurrection
	icon_state = "neckguard_insurgent"
	item_state = "neckguard_insurgent"

/obj/item/clothing/accessory/pads/greaves/insurrection
	icon_state = "shinguards_insurgent"
	item_state = "shinguards_insurgent"

/obj/item/clothing/accessory/pads/groin/insurrection
	icon_state = "groinplate_insurgent"
	item_state = "groinplate_insurgent"

/obj/item/clothing/accessory/pads/odst
	name = "\improper M70DT Shoulder Pads"
	desc = "A set shoulder pads attachable to the M70DT armor set worn by the ODSTs."
	icon_state = "odst_pads"
	item_state = "odst_pads"

/obj/item/clothing/accessory/pads/bracers/odst
	name = "\improper M70DT Bracers"
	desc = "A set arm bracers worn in conjunction to the M70DT body armor of the ODSTs."
	icon_state = "odst_bracers"
	item_state = "odst_bracers"

/obj/item/clothing/accessory/pads/greaves/odst
	name = "\improper M70DT Greaves"
	desc = "A set greaves designed to be worn in conjuction with M70DT body armor."
	icon_state = "odst_shinguards"
	item_state = "odst_shinguards"

/obj/item/clothing/accessory/pads/groin/odst
	name = "\improper M70DT Groin Plate"
	desc = "A plate designed to attach to M70DT body armor to protect the babymakers of the Corps. Standardized protection of the ODSTs often seen worn more often than not."
	icon_state = "odst_groinplate"
	item_state = "odst_groinplate"


/obj/item/clothing/under/marine/odst
	name = "ODST bodyglove"
	icon = 'icons/halo/obj/items/clothing/undersuit.dmi'
	icon_state = "odst"
	worn_state = "odst"
	flags_jumpsuit = null
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_BODY = 'icons/halo/mob/humans/onmob/clothing/uniforms.dmi')

/obj/item/clothing/suit/marine/unsc
	name = "\improper M52B body armor"
	desc = "Standard-issue to the UNSC Marine Corps, the M52B armor entered service by 2531 for use in the Human Covenant war, coming with improved protection against plasma-based projectiles compared to older models."
	icon = 'icons/halo/obj/items/clothing/suits/suits_by_faction/suit_unsc.dmi'
	icon_state = "m52b"
	item_state = "m52b"
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_bodypart_hidden = BODY_FLAG_CHEST
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	blood_overlay_type = "armor"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_LIGHT
	siemens_coefficient = 0.7
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	item_icons = list(
		WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/suits/suits_by_faction/suit_unsc.dmi')
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO)
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/prop/prop_gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/storage/bible,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/type47,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/belt/gun/flaregun,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
		/obj/item/storage/belt/gun/m39,
		/obj/item/storage/belt/gun/xm51,
		/obj/item/storage/belt/gun/m6,
		/obj/item/storage/belt/gun/m7,
		/obj/item/weapon/gun/halo_launcher/spnkr
	)

/obj/item/clothing/suit/marine/unsc/police
	name = "\improper police RD90 ballistic armor"
	desc = "An older model of the M52B body armor, designated as the RD90 by local police and security forces. Whilst not as comfortable, it still does the job for most of it's users, and has added protection against melee attacks."
	icon = 'icons/halo/obj/items/clothing/suits/suits_by_faction/suit_unsc.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO)
	icon_state = "police"
	item_state = "police"
	item_icons = list(
		WEAR_JACKET = 'icons/halo/mob/humans/onmob/clothing/suits/suits_by_faction/suit_unsc.dmi')
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW

/obj/item/clothing/suit/marine/unsc/insurrection
	icon_state = "insurgent"
	item_state = "insurgent"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW

/obj/item/clothing/suit/marine/unsc/odst
	name = "\improper M70DT ODST BDU"
	desc = "The sum total of the ODST's armour complex, simply called 'Battle-Dress-Uniform'. Designed for several environments, be it in vacuum with its 30 minutes of air, in the racket of a SOEIV or the clamour of a battlefield; this BDU is ready for it all. Consists of heat-dispersing and vacuum rated body glove, and the armour worn over it, which reflects heat and bullets quite well. Do not test shock absorption for recreation."
	icon_state = "odst"
	item_state = "odst"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH

/obj/item/clothing/head/helmet/marine/unsc
	name = "\improper CH252 helmet"
	desc = "Standard-issue helmet to the UNSC Marine Corps. Various attachment points on the helmet allow for various equipment to be fitted to the helmet."
	icon = 'icons/halo/obj/items/clothing/hats/hats_by_faction/hat_unsc.dmi'
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	built_in_visors = null
	start_down_visor_type = null
	item_icons = list(
		WEAR_HEAD = 'icons/halo/mob/humans/onmob/clothing/hats/hats_by_faction/hat_unsc.dmi'
	)

/obj/item/clothing/head/helmet/marine/unsc/pilot
	name = "\improper FH252 helmet"
	desc = "The typical helmet found used by most UNSC pilots due to it's fully enclosed nature, particularly preferred by pilots in combat situations where their cockpit may end up breached."
	icon_state = "pilot"
	item_state = "pilot"
	flags_atom = ALLOWINTERNALS|NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE|BLOCKGASEFFECT|ALLOWREBREATH|ALLOWCPR

/obj/item/clothing/head/helmet/marine/unsc/police
	name = "\improper police CH252 helmet"
	desc = "Standard-issue helmet to the UNSC Marine Corps, this one given to the local police and security forces across the colonies for riot suppression during the days of the insurrection."
	icon_state = "police"
	item_state = "police"

/obj/item/clothing/head/helmet/marine/unsc/insurrection
	icon_state = "insurgent"
	item_state = "insurgent"

/obj/item/clothing/head/helmet/marine/unsc/odst
	name = "\improper CH381 ODST helmet"
	desc = "An iconic helmet, designed for use by Orbital-Drop-Shock-Troopers of the UNSC's Marine Corps' Special Forces. An advanced piece of equipment featuring various benefits: a polarizing visor, VISR optical software, reinforced COM unit, fully sealed environment and a nice black finish. Commonly defaced with crude graffiti by bored helljumpers."
	icon_state = "odst"
	item_state = "odst"
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH

/obj/item/clothing/glasses/sunglasses/big/unsc
	name = "\improper UNSC shooting shades"
	desc = "A pair of standard-issue shades. Some models come with an in-built HUD system, this one evidently does not."
	icon = 'icons/halo/obj/items/clothing/glasses/glasses.dmi'
	icon_state = "hudglasses"
	item_state = "hudglasses"
	item_icons = list(
		WEAR_EYES = 'icons/halo/mob/humans/onmob/clothing/eyes.dmi',
		WEAR_FACE = 'icons/halo/mob/humans/onmob/clothing/eyes.dmi'
		)

//---------UNSC---------

/obj/item/storage/firstaid/unsc
	name = "UNSC health pack"
	desc = "First-class military medical aid is typically found in these octogon-shaped health packs."
	icon = 'icons/halo/obj/items/storage/medical.dmi'
	icon_state = "healthpack"
	empty_icon = "healthpack_empty"
	has_overlays = FALSE
	storage_slots = 8

/obj/item/storage/firstaid/unsc/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless(src)

/obj/item/storage/firstaid/unsc/corpsman/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless(src)

/obj/item/storage/box/tear_packet
	name = "packet"
	desc = "A plastic packet."
	icon = 'icons/halo/obj/items/storage/packets.dmi'
	icon_state = "ammo_packet"
	w_class = SIZE_SMALL
	can_hold = list()
	storage_slots = 3
	use_sound = "rip"
	var/isopened = FALSE

/obj/item/storage/box/tear_packet/m7
	name = "magazine packet (M7, x2)"
	storage_slots = 2

/obj/item/storage/box/tear_packet/m7/fill_preset_inventory()
	new /obj/item/ammo_magazine/smg/halo/m7(src)
	new /obj/item/ammo_magazine/smg/halo/m7(src)

/obj/item/storage/box/tear_packet/Initialize()
	. = ..()
	isopened = FALSE
	icon_state = "[initial(icon_state)]"
	use_sound = "rip"

/obj/item/storage/box/tear_packet/update_icon()
	if(!isopened)
		isopened = TRUE
		icon_state = "[initial(icon_state)]_o"
		use_sound = "rustle"

/obj/item/storage/box/tear_packet/medical_packet
	name = "UNSC medical packet"
	desc = "A combat-rated first aid medical packet filled with the bare bones basic essentials to ensuring you or your buddies don't die on the battlefield."
	icon_state = "medical_packet"
	storage_slots = 5
	max_w_class = 3
	can_hold = list(
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/splint,
		/obj/item/reagent_container/hypospray/autoinjector/tricord/skillless,
	)

/obj/item/storage/box/tear_packet/medical_packet/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless(src)
