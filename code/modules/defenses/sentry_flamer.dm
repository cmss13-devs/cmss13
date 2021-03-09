/obj/structure/machinery/defenses/sentry/flamer
	name = "\improper UA 42-F sentry flamer"
	icon = 'icons/obj/structures/machinery/defenses/flamer.dmi'
	desc = "A deployable, semi-automated turret with AI targeting capabilities. Armed with an special flamer and a 100 liters fuel tank."
	fire_delay = 30
	ammo = new /obj/item/ammo_magazine/sentry_flamer
	sentry_type = "flamer"
	handheld_type = /obj/item/defenses/handheld/sentry/flamer

/obj/structure/machinery/defenses/sentry/flamer/Initialize()
	. = ..()

/obj/structure/machinery/defenses/sentry/flamer/actual_fire(var/atom/A)
	var/obj/item/projectile/P = new(initial(name), owner_mob)
	P.generate_bullet(new ammo.default_ammo)
	GIVE_BULLET_TRAIT(P, /datum/element/bullet_trait_iff, faction_group)
	P.fire_at(A, src, owner_mob, P.ammo.max_range, P.ammo.shell_speed, null, FALSE)
	ammo.current_rounds--
	if(ammo.current_rounds == 0)
		visible_message("[icon2html(src, viewers(src))] <span class='warning'>The [name] beeps steadily and its ammo light blinks red.</span>")
		playsound(loc, 'sound/weapons/smg_empty_alarm.ogg', 25, 1)

/obj/structure/machinery/defenses/sentry/flamer/destroyed_action()
	visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("The [name] starts spitting out sparks and smoke!")]")
	playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)
	for(var/i = 1 to 6)
		setDir(pick(NORTH, EAST, SOUTH, WEST))
		sleep(2)

	if(ammo.current_rounds != 0)
		var/datum/reagent/napalm/blue/R = new()
		new /obj/flamer_fire(loc, "sentry explosion", null, R, 2)
	cell_explosion(loc, 10, 10, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, "sentry explosion")
	if(!QDELETED(src))
		qdel(src)


/obj/structure/machinery/defenses/sentry/flamer/mini
	name = "UA 45-FM Mini Sentry"
	defense_type = "Mini"
	fire_delay = 10
	ammo = new /obj/item/ammo_magazine/sentry_flamer/mini
	handheld_type = /obj/item/defenses/handheld/sentry/flamer/mini


/obj/structure/machinery/defenses/sentry/flamer/mini/destroyed_action()
	visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("The [name] starts spitting out sparks and smoke!")]")
	playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)

	cell_explosion(loc, 10, 10, null, "sentry explosion")
	if(!QDELETED(src))
		qdel(src)

#define FLAMER_SENTRY_SNIPER_RANGE 14
/obj/structure/machinery/defenses/sentry/flamer/plasma
	name = "UA 60-FP Plasma Sentry"
	defense_type = "Plasma"
	ammo = new /obj/item/ammo_magazine/sentry_flamer/glob
	fire_delay = 10 SECONDS
	sentry_range = FLAMER_SENTRY_SNIPER_RANGE
	handheld_type = /obj/item/defenses/handheld/sentry/flamer/plasma

/obj/structure/machinery/defenses/sentry/flamer/plasma/set_range()
	switch(dir)
		if(EAST)
			range_bounds = RECT(x + (FLAMER_SENTRY_SNIPER_RANGE/2), y, FLAMER_SENTRY_SNIPER_RANGE, FLAMER_SENTRY_SNIPER_RANGE)
		if(WEST)
			range_bounds = RECT(x - (FLAMER_SENTRY_SNIPER_RANGE/2), y, FLAMER_SENTRY_SNIPER_RANGE, FLAMER_SENTRY_SNIPER_RANGE)
		if(NORTH)
			range_bounds = RECT(x, y + (FLAMER_SENTRY_SNIPER_RANGE/2), FLAMER_SENTRY_SNIPER_RANGE, FLAMER_SENTRY_SNIPER_RANGE)
		if(SOUTH)
			range_bounds = RECT(x, y - (FLAMER_SENTRY_SNIPER_RANGE/2), FLAMER_SENTRY_SNIPER_RANGE, FLAMER_SENTRY_SNIPER_RANGE)

#undef FLAMER_SENTRY_SNIPER_RANGE
/obj/structure/machinery/defenses/sentry/flamer/assault
	name = "UA 55-FA Flamer Assault Sentry"
	defense_type = "Assault"
	ammo = new /obj/item/ammo_magazine/sentry_flamer/assault
	handheld_type = /obj/item/defenses/handheld/sentry/flamer/assault
