//goat
/mob/living/simple_animal/hostile/retaliate/goat
	name = "goat"
	desc = "Not known for their pleasant disposition."
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	speak = list("EHEHEHEHEH","eh?")
	speak_emote = list("brays")
	emote_hear = list("brays")
	emote_see = list("shakes its head", "stamps a foot", "glares around")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_container/food/snacks/meat
	meat_amount = 4
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	faction = "goat"
	attacktext = "kicks"
	health = 40
	melee_damage_lower = 1
	melee_damage_upper = 5
	var/datum/reagents/udder = null

/mob/living/simple_animal/hostile/retaliate/goat/Initialize()
	udder = new(50)
	udder.my_atom = src
	. = ..()

/mob/living/simple_animal/hostile/retaliate/goat/Destroy()
	if(udder)
		udder.my_atom = null
	QDEL_NULL(udder)
	return ..()

/mob/living/simple_animal/hostile/retaliate/goat/Life(delta_time)
	. = ..()
	if(.)
		//chance to go crazy and start wacking stuff
		if(!length(enemies) && prob(1))
			Retaliate()

		if(length(enemies) && prob(10))
			enemies = list()
			LoseTarget()
			src.visible_message(SPAN_NOTICE("[src] calms down."))

		if(stat == CONSCIOUS)
			if(udder && prob(5))
				udder.add_reagent("milk", rand(5, 10))

		if(locate(/obj/effect/plantsegment) in loc)
			var/obj/effect/plantsegment/SV = locate(/obj/effect/plantsegment) in loc
			qdel(SV)
			if(prob(10))
				INVOKE_ASYNC(src, PROC_REF(say), "Nom")

		if(!pulledby)
			for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
				var/step = get_step(src, direction)
				if(step)
					if(locate(/obj/effect/plantsegment) in step)
						Move(step)

/mob/living/simple_animal/hostile/retaliate/goat/Retaliate()
	..()
	src.visible_message(SPAN_DANGER("[src] gets an evil-looking gleam in their eye."))

/mob/living/simple_animal/hostile/retaliate/goat/Move()
	..()
	if(!stat)
		if(locate(/obj/effect/plantsegment) in loc)
			var/obj/effect/plantsegment/SV = locate(/obj/effect/plantsegment) in loc
			qdel(SV)
			if(prob(10))
				INVOKE_ASYNC(src, PROC_REF(say), "Nom")

/mob/living/simple_animal/hostile/retaliate/goat/attackby(obj/item/O as obj, mob/user as mob)
	var/obj/item/reagent_container/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message(SPAN_NOTICE("[user] milks [src] using \the [O]."))
		var/transfered = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, SPAN_DANGER("[O] is full."))
		if(!transfered)
			to_chat(user, SPAN_DANGER("The udder is dry. Wait a bit longer..."))
	else
		..()
//cow
/mob/living/simple_animal/cow
	name = "cow"
	desc = "Known for their milk, just don't tip them over."
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	speak = list("moo?","moo","MOOOOOO")
	speak_emote = list("moos","moos hauntingly")
	emote_hear = list("brays")
	emote_see = list("shakes its head")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_container/food/snacks/meat
	meat_amount = 6
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 50
	var/datum/reagents/udder = null

/mob/living/simple_animal/cow/New()
	udder = new(50)
	udder.my_atom = src
	..()

/mob/living/simple_animal/cow/Destroy()
	if(udder)
		udder.my_atom = null
	QDEL_NULL(udder)
	return ..()

/mob/living/simple_animal/cow/attackby(obj/item/O as obj, mob/user as mob)
	var/obj/item/reagent_container/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message(SPAN_NOTICE("[user] milks [src] using \the [O]."))
		var/transfered = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, SPAN_DANGER("The [O] is full."))
		if(!transfered)
			to_chat(user, SPAN_DANGER("The udder is dry. Wait a bit longer..."))
	else
		..()

/mob/living/simple_animal/cow/Life(delta_time)
	. = ..()
	if(stat == CONSCIOUS)
		if(udder && prob(5))
			udder.add_reagent("milk", rand(5, 10))

/mob/living/simple_animal/cow/death()
	. = ..()
	if(!.) return //was already dead
	if(last_damage_data)
		var/mob/user = last_damage_data.resolve_mob()
		if(user)
			user.count_niche_stat(STATISTICS_NICHE_COW)

/mob/living/simple_animal/cow/attack_hand(mob/living/carbon/M as mob)
	if(!stat && M.a_intent == INTENT_DISARM && icon_state != icon_dead)
		M.visible_message(SPAN_WARNING("[M] tips over [src]."), \
			SPAN_NOTICE("You tip over [src]."))
		apply_effect(30, WEAKEN)
		icon_state = icon_dead
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/list/responses = list( "[src] looks at you imploringly.",
											"[src] looks at you pleadingly",
											"[src] looks at you with a resigned expression.",
											"[src] seems resigned to its fate.")
				to_chat(M, pick(responses))
	else
		..()

/mob/living/simple_animal/chick
	name = "\improper chick"
	desc = "Adorable! They make such a racket though."
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	speak_emote = list("cheeps")
	emote_hear = list("cheeps")
	emote_see = list("pecks at the ground","flaps its tiny wings")
	speak_chance = 2
	turns_per_move = 2
	meat_type = /obj/item/reagent_container/food/snacks/meat
	meat_amount = 1
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 1
	var/amount_grown = 0
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/chick/New()
	..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/chick/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_UNDER

/mob/living/simple_animal/chick/Life(delta_time)
	. =..()
	if(!.)
		return
	if(!stat)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			new /mob/living/simple_animal/chicken(src.loc)
			qdel(src)

GLOBAL_VAR_INIT(MAX_CHICKENS, 50)
GLOBAL_VAR_INIT(chicken_count, 0)

/mob/living/simple_animal/chicken
	name = "\improper chicken"
	desc = "Hopefully the eggs are good this season."
	icon_state = "chicken"
	icon_living = "chicken"
	icon_dead = "chicken_dead"
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	speak_emote = list("clucks","croons")
	emote_hear = list("clucks")
	emote_see = list("pecks at the ground","flaps its wings viciously")
	speak_chance = 2
	turns_per_move = 3
	meat_type = /obj/item/reagent_container/food/snacks/meat
	meat_amount = 2
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 10
	var/eggsleft = 0
	var/body_color
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/chicken/New()
	..()
	if(!body_color)
		body_color = pick( list("brown","black","white") )
	icon_state = "chicken_[body_color]"
	icon_living = "chicken_[body_color]"
	icon_dead = "chicken_[body_color]_dead"
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	GLOB.chicken_count++

/mob/living/simple_animal/chicken/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_UNDER

/mob/living/simple_animal/chicken/death()
	..()
	GLOB.chicken_count--
	if(last_damage_data)
		var/mob/user = last_damage_data.resolve_mob()
		if(user)
			user.count_niche_stat(STATISTICS_NICHE_CHICKEN)

/mob/living/simple_animal/chicken/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_container/food/snacks/grown/wheat)) //feedin' dem chickens
		if(!stat && eggsleft < 8)
			user.visible_message(SPAN_NOTICE("[user] feeds [O] to [name]! It clucks happily."),SPAN_NOTICE("You feed [O] to [name]! It clucks happily."))
			user.drop_held_item()
			qdel(O)
			eggsleft += rand(1, 4)
			//world << eggsleft
		else
			to_chat(user, SPAN_NOTICE(" [name] doesn't seem hungry!"))
	else
		..()

/mob/living/simple_animal/chicken/Life(delta_time)
	. =..()
	if(!.)
		return
	if(!stat && prob(3) && eggsleft > 0)
		visible_message("[src] [pick("lays an egg.","squats down and croons.","begins making a huge racket.","begins clucking raucously.")]")
		eggsleft--
		var/obj/item/reagent_container/food/snacks/egg/E = new(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(GLOB.chicken_count < GLOB.MAX_CHICKENS && prob(10))
			START_PROCESSING(SSobj, E)

/obj/item/reagent_container/food/snacks/egg/var/amount_grown = 0
/obj/item/reagent_container/food/snacks/egg/process()
	if(isturf(loc))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			visible_message("[src] hatches with a quiet cracking sound.")
			new /mob/living/simple_animal/chick(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/reagent_container/food/snacks/egg/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()
