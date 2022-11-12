/obj/structure/interior_viewport
	name = "External Cameras Terminal"
	desc = "A small terminal connected to the external cameras of a vehicle, allowing a 360-degree visual survey of vehicle surroundings."
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "viewport"
	layer = INTERIOR_DOOR_LAYER

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	// The vehicle this viewport is tied to
	var/obj/vehicle/multitile/vehicle = null

	var/viewport_view_buff = 8

/obj/structure/interior_viewport/ex_act()
	return

/obj/structure/interior_viewport/attack_hand(var/mob/M)
	if(!vehicle || !ishuman(M))
		return

	start_use_for(M)

/obj/structure/interior_viewport/proc/start_use_for(var/mob/living/carbon/human/M)
	M.set_interaction(vehicle)
	M.reset_view(vehicle)
	M.client.change_view(viewport_view_buff, vehicle)
	to_chat(M, SPAN_NOTICE("You look into \the [src]'s screen, viewing the vehicle surroundings."))

	give_action(M, /datum/action/human_action/vehicle_unbuckle)

	RegisterSignal(M, COMSIG_MOVABLE_MOVED, .proc/stop_use_for)

//handles deactivating viewport features for user
/obj/structure/interior_viewport/proc/stop_use_for(var/mob/living/carbon/human/M)

	M.unset_interaction()
	M.reset_view()
	M.client.change_view(world_view_size, vehicle)
	to_chat(M, SPAN_NOTICE("You pull away from \the [src]'s screen."))

	remove_action(M, /datum/action/human_action/vehicle_unbuckle)

	UnregisterSignal(M, COMSIG_MOVABLE_MOVED)

//allows xenos to use viewports
/obj/structure/interior_viewport/attack_alien(var/mob/M)
	if(!vehicle || !isXeno(M))
		return XENO_NO_DELAY_ACTION

	start_use_for_xeno(M)
	return XENO_NONCOMBAT_ACTION

/obj/structure/interior_viewport/proc/start_use_for_xeno(var/mob/living/carbon/Xenomorph/X)
	X.set_interaction(vehicle)
	X.reset_view(vehicle)
	X.client.change_view(viewport_view_buff, vehicle)
	to_chat(X, SPAN_XENONOTICE("You peer into the device's screen, observing the vehicle's surroundings."))

	RegisterSignal(X, COMSIG_MOVABLE_MOVED, .proc/stop_use_for_xeno)

/obj/structure/interior_viewport/proc/stop_use_for_xeno(var/mob/living/carbon/Xenomorph/X)

	X.unset_interaction()
	X.reset_view()
	X.client.change_view(world_view_size, vehicle)
	to_chat(X, SPAN_XENONOTICE("You pull away from the screen."))

	UnregisterSignal(X, COMSIG_MOVABLE_MOVED)

//Special version for MED APC that grants user medhud
/obj/structure/interior_viewport/med
	name = "\improper External Medi-Cameras Terminal"
	desc = "A small terminal connected to the external cameras of a vehicle, allowing a 360 degree visual survey of vehicle surroundings as well as providing medical HUD to the user."
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "viewport_med"

	var/list/users = list()
	var/process_cooldown = 2

/obj/structure/interior_viewport/med/Destroy()
	for(var/mob/living/M in users)
		stop_use_for(M)
	users.Cut()
	return ..()

//handles user's eyewear.
/obj/structure/interior_viewport/med/proc/handle_eyewear(var/mob/living/carbon/human/M)
	var/obj/item/clothing/glasses/eyewear = M.glasses
	if(eyewear && (eyewear.hud_type || eyewear.vision_flags))
		if(M.interactee == vehicle)
			if(eyewear.active)
				to_chat(M, SPAN_WARNING("Your [eyewear] interferes with the screen frequency, causing visual artifacts which gives you a headache so you switch it off."))
				eyewear.attack_self(M)
				disable_hud_for(M)	//just in case it was some medical HUD, we properly reapply stuff
				enable_hud_for(M)
		else
			if(!eyewear.active)
				to_chat(M, SPAN_WARNING("You switch your [eyewear] back on."))
				eyewear.attack_self(M)

//handles activating viewport features for user
/obj/structure/interior_viewport/med/start_use_for(var/mob/living/carbon/human/M)
	M.set_interaction(vehicle)
	handle_eyewear(M)

	to_chat(M, SPAN_NOTICE("You look into \the [src]'s screen, viewing the vehicle's surroundings with an overlaid medical HUD."))
	enable_hud_for(M)

	RegisterSignal(M, COMSIG_MOVABLE_MOVED, .proc/stop_use_for)

	START_PROCESSING(SSobj, src)

//handles deactivating viewport features for user
/obj/structure/interior_viewport/med/stop_use_for(var/mob/living/carbon/human/M)
	to_chat(M, SPAN_NOTICE("You pull away from \the [src]'s screen."))
	disable_hud_for(M)
	if(!length(users))
		STOP_PROCESSING(SSobj, src)
	M.unset_interaction()
	handle_eyewear(M)

	UnregisterSignal(M, COMSIG_MOVABLE_MOVED)

//handles enabling view and HUD changes
/obj/structure/interior_viewport/med/proc/enable_hud_for(var/mob/living/carbon/human/M)
	if(!(M in users))
		users.Add(M)
	M.reset_view(vehicle)
	M.client.change_view(viewport_view_buff, vehicle)

	var/datum/mob_hud/hud = huds[MOB_HUD_MEDICAL_ADVANCED]	//the hud we will be adding to user
	hud.add_hud_to(M)

//handles disabling view and HUD changes
/obj/structure/interior_viewport/med/proc/disable_hud_for(var/mob/living/carbon/human/M)
	users.Remove(M)
	M.client.change_view(world_view_size, vehicle)
	M.client.pixel_x = 0
	M.client.pixel_y = 0
	M.reset_view()

	var/datum/mob_hud/hud = huds[MOB_HUD_MEDICAL_ADVANCED]
	hud.remove_hud_from(M)

//processing only when there are users
/obj/structure/interior_viewport/med/process(delta_time)
	process_cooldown = process_cooldown - 1 * delta_time
	if(process_cooldown > 0)
		return
	else
		process_cooldown = initial(process_cooldown)

	for(var/mob/living/carbon/human/M in users)
		if(M.interactee != vehicle)
			stop_use_for(M)
		handle_eyewear(M)

	if(!length(users))
		STOP_PROCESSING(SSobj, src)
		return

/obj/structure/interior_viewport/med/attack_hand(var/mob/living/M)
	if(!vehicle || !ishuman(M))
		return

	if(M in users)	//in case something broke so person can properly deactivate it
		stop_use_for(M)
		return

	start_use_for(M)
	give_action(M, /datum/action/human_action/vehicle_unbuckle)

/obj/structure/interior_viewport/simple
	name = "viewport"
	desc = "Hey, I can see my base from here!"
	icon_state = "viewport_simple"

//van's frontal window viewport
/obj/structure/interior_viewport/simple/windshield
	name = "windshield"
	desc = "When it was cleaned last time? There is a squashed bug in the corner."
	icon = 'icons/obj/vehicles/interiors/van.dmi'
	icon_state = "windshield_viewport_top"
	alpha = 80
