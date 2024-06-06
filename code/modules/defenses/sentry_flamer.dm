/obj/structure/machinery/defenses/sentry/flamer
	name = "\improper UA 42-F sentry flamer"
	icon = 'icons/obj/structures/machinery/defenses/flamer.dmi'
	desc = "A deployable, semi-automated turret with AI targeting capabilities. Armed with a special flamer and a 100 liters fuel tank."
	fire_delay = 30
	ammo = new /obj/item/ammo_magazine/sentry_flamer
	sentry_type = "flamer"
	handheld_type = /obj/item/defenses/handheld/sentry/flamer
	health = 200
	health_max = 200

	choice_categories = list(
		// SENTRY_CATEGORY_ROF = list(ROF_SINGLE, ROF_FULL_AUTO),
		SENTRY_CATEGORY_IFF = list(FACTION_MARINE, SENTRY_FACTION_WEYLAND, SENTRY_FACTION_HUMAN),
	)

	selected_categories = list(
		SENTRY_CATEGORY_ROF = ROF_SINGLE,
		SENTRY_CATEGORY_IFF = FACTION_MARINE,
	)

/obj/structure/machinery/defenses/sentry/flamer/handle_rof(level)
	switch(level)
		if(ROF_SINGLE)
			accuracy_mult = 1
			fire_delay = 4
		if(ROF_FULL_AUTO)
			accuracy_mult = 0.1
			fire_delay = 0.5

/obj/structure/machinery/defenses/sentry/flamer/actual_fire(atom/A)
	var/obj/projectile/P = new(create_cause_data(initial(name), owner_mob))
	P.generate_bullet(new ammo.default_ammo)
	GIVE_BULLET_TRAIT(P, /datum/element/bullet_trait_iff, faction_group)
	P.fire_at(A, src, owner_mob, P.ammo.max_range, P.ammo.shell_speed, null)
	ammo.current_rounds--
	track_shot()
	if(ammo.current_rounds == 0)
		visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("The [name] beeps steadily and its ammo light blinks red.")]")
		playsound(loc, 'sound/weapons/smg_empty_alarm.ogg', 25, 1)

/obj/structure/machinery/defenses/sentry/flamer/destroyed_action()
	visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("The [name] starts spitting out sparks and smoke!")]")
	playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)
	for(var/i = 1 to 6)
		setDir(pick(NORTH, EAST, SOUTH, WEST))
		sleep(2)

	if(ammo.current_rounds != 0)
		var/datum/reagent/napalm/blue/R = new()
		new /obj/flamer_fire(loc, create_cause_data("sentry explosion", owner_mob), R, 2)
	cell_explosion(loc, 10, 10, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("sentry explosion", owner_mob))
	if(!QDELETED(src))
		qdel(src)


/obj/structure/machinery/defenses/sentry/flamer/mini
	name = "UA 45-FM Mini Sentry"
	defense_type = "Mini"
	health = 150
	health_max = 150
	density = FALSE
	fire_delay = 1.25 SECONDS
	disassemble_time = 0.75 SECONDS
	ammo = new /obj/item/ammo_magazine/sentry_flamer/mini
	handheld_type = /obj/item/defenses/handheld/sentry/flamer/mini
	composite_icon = FALSE


/obj/structure/machinery/defenses/sentry/flamer/mini/destroyed_action()
	visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("The [name] starts spitting out sparks and smoke!")]")
	playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)

	cell_explosion(loc, 10, 10, null, create_cause_data("sentry explosion", owner_mob))
	if(!QDELETED(src))
		qdel(src)

#define FLAMER_SENTRY_SNIPER_RANGE 10
/obj/structure/machinery/defenses/sentry/flamer/plasma
	name = "UA 60-FP Plasma Sentry"
	defense_type = "Plasma"
	ammo = new /obj/item/ammo_magazine/sentry_flamer/glob
	health = 150
	health_max = 150
	fire_delay = 7 SECONDS
	sentry_range = FLAMER_SENTRY_SNIPER_RANGE
	handheld_type = /obj/item/defenses/handheld/sentry/flamer/plasma
	disassemble_time = 1.5 SECONDS

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
