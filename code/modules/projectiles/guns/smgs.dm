
/obj/item/weapon/gun/smg
	reload_sound = 'sound/weapons/handling/smg_reload.ogg'
	unload_sound = 'sound/weapons/handling/smg_unload.ogg'
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'

	fire_sound = 'sound/weapons/gun_m39.ogg'
	force = 5
	w_class = SIZE_LARGE
	movement_acc_penalty_mult = 4
	aim_slowdown = SLOWDOWN_ADS_SMG
	wield_delay = WIELD_DELAY_VERY_FAST
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/magnetic_harness)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_SMG

/obj/item/weapon/gun/smg/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/smg/unique_action(mob/user)
	cock(user)

/obj/item/weapon/gun/smg/set_gun_config_values()
	..()
	movement_acc_penalty_mult = 4

//-------------------------------------------------------
//M39 SMG

/obj/item/weapon/gun/smg/m39
	name = "\improper M39 submachinegun"
	desc = "The Armat Battlefield Systems M-39 submachinegun. Occasionally carried by light-infantry, scouts, engineers and medics. A lightweight, lower caliber alternative to the various Pulse weapons used the USCM. Fires 10x20mm rounds out of 48 round magazines."
	icon_state = "m39"
	item_state = "m39"
	flags_equip_slot = SLOT_BACK
	current_mag = /obj/item/ammo_magazine/smg/m39
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/stock/smg,
						/obj/item/attachable/stock/smg/collapsible,
						/obj/item/attachable/compensator,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/scope/mini,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/gyro,
						/obj/item/attachable/stock/smg/collapsible/brace)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/stock/smg/collapsible)
	map_specific_decoration = TRUE

/obj/item/weapon/gun/smg/m39/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 20,"rail_x" = 14, "rail_y" = 22, "under_x" = 21, "under_y" = 16, "stock_x" = 24, "stock_y" = 16)

/obj/item/weapon/gun/smg/m39/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	burst_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_5
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_4
	burst_scatter_mult = SCATTER_AMOUNT_TIER_2
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5


/obj/item/weapon/gun/smg/m39/training
	current_mag = /obj/item/ammo_magazine/smg/m39/rubber

//-------------------------------------------------------

/obj/item/weapon/gun/smg/m39/elite
	name = "\improper M39B/2 submachinegun"
	desc = "A modified version M-39 submachinegun, re-engineered for better weight, handling and accuracy. Given only to elite units."
	icon_state = "m39b2"
	item_state = "m39b2"
	current_mag = /obj/item/ammo_magazine/smg/m39/ap
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WY_RESTRICTED
	map_specific_decoration = FALSE

	random_spawn_chance = 100
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex,
							/obj/item/attachable/flashlight,
							/obj/item/attachable/flashlight/grip,
							/obj/item/attachable/magnetic_harness,
							)
	random_spawn_underbarrel = list(
							/obj/item/attachable/lasersight,
							)

/obj/item/weapon/gun/smg/m39/elite/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult =  BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_7

//-------------------------------------------------------
//M5, a classic SMG used in a lot of action movies.

/obj/item/weapon/gun/smg/mp5
	name = "\improper MP5 submachinegun"
	desc = "A German design, this was one of the most widely used submachine guns in the world. It's still possible to find this firearm in the hands of collectors or gun fanatics."
	icon_state = "mp5"
	item_state = "mp5"

	fire_sound = 'sound/weapons/smg_light.ogg'
	current_mag = /obj/item/ammo_magazine/smg/mp5
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/scope/mini)
	random_spawn_chance = 40
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex,
							/obj/item/attachable/flashlight,
							/obj/item/attachable/magnetic_harness,
							)
	random_spawn_underbarrel = list(
							/obj/item/attachable/lasersight,
							/obj/item/attachable/angledgrip,
							/obj/item/attachable/verticalgrip,
							)
	random_spawn_muzzle = list(
							/obj/item/attachable/extended_barrel
								)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE



/obj/item/weapon/gun/smg/mp5/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 19, "under_x" = 23, "under_y" = 15, "stock_x" = 28, "stock_y" = 17)

/obj/item/weapon/gun/smg/mp5/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_4

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_1 - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_7
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_5


//-------------------------------------------------------
//MP27, based on the MP27, based on the M7.

/obj/item/weapon/gun/smg/mp7
	name = "\improper MP27 submachinegun"
	desc = "An archaic design going back hundreds of years, the MP27 was common in its day. Today it sees limited use as cheap computer-printed replicas or family heirlooms."
	icon_state = "mp7"
	item_state = "mp7"

	fire_sound = 'sound/weapons/smg_light.ogg'
	current_mag = /obj/item/ammo_magazine/smg/mp7
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/scope/mini)
	random_spawn_chance = 40
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex,
							/obj/item/attachable/flashlight,
							/obj/item/attachable/magnetic_harness,
							)
	random_spawn_underbarrel = list(
							/obj/item/attachable/lasersight
							)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK


/obj/item/weapon/gun/smg/mp7/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 12, "rail_y" = 20, "under_x" = 23, "under_y" = 16, "stock_x" = 28, "stock_y" = 17)

/obj/item/weapon/gun/smg/mp7/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_4

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_1 - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

//-------------------------------------------------------
//SKORPION //Based on the same thing.

/obj/item/weapon/gun/smg/skorpion
	name = "\improper CZ-81 submachinegun"
	desc = "A robust, 20th century firearm that's a combination of pistol and submachinegun. Fires .32ACP caliber rounds from a 20 round magazine."
	icon_state = "skorpion"
	item_state = "skorpion"

	fire_sound = 'sound/weapons/gun_skorpion.ogg'
	current_mag = /obj/item/ammo_magazine/smg/skorpion
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK

	attachable_allowed = list(
						/obj/item/attachable/lasersight,
						/obj/item/attachable/reflex,
						/obj/item/attachable/suppressor,
						)
	random_spawn_chance = 33
	random_spawn_rail = list(
							/obj/item/attachable/reflex/
							)
	random_spawn_underbarrel = list(
							/obj/item/attachable/lasersight
							)


/obj/item/weapon/gun/smg/skorpion/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 18,"rail_x" = 16, "rail_y" = 21, "under_x" = 23, "under_y" = 15, "stock_x" = 23, "stock_y" = 15)



/obj/item/weapon/gun/smg/skorpion/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	burst_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_3

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_1 - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5


/obj/item/weapon/gun/smg/skorpion/upp
	icon_state = "skorpion_u"
	item_state = "skorpion_u"

//-------------------------------------------------------
//PPSH //Based on the PPSh-41.

/obj/item/weapon/gun/smg/ppsh
	name = "\improper PPSh-17b submachinegun"
	desc = "An unauthorized copy of a replica of a prototype submachinegun developed in a third world shit hole somewhere."
	icon_state = "ppsh17b"
	item_state = "ppsh17b"

	fire_sound = 'sound/weapons/smg_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/smg/ppsh
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE


/obj/item/weapon/gun/smg/ppsh/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 17,"rail_x" = 15, "rail_y" = 19, "under_x" = 26, "under_y" = 15, "stock_x" = 26, "stock_y" = 15)

/obj/item/weapon/gun/smg/ppsh/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_3

	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_1 - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_5
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5



//-------------------------------------------------------
//GENERIC UZI //Based on the uzi submachinegun, of course.

/obj/item/weapon/gun/smg/uzi
	name = "\improper MAC-15 submachinegun"
	desc = "A cheap, reliable design and manufacture make this ubiquitous submachinegun useful despite the age. Turn on burst mode for maximum firepower."
	icon_state = "mac15"
	item_state = "mac15"

	fire_sound = 'sound/weapons/uzi.ogg'
	current_mag = /obj/item/ammo_magazine/smg/uzi
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK

	attachable_allowed = list(
						/obj/item/attachable/lasersight,
						/obj/item/attachable/reflex,
						/obj/item/attachable/suppressor,
						)
	random_spawn_chance = 33
	random_spawn_rail = list(
							/obj/item/attachable/reflex/
							)
	random_spawn_underbarrel = list(
							/obj/item/attachable/lasersight
							)


/obj/item/weapon/gun/smg/uzi/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 20,"rail_x" = 16, "rail_y" = 22, "under_x" = 22, "under_y" = 16, "stock_x" = 22, "stock_y" = 16)


/obj/item/weapon/gun/smg/uzi/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	burst_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_4

	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_5
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT - BULLET_DAMAGE_MULT_TIER_2
	recoil_unwielded = RECOIL_AMOUNT_TIER_5


//-------------------------------------------------------
//FP9000 //Based on the FN P90

/obj/item/weapon/gun/smg/fp9000
	name = "\improper FN FP9000 Submachinegun"
	desc = "An older design, but one that's stood the test of time and still sees common use today. Fires fast armor piercing rounds at a high rate."
	icon_state = "fp9000"
	item_state = "fp9000"

	fire_sound = 'sound/weapons/gun_p90.ogg'
	current_mag = /obj/item/ammo_magazine/smg/fp9000

	attachable_allowed = list(
						/obj/item/attachable/compensator,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						)
	random_spawn_chance = 65
	random_spawn_underbarrel = list(
							/obj/item/attachable/lasersight,
							)
	random_spawn_muzzle = list(
							/obj/item/attachable/compensator,
							/obj/item/attachable/extended_barrel
								)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK

/obj/item/weapon/gun/smg/fp9000/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/S = new(src)
	S.icon_state = "miniscope_fp9000"
	S.attach_icon = "miniscope_fp9000_a" // Custom
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/smg/fp9000/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 20, "rail_y" = 21, "under_x" = 26, "under_y" = 16, "stock_x" = 22, "stock_y" = 16)

/obj/item/weapon/gun/smg/fp9000/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_3

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7 - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/smg/fp9000/pmc
	name = "\improper FN FP9000 Submachinegun"
	desc = "A variant of the FP9000 SMG that appears to feature some special modifications for elite forces."
	icon_state = "fp9000_pmc"
	item_state = "fp9000_pmc"
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

/obj/item/weapon/gun/smg/fp9000/pmc/set_gun_config_values()
	..()
	scatter = SCATTER_AMOUNT_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7

//-------------------------------------------------------

/obj/item/weapon/gun/smg/nailgun
	name = "nailgun"
	desc = "A carpentry tool, used to drive nails into tough surfaces. Of course, if there isn't anything there, that's just a very sharp nail launching at high velocity..."
	icon_state = "nailgun"
	item_state = "nailgun"
	current_mag = /obj/item/ammo_magazine/smg/nailgun

	reload_sound = 'sound/weapons/handling/smg_reload.ogg'
	unload_sound = 'sound/weapons/handling/smg_unload.ogg'
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'

	fire_sound = 'sound/weapons/nailgun_fire.ogg'
	force = 5
	w_class = SIZE_MEDIUM
	movement_acc_penalty_mult = 4
	aim_slowdown = SLOWDOWN_ADS_SMG
	wield_delay = WIELD_DELAY_VERY_FAST
	attachable_allowed = list()

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_SMG
	var/nailing_speed = 2 SECONDS //Time to apply a sheet for patching. Also haha name. Try to keep sync with soundbyte duration
	var/repair_sound = 'sound/weapons/nailgun_repair_long.ogg'

/obj/item/weapon/gun/smg/nailgun/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/smg/nailgun/unique_action(mob/user)
	return //Yeah no.
