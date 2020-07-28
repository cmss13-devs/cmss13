//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//TODO: Make these simple_animals

#define MIN_IMPREGNATION_TIME 100 //Time it takes to impregnate someone
#define MAX_IMPREGNATION_TIME 150

#define MIN_ACTIVE_TIME 50 //Time between being dropped and going idle
#define MAX_ACTIVE_TIME 150

/obj/item/clothing/mask/facehugger
	name = "alien"
	desc = "It has some sort of a tube at the end of its tail."
	icon = 'icons/mob/xenos/Effects.dmi'
	icon_state = "facehugger"
	item_state = "facehugger"
	w_class = SIZE_TINY //Note: can be picked up by aliens unlike most other items of w_class below 4
	flags_inventory = COVEREYES|ALLOWINTERNALS|COVERMOUTH|ALLOWREBREATH|CANTSTRIP
	flags_armor_protection = BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_atom = NO_FLAGS
	flags_item = NOBLUDGEON
	throw_range = 1
	layer = ABOVE_MOB_LAYER

	var/stat = CONSCIOUS //UNCONSCIOUS is the idle state in this case
	var/sterile = 0
	var/strength = 5
	var/attached = 0
	var/lifecycle = 300 //How long the hugger will survive outside of the egg, or carrier.
	var/leaping = 0 //Is actually attacking someone?
	var/hivenumber = XENO_HIVE_NORMAL
	var/flags_embryo = NO_FLAGS

/obj/item/clothing/mask/facehugger/Initialize(loc, hive)
	. = ..()
	if (hive)
		hivenumber = hive

	set_hive_data(src, hivenumber)
	GoActive()

/obj/item/clothing/mask/facehugger/Dispose()
	. = ..()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		M.temp_drop_inv_item(src)

/obj/item/clothing/mask/facehugger/ex_act(severity)
	Die()

/obj/item/clothing/mask/facehugger/dropped()
	set waitfor = 0
	sleep(2)
	var/obj/item/clothing/mask/facehugger/F
	var/count = 0
	for(F in get_turf(src))
		if(F.stat == CONSCIOUS) count++
		if(count > 2) //Was 5, our rules got much tighter
			visible_message(SPAN_XENOWARNING("The facehugger is furiously cannibalized by the nearby horde of other ones!"))
			qdel(src)
			return
	if(stat == CONSCIOUS && loc) //Make sure we're conscious and not idle or dead.
		GoIdle()
		check_lifecycle()

/obj/item/clothing/mask/facehugger/attack_hand(var/mob/user)

	if(stat != DEAD && !sterile)
		if(CanHug(user, hivenumber))
			Attach(user) //If we're alive, don't let them pick us up even if this fails. Just return.
			return
	if(!isXeno(user) && stat != DEAD)
		return

	return ..()

//Deal with picking up facehuggers. "attack_alien" is the universal 'xenos click something while unarmed' proc.
/obj/item/clothing/mask/facehugger/attack_alien(mob/living/carbon/Xenomorph/user)
	if(user.hivenumber != hivenumber)
		user.animation_attack_on(src)
		user.visible_message(SPAN_XENOWARNING("[user] crushes \the [src]"), SPAN_XENOWARNING("You crush \the [src]"))
		Die()
		return

	if(user.caste.can_hold_facehuggers)
		if(user.on_fire)
			to_chat(user, SPAN_WARNING("Touching \the [src] while you're on fire would burn it!"))
			return
		attack_hand(user)//Not a carrier, or already full? Just pick it up.

/obj/item/clothing/mask/facehugger/attack(mob/M, mob/user)
	if(!(CanHug(M, hivenumber) && (M.is_mob_incapacitated() || M.lying || M.buckled && !isYautja(M))))
		to_chat(user, SPAN_WARNING("The facehugger refuses to attach."))
		..()
		return

	var/datum/species/S
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		S = H.species

	if(!S || S.timed_hug )
		if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_HOSTILE, M, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return

		if(!(CanHug(M, hivenumber) && (M.is_mob_incapacitated() || M.lying || M.buckled)))
			return

	Attach(M)
	user.update_icons()

/obj/item/clothing/mask/facehugger/attack_self(mob/user)
	if(isXenoCarrier(user))
		var/mob/living/carbon/Xenomorph/Carrier/C = user
		C.store_hugger(src)

/obj/item/clothing/mask/facehugger/examine(mob/user)
	..()
	switch(stat)
		if(DEAD, UNCONSCIOUS) to_chat(user, SPAN_DANGER("[src] is not moving."))
		if(CONSCIOUS) to_chat(user, SPAN_DANGER("[src] seems to be active."))
	if(sterile)
		to_chat(user, SPAN_DANGER("It looks like the proboscis has been removed."))

/obj/item/clothing/mask/facehugger/attackby(obj/item/W, mob/user)
	if(W.flags_item & NOBLUDGEON) return
	Die()

/obj/item/clothing/mask/facehugger/bullet_act(obj/item/projectile/P)
	..()
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO_ACID|AMMO_XENO_TOX)) return //Xeno spits ignore huggers.
	if(P.damage) Die()
	P.ammo.on_hit_obj(src,P)
	return 1

/obj/item/clothing/mask/facehugger/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		Die()

/obj/item/clothing/mask/facehugger/equipped(mob/M)
	return

/obj/item/clothing/mask/facehugger/Crossed(atom/target)
	HasProximity(target)

/obj/item/clothing/mask/facehugger/on_found(mob/finder)
	HasProximity(finder)
	return 1

/obj/item/clothing/mask/facehugger/HasProximity(atom/movable/AM)
	if(stat == CONSCIOUS && CanHug(AM, hivenumber))
		Attach(AM)

/obj/item/clothing/mask/facehugger/launch_towards(var/datum/launch_metadata/LM)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_thrown"
		reset_thrown_icon(LM.range)
		if(LM.range < 2)
			if(check_lifecycle()) GoIdle() //To prevent throwing huggers, then having them leap out.
			//Otherwise it will just die.

/obj/item/clothing/mask/facehugger/proc/reset_thrown_icon(range)
	set waitfor = 0
	sleep(range * 3 + 1)
	if(loc && icon_state == "[initial(icon_state)]_thrown")
		icon_state = "[initial(icon_state)]"
	leaping = 0

/obj/item/clothing/mask/facehugger/launch_impact(atom/hit_atom)
	set waitfor = 0
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]"
	if(ismob(hit_atom) && stat != DEAD)
		if(stat == CONSCIOUS)
			if(leaping && CanHug(hit_atom, hivenumber))
				Attach(hit_atom)
			else if(hit_atom.density)
				stat = UNCONSCIOUS //Giving it some brief downtime before jumping on someone via movement.
				icon_state = "[initial(icon_state)]_inactive"
				step(src, turn(dir, 180)) //We want the hugger to bounce off if it hits a mob.
				throwing = 0
				sleep(15) //1.5 seconds.
				if(loc && stat != DEAD)
					stat = CONSCIOUS
					icon_state = "[initial(icon_state)]"
				return
		throwing = 0
		return
	else
		..()


/obj/item/clothing/mask/facehugger/proc/reset_attach_status()
	set waitfor = 0
	sleep(MAX_IMPREGNATION_TIME)
	attached = 0

/obj/item/clothing/mask/facehugger/proc/leap_at_nearest_target()
	if(!isturf(loc))
		return
	for(var/mob/living/M in view(3, src))
		if(CanHug(M, hivenumber))
			M.visible_message(SPAN_WARNING("\The scuttling [src] leaps at [M]!"), \
			SPAN_WARNING("The scuttling [src] leaps at [M]!"))
			leaping = TRUE
			throw_atom(M, 3, SPEED_FAST)
			break

	if(attached) //Didn't hit anything?
		return

	for(var/mob/living/M in loc)
		if(CanHug(M, hivenumber))
			Attach(M)
			break

/obj/item/clothing/mask/facehugger/proc/Attach(mob/living/M)
	set waitfor = 0

	if(attached || !CanHug(M, hivenumber) || isXeno(M) || iszombie(M) || loc == M || stat == DEAD)
		return

	attached++
	reset_attach_status()
	M.visible_message(SPAN_DANGER("[src] leaps at [M]'s face!"))
	if(throwing) 
		throwing = FALSE

	if(isXeno(loc)) //Being carried? Drop it
		var/mob/living/carbon/Xenomorph/X = loc
		X.drop_inv_item_on_ground(src)
		X.update_icons()

	if(isturf(M.loc))
		loc = M.loc //Just checkin

	var/cannot_infect //To determine if the hugger just rips off the protection or can infect.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		if(!H.has_limb("head"))
			visible_message(SPAN_WARNING("[src] looks for a face to hug on [H], but finds none!"))
			GoIdle()
			return

		if(isYautja(M))
			var/catch_chance = 50
			if(H.dir == reverse_dir[dir]) catch_chance += 20
			if(H.lying) catch_chance -= 50
			catch_chance -= ((H.maxHealth - H.health) / 3)
			if(H.get_active_hand()) catch_chance  -= 25
			if(H.get_inactive_hand()) catch_chance  -= 25

			if(!H.stat && H.dir != dir && prob(catch_chance)) //Not facing away
				H.visible_message(SPAN_NOTICE("[H] snatches [src] out of the air and squashes it!"))
				Die()
				loc = H.loc
				return

		if(H.head && !(H.head.flags_item & NODROP))
			var/obj/item/clothing/head/D = H.head
			if(istype(D))
				if(D.anti_hug > 1)
					H.visible_message("<span class='danger'>[src] smashes against [H]'s [D.name]!")
					cannot_infect = 1
				else
					H.visible_message("<span class='danger'>[src] smashes against [H]'s [D.name] and rips it off!")
					H.drop_inv_item_on_ground(D)
					if(istype(D, /obj/item/clothing/head/helmet/marine)) //Marine helmets now get a fancy overlay.
						var/obj/item/clothing/head/helmet/marine/m_helmet = D
						m_helmet.add_hugger_damage()
					H.update_inv_head()

				if(D.anti_hug && prob(15)) //15% chance the hugger will go idle after ripping off a helmet. Otherwise it will keep going.
					D.anti_hug = max(0, --D.anti_hug)
					GoIdle()
					return
				D.anti_hug = max(0, --D.anti_hug)

	if(iscarbon(M))
		var/mob/living/carbon/target = M

		if(target.wear_mask)
			var/obj/item/clothing/mask/W = target.wear_mask
			if(istype(W))
				if(W.flags_item & NODROP) return

				if(istype(W, /obj/item/clothing/mask/facehugger))
					var/obj/item/clothing/mask/facehugger/hugger = W
					if(hugger.stat != DEAD) return

				if(W.anti_hug > 1)
					target.visible_message(SPAN_DANGER("[src] smashes against [target]'s [W.name]!"))
					cannot_infect = 1
				else
					target.visible_message(SPAN_DANGER("[src] smashes against [target]'s [W.name] and rips it off!"))
					target.drop_inv_item_on_ground(W)
				if(W.anti_hug && prob(15)) //15% chance the hugger will go idle after ripping off a helmet. Otherwise it will keep going.
					W.anti_hug = max(0, --W.anti_hug)
					GoIdle()
					return
				W.anti_hug = max(0, --W.anti_hug)

		if(!cannot_infect)
			loc = target
			icon_state = initial(icon_state)
			target.equip_to_slot(src, WEAR_FACE)
			target.contents += src //Monkey sanity check - Snapshot
			target.update_inv_wear_mask()

			var/mob/living/carbon/human/H
			if(ishuman(target))
				H = target
				H.disable_lights()
				H.disable_special_items()
				if(isHumanStrict(target))
					playsound(loc, (target.gender == "male"?'sound/misc/facehugged_male.ogg' : 'sound/misc/facehugged_female.ogg') , 25, 0)
			if(!sterile)
				if(!H || !H.species || !(H.species.flags & IS_SYNTHETIC)) //synthetics aren't paralyzed
					target.KnockOut(MIN_IMPREGNATION_TIME * 0.5, TRUE) //THIS MIGHT NEED TWEAKS

	GoIdle()

	sleep(rand(MIN_IMPREGNATION_TIME,MAX_IMPREGNATION_TIME))
	Impregnate(M)

	return 1

/obj/item/clothing/mask/facehugger/proc/Impregnate(mob/living/carbon/target)
	if(!target || target.wear_mask != src || isXeno(target)) //Was taken off or something
		return
	var/mob/living/carbon/human/H
	if(ishuman(target))
		H = target
		if(H.species && (H.species.flags & IS_SYNTHETIC))
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

			if(H.species)
				H.species.larva_impregnated(embryo)

			icon_state = "[initial(icon_state)]_impregnated"
		target.visible_message(SPAN_DANGER("[src] falls limp after violating [target]'s face!"))
		Die()
	else
		target.visible_message(SPAN_DANGER("[src] violates [target]'s face!"))
	
	if(round_statistics && ishuman(target))
		round_statistics.total_huggers_applied++

/obj/item/clothing/mask/facehugger/proc/check_lifecycle()
	if(lifecycle - 50 <= 0)
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
		Die()
	else if(!attached || !ishuman(loc)) //doesn't age while attached
		lifecycle -= 50
		return 1

/obj/item/clothing/mask/facehugger/proc/GoActive(var/delay = 50)
	set waitfor = 0

	if(stat == DEAD) return

	if(stat != CONSCIOUS) icon_state = "[initial(icon_state)]"
	stat = CONSCIOUS

	sleep(delay) //Every 5 seconds.
	if(stat == CONSCIOUS && loc) //Make sure we're conscious and not idle or dead.
		if(check_lifecycle())
			leap_at_nearest_target()
			.()

/obj/item/clothing/mask/facehugger/proc/GoIdle() //Idle state does not count toward the death timer.
	set waitfor = 0

	if(stat == DEAD || stat == UNCONSCIOUS) return

	stat = UNCONSCIOUS
	icon_state = "[initial(icon_state)]_inactive"

	sleep(rand(MIN_ACTIVE_TIME,MAX_ACTIVE_TIME))
	GoActive()

/obj/item/clothing/mask/facehugger/proc/Die()
	set waitfor = 0

	if(stat == DEAD) return

	icon_state = "[initial(icon_state)]_dead"
	stat = DEAD

	visible_message("[htmlicon(src, viewers(src))] <span class='danger'>\The [src] curls up into a ball!</span>")
	playsound(src.loc, 'sound/voice/alien_facehugger_dies.ogg', 25, 1)

	if(ismob(loc)) //Make it fall off the person so we can update their icons. Won't update if they're in containers thou
		var/mob/M = loc
		M.drop_inv_item_on_ground(src)

	layer = BELOW_MOB_LAYER //so dead hugger appears below live hugger if stacked on same tile.

	sleep(1800) //3 minute timer for it to decay
	visible_message("[htmlicon(src, viewers(src))] <span class='danger'>\The [src] decays into a mass of acid and chitin.</span>")
	qdel(src)

/proc/CanHug(mob/living/carbon/M, var/hivenumber)

	if(!istype(M) || isXeno(M) || isSynth(M) || iszombie(M) || isHellhound(M) || M.stat == DEAD)
		return FALSE

	if(M.status_flags & XENO_HOST)
		for(var/obj/item/alien_embryo/embryo in M)
			if(embryo.hivenumber == hivenumber)
				return
	
	if(M.allied_to_hivenumber(hivenumber, XENO_SLASH_RESTRICTED))
		return

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
	Die()