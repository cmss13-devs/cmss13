
/datum/xeno_strain/gambler

	name = DRONE_GAMBLER
	description = "WE ARE GOING TO MAKE A XILLION BUCKS!!"
	flavor_description = "I cant stop winning."
	icon_state_prefix = "cmplayer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/activable/transfer_plasma,
	)

	actions_to_add = list(
		/datum/action/xeno_action/activable/lets_go_gambling,
	)

	behavior_delegate_type = /datum/behavior_delegate/drone_gambler

/datum/xeno_strain/gambler/apply_strain(mob/living/carbon/xenomorph/drone/gamba)
	gamba.plasma_max = XENO_PLASMA_TIER_GAMBLER
	gamba.recalculate_everything()
	playsound(gamba, 'sound/voice/play_on_init_gamble.ogg', 50)

/datum/behavior_delegate/drone_gambler
	name = "Gambler Drone Behavior Delegate"

	//copy pasted from other delegates so we can actually use some of the abilities i guess
	var/shield_decay_time = 15 SECONDS // Time in deciseconds before our shield decays
	var/slash_charge_cdr = 3 SECONDS // Amount to reduce charge cooldown by per slash
	var/knockdown_amount = 1.6
	var/fling_distance = 3
	var/empower_targets = 0
	var/super_empower_threshold = 3
	var/dmg_buff_per_target = 2
	var/lunging = FALSE
	var/kills = 2
	var/invis_recharge_time = 20 SECONDS
	var/invis_start_time = -1 // Special value for when we're not invisible
	var/invis_duration = 30 SECONDS // so we can display how long the lurker is invisible to it
	var/base_fury = 999999
	var/next_slash_buffed = FALSE

/mob/living/carbon/xenomorph/drone/proc/queen_gut(atom/target)
	if(!iscarbon(target))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_HAULED))
		to_chat(src, SPAN_XENOWARNING("[target] needs to be released first."))
		return FALSE
	var/mob/living/carbon/victim = target

	if(get_dist(src, victim) > 1)
		return FALSE

	if(!check_state())
		return FALSE

	if(issynth(victim))
		var/obj/limb/head/synthhead = victim.get_limb("head")
		if(synthhead.status & LIMB_DESTROYED)
			return FALSE

	if(isxeno(victim))
		var/mob/living/carbon/xenomorph/xeno = victim
		if(hivenumber == xeno.hivenumber)
			to_chat(src, SPAN_WARNING("You can't bring yourself to harm a fellow sister to this magnitude."))
			return FALSE

	var/turf/cur_loc = victim.loc
	if(!istype(cur_loc))
		return FALSE

	if(action_busy)
		return FALSE

	if(!check_plasma(200))
		return FALSE

	visible_message(SPAN_XENOWARNING("[src] begins slowly lifting [victim] into the air."),
	SPAN_XENOWARNING("You begin focusing your anger as you slowly lift [victim] into the air."))
	if(do_after(src, 80, INTERRUPT_ALL, BUSY_ICON_HOSTILE, victim))
		if(!victim)
			return FALSE
		if(victim.loc != cur_loc)
			return FALSE
		if(!check_plasma(200))
			return FALSE

		use_plasma(200)

		visible_message(SPAN_XENODANGER("[src] viciously smashes and wrenches [victim] apart!"),
		SPAN_XENODANGER("You suddenly unleash pure anger on [victim], instantly wrenching \him apart!"))
		emote("roar")

		attack_log += text("\[[time_stamp()]\] <font color='red'>gibbed [key_name(victim)]</font>")
		victim.attack_log += text("\[[time_stamp()]\] <font color='orange'>was gibbed by [key_name(src)]</font>")
		victim.gib(create_cause_data("Queen gutting", src))

		stop_pulling()
		return TRUE

/mob/living/carbon/xenomorph/drone/start_pulling(atom/movable/movable_atom, lunge)
	if(!check_state())
		return FALSE

	if(!isliving(movable_atom))
		return FALSE
	var/mob/living/living_mob = movable_atom
	var/should_neckgrab = !(src.can_not_harm(living_mob)) && lunge

	if(!QDELETED(living_mob) && !QDELETED(living_mob.pulledby) && living_mob != src)
		visible_message(SPAN_WARNING("[src] has broken [living_mob.pulledby]'s grip on [living_mob]!"), null, null, 5)
		living_mob.pulledby.stop_pulling()

	. = ..(living_mob, lunge, should_neckgrab)

	if(.)
		if(isxeno(living_mob))
			var/mob/living/carbon/xenomorph/xeno = living_mob
			if(xeno.tier >= 2)
				return

		if(should_neckgrab && living_mob.mob_size < MOB_SIZE_BIG)
			living_mob.drop_held_items()
			var/duration = get_xeno_stun_duration(living_mob, 2)
			living_mob.KnockDown(duration)
			living_mob.Stun(duration)
			if(living_mob.pulledby != src)
				return
			visible_message(SPAN_XENOWARNING("[src] grabs [living_mob] by the throat!"),
			SPAN_XENOWARNING("We grab [living_mob] by the throat!"))

/mob/living/carbon/xenomorph/drone/proc/stop_lunging(world_time)

/mob/living/carbon/xenomorph/drone/hitby(atom/movable/movable_atom)
	if(ishuman(movable_atom))
		return
	..()


/datum/action/xeno_action/activable/lets_go_gambling

	name = "Let's go gambling"
	action_icon_state = "gardener_plant"
	plasma_cost = 0
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS

	var/list/real_jackpot = list(
		/datum/action/xeno_action/activable/destroy,
		/datum/action/xeno_action/activable/fluff_ability_5,
	)

	var/list/jackpot = list(
		/datum/action/xeno_action/activable/gut,
		/datum/action/xeno_action/onclick/screech,
		/datum/action/xeno_action/activable/fluff_ability_2,
		/datum/action/xeno_action/activable/fluff_ability_3,
	)

	var/list/high_end_abilities = list(
		/datum/action/xeno_action/onclick/crusher_shield,
		/datum/action/xeno_action/activable/prae_abduct,
		/datum/action/xeno_action/onclick/empower,
		/datum/action/xeno_action/onclick/apprehend,
		/datum/action/xeno_action/onclick/feralrush,
		/datum/action/xeno_action/activable/feralfrenzy,
		/datum/action/xeno_action/onclick/predalien_roar,
		/datum/action/xeno_action/activable/prae_retrieve,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/activable/fluff_ability_3,
		/datum/action/xeno_action/activable/fluff_ability_4,
	)

	var/list/medium_end_abilities = list(
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/fling,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/pierce,
		/datum/action/xeno_action/onclick/crusher_stomp,
		/datum/action/xeno_action/activable/cleave,
		/datum/action/xeno_action/activable/oppressor_punch,
		/datum/action/xeno_action/activable/tail_lash,
		/datum/action/xeno_action/activable/pounce/crusher_charge,
		/datum/action/xeno_action/activable/scissor_cut,
		/datum/action/xeno_action/activable/high_gallop,
		/datum/action/xeno_action/onclick/tremor,
		/datum/action/xeno_action/activable/boiler_trap,
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/onclick/lurker_assassinate,
		/datum/action/xeno_action/activable/fluff_ability_1,
	)

	var/strip_size = 7
	var/center_slot = 4
	var/list/spin_delays = list(1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 5, 7, 9, 12)
	var/list/slot_objects = list()
	var/list/scroll_strip = list()
	var/strip_pos = 1
	var/delay_index = 1
	var/winner_icon
	var/winner_ability
	var/winner_tier


/datum/action/xeno_action/activable/lets_go_gambling/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/enterpanuer_drone = owner

	if(!enterpanuer_drone.check_state() || enterpanuer_drone.action_busy)
		return

	if(!action_cooldown_check())
		return

	var/list/chosen_tier = pick(20;high_end_abilities, 75;medium_end_abilities, 4;jackpot, 1;real_jackpot)

	if(chosen_tier == real_jackpot)
		winner_tier = "real_jackpot"
	else if(chosen_tier == jackpot)
		winner_tier = "jackpot"
	else if(chosen_tier == high_end_abilities)
		winner_tier = "high_end"
	else
		winner_tier = "medium_end"

	winner_ability = pick(chosen_tier)

	winner_icon = initial(winner_ability:action_icon_state)

	var/list/all_icons = icon_states('icons/mob/hud/actions_xeno.dmi')
	// lets not use the templates
	var/list/blacklist = list("no name", "template", "template_active", "template_on", "blank", "border_reference", "+stack_3", "+stack_2", "+stack_1", "empowered")
	for(var/bad in blacklist)
		all_icons.Remove(bad)

	scroll_strip = list()
	var/pre_count = 18
	var/post_count = center_slot - 1
	for(var/i = 1 to pre_count)
		scroll_strip += pick(all_icons)
	scroll_strip += winner_icon
	for(var/i = 1 to post_count)
		scroll_strip += pick(all_icons)

	build_strip_slots(enterpanuer_drone)

	strip_pos = 1
	delay_index = 1

	update_strip_display(enterpanuer_drone)

	playsound(enterpanuer_drone, 'sound/voice/play_on_use.ogg')
	addtimer(CALLBACK(src, PROC_REF(spin_step), enterpanuer_drone), spin_delays[1] DECISECONDS, TIMER_STOPPABLE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/lets_go_gambling/proc/build_strip_slots(mob/living/carbon/xenomorph/gamba)
	if(!gamba.client)
		return

	clear_strip_slots(gamba)

	for(var/i = 1 to strip_size)
		var/obj/effect/detector_blip/slot = new /obj/effect/detector_blip()
		var/col_offset = 4 + (2 * i)
		slot.screen_loc = "WEST+[i-1]:[col_offset],NORTH-2:26"
		slot.icon = 'icons/mob/hud/actions_xeno.dmi'
		slot.icon_state = "blank"
		slot.plane = ABOVE_TACMAP_PLANE
		gamba.client.add_to_screen(slot)
		slot_objects += slot

/datum/action/xeno_action/activable/lets_go_gambling/proc/clear_strip_slots(mob/living/carbon/xenomorph/gamba)
	for(var/obj/effect/detector_blip/slot as anything in slot_objects)
		if(gamba && gamba.client)
			gamba.client.remove_from_screen(slot)
		qdel(slot)
	slot_objects = list()

/datum/action/xeno_action/activable/lets_go_gambling/proc/update_strip_display(mob/living/carbon/xenomorph/gamba)
	if(!gamba.client)
		return

	for(var/i = 1 to strip_size)
		var/scroll_index = ((strip_pos + i - 2) % scroll_strip.len) + 1
		var/obj/effect/detector_blip/slot = slot_objects[i]
		if(!slot)
			continue
		slot.icon_state = scroll_strip[scroll_index]
		slot.color = null
		slot.transform = null

/datum/action/xeno_action/activable/lets_go_gambling/proc/spin_step(mob/living/carbon/xenomorph/gamba)
	if(QDELETED(src) || QDELETED(gamba))
		return

	strip_pos++
	update_strip_display(gamba)

	playsound(get_turf(gamba), 'sound/items/detector_ping_1.ogg', 30, FALSE)

	if(delay_index >= spin_delays.len)
		finish_spin(gamba)
		return

	delay_index++
	addtimer(CALLBACK(src, PROC_REF(spin_step), gamba), spin_delays[delay_index] DECISECONDS, TIMER_STOPPABLE)

/datum/action/xeno_action/activable/lets_go_gambling/proc/finish_spin(mob/living/carbon/xenomorph/gamba)
	if(QDELETED(gamba))
		return
	var/obj/effect/detector_blip/center = slot_objects[center_slot]
	if(center)
		center.overlays += image('icons/mob/hud/actions_xeno.dmi', center, "template_won")

	switch(winner_tier)
		if("real_jackpot")
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), gamba, 'sound/voice/play_on_actual_win.ogg', 50, FALSE), 1.25 SECONDS)
		if("jackpot")
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), gamba, 'sound/voice/play_on_rare.ogg', 50, FALSE), 1.25 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), gamba, 'sound/voice/play_on_jackpot.ogg', 50, FALSE), 1.25 SECONDS)
		if("high_end")
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), gamba, 'sound/voice/play_on_rare.ogg', 50, FALSE), 1.25 SECONDS)
		else
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), gamba, 'sound/voice/play_on_fail.ogg', 50, FALSE), 1.25 SECONDS)

	to_chat(gamba, SPAN_XENODANGER("You rolled: [initial(winner_ability:name)]!"))

	var/datum/action/action_given = give_action(gamba, winner_ability)
	RegisterSignal(action_given, COMSIG_XENO_ACTION_USED, PROC_REF(on_ability_used))
	addtimer(CALLBACK(src, PROC_REF(on_ability_expired), action_given), 10 SECONDS, TIMER_STOPPABLE)
	addtimer(CALLBACK(src, PROC_REF(clear_strip_slots), gamba), 2 SECONDS, TIMER_STOPPABLE)

/datum/action/xeno_action/activable/lets_go_gambling/proc/on_ability_used(datum/action/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_XENO_ACTION_USED)
	INVOKE_ASYNC(src, PROC_REF(remove_granted_ability), source)

/datum/action/xeno_action/activable/lets_go_gambling/proc/on_ability_expired(datum/action/source)
	if(QDELETED(source))
		return
	UnregisterSignal(source, COMSIG_XENO_ACTION_USED)
	remove_granted_ability(source)

/datum/action/xeno_action/activable/lets_go_gambling/proc/remove_granted_ability(datum/action/source)
	if(QDELETED(source))
		return
	if(source.owner)
		source.hide_from(source.owner)

// fluff stuff so we can add more to the pool to grant variety

/datum/action/xeno_action/activable/fluff_ability_1
	name = "Mystery Ability"
	action_icon_state = "gardener_plant"
	plasma_cost = 0
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS

/datum/action/xeno_action/activable/fluff_ability_1/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/gamba_drone = owner

	if(!gamba_drone.check_state())
		return

	target = get_turf(gamba_drone)

	playsound(src, 'sound/effects/phasein.ogg', 25, 1)
	new /mob/living/simple_animal/hostile/carp(target)
	new /mob/living/simple_animal/hostile/carp(target)
	new /mob/living/simple_animal/hostile/carp(target)

	apply_cooldown()
	return ..()


/datum/action/xeno_action/activable/fluff_ability_2
	name = "Mystery Ability"
	action_icon_state = "gardener_plant"
	plasma_cost = 0
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS

/datum/action/xeno_action/activable/fluff_ability_2/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/gamba_drone = owner

	if(!gamba_drone.check_state())
		return

	target = get_turf(gamba_drone)

	playsound(src, 'sound/effects/phasein.ogg', 25, 1)
	new /mob/living/simple_animal/small/cat(target)
	new /mob/living/simple_animal/small/cat(target)
	new /mob/living/simple_animal/small/cat(target)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/fluff_ability_3
	name = "Mystery Ability"
	action_icon_state = "gardener_plant"
	plasma_cost = 0
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS

/datum/action/xeno_action/activable/fluff_ability_3/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/gamba_drone = owner

	if(!gamba_drone.check_state())
		return

	var/datum/cause_data/cause_data = create_cause_data("trolled", gamba_drone)

	cell_explosion(gamba_drone, 200, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)

	apply_cooldown()
	..()


/datum/action/xeno_action/activable/fluff_ability_4
	name = "Mystery Ability"
	action_icon_state = "gardener_plant"
	plasma_cost = 0
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS

/datum/action/xeno_action/activable/fluff_ability_4/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/gamba_drone = owner

	if(!gamba_drone.check_state())
		return

	target = get_turf(gamba_drone)

	playsound(src, 'sound/effects/phasein.ogg', 25, 1)
	new /mob/living/simple_animal/hostile/retaliate/giant_lizard(target)
	new /mob/living/simple_animal/hostile/retaliate/giant_lizard(target)
	new /mob/living/simple_animal/hostile/retaliate/giant_lizard(target)

	apply_cooldown()
	return ..()


/datum/action/xeno_action/activable/fluff_ability_5
	name = "Mystery Ability"
	action_icon_state = "gardener_plant"
	plasma_cost = 0
	action_type = XENO_ACTION_CLICK

	var/datum/hive_status/hive
	var/list/transported_xenos

// trollface
/datum/action/xeno_action/activable/fluff_ability_5/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/drone/Q = owner
	if(!Q.check_state())
		return FALSE

	if(Q.action_busy)
		return FALSE

	var/turf/T = get_turf(A)
	if(!check_turf(Q, T))
		return FALSE
	if(!do_after(Q, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		return FALSE
	if(!check_turf(Q, T))
		return FALSE

	for(var/i in transported_xenos)
		UnregisterSignal(i, COMSIG_MOVABLE_PRE_MOVE)

	to_chat(Q, SPAN_XENONOTICE("You rally the hive to the queen beacon!"))
	xeno_message(SPAN_XENOANNOUNCE("[owner] has used a queen beacon, PREPARE TO TELEPORT."), hivenumber = Q.hive.hivenumber)
	LAZYCLEARLIST(transported_xenos)
	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, PROC_REF(tunnel_xeno))
	for(var/xeno in Q.hive.totalXenos)
		tunnel_xeno(src, xeno)

	addtimer(CALLBACK(src, PROC_REF(transport_xenos), T), 3 SECONDS)
	return ..()

/datum/action/xeno_action/activable/fluff_ability_5/proc/tunnel_xeno(datum/source, mob/living/carbon/xenomorph/X)
	SIGNAL_HANDLER
	if(X.z == owner.z)
		to_chat(X, SPAN_XENONOTICE("You begin tunneling towards the queen beacon!"))
		RegisterSignal(X, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(cancel_movement))
		LAZYADD(transported_xenos, X)
		playsound(X, 'sound/voice/alien_echoroar_3.ogg', 35)

/datum/action/xeno_action/activable/fluff_ability_5/proc/transport_xenos(turf/target)
	UnregisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN)
	for(var/xeno in transported_xenos)
		var/mob/living/carbon/xenomorph/X = xeno
		to_chat(X, SPAN_XENONOTICE("You tunnel to the queen beacon!"))
		UnregisterSignal(X, COMSIG_MOVABLE_PRE_MOVE)
		if(target)
			X.forceMove(target)

/datum/action/xeno_action/activable/fluff_ability_5/proc/cancel_movement()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_MOVE

/datum/action/xeno_action/activable/fluff_ability_5/proc/check_turf(mob/living/carbon/xenomorph/queen/Q, turf/T)
	if(!T || T.density)
		to_chat(Q, SPAN_XENOWARNING("You can't place a queen beacon here."))
		return FALSE

	if(T.z != Q.z)
		to_chat(Q, SPAN_XENOWARNING("That's too far away!"))
		return FALSE

	var/obj/effect/alien/weeds/located_weeds = locate() in T
	if(!located_weeds)
		to_chat(Q, SPAN_XENOWARNING("You need to place the queen beacon on weeds."))
		return FALSE

	return TRUE
