/obj/item/device/paddles
	name = "paddles"
	icon = 'core_ru/icons/obj/items/defibs.dmi'
	icon_state = "paddles"

	w_class = SIZE_LARGE

	flags_item = TWOHANDED

	var/obj/item/device/defibrillator/attached_to
	var/datum/effects/tethering/tether_effect

	var/zlevel_transfer = FALSE
	var/zlevel_transfer_timer = TIMER_ID_NULL
	var/zlevel_transfer_timeout = 5 SECONDS
	var/charged = FALSE

	var/wieldsound = null

	var/skill_req = SKILL_MEDICAL_MEDIC
	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
	var/datum/effect_system/spark_spread/sparks = new

/obj/item/device/paddles/Initialize(mapload)
	. = ..()
	if(istype(loc, /obj/item/device/defibrillator))
		attach_to(loc)

	sparks.set_up(5, 0, src)
	sparks.attach(src)

/obj/item/device/paddles/Destroy()
	remove_attached()

	. = ..()

/obj/item/device/paddles/beam(atom/BeamTarget, icon_state="b_beam", icon='icons/effects/beam.dmi', time = BEAM_INFINITE_DURATION, maxdistance = INFINITY, beam_type=/obj/effect/ebeam, always_turn = TRUE)
	. = ..(BeamTarget, icon_state, 'core_ru/icons/effects/beam.dmi', time, maxdistance, beam_type, always_turn)

/obj/item/device/paddles/proc/attach_to(obj/item/device/defibrillator/to_attach)
	if(!istype(to_attach))
		return

	remove_attached()

	attached_to = to_attach
	icon_state = "[icon_state]_[attached_to.icon_state_for_paddles]"

/obj/item/device/paddles/proc/remove_attached()
	if(attached_to)
		attached_to.remove_attached()
		attached_to = null
	reset_tether()

/obj/item/device/paddles/proc/reset_tether()
	SIGNAL_HANDLER
	if(tether_effect)
		UnregisterSignal(tether_effect, COMSIG_PARENT_QDELETING)
		if(!QDESTROYING(tether_effect))
			qdel(tether_effect)
		tether_effect = null
	if(!do_checks())
		on_beam_removed()

/obj/item/device/paddles/proc/on_beam_removed()
	if(!attached_to)
		return

	if(loc == attached_to)
		return

	if(get_dist(attached_to, src) > attached_to.range)
		attached_to.recall_paddles()

	var/atom/tether_to = src

	if(loc != get_turf(src))
		tether_to = loc
		if(tether_to.loc != get_turf(tether_to))
			attached_to.recall_paddles()
			return

	var/atom/tether_from = attached_to

	if(attached_to.tether_holder)
		tether_from = attached_to.tether_holder

	if(tether_from == tether_to)
		return

	var/list/tether_effects = apply_tether(tether_from, tether_to, range = attached_to.range, icon = "paddles_wire", always_face = FALSE)
	tether_effect = tether_effects["tetherer_tether"]
	RegisterSignal(tether_effect, COMSIG_PARENT_QDELETING, PROC_REF(reset_tether))

/obj/item/device/paddles/attack_self(mob/user)
	..()

	if(flags_item & WIELDED)
		unwield(user)
	else
		wield(user)

/obj/item/device/paddles/attack(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(user.action_busy)
		return

	if(user.skills)
		if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return

	if(!charged)
		to_chat(user, SPAN_WARNING("You need charge [src]..."))
		return

	if(!(flags_item & WIELDED))
		to_chat(user, SPAN_WARNING("You need wield [src]..."))
		return

	if(attached_to.defib_mode == FULL_MODE_DEF)
		to_chat(user, SPAN_WARNING("Warning! Shock voltage over 3000V! Cardiac damage is likely!"))

	if(!attached_to.check_revive(H, user))
		return

	var/mob/dead/observer/G = H.get_ghost()
	if(istype(G) && G.client)
		playsound_client(G.client, 'sound/effects/adminhelp_new.ogg')
		to_chat(G, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("Someone is trying to revive your body. Return to it if you want to be resurrected! \
			(Verbs -> Ghost -> Re-enter corpse, or <a href='?src=\ref[G];reentercorpse=1'>click here!</a>)")))

	user.visible_message(SPAN_NOTICE("[user] starts setting up the paddles on [H]'s chest"), \
		SPAN_HELPFUL("You start <b>setting up</b> the paddles on <b>[H]</b>'s chest."))

	//Taking square root not to make defibs too fast...
	overlays += image(icon, "+paddle_zap")
	if(!do_after(user, 1 SECONDS * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, H, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		user.visible_message(SPAN_WARNING("[user] stops setting up the paddles on [H]'s chest"), \
		SPAN_WARNING("You stop setting up the paddles on [H]'s chest"))
		update_icon()
		attached_to.update_icon()
		return

	if(!attached_to.check_revive(H, user))
		update_icon()
		attached_to.update_icon()
		return

	//Do this now, order doesn't matter
	sparks.start()
	attached_to.sparks.start()
	attached_to.dcell.use(attached_to.charge_cost)
	charged = FALSE
	playsound(get_turf(src), 'sound/items/defib_release.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] shocks [H] with the paddles."),
		SPAN_HELPFUL("You shock <b>[H]</b> with the paddles."))
	H.visible_message(SPAN_DANGER("[H]'s body convulses a bit."))
	update_icon()
	attached_to.update_icon()

	var/datum/internal_organ/heart/heart = H.internal_organs_by_name["heart"]
	if(heart && prob(PROB_DMGHEART))
		heart.damage += rand(attached_to.heart_damage_to_deal_lower, attached_to.heart_damage_to_deal_upper) //Allow the defibrilator to possibly worsen heart damage. Still rare enough to just be the "clone damage" of the defib

	if(!H.is_revivable())
		playsound(get_turf(src), 'sound/items/defib_failed.ogg', 25, 0)
		if(heart && heart.organ_status >= ORGAN_BROKEN)
			user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Patient's heart is too damaged. Immediate surgery is advised."))
			return
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Patient's general condition does not allow reviving."))
		return

	if(!H.client) //Freak case, no client at all. This is a braindead mob (like a colonist)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: No soul detected, Attempting to revive..."))

	if(isobserver(H.mind?.current) && !H.client) //Let's call up the correct ghost! Also, bodies with clients only, thank you.
		H.mind.transfer_to(H, TRUE)

	//At this point, the defibrillator is ready to work
	H.apply_damage(-attached_to.damage_heal_threshold, BRUTE)
	H.apply_damage(-attached_to.damage_heal_threshold, BURN)
	H.apply_damage(-attached_to.damage_heal_threshold, TOX)
	H.apply_damage(-attached_to.damage_heal_threshold, CLONE)
	H.apply_damage(-H.getOxyLoss(), OXY)
//	user.track_heal_damage(initial(attached_to.name), H, attached_to.damage_heal_threshold * 3)
	H.updatehealth() //Needed for the check to register properly

	if(!(H.species?.flags & NO_CHEM_METABOLIZATION))
		for(var/datum/reagent/R in H.reagents.reagent_list)
			var/datum/chem_property/P = R.get_property(PROPERTY_ELECTROGENETIC)//Adrenaline helps greatly at restarting the heart
			if(P)
				P.trigger(H)
				H.reagents.remove_reagent(R.id, 1)
				break
	if(H.health > HEALTH_THRESHOLD_DEAD && attached_to.try_to_revive(H, user))
		user.visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] \The [src] beeps: Defibrillation successful."))
		playsound(get_turf(src), 'sound/items/defib_success.ogg', 25, 0)
		user.track_life_saved()
		if(attached_to.defib_mode == FULL_MODE_DEF)
			H.electrocute_act(120, src)//god damn Doktor...
			H.apply_damage(FULL_MODE_TOXIN_DMG, TOX)
			to_chat(H, SPAN_NOTICE("You got shocked!"))
		H.handle_revive()
		to_chat(H, SPAN_NOTICE("You suddenly feel a spark and your consciousness returns, dragging you back to the mortal plane."))
		if(H.client?.prefs.toggles_flashing & FLASH_CORPSEREVIVE)
			window_flash(H.client)
	else
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Vital signs are too weak, repair damage and try again.")) //Freak case
		playsound(get_turf(src), 'sound/items/defib_failed.ogg', 25, 0)
		H.electrocute_act(40, src)

/obj/item/device/paddles/on_enter_storage(obj/item/storage/storage)
	. = ..()
	if(attached_to)
		attached_to.recall_paddles()

/obj/item/device/paddles/equipped(mob/user, slot, silent)
	..()
	if(get_dist(attached_to, user) > attached_to.range)
		unwield(user)
		user.drop_held_item(src)
		attached_to.recall_paddles()
		return

/obj/item/device/paddles/forceMove(atom/dest)
	. = ..()
	if(.)
		if(ismob(loc))
			var/mob/M = loc
			unwield(M)
		reset_tether()

/obj/item/device/paddles/proc/do_checks()
	if(!attached_to || !loc.z || !attached_to.z)
		return FALSE

	if(get_dist(attached_to, src) > attached_to.range)
		return FALSE

	if(zlevel_transfer)
		if(loc.z == attached_to.z)
			zlevel_transfer = FALSE
			if(zlevel_transfer_timer)
				deltimer(zlevel_transfer_timer)
			UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
			return FALSE
		return TRUE

	if(attached_to && loc.z != attached_to.z)
		zlevel_transfer = TRUE
		zlevel_transfer_timer = addtimer(CALLBACK(src, PROC_REF(try_doing_tether)), zlevel_transfer_timeout, TIMER_UNIQUE|TIMER_STOPPABLE)
		RegisterSignal(attached_to, COMSIG_MOVABLE_MOVED, PROC_REF(paddles_move_handler))
		return TRUE
	return FALSE

/obj/item/device/paddles/proc/paddles_move_handler(datum/source)
	SIGNAL_HANDLER
	zlevel_transfer = FALSE
	if(zlevel_transfer_timer)
		deltimer(zlevel_transfer_timer)
	UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
	reset_tether()

/obj/item/device/paddles/proc/try_doing_tether()
	zlevel_transfer_timer = TIMER_ID_NULL
	zlevel_transfer = FALSE
	UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
	reset_tether()

/obj/item/device/paddles/clicked(mob/user, list/mods)
	if(!ishuman(usr))
		return
	if(mods["alt"])
		paddles_charge(user)
		return 1
	return ..()

/obj/item/device/paddles/proc/paddles_charge(mob/user)
	if(!skillcheck(user, SKILL_MEDICAL, skill_req))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return
	if(user.action_busy)
		return

	if(!(flags_item & WIELDED))
		to_chat(user, SPAN_WARNING("You need wield [src]..."))
		return

	if(charged)
		to_chat(user, SPAN_NOTICE("You already charged it."))
		return
	else
		user.visible_message(SPAN_NOTICE("[user] starts charging the paddles"), \
		SPAN_HELPFUL("You start <b>charging</b> the paddles."))
		playsound(get_turf(src), "sparks", 30, 2, 5)
		playsound(get_turf(src),'sound/items/defib_charge.ogg', 25, 0) //Do NOT vary this tune, it needs to be precisely 7 seconds
		if(!do_after(user, attached_to.defib_recharge * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, user, INTERRUPT_ALL))
			user.visible_message(SPAN_NOTICE("[user] stop charging the paddles"), \
			SPAN_HELPFUL("You stop <b>charging</b> the paddles."))
			return
		sparks.start()
		attached_to.sparks.start()
		playsound(get_turf(src), "sparks", 25, 1, 4)
		charged = TRUE
		update_icon()
		user.visible_message(SPAN_NOTICE("[user] charges the paddles"), \
		SPAN_HELPFUL("You <b>charge</b> the paddles."))

/obj/item/device/paddles/update_icon()
	update_overlays()

	icon_state = initial(icon_state)

	icon_state = "[icon_state]_[attached_to.icon_state_for_paddles]"
	if(flags_item & WIELDED)
		icon_state += "_paddle"

/obj/item/device/paddles/proc/update_overlays()
	if(overlays)
		overlays.Cut()

/obj/item/device/paddles/place_offhand(obj/item/weapon/twohanded/offhand/offhand)
	. = ..(offhand)
	update_icon()

/obj/item/device/paddles/remove_offhand(mob/user)
	..()
	update_icon()

/obj/item/device/paddles/dropped(mob/user)
	..()
	unwield(user)

#undef LOW_MODE_RECH
#undef HALF_MODE_RECH
#undef FULL_MODE_RECH

#undef LOW_MODE_CHARGE
#undef HALF_MODE_CHARGE
#undef FULL_MODE_CHARGE

#undef LOW_MODE_DMGHEAL
#undef HALF_MODE_DMGHEAL
#undef FULL_MODE_DMGHEAL

#undef LOW_MODE_HEARTD_LOWER
#undef HALF_MODE_HEARTD_LOWER
#undef FULL_MODE_HEARTD_LOWER
#undef LOW_MODE_HEARTD_UPPER
#undef HALF_MODE_HEARTD_UPPER
#undef FULL_MODE_HEARTD_UPPER

#undef FULL_MODE_TOXIN_DMG

#undef LOW_MODE_DEF
#undef HALF_MODE_DEF
#undef FULL_MODE_DEF

#undef PROB_DMGHEART
