/obj/item/attachable/attached_gun
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	attachment_action_type = /datum/action/item_action/toggle
	// Some attachments may be fired. So here are the variables related to that.
	/// Ammo to fire the attachment with
	var/datum/ammo/ammo = null
	var/max_range = 0 //Determines # of tiles distance the attachable can fire, if it's not a projectile.
	var/last_fired //When the attachment was last fired.
	var/attachment_firing_delay = 0 //the delay between shots, for attachments that fires stuff
	var/fire_sound = null //Sound to play when firing it alternately
	var/gun_original_damage_mult = 1 //so you don't buff the underbarrell gun with charger for the wrong weapon
	var/gun_deactivate_sound = 'sound/weapons/handling/gun_underbarrel_deactivate.ogg'//allows us to give the attached gun unique activate and de-activate sounds. Not used yet.
	var/gun_activate_sound  = 'sound/weapons/handling/gun_underbarrel_activate.ogg'
	var/unload_sound = 'sound/weapons/gun_shotgun_shell_insert.ogg'

	/// An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	/// that will be given to the projectiles of the attached gun
	var/list/list/traits_to_give_attached
	/// Current target we're firing at
	var/mob/target

/obj/item/attachable/attached_gun/Initialize(mapload, ...) //Let's make sure if something needs an ammo type, it spawns with one.
	. = ..()
	if(ammo)
		ammo = GLOB.ammo_list[ammo]


/obj/item/attachable/attached_gun/Destroy()
	ammo = null
	target = null
	return ..()

/// setter for target
/obj/item/attachable/attached_gun/proc/set_target(atom/object)
	if(object == target)
		return
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = object
	if(target)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clean_target))

///Set the target to its turf, so we keep shooting even when it was qdeled
/obj/item/attachable/attached_gun/proc/clean_target()
	SIGNAL_HANDLER
	target = get_turf(target)

/obj/item/attachable/attached_gun/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	if(G.active_attachable == src)
		if(user)
			to_chat(user, SPAN_NOTICE("You are no longer using [src]."))
			playsound(user, gun_deactivate_sound, 30, 1)
		G.active_attachable = null
		var/diff = G.damage_mult - 1 //so that if we buffed gun in process, it still does stuff
		//yeah you can cheat by placing BC after switching to underbarrell, but that is one time and we can skip it for sake of optimization
		G.damage_mult = gun_original_damage_mult + diff
		icon_state = initial(icon_state)
	else if(!turn_off)
		if(user)
			to_chat(user, SPAN_NOTICE("You are now using [src]."))
			playsound(user, gun_activate_sound, 60, 1)
		G.active_attachable = src
		gun_original_damage_mult = G.damage_mult
		G.damage_mult = 1
		icon_state += "-on"

	SEND_SIGNAL(G, COMSIG_GUN_INTERRUPT_FIRE)

	for(var/X in G.actions)
		var/datum/action/A = X
		A.update_button_icon()
	return 1



//The requirement for an attachable being alt fire is AMMO CAPACITY > 0.
/obj/item/attachable/attached_gun/grenade
	name = "U1 grenade launcher"
	desc = "A weapon-mounted, reloadable grenade launcher."
	icon_state = "grenade"
	attach_icon = "grenade_a"
	w_class = SIZE_MEDIUM
	current_rounds = 0
	max_rounds = 3
	max_range = 7
	slot = "under"
	fire_sound = 'sound/weapons/gun_m92_attachable.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	var/grenade_pass_flags
	var/list/loaded_grenades //list of grenade types loaded in the UGL
	var/breech_open = FALSE // is the UGL open for loading?
	var/cocked = TRUE // has the UGL been cocked via opening and closing the breech?
	var/open_sound = 'sound/weapons/handling/ugl_open.ogg'
	var/close_sound = 'sound/weapons/handling/ugl_close.ogg'

/obj/item/attachable/attached_gun/grenade/Initialize()
	. = ..()
	grenade_pass_flags = PASS_HIGH_OVER|PASS_MOB_THRU

/obj/item/attachable/attached_gun/grenade/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_4 * 3
	loaded_grenades = list()

/obj/item/attachable/attached_gun/grenade/get_examine_text(mob/user)
	. = ..()
	if(current_rounds) . += "It has [current_rounds] grenade\s left."
	else . += "It's empty."

/obj/item/attachable/attached_gun/grenade/unique_action(mob/user)
	if(!ishuman(usr))
		return
	if(user.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(user, SPAN_WARNING("Not right now."))
		return

	var/obj/item/weapon/gun/G = user.get_held_item()
	if(!istype(G))
		G = user.get_inactive_hand()
	if(!istype(G) && G != null)
		G = user.get_active_hand()
	if(!G)
		to_chat(user, SPAN_WARNING("You need to hold \the [src] to do that"))
		return

	pump(user)

/obj/item/attachable/attached_gun/grenade/update_icon()
	. = ..()
	attach_icon = initial(attach_icon)
	icon_state = initial(icon_state)
	if(breech_open)
		attach_icon += "-open"
		icon_state += "-open"
	if(istype(loc, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/gun = loc
		gun.update_attachable(slot)

/obj/item/attachable/attached_gun/grenade/proc/pump(mob/user) //for want of a better proc name
	if(breech_open) // if it was ALREADY open
		breech_open = FALSE
		cocked = TRUE // by closing the gun we have cocked it and readied it to fire
		to_chat(user, SPAN_NOTICE("You close \the [src]'s breech, cocking it!"))
		playsound(src, close_sound, 15, 1)
	else
		breech_open = TRUE
		cocked = FALSE
		to_chat(user, SPAN_NOTICE("You open \the [src]'s breech!"))
		playsound(src, open_sound, 15, 1)
	update_icon()

/obj/item/attachable/attached_gun/grenade/reload_attachment(obj/item/explosive/grenade/G, mob/user)
	if(!breech_open)
		to_chat(user, SPAN_WARNING("\The [src]'s breech must be open to load grenades! (use unique-action)"))
		return
	if(!istype(G) || istype(G, /obj/item/explosive/grenade/spawnergrenade/))
		to_chat(user, SPAN_WARNING("[src] doesn't accept that type of grenade."))
		return
	if(!G.active) //can't load live grenades
		if(!G.underslug_launchable)
			to_chat(user, SPAN_WARNING("[src] doesn't accept that type of grenade."))
			return
		if(current_rounds >= max_rounds)
			to_chat(user, SPAN_WARNING("[src] is full."))
		else
			playsound(user, 'sound/weapons/grenade_insert.wav', 25, 1)
			current_rounds++
			loaded_grenades += G
			to_chat(user, SPAN_NOTICE("You load \the [G] into \the [src]."))
			user.drop_inv_item_to_loc(G, src)

/obj/item/attachable/attached_gun/grenade/unload_attachment(mob/user, reload_override = FALSE, drop_override = FALSE, loc_override = FALSE)
	. = TRUE //Always uses special unloading.
	if(!breech_open)
		to_chat(user, SPAN_WARNING("\The [src] is closed! You must open it to take out grenades!"))
		return
	if(!current_rounds)
		to_chat(user, SPAN_WARNING("It's empty!"))
		return

	var/obj/item/explosive/grenade/nade = loaded_grenades[length(loaded_grenades)] //Grab the last-inserted one. Or the only one, as the case may be.
	loaded_grenades.Remove(nade)
	current_rounds--

	if(drop_override || !user)
		nade.forceMove(get_turf(src))
	else
		user.put_in_hands(nade)

	user.visible_message(SPAN_NOTICE("[user] unloads \a [nade] from \the [src]."),
	SPAN_NOTICE("You unload \a [nade] from \the [src]."), null, 4, CHAT_TYPE_COMBAT_ACTION)
	playsound(user, unload_sound, 30, 1)

/obj/item/attachable/attached_gun/grenade/fire_attachment(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	if(!(gun.flags_item & WIELDED))
		if(user)
			to_chat(user, SPAN_WARNING("You must hold [gun] with two hands to use \the [src]."))
		return
	if(breech_open)
		if(user)
			to_chat(user, SPAN_WARNING("You must close the breech to fire \the [src]!"))
			playsound(user, 'sound/weapons/gun_empty.ogg', 50, TRUE, 5)
		return
	if(!cocked)
		if(user)
			to_chat(user, SPAN_WARNING("You must cock \the [src] to fire it! (open and close the breech)"))
			playsound(user, 'sound/weapons/gun_empty.ogg', 50, TRUE, 5)
		return
	if(get_dist(user,target) > max_range)
		to_chat(user, SPAN_WARNING("Too far to fire the attachment!"))
		playsound(user, 'sound/weapons/gun_empty.ogg', 50, TRUE, 5)
		return

	if(current_rounds > 0 && ..())
		prime_grenade(target,gun,user)

/obj/item/attachable/attached_gun/grenade/proc/prime_grenade(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	set waitfor = 0
	var/obj/item/explosive/grenade/G = loaded_grenades[1]

	if(G.antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(G, user))
		to_chat(user, SPAN_WARNING("\The [name]'s safe-area accident inhibitor prevents you from firing!"))
		msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
		return

	playsound(user.loc, fire_sound, 50, 1)
	msg_admin_attack("[key_name_admin(user)] fired an underslung grenade launcher [ADMIN_JMP_USER(user)]")
	log_game("[key_name_admin(user)] used an underslung grenade launcher.")

	var/pass_flags = NO_FLAGS
	pass_flags |= grenade_pass_flags
	G.det_time = min(15, G.det_time)
	G.throw_range = max_range
	G.activate(user, FALSE)
	G.forceMove(get_turf(gun))
	G.throw_atom(target, max_range, SPEED_VERY_FAST, user, null, NORMAL_LAUNCH, pass_flags)
	current_rounds--
	cocked = FALSE // we have fired so uncock the gun
	loaded_grenades.Cut(1,2)

//For the Mk1
/obj/item/attachable/attached_gun/grenade/mk1
	name = "\improper MK1 underslung grenade launcher"
	desc = "An older version of the classic underslung grenade launcher. Can store five grenades, and fire them farther, but fires them slower."
	icon_state = "grenade-mk1"
	attach_icon = "grenade-mk1_a"
	current_rounds = 0
	max_rounds = 5
	max_range = 10
	attachment_firing_delay = 30

/obj/item/attachable/attached_gun/grenade/m203 //M16 GL, only DD have it.
	name = "\improper M203 Grenade Launcher"
	desc = "An antique underbarrel grenade launcher. Adopted in 1969 for the M16, it was made obsolete centuries ago; how its ended up here is a mystery to you. Holds only one propriatary 40mm grenade, does not have modern IFF systems, it won't pass through your friends."
	icon_state = "grenade-m203"
	attach_icon = "grenade-m203_a"
	current_rounds = 0
	max_rounds = 1
	max_range = 14
	attachment_firing_delay = 5 //one shot, so if you can reload fast you can shoot fast

/obj/item/attachable/attached_gun/grenade/m203/Initialize()
	. = ..()
	grenade_pass_flags = NO_FLAGS

//"ammo/flamethrower" is a bullet, but the actual process is handled through fire_attachment, linked through Fire().
/obj/item/attachable/attached_gun/flamer
	name = "mini flamethrower"
	icon_state = "flamethrower"
	attach_icon = "flamethrower_a"
	desc = "A weapon-mounted refillable flamethrower attachment. It has a secondary setting for a more intense flame with far less propulsion ability and heavy fuel usage."
	w_class = SIZE_MEDIUM
	current_rounds = 40
	max_rounds = 40
	max_range = 5
	slot = "under"
	fire_sound = 'sound/weapons/gun_flamethrower3.ogg'
	gun_activate_sound = 'sound/weapons/handling/gun_underbarrel_flamer_activate.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	var/base_type = /obj/item/attachable/attached_gun/flamer
	var/burn_level = BURN_LEVEL_TIER_1
	var/burn_duration = BURN_TIME_TIER_1
	var/round_usage_per_tile = 1
	var/intense_mode = FALSE
	/// Whether an igniter element was added to the attached gun (if attached)
	VAR_PRIVATE/added_igniter = FALSE


/obj/item/attachable/attached_gun/flamer/Initialize(mapload, ...)
	. = ..()
	attachment_firing_delay = FIRE_DELAY_TIER_4 * 5
	ADD_TRAIT(src, TRAIT_IGNITER, TRAIT_SOURCE_INHERENT)

/obj/item/attachable/attached_gun/flamer/Attach(obj/item/weapon/gun/to_attach_to)
	..()
	ADD_TRAIT(to_attach_to, TRAIT_IGNITER, TRAIT_SOURCE_ATTACHMENT(slot))
	RegisterSignal(to_attach_to, COMSIG_IGNITER_OVERRIDE, PROC_REF(igniter_override))

/obj/item/attachable/attached_gun/flamer/Detach(mob/user, obj/item/weapon/gun/detaching_gub)
	REMOVE_TRAIT(detaching_gub, TRAIT_IGNITER, TRAIT_SOURCE_ATTACHMENT(slot))
	UnregisterSignal(detaching_gub, COMSIG_IGNITER_OVERRIDE)
	..()

/obj/item/attachable/attached_gun/flamer/proc/igniter_override(obj/item/weapon/gun/attached_to, datum/igniter_override_metadata/metadata)
	SIGNAL_HANDLER
	metadata.igniter_override = src

/obj/item/attachable/attached_gun/flamer/get_examine_text(mob/user)
	. = ..()
	if(intense_mode)
		. += "It is currently using a more intense and volatile flame."
	else
		. += "It is using a normal and stable flame."
	if(current_rounds > 0)
		. += "It has [current_rounds] unit\s of fuel left."
	else
		. += "It's empty."

/obj/item/attachable/attached_gun/flamer/unique_action(mob/user)
	..()
	playsound(user,'sound/weapons/handling/flamer_ignition.ogg', 25, 1)
	if(intense_mode)
		to_chat(user, SPAN_WARNING("You change \the [src] back to using a normal and more stable flame."))
		round_usage_per_tile = 1
		burn_level = BURN_LEVEL_TIER_1
		burn_duration = BURN_TIME_TIER_1
		max_range = 5
		intense_mode = FALSE
	else
		to_chat(user, SPAN_WARNING("You change \the [src] to use a more intense and volatile flame."))
		round_usage_per_tile = 5
		burn_level = BURN_LEVEL_TIER_5
		burn_duration = BURN_TIME_TIER_2
		max_range = 2
		intense_mode = TRUE

/obj/item/attachable/attached_gun/flamer/handle_pre_break_attachment_description(base_description_text as text)
	return base_description_text + " It is on [intense_mode ? "intense" : "normal"] mode."

/obj/item/attachable/attached_gun/flamer/reload_attachment(obj/item/ammo_magazine/flamer_tank/FT, mob/user)
	if(istype(FT))
		if(current_rounds >= max_rounds)
			to_chat(user, SPAN_WARNING("[src] is full."))
		else if(FT.current_rounds <= 0)
			to_chat(user, SPAN_WARNING("[FT] is empty!"))
		else
			playsound(user, 'sound/effects/refill.ogg', 25, 1, 3)
			to_chat(user, SPAN_NOTICE("You refill [src] with [FT]."))
			var/transfered_rounds = min(max_rounds - current_rounds, FT.current_rounds)
			current_rounds += transfered_rounds
			FT.current_rounds -= transfered_rounds

			var/amount_of_reagents = length(FT.reagents.reagent_list)
			var/amount_removed_per_reagent = transfered_rounds / amount_of_reagents
			for(var/datum/reagent/R in FT.reagents.reagent_list)
				R.volume -= amount_removed_per_reagent
			FT.update_icon()
	else
		to_chat(user, SPAN_WARNING("[src] can only be refilled with an incinerator tank."))

/obj/item/attachable/attached_gun/flamer/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	if(get_dist(user,target) > max_range+4)
		to_chat(user, SPAN_WARNING("Too far to fire the attachment!"))
		return

	if(!istype(loc, /obj/item/weapon/gun))
		to_chat(user, SPAN_WARNING("\The [src] must be attached to a gun!"))
		return

	var/obj/item/weapon/gun/attached_gun = loc

	if(!(attached_gun.flags_item & WIELDED))
		to_chat(user, SPAN_WARNING("You must wield [attached_gun] to fire [src]!"))
		return

	if(current_rounds > round_usage_per_tile && ..())
		unleash_flame(target, user)
		if(attached_gun.last_fired < world.time)
			attached_gun.last_fired = world.time

/obj/item/attachable/attached_gun/flamer/proc/unleash_flame(atom/target, mob/living/user)
	set waitfor = 0
	var/list/turf/turfs = get_line(user,target)
	var/distance = 0
	var/turf/prev_T
	var/stop_at_turf = FALSE
	playsound(user, 'sound/weapons/gun_flamethrower2.ogg', 50, 1)
	for(var/turf/T in turfs)
		if(T == user.loc)
			prev_T = T
			continue
		if(!current_rounds || current_rounds < round_usage_per_tile)
			break
		if(distance >= max_range)
			break

		current_rounds -= round_usage_per_tile
		var/datum/cause_data/cause_data = create_cause_data(initial(name), user)
		if(T.density)
			T.flamer_fire_act(0, cause_data)
			stop_at_turf = TRUE
		else if(prev_T)
			var/atom/movable/temp = new/obj/flamer_fire()
			var/atom/movable/AM = LinkBlocked(temp, prev_T, T)
			qdel(temp)
			if(AM)
				AM.flamer_fire_act(0, cause_data)
				if (AM.flags_atom & ON_BORDER)
					break
				stop_at_turf = TRUE
		flame_turf(T, user)
		if (stop_at_turf)
			break
		distance++
		prev_T = T
		sleep(1)


/obj/item/attachable/attached_gun/flamer/proc/flame_turf(turf/T, mob/living/user)
	if(!istype(T)) return

	if(!locate(/obj/flamer_fire) in T) // No stacking flames!
		var/datum/reagent/napalm/ut/R = new()

		R.intensityfire = burn_level
		R.durationfire = burn_duration

		new/obj/flamer_fire(T, create_cause_data(initial(name), user), R)

/obj/item/attachable/attached_gun/flamer/advanced
	name = "advanced mini flamethrower"
	current_rounds = 50
	max_rounds = 50
	max_range = 6
	burn_level = BURN_LEVEL_TIER_5
	burn_duration = BURN_TIME_TIER_2

/obj/item/attachable/attached_gun/flamer/advanced/unique_action(mob/user)
	return	//No need for volatile mode, it already does high damage by default

/obj/item/attachable/attached_gun/flamer/advanced/integrated
	name = "integrated flamethrower"

/obj/item/attachable/attached_gun/shotgun //basically, a masterkey
	name = "\improper U7 underbarrel shotgun"
	icon_state = "masterkey"
	attach_icon = "masterkey_a"
	desc = "An ARMAT U7 tactical shotgun. Attaches to the underbarrel of most weapons. Only capable of loading up to five buckshot shells. Specialized for breaching into buildings."
	w_class = SIZE_MEDIUM
	max_rounds = 5
	current_rounds = 5
	ammo = /datum/ammo/bullet/shotgun/buckshot/masterkey
	slot = "under"
	fire_sound = 'sound/weapons/gun_shotgun_u7.ogg'
	gun_activate_sound = 'sound/weapons/handling/gun_u7_activate.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_PROJECTILE|ATTACH_RELOADABLE|ATTACH_WEAPON

/obj/item/attachable/attached_gun/shotgun/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_5*3

/obj/item/attachable/attached_gun/shotgun/get_examine_text(mob/user)
	. = ..()
	if(current_rounds > 0) . += "It has [current_rounds] shell\s left."
	else . += "It's empty."

/obj/item/attachable/attached_gun/shotgun/set_bullet_traits()
	LAZYADD(traits_to_give_attached, list(
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 5, GLOB.damage_boost_turfs),
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 10.8, GLOB.damage_boost_breaching),
		BULLET_TRAIT_ENTRY_ID("pylons", /datum/element/bullet_trait_damage_boost, 5, GLOB.damage_boost_pylons)
	))

/obj/item/attachable/attached_gun/shotgun/reload_attachment(obj/item/ammo_magazine/handful/mag, mob/user)
	if(istype(mag) && mag.flags_magazine & AMMUNITION_HANDFUL)
		if(mag.default_ammo == /datum/ammo/bullet/shotgun/buckshot)
			if(current_rounds >= max_rounds)
				to_chat(user, SPAN_WARNING("[src] is full."))
			else
				current_rounds++
				mag.current_rounds--
				mag.update_icon()
				to_chat(user, SPAN_NOTICE("You load one shotgun shell in [src]."))
				playsound(user, 'sound/weapons/gun_shotgun_shell_insert.ogg', 25, 1)
				if(mag.current_rounds <= 0)
					user.temp_drop_inv_item(mag)
					qdel(mag)
			return
	to_chat(user, SPAN_WARNING("[src] only accepts shotgun buckshot."))

/obj/item/attachable/attached_gun/extinguisher
	name = "HME-12 underbarrel extinguisher"
	icon_state = "extinguisher"
	attach_icon = "extinguisher_a"
	desc = "A Taiho-Technologies HME-12 underbarrel extinguisher. Attaches to the underbarrel of most weapons. Point at flame before applying pressure."
	w_class = SIZE_MEDIUM
	slot = "under"
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_WEAPON|ATTACH_MELEE
	var/obj/item/tool/extinguisher/internal_extinguisher
	current_rounds = 1 //This has to be done to pass the fire_attachment check.

/obj/item/attachable/attached_gun/extinguisher/get_examine_text(mob/user)
	. = ..()
	if(internal_extinguisher)
		. += SPAN_NOTICE("It has [internal_extinguisher.reagents.total_volume] unit\s of water left!")
		return
	. += SPAN_WARNING("It's empty.")

/obj/item/attachable/attached_gun/extinguisher/handle_attachment_description(slot)
	return "It has a [icon2html(src)] [name] ([internal_extinguisher.reagents.total_volume]/[internal_extinguisher.max_water]) mounted underneath.<br>"

/obj/item/attachable/attached_gun/extinguisher/New()
	..()
	initialize_internal_extinguisher()

/obj/item/attachable/attached_gun/extinguisher/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	if(!internal_extinguisher)
		return
	if(..())
		return internal_extinguisher.afterattack(target, user)

/obj/item/attachable/attached_gun/extinguisher/proc/initialize_internal_extinguisher()
	internal_extinguisher = new /obj/item/tool/extinguisher/mini/integrated_flamer()
	internal_extinguisher.safety = FALSE
	internal_extinguisher.create_reagents(internal_extinguisher.max_water)
	internal_extinguisher.reagents.add_reagent("water", internal_extinguisher.max_water)

/obj/item/attachable/attached_gun/extinguisher/pyro
	name = "HME-88B underbarrel extinguisher"
	desc = "An experimental Taiho-Technologies HME-88B underbarrel extinguisher integrated with a select few gun models. It is capable of putting out the strongest of flames. Point at flame before applying pressure."
	flags_attach_features = ATTACH_ACTIVATION|ATTACH_WEAPON|ATTACH_MELEE //not removable

/obj/item/attachable/attached_gun/extinguisher/pyro/initialize_internal_extinguisher()
	internal_extinguisher = new /obj/item/tool/extinguisher/pyro()
	internal_extinguisher.safety = FALSE
	internal_extinguisher.create_reagents(internal_extinguisher.max_water)
	internal_extinguisher.reagents.add_reagent("water", internal_extinguisher.max_water)

/obj/item/attachable/attached_gun/flamer_nozzle
	name = "XM-VESG-1 flamer nozzle"
	desc = "A special nozzle designed to alter flamethrowers to be used in a more offense orientated manner. As the inside of the nozzle is coated in a special gel and resin substance that takes the fuel that passes through and hardens it. Upon exiting the barrel, a cluster of burning gel is projected instead of a stream of burning naphtha."
	desc_lore = "The Experimental Volatile-Exothermic-Sphere-Generator clip-on nozzle attachment for the M240A1 incinerator unit was specifically designed to allow marines to launch fireballs into enemy foxholes and bunkers. Despite the gel and resin coating, the flaming ball of naptha tears apart due the drag caused by launching it through the air, leading marines to use the attachment as a makeshift firework launcher during shore leave."
	icon_state = "flamer_nozzle"
	attach_icon = "flamer_nozzle_a_1"
	w_class = SIZE_MEDIUM
	slot = "under"
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_WEAPON|ATTACH_MELEE|ATTACH_IGNORE_EMPTY
	pixel_shift_x = 4
	pixel_shift_y = 14

	max_range = 6
	last_fired = 0
	attachment_firing_delay = 2 SECONDS

	var/projectile_type = /datum/ammo/flamethrower
	var/fuel_per_projectile = 3

	var/static/list/fire_sounds = list(
		'sound/weapons/gun_flamethrower1.ogg',
		'sound/weapons/gun_flamethrower2.ogg',
		'sound/weapons/gun_flamethrower3.ogg'
	)

/obj/item/attachable/attached_gun/flamer_nozzle/handle_attachment_description(slot)
	return "It has a [icon2html(src)] [name] mounted beneath the barrel.<br>"

/obj/item/attachable/attached_gun/flamer_nozzle/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	. = ..()
	attach_icon = "flamer_nozzle_a_[G.active_attachable == src ? 0 : 1]"
	G.update_icon()

/obj/item/attachable/attached_gun/flamer_nozzle/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	. = ..()

	if(world.time < gun.last_fired + gun.get_fire_delay())
		return

	if((gun.flags_gun_features & GUN_WIELDED_FIRING_ONLY) && !(gun.flags_item & WIELDED))
		to_chat(user, SPAN_WARNING("You must wield [gun] to fire [src]!"))
		return

	if(gun.flags_gun_features & GUN_TRIGGER_SAFETY)
		to_chat(user, SPAN_WARNING("\The [gun] isn't lit!"))
		return

	if(!istype(gun.current_mag, /obj/item/ammo_magazine/flamer_tank))
		to_chat(user, SPAN_WARNING("\The [gun] needs a flamer tank installed!"))
		return

	if(!length(gun.current_mag.reagents.reagent_list))
		to_chat(user, SPAN_WARNING("\The [gun] doesn't have enough fuel to launch a projectile!"))
		return

	var/datum/reagent/flamer_reagent = gun.current_mag.reagents.reagent_list[1]
	if(flamer_reagent.volume < FLAME_REAGENT_USE_AMOUNT * fuel_per_projectile)
		to_chat(user, SPAN_WARNING("\The [gun] doesn't have enough fuel to launch a projectile!"))
		return

	if(istype(flamer_reagent, /datum/reagent/foaming_agent/stabilized))
		to_chat(user, SPAN_WARNING("This chemical will clog the nozzle!"))
		return

	if(istype(gun.current_mag, /obj/item/ammo_magazine/flamer_tank/smoke)) // you can't fire smoke like a projectile!
		to_chat(user, SPAN_WARNING("[src] can't be used with this fuel tank!"))
		return

	gun.last_fired = world.time
	gun.current_mag.reagents.remove_reagent(flamer_reagent.id, FLAME_REAGENT_USE_AMOUNT * fuel_per_projectile)

	var/obj/projectile/P = new(src, create_cause_data(initial(name), user, src))
	var/datum/ammo/flamethrower/ammo_datum = new projectile_type
	ammo_datum.flamer_reagent_id = flamer_reagent.id
	P.generate_bullet(ammo_datum)
	P.icon_state = "naptha_ball"
	P.color = flamer_reagent.burncolor
	P.hit_effect_color = flamer_reagent.burncolor
	P.fire_at(target, user, user, max_range, AMMO_SPEED_TIER_2, null)
	var/turf/user_turf = get_turf(user)
	playsound(user_turf, pick(fire_sounds), 50, TRUE)

	to_chat(user, SPAN_WARNING("The gauge reads: <b>[floor(gun.current_mag.get_ammo_percent())]</b>% fuel remaining!"))
