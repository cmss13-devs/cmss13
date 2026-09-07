#define UPGRADE_COOLDOWN 2 SECONDS
#define XENO_GRAB_MULTIPLIER 0.2

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
	return ..()

/obj/item/grab/Destroy()
	grabbed_thing = null
	if(ismob(loc))
		var/mob/M = loc
		M.grab_level = 0
		M.stop_pulling()
	return ..()

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
		var/turf/turf_target = target
		if(!turf_target.density && turf_target.Adjacent(user))
			var/data = SEND_SIGNAL(user.pulling, COMSIG_MOVABLE_PULLED, src)
			if(!(data & COMPONENT_IGNORE_ANCHORED) && user.pulling.anchored)
				user.stop_pulling()
				return
			var/move_dir = get_dir(user.pulling.loc, turf_target)
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

	if(!ismob(grabbed_thing))
		return

	var/user_is_xeno = isxeno(user)

	if(user_is_xeno)
		if(world.time < (last_upgrade + grab_delay * XENO_GRAB_MULTIPLIER)) // Only enough delay for preventing accidental upgrades
			return
		var/mob/living/carbon/xenomorph/xeno = user
		xeno.pull_power(src)
		return

	if(world.time < (last_upgrade + grab_delay * user.get_skill_duration_multiplier(SKILL_CQC)))
		return

	if(!ishuman(user)) //only humans can reinforce a grab in this proc
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

/obj/item/grab/use_unique_action()
	..()
	if(isxeno(usr))
		unique_action(usr)

/obj/item/grab/unique_action(mob/user)
	if(isxeno(user))
		var/mob/living/carbon/xenomorph/current_xeno = user
		current_xeno.rip_limb()

/obj/item/grab/proc/progress_passive(mob/living/carbon/human/user, mob/living/victim)
	if(SEND_SIGNAL(victim, COMSIG_MOB_AGGRESSIVELY_GRABBED, user) & COMSIG_MOB_AGGRESSIVE_GRAB_CANCEL)
		to_chat(user, SPAN_WARNING("You can't grab [victim] aggressively!"))
		return

	user.grab_level = GRAB_AGGRESSIVE
	icon_state = "disarm/kill"
	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
	user.visible_message(SPAN_WARNING("[user] has grabbed [victim] aggressively!"), null, null, 5)

/obj/item/grab/proc/progress_aggressive(mob/living/carbon/human/user, mob/living/victim)
	user.grab_level = GRAB_CHOKE
	icon_state = "disarm/kill1"
	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
	user.visible_message(SPAN_WARNING("[user] holds [victim] by the neck and starts choking them!"), null, null, 5)
	msg_admin_attack("[key_name(user)] started to choke [key_name(victim)] at [get_area_name(victim)]", victim.loc.x, victim.loc.y, victim.loc.z)
	victim.Move(user.loc, get_dir(victim.loc, user.loc))
	victim.update_transform(TRUE)

/obj/item/grab/proc/progress_defensive_xeno(mob/living/carbon/xenomorph/xeno_user, mob/living/victim)
	last_upgrade = world.time
	xeno_user.grab_level = GRAB_AGGRESSIVE
	icon_state = "!reinforce"
	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
	xeno_user.visible_message(SPAN_WARNING("[xeno_user] has grabbed [victim] defensively!"), null, null, 5)

/obj/item/grab/attack(mob/living/dragged_mob, mob/living/user)
	if(dragged_mob == grabbed_thing)
		attack_self(user)
		return
	if(dragged_mob == user && user.pulling && isxeno(user))
		var/grab_delay = UPGRADE_COOLDOWN
		var/list/grabdata = list("grab_delay" = grab_delay)
		SEND_SIGNAL(user, COMSIG_MOB_GRAB_UPGRADE, grabdata)
		grab_delay = grabdata["grab_delay"]

		if(world.time < (last_upgrade + grab_delay * XENO_GRAB_MULTIPLIER)) // Only enough delay for preventing accidental upgrades
			return

		var/mob/living/carbon/xenomorph/xeno = user
		xeno.pull_power(src)
		return

#undef UPGRADE_COOLDOWN
#undef XENO_GRAB_MULTIPLIER
