/mob/living/carbon/Initialize()
	. = ..()
	hunter_data = new /datum/huntdata
	hunter_data.name = "[src.real_name]'s Hunter Data"
	hunter_data.owner = src

/mob/living/carbon/Life(delta_time)
	..()

	handle_fire() //Check if we're on fire
	if(SSweather.is_weather_event)
		handle_weather(delta_time)

	if(stat != CONSCIOUS)
		remove_all_indicators()

/mob/living/carbon/Destroy()
	view_change_sources = null
	active_transfusions = null
	. = ..()

	QDEL_NULL_LIST(internal_organs)
	QDEL_NULL(handcuffed)
	QDEL_NULL(legcuffed)
	QDEL_NULL(halitem)

	hunter_data?.clean_data()
	hunter_data = null
	halimage = null
	halbody = null


/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(nutrition && stat != DEAD)
			nutrition -= HUNGER_FACTOR/5

/mob/living/carbon/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated(TRUE))
		return
	if(!chestburst && (status_flags & XENO_HOST) && islarva(user))
		var/mob/living/carbon/xenomorph/larva/larva_burst = user
		larva_burst.chest_burst(src)

/mob/living/carbon/ex_act(severity, direction, datum/cause_data/cause_data)
	last_damage_data = istype(cause_data) ? cause_data : create_cause_data(cause_data)
	var/gibbing = FALSE

	if(severity >= health && severity >= EXPLOSION_THRESHOLD_GIB)
		gibbing = TRUE

	if(body_position == LYING_DOWN && direction)
		severity *= EXPLOSION_PRONE_MULTIPLIER

	if(HAS_TRAIT(src, TRAIT_HAULED) && !gibbing) // We still probably wanna gib them as well if they were supposed to be gibbed by the explosion in the first place
		visible_message(SPAN_WARNING("[src] is shielded from the blast!"), SPAN_WARNING("You are shielded from the blast!"))
		return

	if(severity >= 30)
		flash_eyes()

	last_damage_data = istype(cause_data) ? cause_data : create_cause_data(cause_data)

	if(gibbing)
		gib(last_damage_data)
		return

	apply_damage(severity, BRUTE)
	updatehealth()

	var/knock_value = min( round( severity*0.1 ,1) ,10)
	if(knock_value > 0)
		apply_effect(knock_value, PARALYZE)
		explosion_throw(severity, direction)

/mob/living/carbon/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	if(legcuffed)
		drop_inv_item_on_ground(legcuffed)
	. = ..(cause)

/mob/living/carbon/revive()
	if(handcuffed && !initial(handcuffed))
		drop_inv_item_on_ground(handcuffed)
	handcuffed = initial(handcuffed)

	if(legcuffed && !initial(legcuffed))
		drop_inv_item_on_ground(legcuffed)
	legcuffed = initial(legcuffed)
	recalculate_move_delay = TRUE
	..()

/mob/living/carbon/human/attackby(obj/item/weapon, mob/living/user)
	if(user.mob_flags & SURGERY_MODE_ON)
		switch(user.a_intent)
			if(INTENT_HELP)
				//Attempt to dig shrapnel first, if any. dig_out_shrapnel_check() will fail if user is not human, which may be possible in future.
				if(weapon.flags_item & CAN_DIG_SHRAPNEL && (locate(/obj/item/shard) in src.embedded_items) && weapon.dig_out_shrapnel_check(src, user))
					return TRUE
				var/datum/surgery/current_surgery = active_surgeries[user.zone_selected]
				if(current_surgery)
					if(current_surgery.attempt_next_step(user, weapon))
						return TRUE //Cancel attack.
				else
					var/obj/limb/affecting = get_limb(check_zone(user.zone_selected))
					if(initiate_surgery_moment(weapon, src, affecting, user))
						return TRUE

			if(INTENT_DISARM) //Same as help but without the shrapnel dig attempt.
				var/datum/surgery/current_surgery = active_surgeries[user.zone_selected]
				if(current_surgery)
					if(current_surgery.attempt_next_step(user, weapon))
						return TRUE
				else
					var/obj/limb/affecting = get_limb(check_zone(user.zone_selected))
					if(initiate_surgery_moment(weapon, src, affecting, user))
						return TRUE

	else if(weapon.flags_item & CAN_DIG_SHRAPNEL && weapon.dig_out_shrapnel_check(src, user))
		return TRUE

	. = ..()

/mob/living/carbon/human/proc/handle_haul_resist()
	if(world.time <= next_haul_resist)
		return

	if(is_mob_incapacitated())
		return

	var/mob/living/carbon/xenomorph/xeno = hauling_xeno
	next_haul_resist = world.time + 1.4 SECONDS
	if(istype(get_active_hand(), /obj/item))
		var/obj/item/item = get_active_hand()
		if(item.force > 0)
			var/limited_force = min(item.force, 35)
			var/damage_of_item = rand(floor(limited_force / 4), limited_force)

			xeno.last_damage_data = create_cause_data("scuffling", src)
			attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(xeno)] with [item.name] (INTENT: [uppertext(intent_text(a_intent))]) (DAMTYPE: [uppertext(BRUTE)])</font>"
			xeno.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [key_name(src)] with [item.name] (INTENT: [uppertext(intent_text(a_intent))]) (DAMTYPE: [uppertext(BRUTE)])</font>"
			msg_admin_attack("[key_name(src)] attacked [key_name(xeno)] with [item.name] (INTENT: [uppertext(intent_text(a_intent))]) (DAMTYPE: [uppertext(BRUTE)]) in [get_area(xeno)] ([xeno.loc.x],[xeno.loc.y],[xeno.loc.z]).", xeno.loc.x, xeno.loc.y, xeno.loc.z)

			xeno.take_limb_damage(damage_of_item)
			for(var/mob/mobs_in_view as anything in viewers(src, null))
				if(mobs_in_view.client)
					mobs_in_view.show_message(text(SPAN_DANGER("<B>[src] attacks [xeno]'s carapace with the [item.name]!")), SHOW_MESSAGE_AUDIBLE)
			track_hit(initial(item.name))
			if(item.sharp)
				playsound(loc, 'sound/weapons/slash.ogg', 25, 1)
			else
				var/hit_sound = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
				playsound(loc, hit_sound, 25, 1)
			if(prob(max(4*(100*xeno.getBruteLoss()/xeno.maxHealth - 75),0))) //4% at 24% health, 80% at 5% health
				xeno.release_haul(stuns=FALSE)
		else
			for(var/mob/mobs_can_hear in hearers(4, xeno))
				if(mobs_can_hear.client)
					mobs_can_hear.show_message(SPAN_DANGER("You hear [src] struggling against [xeno]'s grip..."), SHOW_MESSAGE_AUDIBLE)
	return

/mob/living/carbon/attack_hand(mob/target_mob as mob)
	if(!istype(target_mob, /mob/living/carbon))
		return

	if(target_mob.mob_flags & SURGERY_MODE_ON && target_mob.a_intent & (INTENT_HELP|INTENT_DISARM))
		var/datum/surgery/current_surgery = active_surgeries[target_mob.zone_selected]
		if(current_surgery)
			if(current_surgery.attempt_next_step(target_mob, null))
				return TRUE
		else
			var/obj/limb/affecting = get_limb(check_zone(target_mob.zone_selected))
			if(affecting && initiate_surgery_moment(null, src, affecting, target_mob))
				return TRUE

	if(can_pass_disease() && target_mob.can_pass_disease())
		for(var/datum/disease/virus in viruses)
			if(virus.spread_by_touch())
				target_mob.contract_disease(virus, FALSE, TRUE, CONTACT_HANDS)

		for(var/datum/disease/virus in target_mob.viruses)
			if(virus.spread_by_touch())
				contract_disease(virus, FALSE, TRUE, CONTACT_HANDS)

	target_mob.next_move += 7 //Adds some lag to the 'attack'. Adds up to 11 in combination with click_adjacent.
	return

/// Whether or not a mob can pass diseases to another, or receive said diseases.
/mob/proc/can_pass_disease()
	return TRUE

/mob/living/carbon/human/can_pass_disease()
	// Multiplier for checked pieces.
	var/mult = 0
	// Total amount of bio protection
	var/total_prot = 0
	// Super bio armor
	var/bio_hardcore = 0

	var/list/worn_clothes = list(head, wear_suit, hands, glasses, w_uniform, shoes, wear_mask)

	for(var/obj/item/clothing/worn_item in worn_clothes)
		total_prot += worn_item.armor_bio
		mult++
		if(worn_item.armor_bio == CLOTHING_ARMOR_HARDCORE)
			bio_hardcore++

	if(!mult)
		return FALSE

	if(bio_hardcore >= 2)
		return FALSE

	var/perc = (total_prot / mult)
	if(!prob(perc))
		return TRUE
	return FALSE

/mob/living/carbon/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0, def_zone = null)
	if(status_flags & GODMODE) //godmode
		return FALSE
	shock_damage *= siemens_coeff
	if(shock_damage<1)
		return FALSE

	src.apply_damage(shock_damage, BURN, def_zone, used_weapon="Electrocution")

	playsound(loc, "sparks", 25, 1)
	if(shock_damage > 10)
		src.visible_message(
			SPAN_DANGER("[src] was shocked by [source]!"),
			SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"),
			SPAN_DANGER("You hear a heavy electrical crack.") \
		)
		if(isxeno(src) && mob_size >= MOB_SIZE_BIG)
			apply_effect(1, STUN)//Sadly, something has to stop them from bumping them 10 times in a second
			apply_effect(1, WEAKEN)
		else
			apply_effect(6, STUN)//This should work for now, more is really silly and makes you lay there forever
			apply_effect(6, WEAKEN)

		count_niche_stat(STATISTICS_NICHE_SHOCK)

	else
		src.visible_message(
			SPAN_DANGER("[src] was mildly shocked by [source]."),
			SPAN_DANGER("You feel a mild shock course through your body."),
			SPAN_DANGER("You hear a light zapping.") \
		)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

	return shock_damage


/mob/living/carbon/swap_hand()
	var/obj/item/wielded_item = get_active_hand()
	if(wielded_item && (wielded_item.flags_item & WIELDED)) //this segment checks if the item in your hand is twohanded.
		var/obj/item/weapon/twohanded/offhand/offhand = get_inactive_hand()
		if(offhand && (offhand.flags_item & WIELDED))
			to_chat(src, SPAN_WARNING("Your other hand is too busy holding \the [offhand.name]")) //So it's an offhand.
			return
		else
			wielded_item.unwield(src) //Get rid of it.
	if(wielded_item && wielded_item.zoom) //Adding this here while we're at it
		wielded_item.zoom(src)
	..()
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand) //This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "hand_active"
			hud_used.r_hand_hud_object.icon_state = "hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "hand_active"
	if(l_hand)
		l_hand.hands_swapped(src)
	if(r_hand)
		r_hand.hands_swapped(src)
	return

/mob/living/carbon/proc/activate_hand(selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if(src == M)
		return
	var/t_him = p_them()

	var/shake_action
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_INCAPACITATED) || sleeping) // incap implies also unconscious or knockedout
		shake_action = "wake [t_him] up!"
	else if(HAS_TRAIT(src, TRAIT_FLOORED))
		shake_action = "get [t_him] up!"

	if(shake_action) // We are incapacitated in some fashion
		if(client)
			sleeping = max(0,sleeping-5)
		M.visible_message(SPAN_NOTICE("[M] shakes [src] trying to [shake_action]"),
			SPAN_NOTICE("You shake [src] trying to [shake_action]"), null, 4)

	else if(body_position == LYING_DOWN) // We're just chilling on the ground, let us be
		M.visible_message(SPAN_NOTICE("[M] stares and waves impatiently at [src] lying on the ground."),
			SPAN_NOTICE("You stare and wave at [src] just lying on the ground."), null, 4)

	else
		var/mob/living/carbon/human/H = M
		if(istype(H))
			H.species.hug(H, src, H.zone_selected)
		else
			M.visible_message(SPAN_NOTICE("[M] pats [src] on the back to make [t_him] feel better!"),
				SPAN_NOTICE("You pat [src] on the back to make [t_him] feel better!"), null, 4)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 5)
		return

	adjust_effect(-6, PARALYZE)
	adjust_effect(-6, STUN)
	adjust_effect(-6, WEAKEN)

	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 5)


//Throwing stuff

/mob/living/carbon/toggle_normal_throw()
	if(!stat && isturf(loc) && !is_mob_restrained())
		toggle_throw_mode(THROW_MODE_NORMAL)

/mob/living/carbon/toggle_high_toss()
	if(!stat && isturf(loc) && !is_mob_restrained())
		toggle_throw_mode(THROW_MODE_HIGH)

/mob/living/carbon/proc/toggle_throw_mode(type)
	if(type == THROW_MODE_OFF || throw_mode == type)
		throw_mode = THROW_MODE_OFF
		if(hud_used && hud_used.throw_icon)
			hud_used.throw_icon.icon_state = "act_throw_off"
		return

	throw_mode = type
	if(!hud_used || !hud_used.throw_icon)
		return

	if(type == THROW_MODE_NORMAL)
		hud_used.throw_icon.icon_state = "act_throw_normal"
	else
		hud_used.throw_icon.icon_state = "act_throw_high"

/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target)
	var/throw_type = throw_mode
	toggle_throw_mode(THROW_MODE_OFF) // This MUST be at the beginning, or else players will not recognize that throw is not toggled on (especially xenos)

	if(is_ventcrawling) //NOPE
		return
	if(stat || !target)
		return
	if(!istype(loc, /turf) || HAS_TRAIT(src, TRAIT_HAULED)) // In some mob/object (i.e. hauled or tank)
		to_chat(src, SPAN_WARNING("You cannot throw anything right now."))
		return
	if(target.type == /atom/movable/screen)
		return

	var/atom/movable/thrown_thing
	var/obj/item/I = get_active_hand()

	if(!I || (I.flags_item & NODROP))
		return

	var/spin_throw = TRUE

	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(ismob(G.grabbed_thing))
			if(grab_level >= GRAB_CARRY) // Carry and choke can only throw
				var/mob/living/M = G.grabbed_thing
				spin_throw = FALSE //thrown mobs don't spin
				thrown_thing = M
				var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
				var/turf/end_T = get_turf(target)
				if(start_T && end_T)
					var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
					var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

					M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been thrown by [key_name(usr)] from [start_T_descriptor] with the target [end_T_descriptor]</font>"
					usr.attack_log += "\[[time_stamp()]\] <font color='red'>Has thrown [key_name(M)] from [start_T_descriptor] with the target [end_T_descriptor]</font>"
					msg_admin_attack("[key_name(usr)] has thrown [key_name(M)] from [start_T_descriptor] with the target [end_T_descriptor] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
			else
				to_chat(src, SPAN_WARNING("You need a better grip!"))

	else //real item in hand, not a grab
		thrown_thing = I



	//actually throw it!
	if(thrown_thing)

		if(!(thrown_thing.try_to_throw(src)))
			return
		visible_message(SPAN_WARNING("[src] has thrown [thrown_thing]."), null, null, 5)

		if(!lastarea)
			lastarea = get_area(src.loc)
		if(istype(loc, /turf/open/space))
			inertia_dir = get_dir(target, src)
			step(src, inertia_dir)

		if(throw_type == THROW_MODE_HIGH)
			to_chat(src, SPAN_NOTICE("You prepare to perform a high toss."))
			if(!do_after(src, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
				to_chat(src, SPAN_WARNING("You need to set up the high toss!"))
				return
			animation_attack_on(target, 6)
			//The volume of the sound takes the minimum between the distance thrown or the max range an item, but no more than 15. Short throws are quieter. Invisible mobs do no sound.
			if(alpha >= 50)
				playsound(src, "throwing", min(5*min(get_dist(loc,target),thrown_thing.throw_range), 15), vary = TRUE, sound_range = 6)
			drop_inv_item_on_ground(I, TRUE)
			thrown_thing.throw_atom(target, thrown_thing.throw_range, SPEED_SLOW, src, spin_throw, HIGH_LAUNCH)
		else
			animation_attack_on(target, 6)
			//The volume of the sound takes the minimum between the distance thrown or the max range an item, but no more than 15. Short throws are quieter. Invisible mobs do no sound.
			if(alpha >= 50)
				playsound(src, "throwing", min(5*min(get_dist(loc,target),thrown_thing.throw_range), 15), vary = TRUE, sound_range = 6)
			drop_inv_item_on_ground(I, TRUE)
			thrown_thing.throw_atom(target, thrown_thing.throw_range, thrown_thing.throw_speed, src, spin_throw)

/mob/living/carbon/fire_act(exposed_temperature, exposed_volume)
	..()
	bodytemperature = max(bodytemperature, BODYTEMP_HEAT_DAMAGE_LIMIT+10)
	recalculate_move_delay = TRUE

/**
 * Called by [/mob/dead/observer/proc/do_observe] when a carbon mob is observed by a ghost with [/datum/preferences/var/auto_observe] enabled.
 *
 * Any HUD changes past this point are handled by [/mob/dead/observer/proc/observe_target_screen_add]
 * and [/mob/dead/observer/proc/observe_target_screen_remove].
 *
 * Override on subtype mobs if they have any extra HUD elements/behaviour.
 */
/mob/living/carbon/proc/auto_observed(mob/dead/observer/observer)
	SHOULD_CALL_PARENT(TRUE)

	LAZYINITLIST(observers)
	observers |= observer
	hud_used.show_hud(hud_used.hud_version, observer)

	// Add the player's action buttons (not the actions themselves) to the observer's screen.
	for(var/datum/action/action as anything in actions)
		// Skip any hidden ones (of course).
		if(action.hidden || action.player_hidden)
			continue

		observer.client.add_to_screen(action.button)

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(sleeping)
		to_chat(usr, SPAN_DANGER("You are already sleeping"))
		return
	if(alert(src,"You sure you want to sleep for a while?","Sleep","Yes","No") == "Yes")
		sleeping = 20 //Short nap


/mob/living/carbon/Collide(atom/movable/AM)
	if(now_pushing)
		return
	. = ..()

/mob/living/carbon/slip(slip_source_name, stun_level, weaken_level, run_only, override_noslip, slide_steps)
	set waitfor = 0
	if(buckled)
		return FALSE //can't slip while buckled
	if(body_position != STANDING_UP)
		return FALSE //can't slip if already lying down.
	stop_pulling()
	to_chat(src, SPAN_WARNING("You slipped on \the [slip_source_name? slip_source_name : "floor"]!"))
	playsound(src.loc, 'sound/misc/slip.ogg', 25, 1)
	apply_effect(stun_level, STUN)
	apply_effect(weaken_level, WEAKEN)
	. = TRUE
	if(slide_steps && HAS_TRAIT(src, TRAIT_FLOORED))//lying check to make sure we downed the mob
		var/slide_dir = dir
		for(var/i=1, i<=slide_steps, i++)
			step(src, slide_dir)
			sleep(2)
			if(!HAS_TRAIT(src, TRAIT_FLOORED)) // just watch this break in the most horrible way possible
				break

// Adding traits, etc after xeno restrains and hauls us
/mob/living/carbon/human/proc/handle_haul(mob/living/carbon/xenomorph/xeno)
	ADD_TRAIT(src, TRAIT_FLOORED, TRAIT_SOURCE_XENO_HAUL)
	ADD_TRAIT(src, TRAIT_HAULED, TRAIT_SOURCE_XENO_HAUL)
	ADD_TRAIT(src, TRAIT_NO_STRAY, TRAIT_SOURCE_XENO_HAUL)

	hauling_xeno = xeno
	RegisterSignal(xeno, COMSIG_MOB_DEATH, PROC_REF(release_haul_death))
	RegisterSignal(src, COMSIG_ATTEMPT_MOB_PULL, PROC_REF(haul_grab_attempt))
	RegisterSignal(src, COMSIG_LIVING_PREIGNITION, PROC_REF(haul_fire_shield))
	RegisterSignal(src, list(COMSIG_LIVING_FLAMER_CROSSED, COMSIG_LIVING_FLAMER_FLAMED), PROC_REF(haul_fire_shield_callback))
	layer = LYING_BETWEEN_MOB_LAYER
	add_filter("hauled_shadow", 1, color_matrix_filter(rgb(95, 95, 95)))
	pixel_y = -7
	next_haul_resist = 0

/mob/living/carbon/human/proc/release_haul_death()
	SIGNAL_HANDLER
	handle_unhaul()

/mob/living/carbon/human/proc/haul_grab_attempt()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_MOB_PULL

/mob/living/carbon/human/proc/haul_fire_shield(mob/living/burning_mob) //Stealing it from the pyro spec armor, xenos shield us from fire
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_IGNITION

/mob/living/carbon/human/proc/haul_fire_shield_callback(mob/living/burning_mob)
	SIGNAL_HANDLER
	return COMPONENT_NO_IGNITE|COMPONENT_NO_BURN

// Removing traits and other stuff after xeno releases us from haul
/mob/living/carbon/human/proc/handle_unhaul()
	var/location = get_turf(loc)
	remove_traits(list(TRAIT_HAULED, TRAIT_NO_STRAY, TRAIT_FLOORED, TRAIT_IMMOBILIZED), TRAIT_SOURCE_XENO_HAUL)
	pixel_y = 0
	UnregisterSignal(src, list(COMSIG_ATTEMPT_MOB_PULL, COMSIG_LIVING_PREIGNITION, COMSIG_LIVING_FLAMER_CROSSED, COMSIG_LIVING_FLAMER_FLAMED))
	UnregisterSignal(hauling_xeno, COMSIG_MOB_DEATH)
	hauling_xeno = null
	layer = MOB_LAYER
	remove_filter("hauled_shadow")
	forceMove(location)
	for(var/obj/object in location)
		if(istype(object, /obj/effect/alien/resin/trap) || istype(object, /obj/effect/alien/egg) || istype(object, /obj/effect/alien/resin/special/eggmorph))
			object.HasProximity(src)
		if(istype(object, /obj/effect/egg_trigger))
			object.Crossed(src)
	next_haul_resist = 0
	SEND_SIGNAL(src, COMSIG_MOB_UNHAULED)


/mob/living/carbon/proc/extinguish_mob(mob/living/carbon/C)
	adjust_fire_stacks(-5, min_stacks = 0)
	playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
	C.visible_message(SPAN_DANGER("[C] tries to put out the fire on [src]!"),
	SPAN_WARNING("You try to put out the fire on [src]!"), null, 5)
	if(fire_stacks <= 0)
		C.visible_message(SPAN_DANGER("[C] has successfully extinguished the fire on [src]!"),
		SPAN_NOTICE("You extinguished the fire on [src]."), null, 5)

/mob/living/carbon/resist_buckle()

	if(handcuffed)
		next_move = world.time + 100
		last_special = world.time + 100
		visible_message(SPAN_DANGER("<B>[src] attempts to unbuckle themself!</B>"),
		SPAN_DANGER("You attempt to unbuckle yourself. (This will take around 2 minutes and you need to stand still)"))
		if(do_after(src, 1200, INTERRUPT_NO_FLOORED^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
			if(!buckled)
				return
			visible_message(SPAN_DANGER("<B>[src] manages to unbuckle themself!</B>"),
						SPAN_NOTICE("You successfully unbuckle yourself."))
			buckled.manual_unbuckle(src)
	else
		buckled.manual_unbuckle(src)

/mob/living/carbon/get_examine_text(mob/user)
	. = ..()
	if(isyautja(user))
		. += SPAN_BLUE("[src] is worth [max(life_kills_total, default_honor_value)] honor.")
		if(src.hunter_data.hunted)
			. += SPAN_ORANGE("[src] is being hunted by [src.hunter_data.hunter.real_name].")

		if(src.hunter_data.dishonored)
			. += SPAN_RED("[src] was marked as dishonorable for '[src.hunter_data.dishonored_reason]'.")
		else if(src.hunter_data.honored)
			. += SPAN_GREEN("[src] was honored for '[src.hunter_data.honored_reason]'.")

		if(src.hunter_data.thralled)
			. += SPAN_GREEN("[src] was thralled by [src.hunter_data.thralled_set.real_name] for '[src.hunter_data.thralled_reason]'.")
		else if(src.hunter_data.gear)
			. += SPAN_RED("[src] was marked as carrying gear by [src.hunter_data.gear_set].")


/mob/living/carbon/on_lying_down(new_lying_angle)
	. = ..()
	if(!buckled || buckled.buckle_lying != 0)
		lying_angle_on_lying_down(new_lying_angle)


/// Special carbon interaction on lying down, to transform its sprite by a rotation.
/mob/living/carbon/proc/lying_angle_on_lying_down(new_lying_angle)
	if(!new_lying_angle)
		set_lying_angle(pick(90, 270))
	else
		set_lying_angle(new_lying_angle)
