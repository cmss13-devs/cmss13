#define UPGRADE_COOLDOWN 2 SECONDS

/obj/item/grab
	name = "grab"
	icon_state = "reinforce"
	icon = 'icons/mob/hud/screen1.dmi'
	flags_atom = NO_FLAGS
	flags_item = NOBLUDGEON|DELONDROP|ITEM_ABSTRACT
	layer = ABOVE_HUD_LAYER
	plane = ABOVE_HUD_PLANE
	item_state = "nothing"
	w_class = SIZE_HUGE
	var/atom/movable/grabbed_thing
	var/last_upgrade = 0 //used for cooldown between grab upgrades.


/obj/item/grab/Initialize()
	. = ..()
	last_upgrade = world.time

/obj/item/grab/dropped(mob/user)
	user.stop_pulling()
	. = ..()

/obj/item/grab/Destroy()
	grabbed_thing = null
	if(ismob(loc))
		var/mob/M = loc
		M.grab_level = 0
		M.stop_pulling()
	. = ..()

/obj/item/grab/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!user)
		return
	if(user.pulling == user.buckled)
		return //can't move the thing you're sitting on.
	if(user.grab_level >= GRAB_CARRY)
		return
	if(istype(target, /obj/effect))//if you click a blood splatter with a grab instead of the turf,
		target = get_turf(target) //we still try to move the grabbed thing to the turf.
	if(isturf(target))
		var/turf/T = target
		if(!T.density && T.Adjacent(user))
			var/data = SEND_SIGNAL(user.pulling, COMSIG_MOVABLE_PULLED, src)
			if(!(data & COMPONENT_IGNORE_ANCHORED) && user.pulling.anchored)
				user.stop_pulling()
				return
			var/move_dir = get_dir(user.pulling.loc, T)
			step(user.pulling, move_dir)
			var/mob/living/pmob = user.pulling
			if(istype(pmob))
				SEND_SIGNAL(pmob, COMSIG_MOB_MOVE_OR_LOOK, TRUE, move_dir, move_dir)
			return ATTACKBY_HINT_UPDATE_NEXT_MOVE


/obj/item/grab/attack_self(mob/user)
	..()
	var/grab_delay = UPGRADE_COOLDOWN
	var/list/grabdata = list("grab_delay" = grab_delay)
	SEND_SIGNAL(user, COMSIG_MOB_GRAB_UPGRADE, grabdata)
	grab_delay = grabdata["grab_delay"]

	if(!ismob(grabbed_thing) || world.time < (last_upgrade + grab_delay * user.get_skill_duration_multiplier(SKILL_CQC)))
		return

	if(!ishuman(user)) //only humans can reinforce a grab.
		if (isxeno(user))
			var/mob/living/carbon/xenomorph/xeno = user
			xeno.pull_power(grabbed_thing)
		return


	var/mob/victim = grabbed_thing
	var/max_grab_size = user.mob_size
	/// Amazing what you can do with a bit of dexterity.
	if(HAS_TRAIT(user, TRAIT_DEXTROUS))
		max_grab_size++
	/// Strong mobs can lift above their own weight.
	if(HAS_TRAIT(user, TRAIT_SUPER_STRONG))//NB; this will mean Yautja can bodily lift MOB_SIZE_XENO(3) and Synths can lift MOB_SIZE_XENO_SMALL(2)
		max_grab_size++
	if(victim.mob_size > max_grab_size || !(victim.status_flags & CANPUSH))
		return //can't tighten your grip on mobs bigger than you and mobs you can't push.
	last_upgrade = world.time

	switch(user.grab_level)
		if(GRAB_PASSIVE)
			progress_passive(user, victim)
		if(GRAB_AGGRESSIVE)
			progress_aggressive(user, victim)

	if(user.grab_level >= GRAB_AGGRESSIVE)
		ADD_TRAIT(victim, TRAIT_FLOORED, CHOKEHOLD_TRAIT)

/obj/item/grab/proc/progress_passive(mob/living/carbon/human/user, mob/living/victim)
	if(SEND_SIGNAL(victim, COMSIG_MOB_AGGRESSIVELY_GRABBED, user) & COMSIG_MOB_AGGRESIVE_GRAB_CANCEL)
		to_chat(user, SPAN_WARNING("You can't grab [victim] aggressively!"))
		return

	user.grab_level = GRAB_AGGRESSIVE
	playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
	user.visible_message(SPAN_WARNING("[user] has grabbed [victim] aggressively!"), null, null, 5)

/obj/item/grab/proc/progress_aggressive(mob/living/carbon/human/user, mob/living/victim)
	user.grab_level = GRAB_CHOKE
	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
	user.visible_message(SPAN_WARNING("[user] holds [victim] by the neck and starts choking them!"), null, null, 5)
	msg_admin_attack("[key_name(user)] started to choke [key_name(victim)] at [get_area_name(victim)]", victim.loc.x, victim.loc.y, victim.loc.z)
	victim.Move(user.loc, get_dir(victim.loc, user.loc))
	victim.update_transform(TRUE)

/obj/item/grab/attack(mob/living/dragged_mob, mob/living/user)
	if(dragged_mob == grabbed_thing)
		attack_self(user)
	else if(dragged_mob == user && user.pulling && isxeno(user))
		var/mob/living/carbon/xenomorph/xeno = user
		var/mob/living/carbon/pulled = xeno.pulling
		if(!istype(pulled))
			return
		if(isxeno(pulled) || issynth(pulled))
			to_chat(xeno, SPAN_WARNING("That wouldn't taste very good."))
			return 0
		if(pulled.buckled)
			to_chat(xeno, SPAN_WARNING("[pulled] is buckled to something."))
			return 0
		if(pulled.stat == DEAD && !pulled.chestburst)
			to_chat(xeno, SPAN_WARNING("Ew, [pulled] is already starting to rot."))
			return 0
		if(length(xeno.stomach_contents)) //Only one thing in the stomach at a time, please
			to_chat(xeno, SPAN_WARNING("We already have something in our stomach, there's no way that will fit."))
			return 0
			/* Saving this in case we want to allow devouring of dead bodies UNLESS their client is still online somewhere
			if(pulled.client) //The client is still inside the body
			else // The client is observing
				for(var/mob/dead/observer/G in player_list)
					if(ckey(G.mind.original.ckey) == pulled.ckey)
						to_chat(src, "You start to devour [pulled] but realize \he is already dead.")
						return */
		if(user.action_busy)
			to_chat(xeno, SPAN_WARNING("We are already busy with something."))
			return
		SEND_SIGNAL(xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL)
		xeno.visible_message(SPAN_DANGER("[xeno] starts to devour [pulled]!"),
		SPAN_DANGER("We start to devour [pulled]!"), null, 5)
		if(HAS_TRAIT(xeno, TRAIT_CLOAKED)) //cloaked don't show the visible message, so we gotta work around
			to_chat(pulled, FONT_SIZE_HUGE(SPAN_DANGER("[xeno] is trying to devour you!")))
		if(do_after(xeno, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			if(isxeno(pulled.loc) && !length(xeno.stomach_contents))
				to_chat(xeno, SPAN_WARNING("Someone already ate \the [pulled]."))
				return 0
			if(xeno.pulling == pulled && !pulled.buckled && (pulled.stat != DEAD || pulled.chestburst) && !length(xeno.stomach_contents)) //make sure you've still got them in your claws, and alive
				if(SEND_SIGNAL(pulled, COMSIG_MOB_DEVOURED, xeno) & COMPONENT_CANCEL_DEVOUR)
					return FALSE

				xeno.visible_message(SPAN_WARNING("[xeno] devours [pulled]!"),
					SPAN_WARNING("We devour [pulled]!"), null, 5)
				log_interact(xeno, pulled, "[key_name(xeno)] devoured [key_name(pulled)] at [get_area_name(xeno)]")

				if(ishuman(pulled))
					var/mob/living/carbon/human/pulled_human = pulled
					pulled_human.disable_lights()

				//Then, we place the mob where it ought to be
				xeno.stomach_contents.Add(pulled)
				xeno.devour_timer = world.time + 500 + rand(0,200) // 50-70 seconds
				pulled.forceMove(xeno)
				return TRUE
		if(!(pulled in xeno.stomach_contents))
			to_chat(xeno, SPAN_WARNING("We stop devouring [pulled]. They probably tasted gross anyways."))
		return 0
