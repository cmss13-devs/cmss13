/datum/action/xeno_action/plant_weeds
	name = "Plant Weeds (75)"
	action_icon_state = "plant_weeds"
	plasma_cost = 75
	macro_path = /datum/action/xeno_action/verb/verb_plant_weeds
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/plant_weeds/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state()) return
	if(X.burrow) return

	var/turf/T = X.loc

	if(!istype(T))
		to_chat(X, SPAN_WARNING("You can't do that here."))
		return

	if(!T.is_weedable())
		to_chat(X, SPAN_WARNING("Bad place for a garden!"))
		return

	if(locate(/obj/effect/alien/weeds/node) in T)
		to_chat(X, SPAN_WARNING("There's a pod here already!"))
		return

	var/area/AR = get_area(T)

	if(!(AR.is_resin_allowed))
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	if(X.check_plasma(plasma_cost))
		X.use_plasma(plasma_cost)
		X.visible_message(SPAN_XENONOTICE("\The [X] regurgitates a pulsating node and plants it on the ground!"), \
		SPAN_XENONOTICE("You regurgitate a pulsating node and plant it on the ground!"), null, 5)
		new /obj/effect/alien/weeds/node(X.loc, src, X)
		playsound(X.loc, "alien_resin_build", 25)


// Resting
/datum/action/xeno_action/xeno_resting
	name = "Rest"
	action_icon_state = "resting"
	action_type = XENO_ACTION_CLICK

//resting action can be done even when lying down
/datum/action/xeno_action/xeno_resting/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner

	if(!X || X.is_mob_incapacitated(1) || X.buckled || X.fortify || X.crest_defense || X.burrow)
		return
	return 1

/datum/action/xeno_action/xeno_resting/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.is_mob_incapacitated(TRUE))
		return

	if(X.hardcore)
		to_chat(X, SPAN_WARNING("No time to rest, must KILL!"))
		return

	if(!X.resting)
		X.KnockDown(1) //so that the mob immediately falls over

	X.resting = !X.resting
	to_chat(X, SPAN_NOTICE(" You are now [X.resting ? "resting" : "getting up"]. "))


/datum/action/xeno_action/show_minimap
	name = "Show Minimap"
	action_icon_state = "agility_on"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_show_minimap
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/show_minimap/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	X.update_mapview(X.map_view, TRUE)

// Shift Spits
/datum/action/xeno_action/shift_spits
	name = "Toggle Spit Type"
	action_icon_state = "shift_spit_neurotoxin"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_toggle_spit_type
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/shift_spits/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/shift_spits/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state(1))
		return
	for(var/i in 1 to X.caste.spit_types.len)
		if(X.ammo == ammo_list[X.caste.spit_types[i]])
			if(i == X.caste.spit_types.len)
				X.ammo = ammo_list[X.caste.spit_types[1]]
			else
				X.ammo = ammo_list[X.caste.spit_types[i+1]]
			break
	to_chat(X, SPAN_NOTICE("You will now spit [X.ammo.name] ([X.ammo.spit_cost] plasma)."))
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, "shift_spit_[X.ammo.icon_state]")

// Regurgitate
/datum/action/xeno_action/regurgitate
	name = "Regurgitate"
	action_icon_state = "regurgitate"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_regurgitate
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/regurgitate/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_WARNING("You cannot regurgitate here."))
		return

	if(X.stomach_contents.len)
		for(var/mob/living/M in X.stomach_contents)
			X.regurgitate(M)

// Choose Resin
/datum/action/xeno_action/choose_resin
	name = "Choose Resin Structure"
	action_icon_state = "resin wall"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_choose_resin_structure
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/choose_resin/New()
	..()
	button.click_delay = 0

/datum/action/xeno_action/choose_resin/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return
	switch(X.selected_resin)
		if(RESIN_DOOR)
			X.selected_resin = RESIN_WALL
		if(RESIN_WALL)
			X.selected_resin = RESIN_MEMBRANE
		if(RESIN_MEMBRANE)
			X.selected_resin = RESIN_NEST
		if(RESIN_NEST)
			X.selected_resin = RESIN_STICKY
		if(RESIN_STICKY)
			X.selected_resin = RESIN_FAST
		if(RESIN_FAST)
			X.selected_resin = RESIN_DOOR
		else
			return //something went wrong

	to_chat(X, SPAN_NOTICE("You will now build <b>[X.resin2text(X.selected_resin)]\s</b> when secreting resin."))
	//update the button's overlay with new choice
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, X.resin2text(X.selected_resin))


// Secrete Resin
/datum/action/xeno_action/activable/secrete_resin
	name = "Secrete Resin (150)"
	action_icon_state = "secrete_resin"
	ability_name = "secrete resin"
	var/resin_plasma_cost = 150
	var/thick = FALSE
	var/make_message = TRUE
	macro_path = /datum/action/xeno_action/verb/verb_secrete_resin
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/secrete_resin/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	. = X.build_resin(A, resin_plasma_cost, thick, make_message)
	..()

/datum/action/xeno_action/activable/secrete_resin/hivelord
	name = "Secrete Resin (200)"
	resin_plasma_cost = 200
	thick = TRUE

// Corrosive Acid
/datum/action/xeno_action/activable/corrosive_acid
	name = "Corrosive Acid (100)"
	action_icon_state = "corrosive_acid"
	ability_name = "corrosive acid"
	var/acid_plasma_cost = 100
	var/level = 2 //level of the acid strength
	var/acid_type = /obj/effect/xenomorph/acid
	macro_path = /datum/action/xeno_action/verb/verb_corrosive_acid
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/corrosive_acid/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.corrosive_acid(A, acid_type, acid_plasma_cost)
	..()

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

/datum/action/xeno_action/activable/corrosive_acid/drone
	name = "Corrosive Acid (75)"
	acid_plasma_cost = 75
	level = 1
	acid_type = /obj/effect/xenomorph/acid/weak

/datum/action/xeno_action/activable/corrosive_acid/Boiler
	name = "Corrosive Acid (200)"
	acid_plasma_cost = 200
	level = 3
	acid_type = /obj/effect/xenomorph/acid/strong

/datum/action/xeno_action/activable/spray_acid
	name = "Spray Acid"
	action_icon_state = "spray_acid"
	ability_name = "spray acid"
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/spray_acid/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if(isXenoPraetorian(owner))
		X.acid_spray_cone(A)
		return

	X.acid_spray(A)
	..()

/datum/action/xeno_action/activable/spray_acid/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_acid_spray

// Warrior Agility
/datum/action/xeno_action/activable/toggle_agility
	name = "Toggle Agility"
	action_icon_state = "agility_on"
	ability_name = "toggle agility"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_agility

/datum/action/xeno_action/activable/toggle_agility/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/activable/toggle_agility/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	X.toggle_agility()

/datum/action/xeno_action/activable/toggle_agility/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_toggle_agility


// Warrior Lunge
/datum/action/xeno_action/activable/lunge
	name = "Lunge"
	action_icon_state = "lunge"
	ability_name = "lunge"
	macro_path = /datum/action/xeno_action/verb/verb_lunge
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/lunge/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.lunge(A)
	..()

/datum/action/xeno_action/activable/lunge/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_lunge


// Warrior Fling
/datum/action/xeno_action/activable/fling
	name = "Fling"
	action_icon_state = "fling"
	ability_name = "Fling"
	macro_path = /datum/action/xeno_action/verb/verb_fling
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/fling/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.fling(A)
	..()

/datum/action/xeno_action/activable/fling/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_fling


/datum/action/xeno_action/activable/punch
	name = "Punch"
	action_icon_state = "punch"
	ability_name = "punch"
	macro_path = /datum/action/xeno_action/verb/verb_punch
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/punch/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.punch(A)
	..()

/datum/action/xeno_action/activable/punch/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_punch

// Burrower Abilities
/datum/action/xeno_action/activable/burrow
	name = "Burrow"
	action_icon_state = "agility_on"
	ability_name = "burrow"
	macro_path = /datum/action/xeno_action/verb/verb_burrow
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/burrow/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.burrow)
		X.tunnel(get_turf(A))
	else
		X.burrow()
	..()

// Defender Headbutt
/datum/action/xeno_action/activable/headbutt
	name = "Headbutt"
	action_icon_state = "headbutt"
	ability_name = "headbutt"
	macro_path = /datum/action/xeno_action/verb/verb_headbutt
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/headbutt/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.headbutt(A)
	..()

/datum/action/xeno_action/activable/headbutt/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_headbutt


// Defender Tail Sweep
/datum/action/xeno_action/activable/tail_sweep
	name = "Tail Sweep"
	action_icon_state = "tail_sweep"
	ability_name = "tail sweep"
	macro_path = /datum/action/xeno_action/verb/verb_tail_sweep
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/tail_sweep/use_ability()
	var/mob/living/carbon/Xenomorph/X = owner
	X.tail_sweep()
	..()

/datum/action/xeno_action/activable/tail_sweep/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_tail_sweep

// Defender Toggle Crest Defense
/datum/action/xeno_action/activable/toggle_crest_defense
	name = "Toggle Crest Defense"
	action_icon_state = "crest_defense"
	ability_name = "toggle crest defense"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_crest
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/toggle_crest_defense/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	X.toggle_crest_defense()

/datum/action/xeno_action/activable/toggle_crest_defense/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_crest_defense


// Defender Fortify
/datum/action/xeno_action/activable/fortify
	name = "Fortify"
	action_icon_state = "fortify"
	ability_name = "fortify"
	macro_path = /datum/action/xeno_action/verb/verb_fortify
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/fortify/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	X.fortify()

/datum/action/xeno_action/activable/fortify/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_fortify


// Pounce
/datum/action/xeno_action/activable/pounce
	name = "Pounce"
	action_icon_state = "pounce"
	ability_name = "pounce"
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/pounce/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.Pounce(A)
	..()

/datum/action/xeno_action/activable/pounce/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_pounce

/datum/action/xeno_action/activable/xeno_spit
	name = "Xeno Spit"
	action_icon_state = "xeno_spit"
	ability_name = "xeno spit"
	macro_path = /datum/action/xeno_action/verb/verb_xeno_spit
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/xeno_spit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.xeno_spit(A)
	..()

/datum/action/xeno_action/activable/xeno_spit/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.has_spat < world.time) return TRUE

/datum/action/xeno_action/xenohide
	name = "Hide"
	action_icon_state = "xenohide"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_hide
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/xenohide/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/xenohide/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state(1))
		return
	if(X.layer != XENO_HIDING_LAYER)
		X.layer = XENO_HIDING_LAYER
		to_chat(X, SPAN_NOTICE("You are now hiding."))
	else
		X.layer = MOB_LAYER
		to_chat(X, SPAN_NOTICE("You have stopped hiding."))

/datum/action/xeno_action/emit_pheromones
	name = "Emit Pheromones (30)"
	action_icon_state = "emit_pheromones"
	plasma_cost = 30
	macro_path = /datum/action/xeno_action/verb/verb_pheremones
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/emit_pheromones/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated() && (!X.current_aura || X.plasma_stored >= plasma_cost))
		return TRUE

/datum/action/xeno_action/emit_pheromones/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state(1))
		return

	if(X.current_aura)
		X.current_aura = null
		X.visible_message(SPAN_XENOWARNING("\The [X] stops emitting pheromones."), \
		SPAN_XENOWARNING("You stop emitting pheromones."), null, 5)
	else
		if(!X.check_plasma(plasma_cost))
			return
		var/choice = input(X, "Choose a pheromone") in X.caste.aura_allowed + "help" + "cancel"
		if(choice == "help")
			to_chat(X, SPAN_NOTICE("<br>Pheromones provide a buff to all Xenos in range at the cost of some stored plasma every second, as follows:<br><B>Frenzy</B> - Increased run speed, damage and tackle chance.<br><B>Warding</B> - Increased armor, reduced incoming damage and critical bleedout.<br><B>Recovery</B> - Increased plasma and health regeneration.<br>"))
			return
		if(choice == "cancel" || X.current_aura || !X.check_state(1) || !X.check_plasma(plasma_cost)) //If they are stacking windows, disable all input
			return
		X.use_plasma(plasma_cost)
		X.current_aura = choice
		X.visible_message(SPAN_XENOWARNING("\The [X] begins to emit strange-smelling pheromones."), \
		SPAN_XENOWARNING("You begin to emit '[choice]' pheromones."), null, 5)
		playsound(X.loc, "alien_drool", 25)

	if(isXenoQueen(X) && X.hive.xeno_leader_list.len && X.anchored)
		for(var/mob/living/carbon/Xenomorph/L in X.hive.xeno_leader_list)
			L.handle_xeno_leader_pheromones()

/datum/action/xeno_action/activable/transfer_plasma
	name = "Transfer Plasma"
	action_icon_state = "transfer_plasma"
	ability_name = "transfer plasma"
	var/plasma_transfer_amount = 50
	var/transfer_delay = 20
	var/max_range = 2
	macro_path = /datum/action/xeno_action/verb/verb_transfer_plasma
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/transfer_plasma/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.xeno_transfer_plasma(A, plasma_transfer_amount, transfer_delay, max_range)
	..()

/datum/action/xeno_action/activable/transfer_plasma/hivelord
	plasma_transfer_amount = 200
	transfer_delay = 5
	max_range = 7

//Boiler abilities

/datum/action/xeno_action/toggle_long_range
	name = "Toggle Long Range Sight (20)"
	action_icon_state = "toggle_long_range"
	plasma_cost = 20
	macro_path = /datum/action/xeno_action/verb/verb_toggle_long_range
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/toggle_long_range/can_use_action()
	var/mob/living/carbon/Xenomorph/Boiler/X = owner
	if(X && !X.is_mob_incapacitated() && !X.lying && !X.buckled && (X.is_zoomed || X.plasma_stored >= plasma_cost))
		return TRUE

/datum/action/xeno_action/toggle_long_range/action_activate()
	var/mob/living/carbon/Xenomorph/Boiler/X = owner
	if(X.is_zoomed)
		X.zoom_out()
		X.visible_message(SPAN_NOTICE("[X] stops looking off into the distance."), \
		SPAN_NOTICE("You stop looking off into the distance."), null, 5)
	else
		X.visible_message(SPAN_NOTICE("[X] starts looking off into the distance."), \
			SPAN_NOTICE("You start focusing your sight to look off into the distance."), null, 5)
		if(!do_after(X, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC)) return
		if(X.is_zoomed) return
		X.zoom_in()
		..()

/datum/action/xeno_action/toggle_long_range/runner // Runner has reduced plasma cost
	name = "Toggle Long Range Sight (10)"
	plasma_cost = 10

/datum/action/xeno_action/toggle_bomb
	name = "Toggle Bombard Type"
	action_icon_state = "toggle_bomb0"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_toggle_bombard
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/toggle_bomb/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/toggle_bomb/action_activate()
	var/mob/living/carbon/Xenomorph/Boiler/X = owner
	var/activation_msg = "If you see this, something broke."
	if(X.mutation_type == BOILER_SHATTER)
		activation_msg = "You will now fire [X.ammo.type == /datum/ammo/xeno/boiler_gas/shatter ? "corrosive acid. This is lethal!" : "neurotoxic gas. This is nonlethal."]"
	else
		activation_msg = "You will now fire [X.ammo.type == /datum/ammo/xeno/boiler_gas ? "corrosive acid. This is lethal!" : "neurotoxic gas. This is nonlethal."]"
	to_chat(X, SPAN_NOTICE("[activation_msg]"))
	button.overlays.Cut()
	if(X.mutation_type == BOILER_SHATTER) // Shatter mutation special logic
		if(X.ammo.type == /datum/ammo/xeno/boiler_gas/shatter)
			X.ammo = ammo_list[/datum/ammo/xeno/boiler_gas/shatter/acid]
			button.overlays += image('icons/mob/hud/actions.dmi', button, "toggle_bomb1")
		else
			X.ammo = ammo_list[/datum/ammo/xeno/boiler_gas/shatter]
			button.overlays += image('icons/mob/hud/actions.dmi', button, "toggle_bomb0")
	else
		if(X.ammo.type == /datum/ammo/xeno/boiler_gas)
			X.ammo = ammo_list[/datum/ammo/xeno/boiler_gas/corrosive]
			button.overlays += image('icons/mob/hud/actions.dmi', button, "toggle_bomb1")
		else
			X.ammo = ammo_list[/datum/ammo/xeno/boiler_gas]
			button.overlays += image('icons/mob/hud/actions.dmi', button, "toggle_bomb0")

/datum/action/xeno_action/bombard
	name = "Bombard"
	action_icon_state = "bombard"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_bombard
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/bombard/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Boiler/X = owner
	return !X.bomb_cooldown

/datum/action/xeno_action/bombard/action_activate()
	var/mob/living/carbon/Xenomorph/Boiler/X = owner
	var/bombard_time = X.bombard_cooldown

	if(X.is_bombarding)
		if(X.client)
			X.client.mouse_pointer_icon = initial(X.client.mouse_pointer_icon) //Reset the mouse pointer.
		X.is_bombarding = 0
		to_chat(X, SPAN_NOTICE("You relax your stance."))
		return

	if(X.bomb_cooldown)
		to_chat(X, SPAN_WARNING("You are still preparing another spit. Be patient!"))
		return

	if(!isturf(X.loc))
		to_chat(X, SPAN_WARNING("You can't do that from there."))
		return

	if(bombard_time)
		X.visible_message(SPAN_NOTICE("\The [X] begins digging their claws into the ground."), \
			SPAN_NOTICE("You begin digging yourself into place."), null, 5)
	if(do_after(X, bombard_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		if(X.is_bombarding) return
		X.is_bombarding = 1
		X.visible_message(SPAN_NOTICE("\The [X] digs itself into the ground!"), \
		SPAN_NOTICE("You dig yourself into place! If you move, you must wait again to fire."), null, 5)
		X.bomb_turf = get_turf(X)
		if(X.client)
			X.client.mouse_pointer_icon = file("icons/mob/hud/mecha_mouse.dmi")
	else
		X.is_bombarding = 0
		if(X.client)
			X.client.mouse_pointer_icon = initial(X.client.mouse_pointer_icon)

//Carrier Abilities

/datum/action/xeno_action/activable/throw_hugger
	name = "Use/Throw Facehugger"
	action_icon_state = "throw_hugger"
	ability_name = "throw facehugger"
	macro_path = /datum/action/xeno_action/verb/verb_throw_facehugger
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/throw_hugger/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	X.throw_hugger(A)
	..()

/datum/action/xeno_action/activable/throw_hugger/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	return !X.threw_a_hugger

/datum/action/xeno_action/activable/retrieve_egg
	name = "Retrieve Egg"
	action_icon_state = "retrieve_egg"
	ability_name = "retrieve egg"
	macro_path = /datum/action/xeno_action/verb/verb_retrieve_egg
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/retrieve_egg/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	X.retrieve_egg(A)
	..()

/datum/action/xeno_action/place_trap
	name = "Place resin hole (200)"
	action_icon_state = "place_trap"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_resin_hole
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/place_trap/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state() || X.burrow)
		return
	if(!X.check_plasma(plasma_cost))
		return
	var/turf/T = get_turf(X)

	if(!istype(T) || !T.is_weedable() || !can_xeno_build(T))
		to_chat(X, SPAN_WARNING("You can't do that here."))
		return

	var/area/AR = get_area(T)

	if(istype(AR,/area/shuttle/drop1/lz1) || istype(AR,/area/shuttle/drop2/lz2))
		to_chat(X, SPAN_WARNING("You sense this is not a suitable area for creating a resin hole."))
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in T

	if(!alien_weeds)
		to_chat(X, SPAN_WARNING("You can only shape on weeds. Find some resin before you start building!"))
		return

	if(!X.check_alien_construction(T))
		return

	if(locate(/obj/effect/alien/resin/trap) in orange(1, T))
		to_chat(X, SPAN_XENOWARNING("This is too close to another resin hole!"))
		return

	X.use_plasma(plasma_cost)
	playsound(X.loc, "alien_resin_build", 25)
	new /obj/effect/alien/resin/trap(X.loc, X)
	to_chat(X, SPAN_XENONOTICE("You place a resin hole on the weeds, it still needs a sister to fill it with acid."))

//Crusher abilities
/datum/action/xeno_action/activable/stomp
	name = "Stomp (50)"
	action_icon_state = "stomp"
	ability_name = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_stomp
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/stomp/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Crusher/X = owner
	if(world.time >= X.has_screeched + CRUSHER_STOMP_COOLDOWN)
		return TRUE

/datum/action/xeno_action/activable/stomp/use_ability()
	var/mob/living/carbon/Xenomorph/Crusher/X = owner
	X.stomp()
	..()

/datum/action/xeno_action/ready_charge
	name = "Toggle Charging"
	action_icon_state = "ready_charge"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_toggle_charge
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/ready_charge/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/ready_charge/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state(1)) 
		return FALSE
	if(X.legcuffed)
		to_chat(src, SPAN_XENODANGER("You can't charge with that thing on your leg!"))
		X.is_charging = 0
	else
		X.is_charging = !X.is_charging
		var/will_charge = "[X.is_charging ? "now" : "no longer"]"
		to_chat(X, SPAN_XENONOTICE("You will [will_charge] charge when moving."))
		X.recalculate_move_delay = TRUE

/datum/action/xeno_action/activable/earthquake
	name = "Earthquake (100)"
	action_icon_state = "stomp"
	ability_name = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_earthquake
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/earthquake/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Crusher/X = owner
	if(world.time >= X.has_screeched + CRUSHER_STOMP_COOLDOWN)
		return TRUE

/datum/action/xeno_action/activable/earthquake/use_ability()
	var/mob/living/carbon/Xenomorph/Crusher/X = owner
	X.earthquake()
	..()

//Hivelord Abilities

/datum/action/xeno_action/toggle_speed
	name = "Resin Walker (50)"
	action_icon_state = "toggle_speed"
	plasma_cost = 50
	macro_path = /datum/action/xeno_action/verb/verb_resin_walker
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/toggle_speed/can_use_action()
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(X && !X.is_mob_incapacitated() && !X.lying && !X.buckled && (X.weedwalking_activated || X.plasma_stored >= plasma_cost))
		return TRUE

/datum/action/xeno_action/toggle_speed/action_activate()
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(!X.check_state())
		return

	X.recalculate_move_delay = TRUE

	if(X.weedwalking_activated)
		to_chat(X, SPAN_WARNING("You feel less in tune with the resin."))
		X.weedwalking_activated = 0
		return

	if(!X.check_plasma(plasma_cost))
		return
	X.weedwalking_activated = 1
	X.use_plasma(plasma_cost)
	to_chat(X, SPAN_NOTICE("You become one with the resin. You feel the urge to run!"))

/datum/action/xeno_action/build_tunnel
	name = "Dig Tunnel (200)"
	action_icon_state = "build_tunnel"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_dig_tunnel
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/build_tunnel/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.tunnel_delay) return FALSE
	return ..()

/datum/action/xeno_action/build_tunnel/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(X.action_busy)
		to_chat(X, SPAN_XENOWARNING("You should finish up what you're doing before digging."))
		return

	var/turf/T = X.loc
	if(!istype(T)) //logic
		to_chat(X, SPAN_XENOWARNING("You can't do that from there."))
		return

	if(!T.can_dig_xeno_tunnel())
		to_chat(X, SPAN_XENOWARNING("You scrape around, but you can't seem to dig through that kind of floor."))
		return

	if(locate(/obj/structure/tunnel) in X.loc)
		to_chat(X, SPAN_XENOWARNING("There already is a tunnel here."))
		return

	if(X.tunnel_delay)
		to_chat(X, SPAN_XENOWARNING("You are not ready to dig a tunnel again."))
		return

	if(X.get_active_hand())
		to_chat(X, SPAN_XENOWARNING("You need an empty claw for this!"))
		return

	if(!X.check_plasma(plasma_cost))
		return

	var/area/AR = get_area(T)

	if(!(AR.is_resin_allowed))
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	X.visible_message(SPAN_XENONOTICE("[X] begins digging out a tunnel entrance."), \
	SPAN_XENONOTICE("You begin digging out a tunnel entrance."), null, 5)
	if(!do_after(X, 100, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(X, SPAN_WARNING("Your tunnel caves in as you stop digging it."))
		return
	if(!X.check_plasma(plasma_cost))
		return
	X.visible_message(SPAN_XENONOTICE("\The [X] digs out a tunnel entrance."), \
	SPAN_XENONOTICE("You dig out an entrance to the tunnel network."), null, 5)
	X.start_dig = new /obj/structure/tunnel(T)
	X.tunnel_delay = 1
	spawn(2400)
		to_chat(X, SPAN_NOTICE("You are ready to dig a tunnel again."))
		X.tunnel_delay = 0
	var/msg = copytext(sanitize(input("Add a description to the tunnel:", "Tunnel Description") as text|null), 1, MAX_MESSAGE_LEN)
	if(msg)
		msg = "[msg] ([get_area_name(X.start_dig)])"
		msg_admin_niche("[X]/([key_name(X)]) has named a new tunnel \"[msg]\".")
		X.start_dig.tunnel_desc = "[msg]"

	X.use_plasma(plasma_cost)
	to_chat(X, SPAN_NOTICE("You will be ready to dig a new tunnel in 4 minutes."))
	playsound(X.loc, 'sound/weapons/pierce.ogg', 25, 1)


//Queen Abilities

/datum/action/xeno_action/grow_ovipositor
	name = "Grow Ovipositor (500)"
	action_icon_state = "grow_ovipositor"
	plasma_cost = 500

/datum/action/xeno_action/grow_ovipositor/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	var/turf/current_turf = get_turf(X)
	if(!current_turf || !istype(current_turf))
		return

	if(X.ovipositor_cooldown > world.time)
		to_chat(X, SPAN_XENOWARNING("You're still recovering from detaching your old ovipositor. Wait [round((X.ovipositor_cooldown-world.time)*0.1)] seconds"))
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf

	if(!alien_weeds)
		to_chat(X, SPAN_XENOWARNING("You need to be on resin to grow an ovipositor."))
		return

	if(!X.check_alien_construction(current_turf))
		return

	if(X.action_busy)
		return

	if(X.check_plasma(plasma_cost))
		X.visible_message(SPAN_XENOWARNING("\The [X] starts to grow an ovipositor."), \
		SPAN_XENOWARNING("You start to grow an ovipositor...(takes 20 seconds, hold still)"))
		if(!do_after(X, 200, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, numticks = 20) && X.check_plasma(plasma_cost))
			return
		if(!X.check_state()) return
		if(!locate(/obj/effect/alien/weeds) in current_turf)
			return
		X.use_plasma(plasma_cost)
		X.visible_message(SPAN_XENOWARNING("\The [X] has grown an ovipositor!"), \
		SPAN_XENOWARNING("You have grown an ovipositor!"))
		X.mount_ovipositor()

/datum/action/xeno_action/remove_eggsac
	name = "Remove Eggsac"
	action_icon_state = "grow_ovipositor"
	plasma_cost = 0

/datum/action/xeno_action/remove_eggsac/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	if(X.action_busy) return
	var/answer = alert(X, "Are you sure you want to remove your ovipositor? (5min cooldown to grow a new one)", , "Yes", "No")
	if(answer != "Yes")
		return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.visible_message(SPAN_XENOWARNING("\The [X] starts detaching itself from its ovipositor!"), \
		SPAN_XENOWARNING("You start detaching yourself from your ovipositor."))
	if(!do_after(X, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 10)) return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.dismount_ovipositor()

/datum/action/xeno_action/activable/screech
	name = "Screech (250)"
	action_icon_state = "screech"
	ability_name = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_screech
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/screech/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	return !X.has_screeched

/datum/action/xeno_action/activable/screech/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	X.queen_screech()
	..()

/datum/action/xeno_action/activable/gut
	name = "Gut (200)"
	action_icon_state = "gut"
	ability_name = "gut"
	macro_path = /datum/action/xeno_action/verb/verb_gut
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/gut/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	X.queen_gut(A)
	..()

/datum/action/xeno_action/psychic_whisper
	name = "Psychic Whisper"
	action_icon_state = "psychic_whisper"
	plasma_cost = 0

/datum/action/xeno_action/psychic_whisper/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	var/list/target_list = list()
	for(var/mob/living/possible_target in view(7, X))
		if(possible_target == X || !possible_target.client) continue
		target_list += possible_target

	var/mob/living/M = input("Target", "Send a Psychic Whisper to whom?") as null|anything in target_list
	if(!M) return

	if(!X.check_state())
		return

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(X)]->[M.key] : [msg]")
		to_chat(M, SPAN_XENO("You hear a strange, alien voice in your head. \"[msg]\""))
		to_chat(X, SPAN_XENONOTICE("You said: \"[msg]\" to [M]"))

/datum/action/xeno_action/toggle_queen_zoom
	name = "Toggle Queen Zoom"
	action_icon_state = "toggle_queen_zoom"
	plasma_cost = 0

/datum/action/xeno_action/toggle_queen_zoom/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.is_zoomed)
		X.zoom_out()
	else
		X.zoom_in()

/datum/action/xeno_action/set_xeno_lead
	name = "Choose/Follow Xenomorph Leaders"
	action_icon_state = "xeno_lead"
	plasma_cost = 0

/datum/action/xeno_action/set_xeno_lead/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	var/datum/hive_status/hive = X.hive
	if(X.observed_xeno)
		if(X.queen_ability_cooldown > world.time)
			to_chat(X, SPAN_XENOWARNING("You're still recovering from your last overwatch ability. Wait [round((X.queen_ability_cooldown-world.time)*0.1)] seconds."))
			return
		if(!hive.open_xeno_leader_positions.len && X.observed_xeno.hive_pos == NORMAL_XENO)
			to_chat(X, SPAN_XENOWARNING("You currently have [hive.xeno_leader_list.len] promoted leaders. You may not maintain additional leaders until your power grows."))
			return
		var/mob/living/carbon/Xenomorph/T = X.observed_xeno
		if(T == X)
			to_chat(X, SPAN_XENOWARNING("You cannot add yourself as a leader!"))
			return
		X.queen_ability_cooldown = world.time + 150 //15 seconds
		if(T.hive_pos == NORMAL_XENO)
			if(!hive.add_hive_leader(T))
				to_chat(X, SPAN_XENOWARNING("Unable to add the leader."))
				return
			to_chat(X, SPAN_XENONOTICE("You've selected [T] as a Hive Leader."))
			to_chat(T, SPAN_XENOANNOUNCE("[X] has selected you as a Hive Leader. The other Xenomorphs must listen to you. You will also act as a beacon for the Queen's pheromones."))
		else
			hive.remove_hive_leader(T)
			to_chat(X, SPAN_XENONOTICE("You've demoted [T] from Hive Leader."))
			to_chat(T, SPAN_XENOANNOUNCE("[X] has demoted you from Hive Leader. Your leadership rights and abilities have waned."))
	else
		var/list/possible_xenos = list()
		for(var/mob/living/carbon/Xenomorph/T in hive.xeno_leader_list)
			possible_xenos += T

		if(possible_xenos.len > 1)
			var/mob/living/carbon/Xenomorph/selected_xeno = input(X, "Target", "Watch which xenomorph leader?") as null|anything in possible_xenos
			if(!selected_xeno || selected_xeno.hive_pos == NORMAL_XENO || selected_xeno == X.observed_xeno || selected_xeno.stat == DEAD || selected_xeno.z != X.z || !X.check_state())
				return
			X.set_queen_overwatch(selected_xeno)
		else if(possible_xenos.len)
			X.set_queen_overwatch(possible_xenos[1])
		else
			to_chat(X, SPAN_XENOWARNING("There are no Xenomorph leaders. Overwatch a Xenomorph to make it a leader."))

/datum/action/xeno_action/queen_heal
	name = "Heal Xenomorph (600)"
	action_icon_state = "heal_xeno"
	plasma_cost = 600
	macro_path = /datum/action/xeno_action/verb/verb_heal_xeno
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/queen_heal/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.queen_ability_cooldown > world.time)
		to_chat(X, SPAN_XENOWARNING("You're still recovering from your last overwatch ability. Wait [round((X.queen_ability_cooldown-world.time)*0.1)] seconds."))
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/target = X.observed_xeno
		if(target.stat == DEAD || target.disposed)
			return
		if(X.loc.z != target.loc.z)
			to_chat(X, SPAN_XENOWARNING("They are too far away to do this."))
			return
		if(!target.caste.can_be_queen_healed)
			to_chat(X, SPAN_XENOWARNING("This caste cannot be healed!"))
			return
		if(target.stat != DEAD && (!target.caste || target.caste.fire_immune || !target.on_fire))
			if(target.health < target.maxHealth)
				if(X.check_plasma(plasma_cost))
					X.use_plasma(plasma_cost)
					target.gain_health(200)
					X.queen_ability_cooldown = world.time + 150 //15 seconds
					to_chat(X, SPAN_XENONOTICE("You channel your plasma to heal [target]'s wounds."))
					to_chat(target, SPAN_XENONOTICE("You feel a surge of energy rejuvenate you!"))
			else
				to_chat(X, SPAN_WARNING("[target] is at full health."))
		else
			to_chat(X, SPAN_WARNING("[target] cannot be healed!"))
	else
		to_chat(X, SPAN_WARNING("You must overwatch the xeno you want to give healing to."))

/datum/action/xeno_action/queen_give_plasma
	name = "Give Plasma (600)"
	action_icon_state = "queen_give_plasma"
	plasma_cost = 600
	macro_path = /datum/action/xeno_action/verb/verb_plasma_xeno
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/queen_give_plasma/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.queen_ability_cooldown > world.time)
		to_chat(X, SPAN_XENOWARNING("You're still recovering from your last overwatch ability. Wait [round((X.queen_ability_cooldown-world.time)*0.1)] seconds."))
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/target = X.observed_xeno
		if(!target.caste.can_be_queen_healed)
			to_chat(X, SPAN_XENOWARNING("This caste cannot be given plasma!"))
			return
		if(target.stat != DEAD)
			if(target.plasma_stored < target.plasma_max)
				if(X.check_plasma(plasma_cost))
					X.use_plasma(plasma_cost)
					target.gain_plasma(400)
					X.queen_ability_cooldown = world.time + 150 //15 seconds
					to_chat(X, SPAN_XENONOTICE("You transfer some plasma to [target]."))

			else

				to_chat(X, SPAN_WARNING("[target] is at full plasma."))
	else
		to_chat(X, SPAN_WARNING("You must overwatch the xeno you want to give plasma to."))

/datum/action/xeno_action/queen_order
	name = "Give Order (100)"
	action_icon_state = "queen_order"
	plasma_cost = 100

/datum/action/xeno_action/queen_order/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/target = X.observed_xeno
		if(target.stat != DEAD && target.client)
			if(X.check_plasma(plasma_cost))
				var/input = stripped_input(X, "This message will be sent to the overwatched xeno.", "Queen Order", "")
				if(!input)
					return
				var/queen_order = SPAN_XENOANNOUNCE("<b>[X]</b> reaches you:\"[input]\"")
				if(!X.check_state() || !X.check_plasma(plasma_cost) || X.observed_xeno != target || target.stat == DEAD)
					return
				if(target.client)
					X.use_plasma(plasma_cost)
					to_chat(target, "[queen_order]")
					message_admins("[key_name_admin(X)] has given the following Queen order to [target]: \"[input]\"", 1)

	else
		to_chat(X, SPAN_WARNING("You must overwatch the Xenomorph you want to give orders to."))

/datum/action/xeno_action/activable/place_construction
	name = "Order Construction (500)"
	action_icon_state = "morph_resin"
	ability_name = "order construction"
	macro_path = /datum/action/xeno_action/verb/place_construction
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/place_construction/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return FALSE

	//Make sure construction is unrestricted
	if(X.hive.construction_allowed == 1 && X.hive_pos == NORMAL_XENO)
		to_chat(X, SPAN_WARNING("Construction is currently restricted to Leaders only!"))
		return FALSE
	else if(X.hive.construction_allowed == 0 && !istype(X.caste, /datum/caste_datum/queen))
		to_chat(X, SPAN_WARNING("Construction is currently restricted to Queen only!"))
		return FALSE

	var/turf/T = get_turf(A)
	var/choice = XENO_STRUCTURE_CORE
	if(X.hive.has_structure(XENO_STRUCTURE_CORE))
		choice = input(X, "Choose a structure to build") in X.hive.hive_structure_types + "help" + "cancel"
	if(choice == "help")
		var/message = "<br>Placing a construction node creates a template for special structures that can benefit the hive, which require the insertion of [MATERIAL_CRYSTAL] to construct the following:<br>"
		for(var/structure_name in X.hive.hive_structure_types)
			message += "[get_xeno_structure_desc(structure_name)]<br>"
		to_chat(X, SPAN_NOTICE(message))
		return
	if(choice == "cancel" || !X.check_state(1) || !X.check_plasma(500))
		return FALSE
	if(!do_after(X, XENO_STRUCTURE_BUILD_TIME, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return FALSE
	if(!X.hive.can_build_structure(choice))
		to_chat(X, SPAN_WARNING("You can't build any more [choice]s for the hive."))
		return FALSE

	var/structure_type = X.hive.hive_structure_types[choice]
	var/area/current_area = get_area(T)
	var/datum/construction_template/xenomorph/structure_template = new structure_type()

	if(!X.hive.can_build_structure(structure_template.name))
		to_chat(X, SPAN_WARNING("You cannot build any more [structure_template.name]!"))
		qdel(structure_template)
		return FALSE

	if(isnull(T) || !current_area.can_build_special || !T.is_weedable())
		to_chat(X, SPAN_WARNING("You cannot build here!"))
		qdel(structure_template)
		return FALSE

	if(structure_template.requires_node)
		for(var/turf/TA in (range(T, 1)))
			if(TA.density || !X.check_alien_construction(TA))
				to_chat(X, SPAN_WARNING("You need more open space to build here."))
				qdel(structure_template)
				return FALSE
			var/obj/effect/alien/weeds/alien_weeds = locate() in T
			if(!alien_weeds || alien_weeds.weed_strength < WEED_LEVEL_HIVE)
				to_chat(X, SPAN_WARNING("You can only shape on hive weeds. Find a hive node or core before you start building!"))
				qdel(structure_template)
				return FALSE

	X.use_plasma(500)
	X.place_construction(T, structure_template)

/datum/action/xeno_action/deevolve
	name = "De-Evolve a Xenomorph"
	action_icon_state = "xeno_deevolve"
	plasma_cost = 500

/datum/action/xeno_action/deevolve/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/T = X.observed_xeno
		if(!X.check_plasma(plasma_cost)) return

		if(T.is_ventcrawling)
			to_chat(X, SPAN_XENOWARNING("[T] can't be deevolved here."))
			return

		if(!isturf(T.loc))
			to_chat(X, SPAN_XENOWARNING("[T] can't be deevolved here."))
			return

		if(T.health <= 0)
			to_chat(X, SPAN_XENOWARNING("[T] is too weak to be deevolved."))
			return

		if(!T.caste.deevolves_to)
			to_chat(X, SPAN_XENOWARNING("[T] can't be deevolved."))
			return

		var/newcaste = T.caste.deevolves_to
		if(newcaste == "Larva")
			to_chat(X, SPAN_XENOWARNING("You cannot deevolve xenomorphs to larva."))
			return

		var/confirm = alert(X, "Are you sure you want to deevolve [T] from [T.caste.caste_name] to [newcaste]?", , "Yes", "No")
		if(confirm == "No")
			return

		var/reason = stripped_input(X, "Provide a reason for deevolving this xenomorph, [T]")
		if(isnull(reason))
			to_chat(X, SPAN_XENOWARNING("You must provide a reason for deevolving [T]."))
			return

		if(!X.check_state() || !X.check_plasma(plasma_cost) || X.observed_xeno != T)
			return

		if(T.is_ventcrawling)
			return

		if(!isturf(T.loc))
			return

		if(T.health <= 0)
			return

		to_chat(T, SPAN_XENOWARNING("The queen is deevolving you for the following reason: [reason]"))

		var/xeno_type

		switch(newcaste)
			if("Runner")
				xeno_type = /mob/living/carbon/Xenomorph/Runner
			if("Drone")
				xeno_type = /mob/living/carbon/Xenomorph/Drone
			if("Sentinel")
				xeno_type = /mob/living/carbon/Xenomorph/Sentinel
			if("Spitter")
				xeno_type = /mob/living/carbon/Xenomorph/Spitter
			if("Lurker")
				xeno_type = /mob/living/carbon/Xenomorph/Lurker
			if("Warrior")
				xeno_type = /mob/living/carbon/Xenomorph/Warrior
			if("Defender")
				xeno_type = /mob/living/carbon/Xenomorph/Defender
			if("Burrower")
				xeno_type = /mob/living/carbon/Xenomorph/Burrower

		//From there, the new xeno exists, hopefully
		var/mob/living/carbon/Xenomorph/new_xeno = new xeno_type(get_turf(T), T)

		if(!istype(new_xeno))
			//Something went horribly wrong!
			to_chat(X, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
			if(new_xeno)
				qdel(new_xeno)
			return

		if(T.mind)
			T.mind.transfer_to(new_xeno)
		else
			new_xeno.key = T.key
			if(new_xeno.client)
				new_xeno.client.change_view(world.view)
				new_xeno.client.pixel_x = 0
				new_xeno.client.pixel_y = 0

		//Regenerate the new mob's name now that our player is inside
		new_xeno.generate_name()

		// If the player has self-deevolved before, don't allow them to do it again
		if(!(/mob/living/carbon/Xenomorph/verb/Deevolve in T.verbs))
			new_xeno.verbs -= /mob/living/carbon/Xenomorph/verb/Deevolve

		new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_name] emerges from the husk of \the [T]."), \
		SPAN_XENODANGER("[X] makes you regress into your previous form."))

		if(X.hive.living_xeno_queen && X.hive.living_xeno_queen.observed_xeno == T)
			X.hive.living_xeno_queen.set_queen_overwatch(new_xeno)

		INVOKE_ASYNC(new_xeno, /mob/living/carbon/Xenomorph.proc/upgrade_xeno, min(T.upgrade+1,3)) //a young Crusher de-evolves into a MATURE Hunter

		message_admins("[key_name_admin(X)] has deevolved [key_name_admin(T)]. Reason: [reason]")

		if(round_statistics && !new_xeno.statistic_exempt)
			round_statistics.track_new_participant(T.faction, -1) //so an evolved xeno doesn't count as two.
		qdel(T)
		X.use_plasma(plasma_cost)

	else
		to_chat(X, SPAN_WARNING("You must overwatch the xeno you want to de-evolve."))


//Ravager strain
/datum/action/xeno_action/activable/empower
	name = "Empower (100)"
	action_icon_state = "empower"
	ability_name = "empower"
	macro_path = /datum/action/xeno_action/verb/verb_empower
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/empower/use_ability()
	var/mob/living/carbon/Xenomorph/X = owner
	X.empower()
	..()

/datum/action/xeno_action/activable/empower/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	return !X.used_lunge

//Ravenger

/datum/action/xeno_action/activable/breathe_fire
	name = "Breathe Fire"
	action_icon_state = "breathe_fire"
	ability_name = "breathe fire"

/datum/action/xeno_action/activable/breathe_fire/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Ravager/ravenger/X = owner
	X.breathe_fire(A)
	..()

/datum/action/xeno_action/activable/breathe_fire/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Ravager/ravenger/X = owner
	if(world.time > X.used_fire_breath + 75) return TRUE

//Xenoborg abilities

/datum/action/xeno_action/activable/fire_cannon
	name = "Fire Cannon (5)"
	action_icon_state = "fire_cannon"
	ability_name = "fire cannon"

/datum/action/xeno_action/activable/fire_cannon/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Xenoborg/X = owner
	X.fire_cannon(A)
	..()


// Praetorian strain abilities

/datum/action/xeno_action/activable/prae_spray_acid
	name = "Spray Acid"
	action_icon_state = "spray_acid"
	ability_name = "spray acid"
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	action_type = XENO_ACTION_CLICK

#define PRAE_SPRAY_CONE 0
#define PRAE_SPRAY_LINE 1

/datum/action/xeno_action/activable/prae_spray_acid/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	switch (!!(X.prae_status_flags & PRAE_ROYALGUARD_ACIDSPRAY_TYPE)) // 0 -> Cone; 1 -> Line
		if(PRAE_SPRAY_CONE)
			X.acid_spray_cone(A)
		if(PRAE_SPRAY_LINE)
			X.acid_spray(A)
		else
			log_admin("[src] tried to acid spray with an invalid bitflag set. Tell the devs! Code: PRAE_ACID_00")
			log_debug("[src] tried to acid spray with an invalid bitflag set. Code: PRAE_ACID_00")
	..()

#undef PRAE_SPRAY_CONE
#undef PRAE_SPRAY_LINE

/datum/action/xeno_action/activable/prae_spray_acid/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_acid_spray

/datum/action/xeno_action/prae_switch_spray_type
	name = "Toggle acid spray type"
	action_icon_state = "acid_spray_cone"
	macro_path = /datum/action/xeno_action/verb/verb_prae_switch_spit_types
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/prae_switch_spray_type/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/prae_switch_spray_type/action_activate()

	var/mob/living/carbon/Xenomorph/X = owner
	var/action_icon_result

	if(!X.check_state(1))
		return

	if(!(X.prae_status_flags & PRAE_ROYALGUARD_ACIDSPRAY_TYPE)) // 0 = cone, 1 = line
		action_icon_result = "acid_spray_line"
		to_chat(X, SPAN_WARNING("You will now spray a line of acid with your acid spray."))
	else
		action_icon_result = "acid_spray_cone"
		to_chat(X, SPAN_WARNING("You will now spray a cone of acid with your acid spray."))

	X.prae_status_flags = X.prae_status_flags^(PRAE_ROYALGUARD_ACIDSPRAY_TYPE) // flip the bit

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_result)

/datum/action/xeno_action/activable/prae_screech
	name = "Screech (300)"
	action_icon_state = "screech"
	ability_name = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_prae_screech
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/prae_screech/use_ability()
	var/mob/living/carbon/Xenomorph/X = owner
	X.praetorian_screech()
	..()

/datum/action/xeno_action/activable/prae_screech/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.has_screeched

// End Prae strain abilities

/////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/carbon/Xenomorph/proc/add_abilities()
	if(actions && actions.len)
		for(var/action_path in actions)
			if(ispath(action_path))
				actions -= action_path
				var/datum/action/xeno_action/A = new action_path()
				A.give_action(src)

// Banished xenos can be attacked by all other xenos, even ones in the same hive
/datum/action/xeno_action/banish
	name = "Banish a Xenomorph"
	action_icon_state = "xeno_banish"
	plasma_cost = 500

/datum/action/xeno_action/banish/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/T = X.observed_xeno

		if(T.banished)
			to_chat(X, SPAN_XENOWARNING("This xenomorph is already banished!"))
			return

		// No banishing critted xenos
		if(T.health < 0)
			to_chat(X, SPAN_XENOWARNING("What's the point? They're already about to die."))
			return

		var/confirm = alert(X, "Are you sure you want to banish [T] from the hive? This should only be done with good reason.", , "Yes", "No")
		if(confirm == "No")
			return

		var/reason = stripped_input(X, "Provide a reason for banishing [T]. This will be announced to the entire hive!")
		if(isnull(reason))
			to_chat(X, SPAN_XENOWARNING("You must provide a reason for banishing [T]."))
			return

		if(!X.check_state() || !X.check_plasma(plasma_cost) || X.observed_xeno != T || T.health < 0)
			return

		// Let everyone know they were banished
		xeno_announcement("By [X]'s will, [T] has been banished from the hive!\n\n[reason]", X.hivenumber, title=SPAN_ANNOUNCEMENT_HEADER_BLUE("Banishment"))
		to_chat(T, FONT_SIZE_LARGE(SPAN_XENOWARNING("The [X] has banished you from the hive! Other xenomorphs may now attack you freely, but your link to the hivemind remains, preventing you from harming other sisters.")))

		T.banished = TRUE
		T.hud_update_banished()

		message_admins("[key_name_admin(X)] has banished [key_name_admin(T)]. Reason: [reason]")

	else
		to_chat(X, SPAN_WARNING("You must overwatch the xeno you want to banish."))

// Readmission = un-banish
/datum/action/xeno_action/readmit
	name = "Readmit a Xenomorph"
	action_icon_state = "xeno_readmit"
	plasma_cost = 100

/datum/action/xeno_action/readmit/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/T = X.observed_xeno

		if(!T.banished)
			to_chat(X, SPAN_XENOWARNING("This xenomorph isn't banished!"))
			return

		var/confirm = alert(X, "Are you sure you want to readmit [T] into the hive?", , "Yes", "No")
		if(confirm == "No")
			return

		if(!X.check_state() || !X.check_plasma(plasma_cost) || X.observed_xeno != T)
			return

		to_chat(T, FONT_SIZE_LARGE(SPAN_XENOWARNING("The [X] has readmitted you into the hive.")))
		T.banished = FALSE
		T.hud_update_banished()
	else
		to_chat(X, SPAN_WARNING("You must overwatch the xeno you want to readmit."))
