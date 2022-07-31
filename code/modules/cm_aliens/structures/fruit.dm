#define CAN_CONSUME_AT_FULL_HEALTH 1<<0

/obj/effect/alien/resin/fruit
	name = XENO_FRUIT_LESSER
	desc = "A fruit that can be eaten to immediately recover health."
	icon_state = "fruit_lesser_immature"
	density = 0
	opacity = 0
	anchored = TRUE
	health = 25
	layer = BUSH_LAYER // technically a plant amiright
	var/picked = FALSE
	var/hivenumber = XENO_HIVE_NORMAL
	var/consume_delay = 2 SECONDS
	var/mature = FALSE
	var/flags = 0
	var/timer_id = TIMER_ID_NULL
	var/time_to_mature = 15 SECONDS
	var/heal_amount = 75
	var/regeneration_amount_total = 0
	var/regeneration_ticks = 1
	var/mature_icon_state = "fruit_lesser"
	var/consumed_icon_state = "fruit_spent"

	var/glow_color = "#17991b80"

	var/mob/living/carbon/Xenomorph/bound_xeno // Drone linked to this fruit
	var/fruit_type = /obj/item/reagent_container/food/snacks/resin_fruit

/obj/effect/alien/resin/fruit/attack_hand(mob/living/user)
	. = ..()
	to_chat(user, SPAN_WARNING("You start uprooting \the [src].."))
	if(!do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return
	var/n_color = color
	qdel(src)
	playsound(src, "alien_resin_break", 25, FALSE)
	if(!mature)
		to_chat(user, SPAN_WARNING("[src] disintegrates in your hands as you uproot it."))
		return
	to_chat(user, SPAN_WARNING("You uproot [src]."))
	var/obj/item/reagent_container/food/snacks/resin_fruit/new_fruit = new fruit_type()
	new_fruit.color = n_color
	user.put_in_hands(new_fruit)

/obj/effect/alien/resin/fruit/Initialize(mapload, obj/effect/alien/weeds/W, mob/living/carbon/Xenomorph/X)
	if(!istype(X))
		return INITIALIZE_HINT_QDEL

	bound_xeno = X
	hivenumber = X.hivenumber
	RegisterSignal(W, COMSIG_PARENT_QDELETING, .proc/on_weed_expire)
	RegisterSignal(X, COMSIG_PARENT_QDELETING, .proc/handle_xeno_qdel)
	set_hive_data(src, hivenumber)
	//Keep timer value here
	timer_id = addtimer(CALLBACK(src, .proc/mature), time_to_mature * W.fruit_growth_multiplier, TIMER_UNIQUE | TIMER_STOPPABLE)
	. = ..()
	// Need to do it here because baseline initialize override the icon through config.
	icon = 'icons/mob/hostiles/fruits.dmi'

/obj/effect/alien/resin/fruit/proc/on_weed_expire()
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/alien/resin/fruit/proc/handle_xeno_qdel()
	SIGNAL_HANDLER
	bound_xeno = null

/obj/effect/alien/resin/fruit/flamer_fire_act()
	qdel(src)
	..()

/obj/effect/alien/resin/fruit/fire_act()
	qdel(src)
	..()

/obj/effect/alien/resin/fruit/bullet_act(obj/item/projectile/P)
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO_ACID|AMMO_XENO_TOX))
		return
	qdel(src)
	. = ..()

/obj/effect/alien/resin/fruit/proc/delete_fruit()
	//Notify and update the xeno count
	if(!QDELETED(bound_xeno))
		if(!picked)
			to_chat(bound_xeno, SPAN_XENOWARNING("You sense one of your fruit has been destroyed."))
		bound_xeno.current_fruits.Remove(src)
		var/datum/action/xeno_action/onclick/plant_resin_fruit/prf = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/plant_resin_fruit)
		prf.update_button_icon()

		if(picked) // No need to update the number, since the fruit still exists (just as a different item)
			return
		var/number_of_fruit = length(bound_xeno.current_fruits)
		prf.button.set_maptext(SMALL_FONTS_COLOR(7, number_of_fruit, "#e69d00"), 19, 2)
		prf.update_button_icon()
		bound_xeno = null

/obj/effect/alien/resin/fruit/proc/reduce_timer(maturity_increase)
	if (mature || timer_id == TIMER_ID_NULL)
		return

	// Unconditionally delete the first timer
	var/timeleft = timeleft(timer_id)
	deltimer(timer_id)
	timer_id = TIMER_ID_NULL

	// Are we done, or do we need to add a new timer
	if ((timeleft - maturity_increase) < 0)
		mature()
	else
		// Restart the timer.
		var/new_maturity_time = timeleft - maturity_increase
		timer_id = addtimer(CALLBACK(src, .proc/mature), new_maturity_time, TIMER_UNIQUE | TIMER_STOPPABLE)
		time_to_mature = new_maturity_time


/obj/effect/alien/resin/fruit/proc/mature()
	mature = TRUE
	icon_state = mature_icon_state
	timer_id = TIMER_ID_NULL
	if(glow_color)
		add_filter("fruity_glow", 1, list("type" = "outline", "color" = glow_color, "size" = 1))
	update_icon()

/obj/effect/alien/resin/fruit/proc/consume_effect(mob/living/carbon/Xenomorph/recipient, var/do_consume = TRUE)
	if(mature) // Someone might've eaten it before us!
		recipient.gain_health(75)
		to_chat(recipient, SPAN_XENONOTICE("You recover a bit from your injuries."))
		if(do_consume)
			finish_consume(recipient)

/obj/effect/alien/resin/fruit/proc/finish_consume(mob/living/carbon/Xenomorph/recipient)
	playsound(loc, 'sound/voice/alien_drool1.ogg', 50, 1)
	mature = FALSE
	icon_state = consumed_icon_state
	update_icon()
	QDEL_IN(src, 3 SECONDS)

/obj/effect/alien/resin/fruit/attack_alien(mob/living/carbon/Xenomorph/X)
	if(picked)
		to_chat(X, SPAN_XENODANGER("This fruit is already being picked!"))
		return
	if(X.a_intent != INTENT_HARM && (X.can_not_harm(bound_xeno) || X.hivenumber == hivenumber))
		var/cant_consume = prevent_consume(X)
		if(cant_consume)
			return cant_consume
		if(mature)
			to_chat(X, SPAN_XENOWARNING("You prepare to consume [name]."))
			xeno_noncombat_delay(X)
			if(!do_after(X, consume_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				return XENO_NO_DELAY_ACTION
			consume_effect(X)
		else
			to_chat(X, SPAN_XENOWARNING("[name] isn't ripe yet. You need to wait a little longer."))
	if(X.a_intent == INTENT_HARM && isXenoBuilder(X) || (!X.can_not_harm(bound_xeno) && X.hivenumber != hivenumber))
		X.animation_attack_on(src)
		X.visible_message(SPAN_XENODANGER("[X] removes [name]!"),
		SPAN_XENODANGER("You remove [name]!"))
		playsound(loc, "alien_resin_break", 25)
		qdel(src)
		return XENO_ATTACK_ACTION
	return XENO_NO_DELAY_ACTION

/obj/effect/alien/resin/fruit/proc/prevent_consume(mob/living/carbon/Xenomorph/xeno)
	if(!(flags & CAN_CONSUME_AT_FULL_HEALTH) && xeno.health >= xeno.caste.max_health)
		to_chat(xeno, SPAN_XENODANGER("You are at full health! This would be a waste..."))
		return XENO_NO_DELAY_ACTION
	return FALSE

/obj/effect/alien/resin/fruit/Destroy()
	delete_fruit()
	return ..()

//Greater

/obj/effect/alien/resin/fruit/greater
	name = XENO_FRUIT_GREATER
	desc = "A fruit that can be eaten to immediately recover health, and give a strong regeneration effect for a few seconds."
	time_to_mature = 30 SECONDS
	heal_amount = 75
	regeneration_amount_total = 100
	regeneration_ticks = 5
	icon_state = "fruit_greater_immature"
	mature_icon_state = "fruit_greater"
	fruit_type = /obj/item/reagent_container/food/snacks/resin_fruit/greater


/obj/effect/alien/resin/fruit/greater/consume_effect(mob/living/carbon/Xenomorph/recipient, var/do_consume = TRUE)
	if(!mature)
		return
	if(recipient && !QDELETED(recipient))
		recipient.gain_health(heal_amount)
		to_chat(recipient, SPAN_XENONOTICE("You recover a bit from your injuries, and begin to regenerate rapidly."))
		// Every second, heal him for 15.
		new /datum/effects/heal_over_time(recipient, regeneration_amount_total, regeneration_ticks, 1)
	if(do_consume)
		finish_consume(recipient)

//Unstable
/obj/effect/alien/resin/fruit/unstable
	name = XENO_FRUIT_UNSTABLE
	desc = "A fruit that can be eaten to gain a strong overshield effect, and give a small regeneration for several seconds."
	time_to_mature = 45 SECONDS
	heal_amount = 0
	regeneration_amount_total = 75
	regeneration_ticks = 15
	icon_state = "fruit_unstable_immature"
	mature_icon_state = "fruit_unstable"
	consumed_icon_state = "fruit_spent_2"
	flags = CAN_CONSUME_AT_FULL_HEALTH
	var/overshield_amount = 200
	var/shield_duration = 1 MINUTES
	var/shield_decay = 10
	fruit_type = /obj/item/reagent_container/food/snacks/resin_fruit/unstable
	glow_color = "#17997280"

/obj/effect/alien/resin/fruit/unstable/consume_effect(mob/living/carbon/Xenomorph/recipient, var/do_consume = TRUE)
	if(mature && recipient && !QDELETED(recipient))
		recipient.add_xeno_shield(Clamp(overshield_amount, 0, recipient.maxHealth * 0.3), XENO_SHIELD_SOURCE_GARDENER, duration = shield_duration, decay_amount_per_second = shield_decay)
		to_chat(recipient, SPAN_XENONOTICE("You feel your defense being bolstered, and begin to regenerate rapidly."))
		// Every seconds, heal him for 5.
		new /datum/effects/heal_over_time(recipient, regeneration_amount_total, regeneration_ticks, 1)
	if(do_consume)
		finish_consume(recipient)

//Spore
/obj/effect/alien/resin/fruit/spore
	desc = "A fruit that can be eaten to reenergize your cooldowns. It also passively emits weak recovery pheromones."
	name = XENO_FRUIT_SPORE
	time_to_mature = 15 SECONDS
	icon_state = "fruit_spore_immature"
	mature_icon_state = "fruit_spore"
	flags = CAN_CONSUME_AT_FULL_HEALTH
	var/max_cooldown_reduction = 0.25
	var/cooldown_per_slash = 0.05
	var/aura_strength = 1
	var/pheromone_range = 1
	consumed_icon_state = "fruit_spent_2"
	fruit_type = /obj/item/reagent_container/food/snacks/resin_fruit/spore
	glow_color = "#99461780"

/obj/effect/alien/resin/fruit/spore/consume_effect(mob/living/carbon/Xenomorph/recipient, var/do_consume = TRUE)
	if(mature && recipient && !QDELETED(recipient))
		mature = FALSE
		for (var/datum/effects/gain_xeno_cooldown_reduction_on_slash/E in recipient.effects_list)
			if(E.effect_source == "spore")
				qdel(E)
		new /datum/effects/gain_xeno_cooldown_reduction_on_slash(recipient, bound_xeno, max_cooldown_reduction, cooldown_per_slash, 60 SECONDS, "spore")
		to_chat(recipient, SPAN_XENONOTICE("You feel a frenzy coming onto you! Your abilities will cool off faster as you slash!"))
	if(do_consume)
		finish_consume(recipient)

/obj/effect/alien/resin/fruit/spore/mature()
	..()
	START_PROCESSING(SSobj, src)

/obj/effect/alien/resin/fruit/spore/delete_fruit()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/effect/alien/resin/fruit/spore/process()
	if(mature)
		for(var/mob/living/carbon/Xenomorph/Z in range(pheromone_range, loc))
			if(Z.ignores_pheromones)
				continue
			if(aura_strength > Z.recovery_new && hivenumber == Z.hivenumber)
				Z.recovery_new = aura_strength

/obj/effect/alien/resin/fruit/speed
	name = XENO_FRUIT_SPEED
	desc = "A fruit that can be eaten to move faster for a short amount of time."
	time_to_mature = 35 SECONDS
	icon_state = "fruit_speed_immature"
	mature_icon_state = "fruit_speed"
	consumed_icon_state = "fruit_spent_2"
	flags = CAN_CONSUME_AT_FULL_HEALTH
	fruit_type = /obj/item/reagent_container/food/snacks/resin_fruit/speed
	glow_color = "#9559ca80"
	var/speed_buff_amount = 0.4
	var/speed_duration = 15 SECONDS

/obj/effect/alien/resin/fruit/speed/prevent_consume(mob/living/carbon/Xenomorph/xeno)
	if(LAZYISIN(xeno.modifier_sources, XENO_FRUIT_SPEED))
		to_chat(xeno, SPAN_XENOWARNING("You're already under the effects of this fruit, go out and kill!"))
		return XENO_NO_DELAY_ACTION
	return ..()

/obj/effect/alien/resin/fruit/speed/consume_effect(mob/living/carbon/Xenomorph/recipient, var/do_consume = TRUE)
	if(mature && recipient && !QDELETED(recipient))
		to_chat(recipient, SPAN_XENONOTICE("The [name] invigorates you to move faster!"))
		new /datum/effects/xeno_speed(recipient, ttl = speed_duration, set_speed_modifier = speed_buff_amount, set_modifier_source = XENO_FRUIT_SPEED, set_end_message = SPAN_XENONOTICE("You feel the effects of the [name] wane..."))
	if(do_consume)
		finish_consume(recipient)

/obj/effect/alien/resin/fruit/plasma
	name = XENO_FRUIT_PLASMA
	desc = "A fruit that can be eaten to boost your plasma generation."
	time_to_mature = 25 SECONDS
	icon_state = "fruit_plasma_immature"
	mature_icon_state = "fruit_plasma"
	consumed_icon_state = "fruit_spent_2"
	flags = CAN_CONSUME_AT_FULL_HEALTH
	fruit_type = /obj/item/reagent_container/food/snacks/resin_fruit/plasma
	glow_color = "#287A90"
	var/plasma_amount = 240
	var/plasma_time = 15
	var/time_between_plasmas = 3

/obj/effect/alien/resin/fruit/plasma/consume_effect(mob/living/carbon/Xenomorph/recipient, var/do_consume = TRUE)
	if(mature && recipient && recipient.plasma_max > 0 && !QDELETED(recipient))
		to_chat(recipient, SPAN_XENONOTICE("The [name] boosts your plasma regeneration!"))
		// with the current values (240, 15, 3), this will give the recipient 48 plasma every 3 seconds, for a total of 240 in 15 seconds
		new /datum/effects/plasma_over_time(recipient, plasma_amount, plasma_time, time_between_plasmas)
	if(do_consume)
		finish_consume(recipient)

#undef CAN_CONSUME_AT_FULL_HEALTH

/obj/item/reagent_container/food/snacks/resin_fruit
	name = XENO_FRUIT_LESSER
	desc = "A strange fruit that you could eat.. if you REALLY wanted to. Its roots seem to twitch every so often."
	icon = 'icons/mob/hostiles/fruits.dmi'
	icon_state = "fruit_lesser_item"
	w_class = SIZE_LARGE
	bitesize = 2
	var/mob/living/carbon/Xenomorph/bound_xeno //Drone linked to this fruit
	var/fruit_type = /obj/effect/alien/resin/fruit
	var/consume_delay = 2 SECONDS

/obj/item/reagent_container/food/snacks/resin_fruit/Initialize()
	. = ..()
	add_juice()
	pixel_x = 0
	pixel_y = 0

/obj/item/reagent_container/food/snacks/resin_fruit/proc/link_xeno(mob/living/carbon/Xenomorph/X)
	to_chat(X, SPAN_XENOWARNING("One of your resin fruits has been picked."))
	X.current_fruits.Add(src)
	bound_xeno = X
	RegisterSignal(X, COMSIG_PARENT_QDELETING, .proc/handle_xeno_qdel)

/obj/item/reagent_container/food/snacks/resin_fruit/proc/handle_xeno_qdel()
	SIGNAL_HANDLER
	bound_xeno = null

/obj/item/reagent_container/food/snacks/resin_fruit/Destroy()
	delete_fruit()
	return ..()

// Removes the fruit from the xeno and updates their icons.
/obj/item/reagent_container/food/snacks/resin_fruit/proc/delete_fruit()
	if(bound_xeno)
		bound_xeno.current_fruits.Remove(src)
		var/datum/action/xeno_action/onclick/plant_resin_fruit/prf = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/plant_resin_fruit)
		var/number_of_fruit = length(bound_xeno.current_fruits)
		prf.button.set_maptext(SMALL_FONTS_COLOR(7, number_of_fruit, "#e69d00"), 19, 2)
		prf.update_button_icon()
		bound_xeno = null

// Xenos eating fruit
/obj/item/reagent_container/food/snacks/resin_fruit/attack(mob/living/carbon/Xenomorph/X, mob/user)
	if(istype(user, /mob/living/carbon/Xenomorph)) // Prevents xenos from feeding capped/dead marines fruit
		var/mob/living/carbon/Xenomorph/Y = user
		if(!Y.can_not_harm(X))
			to_chat(Y, SPAN_WARNING("[X] refuses to eat [src]."))
			return
	if(!istype(X))
		return ..()
	if(X.stat == DEAD)
		to_chat(user, SPAN_WARNING("That sister is already dead, they won't benefit from the fruit now..."))
		return
	user.affected_message(X,
		SPAN_HELPFUL("You <b>start [user == X ? "eating" : "feeding [X]"] [src]</b>."),
		SPAN_HELPFUL("[user] <b>starts feeding</b> you <b>[src]</b>."),
		SPAN_NOTICE("[user] starts [user == X ? "eating" : "feeding [X]"] <b>[src]</b>."))
	if(!do_after(user, consume_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, X, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		return FALSE
	user.affected_message(X,
		SPAN_HELPFUL("You [user == X ? "<b>eat</b>" : "<b>fed</b> [X]"] <b>[src]</b>."),
		SPAN_HELPFUL("[user] <b>fed</b> you <b>[src]</b>."),
		SPAN_NOTICE("[user] [user == X ? "ate" : "fed [X]"] <b>[src]</b>."))
	var/obj/effect/alien/resin/fruit/F = new fruit_type(X)
	F.mature = TRUE
	F.consume_effect(X)
	//Notify the fruit's bound xeno if they exist
	if(!QDELETED(bound_xeno))
		to_chat(bound_xeno, SPAN_XENOWARNING("One of your picked resin fruits has been consumed."))
	qdel(src)
	return TRUE

/obj/item/reagent_container/food/snacks/resin_fruit/attack_alien(mob/living/carbon/Xenomorph/M)
	attack_hand(M)
	return XENO_NONCOMBAT_ACTION

/obj/item/reagent_container/food/snacks/resin_fruit/proc/add_juice()
	reagents.add_reagent("fruit_resin", 8)

/obj/effect/alien/resin/fruit/MouseDrop(atom/over_object)
	var/mob/living/carbon/Xenomorph/X = over_object
	if(!istype(X) || !Adjacent(X) || X != usr || X.is_mob_incapacitated() || X.lying) return ..()
	X.pickup_fruit(src)

// Handles xenos picking up fruit
/mob/living/carbon/Xenomorph/proc/pickup_fruit(var/obj/effect/alien/resin/fruit/F)

	if(F.bound_xeno && !can_not_harm(F.bound_xeno))
		to_chat(src, SPAN_XENODANGER("You crush [F]."))
		qdel(F)
		return
	if(!F.mature)
		to_chat(src, SPAN_XENODANGER("[F] isn't mature yet!"))
		return
	if(F.picked)
		to_chat(src, SPAN_XENODANGER("[F] is already being picked!"))
		return
	// Indicates the fruit is being picked, so other xenos can't eat it at the same time
	F.picked = TRUE
	if(!do_after(src, F.consume_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		F.picked = FALSE
		return
	if(!F.mature)
		F.picked = FALSE
		return
	to_chat(src, SPAN_XENONOTICE("You uproot [F]."))
	var/obj/item/reagent_container/food/snacks/resin_fruit/new_fruit = new F.fruit_type()
	new_fruit.color = F.color
	put_in_hands(new_fruit)
	//if there's a xeno linked to the fruit, add it to their fruit cap and notify them.
	if(!QDELETED(F.bound_xeno))
		new_fruit.link_xeno(F.bound_xeno)
	qdel(F)

/mob/living/carbon/Xenomorph/Larva/pickup_fruit(obj/effect/alien/resin/fruit/F)
	to_chat(src, SPAN_XENODANGER("You are too small to pick up \the [F]!"))
	return

/mob/living/carbon/Xenomorph/Facehugger/pickup_fruit(obj/effect/alien/resin/fruit/F)
	to_chat(src, SPAN_XENODANGER("You are too small to pick up \the [F]!"))
	return

/obj/item/reagent_container/food/snacks/resin_fruit/greater
	name = XENO_FRUIT_GREATER
	desc = "A strange large fruit that you could eat.. if you REALLY wanted to. Its roots seem to twitch every so often."
	icon_state = "fruit_greater_item"
	bitesize = 4
	fruit_type = /obj/effect/alien/resin/fruit/greater

/obj/item/reagent_container/food/snacks/resin_fruit/greater/add_juice()
	reagents.add_reagent("fruit_resin", 16)

/obj/item/reagent_container/food/snacks/resin_fruit/unstable
	name = XENO_FRUIT_UNSTABLE
	desc = "A strange volatile fruit that you could eat.. if you REALLY wanted to. Its roots seem to twitch every so often."
	icon_state = "fruit_unstable_item"
	bitesize = 4
	fruit_type = /obj/effect/alien/resin/fruit/unstable

/obj/item/reagent_container/food/snacks/resin_fruit/unstable/add_juice()
	reagents.add_reagent("fruit_resin", 4)
	reagents.add_reagent(PLASMA_CHITIN, 12)

/obj/item/reagent_container/food/snacks/resin_fruit/spore
	name = XENO_FRUIT_SPORE
	desc = "A strange spore-filled fruit that you could eat.. if you REALLY wanted to. Its roots seem to twitch every so often."
	icon_state = "fruit_spore_item"
	fruit_type = /obj/effect/alien/resin/fruit/spore

/obj/item/reagent_container/food/snacks/resin_fruit/spore/add_juice()
	reagents.add_reagent("fruit_resin", 4)
	reagents.add_reagent(PLASMA_PHEROMONE, 12)

/obj/item/reagent_container/food/snacks/resin_fruit/speed
	name = XENO_FRUIT_SPEED
	desc = "A strange plasma-filled fruit that you could eat.. if you REALLY wanted to. Its roots seem to twitch every so often."
	icon_state = "fruit_speed_item"
	fruit_type = /obj/effect/alien/resin/fruit/speed

/obj/item/reagent_container/food/snacks/resin_fruit/speed/add_juice()
	reagents.add_reagent("fruit_resin", 4)
	reagents.add_reagent(PLASMA_PHEROMONE, 12)

/obj/item/reagent_container/food/snacks/resin_fruit/plasma
	name = XENO_FRUIT_PLASMA
	icon_state = "fruit_plasma_item"
	fruit_type = /obj/effect/alien/resin/fruit/plasma

/obj/item/reagent_container/food/snacks/resin_fruit/plasma/add_juice()
	reagents.add_reagent("fruit_resin", 4)
	reagents.add_reagent(PLASMA_PURPLE, 12)
