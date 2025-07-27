//Disposal bin, holds items for disposal into pipe system. Draws air from turf, gradually charges internal reservoir
//Once full (~1 atm), uses air resv to flush items into the pipes. Automatically recharges air (unless off), will flush when ready if pre-set
//Can hold items and human size things, no other draggables
//Toilets are a type of disposal bin for small objects only and work on magic. By magic, I mean torque rotation
#define SEND_PRESSURE 50 //kPa
#define PRESSURE_TANK_VOLUME 70 //L - a 0.3 m diameter * 1 m long cylindrical tank. Happens to be the same volume as the regular oxygen tanks, so seems appropriate.
#define PUMP_MAX_FLOW_RATE 50 //L/s - 8 m/s using a 15 cm by 15 cm inlet

#define DISPOSALS_DOUBLE_OFF -1
#define DISPOSALS_OFF 0
#define DISPOSALS_CHARGING 1
#define DISPOSALS_CHARGED 2

/obj/structure/machinery/disposal
	name = "disposal unit"
	desc = "A pneumatic waste disposal unit."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposal"
	anchored = TRUE
	density = TRUE
	///Item mode 0=off 1=charging 2=charged
	var/mode = DISPOSALS_CHARGING
	///Used for cosmetic broken disposal units.
	var/broken = FALSE
	///True if flush handle is pulled
	var/flush = 0
	///The attached pipe trunk
	var/obj/structure/disposalpipe/trunk/trunk = null
	///True if flushing in progress
	var/flushing = FALSE
	///After 10 ticks it will look whether it is ready to flush
	var/flush_after_ticks = 10
	///This var adds 1 once per tick. When it reaches flush_after_ticks it resets and tries to flush.
	var/flush_count = 0
	var/last_sound = 0
	///The pneumatic pump power. 3 HP ~ 2200W
	active_power_usage = 3500
	idle_power_usage = 100
	var/disposal_pressure = 0
	///Whether the disposals tube is too narrow for a mob to fit into.
	var/narrow_tube = FALSE

/obj/structure/machinery/disposal/delivery
	name = "delivery chute"
	desc = "A pneumatic delivery unit connecting two locations. It's rather narrow."
	narrow_tube = TRUE

/obj/structure/machinery/disposal/broken
	name = "broken disposal unit"
	desc = "A pneumatic waste disposal unit. It does an exemplary job as a table. In fact, it deserves a medal."
	icon_state = "condisposal"
	broken = TRUE

///Create a new disposal, find the attached trunk (if present) and init gas resvr.
/obj/structure/machinery/disposal/Initialize(mapload, ...)
	. = ..()
	trunk = locate() in loc
	if(!trunk || broken)
		mode = DISPOSALS_OFF
		flush = 0
	else
		trunk.linked = src //Link the pipe trunk to self

	update()
	start_processing()

/obj/structure/machinery/disposal/Destroy()
	if(length(contents))
		eject()
	trunk = null
	return ..()

/obj/structure/machinery/disposal/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND

///Attack by item places it in to disposal
/obj/structure/machinery/disposal/attackby(obj/item/I, mob/user)
	if(stat & BROKEN || !I || !user)
		return

	if(isxeno(user)) //No, fuck off. Concerns trashing Marines and facehuggers
		return

	add_fingerprint(user)
	if(mode <= 0) //It's off
		if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
			if(length(contents) > 0)
				to_chat(user, SPAN_WARNING("Eject the contents first!"))
				return
			if(mode == DISPOSALS_OFF) //It's off but still not unscrewed
				mode = DISPOSALS_DOUBLE_OFF //Set it to doubleoff
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You remove the screws around the power connection."))
				return
			else if(mode == DISPOSALS_DOUBLE_OFF)
				mode = DISPOSALS_OFF
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You attach the screws around the power connection."))
				return
		else if(iswelder(I) && mode == DISPOSALS_DOUBLE_OFF)
			if(!HAS_TRAIT(I, TRAIT_TOOL_BLOWTORCH))
				to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
				return
			if(length(contents) > 0)
				to_chat(user, SPAN_WARNING("Eject the contents first!"))
				return
			var/obj/item/tool/weldingtool/W = I
			if(W.remove_fuel(0, user))
				playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You start slicing the floorweld off the disposal unit."))
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!src || !W.isOn())
						return
					to_chat(user, SPAN_NOTICE("You sliced the floorweld off the disposal unit."))
					var/obj/structure/disposalconstruct/C = new(loc)
					transfer_fingerprints_to(C)
					C.ptype = 6 //6 = disposal unit
					C.anchored = TRUE
					C.density = TRUE
					C.update()
					qdel(src)
			else
				to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return


	if(isstorage(I))
		var/obj/item/storage/S = I
		if(!S.can_storage_interact(user))
			return
		if(length(S.contents) > 0)
			to_chat(user, SPAN_NOTICE("You empty [S] into [src]."))
			for(var/obj/item/O in S.contents)
				S.remove_from_storage(O, src, user)
			S.update_icon()
			update()
			return

	var/obj/item/grab/grab_effect = I
	if(istype(grab_effect)) //Handle grabbed mob
		if(ismob(grab_effect.grabbed_thing))
			var/mob/grabbed_mob = grab_effect.grabbed_thing
			if((!MODE_HAS_MODIFIER(/datum/gamemode_modifier/disposable_mobs) && !HAS_TRAIT(grabbed_mob, TRAIT_CRAWLER)) || narrow_tube || grabbed_mob.mob_size >= MOB_SIZE_BIG)
				to_chat(user, SPAN_WARNING("You can't fit that in there!"))
				return FALSE
			var/max_grab_size = user.mob_size
			/// Amazing what you can do with a bit of dexterity.
			if(HAS_TRAIT(user, TRAIT_DEXTROUS))
				max_grab_size++
			/// Strong mobs can lift above their own weight.
			if(HAS_TRAIT(user, TRAIT_SUPER_STRONG))//NB; this will mean Yautja can bodily lift MOB_SIZE_XENO(3) and Synths can lift MOB_SIZE_XENO_SMALL(2)
				max_grab_size++
			if(grabbed_mob.mob_size > max_grab_size || !(grabbed_mob.status_flags & CANPUSH))
				to_chat(user, SPAN_WARNING("You don't have the strength to move [grabbed_mob]!"))
				return FALSE//can't tighten your grip on mobs bigger than you and mobs you can't push.
			if(!user.grab_level >= GRAB_AGGRESSIVE)
				to_chat(user, SPAN_WARNING("You need a better grip to force [grabbed_mob] in there!"))
				return FALSE
			user.visible_message(SPAN_WARNING("[user] starts putting [grabbed_mob] into [src]."),
			SPAN_WARNING("You start putting [grabbed_mob] into [src]."))
			if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
				user.visible_message(SPAN_WARNING("[user] stops putting [grabbed_mob] into [src]."),
				SPAN_WARNING("You stop putting [grabbed_mob] into [src]."))
				return FALSE

			grabbed_mob.forceMove(src)
			user.visible_message(SPAN_WARNING("[user] puts [grabbed_mob] into [src]."),
			SPAN_WARNING("[user] puts [grabbed_mob] into [src]."))
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has placed [key_name(grabbed_mob)] in disposals.</font>")
			grabbed_mob.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been placed in disposals by [user] ([user.ckey])</font>")
			msg_admin_attack("[user] ([user.ckey]) placed [key_name(grabbed_mob)] in a disposals unit in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
			flush(TRUE)//Forcibly flushing someone if forced in by another player.
			return TRUE
		return FALSE

	if(!I)
		return

	if(user.drop_inv_item_to_loc(I, src))
		user.visible_message(SPAN_NOTICE("[user] places [I] into [src]."),
		SPAN_NOTICE("You place [I] into [src]."))
		//Something to dispose!
		start_processing()
	update()

///Mouse drop another mob or self
/obj/structure/machinery/disposal/MouseDrop_T(mob/target, mob/user)
	if((!MODE_HAS_MODIFIER(/datum/gamemode_modifier/disposable_mobs) && !HAS_TRAIT(user, TRAIT_CRAWLER)) || narrow_tube)
		to_chat(user, SPAN_WARNING("Looks a little bit too tight in there!"))
		return FALSE

	if(target != user)
		to_chat(user, SPAN_WARNING("You need a better grip on [target] to force them into [src]!"))
		return FALSE //Need a firm grip to put someone else in there.

	if(!istype(target) || target.anchored || target.buckled || get_dist(user, src) > 1 || user.is_mob_incapacitated(TRUE) || isRemoteControlling(user) || target.mob_size >= MOB_SIZE_BIG)
		to_chat(user, SPAN_WARNING("You cannot get into [src]!"))
		return FALSE
	add_fingerprint(user)
	var/target_loc = target.loc

	if(target == user)
		visible_message(SPAN_NOTICE("[user] starts climbing into the disposal."))

	if(!do_after(user, 40, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return FALSE
	if(target_loc != target.loc)
		return FALSE
	if(user.is_mob_incapacitated(TRUE))
		to_chat(user, SPAN_WARNING("You cannot do this while incapacitated!"))
		return FALSE

	if(target == user)
		user.visible_message(SPAN_NOTICE("[user] climbs into [src]."),
		SPAN_NOTICE("You climb into [src]."))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>[key_name(user)] climbed into a disposals bin!</font>")

	target.forceMove(src)
	flush()//Not forcing flush if climbing in by self.
	update()

///Attempt to move while inside
/obj/structure/machinery/disposal/relaymove(mob/living/user)
	if(user.is_mob_incapacitated(TRUE) || flushing)
		return FALSE
	if(user.loc == src)
		go_out(user)
		return TRUE

///Leave the disposal
/obj/structure/machinery/disposal/proc/go_out(mob/living/user)
	if(user.client)
		user.client.eye = user.client.mob
		user.client.perspective = MOB_PERSPECTIVE
	user.forceMove(loc)
	user.apply_effect(2, STUN)
	if(user.mobility_flags & MOBILITY_MOVE)
		user.visible_message(SPAN_WARNING("[user] suddenly climbs out of [src]!"),
		SPAN_WARNING("You climb out of [src] and get your bearings!"))
		update()

///Human interact with machine
/obj/structure/machinery/disposal/attack_hand(mob/user as mob)
	if(user && user.loc == src)
		to_chat(usr, SPAN_DANGER("You cannot reach the controls from inside."))
		return

	tgui_interact(user)

// TGUI \\

/obj/structure/machinery/disposal/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Disposals", "[src.name]")
		ui.open()

/obj/structure/machinery/disposal/ui_data(mob/user)
	var/list/data = list()

	data["pressure"] = disposal_pressure*100/SEND_PRESSURE
	data["mode"] = mode
	data["flush"] = flush

	return data

/obj/structure/machinery/disposal/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_DISABLED
	if(user.loc == src)
		return UI_CLOSE //can't use it from inside!

/obj/structure/machinery/disposal/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("pump")
			if(mode <= DISPOSALS_OFF)
				mode = DISPOSALS_CHARGING
			else
				mode = DISPOSALS_OFF
				disposal_pressure = 0
			update()
			. = TRUE

		if("handle")
			flush = !flush
			update()
			. = TRUE

		if("eject")
			eject()
			. = TRUE

///Eject the contents of the disposal unit
/obj/structure/machinery/disposal/proc/eject()
	for(var/atom/movable/AM in src)
		AM.forceMove(loc)
		AM.pipe_eject(0)
		if(isliving(AM))
			var/mob/living/living = AM
			living.Stun(2)
			if(living.body_position == STANDING_UP)
				living.visible_message(SPAN_WARNING("[living] is suddenly pushed out of [src]!"),
				SPAN_WARNING("You get pushed out of [src] and get your bearings!"))
	update()

///Pipe affected by explosion
/obj/structure/machinery/disposal/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(60))
				deconstruct(FALSE)
			return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

///Update the icon & overlays to reflect mode & status
/obj/structure/machinery/disposal/proc/update()
	overlays.Cut()
	if(stat & BROKEN)
		icon_state = "disposal-broken"
		mode = DISPOSALS_OFF
		flush = 0
		return

	//Flush handle
	if(flush)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-handle")

	//Only handle is shown if no power
	if(stat & NOPOWER || mode == DISPOSALS_DOUBLE_OFF)
		return

	//Check for items in disposal - occupied light
	if(length(contents) > 0)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-full")

	//Charging and ready light
	if(mode == DISPOSALS_CHARGING)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-charge")
	else if(mode == DISPOSALS_CHARGED)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-ready")

///Timed process, charge the gas reservoir and perform flush if ready
/obj/structure/machinery/disposal/process()
	if(stat & BROKEN) //Nothing can happen if broken
		update_use_power(USE_POWER_NONE)
		return

	flush_count++
	if(flush_count >= flush_after_ticks)
		if(length(contents))
			if(mode == DISPOSALS_CHARGED)
				spawn(0)
					flush()
		flush_count = 0

	updateDialog()

	if(flush && disposal_pressure >= SEND_PRESSURE) //Flush can happen even without power
		flush()

	if(mode != 1) //If off or ready, no need to charge
		update_use_power(USE_POWER_IDLE)
	else if(disposal_pressure >= SEND_PRESSURE)
		mode = DISPOSALS_CHARGED //If full enough, switch to ready mode
		update()
		if(!length(contents))
			//Full and nothing to flush - stop processing!
			stop_processing()
	else
		pressurize() //Otherwise charge

/obj/structure/machinery/disposal/proc/pressurize()
	if(disposal_pressure < SEND_PRESSURE)
		disposal_pressure += 5
	return

///Perform a flush
/obj/structure/machinery/disposal/proc/flush(forced = FALSE)
	if((disposal_pressure < SEND_PRESSURE) && !forced)
		return FALSE

	flushing = TRUE
	flick("[icon_state]-flush", src)

	var/wrapcheck = 0
	var/obj/structure/disposalholder/H = new() //Virtual holder object which actually
												//Travels through the pipes.
	//Hacky test to get drones to mail themselves through disposals.

	for(var/obj/item/smallDelivery/O in src)
		wrapcheck = 1

	if(wrapcheck == 1)
		H.tomail = 1

	sleep(10)
	if(last_sound < world.time + 1)
		playsound(src, 'sound/machines/disposalflush.ogg', 15, 0)
		last_sound = world.time
	sleep(5) //Wait for animation to finish

	disposal_pressure = 0

	if(H)
		H.init(src) //Copy the contents of disposer to holder

		H.start(src) //Start the holder processing movement
	flushing = FALSE
	//Now reset disposal state
	flush = 0
	if(mode == DISPOSALS_CHARGED) //If was ready,
		mode = DISPOSALS_CHARGING //Switch to charging
	update()
	return

///Called when area power changes
/obj/structure/machinery/disposal/power_change()
	..() //Do default setting/reset of stat NOPOWER bit
	update() //Update icon
	return

///Called when holder is expelled from a disposal, should usually only occur if the pipe network is modified
/obj/structure/machinery/disposal/proc/expel(obj/structure/disposalholder/H)
	var/turf/target
	playsound(src, 'sound/machines/hiss.ogg', 25, 0)
	if(H) //Somehow, someone managed to flush a window which broke mid-transit and caused the disposal to go in an infinite loop trying to expel null, hopefully this fixes it
		for(var/atom/movable/AM in H)
			target = get_offset_target_turf(loc, rand(5) - rand(5), rand(5) - rand(5))
			AM.forceMove(loc)
			AM.pipe_eject(0)
			spawn(1)
				if(AM)
					AM.throw_atom(target, 5, SPEED_FAST)
		qdel(H)

/obj/structure/machinery/disposal/hitby(atom/movable/mover)
	if (!istype(mover, /obj/item))
		return
	if (prob(75))
		mover.forceMove(src)
		visible_message(SPAN_NOTICE("[mover] lands into [src]."))
		//Something to flush, start processing!
		start_processing()
	else
		visible_message(SPAN_WARNING("[mover] bounces off of [src]'s rim!"))

///Virtual disposal object, travels through pipes in lieu of actual items
///Contents will be items flushed by the disposal, this allows the gas flushed to be tracked
/obj/structure/disposalholder
	invisibility = 101
	var/active = 0 //True if the holder is moving, otherwise inactive
	dir = 0
	var/count = 2048 //Can travel 2048 steps before going inactive (in case of loops)
	var/has_fat_guy = 0 //True if contains a fat person
	var/destinationTag = "" //Changes if contains a delivery container
	var/tomail = 0 //Changes if contains wrapped package
	var/hasmob = 0 //If it contains a mob

	var/partialTag = "" //Set by a partial tagger the first time round, then put in destinationTag if it goes through again.

/obj/structure/disposalholder/Destroy()
		active = 0
		. = ..()

//initialize a holder from the contents of a disposal unit
/obj/structure/disposalholder/proc/init(obj/structure/machinery/disposal/D)

	//Check for any living mobs trigger hasmob.
	//hasmob effects whether the package goes to cargo or its tagged destination.
	for(var/mob/living/M in D)
		if(M && M.stat != DEAD)
			hasmob = 1

	//Checks 1 contents level deep. This means that players can be sent through disposals...
	//...but it should require a second person to open the package. (i.e. person inside a wrapped locker)
	for(var/obj/O in D)
		if(O.contents)
			for(var/mob/living/M in O.contents)
				if(M && M.stat != 2)
					hasmob = 1

	//Now everything inside the disposal gets put into the holder
	//Note AM since can contain mobs or objs
	for(var/atom/movable/AM in D)
		AM.forceMove(src)
		if(istype(AM, /obj/structure/bigDelivery) && !hasmob)
			var/obj/structure/bigDelivery/T = AM
			destinationTag = T.sortTag
		if(istype(AM, /obj/item/smallDelivery) && !hasmob)
			var/obj/item/smallDelivery/T = AM
			destinationTag = T.sortTag

//Start the movement process
//Argument is the disposal unit the holder started in
/obj/structure/disposalholder/proc/start(obj/structure/machinery/disposal/D)

	if(!D.trunk)
		D.expel(src) //No trunk connected, so expel immediately
		return

	forceMove(D.trunk)
	active = 1
	setDir(DOWN)
	spawn(1)
		move() //Spawn off the movement process

//Movement process, persists while holder is moving through pipes
/obj/structure/disposalholder/proc/move()

	var/obj/structure/disposalpipe/last
	while(active)
		if(hasmob && prob(3))
			for(var/mob/living/H in src)
				H.take_overall_damage(20, 0, "Blunt Trauma") //Horribly maim any living creature jumping down disposals.  c'est la vie

		if(has_fat_guy && prob(2)) //Chance of becoming stuck per segment if contains a fat guy
			active = 0
			//Find the fat guys
			for(var/mob/living/carbon/human/H in src)

			break
		sleep(1) //Was 1
		var/obj/structure/disposalpipe/curr = loc
		if(!curr && loc)
			last.expel(src, loc, dir)
		last = curr
		if(curr)
			curr = curr.transfer(src)
		if(!curr && loc)
			last.expel(src, loc, dir)

		if(!(count--))
			active = 0

//Find the turf which should contain the next pipe
/obj/structure/disposalholder/proc/nextloc()
	return get_step(loc, dir)

//Find a matching pipe on a turf
/obj/structure/disposalholder/proc/findpipe(turf/T)

	if(!T)
		return null

	var/fdir = turn(dir, 180) //Flip the movement direction
	for(var/obj/structure/disposalpipe/P in T)
		if(fdir & P.dpdir) //Find pipe direction mask that matches flipped dir
			return P
	//If no matching pipe, return null
	return null

//Merge two holder objects
//Used when a a holder meets a stuck holder
/obj/structure/disposalholder/proc/merge(obj/structure/disposalholder/other)
	for(var/atom/movable/AM in other)
		AM.forceMove(src) //Move everything in other holder to this one
		if(ismob(AM))
			var/mob/M = AM
			if(M.client) //If a client mob, update eye to follow this holder
				M.client.eye = src

	if(other.has_fat_guy)
		has_fat_guy = 1
	qdel(other)

/obj/structure/disposalholder/proc/settag(new_tag)
	destinationTag = new_tag

/obj/structure/disposalholder/proc/setpartialtag(new_tag)
	if(partialTag == new_tag)
		destinationTag = new_tag
		partialTag = ""
	else
		partialTag = new_tag


//Called when player tries to move while in a pipe
/obj/structure/disposalholder/relaymove(mob/user as mob)

	if(!isliving(user))
		return

	var/mob/living/U = user

	if(U.stat || U.last_special <= world.time)
		return

	U.last_special = world.time + 100

	playsound(src.loc, 'sound/effects/clang.ogg', 25, 0)


//Disposal pipes
/obj/structure/disposalpipe
	icon = 'icons/obj/pipes/disposal.dmi'
	name = "disposal pipe"
	desc = "An underfloor disposal pipe."
	anchored = TRUE
	density = FALSE

	level = 1 //Underfloor only
	var/dpdir = 0 //Bitmask of pipe directions
	dir = 0 //dir will contain dominant direction for junction pipes
	health = 10 //Health points 0-10
	plane = FLOOR_PLANE
	layer = DISPOSAL_PIPE_LAYER //Slightly lower than wires and other pipes
	var/base_icon_state //Initial icon state on map

	//New pipe, set the icon_state as on map
/obj/structure/disposalpipe/Initialize(mapload, ...)
	. = ..()
	base_icon_state = icon_state


//Pipe is deleted
//Ensure if holder is present, it is expelled
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		//Holder was present
		H.active = 0
		var/turf/T = loc
		if(T.density)
			//Deleting pipe is inside a dense turf (wall), this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			..()
			return

		//Otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)
	. = ..()

//Returns the direction of the next pipe object, given the entrance dir by default, returns the bitmask of remaining directions
/obj/structure/disposalpipe/proc/nextdir(fromdir)
	return dpdir & (~turn(fromdir, 180))

//Transfer the holder through this pipe segment, overridden for special behaviour
/obj/structure/disposalpipe/proc/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.setDir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		//Find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else //If wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null
	return P

//Update the icon_state to reflect hidden status
/obj/structure/disposalpipe/proc/update()
	var/turf/T = loc
	hide(T.intact_tile && !istype(T, /turf/open/space)) //Space never hides pipes

//Hide called by levelupdate if turf intact status changes, change visibility status and force update of icon
/obj/structure/disposalpipe/hide(intact)
	invisibility = intact ? 101: 0 // hide if floor is intact
	updateicon()

//Update actual icon_state depending on visibility, if invisible, append "f" to icon_state to show faded version, this will be revealed if a T-scanner is used
//If visible, use regular icon_state
/obj/structure/disposalpipe/proc/updateicon()

	if(!isnull(base_icon_state))
		icon_state = base_icon_state
	else
		base_icon_state = icon_state

//Expel the held objects into a turf. called when there is a break in the pipe
/obj/structure/disposalpipe/proc/expel(obj/structure/disposalholder/H, turf/T, direction)

	var/turf/target

	if(T.density) //Dense ouput turf, so stop holder
		H.active = 0
		H.forceMove(src)
		return
	if(istype(T, /turf/open/floor)) //intact floor, pop the tile
		var/turf/open/floor/F = T
		if(!F.intact_tile)
			if(!(F.turf_flags & TURF_BROKEN) && !(F.turf_flags & TURF_BURNT))
				new F.tile_type(H, 1, F.type)
			F.make_plating()

	if(direction) //Direction is specified
		if(istype(T, /turf/open/space)) //If ended in space, then range is unlimited
			target = get_edge_target_turf(T, direction)
		else //Otherwise limit to 10 tiles
			target = get_ranged_target_turf(T, direction, 10)

		playsound(src, 'sound/machines/hiss.ogg', 25, 0)
		if(H)
			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(direction)
				spawn(1)
					if(AM)
						AM.throw_atom(target, 100, SPEED_FAST)
			qdel(H)

	else //No specified direction, so throw in random direction

		playsound(src, 'sound/machines/hiss.ogg', 25, 0)
		if(H)
			for(var/atom/movable/AM in H)
				target = get_offset_target_turf(T, rand(5) - rand(5), rand(5) - rand(5))

				AM.forceMove(T)
				AM.pipe_eject(0)
				spawn(1)
					if(AM)
						AM.throw_atom(target, 5, SPEED_FAST)

			qdel(H)

//Call to break the pipe, will expel any holder inside at the time then delete the pipe
//Remains : set to leave broken pipe pieces in place
/obj/structure/disposalpipe/deconstruct(disassembled = TRUE)
	if(disassembled)
		for(var/D in GLOB.cardinals)
			if(D & dpdir)
				var/obj/structure/disposalpipe/broken/P = new(loc)
				P.setDir(D)

	invisibility = 101 //Make invisible (since we won't delete the pipe immediately)
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		//Holder was present
		H.active = 0
		var/turf/T = src.loc
		if(T.density)
			//Broken pipe is inside a dense turf (wall)
			//This is unlikely, but just dump out everything into the turf in case
			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			return

		//Otherwise, do normal expel from turf
		if(H && H.loc)
			expel(H, T, 0)

	QDEL_IN(src, 2) // doesn't call parent because of all this snowflakery

//Pipe affected by explosion
/obj/structure/disposalpipe/ex_act(severity)

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			health -= rand(0, 15)
			healthcheck()
			return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			health -= rand(5, 15)
			healthcheck()
			return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

//Test health for brokenness
/obj/structure/disposalpipe/proc/healthcheck()
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		return
	if(health < -2)
		deconstruct(FALSE)
	else if(health < 1)
		deconstruct(TRUE)

//Attack by item. Weldingtool: unfasten and convert to obj/disposalconstruct
/obj/structure/disposalpipe/attackby(obj/item/I, mob/user)

	var/turf/T = loc
	if(T.intact_tile)
		return //Prevent interaction with T-scanner revealed pipes
	add_fingerprint(user)
	if(iswelder(I))
		if(!HAS_TRAIT(I, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/W = I

		if(W.remove_fuel(0, user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			//Check if anything changed over 2 seconds
			var/turf/uloc = user.loc
			var/atom/wloc = W.loc
			user.visible_message(SPAN_NOTICE("[user] starts slicing [src]."),
			SPAN_NOTICE("You start slicing [src]."))
			sleep(30)
			if(!W.isOn())
				return
			if(user.loc == uloc && wloc == W.loc)
				welded()
			else
				to_chat(user, SPAN_WARNING("You must stay still while welding [src]."))
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to cut [src]."))

//Called when pipe is cut with blowtorch
/obj/structure/disposalpipe/proc/welded()

	var/obj/structure/disposalconstruct/C = new(loc)
	switch(base_icon_state)
		if("pipe-s")
			C.ptype = 0
		if("pipe-c")
			C.ptype = 1
		if("pipe-j1")
			C.ptype = 2
		if("pipe-j2")
			C.ptype = 3
		if("pipe-y")
			C.ptype = 4
		if("pipe-t")
			C.ptype = 5
		if("pipe-j1s")
			C.ptype = 9
		if("pipe-j2s")
			C.ptype = 10
		//Z-Level stuff
		if("pipe-u")
			C.ptype = 11
		if("pipe-d")
			C.ptype = 12
		//Z-Level stuff
		if("pipe-tagger")
			C.ptype = 13
		if("pipe-tagger-partial")
			C.ptype = 14
	transfer_fingerprints_to(C)
	C.setDir(dir)
	C.density = FALSE
	C.anchored = TRUE
	C.update()
	qdel(src)

//A straight or bent segment
/obj/structure/disposalpipe/segment
	icon_state = "pipe-s"

/obj/structure/disposalpipe/segment/Initialize(mapload, ...)
	. = ..()
	if(icon_state == "pipe-s")
		dpdir = dir|turn(dir, 180)
	else
		dpdir = dir|turn(dir, -90)
	update()

//Z-Level stuff
/obj/structure/disposalpipe/up
	icon_state = "pipe-u"

/obj/structure/disposalpipe/up/Initialize(mapload, ...)
	. = ..()
	dpdir = dir
	update()

/obj/structure/disposalpipe/up/nextdir(fromdir)
	var/nextdir
	if(fromdir == 11)
		nextdir = dir
	else
		nextdir = 12
	return nextdir

/obj/structure/disposalpipe/up/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.setDir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 12)
		H.forceMove(loc)
		return

	else
		T = get_step(loc, H.dir)
		P = H.findpipe(T)

	if(P)
		//Find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else //If wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null
	return P

/obj/structure/disposalpipe/down
	icon_state = "pipe-d"

/obj/structure/disposalpipe/down/Initialize(mapload, ...)
	. = ..()
	dpdir = dir
	update()

/obj/structure/disposalpipe/down/nextdir(fromdir)
	var/nextdir
	if(fromdir == 12)
		nextdir = dir
	else
		nextdir = 11
	return nextdir

/obj/structure/disposalpipe/down/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.setDir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 11)
		H.forceMove(loc)
		return

	else
		T = get_step(loc, H.dir)
		P = H.findpipe(T)

	if(P)
		//Find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else //If wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null
	return P

// *** special cased almayer stuff because it's all one z level ***

/obj/structure/disposalpipe/up/almayer
	var/id

/obj/structure/disposalpipe/up/almayer/Initialize(mapload, ...)
	. = ..()
	GLOB.disposalpipe_up_list += src

/obj/structure/disposalpipe/up/almayer/Destroy()
	GLOB.disposalpipe_up_list -= src
	return ..()

/obj/structure/disposalpipe/down/almayer
	var/id

/obj/structure/disposalpipe/down/almayer/Initialize(mapload, ...)
	. = ..()
	GLOB.disposalpipe_down_list += src

/obj/structure/disposalpipe/down/almayer/Destroy()
	GLOB.disposalpipe_down_list -= src
	return ..()

/obj/structure/disposalpipe/up/almayer/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.setDir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 12)
		for(var/i in GLOB.disposalpipe_down_list)
			var/obj/structure/disposalpipe/down/almayer/F = i
			if(id == F.id)
				P = F
				break // stop at first found match
	else
		T = get_step(loc, H.dir)
		P = H.findpipe(T)

	if(P)
		//Find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else //If wasn't a pipe, then set loc to turf
		H.forceMove(loc)
		return null
	return P

/obj/structure/disposalpipe/down/almayer/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.setDir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 11)
		for(var/i in GLOB.disposalpipe_up_list)
			var/obj/structure/disposalpipe/up/almayer/F = i
			if(id == F.id)
				P = F
				break // stop at first found match
	else
		T = get_step(loc, H.dir)
		P = H.findpipe(T)

	if(P)
		//Find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else //If wasn't a pipe, then set loc to turf
		H.forceMove(loc)
		return null
	return P

// *** end special cased almayer stuff ***

//Z-Level stuff
//A three-way junction with dir being the dominant direction
/obj/structure/disposalpipe/junction
	icon_state = "pipe-j1"

/obj/structure/disposalpipe/junction/Initialize(mapload, ...)
	. = ..()
	if(icon_state == "pipe-j1")
		dpdir = dir|turn(dir, -90)|turn(dir, 180)
	else if(icon_state == "pipe-j2")
		dpdir = dir|turn(dir, 90)|turn(dir, 180)
	else //Pipe-y
		dpdir = dir|turn(dir,90)|turn(dir, -90)
	update()

//Next direction to move, if coming in from secondary dirs, then next is primary dir, if coming in from primary dir, then next is equal chance of other dirs
/obj/structure/disposalpipe/junction/nextdir(fromdir)
	var/flipdir = turn(fromdir, 180)
	if(flipdir != dir) //Came from secondary dir
		return dir //So exit through primary
	else //Came from primary
						//So need to choose either secondary exit
		var/mask = ..(fromdir)

		//Find a bit which is set
		var/setbit = 0
		if(mask & NORTH)
			setbit = NORTH
		else if(mask & SOUTH)
			setbit = SOUTH
		else if(mask & EAST)
			setbit = EAST
		else
			setbit = WEST

		if(prob(50)) //50% chance to choose the found bit or the other one
			return setbit
		else
			return mask & (~setbit)

/obj/structure/disposalpipe/tagger
	name = "package tagger"
	icon_state = "pipe-tagger"
	var/sort_tag = ""
	var/partial = 0

/obj/structure/disposalpipe/tagger/Initialize(mapload, ...)
	. = ..()
	dpdir = dir|turn(dir, 180)
	if(sort_tag)
		GLOB.tagger_locations |= sort_tag
	updatename()
	updatedesc()
	update()

/obj/structure/disposalpipe/tagger/proc/updatedesc()
	desc = initial(desc)
	if(sort_tag)
		desc += "\nIt's tagging objects with the '[sort_tag]' tag."

/obj/structure/disposalpipe/tagger/proc/updatename()
	if(sort_tag)
		name = "[initial(name)] ([sort_tag])"
	else
		name = initial(name)

/obj/structure/disposalpipe/tagger/attackby(obj/item/I, mob/user)
	. = ..()
	if(.)
		return

	if(istype(I, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = I

		if(O.currTag) //Tag set
			sort_tag = O.currTag
			playsound(loc, 'sound/machines/twobeep.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("Changed tag to '[sort_tag]'."))
			updatename()
			updatedesc()

/obj/structure/disposalpipe/tagger/transfer(obj/structure/disposalholder/H)
	if(sort_tag)
		if(partial)
			H.setpartialtag(sort_tag)
		else
			H.settag(sort_tag)
	return ..()

/obj/structure/disposalpipe/tagger/partial //Needs two passes to tag
	name = "partial package tagger"
	icon_state = "pipe-tagger-partial"
	partial = 1

//A three-way junction that sorts objects
/obj/structure/disposalpipe/sortjunction
	name = "sorting junction"
	icon_state = "pipe-j1s"
	desc = "An underfloor disposal pipe with a package sorting mechanism."

	var/sortType = ""
	var/posdir = 0
	var/negdir = 0
	var/sortdir = 0

/obj/structure/disposalpipe/sortjunction/Initialize(mapload, ...)
	. = ..()
	if(sortType)
		GLOB.tagger_locations |= sortType

	updatedir()
	updatename()
	updatedesc()
	update()

/obj/structure/disposalpipe/sortjunction/proc/updatedesc()
	desc = initial(desc)
	if(sortType)
		desc += "\nIt's filtering objects with the '[sortType]' tag."

/obj/structure/disposalpipe/sortjunction/proc/updatename()
	if(sortType)
		name = "[initial(name)] ([sortType])"
	else
		name = initial(name)

/obj/structure/disposalpipe/sortjunction/proc/updatedir()
	posdir = dir
	negdir = turn(posdir, 180)

	if(icon_state == "pipe-j1s")
		sortdir = turn(posdir, -90)
	else if(icon_state == "pipe-j2s")
		sortdir = turn(posdir, 90)

	dpdir = sortdir|posdir|negdir

/obj/structure/disposalpipe/sortjunction/attackby(obj/item/I, mob/user)
	if(..())
		return

	if(istype(I, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = I

		if(O.currTag) //Tag set
			sortType = O.currTag
			playsound(loc, 'sound/machines/twobeep.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("Changed filter to '[sortType]'."))
			updatename()
			updatedesc()

/obj/structure/disposalpipe/sortjunction/proc/divert_check(checkTag)
	return sortType == checkTag

//Next direction to move, if coming in from negdir, then next is primary dir or sortdir, if coming in from posdir, then flip around and go back to posdir, if coming in from sortdir, go to posdir
/obj/structure/disposalpipe/sortjunction/nextdir(fromdir, sortTag)
	if(fromdir != sortdir) //Probably came from the negdir
		if(divert_check(sortTag))
			return sortdir
		else
			return posdir
	else //Came from sortdir so go with the flow to positive direction
		return posdir

/obj/structure/disposalpipe/sortjunction/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir, H.destinationTag)
	H.setDir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		//Find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else //If wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null
	return P

//A three-way junction that filters all wrapped and tagged items
/obj/structure/disposalpipe/sortjunction/wildcard
	name = "wildcard sorting junction"
	desc = "An underfloor disposal pipe which filters all wrapped and tagged items."

/obj/structure/disposalpipe/sortjunction/wildcard/divert_check(checkTag)
	return checkTag != ""

//Junction that filters all untagged items
/obj/structure/disposalpipe/sortjunction/untagged
	name = "untagged sorting junction"
	desc = "An underfloor disposal pipe which filters all untagged items."

/obj/structure/disposalpipe/sortjunction/untagged/divert_check(checkTag)
	return checkTag == ""

/obj/structure/disposalpipe/sortjunction/flipped //For easier and cleaner mapping
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/wildcard/flipped
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/untagged/flipped
	icon_state = "pipe-j2s"

//A trunk joining to a disposal bin or outlet on the same turf
/obj/structure/disposalpipe/trunk
	icon_state = "pipe-t"
	var/obj/linked //The linked obj/structure/machinery/disposal or obj/disposaloutlet

/obj/structure/disposalpipe/trunk/Initialize(mapload, ...)
	. = ..()
	dpdir = dir
	update()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/disposalpipe/trunk/LateInitialize()
	. = ..()
	getlinked()

/obj/structure/disposalpipe/trunk/Destroy()
	linked = null
	return ..()

/obj/structure/disposalpipe/trunk/proc/getlinked()
	linked = null
	var/obj/structure/machinery/disposal/D = locate() in loc
	if(D)
		linked = D
		if(!D.trunk)
			D.trunk = src

	var/obj/structure/disposaloutlet/O = locate() in loc
	if(O)
		linked = O
	update()

//Override attackby so we disallow trunkremoval when somethings ontop
/obj/structure/disposalpipe/trunk/attackby(obj/item/I, mob/user)

	//Disposal constructors
	var/obj/structure/disposalconstruct/C = locate() in loc
	if(C && C.anchored)
		return
	var/turf/T = loc
	if(T.intact_tile)
		return //Prevent interaction with T-scanner revealed pipes
	add_fingerprint(user)
	if(iswelder(I))
		if(!HAS_TRAIT(I, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/W = I
		if(W.remove_fuel(0, user))
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			//Check if anything changed over 2 seconds
			var/turf/uloc = user.loc
			var/atom/wloc = W.loc
			user.visible_message(SPAN_NOTICE("[user] starts slicing [src]."),
			SPAN_NOTICE("You start slicing [src]."))
			sleep(30)
			if(!W.isOn())
				return
			if(user.loc == uloc && wloc == W.loc)
				welded()
			else
				to_chat(user, SPAN_WARNING("You must stay still while welding the pipe."))
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to cut the pipe."))

//Would transfer to next pipe segment, but we are in a trunk. If not entering from disposal bin, transfer to linked object (outlet or bin)
/obj/structure/disposalpipe/trunk/transfer(obj/structure/disposalholder/H)

	if(H.dir == DOWN) //We just entered from a disposer
		return ..() //So do base transfer proc
	//Otherwise, go to the linked object
	if(linked)
		var/obj/structure/disposaloutlet/O = linked
		if(istype(O) && H && H.loc)
			O.expel(H) //Expel at outlet
		else
			var/obj/structure/machinery/disposal/D = linked
			if(H && H.loc)
				D.expel(H) //Expel at disposal
	else
		if(H && H.loc)
			src.expel(H, loc, 0) //Expel at turf
	return null

/obj/structure/disposalpipe/trunk/nextdir(fromdir)
	if(fromdir == DOWN)
		return dir
	else
		return 0

//A broken pipe
/obj/structure/disposalpipe/broken
	icon_state = "pipe-b"
	dpdir = 0 //Broken pipes have dpdir = 0 so they're not found as 'real' pipes i.e. will be treated as an empty turf
	desc = "A broken piece of disposal pipe."

/obj/structure/disposalpipe/broken/Initialize(mapload, ...)
	. = ..()
	update()

//Called when welded, for broken pipe, remove and turn into scrap
/obj/structure/disposalpipe/broken/welded()
	qdel(src)

//The disposal outlet machine
/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "outlet"
	density = TRUE
	anchored = TRUE
	var/active = 0
	var/turf/target //This will be where the output objects are 'thrown' to.
	var/mode = 0
	var/range = 10

/obj/structure/disposaloutlet/Initialize(mapload, ...)
	. = ..()
	target = get_ranged_target_turf(src, dir, range)
	var/obj/structure/disposalpipe/trunk/trunk = locate() in loc
	if(trunk)
		trunk.linked = src //Link the pipe trunk to self

//Expel the contents of the holder object, then delete it. Called when the holder exits the outlet
/obj/structure/disposaloutlet/proc/expel(obj/structure/disposalholder/H)

	flick("[icon_state]-open", src)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 25, 0)
	sleep(20) //Wait until correct animation frame
	playsound(src, 'sound/machines/hiss.ogg', 25, 0)

	if(H)
		for(var/atom/movable/AM in H)
			AM.forceMove(loc)
			AM.pipe_eject(dir)
			spawn(5)
				AM.throw_atom(target, 3, SPEED_FAST)
		qdel(H)

/obj/structure/disposaloutlet/attackby(obj/item/I, mob/user)
	if(!I || !user)
		return
	add_fingerprint(user)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		if(mode == 0)
			mode = 1
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("You remove the screws around the power connection."))
		else if(mode == 1)
			mode = 0
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("You attach the screws around the power connection."))
	else if(iswelder(I) && mode == 1)
		if(!HAS_TRAIT(I, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/W = I
		if(W.remove_fuel(0, user))
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("You start slicing the floorweld off the disposal outlet."))
			if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(!src || !W.isOn())
					return
				to_chat(user, SPAN_NOTICE("You sliced the floorweld off the disposal outlet."))
				var/obj/structure/disposalconstruct/C = new(loc)
				transfer_fingerprints_to(C)
				C.ptype = 7 //7 =  outlet
				C.update()
				C.anchored = TRUE
				C.density = TRUE
				qdel(src)
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))

/obj/structure/disposaloutlet/retrieval
	name = "retrieval outlet"
	desc = "An outlet for the pneumatic disposal system."
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/disposaloutlet/retrieval/Initialize(mapload, ...)
	. = ..()
	GLOB.disposal_retrieval_list += src

/obj/structure/disposaloutlet/retrieval/Destroy()
	GLOB.disposal_retrieval_list -= src
	return ..()

/obj/structure/disposaloutlet/retrieval/attackby(obj/item/I, mob/user)
	return

//Called when movable is expelled from a disposal pipe or outlet, by default does nothing, override for special behaviour
/atom/movable/proc/pipe_eject(direction)
	return

//Check if mob has client, if so restore client view on eject
/mob/pipe_eject(direction)
	if(client)
		client.perspective = MOB_PERSPECTIVE
		client.eye = src

/obj/effect/decal/cleanable/blood/gibs/pipe_eject(direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()

	INVOKE_ASYNC(streak(dirs))

/obj/effect/decal/cleanable/blood/gibs/robot/pipe_eject(direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()

	INVOKE_ASYNC(streak(dirs))

#undef DISPOSALS_OFF
#undef DISPOSALS_CHARGING
#undef DISPOSALS_CHARGED
