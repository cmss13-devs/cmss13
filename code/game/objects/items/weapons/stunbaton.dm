/obj/item/weapon/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	flags_equip_slot = SLOT_WAIST
	force = 15
	throwforce = 7
	sharp = FALSE
	edge = FALSE
	w_class = SIZE_MEDIUM

	attack_verb = list("beaten")
	req_one_access = list(ACCESS_MARINE_BRIG, ACCESS_MARINE_ARMORY, ACCESS_MARINE_SENIOR, ACCESS_WY_GENERAL, ACCESS_WY_SECURITY, ACCESS_CIVILIAN_BRIG)
	var/stunforce = 50
	var/status = FALSE //whether the thing is on or not
	var/obj/item/cell/bcell = null
	var/hitcost = 1000 //oh god why do power cells carry so much charge? We probably need to make a distinction between "industrial" sized power cells for APCs and power cells for everything else.
	var/has_user_lock = TRUE //whether the baton prevents people without correct access from using it.

/obj/item/weapon/baton/suicide_act(mob/user)
	user.visible_message(SPAN_SUICIDE("[user] is putting the live [name] in \his mouth! It looks like \he's trying to commit suicide."))
	return (FIRELOSS)

/obj/item/weapon/baton/Initialize(mapload, ...)
	. = ..()
	bcell = new/obj/item/cell/high(src) //Fuckit lets givem all the good cells
	update_icon()

/obj/item/weapon/baton/Destroy()
	QDEL_NULL(bcell)
	return ..()

// legacy type, remove when able
/obj/item/weapon/baton/loaded

/obj/item/weapon/baton/proc/deductcharge(chrgdeductamt)
	if(bcell)
		if(bcell.use(chrgdeductamt))
			return TRUE
		else
			status = 0
			update_icon()
			return FALSE

/obj/item/weapon/baton/update_icon()
	if(status)
		icon_state = "[initial(icon_state)]_active"
	else if(!bcell)
		icon_state = "[initial(icon_state)]_nocell"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/weapon/baton/get_examine_text(mob/user)
	. = ..()
	if(bcell)
		. += SPAN_NOTICE("The baton is [floor(bcell.percent())]% charged.")
	else
		. += SPAN_WARNING("The baton does not have a power source installed.")

/obj/item/weapon/baton/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/cell))
		if(!bcell)
			if(user.drop_held_item())
				W.forceMove(src)
				bcell = W
				to_chat(user, SPAN_NOTICE("You install a cell in [src]."))
				update_icon()
		else
			to_chat(user, SPAN_NOTICE("[src] already has a cell."))

	else if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(src.loc))
			bcell = null
			to_chat(user, SPAN_NOTICE("You remove the cell from [src]."))
			status = 0
			update_icon()
			return
		..()

/obj/item/weapon/baton/attack_self(mob/user)
	..()

	if(has_user_lock && !skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return
	if(bcell && bcell.charge > hitcost)
		status = !status
		to_chat(user, SPAN_NOTICE("[src] is now [status ? "on" : "off"]."))
		playsound(loc, "sparks", 25, 1, 6)
		update_icon()
	else
		status = 0
		if(!bcell)
			to_chat(user, SPAN_WARNING("[src] does not have a power source!"))
		else
			to_chat(user, SPAN_WARNING("[src] is out of charge."))
	add_fingerprint(user)


/obj/item/weapon/baton/attack(mob/target, mob/user)
	var/mob/living/carbon/human/real_user = user
	var/mob/living/carbon/human/human_target = target
	if(has_user_lock && !skillcheck(real_user, SKILL_POLICE, SKILL_POLICE_SKILLED))
		if(prob(70) && status)
			to_chat(real_user, SPAN_WARNING("You hit yourself with the [src] during the struggle..."))
			real_user.drop_held_item()
			real_user.apply_effect(1,STUN)
			human_target = real_user
		if(prob(20) && !status) //a relatively reliable melee weapon when turned off.
			to_chat(real_user, SPAN_WARNING("You grab the [src] incorrectly twisting your hand in the process."))
			real_user.drop_held_item()
			real_user.apply_effect(1,STUN)
			real_user.apply_damage(force, BRUTE, pick("l_hand","r_hand"), no_limb_loss = TRUE)

	var/target_zone = check_zone(user.zone_selected)
	if(user.a_intent == INTENT_HARM)
		if (!..()) //item/attack() does it's own messaging and logs
			return FALSE // item/attack() will return TRUE if they hit, 0 if they missed.

		if(!status)
			return TRUE

	else
		//copied from human_defense.dm - human defence code should really be refactored some time.
		if (ishuman(human_target))

			if(!target_zone) //shouldn't ever happen
				human_target.visible_message(SPAN_DANGER("<B>[user] misses [human_target] with \the [src]!"))
				return FALSE

			var/mob/living/carbon/human/H = human_target
			var/obj/limb/affecting = H.get_limb(target_zone)
			if (affecting)
				if(!status)
					human_target.visible_message(SPAN_WARNING("[human_target] has been prodded in the [affecting.display_name] with [src] by [user]. Luckily it was off."))
					return TRUE
				else
					H.visible_message(SPAN_DANGER("[human_target] has been prodded in the [affecting.display_name] with [src] by [user]!"))
		else
			if(!status)
				human_target.visible_message(SPAN_WARNING("[human_target] has been prodded with [src] by [user]. Luckily it was off."))
				return TRUE
			else
				human_target.visible_message(SPAN_DANGER("[human_target] has been prodded with [src] by [user]!"))

	//stun effects

	if(!isyautja(human_target) && !isxeno(human_target)) //Xenos and Predators are IMMUNE to all baton stuns.
		human_target.emote("pain")
		human_target.apply_stamina_damage(stunforce, target_zone, ARMOR_ENERGY)
		human_target.sway_jitter(2,1)


		// Logging
		if(user == human_target)
			user.attack_log += "\[[time_stamp()]\] <b>[key_name(user)]</b> stunned themselves with [src] in [get_area(user)]"
		else
			msg_admin_attack("[key_name(user)] stunned [key_name(human_target)] with [src] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
			var/logentry = "\[[time_stamp()]\] <b>[key_name(user)]</b> stunned <b>[key_name(human_target)]</b> with [src] in [get_area(user)]"
			human_target.attack_log += logentry
			user.attack_log += logentry

	playsound(loc, 'sound/weapons/Egloves.ogg', 25, 1, 6)

	deductcharge(hitcost)

	return TRUE

/obj/item/weapon/baton/emp_act(severity)
	. = ..()
	if(bcell)
		bcell.emp_act(severity) //let's not duplicate code everywhere if we don't have to please.

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/weapon/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 40
	hitcost = 2500
	attack_verb = list("poked")
	flags_equip_slot = NO_FLAGS
	has_user_lock = FALSE
