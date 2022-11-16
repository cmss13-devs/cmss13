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
	cooldown = 10
	accuracy = 0.9
	firing_arc = 120
	var/burst_amount = 3
	//FPWs reload automatically
	var/reloading = FALSE
	var/reload_time = 10 SECONDS
	var/reload_time_started = 0

	use_muzzle_flash = TRUE

	allowed_seat = VEHICLE_SUPPORT_GUNNER_ONE

	origins = list(0, 0)

	ammo = new /obj/item/ammo_magazine/hardpoint/firing_port_weapon
	max_clips = 1

	underlayer_north_muzzleflash = TRUE

/obj/item/hardpoint/special/firing_port_weapon/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/special/firing_port_weapon/get_hardpoint_info()
	var/dat = "<hr>"
	dat += "[name]<br>"
	if(ammo)
		dat += "Ammo: [ammo ? (ammo.current_rounds ? ammo.current_rounds : "<font color=\"red\">0</font>") : "<font color=\"red\">0</font>"]/[ammo ? ammo.max_rounds : "<font color=\"red\">0</font>"]"
	return dat

/obj/item/hardpoint/special/firing_port_weapon/can_activate(var/mob/user, var/atom/A)
	if(!owner)
		return FALSE

	var/seat = owner.get_mob_seat(user)
	if(!seat)
		return FALSE

	if(seat != allowed_seat)
		to_chat(user, SPAN_WARNING("<b>Only [allowed_seat] can use [name].</b>"))
		return FALSE

	//FPW stop working at 50% hull
	if(owner.health < initial(owner.health) * 0.5)
		to_chat(user, SPAN_WARNING("<b>\The [owner]'s hull is too damaged!</b>"))
		return FALSE

	if(world.time < next_use)
		if(cooldown >= 20)	//filter out guns with high firerate to prevent message spam.
			to_chat(user, SPAN_WARNING("You need to wait [SPAN_HELPFUL((next_use - world.time) / 10)] seconds before [name] can be used again."))
		return FALSE

	if(reloading)
		to_chat(user, SPAN_NOTICE("\The [name] is reloading. Wait [SPAN_HELPFUL("[((reload_time_started + reload_time - world.time) / 10)]")] seconds."))
		return FALSE

	if(ammo && ammo.current_rounds <= 0)
		if(reloading)
			to_chat(user, SPAN_WARNING("<b>\The [name] is out of ammo! You have to wait [(reload_time_started + reload_time - world.time) / 10] seconds before it reloads!"))
		else
			start_auto_reload(user)
		return FALSE

	if(!in_firing_arc(A))
		to_chat(user, SPAN_WARNING("<b>The target is not within your firing arc!</b>"))
		return FALSE

	return TRUE

/obj/item/hardpoint/special/firing_port_weapon/get_examine_text(mob/user, var/integrity_only = FALSE)
	return list()

/obj/item/hardpoint/special/firing_port_weapon/reload(var/mob/user)
	if(!ammo)
		ammo = new /obj/item/ammo_magazine/hardpoint/firing_port_weapon
	else
		ammo.current_rounds = ammo.max_rounds
	reloading = FALSE

	playsound(owner, 'sound/items/m56dauto_setup.ogg', 50, TRUE)

	if(user && owner.get_mob_seat(user))
		to_chat(user, SPAN_WARNING("\The [name]'s automated reload is finished. Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b>"))

/obj/item/hardpoint/special/firing_port_weapon/proc/start_auto_reload(var/mob/user)
	if(reloading)
		to_chat(user, SPAN_WARNING("\The [name] is already being reloaded. Wait [SPAN_HELPFUL("[((reload_time_started + reload_time - world.time) / 10)]")] seconds."))
		return
	if(user)
		to_chat(user, SPAN_WARNING("\The [name] is out of ammunition! Wait [reload_time / 10] seconds for automatic reload to finish."))
	reloading = TRUE
	reload_time_started = world.time
	addtimer(CALLBACK(src, .proc/reload, user), reload_time)

//try adding magazine to hardpoint's backup clips. Called via weapons loader
/obj/item/hardpoint/special/firing_port_weapon/try_add_clip(var/obj/item/ammo_magazine/A, var/mob/user)
	to_chat(user, SPAN_NOTICE("\The [name] reloads automatically."))
	return FALSE


/obj/item/hardpoint/special/firing_port_weapon/fire(var/mob/user, var/atom/A)
	if(user.get_active_hand())
		to_chat(user, SPAN_WARNING("You need a free hand to use \the [name]."))
		return

	if(ammo.current_rounds <= 0)
		start_auto_reload(user)
		return

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]

	for(var/bullets_fired = 1, bullets_fired <= burst_amount, bullets_fired++)
		var/atom/T = A
		if(!prob((accuracy * 100) / owner.misc_multipliers["accuracy"]))
			T = get_step(get_turf(A), pick(cardinal))
		if(LAZYLEN(activation_sounds))
			playsound(get_turf(src), pick(activation_sounds), 60, 1)
		fire_projectile(user, T)
		if(ammo.current_rounds <= 0)
			break
		if(bullets_fired < burst_amount)	//we need to sleep only if there are more bullets to shoot in the burst
			sleep(3)
	to_chat(user, SPAN_WARNING("[src] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b>"))
