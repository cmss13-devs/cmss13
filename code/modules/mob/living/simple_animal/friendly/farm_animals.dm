//goat
/mob/living/simple_animal/hostile/retaliate/goat
	name = "goat"
	desc = "Not known for their pleasant disposition."
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	speak = list("MEHEHEHEHEH!","Mehh?","Maa!","MAAAA!","Mehh!","AAAAAAAAAA!")
	speak_emote = list("bleats")
	emote_hear = list("bleats.")
	emote_see = list("shakes its head.", "wiggles its tail.", "stamps a foot.", "glares around.")
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

/mob/living/simple_animal/hostile/retaliate/goat/Retaliate()
	..()
	src.visible_message(SPAN_DANGER("[src] gets an evil-looking gleam in their eye."))


/mob/living/simple_animal/hostile/retaliate/goat/attackby(obj/item/O as obj, mob/user as mob)
	var/obj/item/reagent_container/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message(SPAN_NOTICE("[user] milks [src] using \the [O]."))
		var/transferred = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, SPAN_DANGER("[O] is full."))
		if(!transferred)
			to_chat(user, SPAN_DANGER("The udder is dry. Wait a bit longer..."))
	else
		..()
//cow
/mob/living/simple_animal/big/cow
	name = "cow"
	desc = "Known for their milk, just don't tip them over."
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	speak = list("Moo?","Moo.", "Mooooo!","Mmmmmm.","MrrrrrOOOOOO!","MOOOOOO!")
	speak_emote = list("moos","moos hauntingly")
	emote_hear = list("moos.")
	emote_see = list("shakes its head.", "flicks its ear", "swishes its tail.", "licks at its side.")
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

/mob/living/simple_animal/big/cow/New()
	udder = new(50)
	udder.my_atom = src
	..()

/mob/living/simple_animal/big/cow/Destroy()
	if(udder)
		udder.my_atom = null
	QDEL_NULL(udder)
	return ..()

/mob/living/simple_animal/big/cow/attackby(obj/item/O as obj, mob/user as mob)
	var/obj/item/reagent_container/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message(SPAN_NOTICE("[user] milks [src] using \the [O]."))
		var/transferred = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, SPAN_DANGER("The [O] is full."))
		if(!transferred)
			to_chat(user, SPAN_DANGER("The udder is dry. Wait a bit longer..."))
	else
		..()

/mob/living/simple_animal/big/cow/Life(delta_time)
	. = ..()
	if(stat == CONSCIOUS)
		if(udder && prob(5))
			udder.add_reagent("milk", rand(5, 10))

/mob/living/simple_animal/big/cow/death()
	. = ..()
	if(!.)
		return //was already dead
	if(last_damage_data)
		var/mob/user = last_damage_data.resolve_mob()
		if(user)
			user.count_niche_stat(STATISTICS_NICHE_COW)

/mob/living/simple_animal/big/cow/attack_hand(mob/living/carbon/M as mob)
	if(!stat && M.a_intent == INTENT_DISARM && icon_state != icon_dead)
		M.visible_message(SPAN_WARNING("[M] tips over [src]."),
			SPAN_NOTICE("You tip over [src]."))
		apply_effect(30, WEAKEN)
		icon_state = icon_dead
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/list/responses = list( "[src] looks at you imploringly.",
											"[src] looks at you pleadingly.",
											"[src] looks at you with a resigned expression.",
											"[src] seems resigned to its fate.")
				to_chat(M, pick(responses))
	else
		..()

/mob/living/simple_animal/small/chick
	name = "\improper chick"
	desc = "Adorable! They make such a racket though."
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	speak = list("Chirp.","Chirp?","Chirrup.","Cheep!","Peep!")
	speak_emote = list("cheeps")
	emote_hear = list("cheeps.")
	emote_see = list("pecks at the ground.","flaps its tiny wings.", "scratches around with its foot, looking for scraps.")
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

/mob/living/simple_animal/small/chick/New()
	..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/small/chick/Life(delta_time)
	. = ..()
	if(!.)
		return
	if(stat == CONSCIOUS)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			new /mob/living/simple_animal/small/chicken(loc)
			qdel(src)

GLOBAL_VAR_INIT(MAX_CHICKENS, 50)
GLOBAL_VAR_INIT(chicken_count, 0)

/mob/living/simple_animal/small/chicken
	name = "\improper chicken"
	desc = "Hopefully the eggs are good this season."
	icon_state = "chicken"
	icon_living = "chicken"
	icon_dead = "chicken_dead"
	speak = list("Cluck!", "Bawk bwak.", "Bwarrrrk...", "Bawk!", "Bawk bawk bwak.", "BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	speak_emote = list("clucks","croons")
	emote_hear = list("clucks.")
	emote_see = list("pecks at the ground.","flaps its wings viciously.", "scratches around with its foot, looking for scraps.")
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

/mob/living/simple_animal/small/chicken/New()
	if(!body_color)
		body_color = pick( list("brown","black","white") )
	icon_state = "chicken_[body_color]"
	icon_living = "chicken_[body_color]"
	icon_dead = "chicken_[body_color]_dead"
	..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	GLOB.chicken_count++

/mob/living/simple_animal/small/chicken/death()
	..()
	GLOB.chicken_count--
	if(last_damage_data)
		var/mob/user = last_damage_data.resolve_mob()
		if(user)
			user.count_niche_stat(STATISTICS_NICHE_CHICKEN)

/mob/living/simple_animal/small/chicken/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_container/food/snacks/grown/wheat)) //feedin' dem chickens
		if(!stat && eggsleft < 8)
			user.visible_message(SPAN_NOTICE("[user] feeds [O] to [name]! It clucks happily."),SPAN_NOTICE("You feed [O] to [name]! It clucks happily."))
			user.drop_held_item()
			qdel(O)
			eggsleft += rand(1, 4)
			//world << eggsleft
		else
			to_chat(user, SPAN_NOTICE("[name] doesn't seem hungry!"))
	else
		..()

/mob/living/simple_animal/small/chicken/Life(delta_time)
	. = ..()
	if(!.)
		return
	if(stat == CONSCIOUS && prob(3) && eggsleft > 0)
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
			new /mob/living/simple_animal/small/chick(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/reagent_container/food/snacks/egg/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/mob/living/simple_animal/big/horse
	name = "horse"
	desc = "A beautiful wild horse."
	icon_state = "pony"
	icon_living = "pony"
	icon_dead = "pony_dead"
	speak = list("neighs", "winnies")
	speak_emote = list("shakes its hair.")
	emote_hear = list("neighs.")
	emote_see = list("shakes its hair.", "stomps its feet.", "swishes its tail.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_container/food/snacks/meat
	meat_amount = 6
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	buckle_flags = CAN_BUCKLE
	maxHealth = 50
	health = 50
	// Do we register a unique rider?
	var/unique_tamer = FALSE
	// The person we've been tamed by
	var/datum/weakref/my_owner
	// 1st color is body, 2nd is mane
	var/list/ponycolors = list("#cc8c5d", "#cc8c5d")

/mob/living/simple_animal/big/horse/Initialize(mapload)
	. = ..()
	apply_colour()

/mob/living/simple_animal/big/horse/death()
	. = ..()
	overlays.Cut()
	var/image/pony_hair_dead = image('icons/mob/animal.dmi', icon_state = "pony_hair_dead")
	pony_hair_dead.color = ponycolors[2]
	overlays += "pony_hair_dead"

/mob/living/simple_animal/big/horse/proc/tamed(mob/living/tamer)
	ENABLE_BITFIELD(buckle_flags, CAN_BUCKLE)
	AddElement(/datum/element/ridable, /datum/component/riding/creature/horse)
	if(unique_tamer)
		my_owner = WEAKREF(tamer)
		RegisterSignal(src, COMSIG_MOVABLE_PREBUCKLE, PROC_REF(on_prebuckle))
		stop_automated_movement = TRUE

/mob/living/simple_animal/big/horse/Destroy()
	UnregisterSignal(src, COMSIG_MOVABLE_PREBUCKLE)
	my_owner = null
	return ..()

// Only let us get ridden if the buckler is our owner, if we have a unique owner.
/mob/living/simple_animal/big/horse/proc/on_prebuckle(mob/source, mob/living/buckler, force, buckle_mob_flags)
	SIGNAL_HANDLER
	var/mob/living/tamer = my_owner?.resolve()
	if(!unique_tamer || (isnull(tamer) && unique_tamer))
		return
	if(buckler != tamer)
		manual_emote("whinnies ANGRILY!")
		return COMPONENT_BLOCK_BUCKLE

/mob/living/simple_animal/big/horse/proc/apply_colour()
	color = ponycolors[1]
	var/image/pony_hair = image('icons/mob/animal.dmi', icon_state = "pony_hair")
	pony_hair.color = ponycolors[2]
	overlays += "pony_hair"

/mob/living/simple_animal/big/horse/proc/can_mount(mob/living/user, target_mounting = FALSE)
	if(!target_mounting)
		user = pulling
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/human_pulled = user
	if(human_pulled.stat == DEAD)
		return FALSE
	return TRUE

/mob/living/simple_animal/big/horse/MouseDrop_T(atom/dropping, mob/user)
	. = ..()
	if(isxeno(user))
		return
	if(!can_mount(user, TRUE))
		return
	INVOKE_ASYNC(src, PROC_REF(carry_target), dropping, TRUE)

/mob/living/simple_animal/big/horse/proc/carry_target(mob/living/carbon/target, target_mounting = FALSE)
	if(!ismob(target))
		return
	if(target.is_mob_incapacitated())
		if(target_mounting)
			to_chat(target, SPAN_XENOWARNING("You cannot mount [src]!"))
			return
		to_chat(src, SPAN_XENOWARNING("[target] cannot mount you!"))
		return
	visible_message(SPAN_NOTICE("[target_mounting ? "[target] starts to mount [src]" : "[src] starts hoisting [target] onto [p_their()] back..."]"),
	SPAN_NOTICE("[target_mounting ? "[target] starts to mount on your back" : "You start to lift [target] onto your back..."]"))
	if(!do_after(target_mounting ? target : src, 5 SECONDS, NONE, BUSY_ICON_HOSTILE, target_mounting ? src : target))
		visible_message(SPAN_WARNING("[target_mounting ? "[target] fails to mount on [src]" : "[src] fails to carry [target]!"]"))
		return
	//Second check to make sure they're still valid to be carried
	if(target.is_mob_incapacitated())
		return
	buckle_mob(target, usr, target_hands_needed = 1)

/mob/living/simple_animal/big/horse/spec
	name = "cavalry horse"
	desc = "A horse trained for combat. Charge!!"
	unique_tamer = TRUE
	maxHealth = 300
	health = 300

/mob/living/simple_animal/big/horse/yautja
	name = "E'wun"
	desc = "It is red because it hates you"
	unique_tamer = TRUE
	maxHealth = 500
	health = 500
	ponycolors = list("#aa0000", "#444444")

/obj/item/explosive/grenade/spawnergrenade/horse
	name = "horse caller"
	spawner_type = /mob/living/simple_animal/big/horse/spec
	deliveryamt = 1
	desc = "Come to me, my steed!"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "hellnade"
	w_class = SIZE_TINY
	det_time = 30
	var/turf/activated_turf = null

/obj/item/explosive/grenade/spawnergrenade/horse/dropped(mob/user)
	check_eye(user)
	return ..()

/obj/item/explosive/grenade/spawnergrenade/horse/attack_self(mob/living/carbon/human/user)
	if(!active)
		to_chat(user, SPAN_WARNING("You activate the horse beacon!"))
		activate(user)
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.toggle_throw_mode(THROW_MODE_NORMAL)
	..()

/obj/item/explosive/grenade/spawnergrenade/horse/activate(mob/user)
	if(active)
		return

	if(user)
		msg_admin_attack("[key_name(user)] primed \a [src] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
	icon_state = initial(icon_state) + "_active"
	active = 1
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(prime), user), det_time)

/obj/item/explosive/grenade/spawnergrenade/horse/prime(mob/user)
	if(spawner_type && deliveryamt)
		// Make a quick flash
		var/turf/spawn_turf = get_turf(src)
		if(ispath(spawner_type))
			var/mob/living/simple_animal/big/horse/horse = new spawner_type(spawn_turf)
			horse.tamed(user)
		qdel(src)
		return

/obj/item/explosive/grenade/spawnergrenade/horse/Initialize()
	. = ..()

	force = 20
	throwforce = 40

/obj/item/explosive/grenade/spawnergrenade/horse/yautja
	spawner_type = /mob/living/simple_animal/big/horse/yautja

/obj/item/explosive/grenade/spawnergrenade/horse/yautja/attack_self(mob/living/carbon/human/user)
	if(!active)
		if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
			to_chat(user, SPAN_WARNING("What's this thing?"))
			return
		to_chat(user, SPAN_WARNING("You activate the horse caller!"))
		activate(user)
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.toggle_throw_mode(THROW_MODE_NORMAL)
	..()
