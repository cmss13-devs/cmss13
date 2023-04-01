//Xenomorph General Procs And Functions - Colonial Marines
//LAST EDIT: APOPHIS 22MAY16

//Send a message to all xenos. Mostly used in the deathgasp display
/proc/xeno_message(message = null, size = 3, hivenumber = XENO_HIVE_NORMAL)
	if(!message)
		return

	var/fontsize_style
	switch(size)
		if(1)
			fontsize_style = "medium"
		if(2)
			fontsize_style = "big"
		if(3)
			fontsize_style = "large"

	if(SSticker.mode && SSticker.mode.xenomorphs.len) //Send to only xenos in our gamemode list. This is faster than scanning all mobs
		for(var/datum/mind/L in SSticker.mode.xenomorphs)
			var/mob/living/carbon/M = L.current
			if(M && istype(M) && !M.stat && M.client && (!hivenumber || M.ally_of_hivenumber(hivenumber))) //Only living and connected xenos
				to_chat(M, SPAN_XENODANGER("<span class=\"[fontsize_style]\"> [message]</span>"))

//Sends a maptext alert to our currently selected squad. Does not make sound.
/proc/xeno_maptext(text = "", title_text = "", hivenumber = XENO_HIVE_NORMAL)
	if(text == "" || !hivenumber)
		return //Logic

	if(SSticker.mode && SSticker.mode.xenomorphs.len) //Send to only xenos in our gamemode list. This is faster than scanning all mobs
		for(var/datum/mind/L in SSticker.mode.xenomorphs)
			var/mob/living/carbon/M = L.current
			if(M && istype(M) && !M.stat && M.client && M.ally_of_hivenumber(hivenumber)) //Only living and connected xenos
				M.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>[title_text]</u></span><br>" + text, /atom/movable/screen/text/screen_text/command_order, "#b491c8")

/proc/xeno_message_all(message = null, size = 3)
	xeno_message(message, size)

//Adds stuff to your "Status" pane -- Specific castes can have their own, like carrier hugger count
//Those are dealt with in their caste files.
/mob/living/carbon/xenomorph/get_status_tab_items()
	. = ..()

	. += "Name: [name]"

	. += ""

	. += "Health: [round(health)]/[round(maxHealth)]"
	. += "Armor: [round(0.01*armor_integrity*armor_deflection)+(armor_deflection_buff-armor_deflection_debuff)]/[round(armor_deflection)]"
	. += "Plasma: [round(plasma_stored)]/[round(plasma_max)]"
	. += "Slash Damage: [round((melee_damage_lower+melee_damage_upper)/2)]"

	var/shieldtotal = 0
	for (var/datum/xeno_shield/XS in xeno_shields)
		shieldtotal += XS.amount

	. += "Shield: [shieldtotal]"

	if(selected_ability)
		. += ""
		. += "Selected Ability: [selected_ability.name]"
		if(selected_ability.charges != NO_ACTION_CHARGES)
			. += "Charges Left: [selected_ability.charges]"

		if(selected_ability.cooldown_timer_id != TIMER_ID_NULL)
			. += "On Cooldown: [DisplayTimeText(timeleft(selected_ability.cooldown_timer_id))]"

	. += ""

	var/stored_evolution = round(evolution_stored)
	var/evolve_progress

	if(caste && caste.evolution_allowed)
		evolve_progress = "[min(stored_evolution, evolution_threshold)]/[evolution_threshold]"
		if(hive && !hive.allow_no_queen_actions && !caste?.evolve_without_queen)
			if(!hive.living_xeno_queen)
				evolve_progress += " (NO QUEEN)"
			else if(!(hive.living_xeno_queen.ovipositor || hive.evolution_without_ovipositor))
				evolve_progress += " (NO OVIPOSITOR)"

	if(evolve_progress)
		. += "Evolve Progress: [evolve_progress]"
	if(stored_evolution > evolution_threshold)
		. += "Bonus Evolution: [stored_evolution - evolution_threshold]"

	. += ""

	if (behavior_delegate)
		var/datum/behavior_delegate/MD = behavior_delegate
		. += MD.append_to_stat()

	var/list/statdata = list()
	SEND_SIGNAL(src, COMSIG_XENO_APPEND_TO_STAT, statdata)
	if(length(statdata))
		. += statdata

	. += ""
	if(!ignores_pheromones)
		//Very weak <= 1.0, weak <= 2.0, no modifier 2-3, strong <= 3.5, very strong <= 4.5
		var/msg_holder = "-"
		if(frenzy_aura)
			msg_holder = get_pheromone_aura_strength(frenzy_aura)
		. += "Frenzy: [msg_holder]"
		msg_holder = "-"
		if(warding_aura)
			msg_holder = get_pheromone_aura_strength(warding_aura)
		. += "Warding: [msg_holder]"
		msg_holder = "-"
		if(recovery_aura)
			msg_holder = get_pheromone_aura_strength(recovery_aura)
		. += "Recovery: [msg_holder]"
		. += ""

	if(hive)
		if(!hive.living_xeno_queen)
			. += "Queen's Location: NO QUEEN"
		else if(!(caste_type == XENO_CASTE_QUEEN))
			. += "Queen's Location: [hive.living_xeno_queen.loc.loc.name]"

		if(hive.slashing_allowed == XENO_SLASH_ALLOWED)
			. += "Slashing: PERMITTED"
		else
			. += "Slashing: FORBIDDEN"

		if(hive.construction_allowed == XENO_LEADER)
			. += "Construction Placement: LEADERS"
		else if(hive.construction_allowed == NORMAL_XENO)
			. += "Construction Placement: ANYONE"
		else if(hive.construction_allowed == XENO_NOBODY)
			. += "Construction Placement: NOBODY"
		else
			. += "Construction Placement: QUEEN"

		if(hive.destruction_allowed == XENO_LEADER)
			. += "Special Structure Destruction: LEADERS"
		else if(hive.destruction_allowed == NORMAL_XENO)
			. += "Special Structure Destruction: BUILDERS and LEADERS"
		else if(hive.construction_allowed == XENO_NOBODY)
			. += "Construction Placement: NOBODY"
		else
			. += "Special Structure Destruction: QUEEN"

		if(hive.hive_orders)
			. += "Hive Orders: [hive.hive_orders]"
		else
			. += "Hive Orders: -"

	. += ""

//A simple handler for checking your state. Used in pretty much all the procs.
/mob/living/carbon/xenomorph/proc/check_state(permissive = 0)
	if(!permissive)
		if(is_mob_incapacitated() || lying || buckled || evolving || !isturf(loc))
			to_chat(src, SPAN_WARNING("You cannot do this in your current state."))
			return FALSE
		else if(caste_type != XENO_CASTE_QUEEN && observed_xeno)
			to_chat(src, SPAN_WARNING("You cannot do this in your current state."))
			return FALSE
	else
		if(is_mob_incapacitated() || buckled || evolving)
			to_chat(src, SPAN_WARNING("You cannot do this in your current state."))
			return FALSE

	return TRUE

//Checks your plasma levels and gives a handy message.
/mob/living/carbon/xenomorph/proc/check_plasma(value)
	if(stat)
		to_chat(src, SPAN_WARNING("You cannot do this in your current state."))
		return FALSE

	if(value)
		if(plasma_stored < value)
			to_chat(src, SPAN_WARNING("You do not have enough plasma to do this. You require [value] plasma but have only [plasma_stored] stored."))
			return FALSE
	return TRUE

/mob/living/carbon/xenomorph/proc/use_plasma(value)
	plasma_stored = max(plasma_stored - value, 0)
	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/mob/living/carbon/xenomorph/proc/gain_plasma(value)
	plasma_stored = min(plasma_stored + value, plasma_max)
	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/mob/living/carbon/xenomorph/proc/gain_health(value)
	if(bruteloss == 0 && fireloss == 0)
		return

	var/list/L = list("healing" = value)
	SEND_SIGNAL(src, COMSIG_XENO_ON_HEAL, L)
	value = L["healing"]
	if(value < 0)
		value = 0

	if(bruteloss < value)
		value -= bruteloss
		bruteloss = 0
		if(fireloss < value)
			fireloss = 0
		else
			fireloss -= value
	else
		bruteloss -= value

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()


/mob/living/carbon/xenomorph/proc/gain_armor_percent(value)
	armor_integrity = min(armor_integrity + value, 100)


//Strip all inherent xeno verbs from your caste. Used in evolution.
/mob/living/carbon/xenomorph/proc/remove_inherent_verbs()
	if(inherent_verbs)
		remove_verb(src, inherent_verbs)

//Add all your inherent caste verbs and procs. Used in evolution.
/mob/living/carbon/xenomorph/proc/add_inherent_verbs()
	if(inherent_verbs)
		add_verb(src, inherent_verbs)


//Adds or removes a delay to movement based on your caste. If speed = 0 then it shouldn't do much.
//Runners are -2, -4 is BLINDLINGLY FAST, +2 is fat-level
/mob/living/carbon/xenomorph/movement_delay()
	. = ..()

	. += ability_speed_modifier

	if(frenzy_aura)
		. -= (frenzy_aura * 0.05)

	if(agility)
		. += caste.agility_speed_increase

	var/obj/effect/alien/weeds/W = locate(/obj/effect/alien/weeds) in loc
	if (W)
		if (W.linked_hive.hivenumber == hivenumber)
			. *= 0.95

	var/obj/effect/alien/resin/sticky/fast/FR = locate(/obj/effect/alien/resin/sticky/fast) in loc
	if (FR && FR.hivenumber == hivenumber)
		. *= 0.8

	if(superslowed)
		. += XENO_SUPERSLOWED_AMOUNT

	if(slowed && !superslowed)
		. += XENO_SLOWED_AMOUNT

	var/list/L = list("speed" = .)
	SEND_SIGNAL(src, COMSIG_XENO_MOVEMENT_DELAY, L)
	. = L["speed"]

	move_delay = .


/mob/living/carbon/xenomorph/show_inv(mob/user)
	return

/mob/living/carbon/xenomorph/proc/pounced_mob(mob/living/L)
	// This should only be called back by a mob that has pounce, so no need to check
	var/datum/action/xeno_action/activable/pounce/pounceAction = get_xeno_action_by_type(src, /datum/action/xeno_action/activable/pounce)

	// Unconscious or dead, or not throwing but used pounce.
	if(!check_state() || (!throwing && !pounceAction.action_cooldown_check()))
		return

	var/mob/living/carbon/M = L
	if(M.stat || M.mob_size >= MOB_SIZE_BIG || can_not_harm(L) || M == src)
		throwing = FALSE
		return

	if (pounceAction.can_be_shield_blocked)
		if(ishuman(M) && (M.dir in reverse_nearby_direction(dir)))
			var/mob/living/carbon/human/H = M
			if(H.check_shields(15, "the pounce")) //Human shield block.
				visible_message(SPAN_DANGER("[src] slams into [H]!"),
					SPAN_XENODANGER("You slam into [H]!"), null, 5)
				apply_effect(1, WEAKEN)
				throwing = FALSE //Reset throwing manually.
				playsound(H, "bonk", 75, FALSE) //bonk
				return

			if(isyautja(H))
				if(H.check_shields(0, "the pounce", 1))
					visible_message(SPAN_DANGER("[H] blocks the pounce of [src] with the combistick!"), SPAN_XENODANGER("[H] blocks your pouncing form with the combistick!"), null, 5)
					apply_effect(3, WEAKEN)
					throwing = FALSE
					playsound(H, "bonk", 75, FALSE)
					return
				else if(prob(75)) //Body slam the fuck out of xenos jumping at your front.
					visible_message(SPAN_DANGER("[H] body slams [src]!"),
						SPAN_XENODANGER("[H] body slams you!"), null, 5)
					apply_effect(3, WEAKEN)
					throwing = FALSE
					return
			if(iscolonysynthetic(H) && prob(60))
				visible_message(SPAN_DANGER("[H] withstands being pounced and slams down [src]!"),
					SPAN_XENODANGER("[H] throws you down after withstanding the pounce!"), null, 5)
				apply_effect(1.5, WEAKEN)
				throwing = FALSE
				return


	visible_message(SPAN_DANGER("[src] [pounceAction.ability_name] onto [M]!"), SPAN_XENODANGER("You [pounceAction.ability_name] onto [M]!"), null, 5)

	if (pounceAction.knockdown)
		M.apply_effect(pounceAction.knockdown_duration, WEAKEN)
		step_to(src, M)

	if (pounceAction.freeze_self)
		if(pounceAction.freeze_play_sound)
			playsound(loc, rand(0, 100) < 95 ? 'sound/voice/alien_pounce.ogg' : 'sound/voice/alien_pounce2.ogg', 25, 1)
		canmove = FALSE
		frozen = TRUE
		pounceAction.freeze_timer_id = addtimer(CALLBACK(src, PROC_REF(unfreeze)), pounceAction.freeze_time, TIMER_STOPPABLE)

	pounceAction.additional_effects(M)

	if(pounceAction.slash)
		M.attack_alien(src, pounceAction.slash_bonus_damage)

	throwing = FALSE //Reset throwing since something was hit.

/mob/living/carbon/xenomorph/proc/pounced_mob_wrapper(mob/living/L)
	pounced_mob(L)

/mob/living/carbon/xenomorph/proc/pounced_obj(obj/O)
	var/datum/action/xeno_action/activable/pounce/pounceAction = get_xeno_action_by_type(src, /datum/action/xeno_action/activable/pounce)

	// Unconscious or dead, or not throwing but used pounce
	if(!check_state() || (!throwing && !pounceAction.action_cooldown_check()))
		obj_launch_collision(O)
		return

	if (pounceAction.should_destroy_objects)
		if(istype(O, /obj/structure/surface/table) || istype(O, /obj/structure/surface/rack) || istype(O, /obj/structure/window_frame))
			var/obj/structure/S = O
			visible_message(SPAN_DANGER("[src] plows straight through [S]!"), null, null, 5)
			S.deconstruct(FALSE) //We want to continue moving, so we do not reset throwing.
		else
			O.hitby(src) //This resets throwing.
	else
		if(!istype(O, /obj/structure/surface/table) && !istype(O, /obj/structure/surface/rack))
			O.hitby(src) //This resets throwing.

/mob/living/carbon/xenomorph/proc/pounced_obj_wrapper(obj/O)
	pounced_obj(O)

/mob/living/carbon/xenomorph/proc/pounced_turf(turf/T)
	if(!T.density)
		for(var/mob/M in T)
			pounced_mob(M)
			break
	else
		turf_launch_collision(T)

/mob/living/carbon/xenomorph/proc/pounced_turf_wrapper(turf/T)
	pounced_turf(T)

//Bleuugh
/mob/living/carbon/xenomorph/proc/empty_gut()
	if(stomach_contents.len)
		for(var/atom/movable/S in stomach_contents)
			stomach_contents.Remove(S)
			S.acid_damage = 0 //Reset the acid damage
			S.forceMove(get_true_turf(src))

	if(contents.len) //Get rid of anything that may be stuck inside us as well
		for(var/atom/movable/A in contents)
			A.forceMove(get_true_turf(src))

/mob/living/carbon/xenomorph/proc/toggle_nightvision()
	see_in_dark = 12
	sight |= SEE_MOBS
	if(lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE)
		lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	else if(lighting_alpha == LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
		lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	else
		lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	update_sight()

/mob/living/carbon/xenomorph/proc/regurgitate(mob/living/victim, stuns = FALSE)
	if(stomach_contents.len)
		if(victim)
			stomach_contents.Remove(victim)
			victim.acid_damage = 0
			victim.forceMove(get_true_turf(loc))

			visible_message(SPAN_XENOWARNING("[src] hurls out the contents of their stomach!"), \
			SPAN_XENOWARNING("You hurl out the contents of your stomach!"), null, 5)
			playsound(get_true_location(loc), 'sound/voice/alien_drool2.ogg', 50, 1)

			if (stuns)
				victim.adjust_effect(2, STUN)
	else
		to_chat(src, SPAN_WARNING("There's nothing in your belly that needs regurgitating."))

/mob/living/carbon/xenomorph/proc/check_alien_construction(turf/current_turf, check_blockers = TRUE, silent = FALSE, check_doors = TRUE)
	var/has_obstacle
	for(var/obj/O in current_turf)
		if(check_blockers && istype(O, /obj/effect/build_blocker))
			var/obj/effect/build_blocker/bb = O
			if(!silent)
				to_chat(src, SPAN_WARNING("This is too close to a [bb.linked_structure]!"))
			return
		if(check_doors)
			if(istype(O, /obj/structure/machinery/door))
				if(!silent)
					to_chat(src, SPAN_WARNING("\The [O] is blocking the resin! There's not enough space to build that here."))
				return
		if(istype(O, /obj/item/clothing/mask/facehugger))
			if(!silent)
				to_chat(src, SPAN_WARNING("There is a little one here already. Best move it."))
			return
		if(istype(O, /obj/effect/alien/egg))
			if(!silent)
				to_chat(src, SPAN_WARNING("There's already an egg."))
			return
		if(istype(O, /obj/structure/mineral_door) || istype(O, /obj/effect/alien/resin))
			has_obstacle = TRUE
			break
		if(istype(O, /obj/structure/ladder))
			has_obstacle = TRUE
			break
		if(istype(O, /obj/structure/fence))
			has_obstacle = TRUE
			break
		if(istype(O, /obj/structure/bed))
			if(istype(O, /obj/structure/bed/chair/dropship/passenger))
				var/obj/structure/bed/chair/dropship/passenger/P = O
				if(P.chair_state != DROPSHIP_CHAIR_BROKEN)
					has_obstacle = TRUE
					break
			else
				has_obstacle = TRUE
				break

		if(O.density && !(O.flags_atom & ON_BORDER))
			has_obstacle = TRUE
			break

	if(current_turf.density || has_obstacle)
		if(!silent)
			to_chat(src, SPAN_WARNING("There's something built here already."))
		return

	return TRUE

/mob/living/carbon/xenomorph/drop_held_item()
	var/obj/item/clothing/mask/facehugger/F = get_active_hand()
	if(istype(F))
		var/turf/TU = loc
		if(!isturf(TU) || TU.density)
			to_chat(src, SPAN_WARNING("You decide not to drop [F] after all."))
			return

	. = ..()

/mob/living/carbon/xenomorph/proc/get_diagonal_step(atom/movable/A, direction)
	if(!A)
		return FALSE
	switch(direction)
		if(EAST, WEST)
			return get_step(A, pick(NORTH,SOUTH))
		if(NORTH,SOUTH)
			return get_step(A, pick(EAST,WEST))


//Welp
/mob/living/carbon/xenomorph/proc/xeno_jitter(jitter_time = 25)
	set waitfor = 0

	pixel_x = old_x + rand(-3, 3)
	pixel_y = old_y + rand(-1, 1)
	jitter_time--

	if(jitter_time)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/xenomorph, xeno_jitter), jitter_time), 1) // The fuck, use a processing SS, TODO FIXME AHH
	else
		//endwhile - reset the pixel offsets to zero
		pixel_x = old_x
		pixel_y = old_y

//When the Queen's pheromones are updated, or we add/remove a leader, update leader pheromones
/mob/living/carbon/xenomorph/proc/handle_xeno_leader_pheromones()
	if(!hive)
		return
	var/mob/living/carbon/xenomorph/queen/Q = hive.living_xeno_queen
	if(!Q || !Q.ovipositor || hive_pos == NORMAL_XENO || !Q.current_aura || Q.loc.z != loc.z) //We are no longer a leader, or the Queen attached to us has dropped from her ovi, disabled her pheromones or even died
		leader_aura_strength = 0
		leader_current_aura = ""
		to_chat(src, SPAN_XENOWARNING("Your pheromones wane. The Queen is no longer granting you her pheromones."))
	else
		leader_aura_strength = Q.aura_strength
		leader_current_aura = Q.current_aura
		to_chat(src, SPAN_XENOWARNING("Your pheromones have changed. The Queen has new plans for the Hive."))
	hud_set_pheromone()

/mob/living/carbon/xenomorph/proc/nocrit(wowave)
	if(SSticker?.mode?.hardcore)
		nocrit = TRUE
		if(wowave < 15)
			maxHealth = ((maxHealth+abs(crit_health))*(wowave/15)*(3/4))+((maxHealth)*1/4) //if it's wo we give xeno's less hp in lower rounds. This makes help the marines feel good.
			health = ((health+abs(crit_health))*(wowave/15)*(3/4))+((health)*1/4) //if it's wo we give xeno's less hp in lower rounds. This makes help the marines feel good.
		else
			maxHealth = maxHealth+abs(crit_health) // From round 15 and on we give them only a slight boost
			health = health+abs(crit_health) // From round 15 and on we give them only a slight boost
	crit_health = -1 // Do not put this at 0 or xeno's will just vanish on WO due to how the garbage collector works.


// Handle queued actions.
/mob/living/carbon/xenomorph/proc/handle_queued_action(atom/A)
	if(!queued_action || !istype(queued_action) || !(queued_action in actions))
		return

	if(queued_action.can_use_action() && queued_action.action_cooldown_check())
		queued_action.use_ability_wrapper(A)

	queued_action = null

	if(client)
		client.mouse_pointer_icon = initial(client.mouse_pointer_icon) // Reset our mouse pointer when we no longer have an action queued.

// Called when pulling something and attacking yourself with the pull
/mob/living/carbon/xenomorph/proc/pull_power(mob/M)
	if(iswarrior(src) && !ripping_limb && M.stat != DEAD)
		if(M.status_flags & XENO_HOST)
			to_chat(src, SPAN_XENOWARNING("This would harm the embryo!"))
			return
		ripping_limb = TRUE
		if(rip_limb(M))
			stop_pulling()
		ripping_limb = FALSE


// Warrior Rip Limb - called by pull_power()
/mob/living/carbon/xenomorph/proc/rip_limb(mob/M)
	if(!istype(M, /mob/living/carbon/human))
		return FALSE

	if(action_busy) //can't stack the attempts
		return FALSE

	var/mob/living/carbon/human/H = M
	var/obj/limb/L = H.get_limb(check_zone(zone_selected))

	if(can_not_harm(H))
		to_chat(src, SPAN_XENOWARNING("You can't harm this host!"))
		return

	if(!L || L.body_part == BODY_FLAG_CHEST || L.body_part == BODY_FLAG_GROIN || (L.status & LIMB_DESTROYED)) //Only limbs and head.
		to_chat(src, SPAN_XENOWARNING("You can't rip off that limb."))
		return FALSE
	var/limb_time = rand(40,60)

	if(L.body_part == BODY_FLAG_HEAD)
		limb_time = rand(90,110)

	visible_message(SPAN_XENOWARNING("[src] begins pulling on [M]'s [L.display_name] with incredible strength!"), \
	SPAN_XENOWARNING("You begin to pull on [M]'s [L.display_name] with incredible strength!"))

	if(!do_after(src, limb_time, INTERRUPT_ALL|INTERRUPT_DIFF_SELECT_ZONE, BUSY_ICON_HOSTILE) || M.stat == DEAD)
		to_chat(src, SPAN_NOTICE("You stop ripping off the limb."))
		return FALSE

	if(L.status & LIMB_DESTROYED)
		return FALSE

	if(L.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		L.take_damage(rand(30,40), 0, 0) // just do more damage
		visible_message(SPAN_XENOWARNING("You hear [M]'s [L.display_name] being pulled beyond its load limits!"), \
		SPAN_XENOWARNING("[M]'s [L.display_name] begins to tear apart!"))
	else
		visible_message(SPAN_XENOWARNING("You hear the bones in [M]'s [L.display_name] snap with a sickening crunch!"), \
		SPAN_XENOWARNING("[M]'s [L.display_name] bones snap with a satisfying crunch!"))
		L.take_damage(rand(15,25), 0, 0)
		L.fracture(100)
	M.last_damage_data = create_cause_data(initial(caste_type), src)
	src.attack_log += text("\[[time_stamp()]\] <font color='red'>ripped the [L.display_name] off of [M.name] ([M.ckey]) 1/2 progress</font>")
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>had their [L.display_name] ripped off by [src.name] ([src.ckey]) 1/2 progress</font>")
	log_attack("[src.name] ([src.ckey]) ripped the [L.display_name] off of [M.name] ([M.ckey]) 1/2 progress")

	if(!do_after(src, limb_time, INTERRUPT_ALL|INTERRUPT_DIFF_SELECT_ZONE, BUSY_ICON_HOSTILE)  || M.stat == DEAD || iszombie(M))
		to_chat(src, SPAN_NOTICE("You stop ripping off the limb."))
		return FALSE

	if(L.status & LIMB_DESTROYED)
		return FALSE

	visible_message(SPAN_XENOWARNING("[src] rips [M]'s [L.display_name] away from \his body!"), \
	SPAN_XENOWARNING("[M]'s [L.display_name] rips away from \his body!"))
	src.attack_log += text("\[[time_stamp()]\] <font color='red'>ripped the [L.display_name] off of [M.name] ([M.ckey]) 2/2 progress</font>")
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>had their [L.display_name] ripped off by [src.name] ([src.ckey]) 2/2 progress</font>")
	log_attack("[src.name] ([src.ckey]) ripped the [L.display_name] off of [M.name] ([M.ckey]) 2/2 progress")

	L.droplimb(0, 0, initial(name))

	return TRUE

// Vent Crawl
/mob/living/carbon/xenomorph/proc/vent_crawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Alien"
	if(!check_state() || !can_ventcrawl())
		return
	var/pipe = start_ventcrawl()
	if(pipe)
		handle_ventcrawl(pipe)

/mob/living/carbon/xenomorph/proc/attempt_tackle(mob/M, tackle_mult = 1, tackle_min_offset = 0, tackle_max_offset = 0, tackle_bonus = 0)
	var/datum/tackle_counter/TC = LAZYACCESS(tackle_counter, M)
	if(!TC)
		TC = new(tackle_min + tackle_min_offset, tackle_max + tackle_max_offset, tackle_chance*tackle_mult)
		LAZYSET(tackle_counter, M, TC)
		RegisterSignal(M, COMSIG_MOB_KNOCKED_DOWN, PROC_REF(tackle_handle_lying_changed))

	if (TC.tackle_reset_id)
		deltimer(TC.tackle_reset_id)
		TC.tackle_reset_id = null

	. = TC.attempt_tackle(tackle_bonus)
	if (!.)
		TC.tackle_reset_id = addtimer(CALLBACK(src, PROC_REF(reset_tackle), M), 4 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)
	else
		reset_tackle(M)

/mob/living/carbon/xenomorph/proc/tackle_handle_lying_changed(mob/M)
	SIGNAL_HANDLER
	// Infected mobs do not have their tackle counter reset if
	// they get knocked down or get up from a knockdown
	if(M.status_flags & XENO_HOST)
		return

	reset_tackle(M)

/mob/living/carbon/xenomorph/proc/reset_tackle(mob/M)
	var/datum/tackle_counter/TC = LAZYACCESS(tackle_counter, M)
	if (TC)
		qdel(TC)
		LAZYREMOVE(tackle_counter, M)
		UnregisterSignal(M, COMSIG_MOB_KNOCKED_DOWN)


/mob/living/carbon/xenomorph/burn_skin(burn_amount)
	if(burrow)
		return FALSE

	if(caste.fire_immunity & FIRE_IMMUNITY_NO_DAMAGE)
		burn_amount *= 0.5

	apply_damage(burn_amount, BURN)
	to_chat(src, SPAN_DANGER("Your flesh, it melts!"))
	updatehealth()
	return TRUE

/mob/living/carbon/xenomorph/get_role_name()
	return caste_type

/proc/get_pheromone_aura_strength(aura)
	switch(aura)
		if(-INFINITY to 0.9)
			return "Very Weak"
		if(1 to 1.9)
			return "Weak"
		if(2 to 2.9)
			return "Moderate"
		if(3 to 3.9)
			return "Strong"
		if(4 to INFINITY)
			return "Very Strong"

/mob/living/carbon/xenomorph/proc/start_tracking_resin_mark(obj/effect/alien/resin/marker/target)
	if(!target)
		to_chat(src, SPAN_XENONOTICE("This resin mark no longer exists!"))
		return
	target.xenos_tracking |= src
	tracked_marker = target
	to_chat(src, SPAN_XENONOTICE("You start tracking the [target.mark_meaning.name] resin mark."))
	to_chat(src, SPAN_INFO("shift click the compass to watch the mark, alt click to stop tracking"))

/mob/living/carbon/xenomorph/proc/stop_tracking_resin_mark(destroyed, silent = FALSE) //tracked_marker shouldnt be nulled outside this PROC!! >:C
	var/atom/movable/screen/mark_locator/ML = hud_used.locate_marker
	ML.overlays.Cut()
	if(!silent)
		if(destroyed)
			to_chat(src, SPAN_XENONOTICE("The [tracked_marker.mark_meaning.name] resin mark has ceased to exist."))
		else
			to_chat(src, SPAN_XENONOTICE("You stop tracking the [tracked_marker.mark_meaning.name] resin mark."))
	if(tracked_marker)
		tracked_marker.xenos_tracking -= src
	tracked_marker = null

/mob/living/carbon/xenomorph/proc/update_minimap_icon()
	if(istype(caste, /datum/caste_datum/queen))
		return

	SSminimaps.remove_marker(src)
	add_minimap_marker()
