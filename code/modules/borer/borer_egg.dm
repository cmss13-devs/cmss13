/obj/item/borer_egg
	name = "strange egg"
	desc = "Some sort of tiny egg."
	icon = 'icons/mob/brainslug.dmi'
	icon_state = "borer_egg"
	w_class = SIZE_TINY
	flags_atom = FPRINT|OPENCONTAINER
	flags_item = NOBLUDGEON
	throw_range = 1
	layer = MOB_LAYER
	black_market_value = 35

/obj/item/borer_egg/attack_ghost(mob/dead/observer/user)
	. = ..() //Do a view printout as needed just in case the observer doesn't want to join as a Borer but wants info



/obj/item/borer_egg/proc/join_as_borer(mob/dead/observer/user)
	var/mob/living/carbon/xenomorph/facehugger/hugger = new /mob/living/carbon/xenomorph/facehugger(loc, null, hivenumber)
	user.mind.transfer_to(hugger, TRUE)
	hugger.visible_message(SPAN_XENODANGER("A facehugger suddenly emerges out of \the [A]!"), SPAN_XENODANGER("You emerge out of \the [A] and awaken from your slumber. For the Hive!"))
	playsound(hugger, 'sound/effects/xeno_newlarva.ogg', 25, TRUE)
	hugger.generate_name()
	hugger.timeofdeath = user.timeofdeath // Keep old death time
