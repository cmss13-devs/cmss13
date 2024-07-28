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

	var/birth_generation = 1
	var/can_reproduce = 1
	var/target_flags = BORER_TARGET_HUMANS
	var/list/ancestors = list()

/obj/item/borer_egg/attack_ghost(mob/dead/observer/user)
	. = ..() //Do a view printout as needed just in case the observer doesn't want to join as a Borer but wants info
	attempt_join_as_borer(user)


/obj/item/borer_egg/proc/attempt_join_as_borer(mob/dead/observer/user)
	if(!istype(user))
		return FALSE
	if(jobban_isbanned(user, "Syndicate") || jobban_isbanned(user, "Emergency Response Team"))
		to_chat(user, SPAN_DANGER("You are jobbanned from ERTs!"))
		return FALSE

	var/try_join = tgui_alert(user, "Do you want to hatch as a Cortical Borer?", "Join as Borer?", list("Yes", "No"))
	if(try_join != "Yes")
		return FALSE
	if(hatched)
		to_chat(user, SPAN_DANGER("This egg has already hatched!"))
		return FALSE
	join_as_borer(user)


/obj/item/borer_egg/proc/join_as_borer(mob/dead/observer/user)
	if(hatched)
		return FALSE
	hatched = TRUE
	var/mob/living/carbon/cortical_borer/birthed = new /mob/living/carbon/cortical_borer(loc, birth_generation, TRUE, can_reproduce, target_flags, ancestors)

	user.mind.transfer_to(birthed, TRUE)
	birthed.visible_message(SPAN_XENODANGER("A facehugger suddenly emerges out of \the [A]!"), SPAN_XENODANGER("You emerge out of \the [A] and awaken from your slumber. For the Hive!"))
	playsound(birthed, 'sound/effects/xeno_newlarva.ogg', 25, TRUE)
