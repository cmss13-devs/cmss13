// All xeno ability macros are handled here
// If you want to add a new one:
// Copy the plant weeds macro, change only the 'set name =', and add a macro_path var to the corresponding ability in Abilities.dm

/datum/action/xeno_action/verb/verb_pounce()
	set category = "Alien"
	set name = "Pounce"
	set hidden = TRUE
	var/action_name = "Pounce"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_plant_weeds()
	set category = "Alien"
	set name = "Plant Weeds"
	set hidden = TRUE
	var/action_name = "Plant Weeds (75)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_mark_resin()
	set category = "Alien"
	set name = "Mark Resin"
	set hidden = TRUE
	var/action_name = "Mark Resin"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_toggle_spit_type()
	set category = "Alien"
	set name = "Toggle Spit Type"
	set hidden = TRUE
	var/action_name = "Toggle Spit Type"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_release_haul()
	set category = "Alien"
	set name = "Release"
	set hidden = TRUE
	var/action_name = "Release"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_choose_resin_structure()
	set category = "Alien"
	set name = "Choose Resin Structure"
	set hidden = TRUE
	var/action_name = "Choose Resin Structure"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_secrete_resin()
	set category = "Alien"
	set name = "Secrete Resin"
	set hidden = TRUE
	var/action_name = "Secrete Resin (150)"
	if(ishivelord(src)) // >:( special snowflake caste
		action_name = "Secrete Resin (200)"
	handle_xeno_macro(src, action_name)

/* Resolve this line once structures are resolved.
/datum/action/xeno_action/verb/verb_morph_resin()
	set category = "Alien"
	set name = "Resin Morph"
	set hidden = TRUE
	var/action_name = "Resin Morph (125)"
	handle_xeno_macro(src, action_name)
*/

/datum/action/xeno_action/verb/verb_corrosive_acid()
	set category = "Alien"
	set name = "Corrosive Acid"
	set hidden = TRUE
	var/action_name = "Corrosive Acid (100)"

	var/mob/living/carbon/xenomorph/X = src // different levels of have different names
	switch(X.acid_level)
		if(1)
			action_name = "Corrosive Acid (75)"
		if(2)
			action_name = "Corrosive Acid (100)"
		if(3)
			action_name = "Corrosive Acid (125)"

	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_spray_acid()
	set category = "Alien"
	set name = "Spray Acid"
	set hidden = TRUE
	var/action_name = "Spray Acid"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_burrow()
	set category = "Alien"
	set name = "Burrow"
	set hidden = TRUE
	var/action_name = "Burrow"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_xeno_spit()
	set category = "Alien"
	set name = "Xeno Spit"
	set hidden = TRUE
	var/action_name = "Xeno Spit"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_hide()
	set category = "Alien"
	set name = "Hide"
	set hidden = TRUE
	var/action_name = "Hide"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_pheremones()
	set category = "Alien"
	set name = "Emit Pheromones"
	set hidden = TRUE
	var/action_name = "Emit Pheromones (30)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_transfer_plasma()
	set category = "Alien"
	set name = "Transfer Plasma"
	set hidden = TRUE
	var/action_name = "Transfer Plasma"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_toggle_long_range()
	set category = "Alien"
	set name = "Toggle Long-Range Sight"
	set hidden = TRUE
	var/action_name = "Toggle Long-Range Sight"
	if(isrunner(src))
		action_name = "Toggle Long-Range Sight (10)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_resin_hole()
	set category = "Alien"
	set name = "Place resin hole"
	set hidden = TRUE
	var/action_name = "Place resin hole (200)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_stomp()
	set category = "Alien"
	set name = "Stomp"
	set hidden = TRUE
	var/action_name = "Stomp (50)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_toggle_charge()
	set category = "Alien"
	set name = "Toggle Charging"
	set hidden = TRUE
	var/action_name = "Toggle Charging"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_resin_walker()
	set category = "Alien"
	set name = "Resin Walker"
	set hidden = TRUE
	var/action_name = "Resin Walker (50)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_dig_tunnel()
	set category = "Alien"
	set name = "Dig Tunnel"
	set hidden = TRUE
	var/action_name = "Dig Tunnel (200)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_screech()
	set category = "Alien"
	set name = "Screech"
	set hidden = TRUE
	var/action_name = "Screech (250)"
	handle_xeno_macro(src, action_name)


/datum/action/xeno_action/verb/verb_watch_xeno()
	set category = "Alien"
	set name = "Watch Xenomorph"
	set hidden = TRUE
	var/action_name = "Watch Xenomorph"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_heal_xeno()
	set category = "Alien"
	set name = "Heal Xenomorph"
	set hidden = TRUE
	var/action_name = "Heal Xenomorph (600)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/verb/verb_plasma_xeno()
	set category = "Alien"
	set name = "Give Plasma"
	set hidden = TRUE
	var/action_name = "Give Plasma (600)"
	handle_xeno_macro(src, action_name)

// night vision is special
/datum/action/xeno_action/verb/verb_night_vision()
	set category = "Alien"
	set name = "Toggle Nightvision"
	set hidden = TRUE
	var/mob/living/carbon/C = src
	for(var/atom/movable/screen/xenonightvision/B in C.client.screen)
		B.clicked(src)

/datum/action/xeno_action/verb/place_construction()
	set category = "Alien"
	set name = "Order Construction"
	set hidden = TRUE
	var/action_name = "Order Construction (400)"
	handle_xeno_macro(src, action_name)
