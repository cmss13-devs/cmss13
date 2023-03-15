//TODO: Convert this over for languages.
/mob/living/brain/say(message)
	if (silent)
		return

	if(stat != DEAD)
		if(!(container && (istype(container, /obj/item/device/mmi) || istype(container, /obj/item/limb/head/synth))))
			return //No MMI or synthetic head, can't speak.

		if(prob(emp_damage*4))
			if(prob(10))//10% chance to drop the message entirely
				return
			else
				message = Gibberish(message, (emp_damage*6))//scrambles the message, gets worse when emp_damage is higher
		if(istype(container, /obj/item/device/mmi/radio_enabled))
			var/obj/item/device/mmi/radio_enabled/R = container
			if(R.radio)
				spawn(0) R.radio.hear_talk(src, sanitize(message))
		..()
	else //dead brains should can always talk in dead chat.
		message =  trim(strip_html(message))
		return say_dead(message)

