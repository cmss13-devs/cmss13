/obj/structure/machinery/medical_pod
	name = "generic medical pod"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "sleeper"

	unslashable = TRUE
	density = TRUE
	anchored = TRUE

	/// the person in the pod
	var/mob/living/carbon/human/occupant = null
	/// do_after on entry via the move_inside verb
	var/entry_timer = null
	/// do_after on entry via the go_in proc
	var/go_in_timer = null
	/// do_after on entry via being put in by another person
	var/push_in_timer = 2 SECONDS
	/// stun on exiting, IN SECONDS BY DEFAULT, DO NOT PUT "SECONDS" AFTER IT
	var/exit_stun = 1
	/// surgical skill lock on putting people in
	var/skilllock = null

/obj/structure/machinery/medical_pod/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/structure/machinery/medical_pod/attack_hand(mob/living/user)
	eject()

/obj/structure/machinery/medical_pod/attack_alien(mob/living/carbon/xenomorph/M)
	eject()

/obj/structure/machinery/medical_pod/update_icon()
	if(occupant)
		icon_state = "[initial(icon_state)]_closed"
	else
		icon_state = "[initial(icon_state)]_open"

/obj/structure/machinery/medical_pod/verb/move_inside(mob/target)
	set src in oview(1)
	set category = "Object"
	set name = "Enter Pod"

	target = usr

	if (usr.stat || !(ishuman(usr)))
		return
	if (src.occupant)
		to_chat(usr, SPAN_BOLDNOTICE("\The [src] is already occupied!"))
		return
	if(inoperable())
		to_chat(usr, SPAN_NOTICE("\The [src] is non-functional!"))
		return
	if (usr.abiotic())
		to_chat(usr, SPAN_BOLDNOTICE("Subject cannot have abiotic items on."))
		return
	if(entry_timer)
		if(!do_after(usr, entry_timer, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			return
		if(src.occupant)
			to_chat(usr, SPAN_NOTICE("\The [src] is already occupied!"))
			return
	if(skilllock)
		if(!skillcheck(usr, SKILL_SURGERY, skilllock))
			to_chat(usr, SPAN_WARNING("You're going to need someone trained in the use of \the [src] to help you get into it."))
			return
	go_in(usr)
	add_fingerprint(usr)

/obj/structure/machinery/medical_pod/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Pod"

	if(usr.is_mob_incapacitated())
		return
	if(!occupant)
		to_chat(usr, SPAN_WARNING("There's nobody in \the [src] to eject!"))
		return
	if(isxeno(usr)) // let xenos eject people hiding inside.
		visible_message("[usr] starts forcing open \the [src]!")
		if(!do_after(usr, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			to_chat(usr, SPAN_WARNING("You were interrupted!"))
			return
		go_out()
		add_fingerprint(usr)
		return
	if(!ishuman(usr))
		return
	if(skilllock)
		if(!skillcheck(usr, SKILL_SURGERY, skilllock))
			to_chat(usr, SPAN_WARNING("You don't have the training to use this."))
			return

	if(!extra_eject_checks())
		return

	go_out()
	add_fingerprint(usr)
	return

/obj/structure/machinery/medical_pod/proc/extra_eject_checks()
	return TRUE

/obj/structure/machinery/medical_pod/MouseDrop_T(mob/target, mob/user)
	. = ..()
	var/mob/living/H = user
	if(!istype(H) || target != user) //cant make others get in. grab-click for this
		return

	move_inside(target)

/// the putter is the guy putting the person in the pod
/obj/structure/machinery/medical_pod/proc/go_in(mob/M, mob/putter)
	if(isxeno(M))
		return

	/// who is doing the work of putting/going in the scanner
	var/mob/main_character
	if(!putter)
		main_character = M
	else
		main_character = putter


	if(go_in_timer)
		if(!do_after(main_character, go_in_timer, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			return

	if(occupant)
		to_chat(main_character, SPAN_BOLDNOTICE("\The [src] is already occupied!"))
		return
	if(main_character != M)
		to_chat(main_character, SPAN_NOTICE("You move [M.name] inside \the [src]."))
	else
		to_chat(main_character, SPAN_NOTICE("You move into \the [src]."))

	M.forceMove(src)
	occupant = M
	update_use_power(USE_POWER_ACTIVE)
	update_icon()
	//prevents occupant's belonging from landing inside the machine
	for(var/obj/O in src)
		O.forceMove(loc)

/obj/structure/machinery/medical_pod/proc/go_out()
	if(!(src.occupant))
		return
	for(var/obj/O in src)
		O.forceMove(loc)

	occupant.forceMove(loc)
	occupant.update_med_icon()

	if(exit_stun)
		occupant.apply_effect(exit_stun, STUN) //Action delay when going out
		occupant.update_canmove() //Force the delay to go in action immediately
		occupant.visible_message(SPAN_WARNING("[occupant] pops out of \the [src]!"),
		SPAN_WARNING("You get out of \the [src] and get your bearings!"))

	occupant = null
	update_use_power(USE_POWER_IDLE)
	update_icon()
	playsound(src, 'sound/machines/hydraulics_3.ogg')

// attackby code

/obj/structure/machinery/medical_pod/attackby(obj/item/W, mob/user)

	if(!ishuman(user))
		return // no
	if(inoperable())
		to_chat(user, SPAN_NOTICE("\The [src] is non-functional!"))
		return
	if(istype(W, /obj/item/grab))
		var/mob/to_put_in
		var/obj/item/grab/G = W
		if(istype(G.grabbed_thing,/obj/structure/closet/bodybag/cryobag))
			var/obj/structure/closet/bodybag/cryobag/C = G.grabbed_thing
			if(!C.stasis_mob)
				to_chat(user, SPAN_WARNING("\The [C] is empty!"))
				return
			to_put_in = C.stasis_mob
			C.open()
			user.start_pulling(to_put_in)
		else if(ismob(G.grabbed_thing))
			to_put_in = G.grabbed_thing
		else
			return
		if(skilllock)
			if(!skillcheck(usr, SKILL_SURGERY, skilllock))
				to_chat(usr, SPAN_WARNING("You don't have the training to use \the [src]!"))
				return
		if(occupant)
			to_chat(user, SPAN_WARNING("\The [src] is already occupied!"))
			return
		if(to_put_in.abiotic())
			to_chat(user, SPAN_WARNING("Subject cannot have abiotic items on."))
			return
		if(!ishuman(to_put_in))
			to_chat(user, SPAN_WARNING("An unsupported lifeform was detected, aborting!"))
			return

		if(push_in_timer)
			visible_message(SPAN_NOTICE("[user] starts putting [to_put_in] into \the [src]."), null, null, 3)
			if(!do_after(usr, push_in_timer, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
				return
			if(src.occupant)
				to_chat(usr, SPAN_NOTICE("\The [src] is already occupied!"))
				return
			if(!G || !G.grabbed_thing)
				return

		go_in(to_put_in, user)
		add_fingerprint(user)

/obj/structure/machinery/medical_pod/autodoc/attackby(obj/item/W, mob/living/user)
	. = ..()
	if(istype(W, /obj/item/stack/sheet/metal))
		if(stored_metal == max_metal)
			to_chat(user, SPAN_WARNING("\The [src] is full!"))
			return
		var/obj/item/stack/sheet/metal/M = W
		var/sheets_to_eat = (round((max_metal - stored_metal), 100))/100
		if(!sheets_to_eat)
			sheets_to_eat = 1
		if(M.amount >= sheets_to_eat)
			stored_metal += sheets_to_eat * 100
			M.use(sheets_to_eat)
		else
			stored_metal += M.amount * 100
			M.use(M.amount)
		if(stored_metal > max_metal)
			stored_metal = max_metal
		to_chat(user, SPAN_NOTICE("\The [src] processes \the [W]."))
		playsound(user, 'sound/machines/outputclick1.ogg', 25, TRUE)
		return
