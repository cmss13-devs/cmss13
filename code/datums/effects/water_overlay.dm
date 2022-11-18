/datum/effects/water_overlay
	effect_name = "water"
	duration = 20
	icon_path = 'icons/effects/water_effects.dmi'
	obj_icon_state_path = "+water"
	mob_icon_state_path = "water"
	flags = INF_DURATION
	do_proccess = FALSE

/datum/effects/water_overlay/New(atom/A, turf/open/O)
	..(A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.update_effects()

/datum/effects/water_overlay/Destroy()
	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/H = affected_atom
		H.update_effects()

	return ..()



