/obj/effect/alien/resin/moba_hive_core
	name = XENO_STRUCTURE_CORE
	desc = "A giant pulsating mound of mass. This looks important."
	icon_state = "core"
	icon = 'icons/mob/xenos/structures64x64.dmi'
	plane = FLOOR_PLANE
	pixel_x = -16
	pixel_y = -16
	maptext_x = 16
	maptext_y = 50
	health = 4000
	var/hivenumber = XENO_HIVE_MOBA_LEFT
	var/map_id
	var/obj/effect/alien/resin/moba_turret/hive_core/linked_turret

/obj/effect/alien/resin/moba_hive_core/Initialize(mapload, mob/builder)
	. = ..()
	set_hive_data(src, hivenumber)
	var/obj/effect/landmark/moba_hive_core_turret/turret_marker = locate() in range(5, src)
	if(turret_marker)
		linked_turret = new(get_turf(turret_marker))
		linked_turret.hivenumber = hivenumber
		set_hive_data(linked_turret, linked_turret.hivenumber)
	healthcheck()
	if(!(locate(/obj/effect/moba_reuse_object_spawner) in get_turf(src)))
		new /obj/effect/moba_reuse_object_spawner(get_turf(src), type)

/obj/effect/alien/resin/moba_hive_core/Destroy()
	linked_turret = null
	return ..()

/obj/effect/alien/resin/moba_hive_core/attack_alien(mob/living/carbon/xenomorph/M)
	if((M.a_intent == INTENT_HELP) || (M.hive.hivenumber == hivenumber))
		return XENO_NO_DELAY_ACTION
	else if(linked_turret && !QDELETED(linked_turret))
		to_chat(M, SPAN_XENOWARNING("We can't attack [src] while its acid pillar is still functional."))
		return XENO_NO_DELAY_ACTION
	else
		M.animation_attack_on(src)
		M.visible_message(SPAN_XENONOTICE("[M] claws [src]!"),
		SPAN_XENONOTICE("We claw [src]."))
		playsound(loc, "alien_resin_break", 25)

		health -= M.melee_damage_upper
		healthcheck()
		return XENO_ATTACK_ACTION

/obj/effect/alien/resin/moba_hive_core/bullet_act(obj/projectile/Proj)
	visible_message(SPAN_XENOWARNING("[src] deflects the [Proj]!"))
	return // Can only be meleed

/obj/effect/alien/resin/moba_hive_core/deconstruct(disassembled)
	. = ..()
	SSmoba.get_moba_controller(map_id).end_game(hivenumber)

/obj/effect/alien/resin/moba_hive_core/healthcheck()
	. = ..()
	maptext = MAPTEXT("<center><h2>[floor(health / initial(health) * 100)]%</h2></center>")

/obj/effect/alien/resin/moba_hive_core/right
	hivenumber = XENO_HIVE_MOBA_RIGHT
