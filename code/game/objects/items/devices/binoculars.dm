/obj/item/device/binoculars
	name = "binoculars"
	desc = "A military-issued pair of binoculars."
	icon = 'icons/obj/items/binoculars.dmi'
	icon_state = "binoculars"

	flags_atom = FPRINT|CONDUCT
	force = 5.0
	w_class = SIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = SPEED_VERY_FAST

	//matter = list("metal" = 50,"glass" = 50)

/obj/item/device/binoculars/Initialize()
	. = ..()
	select_gamemode_skin(type)

/obj/item/device/binoculars/attack_self(mob/user)
	zoom(user, 11, 12)

/obj/item/device/binoculars/on_set_interaction(var/mob/user)
	flags_atom |= RELAY_CLICK


/obj/item/device/binoculars/on_unset_interaction(var/mob/user)
	flags_atom &= ~RELAY_CLICK

/obj/item/device/binoculars/civ
	desc = "A pair of binoculars."

/obj/item/device/binoculars/civ/Initialize()
	. = ..()
	icon_state = "binoculars_civ"

//RANGEFINDER with ability to acquire coordinates
/obj/item/device/binoculars/range
	name = "rangefinder"
	desc = "A pair of binoculars with a rangefinding function. Ctrl + Click turf to acquire it's coordinates. Ctrl + Click rangefinder to stop lasing."
	icon_state = "rangefinder"
	var/laser_cooldown = 0
	var/cooldown_duration = 200 //20 seconds
	var/obj/effect/overlay/temp/laser_coordinate/coord
	var/target_acquisition_delay = 100 //10 seconds

/obj/item/device/binoculars/range/Initialize()
	. = ..()
	update_icon()

/obj/item/device/binoculars/range/Dispose()
	if(coord)
		qdel(coord)
		coord = null
	. = ..()

/obj/item/device/binoculars/range/update_icon()
	overlays += "laser_range"

/obj/item/device/binoculars/range/on_unset_interaction(var/mob/user)
	..()
	if(user && coord && !zoom)
		qdel(coord)
		coord = null

/obj/item/device/binoculars/range/clicked(mob/user, list/mods)
	if(!ishuman(usr))
		return
	if(mods["ctrl"])
		stop_targeting(user)
		return 1
	return ..()

/obj/item/device/binoculars/range/handle_click(var/mob/living/carbon/human/user, var/atom/A, var/list/mods)
	if(!istype(user))
		return
	if(mods["ctrl"])
		acquire_target(A, user)
		return TRUE
	return FALSE

/obj/item/device/binoculars/range/proc/stop_targeting(mob/living/carbon/human/user)
	if(coord)
		qdel(coord)
		coord = null
		to_chat(user, SPAN_WARNING("You stop lasing."))

/obj/item/device/binoculars/range/proc/acquire_target(atom/A, mob/living/carbon/human/user)
	set waitfor = 0

	if(coord)
		to_chat(user, SPAN_WARNING("You're already targeting something."))
		return
	if(world.time < laser_cooldown)
		to_chat(user, SPAN_WARNING("[src]'s laser battery is recharging."))
		return

	var/acquisition_time = target_acquisition_delay
	if(user.skills)
		acquisition_time = max(15, acquisition_time - 25*user.skills.get_skill_level(SKILL_LEADERSHIP))

	var/datum/squad/S = user.assigned_squad

	var/las_name = ""
	if(S)
		las_name = S.name

	var/turf/TU = get_turf(A)
	if(!istype(TU) || user.action_busy)
		return
	playsound(src, 'sound/effects/nightvision.ogg', 35)
	to_chat(user, SPAN_NOTICE("INITIATING LASER TARGETING. Stand still."))
	if(!do_after(user, acquisition_time, INTERRUPT_ALL, BUSY_ICON_GENERIC) || world.time < laser_cooldown)
		return
	var/obj/effect/overlay/temp/laser_coordinate/LT = new (TU, las_name, user)
	coord = LT
	interact(user)
	playsound(src, 'sound/effects/binoctarget.ogg', 35)
	while(coord)
		if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			if(coord)
				qdel(coord)
				coord = null
			break

/obj/item/device/binoculars/range/interact(mob/user as mob)
	var/dat = "<html><head><title>[src]</title></head><body><TT>"

	dat += "<h3>SIMPLIFIED COORDINATES OF TARGET:</h3><BR>"
	dat += "<h4>LONGITUDE [obfuscate_x(coord.x)]. LATITUDE [obfuscate_y(coord.y)].</h4></TT></body></html>"

	show_browser(user, dat, "Coordinates successfully acquired", "rangebinos")
	onclose(user, "rangebinos")
	return

//LASER DESIGNATOR with ability to acquire coordinates and CAS lasing support
/obj/item/device/binoculars/range/designator
	name = "laser designator"
	desc = "A laser designator with two modes: target marking for CAS with IR laser and rangefinding. Ctrl + Click turf to target something. Ctrl + Click designator to stop lasing. Alt + Click designator to switch modes."
	var/obj/effect/overlay/temp/laser_target/laser
	var/mode = 0 //Able to be switched between modes, 0 for cas laser, 1 for finding coordinates.
	var/tracking_id //a set tracking id used for CAS

/obj/item/device/binoculars/range/designator/New()
	..()
	tracking_id = cas_tracking_id_increment++
	desc = "A laser designator with two modes: target marking for CAS with IR laser and rangefinding. Tracking ID for CAS: [tracking_id]. Ctrl + Click turf to target something. Ctrl + Click designator to stop lasing. Alt + Click designator to switch modes."

/obj/item/device/binoculars/range/designator/Dispose()
	if(laser)
		qdel(laser)
		laser = null
	if(coord)
		qdel(coord)
		coord = null
	. = ..()

/obj/item/device/binoculars/range/designator/update_icon()
	if(mode)
		overlays += "laser_range"
	else
		overlays += "laser_cas"

/obj/item/device/binoculars/range/designator/examine()
	..()
	to_chat(usr, SPAN_NOTICE("They are currently set to [mode ? "range finder" : "CAS marking"] mode."))

/obj/item/device/binoculars/range/designator/clicked(mob/user, list/mods)
	if(!ishuman(usr))
		return
	if(mods["alt"])
		toggle_bino_mode(user)
		return 1
	return ..()

/obj/item/device/binoculars/range/designator/stop_targeting(mob/living/carbon/human/user)
	..()
	if(laser)
		qdel(laser)
		laser = null
		to_chat(user, SPAN_WARNING("You stop lasing."))

/obj/item/device/binoculars/range/designator/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Laser Mode"
	set desc = "Toggles laser mode of laser designator between rangefinding and lasing for CAS"

	if(!ishuman(usr))
		return
	toggle_bino_mode(usr)

/obj/item/device/binoculars/range/designator/proc/toggle_bino_mode(mob/user)
	if(user.action_busy || laser || coord)
		return

	mode = !mode
	to_chat(user, SPAN_NOTICE("You switch [src] to [mode? "range finder" : "CAS marking"] mode."))
	update_icon()
	playsound(usr, 'sound/machines/click.ogg', 15, 1)

/obj/item/device/binoculars/range/designator/on_unset_interaction(var/mob/user)
	..()

	if(user && (laser || coord) && !zoom)
		if(laser)
			qdel(laser)
		if(coord)
			qdel(coord)

/obj/item/device/binoculars/range/designator/acquire_target(atom/A, mob/living/carbon/human/user)
	set waitfor = 0

	if(laser || coord)
		to_chat(user, SPAN_WARNING("You're already targeting something."))
		return

	if(world.time < laser_cooldown)
		to_chat(user, SPAN_WARNING("[src]'s laser battery is recharging."))
		return

	var/acquisition_time = target_acquisition_delay
	if(user.skills)
		acquisition_time = max(15, acquisition_time - 25*user.skills.get_skill_level(SKILL_LEADERSHIP))

	var/datum/squad/S = user.assigned_squad

	var/las_name
	if(S)
		las_name = S.name
	else
		las_name = "X"
	las_name = las_name + "-[tracking_id]"

	var/turf/TU = get_turf(A)
	var/area/targ_area = get_area(A)
	if(!istype(TU)) return
	var/is_outside = FALSE
	if(TU.z == 1)
		switch(targ_area.ceiling)
			if(CEILING_NONE)
				is_outside = TRUE
			if(CEILING_GLASS)
				is_outside = TRUE
	if(!is_outside && !mode) //rangefinding works regardless of ceiling
		to_chat(user, SPAN_WARNING("INVALID TARGET: target must be visible from high altitude."))
		return
	if(user.action_busy)
		return
	playsound(src, 'sound/effects/nightvision.ogg', 35)
	to_chat(user, SPAN_NOTICE("INITIATING LASER TARGETING. Stand still."))
	if(!do_after(user, acquisition_time, INTERRUPT_ALL, BUSY_ICON_GENERIC) || world.time < laser_cooldown || laser)
		return
	if(mode)
		var/obj/effect/overlay/temp/laser_coordinate/LT = new (TU, las_name, user)
		coord = LT
		interact(user)
		playsound(src, 'sound/effects/binoctarget.ogg', 35)
		while(coord)
			if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				if(coord)
					qdel(coord)
					coord = null
				break
	else
		to_chat(user, SPAN_NOTICE("TARGET ACQUIRED. LASER TARGETING IS ONLINE. DON'T MOVE."))
		var/obj/effect/overlay/temp/laser_target/LT = new (TU, las_name, user, tracking_id)
		laser = LT
		playsound(src, 'sound/effects/binoctarget.ogg', 35)
		while(laser)
			if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				if(laser)
					qdel(laser)
					laser = null
				break

//IMPROVED LASER DESIGNATER, faster cooldown, faster target acquisition, can be found only in scout spec kit
/obj/item/device/binoculars/range/designator/scout
	name = "scout laser designator"
	desc = "An improved laser designator, issued to USCM scouts, with two modes: target marking for CAS with IR laser and rangefinding. Ctrl + Click turf to target something. Ctrl + Click designator to stop lasing. Alt + Click designator to switch modes."
	cooldown_duration = 80
	target_acquisition_delay = 30

//ADVANCED LASER DESIGNATER, was used for WO.
/obj/item/device/binoculars/designator
	name = "advanced laser designator" // Make sure they know this will kill people in the desc below.
	desc = "An advanced laser designator, used to mark targets for airstrikes and mortar fire. This one comes with two modes, one for IR laser which calls in a napalm airstrike upon the position, the other being a UV laser which calculates the distance for a mortar strike. On the side there is a label that reads:<span class='notice'> !!WARNING: Deaths from use of this tool will have the user held accountable!!</span>"
	icon_state = "designator_e"

	//laser_con is to add you to the list of laser users.
	flags_atom = FPRINT|CONDUCT
	force = 5.0
	w_class = SIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = SPEED_VERY_FAST
	var/atom/target = null // required for lazing at things.
	var/las_r = 0 //Red Laser, Used to Replace the IR. 0 is not active, 1 is cool down, 2 is actively Lazing the target
	var/las_b = 0 //Blue laser, Used to rangefind the coordinates for a mortar strike. 0 is not active, 1 is cool down, 2 is active laz.
	var/las_mode = 0 //What laser mode we are on. If we're on 0 we're not active, 1 is IR laser, 2 is UV Laser
	var/plane_toggle = 0 //Attack plane for Airstrike 0 for E-W 1 for N-S, Mortar power for mortars.
	var/mob/living/carbon/human/FAC = null // Our lovely Forward Air Controllers
	var/lasing = FALSE //Are we using it right now?

/obj/item/device/binoculars/designator/update_icon()
	switch(las_mode)
		if(0)
			icon_state = "designator_e"
		if(1)
			icon_state = "designator_r"
		if(2)
			icon_state = "designator_b"
	return

/obj/item/device/binoculars/designator/verb/switch_mode()
	set category = "Weapons"
	set name = "Change Laser Setting"
	set desc = "This will disable the laser, enable the IR laser, or enable the UV laser. IR for airstrikes and UV for Mortars"
	set src in usr

	playsound(src,'sound/machines/click.ogg', 15, 1)

	switch(las_mode)
		if(0) //Actually adding descriptions so you can tell what the hell you've selected now.
			las_mode = 1
			to_chat(usr, SPAN_WARNING("IR Laser enabled! You will now designate airstrikes!"))
			update_icon()
			return
		if(1)
			las_mode = 2
			to_chat(usr, SPAN_WARNING("UV Laser enabled! You will now designate mortars!"))
			update_icon()
			return
		if(2)
			las_mode = 0
			to_chat(usr, SPAN_WARNING(" System offline, now this is just a pair of binoculars but heavier."))
			update_icon()
			return
	return

/obj/item/device/binoculars/designator/verb/switch_laz()
	set category = "Weapons"
	set name = "Change Lasing Mode"
	set desc = "Will change the airstrike plane from going East/West to North/South, or if using Mortars, it'll change the warhead used on them."
	set src in usr

	playsound(src,'sound/machines/click.ogg', 15, 1)

	switch(plane_toggle)
		if(0)
			plane_toggle = 1
			to_chat(usr, SPAN_WARNING(" Airstrike plane is now N-S! If using mortars its now HE rounds!"))
			return
		if(1)
			plane_toggle = 0
			to_chat(usr, SPAN_WARNING(" Airstrike plane is now E-W! If using mortars its now concussion rounds!"))
			return
	return

/obj/item/device/binoculars/designator/attack_self(mob/living/carbon/human/user)
	zoom(user)
	if(!FAC)
		FAC = user
		return
	else
		FAC = null
		return

/obj/item/device/binoculars/designator/proc/lasering(var/mob/living/carbon/human/user, var/atom/A, var/params)
	if(!FAC || FAC != user || istype(A,/obj/screen))
		return FALSE
	if(user.stat)
		zoom(user)
		FAC = null
		return FALSE
	if(lasing)
		return FALSE
	target = A
	if(!istype(target))
		return FALSE
	if(target.z != FAC.z || target.z == 0 || FAC.z == 0 || isnull(FAC.loc))
		return FALSE

	var/list/modifiers = params2list(params) //Only single clicks.
	if(modifiers["middle"] || modifiers["shift"] || modifiers["alt"] || modifiers["ctrl"])
		return FALSE

	var/turf/SS = get_turf(src) //Stand Still, not what you're thinking.
	var/turf/T = get_turf(A)

	if(!las_mode)
		to_chat(user, SPAN_WARNING("The Laser Designator is currently off!"))
		return 0

	if(las_r || las_b) //Make sure we don't spam strikes
		to_chat(user, SPAN_WARNING("The laser is currently cooling down. Please wait roughly 10 minutes from lasing the target."))
		return 0

	to_chat(user, SPAN_BOLDNOTICE(" You start lasing the target area."))
	message_admins("ALERT: [user] ([user.key]) IS CURRENTLY LASING A TARGET: CURRENT MODE [las_mode], at ([T.x],[T.y],[T.z]) (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>).") // Alert all the admins to this asshole. Added the jmp command from the explosion code.
	var/obj/effect/las_target/lasertarget = new(T.loc)
	if(las_mode == 1 && !las_r) // Heres our IR bomb code.
		lasing = TRUE
		lasertarget.icon_state = "las_r"
		las_r = 2
		sleep(50)
		if(SS != get_turf(src)) //Don't move.
			lasing = FALSE
			las_r = 0
			return 0
		lasertarget.icon_state = "laslock_r"
		var/offset_x = 0
		var/offset_y = 0
		if(!plane_toggle)
			offset_x = 4
		if(plane_toggle)
			offset_y = 4
		var/turf/target = locate(T.x + offset_x,T.y + offset_y,T.z) //Three napalm rockets are launched
		var/turf/target_2 = locate(T.x,T.y,T.z)
		var/turf/target_3 = locate(T.x - offset_x,T.y - offset_y,T.z)
		var/turf/target_4 = locate(T.x - (offset_x*2),T.y - (offset_y*2),T.z)
		sleep(50) //AWW YEAH
		flame_radius("artillery fire", null, 3, target)
		explosion(target,  -1, 2, 3, 5)
		flame_radius("artillery fire", null, 3, target_2)
		explosion(target_2,  -1, 2, 3, 5)
		flame_radius("artillery fire", null, 3, target_3)
		explosion(target_3,  -1, 2, 3, 5)
		flame_radius("artillery fire", null, 3, target_4)
		explosion(target_4,  -1, 2, 3, 5)
		sleep(1)
		qdel(lasertarget)
		lasing = FALSE
		las_r = 1
		sleep(6000)
		las_r = 0
		return
	else if(las_mode == 2 && !las_b) //Give them the option for mortar fire.
		lasing = TRUE
		lasertarget.icon_state = "laz_b"
		las_b = 2
		sleep(50)
		if(SS != get_turf(src)) //Don't move.
			lasing = FALSE
			las_b = 0
			return 0
		lasertarget.icon_state = "lazlock_b"
		var/HE_power = 0
		var/con_power = 0
		if(!plane_toggle)
			con_power = 5
			HE_power = 1
		else
			con_power = 3
			HE_power = 3
		var/turf/target = locate(T.x + rand(-2,2),T.y + rand(-2,2),T.z)
		var/turf/target_2 = locate(T.x + rand(-2,2),T.y + rand(-2,2),T.z)
		var/turf/target_3 = locate(T.x + rand(-2,2),T.y + rand(-2,2),T.z)
		if(target && istype(target))
			qdel(lasertarget)
			explosion(target, -1, HE_power, con_power, con_power) //Kaboom!
			sleep(rand(15,30)) //This is all better done in a for loop, but I am mad lazy
			explosion(target_2, -1, HE_power, con_power, con_power)
			sleep(rand(15,30))
			explosion(target_3, -1, HE_power, con_power, con_power)
			lasing = FALSE
			las_b = 1
			sleep(6000)
			las_b = 0
			return

/obj/item/device/binoculars/designator/afterattack(atom/A as mob|obj|turf, mob/user as mob, params) // This is actually WAY better, espically since its fucken already in the code.
	lasering(user, A, params)
	return

/obj/effect/las_target
	name = "laser"
	icon = 'icons/obj/items/binoculars.dmi'
	icon_state = "las_r"
	opacity = 1
	anchored = 1
	mouse_opacity = 0
	unacidable = TRUE