//-------------------------------------------------------

/obj/item/weapon/gun/rifle
	reload_sound = 'sound/weapons/gun_rifle_reload.ogg'
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'

	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	force = 15
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	wield_delay = WIELD_DELAY_NORMAL
	gun_skill_category = SKILL_RIFLES

/obj/item/weapon/gun/rifle/New()
	..()
	if(current_mag && current_mag.current_rounds > 0) load_into_chamber()

/obj/item/weapon/gun/rifle/set_gun_config_values()
	..()
	fire_delay = config.mhigh_fire_delay
	burst_amount = config.med_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.high_hit_accuracy_mult
	scatter = config.med_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil_unwielded = config.high_recoil_value

/obj/item/weapon/gun/rifle/unique_action(mob/user)
	cock(user)


//-------------------------------------------------------
//M41A PULSE RIFLE

/obj/item/weapon/gun/rifle/m41a
	name = "\improper M41A pulse rifle MK2"
	desc = "The standard issue rifle of the Colonial Marines. Commonly carried by most combat personnel. Uses 10x24mm caseless ammunition."
	icon_state = "m41a"
	item_state = "m41a"
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/quickfire,
						/obj/item/attachable/reflex,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/gyro,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/bipod,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/stock/rifle,
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/shotgun,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/scope,
						/obj/item/attachable/scope/mini
						)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade)
	map_specific_decoration = TRUE

/obj/item/weapon/gun/rifle/m41a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/m41a/set_gun_config_values()
	..()
	fire_delay = config.med_fire_delay
	burst_amount = config.med_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult + config.med_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.high_hit_accuracy_mult
	scatter = config.low_scatter_value
	burst_scatter_mult = config.mlow_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil_unwielded = config.high_recoil_value


//variant without ugl attachment
/obj/item/weapon/gun/rifle/m41a/stripped
	starting_attachment_types = list()

//-------------------------------------------------------
//M41A PMC VARIANT

/obj/item/weapon/gun/rifle/m41a/elite
	name = "\improper M41A/2 pulse rifle"
	desc = "A modified version M41A Pulse Rifle MK2, re-engineered for better weight, handling and accuracy. Fires precise two-round bursts. Given only to elite units."
	icon_state = "m41a2"
	item_state = "m41a2"

	current_mag = /obj/item/ammo_magazine/rifle/ap
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WY_RESTRICTED
	aim_slowdown = SLOWDOWN_ADS_SMG
	wield_delay = WIELD_DELAY_FAST
	map_specific_decoration = FALSE
	starting_attachment_types = list()

	random_spawn_chance = 100
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex,
							/obj/item/attachable/flashlight,
							/obj/item/attachable/magnetic_harness,
							)
	random_spawn_underbarrel = list(
							/obj/item/attachable/lasersight,
							)


/obj/item/weapon/gun/rifle/m41a/elite/set_gun_config_values()
	..()
	fire_delay = config.mlow_fire_delay
	burst_amount = config.low_burst_value
	burst_delay = config.min_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult + config.max_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.med_hit_accuracy_mult
	scatter = config.min_scatter_value
	burst_scatter_mult = config.min_scatter_value
	scatter_unwielded = config.high_scatter_value


//-------------------------------------------------------
//M41A TRUE AND ORIGINAL

/obj/item/weapon/gun/rifle/m41aMK1
	name = "\improper M41A pulse rifle"
	desc = "An older design of the Pulse Rifle commonly used by Colonial Marines. Uses 10x24mm caseless ammunition."
	icon_state = "m41amk1" //Placeholder.
	item_state = "m41amk1" //Placeholder.
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1
	attachable_allowed = list(
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/reflex,
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/shotgun)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER

/obj/item/weapon/gun/rifle/m41aMK1/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/m41aMK1/set_gun_config_values()
	..()
	fire_delay = config.mhigh_fire_delay
	burst_amount = config.high_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult - config.min_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.high_hit_accuracy_mult
	scatter = config.med_scatter_value
	burst_scatter_mult = config.med_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil_unwielded = config.high_recoil_value

//----------------------------------------------
//Special gun for the CO to replace the smartgun
//Attachment points need fixing

/obj/item/weapon/gun/rifle/m46c
	name = "\improper M46C pulse rifle"
	desc = "A prototype M46C, an experimental rifle platform built to outperform the standard M41A. Back issue only. Uses standard MK1 & MK2 rifle magazines."
	icon_state = "m46c"
	item_state = "m46c"
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/incendiary
	accepted_ammo = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/rifle/extended,
		/obj/item/ammo_magazine/rifle/incendiary,
		/obj/item/ammo_magazine/rifle/ap,
		/obj/item/ammo_magazine/rifle/m41aMK1
	)
	//somewhere in between the mk1 and mk2
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/scope/mini,
						/obj/item/attachable/scope/mini_iff,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/shotgun)
	// CO rifle is guaranteed kitted out
	random_spawn_chance = 100
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex/,
							/obj/item/attachable/scope/mini_iff,
							/obj/item/attachable/magnetic_harness,
							)
	random_spawn_underbarrel = list(
							/obj/item/attachable/angledgrip,
							/obj/item/attachable/verticalgrip,
							/obj/item/attachable/attached_gun/shotgun,
									)
	random_spawn_muzzle = list(
							/obj/item/attachable/suppressor,
							/obj/item/attachable/bayonet,
							/obj/item/attachable/extended_barrel,
							/obj/item/attachable/heavy_barrel,
								)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER


/obj/item/weapon/gun/rifle/m46c/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/rifle/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.hidden = TRUE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/m46c/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17, "rail_x" = 12, "rail_y" = 18, "under_x" = 24, "under_y" = 12, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/m46c/set_gun_config_values()
	..()
	fire_delay = config.mhigh_fire_delay
	burst_amount = config.mhigh_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult + config.hmed_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.high_hit_accuracy_mult
	scatter = config.low_scatter_value
	burst_scatter_mult = config.low_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult + config.min_hit_damage_mult
	recoil_unwielded = config.high_recoil_value


/obj/item/weapon/gun/rifle/m46c/proc/name_after_co(var/mob/living/carbon/human/H, var/obj/item/weapon/gun/rifle/m46c/I)
	I.desc = "A prototype M46C, an experimental rifle platform built to outperform the standard M41A. Back issue only. Uses standard MK1 & MK2 rifle magazines. Property of [H.real_name]"



//-------------------------------------------------------
//MAR-40 AK CLONE //AK47 and FN FAL together as one.


/obj/item/weapon/gun/rifle/mar40
	name = "\improper MAR-40 battle rifle"
	desc = "A cheap, reliable assault rifle chambered in 7.62x39mm. Commonly found in the hands of criminals or mercenaries, or in the hands of the UPP or Iron Bears."
	icon_state = "mar40"
	item_state = "mar40"
	fire_sound = 'sound/weapons/gun_mar40.ogg'
	reload_sound = 'sound/weapons/handling/gun_mar40_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_mar40_unload.ogg'

	current_mag = /obj/item/ammo_magazine/rifle/mar40
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/gyro,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/bipod,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/compensator,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/shotgun,
						/obj/item/attachable/scope/slavic
						)
	random_spawn_chance = 38
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex/,
							/obj/item/attachable/scope/slavic,
							/obj/item/attachable/magnetic_harness
							)
	random_spawn_underbarrel = list(
							/obj/item/attachable/angledgrip,
							/obj/item/attachable/verticalgrip,
							/obj/item/attachable/gyro,
							/obj/item/attachable/bipod,
							/obj/item/attachable/attached_gun/flamer,
							/obj/item/attachable/attached_gun/extinguisher,
							/obj/item/attachable/attached_gun/shotgun,
							/obj/item/attachable/lasersight,
							/obj/item/attachable/burstfire_assembly,
									)
	random_spawn_muzzle = list(
							/obj/item/attachable/suppressor,
							/obj/item/attachable/bayonet/upp,
							/obj/item/attachable/extended_barrel,
							/obj/item/attachable/compensator,
								)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK



/obj/item/weapon/gun/rifle/mar40/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 17,"rail_x" = 16, "rail_y" = 20, "under_x" = 24, "under_y" = 15, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/mar40/set_gun_config_values()
	..()
	fire_delay = config.med_fire_delay
	burst_amount = config.high_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.high_hit_accuracy_mult
	scatter = config.med_scatter_value
	burst_scatter_mult = config.low_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil_unwielded = config.high_recoil_value
	recoil = config.min_recoil_value


/obj/item/weapon/gun/rifle/mar40/carbine
	name = "\improper MAR-30 battle carbine"
	desc = "A cheap, reliable carbine chambered in 7.62x39mm. Commonly found in the hands of criminals or mercenaries."
	icon_state = "mar30"
	item_state = "mar30"
	fire_sound = 'sound/weapons/gun_mar40.ogg'
	reload_sound = 'sound/weapons/handling/gun_mar40_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_mar40_unload.ogg'

	aim_slowdown = SLOWDOWN_ADS_SMG //Carbine is more lightweight
	wield_delay = WIELD_DELAY_FAST
	attachable_allowed = list(
					/obj/item/attachable/suppressor,
					/obj/item/attachable/bayonet,
					/obj/item/attachable/bayonet/upp,
					/obj/item/attachable/reddot,
					/obj/item/attachable/reflex,
					/obj/item/attachable/verticalgrip,
					/obj/item/attachable/angledgrip,
					/obj/item/attachable/lasersight,
					/obj/item/attachable/flashlight,
					/obj/item/attachable/bipod,
					/obj/item/attachable/extended_barrel,
					/obj/item/attachable/heavy_barrel,
					/obj/item/attachable/magnetic_harness,
					/obj/item/attachable/attached_gun/grenade,
					/obj/item/attachable/attached_gun/flamer,
					/obj/item/attachable/attached_gun/extinguisher,
					/obj/item/attachable/attached_gun/shotgun,
					/obj/item/attachable/scope,
					/obj/item/attachable/scope/mini
					)
	random_spawn_chance = 35
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex/,
							/obj/item/attachable/scope/mini,
							/obj/item/attachable/magnetic_harness
							)
	random_spawn_underbarrel = list(
							/obj/item/attachable/angledgrip,
							/obj/item/attachable/verticalgrip,
							/obj/item/attachable/gyro,
							/obj/item/attachable/bipod,
							/obj/item/attachable/attached_gun/extinguisher,
							/obj/item/attachable/attached_gun/shotgun,
							/obj/item/attachable/lasersight,
									)
	random_spawn_muzzle = list(
							/obj/item/attachable/suppressor,
							/obj/item/attachable/bayonet/upp,
							/obj/item/attachable/extended_barrel
								)

/obj/item/weapon/gun/rifle/mar40/carbine/set_gun_config_values()
	..()
	fire_delay = config.low_fire_delay
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.med_hit_accuracy_mult
	damage_mult = config.base_hit_damage_mult - config.low_hit_damage_mult
	scatter_unwielded = config.high_scatter_value
	recoil_unwielded = config.med_recoil_value


//-------------------------------------------------------
//M16 RIFLE

/obj/item/weapon/gun/rifle/m16
	name = "\improper M16 rifle"
	desc = "An old, reliable design first adopted by the U.S. military in the 1960s. Something like this belongs in a museum of war history. It is chambered in 5.56x45mm."
	icon_state = "m16"
	item_state = "m16"

	fire_sound = 'sound/weapons/gun_m16.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_m16_unload.ogg'

	current_mag = /obj/item/ammo_magazine/rifle/m16
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/scope/mini,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/gyro,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/bipod,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/compensator,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/shotgun,
						)
	random_spawn_chance = 42
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex/,
							/obj/item/attachable/scope/mini,
							)
	random_spawn_underbarrel = list(
							/obj/item/attachable/angledgrip,
							/obj/item/attachable/verticalgrip,
							/obj/item/attachable/gyro,
							/obj/item/attachable/burstfire_assembly,
							/obj/item/attachable/bipod,
							/obj/item/attachable/attached_gun/extinguisher,
							/obj/item/attachable/attached_gun/shotgun
									)
	random_spawn_muzzle = list(
							/obj/item/attachable/suppressor,
							/obj/item/attachable/bayonet,
							/obj/item/attachable/compensator,
							/obj/item/attachable/extended_barrel
								)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE

/obj/item/weapon/gun/rifle/m16/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 22, "under_x" = 24, "under_y" = 14, "stock_x" = 27, "stock_y" = 12)


/obj/item/weapon/gun/rifle/m16/set_gun_config_values()
	..()
	fire_delay = config.med_fire_delay
	burst_amount = config.med_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult + config.min_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.high_hit_accuracy_mult
	scatter = config.low_scatter_value
	burst_scatter_mult = config.mlow_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult + config.min_hit_damage_mult
	recoil_unwielded = config.high_recoil_value

//-------------------------------------------------------
//DUTCH'S GEAR

/obj/item/weapon/gun/rifle/m16/dutch
	name = "\improper Dutch's M16A2"
	desc = "A modified M16 employed by Dutch's Dozen mercenaries. It has 'CLOAKER KILLER' printed on a label on the side. Chambered in 5.56x45mm."
	icon_state = "m16"
	item_state = "m16"
	fire_sound = 'sound/weapons/gun_m16.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_m16_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m16/ap
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/gyro,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/bipod,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/compensator,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/shotgun
						)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE

/obj/item/weapon/gun/rifle/m16/dutch/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 22, "under_x" = 24, "under_y" = 14, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/m16/set_gun_config_values()
	..()
	fire_delay = config.mlow_fire_delay
	burst_amount = config.med_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult + config.high_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.high_hit_accuracy_mult
	scatter = config.min_scatter_value
	burst_scatter_mult = config.min_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult + config.med_hit_damage_mult
	recoil_unwielded = config.high_recoil_value

//-------------------------------------------------------
//M41AE2 HEAVY PULSE RIFLE

/obj/item/weapon/gun/rifle/lmg
	name = "\improper M41AE2 heavy pulse rifle"
	desc = "A large squad support weapon capable of laying down sustained supressing fire from a mounted position. While unstable and less accurate, it can be lugged and shot with two hands. Like it's smaller brothers, the M41A MK2 and L42 MK1, the M41AE2 is chambered in 10mm."
	icon_state = "m41ae2"
	item_state = "m41ae2"

	reload_sound = 'sound/weapons/handling/hpr_reload.ogg'
	unload_sound = 'sound/weapons/handling/hpr_unload.ogg'
	fire_sound = 'sound/weapons/gun_hpr.ogg'
	aim_slowdown = SLOWDOWN_ADS_LMG
	current_mag = /obj/item/ammo_magazine/rifle/lmg
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/bipod,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/compensator,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/scope)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WIELDED_FIRING_ONLY
	gun_skill_category = SKILL_HEAVY_WEAPONS

/obj/item/weapon/gun/rifle/lmg/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 23, "under_x" = 23, "under_y" = 12, "stock_x" = 24, "stock_y" = 12)


/obj/item/weapon/gun/rifle/lmg/set_gun_config_values()
	..()
	fire_delay = config.mlow_fire_delay
	burst_amount = config.high_burst_value
	burst_delay = config.mlow_fire_delay
	fa_delay = config.mlow_fire_delay
	fa_scatter_peak = config.hmed_scatter_peak
	fa_max_scatter = config.high_scatter_value
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.max_hit_accuracy_mult
	scatter = config.med_scatter_value
	burst_scatter_mult = config.hmed_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil_unwielded = config.max_recoil_value



//-------------------------------------------------------


//-------------------------------------------------------
//UPP TYPE 71 RIFLE

/obj/item/weapon/gun/rifle/type71
	name = "\improper Type 71 pulse rifle"
	desc = "The primary service rifle of the UPP space forces, the Type 71 is an ergonomic, lightweight pulse rifle chambered in 5.45x39mm. In accordance with doctrinal principles of overmatch and suppression, the rifle has a high rate of fire and a high-capacity casket magazine. Despite lackluster precision, an integrated recoil-dampening mechanism makes the rifle surprisingly controllable in bursts."
	icon_state = "type71"
	item_state = "type71"

	fire_sound = 'sound/weapons/gun_type71.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/type71
	wield_delay = WIELD_DELAY_FAST

	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip
						)

	random_spawn_chance = 45
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex/,
							)
	random_spawn_muzzle = list(
							/obj/item/attachable/bayonet/upp
							)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER

/obj/item/weapon/gun/rifle/type71/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 18, "rail_y" = 23, "under_x" = 20, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/type71/set_gun_config_values()
	..()
	fire_delay = config.low_fire_delay
	burst_amount = config.high_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult + config.med_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.high_hit_accuracy_mult
	scatter = config.med_scatter_value
	burst_scatter_mult = config.min_scatter_value
	scatter_unwielded = config.high_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil_unwielded = config.med_recoil_value


/obj/item/weapon/gun/rifle/type71/flamer
	name = "\improper Type 71 flamethrower pulse rifle"
	desc = " This appears to be a less common variant of the Type 71 with an integrated undermounted flamethrower."
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/extended_barrel,
						)

/obj/item/weapon/gun/rifle/type71/flamer/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/flamer/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/type71/flamer/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 20, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)



/obj/item/weapon/gun/rifle/type71/carbine
	name = "\improper Type 71 pulse carbine"
	desc = "A carbine variant of the Type 71, intended for use by frontline support roles. A reduced length makes the gun lighter and easier to handle at the cost of muzzle velocity."
	icon_state = "type71c"
	item_state = "type71c"
	aim_slowdown = SLOWDOWN_ADS_SMG //Carbine is more lightweight
	wield_delay = WIELD_DELAY_VERY_FAST

	random_spawn_muzzle = list() //no default bayonet

/obj/item/weapon/gun/rifle/type71/carbine/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 18,"rail_x" = 19, "rail_y" = 22, "under_x" = 21, "under_y" = 14, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/type71/carbine/set_gun_config_values()
	..()
	fire_delay = config.mlow_fire_delay
	damage_mult = config.base_hit_damage_mult - config.low_hit_damage_mult
	scatter_unwielded = config.hmed_scatter_value
	recoil_unwielded = config.low_recoil_value


/obj/item/weapon/gun/rifle/type71/carbine/commando
	name = "\improper Type 71 'Commando' pulse carbine"
	desc = "A much rarer variant of the Type 71, this version contains an integrated supressor, integrated scope, and extensive fine-tuning. Many parts have been replaced, filed down, and improved upon. As a result, this variant is rarely seen outside of commando units."
	icon_state = "type73"
	item_state = "type73"
	wield_delay = 0 //Ends up being .5 seconds due to scope
	current_mag = /obj/item/ammo_magazine/rifle/type71/ap
	attachable_allowed = list(
						/obj/item/attachable/lasersight,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						)
	random_spawn_chance = 0
	random_spawn_rail = list()
	random_spawn_muzzle = list()


/obj/item/weapon/gun/rifle/type71/carbine/commando/handle_starting_attachment()//Making the gun have an invisible silencer since it's supposed to have one.
	..()
	//supressor
	var/obj/item/attachable/suppressor/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)
	//scope
	var/obj/item/attachable/scope/mini/F = new(src)
	F.hidden = TRUE
	F.flags_attach_features &= ~ATTACH_REMOVABLE
	F.Attach(src)
	update_attachable(F.slot)


/obj/item/weapon/gun/rifle/type71/carbine/commando/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 22, "under_x" = 21, "under_y" = 18, "stock_x" = 21, "stock_y" = 18)


/obj/item/weapon/gun/rifle/type71/carbine/commando/set_gun_config_values()
	..()
	accuracy_mult = config.base_hit_accuracy_mult + config.high_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.med_hit_accuracy_mult
	fire_delay = config.mlow_fire_delay
	burst_delay = config.min_fire_delay
	scatter = config.low_scatter_value

//-------------------------------------------------------
//-------------------------------------------------------
//L42 MK1 Pulse Carbine

/obj/item/weapon/gun/rifle/l42a
	name = "\improper L42A battle rifle"
	desc = "A L42A battle rifle. A non-standard alternative to the standard issue M41A-MK2 available to the jarheads of the USCM. Renowned for its high accuracy and superior stopping power compared to other pulse rifles. Chambered in 10x24mm caseless."
	icon_state = "l42mk1"
	item_state = "l42mk1"
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'
	fire_sound = 'sound/weapons/gun_carbine.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/l42a
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/stock/carbine,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/scope,
						/obj/item/attachable/scope/mini,
						/obj/item/attachable/scope/mini_iff,
						)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_VERY_FAST
	aim_slowdown = SLOWDOWN_ADS_SMG
	starting_attachment_types = list(/obj/item/attachable/stock/carbine)
	map_specific_decoration = TRUE

/obj/item/weapon/gun/rifle/l42a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 19,"rail_x" = 7, "rail_y" = 19, "under_x" = 18, "under_y" = 16, "stock_x" = 22, "stock_y" = 10)


/obj/item/weapon/gun/rifle/l42a/set_gun_config_values()
	..()
	fire_delay = config.high_fire_delay
	burst_amount = 0
	accuracy_mult = config.base_hit_accuracy_mult + config.hmed_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.med_hit_accuracy_mult
	damage_mult = config.base_hit_damage_mult + config.hmed_hit_damage_mult
	recoil_unwielded = config.low_recoil_value
	damage_falloff_mult = 0
	scatter = config.low_scatter_value

//-------------------------------------------------------
//-------------------------------------------------------
//Basira-Armstrong rifle (Used by the CLF)

/obj/item/weapon/gun/rifle/hunting
	name = "\improper Basira-Armstrong rifle"
	desc = "Named after its eccentric designers, the Basira-Armstrong is a civilian semi-automatic rifle frequently found in the outer colonies. Despite its legally-mandated limited magazine capacity, its light weight and legendary accuracy makes it popular among hunters and competitive shooters."
	icon_state = "hunting"
	item_state = "hunting"
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'
	fire_sound = 'sound/weapons/gun_carbine.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/hunting
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/scope,
						/obj/item/attachable/scope/mini,
						/obj/item/attachable/scope/mini_iff,
						/obj/item/attachable/scope/mini/hunting,
						/obj/item/attachable/stock/hunting,
						)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_VERY_FAST
	aim_slowdown = SLOWDOWN_ADS_SMG
	starting_attachment_types = list(/obj/item/attachable/scope/mini/hunting,/obj/item/attachable/stock/hunting)

/obj/item/weapon/gun/rifle/hunting/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 5, "rail_y" = 18, "under_x" = 25, "under_y" = 14, "stock_x" = 18, "stock_y" = 10)

/obj/item/weapon/gun/rifle/hunting/set_gun_config_values()
	..()
	fire_delay = config.med_fire_delay
	burst_amount = 0
	accuracy_mult = config.base_hit_accuracy_mult + config.max_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.med_hit_accuracy_mult
	scatter = config.min_scatter_value
	damage_mult = config.base_hit_damage_mult + config.hmed_hit_damage_mult
	recoil_unwielded = config.low_recoil_value
	damage_falloff_mult = 0
