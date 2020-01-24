//-------------------------------------------------------
//SNIPER RIFLES
//Keyword rifles. They are subtype of rifles, but still contained here as a specialist weapon.

//Because this parent type did not exist
//Note that this means that snipers will have a slowdown of 3, due to the scope
/obj/item/weapon/gun/rifle/sniper
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	gun_skill_category = SKILL_SPEC_WEAPONS
	wield_delay = WIELD_DELAY_SLOW

	able_to_fire(mob/living/user)
		. = ..()
		if(. && istype(user)) //Let's check all that other stuff first.
			if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && user.mind.cm_skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SNIPER)
				to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
				return 0

//Pow! Headshot.
/obj/item/weapon/gun/rifle/sniper/M42A
	name = "\improper M42A scoped rifle"
	desc = "A heavy sniper rifle manufactured by Armat Systems. It has a scope system and fires armor penetrating rounds out of a 15-round magazine.\n'Peace Through Superior Firepower'"
	icon_state = "m42a"
	item_state = "m42a"
	unacidable = TRUE
	indestructible = 1

	fire_sound = 'sound/weapons/gun_sniper.ogg'
	current_mag = /obj/item/ammo_magazine/sniper
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod)
	starting_attachment_types = list(/obj/item/attachable/sniperbarrel)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER

/obj/item/weapon/gun/rifle/sniper/M42A/New()
	..()
	select_gamemode_skin(/obj/item/weapon/gun/rifle/sniper/M42A) //use j_ for legacy variant via VV

/obj/item/weapon/gun/rifle/sniper/M42A/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/sniper/M42A/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 20, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)


/obj/item/weapon/gun/rifle/sniper/M42A/set_gun_config_values()
	..()
	fire_delay = config.high_fire_delay*3
	burst_amount = config.min_burst_value
	accuracy_mult = config.base_hit_accuracy_mult * 3 //you HAVE to be able to hit
	scatter = config.low_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.min_recoil_value

/obj/item/weapon/gun/rifle/sniper/M42B
	name = "\improper XM42B experimental anti-tank rifle"
	desc = "An experimental anti-tank rifle produced by Armat Systems, currently undergoing field testing. Chambered in 10x99mm Caseless."
	icon_state = "xm42b"
	item_state = "xm42b"
	unacidable = TRUE
	indestructible = 1

	fire_sound = 'sound/weapons/sniper_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/anti_tank
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/sniperbarrel)

/obj/item/weapon/gun/rifle/sniper/M42B/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.icon_state = "pmcscope"
	S.attach_icon = "pmcscope"
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/sniper/M42B/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 15, "rail_y" = 19, "under_x" = 20, "under_y" = 15, "stock_x" = 20, "stock_y" = 15)


/obj/item/weapon/gun/rifle/sniper/M42B/set_gun_config_values()
	..()
	fire_delay = config.max_fire_delay * 8 //Big boy damage, but it takes a lot of time to fire a shot.
	burst_amount = config.min_burst_value
	accuracy_mult = config.base_hit_accuracy_mult + 2*config.max_hit_accuracy_mult
	scatter = config.min_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.max_recoil_value

/obj/item/weapon/gun/rifle/sniper/M42B/afterattack(atom/target, mob/user, flag)
	if(able_to_fire(user))
		if(get_dist(target,user) <= 8)
			to_chat(user, SPAN_WARNING("The [src] beeps, indicating that the target is within an unsafe proximity to the rifle, refusing to fire."))
			return
		else ..()


/obj/item/weapon/gun/rifle/sniper/elite
	name = "\improper M42C anti-tank sniper rifle"
	desc = "A high end mag-rail heavy sniper rifle from Weston-Armat chambered in the heaviest ammo available, 10x99mm Caseless."
	icon_state = "m42c"
	item_state = "m42c" //NEEDS A TWOHANDED STATE

	fire_sound = 'sound/weapons/sniper_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/elite
	force = 17
	zoomdevicename = "scope"
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WY_RESTRICTED|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/sniperbarrel)

/obj/item/weapon/gun/rifle/sniper/elite/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.icon_state = "pmcscope"
	S.attach_icon = "pmcscope"
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/sniper/elite/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 15, "rail_y" = 19, "under_x" = 20, "under_y" = 15, "stock_x" = 20, "stock_y" = 15)


/obj/item/weapon/gun/rifle/sniper/elite/set_gun_config_values()
	..()
	fire_delay = config.high_fire_delay*5
	burst_amount = config.min_burst_value
	accuracy_mult = config.base_hit_accuracy_mult + config.max_hit_accuracy_mult
	scatter = config.low_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.max_recoil_value

/obj/item/weapon/gun/rifle/sniper/elite/simulate_recoil(total_recoil = 0, mob/user, atom/target)
	. = ..()
	if(.)
		var/mob/living/carbon/human/PMC_sniper = user
		if(PMC_sniper.lying == 0 && !istype(PMC_sniper.wear_suit,/obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC) && !istype(PMC_sniper.wear_suit,/obj/item/clothing/suit/storage/marine/veteran))
			PMC_sniper.visible_message(SPAN_WARNING("[PMC_sniper] is blown backwards from the recoil of the [src]!"),SPAN_HIGHDANGER("You are knocked prone by the blowback!"))
			step(PMC_sniper,turn(PMC_sniper.dir,180))
			PMC_sniper.KnockDown(5)

//SVD //Based on the actual Dragunov sniper rifle.

/obj/item/weapon/gun/rifle/sniper/svd
	name = "\improper SVD Dragunov-033 sniper rifle"
	desc = "A sniper variant of the MAR-40 rifle, with a new stock, barrel, and scope. It doesn't have the punch of modern sniper rifles, but it's finely crafted in 2133 by someone probably illiterate. Fires 7.62x54mmR rounds."
	icon_state = "svd003"
	item_state = "svd003" //NEEDS A ONE HANDED STATE

	fire_sound = 'sound/weapons/gun_kt42.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/svd
	attachable_allowed = list(
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/gyro,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/bipod,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/scope/slavic)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY


/obj/item/weapon/gun/rifle/sniper/svd/handle_starting_attachment()
	..()
	var/obj/item/attachable/S = new /obj/item/attachable/scope/slavic(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)
	S = new /obj/item/attachable/slavicbarrel(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)
	S = new /obj/item/attachable/stock/slavic(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/sniper/svd/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 13, "rail_y" = 19, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/sniper/svd/set_gun_config_values()
	..()
	fire_delay = config.mhigh_fire_delay*2
	burst_amount = config.low_burst_value
	accuracy_mult = config.base_hit_accuracy_mult * 3 //you HAVE to be able to hit
	scatter = config.low_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.min_recoil_value



//M4RA marksman rifle

/obj/item/weapon/gun/rifle/m4ra
	name = "\improper M4RA battle rifle"
	desc = "The M4RA battle rifle is a designated marksman rifle in service with the USCM. Only fielded in small numbers, and sporting a bullpup configuration, the M4RA battle rifle is perfect for reconnaissance and fire support teams.\nIt is equipped with rail scope and takes 10x24mm A19 high velocity magazines."
	icon_state = "m41b"
	item_state = "m4ra" //PLACEHOLDER
	unacidable = TRUE
	indestructible = 1

	fire_sound = 'sound/weapons/gun_m4ra.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m4ra
	force = 16
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/bipod,
						/obj/item/attachable/compensator)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	gun_skill_category = SKILL_SPEC_WEAPONS
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/marksman)

/obj/item/weapon/gun/rifle/m4ra/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.hidden = TRUE // the gun's sprite already shows a scope
	S.flags_attach_features &= ~ATTACH_REMOVABLE //Don't want it coming off.
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/m4ra/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 19,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/m4ra/set_gun_config_values()
	..()
	fire_delay = config.high_fire_delay
	burst_amount = config.med_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult
	scatter = config.low_scatter_value
	burst_scatter_mult = config.low_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.min_recoil_value

/obj/item/weapon/gun/rifle/m4ra/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && user.mind.cm_skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SCOUT)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return 0



//-------------------------------------------------------
//SMARTGUN

//Come get some.
/obj/item/weapon/gun/smartgun
	name = "\improper M56B smartgun"
	desc = "The actual firearm in the 4-piece M56B Smartgun System. Essentially a heavy, mobile machinegun.\nYou may toggle firing restrictions by using a special action."
	icon_state = "m56"
	item_state = "m56"

	fire_sound = "gun_smartgun"
	reload_sound = 'sound/weapons/handling/gun_sg_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_sg_unload.ogg'
	current_mag = /obj/item/ammo_magazine/smartgun
	flags_equip_slot = NO_FLAGS
	w_class = SIZE_HUGE
	force = 20
	wield_delay = WIELD_DELAY_FAST
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	var/powerpack = null
	ammo = /datum/ammo/bullet/smartgun/marine
	var/datum/ammo/ammo_primary = /datum/ammo/bullet/smartgun/marine //Toggled ammo type
	var/datum/ammo/ammo_secondary = /datum/ammo/bullet/smartgun/marine/armor_piercing //Toggled ammo type
	var/shells_fired_max = 20 //Smartgun only; once you fire # of shells, it will attempt to reload automatically. If you start the reload, the counter resets.
	var/shells_fired_now = 0 //The actual counter used. shells_fired_max is what it is compared to.
	iff_enabled = TRUE //Begin with the safety on.
	iff_enabled_current = TRUE
	var/secondary_toggled = 0 //which ammo we use
	var/recoil_compensation = 0
	var/accuracy_improvement = 0
	var/auto_fire = 0
	var/motion_detector = 0
	var/drain = 11
	var/range = 12
	var/angle = 2
	var/list/angle_list = list(180,135,90,60,30)
	var/detector_range = 14
	var/ping_count = 0
	var/list/blip_pool = list()
	var/detector_mode = MOTION_DETECTOR_LONG
	var/recycletime = 120
	var/long_range_cooldown = 2
	var/blip_type = "detector"
	var/iff_signal = ACCESS_IFF_MARINE

	unacidable = 1
	indestructible = 1

	gun_skill_category = SKILL_SMARTGUN
	attachable_allowed = list(
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/flashlight)

	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY


/obj/item/weapon/gun/smartgun/New()
	..()
	ammo_primary = ammo_list[ammo_primary]
	ammo_secondary = ammo_list[ammo_secondary]



/obj/item/weapon/gun/smartgun/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 17, "rail_y" = 18, "under_x" = 22, "under_y" = 14, "stock_x" = 22, "stock_y" = 14)

/obj/item/weapon/gun/smartgun/set_gun_config_values()
	..()
	fire_delay = config.min_fire_delay
	burst_amount = config.med_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult + config.min_hit_accuracy_mult
	scatter = config.med_scatter_value
	burst_scatter_mult = config.low_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.min_recoil_value

/obj/item/weapon/gun/smartgun/examine(mob/user)
	..()
	var/rounds = 0
	if(current_mag && current_mag.current_rounds)
		rounds = current_mag.current_rounds
	var/message = "[rounds ? "Ammo counter shows [rounds] round\s remaining." : "It's dry."]"
	to_chat(user, message)
	to_chat(user, "The restriction system is [iff_enabled ? "<B>on</b>" : "<B>off</b>"].")

/obj/item/weapon/gun/smartgun/check_iff()
	..()
	if(iff_enabled)
		drain += 10
	if(!iff_enabled)
		drain -= 10
	if(!powerpack)
		link_powerpack(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_lethal_mode()
	set category = "Smartgun"
	set name = "Toggle Lethal Mode"

	if(isobserver(usr) || isXeno(usr))
		return
	if(!powerpack)
		link_powerpack(usr)
	toggle_lethal_mode(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_ammo_type()
	set category = "Smartgun"
	set name = "Toggle Ammo Type"

	if(isobserver(usr) || isXeno(usr))
		return
	if(!powerpack)
		link_powerpack(usr)
	toggle_ammo_type(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_recoil_compensation()
	set category = "Smartgun"
	set name = "Toggle Recoil Compensation"

	if(isobserver(usr) || isXeno(usr))
		return
	if(!powerpack)
		link_powerpack(usr)
	toggle_recoil_compensation(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_accuracy_improvement()
	set category = "Smartgun"
	set name = "Toggle Accuracy Improvement"

	if(isobserver(usr) || isXeno(usr))
		return
	if(!powerpack)
		link_powerpack(usr)
	toggle_accuracy_improvement(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_auto_fire()
	set category = "Smartgun"
	set name = "Toggle Auto Fire"

	if(isobserver(usr) || isXeno(usr))
		return
	if(!powerpack)
		link_powerpack(usr)
	toggle_auto_fire(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_motion_detector()
	set category = "Smartgun"
	set name = "Toggle Motion Detector"

	if(isobserver(usr) || isXeno(usr))
		return
	if(!powerpack)
		link_powerpack(usr)
	toggle_motion_detector(usr)



/obj/item/weapon/gun/smartgun/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user)) return 0
		var/mob/living/carbon/human/H = user
		if(!skillcheck(user, SKILL_SMARTGUN, SKILL_SMART_USE))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return 0
		if ( !istype(H.wear_suit,/obj/item/clothing/suit/storage/marine/smartgunner) || !istype(H.back,/obj/item/smartgun_powerpack))
			click_empty(H)
			return 0


/obj/item/weapon/gun/smartgun/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) current_mag.current_rounds++
	return 1

/obj/item/weapon/gun/smartgun/unique_action(mob/user)
	if(isobserver(usr) || isXeno(usr))
		return
	if(!powerpack)
		link_powerpack(usr)
	toggle_ammo_type(usr)

/obj/item/weapon/gun/smartgun/proc/toggle_ammo_type(mob/user)
	if(!iff_enabled)
		to_chat(user, "[htmlicon(src, usr)] Can't switch ammunition type when the [src]'s fire restriction is disabled.")
		return
	secondary_toggled = !secondary_toggled
	to_chat(user, "[htmlicon(src, usr)] You changed the [src]'s ammo preparation procedures. You now fire [secondary_toggled ? "armor shredding rounds" : "highly precise rounds"].")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	ammo = secondary_toggled ? ammo_secondary : ammo_primary

/obj/item/weapon/gun/smartgun/proc/toggle_lethal_mode(mob/user)
	to_chat(user, "[htmlicon(src, usr)] You [iff_enabled? "<B>disable</b>" : "<B>enable</b>"] the [src]'s fire restriction. You will [iff_enabled ? "harm anyone in your way" : "target through IFF"].")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	iff_enabled = !iff_enabled
	ammo = ammo_primary
	check_iff()

/obj/item/weapon/gun/smartgun/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	if(!src.powerpack)
		if(!link_powerpack(user))
			click_empty(user)
			unlink_powerpack()
			return
	if(src.powerpack)
		var/obj/item/smartgun_powerpack/pp = user.back
		if(istype(pp))
			var/obj/item/cell/c = pp.pcell
			var/d = drain
			if(flags_gun_features & GUN_BURST_ON)
				d = drain*burst_amount*1.5
			if(pp.drain_powerpack(d, c))
				..()


/obj/item/weapon/gun/smartgun/proc/link_powerpack(var/mob/user)
	if(user.back)
		if(istype(user.back,/obj/item/smartgun_powerpack))
			src.powerpack = user.back
			return TRUE
	return FALSE

/obj/item/weapon/gun/smartgun/proc/unlink_powerpack()
	src.powerpack = null

/obj/item/weapon/gun/smartgun/proc/toggle_recoil_compensation(mob/user)
	to_chat(user, "[htmlicon(src, usr)] You [recoil_compensation? "<B>disable</b>" : "<B>enable</b>"] the [src]'s recoil compensation.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	recoil_compensation = !recoil_compensation
	recoil_compensation()

/obj/item/weapon/gun/smartgun/proc/recoil_compensation()
	if(recoil_compensation)
		src.scatter = config.min_scatter_value
		src.recoil = config.no_recoil_value
		src.drain += 50
	if(!recoil_compensation)
		src.scatter = config.med_scatter_value
		src.recoil = config.med_recoil_value
		src.drain -= 50

/obj/item/weapon/gun/smartgun/proc/toggle_accuracy_improvement(mob/user)
	to_chat(user, "[htmlicon(src, usr)] You [accuracy_improvement? "<B>disable</b>" : "<B>enable</b>"] the [src]'s accuracy improvement.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	accuracy_improvement = !accuracy_improvement
	accuracy_improvement()

/obj/item/weapon/gun/smartgun/proc/accuracy_improvement()
	if(accuracy_improvement)
		src.accuracy_mult += config.min_hit_accuracy_mult
		src.drain += 50
	if(!accuracy_improvement)
		src.accuracy_mult -= config.min_hit_accuracy_mult
		src.drain -= 50

/obj/item/weapon/gun/smartgun/proc/toggle_auto_fire(mob/user)
	if(!(flags_item & WIELDED))
		to_chat(user, "[htmlicon(src, usr)] You need to wield the [src] to enable autofire.")
		return //Have to be actually be wielded.
	to_chat(user, "[htmlicon(src, usr)] You [auto_fire? "<B>disable</b>" : "<B>enable</b>"] the [src]'s auto fire mode.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	auto_fire = !auto_fire
	auto_fire()

/obj/item/weapon/gun/smartgun/proc/auto_fire()
	if(auto_fire)
		src.drain += 150
		if(!motion_detector)
			processing_objects.Add(src)
	if(!auto_fire)
		src.drain -= 150
		if(!motion_detector)
			processing_objects.Remove(src)

/obj/item/weapon/gun/smartgun/process()
	if(!auto_fire && !motion_detector)
		processing_objects.Remove(src)
	if(auto_fire)
		if(ishuman(loc) && (flags_item & WIELDED))
			var/human_user = loc
			target = get_target(human_user)
			process_shot(human_user)
		else
			auto_fire = 0
			auto_fire()
	if(motion_detector)
		recycletime--
		if(!recycletime)
			recycletime = initial(recycletime)
			for(var/X in blip_pool) //we dump and remake the blip pool every few minutes
				if(blip_pool[X])	//to clear blips assigned to mobs that are long gone.
					qdel(blip_pool[X])
			blip_pool = list()
		if(!detector_mode)
			long_range_cooldown--
			if(long_range_cooldown)
				return
			long_range_cooldown = initial(long_range_cooldown)
		scan()

/obj/item/weapon/gun/smartgun/proc/scan()
	var/mob/living/carbon/human/human_user
	if(ishuman(loc))
		human_user = loc

	ping_count = 0
	for(var/mob/M in living_mob_list)

		if(loc == null || M == null) continue
		if(loc.z != M.z) continue
		if(get_dist(M, src) > detector_range) continue
		if(M == loc) continue //device user isn't detected
		if(!isturf(M.loc)) continue
		if(world.time > M.l_move_time + 20) continue //hasn't moved recently
		if(isrobot(M)) continue
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.get_target_lock(iff_signal))
				continue
		ping_count++

		if(human_user)
			show_blip(human_user, M)

	if(ping_count > 0)
		playsound(loc, pick('sound/items/detector_ping_1.ogg', 'sound/items/detector_ping_2.ogg', 'sound/items/detector_ping_3.ogg', 'sound/items/detector_ping_4.ogg'), 60, 0, 7, 2)
	else
		playsound(loc, 'sound/items/detector.ogg', 60, 0, 7, 2)

/obj/item/weapon/gun/smartgun/proc/show_blip(mob/user, mob/target)
	set waitfor = 0
	if(user && user.client)

		if(!blip_pool[target])
			blip_pool[target] = new /obj/effect/detector_blip

		var/obj/effect/detector_blip/DB = blip_pool[target]
		var/c_view = user.client.view
		var/view_x_offset = 0
		var/view_y_offset = 0
		if(c_view > 7)
			if(user.client.pixel_x >= 0) view_x_offset = round(user.client.pixel_x/32)
			else view_x_offset = Ceiling(user.client.pixel_x/32)
			if(user.client.pixel_y >= 0) view_y_offset = round(user.client.pixel_y/32)
			else view_y_offset = Ceiling(user.client.pixel_y/32)

		var/diff_dir_x = 0
		var/diff_dir_y = 0
		if(target.x - user.x > c_view + view_x_offset) diff_dir_x = 4
		else if(target.x - user.x < -c_view + view_x_offset) diff_dir_x = 8
		if(target.y - user.y > c_view + view_y_offset) diff_dir_y = 1
		else if(target.y - user.y < -c_view + view_y_offset) diff_dir_y = 2
		if(diff_dir_x || diff_dir_y)
			DB.icon_state = "[blip_type]_blip_dir"
			DB.dir = diff_dir_x + diff_dir_y
		else
			DB.icon_state = "[blip_type]_blip"
			DB.dir = initial(DB.dir)

		DB.screen_loc = "[Clamp(c_view + 1 - view_x_offset + (target.x - user.x), 1, 2*c_view+1)],[Clamp(c_view + 1 - view_y_offset + (target.y - user.y), 1, 2*c_view+1)]"
		user.client.screen += DB
		sleep(12)
		if(user.client)
			user.client.screen -= DB

/obj/item/weapon/gun/smartgun/proc/get_target(var/mob/living/user)
	var/list/conscious_targets = list()
	var/list/unconscious_targets = list()
	var/list/turf/path = list()
	var/turf/T
	var/mob/M

	for(M in orange(range, user)) // orange allows sentry to fire through gas and darkness
		if(!isliving(M) || M.stat & DEAD || isrobot(M)) continue // No dead or non living.

		/*
		I really, really need to replace this with some that isn't insane. You shouldn't have to fish for access like this.
		This should be enough shortcircuiting, but it is possible for the code to go all over the possibilities and generally
		slow down. It'll serve for now.
		*/
		var/mob/living/carbon/human/H = M
		if(istype(H) && H.get_target_lock(ammo.iff_signal)) continue
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

		path = getline2(user, M)

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

/obj/item/weapon/gun/smartgun/proc/process_shot(var/mob/living/user)
	set waitfor = 0


	if(isnull(target)) return //Acquire our victim.

	if(!ammo) return

	if(target && (world.time-last_fired >= 3))
		if(world.time-last_fired >= 300) //if we haven't fired for a while, beep first
			playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
			sleep(3)

		Fire(target,user)

	target = null

/obj/item/weapon/gun/smartgun/proc/toggle_motion_detector(mob/user)
	to_chat(user, "[htmlicon(src, usr)] You [motion_detector? "<B>disable</b>" : "<B>enable</b>"] the [src]'s motion detector.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	motion_detector = !motion_detector
	motion_detector()

/obj/item/weapon/gun/smartgun/proc/motion_detector()
	if(motion_detector)
		src.drain += 15
		if(!auto_fire)
			processing_objects.Add(src)
	if(!motion_detector)
		src.drain -= 15
		if(!auto_fire)
			processing_objects.Remove(src)

/obj/item/weapon/gun/smartgun/dirty
	name = "\improper M56D 'Dirty' smartgun"
	desc = "The actual firearm in the 4-piece M56D Smartgun System. If you have this, you're about to bring some serious pain to anyone in your way.\nYou may toggle firing restrictions by using a special action."
	current_mag = /obj/item/ammo_magazine/smartgun/dirty
	ammo = /obj/item/ammo_magazine/smartgun/dirty
	ammo_primary = /datum/ammo/bullet/smartgun/dirty//Toggled ammo type
	ammo_secondary = /datum/ammo/bullet/smartgun/dirty/armor_piercing///Toggled ammo type
	flags_gun_features = GUN_WY_RESTRICTED|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY


//TERMINATOR SMARTGUN
/obj/item/weapon/gun/smartgun/dirty/elite
	name = "\improper M56T 'Terminator' smartgun"
	desc = "The actual firearm in the 4-piece M56T Smartgun System. If you have this, you're about to bring some serious pain to anyone in your way.\nYou may toggle firing restrictions by using a special action."


/obj/item/weapon/gun/smartgun/dirty/elite/set_gun_config_values()
	..()
	burst_amount = config.mhigh_burst_value
	burst_delay = config.min_fire_delay
	scatter = config.low_scatter_value
	burst_scatter_mult = config.min_scatter_value


//-------------------------------------------------------
//GRENADE LAUNCHER
/obj/item/weapon/gun/launcher
	var/list/disallowed_grenade_types = list(/obj/item/explosive/grenade/spawnergrenade)

/obj/item/weapon/gun/launcher/proc/allowed_ammo_type(obj/item/I)
	for(var/G in disallowed_grenade_types)
		if(istype(I, G))
			return 0
	return 1

/obj/item/weapon/gun/launcher/m92
	name = "\improper M92 grenade launcher"
	desc = "A heavy, 6-shot grenade launcher used by the Colonial Marines for area denial and big explosions."
	icon_state = "m92"
	item_state = "m92" //NEED TWO HANDED SPRITE
	unacidable = TRUE
	indestructible = 1

	matter = list("metal" = 6000)
	w_class = SIZE_LARGE
	throw_speed = SPEED_SLOW
	throw_range = 10
	force = 5.0
	wield_delay = WIELD_DELAY_SLOW
	fire_sound = 'sound/weapons/armbomb.ogg'
	cocked_sound = 'sound/weapons/gun_m92_cocked.ogg'
	var/list/grenades = new/list()
	var/max_grenades = 6
	var/is_lobbing = TRUE
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	attachable_allowed = list(/obj/item/attachable/magnetic_harness, /obj/item/attachable/scope/mini)

	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	gun_skill_category = SKILL_SPEC_WEAPONS

/obj/item/weapon/gun/launcher/m92/New()
	..()
	select_gamemode_skin(/obj/item/weapon/gun/launcher/m92)
	grenades += new /obj/item/explosive/grenade/HE(src)
	grenades += new /obj/item/explosive/grenade/HE(src)
	grenades += new /obj/item/explosive/grenade/HE(src)
	grenades += new /obj/item/explosive/grenade/HE(src)
	grenades += new /obj/item/explosive/grenade/HE(src)
	grenades += new /obj/item/explosive/grenade/HE(src)


/obj/item/weapon/gun/launcher/m92/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 14, "rail_y" = 22, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)


/obj/item/weapon/gun/launcher/m92/set_gun_config_values()
	..()
	fire_delay = config.max_fire_delay*4
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult
	scatter = config.med_scatter_value
	scatter_unwielded = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult


/obj/item/weapon/gun/launcher/m92/examine(mob/user)
	..()
	if(grenades.len)
		if (get_dist(user, src) > 2 && user != loc) return
		to_chat(user, SPAN_NOTICE(" It is loaded with <b>[grenades.len] / [max_grenades]</b> grenades."))

/obj/item/weapon/gun/launcher/m92/attackby(obj/item/I, mob/user)
	if(allowed_ammo_type(I))
		if((istype(I, /obj/item/explosive/grenade)))
			if(grenades.len < max_grenades)
				if(user.drop_inv_item_to_loc(I, src))
					grenades += I
					to_chat(user, SPAN_NOTICE("You put [I] in the grenade launcher."))
					to_chat(user, SPAN_INFO("Now storing: [grenades.len] / [max_grenades] grenades."))
			else
				to_chat(user, SPAN_WARNING("The grenade launcher cannot hold more grenades!"))

		else if(istype(I,/obj/item/attachable))
			if(check_inactive_hand(user)) attach_to_gun(user,I)
	else
		to_chat(user, SPAN_WARNING("[src] can't use this type of grenade!"))

/obj/item/weapon/gun/launcher/m92/afterattack(atom/target, mob/user, flag)
	if(able_to_fire(user))
		if(get_dist(target,user) <= 2)
			to_chat(user, SPAN_WARNING("The grenade launcher beeps a warning noise. You are too close!"))
			return
		if(grenades.len)
			fire_grenade(target,user)
			playsound(user.loc, cocked_sound, 25, 1)
		else to_chat(user, SPAN_WARNING("The grenade launcher is empty."))

//Doesn't use most of any of these. Listed for reference.
/obj/item/weapon/gun/launcher/m92/load_into_chamber()
	return

/obj/item/weapon/gun/launcher/m92/reload_into_chamber()
	return

/obj/item/weapon/gun/launcher/m92/unload(mob/user)
	if(grenades.len)
		var/obj/item/explosive/grenade/nade = grenades[grenades.len] //Grab the last one.
		if(user)
			user.put_in_hands(nade)
			playsound(user, unload_sound, 25, 1)
		else nade.loc = get_turf(src)
		grenades -= nade
	else to_chat(user, SPAN_WARNING("It's empty!"))

/obj/item/weapon/gun/launcher/m92/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && user.mind.cm_skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_GRENADIER)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return FALSE
		if(grenades.len)
			var/obj/item/explosive/grenade/G = grenades[1]
			if(grenade_grief_check(G))
				to_chat(user, SPAN_WARNING("\The [name]'s IFF inhibitor prevents you from firing!"))
				message_staff("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)")
				return FALSE

/obj/item/weapon/gun/launcher/m92/proc/fire_grenade(atom/target, mob/user)
	set waitfor = 0
	last_fired = world.time
	for(var/mob/O in viewers(world.view, user))
		O.show_message(SPAN_DANGER("[user] fired a grenade!"), 1)
	to_chat(user, SPAN_WARNING("You fire the grenade launcher!"))
	var/obj/item/explosive/grenade/F = grenades[1]
	grenades -= F
	F.loc = user.loc
	F.throw_range = 20

	var/pass_flags = NO_FLAGS
	if(is_lobbing)
		pass_flags |= PASS_MOB

	F.launch_towards(target, 20, SPEED_VERY_FAST, user, null, NORMAL_LAUNCH, pass_flags)
	if(F && F.loc) //Apparently it can get deleted before the next thing takes place, so it runtimes.
		message_admins("[key_name_admin(user)] fired a grenade ([F.name]) from \a ([name]).")
		log_game("[key_name_admin(user)] used a grenade ([name]).")
		F.icon_state = initial(F.icon_state) + "_active"
		F.active = 1
		F.updateicon()
		playsound(F.loc, fire_sound, 50, 1)
		sleep(10)
		if(F && F.loc) F.prime()

/obj/item/weapon/gun/launcher/m81
	name = "\improper M81 grenade launcher"
	desc = "A lightweight, single-shot grenade launcher used by the Colonial Marines for area denial and big explosions."
	icon_state = "m81"
	item_state = "m81"

	matter = list("metal" = 7000)
	w_class = SIZE_LARGE
	throw_speed = SPEED_SLOW
	throw_range = 10
	force = 5.0
	wield_delay = WIELD_DELAY_SLOW
	fire_sound = 'sound/weapons/armbomb.ogg'
	cocked_sound = 'sound/weapons/gun_m92_cocked.ogg'
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	gun_skill_category = SKILL_SPEC_WEAPONS
	var/grenade
	var/grenade_type_allowed = /obj/item/explosive/grenade
	var/riot_version

/obj/item/weapon/gun/launcher/m81/New(loc, spawn_empty)
	..()
	if(!spawn_empty)
		if(riot_version)
			grenade = new /obj/item/explosive/grenade/chem_grenade/teargas(src)
		else
			grenade = new /obj/item/explosive/grenade/HE(src)


/obj/item/weapon/gun/launcher/m81/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 14, "rail_y" = 22, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/launcher/m81/set_gun_config_values()
	..()
	fire_delay = config.max_fire_delay * 1.5
	accuracy_mult = config.base_hit_accuracy_mult
	scatter = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult


/obj/item/weapon/gun/launcher/m81/examine(mob/user)
	..()
	if(grenade)
		if (get_dist(user, src) > 2 && user != loc) return
		to_chat(user, SPAN_NOTICE(" It is loaded with a grenade."))

/obj/item/weapon/gun/launcher/m81/attackby(obj/item/I, mob/user)
	if(allowed_ammo_type(I))
		if((istype(I, /obj/item/explosive/grenade)))
			if((istype(I, grenade_type_allowed)))
				if(!grenade)
					if(user.drop_inv_item_to_loc(I, src))
						grenade = I
						to_chat(user, SPAN_NOTICE("You put [I] in the grenade launcher."))
				else
					to_chat(user, SPAN_WARNING("The grenade launcher cannot hold more grenades!"))
			else
				to_chat(user, SPAN_WARNING("[src] can't use this type of grenade!"))

		else if(istype(I,/obj/item/attachable))
			if(check_inactive_hand(user)) attach_to_gun(user,I)
	else
		to_chat(user, SPAN_WARNING("[src] can't use this type of grenade!"))

/obj/item/weapon/gun/launcher/m81/afterattack(atom/target, mob/user, flag)
	if(able_to_fire(user))
		if(get_dist(target,user) <= 2)
			to_chat(user, SPAN_WARNING("The grenade launcher beeps a warning noise. You are too close!"))
			return
		if(grenade)
			fire_grenade(target,user)
			playsound(user.loc, cocked_sound, 25, 1)
		else to_chat(user, SPAN_WARNING("The grenade launcher is empty."))

//Doesn't use most of any of these. Listed for reference.
/obj/item/weapon/gun/launcher/m81/load_into_chamber()
	return

/obj/item/weapon/gun/launcher/m81/reload_into_chamber()
	return

/obj/item/weapon/gun/launcher/m81/unload(mob/user)
	if(grenade)
		var/obj/item/explosive/grenade/nade = grenade
		if(user)
			user.put_in_hands(nade)
			playsound(user, unload_sound, 25, 1)
		else nade.loc = get_turf(src)
		grenade = null
	else to_chat(user, SPAN_WARNING("It's empty!"))

/obj/item/weapon/gun/launcher/m81/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(user.mind && user.mind.cm_skills)
			if(riot_version)
				if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_MP))
					to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
					return 0
			else if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && user.mind.cm_skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_GRENADIER)
				to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
				return 0


/obj/item/weapon/gun/launcher/m81/proc/fire_grenade(atom/target, mob/user)
	set waitfor = 0
	last_fired = world.time
	user.visible_message(SPAN_DANGER("[user] fired a grenade!"), \
							SPAN_WARNING("You fire the grenade launcher!"))
	var/obj/item/explosive/grenade/F = grenade
	grenade = null
	F.loc = user.loc
	F.throw_range = 20
	F.launch_towards(target, 20, SPEED_VERY_FAST, user)
	if(F && F.loc) //Apparently it can get deleted before the next thing takes place, so it runtimes.
		message_admins("[key_name_admin(user)] fired a grenade ([F.name]) from \a ([name]).")
		log_game("[key_name_admin(user)] used a grenade ([name]).")
		F.icon_state = initial(F.icon_state) + "_active"
		F.active = 1
		F.updateicon()
		playsound(F.loc, fire_sound, 50, 1)
		sleep(10)
		if(F && F.loc) F.prime()


/obj/item/weapon/gun/launcher/m81/riot
	name = "\improper M81 riot grenade launcher"
	desc = "A lightweight, single-shot grenade launcher to launch tear gas grenades. Used by the Colonial Marines Military Police during riots."
	grenade_type_allowed = /obj/item/explosive/grenade/chem_grenade
	riot_version = TRUE




//-------------------------------------------------------
//M5 RPG

/obj/item/weapon/gun/launcher/rocket
	name = "\improper M5 RPG"
	desc = "The M5 RPG is the primary anti-armor weapon of the USCM. Used to take out light-tanks and enemy structures, the M5 RPG is a dangerous weapon with a variety of combat uses."
	icon_state = "m5"
	item_state = "m5"
	unacidable = TRUE
	indestructible = 1

	matter = list("metal" = 10000)
	current_mag = /obj/item/ammo_magazine/rocket
	flags_equip_slot = NO_FLAGS
	w_class = SIZE_HUGE
	force = 15
	wield_delay = WIELD_DELAY_HORRIBLE
	delay_style	= WEAPON_DELAY_NO_FIRE
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	attachable_allowed = list(
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/scope/mini)

	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	gun_skill_category = SKILL_SPEC_WEAPONS
	var/datum/effect_system/smoke_spread/smoke

/obj/item/weapon/gun/launcher/rocket/New()
	..()
	smoke = new()
	smoke.attach(src)


/obj/item/weapon/gun/launcher/rocket/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 6, "rail_y" = 19, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)


/obj/item/weapon/gun/launcher/rocket/set_gun_config_values()
	..()
	fire_delay = config.high_fire_delay*2
	accuracy_mult = config.base_hit_accuracy_mult
	scatter = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.med_recoil_value


/obj/item/weapon/gun/launcher/rocket/examine(mob/user)
	..()
	if(current_mag.current_rounds > 0)
		to_chat(user, "It has an 84mm [ammo.name] loaded.")


/obj/item/weapon/gun/launcher/rocket/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		/*var/turf/current_turf = get_turf(user)
		if (current_turf.z == 3 || current_turf.z == 4) //Can't fire on the Almayer, bub.
			click_empty(user)
			to_chat(user, SPAN_WARNING("You can't fire that here!"))
			return 0*/
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && user.mind.cm_skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_ROCKET)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return 0
		if(current_mag.current_rounds > 0)
			make_rocket(user, 0, 1)

/obj/item/weapon/gun/launcher/rocket/load_into_chamber(mob/user)
//	if(active_attachable) active_attachable = null
	return ready_in_chamber()

//No such thing
/obj/item/weapon/gun/launcher/rocket/reload_into_chamber(mob/user)
	return 1

/obj/item/weapon/gun/launcher/rocket/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) current_mag.current_rounds++
	return 1

/obj/item/weapon/gun/launcher/rocket/proc/make_rocket(mob/user, drop_override = 0, empty = 1)
	var/obj/item/ammo_magazine/rocket/r = new current_mag.type()
	if(empty)
		r.current_rounds = 0
	if(drop_override || !user) //If we want to drop it on the ground or there's no user.
		r.forceMove(get_turf(src)) //Drop it on the ground.
	else user.put_in_hands(r)
	r.update_icon()

/obj/item/weapon/gun/launcher/rocket/reload(mob/user, obj/item/ammo_magazine/rocket)
	if(flags_gun_features & GUN_BURST_FIRING)
		return

	if(!rocket || !istype(rocket) || !istype(src, rocket.gun_type))
		to_chat(user, SPAN_WARNING("That's not going to fit!"))
		return

	if(current_mag.current_rounds > 0)
		to_chat(user, SPAN_WARNING("[src] is already loaded!"))
		return

	if(rocket.current_rounds <= 0)
		to_chat(user, SPAN_WARNING("That frame is empty!"))
		return

	if(user)
		to_chat(user, SPAN_NOTICE("You begin reloading [src]. Hold still..."))
		if(do_after(user,current_mag.reload_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			qdel(current_mag)
			user.drop_inv_item_on_ground(rocket)
			current_mag = rocket
			rocket.forceMove(src)
			replace_ammo(,rocket)
			to_chat(user, SPAN_NOTICE("You load [rocket] into [src]."))
			if(reload_sound)
				playsound(user, reload_sound, 25, 1)
			else
				playsound(user,'sound/machines/click.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("Your reload was interrupted!"))
			return
	else
		qdel(current_mag)
		current_mag = rocket
		rocket.forceMove(src)
		replace_ammo(,rocket)
	return 1

/obj/item/weapon/gun/launcher/rocket/unload(mob/user,  reload_override = 0, drop_override = 0)
	if(user)
		if(current_mag.current_rounds <= 0)
			to_chat(user, SPAN_WARNING("[src] is already empty!"))
			return
		to_chat(user, SPAN_NOTICE("You begin unloading [src]. Hold still..."))
		if(do_after(user,current_mag.reload_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			playsound(user, unload_sound, 25, 1)
			user.visible_message(SPAN_NOTICE("[user] unloads [ammo] from [src]."),
			SPAN_NOTICE("You unload [ammo] from [src]."))
			make_rocket(user, drop_override, 0)
			current_mag.current_rounds = 0

//Adding in the rocket backblast. The tile behind the specialist gets blasted hard enough to down and slightly wound anyone
/obj/item/weapon/gun/launcher/rocket/apply_bullet_effects(obj/item/projectile/projectile_to_fire, mob/user, i = 1, reflex = 0)

	var/backblast_loc = get_turf(get_step(user.loc, turn(user.dir, 180)))
	smoke.set_up(1, 0, backblast_loc, turn(user.dir, 180))
	smoke.start()
	playsound(src, 'sound/weapons/gun_rocketlauncher.ogg', 100, 1, 7)
	for(var/mob/living/carbon/C in backblast_loc)
		if(!C.lying) //Have to be standing up to get the fun stuff
			C.adjustBruteLoss(15) //The shockwave hurts, quite a bit. It can knock unarmored targets unconscious in real life
			C.Stun(4) //For good measure
			C.emote("pain")

		..()

//-------------------------------------------------------
//M5 RPG'S MEAN FUCKING COUSIN

/obj/item/weapon/gun/launcher/rocket/m57a4
	name = "\improper M57-A4 'Lightning Bolt' quad thermobaric launcher"
	desc = "The M57-A4 'Lightning Bolt' is posssibly the most destructive man-portable weapon ever made. It is a 4-barreled missile launcher capable of burst-firing 4 thermobaric missiles. Enough said."
	icon_state = "m57a4"
	item_state = "m57a4"

	current_mag = /obj/item/ammo_magazine/rocket/m57a4
	aim_slowdown = SLOWDOWN_ADS_SUPERWEAPON
	flags_gun_features = GUN_WY_RESTRICTED|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/launcher/rocket/m57a4/set_gun_config_values()
	..()
	fire_delay = config.mhigh_fire_delay
	burst_delay = config.med_fire_delay
	burst_amount = config.high_burst_value
	accuracy_mult = config.base_hit_accuracy_mult - config.med_hit_accuracy_mult
	scatter = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.med_recoil_value

//-------------------------------------------------------
//Flare gun. Close enough to a specialist gun?

/obj/item/weapon/gun/flare
	name = "\improper M82-F flare gun"
	desc = "A flare gun issued to JTAC operators to use with standard flares. Cannot be used with signal flares. Comes with a miniscope. One shot, one... life saved?"
	icon_state = "m82f"
	item_state = "m82f"
	current_mag = /obj/item/ammo_magazine/internal/flare
	reload_sound = 'sound/weapons/gun_shotgun_shell_insert.ogg'
	fire_sound = 'sound/weapons/gun_flare.ogg'
	flags_gun_features = GUN_INTERNAL_MAG
	attachable_allowed = list(/obj/item/attachable/scope/mini)
	var/popped_state = "m82f_e" //Icon state that represents an unloaded flare gun. The tube's just popped out.


/obj/item/weapon/gun/flare/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachables()


/obj/item/weapon/gun/flare/rocket/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 20, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/flare/set_gun_config_values()
	..()
	fire_delay = config.min_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult
	scatter = 0
	recoil = config.min_recoil_value
	recoil_unwielded = config.low_recoil_value
	recoil = config.min_recoil_value


/obj/item/weapon/gun/flare/apply_bullet_effects(obj/item/projectile/projectile_to_fire, mob/user, bullets_fired, reflex, dual_wield)
	. = ..()
	to_chat(user, SPAN_WARNING("You pop out [src]'s tube!"))
	icon_state = popped_state

/obj/item/weapon/gun/flare/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/F = I
		if(F.on)
			to_chat(user, SPAN_WARNING("You can't put a lit flare in [src]!"))
			return
		if(!F.fuel)
			to_chat(user, SPAN_WARNING("You can't put a burnt out flare in [src]!"))
			return
		if(istype(F, /obj/item/device/flashlight/flare/signal))
			to_chat(user, SPAN_WARNING("You can't load a signal flare in [src]!"))
			return
		if(current_mag.current_rounds == 0)
			playsound(user, reload_sound, 25, 1)
			to_chat(user, SPAN_NOTICE("You load \the [F] into [src]."))
			current_mag.current_rounds++
			qdel(I)
			icon_state = "m82f"
		else to_chat(user, SPAN_WARNING("\The [src] is already loaded!"))
	else to_chat(user, SPAN_WARNING("That's not a flare!"))
