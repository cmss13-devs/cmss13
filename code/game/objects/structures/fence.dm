/obj/structure/fence
	name = "fence"
	desc = "A large metal mesh strewn between two poles. Intended as a cheap way to separate areas, while allowing one to see through it."
	icon = 'icons/obj/structures/props/fence.dmi'
	icon_state = "fence0"
	density = 1
	anchored = 1
	layer = WINDOW_LAYER
	flags_atom = FPRINT
	health = 50
	var/health_max = 50
	var/cut = 0 //Cut fences can be passed through
	var/junction = 0 //Because everything is terrible, I'm making this a fence-level var
	var/basestate = "fence"

/obj/structure/fence/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_THROUGH, PASS_HIGH_OVER_ONLY)

//create_debris creates debris like shards and rods. This also includes the window frame for explosions
//If an user is passed, it will create a "user smashes through the window" message. AM is the item that hits
//Please only fire this after a hit
/obj/structure/fence/proc/healthcheck(make_hit_sound = 1, create_debris = 1, mob/user, atom/movable/AM)

	if(cut) //It's broken/cut, just a frame!
		return
	if(health <= 0)
		if(user)
			user.visible_message(SPAN_DANGER("[user] smashes through [src][AM ? " with [AM]":""]!"))
		playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
		cut_grille()
	if(make_hit_sound)
		playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)

/obj/structure/fence/bullet_act(var/obj/item/projectile/Proj)
	//Tasers and the like should not damage windows.
	var/ammo_flags = Proj.ammo.flags_ammo_behavior | Proj.projectile_override_flags
	if(Proj.ammo.damage_type == HALLOSS || Proj.damage <= 0 || ammo_flags == AMMO_ENERGY)
		return 0

	health -= Proj.damage * 0.3
	..()
	healthcheck()
	return 1

/obj/structure/fence/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			health -= severity/2
			healthcheck(0, 1)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			qdel(src)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src) //Nope

/obj/structure/fence/hitby(atom/movable/AM)
	..()
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	health = max(0, health - tforce)
	healthcheck()

/obj/structure/fence/attack_hand(mob/user as mob)
	if(ishuman(user) && user.a_intent == INTENT_HARM)
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_generic(H, 25)

//Used by attack_animal
/obj/structure/fence/proc/attack_generic(mob/living/user, damage = 0)
	health -= damage
	user.animation_attack_on(src)
	user.visible_message(SPAN_DANGER("[user] smashes into [src]!"))
	healthcheck(1, 1, user)

/obj/structure/fence/attack_animal(mob/user as mob)
	if(!isanimal(user)) return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	attack_generic(M, M.melee_damage_upper)

/obj/structure/fence/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/stack/barbed_wire) && health < health_max)
		if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_ENGI))
			to_chat(user, SPAN_WARNING("You don't have the skill needed to fix [src]'s wiring."))
			return
		var/obj/item/stack/barbed_wire/R = W
		var/amount_needed = 2
		if(health)
			amount_needed = 1
		if(R.amount >= amount_needed)
			user.visible_message(SPAN_NOTICE("[user] starts repairing [src] with [R]."),
			SPAN_NOTICE("You start repairing [src] with [R]."))
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
			if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				if(R.amount < amount_needed)
					to_chat(user, SPAN_WARNING("You need more barbed wire to repair [src]."))
					return
				R.use(amount_needed)
				health = health_max
				cut = 0
				density = 1
				update_icon()
				playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] repairs [src] with [R]."),
				SPAN_NOTICE("You repair [src] with [R]."))
				return
		else
			to_chat(user, SPAN_WARNING("You need more barbed wire to repair [src]."))
			return

	if(istype(W, /obj/item/tool/wirecutters) && cut)
		user.visible_message(SPAN_NOTICE("[user] starts cutting away the remains of [src] with [W]."),
		SPAN_NOTICE("You start cutting away the remains of [src] with [W]."))
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			new /obj/item/stack/rods(loc, 10)
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] cuts away the remains of [src] with [W]."),
			SPAN_NOTICE("You cut away the remains of [src] with [W]."))
			qdel(src)
			return

	if(cut) //Cut/brokn grilles can't be messed with further than this
		return

	if(istype(W, /obj/item/grab) && get_dist(src, user) < 2)
		var/obj/item/grab/G = W
		if(istype(G.grabbed_thing, /mob/living))
			var/mob/living/M = G.grabbed_thing
			var/state = user.grab_level
			user.drop_held_item()
			switch(state)
				if(GRAB_PASSIVE)
					M.visible_message(SPAN_WARNING("[user] slams [M] against \the [src]!"))
					M.apply_damage(7)
					health -= 10
				if(GRAB_AGGRESSIVE)
					M.visible_message(SPAN_DANGER("[user] bashes [M] against \the [src]!"))
					if(prob(50))
						M.KnockDown(1)
					M.apply_damage(10)
					health -= 25
				if(GRAB_CHOKE)
					M.visible_message(SPAN_DANGER("[user] crushes [M] against \the [src]!"))
					M.KnockDown(5)
					M.apply_damage(20)
					health -= 50

			healthcheck(1, 1, M) //The person thrown into the window literally shattered it
		return

	if(W.flags_item & NOBLUDGEON) return

	if(istype(W, /obj/item/tool/wirecutters))
		user.visible_message(SPAN_NOTICE("[user] starts cutting through [src] with [W]."),
		SPAN_NOTICE("You start cutting through [src] with [W]."))
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
		if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] cuts through [src] with [W]."),
			SPAN_NOTICE("You cut through [src] with [W]."))
			cut_grille()
		return
	else
		switch(W.damtype)
			if("fire")
				health -= W.force
			if("brute")
				health -= W.force * 0.1
		healthcheck(1, 1, user, W)
		..()

/obj/structure/fence/proc/cut_grille()
	health = 0
	cut = 1
	density = 0
	update_icon() //Make it appear cut through!

/obj/structure/fence/New(Loc, start_dir = null, constructed = 0)
	..()

	if(start_dir)
		dir = start_dir

	update_nearby_icons()

/obj/structure/fence/Destroy()
	density = 0
	update_nearby_icons()
	. = ..()

/obj/structure/fence/Move()
	var/ini_dir = dir
	. = ..()
	dir = ini_dir

//This proc is used to update the icons of nearby windows.
/obj/structure/fence/proc/update_nearby_icons()
	update_icon()
	for(var/direction in cardinal)
		for(var/obj/structure/fence/W in get_step(src, direction))
			W.update_icon()

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/fence/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	//This spawn is here so windows get properly updated when one gets deleted.
	spawn(2)
		if(!src) return
		for(var/obj/structure/fence/W in orange(src, 1))
			if(abs(x - W.x) - abs(y - W.y)) //Doesn't count grilles, placed diagonally to src
				junction |= get_dir(src, W)
		if(cut)
			icon_state = "broken[basestate][junction]"
		else
			icon_state = "[basestate][junction]"

/obj/structure/fence/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 800)
		health -= round(exposed_volume / 100)
		healthcheck(0) //Don't make hit sounds, it's dumb with fire/heat
	..()
