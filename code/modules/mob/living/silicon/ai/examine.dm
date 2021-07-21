/mob/living/silicon/ai/examine(mob/user)
	if( (user.sdisabilities & DISABILITY_BLIND || user.blinded || user.stat) && !istype(user,/mob/dead/observer) )
		to_chat(user, SPAN_NOTICE("Something is there but you can't see it."))
		return

	var/msg = "<span class='info'>*---------*\nThis is [icon2html(src)] <EM>[src]</EM>!\n"
	if (src.stat == DEAD)
		msg += "<span class='deadsay'>It appears to be powered-down.</span>\n"
	else
		msg += "<span class='warning'>"
		if (src.getBruteLoss())
			if (src.getBruteLoss() < 30)
				msg += "It looks slightly dented.\n"
			else
				msg += "<B>It looks severely dented!</B>\n"
		if (src.getFireLoss())
			if (src.getFireLoss() < 30)
				msg += "It looks slightly charred.\n"
			else
				msg += "<B>Its casing is melted and heat-warped!</B>\n"

		if (src.stat == UNCONSCIOUS)
			msg += "It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".\n"
		msg += "</span>"
	msg += "*---------*</span>"

	to_chat(user, msg)
