//// Abilities used by multiple Xenos.
//// README
/*
	When I migrated abilities to these files c. 1/2020, I *tried* to mostly
	move the plasma cost and cooldown stuff to the new xeno_action format.
	however certain abilities (read: acid and resin-related) still deduct
	plasma internally. Bear that in mind. -4khan
*/

/mob/living/carbon/xenomorph/proc/set_selected_ability(datum/action/xeno_action/activable/ability)
	if(selected_ability)
		selected_ability.on_deselect(src)
	if(!ability)
		selected_ability = null
		client?.set_right_click_menu_mode(shift_only = FALSE)
		return
	selected_ability = ability
	selected_ability.on_select(src)
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

	/// In addition to the cooldown on building, you also get an increased cooldown after canceling that building or when interrupted.
	var/xeno_cooldown_interrupt_penalty = 1 SECONDS
	/// Something went wrong, for example, you can't build here
	var/xeno_cooldown_fail = 1
	/// Placement time increase modifier
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
	ability_uses_acid_overlay = TRUE

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

/**
 * Effects to apply before "thrown" xeno to choosen tile.
 */
/datum/action/xeno_action/activable/pounce/proc/start_airbone()
	return

/**
 * Effects to apply after xeno is "thrown" to choosen tile.
 */
/datum/action/xeno_action/activable/pounce/proc/end_airbone()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_POUNCE))
		REMOVE_TRAIT(xeno, TRAIT_ABILITY_POUNCE, TRAIT_SOURCE_ABILITY("pounce"))

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
	button.icon_state = "template_xeno"

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
	ability_uses_acid_overlay = TRUE

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
	if(xeno && !xeno.buckled && !xeno.is_mob_incapacitated() && !LAZYLEN(xeno.buckled_mobs))
		if(!(SEND_SIGNAL(xeno, COMSIG_LIVING_SHIMMY_LAYER) & COMSIG_LIVING_SHIMMY_LAYER_CANCEL))
			return TRUE

/// remove hide and apply modified attack cooldown
/datum/action/xeno_action/onclick/xenohide/proc/post_attack()
	var/mob/living/carbon/xenomorph/xeno = owner
	UnregisterSignal(xeno, COMSIG_MOB_STATCHANGE)
	if(xeno.layer == XENO_HIDING_LAYER)
		xeno.layer = initial(xeno.layer)
		button.icon_state = "template_xeno"
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
	ability_uses_acid_overlay = TRUE

	var/sound_to_play = "acid_spit"
	var/aim_turf = FALSE

/datum/action/xeno_action/activable/xeno_spit/queen_macro //so it doesn't screw other macros up
	ability_primacy = XENO_PRIMARY_ACTION_3

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
	xeno_cooldown = 5 SECONDS
	ability_primacy = XENO_BECOME_SEETHROUGH


/datum/action/xeno_action/onclick/toggle_seethrough/use_ability(atom/target)

	var/datum/component/seethrough_mob/seethroughComp = owner.GetComponent(/datum/component/seethrough_mob)
	. = ..()

	if(!action_cooldown_check())
		return


	seethroughComp.toggle_active()
	apply_cooldown()



/mob/living/carbon/xenomorph/proc/set_orders()
	set category = "Alien.Hivemind-Control"
	set name = "Set Hive Orders (50)"
	set desc = "Give some specific orders to the hive. They can see this on the status pane."

	if(!check_state())
		return
	if(last_special > world.time)
		return
	if(!check_plasma(50))
		return
	use_plasma(50)

	var/txt = strip_html(input("Set the hive's orders to what? Leave blank to clear it.", "Hive Orders",""))
	if(txt)
		xeno_message("<B>The Queen's will overwhelms your instincts...</B>", 3, hivenumber)
		xeno_message("<B>\""+txt+"\"</B>", 3, hivenumber)
		xeno_maptext(txt, "Hive Orders Updated", hivenumber)
		hive.hive_orders = txt
		log_hiveorder("[key_name(usr)] has set the Hive Order to: [txt]")
	else
		hive.hive_orders = ""

	last_special = world.time + 15 SECONDS

/mob/living/carbon/xenomorph/proc/hive_message()
	set category = "Alien.Hivemind"
	set name = "Word of the Queen (50)"
	set desc = "Send a message to all aliens in the hive that is big and visible."
	if(client.prefs.muted & MUTE_IC)
		to_chat(src, SPAN_DANGER("You cannot send Announcements (muted)."))
		return
	if(health <= 0)
		to_chat(src, SPAN_WARNING("You can't do that while unconscious."))
		return FALSE
	if(!check_plasma(50))
		return FALSE

	// Get a reference to the ability to utilize cooldowns
	var/datum/action/xeno_action/onclick/queen_word/word_ability = locate() in actions
	if(!word_ability?.action_cooldown_check())
		return FALSE
	if(word_ability.hidden)
		return FALSE

	var/input = tgui_input_text(src, "This message will be broadcast throughout the hive.", "Word of the Queen", multiline=TRUE)
	if(!input)
		return FALSE

	use_plasma(50)
	word_ability.apply_cooldown()

	xeno_announcement(input, hivenumber, "The words of the [name] reverberate in our head...")

	message_admins("[key_name_admin(src)] has created a Word of the Queen report:")
	log_admin("[key_name_admin(src)] Word of the Queen: [input]")
	return TRUE

/mob/living/carbon/xenomorph/proc/claw_toggle()
	set name = "Permit/Disallow Harming"
	set desc = "Allows you to permit the hive to harm/slash."
	set category = "Alien.Hivemind-Control"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	if(!hive)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		CRASH("[src] attempted to toggle slashing without a linked hive")

	if(hive.hive_flags_locked)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_TOGGLE_SLASH))
		to_chat(src, SPAN_WARNING("You must wait a bit before you can toggle this again."))
		return

	var/current_setting = null
	if(CHECK_MULTIPLE_BITFIELDS(hive.hive_flags, XENO_SLASH_ALLOW_ALL))
		current_setting = "Allowed"
	else if(!(hive.hive_flags & XENO_SLASH_INFECTED) && (hive.hive_flags & XENO_SLASH_NORMAL))
		current_setting = "Restricted - Infected Hosts"
	else if(!(hive.hive_flags & XENO_SLASH_ALLOW_ALL))
		current_setting = "Forbidden"

	var/choice = tgui_input_list(src, "Choose which level of harming hosts to permit to your hive.", "Harming", list("Forbidden", "Restricted - Infected Hosts", "Allowed"), theme="hive_status", default=current_setting)
	if(!choice)
		return

	if(choice == "Allowed")
		if(current_setting == choice)
			to_chat(src, SPAN_XENOWARNING("You already allow harming."))
			return
		to_chat(src, SPAN_XENONOTICE("You allow harming."))
		xeno_message(SPAN_XENOANNOUNCE("The Queen has <b>permitted</b> the harming of hosts! Go hog wild!"), hivenumber=hivenumber)
		hive.hive_flags |= XENO_SLASH_ALLOW_ALL
	else if(choice == "Restricted - Infected Hosts")
		if(current_setting == choice)
			to_chat(src, SPAN_XENOWARNING("You already forbid harming of infected hosts."))
			return
		to_chat(src, SPAN_XENONOTICE("You forbid harming of infected hosts."))
		xeno_message(SPAN_XENOANNOUNCE("The Queen has <b>restricted</b> the harming of hosts. You can no longer slash infected hosts."), hivenumber=hivenumber)
		hive.hive_flags &= ~XENO_SLASH_INFECTED
		hive.hive_flags |= XENO_SLASH_NORMAL
	else if(choice == "Forbidden")
		if(current_setting == choice)
			to_chat(src, SPAN_XENOWARNING("You already forbid harming entirely."))
			return
		to_chat(src, SPAN_XENONOTICE("You forbid harming entirely."))
		xeno_message(SPAN_XENOANNOUNCE("The Queen has <b>forbidden</b> the harming of hosts. You can no longer slash your enemies."), hivenumber=hivenumber)
		hive.hive_flags &= ~XENO_SLASH_ALLOW_ALL

	TIMER_COOLDOWN_START(src, COOLDOWN_TOGGLE_SLASH, 30 SECONDS)

/mob/living/carbon/xenomorph/proc/construction_toggle()
	set name = "Permit/Disallow Construction Placement"
	set desc = "Allows you to permit the hive to place construction nodes freely."
	set category = "Alien.Hivemind-Control"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	if(!hive)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		CRASH("[src] attempted to toggle construction without a linked hive")

	if(hive.hive_flags_locked)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_TOGGLE_CONSTRUCTION))
		to_chat(src, SPAN_WARNING("You must wait a bit before you can toggle this again."))
		return

	var/current_setting = null
	if(CHECK_MULTIPLE_BITFIELDS(hive.hive_flags, XENO_CONSTRUCTION_ALLOW_ALL))
		current_setting = "Anyone"
	else if(!(hive.hive_flags & XENO_CONSTRUCTION_NORMAL) && CHECK_MULTIPLE_BITFIELDS(hive.hive_flags, XENO_CONSTRUCTION_QUEEN|XENO_CONSTRUCTION_LEADERS))
		current_setting = "Leaders"
	else if(!(hive.hive_flags & (XENO_CONSTRUCTION_LEADERS|XENO_CONSTRUCTION_NORMAL)) && (hive.hive_flags & XENO_CONSTRUCTION_QUEEN))
		current_setting = "Queen"

	var/choice = tgui_input_list(src, "Choose which level of construction placement freedom to permit to your hive.", "Construction", list("Queen", "Leaders", "Anyone"), theme="hive_status", default=current_setting)
	if(!choice)
		return

	if(choice == "Anyone")
		if(current_setting == choice)
			to_chat(src, SPAN_XENOWARNING("You already allow construction placement to all builder castes."))
			return
		to_chat(src, SPAN_XENONOTICE("You allow construction placement to all builder castes."))
		xeno_message("The Queen has <b>permitted</b> the placement of construction nodes to all builder castes!", hivenumber=hivenumber)
		hive.hive_flags |= XENO_CONSTRUCTION_ALLOW_ALL
	else if(choice == "Leaders")
		if(current_setting == choice)
			to_chat(src, SPAN_XENOWARNING("You already restrict construction placement to leaders only."))
			return
		to_chat(src, SPAN_XENONOTICE("You restrict construction placement to leaders only."))
		xeno_message("The Queen has <b>restricted</b> the placement of construction nodes to leading builder castes only.", hivenumber=hivenumber)
		hive.hive_flags &= ~XENO_CONSTRUCTION_NORMAL
		hive.hive_flags |= XENO_CONSTRUCTION_QUEEN|XENO_CONSTRUCTION_LEADERS
	else if(choice == "Queen")
		if(current_setting == choice)
			to_chat(src, SPAN_XENOWARNING("You already forbid construction placement entirely."))
			return
		to_chat(src, SPAN_XENONOTICE("You forbid construction placement entirely."))
		xeno_message("The Queen has <b>forbidden</b> the placement of construction nodes to all but herself.", hivenumber=hivenumber)
		hive.hive_flags &= ~(XENO_CONSTRUCTION_LEADERS|XENO_CONSTRUCTION_NORMAL)
		hive.hive_flags |= XENO_CONSTRUCTION_QUEEN

	TIMER_COOLDOWN_START(src, COOLDOWN_TOGGLE_CONSTRUCTION, 30 SECONDS)

/mob/living/carbon/xenomorph/proc/destruction_toggle()
	set name = "Permit/Disallow Special Structure Destruction"
	set desc = "Allows you to permit the hive to destroy special structures freely."
	set category = "Alien.Hivemind-Control"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	if(!hive)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		CRASH("[src] attempted to toggle deconstruction without a linked hive")

	if(hive.hive_flags_locked)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_TOGGLE_DECONSTRUCTION))
		to_chat(src, SPAN_WARNING("You must wait a bit before you can toggle this again."))
		return

	var/current_setting = null
	if(CHECK_MULTIPLE_BITFIELDS(hive.hive_flags, XENO_DECONSTRUCTION_ALLOW_ALL))
		current_setting = "Anyone"
	else if(!(hive.hive_flags & XENO_DECONSTRUCTION_NORMAL) && CHECK_MULTIPLE_BITFIELDS(hive.hive_flags, XENO_DECONSTRUCTION_QUEEN|XENO_DECONSTRUCTION_LEADERS))
		current_setting = "Leaders"
	else if(!(hive.hive_flags & (XENO_DECONSTRUCTION_LEADERS|XENO_DECONSTRUCTION_NORMAL)) && (hive.hive_flags & XENO_DECONSTRUCTION_QUEEN))
		current_setting = "Queen"

	var/choice = tgui_input_list(src, "Choose which level of destruction freedom to permit to your hive.", "Deconstruction", list("Queen", "Leaders", "Anyone"), theme="hive_status", default=current_setting)
	if(!choice)
		return

	if(choice == "Anyone")
		if(current_setting == choice)
			to_chat(src, SPAN_XENOWARNING("You already allow special structure destruction to all builder castes and leaders."))
			return
		to_chat(src, SPAN_XENONOTICE("You allow special structure destruction to all builder castes and leaders."))
		xeno_message("The Queen has <b>permitted</b> the destruction of special structures to all builder castes and leaders!", hivenumber=hivenumber)
		hive.hive_flags |= XENO_DECONSTRUCTION_ALLOW_ALL
	else if(choice == "Leaders")
		if(current_setting == choice)
			to_chat(src, SPAN_XENOWARNING("You already restrict special structure destruction to leaders only."))
			return
		to_chat(src, SPAN_XENONOTICE("You restrict special structure destruction to leaders only."))
		xeno_message("The Queen has <b>restricted</b> the destruction of special structures to leaders only.", hivenumber=hivenumber)
		hive.hive_flags &= ~XENO_DECONSTRUCTION_NORMAL
		hive.hive_flags |= XENO_DECONSTRUCTION_QUEEN|XENO_DECONSTRUCTION_LEADERS
	else if(choice == "Queen")
		if(current_setting == choice)
			to_chat(src, SPAN_XENOWARNING("You already forbid special structure destruction entirely."))
			return
		to_chat(src, SPAN_XENONOTICE("You forbid special structure destruction entirely."))
		xeno_message("The Queen has <b>forbidden</b> the destruction of special structures to all but herself.", hivenumber=hivenumber)
		hive.hive_flags &= ~(XENO_DECONSTRUCTION_LEADERS|XENO_DECONSTRUCTION_NORMAL)
		hive.hive_flags |= XENO_DECONSTRUCTION_QUEEN

	TIMER_COOLDOWN_START(src, COOLDOWN_TOGGLE_DECONSTRUCTION, 30 SECONDS)

/mob/living/carbon/xenomorph/proc/unnesting_toggle()
	set name = "Permit/Disallow Unnesting"
	set desc = "Allows you to restrict unnesting to drones."
	set category = "Alien.Hivemind-Control"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that now."))

	if(!hive)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		CRASH("[src] attempted to toggle unnesting without a linked hive")

	if(hive.hive_flags_locked)
		to_chat(src, SPAN_WARNING("You can't do that now."))
		return

	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_TOGGLE_UNNESTING))
		to_chat(src, SPAN_WARNING("You must wait a bit before you can toggle this again."))
		return

	var/current_setting = null
	if(!(hive.hive_flags & XENO_UNNESTING_RESTRICTED))
		current_setting = "Anyone"
	else if(hive.hive_flags & XENO_UNNESTING_RESTRICTED)
		current_setting = "Drone castes"

	var/choice = tgui_input_list(src, "Choose which level of unnesting freedom to permit to your hive.", "Unnesting", list("Drone castes", "Anyone"), theme="hive_status", default=current_setting)
	if(!choice)
		return

	if(choice == "Anyone")
		if(!(hive.hive_flags & XENO_UNNESTING_RESTRICTED))
			to_chat(src, SPAN_XENOWARNING("You have already allowed everyone to unnest hosts."))
			return
		to_chat(src, SPAN_XENONOTICE("You have allowed everyone to unnest hosts."))
		xeno_message("The Queen has <b>allowed</b> everyone to unnest hosts.", hivenumber=hivenumber)
		hive.hive_flags &= ~XENO_UNNESTING_RESTRICTED
	else
		if(hive.hive_flags & XENO_UNNESTING_RESTRICTED)
			to_chat(src, SPAN_XENOWARNING("You have already forbidden anyone to unnest hosts, except for the drone caste."))
			return
		to_chat(src, SPAN_XENONOTICE("You have forbidden anyone to unnest hosts, except for the drone caste."))
		xeno_message("The Queen has <b>forbidden</b> anyone to unnest hosts, except for the drone caste.", hivenumber=hivenumber)
		hive.hive_flags |= XENO_UNNESTING_RESTRICTED

	TIMER_COOLDOWN_START(src, COOLDOWN_TOGGLE_UNNESTING, 30 SECONDS)
