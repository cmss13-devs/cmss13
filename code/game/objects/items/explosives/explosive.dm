
//explosive items (grenades, plastique c4, onetankbomb, etc)

/obj/item/explosive
	var/active = FALSE
	var/customizable = FALSE
	var/source_mob
	var/creator
	//Below is used for customization
	var/obj/item/device/assembly_holder/detonator = null
	var/list/containers = new/list()
	var/list/allowed_sensors = list()
	var/list/allowed_containers = list(/obj/item/reagent_container/glass/beaker, /obj/item/reagent_container/glass/bucket, /obj/item/reagent_container/glass/bottle)
	var/max_container_volume = 120
	var/current_container_volume = 0
	var/assembly_stage = ASSEMBLY_EMPTY //The assembly_stage of the assembly
	var/list/reaction_limits = list("max_ex_power" = 175,	"base_ex_falloff" = 75,	"max_ex_shards" = 32,
									"max_fire_rad" = 5,		"max_fire_int" = 20,	"max_fire_dur" = 24,
									"min_fire_rad" = 1,		"min_fire_int" = 3,		"min_fire_dur" = 3
	)

/obj/item/explosive/Initialize()
	if(!customizable)
		return
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	for(var/limit in reaction_limits)
		R.vars[limit] = reaction_limits[limit]
	R.my_atom = src

/obj/item/explosive/Dispose()
	source_mob = null
	creator = null
	. = ..()

/obj/item/explosive/attack_self(mob/user as mob)
	if(customizable && assembly_stage <= ASSEMBLY_UNLOCKED)
		if(detonator)
			detonator.detached()
			usr.put_in_hands(detonator)
			detonator=null
			assembly_stage = ASSEMBLY_EMPTY
			icon_state = initial(icon_state)
		else if(containers.len)
			for(var/obj/B in containers)
				if(istype(B))
					containers -= B
					user.put_in_hands(B)
			current_container_volume = 0
		desc = initial(desc) + "\n Contains [containers.len] containers[detonator?" and detonator":""]"
		return
	source_mob = user
	return TRUE

/obj/item/explosive/update_icon()
	if(active)
		icon_state = initial(icon_state) + "_active"
		return
	switch(assembly_stage)
		if(ASSEMBLY_EMPTY)
			icon_state = initial(icon_state)
		if(ASSEMBLY_UNLOCKED)
			if(detonator)
				icon_state = initial(icon_state) + "_ass"
			else
				icon_state = initial(icon_state)
		if(ASSEMBLY_LOCKED)	
			icon_state = initial(icon_state) + "_locked"
		else
			icon_state = initial(icon_state)

/obj/item/explosive/attackby(obj/item/W as obj, mob/user as mob)
	if(!customizable || active)
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_OT))
		to_chat(user, SPAN_WARNING("You do not know how to tinker with [name]."))
		return
	if(istype(W,/obj/item/device/assembly_holder) && (!assembly_stage || assembly_stage == ASSEMBLY_UNLOCKED))
		var/obj/item/device/assembly_holder/det = W
		if(detonator)
			to_chat(user, SPAN_DANGER("This casing already has a detonator."))
			return
		if((!isigniter(det.a_left) && !isigniter(det.a_right)))
			to_chat(user, SPAN_DANGER("Assembly must contain one igniter."))
			return
		if((!(det.a_left.type in allowed_sensors) && !isigniter(det.a_left)) || (!(det.a_right.type in allowed_sensors) && !isigniter(det.a_right)))
			to_chat(user, SPAN_DANGER("Assembly contains a sensor that is incompatible with this type of casing."))
			return
		if(!det.secured)
			to_chat(user, SPAN_DANGER("Assembly must be secured with screwdriver."))
			return
		to_chat(user, SPAN_NOTICE("You add [W] to the [name]."))
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)
		user.temp_drop_inv_item(det)
		det.forceMove(src)
		detonator = det
		assembly_stage = ASSEMBLY_UNLOCKED
		desc = initial(desc) + "\n Contains [containers.len] containers[detonator?" and detonator":""]"
		update_icon()
	else if(istype(W,/obj/item/tool/screwdriver))
		if(assembly_stage == ASSEMBLY_UNLOCKED)
			if(containers.len)
				to_chat(user, SPAN_NOTICE("You lock the assembly."))
			else
				to_chat(user, SPAN_NOTICE("You lock the empty assembly."))
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 0, 6)
			creator = user
			assembly_stage = ASSEMBLY_LOCKED
		else if(assembly_stage == ASSEMBLY_LOCKED)
			to_chat(user, SPAN_NOTICE("You unlock the assembly."))
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 0, 6)
			desc = initial(desc) + "\n Contains [containers.len] containers[detonator?" and detonator":""]"
			assembly_stage = ASSEMBLY_UNLOCKED
		update_icon()
	else if(is_type_in_list(W, allowed_containers) && (!assembly_stage || assembly_stage == ASSEMBLY_UNLOCKED))
		if(current_container_volume >= max_container_volume)
			to_chat(user, SPAN_DANGER("The [name] can not hold more containers."))
			return
		else
			if(W.reagents.total_volume)
				if(W.reagents.maximum_volume + current_container_volume > max_container_volume)
					to_chat(user, SPAN_DANGER("\the [W] is too large for [name]."))
					return
				if(user.drop_held_item())
					to_chat(user, SPAN_NOTICE("You add \the [W] to the assembly."))
					W.forceMove(src)
					containers += W
					current_container_volume += W.reagents.maximum_volume 
					assembly_stage = ASSEMBLY_UNLOCKED
					desc = initial(desc) + "\n Contains [containers.len] containers[detonator?" and detonator":""]"
			else
				to_chat(user, SPAN_DANGER("\the [W] is empty."))

/obj/item/explosive/proc/activate_sensors()
	if(!detonator || active || assembly_stage < ASSEMBLY_LOCKED)
		return
	if(!isigniter(detonator.a_right))
		if(!issignaler(detonator.a_right))
			detonator.a_right.activate()
		active = TRUE
	if(!isigniter(detonator.a_left))
		if(!issignaler(detonator.a_left))
			detonator.a_left.activate()
		active = TRUE

/obj/item/explosive/proc/prime(var/force = FALSE)
	if(!force && (!customizable || !assembly_stage || assembly_stage < ASSEMBLY_LOCKED))
		return

	active = FALSE

	var/has_reagents = 0
	for(var/obj/item/reagent_container/glass/G in containers)
		if(G.reagents.total_volume)
			has_reagents = 1
			break

	if(!has_reagents)
		update_icon()
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 1)
		return

	playsound(loc, 'sound/effects/bamf.ogg', 50, 1)
	var/reagent_list_text = ""
	var/i = 0
	for(var/obj/O in containers)
		if(!O.reagents)
			continue
		for(var/datum/reagent/R in O.reagents.reagent_list)
			reagent_list_text += " [R.volume] [R.name], "
		i++
	
	if(source_mob)//so we don't message for simulations
		message_admins("[source_mob] detonated custom explosive by [creator]: [name] (REAGENTS: [reagent_list_text]) in [get_area(src)] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)", loc.x, loc.y, loc.z)

	if(containers.len < 2)
		reagents.trigger_volatiles = TRUE //Explode on the first transfer

	for(var/obj/item/reagent_container/glass/G in containers)
		G.reagents.trans_to(src, G.reagents.total_volume)
		i--
		if(reagents && i <= 1)
			reagents.trigger_volatiles = TRUE //So it doesn't explode before transfering the last container
	if(reagents)
		reagents.trigger_volatiles = FALSE
	
	
	if(!disposed) //the possible reactions didn't qdel src
		if(reagents.total_volume) //The possible reactions didnt use up all reagents.
			var/datum/effect_system/steam_spread/steam = new /datum/effect_system/steam_spread()
			steam.set_up(10, 0, get_turf(src))
			steam.attach(src)
			steam.start()

		if(iscarbon(loc))//drop dat grenade if it goes off in your hand
			var/mob/living/carbon/C = loc
			C.drop_inv_item_on_ground(src)
			C.toggle_throw_mode(THROW_MODE_OFF)

		invisibility = INVISIBILITY_MAXIMUM //Why am i doing this?
		QDEL_IN(src, 50) //To make sure all reagents can work correctly before deleting the grenade.

/obj/item/explosive/proc/make_copy_of(var/obj/item/explosive/other)
	assembly_stage = other.assembly_stage
	for(var/obj/item/reagent_container/other_container in other.containers)
		var/obj/item/reagent_container/new_container = new other_container.type()
		other_container.reagents.copy_to(new_container, other_container.reagents.total_volume, TRUE, TRUE, TRUE)
		containers += new_container
		