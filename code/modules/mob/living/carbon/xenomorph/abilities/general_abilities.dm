//// Abilities used by multiple Xenos.
//// README
/*
	When I migrated abilities to these files c. 1/2020, I *tried* to mostly
	move the plasma cost and cooldown stuff to the new xeno_action format.
	however certain abilities (read: acid and resin-related) still deduct
	plasma internally. Bear that in mind. -4khan
*/

/datum/action/xeno_action/onclick/plant_weeds
	name = "Plant Weeds (75)"
	ability_name = "Plant Weeds"
	action_icon_state = "plant_weeds"
	plasma_cost = 75
	macro_path = /datum/action/xeno_action/verb/verb_plant_weeds
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 10
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/plant_on_semiweedable = FALSE
	var/node_type = /obj/effect/alien/weeds/node

// Resting
/datum/action/xeno_action/onclick/xeno_resting
	name = "Rest"
	action_icon_state = "resting"
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/onclick/xeno_resting/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/xeno_resting/give_to(mob/living/living_mob)
	. = ..()
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(xeno.resting)
		button.icon_state = "template_active"

// Shift Spits
/datum/action/xeno_action/onclick/shift_spits
	name = "Toggle Spit Type"
	action_icon_state = "shift_spit_neurotoxin"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_toggle_spit_type
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2

/datum/action/xeno_action/onclick/shift_spits/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

// Regurgitate
/datum/action/xeno_action/onclick/regurgitate
	name = "Regurgitate"
	action_icon_state = "regurgitate"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_regurgitate
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
	ability_name = "secrete resin"
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

	var/mob/living/carbon/Xenomorph/X = owner
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
	ability_name = "mark resin"
	macro_path = /datum/action/xeno_action/verb/verb_mark_resin
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	xeno_cooldown = 10 SECONDS
	var/max_markers = 3

/datum/action/xeno_action/activable/info_marker/update_button_icon(var/datum/xeno_mark_define/x)
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
	ability_name = "corrosive acid"
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
			name = "Corrosive Acid (200)"
			acid_plasma_cost = 200
			acid_type = /obj/effect/xenomorph/acid/strong

/datum/action/xeno_action/activable/corrosive_acid/weak
	name = "Corrosive Acid (75)"
	acid_plasma_cost = 75
	level = 1
	acid_type = /obj/effect/xenomorph/acid/weak

/datum/action/xeno_action/activable/corrosive_acid/strong
	name = "Corrosive Acid (200)"
	acid_plasma_cost = 200
	level = 3
	acid_type = /obj/effect/xenomorph/acid/strong

/datum/action/xeno_action/onclick/emit_pheromones
	name = "Emit Pheromones (30)"
	action_icon_state = "emit_pheromones"
	plasma_cost = 30
	macro_path = /datum/action/xeno_action/verb/verb_pheremones
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/onclick/emit_pheromones/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated() && (!X.current_aura || X.plasma_stored >= plasma_cost))
		return TRUE

// Pounce
// Subtype this to customize behavior, or do it at runtime
/datum/action/xeno_action/activable/pounce
	name = "Pounce"
	action_icon_state = "pounce"
	ability_name = "pounce"
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 40
	plasma_cost = 10

	// Config options
	var/distance = 6					// 6 for runners, 4 for ravagers and praes

	var/knockdown = TRUE				// Should we knock down the target?
	var/knockdown_duration = 1			// 1 for runners, 3 for lurkers.
										// ONLY USED IF THE POUNCE KNOCKS DOWN

	var/slash = FALSE					// Do we slash upon reception?
	var/slash_bonus_damage = 0			// Any bonus damage to apply on the tackle slash, if applicable

	var/freeze_self = TRUE				// Should we freeze ourselves after the lunge?
	var/freeze_time = 5					// 5 for runners, 15 for lurkers
	var/freeze_timer_id = TIMER_ID_NULL	// Timer to cancel the end freeze if it can be cancelled earlier
	var/freeze_play_sound = TRUE

	var/windup = FALSE					// Is there a do_after before we pounce?
	var/windup_duration = 20			// How long to wind up, if applicable
	var/windup_interruptable = TRUE		// Can the windup be interrupted?

	var/can_be_shield_blocked = FALSE	// Some legacy stuff, self explanatory
	var/should_destroy_objects = FALSE  // Only used for ravager charge
	var/pounce_pass_flags // Pounce flags to customize what pounce can go over/through
	var/throw_speed = SPEED_FAST        // Throw speed
	var/tracks_target = TRUE					// Does it track the target atom?

	var/list/pounce_callbacks = null	// Specific callbacks to invoke when a pounce lands on an atom of a specific type
										// (note that if a collided atom does not match any of the key types, defaults to the appropriate X_launch_collision proc)

/datum/action/xeno_action/activable/pounce/New()
	. = ..()
	initialize_pounce_pass_flags()
	pounce_callbacks = list()
	pounce_callbacks[/mob] = DYNAMIC(/mob/living/carbon/Xenomorph/proc/pounced_mob_wrapper)
	pounce_callbacks[/obj] = DYNAMIC(/mob/living/carbon/Xenomorph/proc/pounced_obj_wrapper)
	pounce_callbacks[/turf] = DYNAMIC(/mob/living/carbon/Xenomorph/proc/pounced_turf_wrapper)

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

/datum/action/xeno_action/activable/pounce/proc/end_pounce_freeze()
	if(freeze_timer_id == TIMER_ID_NULL)
		return
	var/mob/living/carbon/Xenomorph/X = owner
	X.frozen = FALSE
	X.update_canmove()
	deltimer(freeze_timer_id)
	freeze_timer_id = TIMER_ID_NULL
	to_chat(X, SPAN_XENONOTICE("Slashing frenzies you! You feel free to move immediately!"))

/// Any effects to apply to the xenomorph before the windup occurs
/datum/action/xeno_action/activable/pounce/proc/pre_windup_effects()
	return

/// Any effects to apply to the xenomorph after the windup finishes (or is interrupted)
/datum/action/xeno_action/activable/pounce/proc/post_windup_effects(var/interrupted)
	SHOULD_CALL_PARENT(TRUE)
	owner.flags_atom &= ~DIRLOCK

/datum/action/xeno_action/onclick/toggle_long_range
	name = "Toggle Long-Range Sight"
	action_icon_state = "toggle_long_range"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_long_range
	action_type = XENO_ACTION_ACTIVATE
	var/should_delay = FALSE
	var/delay = 20
	var/handles_movement = TRUE
	var/movement_buffer = 0

/datum/action/xeno_action/onclick/toggle_long_range/can_use_action()
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(xeno && !xeno.is_mob_incapacitated() && !xeno.lying && !xeno.buckled)
		return TRUE

/datum/action/xeno_action/onclick/toggle_long_range/give_to(mob/living/living_mob)
	. = ..()
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(xeno.is_zoomed)
		button.icon_state = "template_active"

/datum/action/xeno_action/onclick/toggle_long_range/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(xeno.is_zoomed)
		xeno.zoom_out() // will also handle icon_state
		xeno.visible_message(SPAN_NOTICE("[xeno] stops looking off into the distance."), \
		SPAN_NOTICE("You stop looking off into the distance."), null, 5)
	else
		xeno.visible_message(SPAN_NOTICE("[xeno] starts looking off into the distance."), \
			SPAN_NOTICE("You start focusing your sight to look off into the distance."), null, 5)
		if (should_delay)
			if(!do_after(xeno, delay, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC)) return
		if(xeno.is_zoomed) return
		if(handles_movement)
			RegisterSignal(xeno, COMSIG_MOB_MOVE_OR_LOOK, .proc/handle_mob_move_or_look)
		xeno.zoom_in()
		button.icon_state = "template_active"

/datum/action/xeno_action/onclick/toggle_long_range/proc/handle_mob_move_or_look(mob/living/carbon/Xenomorph/mover, var/actually_moving, var/direction, var/specific_direction)
	SIGNAL_HANDLER

	if(!actually_moving)
		return

	movement_buffer--
	if(movement_buffer <= 0)
		movement_buffer = initial(movement_buffer)
		mover.zoom_out() // will also handle icon_state
		UnregisterSignal(mover, COMSIG_MOB_MOVE_OR_LOOK)

// General use acid spray, can be subtyped to customize behavior.
// ... or mutated at runtime by another action that retrieves and edits these values
// ... as they are all safely mutable. (Except possibly xeno_cooldown)
/datum/action/xeno_action/activable/spray_acid
	name = "Spray Acid"
	action_icon_state = "spray_acid"
	ability_name = "spray acid"
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	action_type = XENO_ACTION_CLICK

	plasma_cost = 40
	xeno_cooldown = 80


	// Configurable options

	var/spray_type = ACID_SPRAY_LINE	// Enum for the shape of spray to do
	var/spray_distance = 5 				// Distance to spray
	var/spray_effect_type = /obj/effect/xenomorph/spray

	var/activation_delay = FALSE		// Is there an activation delay?
	var/activation_delay_length = 0		// Only used if activation_delay is TRUE.


/datum/action/xeno_action/activable/transfer_plasma
	name = "Transfer Plasma"
	action_icon_state = "transfer_plasma"
	ability_name = "transfer plasma"
	var/plasma_transfer_amount = 50
	var/transfer_delay = 20
	var/max_range = 2
	macro_path = /datum/action/xeno_action/verb/verb_transfer_plasma
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/activable/transfer_plasma/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.xeno_transfer_plasma(A, plasma_transfer_amount, transfer_delay, max_range)
	..()

/datum/action/xeno_action/onclick/xenohide
	name = "Hide"
	action_icon_state = "xenohide"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_hide
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/onclick/xenohide/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/xenohide/give_to(mob/living/living_mob)
	. = ..()
	var/mob/living/carbon/Xenomorph/xeno = owner
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
	ability_name = "order construction"
	macro_path = /datum/action/xeno_action/verb/place_construction
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/activable/place_construction/queen_macro //so it doesn't screw other macros up
	ability_primacy = XENO_NOT_PRIMARY_ACTION

/datum/action/xeno_action/activable/xeno_spit
	name = "Xeno Spit"
	action_icon_state = "xeno_spit"
	ability_name = "xeno spit"
	macro_path = /datum/action/xeno_action/verb/verb_xeno_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	cooldown_message = "You feel your neurotoxin glands swell with ichor. You can spit again."
	xeno_cooldown = 60 SECONDS

/datum/action/xeno_action/activable/xeno_spit/queen_macro //so it doesn't screw other macros up
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/bombard
	name = "Bombard"
	ability_name = "bombard"
	action_icon_state = "bombard"
	plasma_cost = 75
	macro_path = /datum/action/xeno_action/verb/verb_bombard
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 245

	// Range and other config
	var/effect_range = 3
	var/effect_type = /obj/effect/xenomorph/boiler_bombard
	var/activation_delay = 1.5 SECONDS
	var/range = 15
	var/interrupt_flags = INTERRUPT_ALL|BEHAVIOR_IMMOBILE

/datum/action/xeno_action/activable/tail_stab
	name = "Tail Stab"
	action_icon_state = "tail_attack"
	ability_name = "tail stab"
	action_type = XENO_ACTION_CLICK
	charge_time = 1 SECONDS
	xeno_cooldown = 10 SECONDS
	ability_primacy = XENO_TAIL_STAB
	 /// Used for defender's tail 'stab'.
	var/blunt_stab = FALSE
