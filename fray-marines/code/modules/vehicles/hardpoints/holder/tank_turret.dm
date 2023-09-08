/obj/item/hardpoint/holder/tank_turret/flares
	name = "M34A2-B Multipurpose Turret"
	desc = "The centerpiece of the tank. Designed to support quick installation and deinstallation of various tank weapon modules. Has inbuilt flare deployment system."

	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	cooldown = 30
	accuracy = 0.7
	firing_arc = 120

	ammo = new /obj/item/ammo_magazine/hardpoint/flare_launcher
	max_clips = 3

/obj/item/hardpoint/holder/tank_turret/flares/fire(mob/user, atom/A)
	if(!ammo) //Prevents a runtime
		return
	if(ammo.current_rounds <= 0)
		return

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]
	if(!prob((accuracy * 100) / owner.misc_multipliers["accuracy"]))
		A = get_step(get_turf(A), pick(cardinal))

	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)

	fire_projectile(user, A)

	to_chat(user, SPAN_WARNING("[name] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))

/obj/item/hardpoint/holder/tank_turret/flares/fire_projectile(mob/user, atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)
	origin_turf = get_step(get_step(origin_turf, dir), dir)

	var/obj/item/projectile/P = generate_bullet(user, origin_turf)
	SEND_SIGNAL(P, COMSIG_BULLET_USER_EFFECTS, user)
	P.fire_at(A, user, src, get_dist(origin_turf, A) + 1, P.ammo.shell_speed)
	ammo.current_rounds--

/obj/item/ammo_magazine/hardpoint/flare_launcher/tank
	name = "M34A2-B Flare Launcher Magazine"
	gun_type = /obj/item/hardpoint/holder/tank_turret/flares
