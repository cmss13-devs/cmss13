/datum/effects/water
	effect_name = "water"
	duration = 20
	icon_path = 'icons/mob/humans/onmob/water.dmi'
	obj_icon_state_path = "+water"
	mob_icon_state_path = "water"
	flags = INF_DURATION

/datum/effects/water/New(var/atom/A)
	..(A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.update_effects()

/datum/effects/water/Destroy()
	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/H = affected_atom
		H.update_effects()

	return ..()

/datum/effects/water/process()
	. = ..()
	STOP_PROCESSING(SSeffects, src)
