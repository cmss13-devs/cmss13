/obj/item/weapon/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	flags_equip_slot = SLOT_WAIST
	force = 15
	sharp = 0
	edge = 0
	throwforce = 7
	w_class = SIZE_MEDIUM
	
	attack_verb = list("beaten")
	req_one_access = list(ACCESS_MARINE_BRIG, ACCESS_MARINE_ARMORY, ACCESS_MARINE_COMMANDER, ACCESS_WY_CORPORATE, ACCESS_WY_PMC_GREEN, ACCESS_CIVILIAN_BRIG)
	var/stunforce = 50
	var/status = 0		//whether the thing is on or not
	var/obj/item/cell/bcell = null
	var/hitcost = 1000	//oh god why do power cells carry so much charge? We probably need to make a distinction between "industrial" sized power cells for APCs and power cells for everything else.
	var/has_user_lock = TRUE //whether the baton prevents people without correct access from using it.

/obj/item/weapon/melee/baton/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is putting the live [name] in \his mouth! It looks like \he's trying to commit suicide.</span>")
	return (FIRELOSS)

/obj/item/weapon/melee/baton/New()
	..()
	bcell = new/obj/item/cell/high(src) //Fuckit lets givem all the good cells
	update_icon()
	return

/obj/item/weapon/melee/baton/loaded/New() //this one starts with a cell pre-installed.
	..()
	bcell = new/obj/item/cell/high(src)
	update_icon()
	return

/obj/item/weapon/melee/baton/proc/deductcharge(var/chrgdeductamt)
	if(bcell)
		if(bcell.use(chrgdeductamt))
			return 1
		else
			status = 0
			update_icon()
			return 0

/obj/item/weapon/melee/baton/update_icon()
	if(status)
		icon_state = "[initial(icon_state)]_active"
	else if(!bcell)
		icon_state = "[initial(icon_state)]_nocell"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/weapon/melee/baton/examine(mob/user)
	..()
	if(bcell)
		to_chat(user, SPAN_NOTICE("The baton is [round(bcell.percent())]% charged."))
	else
		to_chat(user, SPAN_WARNING("The baton does not have a power source installed."))

/obj/item/weapon/melee/baton/attack_hand(mob/user)
	if(check_user_auth(user))
		..()


/obj/item/weapon/melee/baton/equipped(mob/user, slot)
	..()
	check_user_auth(user)


//checks if the mob touching the baton has proper access
/obj/item/weapon/melee/baton/proc/check_user_auth(mob/user)
	if(!has_user_lock)
		return TRUE
	var/mob/living/carbon/human/H = user
	if(istype(H))
		var/obj/item/card/id/I = H.wear_id
		if(!istype(I) || !check_access(I))
			H.visible_message(SPAN_NOTICE("[src] beeeps as [H] picks it up"), SPAN_DANGER("WARNING: Unauthorized user detected. Denying access..."))
			H.KnockDown(20)
			H.visible_message(SPAN_WARNING("[src] beeps and sends a shock through [H]'s body!"))
			deductcharge(hitcost)
			add_fingerprint(user)
			return FALSE
	return TRUE

/obj/item/weapon/melee/baton/pull_response(mob/puller)
	return check_user_auth(puller)

/obj/item/weapon/melee/baton/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/cell))
		if(!bcell)
			if(user.drop_held_item())
				W.forceMove(src)
				bcell = W
				to_chat(user, SPAN_NOTICE("You install a cell in [src]."))
				update_icon()
		else
			to_chat(user, SPAN_NOTICE("[src] already has a cell."))

	else if(istype(W, /obj/item/tool/screwdriver))
		if(bcell)
			bcell.updateicon()
			bcell.forceMove(get_turf(src.loc))
			bcell = null
			to_chat(user, SPAN_NOTICE("You remove the cell from the [src]."))
			status = 0
			update_icon()
			return
		..()

/obj/item/weapon/melee/baton/attack_self(mob/user)
	if(has_user_lock && !skillcheck(user, SKILL_POLICE, SKILL_POLICE_MP))
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


/obj/item/weapon/melee/baton/attack(mob/M, mob/user)
	if(has_user_lock && !skillcheck(user, SKILL_POLICE, SKILL_POLICE_MP))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	if(isrobot(M))
		..()
		return

	var/stun = stunforce
	var/mob/living/L = M

	var/target_zone = check_zone(user.zone_selected)
	if(user.a_intent == INTENT_HARM)
		if (!..())	//item/attack() does it's own messaging and logs
			return 0	// item/attack() will return 1 if they hit, 0 if they missed.

		if(!status)
			return TRUE

	else
		//copied from human_defense.dm - human defence code should really be refactored some time.
		if (ishuman(L))
			user.lastattacked = L	//are these used at all, if we have logs?
			L.lastattacker = user

			if (user != L) // Attacking yourself can't miss
				target_zone = get_zone_with_miss_chance(user.zone_selected, L)

			if(!target_zone)
				L.visible_message(SPAN_DANGER("<B>[user] misses [L] with \the [src]!"))
				return 0

			var/mob/living/carbon/human/H = L
			var/obj/limb/affecting = H.get_limb(target_zone)
			if (affecting)
				if(!status)
					L.visible_message(SPAN_WARNING("[L] has been prodded in the [affecting.display_name] with [src] by [user]. Luckily it was off."))
					return 1
				else
					H.visible_message(SPAN_DANGER("[L] has been prodded in the [affecting.display_name] with [src] by [user]!"))
		else
			if(!status)
				L.visible_message(SPAN_WARNING("[L] has been prodded with [src] by [user]. Luckily it was off."))
				return 1
			else
				L.visible_message(SPAN_DANGER("[L] has been prodded with [src] by [user]!"))

	//stun effects

	if(!isYautja(L) && !isXeno(L)) //Xenos and Predators are IMMUNE to all baton stuns.
		L.emote("pain")
		L.apply_stamina_damage(stun, target_zone, ARMOR_ENERGY)

		// Logging
		if(user == L)
			user.attack_log += "\[[time_stamp()]\] <b>[key_name(user)]</b> stunned themselves with the [src] in [get_area(user)]"
		else
			msg_admin_attack("[key_name(user)] stunned [key_name(L)] with the [src] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
			var/logentry = "\[[time_stamp()]\] <b>[key_name(user)]</b> stunned <b>[key_name(L)]</b> with the [src] in [get_area(user)]"
			L.attack_log += logentry
			user.attack_log += logentry

	playsound(loc, 'sound/weapons/Egloves.ogg', 25, 1, 6)

	deductcharge(hitcost)

	return 1

/obj/item/weapon/melee/baton/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()

//secborg stun baton module
/obj/item/weapon/melee/baton/robot/attack_self(mob/user)
	//try to find our power cell
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		bcell = R.cell
	return ..()

/obj/item/weapon/melee/baton/robot/attackby(obj/item/W, mob/user)
	return

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/weapon/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 0
	hitcost = 2500
	attack_verb = list("poked")
	flags_equip_slot = NO_FLAGS
	has_user_lock = FALSE
