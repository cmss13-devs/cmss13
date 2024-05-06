//this is Cupola guns that are fired from the sides of APC by support gunners
/obj/item/hardpoint/special/firing_port_weapon
	name = "M56 FPW"
	desc = "A modified M56B Smartgun installed on the sides of M577 Armored Personnel Carrier as a Firing Port Weapon. Used by support gunners to cover friendly infantry at APC sides."

	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'
	icon_state = "m56_FPW"
	disp_icon = "apc"
	disp_icon_state = ""
	activation_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg', 'sound/weapons/gun_smartgun4.ogg')

	health = 100
	firing_arc = 120
	//FPWs reload automatically
	var/reloading = FALSE
	var/reload_time = 10 SECONDS
	var/reload_time_started = 0

	use_muzzle_flash = TRUE

	allowed_seat = VEHICLE_SUPPORT_GUNNER_ONE

	ammo = new /obj/item/ammo_magazine/hardpoint/firing_port_weapon
	max_clips = 1

	underlayer_north_muzzleflash = TRUE

	scatter = 3
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.3 SECONDS

/obj/item/hardpoint/special/firing_port_weapon/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))


//for le tgui
/obj/item/hardpoint/special/firing_port_weapon/get_tgui_info()
	var/list/data = list()

	data["name"] = name
	data["uses_ammo"] = TRUE
	data["current_rounds"] = ammo.current_rounds
	data["max_rounds"] = ammo.max_rounds
	data["fpw"] = TRUE

	return data

/obj/item/hardpoint/special/firing_port_weapon/reload(mob/user)
	if(!ammo)
		ammo = new /obj/item/ammo_magazine/hardpoint/firing_port_weapon
	else
		ammo.current_rounds = ammo.max_rounds
	reloading = FALSE

	playsound(owner, 'sound/items/m56dauto_setup.ogg', 50, TRUE)

	if(user && owner.get_mob_seat(user))
		to_chat(user, SPAN_WARNING("\The [name]'s automated reload is finished. Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b>"))

/obj/item/hardpoint/special/firing_port_weapon/proc/start_auto_reload(mob/user)
	if(reloading)
		to_chat(user, SPAN_WARNING("\The [name] is already being reloaded. Wait [SPAN_HELPFUL("[((reload_time_started + reload_time - world.time) / 10)]")] seconds."))
		return
	if(user)
		to_chat(user, SPAN_WARNING("\The [name] is out of ammunition! Wait [reload_time / 10] seconds for automatic reload to finish."))
	reloading = TRUE
	reload_time_started = world.time
	addtimer(CALLBACK(src, PROC_REF(reload), user), reload_time)

//try adding magazine to hardpoint's backup clips. Called via weapons loader
/obj/item/hardpoint/special/firing_port_weapon/try_add_clip(obj/item/ammo_magazine/A, mob/user)
	to_chat(user, SPAN_NOTICE("\The [name] reloads automatically."))
	return FALSE

/obj/item/hardpoint/special/firing_port_weapon/try_fire(atom/target, mob/living/user, params)
	if(!owner)
		return NONE

	//FPW stop working at 50% hull
	if(owner.health < initial(owner.health) * 0.5)
		to_chat(user, SPAN_WARNING("<b>\The [owner]'s hull is too damaged!</b>"))
		return NONE

	if(user.get_active_hand())
		to_chat(user, SPAN_WARNING("You need a free hand to use \the [name]."))
		return NONE

	if(reloading)
		to_chat(user, SPAN_NOTICE("\The [name] is reloading. Wait [SPAN_HELPFUL("[((reload_time_started + reload_time - world.time) / 10)]")] seconds."))
		return NONE

	if(ammo && ammo.current_rounds <= 0)
		if(reloading)
			to_chat(user, SPAN_WARNING("<b>\The [name] is out of ammo! You have to wait [(reload_time_started + reload_time - world.time) / 10] seconds before it reloads!"))
		else
			start_auto_reload(user)
		return NONE

	if(!in_firing_arc(target))
		to_chat(user, SPAN_WARNING("<b>The target is not within your firing arc!</b>"))
		return NONE

	return handle_fire(target, user, params)
