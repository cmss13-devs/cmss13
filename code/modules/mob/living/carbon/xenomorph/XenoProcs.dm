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

	if(SSticker.mode && length(SSticker.mode.xenomorphs)) //Send to only xenos in our gamemode list. This is faster than scanning all mobs
		for(var/datum/mind/L in SSticker.mode.xenomorphs)
			var/mob/living/carbon/M = L.current
			if(M && istype(M) && !M.stat && M.client && (!hivenumber || M.hivenumber == hivenumber)) //Only living and connected xenos
				to_chat(M, SPAN_XENODANGER("<span class=\"[fontsize_style]\"> [message]</span>"))

//Sends a maptext alert to xenos.
/proc/xeno_maptext(text = "", title_text = "", hivenumber = XENO_HIVE_NORMAL)
	if(text == "" || !hivenumber)
		return //Logic

	if(SSticker.mode && length(SSticker.mode.xenomorphs)) //Send to only xenos in our gamemode list. This is faster than scanning all mobs
		for(var/datum/mind/living in SSticker.mode.xenomorphs)
			var/mob/living/carbon/xenomorph/xeno = living.current
			if(istype(xeno) && !xeno.stat && xeno.client && xeno.hivenumber == hivenumber) //Only living and connected xenos
				playsound_client(xeno.client, 'sound/voice/alien_distantroar_3.ogg', xeno.loc, 25, FALSE)
				xeno.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>[title_text]</u></span><br>" + text, /atom/movable/screen/text/screen_text/command_order, "#b491c8")

/proc/xeno_message_all(message = null, size = 3)
	xeno_message(message, size)

//Adds stuff to your "Status" pane -- Specific castes can have their own, like carrier hugger count
//Those are dealt with in their caste files.
/mob/living/carbon/xenomorph/get_status_tab_items()
	. = ..()

	. += "Name: [name]"

	. += ""

	. += "Health: [floor(health)]/[floor(maxHealth)]"
	. += "Armor: [floor(0.01*armor_integrity*armor_deflection)+(armor_deflection_buff-armor_deflection_debuff)]/[floor(armor_deflection)]"
	. += "Plasma: [floor(plasma_stored)]/[floor(plasma_max)]"
	. += "Slash Damage: [floor((melee_damage_lower+melee_damage_upper)/2)]"

	var/shieldtotal = 0
	for (var/datum/xeno_shield/XS in xeno_shields)
		shieldtotal += XS.amount

	. += "Shield: [shieldtotal]"

	if(selected_ability)
		. += ""
		. += "Selected Ability: [selected_ability.name]"
		if(selected_ability.charges != NO_ACTION_CHARGES)
			. += "Charges Left: [selected_ability.charges]"

		if(selected_ability.cooldown_timer_id != TIMER_ID_NULL && client?.prefs.show_cooldown_messages)
			. += "On Cooldown: [DisplayTimeText(timeleft(selected_ability.cooldown_timer_id))]"

	. += ""

	var/stored_evolution = floor(evolution_stored)
	var/evolve_progress

	if(caste && caste.evolution_allowed)
		evolve_progress = "[min(stored_evolution, evolution_threshold)]/[evolution_threshold]"
		if(hive && !hive.allow_no_queen_evo && !caste?.evolve_without_queen)
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
/mob/living/carbon/xenomorph/proc/check_state(permissive = FALSE)
	if(!permissive)
		if(is_mob_incapacitated() || body_position == LYING_DOWN || buckled || evolving || !isturf(loc))
			to_chat(src, SPAN_WARNING("We cannot do this in our current state."))
			return FALSE
		else if(caste_type != XENO_CASTE_QUEEN && observed_xeno)
			to_chat(src, SPAN_WARNING("We cannot do this in our current state."))
			return FALSE
	else
		if(is_mob_incapacitated() || buckled || evolving)
			to_chat(src, SPAN_WARNING("We cannot do this in our current state."))
			return FALSE

	return TRUE

//Checks your plasma levels and gives a handy message.
/mob/living/carbon/xenomorph/proc/check_plasma(value)
	if(stat)
		to_chat(src, SPAN_WARNING("We cannot do this in our current state."))
		return FALSE

	if(value)
		if(plasma_stored < value)
			to_chat(src, SPAN_WARNING("We do not have enough plasma to do this. We require [value] plasma but have only [plasma_stored] stored."))
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

/mob/living/carbon/xenomorph/animation_attack_on(atom/A, pixel_offset)
	if(hauled_mob?.resolve())
		return
	. = ..()

/mob/living/carbon/xenomorph/Move(NewLoc, direct)
	. = ..()
	var/mob/user = hauled_mob?.resolve()
	if(user)
		user.forceMove(loc)

/mob/living/carbon/xenomorph/forceMove(atom/destination)
	. = ..()
	var/mob/user = hauled_mob?.resolve()
	if(user)
		if(!isturf(destination))
			user.forceMove(src)
		else
			user.forceMove(loc)

/mob/living/carbon/xenomorph/relaymove(mob/user, direction)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_HAULED))
		var/mob/living/carbon/human/hauled_mob = user
		hauled_mob.handle_haul_resist()

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


/mob/living/carbon/xenomorph/proc/pounced_mob(mob/living/L)
	// This should only be called back by a mob that has pounce, so no need to check
	var/datum/action/xeno_action/activable/pounce/pounceAction = get_action(src, /datum/action/xeno_action/activable/pounce)

	// Unconscious or dead, or not throwing but used pounce.
	if(!check_state() || (!throwing && !pounceAction.action_cooldown_check()))
		return

	var/mob/living/carbon/M = L
	if(M.stat == DEAD || M.mob_size >= MOB_SIZE_BIG || can_not_harm(L) || M == src)
		throwing = FALSE
		return

	if (pounceAction.can_be_shield_blocked)
		if(ishuman(M) && (M.dir in reverse_nearby_direction(dir)))
			var/mob/living/carbon/human/H = M
			if(H.check_shields(15, "the pounce")) //Human shield block.
				visible_message(SPAN_DANGER("[src] slams into [H]!"),
					SPAN_XENODANGER("We slam into [H]!"), null, 5)
				KnockDown(1)
				Stun(1)
				throwing = FALSE //Reset throwing manually.
				playsound(H, "bonk", 75, FALSE) //bonk
				return

			if(isyautja(H))
				if(H.check_shields(0, "the pounce", 1))
					visible_message(SPAN_DANGER("[H] blocks the pounce of [src] with the combistick!"), SPAN_XENODANGER("[H] blocks our pouncing form with the combistick!"), null, 5)
					apply_effect(3, WEAKEN)
					throwing = FALSE
					playsound(H, "bonk", 75, FALSE)
					return
				else if(prob(75)) //Body slam the fuck out of xenos jumping at your front.
					visible_message(SPAN_DANGER("[H] body slams [src]!"),
						SPAN_XENODANGER("[H] body slams us!"), null, 5)
					KnockDown(3)
					Stun(3)
					throwing = FALSE
					return
			if(iscolonysynthetic(H) && prob(60))
				visible_message(SPAN_DANGER("[H] withstands being pounced and slams down [src]!"),
					SPAN_XENODANGER("[H] throws us down after withstanding the pounce!"), null, 5)
				KnockDown(1.5)
				Stun(1.5)
				throwing = FALSE
				return


	visible_message(SPAN_DANGER("[src] [pounceAction.action_text] onto [M]!"), SPAN_XENODANGER("We [pounceAction.action_text] onto [M]!"), null, 5)

	if (pounceAction.knockdown)
		M.KnockDown(pounceAction.knockdown_duration)
		M.Stun(pounceAction.knockdown_duration) // To replicate legacy behavior. Otherwise M39 Armbrace users for example can still shoot
		step_to(src, M)

	if (pounceAction.freeze_self)
		if(pounceAction.freeze_play_sound)
			playsound(loc, rand(0, 100) < 95 ? 'sound/voice/alien_pounce.ogg' : 'sound/voice/alien_pounce2.ogg', 25, 1)
		ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Pounce"))
		pounceAction.freeze_timer_id = addtimer(CALLBACK(src, PROC_REF(unfreeze_pounce)), pounceAction.freeze_time, TIMER_STOPPABLE)
	pounceAction.additional_effects(M)

	if(pounceAction.slash)
		M.attack_alien(src, pounceAction.slash_bonus_damage)

	throwing = FALSE //Reset throwing since something was hit.

/mob/living/carbon/xenomorph/proc/unfreeze_pounce()
	REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Pounce"))

/mob/living/carbon/xenomorph/proc/pounced_mob_wrapper(mob/living/L)
	pounced_mob(L)

/mob/living/carbon/xenomorph/proc/pounced_obj(obj/O)
	var/datum/action/xeno_action/activable/pounce/pounceAction = get_action(src, /datum/action/xeno_action/activable/pounce)

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
		for(var/mob/living/mob in T)
			pounced_mob(mob)
			break
	else
		turf_launch_collision(T)

/mob/living/carbon/xenomorph/proc/pounced_turf_wrapper(turf/T)
	pounced_turf(T)


/mob/living/carbon/xenomorph/proc/toggle_nightvision()
	see_in_dark = 12
	sight |= SEE_MOBS
	if(lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE)
		lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE
	else if (lighting_alpha == LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE)
		lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	else if(lighting_alpha == LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
		lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	else
		lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	update_sight()

/mob/living/carbon/xenomorph/proc/haul(mob/living/carbon/human/victim)
	visible_message(SPAN_WARNING("[src] restrains [victim], hauling them effortlessly!"),
	SPAN_WARNING("We fully restrain [victim] and start hauling them!"), null, 5)
	log_interact(src, victim, "[key_name(src)] started hauling [key_name(victim)] at [get_area_name(src)]")
	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)

	if(ishuman(victim))
		var/mob/living/carbon/human/pulled_human = victim
		pulled_human.disable_lights()
	hauled_mob = WEAKREF(victim)
	victim.forceMove(loc, get_dir(victim.loc, loc))
	victim.handle_haul(src)
	RegisterSignal(victim, COMSIG_MOB_DEATH, PROC_REF(release_dead_haul))
	haul_timer = addtimer(CALLBACK(src, PROC_REF(about_to_release_hauled)), 40 SECONDS + rand(0 SECONDS, 20 SECONDS), TIMER_STOPPABLE)

/mob/living/carbon/xenomorph/proc/about_to_release_hauled()
	var/mob/living/carbon/human/user = hauled_mob?.resolve()
	if(!user)
		deltimer(haul_timer)
		return
	to_chat(src, SPAN_XENOWARNING("We feel our grip loosen on [user], we will have to release them soon."))
	playsound(src, 'sound/voice/alien_hiss2.ogg', 15)
	haul_timer = addtimer(CALLBACK(src, PROC_REF(release_haul)), 10 SECONDS, TIMER_STOPPABLE)

// Releasing a dead hauled mob
/mob/living/carbon/xenomorph/proc/release_dead_haul()
	SIGNAL_HANDLER
	deltimer(haul_timer)
	var/mob/living/carbon/human/user = hauled_mob?.resolve()
	to_chat(src, SPAN_XENOWARNING("[user] is dead. No more use for them now."))
	user.handle_unhaul()
	UnregisterSignal(user, COMSIG_MOB_DEATH)
	UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)
	hauled_mob = null

// Releasing a hauled mob
/mob/living/carbon/xenomorph/proc/release_haul(stuns = FALSE)
	deltimer(haul_timer)
	var/mob/living/carbon/human/user = hauled_mob?.resolve()
	if(!user)
		to_chat(src, SPAN_WARNING("We are not hauling anyone."))
		return
	user.handle_unhaul()
	visible_message(SPAN_XENOWARNING("[src] releases [user] from their grip!"),
	SPAN_XENOWARNING("We release [user] from our grip!"), null, 5)
	playsound(src, 'sound/voice/alien_growl1.ogg', 15)
	log_interact(src, user, "[key_name(src)] released [key_name(user)] at [get_area_name(loc)]")
	if(stuns)
		user.adjust_effect(2, STUN)
	UnregisterSignal(user, COMSIG_MOB_DEATH)
	UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)
	hauled_mob = null

/mob/living/carbon/xenomorph/proc/check_alien_construction(turf/current_turf, check_blockers = TRUE, silent = FALSE, check_doors = TRUE, ignore_nest = FALSE)
	var/has_obstacle
	for(var/obj/O in current_turf)
		if(istype(O, /obj/effect/alien/resin/design/speed_node) || istype(O, /obj/effect/alien/resin/design/cost_node) || istype(O, /obj/effect/alien/resin/design/construct_node))
			continue
		if(check_blockers && istype(O, /obj/effect/build_blocker))
			var/obj/effect/build_blocker/bb = O
			if(!silent)
				to_chat(src, SPAN_WARNING("This is too close to \a [bb.linked_structure]!"))
			return
		if(check_doors)
			if(istype(O, /obj/structure/machinery/door))
				if(!silent)
					to_chat(src, SPAN_WARNING("[O] is blocking the resin! There's not enough space to build that here."))
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
		if(istype(O, /obj/structure/tunnel))
			has_obstacle = TRUE
			break
		if(istype(O, /obj/structure/bed))
			if(istype(O, /obj/structure/bed/chair/dropship/passenger))
				var/obj/structure/bed/chair/dropship/passenger/P = O
				if(P.chair_state != DROPSHIP_CHAIR_BROKEN)
					has_obstacle = TRUE
					break
			else if(istype(O, /obj/structure/bed/nest) && ignore_nest)
				continue
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
	if(!Q || !Q.ovipositor || hive_pos == NORMAL_XENO || !Q.current_aura || !SSmapping.same_z_map(Q.loc.z, loc.z)) //We are no longer a leader, or the Queen attached to us has dropped from her ovi, disabled her pheromones or even died
		leader_aura_strength = 0
		leader_current_aura = ""
		to_chat(src, SPAN_XENOWARNING("Our pheromones wane. The Queen is no longer granting us her pheromones."))
	else
		leader_aura_strength = Q.aura_strength
		leader_current_aura = Q.current_aura
		to_chat(src, SPAN_XENOWARNING("Our pheromones have changed. The Queen has new plans for the Hive."))
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

/// Called when pulling something and attacking yourself wth the pull (Z hotkey) override for caste specific behaviour
/mob/living/carbon/xenomorph/proc/pull_power(mob/mob)
	return

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
		RegisterSignal(M, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(tackle_handle_lying_changed))

	if (TC.tackle_reset_id)
		deltimer(TC.tackle_reset_id)
		TC.tackle_reset_id = null

	. = TC.attempt_tackle(tackle_bonus)
	if (!. || (M.status_flags & XENO_HOST))
		TC.tackle_reset_id = addtimer(CALLBACK(src, PROC_REF(reset_tackle), M), 4 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)
	else
		reset_tackle(M)

/mob/living/carbon/xenomorph/proc/tackle_handle_lying_changed(mob/living/M, body_position)
	SIGNAL_HANDLER
	if(body_position != LYING_DOWN)
		return

	// Infected mobs do not have their tackle counter reset if
	// they get knocked down or get up from a knockdown
	if(M.status_flags & XENO_HOST)
		return

	// If they were not forcibly floored, don't reset
	// Resting should not reset the counter
	if(!HAS_TRAIT(M, TRAIT_FLOORED))
		return

	reset_tackle(M)

/mob/living/carbon/xenomorph/proc/reset_tackle(mob/M)
	var/datum/tackle_counter/TC = LAZYACCESS(tackle_counter, M)
	if (TC)
		qdel(TC)
		LAZYREMOVE(tackle_counter, M)
		UnregisterSignal(M, COMSIG_LIVING_SET_BODY_POSITION)


/mob/living/carbon/xenomorph/burn_skin(burn_amount)
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		return FALSE

	if(caste.fire_immunity & FIRE_IMMUNITY_NO_DAMAGE)
		burn_amount *= 0.5

	apply_damage(burn_amount, BURN)
	to_chat(src, SPAN_DANGER("Our flesh, it melts!"))
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
		if(4 to 4.9)
			return "Very Strong"
		if(4.9 to INFINITY)
			return "Overwhelming"

/mob/living/carbon/xenomorph/proc/start_tracking_resin_mark(obj/effect/alien/resin/marker/target)
	if(!target)
		to_chat(src, SPAN_XENONOTICE("This resin mark no longer exists!"))
		return
	target.xenos_tracking |= src
	tracked_marker = target
	to_chat(src, SPAN_XENONOTICE("We start tracking the [target.mark_meaning.name] resin mark."))
	to_chat(src, SPAN_INFO("Shift click the compass to watch the mark, alt click to stop tracking"))

/mob/living/carbon/xenomorph/proc/stop_tracking_resin_mark(destroyed, silent = FALSE) //tracked_marker shouldnt be nulled outside this PROC!! >:C
	if(QDELETED(src))
		return

	if(!hud_used)
		CRASH("hud_used is null in stop_tracking_resin_mark")

	var/atom/movable/screen/mark_locator/ML = hud_used.locate_marker
	ML.overlays.Cut()

	if(tracked_marker)
		if(!silent)
			if(destroyed)
				to_chat(src, SPAN_XENONOTICE("The [tracked_marker.mark_meaning.name] resin mark has ceased to exist."))
			else
				to_chat(src, SPAN_XENONOTICE("We stop tracking the [tracked_marker.mark_meaning.name] resin mark."))
		tracked_marker.xenos_tracking -= src

	tracked_marker = null

	///This permits xenos with thumbs to fire guns and arm grenades. God help us all.
/mob/living/carbon/xenomorph/IsAdvancedToolUser()
	return HAS_TRAIT(src, TRAIT_OPPOSABLE_THUMBS)

/mob/living/carbon/xenomorph/proc/do_nesting_host(mob/current_mob, nest_structural_base)
	var/list/xeno_hands = list(get_active_hand(), get_inactive_hand())

	if(!ishuman(current_mob))
		to_chat(src, SPAN_XENONOTICE("This is not a host."))
		return

	if(current_mob.stat == DEAD)
		to_chat(src, SPAN_XENONOTICE("This host is dead."))
		return

	var/mob/living/carbon/human/host_to_nest = current_mob

	var/found_grab = FALSE
	for(var/i in 1 to length(xeno_hands))
		if(istype(xeno_hands[i], /obj/item/grab))
			found_grab = TRUE
			break

	if(!found_grab)
		to_chat(src, SPAN_XENONOTICE("To nest the host here, a sure grip is needed to lift them up onto it!"))
		return

	var/turf/supplier_turf = get_turf(nest_structural_base)
	var/obj/effect/alien/weeds/supplier_weeds = locate(/obj/effect/alien/weeds) in supplier_turf
	if(!supplier_weeds)
		to_chat(src, SPAN_XENOBOLDNOTICE("There are no weeds here! Nesting hosts requires hive weeds."))
		return

	if(supplier_weeds.weed_strength < WEED_LEVEL_HIVE)
		to_chat(src, SPAN_XENOBOLDNOTICE("The weeds here are not strong enough for nesting hosts."))
		return

	if(!supplier_turf.density)
		var/obj/structure/window/framed/framed_window = locate(/obj/structure/window/framed/) in supplier_turf
		if(!framed_window)
			to_chat(src, SPAN_XENOBOLDNOTICE("Hosts need a vertical surface to be nested upon!"))
			return

	var/dir_to_nest = get_dir(host_to_nest, nest_structural_base)

	if(!host_to_nest.Adjacent(supplier_turf))
		to_chat(src, SPAN_XENONOTICE("The host must be directly next to the wall its being nested on!"))
		return

	if(!locate(dir_to_nest) in GLOB.cardinals)
		to_chat(src, SPAN_XENONOTICE("The host must be directly next to the wall its being nested on!"))
		return

	for(var/obj/structure/bed/nest/preexisting_nest in get_turf(host_to_nest))
		if(preexisting_nest.dir == dir_to_nest)
			to_chat(src, SPAN_XENONOTICE("There is already a host nested here!"))
			return

	var/obj/structure/bed/nest/applicable_nest = new(get_turf(host_to_nest))
	applicable_nest.dir = dir_to_nest
	if(!applicable_nest.buckle_mob(host_to_nest, src))
		qdel(applicable_nest)

/mob/living/carbon/xenomorph/proc/update_minimap_icon()
	if(istype(caste, /datum/caste_datum/queen))
		return

	SSminimaps.remove_marker(src)
	add_minimap_marker()

/mob/living/carbon/xenomorph/lying_angle_on_lying_down(new_lying_angle)
	return // Do not rotate xenos around on the floor, their sprite is already top-down'ish

/**
 * Helper procedure for throwing other carbon based mobs around
 * Pretty much a wrapper to [/atom/movable/proc/throw_atom] with extra handling
 *
 * * target - the target carbon mob that will be thrown
 * * direction - the direction the target will be thrown toward, or if null, infered from relative position with target
 * * distance - the total distance the throw will be made for
 * * speed - throw_atom relative speed of the throw, check [SPEED_AVERAGE] for details
 * * shake_camera - whether to shake the thrown mob camera on throw
 * * immobilize - if TRUE the mob will be immobilized during the throw, ensuring it doesn't move and break it
 */
/mob/living/proc/throw_carbon(mob/living/carbon/target, direction, distance, speed = SPEED_VERY_FAST, shake_camera = TRUE, immobilize = TRUE)
	if(!direction)
		direction = get_dir(src, target)
	var/turf/target_destination = get_ranged_target_turf(target, direction, distance)

	var/list/end_throw_callbacks
	if(immobilize)
		end_throw_callbacks = list(CALLBACK(src, PROC_REF(throw_carbon_end), target))
		ADD_TRAIT(target, TRAIT_IMMOBILIZED, XENO_THROW_TRAIT)

	target.throw_atom(target_destination, distance, speed, src, spin = TRUE, end_throw_callbacks = end_throw_callbacks)
	if(shake_camera)
		shake_camera(target, 10, 1)

/// Handler callback to reset immobilization status after a successful [/mob/living/carbon/xenomorph/proc/throw_carbon]
/mob/living/proc/throw_carbon_end(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, XENO_THROW_TRAIT)

/// snowflake proc to clear effects from research warcrimes
/mob/living/carbon/xenomorph/proc/clear_debuffs()
	SEND_SIGNAL(src, COMSIG_XENO_DEBUFF_CLEANSE)
	SetKnockOut(0)
	SetStun(0)
	SetKnockDown(0)
	SetDaze(0)
	SetSlow(0)
	SetSuperslow(0)
	SetRoot(0)
	SetEyeBlur(0)
	updatehealth()
