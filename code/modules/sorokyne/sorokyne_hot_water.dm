
/obj/effect/blocker/sorokyne_hot_water
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	unacidable = 1
	layer = ABOVE_FLY_LAYER //to make it visible in the map editor
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/landmarks.dmi'

	icon_state = "map_blocker_hazard"

	var/dam_amount = 0.5
	var/dam_type = BURN
	var/target_temp = T90C
	var/temp_delta = 5

/obj/effect/blocker/sorokyne_hot_water/Initialize(mapload, ...)
	. = ..()
	invisibility = 101

/obj/effect/blocker/sorokyne_hot_water/Crossed(mob/living/affected_mob)
	if(!ismob(affected_mob))
		return
	if(affected_mob.stat == DEAD)
		return
	if(!ishuman(affected_mob))
		return

	affected_mob.AddComponent(/datum/component/damage_over_time, /obj/effect/blocker/sorokyne_hot_water, dam_amount, dam_type, target_temp, temp_delta, synth_dmg_mult=0, pred_dmg_mult=0)

