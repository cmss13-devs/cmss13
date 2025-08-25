//// Powers used by multiple Xenomorphs.
// In general, powers files hold actual implementations of abilities,
// and abilities files hold the object declarations for the abilities

// Plant weeds
/datum/action/xeno_action/onclick/plant_weeds/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!action_cooldown_check())
		return
	if(!xeno.check_state())
		return
	if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
		return

	var/turf/turf = xeno.loc

	if(!istype(turf))
		to_chat(xeno, SPAN_WARNING("We can't do that here."))
		return

	if(turf.density)
		to_chat(xeno, SPAN_WARNING("We can't do that here."))
		return

	var/is_weedable = turf.is_weedable
	if(!is_weedable)
		to_chat(xeno, SPAN_WARNING("Bad place for a garden!"))
		return
	if(!plant_on_semiweedable && is_weedable < FULLY_WEEDABLE)
		to_chat(xeno, SPAN_WARNING("Bad place for a garden!"))
		return

	var/obj/effect/alien/weeds/node/node = locate() in turf
	if(node && node.weed_strength >= xeno.weed_level)
		to_chat(xeno, SPAN_WARNING("There's a pod here already!"))
		return

	var/obj/effect/alien/resin/trap/resin_trap = locate() in turf
	if(resin_trap)
		to_chat(xeno, SPAN_WARNING("We can't weed on top of a trap!"))
		return

	var/obj/effect/alien/weeds/weed = node || locate() in turf
	if(weed && weed.weed_strength >= WEED_LEVEL_HIVE)
		to_chat(xeno, SPAN_WARNING("These weeds are too strong to plant a node on!"))
		return

	for(var/obj/structure/struct in turf)
		if(struct.density && !(struct.flags_atom & ON_BORDER)) // Not sure exactly if we need to test against ON_BORDER though
			to_chat(xeno, SPAN_WARNING("We can't do that here."))
			return

	var/area/area = get_area(turf)
	if(isnull(area) || !(area.is_resin_allowed))
		if(!area || area.flags_area & AREA_UNWEEDABLE)
			to_chat(xeno, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(xeno, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	if(!check_and_use_plasma_owner())
		return

	var/list/to_convert
	if(node)
		to_convert = node.children.Copy()

	xeno.visible_message(SPAN_XENONOTICE("\The [xeno] regurgitates a pulsating node and plants it on the ground!"),
	SPAN_XENONOTICE("We regurgitate a pulsating node and plant it on the ground!"), null, 5)
	var/obj/effect/alien/weeds/node/new_node = new node_type(xeno.loc, src, xeno)

	if(to_convert)
		for(var/cur_weed in to_convert)
			var/turf/target_turf = get_turf(cur_weed)
			if(target_turf && !target_turf.density)
				new /obj/effect/alien/weeds(target_turf, new_node)
			qdel(cur_weed)

	playsound(xeno.loc, "alien_resin_build", 25)
	apply_cooldown()
	SEND_SIGNAL(xeno, COMSIG_XENO_PLANT_RESIN_NODE)
	return ..()

/mob/living/carbon/xenomorph/lay_down()
	if(!can_heal && !resting)
		to_chat(src, SPAN_WARNING("No time to rest, must KILL!"))
		return

	if(fortify)
		to_chat(src, SPAN_WARNING("We cannot rest while fortified!"))
		return

	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_WARNING("We cannot rest while burrowed!"))
		return

	if(crest_defense)
		to_chat(src, SPAN_WARNING("We cannot rest while our crest is down!"))
		return

	return ..()

/datum/action/xeno_action/onclick/xeno_resting/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.lay_down()
	button.icon_state = xeno.resting ? "template_active" : "template"
	return ..()

// Shift spits
/datum/action/xeno_action/onclick/shift_spits/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state())
		return
	for(var/i in 1 to length(X.caste.spit_types))
		if(X.ammo == GLOB.ammo_list[X.caste.spit_types[i]])
			if(i == length(X.caste.spit_types))
				X.ammo = GLOB.ammo_list[X.caste.spit_types[1]]
			else
				X.ammo = GLOB.ammo_list[X.caste.spit_types[i+1]]
			break
	to_chat(X, SPAN_NOTICE("We will now spit [X.ammo.name] ([X.ammo.spit_cost] plasma)."))
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, "shift_spit_[X.ammo.icon_state]")
	return ..()

/datum/action/xeno_action/onclick/release_haul/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state())
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_WARNING("We cannot put them down here."))
		return

	X.release_haul(TRUE)

	return ..()

/datum/action/xeno_action/onclick/choose_resin/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state())
		return

	tgui_interact(X)
	return ..()

/datum/action/xeno_action/onclick/choose_resin/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/choose_resin),
	)

/datum/action/xeno_action/onclick/choose_resin/ui_static_data(mob/user)
	var/mob/living/carbon/xenomorph/X = user
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
	var/mob/living/carbon/xenomorph/X = user
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

	var/mob/living/carbon/xenomorph/X = usr
	if(!istype(X))
		return

	switch(action)
		if("choose_resin")
			var/selected_type = text2path(params["type"])
			if(!(selected_type in X.resin_build_order))
				return
			//update the button's overlay with new choice
			update_button_icon(selected_type, to_chat=TRUE)
			X.selected_resin = selected_type
			. = TRUE
		if("refresh_ui")
			. = TRUE

/datum/action/xeno_action/onclick/choose_resin/update_button_icon(selected_type, to_chat = FALSE)
	. = ..()
	if(!selected_type)
		return
	var/datum/resin_construction/resin_construction = GLOB.resin_constructions_list[selected_type]
	if(to_chat)
		to_chat(usr, SPAN_NOTICE("We will now build <b>[resin_construction.construction_name]\s</b> when secreting resin."))
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, resin_construction.construction_name)

// Resin
/datum/action/xeno_action/activable/secrete_resin/use_ability(atom/target)
	if(!..())
		return FALSE
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(isstorage(target.loc))
		return FALSE
	if(xeno_owner.contains(target))
		return FALSE
	if(istype(target, /atom/movable/screen))
		return FALSE
	if(!SSmapping.same_z_map(target.z, xeno_owner.z))
		to_chat(owner, SPAN_XENOWARNING("This area is too far away to affect!"))
		return
	apply_cooldown()
	switch(xeno_owner.build_resin(target, thick, make_message, plasma_cost != 0, build_speed_mod))
		if(SECRETE_RESIN_INTERRUPT)
			if(xeno_cooldown)
				apply_cooldown_override(xeno_cooldown * 3)
			return FALSE
		if(SECRETE_RESIN_FAIL)
			if(xeno_cooldown)
				apply_cooldown_override(1)
			return FALSE
	return TRUE

// leader Marker

/datum/action/xeno_action/activable/info_marker/use_ability(atom/A, mods)
	if(!..())
		return FALSE

	if(mods[CLICK_CATCHER])
		return

	if(!action_cooldown_check())
		return

	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state(TRUE))
		return FALSE

	if(ismob(A)) //anticheese : if they click a mob, it will cancel.
		to_chat(X, SPAN_XENOWARNING("We can't place resin markers on living things!"))
		return FALSE //this is because xenos have thermal vision and can see mobs through walls - which would negate not being able to place them through walls

	if(isstorage(A.loc) || X.contains(A) || istype(A, /atom/movable/screen))
		return FALSE
	var/turf/target_turf = get_turf(A)

	if(!SSmapping.same_z_map(X.loc.z, target_turf.loc.z))
		to_chat(X, SPAN_XENOWARNING("Our mind cannot reach that far."))
		return

	if(!X.hive.living_xeno_queen || !SSmapping.same_z_map(X.hive.living_xeno_queen.z, X.z))
		to_chat(X, SPAN_XENOWARNING("Our psychic link is gone, the Queen is either dead or too far away!"))
		return

	var/tally = 0

	for(var/obj/effect/alien/resin/marker/MRK in X.hive.resin_marks)
		if(MRK.createdby == X.nicknumber)
			tally++
	if(tally >= max_markers)
		to_chat(X, SPAN_XENOWARNING("We have reached the maximum number of resin marks."))
		var/list/promptlist = list("Yes", "No")
		var/obj/effect/alien/resin/marker/Goober = null
		var/promptuser = null
		for(var/i=1, i<=length(X.hive.resin_marks))
			Goober = X.hive.resin_marks[i]
			if(Goober.createdby == X.nicknumber)
				promptuser = tgui_input_list(X, "Remove oldest placed mark: '[Goober.mark_meaning.name]!'?", "Mark limit reached.", promptlist, theme="hive_status")
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
/datum/action/xeno_action/activable/corrosive_acid/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.corrosive_acid(target, acid_type, acid_plasma_cost)
	for(var/obj/item/explosive/plastic/explosive in target.contents)
		xeno.corrosive_acid(explosive,acid_type,acid_plasma_cost)
	return ..()

#define ACID_COST_LEVEL_1 70
#define ACID_COST_LEVEL_2 100
#define ACID_COST_LEVEL_3 200

/// Attempt to fill the target trap (called when xeno attacks with an empty hand)
/// Returns TRUE if the trap was filled
/mob/living/carbon/xenomorph/proc/try_fill_trap(obj/effect/alien/resin/trap/target)
	if(!istype(target))
		return FALSE

	if(!acid_level)
		to_chat(src, SPAN_XENONOTICE("You can't secrete any acid into [target]."))
		return FALSE

	var/trap_acid_level = 0
	if(target.trap_type >= RESIN_TRAP_ACID1)
		trap_acid_level = 1 + target.trap_type - RESIN_TRAP_ACID1

	if(trap_acid_level >= acid_level)
		to_chat(src, SPAN_XENONOTICE("It already has good acid in."))
		return FALSE

	var/acid_cost = ACID_COST_LEVEL_1
	if(acid_level == 2)
		acid_cost = ACID_COST_LEVEL_2
	else if(acid_level == 3)
		acid_cost = ACID_COST_LEVEL_3

	if(!check_plasma(acid_cost))
		to_chat(src, SPAN_XENOWARNING("You must produce more plasma before doing this."))
		return FALSE

	to_chat(src, SPAN_XENONOTICE("You begin charging the resin trap with acid."))
	xeno_attack_delay(src)
	if(!do_after(src, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, src))
		return FALSE

	if(target.trap_type >= RESIN_TRAP_ACID1)
		trap_acid_level = 1 + target.trap_type - RESIN_TRAP_ACID1

	if(trap_acid_level >= acid_level)
		return FALSE

	if(!check_plasma(acid_cost))
		return FALSE

	use_plasma(acid_cost)

	target.cause_data = create_cause_data("resin acid trap", src)
	target.setup_tripwires()
	target.set_state(RESIN_TRAP_ACID1 + acid_level - 1)

	playsound(target, 'sound/effects/refill.ogg', 25, 1)
	visible_message(SPAN_XENOWARNING("[src] pressurises the resin trap with acid!"),
	SPAN_XENOWARNING("You pressurise the resin trap with acid!"), null, 5)
	return TRUE

#undef ACID_COST_LEVEL_1
#undef ACID_COST_LEVEL_2
#undef ACID_COST_LEVEL_3

/datum/action/xeno_action/onclick/emit_pheromones/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return
	xeno.emit_pheromones(emit_cost = plasma_cost)
	return ..()

/mob/living/carbon/xenomorph/proc/emit_pheromones(pheromone, emit_cost = 30)
	if(!check_state(TRUE))
		return
	if(!(locate(/datum/action/xeno_action/onclick/emit_pheromones) in actions))
		to_chat(src, SPAN_XENOWARNING("We are incapable of emitting pheromones!"))
		return
	if(!pheromone)
		if(current_aura)
			current_aura = null
			visible_message(SPAN_XENOWARNING("\The [src] stops emitting pheromones."),
			SPAN_XENOWARNING("We stop emitting pheromones."), null, 5)
		else
			if(!check_plasma(emit_cost))
				to_chat(src, SPAN_XENOWARNING("We do not have enough plasma!"))
				return
			if(client.prefs && client.prefs.no_radials_preference)
				pheromone = tgui_input_list(src, "Choose a pheromone", "Pheromone Menu", caste.aura_allowed + "help" + "cancel", theme="hive_status")
				if(pheromone == "help")
					to_chat(src, SPAN_NOTICE("<br>Pheromones provide a buff to all Xenos in range at the cost of some stored plasma every second, as follows:<br><B>Frenzy</B> - Increased run speed, damage and chance to knock off headhunter masks.<br><B>Warding</B> - While in critical state, increased maximum negative health and slower off weed bleedout.<br><B>Recovery</B> - Increased plasma and health regeneration.<br>"))
					return
				if(!pheromone || pheromone == "cancel" || current_aura || !check_state(1)) //If they are stacking windows, disable all input
					return
			else
				var/static/list/phero_selections = list("Help" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_help"), "Frenzy" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_frenzy"), "Warding" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_warding"), "Recovery" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_recov"))
				pheromone = lowertext(show_radial_menu(src, src.client?.eye, phero_selections))
				if(pheromone == "help")
					to_chat(src, SPAN_XENONOTICE("<br>Pheromones provide a buff to all Xenos in range at the cost of some stored plasma every second, as follows:<br><B>Frenzy (Red)</B> - Increased run speed, damage and chance to knock off headhunter masks.<br><B>Warding (Green)</B> - While in critical state, increased maximum negative health and slower off weed bleedout.<br><B>Recovery (Blue)</B> - Increased plasma and health regeneration.<br>"))
					return
				if(!pheromone || current_aura || !check_state(1)) //If they are stacking windows, disable all input
					return
	if(pheromone)
		if(pheromone == current_aura)
			to_chat(src, SPAN_XENOWARNING("We are already emitting [pheromone] pheromones!"))
			return
		if(!check_plasma(emit_cost))
			to_chat(src, SPAN_XENOWARNING("We do not have enough plasma!"))
			return
		use_plasma(emit_cost)
		current_aura = pheromone
		visible_message(SPAN_XENOWARNING("\The [src] begins to emit strange-smelling pheromones."),
		SPAN_XENOWARNING("We begin to emit '[pheromone]' pheromones."), null, 5)
		SEND_SIGNAL(src, COMSIG_XENO_START_EMIT_PHEROMONES, pheromone)
		playsound(loc, "alien_drool", 25)

	if(isqueen(src) && hive && length(hive.xeno_leader_list) && anchored)
		for(var/mob/living/carbon/xenomorph/L in hive.xeno_leader_list)
			L.handle_xeno_leader_pheromones()

/datum/action/xeno_action/activable/pounce/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

	if(!action_cooldown_check())
		return

	if(!A)
		return

	if(A.layer >= FLY_LAYER)//anything above that shouldn't be pounceable (hud stuff)
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_XENOWARNING("We can't [action_text] from here!"))
		return

	if(!X.check_state())
		return

	if(X.legcuffed)
		to_chat(X, SPAN_XENODANGER("We can't [action_text] with that thing on our leg!"))
		return

	if(!check_and_use_plasma_owner())
		return

	if(X.layer == XENO_HIDING_LAYER) //Xeno is currently hiding, unhide him
		var/datum/action/xeno_action/onclick/xenohide/hide = get_action(X, /datum/action/xeno_action/onclick/xenohide)
		if(hide)
			hide.post_attack()

	if(isravager(X))
		X.emote("roar")

	if (!tracks_target)
		A = get_turf(A)

	if(A.z != X.z && X.mob_size >= MOB_SIZE_BIG)
		if (!do_after(X, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			return

	//everyone gets (extra) timer to pounce up
	if(A.z > X.z)
		if (!do_after(X, 0.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			return




	apply_cooldown()

	if (windup)
		X.set_face_dir(get_cardinal_dir(X, A))
		if (!windup_interruptable)
			ADD_TRAIT(X, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Pounce"))
			X.anchored = TRUE
		pre_windup_effects()

		if (!do_after(X, windup_duration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			to_chat(X, SPAN_XENODANGER("We cancel our [action_text]!"))
			if (!windup_interruptable)
				REMOVE_TRAIT(X, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Pounce"))
				X.anchored = FALSE
			post_windup_effects(interrupted = TRUE)
			return

		if (!windup_interruptable)
			REMOVE_TRAIT(X, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Pounce"))
			X.anchored = FALSE
		post_windup_effects()

	X.visible_message(SPAN_XENOWARNING("\The [X] [action_text][findtext(action_text, "e", -1) || findtext(action_text, "p", -1) ? "s" : "es"] at [A]!"), SPAN_XENOWARNING("We [action_text] at [A]!"))

	pre_pounce_effects()

	X.pounce_distance = get_dist(X, A)
	X.throw_atom(A, distance, throw_speed, X, launch_type = LOW_LAUNCH, pass_flags = pounce_pass_flags, collision_callbacks = pounce_callbacks, tracking=TRUE)
	X.update_icons()

	additional_effects_always()
	..()

	return TRUE

// Massive, customizable spray_acid
/datum/action/xeno_action/activable/spray_acid/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

	if(!action_cooldown_check())
		return

	if(!A)
		return

	if(A.layer >= FLY_LAYER)
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_XENOWARNING("We can't [action_text] from here!"))
		return

	if(!X.check_state() || X.action_busy)
		return

	if (activation_delay)
		if(!do_after(X, activation_delay_length, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			to_chat(X, SPAN_XENOWARNING("We decide to cancel our acid spray."))
			end_cooldown()
			return

	if (!action_cooldown_check())
		return

	apply_cooldown()

	if(!check_and_use_plasma_owner())
		return

	playsound(get_turf(X), 'sound/effects/refill.ogg', 25, 1)
	X.visible_message(SPAN_XENOWARNING("[X] vomits a flood of acid!"), SPAN_XENOWARNING("We vomit a flood of acid!"), null, 5)

	apply_cooldown()

	// Build our list of target turfs based on
	if (spray_type == ACID_SPRAY_LINE)
		X.do_acid_spray_line(get_line(X, A, include_start_atom = FALSE), spray_effect_type, spray_distance)

	else if (spray_type == ACID_SPRAY_CONE)
		X.do_acid_spray_cone(get_turf(A), spray_effect_type, spray_distance)

	return ..()

/datum/action/xeno_action/onclick/xenohide/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state(TRUE))
		return
	if(!action_cooldown_check())
		return
	if(xeno.action_busy)
		return
	if(xeno.layer != XENO_HIDING_LAYER)
		xeno.layer = XENO_HIDING_LAYER
		to_chat(xeno, SPAN_NOTICE("We are now hiding."))
		button.icon_state = "template_active"
		RegisterSignal(xeno, COMSIG_MOB_STATCHANGE, PROC_REF(unhide_on_stat))
	else
		xeno.layer = initial(xeno.layer)
		to_chat(xeno, SPAN_NOTICE("We have stopped hiding."))
		button.icon_state = "template"
		UnregisterSignal(xeno, COMSIG_MOB_STATCHANGE)
	xeno.update_wounds()
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/xenohide/proc/unhide_on_stat(mob/living/carbon/xenomorph/source, new_stat, old_stat)
	SIGNAL_HANDLER
	if(!QDELETED(source) && (new_stat >= UNCONSCIOUS && old_stat <= UNCONSCIOUS))
		post_attack()

/datum/action/xeno_action/onclick/place_trap/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state())
		return

	if (istype(X, /mob/living/carbon/xenomorph/burrower))
		var/mob/living/carbon/xenomorph/burrower/B = X
		if (HAS_TRAIT(B, TRAIT_ABILITY_BURROWED))
			return

	var/turf/T = get_turf(X)
	if(!istype(T))
		to_chat(X, SPAN_XENOWARNING("We can't do that here."))
		return
	var/area/AR = get_area(T)
	if(istype(AR,/area/shuttle/drop1/lz1) || istype(AR,/area/shuttle/drop2/lz2) || SSinterior.in_interior(owner))
		to_chat(X, SPAN_WARNING("We sense this is not a suitable area for creating a resin hole."))
		return
	var/obj/effect/alien/weeds/alien_weeds = T.check_xeno_trap_placement(X)
	if(!alien_weeds)
		return
	if(istype(alien_weeds, /obj/effect/alien/weeds/node))
		to_chat(X, SPAN_NOTICE("We start uprooting the node so we can put the resin hole in its place..."))
		if(!do_after(X, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, target, INTERRUPT_ALL))
			return
		if(!T.check_xeno_trap_placement(X))
			return
		var/obj/effect/alien/weeds/the_replacer = new /obj/effect/alien/weeds(T)
		the_replacer.hivenumber = X.hivenumber
		the_replacer.linked_hive = X.hive
		set_hive_data(the_replacer, X.hivenumber)
		qdel(alien_weeds)

	if(!X.check_plasma(plasma_cost))
		return
	X.use_plasma(plasma_cost)
	playsound(X.loc, "alien_resin_build", 25)
	new /obj/effect/alien/resin/trap(T, X)
	to_chat(X, SPAN_XENONOTICE("We place a resin hole on the weeds, it still needs a sister to fill it with acid."))
	return ..()

/turf/proc/check_xeno_trap_placement(mob/living/carbon/xenomorph/xeno)
	if(is_weedable < FULLY_WEEDABLE || !can_xeno_build(src))
		to_chat(xeno, SPAN_XENOWARNING("We can't do that here."))
		return FALSE

	var/obj/effect/alien/weeds/alien_weeds = locate() in src
	if(!alien_weeds)
		to_chat(xeno, SPAN_XENOWARNING("We can only shape on weeds. We must find some resin before we start building!"))
		return FALSE

	if(alien_weeds.linked_hive.hivenumber != xeno.hivenumber)
		to_chat(xeno, SPAN_XENOWARNING("These weeds don't belong to our hive!"))
		return FALSE

	// This snowflake check exists because stairs specifically are indestructable, tile-covering, and cannot be moved, which allows resin holes to be
	// planted under them without any possible counterplay. In the future if resin holes stop being able to be hidden under objects, remove this check.
	if(locate(/obj/structure) in src)
		if(locate(/obj/structure/stairs) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot make a hole on a staircase!"))
			return FALSE

		if(locate(/obj/structure/monorail) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot make a hole on a track!"))
			return FALSE

		if(locate(/obj/structure/machinery/conveyor) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot make a hole on a conveyor!"))
			return FALSE

		if(locate(/obj/structure/machinery/colony_floodlight) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot make a hole on a light!"))
			return FALSE

		if(locate(/obj/structure/flora/jungle/vines) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot make a hole under the vines!"))
			return FALSE

	if(!xeno.check_alien_construction(src, check_doors = TRUE))
		return FALSE

	if(locate(/obj/effect/alien/resin/trap) in orange(1, src)) // obj/effect/alien/resin presence is checked on turf by check_alien_construction, so we just check orange.
		to_chat(xeno, SPAN_XENOWARNING("This is too close to another resin hole!"))
		return FALSE

	if(locate(/obj/effect/alien/resin/fruit) in orange(1, src))
		to_chat(xeno, SPAN_XENOWARNING("This is too close to a fruit!"))
		return FALSE

	for(var/mob/living/body in src)
		if(body.stat == DEAD)
			to_chat(xeno, SPAN_XENOWARNING("The body is in the way!"))
			return FALSE

	return alien_weeds

/datum/action/xeno_action/activable/place_construction/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state())
		return FALSE

	if(isstorage(A.loc) || X.contains(A) || istype(A, /atom/movable/screen))
		return FALSE

	//Make sure construction is unrestricted
	if(X.hive && X.hive.construction_allowed == XENO_LEADER && X.hive_pos == NORMAL_XENO)
		to_chat(X, SPAN_WARNING("Construction is currently restricted to Leaders only!"))
		return FALSE
	else if(X.hive && X.hive.construction_allowed == XENO_QUEEN && !istype(X.caste, /datum/caste_datum/queen))
		to_chat(X, SPAN_WARNING("Construction is currently restricted to Queen only!"))
		return FALSE
	else if(X.hive && X.hive.construction_allowed == XENO_NOBODY)
		to_chat(X, SPAN_WARNING("The hive is too weak and fragile to have the strength to design constructions."))
		return FALSE

	var/turf/T = get_turf(A)

	var/area/AR = get_area(T)
	if(isnull(AR) || !(AR.is_resin_allowed))
		if(!AR || AR.flags_area & AREA_UNWEEDABLE)
			to_chat(X, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return FALSE

	if(T.z != X.z)
		to_chat(X, SPAN_XENOWARNING("This area is too far away to affect!"))
		return FALSE

	if(SSinterior.in_interior(X))
		to_chat(X, SPAN_XENOWARNING("It's too tight in here to build."))
		return FALSE

	if(!X.check_alien_construction(T))
		return FALSE

	var/choice = XENO_STRUCTURE_CORE
	if(X.hive.hivecore_cooldown)
		to_chat(X, SPAN_WARNING("The weeds are still recovering from the death of the hive core, wait until the weeds have recovered!"))
		return FALSE
	if(X.hive.has_structure(XENO_STRUCTURE_CORE) || !X.hive.can_build_structure(XENO_STRUCTURE_CORE))
		choice = tgui_input_list(X, "Choose a structure to build", "Build structure", X.hive.hive_structure_types + "help", theme = "hive_status")
		if(!choice)
			return
		if(choice == "help")
			var/message = "Placing a construction node creates a template for special structures that can benefit the hive, which require the insertion of plasma to construct the following:<br>"
			for(var/structure_name in X.hive.hive_structure_types)
				var/datum/construction_template/xenomorph/structure_type = X.hive.hive_structure_types[structure_name]
				message += "<b>[capitalize_first_letters(structure_name)]</b> - [initial(structure_type.description)]<br>"
			to_chat(X, SPAN_NOTICE(message))
			return TRUE
	if(!X.check_state(TRUE) || !X.check_plasma(400))
		return FALSE
	var/structure_type = X.hive.hive_structure_types[choice]
	var/datum/construction_template/xenomorph/structure_template = new structure_type()

	if(!spacecheck(X, T, structure_template))
		// spacecheck already cleans up the template
		return FALSE

	if((choice == XENO_STRUCTURE_EGGMORPH) && locate(/obj/structure/flora/grass/tallgrass) in T)
		to_chat(X, SPAN_WARNING("The tallgrass is preventing us from building the egg morpher!"))
		qdel(structure_template)
		return FALSE

	if(!do_after(X, XENO_STRUCTURE_BUILD_TIME, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return FALSE

	if(!spacecheck(X, T, structure_template)) //doublechecking
		// spacecheck already cleans up the template
		return FALSE

	if(choice == XENO_STRUCTURE_CORE && AR.unoviable_timer)
		to_chat(X, SPAN_WARNING("This area does not feel right for you to build this in."))
		qdel(structure_template)
		return FALSE

	if((choice == XENO_STRUCTURE_CORE) && isqueen(X) && X.hive.has_structure(XENO_STRUCTURE_CORE))
		if(X.hive.hive_location.hardcore || world.time > XENOMORPH_PRE_SETUP_CUTOFF)
			to_chat(X, SPAN_WARNING("We can't rebuild this structure!"))
			qdel(structure_template)
			return FALSE
		if(alert(X, "Are we sure that we want to move the hive and destroy the old hive core?", , "Yes", "No") != "Yes")
			qdel(structure_template)
			return FALSE
		qdel(X.hive.hive_location)
	else if(!X.hive.can_build_structure(choice))
		to_chat(X, SPAN_WARNING("We can't build any more [choice]s for the hive."))
		qdel(structure_template)
		return FALSE

	if(QDELETED(T))
		to_chat(X, SPAN_WARNING("We cannot build here!"))
		qdel(structure_template)
		return FALSE

	var/queen_on_zlevel = !X.hive.living_xeno_queen || SSmapping.same_z_map(X.hive.living_xeno_queen.z, T.z)
	if(!queen_on_zlevel)
		to_chat(X, SPAN_WARNING("Our link to the Queen is too weak here. She is on another world."))
		qdel(structure_template)
		return FALSE

	if(SSinterior.in_interior(X))
		to_chat(X, SPAN_WARNING("It's too tight in here to build."))
		qdel(structure_template)
		return FALSE

	if(T.is_weedable < FULLY_WEEDABLE)
		to_chat(X, SPAN_WARNING("\The [T] can't support a [structure_template.name]!"))
		qdel(structure_template)
		return FALSE

	var/obj/effect/alien/weeds/weeds = locate() in T
	if(weeds?.block_structures >= BLOCK_SPECIAL_STRUCTURES)
		to_chat(X, SPAN_WARNING("\The [weeds] block the construction of any special structures!"))
		qdel(structure_template)
		return FALSE

	X.use_plasma(400)
	X.place_construction(T, structure_template)

	return ..()

// XSS Spacecheck

/datum/action/xeno_action/activable/place_construction/proc/spacecheck(mob/living/carbon/xenomorph/X, turf/T, datum/construction_template/xenomorph/tem)
	if(tem.block_range)
		for(var/turf/TA in range(tem.block_range, T))
			if(!X.check_alien_construction(TA, FALSE, TRUE, ignore_nest = TRUE))
				to_chat(X, SPAN_WARNING("We need more open space to build here."))
				qdel(tem)
				return FALSE
		if(!X.check_alien_construction(T, ignore_nest = TRUE))
			to_chat(X, SPAN_WARNING("We need more open space to build here."))
			qdel(tem)
			return FALSE
		var/obj/effect/alien/weeds/alien_weeds = locate() in T
		if(!alien_weeds || alien_weeds.weed_strength < WEED_LEVEL_HIVE || alien_weeds.linked_hive.hivenumber != X.hivenumber)
			to_chat(X, SPAN_WARNING("We can only shape on [lowertext(GLOB.hive_datum[X.hivenumber].prefix)]hive weeds. We must find a hive node or core before we start building!"))
			qdel(tem)
			return FALSE
		if(T.density)
			qdel(tem)
			to_chat(X, SPAN_WARNING("We need empty space to build this."))
			return FALSE
	return TRUE

/datum/action/xeno_action/activable/xeno_spit/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/spit_target = aim_turf ? get_turf(atom) : atom
	if(!xeno.check_state())
		return

	if(spitting)
		to_chat(src, SPAN_WARNING("We are already preparing a spit!"))
		return

	if(!isturf(xeno.loc))
		to_chat(src, SPAN_WARNING("We can't spit from here!"))
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("We must wait for our spit glands to refill."))
		return

	var/turf/current_turf = get_turf(xeno)

	if(!current_turf)
		return

	if (!check_plasma_owner())
		return

	if(xeno.ammo.spit_windup)
		spitting = TRUE
		if(xeno.ammo.pre_spit_warn)
			playsound(xeno.loc,"alien_drool", 55, 1)
		to_chat(xeno, SPAN_WARNING("We begin to prepare a large spit!"))
		xeno.visible_message(SPAN_WARNING("[xeno] prepares to spit a massive glob!"),
		SPAN_WARNING("We begin to spit [xeno.ammo.name]!"))
		if (!do_after(xeno, xeno.ammo.spit_windup, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			to_chat(xeno, SPAN_XENODANGER("We decide to cancel our spit."))
			spitting = FALSE
			return
	plasma_cost = xeno.ammo.spit_cost

	if(!check_and_use_plasma_owner())
		spitting = FALSE
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] spits at [atom]!"),

	SPAN_XENOWARNING("We spit [xeno.ammo.name] at [atom]!") )
	playsound(xeno.loc, sound_to_play, 25, 1)

	var/obj/projectile/proj = new (current_turf, create_cause_data(xeno.ammo.name, xeno))
	proj.generate_bullet(xeno.ammo)
	proj.permutated += xeno
	proj.def_zone = xeno.get_limbzone_target()
	proj.fire_at(spit_target, xeno, xeno, xeno.ammo.max_range, xeno.ammo.shell_speed)

	spitting = FALSE

	SEND_SIGNAL(xeno, COMSIG_XENO_POST_SPIT)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/bombard/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

	if (!istype(X) || !X.check_state() || !action_cooldown_check() || X.action_busy)
		return FALSE

	var/turf/T = get_turf(A)

	if(isnull(T) || istype(T, /turf/closed) || !T.can_bombard(owner))
		to_chat(X, SPAN_XENODANGER("We can't bombard that!"))
		return FALSE

	if (!check_plasma_owner())
		return FALSE

	if(T.z != X.z)
		to_chat(X, SPAN_WARNING("That target is too far away!"))
		return FALSE

	var/atom/bombard_source = get_bombard_source()
	if (!X.can_bombard_turf(T, range, bombard_source))
		return FALSE

	X.visible_message(SPAN_XENODANGER("[X] digs itself into place!"), SPAN_XENODANGER("We dig ourself into place!"))
	if (!do_after(X, activation_delay, interrupt_flags, BUSY_ICON_HOSTILE))
		to_chat(X, SPAN_XENODANGER("We decide to cancel our bombard."))
		return FALSE

	if (!X.can_bombard_turf(T, range, bombard_source)) //Second check in case something changed during the do_after.
		return FALSE

	if (!check_and_use_plasma_owner())
		return FALSE

	apply_cooldown()

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

	addtimer(CALLBACK(src, PROC_REF(new_effect), T, owner), 2*(orig_depth - dist_left))

	for(var/mob/living/L in T)
		to_chat(L, SPAN_XENOHIGHDANGER("You see a massive ball of acid flying towards you!"))

	for(var/dirn in GLOB.alldirs)
		recursive_spread(get_step(T, dirn), dist_left - 1, orig_depth)


/datum/action/xeno_action/activable/bombard/proc/new_effect(turf/T, mob/living/carbon/xenomorph/X)
	if(!istype(T))
		return

	for(var/obj/effect/xenomorph/boiler_bombard/BB in T)
		return

	new effect_type(T, X)

/datum/action/xeno_action/activable/bombard/proc/get_bombard_source()
	return owner

/turf/proc/can_bombard(mob/bombarder)
	if(!can_be_dissolved() && density)
		return FALSE
	for(var/atom/A in src)
		if(istype(A, /obj/structure/machinery))
			continue // Machinery shouldn't block boiler gas (e.g. computers)
		if(ismob(A))
			continue // Mobs shouldn't block boiler gas

		if(A && A.unacidable && A.density && !(A.flags_atom & ON_BORDER))
			return FALSE

	return TRUE

/mob/living/carbon/xenomorph/proc/can_bombard_turf(atom/target, range = 5, atom/bombard_source) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
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

/datum/action/xeno_action/activable/tail_stab/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/stabbing_xeno = owner
	if(HAS_TRAIT(targetted_atom, TRAIT_HAULED))
		return

	if(HAS_TRAIT(stabbing_xeno, TRAIT_ABILITY_BURROWED) || stabbing_xeno.is_ventcrawling)
		to_chat(stabbing_xeno, SPAN_XENOWARNING("We must be above ground to do this."))
		return

	if(!stabbing_xeno.check_state() || stabbing_xeno.cannot_slash)
		return FALSE

	var/pre_result = pre_ability_act(stabbing_xeno, targetted_atom)

	if(pre_result)
		return FALSE

	if(!action_cooldown_check())
		return FALSE

	if (world.time <= stabbing_xeno.next_move)
		return FALSE

	if(stabbing_xeno.z != targetted_atom.z)
		return

	var/distance = get_dist(stabbing_xeno, targetted_atom)
	if(distance > stab_range)
		return FALSE

	var/list/turf/path = get_line(stabbing_xeno, targetted_atom, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
			return FALSE
		for(var/obj/path_contents in path_turf.contents)
			if(path_contents != targetted_atom && path_contents.density && !path_contents.throwpass)
				to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
				return FALSE

		var/atom/barrier = path_turf.handle_barriers(stabbing_xeno, null, (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			var/tail_stab_cooldown_multiplier = barrier.handle_tail_stab(stabbing_xeno)
			if(!tail_stab_cooldown_multiplier)
				to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
			else
				apply_cooldown(cooldown_modifier = tail_stab_cooldown_multiplier)
				xeno_attack_delay(stabbing_xeno)
			return FALSE

	var/tail_stab_cooldown_multiplier = targetted_atom.handle_tail_stab(stabbing_xeno)
	if(tail_stab_cooldown_multiplier)
		stabbing_xeno.animation_attack_on(targetted_atom)
		apply_cooldown(cooldown_modifier = tail_stab_cooldown_multiplier)
		xeno_attack_delay(stabbing_xeno)
		return ..()

	if(!isxeno_human(targetted_atom))
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] swipes their tail through the air!"), SPAN_XENOWARNING("We swipe our tail through the air!"))
		apply_cooldown(cooldown_modifier = 0.1)
		xeno_attack_delay(stabbing_xeno)
		playsound(stabbing_xeno, "alien_tail_swipe", 50, TRUE)
		return FALSE

	if(stabbing_xeno.can_not_harm(targetted_atom))
		return FALSE

	var/mob/living/carbon/target = targetted_atom

	if(target.stat == DEAD || HAS_TRAIT(target, TRAIT_NESTED))
		return FALSE

	var/obj/limb/limb = target.get_limb(check_zone(stabbing_xeno.zone_selected))
	if (ishuman(target) && (!limb || (limb.status & LIMB_DESTROYED)))
		to_chat(stabbing_xeno, (SPAN_WARNING("What [limb.display_name]?")))
		return FALSE

	if(!check_and_use_plasma_owner())
		return FALSE

	var/result = ability_act(stabbing_xeno, target, limb)

	apply_cooldown()
	xeno_attack_delay(stabbing_xeno)
	..()
	return result

/datum/action/xeno_action/activable/tail_stab/proc/pre_ability_act(mob/living/carbon/xenomorph/stabbing_xeno, atom/targetted_atom)
	return

/datum/action/xeno_action/activable/tail_stab/proc/ability_act(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/target, obj/limb/limb)

	target.last_damage_data = create_cause_data(initial(stabbing_xeno.caste_type), stabbing_xeno)

	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = stabbing_xeno.dir
	/// Direction var to make the tail stab look cool and immersive.
	var/stab_direction

	var/stab_overlay

	if(blunt_stab)
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] swipes its tail into [target]'s [limb ? limb.display_name : "chest"], bashing it!"), SPAN_XENOWARNING("We swipe our tail into [target]'s [limb? limb.display_name : "chest"], bashing it!"))
		if(prob(1))
			playsound(target, 'sound/effects/comical_bonk.ogg', 50, TRUE)
		else
			playsound(target, "punch", 50, TRUE)
		// The xeno smashes the target with their tail, moving it to the side and thus their direction as well.
		stab_direction = turn(stabbing_xeno.dir, pick(90, -90))
		stab_overlay = "slam"
	else
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] skewers [target] through the [limb ? limb.display_name : "chest"] with its razor sharp tail!"), SPAN_XENOWARNING("We skewer [target] through the [limb? limb.display_name : "chest"] with our razor sharp tail!"))
		playsound(target, "alien_bite", 50, TRUE)
		// The xeno flips around for a second to impale the target with their tail. These look awsome.
		stab_direction = turn(get_dir(stabbing_xeno, target), 180)
		stab_overlay = "tail"
	log_attack("[key_name(stabbing_xeno)] tailstabbed [key_name(target)] at [get_area_name(stabbing_xeno)]")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>was tailstabbed by [key_name(stabbing_xeno)]</font>")
	stabbing_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>tailstabbed [key_name(target)]</font>")

	if(last_dir != stab_direction)
		stabbing_xeno.setDir(stab_direction)
		stabbing_xeno.emote("tail")
		/// Ditto.
		var/new_dir = stabbing_xeno.dir
		addtimer(CALLBACK(src, PROC_REF(reset_direction), stabbing_xeno, last_dir, new_dir), 0.5 SECONDS)

	stabbing_xeno.animation_attack_on(target)
	stabbing_xeno.flick_attack_overlay(target, stab_overlay)

	var/damage = (stabbing_xeno.melee_damage_upper + stabbing_xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER) * TAILSTAB_MOB_DAMAGE_MULTIPLIER

	if(stabbing_xeno.behavior_delegate)
		stabbing_xeno.behavior_delegate.melee_attack_additional_effects_target(target)
		stabbing_xeno.behavior_delegate.melee_attack_additional_effects_self()
		damage = stabbing_xeno.behavior_delegate.melee_attack_modify_damage(damage, target)

	target.apply_armoured_damage(get_xeno_damage_slash(target, damage), ARMOR_MELEE, BRUTE, limb ? limb.name : "chest")
	if(stabbing_xeno.mob_size >= MOB_SIZE_BIG)
		target.apply_effect(3, DAZE)
	else if(stabbing_xeno.mob_size == MOB_SIZE_XENO)
		target.apply_effect(1, DAZE)
	shake_camera(target, 2, 1)

	target.handle_blood_splatter(get_dir(owner.loc, target.loc))
	return target

/datum/action/xeno_action/activable/tail_stab/proc/reset_direction(mob/living/carbon/xenomorph/stabbing_xeno, last_dir, new_dir)
	// If the xenomorph is still holding the same direction as the tail stab animation's changed it to, reset it back to the old direction so the xenomorph isn't stuck facing backwards.
	if(new_dir == stabbing_xeno.dir)
		stabbing_xeno.setDir(last_dir)
