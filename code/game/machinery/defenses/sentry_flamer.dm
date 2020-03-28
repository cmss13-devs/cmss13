/obj/structure/machinery/defenses/sentry/flamer
	name = "\improper UA 42-F sentry flamer"
	desc = "A deployable, semi-automated turret with AI targeting capabilities. Armed with an special flamer and a 100 liters fuel tank."
	fire_delay = 30
	ammo = new /obj/item/ammo_magazine/sentry_flamer
	sentry_type = "flamer"

/obj/structure/machinery/defenses/sentry/flamer/actual_fire(var/atom/A)
	var/obj/item/projectile/P = new(initial(name), owner_mob)
	P.generate_bullet(new ammo.default_ammo)
	P.fire_at(A, src, owner_mob, P.ammo.max_range, P.ammo.shell_speed)
	ammo.current_rounds--
	if(ammo.current_rounds == 0)
		visible_message("[htmlicon(src, viewers(src))] <span class='warning'>The [name] beeps steadily and its ammo light blinks red.</span>")
		playsound(loc, 'sound/weapons/smg_empty_alarm.ogg', 25, 1)