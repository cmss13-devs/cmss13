/obj/item/borer_egg
	name = "strange egg"
	desc = "Some sort of tiny egg."
	icon = 'icons/mob/brainslug.dmi'
	icon_state = "borer_egg"
	w_class = SIZE_TINY
	flags_atom = FPRINT|OPENCONTAINER
	flags_item = NOBLUDGEON
	layer = MOB_LAYER
	black_market_value = 35

	var/hatched = FALSE
	var/birth_generation = 1
	var/can_reproduce = 1
	var/target_flags = BORER_TARGET_HUMANS
	var/list/ancestors = list()

/obj/item/borer_egg/Initialize()
	. = ..()
	if (!pixel_x && !pixel_y)
		pixel_x = rand(-6.0, 6) //Randomizes postion
		pixel_y = rand(-6.0, 6)

/obj/item/borer_egg/attack_ghost(mob/dead/observer/user)
	. = ..() //Do a view printout as needed just in case the observer doesn't want to join as a Borer but wants info
	attempt_join_as_borer(user)


/obj/item/borer_egg/proc/attempt_join_as_borer(mob/dead/observer/user)
	if(!istype(user) || hatched)
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
	var/turf/turf_loc = get_turf(src)
	var/mob/living/carbon/cortical_borer/birthed = new /mob/living/carbon/cortical_borer(turf_loc, birth_generation, FALSE, can_reproduce, target_flags, ancestors)

	user.mind.transfer_to(birthed, TRUE)
	birthed.visible_message(SPAN_XENODANGER("A Borer suddenly emerges out of \the [src]!"), SPAN_XENODANGER("You emerge out of \the [src] and awaken from your slumber."))
	qdel(src)

/obj/item/borer_egg/attack_self(mob/living/carbon/user)
	. = ..()
	if(!istype(user))
		return FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(human_user.species.flags & IS_SYNTHETIC)
			return FALSE

	if(hatched)
		to_chat(user, SPAN_WARNING("This egg is hollow! There's nothing in it!"))
		return FALSE

	if(user.has_brain_worms())
		to_chat(user, SPAN_WARNING("Something makes you feel like you don't need to do this..."))
		return FALSE
	if(tgui_alert(user, "Do you wish to eat the egg?", "Eat Egg?", list("Yes", "No")) != "Yes")
		return FALSE
	to_chat(user, SPAN_XENOBOLDNOTICE("You swallow [src] whole!"))
	log_interact(user, "Consumed a Cortical Borer Egg")
	hatch_egg(user)
	return TRUE

/obj/item/borer_egg/attack(mob/living/target, mob/living/user)
	if(target == user)
		attack_self(user)

	else if(istype(target, /mob/living/carbon/human) )
		var/mob/living/carbon/human/human_target = target
		if(human_target.species.flags & IS_SYNTHETIC)
			to_chat(human_target, SPAN_DANGER("They have a monitor for a head, where do you think you're going to put that?"))
			return FALSE
		if(target.has_brain_worms())
			to_chat(user, SPAN_WARNING("Something makes you feel like you don't need to do this..."))
			return FALSE

		user.affected_message(target,
			SPAN_HELPFUL("You <b>start feeding</b> [target] the strange egg."),
			SPAN_HELPFUL("[user] <b>starts feeding</b> you a strange egg."),
			SPAN_NOTICE("[user] starts feeding [target] a strange egg."))

		var/ingestion_time = 30
		if(user.skills)
			ingestion_time = max(10, 30 - 10*user.skills.get_skill_level(SKILL_MEDICAL))

		if(!do_after(user, ingestion_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, target, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return FALSE
		if(QDELETED(src))
			return FALSE

		user.drop_inv_item_on_ground(src) //icon update

		user.affected_message(target,
			SPAN_HELPFUL("You <b>fed</b> [target] a strange egg."),
			SPAN_HELPFUL("[user] <b>fed</b> you a strange egg."),
			SPAN_NOTICE("[user] fed [target] a strange egg."))

		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [key_name(user)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [target.name] to [key_name(target)]</font>")
		msg_admin_attack("[key_name(user)] fed [key_name(target)] a Cortical Borer Egg (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
		hatch_egg(target)

		return TRUE

	return FALSE


/obj/item/borer_egg/proc/hatch_egg(mob/living/carbon/consumer)
	if(!istype(consumer))
		return FALSE
	var/mob/living/carbon/cortical_borer/birthed = new /mob/living/carbon/cortical_borer(consumer, birth_generation, TRUE, can_reproduce, target_flags, ancestors)
	birthed.perform_infestation(consumer)
	qdel(src)
	return TRUE

