//-------------------------------------------------------
//SMARTGUN

//Come get some.
/obj/item/weapon/gun/smartgun
	name = "\improper M56B smartgun"
	desc = "The actual firearm in the 4-piece M56B Smartgun System. Essentially a heavy, mobile machinegun.\nYou may toggle firing restrictions by using a special action.\nAlt-click it to open the feed cover and allow for reloading."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m56"
	item_state = "m56"
	fire_sound = "gun_smartgun"
	fire_rattle = "gun_smartgun_rattle"
	reload_sound = 'sound/weapons/handling/gun_sg_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_sg_unload.ogg'
	current_mag = /obj/item/ammo_magazine/smartgun
	flags_equip_slot = NO_FLAGS
	w_class = SIZE_HUGE
	force = 20
	wield_delay = WIELD_DELAY_FAST
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	var/obj/item/smartgun_battery/battery = null
	/// Whether the smartgun drains the battery (Ignored if requires_battery is false)
	var/requires_power = TRUE
	/// Whether the smartgun requires a battery
	var/requires_battery = TRUE
	/// Whether the smartgun requires a harness to use
	var/requires_harness = TRUE
	ammo = /datum/ammo/bullet/smartgun
	actions_types = list(
		/datum/action/item_action/smartgun/toggle_accuracy_improvement,
		/datum/action/item_action/smartgun/toggle_ammo_type,
		/datum/action/item_action/smartgun/toggle_auto_fire,
		/datum/action/item_action/smartgun/toggle_lethal_mode,
		/datum/action/item_action/smartgun/toggle_motion_detector,
		/datum/action/item_action/smartgun/toggle_recoil_compensation,
	)
	var/datum/ammo/ammo_primary = /datum/ammo/bullet/smartgun //Toggled ammo type
	var/datum/ammo/ammo_secondary = /datum/ammo/bullet/smartgun/armor_piercing //Toggled ammo type
	var/iff_enabled = TRUE //Begin with the safety on.
	var/secondary_toggled = 0 //which ammo we use
	var/recoil_compensation = 0
	var/accuracy_improvement = 0
	var/auto_fire = 0
	var/motion_detector = 0
	var/drain = 11
	var/range = 7
	var/angle = 2
	var/list/angle_list = list(180,135,90,60,30)
	var/obj/item/device/motiondetector/sg/MD
	var/long_range_cooldown = 2
	var/recycletime = 120
	var/cover_open = FALSE

	unacidable = 1
	indestructible = 1

	attachable_allowed = list(
		/obj/item/attachable/smartbarrel,
		/obj/item/attachable/flashlight,
	)

	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	gun_category = GUN_CATEGORY_HEAVY
	starting_attachment_types = list(/obj/item/attachable/smartbarrel)
	auto_retrieval_slot = WEAR_J_STORE
	start_semiauto = FALSE
	start_automatic = TRUE


/obj/item/weapon/gun/smartgun/Initialize(mapload, ...)
	ammo_primary = GLOB.ammo_list[ammo_primary] //Gun initialize calls replace_ammo() so we need to set these first.
	ammo_secondary = GLOB.ammo_list[ammo_secondary]
	MD = new(src)
	battery = new /obj/item/smartgun_battery(src)
	. = ..()
	update_icon()

/obj/item/weapon/gun/smartgun/Destroy()
	ammo_primary = null
	ammo_secondary = null
	QDEL_NULL(MD)
	QDEL_NULL(battery)
	. = ..()

/obj/item/weapon/gun/smartgun/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 17, "rail_y" = 18, "under_x" = 22, "under_y" = 14, "stock_x" = 22, "stock_y" = 14)

/obj/item/weapon/gun/smartgun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SG)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_8
	fa_max_scatter = SCATTER_AMOUNT_TIER_9
	if(accuracy_improvement)
		accuracy_mult += HIT_ACCURACY_MULT_TIER_3
	else
		accuracy_mult += HIT_ACCURACY_MULT_TIER_1
	if(recoil_compensation)
		scatter = SCATTER_AMOUNT_TIER_10
		recoil = RECOIL_OFF
	else
		scatter = SCATTER_AMOUNT_TIER_6
		recoil = RECOIL_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/smartgun/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/smartgun/get_examine_text(mob/user)
	. = ..()
	var/rounds = 0
	if(current_mag && current_mag.current_rounds)
		rounds = current_mag.current_rounds
	var/message = "[rounds ? "Ammo counter shows [rounds] round\s remaining." : "It's dry."]"
	. += message
	. += "The restriction system is [iff_enabled ? "<B>on</b>" : "<B>off</b>"]."

	if(battery && get_dist(user, src) <= 1)
		. += "A small gauge on [battery] reads: Power: [battery.power_cell.charge] / [battery.power_cell.maxcharge]."

/obj/item/weapon/gun/smartgun/clicked(mob/user, list/mods)
	if(mods["alt"])
		if(!CAN_PICKUP(user, src))
			return ..()
		if(!locate(src) in list(user.get_active_hand(), user.get_inactive_hand()))
			return TRUE
		if(user.get_active_hand() && user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("You can't do that with your hands full!"))
			return TRUE
		if(!cover_open)
			playsound(src.loc, 'sound/handling/smartgun_open.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You open \the [src]'s feed cover, allowing the drum to be removed."))
			cover_open = TRUE
		else
			playsound(src.loc, 'sound/handling/smartgun_close.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You close \the [src]'s feed cover."))
			cover_open = FALSE
		update_icon()
		return TRUE
	else
		return ..()

/obj/item/weapon/gun/smartgun/attackby(obj/item/attacking_object, mob/user)
	if(istype(attacking_object, /obj/item/smartgun_battery))
		var/obj/item/smartgun_battery/new_cell = attacking_object
		visible_message(SPAN_NOTICE("[user] swaps out the power cell in [src]."),
			SPAN_NOTICE("You swap out the power cell in [src] and drop the old one."))
		to_chat(user, SPAN_NOTICE("The new cell contains: [new_cell.power_cell.charge] power."))
		battery.update_icon()
		battery.forceMove(get_turf(user))
		battery = new_cell
		user.drop_inv_item_to_loc(new_cell, src)
		playsound(src, 'sound/machines/click.ogg', 25, 1)
		return

	return ..()

/obj/item/weapon/gun/smartgun/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("\The [src]'s feed cover is closed! You can't put a new drum in! (alt-click to open it)"))
		return
	. = ..()

/obj/item/weapon/gun/smartgun/unload(mob/user, reload_override, drop_override, loc_override)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("\The [src]'s feed cover is closed! You can't take out the drum! (alt-click to open it)"))
		return
	. = ..()

/obj/item/weapon/gun/smartgun/update_icon()
	. = ..()
	if(cover_open)
		overlays += "+[base_gun_icon]_cover_open"
	else
		overlays += "+[base_gun_icon]_cover_closed"

//---ability actions--\\

/datum/action/item_action/smartgun/action_activate()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.is_mob_incapacitated() || G.get_active_firearm(H, FALSE) != holder_item)
		return

/datum/action/item_action/smartgun/update_button_icon()
	return

/datum/action/item_action/smartgun/toggle_motion_detector/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Motion Detector"
	action_icon_state = "motion_detector"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_motion_detector/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_motion_detector(usr)

/datum/action/item_action/smartgun/toggle_motion_detector/proc/update_icon()
	if(!holder_item)
		return
	var/obj/item/weapon/gun/smartgun/G = holder_item
	if(G.motion_detector)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

/datum/action/item_action/smartgun/toggle_auto_fire/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Auto Fire"
	action_icon_state = "autofire"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_auto_fire/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_auto_fire(usr)

/datum/action/item_action/smartgun/toggle_auto_fire/proc/update_icon()
	if(!holder_item)
		return
	var/obj/item/weapon/gun/smartgun/G = holder_item
	if(G.auto_fire)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

/datum/action/item_action/smartgun/toggle_accuracy_improvement/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Accuracy Improvement"
	action_icon_state = "accuracy_improvement"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_accuracy_improvement/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_accuracy_improvement(usr)
	if(G.accuracy_improvement)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

/datum/action/item_action/smartgun/toggle_recoil_compensation/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Recoil Compensation"
	action_icon_state = "recoil_compensation"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_recoil_compensation/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_recoil_compensation(usr)
	if(G.recoil_compensation)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

/datum/action/item_action/smartgun/toggle_lethal_mode/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle IFF"
	action_icon_state = "iff_toggle_on"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_lethal_mode/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_lethal_mode(usr)
	if(G.iff_enabled)
		action_icon_state = "iff_toggle_on"
	else
		action_icon_state = "iff_toggle_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_ammo_type/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Ammo Type"
	action_icon_state = "ammo_swap_normal"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_ammo_type/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_ammo_type(usr)

/datum/action/item_action/smartgun/toggle_ammo_type/proc/update_icon()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	if(G.secondary_toggled)
		action_icon_state = "ammo_swap_ap"
	else
		action_icon_state = "ammo_swap_normal"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

//more general procs

/obj/item/weapon/gun/smartgun/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user))
			return FALSE
		var/mob/living/carbon/human/H = user
		if(!skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_SMARTGUN) && !skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL))
			balloon_alert(user, "insufficient skills")
			return FALSE
		if(requires_harness)
			if(!H.wear_suit || !(H.wear_suit.flags_inventory & SMARTGUN_HARNESS))
				balloon_alert(user, "harness required")
				return FALSE
		if(cover_open)
			to_chat(H, SPAN_WARNING("You can't fire \the [src] with the feed cover open! (alt-click to close)"))
			balloon_alert(user, "cannot fire; feed cover open")
			return FALSE

/obj/item/weapon/gun/smartgun/unique_action(mob/user)
	if(isobserver(usr) || isxeno(usr))
		return
	toggle_ammo_type(usr)

/obj/item/weapon/gun/smartgun/proc/toggle_ammo_type(mob/user)
	if(!iff_enabled)
		to_chat(user, "[icon2html(src, usr)] Can't switch ammunition type when \the [src]'s fire restriction is disabled.")
		return
	secondary_toggled = !secondary_toggled
	to_chat(user, "[icon2html(src, usr)] You changed \the [src]'s ammo preparation procedures. You now fire [secondary_toggled ? "armor shredding rounds" : "highly precise rounds"].")
	balloon_alert(user, "firing [secondary_toggled ? "armor shredding" : "highly precise"]")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	ammo = secondary_toggled ? ammo_secondary : ammo_primary
	var/datum/action/item_action/smartgun/toggle_ammo_type/TAT = locate(/datum/action/item_action/smartgun/toggle_ammo_type) in actions
	TAT.update_icon()

/obj/item/weapon/gun/smartgun/replace_ammo()
	..()
	ammo = secondary_toggled ? ammo_secondary : ammo_primary

/obj/item/weapon/gun/smartgun/proc/toggle_lethal_mode(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [iff_enabled? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s fire restriction. You will [iff_enabled ? "harm anyone in your way" : "target through IFF"].")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	iff_enabled = !iff_enabled
	ammo = ammo_primary
	secondary_toggled = FALSE
	if(iff_enabled)
		add_bullet_trait(BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff))
		drain += 10
		MD.iff_signal = initial(MD.iff_signal)
	if(!iff_enabled)
		remove_bullet_trait("iff")
		drain -= 10
		MD.iff_signal = null

/obj/item/weapon/gun/smartgun/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	if(!requires_battery)
		return ..()

	if(battery)
		if(!requires_power)
			return ..()
		if(drain_battery())
			return ..()

/obj/item/weapon/gun/smartgun/proc/drain_battery(override_drain)

	var/actual_drain = (rand(drain / 2, drain) / 25)

	if(override_drain)
		actual_drain = (rand(override_drain / 2, override_drain) / 25)

	if(battery && battery.power_cell.charge > 0)
		if(battery.power_cell.charge > actual_drain)
			battery.power_cell.charge -= actual_drain
		else
			battery.power_cell.charge = 0
			to_chat(usr, SPAN_WARNING("[src] emits a low power warning and immediately shuts down!"))
			return FALSE
		return TRUE
	if(!battery || battery.power_cell.charge == 0)
		balloon_alert(usr, "low power")
		return FALSE
	return FALSE

/obj/item/weapon/gun/smartgun/proc/toggle_recoil_compensation(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [recoil_compensation? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s recoil compensation.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	recoil_compensation = !recoil_compensation
	if(recoil_compensation)
		drain += 50
	else
		drain -= 50
	recalculate_attachment_bonuses() //Includes set_gun_config_values() as well as attachments.

/obj/item/weapon/gun/smartgun/proc/toggle_accuracy_improvement(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [accuracy_improvement? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s accuracy improvement.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	accuracy_improvement = !accuracy_improvement
	if(accuracy_improvement)
		drain += 50
	else
		drain -= 50
	recalculate_attachment_bonuses()

/obj/item/weapon/gun/smartgun/proc/toggle_auto_fire(mob/user)
	if(!(flags_item & WIELDED))
		to_chat(user, "[icon2html(src, usr)] You need to wield \the [src] to enable autofire.")
		return //Have to be actually be wielded.
	to_chat(user, "[icon2html(src, usr)] You [auto_fire? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s auto fire mode.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	auto_fire = !auto_fire
	var/datum/action/item_action/smartgun/toggle_auto_fire/TAF = locate(/datum/action/item_action/smartgun/toggle_auto_fire) in actions
	TAF.update_icon()
	auto_fire()

/obj/item/weapon/gun/smartgun/proc/auto_fire()
	if(auto_fire)
		drain += 150
		if(!motion_detector)
			START_PROCESSING(SSobj, src)
	if(!auto_fire)
		drain -= 150
		if(!motion_detector)
			STOP_PROCESSING(SSobj, src)

/obj/item/weapon/gun/smartgun/process()
	if(!auto_fire && !motion_detector)
		STOP_PROCESSING(SSobj, src)
	if(auto_fire)
		auto_prefire()
	if(motion_detector)
		recycletime--
		if(!recycletime)
			recycletime = initial(recycletime)
			MD.refresh_blip_pool()

		long_range_cooldown--
		if(long_range_cooldown)
			return
		long_range_cooldown = initial(long_range_cooldown)
		MD.scan()

/obj/item/weapon/gun/smartgun/proc/auto_prefire(warned) //To allow the autofire delay to properly check targets after waiting.
	if(ishuman(loc) && (flags_item & WIELDED))
		var/human_user = loc
		target = get_target(human_user)
		process_shot(human_user, warned)
	else
		auto_fire = FALSE
		var/datum/action/item_action/smartgun/toggle_auto_fire/TAF = locate(/datum/action/item_action/smartgun/toggle_auto_fire) in actions
		TAF.update_icon()
		auto_fire()

/obj/item/weapon/gun/smartgun/proc/get_target(mob/living/user)
	var/list/conscious_targets = list()
	var/list/unconscious_targets = list()
	var/list/turf/path = list()
	var/turf/T

	for(var/mob/living/M in orange(range, user)) // orange allows sentry to fire through gas and darkness
		if((M.stat & DEAD)) continue // No dead or non living.

		if(M.get_target_lock(user.faction_group)) continue
		if(angle > 0)
			var/opp
			var/adj

			switch(user.dir)
				if(NORTH)
					opp = user.x-M.x
					adj = M.y-user.y
				if(SOUTH)
					opp = user.x-M.x
					adj = user.y-M.y
				if(EAST)
					opp = user.y-M.y
					adj = M.x-user.x
				if(WEST)
					opp = user.y-M.y
					adj = user.x-M.x

			var/r = 9999
			if(adj != 0) r = abs(opp/adj)
			var/angledegree = arcsin(r/sqrt(1+(r*r)))
			if(adj < 0)
				continue

			if((angledegree*2) > angle_list[angle])
				continue

		path = get_line(user, M)

		if(path.len)
			var/blocked = FALSE
			for(T in path)
				if(T.density || T.opacity)
					blocked = TRUE
					break
				for(var/obj/structure/S in T)
					if(S.opacity)
						blocked = TRUE
						break
				for(var/obj/structure/machinery/MA in T)
					if(MA.opacity)
						blocked = TRUE
						break
				if(blocked)
					break
			if(blocked)
				continue
			if(M.stat & UNCONSCIOUS)
				unconscious_targets += M
			else
				conscious_targets += M

	if(conscious_targets.len)
		. = pick(conscious_targets)
	else if(unconscious_targets.len)
		. = pick(unconscious_targets)

/obj/item/weapon/gun/smartgun/proc/process_shot(mob/living/user, warned)
	set waitfor = 0


	if(!target)
		return //Acquire our victim.

	if(!ammo)
		return

	if(target && (world.time-last_fired >= 3)) //Practical firerate is limited mainly by process delay; this is just to make sure it doesn't fire too soon after a manual shot or slip a shot into an ongoing burst.
		if(world.time-last_fired >= 300 && !warned) //if we haven't fired for a while, beep first
			playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
			addtimer(CALLBACK(src, /obj/item/weapon/gun/smartgun/proc/auto_prefire, TRUE), 3)
			return

		Fire(target,user)

	target = null

/obj/item/weapon/gun/smartgun/proc/toggle_motion_detector(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [motion_detector? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s motion detector.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	motion_detector = !motion_detector
	var/datum/action/item_action/smartgun/toggle_motion_detector/TMD = locate(/datum/action/item_action/smartgun/toggle_motion_detector) in actions
	TMD.update_icon()
	motion_detector()

/obj/item/weapon/gun/smartgun/proc/motion_detector()
	if(motion_detector)
		drain += 15
		if(!auto_fire)
			START_PROCESSING(SSobj, src)
	if(!motion_detector)
		drain -= 15
		if(!auto_fire)
			STOP_PROCESSING(SSobj, src)

//CO SMARTGUN
/obj/item/weapon/gun/smartgun/co
	name = "\improper M56C 'Cavalier' smartgun"
	desc = "The actual firearm in the 4-piece M56C Smartgun system. Back order only. Besides a more robust weapons casing, an ID lock system and a fancy paintjob, the gun's performance is identical to the standard-issue M56B.\nAlt-click it to open the feed cover and allow for reloading."
	icon_state = "m56c"
	item_state = "m56c"
	var/mob/living/carbon/human/linked_human
	var/is_locked = TRUE

/obj/item/weapon/gun/smartgun/co/Initialize(mapload, ...)
	LAZYADD(actions_types, /datum/action/item_action/co_sg/toggle_id_lock)
	. = ..()

/obj/item/weapon/gun/smartgun/co/able_to_fire(mob/user)
	. = ..()
	if(is_locked && linked_human && linked_human != user)
		if(linked_human.is_revivable() || linked_human.stat != DEAD)
			to_chat(user, SPAN_WARNING("[icon2html(src, usr)] Trigger locked by [src]. Unauthorized user."))
			playsound(loc,'sound/weapons/gun_empty.ogg', 25, 1)
			return FALSE

		linked_human = null
		is_locked = FALSE
		UnregisterSignal(linked_human, COMSIG_PARENT_QDELETING)

// ID lock action \\

/datum/action/item_action/co_sg/action_activate()
	var/obj/item/weapon/gun/smartgun/co/protag_gun = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/protagonist = owner
	if(protagonist.is_mob_incapacitated() || protag_gun.get_active_firearm(protagonist, FALSE) != holder_item)
		return

/datum/action/item_action/co_sg/update_button_icon()
	return

/datum/action/item_action/co_sg/toggle_id_lock/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle ID lock"
	action_icon_state = "id_lock_locked"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/co_sg/toggle_id_lock/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/co/protag_gun = holder_item
	protag_gun.toggle_lock()
	if(protag_gun.is_locked)
		action_icon_state = "id_lock_locked"
	else
		action_icon_state = "id_lock_unlocked"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/obj/item/weapon/gun/smartgun/co/proc/toggle_lock(mob/user)
	if(linked_human && usr != linked_human)
		to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] Action denied by \the [src]. Unauthorized user."))
		return
	else if(!linked_human)
		name_after_co(usr)

	is_locked = !is_locked
	to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] You [is_locked? "lock": "unlock"] \the [src]."))
	playsound(loc,'sound/machines/click.ogg', 25, 1)

// action end \\

/obj/item/weapon/gun/smartgun/co/pickup(user)
	if(!linked_human)
		src.name_after_co(user, src)
		to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] You pick up \the [src], registering yourself as its owner."))
	..()


/obj/item/weapon/gun/smartgun/co/proc/name_after_co(mob/living/carbon/human/H, obj/item/weapon/gun/smartgun/co/I)
	linked_human = H
	RegisterSignal(linked_human, COMSIG_PARENT_QDELETING, PROC_REF(remove_idlock))

/obj/item/weapon/gun/smartgun/co/get_examine_text()
	. = ..()
	if(linked_human)
		if(is_locked)
			. += SPAN_NOTICE("It is registered to [linked_human].")
		else
			. += SPAN_NOTICE("It is registered to [linked_human] but has its fire restrictions unlocked.")
	else
		. += SPAN_NOTICE("It's unregistered. Pick it up to register yourself as its owner.")
	if(!iff_enabled)
		. += SPAN_WARNING("Its IFF restrictions are disabled.")

/obj/item/weapon/gun/smartgun/co/proc/remove_idlock()
	SIGNAL_HANDLER
	linked_human = null

/obj/item/weapon/gun/smartgun/dirty
	name = "\improper M56D 'Dirty' smartgun"
	desc = "The actual firearm in the 4-piece M56D Smartgun System. If you have this, you're about to bring some serious pain to anyone in your way.\nYou may toggle firing restrictions by using a special action.\nAlt-click it to open the feed cover and allow for reloading."
	current_mag = /obj/item/ammo_magazine/smartgun/dirty
	ammo = /obj/item/ammo_magazine/smartgun/dirty
	ammo_primary = /datum/ammo/bullet/smartgun/dirty//Toggled ammo type
	ammo_secondary = /datum/ammo/bullet/smartgun/dirty/armor_piercing///Toggled ammo type
	flags_gun_features = GUN_WY_RESTRICTED|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/smartgun/dirty/Initialize(mapload, ...)
	. = ..()
	MD.iff_signal = FACTION_PMC


//TERMINATOR SMARTGUN
/obj/item/weapon/gun/smartgun/dirty/elite
	name = "\improper M56T 'Terminator' smartgun"
	desc = "The actual firearm in the 4-piece M56T Smartgun System. If you have this, you're about to bring some serious pain to anyone in your way.\nYou may toggle firing restrictions by using a special action.\nAlt-click it to open the feed cover and allow for reloading."

/obj/item/weapon/gun/smartgun/dirty/elite/Initialize(mapload, ...)
	. = ..()
	MD.iff_signal = FACTION_WY_DEATHSQUAD

/obj/item/weapon/gun/smartgun/dirty/elite/set_gun_config_values()
	..()
	set_burst_amount(BURST_AMOUNT_TIER_5)
	set_burst_delay(FIRE_DELAY_TIER_12)
	if(!recoil_compensation)
		scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	set_fire_delay(FIRE_DELAY_TIER_12)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_10
	fa_max_scatter = SCATTER_AMOUNT_NONE


// CLF SMARTGUN

/obj/item/weapon/gun/smartgun/clf
	name = "\improper M56B 'Freedom' smartgun"
	desc = "The actual firearm in the 4-piece M56B Smartgun System. Essentially a heavy, mobile machinegun. This one has the CLF logo carved over the manufacturing stamp.\nYou may toggle firing restrictions by using a special action.\nAlt-click it to open the feed cover and allow for reloading."

/obj/item/weapon/gun/smartgun/clf/Initialize(mapload, ...)
	. = ..()
	MD.iff_signal = FACTION_CLF

/obj/item/weapon/gun/smartgun/admin
	requires_power = FALSE
	requires_battery = FALSE
	requires_harness = FALSE

/obj/item/smartgun_battery
	name = "smartgun DV9 battery"
	desc = "A standard-issue 9-volt lithium dry-cell battery, most commonly used within the USCMC to power smartguns. Per the manual, one battery is good for up to 50000 rounds and plugs directly into the smartgun's power receptacle, which is only compatible with this type of battery. Various auxiliary modes usually bring the round count far lower. While this cell is incompatible with most standard electrical system, it can be charged by common rechargers in a pinch. USCMC smartgunners often guard them jealously."

	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "smartguncell"

	force = 5
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL

	var/obj/item/cell/high/power_cell

/obj/item/smartgun_battery/Initialize(mapload)
	. = ..()

	power_cell = new(src)

/obj/item/smartgun_battery/get_examine_text(mob/user)
	. = ..()

	. += SPAN_NOTICE("The power indicator reads [power_cell.charge] charge out of [power_cell.maxcharge] total.")

/obj/item/weapon/gun/smartgun/rmc
	name = "\improper L56A2 smartgun"
	desc = "The actual firearm in the 2-piece L56A2 Smartgun System. This Variant is used by the Three World Empires Royal Marines Commando units.\nYou may toggle firing restrictions by using a special action.\nAlt-click it to open the feed cover and allow for reloading."
	current_mag = /obj/item/ammo_magazine/smartgun/holo_targetting
	ammo = /obj/item/ammo_magazine/smartgun/holo_targetting
	ammo_primary = /datum/ammo/bullet/smartgun/holo_target //Toggled ammo type
	ammo_secondary = /datum/ammo/bullet/smartgun/holo_target/ap ///Toggled ammo type
	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/twe_guns.dmi'
	icon_state = "magsg"
	item_state = "magsg"
	starting_attachment_types = list(/obj/item/attachable/l56a2_smartgun)

/obj/item/weapon/gun/smartgun/rmc/Initialize(mapload, ...)
	. = ..()
	MD.iff_signal = FACTION_TWE
