
/obj/item/weapon/gun/smg
	reload_sound = 'sound/weapons/handling/smg_reload.ogg'
	unload_sound = 'sound/weapons/handling/smg_unload.ogg'
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'

	fire_sound = 'sound/weapons/gun_m39.ogg'
	force = 5
	w_class = SIZE_LARGE
	movement_onehanded_acc_penalty_mult = 4
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_VERY_FAST
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
	)

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
	movement_onehanded_acc_penalty_mult = 4

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
		/obj/item/attachable/bayonet/c02,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/gyro,
		/obj/item/attachable/stock/smg/collapsible/brace,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/stock/smg/collapsible)
	map_specific_decoration = TRUE

/obj/item/weapon/gun/smg/m39/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 20,"rail_x" = 14, "rail_y" = 22, "under_x" = 21, "under_y" = 16, "stock_x" = 24, "stock_y" = 15)

/obj/item/weapon/gun/smg/m39/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_SMG
	burst_delay = FIRE_DELAY_TIER_SMG
	burst_amount = BURST_AMOUNT_TIER_3
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_4
	burst_scatter_mult = SCATTER_AMOUNT_TIER_4
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
	starting_attachment_types = list(/obj/item/attachable/stock/smg)

	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight/grip,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/extended_barrel,
	)



/obj/item/weapon/gun/smg/m39/elite/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_SMG
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult =  BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_7

/obj/item/weapon/gun/smg/m39/elite/whiteout//attachies + heap mag for whiteout.
	starting_attachment_types = list(/obj/item/attachable/stock/smg, /obj/item/attachable/suppressor, /obj/item/attachable/angledgrip, /obj/item/attachable/magnetic_harness)
	current_mag = /obj/item/ammo_magazine/smg/m39/heap


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
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/c02,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/lasersight, // Under
		/obj/item/attachable/gyro,
		/obj/item/attachable/bipod,
		/obj/item/attachable/burstfire_assembly
		)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE



/obj/item/weapon/gun/smg/mp5/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 19, "under_x" = 23, "under_y" = 15, "stock_x" = 28, "stock_y" = 17)

/obj/item/weapon/gun/smg/mp5/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_delay = FIRE_DELAY_TIER_SMG
	burst_amount = BURST_AMOUNT_TIER_3

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

//-------------------------------------------------------
//MP27, based on the MP27, based on the M7.

/obj/item/weapon/gun/smg/mp27
	name = "\improper MP27 submachinegun"
	desc = "An archaic design going back almost a century, the MP27 was common in its day. Today it sees limited use as cheap computer-printed replicas or family heirlooms. An extremely ergonomic and lightweight design allows easy mass production and surpisingly good handling, but the cheap materials used hurt the weapon's scatter noticeably."
	icon_state = "mp7"
	item_state = "mp7"
	fire_sound = 'sound/weapons/smg_light.ogg'
	current_mag = /obj/item/ammo_magazine/smg/mp27
	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/c02,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/lasersight, // Under
		/obj/item/attachable/gyro,
		/obj/item/attachable/bipod,
		/obj/item/attachable/burstfire_assembly,
		)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK
	aim_slowdown = SLOWDOWN_ADS_NONE


/obj/item/weapon/gun/smg/mp27/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 12, "rail_y" = 20, "under_x" = 23, "under_y" = 16, "stock_x" = 28, "stock_y" = 17)

/obj/item/weapon/gun/smg/mp27/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_SMG
	burst_delay = FIRE_DELAY_TIER_SMG
	burst_amount = BURST_AMOUNT_TIER_2
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_4 + (SCATTER_AMOUNT_TIER_10 * 0.5)
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8 + (SCATTER_AMOUNT_TIER_10 * 0.5)
	scatter_unwielded = SCATTER_AMOUNT_TIER_4 + SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

//-------------------------------------------------------
//PPSH //Based on the PPSh-41.

#define PPSH_UNJAM_CHANCE 25

/obj/item/weapon/gun/smg/ppsh
	name = "\improper PPSh-17b submachinegun"
	desc = "An unauthorized copy of a replica of a prototype submachinegun developed in a third world shit hole somewhere."
	icon_state = "ppsh17b"
	item_state = "ppsh17b"

	fire_sound = 'sound/weapons/smg_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/smg/ppsh
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE
	var/jammed = FALSE

/obj/item/weapon/gun/smg/ppsh/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 17,"rail_x" = 15, "rail_y" = 19, "under_x" = 26, "under_y" = 15, "stock_x" = 26, "stock_y" = 15)

/obj/item/weapon/gun/smg/ppsh/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_SMG
	burst_delay = FIRE_DELAY_TIER_SMG
	burst_amount = BURST_AMOUNT_TIER_3
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_4
	burst_scatter_mult = SCATTER_AMOUNT_TIER_4
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/smg/ppsh/with_drum_mag
	current_mag = /obj/item/ammo_magazine/smg/ppsh/extended

// Special feature! The PPSH can jam with the drum magazine, and will also receive handling debuffs when using one.

/obj/item/weapon/gun/smg/ppsh/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	var/obj/item/ammo_magazine/smg/ppsh/ppsh_mag =  current_mag
	if(jammed)
		if(world.time % 3)
			playsound(src, 'sound/weapons/handling/gun_jam_click.ogg', 35, TRUE)
			to_chat(user, SPAN_WARNING("Your gun is jammed! Mash Unique-Action to unjam it!"))
			balloon_alert(user, "*jammed*")
		return
	else if(prob(ppsh_mag?.jam_chance))
		jammed = TRUE
		playsound(src, 'sound/weapons/handling/gun_jam_initial_click.ogg', 50, FALSE)
		user.visible_message(SPAN_DANGER("[src] makes a noticeable clicking noise!"), SPAN_HIGHDANGER("\The [src] suddenly jams and refuses to fire! Mash Unique-Action to unjam it."))
		balloon_alert(user, "*jammed*")
		return
	else
		. = ..()

/obj/item/weapon/gun/smg/ppsh/unique_action(mob/user)
	if(jammed)
		if(prob(PPSH_UNJAM_CHANCE))
			to_chat(user, SPAN_GREEN("You succesfully unjam \the [src]!"))
			playsound(src, 'sound/weapons/handling/gun_jam_rack_success.ogg', 50, FALSE)
			jammed = FALSE
			cock_cooldown += 1 SECONDS //so they dont accidentally cock a bullet away
			balloon_alert(user, "*unjammed!*")
		else
			to_chat(user, SPAN_NOTICE("You start wildly racking the bolt back and forth attempting to unjam \the [src]!"))
			playsound(src, "gun_jam_rack", 50, FALSE)
			balloon_alert(user, "*rack*")
		return
	. = ..()

/obj/item/weapon/gun/smg/ppsh/unload(mob/user, reload_override, drop_override, loc_override)
	. = ..()
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_VERY_FAST

/obj/item/weapon/gun/smg/ppsh/reload(mob/user, obj/item/ammo_magazine/magazine)
	var/obj/item/ammo_magazine/smg/ppsh/ppsh_mag = magazine

	if( (ppsh_mag.bonus_mag_aim_slowdown || ppsh_mag.bonus_mag_wield_delay) && user)
		to_chat(user, SPAN_WARNING("\The [src] feels noticeably bulkier with \the [magazine]. It's probably going to have a lot worse handling than usual."))

	aim_slowdown = SLOWDOWN_ADS_QUICK + ppsh_mag.bonus_mag_aim_slowdown
	wield_delay = WIELD_DELAY_VERY_FAST + ppsh_mag.bonus_mag_wield_delay
	update_icon()
	. = ..()

/obj/item/weapon/gun/smg/ppsh/update_icon()
	..()
	var/obj/item/ammo_magazine/smg/ppsh/ppsh_mag = current_mag
	if(ppsh_mag && ppsh_mag.new_item_state)
		item_state = ppsh_mag.new_item_state
		ppsh_mag.update_icon()

#undef PPSH_UNJAM_CHANCE

//-------------------------------------------------------
//GENERIC UZI //Based on the uzi submachinegun, of course.

/obj/item/weapon/gun/smg/mac15
	name = "\improper MAC-15 submachinegun"
	desc = "A cheap, reliable design and manufacture make this ubiquitous submachinegun useful despite the age." //Includes proprietary 'full-auto' mode, banned in several Geneva Suggestions rim-wide.
	icon_state = "mac15"
	item_state = "mac15"

	fire_sound = 'sound/weapons/gun_mac15.ogg'
	current_mag = /obj/item/ammo_magazine/smg/mac15
	flags_gun_features = GUN_ANTIQUE|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED //|GUN_HAS_FULL_AUTO|GUN_FULL_AUTO_ON|GUN_FULL_AUTO_ONLY commented out until better fullauto code

	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/lasersight, // Under
		/obj/item/attachable/burstfire_assembly,
		)
	wield_delay = WIELD_DELAY_NONE
	aim_slowdown = SLOWDOWN_ADS_NONE

/obj/item/weapon/gun/smg/mac15/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 20,"rail_x" = 16, "rail_y" = 22, "under_x" = 22, "under_y" = 16, "stock_x" = 22, "stock_y" = 16)

/obj/item/weapon/gun/smg/mac15/set_gun_config_values()
	..()

	/* commented out until better fullauto code
	fa_delay = FIRE_DELAY_TIER_10
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_7
	fa_max_scatter = SCATTER_AMOUNT_TIER_3
	*/

	fire_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_5
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT - BULLET_DAMAGE_MULT_TIER_2

/obj/item/weapon/gun/smg/mac15/extended
	current_mag = /obj/item/ammo_magazine/smg/mac15/extended

//-------------------------------------------------------
// DAS REAL UZI

#define UZI_UNJAM_CHANCE 25

/obj/item/weapon/gun/smg/uzi
	name = "\improper UZI"
	desc = "Exported to over 90 countries, somehow this relic has managed to end up here. Couldn't be simpler to use."
	icon_state = "uzi"
	item_state = "uzi"
	flags_equip_slot = SLOT_WAIST
	fire_sound = 'sound/weapons/gun_uzi.ogg'
	current_mag = /obj/item/ammo_magazine/smg/uzi
	flags_gun_features = GUN_ANTIQUE|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED //|GUN_HAS_FULL_AUTO|GUN_FULL_AUTO_ON|GUN_FULL_AUTO_ONLY commented out until better fullauto code

	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/lasersight, // Under
		/obj/item/attachable/burstfire_assembly,
		)
	wield_delay = WIELD_DELAY_MIN
	aim_slowdown = SLOWDOWN_ADS_QUICK
	var/jammed = FALSE

/obj/item/weapon/gun/smg/uzi/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 12, "rail_y" = 22, "under_x" = 22, "under_y" = 16, "stock_x" = 22, "stock_y" = 16)

/obj/item/weapon/gun/smg/uzi/set_gun_config_values()
	..()

	/* commented out until better fullauto code
	fa_delay = FIRE_DELAY_TIER_9
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_5
	fa_max_scatter = SCATTER_AMOUNT_TIER_5
	*/

	fire_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_2
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

// The UZI can also jam, though it's less likely.

/obj/item/weapon/gun/smg/uzi/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	var/obj/item/ammo_magazine/smg/uzi/uzi_mag = current_mag
	if(jammed)
		if(world.time % 3)
			playsound(src, 'sound/weapons/handling/gun_jam_click.ogg', 35, TRUE)
			to_chat(user, SPAN_WARNING("Your gun is jammed! Mash Unique-Action to unjam it!"))
			balloon_alert(user, "*jammed*")
		return
	else if(prob(uzi_mag.jam_chance))
		jammed = TRUE
		playsound(src, 'sound/weapons/handling/gun_jam_initial_click.ogg', 35, TRUE)
		user.visible_message(SPAN_DANGER("[src] makes a noticeable clicking noise!"), SPAN_HIGHDANGER("\The [src] suddenly jams and refuses to fire! Mash Unique-Action to unjam it."))
		balloon_alert(user, "*jammed*")
		return
	else
		. = ..()

/obj/item/weapon/gun/smg/uzi/unique_action(mob/user)
	if(jammed)
		if(prob(UZI_UNJAM_CHANCE))
			to_chat(user, SPAN_GREEN("You succesfully unjam \the [src]!"))
			playsound(src, 'sound/weapons/handling/gun_jam_rack_success.ogg', 35, TRUE)
			jammed = FALSE
			cock_cooldown += 1 SECONDS //so they dont accidentally cock a bullet away
			balloon_alert(user, "*unjammed!*")
		else
			to_chat(user, SPAN_NOTICE("You start wildly racking the bolt back and forth attempting to unjam \the [src]!"))
			playsound(src, "gun_jam_rack", 50, FALSE)
			balloon_alert(user, "*rack*")
		return
	. = ..()

#undef UZI_UNJAM_CHANCE

//-------------------------------------------------------
//FP9000 //Based on the FN P90

/obj/item/weapon/gun/smg/fp9000
	name = "\improper FN FP9000 Submachinegun"
	desc = "An old design, but one that's stood the test of time. A leaked and unencrypted 3D-printing pattern alongside an extremely robust and reasonably cheap to manufacture frame have ensured this weapon be a mainstay of rim colonies and private security firms for over a century."
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
	random_spawn_under = list(
		/obj/item/attachable/lasersight,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/compensator,
		/obj/item/attachable/extended_barrel,
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
	fire_delay = FIRE_DELAY_TIER_SMG
	burst_delay = FIRE_DELAY_TIER_SMG
	burst_amount = BURST_AMOUNT_TIER_3
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_4
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_1
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/smg/fp9000/pmc
	name = "\improper FN FP9000/2 Submachinegun"
	desc = "Despite the rather ancient design, the FN FP9K sees frequent use in PMC teams due to its extreme reliability and versatility, allowing it to excel in any situation, especially due to the fact that they use the patented, official version of the gun, which has recieved several upgrades and tuning to its design over time."
	icon_state = "fp9000_pmc"
	item_state = "fp9000_pmc"
	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
	)
	random_spawn_under = list(
		/obj/item/attachable/lasersight,
	)

/obj/item/weapon/gun/smg/fp9000/pmc/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4
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
	movement_onehanded_acc_penalty_mult = 4
	aim_slowdown = SLOWDOWN_ADS_QUICK
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

/obj/item/weapon/gun/smg/nailgun/unload_chamber(mob/user)
	return //Can't remove nails from mags or gun.

/obj/item/weapon/gun/smg/nailgun/compact
	name = "compact nailgun"
	desc = "A carpentry tool, used to drive nails into tough surfaces. Cannot fire nails offensively due to a lack of a gas seal around the nail, meaning it cannot build up the pressure to fire."
	icon_state = "cnailgun"
	item_state = "nailgun"
	w_class = SIZE_SMALL

/obj/item/weapon/gun/smg/nailgun/compact/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		click_empty(user)
	return FALSE
