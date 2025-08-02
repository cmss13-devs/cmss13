//// Abilities used by multiple Xenos.
//// README
/*
	When I migrated abilities to these files c. 1/2020, I *tried* to mostly
	move the plasma cost and cooldown stuff to the new xeno_action format.
	however certain abilities (read: acid and resin-related) still deduct
	plasma internally. Bear that in mind. -4khan
*/

/mob/living/carbon/xenomorph/proc/set_selected_ability(datum/action/xeno_action/activable/ability)
	if(!ability)
		selected_ability = null
		client?.set_right_click_menu_mode(shift_only = FALSE)
		return
	selected_ability = ability
	if(get_ability_mouse_key() == XENO_ABILITY_CLICK_RIGHT)
		client?.set_right_click_menu_mode(shift_only = TRUE)

/datum/action/xeno_action/onclick/plant_weeds
	name = "Plant Weeds (75)"
	action_icon_state = "plant_weeds"
	plasma_cost = 75
	macro_path = /datum/action/xeno_action/verb/verb_plant_weeds
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 1 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/plant_on_semiweedable = FALSE
	var/node_type = /obj/effect/alien/weeds/node

// Resting
/datum/action/xeno_action/onclick/xeno_resting
	name = "Rest"
	action_icon_state = "resting"
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/onclick/xeno_resting/can_use_action()
	var/mob/living/carbon/xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/xeno_resting/give_to(mob/living/living_mob)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.resting)
		button.icon_state = "template_active"

// Shift Spits
/datum/action/xeno_action/onclick/shift_spits
	name = "Toggle Spit Type"
	action_icon_state = "shift_spit_neurotoxin"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_toggle_gas_type
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2

/datum/action/xeno_action/onclick/shift_spits/can_use_action()
	var/mob/living/carbon/xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

// release_haul
/datum/action/xeno_action/onclick/release_haul
	name = "Release"
	action_icon_state = "release_haul"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_release_haul
	action_type = XENO_ACTION_CLICK

// Choose Resin
/datum/action/xeno_action/onclick/choose_resin
	name = "Choose Resin Structure"
	action_icon_state = "retrieve_egg"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_choose_resin_structure
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2

/datum/action/xeno_action/onclick/choose_resin/queen_macro //so it doesn't screw other macros up
	ability_primacy = XENO_PRIMARY_ACTION_4 //it's important that hivelord and drone have the same macros because their playstyle is similar, but it's not as important for queen since her playstyle is very different

// Secrete Resin
/datum/action/xeno_action/activable/secrete_resin
	name = "Secrete Resin"
	action_icon_state = "secrete_resin"
	var/thick = FALSE
	var/make_message = TRUE
	macro_path = /datum/action/xeno_action/verb/verb_secrete_resin
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

	var/build_speed_mod = 1

	plasma_cost = 1

/datum/action/xeno_action/activable/secrete_resin/can_use_action()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/xenomorph/X = owner
	if(X)
		return X.selected_resin
	else
		return FALSE

/datum/action/xeno_action/activable/secrete_resin/queen_macro //see above for reasoning
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/activable/secrete_resin/hivelord
	name = "Secrete Thick Resin"
	thick = TRUE

//resin marker
/datum/action/xeno_action/activable/info_marker
	name = "Mark Resin"
	action_icon_state = "mark"
	macro_path = /datum/action/xeno_action/verb/verb_mark_resin
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	xeno_cooldown = 10 SECONDS
	var/max_markers = 3

/datum/action/xeno_action/activable/info_marker/update_button_icon(datum/xeno_mark_define/x)
	. = ..()
	if(!x)
		return
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', "mark_[x.icon_state]")

/datum/action/xeno_action/activable/info_marker/queen
	max_markers = 5

// Corrosive Acid
/datum/action/xeno_action/activable/corrosive_acid
	name = "Corrosive Acid (100)"
	action_icon_state = "corrosive_acid"
	var/acid_plasma_cost = 100
	var/level = 2 //level of the acid strength
	var/acid_type = /obj/effect/xenomorph/acid
	macro_path = /datum/action/xeno_action/verb/verb_corrosive_acid
	ability_primacy = XENO_CORROSIVE_ACID
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/corrosive_acid/New()
	update_level()
	. = ..()

/datum/action/xeno_action/activable/corrosive_acid/proc/update_level()
	switch(level)
		if(1)
			name = "Corrosive Acid (75)"
			acid_plasma_cost = 75
			acid_type = /obj/effect/xenomorph/acid/weak
		if(2)
			name = "Corrosive Acid (100)"
			acid_plasma_cost = 100
			acid_type = /obj/effect/xenomorph/acid
		if(3)
			name = "Corrosive Acid (125)"
			acid_plasma_cost = 125
			acid_type = /obj/effect/xenomorph/acid/strong

/datum/action/xeno_action/activable/corrosive_acid/weak
	name = "Corrosive Acid (75)"
	acid_plasma_cost = 75
	level = 1
	acid_type = /obj/effect/xenomorph/acid/weak

/datum/action/xeno_action/activable/corrosive_acid/strong
	name = "Corrosive Acid (125)"
	acid_plasma_cost = 125
	level = 3
	acid_type = /obj/effect/xenomorph/acid/strong

/datum/action/xeno_action/onclick/emit_pheromones
	name = "Emit Pheromones (30)"
	action_icon_state = "emit_pheromones"
	plasma_cost = 30
	macro_path = /datum/action/xeno_action/verb/verb_pheremones
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/onclick/emit_pheromones/can_use_action()
	var/mob/living/carbon/xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated() && (!X.current_aura || X.plasma_stored >= plasma_cost))
		return TRUE

// Pounce
// Subtype this to customize behavior, or do it at runtime
/datum/action/xeno_action/activable/pounce
	name = "Pounce"
	action_icon_state = "pounce"
	var/action_text = "pounce"
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 4 SECONDS
	plasma_cost = 10

	// Config options
	var/distance = 6 // 6 for runners, 4 for ravagers and praes

	var/knockdown = TRUE // Should we knock down the target?
	var/knockdown_duration = 1 // 1 for runners, 3 for lurkers.
										// ONLY USED IF THE POUNCE KNOCKS DOWN

	var/slash = FALSE // Do we slash upon reception?
	var/slash_bonus_damage = 0 // Any bonus damage to apply on the tackle slash, if applicable

	var/freeze_self = TRUE // Should we freeze ourselves after the lunge?
	var/freeze_time = 5 // 5 for runners, 15 for lurkers
	var/freeze_timer_id = TIMER_ID_NULL // Timer to cancel the end freeze if it can be cancelled earlier
	var/freeze_play_sound = TRUE

	var/windup = FALSE // Is there a do_after before we pounce?
	var/windup_duration = 20 // How long to wind up, if applicable
	var/windup_interruptable = TRUE // Can the windup be interrupted?

	var/can_be_shield_blocked = FALSE // Some legacy stuff, self explanatory
	var/should_destroy_objects = FALSE  // Only used for ravager charge
	var/pounce_pass_flags // Pounce flags to customize what pounce can go over/through
	var/throw_speed = SPEED_FAST // Throw speed
	var/tracks_target = TRUE // Does it track the target atom?

	var/list/pounce_callbacks = null // Specific callbacks to invoke when a pounce lands on an atom of a specific type
										// (note that if a collided atom does not match any of the key types, defaults to the appropriate X_launch_collision proc)

/datum/action/xeno_action/activable/pounce/New()
	. = ..()
	initialize_pounce_pass_flags()
	pounce_callbacks = list()
	pounce_callbacks[/mob] = DYNAMIC(/mob/living/carbon/xenomorph/proc/pounced_mob_wrapper)
	pounce_callbacks[/obj] = DYNAMIC(/mob/living/carbon/xenomorph/proc/pounced_obj_wrapper)
	pounce_callbacks[/turf] = DYNAMIC(/mob/living/carbon/xenomorph/proc/pounced_turf_wrapper)

/datum/action/xeno_action/activable/pounce/proc/initialize_pounce_pass_flags()
	pounce_pass_flags = PASS_OVER_THROW_MOB

/**
 * Any additional effects to apply to the target
 * is called if and only if we actually hit a human target
 */
/datum/action/xeno_action/activable/pounce/proc/additional_effects(mob/living/L)
	return

/// Additional effects to apply even if we don't hit anything
/datum/action/xeno_action/activable/pounce/proc/additional_effects_always()
	return

/**
 * Effects to apply *inmediately* before pouncing.
 */
/datum/action/xeno_action/activable/pounce/proc/pre_pounce_effects()
	return

/datum/action/xeno_action/activable/pounce/proc/end_pounce_freeze()
	if(freeze_timer_id == TIMER_ID_NULL)
		return
	var/mob/living/carbon/xenomorph/X = owner
	REMOVE_TRAIT(X, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Pounce"))
	deltimer(freeze_timer_id)
	freeze_timer_id = TIMER_ID_NULL
	to_chat(X, SPAN_XENONOTICE("Slashing frenzies us! We feel free to move immediately!"))

/// Any effects to apply to the xenomorph before the windup occurs
/datum/action/xeno_action/activable/pounce/proc/pre_windup_effects()
	return

/// Any effects to apply to the xenomorph after the windup finishes (or is interrupted)
/datum/action/xeno_action/activable/pounce/proc/post_windup_effects(interrupted)
	SHOULD_CALL_PARENT(TRUE)
	if(!owner)
		return
	owner.flags_atom &= ~DIRLOCK

/datum/action/xeno_action/onclick/toggle_long_range
	name = "Toggle Long-Range Sight"
	action_icon_state = "toggle_long_range"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_long_range
	action_type = XENO_ACTION_ACTIVATE
	var/should_delay = FALSE
	var/delay = 20
	var/handles_movement = TRUE

	/// how much you can move before zoom breaks
	var/movement_buffer = 0

	/// if we can move while zoomed, how slowed will we be when zoomed in? Use speed modifier defines.
	var/movement_slowdown = 0

/datum/action/xeno_action/onclick/toggle_long_range/can_use_action()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno && !xeno.is_mob_incapacitated() && !xeno.buckled)
		return TRUE

/datum/action/xeno_action/onclick/toggle_long_range/give_to(mob/living/living_mob)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.is_zoomed)
		button.icon_state = "template_active"

/datum/action/xeno_action/onclick/toggle_long_range/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!HAS_TRAIT(xeno, TRAIT_ABILITY_SIGHT_IGNORE_REST) && !xeno.check_state())
		return

	if(xeno.observed_xeno)
		return

	if(xeno.is_zoomed)
		xeno.zoom_out() // will call on_zoom_out()
		return
	xeno.visible_message(SPAN_NOTICE("[xeno] starts looking off into the distance."),
		SPAN_NOTICE("We start focusing our sight to look off into the distance."), null, 5)
	if (should_delay)
		if(!do_after(xeno, delay, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			return
	if(xeno.is_zoomed)
		return
	if(handles_movement)
		RegisterSignal(xeno, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(handle_mob_move_or_look))
	if(movement_slowdown)
		xeno.speed_modifier += movement_slowdown
		xeno.recalculate_speed()
	xeno.zoom_in()
	button.icon_state = "template_active"
	return ..()

/datum/action/xeno_action/onclick/toggle_long_range/proc/on_zoom_out()
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.visible_message(SPAN_NOTICE("[xeno] stops looking off into the distance."),
	SPAN_NOTICE("We stop looking off into the distance."), null, 5)
	if(movement_slowdown)
		xeno.speed_modifier -= movement_slowdown
		xeno.recalculate_speed()
	button.icon_state = "template"

/datum/action/xeno_action/onclick/toggle_long_range/proc/on_zoom_in()
	return

/datum/action/xeno_action/onclick/toggle_long_range/proc/handle_mob_move_or_look(mob/living/carbon/xenomorph/xeno, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER
	movement_buffer--
	if(!actually_moving)
		return
	if(movement_buffer <= 0)
		movement_buffer = initial(movement_buffer)
		xeno.zoom_out() // will also handle icon_state
		UnregisterSignal(xeno, COMSIG_MOB_MOVE_OR_LOOK)

// General use acid spray, can be subtyped to customize behavior.
// ... or mutated at runtime by another action that retrieves and edits these values
// ... as they are all safely mutable. (Except possibly xeno_cooldown)
/datum/action/xeno_action/activable/spray_acid
	name = "Spray Acid"
	action_icon_state = "spray_acid"
	var/action_text = "spray acid"
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	action_type = XENO_ACTION_CLICK

	plasma_cost = 40
	xeno_cooldown = 8 SECONDS


	// Configurable options

	var/spray_type = ACID_SPRAY_LINE // Enum for the shape of spray to do
	var/spray_distance = 5 // Distance to spray
	var/spray_effect_type = /obj/effect/xenomorph/spray

	var/activation_delay = FALSE // Is there an activation delay?
	var/activation_delay_length = 0 // Only used if activation_delay is TRUE.


/datum/action/xeno_action/activable/transfer_plasma
	name = "Transfer Plasma"
	action_icon_state = "transfer_plasma"
	var/plasma_transfer_amount = 50
	var/transfer_delay = 20
	var/max_range = 2
	macro_path = /datum/action/xeno_action/verb/verb_transfer_plasma
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/activable/transfer_plasma/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.xeno_transfer_plasma(target, plasma_transfer_amount, transfer_delay, max_range)
	return ..()

/datum/action/xeno_action/onclick/xenohide
	name = "Hide"
	action_icon_state = "xenohide"
	plasma_cost = 0
	xeno_cooldown = 0.5 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_hide
	action_type = XENO_ACTION_CLICK
	listen_signal = COMSIG_KB_XENO_HIDE

/datum/action/xeno_action/onclick/xenohide/can_use_action()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno && !xeno.buckled && !xeno.is_mob_incapacitated())
		if(!(SEND_SIGNAL(xeno, COMSIG_LIVING_SHIMMY_LAYER) & COMSIG_LIVING_SHIMMY_LAYER_CANCEL))
			return TRUE

/// remove hide and apply modified attack cooldown
/datum/action/xeno_action/onclick/xenohide/proc/post_attack()
	var/mob/living/carbon/xenomorph/xeno = owner
	UnregisterSignal(xeno, COMSIG_MOB_STATCHANGE)
	if(xeno.layer == XENO_HIDING_LAYER)
		xeno.layer = initial(xeno.layer)
		button.icon_state = "template"
		xeno.update_wounds()
		xeno.update_layer()
	apply_cooldown(4) //2 second cooldown after attacking

/datum/action/xeno_action/onclick/xenohide/give_to(mob/living/living_mob)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.layer == XENO_HIDING_LAYER)
		button.icon_state = "template_active"

/datum/action/xeno_action/onclick/place_trap
	name = "Place resin hole (200)"
	action_icon_state = "place_trap"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_resin_hole
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2

/datum/action/xeno_action/activable/place_construction
	name = "Order Construction (400)"
	action_icon_state = "morph_resin"
	macro_path = /datum/action/xeno_action/verb/place_construction
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/activable/place_construction/not_primary //so it doesn't screw other macros up
	ability_primacy = XENO_NOT_PRIMARY_ACTION

/datum/action/xeno_action/activable/xeno_spit
	name = "Xeno Spit"
	action_icon_state = "xeno_spit"
	macro_path = /datum/action/xeno_action/verb/verb_xeno_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 2.5 SECONDS
	no_cooldown_msg = TRUE // Currently [14.6.25], every xeno that uses this save Boiler has a cooldown far too fast for messages to be worth it

	/// Var that keeps track of in-progress wind-up spits like Bombard to prevent spitting multiple spits at the same time
	var/spitting = FALSE
	var/sound_to_play = "acid_spit"
	var/aim_turf = FALSE

/datum/action/xeno_action/activable/xeno_spit/queen_macro //so it doesn't screw other macros up
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/bombard
	name = "Bombard"
	action_icon_state = "bombard"
	plasma_cost = 75
	macro_path = /datum/action/xeno_action/verb/verb_bombard
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 23 SECONDS

	// Range and other config
	var/effect_range = 3
	var/effect_type = /obj/effect/xenomorph/boiler_bombard
	var/activation_delay = 1.5 SECONDS
	var/range = 15
	var/interrupt_flags = INTERRUPT_ALL|BEHAVIOR_IMMOBILE

/datum/action/xeno_action/activable/tail_stab
	name = "Tail Stab"
	action_icon_state = "tail_attack"
	action_type = XENO_ACTION_CLICK
	charge_time = 1 SECONDS
	xeno_cooldown = 10 SECONDS
	ability_primacy = XENO_TAIL_STAB
	var/stab_range = 2
	/// Used for defender's tail 'stab'.
	var/blunt_stab = FALSE

/datum/action/xeno_action/onclick/evolve
	name = "Evolve"
	action_icon_state = "evolve"
	action_type = XENO_ACTION_CLICK
	listen_signal = COMSIG_KB_XENO_EVOLVE

/datum/action/xeno_action/onclick/evolve/action_activate()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.do_evolve()

/datum/action/xeno_action/onclick/evolve/can_use_action()
	if(!owner)
		return FALSE
	var/mob/living/carbon/xenomorph/xeno = owner
	// Perform check_state(TRUE) silently:
	if(xeno && !xeno.is_mob_incapacitated() || !xeno.buckled || !xeno.evolving && xeno.plasma_stored >= plasma_cost)
		return TRUE

/datum/action/xeno_action/onclick/transmute
	name = "Transmute"
	action_icon_state = "transmute"
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/onclick/transmute/action_activate()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.transmute_verb()

/datum/action/xeno_action/onclick/transmute/can_use_action()
	if(!owner)
		return FALSE
	var/mob/living/carbon/xenomorph/xeno = owner
	// Perform check_state(TRUE) silently:
	if(xeno && !xeno.is_mob_incapacitated() || !xeno.buckled || !xeno.evolving && xeno.plasma_stored >= plasma_cost)
		return TRUE


/datum/action/xeno_action/onclick/tacmap
	name = "View Tactical Map"
	action_icon_state = "toggle_queen_zoom"

	var/mob/living/carbon/xenomorph/queen/tracked_queen
	var/hivenumber

/datum/action/xeno_action/onclick/tacmap/Destroy()
	tracked_queen = null
	return ..()

/datum/action/xeno_action/onclick/tacmap/give_to(mob/living/carbon/xenomorph/xeno)
	. = ..()

	hivenumber = xeno.hive.hivenumber
	RegisterSignal(xeno.hive, COMSIG_HIVE_NEW_QUEEN, PROC_REF(handle_new_queen))
	RegisterSignal(xeno.hive, COMSIG_XENO_REVEAL_TACMAP, PROC_REF(handle_unhide_tacmap))

	if(!xeno.hive.living_xeno_queen && !xeno.hive.allow_no_queen_actions)
		hide_from(xeno)
		return

	if(!xeno.hive.living_xeno_queen?.ovipositor && !xeno.hive.tacmap_requires_queen_ovi)
		hide_from(xeno)

	handle_new_queen(new_queen = xeno.hive.living_xeno_queen)

/datum/action/xeno_action/onclick/tacmap/remove_from(mob/living/carbon/xenomorph/xeno)
	. = ..()
	UnregisterSignal(GLOB.hive_datum[hivenumber], COMSIG_HIVE_NEW_QUEEN)

/// handles the addition of a new queen, hiding if appropriate
/datum/action/xeno_action/onclick/tacmap/proc/handle_new_queen(datum/hive_status/hive, mob/living/carbon/xenomorph/queen/new_queen)
	SIGNAL_HANDLER

	if(tracked_queen)
		UnregisterSignal(tracked_queen, list(COMSIG_QUEEN_MOUNT_OVIPOSITOR, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR))

	tracked_queen = new_queen

	if(!tracked_queen?.ovipositor)
		hide_from(owner)

	RegisterSignal(tracked_queen, COMSIG_QUEEN_MOUNT_OVIPOSITOR, PROC_REF(handle_mount_ovipositor))
	RegisterSignal(tracked_queen, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, PROC_REF(handle_dismount_ovipositor))

/// deals with the queen mounting the ovipositor, unhiding the action from the user
/datum/action/xeno_action/onclick/tacmap/proc/handle_mount_ovipositor()
	SIGNAL_HANDLER

	unhide_from(owner)

/// deals with the queen dismounting the ovipositor, hiding the action from the user
/datum/action/xeno_action/onclick/tacmap/proc/handle_dismount_ovipositor()
	SIGNAL_HANDLER

	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.hive?.tacmap_requires_queen_ovi)
		hide_from(owner)

/datum/action/xeno_action/onclick/tacmap/proc/handle_unhide_tacmap()
	SIGNAL_HANDLER

	unhide_from(owner)

/datum/action/xeno_action/onclick/tacmap/can_use_action()
	if(!owner)
		return FALSE
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.is_mob_incapacitated() || xeno.dazed)
		return FALSE
	return TRUE

/datum/action/xeno_action/onclick/tacmap/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.xeno_tacmap()
	return ..()

/datum/action/xeno_action/active_toggle/toggle_meson_vision
	name = "Toggle Meson Vision"
	action_icon_state = "project_xeno"
	plasma_cost = 0
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/active_toggle/toggle_meson_vision/enable_toggle()
	. = ..()
	owner.sight |= SEE_TURFS

/datum/action/xeno_action/active_toggle/toggle_meson_vision/disable_toggle()
	. = ..()
	owner.sight &= ~SEE_TURFS

/mob/living/carbon/xenomorph/proc/add_abilities()
	if(!base_actions)
		return
	for(var/action_path in base_actions)
		give_action(src, action_path)


/datum/action/xeno_action/onclick/toggle_seethrough
	name = "Toggle Seethrough"
	action_icon_state = "xenohide"


/datum/action/xeno_action/onclick/toggle_seethrough/use_ability(atom/target)

	var/datum/component/seethrough_mob/seethroughComp = owner.GetComponent(/datum/component/seethrough_mob)
	. = ..()

	seethroughComp.toggle_active()
