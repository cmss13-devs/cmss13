//-------------------------------------------------------
//SNIPER RIFLES
//Keyword rifles. They are subtype of rifles, but still contained here as a specialist weapon.

//Because this parent type did not exist
//Note that this means that snipers will have a slowdown of 3, due to the scope
/obj/item/weapon/gun/rifle/sniper
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	wield_delay = WIELD_DELAY_SLOW

	able_to_fire(mob/living/user)
		. = ..()
		if(. && istype(user)) //Let's check all that other stuff first.
			if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SNIPER)
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
	map_specific_decoration = TRUE

	flags_item = TWOHANDED|NO_CRYO_STORE

/obj/item/weapon/gun/rifle/sniper/M42A/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/sniper/M42A/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/rifle/sniper/M42A/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 20, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)


/obj/item/weapon/gun/rifle/sniper/M42A/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*3
	burst_amount = BURST_AMOUNT_TIER_1
	accuracy_mult = BASE_ACCURACY_MULT * 3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

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
	fire_delay = FIRE_DELAY_TIER_4 * 8 //Big boy damage, but it takes a lot of time to fire a shot.
	burst_amount = BURST_AMOUNT_TIER_1
	accuracy_mult = BASE_ACCURACY_MULT + 2*HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/rifle/sniper/M42B/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

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

/obj/item/weapon/gun/rifle/sniper/elite/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/rifle/sniper/elite/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 15, "rail_y" = 19, "under_x" = 20, "under_y" = 15, "stock_x" = 20, "stock_y" = 15)

/obj/item/weapon/gun/rifle/sniper/elite/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*5
	burst_amount = BURST_AMOUNT_TIER_1
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_1

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
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/gyro,
						/obj/item/attachable/bipod,
						/obj/item/attachable/scope/slavic)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY


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
	fire_delay = FIRE_DELAY_TIER_5*2
	burst_amount = BURST_AMOUNT_TIER_2
	accuracy_mult = BASE_ACCURACY_MULT * 3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5



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
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/bipod,
						/obj/item/attachable/compensator,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/attached_gun/shotgun,
						/obj/item/attachable/scope,
						/obj/item/attachable/scope/mini,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex
						)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/marksman)

	flags_item = TWOHANDED|NO_CRYO_STORE


/obj/item/weapon/gun/rifle/m4ra/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 20, "under_x" = 23, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)
//also logs for AA canno
/obj/item/weapon/gun/rifle/m4ra/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6
	burst_amount = BURST_AMOUNT_TIER_2
	burst_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/m4ra/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SCOUT)
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
	fire_rattle	= "gun_smartgun_rattle"
	reload_sound = 'sound/weapons/handling/gun_sg_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_sg_unload.ogg'
	current_mag = /obj/item/ammo_magazine/smartgun
	flags_equip_slot = NO_FLAGS
	w_class = SIZE_HUGE
	force = 20
	wield_delay = WIELD_DELAY_FAST
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	var/powerpack = null
	ammo = /datum/ammo/bullet/smartgun
	var/datum/ammo/ammo_primary = /datum/ammo/bullet/smartgun //Toggled ammo type
	var/datum/ammo/ammo_secondary = /datum/ammo/bullet/smartgun/armor_piercing //Toggled ammo type
	var/shells_fired_max = 20 //Smartgun only; once you fire # of shells, it will attempt to reload automatically. If you start the reload, the counter resets.
	var/shells_fired_now = 0 //The actual counter used. shells_fired_max is what it is compared to.
	var/iff_enabled = TRUE //Begin with the safety on.
	var/secondary_toggled = 0 //which ammo we use
	var/recoil_compensation = 0
	var/accuracy_improvement = 0
	var/auto_fire = 0
	var/motion_detector = 0
	var/drain = 11
	var/range = 12
	var/angle = 2
	var/list/angle_list = list(180,135,90,60,30)
	var/obj/item/device/motiondetector/sg/MD
	var/long_range_cooldown = 2
	var/recycletime = 120

	unacidable = 1
	indestructible = 1

	attachable_allowed = list(
						/obj/item/attachable/smartbarrel,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/flashlight)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_HAS_FULL_AUTO
	gun_category = GUN_CATEGORY_HEAVY
	starting_attachment_types = list(/obj/item/attachable/smartbarrel)


/obj/item/weapon/gun/smartgun/Initialize(mapload, ...)
	. = ..()
	ammo_primary = GLOB.ammo_list[ammo_primary]
	ammo_secondary = GLOB.ammo_list[ammo_secondary]
	AddElement(/datum/element/magharness)
	MD = new(src)

/obj/item/weapon/gun/smartgun/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 17, "rail_y" = 18, "under_x" = 22, "under_y" = 14, "stock_x" = 22, "stock_y" = 14)

/obj/item/weapon/gun/smartgun/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_9
	fa_delay = FIRE_DELAY_TIER_9
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_6
	fa_max_scatter = SCATTER_AMOUNT_TIER_5
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_1
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_3

/obj/item/weapon/gun/smartgun/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/smartgun/examine(mob/user)
	..()
	var/rounds = 0
	if(current_mag && current_mag.current_rounds)
		rounds = current_mag.current_rounds
	var/message = "[rounds ? "Ammo counter shows [rounds] round\s remaining." : "It's dry."]"
	to_chat(user, message)
	to_chat(user, "The restriction system is [iff_enabled ? "<B>on</b>" : "<B>off</b>"].")

/obj/item/weapon/gun/smartgun/verb/vtoggle_lethal_mode()
	set category = "Smartgun"
	set name = "Toggle Lethal Mode"
	set src in usr
	var/obj/item/weapon/gun/smartgun/G = get_active_firearm(usr)
	if(!istype(G))
		return

	if(isobserver(usr) || isXeno(usr))
		return
	if(!G.powerpack)
		G.link_powerpack(usr)
	G.toggle_lethal_mode(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_ammo_type()
	set category = "Smartgun"
	set name = "Toggle Ammo Type"
	set src in usr
	var/obj/item/weapon/gun/smartgun/G = get_active_firearm(usr)
	if(!istype(G))
		return

	if(isobserver(usr) || isXeno(usr))
		return
	if(!G.powerpack)
		G.link_powerpack(usr)
	G.toggle_ammo_type(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_recoil_compensation()
	set category = "Smartgun"
	set name = "Toggle Recoil Compensation"
	set src in usr
	var/obj/item/weapon/gun/smartgun/G = get_active_firearm(usr)
	if(!istype(G))
		return

	if(isobserver(usr) || isXeno(usr))
		return
	if(!G.powerpack)
		G.link_powerpack(usr)
	G.toggle_recoil_compensation(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_accuracy_improvement()
	set category = "Smartgun"
	set name = "Toggle Accuracy Improvement"
	set src in usr
	var/obj/item/weapon/gun/smartgun/G = get_active_firearm(usr)
	if(!istype(G))
		return

	if(isobserver(usr) || isXeno(usr))
		return
	if(!G.powerpack)
		G.link_powerpack(usr)
	G.toggle_accuracy_improvement(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_auto_fire()
	set category = "Smartgun"
	set name = "Toggle Auto Fire"
	set src in usr
	var/obj/item/weapon/gun/smartgun/G = get_active_firearm(usr)
	if(!istype(G))
		return

	if(isobserver(usr) || isXeno(usr))
		return
	if(!G.powerpack)
		G.link_powerpack(usr)
	G.toggle_auto_fire(usr)

/obj/item/weapon/gun/smartgun/verb/vtoggle_motion_detector()
	set category = "Smartgun"
	set name = "Toggle Motion Detector"
	set src in usr
	var/obj/item/weapon/gun/smartgun/G = get_active_firearm(usr)
	if(!istype(G))
		return

	if(isobserver(usr) || isXeno(usr))
		return
	if(!G.powerpack)
		G.link_powerpack(usr)
	G.toggle_motion_detector(usr)

/obj/item/weapon/gun/smartgun/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user)) return 0
		var/mob/living/carbon/human/H = user
		if(!skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_SMARTGUN) && !skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return 0
		if ( !istype(H.wear_suit,/obj/item/clothing/suit/storage/marine/smartgunner) || !istype(H.back,/obj/item/smartgun_powerpack))
			click_empty(H)
			return 0

/obj/item/weapon/gun/smartgun/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	if(!current_mag)
		return
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
		to_chat(user, "[icon2html(src, usr)] Can't switch ammunition type when the [src]'s fire restriction is disabled.")
		return
	secondary_toggled = !secondary_toggled
	to_chat(user, "[icon2html(src, usr)] You changed the [src]'s ammo preparation procedures. You now fire [secondary_toggled ? "armor shredding rounds" : "highly precise rounds"].")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	ammo = secondary_toggled ? ammo_secondary : ammo_primary

/obj/item/weapon/gun/smartgun/replace_ammo()
	..()
	ammo = secondary_toggled ? ammo_secondary : ammo_primary

/obj/item/weapon/gun/smartgun/proc/toggle_lethal_mode(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [iff_enabled? "<B>disable</b>" : "<B>enable</b>"] the [src]'s fire restriction. You will [iff_enabled ? "harm anyone in your way" : "target through IFF"].")
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
	if(!powerpack)
		link_powerpack(usr)

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
	if(!QDELETED(user) && !QDELETED(user.back))
		if(istype(user.back, /obj/item/smartgun_powerpack))
			src.powerpack = user.back
			return TRUE
	return FALSE

/obj/item/weapon/gun/smartgun/proc/unlink_powerpack()
	src.powerpack = null

/obj/item/weapon/gun/smartgun/proc/toggle_recoil_compensation(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [recoil_compensation? "<B>disable</b>" : "<B>enable</b>"] the [src]'s recoil compensation.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	recoil_compensation = !recoil_compensation
	recoil_compensation()

/obj/item/weapon/gun/smartgun/proc/recoil_compensation()
	if(recoil_compensation)
		src.scatter -= SCATTER_AMOUNT_TIER_7
		src.recoil -= RECOIL_AMOUNT_TIER_3
		src.drain += 50
	if(!recoil_compensation)
		src.scatter += SCATTER_AMOUNT_TIER_7
		src.recoil += RECOIL_AMOUNT_TIER_3
		src.drain -= 50

/obj/item/weapon/gun/smartgun/proc/toggle_accuracy_improvement(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [accuracy_improvement? "<B>disable</b>" : "<B>enable</b>"] the [src]'s accuracy improvement.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	accuracy_improvement = !accuracy_improvement
	accuracy_improvement()

/obj/item/weapon/gun/smartgun/proc/accuracy_improvement()
	if(accuracy_improvement)
		src.accuracy_mult += HIT_ACCURACY_MULT_TIER_1
		src.drain += 50
	if(!accuracy_improvement)
		src.accuracy_mult -= HIT_ACCURACY_MULT_TIER_1
		src.drain -= 50

/obj/item/weapon/gun/smartgun/proc/toggle_auto_fire(mob/user)
	if(!(flags_item & WIELDED))
		to_chat(user, "[icon2html(src, usr)] You need to wield the [src] to enable autofire.")
		return //Have to be actually be wielded.
	to_chat(user, "[icon2html(src, usr)] You [auto_fire? "<B>disable</b>" : "<B>enable</b>"] the [src]'s auto fire mode.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	auto_fire = !auto_fire
	auto_fire()

/obj/item/weapon/gun/smartgun/proc/auto_fire()
	if(auto_fire)
		src.drain += 150
		if(!motion_detector)
			START_PROCESSING(SSobj, src)
	if(!auto_fire)
		src.drain -= 150
		if(!motion_detector)
			STOP_PROCESSING(SSobj, src)

/obj/item/weapon/gun/smartgun/process()
	if(!auto_fire && !motion_detector)
		STOP_PROCESSING(SSobj, src)
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
			MD.refresh_blip_pool()

		long_range_cooldown--
		if(long_range_cooldown)
			return
		long_range_cooldown = initial(long_range_cooldown)
		MD.scan()

/obj/item/weapon/gun/smartgun/proc/get_target(var/mob/living/user)
	var/list/conscious_targets = list()
	var/list/unconscious_targets = list()
	var/list/turf/path = list()
	var/turf/T
	var/mob/M

	for(M in orange(range, user)) // orange allows sentry to fire through gas and darkness
		if(!isliving(M) || M.stat & DEAD || isrobot(M)) continue // No dead or non living.

		var/mob/living/carbon/human/H = M
		if(istype(H) && H.get_target_lock(user.faction_group)) continue
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


	if(!length(target))
		return //Acquire our victim.

	if(!ammo)
		return

	if(target && (world.time-last_fired >= 3))
		if(world.time-last_fired >= 300) //if we haven't fired for a while, beep first
			playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
			sleep(3)

		Fire(target,user)

	target = null

/obj/item/weapon/gun/smartgun/proc/toggle_motion_detector(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [motion_detector? "<B>disable</b>" : "<B>enable</b>"] the [src]'s motion detector.")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	motion_detector = !motion_detector
	motion_detector()

/obj/item/weapon/gun/smartgun/proc/motion_detector()
	if(motion_detector)
		src.drain += 15
		if(!auto_fire)
			START_PROCESSING(SSobj, src)
	if(!motion_detector)
		src.drain -= 15
		if(!auto_fire)
			STOP_PROCESSING(SSobj, src)

/obj/item/weapon/gun/smartgun/dirty
	name = "\improper M56D 'Dirty' smartgun"
	desc = "The actual firearm in the 4-piece M56D Smartgun System. If you have this, you're about to bring some serious pain to anyone in your way.\nYou may toggle firing restrictions by using a special action."
	current_mag = /obj/item/ammo_magazine/smartgun/dirty
	ammo = /obj/item/ammo_magazine/smartgun/dirty
	ammo_primary = /datum/ammo/bullet/smartgun/dirty//Toggled ammo type
	ammo_secondary = /datum/ammo/bullet/smartgun/dirty/armor_piercing///Toggled ammo type
	flags_gun_features = GUN_WY_RESTRICTED|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_HAS_FULL_AUTO


//TERMINATOR SMARTGUN
/obj/item/weapon/gun/smartgun/dirty/elite
	name = "\improper M56T 'Terminator' smartgun"
	desc = "The actual firearm in the 4-piece M56T Smartgun System. If you have this, you're about to bring some serious pain to anyone in your way.\nYou may toggle firing restrictions by using a special action."


/obj/item/weapon/gun/smartgun/dirty/elite/set_gun_config_values()
	..()
	burst_amount = BURST_AMOUNT_TIER_5
	burst_delay = FIRE_DELAY_TIER_10
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10



//-------------------------------------------------------
//HEAVY WEAPONS

/obj/item/weapon/gun/launcher
	gun_category = GUN_CATEGORY_HEAVY
	has_empty_icon = FALSE
	has_open_icon = FALSE
	///gun update_icon doesn't detect that guns with no magazine are loaded or not, and will always append _o or _e if possible.
	var/GL_has_empty_icon = TRUE
	///gun update_icon doesn't detect that guns with no magazine are loaded or not, and will always append _o or _e if possible.
	var/GL_has_open_icon = FALSE

	///Internal storage item used as magazine. Must be initialised to work! Set parameters by variables or it will inherit standard numbers from storage.dm. Got to call it *something* and 'magazine' or w/e would be confusing. If FALSE, is not active.
	var/obj/item/storage/internal/cylinder = FALSE
	///What single item to fill the storage with, if any. This does not respect w_class.
	var/preload
	///How many items can be inserted. "Null" = backpack-style size-based inventory. You'll have to set max_storage_space too if you do that, and arrange any initial contents. Iff you arrange to put in more items than the storage can hold, they can be taken out but not replaced.
	var/internal_slots
	///how big an item can be inserted.
	var/internal_max_w_class
	///the sfx played when the storage is opened.
	var/use_sound = null
	///Whether clicking a held weapon with an empty hand will open its inventory or draw a munition out.
	var/direct_draw = TRUE

/obj/item/weapon/gun/launcher/Initialize(mapload, spawn_empty) //If changing vars on init, be sure to do the parent proccall *after* the change.
	. = ..()
	if(cylinder)
		cylinder = new/obj/item/storage/internal(src)
		cylinder.storage_slots = internal_slots
		cylinder.max_w_class = internal_max_w_class
		cylinder.use_sound = use_sound
		if(direct_draw)
			cylinder.storage_flags ^= STORAGE_USING_DRAWING_METHOD
		if(preload && !spawn_empty)	for(var/i = 1 to cylinder.storage_slots)
			new preload(cylinder)
		update_icon()

/obj/item/weapon/gun/launcher/verb/toggle_draw_mode()
	set name = "Switch Storage Drawing Method"
	set category = "Object"
	set src in usr
	cylinder.storage_flags ^= STORAGE_USING_DRAWING_METHOD
	if (cylinder.storage_flags & STORAGE_USING_DRAWING_METHOD)
		to_chat(usr, "Clicking [src] with an empty hand now puts the last stored item in your hand.")
	else
		to_chat(usr, "Clicking [src] with an empty hand now opens the internal storage menu.")

//-------------------------------------------------------
//GRENADE LAUNCHER

/obj/item/weapon/gun/launcher/grenade //Parent item for GLs.
	w_class = SIZE_LARGE
	throw_speed = SPEED_SLOW
	throw_range = 10
	force = 5.0

	fire_sound = 'sound/weapons/armbomb.ogg'
	cocked_sound = 'sound/weapons/gun_m92_cocked.ogg'
	reload_sound = 'sound/weapons/gun_shotgun_open2.ogg' //Played when inserting nade.
	unload_sound = 'sound/weapons/gun_revolver_unload.ogg'

	cylinder = TRUE //This weapon won't work otherwise.
	preload = /obj/item/explosive/grenade/HE
	internal_slots = 1 //This weapon must use slots.
	internal_max_w_class = SIZE_MEDIUM //MEDIUM = M15.

	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	wield_delay = WIELD_DELAY_SLOW
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	///Can you access the storage by clicking it, put things into it, or take things out? Meant for break-actions mostly but useful for any state where you want access to be toggleable. Make sure to call cylinder.hide_from(user) so they don't still have the screen open!
	var/open_chamber = TRUE
	///Does it launch its grenades in a low arc or a high? Do they strike people in their path, or fly beyond?
	var/is_lobbing = FALSE
	///Verboten munitions. This is a blacklist. Anything in this list isn't loadable.
	var/disallowed_grenade_types = list(/obj/item/explosive/grenade/spawnergrenade)
	///What is this weapon permitted to fire? This is a whitelist. Anything in this list can be fired. Anything.
	var/valid_munitions = list(/obj/item/explosive/grenade)


/obj/item/weapon/gun/launcher/grenade/set_gun_config_values()
	..()
	recoil = RECOIL_AMOUNT_TIER_4 //Same as m37 shotgun.


/obj/item/weapon/gun/launcher/grenade/on_pocket_insertion() //Plays load sfx whenever a nade is put into storage.
	playsound(usr, reload_sound, 25, 1)
	update_icon()

/obj/item/weapon/gun/launcher/grenade/on_pocket_removal()
	update_icon()

/obj/item/weapon/gun/launcher/grenade/examine(mob/user) //Different treatment for single-shot VS multi-shot GLs.
	..()
	if(get_dist(user, src) > 2 && user != loc)
		return
	if(length(cylinder.contents))
		if(internal_slots == 1)
			to_chat(user, SPAN_NOTICE("It is loaded with a grenade."))
		else
			to_chat(user, SPAN_NOTICE("It is loaded with <b>[length(cylinder.contents)] / [internal_slots]</b> grenades."))
	else
		to_chat(user, SPAN_NOTICE("It is empty."))


obj/item/weapon/gun/launcher/grenade/update_icon()
	..()
	var/GL_sprite = base_gun_icon
	if(GL_has_empty_icon && !length(cylinder.contents))
		GL_sprite += "_e"
	if(GL_has_open_icon && open_chamber)
		GL_sprite += "_o"
	icon_state = GL_sprite


/obj/item/weapon/gun/launcher/grenade/attack_hand(mob/user)
	if(!open_chamber || src != user.get_inactive_hand()) //Need to have the GL in your hands to open the cylinder.
		return ..()
	if(cylinder.handle_attack_hand(user))
		..()


/obj/item/weapon/gun/launcher/grenade/unload(mob/user, reload_override = FALSE, drop_override = FALSE, loc_override = FALSE)
	if(!open_chamber)
		to_chat(user, SPAN_WARNING("[src] is closed!"))
		return
	if(!length(cylinder.contents))
		to_chat(user, SPAN_WARNING("It's empty!"))
		return

	var/obj/item/explosive/grenade/nade = cylinder.contents[length(cylinder.contents)] //Grab the last-inserted one. Or the only one, as the case may be.
	cylinder.remove_from_storage(nade, user.loc)

	if(drop_override || !user)
		nade.forceMove(get_turf(src))
	else
		user.put_in_hands(nade)

	user.visible_message(SPAN_NOTICE("[user] unloads [nade] from [src]."),
	SPAN_NOTICE("You unload [nade] from [src]."), null, 4, CHAT_TYPE_COMBAT_ACTION)
	playsound(user, unload_sound, 30, 1)


/obj/item/weapon/gun/launcher/grenade/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/attachable) && check_inactive_hand(user))
		attach_to_gun(user,I)
		return
	return cylinder.attackby(I, user)


/obj/item/weapon/gun/launcher/grenade/proc/allowed_ammo_type(obj/item/I)
	for(var/G in disallowed_grenade_types) //Check for the bad stuff.
		if(istype(I, G))
			return FALSE
	for(var/G in valid_munitions) //Check if it has a ticket.
		if(istype(I, G))
			return TRUE


/obj/item/weapon/gun/launcher/grenade/on_attackby(obj/item/explosive/grenade/I, mob/user) //the attack in question is on the internal container. Complete override - normal storage attackby cannot be silenced, and will always say "you put the x into y".
	if(!open_chamber)
		to_chat(user, SPAN_WARNING("[src] is closed!"))
		return
	if(!istype(I))
		to_chat(user, SPAN_WARNING("You can't load [I] into [src]!"))
		return
	if(!allowed_ammo_type(I))
		to_chat(user, SPAN_WARNING("[src] can't fire this type of grenade!"))
		return
	if(length(cylinder.contents) >= internal_slots)
		to_chat(user, SPAN_WARNING("[src] cannot hold more grenades!"))
		return
	if(!cylinder.can_be_inserted(I)) //Technically includes whether there's room for it, but the above gives a tailored message.
		return

	user.visible_message(SPAN_NOTICE("[user] loads [I] into [src]."),
	SPAN_NOTICE("You load [I] into the grenade launcher."), null, 4, CHAT_TYPE_COMBAT_ACTION)
	if(internal_slots > 1)
		to_chat(user, SPAN_INFO("Now storing: [length(cylinder.contents) + 1] / [internal_slots] grenades."))

	cylinder.handle_item_insertion(I, TRUE, user)


/obj/item/weapon/gun/launcher/grenade/able_to_fire(mob/living/user) //Skillchecks and fire blockers go in the child items.
	. = ..()
	if(.)
		if(!length(cylinder.contents))
			to_chat(user, SPAN_WARNING("The [name] is empty."))
			return FALSE
		var/obj/item/G = cylinder.contents[1]
		if(grenade_grief_check(G))
			to_chat(user, SPAN_WARNING("\The [name]'s IFF inhibitor prevents you from firing!"))
			msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)")
			return FALSE


/obj/item/weapon/gun/launcher/grenade/afterattack(atom/target, mob/user, flag) //Not actually after the attack. After click, more like.
	if(able_to_fire(user))
		if(get_dist(target,user) <= 2)
			to_chat(user, SPAN_WARNING("The grenade launcher beeps a warning noise. You are too close!"))
			return
		fire_grenade(target,user)
		playsound(user.loc, cocked_sound, 25, 1)


/obj/item/weapon/gun/launcher/grenade/proc/fire_grenade(atom/target, mob/user)
	set waitfor = 0
	last_fired = world.time

	var/to_firer = "You fire the [name]!"
	if(internal_slots > 1)
		to_firer += " [length(cylinder.contents)-1]/[internal_slots] grenades remaining."
	user.visible_message(SPAN_DANGER("[user] fired a grenade!"),
	SPAN_WARNING("[to_firer]"), null, null, null, CHAT_TYPE_WEAPON_USE)

	var/angle = round(Get_Angle(user,target))
	muzzle_flash(angle,user)
	simulate_recoil(0, user)

	var/obj/item/explosive/grenade/F = cylinder.contents[1]
	cylinder.remove_from_storage(F, user.loc)
	var/pass_flags = NO_FLAGS
	if(is_lobbing)
		pass_flags |= PASS_MOB_THRU|PASS_HIGH_OVER

	msg_admin_attack("[key_name_admin(user)] fired a grenade ([F.name]) from \a ([name]).")
	log_game("[key_name_admin(user)] used a grenade ([name]).")

	F.throw_range = 20
	F.det_time = min(10, F.det_time)
	F.activate(user, FALSE)
	F.forceMove(get_turf(src))
	F.throw_atom(target, 20, SPEED_VERY_FAST, user, null, NORMAL_LAUNCH, pass_flags)
	playsound(F.loc, fire_sound, 50, 1)


//Doesn't use these. Listed for reference.
/obj/item/weapon/gun/launcher/grenade/load_into_chamber()
	return
/obj/item/weapon/gun/launcher/grenade/reload_into_chamber()
	return


//-------------------------------------------------------
//M92 GRENADE LAUNCHER

/obj/item/weapon/gun/launcher/grenade/m92
	name = "\improper M92 grenade launcher"
	desc = "A heavy, 6-shot grenade launcher used by the Colonial Marines for area denial and big explosions."
	icon_state = "m92"
	item_state = "m92"
	unacidable = TRUE
	indestructible = 1
	matter = list("metal" = 6000)

	attachable_allowed = list(/obj/item/attachable/magnetic_harness)
	flags_item = TWOHANDED|NO_CRYO_STORE
	map_specific_decoration = TRUE

	is_lobbing = TRUE
	internal_slots = 6
	direct_draw = FALSE

/obj/item/weapon/gun/launcher/grenade/m92/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 14, "rail_y" = 22, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/launcher/grenade/m92/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_4*4

/obj/item/weapon/gun/launcher/grenade/m92/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user))
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_GRENADIER)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return FALSE


//-------------------------------------------------------
//M81 GRENADE LAUNCHER

/obj/item/weapon/gun/launcher/grenade/m81
	name = "\improper M81 grenade launcher"
	desc = "A lightweight, single-shot low-angle grenade launcher used by the Colonial Marines for area denial and big explosions."
	icon_state = "m81"
	item_state = "m81" //needs a wield sprite.
	var/riot_version = FALSE

	matter = list("metal" = 7000)

/obj/item/weapon/gun/launcher/grenade/m81/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 14, "rail_y" = 22, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/launcher/grenade/m81/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_4 * 1.5

/obj/item/weapon/gun/launcher/grenade/m81/on_pocket_removal()
	..()
	playsound(usr, unload_sound, 30, 1)

/obj/item/weapon/gun/launcher/grenade/m81/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user))
		if(riot_version)
			if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_MP))
				to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
				return FALSE
		else if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_GRENADIER)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return FALSE


/obj/item/weapon/gun/launcher/grenade/m81/riot
	name = "\improper M81 riot grenade launcher"
	desc = "A lightweight, single-shot low-angle grenade launcher to launch tear gas grenades. Used by the Colonial Marines Military Police during riots."
	valid_munitions = list(/obj/item/explosive/grenade/custom/teargas)
	preload = /obj/item/explosive/grenade/custom/teargas
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
						/obj/item/attachable/magnetic_harness
						)

	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	var/datum/effect_system/smoke_spread/smoke

	flags_item = TWOHANDED|NO_CRYO_STORE

/obj/item/weapon/gun/launcher/rocket/Initialize(mapload, spawn_empty)
	. = ..()
	smoke = new()
	smoke.attach(src)


/obj/item/weapon/gun/launcher/rocket/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 6, "rail_y" = 19, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)


/obj/item/weapon/gun/launcher/rocket/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*2
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_3


/obj/item/weapon/gun/launcher/rocket/examine(mob/user)
	..()
	if(!current_mag)
		return
	if(current_mag.current_rounds > 0)
		to_chat(user, "It has an 84mm [ammo.name] loaded.")


/obj/item/weapon/gun/launcher/rocket/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		/*var/turf/current_turf = get_turf(user)
		if (is_mainship_level(current_turf.z) || is_loworbit_level(current_turf.z)) //Can't fire on the Almayer, bub.
			click_empty(user)
			to_chat(user, SPAN_WARNING("You can't fire that here!"))
			return 0*/
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_ROCKET)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return 0
		if(current_mag && current_mag.current_rounds > 0)
			make_rocket(user, 0, 1)

/obj/item/weapon/gun/launcher/rocket/load_into_chamber(mob/user)
//	if(active_attachable) active_attachable = null
	return ready_in_chamber()

//No such thing
/obj/item/weapon/gun/launcher/rocket/reload_into_chamber(mob/user)
	return 1

/obj/item/weapon/gun/launcher/rocket/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	if(!current_mag)
		return
	qdel(projectile_to_fire)
	if(refund) current_mag.current_rounds++
	return 1

/obj/item/weapon/gun/launcher/rocket/proc/make_rocket(mob/user, drop_override = 0, empty = 1)
	if(!current_mag)
		return

	var/obj/item/ammo_magazine/rocket/r = new current_mag.type()
	//if there's ever another type of custom rocket ammo this logic should just be moved into a function on the rocket
	if(istype(current_mag, /obj/item/ammo_magazine/rocket/custom) && !empty)
		//set the custom rocket variables here.
		var/obj/item/ammo_magazine/rocket/custom/k = new /obj/item/ammo_magazine/rocket/custom
		var/obj/item/ammo_magazine/rocket/custom/cur_mag_cast = current_mag
		k.contents = cur_mag_cast.contents
		k.desc = cur_mag_cast.desc
		k.fuel = cur_mag_cast.fuel
		k.icon_state = cur_mag_cast.icon_state
		k.warhead = cur_mag_cast.warhead
		k.locked = cur_mag_cast.locked
		k.name = cur_mag_cast.name
		k.filters = cur_mag_cast.filters
		r = k

	if(empty)
		r.current_rounds = 0
	if(drop_override || !user) //If we want to drop it on the ground or there's no user.
		r.forceMove(get_turf(src)) //Drop it on the ground.
	else
		user.put_in_hands(r)
		r.update_icon()

/obj/item/weapon/gun/launcher/rocket/reload(mob/user, obj/item/ammo_magazine/rocket)
	if(!current_mag)
		return
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
	if(user && current_mag)
		if(current_mag.current_rounds <= 0)
			to_chat(user, SPAN_WARNING("[src] is already empty!"))
			return
		to_chat(user, SPAN_NOTICE("You begin unloading [src]. Hold still..."))
		if(do_after(user,current_mag.reload_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			if(current_mag.current_rounds <= 0)
				to_chat(user, SPAN_WARNING("You have already unloaded \the [src]."))
				return
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
			C.apply_damage(15, BRUTE) //The shockwave hurts, quite a bit. It can knock unarmored targets unconscious in real life
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
	flags_gun_features = GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/launcher/rocket/m57a4/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_5
	burst_delay = FIRE_DELAY_TIER_7
	burst_amount = BURST_AMOUNT_TIER_4
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_3

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
	gun_category = GUN_CATEGORY_HANDGUN
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
	fire_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = 0
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_4
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/flare/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

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
		if(current_mag && current_mag.current_rounds == 0)
			playsound(user, reload_sound, 25, 1)
			to_chat(user, SPAN_NOTICE("You load \the [F] into [src]."))
			current_mag.current_rounds++
			qdel(I)
			icon_state = "m82f"
		else to_chat(user, SPAN_WARNING("\The [src] is already loaded!"))
	else to_chat(user, SPAN_WARNING("That's not a flare!"))
