/obj/item/attachable/heavy_barrel
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	delay_mod = FIRE_DELAY_TIER_11
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_7
	var/normal_damage_mod = BULLET_DAMAGE_MULT_TIER_6
	var/shotgun_damage_mod = BULLET_DAMAGE_MULT_TIER_1

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
	shotgun_damage_mod = BULLET_DAMAGE_MULT_TIER_2
