/obj/item/attachable/heavy_barrel
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	delay_mod = FIRE_DELAY_TIER_11
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_7
	var/normal_damage_mod = BULLET_DAMAGE_MULT_TIER_6
	var/shotgun_damage_mod = BULLET_DAMAGE_MULT_TIER_2

/obj/item/attachable/heavy_barrel/Attach(obj/item/weapon/gun/G)
	if(G.gun_category == GUN_CATEGORY_SHOTGUN)
		damage_mod = shotgun_damage_mod
	else
		damage_mod = normal_damage_mod
	..()

/obj/item/attachable/heavy_barrel/upgraded
	name = "upgraded barrel charger"
	desc = "A hyper threaded barrel extender that fits to the muzzle of most firearms. Increases bullet speed and velocity.\nGreatly increases projectile damage at the cost of accuracy and firing speed."
	icon = 'core_ru/icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "ubc"
	attach_icon = "ubc_a"

	delay_mod = FIRE_DELAY_TIER_LMG
	normal_damage_mod = BULLET_DAMAGE_MULT_TIER_8
	shotgun_damage_mod = BULLET_DAMAGE_MULT_TIER_4

/obj/item/attachable/stock/rifle/collapsible/xm52
	name = "\improper XM52 stock"
	desc = "A specialized stock designed for XM52 breaching shotguns. Helps the user absorb the recoil of the weapon while also reducing scatter. Integrated mechanisms inside the stock allow use of a devastating two-shot burst. This comes at a cost of the gun becoming too unwieldy to holster, worse handling and mobility."
	icon = 'core_ru/icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "xm52_folding_a"
	attach_icon = "xm52_folding_a"
	wield_delay_mod = WIELD_DELAY_FAST
	pixel_shift_x = 31
	pixel_shift_y = 15
	hud_offset_mod = 3
	melee_mod = 10
	flags_attach_features = ATTACH_ACTIVATION

/obj/item/attachable/stock/rifle/collapsible/xm52/New()
	..()

	//xm52 stock starts collapsed so we zero out everything
	accuracy_mod = 0
	recoil_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	recoil_unwielded_mod = 0
	scatter_unwielded_mod = 0
	aim_speed_mod = 0

/obj/item/attachable/stock/rifle/collapsible/xm52/apply_on_weapon(obj/item/weapon/gun/gun)
	if(stock_activated)
		. = ..()
		//it makes stuff much better when two-handed
		accuracy_mod = HIT_ACCURACY_MULT_TIER_3
		recoil_mod = -RECOIL_AMOUNT_TIER_4
		scatter_mod = -SCATTER_AMOUNT_TIER_8
		movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
		//but it makes stuff much worse when one handed
		accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_5
		recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
		scatter_unwielded_mod = SCATTER_AMOUNT_TIER_6
		//and makes you slower
		aim_speed_mod = CONFIG_GET(number/slowdown_med)
		icon_state = "xm52_folding_a_on"
		attach_icon = "xm52_folding_a_on"
		pixel_shift_x = 29
		size_mod = 2
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
		icon_state = "xm52_folding_a"
		attach_icon = "xm52_folding_a"
		pixel_shift_x = 31
		size_mod = 1
		wield_delay_mod = WIELD_DELAY_NONE //stock is folded so no wield delay

	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")
