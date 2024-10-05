/obj/item/attachable/verticalgrip
	name = "vertical grip"
	desc = "A vertical foregrip that offers better accuracy, less recoil, and less scatter, especially during burst fire. \nHowever, it also increases weapon size."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
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
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10

/obj/item/attachable/angledgrip
	name = "angled grip"
	desc = "An angled foregrip that improves weapon ergonomics resulting in faster wielding time. \nHowever, it also increases weapon size."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "angledgrip"
	attach_icon = "angledgrip_a"
	wield_delay_mod = -WIELD_DELAY_FAST
	size_mod = 1
	slot = "under"
	pixel_shift_x = 20

/obj/item/attachable/gyro
	name = "gyroscopic stabilizer"
	desc = "A set of weights and balances to stabilize the weapon when fired with one hand. Slightly decreases firing speed."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "gyro"
	attach_icon = "gyro_a"
	slot = "under"

/obj/item/attachable/gyro/New()
	..()
	delay_mod = FIRE_DELAY_TIER_11
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	burst_scatter_mod = -2
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_3
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
	desc_lore = "A standard visible-band laser module designated as the AN/PEQ-42 Laser Sight. Can be mounted onto any firearm that has a lower rail large enough to accommodate it."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "lasersight"
	attach_icon = "lasersight_a"
	slot = "under"
	pixel_shift_x = 17
	pixel_shift_y = 17

/obj/item/attachable/lasersight/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_9
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1


/obj/item/attachable/bipod
	name = "bipod"
	desc = "A simple set of telescopic poles to keep a weapon stabilized during firing. \nGreatly increases accuracy and reduces recoil when properly placed, but also increases weapon size and slows firing speed."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "bipod"
	attach_icon = "bipod_a"
	slot = "under"
	size_mod = 2
	melee_mod = -10
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/initial_mob_dir = NORTH // the dir the mob faces the moment it deploys the bipod
	var/bipod_deployed = FALSE
	/// If this should anchor the user while in use
	var/heavy_bipod = FALSE
	// Are switching to full auto when deploying the bipod
	var/full_auto_switch = FALSE
	// Store our old firemode so we can switch to it when undeploying the bipod
	var/old_firemode = null

/obj/item/attachable/bipod/New()
	..()

	delay_mod = FIRE_DELAY_TIER_11
	wield_delay_mod = WIELD_DELAY_FAST
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_5
	scatter_mod = SCATTER_AMOUNT_TIER_9
	recoil_mod = RECOIL_AMOUNT_TIER_5

/obj/item/attachable/bipod/Attach(obj/item/weapon/gun/gun, mob/user)
	..()

	if((GUN_FIREMODE_AUTOMATIC in gun.gun_firemode_list) || (gun.flags_gun_features & GUN_SUPPORT_PLATFORM))
		var/given_action = FALSE
		if(user && (gun == user.l_hand || gun == user.r_hand))
			give_action(user, /datum/action/item_action/bipod/toggle_full_auto_switch, src, gun)
			given_action = TRUE
		if(!given_action)
			new /datum/action/item_action/bipod/toggle_full_auto_switch(src, gun)

	RegisterSignal(gun, COMSIG_ITEM_DROPPED, PROC_REF(handle_drop))

/obj/item/attachable/bipod/Detach(mob/user, obj/item/weapon/gun/detaching_gub)
	UnregisterSignal(detaching_gub, COMSIG_ITEM_DROPPED)

	//clear out anything related to full auto switching
	full_auto_switch = FALSE
	old_firemode = null
	for(var/item_action in detaching_gub.actions)
		var/datum/action/item_action/bipod/toggle_full_auto_switch/target_action = item_action
		if(target_action.target == src)
			qdel(item_action)
			break

	if(bipod_deployed)
		undeploy_bipod(detaching_gub, user)
	..()

/obj/item/attachable/bipod/update_icon()
	if(bipod_deployed)
		icon_state = "[icon_state]-on"
		attach_icon = "[attach_icon]-on"
	else
		icon_state = initial(icon_state)
		attach_icon = initial(attach_icon)

	if(istype(loc, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/gun = loc
		gun.update_attachable(slot)
		for(var/datum/action/item_action as anything in gun.actions)
			if(!istype(item_action, /datum/action/item_action/bipod/toggle_full_auto_switch))
				item_action.update_button_icon()

/obj/item/attachable/bipod/proc/handle_drop(obj/item/weapon/gun/gun, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	UnregisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK)

	if(bipod_deployed)
		undeploy_bipod(gun, user)
		user.apply_effect(1, SUPERSLOW)
		user.apply_effect(2, SLOW)

/obj/item/attachable/bipod/proc/undeploy_bipod(obj/item/weapon/gun/gun, mob/user)
	REMOVE_TRAIT(gun, TRAIT_GUN_BIPODDED, "attached_bipod")
	bipod_deployed = FALSE
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_5
	scatter_mod = SCATTER_AMOUNT_TIER_9
	recoil_mod = RECOIL_AMOUNT_TIER_5
	burst_scatter_mod = 0
	delay_mod = FIRE_DELAY_TIER_12
	//if we are no longer on full auto, don't bother switching back to the old firemode
	if(full_auto_switch && gun.gun_firemode == GUN_FIREMODE_AUTOMATIC && gun.gun_firemode != old_firemode)
		gun.do_toggle_firemode(user, null, old_firemode)

	gun.recalculate_attachment_bonuses()
	gun.stop_fire()
	SEND_SIGNAL(user, COMSIG_MOB_UNDEPLOYED_BIPOD)
	UnregisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK)

	if(gun.flags_gun_features & GUN_SUPPORT_PLATFORM)
		gun.remove_firemode(GUN_FIREMODE_AUTOMATIC)

	if(heavy_bipod)
		user.anchored = FALSE

	if(!QDELETED(gun))
		playsound(user,'sound/items/m56dauto_rotate.ogg', 55, 1)
		update_icon()

/obj/item/attachable/bipod/activate_attachment(obj/item/weapon/gun/gun, mob/living/user, turn_off)
	if(turn_off)
		if(bipod_deployed)
			undeploy_bipod(gun, user)
	else
		var/obj/support = check_bipod_support(gun, user)
		if(!support&&!bipod_deployed)
			to_chat(user, SPAN_NOTICE("You start deploying [src] on the ground."))
			if(!do_after(user, 15, INTERRUPT_ALL, BUSY_ICON_HOSTILE, gun, INTERRUPT_DIFF_LOC))
				return FALSE

		bipod_deployed = !bipod_deployed
		if(user)
			if(bipod_deployed)
				ADD_TRAIT(gun, TRAIT_GUN_BIPODDED, "attached_bipod")
				to_chat(user, SPAN_NOTICE("You deploy [src] [support ? "on [support]" : "on the ground"]."))
				SEND_SIGNAL(user, COMSIG_MOB_DEPLOYED_BIPOD)
				playsound(user,'sound/items/m56dauto_rotate.ogg', 55, 1)
				accuracy_mod = HIT_ACCURACY_MULT_TIER_5
				scatter_mod = -SCATTER_AMOUNT_TIER_10
				recoil_mod = -RECOIL_AMOUNT_TIER_4
				burst_scatter_mod = -SCATTER_AMOUNT_TIER_8
				if(istype(gun, /obj/item/weapon/gun/rifle/sniper/M42A))
					delay_mod = -FIRE_DELAY_TIER_7
				else
					delay_mod = -FIRE_DELAY_TIER_12
				gun.recalculate_attachment_bonuses()
				gun.stop_fire()

				initial_mob_dir = user.dir
				RegisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(handle_mob_move_or_look))

				if(gun.flags_gun_features & GUN_SUPPORT_PLATFORM)
					gun.add_firemode(GUN_FIREMODE_AUTOMATIC)

				if(heavy_bipod)
					user.anchored = TRUE

				old_firemode = gun.gun_firemode
				if(full_auto_switch && gun.gun_firemode != GUN_FIREMODE_AUTOMATIC)
					gun.do_toggle_firemode(user, null, GUN_FIREMODE_AUTOMATIC)

			else
				to_chat(user, SPAN_NOTICE("You retract [src]."))
				undeploy_bipod(gun, user)

	update_icon()

	return 1

/obj/item/attachable/bipod/proc/handle_mob_move_or_look(mob/living/mover, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(!actually_moving && (specific_direction & initial_mob_dir)) // if you're facing north, but you're shooting north-east and end up facing east, you won't lose your bipod
		return
	undeploy_bipod(loc, mover)
	mover.apply_effect(1, SUPERSLOW)
	mover.apply_effect(2, SLOW)


//when user fires the gun, we check if they have something to support the gun's bipod.
/obj/item/attachable/proc/check_bipod_support(obj/item/weapon/gun/gun, mob/living/user)
	return 0

/obj/item/attachable/bipod/check_bipod_support(obj/item/weapon/gun/gun, mob/living/user)
	var/turf/T = get_turf(user)
	for(var/obj/O in T)
		if(O.throwpass && O.density && O.dir == user.dir && O.flags_atom & ON_BORDER)
			return O
	var/turf/T2 = get_step(T, user.dir)

	for(var/obj/O2 in T2)
		if(O2.throwpass && O2.density)
			return O2
	return 0

//item actions for handling deployment to full auto.
/datum/action/item_action/bipod/toggle_full_auto_switch/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Full Auto Switch"
	action_icon_state = "full_auto_switch"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/bipod/toggle_full_auto_switch/action_activate()
	. = ..()
	var/obj/item/weapon/gun/holder_gun = holder_item
	var/obj/item/attachable/bipod/attached_bipod = holder_gun.attachments["under"]

	attached_bipod.full_auto_switch = !attached_bipod.full_auto_switch
	to_chat(owner, SPAN_NOTICE("[icon2html(holder_gun, owner)] You will [attached_bipod.full_auto_switch? "<B>start</b>" : "<B>stop</b>"] switching to full auto when deploying the bipod."))
	playsound(owner, 'sound/weapons/handling/gun_burst_toggle.ogg', 15, 1)

	if(attached_bipod.full_auto_switch)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)


/obj/item/attachable/bipod/m60
	name = "bipod"
	desc = "A simple set of telescopic poles to keep a weapon stabilized during firing. This one looks rather old.\nGreatly increases accuracy and reduces recoil when properly placed, but also increases weapon size and slows firing speed."
	icon_state = "bipod_m60"
	attach_icon = "bipod_m60_a"

	flags_attach_features = ATTACH_ACTIVATION

/obj/item/attachable/bipod/vulture
	name = "heavy bipod"
	desc = "A set of rugged telescopic poles to keep a weapon stabilized during firing."
	icon_state = "bipod_m60"
	attach_icon = "vulture_bipod"
	heavy_bipod = TRUE

/obj/item/attachable/bipod/vulture/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(type)

/obj/item/attachable/bipod/vulture/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
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

/obj/item/attachable/burstfire_assembly
	name = "burst fire assembly"
	desc = "A small angled piece of fine machinery that increases the burst count on some weapons, and grants the ability to others. \nIncreases weapon scatter."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "rapidfire"
	attach_icon = "rapidfire_a"
	slot = "under"

/obj/item/attachable/burstfire_assembly/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	burst_mod = BURST_AMOUNT_TIER_2

	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_4

/obj/item/attachable/eva_doodad
	name = "RXF-M5 EVA beam projector"
	desc = "A strange little doodad that projects an invisible beam that the EVA pistol's actual laser travels in, used as a focus that slightly weakens the laser's intensity. Or at least that's what the manual said."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "rxfm5_eva_doodad"
	attach_icon = "rxfm5_eva_doodad_a"
	slot = "under"

/obj/item/attachable/eva_doodad/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_5
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_5
	damage_mod -= BULLET_DAMAGE_MULT_TIER_4

/obj/item/attachable/flashlight/grip //Grip Light is here because it is a child object. Having it further down might cause a future coder a headache.
	name = "underbarrel flashlight grip"
	desc = "Holy smokes RO man, they put a grip on a flashlight! \nReduces recoil and scatter by a tiny amount. Boosts accuracy by a tiny amount. Works as a light source."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
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

// TODO: Move repair into a separate proc
/obj/item/attachable/flashlight/grip/attackby(obj/item/I, mob/user)
	. = ..()
	if (. & ATTACK_HINT_BREAK_ATTACK)
		return

	. |= ATTACK_HINT_NO_TELEGRAPH
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		to_chat(user, SPAN_NOTICE("Hold on there cowboy, that grip is bolted on. You are unable to modify it."))

/obj/item/attachable/flashlight/laser_light_combo //Unique attachment for the VP78 based on the fact it has a Laser-Light Module in AVP2010
	name = "VP78 Laser-Light Module"
	desc = "A Laser-Light module for the VP78 Service Pistol which is currently undergoing limited field testing as part of the USCMs next generation pistol program. All VP78 pistols come equipped with the module."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "vplaserlight"
	attach_icon = "vplaserlight_a"
	slot = "under"
	original_state = "vplaserlight"
	original_attach = "vplaserlight_a"

/obj/item/attachable/flashlight/laser_light_combo/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_9
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/flashlight/laser_light_combo/attackby(obj/item/combo_light, mob/user)
	. = ..()
	if (. & ATTACK_HINT_BREAK_ATTACK)
		return

	if(HAS_TRAIT(combo_light, TRAIT_TOOL_SCREWDRIVER))
		. |= ATTACK_HINT_NO_TELEGRAPH
		to_chat(user, SPAN_NOTICE("You are unable to modify it."))

/obj/item/attachable/magnetic_harness/lever_sling
	name = "R4T magnetic sling" //please don't make this attachable to any other guns...
	desc = "A custom sling designed for comfortable holstering of a 19th century lever action rifle, for some reason. Contains magnets specifically built to make sure the lever-action rifle never drops from your back, however they somewhat get in the way of the grip."
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "r4t-sling"
	attach_icon = "r4t-sling_a"
	slot = "under"
	wield_delay_mod = WIELD_DELAY_VERY_FAST
	retrieval_slot = WEAR_BACK

/obj/item/attachable/magnetic_harness/lever_sling/New()
	..()
	select_gamemode_skin(type)

/obj/item/attachable/magnetic_harness/lever_sling/Attach(obj/item/weapon/gun/G) //this is so the sling lines up correctly
	. = ..()
	G.attachable_offset["under_x"] = 15
	G.attachable_offset["under_y"] = 12


/obj/item/attachable/magnetic_harness/lever_sling/Detach(mob/user, obj/item/weapon/gun/detaching_gub)
	. = ..()
	detaching_gub.attachable_offset["under_x"] = 24
	detaching_gub.attachable_offset["under_y"] = 16

/obj/item/attachable/magnetic_harness/lever_sling/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
