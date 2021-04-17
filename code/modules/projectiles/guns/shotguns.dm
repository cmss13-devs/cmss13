/*
Shotguns always start with an ammo buffer and they work by alternating ammo and ammo_buffer1
in order to fire off projectiles. This is only done to enable burst fire for the shotgun.
Consequently, the shotgun should never fire more than three projectiles on burst as that
can cause issues with ammo types getting mixed up during the burst.
*/

/obj/item/weapon/gun/shotgun
	w_class = SIZE_LARGE
	fire_sound = 'sound/weapons/gun_shotgun.ogg'
	reload_sound = 'sound/weapons/gun_shotgun_shell_insert.ogg'
	cocked_sound = 'sound/weapons/gun_shotgun_reload.ogg'
	var/break_sound = 'sound/weapons/handling/gun_mou_open.ogg'
	var/seal_sound = 'sound/weapons/handling/gun_mou_close.ogg'
	accuracy_mult = 1.15
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG
	gun_category = GUN_CATEGORY_SHOTGUN
	aim_slowdown = SLOWDOWN_ADS_SHOTGUN
	wield_delay = WIELD_DELAY_NORMAL //Shotguns are as hard to pull up as a rifle. They're quite bulky afterall
	has_empty_icon = FALSE
	has_open_icon = FALSE
	var/gauge = "12g"

/obj/item/weapon/gun/shotgun/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag)
		replace_tube(current_mag.current_rounds) //Populate the chamber.

/obj/item/weapon/gun/shotgun/examine(mob/user)
	. = ..()
	if(flags_gun_features & GUN_AMMO_COUNTER && user)
		var/chambered = in_chamber ? TRUE : FALSE
		to_chat(user, "It has [current_mag.current_rounds][chambered ? "+1" : ""] / [current_mag.max_rounds] rounds remaining.")

/obj/item/weapon/gun/shotgun/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_5
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/shotgun/proc/replace_tube(number_to_replace)
	if(!current_mag)
		return
	current_mag.chamber_contents = list()
	current_mag.chamber_contents.len = current_mag.max_rounds
	var/i
	for(i = 1 to current_mag.max_rounds) //We want to make sure to populate the tube.
		current_mag.chamber_contents[i] = i > number_to_replace ? "empty" : current_mag.default_ammo
	current_mag.chamber_position = current_mag.current_rounds //The position is always in the beginning [1]. It can move from there.

/obj/item/weapon/gun/shotgun/proc/add_to_tube(mob/user,selection) //Shells are added forward.
	if(!current_mag)
		return
	current_mag.chamber_position++ //We move the position up when loading ammo. New rounds are always fired next, in order loaded.
	current_mag.chamber_contents[current_mag.chamber_position] = selection //Just moves up one, unless the mag is full.
	if(current_mag.current_rounds == 1 && !in_chamber) //The previous proc in the reload() cycle adds ammo, so the best workaround here,
		update_icon()	//This is not needed for now. Maybe we'll have loaded sprites at some point, but I doubt it. Also doesn't play well with double barrel.
		ready_in_chamber()
		cock_gun(user)
	if(user)
		playsound(user, reload_sound, 25, TRUE)
		if(flags_gun_features & GUN_AMMO_COUNTER)
			var/chambered = in_chamber ? TRUE : FALSE
			to_chat(user, SPAN_DANGER("[current_mag.current_rounds][chambered ? "+1" : ""] / [current_mag.max_rounds] ROUNDS REMAINING"))
	return TRUE

/obj/item/weapon/gun/shotgun/proc/empty_chamber(mob/user)
	if(!current_mag)
		return
	if(current_mag.current_rounds <= 0)
		if(in_chamber)
			in_chamber = null
			var/obj/item/ammo_magazine/handful/new_handful = retrieve_shell(ammo.type)
			playsound(user, reload_sound, 25, TRUE)
			new_handful.forceMove(get_turf(src))
			if(flags_gun_features & GUN_AMMO_COUNTER && user)
				var/chambered = in_chamber ? TRUE : FALSE //useless, but for consistency
				to_chat(user, SPAN_DANGER("[current_mag.current_rounds][chambered ? "+1" : ""] / [current_mag.max_rounds] ROUNDS REMAINING"))
		else
			if(user)
				to_chat(user, SPAN_WARNING("[src] is already empty."))
		return

	unload_shell(user)
	if(!current_mag.current_rounds && !in_chamber) update_icon()

/obj/item/weapon/gun/shotgun/proc/unload_shell(mob/user)
	if(isnull(current_mag) || !length(current_mag.chamber_contents))
		return
	var/obj/item/ammo_magazine/handful/new_handful = retrieve_shell(current_mag.chamber_contents[current_mag.chamber_position])

	if(user)
		user.put_in_hands(new_handful)
		playsound(user, reload_sound, 25, 1)
	else new_handful.forceMove(get_turf(src))

	current_mag.current_rounds--
	current_mag.chamber_contents[current_mag.chamber_position] = "empty"
	current_mag.chamber_position--
	return 1

		//While there is a much smaller way to do this,
		//this is the most resource efficient way to do it.
/obj/item/weapon/gun/shotgun/proc/retrieve_shell(selection)
	var/datum/ammo/A = GLOB.ammo_list[selection]
	var/obj/item/ammo_magazine/handful/new_handful = new A.handful_type()
	new_handful.generate_handful(selection, gauge, 5, 1, /obj/item/weapon/gun/shotgun)
	return new_handful

/obj/item/weapon/gun/shotgun/proc/check_chamber_position()
	return 1


/obj/item/weapon/gun/shotgun/reload(mob/user, var/obj/item/ammo_magazine/magazine)
	if(flags_gun_features & GUN_BURST_FIRING) return

	if(!magazine || !istype(magazine,/obj/item/ammo_magazine/handful)) //Can only reload with handfuls.
		to_chat(user, SPAN_WARNING("You can't use that to reload!"))
		return

	if(!check_chamber_position()) //For the double barrel.
		to_chat(user, SPAN_WARNING("[src] has to be open!"))
		return

	//From here we know they are using shotgun type ammo and reloading via handful.
	//Makes some of this a lot easier to determine.

	var/mag_caliber = magazine.default_ammo //Handfuls can get deleted, so we need to keep this on hand for later.
	if(current_mag.transfer_ammo(magazine,user,1))
		add_to_tube(user,mag_caliber) //This will check the other conditions.

/obj/item/weapon/gun/shotgun/unload(mob/user)
	if(flags_gun_features & GUN_BURST_FIRING) return
	empty_chamber(user)

/obj/item/weapon/gun/shotgun/proc/ready_shotgun_tube()
	if(isnull(current_mag) || !length(current_mag.chamber_contents))
		return
	if(current_mag.current_rounds > 0)
		ammo = GLOB.ammo_list[current_mag.chamber_contents[current_mag.chamber_position]]
		in_chamber = create_bullet(ammo, initial(name))
		current_mag.current_rounds--
		current_mag.chamber_contents[current_mag.chamber_position] = "empty"
		current_mag.chamber_position--
		return in_chamber


/obj/item/weapon/gun/shotgun/ready_in_chamber()
	return ready_shotgun_tube()

/obj/item/weapon/gun/shotgun/reload_into_chamber(mob/user)
	if(!active_attachable)
		in_chamber = null

		//Time to move the tube position.
		ready_in_chamber() //We're going to try and reload. If we don't get anything, icon change.
		if(!current_mag.current_rounds && !in_chamber) //No rounds, nothing chambered.
			update_icon()

	return 1


//-------------------------------------------------------
//GENERIC MERC SHOTGUN //Not really based on anything.

/obj/item/weapon/gun/shotgun/merc
	name = "custom built shotgun"
	desc = "A cobbled-together pile of scrap and alien wood. Point end towards things you want to die. Has a burst fire feature, as if it needed it."
	icon_state = "cshotgun"
	item_state = "cshotgun"

	fire_sound = 'sound/weapons/gun_shotgun_automatic.ogg'
	current_mag = /obj/item/ammo_magazine/internal/shotgun/merc
	attachable_allowed = list(
						/obj/item/attachable/compensator)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG

/obj/item/weapon/gun/shotgun/merc/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()


/obj/item/weapon/gun/shotgun/merc/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 31, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 21, "under_x" = 17, "under_y" = 14, "stock_x" = 17, "stock_y" = 14)


/obj/item/weapon/gun/shotgun/merc/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*2
	burst_amount = BURST_AMOUNT_TIER_2
	burst_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_4
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2


/obj/item/weapon/gun/shotgun/merc/examine(mob/user)
	..()
	if(in_chamber) to_chat(user, "It has a chambered round.")

//-------------------------------------------------------
//TACTICAL SHOTGUN

/obj/item/weapon/gun/shotgun/combat
	name = "\improper MK221 tactical shotgun"
	desc = "The Weston-Yamada MK221 Shotgun, a semi-automatic shotgun with a quick fire rate."
	icon_state = "mk221"
	item_state = "mk221"

	fire_sound = 'sound/weapons/gun_shotgun_automatic.ogg'
	current_mag = /obj/item/ammo_magazine/internal/shotgun
	attachable_allowed = list(
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/compensator,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/stock/tactical)

/obj/item/weapon/gun/shotgun/combat/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/shotgun/combat/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/grenade/G = new(src)
	G.flags_attach_features &= ~ATTACH_REMOVABLE
	G.hidden = TRUE
	G.Attach(src)
	update_attachable(G.slot)

/obj/item/weapon/gun/shotgun/combat/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 21, "under_x" = 14, "under_y" = 16, "stock_x" = 14, "stock_y" = 16)



/obj/item/weapon/gun/shotgun/combat/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_5*2
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2


/obj/item/weapon/gun/shotgun/combat/examine(mob/user)
	..()
	if(in_chamber) to_chat(user, "It has a chambered round.")


/obj/item/weapon/gun/shotgun/combat/riot
	current_mag = /obj/item/ammo_magazine/internal/shotgun/combat/riot

/obj/item/weapon/gun/shotgun/combat/guard
	desc = "The Weston-Yamada MK221 Shotgun, a semi-automatic shotgun with a quick fire rate. Equipped with a red handle to signify its use with Military Police Honor Gaurds"
	icon_state = "mp221"
	item_state = "mp221"
	starting_attachment_types = list(/obj/item/attachable/bayonet)
	starting_attachment_types = list(/obj/item/attachable/magnetic_harness)
	current_mag = /obj/item/ammo_magazine/internal/shotgun/buckshot

//MARSOC MK210, an earlier developmental variant of the MK211 tactical used by the USCM MARSOC.
/obj/item/weapon/gun/shotgun/combat/marsoc
	name = "\improper MK210 tactical shotgun"
	desc = "Way back in 2168, W-Y began testing the MK221. The USCM picked up an early prototype, and later adopted it with a limited military contract. But the USCM MARSOC division wasn't satisfied, and iterated on the early prototypes they had access to; eventually, their internal armorers and tinkerers produced the MK210, a lightweight folding shotgun that snaps to the belt. And to boot, it's fully automatic and made of stamped medal. Truly an engineering marvel."
	icon_state = "mk210"
	item_state = "mk210"

	fire_sound = 'sound/weapons/gun_shotgun_automatic.ogg'
	current_mag = /obj/item/ammo_magazine/internal/shotgun/buckshot

	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG|GUN_HAS_FULL_AUTO|GUN_FULL_AUTO_ON
	fa_delay = FIRE_DELAY_TIER_6

/obj/item/weapon/gun/shotgun/combat/marsoc/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/shotgun/combat/marsoc/handle_starting_attachment()
	return

/obj/item/weapon/gun/shotgun/combat/marsoc/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 21, "under_x" = 14, "under_y" = 16, "stock_x" = 14, "stock_y" = 16)

/obj/item/weapon/gun/shotgun/combat/marsoc/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_5*2
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3 - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

//-------------------------------------------------------
//TYPE 23. SEMI-AUTO UPP SHOTGUN, BASED ON KS-23

/obj/item/weapon/gun/shotgun/type23
	name = "\improper Type 23 riot shotgun"
	desc = "As UPP soldiers frequently reported being outmatched by enemy combatants, UPP High Command commissioned a large amount of Type 23 shotguns, originally used for quelling defector colony riots. This slow semi-automatic shotgun chambers 8 gauge, and packs a mean punch."
	icon_state = "type23"
	item_state = "type23"
	fire_sound = 'sound/weapons/gun_type23.ogg' //not perfect, too small
	current_mag = /obj/item/ammo_magazine/internal/shotgun/type23
	attachable_allowed = list(
						//Rail
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/magnetic_harness,
						//Muzzle
						/obj/item/attachable/bayonet,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/bayonet/upp,
						//Underbarrel
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/burstfire_assembly, //what could possibly go wrong?
						//Stock
						/obj/item/attachable/stock/type23
						)
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_INTERNAL_MAG
	flags_equip_slot = SLOT_BACK
	map_specific_decoration = FALSE
	gauge = "8g"
	starting_attachment_types = list(/obj/item/attachable/stock/type23)

/obj/item/weapon/gun/shotgun/type23/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 31, "muzzle_y" = 19,"rail_x" = 13, "rail_y" = 21, "under_x" = 24, "under_y" = 15, "stock_x" = 1, "stock_y" = 16)

/obj/item/weapon/gun/shotgun/type23/set_gun_config_values()
	..()
	fire_delay = 2.5 SECONDS
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_4
	scatter_unwielded = SCATTER_AMOUNT_TIER_1
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_1
	recoil_unwielded = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/shotgun/type23/breacher
	random_spawn_chance = 100
	random_rail_chance = 100
	random_spawn_rail = list(
							/obj/item/attachable/magnetic_harness,
							/obj/item/attachable/flashlight
							)
	random_muzzle_chance = 100
	random_spawn_muzzle = list(
							/obj/item/attachable/bayonet/upp,
							)
	random_under_chance = 40
	random_spawn_under = list(
							/obj/item/attachable/verticalgrip,
							)

/obj/item/weapon/gun/shotgun/type23/breacher/slug
	current_mag = /obj/item/ammo_magazine/internal/shotgun/type23/slug

/obj/item/weapon/gun/shotgun/type23/breacher/flechette
	current_mag = /obj/item/ammo_magazine/internal/shotgun/type23/flechette

/obj/item/weapon/gun/shotgun/type23/dual
	random_spawn_chance = 100
	random_rail_chance = 100
	random_spawn_rail = list(
							/obj/item/attachable/magnetic_harness,
							)
	random_muzzle_chance = 80
	random_spawn_muzzle = list(
							/obj/item/attachable/bayonet/upp,
							/obj/item/attachable/heavy_barrel
							)
	random_under_chance = 100
	random_spawn_under = list(
							/obj/item/attachable/flashlight/grip,
							/obj/item/attachable/verticalgrip,
							)

/obj/item/weapon/gun/shotgun/type23/dragon
	current_mag = /obj/item/ammo_magazine/internal/shotgun/type23/dragonsbreath
	random_spawn_chance = 100
	random_rail_chance = 100
	random_spawn_rail = list(
							/obj/item/attachable/magnetic_harness,
							)
	random_muzzle_chance = 70
	random_spawn_muzzle = list(
							/obj/item/attachable/bayonet/upp,
							/obj/item/attachable/heavy_barrel
							)
	random_under_chance = 100
	random_spawn_under = list(
							/obj/item/attachable/attached_gun/extinguisher,
							)

//-------------------------------------------------------
//DOUBLE SHOTTY

/obj/item/weapon/gun/shotgun/double
	name = "double barrel shotgun"
	desc = "A double barreled shotgun of archaic, but sturdy design. Uses 12 Gauge Special slugs, but can only hold 2 at a time."
	icon_state = "dshotgun"
	item_state = "dshotgun"

	current_mag = /obj/item/ammo_magazine/internal/shotgun/double
	fire_sound = 'sound/weapons/gun_shotgun_heavy.ogg'
	break_sound = 'sound/weapons/handling/gun_mou_open.ogg'
	seal_sound = 'sound/weapons/handling/gun_mou_close.ogg'//replace w/ uniques
	cocked_sound = null //We don't want this.
	attachable_allowed = list(
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/gyro,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/magnetic_harness)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG
	burst_delay = 0 //So doubleshotty can doubleshot
	has_open_icon = TRUE

/obj/item/weapon/gun/shotgun/double/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 21,"rail_x" = 15, "rail_y" = 22, "under_x" = 21, "under_y" = 16, "stock_x" = 21, "stock_y" = 16)

/obj/item/weapon/gun/shotgun/double/set_gun_config_values()
	..()
	burst_amount = BURST_AMOUNT_TIER_2
	fire_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/shotgun/double/examine(mob/user)
	..()
	if(!current_mag)
		return
	if(current_mag.chamber_closed) to_chat(user, "It's closed.")
	else to_chat(user, "It's open with [current_mag.current_rounds] shell\s loaded.")

/obj/item/weapon/gun/shotgun/double/unique_action(mob/user)
	if(flags_item & WIELDED)
		unwield(user)
	open_chamber(user)

/obj/item/weapon/gun/shotgun/double/check_chamber_position()
	if(!current_mag)
		return
	if(current_mag.chamber_closed) return
	return 1

/obj/item/weapon/gun/shotgun/double/add_to_tube(mob/user,selection) //Load it on the go, nothing chambered.
	if(!current_mag)
		return
	current_mag.chamber_position++
	current_mag.chamber_contents[current_mag.chamber_position] = selection
	playsound(user, reload_sound, 25, 1)
	return 1

/obj/item/weapon/gun/shotgun/double/able_to_fire(mob/user)
	. = ..()
	if(. && istype(user))
		if(!current_mag)
			return
		if(!current_mag.chamber_closed)
			to_chat(user, SPAN_DANGER("Close the chamber!"))
			return 0

/obj/item/weapon/gun/shotgun/double/empty_chamber(mob/user)
	if(!current_mag)
		return
	if(current_mag.chamber_closed)
		open_chamber(user)
	else
		..()

/obj/item/weapon/gun/shotgun/double/load_into_chamber()
	//Trimming down the unnecessary stuff.
	//This doesn't chamber, creates a bullet on the go.

	if(!current_mag)
		return
	if(current_mag.current_rounds > 0)
		ammo = GLOB.ammo_list[current_mag.chamber_contents[current_mag.chamber_position]]
		in_chamber = create_bullet(ammo, initial(name))
		current_mag.current_rounds--
		return in_chamber
	//We can't make a projectile without a mag or active attachable.


/obj/item/weapon/gun/shotgun/double/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(!current_mag)
		return
	if(refund) current_mag.current_rounds++
	return 1

/obj/item/weapon/gun/shotgun/double/reload_into_chamber(mob/user)
	if(!current_mag)
		return
	in_chamber = null
	current_mag.chamber_contents[current_mag.chamber_position] = "empty"
	current_mag.chamber_position--
	return 1

/obj/item/weapon/gun/shotgun/double/proc/open_chamber(mob/user)
	if(!current_mag)
		return
	current_mag.chamber_closed = !current_mag.chamber_closed
	update_icon()

	if (current_mag.chamber_closed)
		playsound(user, break_sound, 25, 1)
	else
		playsound(user, seal_sound, 25, 1)


/obj/item/weapon/gun/shotgun/double/sawn
	name = "sawn-off shotgun"
	desc = "A double barreled shotgun whose barrel has been artificially shortened to reduce range but increase damage and spread."
	icon_state = "sshotgun"
	item_state = "sshotgun"
	flags_equip_slot = SLOT_WAIST
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG

/obj/item/weapon/gun/shotgun/double/sawn/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 20,"rail_x" = 11, "rail_y" = 22, "under_x" = 18, "under_y" = 16, "stock_x" = 18, "stock_y" = 16)

/obj/item/weapon/gun/shotgun/double/sawn/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3 - HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_7
	recoil = RECOIL_AMOUNT_TIER_3
	recoil_unwielded = RECOIL_AMOUNT_TIER_1

//M-OU53 SHOTGUN | Marine mid-range slug/flechette only coach gun (except its an over-under). Support weapon for slug stuns / flechette DOTS (when implemented). Buckshot in this thing is just stupidly strong, hence the denial.

/obj/item/weapon/gun/shotgun/double/mou53
	name = "\improper MOU53 break action shotgun"
	desc = "A limited production Kerchner MOU53 triple break action classic. Respectable damage output at medium ranges, while the ARMAT M37 is the king of CQC, the Kerchner MOU53 is what hits the broadside of that barn. This specific model cannot safely fire buckshot shells."
	icon_state = "mou"
	item_state = "mou"
	var/max_rounds = 3
	var/current_rounds = 0
	fire_sound = 'sound/weapons/gun_mou53.ogg'
	reload_sound = 'sound/weapons/handling/gun_mou_reload.ogg'//unique shell insert
	flags_equip_slot = SLOT_BACK
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG
	current_mag = /obj/item/ammo_magazine/internal/shotgun/double/mou53 //Take care, she comes loaded!
	attachable_allowed = list(
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/gyro,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/stock/mou53)
	map_specific_decoration = TRUE

/obj/item/weapon/gun/shotgun/double/mou53/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 11, "rail_y" = 21, "under_x" = 17, "under_y" = 15, "stock_x" = 10, "stock_y" = 9) //Weird stock values, make sure any new stock matches the old sprite placement in the .dmi


/obj/item/weapon/gun/shotgun/double/mou53/set_gun_config_values()
	..()
	burst_amount = BURST_AMOUNT_TIER_1
	fire_delay = FIRE_DELAY_TIER_8
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_3
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/shotgun/double/mou53/reload(mob/user, obj/item/ammo_magazine/magazine)
	if(magazine.default_ammo == /datum/ammo/bullet/shotgun/buckshot) // No buckshot in this gun
		to_chat(user, SPAN_WARNING("\the [src] cannot safely fire this type of shell!"))
		return
	..()

//-------------------------------------------------------
//PUMP SHOTGUN
//Shotguns in this category will need to be pumped each shot.

/obj/item/weapon/gun/shotgun/pump
	name = "\improper M37A2 pump shotgun"
	desc = "An Armat Battlefield Systems classic design, the M37A2 combines close-range firepower with long term reliability. Requires a pump, which is a Unique Action."
	icon_state = "m37"
	item_state = "m37"
	current_mag = /obj/item/ammo_magazine/internal/shotgun
	flags_equip_slot = SLOT_BACK
	fire_sound = 'sound/weapons/gun_shotgun.ogg'
	var/pump_sound = 'sound/weapons/gun_shotgun_pump.ogg'
	var/pump_delay //Higher means longer delay.
	var/recent_pump //world.time to see when they last pumped it.
	var/pumped = FALSE //Used to see if the shotgun has already been pumped.
	var/message //To not spam the above.
	attachable_allowed = list(
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/gyro,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/compensator,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/stock/shotgun)
	map_specific_decoration = TRUE

/obj/item/weapon/gun/shotgun/pump/Initialize(mapload, spawn_empty)
	. = ..()
	pump_delay = FIRE_DELAY_TIER_4*2


/obj/item/weapon/gun/shotgun/pump/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 20, "under_x" = 20, "under_y" = 14, "stock_x" = 20, "stock_y" = 14)


/obj/item/weapon/gun/shotgun/pump/set_gun_config_values()
	..()
	burst_amount = BURST_AMOUNT_TIER_1
	fire_delay = FIRE_DELAY_TIER_7 * 5
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/shotgun/pump/unique_action(mob/user)
	pump_shotgun(user)

/obj/item/weapon/gun/shotgun/pump/ready_in_chamber() //If there wasn't a shell loaded through pump, this returns null.
	return

//Same as double barrel. We don't want to do anything else here.
/obj/item/weapon/gun/shotgun/pump/add_to_tube(mob/user, selection) //Load it on the go, nothing chambered.
	if(!current_mag)
		return
	current_mag.chamber_position++
	current_mag.chamber_contents[current_mag.chamber_position] = selection
	playsound(user, reload_sound, 25, 1)
	return 1
	/*
	Moves the ready_in_chamber to it's own proc.
	If the Fire() cycle doesn't find a chambered round with no active attachable, it will return null.
	Which is what we want, since the gun shouldn't fire unless something was chambered.
	*/

//More or less chambers the round instead of load_into_chamber().
/obj/item/weapon/gun/shotgun/pump/proc/pump_shotgun(mob/user)	//We can't fire bursts with pumps.
	if(world.time < (recent_pump + pump_delay) ) return //Don't spam it.
	if(pumped)
		if (world.time > (message + pump_delay))
			to_chat(usr, SPAN_WARNING("<i>[src] already has a shell in the chamber!<i>"))
			message = world.time
		return
	if(in_chamber) //eject the chambered round
		in_chamber = null
		var/obj/item/ammo_magazine/handful/new_handful = retrieve_shell(ammo.type)
		new_handful.forceMove(get_turf(src))

	ready_shotgun_tube()

	playsound(user, pump_sound, 25, 1)
	recent_pump = world.time
	if (in_chamber)
		pumped = TRUE


/obj/item/weapon/gun/shotgun/pump/reload_into_chamber(mob/user)
	if(!current_mag)
		return
	if(!active_attachable)
		pumped = FALSE //It was fired, so let's unlock the pump.
		in_chamber = null
		//Time to move the tube position.
		if(!current_mag.current_rounds && !in_chamber)
			update_icon()//No rounds, nothing chambered.

	return 1

/obj/item/weapon/gun/shotgun/pump/unload(mob/user) //We can't pump it to get rid of the shells, so we'll make it work via the unloading mechanism.
	if(pumped)
		to_chat(user, SPAN_WARNING("You release the locking mechanism on [src]."))
		pumped = FALSE
	return ..()

//-------------------------------------------------------
//SHOTGUN FROM ISOLATION

/obj/item/weapon/gun/shotgun/pump/cmb
	name = "\improper HG 37-12 pump shotgun"
	desc = "A nine-round pump action shotgun with internal tube magazine allowing for quick reloading and highly accurate fire. Used exclusively by Colonial Marshals."
	icon_state = "hg3712"
	item_state = "hg3712"
	fire_sound = 'sound/weapons/gun_shotgun_small.ogg'
	current_mag = /obj/item/ammo_magazine/internal/shotgun/buckshot
	attachable_allowed = list(
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/gyro,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/compensator,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/flamer)
	map_specific_decoration = FALSE


/obj/item/weapon/gun/shotgun/pump/cmb/Initialize(mapload, spawn_empty)
	. = ..()
	pump_delay = FIRE_DELAY_TIER_5*2


/obj/item/weapon/gun/shotgun/pump/cmb/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 31, "muzzle_y" = 15,"rail_x" = 7, "rail_y" = 18, "under_x" = 19, "under_y" = 13, "stock_x" = 19, "stock_y" = 17)


/obj/item/weapon/gun/shotgun/pump/cmb/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_7*4
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2


//-------------------------------------------------------
