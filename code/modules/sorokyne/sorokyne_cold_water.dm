#define COLD_WATER_DAMAGE 1.5
#define COLD_WATER_TEMP_EFFECT 5
#define MINIMUM_TEMP 170

/obj/effect/blocker/sorokyne_cold_water
	anchored = 1
	density = 0
	opacity = 0
	unacidable = 1
	layer = ABOVE_FLY_LAYER //to make it visible in the map editor
	mouse_opacity = 0
	icon = 'icons/old_stuff/mark.dmi'

	icon_state = null

/obj/effect/blocker/sorokyne_cold_water/Crossed(mob/living/M as mob)

	if(!istype(M))
		return

	if(!istype(M.loc, /turf))
		return

	cause_damage(M)
	START_PROCESSING(SSobj, src)


/obj/effect/blocker/sorokyne_cold_water/process()
	var/mobs_present = 0
	for(var/mob/living/carbon/M in range(0, src))
		mobs_present++
		cause_damage(M)
	if(mobs_present < 1)
		STOP_PROCESSING(SSobj, src)


/obj/effect/blocker/sorokyne_cold_water/proc/cause_damage(mob/living/M)
	if(M.stat == DEAD)
		return
	if(isXeno(M))
		return

	var/dam_amount = COLD_WATER_DAMAGE
	if(isSynth(M) || isYautja(M))
		dam_amount -= 0.5
	if(M.lying)
		M.apply_damage(5*dam_amount,BURN)
	else
		M.apply_damage(dam_amount,BURN,"l_leg")
		M.apply_damage(dam_amount,BURN,"l_foot")
		M.apply_damage(dam_amount,BURN,"r_leg")
		M.apply_damage(dam_amount,BURN,"r_foot")

	if (ishuman(M))
		if (M.bodytemperature > MINIMUM_TEMP)
			M.bodytemperature -= COLD_WATER_TEMP_EFFECT
		else
			M.bodytemperature = MINIMUM_TEMP
		if(!isSynth(M))
			to_chat(M, SPAN_DANGER("You feel your body start to shake as the water chills you to the bone.."))

#undef COLD_WATER_DAMAGE
#undef COLD_WATER_TEMP_EFFECT
#undef MINIMUM_TEMP
