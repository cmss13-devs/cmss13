/datum/effects/turf_overlay_effect
	effect_name = "turf_effect_overlay"
	icon_path = 'icons/effects/water_effects.dmi'
	obj_icon_state_path
	mob_icon_state_path
	flags = INF_DURATION
	do_proccess = FALSE

/datum/effects/turf_overlay_effect/New(atom/A, turf/open/O)
	..(A)

	obj_icon_state_path = O.icon_state
	mob_icon_state_path = O.icon_state

	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.update_effects()

/datum/effects/turf_overlay_effect/Destroy()
	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/H = affected_atom
		H.update_effects()

	return ..()

/datum/effects/turf_overlay_effect/proc/update_icons(turf/open/O)
	obj_icon_state_path = O.icon_state
	mob_icon_state_path = O.icon_state

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/H = affected_atom
		H.update_effects()

