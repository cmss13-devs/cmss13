
//Basically counts how many times the target was hit by a weak acid spray, to later divide the latter's damage by that amount.

/datum/effects/weak_spray_stack
	effect_name = "weak spray stack"
	duration = 4
	var/hit_count = 1

/datum/effects/weak_spray_stack/validate_atom(atom/A)

	if(!ishuman(A))
		return FALSE

	. = ..()

/datum/effects/weak_spray_stack/Destroy()
	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/hooman = affected_atom
		to_chat(hooman, SPAN_WARNING("You feel the last of the weak acid coating on your legs dissipate."))

	return ..()
