// All xeno ability macros are handled here
// If you want to add a new one:
// Copy the plant weeds macro, change only the 'set name =', and add a macro_path var to the corresponding ability in Abilities.dm


/proc/handle_xeno_macro(var/mob/living/carbon/Xenomorph/X, var/action_name)
	for(var/datum/action/xeno_action/A in X.actions)
		if(A.name == action_name)
			switch (A.action_type)
			
				// "Old" behavior: select the action.
				if (XENO_ACTION_CLICK) // This should be used for all actions that require an atom handed in by click() to function
					handle_xeno_macro_click(X, A)

				if (XENO_ACTION_ACTIVATE) // Actions that don't require a click() atom to work
					handle_xeno_macro_activate(X, A)

				if (XENO_ACTION_QUEUE)
					handle_xeno_macro_actionqueue(X, A)

				else
					log_debug("Xeno action [action_name] is misconfigured. Code: XENO_ACTION_MACRO_1")
					log_admin("Xeno action [action_name] is misconfigured. Tell the devs. Code: XENO_ACTION_MACRO_1")
			
			return 

/proc/handle_xeno_macro_click(var/mob/living/carbon/Xenomorph/X, var/datum/action/xeno_action/A)
	A.button.clicked(X)
	return

/proc/handle_xeno_macro_activate(var/mob/living/carbon/Xenomorph/X, var/datum/action/xeno_action/A)
	
	var/datum/action/xeno_action/activable/activableA = A

	if (!istype(A))
		return
	
	if (activableA.can_use_action() && activableA.action_cooldown_check())
		activableA.use_ability()

// Queue an action for the next click. This will always work but should only be used for actions that actually NEED an atom to work
// Other ones should just use the activate proc
/proc/handle_xeno_macro_actionqueue(var/mob/living/carbon/Xenomorph/X, var/datum/action/xeno_action/activable/A)
	if (!istype(A))
		return
	
	X.queued_action = A
	to_chat(X, SPAN_WARNING("Your next click will use [A.name]!"))
	
	if(X.client)
		X.client.mouse_pointer_icon = file("icons/mob/hud/mecha_mouse.dmi")


/datum/action/xeno_action/verb/verb_plant_weeds()
	set category = "Alien"
	set name = "Plant Weeds"
	set hidden = 1
	var/action_name = "Plant Weeds (75)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_show_minimap()
	set category = "Alien"
	set name = "Show Minimap"
	set hidden = 1
	var/action_name = "Show Minimap"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_toggle_spit_type()
	set category = "Alien"
	set name = "Toggle Spit Type"
	set hidden = 1
	var/action_name = "Toggle Spit Type"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_regurgitate()
	set category = "Alien"
	set name = "Regurgitate"
	set hidden = 1
	var/action_name = "Regurgitate"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_choose_resin_structure()
	set category = "Alien"
	set name = "Choose Resin Structure"
	set hidden = 1
	var/action_name = "Choose Resin Structure"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_secrete_resin()
	set category = "Alien"
	set name = "Secrete Resin"
	set hidden = 1
	var/action_name = "Secrete Resin (150)"
	if(isXenoHivelord(src)) // >:( special snowflake caste
		action_name = "Secrete Resin (200)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_corrosive_acid()
	set category = "Alien"
	set name = "Corrosive Acid"
	set hidden = 1
	var/action_name = "Corrosive Acid (100)"

	var/mob/living/carbon/Xenomorph/X = src // different levels of have different names
	switch(X.acid_level)
		if(1)
			action_name = "Corrosive Acid (75)"
		if(2)
			action_name = "Corrosive Acid (100)"
		if(3)
			action_name = "Corrosive Acid (200)"

	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_spray_acid()
	set category = "Alien"
	set name = "Spray Acid"
	set hidden = 1
	var/action_name = "Spray Acid"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_toggle_agility()
	set category = "Alien"
	set name = "Toggle Agility"
	set hidden = 1
	var/action_name = "Toggle Agility"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_lunge()
	set category = "Alien"
	set name = "Lunge"
	set hidden = 1
	var/action_name = "Lunge"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_fling()
	set category = "Alien"
	set name = "Fling"
	set hidden = 1
	var/action_name = "Fling"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_punch()
	set category = "Alien"
	set name = "Punch"
	set hidden = 1
	var/action_name = "Punch"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_burrow()
	set category = "Alien"
	set name = "Burrow"
	set hidden = 1
	var/action_name = "Burrow"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_headbutt()
	set category = "Alien"
	set name = "Headbutt"
	set hidden = 1
	var/action_name = "Headbutt"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_tail_sweep()
	set category = "Alien"
	set name = "Tail Sweep"
	set hidden = 1
	var/action_name = "Tail Sweep"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_toggle_crest()
	set category = "Alien"
	set name = "Toggle Crest Defense"
	set hidden = 1
	var/action_name = "Toggle Crest Defense"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_fortify()
	set category = "Alien"
	set name = "Fortify"
	set hidden = 1
	var/action_name = "Fortify"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_pounce()
	set category = "Alien"
	set name = "Pounce"
	set hidden = 1
	var/action_name = "Pounce"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_xeno_spit()
	set category = "Alien"
	set name = "Xeno Spit"
	set hidden = 1
	var/action_name = "Xeno Spit"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_hide()
	set category = "Alien"
	set name = "Hide"
	set hidden = 1
	var/action_name = "Hide"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_pheremones()
	set category = "Alien"
	set name = "Emit Pheromones"
	set hidden = 1
	var/action_name = "Emit Pheromones (30)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_transfer_plasma()
	set category = "Alien"
	set name = "Transfer Plasma"
	set hidden = 1
	var/action_name = "Transfer Plasma"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_toggle_long_range()
	set category = "Alien"
	set name = "Toggle Long Range Sight"
	set hidden = 1
	var/action_name = "Toggle Long Range Sight (20)"
	if(isXenoRunner(src))
		action_name = "Toggle Long Range Sight (10)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_toggle_bombard()
	set category = "Alien"
	set name = "Toggle Bombard Type"
	set hidden = 1
	var/action_name = "Toggle Bombard Type"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_bombard()
	set category = "Alien"
	set name = "Bombard"
	set hidden = 1
	var/action_name = "Bombard"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_throw_facehugger()
	set category = "Alien"
	set name = "Throw Facehugger"
	set hidden = 1
	var/action_name = "Use/Throw Facehugger"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_retrieve_egg()
	set category = "Alien"
	set name = "Retrieve Egg"
	set hidden = 1
	var/action_name = "Retrieve Egg"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_resin_hole()
	set category = "Alien"
	set name = "Place resin hole"
	set hidden = 1
	var/action_name = "Place resin hole (200)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_stomp()
	set category = "Alien"
	set name = "Stomp"
	set hidden = 1
	var/action_name = "Stomp (50)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_toggle_charge()
	set category = "Alien"
	set name = "Toggle Charging"
	set hidden = 1
	var/action_name = "Toggle Charging"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_earthquake()
	set category = "Alien"
	set name = "Earthquake"
	set hidden = 1
	var/action_name = "Earthquake (100)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_resin_walker()
	set category = "Alien"
	set name = "Resin Walker"
	set hidden = 1
	var/action_name = "Resin Walker (50)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_dig_tunnel()
	set category = "Alien"
	set name = "Dig Tunnel"
	set hidden = 1
	var/action_name = "Dig Tunnel (200)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_screech()
	set category = "Alien"
	set name = "Screech"
	set hidden = 1
	var/action_name = "Screech (250)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_gut()
	set category = "Alien"
	set name = "Gut"
	set hidden = 1
	var/action_name = "Gut (200)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_watch_xeno()
	set category = "Alien"
	set name = "Watch Xenomorph"
	set hidden = 1
	var/action_name = "Watch Xenomorph"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_heal_xeno()
	set category = "Alien"
	set name = "Heal Xenomorph"
	set hidden = 1
	var/action_name = "Heal Xenomorph (600)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_plasma_xeno()
	set category = "Alien"
	set name = "Give Plasma"
	set hidden = 1
	var/action_name = "Give Plasma (600)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_empower()
	set category = "Alien"
	set name = "Empower"
	set hidden = 1
	var/action_name = "Empower (100)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/place_construction()
	set category = "Alien"
	set name = "Order Construction"
	set hidden = 1
	var/action_name = "Order Construction (500)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/choose_construction()
	set category = "Alien"
	set name = "Select Construction Type"
	set hidden = 1
	var/action_name = "Select Construction Type"
	handle_xeno_macro(src, action_name)

// night vision is special
/datum/action/xeno_action/verb/verb_night_vision()
	set category = "Alien"
	set name = "Toggle Nightvision"
	set hidden = 1
	var/mob/living/carbon/C = src
	for(var/obj/screen/xenonightvision/B in C.client.screen)
		B.clicked(src)

// Appreciate the fact for a moment, future coder, that if you're adding a new macro for a new ability, you're only adding one. Not 45.


// Praetorian stuff
// Praetorian macro list:
//  Screech: Praetorian-Screech
//  Dance: Praetorian-Dance
//  Tail Attack: Praetorian-Tail-Attack
//  Shift Tail Attack: Praetorian-Shift-Tail-Attack
//  Shift Spray types: Praetorian-Switch-Spray-Types
//  Punch: Praetorian-Punch
//  Oppressor bomb: Praetorian-Bomb

/datum/action/xeno_action/verb/verb_prae_screech()
	set category = "Alien"
	set name = "Praetorian Screech"
	set hidden = 1
	var/action_name = "Screech (300)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_prae_switch_spit_types()
	set category = "Alien"
	set name = "Praetorian Switch Spray Types"
	set hidden = 1
	var/action_name = "Toggle acid spray type"
	handle_xeno_macro(src, action_name) 
