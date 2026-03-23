/obj/item/hardpoint/special/vulcan
	name = "M41 'Vulcan' LAAG"
	desc = "The M41 Light Anti-Aircraft Gun is a triple-barrelled belt-fed rotary machinegun, firing 12.7x99mm high-velocity explosive rounds at a blistering pace, making it perfectly suited for close-in anti-aircraft fire. Recoil during sustained fire makes any long range engagements difficult, best to fire in short controlled bursts."
	desc_lore = "The M41 is electrically powered and uses linkless belts fed directly via a reinforced mechanical belt attached to a drum fitted to the weapons mounting point. While intended as a light anti-aircraft option for long patrols and hard points, the .50 calibre gun finds itself most often used against soft targets, like hostile infantry and light armour, where it also excels."

	icon = 'icons/halo/obj/vehicles/hardpoints/warthog.dmi'
	icon_state = "vulcan"
	disp_icon = "warthog"
	disp_icon_state = "vulcan"
	activation_sounds = "gun_hog_chaingun"
	health = 100
	firing_arc = 0

	use_muzzle_flash = TRUE
	muzzleflash_deviance = 0.6

	allowed_seat = VEHICLE_GUNNER

	ammo = new /obj/item/ammo_magazine/hardpoint/vulcan
	max_clips = 1

	// underlayer_north_muzzleflash = FALSE

	scatter = 3
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = FIRE_DELAY_TIER_12

	origins = list(0, 1)

	px_offsets = list(
		"1" = list(0, -19),
		"2" = list(0, 28),
		"4" = list(-24, 6),
		"8" = list(24, 6)
	)
	muzzle_flash_pos = list(
		"1" = list(-16, 16),
		"2" = list(-17, -50),
		"4" = list(28, -12),
		"8" = list(-60, -12)
	)
	use_mz_px_offsets = TRUE

	// Like FPWs, this reloads automatically
	var/reloading = FALSE
	var/reload_time = 5 SECONDS
	var/reload_time_started = 0

/obj/item/hardpoint/special/vulcan/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/special/vulcan/setDir(newdir)
	if(!istype(owner, /obj/vehicle/multitile/warthog))
		return ..()
	if(dir == newdir)
		return
	var/obj/vehicle/multitile/warthog/wort_wort_wort = owner
	var/mob/our_gunner = wort_wort_wort.get_seat_mob(allowed_seat)
	if(our_gunner && our_gunner)
		our_gunner.setDir(newdir)
	. = ..()
	wort_wort_wort.update_icon()

//for le tgui
/obj/item/hardpoint/special/vulcan/get_tgui_info()
	var/list/data = list()

	data["name"] = name
	data["uses_ammo"] = TRUE
	data["current_rounds"] = ammo.current_rounds
	data["max_rounds"] = ammo.max_rounds
	data["fpw"] = FALSE

	return data

/obj/item/hardpoint/special/vulcan/reload(mob/user)
	if(!ammo)
		ammo = new /obj/item/ammo_magazine/hardpoint/vulcan
	else
		ammo.current_rounds = ammo.max_rounds
	reloading = FALSE

	playsound(owner, 'sound/items/m56dauto_setup.ogg', 50, TRUE)

	if(user && owner.get_mob_seat(user))
		to_chat(user, SPAN_WARNING("\The [name]'s automated reload is finished. Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b>"))

/obj/item/hardpoint/special/vulcan/proc/start_auto_reload(mob/user)
	if(reloading)
		to_chat(user, SPAN_WARNING("\The [name] is already being reloaded. Wait [SPAN_HELPFUL("[((reload_time_started + reload_time - world.time) / 10)]")] seconds."))
		return
	if(user)
		to_chat(user, SPAN_WARNING("\The [name] is out of ammunition! Wait [reload_time / 10] seconds for automatic reload to finish."))
	reloading = TRUE
	reload_time_started = world.time
	addtimer(CALLBACK(src, PROC_REF(reload), user), reload_time)

//try adding magazine to hardpoint's backup clips. Called via weapons loader
/obj/item/hardpoint/special/vulcan/try_add_clip(obj/item/ammo_magazine/A, mob/user)
	to_chat(user, SPAN_NOTICE("\The [name] reloads automatically."))
	return FALSE

/obj/item/hardpoint/special/vulcan/try_fire(atom/target, mob/living/user, params)
	if(!owner)
		return NONE

	if(user.get_active_hand() || user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need both hands to use \the [name]."))
		return NONE

	if(reloading)
		to_chat(user, SPAN_NOTICE("\The [name] is reloading. Wait [SPAN_HELPFUL("[((reload_time_started + reload_time - world.time) / 10)]")] seconds."))
		setDir(get_cardinal_dir(get_origin_turf(), target))
		click_empty()
		return NONE

	if(ammo && ammo.current_rounds <= 0)
		if(reloading)
			to_chat(user, SPAN_WARNING("<b>\The [name] is out of ammo! You have to wait [(reload_time_started + reload_time - world.time) / 10] seconds before it reloads!"))
		else
			start_auto_reload(user)
		setDir(get_cardinal_dir(get_origin_turf(), target))
		click_empty()
		return NONE

	return handle_fire(target, user, params)

/obj/item/hardpoint/special/vulcan/handle_fire(atom/target, mob/living/user, params)
	var/turf/origin_turf = get_origin_turf()
	var/dx = (32 * (target.x - origin_turf.x)) - px_offsets["[loc.dir]"][1]
	var/dy = (32 * (target.y - origin_turf.y)) - px_offsets["[loc.dir]"][2]
	setDir(angle2cardinaldir(delta_to_angle(dx, dy)))
	return ..()

/obj/item/hardpoint/special/vulcan/get_icon_image(x_offset, y_offset, new_dir)
	var/is_broken = health <= 0
	var/image/chaingun_low = image(icon = disp_icon, icon_state = "[disp_icon_state]_[is_broken ? "1" : "0"]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)
	var/image/chaingun_high = image(icon = disp_icon, icon_state = "[disp_icon_state]_top_[is_broken ? "1" : "0"]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)
	switch(floor((health / initial(health)) * 100))
		if(0)
			chaingun_low.color = "#888888"
			chaingun_high.color = "#888888"
		if(1 to 20)
			chaingun_low.color = "#4e4e4e"
			chaingun_high.color = "#4e4e4e"
		if(21 to 40)
			chaingun_low.color = "#6e6e6e"
			chaingun_high.color = "#6e6e6e"
		if(41 to 60)
			chaingun_low.color = "#8b8b8b"
			chaingun_high.color = "#8b8b8b"
		if(61 to 80)
			chaingun_low.color = "#bebebe"
			chaingun_high.color = "#bebebe"
		else
			chaingun_low.color = null
			chaingun_high.color = null
	return list(chaingun_low, chaingun_high)

/obj/item/ammo_magazine/hardpoint/vulcan
	name = "M41 'Vulcan' Magazine"
	desc = "A magazine for an M41 'Vulcan'. Supports IFF."
	caliber = "12.7x99mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	icon_state = "cupola_1"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/smartgun/holo_target/wart
	max_rounds = 60
	gun_type = /obj/item/hardpoint/special/vulcan

/obj/item/ammo_magazine/hardpoint/vulcan/update_icon()
	icon_state = "cupola_[current_rounds <= 0 ? "0" : "1"]"

/datum/ammo/bullet/smartgun/holo_target/wart
	name = "12.7x99 bullet"
	damage = 24
	penetration = ARMOR_PENETRATION_TIER_4
	icon_state = "autocannon"
