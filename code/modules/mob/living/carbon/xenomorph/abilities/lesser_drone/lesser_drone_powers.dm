/datum/action/xeno_action/onclick/plant_weeds/lesser/use_ability(atom/A)
	if(!(locate(/obj/effect/alien/weeds/node) in orange(4, owner)))
		to_chat(owner, SPAN_XENONOTICE("We can only plant weed nodes near other weed nodes!"))
		return

	. = ..()
