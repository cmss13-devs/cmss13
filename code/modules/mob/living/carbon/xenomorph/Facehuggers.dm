#define MIN_IMPREGNATION_TIME 10 SECONDS //Time it takes to impregnate someone
#define MAX_IMPREGNATION_TIME 15 SECONDS

#define MIN_ACTIVE_TIME 5 SECONDS //Time between being dropped and going idle
#define MAX_ACTIVE_TIME 15 SECONDS

/obj/item/clothing/mask/facehugger
	name = "facehugger"
	desc = "It has some sort of a tube at the end of its tail."
	icon = 'icons/mob/xenos/effects.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/objects.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/misc.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/xeno_items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/xeno_items_righthand.dmi',
	)
	icon_state = "facehugger"
	item_state = "facehugger"
	item_state_slots = list(
		WEAR_FACE = "facehugger",
		WEAR_AS_GARB = "lamarr",
	)
	w_class = SIZE_TINY //Note: can be picked up by aliens unlike most other items of w_class below 4
	flags_inventory = COVEREYES|ALLOWINTERNALS|COVERMOUTH|ALLOWREBREATH|CANTSTRIP
	flags_armor_protection = BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_atom = NO_FLAGS
	flags_item = NOBLUDGEON
	throw_range = 1
	vision_impair = VISION_IMPAIR_MAX
	layer = FACEHUGGER_LAYER
	black_market_value = 20

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

	var/time_to_live = 30 SECONDS
	var/death_timer

	var/icon_xeno = 'icons/mob/xenos/effects.dmi'
	var/icon_xenonid = 'icons/mob/xenonids/castes/tier_0/xenonid_crab.dmi'

/obj/item/clothing/mask/facehugger/Initialize(mapload, hive)
	. = ..()
	var/new_icon = icon_xeno
	if (hive)
		hivenumber = hive

		var/datum/hive_status/hive_s = GLOB.hive_datum[hivenumber]
		if(HAS_TRAIT(hive_s, TRAIT_XENONID))
			new_icon = icon_xenonid

	icon = new_icon
	set_hive_data(src, hivenumber)
	go_active()

	if (hivenumber != XENO_HIVE_TUTORIAL)
		death_timer = addtimer(CALLBACK(src, PROC_REF(end_lifecycle)), time_to_live, TIMER_OVERRIDE|TIMER_STOPPABLE|TIMER_UNIQUE)


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
	addtimer(CALLBACK(src, PROC_REF(check_turf)), 0.2 SECONDS)

	if(!death_timer && hivenumber != XENO_HIVE_TUTORIAL && stat != DEAD)
		death_timer = addtimer(CALLBACK(src, PROC_REF(end_lifecycle)), time_to_live, TIMER_OVERRIDE|TIMER_STOPPABLE|TIMER_UNIQUE)

	if(stat == CONSCIOUS && loc) //Make sure we're conscious and not idle or dead.
		go_idle()
	if(attached)
		attached = FALSE
		die()

/obj/item/clothing/mask/facehugger/proc/check_turf()
	var/count = 0
	for(var/obj/item/clothing/mask/facehugger/F in get_turf(src))
		if(F.stat == CONSCIOUS)
			count++
		if(count > 2) //Was 5, our rules got much tighter
			visible_message(SPAN_XENOWARNING("The facehugger is furiously cannibalized by the nearby horde of other ones!"))
			qdel(src)
			return

/obj/item/clothing/mask/facehugger/attack_hand(mob/user)
	if(stat != DEAD)
		if(!sterile && can_hug(user, hivenumber))
			attach(user)
		//If we're alive, don't let them pick us up, even if attach fails. Just return.
		if(!isxeno(user))
			return
	return ..()

//Deal with picking up facehuggers. "attack_alien" is the universal 'xenos click something while unarmed' proc.
/obj/item/clothing/mask/facehugger/attack_alien(mob/living/carbon/xenomorph/user)
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

/obj/item/clothing/mask/facehugger/attack(mob/living/M, mob/user)
	if(stat == DEAD)
		to_chat(user, SPAN_WARNING("The facehugger is dead, what were you thinking?"))
		return
	if(!can_hug(M, hivenumber) || !(M.is_mob_incapacitated() || M.body_position == LYING_DOWN || M.buckled && !isyautja(M)))
		to_chat(user, SPAN_WARNING("The facehugger refuses to attach."))
		..()
		return

	// Guaranteed to work because of can_hug
	var/mob/living/carbon/human/H = M
	var/datum/species/S = H.species

	if(!S || S.timed_hug)
		if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, M, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return

		if(!can_hug(M, hivenumber) || !(M.is_mob_incapacitated() || M.body_position == LYING_DOWN || M.buckled))
			return

	attach(M)
	user.update_icons()

// TODO: make this use signals
/obj/item/clothing/mask/facehugger/attack_self(mob/user)
	..()

	if(iscarrier(user))
		var/mob/living/carbon/xenomorph/carrier/C = user
		C.store_hugger(src)

/obj/item/clothing/mask/facehugger/get_examine_text(mob/user)
	. = ..()
	switch(stat)
		if(DEAD, UNCONSCIOUS)
			. += SPAN_DANGER("[src] is not moving.")
		if(CONSCIOUS)
			. += SPAN_DANGER("[src] seems to be active.")
	if(sterile)
		. += SPAN_DANGER("It looks like the proboscis has been removed.")

/obj/item/clothing/mask/facehugger/attackby(obj/item/W, mob/user)
	if(W.flags_item & NOBLUDGEON)
		return
	die()

/obj/item/clothing/mask/facehugger/bullet_act(obj/projectile/P)
	..()
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO))
		return //Xeno spits ignore huggers.
	if(P.damage)
		die()
	P.ammo.on_hit_obj(src, P)
	return TRUE

/obj/item/clothing/mask/facehugger/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		die()

/obj/item/clothing/mask/facehugger/equipped(mob/holder)
	SHOULD_CALL_PARENT(FALSE) // ugh equip sounds
	// So picking up a hugger does not prematurely kill it
	if (!isxeno(holder))
		return

	var/mob/living/carbon/xenomorph/xeno = holder

	if ((xeno.caste.hugger_nurturing || hivenumber == XENO_HIVE_TUTORIAL) && death_timer)
		deltimer(death_timer)
		death_timer = null

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

/obj/item/clothing/mask/facehugger/launch_towards(datum/launch_metadata/LM)
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_thrown"
	..()

/obj/item/clothing/mask/facehugger/launch_impact(atom/hit_atom)
	. = ..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]"
		item_state = icon_state
	leaping = FALSE

/obj/item/clothing/mask/facehugger/mob_launch_collision(mob/living/L)
	if(stat == DEAD)
		..()
		return

	if(stat == UNCONSCIOUS)
		return

	// Force reset throw now because [/atom/movable/proc/launch_impact] only does that later on
	// If we DON'T, step()'s move below can collide, rebound, trigger this proc again, into infinite recursion
	throwing = FALSE
	rebounding = FALSE

	if(leaping && can_hug(L, hivenumber))
		attach(L)
	else if(L.density)
		step(src, turn(dir, 180)) //We want the hugger to bounce off if it hits a mob.
		go_idle()



/obj/item/clothing/mask/facehugger/proc/leap_at_nearest_target()
	if(!isturf(loc))
		return FALSE

	for(var/mob/living/M in loc)
		if(can_hug(M, hivenumber))
			attach(M)
			return TRUE

	var/mob/living/target
	for(var/mob/living/M in view(3, src))
		if(!can_hug(M, hivenumber))
			continue
		target = M
		break
	if(!target)
		return FALSE

	target.visible_message(SPAN_WARNING("[src] leaps at [target]!"),
	SPAN_WARNING("[src] leaps at [target]!"))
	leaping = TRUE
	throw_atom(target, 3, SPEED_FAST)
	return TRUE

/obj/item/clothing/mask/facehugger/proc/attach(mob/living/living_mob, silent = FALSE, knockout_mod = 1, mob/living/carbon/xenomorph/facehugger/hugger)
	if(attached || !can_hug(living_mob, hivenumber))
		return FALSE

	// This is always going to be valid because of the can_hug check above
	var/mob/living/carbon/human/human = living_mob
	if(!silent)
		human.visible_message(SPAN_DANGER("[src] leaps at [human]'s face!"))

	if(isxeno(loc)) //Being carried? Drop it
		var/mob/living/carbon/xenomorph/X = loc
		X.drop_inv_item_on_ground(src)

	if(isturf(human.loc))
		forceMove(human.loc)//Just checkin

	if(!human.handle_hugger_attachment(src, hugger))
		return FALSE

	attached = TRUE

	forceMove(human)
	icon_state = initial(icon_state)
	human.equip_to_slot(src, WEAR_FACE)
	human.update_inv_wear_mask()
	human.disable_lights()
	human.disable_special_items()
	if(ishuman_strict(human))
		playsound(loc, human.gender == "male" ? "male_hugged" : "female_hugged" , 25, 0)
	else if(isyautja(human))
		playsound(loc, 'sound/voice/pred_facehugged.ogg', 65, FALSE)
	if(!sterile)
		if(!human.species || !(human.species.flags & IS_SYNTHETIC)) //synthetics aren't paralyzed
			human.apply_effect(MIN_IMPREGNATION_TIME * 0.5 * knockout_mod, PARALYZE) //THIS MIGHT NEED TWEAKS

	var/area/hug_area = get_area(src)
	var/name = hugger ? "[hugger]" : "\a [src]"
	if(hivenumber != XENO_HIVE_TUTORIAL) // prevent hugs from any tutorial huggers from showing up in dchat
		if(hug_area)
			notify_ghosts(header = "Hugged", message = "[human] has been hugged by [name] at [hug_area]!", source = human, action = NOTIFY_ORBIT)
			to_chat(src, SPAN_DEADSAY("<b>[human]</b> has been facehugged by <b>[name]</b> at \the <b>[hug_area]</b>"))
		else
			notify_ghosts(header = "Hugged", message = "[human] has been hugged by [name]!", source = human, action = NOTIFY_ORBIT)
			to_chat(src, SPAN_DEADSAY("<b>[human]</b> has been facehugged by <b>[name]</b>"))

	if(hug_area)
		xeno_message(SPAN_XENOMINORWARNING("We sense that [name] has facehugged a host at \the [hug_area]!"), 1, hivenumber)
	else
		xeno_message(SPAN_XENOMINORWARNING("We sense that [name] has facehugged a host!"), 1, hivenumber)

	addtimer(CALLBACK(src, PROC_REF(impregnate), human, hugger?.client?.ckey), rand(MIN_IMPREGNATION_TIME, MAX_IMPREGNATION_TIME))

	return TRUE

/obj/item/clothing/mask/facehugger/proc/impregnate(mob/living/carbon/human/target, hugger_ckey = null)
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
			embryo.hugger_ckey = hugger_ckey
			GLOB.player_embryo_list += embryo

			embryo.flags_embryo = flags_embryo
			flags_embryo = NO_FLAGS

			if(target.species)
				target.species.larva_impregnated(embryo)

			icon_state = "[initial(icon_state)]_impregnated"
			item_state = icon_state
			impregnated = TRUE
		target.visible_message(SPAN_DANGER("[src] falls limp after violating [target]'s face!"))
		die()
	else
		target.visible_message(SPAN_DANGER("[src] violates [target]'s face!"))

	if(GLOB.round_statistics && ishuman(target))
		GLOB.round_statistics.total_huggers_applied++

/obj/item/clothing/mask/facehugger/proc/go_active()
	if(stat == DEAD)
		return

	if(stat != CONSCIOUS)
		icon_state = "[initial(icon_state)]"
		item_state = icon_state
	stat = CONSCIOUS
	jump_timer = addtimer(CALLBACK(src, PROC_REF(try_jump)), time_between_jumps, TIMER_OVERRIDE|TIMER_STOPPABLE|TIMER_UNIQUE)

/obj/item/clothing/mask/facehugger/proc/go_idle() //Idle state does not count toward the death timer.
	if(stat == DEAD || stat == UNCONSCIOUS)
		return

	stat = UNCONSCIOUS
	icon_state = "[initial(icon_state)]_inactive"
	item_state = icon_state
	if(jump_timer)
		deltimer(jump_timer)
	jump_timer = null
	// Reset the jumps left to their original count
	jumps_left = initial(jumps_left)
	addtimer(CALLBACK(src, PROC_REF(go_active)), rand(MIN_ACTIVE_TIME,MAX_ACTIVE_TIME))

/obj/item/clothing/mask/facehugger/proc/try_jump()
	jump_timer = addtimer(CALLBACK(src, PROC_REF(try_jump)), time_between_jumps, TIMER_OVERRIDE|TIMER_STOPPABLE|TIMER_UNIQUE)
	if(stat != CONSCIOUS || isnull(loc)) //Make sure we're conscious and not idle or dead.
		return

	if(isxeno(loc))
		var/mob/living/carbon/xenomorph/X = loc
		if(X.caste.hugger_nurturing) // caste can prevent hugger death
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
			return_to_egg(E)
			return
		var/obj/effect/alien/resin/trap/T = locate() in loc
		if(T && T.trap_type == RESIN_TRAP_EMPTY)
			visible_message(SPAN_XENOWARNING("[src] crawls into [T]!"))
			T.hivenumber = hivenumber
			T.set_state(RESIN_TRAP_HUGGER)
			qdel(src)
			return
		var/obj/effect/alien/resin/special/eggmorph/M = locate() in loc
		if(istype(M) && M.stored_huggers < M.huggers_max_amount)
			visible_message(SPAN_XENOWARNING("[src] crawls back into [M]!"))
			M.stored_huggers++
			qdel(src)
			return
	die()

/obj/item/clothing/mask/facehugger/proc/die()
	if(attached && !impregnated)
		return

	if(jump_timer)
		deltimer(jump_timer)
	jump_timer = null

	if(death_timer)
		deltimer(death_timer)
	death_timer = null

	if(stat == DEAD)
		return

	if(!impregnated)
		icon_state = "[initial(icon_state)]_dead"
		item_state = icon_state
	stat = DEAD
	flags_inventory &= ~CANTSTRIP
	visible_message("[icon2html(src, viewers(src))] <span class='danger'>\The [src] curls up into a ball!</span>")
	playsound(src.loc, 'sound/voice/alien_facehugger_dies.ogg', 25, 1)

	if(ismob(loc)) //Make it fall off the person so we can update their icons. Won't update if they're in containers thou
		var/mob/holder_mob = loc
		holder_mob.drop_inv_item_on_ground(src)

	layer = TURF_LAYER //so dead hugger appears below live hugger if stacked on same tile. (and below nested hosts)

	if(hivenumber == XENO_HIVE_TUTORIAL)
		addtimer(CALLBACK(src, PROC_REF(decay)), 5 SECONDS)
	else
		addtimer(CALLBACK(src, PROC_REF(decay)), 3 MINUTES)

/obj/item/clothing/mask/facehugger/proc/decay()
	visible_message("[icon2html(src, viewers(src))] <span class='danger'>\The [src] decays into a mass of acid and chitin.</span>")
	qdel(src)

/proc/can_hug(mob/living/carbon/M, hivenumber)
	if(!istype(M) || isxeno(M) || issynth(M) || iszombie(M) || isHellhound(M) || M.stat == DEAD || !M.huggable)
		return FALSE
	if(HAS_TRAIT(M, TRAIT_HAULED))
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

/obj/item/clothing/mask/facehugger/proc/return_to_egg(obj/effect/alien/egg/E)
	visible_message(SPAN_XENOWARNING("[src] crawls back into [E]!"))
	E.status = EGG_GROWN
	E.icon_state = "Egg"
	E.deploy_egg_triggers()
	qdel(src)

/**
 * Human hugger handling
 */
/mob/living/carbon/human/proc/handle_hugger_attachment(obj/item/clothing/mask/facehugger/hugger, mob/living/carbon/xenomorph/facehugger/mob_hugger)
	var/can_infect = TRUE
	if(!has_limb("head"))
		hugger.visible_message(SPAN_WARNING("[hugger] looks for a face to hug on [src], but finds none!"))
		hugger.go_idle()
		return FALSE

	if(species && !species.handle_hugger_attachment(src, hugger, mob_hugger))
		return FALSE

	var/obj/item/device/overwatch_camera/cam_gear
	if(istype(wear_l_ear, /obj/item/device/overwatch_camera))
		cam_gear = wear_l_ear
	else if(istype(wear_r_ear, /obj/item/device/overwatch_camera))
		cam_gear = wear_r_ear
	if(cam_gear && !(cam_gear.flags_item & NODROP))
		drop_inv_item_on_ground(cam_gear)
		update_inv_ears()

	if(head && !(head.flags_item & NODROP))
		var/obj/item/clothing/head/D = head
		if(istype(D))
			if(D.anti_hug >= 1)
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

		if(W.anti_hug >= 1)
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

/datum/species/proc/handle_hugger_attachment(mob/living/carbon/human/target, obj/item/clothing/mask/facehugger/hugger, mob/living/carbon/xenomorph/facehugger/mob_hugger)
	return TRUE

/datum/species/yautja/handle_hugger_attachment(mob/living/carbon/human/target, obj/item/clothing/mask/facehugger/hugger,  mob/living/carbon/xenomorph/facehugger/mob_hugger)
	var/catch_chance = 50
	if(target.dir == GLOB.reverse_dir[hugger.dir])
		catch_chance += 20
	if(target.body_position == LYING_DOWN)
		catch_chance -= 50
	catch_chance -= ((target.maxHealth - target.health) / 3)
	if(target.get_active_hand())
		catch_chance  -= 25
	if(target.get_inactive_hand())
		catch_chance  -= 25

	if(!target.stat && target.dir != hugger.dir && prob(catch_chance)) //Not facing away
		target.visible_message(SPAN_NOTICE("[target] snatches [hugger] out of the air and squashes it!"))
		if(mob_hugger)
			mob_hugger.death(create_cause_data("squished"))
		else
			hugger.die()
		return FALSE

	return TRUE
