/obj/structure/fence
	name = "fence"
	desc = "A large metal mesh strewn between two poles. Intended as a cheap way to separate areas, while allowing one to see through it."
	icon = 'icons/obj/structures/props/fences/fence.dmi'
	icon_state = "fence0"
	throwpass = TRUE
	density = TRUE
	anchored = TRUE
	layer = WINDOW_LAYER
	flags_atom = FPRINT
	health = 50
	minimap_color = MINIMAP_FENCE
	var/health_max = 50
	var/cut = 0 //Cut fences can be passed through
	var/junction = 0 //Because everything is terrible, I'm making this a fence-level var
	var/basestate = "fence"
	var/forms_junctions = TRUE

/obj/structure/fence/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_THROUGH|PASS_HIGH_OVER_ONLY

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

/obj/structure/fence/bullet_act(obj/projectile/Proj)
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
		if(EXPLOSION_THRESHOLD_LOW to INFINITY)
			deconstruct(TRUE)

/obj/structure/fence/hitby(atom/movable/AM)
	..()
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce/2
	health = max(0, health - tforce)
	healthcheck()

/obj/structure/fence/attack_hand(mob/user as mob)
	if(ishuman(user) && user.a_intent == INTENT_HARM)
		var/mob/living/carbon/human/human = user
		if(human.species.can_shred(human))
			attack_generic(human, 25)

//Used by attack_animal
/obj/structure/fence/proc/attack_generic(mob/living/user, damage = 0)
	health -= damage
	user.animation_attack_on(src)
	user.visible_message(SPAN_DANGER("[user] smashes into [src]!"))
	healthcheck(1, 1, user)

/obj/structure/fence/attack_animal(mob/user as mob)
	if(!isanimal(user))
		return
	var/mob/living/simple_animal/simple = user
	if(simple.melee_damage_upper <= 0)
		return
	attack_generic(simple, simple.melee_damage_upper)

/obj/structure/fence/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/stack/barbed_wire) && health < health_max)
		if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_ENGI))
			to_chat(user, SPAN_WARNING("You don't have the skill needed to fix [src]'s wiring."))
			return
		var/obj/item/stack/barbed_wire/wire = W
		var/amount_needed = 2
		if(health)
			amount_needed = 1
		if(wire.amount >= amount_needed)
			user.visible_message(SPAN_NOTICE("[user] starts repairing [src] with [wire]."),
			SPAN_NOTICE("You start repairing [src] with [wire]."))
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
			if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				if(wire.amount < amount_needed)
					to_chat(user, SPAN_WARNING("You need more barbed wire to repair [src]."))
					return
				wire.use(amount_needed)
				health = health_max
				cut = FALSE
				density = TRUE
				update_icon()
				playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] repairs [src] with [wire]."),
				SPAN_NOTICE("You repair [src] with [wire]."))
				return
		else
			to_chat(user, SPAN_WARNING("You need more barbed wire to repair [src]."))
			return

	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) && cut)
		user.visible_message(SPAN_NOTICE("[user] starts cutting away the remains of [src] with [W]."),
		SPAN_NOTICE("You start cutting away the remains of [src] with [W]."))
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] cuts away the remains of [src] with [W]."),
			SPAN_NOTICE("You cut away the remains of [src] with [W]."))
			deconstruct()
			return

	if(cut) //Cut/brokn grilles can't be messed with further than this
		return

	if(istype(W, /obj/item/grab) && get_dist(src, user) < 2)
		var/obj/item/grab/grabby = W
		if(istype(grabby.grabbed_thing, /mob/living))
			var/mob/living/grabbed_mob = grabby.grabbed_thing
			var/state = user.grab_level
			user.drop_held_item()
			switch(state)
				if(GRAB_PASSIVE)
					grabbed_mob.visible_message(SPAN_WARNING("[user] slams [grabbed_mob] against \the [src]!"))
					grabbed_mob.apply_damage(7)
					health -= 10
				if(GRAB_AGGRESSIVE)
					grabbed_mob.visible_message(SPAN_DANGER("[user] bashes [grabbed_mob] against \the [src]!"))
					if(prob(50))
						grabbed_mob.apply_effect(1, WEAKEN)
					grabbed_mob.apply_damage(10)
					health -= 25
				if(GRAB_CHOKE)
					grabbed_mob.visible_message(SPAN_DANGER("[user] crushes [grabbed_mob] against \the [src]!"))
					grabbed_mob.apply_effect(5, WEAKEN)
					grabbed_mob.apply_damage(20)
					health -= 50

			grabbed_mob.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slammed against [src] by [key_name(user)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>slammed [key_name(grabbed_mob)] against [src]</font>")
			msg_admin_attack("[key_name(user)] slammed [key_name(grabbed_mob)] against [src] at [get_area_name(grabbed_mob)]", grabbed_mob.loc.x, grabbed_mob.loc.y, grabbed_mob.loc.z)

			healthcheck(1, 1, grabbed_mob) //The person thrown into the window literally shattered it
		return

	if(W.flags_item & NOBLUDGEON)
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) || istype(W, /obj/item/attachable/bayonet) || istype(W, /obj/item/weapon/bracer_attachment))
		user.visible_message(SPAN_NOTICE("[user] starts cutting through [src] with [W]."),
		SPAN_NOTICE("You start cutting through [src] with [W]."))
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)

		//Bayonets and Wristblades are 3/4th as effective at cutting fences
		var duration = 10 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)
		if(istype(W, /obj/item/attachable/bayonet) || istype(W, /obj/item/weapon/bracer_attachment))
			duration *= 1.5

		if(do_after(user, duration, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] cuts through [src] with [W]."),
			SPAN_NOTICE("You cut through [src] with [W]."))
			cut_grille()
		return
	else
		switch(W.damtype)
			if("fire")
				health -= W.force * W.demolition_mod
			if("brute")
				health -= W.force * W.demolition_mod * 0.1
		healthcheck(1, 1, user, W)
		. = ..()

/obj/structure/fence/deconstruct(disassembled = TRUE)
	if(disassembled)
		new /obj/item/stack/rods(loc, 10)
	return ..()

/obj/structure/fence/proc/cut_grille()
	health = 0
	cut = TRUE
	density = FALSE
	update_icon() //Make it appear cut through!

/obj/structure/fence/Initialize(mapload, start_dir = null, constructed = 0)
	. = ..()

	if(start_dir)
		setDir(start_dir)

	healthcheck()
	update_nearby_icons()

/obj/structure/fence/Destroy()
	density = FALSE
	update_nearby_icons()
	. = ..()

/obj/structure/fence/Move()
	var/ini_dir = dir
	. = ..()
	setDir(ini_dir)

//This proc is used to update the icons of nearby windows.
/obj/structure/fence/proc/update_nearby_icons()
	update_icon()
	for(var/direction in GLOB.cardinals)
		for(var/obj/structure/fence/fence in get_step(src, direction))
			if(fence.forms_junctions)
				fence.update_icon()

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/fence/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	//This spawn is here so windows get properly updated when one gets deleted.
	spawn(2)
		if(!src)
			return
		for(var/obj/structure/fence/fence in orange(src, 1))
			if(!fence.forms_junctions)
				continue
			if(abs(x - fence.x) - abs(y - fence.y)) //Doesn't count grilles, placed diagonally to src
				junction |= get_dir(src, fence)
		if(cut)
			icon_state = "broken[basestate][junction]"
		else
			icon_state = "[basestate][junction]"

/obj/structure/fence/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 800)
		health -= floor(exposed_volume / 100)
		healthcheck(0) //Don't make hit sounds, it's dumb with fire/heat
	..()

GLOBAL_LIST_INIT(all_electric_fences, list())

// Hybrisa Electric Fence

/obj/structure/fence/electrified
	name = "electrified grille"
	desc = "A dark reinforced mesh grille with warning stripes, equipped with Tesla-like coils to regulate high voltage current. It is highly electrified and dangerous when powered."
	icon = 'icons/obj/structures/props/hybrisa/piping_wiring.dmi'
	icon_state = "highvoltagegrille_off"
	basestate = "highvoltagegrille"
	throwpass = TRUE
	unacidable = TRUE
	health = 150
	health_max = 200
	forms_junctions = FALSE
	var/electrified = FALSE
	var/obj/structure/machinery/colony_floodlight_switch/electrified_fence_switch/breaker_switch = null

/obj/structure/fence/electrified/hitby(atom/movable/AM)
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		if(electrified && !cut)
			electrocute_mob(AM, get_area(breaker_switch), src, 2.25)
		else
			tforce = 40
	else if(isobj(AM))
		var/obj/item/zapped_item = AM
		tforce = zapped_item.throwforce
	health = max(0, health - tforce)
	healthcheck()

/obj/structure/fence/electrified/update_nearby_icons()
	return

/obj/structure/fence/electrified/update_icon()
	if(cut)
		icon_state = "[basestate]_broken"
	else
		if(electrified)
			icon_state = "[basestate]"
		else
			icon_state = "[basestate]_off"

/obj/structure/fence/electrified/proc/toggle_power()
	electrified = !electrified
	update_icon()

/obj/structure/fence/electrified/Initialize()
	. = ..()
	GLOB.all_electric_fences += src

/obj/structure/fence/electrified/Destroy()
	GLOB.all_electric_fences -= src
	return ..()

/obj/structure/fence/electrified/attackby(obj/item/W, mob/user)
	if(electrified && !cut)
		electrocute_mob(user, get_area(breaker_switch), src, 2.25)
	return ..()

/obj/structure/fence/electrified/ex_act(severity)
	health -= severity/2
	healthcheck(make_hit_sound = FALSE, create_debris = TRUE)

/obj/structure/fence/dark
	name = "fence"
	desc = "A large metal mesh strewn between two poles. Intended as a cheap way to separate areas, while allowing one to see through it."
	icon = 'icons/obj/structures/props/fences/dark_fence.dmi'

/obj/structure/fence/dark/warning
	name = "fence"
	desc = "A large metal mesh strewn between two poles. Intended as a cheap way to separate areas, while allowing one to see through it."
	icon = 'icons/obj/structures/props/fences/electric_fence.dmi'
