#define HOT_WATER_DAMAGE 1.5
#define HOT_WATER_TEMP_EFFECT 5

/obj/effect/blocker/sorokyne_hot_water
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	unacidable = 1
	layer = ABOVE_FLY_LAYER //to make it visible in the map editor
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/landmarks.dmi'

	icon_state = "map_blocker_hazard"

/obj/effect/blocker/sorokyne_hot_water/Initialize(mapload, ...)
	. = ..()
	invisibility = 101


/obj/effect/blocker/sorokyne_hot_water/Crossed(mob/living/M as mob)

	if(!istype(M))
		return

	if(!istype(M.loc, /turf))
		return

	cause_damage(M)
	START_PROCESSING(SSobj, src)


/obj/effect/blocker/sorokyne_hot_water/process()
	var/mobs_present = 0
	for(var/mob/living/carbon/M in range(0, src))
		mobs_present++
		cause_damage(M)
	if(mobs_present < 1)
		STOP_PROCESSING(SSobj, src)


/obj/effect/blocker/sorokyne_hot_water/proc/cause_damage(mob/living/M)
	if(M.stat == DEAD)
		return
	if(isxeno(M))
		return

	var/dam_amount = HOT_WATER_DAMAGE
	if(issynth(M) || isyautja(M))
		dam_amount -= 0.5
	if(M.body_position == STANDING_UP)
		M.apply_damage(dam_amount,BURN,"l_leg")
		M.apply_damage(dam_amount,BURN,"l_foot")
		M.apply_damage(dam_amount,BURN,"r_leg")
		M.apply_damage(dam_amount,BURN,"r_foot")
	else
		M.apply_damage(2*dam_amount,BURN)

	if (ishuman(M))
		if (M.bodytemperature > T90C)
			M.bodytemperature -= HOT_WATER_TEMP_EFFECT
		else
			M.bodytemperature = T90C
		if(!issynth(M))
			to_chat(M, SPAN_DANGER("You feel your body start to shake as the scalding water sears your skin, heat overwhelming your senses..."))

#undef HOT_WATER_DAMAGE
#undef HOT_WATER_TEMP_EFFECT
