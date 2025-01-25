/turf/open/floor/glass
	name = "glass floor"
	desc = "Don't jump on it, or do, I'm not your mom."
	icon = 'icons/turf/floors/glass.dmi'
	icon_state = "glass-0"
	base_icon = "glass-0"
	special_icon = TRUE
	antipierce = 1
	turf_flags = parent_type::turf_flags|TURF_TRANSPARENT
	baseturfs = /turf/open/openspace
	plating_type = null

	breakable_tile = FALSE // platingdmg# icon_state does not exist in this icon
	burnable_tile = FALSE // panelscorched icon_state does not exist in this icon

	var/health = 100

/turf/open/floor/glass/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/glass/LateInitialize()
	. = ..()
	handle_transpare_turf()

//TODO (MULTIZ): IMPROVE IT
/turf/open/floor/glass/make_plating()
	playsound(src, "windowshatter", 50, 1)
	var/turf/below_turf = SSmapping.get_turf_below(src)
	if(below_turf)
		playsound(below_turf, "windowshatter", 50, 1)
		below_turf.visible_message(SPAN_DANGER("Roof above [src] caving in!"), SPAN_DANGER("Roof above [src] caving in!"))
		spawn(1 SECONDS)
			var/obj/item/shard = new /obj/item/shard(below_turf)
			shard.explosion_throw(5, pick(GLOB.cardinals))
			shard = new /obj/item/shard(below_turf)
			shard.explosion_throw(5, pick(GLOB.cardinals))
			shard = new /obj/item/shard(below_turf)
			shard.explosion_throw(5, pick(GLOB.cardinals))
			shard = new /obj/item/stack/rods(below_turf)
			shard.explosion_throw(5, pick(GLOB.cardinals))
			for(var/mob/living/unlucky in below_turf)
				unlucky.adjustBruteLoss(30)
	ScrapeAway()

/turf/open/floor/glass/break_tile()
	make_plating()

/turf/open/floor/glass/on_turf_bullet_pass(obj/projectile/P)
	if(health < P.damage)
		make_plating()
	else
		health -= P.damage
	return

/turf/open/floor/glass/reinforced
	name = "reinforced glass floor"
	desc = "Do jump on it, it can take it."
	icon = 'icons/turf/floors/reinf_glass.dmi'
	icon_state = "reinf_glass-0"
	base_icon = "reinf_glass-0"
	health = 500
