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
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon

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

/obj/item/attachable/stock/m16/xm177
	name = "\improper collapsible M16 stock"
	desc = "Very illegal in the state of California."
	icon_state = "m16_folding"
	attach_icon = "m16_folding"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 3
	collapsible = TRUE
	stock_activated = FALSE
	wield_delay_mod = WIELD_DELAY_NONE //starts collapsed so no delay mod
	collapse_delay = 0.5 SECONDS
	flags_attach_features = ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle

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
		icon_state = "m16_folding"
		attach_icon = "m16_folding_on"
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
		icon_state = "m16_folding"
		attach_icon = "m16_folding"
		wield_delay_mod = WIELD_DELAY_NONE //stock is folded so no wield delay
	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")


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
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon

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
		icon_state = "smgstockc"
		attach_icon = "smgstockc_a"

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
		icon_state = "smgstockcc"
		attach_icon = "smgstockcc_a"

	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")

/obj/item/attachable/stock/smg/collapsible/brace
	name = "\improper submachinegun arm brace"
	desc = "A specialized stock for use on an M39 submachine gun. It makes one handing more accurate at the expense of burst amount. Wielding the weapon with this stock attached confers a major inaccuracy and recoil debuff."
	size_mod = 1
	icon_state = "smg_brace"
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
/obj/item/attachable/stock/revolver/Detach(mob/user, obj/item/weapon/gun/detaching_gub)
	..()
	var/obj/item/weapon/gun/revolver/m44/R = detaching_gub
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
