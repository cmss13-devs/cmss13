/obj/structure/prop/tyrargo/boards
	name = "boards"
	desc = "Salvaged wooden boards."
	icon = 'icons/obj/structures/props/tyrargo_props.dmi'
	icon_state = "boards"
	density = FALSE
	anchored = TRUE
	unslashable = FALSE
	health = 100
//	layer = BELOW_MOB_LAYER
	layer = XENO_HIDING_LAYER

/obj/structure/prop/tyrargo/boards/boards_1
	icon_state = "boards_2"
/obj/structure/prop/tyrargo/boards/boards_2
	icon_state = "boards_3"

/obj/structure/prop/tyrargo/boards/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/woodhit.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/tyrargo/boards/proc/explode()
	visible_message(SPAN_DANGER("[src] crumbles!"), max_distance = 1)
	playsound(loc, 'sound/effects/woodhit.ogg', 25)

	deconstruct(FALSE)

/obj/structure/prop/tyrargo/boards/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/tyrargo/boards/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/tyrargo/boards/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

// tents

/obj/structure/prop/tyrargo/large_tents

	icon = 'icons/obj/structures/props/large_tent_props.dmi'
	icon_state = "medical_tent"
	unacidable = TRUE
	unslashable = TRUE
	explo_proof = TRUE
	health = 1000000

/obj/structure/prop/tyrargo/large_tents/medical
	icon_state = "medical_tent"
/obj/structure/prop/tyrargo/large_tents/command
	icon_state = "command_tent"
/obj/structure/prop/tyrargo/large_tents/supply
	icon_state = "supply_tent"
/obj/structure/prop/tyrargo/large_tents/small
	icon_state = "small_tent"
/obj/structure/prop/tyrargo/large_tents/small_closed
	icon_state = "small_closed_tent"
/obj/structure/prop/tyrargo/large_tents/small_closed/back
	icon_state = "small_closed_tent_back"

/obj/structure/prop/tyrargo/illuminator
	icon = 'icons/obj/structures/props/industrial/illuminator.dmi'
	icon_state = "floodlight-off"
	health = 300
	density = TRUE
	layer = ABOVE_FLY_LAYER
	bound_height = 32
