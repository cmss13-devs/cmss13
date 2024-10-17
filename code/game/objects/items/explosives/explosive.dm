
//explosive items (grenades, plastic c4, onetankbomb, etc)

/obj/item/explosive
	var/base_icon_state
	var/active = FALSE
	var/customizable = FALSE
	var/datum/cause_data/cause_data
	var/creator
	//Is it harmful? Are they banned for synths?
	var/harmful
	//Should it be checked by antigrief?
	var/antigrief_protection
	//Below is used for customization
	var/obj/item/device/assembly_holder/detonator = null
	var/list/obj/containers = list()
	var/list/allowed_sensors = list()
	var/list/allowed_containers = list(/obj/item/reagent_container/glass/beaker, /obj/item/reagent_container/glass/bucket, /obj/item/reagent_container/glass/bottle)
	var/max_container_volume = 120
	var/current_container_volume = 0
	var/assembly_stage = ASSEMBLY_EMPTY //The assembly_stage of the assembly
	var/list/reaction_limits = list("max_ex_power" = 175, "base_ex_falloff" = 75, "max_ex_shards" = 32,
									"max_fire_rad" = 5, "max_fire_int" = 20, "max_fire_dur" = 24,
									"min_fire_rad" = 1, "min_fire_int" = 3, "min_fire_dur" = 3
	)
	var/falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR
	/// Whether a star shape is possible when the intensity meets CHEM_FIRE_STAR_THRESHOLD
	var/allow_star_shape = TRUE
	var/use_dir = FALSE
	var/angle = 360
	var/has_blast_wave_dampener = FALSE; //Whether or not the casing can be toggle between different falloff_mode

/obj/item/explosive/Initialize()
	. = ..()
	if(!base_icon_state)
		base_icon_state = initial(icon_state)
	if(!customizable)
		return
	if(has_blast_wave_dampener)
		verbs += /obj/item/explosive/proc/toggle_blast_dampener
	create_reagents(1000)
	for(var/limit in reaction_limits)
		reagents.vars[limit] = reaction_limits[limit]

/obj/item/explosive/Destroy()
	cause_data = null
	creator = null
	QDEL_NULL(detonator)
	QDEL_NULL_LIST(containers)
	. = ..()

/obj/item/explosive/clicked(mob/user, list/mods)
	if(mods["alt"])
		if(!CAN_PICKUP(user, src))
			return ..()
		if(!has_blast_wave_dampener)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have blast wave dampening."))
			return
		toggle_blast_dampener(user)
		return
	return ..()

/obj/item/explosive/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag && (istype(target, /obj/item/device/assembly_holder) || is_type_in_list(target, allowed_sensors) || is_type_in_list(target, allowed_containers)))
		return attackby(target, user)
	return ..()

/obj/item/explosive/attack_self(mob/user)
	..()
	if(customizable && assembly_stage <= ASSEMBLY_UNLOCKED)
		if(detonator)
			detonator.detached()
			usr.put_in_hands(detonator)
			detonator=null
			assembly_stage = ASSEMBLY_EMPTY
			icon_state = base_icon_state
		else if(length(containers))
			for(var/obj/B in containers)
				if(istype(B))
					containers -= B
					user.put_in_hands(B)
			current_container_volume = 0
		desc = initial(desc) + "\n Contains [length(containers)] containers[detonator?" and detonator":""]"
		return
	cause_data = create_cause_data(initial(name), user)
	return TRUE

/obj/item/explosive/update_icon()
	if(active)
		icon_state = base_icon_state + "_active"
		return
	switch(assembly_stage)
		if(ASSEMBLY_EMPTY)
			icon_state = base_icon_state
		if(ASSEMBLY_UNLOCKED)
			if(detonator)
				icon_state = base_icon_state + "_ass"
			else
				icon_state = base_icon_state
		if(ASSEMBLY_LOCKED)
			icon_state = base_icon_state + "_locked"
		else
			icon_state = base_icon_state

/obj/item/explosive/attackby(obj/item/W as obj, mob/user as mob)
	if(!customizable || active)
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_MASTER))
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
		desc = initial(desc) + "\n Contains [length(containers)] containers[detonator?" and detonator":""]"
		update_icon()
	else if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(assembly_stage == ASSEMBLY_UNLOCKED)
			if(length(containers))
				to_chat(user, SPAN_NOTICE("You lock the assembly."))
			else
				to_chat(user, SPAN_NOTICE("You lock the empty assembly."))
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 0, 6)
			creator = user
			cause_data = create_cause_data(initial(name), user)
			assembly_stage = ASSEMBLY_LOCKED
		else if(assembly_stage == ASSEMBLY_LOCKED)
			to_chat(user, SPAN_NOTICE("You unlock the assembly."))
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 0, 6)
			desc = initial(desc) + "\n Contains [length(containers)] containers[detonator?" and detonator":""]"
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
				if(user.temp_drop_inv_item(W))
					to_chat(user, SPAN_NOTICE("You add \the [W] to the assembly."))
					W.forceMove(src)
					containers += W
					current_container_volume += W.reagents.maximum_volume
					assembly_stage = ASSEMBLY_UNLOCKED
					desc = initial(desc) + "\n Contains [length(containers)] containers[detonator?" and detonator":""]"
			else
				to_chat(user, SPAN_DANGER("\the [W] is empty."))

/obj/item/explosive/proc/activate_sensors()
	if(!detonator || active || assembly_stage < ASSEMBLY_LOCKED)
		return
	if(!isigniter(detonator.a_right))
		if(!issignaller(detonator.a_right))
			detonator.a_right.activate()
		active = TRUE
	if(!isigniter(detonator.a_left))
		if(!issignaller(detonator.a_left))
			detonator.a_left.activate()
		active = TRUE

/obj/item/explosive/proc/prime(force = FALSE)
	if(!force && (!customizable || !assembly_stage || assembly_stage < ASSEMBLY_LOCKED))
		return

	active = FALSE

	var/has_reagents = 0
	for(var/obj/item/reagent_container/glass/G in containers)
		if(G.reagents.total_volume)
			has_reagents = 1
			reagents.allow_star_shape = allow_star_shape
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

	var/mob/cause_mob = cause_data?.resolve_mob()
	if(cause_mob) //so we don't message for simulations
		reagents.source_mob = WEAKREF(cause_mob)
		msg_admin_niche("[key_name(cause_mob)] detonated custom explosive by [key_name(creator)]: [name] (REAGENTS: [reagent_list_text]) in [get_area(src)] [ADMIN_JMP(loc)]", loc.x, loc.y, loc.z)

	if(length(containers) < 2)
		reagents.trigger_volatiles = TRUE //Explode on the first transfer

	for(var/obj/item/reagent_container/glass/G in containers)
		G.reagents.trans_to(src, G.reagents.total_volume)
		i--
		if(reagents && i <= 1)
			reagents.trigger_volatiles = TRUE //So it doesn't explode before transfering the last container
	if(reagents)
		reagents.trigger_volatiles = FALSE


	if(!QDELETED(src)) //the possible reactions didn't qdel src
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

/obj/item/explosive/proc/make_copy_of(obj/item/explosive/other)
	cause_data = other.cause_data
	assembly_stage = other.assembly_stage
	falloff_mode = other.falloff_mode
	for(var/obj/item/reagent_container/other_container in other.containers)
		var/obj/item/reagent_container/new_container = new other_container.type()
		other_container.reagents.copy_to(new_container, other_container.reagents.total_volume, TRUE, TRUE, TRUE)
		containers += new_container

/obj/item/explosive/proc/toggle_blast_dampener_verb()
	set category = "Weapons"
	set name = "Toggle Blast Wave Dampener"
	set desc = "Enable/Disable the Explosive Blast Wave Dampener"
	set src in usr

	toggle_blast_dampener(usr)

/obj/item/explosive/proc/toggle_blast_dampener(mob/living/carbon/human/H)
	if(!istype(H))
		to_chat(usr, SPAN_DANGER("This is beyond your understanding..."))
		return

	if(!skillcheck(H, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(usr, SPAN_DANGER("You have no idea how to use this..."))
		return

	if(falloff_mode == EXPLOSION_FALLOFF_SHAPE_LINEAR)
		falloff_mode = EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL
		to_chat(usr, SPAN_NOTICE("You enable [src]'s blast wave dampener, limiting the blast radius."))
	else
		falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR
		to_chat(usr, SPAN_NOTICE("You disable [src]'s blast wave dampener, restoring the blast radius to full."))
	playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)

/obj/item/satchel_charge_detonator
	name = "M38-D Multipurpose Detonator"
	desc = "An ergonomic detonator capable of detonating multiple types of command explosives, notable being satchel charges, detcords and plastic explosives."
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "detonator"
	w_class = SIZE_TINY

	/// list of linked explosives to handle
	var/list/linked_charges = list()
	var/pressed = FALSE

/obj/item/satchel_charge_detonator/attack_self(mob/user, parameters) // when attackl_self, detonate charges
	. = ..()
	to_chat(user, SPAN_BOLDWARNING("You hold down the detonator button."))
	if(pressed)
		return
	pressed = TRUE
	flick("detonator_active", src)
	playsound(src.loc, 'sound/handling/charge-detonator.ogg', 25, 1)
	sleep(40)
	pressed = FALSE
	var/detonation_count = 0
	for(var/obj/item/explosive/satchel_charge/charges in linked_charges)
		if(charges.detonate(src))
			detonation_count++
	to_chat(user, SPAN_NOTICE("[src] reported [detonation_count] charge[detonation_count > 1 ? "s" : ""] detonated."))

/obj/item/satchel_charge_detonator/clicked(mob/user, list/mods)  // kill me
	if (isobserver(user) || isxeno(user))
		return

	if (mods["alt"]) // alt+click to ping charges?
		to_chat(user, SPAN_NOTICE("You ping the detonator's [length(linked_charges)] linked charges."))
		for(var/obj/item/explosive/satchel_charge/charges in linked_charges)
			flick("satchel_primed", charges)
			charges.beep(TRUE)
		return TRUE
	return

/obj/item/satchel_charge_detonator/Destroy()
	for(var/obj/item/explosive/satchel_charge/charges in linked_charges)
		charges.linked_detonator = null
	linked_charges = null
	return ..()

/obj/item/explosive/satchel_charge
	name = "M17 Satchel Charge"
	desc = "After linked to a detonator, and thrown, will become primed and able to be detonated."
	desc_lore = "The M17 is a simple satchel charge system used by Marines in situations where their usual fire support can't reach, designed to be thrown at or into structures before exploding. This one is set to automatically disarm after a short period, to reduce the chances of civilian injuries from abandoned UXO.\nTo detonate it, link the satchel charge with the included M38-D universal detonator beforehand, then throw it. The detonator's safety mechanism takes four seconds to deactivate after being thrown."
	gender = PLURAL
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "satchel"
	flags_item = NOBLUDGEON
	w_class = SIZE_SMALL
	antigrief_protection = TRUE
	max_container_volume = 180
	reaction_limits = list(	"max_ex_power" = 260,	"base_ex_falloff" = 90,	"max_ex_shards" = 64,
							"max_fire_rad" = 6,		"max_fire_int" = 26,	"max_fire_dur" = 30,
							"min_fire_rad" = 2,		"min_fire_int" = 4,		"min_fire_dur" = 5
	)

	var/prime_time  = 3 SECONDS
	var/prime_timer  = null
	var/obj/item/satchel_charge_detonator/linked_detonator = null
	var/activated = FALSE
	var/armed = FALSE

/obj/item/explosive/satchel_charge/attack_self(mob/user)
	. = ..()
	if(antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(src, user))
		to_chat(user, SPAN_WARNING("[name]'s safe-area accident inhibitor prevents you from planting it!"))
		msg_admin_niche("[key_name(user)] attempted to prime \a [name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
		return
	if(!linked_detonator)
		to_chat(user, SPAN_NOTICE("This Charge is not linked to any detonator"))
		return
	icon_state = "satchel_primed"
	playsound(src.loc, 'sound/handling/charge-primed.ogg', 25, 1)
	var/mob/living/carbon/living_carbon = user
	if(istype(living_carbon) && !living_carbon.throw_mode)
		living_carbon.toggle_throw_mode(THROW_MODE_NORMAL)
	to_chat(user, SPAN_NOTICE("You activate the M17 Satchel Charge, it will now arm itself after a short time once thrown."))
	w_class = SIZE_MASSIVE
	activated = TRUE
	addtimer(CALLBACK(src, PROC_REF(un_activate)), 10 SECONDS, TIMER_UNIQUE)

/obj/item/explosive/satchel_charge/attackby(obj/item/weapon_thing, mob/user)
	. = ..()
	if(armed)
		to_chat(user, SPAN_WARNING("This charge is armed, its linking cannot be altered unless disarmed."))
		return
	if(!istype(weapon_thing, /obj/item/satchel_charge_detonator))
		return
	var/obj/item/satchel_charge_detonator/detonator = weapon_thing
	if(linked_detonator == detonator)
		detonator.linked_charges -= src
		linked_detonator = null
		to_chat(user, SPAN_NOTICE("You unlink the charge from [detonator]."))
		icon_state = "satchel"
	else
		linked_detonator?.linked_charges -= src
		detonator.linked_charges |= src
		linked_detonator = detonator
		to_chat(user, SPAN_NOTICE("[detonator] indicates a new charge has been linked."))
		playsound(src.loc, 'sound/handling/charge-connection.ogg', 25, 1)
		icon_state = "satchel_linked"

/obj/item/explosive/satchel_charge/proc/un_activate()
	if(activated)
		activated = FALSE
		w_class = SIZE_SMALL
		if(linked_detonator)
			icon_state = "satchel_linked"
		else
			icon_state = "satchel"

/obj/item/explosive/satchel_charge/throw_atom(atom/target, range, speed, atom/thrower, spin, launch_type, pass_flags)
	. = ..()
	dir = get_dir(src, thrower)
	if(activated && linked_detonator)
		icon_state = "satchel_primed"
		prime_timer  = addtimer(CALLBACK(src, PROC_REF(arm)), prime_time, TIMER_UNIQUE)
		beep()

/obj/item/explosive/satchel_charge/proc/beep(beep_once)
	playsound(src.loc, 'sound/weapons/mine_tripped.ogg', 10, 1)
	if(!armed && beep_once != TRUE)
		addtimer(CALLBACK(src, PROC_REF(beep)), 1 SECONDS, TIMER_UNIQUE)


/obj/item/explosive/satchel_charge/proc/arm()
	activated = FALSE
	if(!linked_detonator || armed)
		return
	icon_state = "satchel_armed"
	armed = TRUE

/obj/item/explosive/satchel_charge/pickup(mob/user)
	if(armed)
		if(linked_detonator)
			icon_state = "satchel_linked"
		else
			icon_state = "satchel"
		armed = FALSE
		w_class = SIZE_SMALL
	return ..()

/obj/item/explosive/satchel_charge/proc/detonate(triggerer)
	if(!armed || linked_detonator != triggerer)
		return FALSE
	cell_explosion(loc, 120, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
	qdel(src)
	return TRUE

/obj/item/explosive/satchel_charge/Destroy()
	linked_detonator?.linked_charges -= src
	linked_detonator = null
	return ..()

