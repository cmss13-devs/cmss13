/mob/living/simple_animal/rat
	name = "rat"
	real_name = "rat"
	desc = "It's a big, disease-ridden rodent."
	icon_state = "rat_gray"
	icon_living = "rat_gray"
	icon_dead = "rat_gray_dead"
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	mob_size = MOB_SIZE_SMALL
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 10
	health = 10
	meat_type = /obj/item/reagent_container/food/snacks/meat
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "stamps on the"
	density = FALSE
	layer = ABOVE_LYING_MOB_LAYER
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223 //Below -50 Degrees Celcius
	maxbodytemp = 323 //Above 50 Degrees Celcius
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/holder/rat
	var/body_color //black, brown, gray and white, leave blank for random

/mob/living/simple_animal/rat/Life(delta_time)
	..()
	if(!stat && prob(speak_chance))
		for(var/mob/cur_mob in view())
			cur_mob << 'sound/effects/mousesqueek.ogg'

	if(!ckey && stat == CONSCIOUS && prob(0.5))
		set_stat(UNCONSCIOUS)
		icon_state = "rat_[body_color]_sleep"
		wander = FALSE
		speak_chance = 0
		//snuffles
	else if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			set_stat(CONSCIOUS)
			icon_state = "rat_[body_color]"
			wander = TRUE
		else if(prob(5))
			INVOKE_ASYNC(src, PROC_REF(emote), "snuffles")

/mob/living/simple_animal/rat/New()
	..()

	add_verb(src, list(
		/mob/living/proc/ventcrawl,
		/mob/living/proc/hide,
	))
	if(!name)
		name = "[name] ([rand(1, 1000)])"
	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "rat_[body_color]"
	icon_living = "rat_[body_color]"
	icon_dead = "rat_[body_color]_dead"
	if(!desc)
		desc = "It's a small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."

/mob/living/simple_animal/rat/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_CRAWLER

/mob/living/simple_animal/rat/splat(mob/killer)
	health = 0
	set_stat(DEAD)
	icon_dead = "rat_[body_color]_splat"
	icon_state = "rat_[body_color]_splat"
	layer = ABOVE_LYING_MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time

/mob/living/simple_animal/rat/start_pulling(atom/movable/AM)//Prevents rat from pulling things
	to_chat(src, SPAN_WARNING("You are too small to pull anything."))
	return

/mob/living/simple_animal/rat/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!ckey && stat == UNCONSCIOUS)
			set_stat(CONSCIOUS)
			icon_state = "rat_[body_color]"
			wander = TRUE
		else if(!stat && prob(5))
			var/mob/crossed_mob = AM
			to_chat(crossed_mob, SPAN_NOTICE(" [icon2html(src, crossed_mob)] Squeek!"))
			crossed_mob << 'sound/effects/mousesqueek.ogg'
	..()

/mob/living/simple_animal/rat/death()
	layer = ABOVE_LYING_MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time
	..()

/mob/living/simple_animal/rat/MouseDrop(atom/over_object)
	if(!CAN_PICKUP(usr, src))
		return ..()
	var/mob/living/carbon/human = over_object
	if(!istype(human) || !Adjacent(human) || human != usr) return ..()

	if(human.a_intent == INTENT_HELP)
		get_scooped(human)
		return
	return ..()

/mob/living/simple_animal/rat/get_scooped(mob/living/carbon/grabber)
	if (stat >= DEAD)
		return
	..()

/*
 * rat types
 */

/mob/living/simple_animal/rat/white
	body_color = "white"
	icon_state = "rat_white"
	desc = "It's a small laboratory rat."
	holder_type = /obj/item/holder/rat/white

/mob/living/simple_animal/rat/gray
	body_color = "gray"
	icon_state = "rat_gray"
	holder_type = /obj/item/holder/rat/gray

/mob/living/simple_animal/rat/brown
	body_color = "brown"
	icon_state = "rat_brown"
	holder_type = /obj/item/holder/rat/brown
/mob/living/simple_animal/rat/black
	body_color = "black"
	icon_state = "rat_black"
	holder_type = /obj/item/holder/rat/black

/mob/living/simple_animal/rat/white/Milky
	name = "Milky"
	desc = "An escaped test rat from the Weyland-Yutani Research Facility. Hope it doesn't have some sort of genetically engineered disease or something..."
	gender = MALE
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	holder_type = /obj/item/holder/rat/white/Milky

/mob/living/simple_animal/rat/brown/Old_Timmy
	name = "Old Timmy"
	desc = "An ancient looking rat from the old days of the colony."
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "splats"
	holder_type = /obj/item/holder/rat/brown/Old_Timmy

/mob/living/simple_animal/rat/black/Korey
	name = "Korey"
	desc = "An escaped test rat from the Weyland-Yutani Research Facility. Hope it doesn't have some sort of genetically engineered disease or something..."
	gender = MALE
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	holder_type = /obj/item/holder/rat/black/Korey
