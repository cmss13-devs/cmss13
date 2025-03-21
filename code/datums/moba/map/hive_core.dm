/obj/effect/alien/resin/moba_hive_core
	name = XENO_STRUCTURE_CORE
	desc = "A giant pulsating mound of mass. This looks important."
	icon_state = "left_nexus"
	icon = 'icons/obj/structures/alien/structures96x96.dmi'
	can_block_movement = TRUE
	density = TRUE
	pixel_x = -32
	maptext_x = 16
	maptext_y = 98
	bound_height = 96
	bound_width = 96
	maptext_width = 64
	health = 4000
	layer = ABOVE_XENO_LAYER
	var/hivenumber = XENO_HIVE_MOBA_LEFT
	var/map_id
	var/obj/effect/alien/resin/moba_turret/linked_turret
	var/turret_type = /obj/effect/alien/resin/moba_turret/left/hive_core

/obj/effect/alien/resin/moba_hive_core/Initialize(mapload, mob/builder)
	. = ..()
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	name = "[lowertext(hive.prefix)][name]"
	var/obj/effect/landmark/moba_hive_core_turret/turret_marker = locate() in range(5, src)
	if(turret_marker)
		linked_turret = new turret_type(get_turf(turret_marker))
		linked_turret.hivenumber = hivenumber
		linked_turret.name = "[lowertext(hive.prefix)][linked_turret.name]"
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
		if(HAS_TRAIT(M, TRAIT_MOBA_STRUCTURESHRED))
			health -= MOBA_HIVEBOT_BOON_TRUE_DAMAGE
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
	icon_state = "right_nexus"
	turret_type = /obj/effect/alien/resin/moba_turret/right/hive_core
