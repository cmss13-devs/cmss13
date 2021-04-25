#define MIN_IMPREGNATION_TIME 10 SECONDS //Time it takes to impregnate someone
#define MAX_IMPREGNATION_TIME 15 SECONDS

#define MIN_ACTIVE_TIME 5 SECONDS //Time between being dropped and going idle
#define MAX_ACTIVE_TIME 15 SECONDS

/obj/item/clothing/mask/facehugger
	name = "facehugger"
	desc = "It has some sort of a tube at the end of its tail."
	icon_state = "facehugger"
	item_state = "facehugger"
	w_class = SIZE_TINY //Note: can be picked up by aliens unlike most other items of w_class below 4
	flags_inventory = COVEREYES|ALLOWINTERNALS|COVERMOUTH|ALLOWREBREATH|CANTSTRIP
	flags_armor_protection = BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_atom = NO_FLAGS
	flags_item = NOBLUDGEON
	throw_range = 1
	layer = FACEHUGGER_LAYER

	var/stat = CONSCIOUS //UNCONSCIOUS is the idle state in this case
	var/sterile = FALSE
	var/strength = 5
	var/attached = FALSE
	var/leaping = FALSE //Is actually attacking someone?
	var/hivenumber = XENO_HIVE_NORMAL
	var/flags_embryo = NO_FLAGS
	var/impregnated = FALSE

	/// The timer for the hugger to jump
	/// at the nearest human
	var/jump_timer
	/// Delay of time between the hugger jumping
	/// at the nearest human
	var/time_between_jumps = 5 SECONDS
	/// How many times the hugger will try to jump at
	/// the nearest human before dying
	var/jumps_left = 2

/obj/item/clothing/mask/facehugger/Initialize(mapload, hive)
	. = ..()
	icon = get_icon_from_source(CONFIG_GET(string/alien_effects))
	if (hive)
		hivenumber = hive

	set_hive_data(src, hivenumber)
	go_active()

/obj/item/clothing/mask/facehugger/Destroy()
	. = ..()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		M.temp_drop_inv_item(src)
	if(jump_timer)
		deltimer(jump_timer)
	jump_timer = null

/obj/item/clothing/mask/facehugger/ex_act(severity)
	die()

/obj/item/clothing/mask/facehugger/dropped()
	. = ..()
	// dropped is called by `Destroy`, which leads
	// to issues with timers
	if(QDESTROYING(src))
		return
	addtimer(CALLBACK(src, .proc/check_turf), 0.2 SECONDS)
	if(stat == CONSCIOUS && loc) //Make sure we're conscious and not idle or dead.
		go_idle()

/obj/item/clothing/mask/facehugger/proc/check_turf()
	var/count = 0
	for(var/obj/item/clothing/mask/facehugger/F in get_turf(src))
		if(F.stat == CONSCIOUS)
			count++
		if(count > 2) //Was 5, our rules got much tighter
			visible_message(SPAN_XENOWARNING("The facehugger is furiously cannibalized by the nearby horde of other ones!"))
			qdel(src)
			return

/obj/item/clothing/mask/facehugger/attack_hand(var/mob/user)
	if(stat != DEAD)
		if(!sterile && can_hug(user, hivenumber))
			attach(user)
		//If we're alive, don't let them pick us up, even if attach fails. Just return.
		if(!isXeno(user))
			return
	return ..()

//Deal with picking up facehuggers. "attack_alien" is the universal 'xenos click something while unarmed' proc.
/obj/item/clothing/mask/facehugger/attack_alien(mob/living/carbon/Xenomorph/user)
	if(user.hivenumber != hivenumber)
		user.animation_attack_on(src)
		user.visible_message(SPAN_XENOWARNING("[user] crushes \the [src]"), SPAN_XENOWARNING("You crush \the [src]"))
		die()
		return XENO_ATTACK_ACTION

	if(user.caste.can_hold_facehuggers)
		if(user.on_fire)
			to_chat(user, SPAN_WARNING("Touching \the [src] while you're on fire would burn it!"))
		else
			// TODO: Refactor how pickups work so you do not need to go through attack_hand
			attack_hand(user)//Not a carrier, or already full? Just pick it up.
		return XENO_NO_DELAY_ACTION

/obj/item/clothing/mask/facehugger/attack(mob/M, mob/user)
	if(!can_hug(M, hivenumber) || !(M.is_mob_incapacitated() || M.lying || M.buckled && !isYautja(M)))
		to_chat(user, SPAN_WARNING("The facehugger refuses to attach."))
		..()
		return

	// Guaranteed to work because of can_hug
	var/mob/living/carbon/human/H = M
	var/datum/species/S = H.species

	if(!S || S.timed_hug)
		if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, M, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return

		if(!can_hug(M, hivenumber) || !(M.is_mob_incapacitated() || M.lying || M.buckled))
			return

	attach(M)
	user.update_icons()

// TODO: make this use signals
/obj/item/clothing/mask/facehugger/attack_self(mob/user)
	if(isXenoCarrier(user))
		var/mob/living/carbon/Xenomorph/Carrier/C = user
		C.store_hugger(src)

/obj/item/clothing/mask/facehugger/examine(mob/user)
	..()
	switch(stat)
		if(DEAD, UNCONSCIOUS)
			to_chat(user, SPAN_DANGER("[src] is not moving."))
		if(CONSCIOUS)
			to_chat(user, SPAN_DANGER("[src] seems to be active."))
	if(sterile)
		to_chat(user, SPAN_DANGER("It looks like the proboscis has been removed."))

/obj/item/clothing/mask/facehugger/attackby(obj/item/W, mob/user)
	if(W.flags_item & NOBLUDGEON)
		return
	die()

/obj/item/clothing/mask/facehugger/bullet_act(obj/item/projectile/P)
	..()
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO_ACID|AMMO_XENO_TOX))
		return //Xeno spits ignore huggers.
	if(P.damage)
		die()
	P.ammo.on_hit_obj(src, P)
	return TRUE

/obj/item/clothing/mask/facehugger/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		die()

/obj/item/clothing/mask/facehugger/equipped(mob/M)
	SHOULD_CALL_PARENT(FALSE) // ugh equip sounds
	// So getting hugged or picking up a hugger does not
	// prematurely kill the hugger
	go_idle()

/obj/item/clothing/mask/facehugger/Crossed(atom/target)
	has_proximity(target)

/obj/item/clothing/mask/facehugger/on_found(mob/finder)
	return has_proximity(finder)

/obj/item/clothing/mask/facehugger/proc/has_proximity(atom/movable/AM)
	if(stat == CONSCIOUS && can_hug(AM, hivenumber))
		attach(AM)
		return TRUE
	return FALSE

/obj/item/clothing/mask/facehugger/launch_towards(var/datum/launch_metadata/LM)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_thrown"

/obj/item/clothing/mask/facehugger/launch_impact(atom/hit_atom)
	. = ..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]"
	leaping = FALSE

/obj/item/clothing/mask/facehugger/mob_launch_collision(mob/living/L)
	if(stat == DEAD)
		..()
		return

	if(stat == UNCONSCIOUS)
		return

	if(leaping && can_hug(L, hivenumber))
		attach(L)
	else if(L.density)
		step(src, turn(dir, 180)) //We want the hugger to bounce off if it hits a mob.
		go_idle()



/obj/item/clothing/mask/facehugger/proc/leap_at_nearest_target()
	if(!isturf(loc))
		return

	for(var/mob/living/M in loc)
		if(can_hug(M, hivenumber))
			attach(M)
			return

	var/mob/living/target
	for(var/mob/living/M in view(3, src))
		if(!can_hug(M, hivenumber))
			continue
		target = M
		break
	if(!target)
		return

	target.visible_message(SPAN_WARNING("\The scuttling [src] leaps at [target]!"), \
	SPAN_WARNING("The scuttling [src] leaps at [target]!"))
	leaping = TRUE
	throw_atom(target, 3, SPEED_FAST)

/obj/item/clothing/mask/facehugger/proc/attach(mob/living/M)
	if(attached || !can_hug(M, hivenumber))
		return

	// This is always going to be valid because of the can_hug check above
	var/mob/living/carbon/human/H = M
	attached = TRUE
	H.visible_message(SPAN_DANGER("[src] leaps at [H]'s face!"))

	if(isXeno(loc)) //Being carried? Drop it
		var/mob/living/carbon/Xenomorph/X = loc
		X.drop_inv_item_on_ground(src)

	if(isturf(H.loc))
		forceMove(H.loc)//Just checkin

	if(!H.handle_hugger_attachment(src))
		return

	forceMove(H)
	icon_state = initial(icon_state)
	H.equip_to_slot(src, WEAR_FACE)
	H.update_inv_wear_mask()
	H.disable_lights()
	H.disable_special_items()
	if(isHumanStrict(H))
		playsound(loc, H.gender == "male" ? 'sound/misc/facehugged_male.ogg' : 'sound/misc/facehugged_female.ogg' , 25, 0)
	if(!sterile)
		if(!H.species || !(H.species.flags & IS_SYNTHETIC)) //synthetics aren't paralyzed
			H.KnockOut(MIN_IMPREGNATION_TIME * 0.5, TRUE) //THIS MIGHT NEED TWEAKS

	addtimer(CALLBACK(src, .proc/impregnate, H), rand(MIN_IMPREGNATION_TIME, MAX_IMPREGNATION_TIME))

/obj/item/clothing/mask/facehugger/proc/impregnate(mob/living/carbon/human/target)
	if(!target || target.wear_mask != src) //Was taken off or something
		return
	if(SEND_SIGNAL(target, COMSIG_HUMAN_IMPREGNATE, src) & COMPONENT_NO_IMPREGNATE)
		return //can't impregnate synthetics
	if(!sterile)
		var/embryos = 0
		for(var/obj/item/alien_embryo/embryo in target) // already got one, stops doubling up
			if(embryo.hivenumber == hivenumber)
				embryos++
			else
				qdel(embryo)
		if(!embryos)
			var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(target)
			embryo.hivenumber = hivenumber

			embryo.flags_embryo = flags_embryo
			flags_embryo = NO_FLAGS

			if(target.species)
				target.species.larva_impregnated(embryo)

			icon_state = "[initial(icon_state)]_impregnated"
			impregnated = TRUE
		target.visible_message(SPAN_DANGER("[src] falls limp after violating [target]'s face!"))
		die()
	else
		target.visible_message(SPAN_DANGER("[src] violates [target]'s face!"))

	if(round_statistics && ishuman(target))
		round_statistics.total_huggers_applied++

/obj/item/clothing/mask/facehugger/proc/go_active()
	if(stat == DEAD)
		return

	if(stat != CONSCIOUS)
		icon_state = "[initial(icon_state)]"
	stat = CONSCIOUS
	jump_timer = addtimer(CALLBACK(src, .proc/try_jump), time_between_jumps, TIMER_OVERRIDE|TIMER_STOPPABLE|TIMER_UNIQUE)

/obj/item/clothing/mask/facehugger/proc/go_idle() //Idle state does not count toward the death timer.
	if(stat == DEAD || stat == UNCONSCIOUS)
		return

	stat = UNCONSCIOUS
	icon_state = "[initial(icon_state)]_inactive"
	if(jump_timer)
		deltimer(jump_timer)
	jump_timer = null
	// Reset the jumps left to their original count
	jumps_left = initial(jumps_left)
	addtimer(CALLBACK(src, .proc/go_active), rand(MIN_ACTIVE_TIME,MAX_ACTIVE_TIME))

/obj/item/clothing/mask/facehugger/proc/try_jump()
	jump_timer = addtimer(CALLBACK(src, .proc/try_jump), time_between_jumps, TIMER_OVERRIDE|TIMER_STOPPABLE|TIMER_UNIQUE)
	if(stat != CONSCIOUS || isnull(loc)) //Make sure we're conscious and not idle or dead.
		return

	leap_at_nearest_target()
	jumps_left--
	if(!jumps_left)
		end_lifecycle()
		return

/obj/item/clothing/mask/facehugger/proc/end_lifecycle()
	// Cleanup timer id
	jump_timer = null

	if(isturf(loc))
		var/obj/effect/alien/egg/E = locate() in loc
		if(E && E.status == EGG_BURST)
			visible_message(SPAN_XENOWARNING("[src] crawls back into [E]!"))
			E.status = EGG_GROWN
			E.icon_state = "Egg"
			E.deploy_egg_triggers()
			qdel(src)
			return
		var/obj/effect/alien/resin/trap/T = locate() in loc
		if(T && T.trap_type == RESIN_TRAP_EMPTY)
			visible_message(SPAN_XENOWARNING("[src] crawls into [T]!"))
			T.hivenumber = hivenumber
			T.set_state(RESIN_TRAP_HUGGER)
			qdel(src)
			return
		var/obj/effect/alien/resin/special/eggmorph/M = locate() in loc
		if(istype(M) && M.stored_huggers < M.huggers_to_grow_max)
			visible_message(SPAN_XENOWARNING("[src] crawls back into [M]!"))
			M.stored_huggers++
			qdel(src)
			return
	die()

/obj/item/clothing/mask/facehugger/proc/die()
	if(stat == DEAD)
		return

	if(jump_timer)
		deltimer(jump_timer)
	jump_timer = null

	if(!impregnated)
		icon_state = "[initial(icon_state)]_dead"
	stat = DEAD

	visible_message("[icon2html(src, viewers(src))] <span class='danger'>\The [src] curls up into a ball!</span>")
	playsound(src.loc, 'sound/voice/alien_facehugger_dies.ogg', 25, 1)

	if(ismob(loc)) //Make it fall off the person so we can update their icons. Won't update if they're in containers thou
		var/mob/M = loc
		M.drop_inv_item_on_ground(src)

	layer = BELOW_MOB_LAYER //so dead hugger appears below live hugger if stacked on same tile.

	addtimer(CALLBACK(src, .proc/decay), 3 MINUTES)

/obj/item/clothing/mask/facehugger/proc/decay()
	visible_message("[icon2html(src, viewers(src))] <span class='danger'>\The [src] decays into a mass of acid and chitin.</span>")
	qdel(src)

/proc/can_hug(mob/living/carbon/M, var/hivenumber)
	if(!istype(M) || isXeno(M) || isSynth(M) || iszombie(M) || isHellhound(M) || M.stat == DEAD || (M.huggable == FALSE))
		return FALSE

	if(M.ally_of_hivenumber(hivenumber))
		return FALSE

	if(M.status_flags & XENO_HOST)
		for(var/obj/item/alien_embryo/embryo in M)
			if(embryo.hivenumber == hivenumber)
				return FALSE

	//Already have a hugger? NOPE
	//This is to prevent eggs from bursting all over if you walk around with one on your face,
	//or an unremovable mask.
	if(M.wear_mask)
		var/obj/item/W = M.wear_mask
		if(W.flags_item & NODROP)
			return FALSE
		if(istype(W, /obj/item/clothing/mask/facehugger))
			var/obj/item/clothing/mask/facehugger/hugger = W
			if(hugger.stat != DEAD)
				return FALSE

	return TRUE

/obj/item/clothing/mask/facehugger/flamer_fire_act()
	die()

/**
 * Human hugger handling
 */

/mob/living/carbon/human/proc/handle_hugger_attachment(obj/item/clothing/mask/facehugger/hugger)
	var/can_infect = TRUE
	if(!has_limb("head"))
		hugger.visible_message(SPAN_WARNING("[hugger] looks for a face to hug on [src], but finds none!"))
		hugger.go_idle()
		return FALSE

	if(species && !species.handle_hugger_attachment(src, hugger))
		return FALSE

	if(head && !(head.flags_item & NODROP))
		var/obj/item/clothing/head/D = head
		if(istype(D))
			if(D.anti_hug > 1)
				visible_message(SPAN_DANGER("[hugger] smashes against [src]'s [D.name]!"))
				D.anti_hug = max(0, --D.anti_hug)
				if(prob(15)) // 15% chance the hugger will go idle after ripping off a helmet. Otherwise it will keep going.
					hugger.go_idle()
					return FALSE
				can_infect = FALSE
			else
				visible_message(SPAN_DANGER("[hugger] smashes against [src]'s [D.name] and rips it off!"))
				drop_inv_item_on_ground(D)
				if(istype(D, /obj/item/clothing/head/helmet/marine)) //Marine helmets now get a fancy overlay.
					var/obj/item/clothing/head/helmet/marine/m_helmet = D
					m_helmet.add_hugger_damage()
				update_inv_head()

	if(!wear_mask)
		return can_infect

	var/obj/item/clothing/mask/W = wear_mask
	if(istype(W))
		if(W.flags_item & NODROP)
			return FALSE

		if(istype(W, /obj/item/clothing/mask/facehugger))
			var/obj/item/clothing/mask/facehugger/FH = W
			if(FH.stat != DEAD)
				return FALSE

		if(W.anti_hug > 1)
			visible_message(SPAN_DANGER("[hugger] smashes against [src]'s [W.name]!"))
			W.anti_hug = max(0, --W.anti_hug)
			if(prob(15)) //15% chance the hugger will go idle after ripping off a mask. Otherwise it will keep going.
				hugger.go_idle()
				return FALSE
			can_infect = FALSE
		else
			visible_message(SPAN_DANGER("[hugger] smashes against [src]'s [W.name] and rips it off!"))
			drop_inv_item_on_ground(W)

	return can_infect

/datum/species/proc/handle_hugger_attachment(mob/living/carbon/human/target, obj/item/clothing/mask/facehugger/hugger)
	return TRUE

/datum/species/yautja/handle_hugger_attachment(mob/living/carbon/human/target, obj/item/clothing/mask/facehugger/hugger)
	var/catch_chance = 50
	if(target.dir == reverse_dir[hugger.dir])
		catch_chance += 20
	if(target.lying)
		catch_chance -= 50
	catch_chance -= ((target.maxHealth - target.health) / 3)
	if(target.get_active_hand())
		catch_chance  -= 25
	if(target.get_inactive_hand())
		catch_chance  -= 25

	if(!target.stat && target.dir != hugger.dir && prob(catch_chance)) //Not facing away
		target.visible_message(SPAN_NOTICE("[target] snatches [hugger] out of the air and squashes it!"))
		hugger.die()
		return FALSE

	return TRUE
