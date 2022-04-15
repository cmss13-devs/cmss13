//// Powers used by multiple Xenomorphs.
// In general, powers files hold actual implementations of abilities,
// and abilities files hold the object declarations for the abilities

// Plant weeds
/datum/action/xeno_action/onclick/plant_weeds/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!action_cooldown_check())
		return
	if(!X.check_state())
		return
	if(X.burrow)
		return

	var/turf/T = X.loc

	if(!istype(T))
		to_chat(X, SPAN_WARNING("You can't do that here."))
		return

	if(!T.is_weedable())
		to_chat(X, SPAN_WARNING("Bad place for a garden!"))
		return

	var/obj/effect/alien/weeds/node/N = locate() in T
	if(N && N.weed_strength >= X.weed_level)
		to_chat(X, SPAN_WARNING("There's a pod here already!"))
		return

	var/list/to_convert
	if(N)
		to_convert = N.children.Copy()

	var/obj/effect/alien/weeds/W = locate(/obj/effect/alien/weeds) in T
	if (W && W.weed_strength >= WEED_LEVEL_HIVE)
		to_chat(X, SPAN_WARNING("These weeds are too strong to plant a node on!"))
		return

	var/area/AR = get_area(T)
	if(isnull(AR) || !(AR.is_resin_allowed))
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	if (!check_and_use_plasma_owner())
		return

	X.visible_message(SPAN_XENONOTICE("\The [X] regurgitates a pulsating node and plants it on the ground!"), \
	SPAN_XENONOTICE("You regurgitate a pulsating node and plant it on the ground!"), null, 5)
	var/obj/effect/alien/weeds/node/new_node = new /obj/effect/alien/weeds/node(X.loc, src, X)

	if(to_convert)
		for(var/weed in to_convert)
			var/turf/target_turf = get_turf(weed)
			if(target_turf && !target_turf.density)
				new /obj/effect/alien/weeds(target_turf, new_node)
			qdel(weed)

	playsound(X.loc, "alien_resin_build", 25)

	apply_cooldown()

	..()
	return

/mob/living/carbon/Xenomorph/lay_down()
	if(hardcore)
		to_chat(src, SPAN_WARNING("No time to rest, must KILL!"))
		return

	if(fortify)
		to_chat(src, SPAN_WARNING("You cannot rest while fortified!"))
		return

	if(burrow)
		to_chat(src, SPAN_WARNING("You cannot rest while burrowed!"))
		return

	return ..()

/datum/action/xeno_action/onclick/xeno_resting/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.lay_down()

// Shift spits
/datum/action/xeno_action/onclick/shift_spits/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state(1))
		return
	for(var/i in 1 to X.caste.spit_types.len)
		if(X.ammo == GLOB.ammo_list[X.caste.spit_types[i]])
			if(i == X.caste.spit_types.len)
				X.ammo = GLOB.ammo_list[X.caste.spit_types[1]]
			else
				X.ammo = GLOB.ammo_list[X.caste.spit_types[i+1]]
			break
	to_chat(X, SPAN_NOTICE("You will now spit [X.ammo.name] ([X.ammo.spit_cost] plasma)."))
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, "shift_spit_[X.ammo.icon_state]")
	..()
	return


/datum/action/xeno_action/onclick/regurgitate/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_WARNING("You cannot regurgitate here."))
		return

	if(X.stomach_contents.len)
		for(var/mob/living/M in X.stomach_contents)
			// Also has good reason to be a proc on all Xenos
			X.regurgitate(M, TRUE)

	..()
	return

/datum/action/xeno_action/onclick/choose_resin/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	tgui_interact(X)
	return ..()

/datum/action/xeno_action/onclick/choose_resin/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/choose_resin),
	)

/datum/action/xeno_action/onclick/choose_resin/ui_static_data(mob/user)
	var/mob/living/carbon/Xenomorph/X = user
	if(!istype(X))
		return

	. = list()

	var/list/constructions = list()
	for(var/type in X.resin_build_order)
		var/list/entry = list()
		var/datum/resin_construction/RC = GLOB.resin_constructions_list[type]

		entry["name"] = RC.name
		entry["desc"] = RC.desc
		entry["image"] = replacetext(RC.construction_name, " ", "-")
		entry["plasma_cost"] = RC.cost
		entry["max_per_xeno"] = RC.max_per_xeno
		entry["id"] = "[type]"
		constructions += list(entry)

	.["constructions"] = constructions

/datum/action/xeno_action/onclick/choose_resin/ui_data(mob/user)
	var/mob/living/carbon/Xenomorph/X = user
	if(!istype(X))
		return

	. = list()
	.["selected_resin"] = X.selected_resin


/datum/action/xeno_action/onclick/choose_resin/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChooseResin", "Choose Resin")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/action/xeno_action/onclick/choose_resin/Destroy()
	SStgui.close_uis(src)
	return ..()

/datum/action/xeno_action/onclick/choose_resin/ui_state(mob/user)
	return GLOB.always_state

/datum/action/xeno_action/onclick/choose_resin/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/Xenomorph/X = usr
	if(!istype(X))
		return

	switch(action)
		if("choose_resin")
			var/selected_type = text2path(params["type"])
			if(!(selected_type in X.resin_build_order))
				return

			var/datum/resin_construction/RC = GLOB.resin_constructions_list[selected_type]
			to_chat(X, SPAN_NOTICE("You will now build <b>[RC.construction_name]\s</b> when secreting resin."))
			//update the button's overlay with new choice
			button.overlays.Cut()
			button.overlays += image('icons/mob/hud/actions.dmi', button, RC.construction_name)
			X.selected_resin = selected_type
			. = TRUE
		if("refresh_ui")
			. = TRUE


// Resin
/datum/action/xeno_action/activable/secrete_resin/use_ability(atom/A)
	if(!..())
		return FALSE
	var/mob/living/carbon/Xenomorph/X = owner
	if(isstorage(A.loc) || X.contains(A) || istype(A, /obj/screen)) return FALSE
	if(A.z != X.z)
		to_chat(owner, SPAN_XENOWARNING("This area is too far away to affect!"))
		return
	apply_cooldown()
	switch(X.build_resin(A, thick, make_message, plasma_cost != 0, build_speed_mod))
		if(SECRETE_RESIN_INTERRUPT)
			if(xeno_cooldown)
				apply_cooldown_override(xeno_cooldown * 2)
			return FALSE
		if(SECRETE_RESIN_FAIL)
			if(xeno_cooldown)
				apply_cooldown_override(1)
			return FALSE
	return TRUE

// leader Marker

/datum/action/xeno_action/activable/info_marker/use_ability(atom/A)
	if(!..())
		return FALSE

	if(!action_cooldown_check())
		return

	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return FALSE
	if(isstorage(A.loc) || X.contains(A) || istype(A, /obj/screen)) return FALSE
	var/turf/target_turf = get_turf(A)

	if(target_turf.z != X.z)
		to_chat(X, SPAN_XENOWARNING("This area is too far away to affect!"))
		return
	if(!X.hive.living_xeno_queen || X.hive.living_xeno_queen.z != X.z)
		to_chat(X, SPAN_XENOWARNING("You have no queen, the psychic link is gone!"))
		return

	var/tally = 0

	for(var/obj/effect/alien/resin/marker/MRK in X.hive.resin_marks)
		if(MRK.createdby == X.nicknumber)
			tally++
	if(tally >= max_markers)
		to_chat(X, SPAN_XENOWARNING("You have reached the maximum number of resin marks."))
		var/list/promptlist = list("Yes", "No")
		var/obj/effect/alien/resin/marker/Goober = null
		var/promptuser = null
		for(var/i=1, i<=length(X.hive.resin_marks))
			Goober = X.hive.resin_marks[i]
			if(Goober.createdby == X.nicknumber)
				promptuser = tgui_input_list(X, "Remove oldest placed mark: '[Goober.mark_meaning.name]!'?", "Mark limit reached.", promptlist)
				break
			i++
		if(promptuser == "No")
			return
		else if(promptuser == "Yes")
			qdel(Goober)
			if(X.make_marker(target_turf))
				apply_cooldown()
				return TRUE
	else if(X.make_marker(target_turf))
		apply_cooldown()
		return TRUE



// Destructive Acid
/datum/action/xeno_action/activable/corrosive_acid/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.corrosive_acid(A, acid_type, acid_plasma_cost)
	for(var/obj/item/explosive/plastic/E in A.contents)
		X.corrosive_acid(E,acid_type,acid_plasma_cost)
	..()


/datum/action/xeno_action/onclick/emit_pheromones/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!istype(X))
		return
	X.emit_pheromones(emit_cost = plasma_cost)

/mob/living/carbon/Xenomorph/proc/emit_pheromones(var/pheromone, var/emit_cost = 30)
	if(!check_state(TRUE))
		return
	if(!(locate(/datum/action/xeno_action/onclick/emit_pheromones) in actions))
		to_chat(src, SPAN_XENOWARNING("You are incapable of emitting pheromones!"))
		return
	if(!pheromone)
		if(current_aura)
			current_aura = null
			visible_message(SPAN_XENOWARNING("\The [src] stops emitting pheromones."), \
			SPAN_XENOWARNING("You stop emitting pheromones."), null, 5)
		else
			if(!check_plasma(emit_cost))
				to_chat(src, SPAN_XENOWARNING("You do not have enough plasma!"))
				return
			if(client.prefs && client.prefs.no_radials_preference)
				pheromone = tgui_input_list(src, "Choose a pheromone", "Pheromone Menu", caste.aura_allowed + "help" + "cancel")
				if(pheromone == "help")
					to_chat(src, SPAN_NOTICE("<br>Pheromones provide a buff to all Xenos in range at the cost of some stored plasma every second, as follows:<br><B>Frenzy</B> - Increased run speed, damage and chance to knock off headhunter masks.<br><B>Warding</B> - While in critical state, increased maximum negative health and slower off weed bleedout.<br><B>Recovery</B> - Increased plasma and health regeneration.<br>"))
					return
				if(!pheromone || pheromone == "cancel" || current_aura || !check_state(1)) //If they are stacking windows, disable all input
					return
			else
				var/static/list/phero_selections = list("help" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_help"), "frenzy" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_frenzy"), "warding" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_warding"), "recovery" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_recov"))
				pheromone = show_radial_menu(src, src, phero_selections)
				if(pheromone == "help")
					to_chat(src, SPAN_XENONOTICE("<br>Pheromones provide a buff to all Xenos in range at the cost of some stored plasma every second, as follows:<br><B>Frenzy (Red)</B> - Increased run speed, damage and chance to knock off headhunter masks.<br><B>Warding (Green)</B> - While in critical state, increased maximum negative health and slower off weed bleedout.<br><B>Recovery (Blue)</B> - Increased plasma and health regeneration.<br>"))
					return
				if(!pheromone || current_aura || !check_state(1)) //If they are stacking windows, disable all input
					return
	if(pheromone)
		if(pheromone == current_aura)
			to_chat(src, SPAN_XENOWARNING("You are already emitting [pheromone] pheromones!"))
			return
		if(!check_plasma(emit_cost))
			to_chat(src, SPAN_XENOWARNING("You do not have enough plasma!"))
			return
		use_plasma(emit_cost)
		current_aura = pheromone
		visible_message(SPAN_XENOWARNING("\The [src] begins to emit strange-smelling pheromones."), \
		SPAN_XENOWARNING("You begin to emit '[pheromone]' pheromones."), null, 5)
		playsound(loc, "alien_drool", 25)

	if(isXenoQueen(src) && hive && hive.xeno_leader_list.len && anchored)
		for(var/mob/living/carbon/Xenomorph/L in hive.xeno_leader_list)
			L.handle_xeno_leader_pheromones()

/datum/action/xeno_action/activable/pounce/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if(!action_cooldown_check())
		return

	if(!A) return

	if(A.layer >= FLY_LAYER)//anything above that shouldn't be pounceable (hud stuff)
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_XENOWARNING("You can't [ability_name] from here!"))
		return

	if(!X.check_state())
		return

	if(X.legcuffed)
		to_chat(X, SPAN_XENODANGER("You can't [ability_name] with that thing on your leg!"))
		return

	if(!check_and_use_plasma_owner())
		return

	if(X.layer == XENO_HIDING_LAYER) //Xeno is currently hiding, unhide him
		X.layer = MOB_LAYER
		X.update_wounds()

	if(isXenoRavager(X))
		X.emote("roar")

	if (!tracks_target)
		A = get_turf(A)

	apply_cooldown()

	if (windup)
		X.set_face_dir(get_cardinal_dir(X, A))
		if (!windup_interruptable)
			X.frozen = TRUE
			X.anchored = TRUE
			X.update_canmove()
		pre_windup_effects()

		if (!do_after(X, windup_duration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			to_chat(X, SPAN_XENODANGER("You cancel your [ability_name]!"))
			if (!windup_interruptable)
				X.frozen = FALSE
				X.anchored = FALSE
				X.update_canmove()
			post_windup_effects(interrupted = TRUE)
			return

		if (!windup_interruptable)
			X.frozen = FALSE
			X.anchored = FALSE
			X.update_canmove()
		post_windup_effects()

	X.visible_message(SPAN_XENOWARNING("\The [X] [ability_name]s at [A]!"), SPAN_XENOWARNING("You [ability_name] at [A]!"))

	// ok so basically the way this code works is godawful
	// what happens next is if we hit anything
	// a callback occurs to either the mob_launch_collision or obj_launch_collision procs.
	// those procs poll our action to see if we are 'pouncing'
	var/datum/launch_metadata/LM = new()
	LM.target = A
	LM.range = distance
	LM.speed = throw_speed
	LM.thrower = X
	LM.spin = FALSE
	LM.pass_flags = pounce_pass_flags
	LM.collision_callbacks = pounce_callbacks

	X.launch_towards(LM) //Victim, distance, speed

	additional_effects_always()
	..()

	return TRUE

// Massive, customizable spray_acid
/datum/action/xeno_action/activable/spray_acid/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if(!action_cooldown_check())
		return

	if(!A) return

	if(A.layer >= FLY_LAYER)
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_XENOWARNING("You can't [ability_name] from here!"))
		return

	if(!X.check_state() || X.action_busy)
		return

	if (activation_delay)
		if(!do_after(X, activation_delay_length, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			to_chat(X, SPAN_XENOWARNING("You decide to cancel your acid spray."))
			end_cooldown()
			return

	if (!action_cooldown_check())
		return

	apply_cooldown()

	if(!check_and_use_plasma_owner())
		return

	playsound(get_turf(X), 'sound/effects/refill.ogg', 25, 1)
	X.visible_message(SPAN_XENOWARNING("[X] vomits a flood of acid!"), SPAN_XENOWARNING("You vomit a flood of acid!"), null, 5)

	apply_cooldown()

	// Build our list of target turfs based on
	if (spray_type == ACID_SPRAY_LINE)
		X.do_acid_spray_line(getline2(X, A, include_from_atom = FALSE), spray_effect_type, spray_distance)

	else if (spray_type == ACID_SPRAY_CONE)
		X.do_acid_spray_cone(get_turf(A), spray_effect_type, spray_distance)

	..()
	return

/datum/action/xeno_action/onclick/xenohide/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state(1))
		return
	if(X.layer != XENO_HIDING_LAYER)
		X.layer = XENO_HIDING_LAYER
		to_chat(X, SPAN_NOTICE("You are now hiding."))
	else
		X.layer = MOB_LAYER
		to_chat(X, SPAN_NOTICE("You have stopped hiding."))
	X.update_wounds()


/datum/action/xeno_action/onclick/place_trap/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if (istype(X, /mob/living/carbon/Xenomorph/Burrower))
		var/mob/living/carbon/Xenomorph/Burrower/B = X
		if (B.burrow)
			return

	if(!X.check_plasma(plasma_cost))
		return
	var/turf/T = get_turf(X)

	if(!istype(T) || !T.is_weedable() || !can_xeno_build(T))
		to_chat(X, SPAN_WARNING("You can't do that here."))
		return

	var/area/AR = get_area(T)

	if(istype(AR,/area/shuttle/drop1/lz1) || istype(AR,/area/shuttle/drop2/lz2) || GLOB.interior_manager.interior_z == X.z)
		to_chat(X, SPAN_WARNING("You sense this is not a suitable area for creating a resin hole."))
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in T

	if(!alien_weeds)
		to_chat(X, SPAN_WARNING("You can only shape on weeds. Find some resin before you start building!"))
		return

	if(alien_weeds.linked_hive.hivenumber != X.hivenumber)
		to_chat(X, SPAN_WARNING("These weeds don't belong to your hive!"))
		return

	if(!X.check_alien_construction(T))
		return

	if(locate(/obj/effect/alien/resin/trap) in orange(1, T)) // obj/effect/alien/resin presence is checked on turf by check_alien_construction, so we just check orange.
		to_chat(X, SPAN_XENOWARNING("This is too close to another resin hole!"))
		return

	if(locate(/obj/effect/alien/resin/fruit) in orange(1, T))
		to_chat(X, SPAN_XENOWARNING("This is too close to a fruit!"))
		return

	X.use_plasma(plasma_cost)
	playsound(X.loc, "alien_resin_build", 25)
	new /obj/effect/alien/resin/trap(X.loc, X)
	to_chat(X, SPAN_XENONOTICE("You place a resin hole on the weeds, it still needs a sister to fill it with acid."))

/datum/action/xeno_action/activable/place_construction/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return FALSE

	if(isstorage(A.loc) || X.contains(A) || istype(A, /obj/screen)) return FALSE

	//Make sure construction is unrestricted
	if(X.hive && X.hive.construction_allowed == XENO_LEADER && X.hive_pos == NORMAL_XENO)
		to_chat(X, SPAN_WARNING("Construction is currently restricted to Leaders only!"))
		return FALSE
	else if(X.hive && X.hive.construction_allowed == XENO_QUEEN && !istype(X.caste, /datum/caste_datum/queen))
		to_chat(X, SPAN_WARNING("Construction is currently restricted to Queen only!"))
		return FALSE

	var/turf/T = get_turf(A)

	var/area/AR = get_area(T)
	if(isnull(AR) || !(AR.is_resin_allowed))
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return FALSE

	if(T.z != X.z)
		to_chat(X, SPAN_XENOWARNING("This area is too far away to affect!"))
		return FALSE

	if(GLOB.interior_manager.interior_z == X.z)
		to_chat(X, SPAN_XENOWARNING("It's too tight in here to build."))
		return FALSE

	var/choice = XENO_STRUCTURE_CORE
	if(X.hive.has_structure(XENO_STRUCTURE_CORE) || !X.hive.can_build_structure(XENO_STRUCTURE_CORE))
		choice = tgui_input_list(X, "Choose a structure to build", "Build structure", X.hive.hive_structure_types + "help")
		if(!choice)
			return
		if(choice == "help")
			var/message = "<br>Placing a construction node creates a template for special structures that can benefit the hive, which require the insertion of [MATERIAL_CRYSTAL] to construct the following:<br>"
			for(var/structure_name in X.hive.hive_structure_types)
				message += "[get_xeno_structure_desc(structure_name)]<br>"
			to_chat(X, SPAN_NOTICE(message))
			return
	if(!X.check_state(1) || !X.check_plasma(400))
		return FALSE
	var/structure_type = X.hive.hive_structure_types[choice]
	var/datum/construction_template/xenomorph/structure_template = new structure_type()

	if(!spacecheck(X,T,structure_template))
		return FALSE

	if(!do_after(X, XENO_STRUCTURE_BUILD_TIME, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return FALSE

	if(!spacecheck(X,T,structure_template)) //doublechecking
		return FALSE

	if((choice == XENO_STRUCTURE_CORE) && isXenoQueen(X) && X.hive.has_structure(XENO_STRUCTURE_CORE))
		if(X.hive.hive_location.hardcore)
			to_chat(X, SPAN_WARNING("You can't rebuild this structure"))
			return

		if(alert(X, "Are you sure that you want to move the hive and destroy the old hive core?", , "Yes", "No") == "No")
			return
		qdel(X.hive.hive_location)
	else if(!X.hive.can_build_structure(choice))
		to_chat(X, SPAN_WARNING("You can't build any more [choice]s for the hive."))
		return FALSE

	if(!X.hive.can_build_structure(structure_template.name) && !(choice == XENO_STRUCTURE_CORE))
		to_chat(X, SPAN_WARNING("You cannot build any more [structure_template.name]!"))
		qdel(structure_template)
		return FALSE

	if (QDELETED(T))
		to_chat(X, SPAN_WARNING("You cannot build here!"))
		qdel(structure_template)
		return FALSE

	var/queen_on_zlevel = !X.hive.living_xeno_queen || X.hive.living_xeno_queen.z == T.z
	if(!queen_on_zlevel)
		to_chat(X, SPAN_WARNING("Your link to the Queen is too weak here. She is on another world."))
		qdel(structure_template)
		return FALSE

	if(GLOB.interior_manager.interior_z == X.z)
		to_chat(X, SPAN_WARNING("It's too tight in here to build."))
		qdel(structure_template)
		return FALSE

	if(!T.is_weedable())
		to_chat(X, SPAN_WARNING("It's too early to be placing [structure_template.name] here!"))
		qdel(structure_template)
		return FALSE

	X.use_plasma(400)
	X.place_construction(T, structure_template)




// XSS Spacecheck

/datum/action/xeno_action/activable/place_construction/proc/spacecheck(var/mob/living/carbon/Xenomorph/X, var/turf/T, datum/construction_template/xenomorph/tem)
	if(tem.block_range)
		for(var/turf/TA in range(T, tem.block_range))
			if(!X.check_alien_construction(TA, FALSE, TRUE))
				to_chat(X, SPAN_WARNING("You need more open space to build here."))
				qdel(tem)
				return FALSE
		if(!X.check_alien_construction(T))
			to_chat(X, SPAN_WARNING("You need more open space to build here."))
			qdel(tem)
			return FALSE
		var/obj/effect/alien/weeds/alien_weeds = locate() in T
		if(!alien_weeds || alien_weeds.weed_strength < WEED_LEVEL_HIVE || alien_weeds.linked_hive.hivenumber != X.hivenumber)
			to_chat(X, SPAN_WARNING("You can only shape on [lowertext(GLOB.hive_datum[X.hivenumber].prefix)]hive weeds. Find a hive node or core before you start building!"))
			qdel(tem)
			return FALSE
		if(T.density)
			qdel(tem)
			to_chat(X, SPAN_WARNING("You need an empty space to build this."))
			return FALSE
	return TRUE

/datum/action/xeno_action/activable/xeno_spit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(!isturf(X.loc))
		to_chat(src, SPAN_WARNING("You can't spit from here!"))
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("You must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(X)

	if(!current_turf)
		return

	plasma_cost = X.ammo.spit_cost

	if(!check_and_use_plasma_owner())
		return

	xeno_cooldown = X.caste.spit_delay + X.ammo.added_spit_delay

	X.visible_message(SPAN_XENOWARNING("[X] spits at [A]!"), \
	SPAN_XENOWARNING("You spit at [A]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(X.loc, sound_to_play, 25, 1)

	var/obj/item/projectile/P = new /obj/item/projectile(current_turf, create_cause_data(initial(X.caste_type), X))
	P.generate_bullet(X.ammo)
	P.permutated += X
	P.def_zone = X.get_limbzone_target()
	P.fire_at(A, X, X, X.ammo.max_range, X.ammo.shell_speed)

	apply_cooldown()
	..()

/datum/action/xeno_action/activable/bombard/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X) || !X.check_state() || !action_cooldown_check() || X.action_busy)
		return FALSE

	var/turf/T = get_turf(A)

	if(isnull(T) || istype(T, /turf/closed) || !T.can_bombard(owner))
		to_chat(X, SPAN_XENODANGER("You can't bombard that!"))
		return FALSE

	if (!check_plasma_owner())
		return FALSE

	if(T.z != X.z)
		to_chat(X, SPAN_WARNING("That target is too far away!"))
		return FALSE

	var/atom/bombard_source = get_bombard_source()
	if (!X.can_bombard_turf(T, range, bombard_source))
		return FALSE

	apply_cooldown()

	X.visible_message(SPAN_XENODANGER("[X] digs itself into place!"), SPAN_XENODANGER("You dig yourself into place!"))
	if (!do_after(X, activation_delay, interrupt_flags, BUSY_ICON_HOSTILE))
		to_chat(X, SPAN_XENODANGER("You decide to cancel your bombard."))
		return FALSE

	if (!X.can_bombard_turf(T, range, bombard_source)) //Second check in case something changed during the do_after.
		return FALSE

	if (!check_and_use_plasma_owner())
		return FALSE

	X.visible_message(SPAN_XENODANGER("[X] launches a massive ball of acid at [A]!"), SPAN_XENODANGER("You launch a massive ball of acid at [A]!"))
	playsound(get_turf(X), 'sound/effects/blobattack.ogg', 25, 1)

	recursive_spread(T, effect_range, effect_range)

	return ..()

/datum/action/xeno_action/activable/bombard/proc/recursive_spread(turf/T, dist_left, orig_depth)
	if(!istype(T))
		return
	else if(dist_left == 0)
		return
	else if(istype(T, /turf/closed) || istype(T, /turf/open/space))
		return
	else if(!T.can_bombard(owner))
		return

	addtimer(CALLBACK(src, .proc/new_effect, T, owner), 2*(orig_depth - dist_left))

	for(var/mob/living/L in T)
		to_chat(L, SPAN_XENOHIGHDANGER("You see a massive ball of acid flying towards you!"))

	for(var/dirn in alldirs)
		recursive_spread(get_step(T, dirn), dist_left - 1, orig_depth)


/datum/action/xeno_action/activable/bombard/proc/new_effect(turf/T, mob/living/carbon/Xenomorph/X)
	if(!istype(T))
		return

	for(var/obj/effect/xenomorph/boiler_bombard/BB in T)
		return

	new effect_type(T, X)

/datum/action/xeno_action/activable/bombard/proc/get_bombard_source()
	return owner

/turf/proc/can_bombard(var/mob/bombarder)
	if(!can_be_dissolved() && density) return FALSE
	for(var/atom/A in src)
		if(istype(A, /obj/structure/machinery)) continue // Machinery shouldn't block boiler gas (e.g. computers)
		if(ismob(A)) continue // Mobs shouldn't block boiler gas

		if(A && A.unacidable && A.density && !(A.flags_atom & ON_BORDER)) return FALSE

	return TRUE

/mob/living/carbon/Xenomorph/proc/can_bombard_turf(var/atom/target, var/range = 5, var/atom/bombard_source) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
	if(!bombard_source || !isturf(bombard_source.loc))
		to_chat(src, SPAN_XENODANGER("That target is obstructed!"))
		return FALSE
	var/turf/current = bombard_source.loc
	var/turf/target_turf = get_turf(target)

	if (get_dist_sqrd(current, target_turf) > (range*range))
		to_chat(src, SPAN_XENODANGER("That is too far away!"))
		return

	. = TRUE
	while(current != target_turf)
		if(!current)
			. = FALSE
		if(!current.can_bombard(src))
			. = FALSE
		if(current.opacity)
			. = FALSE
		if(.)
			for(var/atom/A in current)
				if(A.opacity)
					. = FALSE
					break
		if(!.)
			to_chat(src, SPAN_XENODANGER("That target is obstructed!"))
			return

		current = get_step_towards(current, target_turf)
