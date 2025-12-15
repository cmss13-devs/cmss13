/mob/living/simple_animal/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small, disease-ridden rodent."
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	mob_size = MOB_SIZE_SMALL
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	meat_type = /obj/item/reagent_container/food/snacks/meat
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "stamps on the"
	density = FALSE
	layer = ABOVE_LYING_MOB_LAYER
	min_oxy = 16 //Require at least 16kPA oxygen
	minbodytemp = 223 //Below -50 Degrees Celcius
	maxbodytemp = 323 //Above 50 Degrees Celcius
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/holder/mouse
	///the rodent color e.g. brown, gray and white, leave blank for random
	var/body_color
	///the icon_state prefix to use for the icon_state, icon_living, and icon_dead
	var/icon_base = "mouse"

/mob/living/simple_animal/mouse/Life(delta_time)
	..()
	if(stat == CONSCIOUS && prob(speak_chance))
		FOR_DVIEW(var/mob/mob, world.view, src, HIDE_INVISIBLE_OBSERVER)
			mob << 'sound/effects/mousesqueek.ogg'
		FOR_DVIEW_END

	if(!ckey && stat == CONSCIOUS && prob(0.5))
		set_stat(UNCONSCIOUS)
		icon_state = "[icon_base]_[body_color]_sleep"
		wander = FALSE
		speak_chance = 0
		//snuffles
	else if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			set_stat(CONSCIOUS)
			icon_state = "[icon_base]_[body_color]"
			wander = TRUE
		else if(prob(5))
			INVOKE_ASYNC(src, PROC_REF(emote), "snuffles")

/mob/living/simple_animal/mouse/New()
	..()

	add_verb(src, list(
		/mob/living/proc/ventcrawl,
		/mob/living/proc/hide,
	))
	if(!name)
		name = "[name] ([rand(1, 1000)])"
	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "[icon_base]_[body_color]"
	icon_living = "[icon_base]_[body_color]"
	icon_dead = "[icon_base]_[body_color]_dead"
	if(!desc)
		desc = "It's a small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."

/mob/living/simple_animal/mouse/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_CRAWLER

/mob/living/simple_animal/mouse/splat(mob/killer)
	health = 0
	set_stat(DEAD)
	icon_dead = "[icon_base]_[body_color]_splat"
	icon_state = "[icon_base]_[body_color]_splat"
	layer = ABOVE_LYING_MOB_LAYER
	set_body_position(LYING_DOWN)
	if(client)
		client.time_died_as_mouse = world.time

/mob/living/simple_animal/mouse/start_pulling(atom/movable/AM)//Prevents mouse from pulling things
	to_chat(src, SPAN_WARNING("You are too small to pull anything."))
	return

/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!ckey && stat == UNCONSCIOUS)
			set_stat(CONSCIOUS)
			icon_state = "[icon_base]_[body_color]"
			wander = TRUE
		else if(!stat && prob(5))
			var/mob/M = AM
			to_chat(M, SPAN_NOTICE(" [icon2html(src, M)] Squeek!"))
			M << 'sound/effects/mousesqueek.ogg'
	..()

/mob/living/simple_animal/mouse/death()
	layer = ABOVE_LYING_MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time
	..()

/mob/living/simple_animal/mouse/MouseDrop(atom/over_object)
	if(!CAN_PICKUP(usr, src))
		return ..()
	var/mob/living/carbon/human = over_object
	if(!istype(human) || !Adjacent(human) || human != usr)
		return ..()

	if(human.a_intent == INTENT_HELP)
		get_scooped(human)
		return
	else
		return ..()

/mob/living/simple_animal/mouse/get_scooped(mob/living/carbon/grabber)
	if(stat >= DEAD)
		return
	..()

/*
 * Mouse types
 */

/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon_state = "mouse_white"
	desc = "It's a small laboratory mouse."
	holder_type = /obj/item/holder/mouse/white

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"
	holder_type = /obj/item/holder/mouse/gray

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"
	holder_type = /obj/item/holder/mouse/brown

/mob/living/simple_animal/mouse/white/Doc
	name = "Doc"
	desc = "Senior mouse researcher of the Almayer. Likes: cheese, experiments, explosions."
	gender = MALE
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	holder_type = /obj/item/holder/mouse/white/Doc

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "splats"
	holder_type = /obj/item/holder/mouse/brown/Tom
