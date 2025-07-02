/datum/action/xeno_action/onclick/plant_weeds/lesser/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/lesser_drone/xeno = owner
	var/obj/effect/alien/weeds/node/mother_node

	for(var/obj/effect/alien/weeds/node/node_to_check in orange(4, owner))
		if(node_to_check.hivenumber == xeno.hivenumber)
			mother_node = node_to_check
			break
	if(!mother_node)
		to_chat(xeno, SPAN_XENOWARNING("We can only plant weed nodes near other weed nodes our hive owns!"))
		return

	. = ..()
