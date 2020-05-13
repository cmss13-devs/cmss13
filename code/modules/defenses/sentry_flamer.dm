/obj/structure/machinery/defenses/sentry/flamer
	name = "\improper UA 42-F sentry flamer"
	desc = "A deployable, semi-automated turret with AI targeting capabilities. Armed with an special flamer and a 100 liters fuel tank."
	fire_delay = 30
	ammo = new /obj/item/ammo_magazine/sentry_flamer
	sentry_type = "flamer"
	handheld_type = /obj/item/defenses/handheld/sentry/flamer

/obj/structure/machinery/defenses/sentry/flamer/actual_fire(var/atom/A)
	var/obj/item/projectile/P = new(initial(name), owner_mob)
	P.generate_bullet(new ammo.default_ammo)
	P.fire_at(A, src, owner_mob, P.ammo.max_range, P.ammo.shell_speed)
	ammo.current_rounds--
	if(ammo.current_rounds == 0)
		visible_message("[htmlicon(src, viewers(src))] <span class='warning'>The [name] beeps steadily and its ammo light blinks red.</span>")
		playsound(loc, 'sound/weapons/smg_empty_alarm.ogg', 25, 1)

/obj/structure/machinery/defenses/sentry/flamer/destroyed_action()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_WARNING("The [name] starts spitting out sparks and smoke!")]")
	playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)
	for(var/i = 1 to 6)
		dir = pick(NORTH, EAST, SOUTH, WEST)
		sleep(2)

	if(ammo.current_rounds != 0)
		new /obj/flamer_fire(loc, "sentry explosion", null, 20, 35, "blue", 2)
	cell_explosion(loc, 10, 10, null, "sentry explosion")
	if(!disposed)
		qdel(src)
