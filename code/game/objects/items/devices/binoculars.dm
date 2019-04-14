/obj/item/device/binoculars

	name = "binoculars"
	desc = "A pair of binoculars."
	icon_state = "binoculars"

	flags_atom = FPRINT|CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

	//matter = list("metal" = 50,"glass" = 50)

/obj/item/device/binoculars/attack_self(mob/user)
	zoom(user, 11, 12)

/obj/item/device/binoculars/on_set_interaction(var/mob/user)
	flags_atom |= RELAY_CLICK


/obj/item/device/binoculars/on_unset_interaction(var/mob/user)
	flags_atom &= ~RELAY_CLICK

/obj/item/device/binoculars/tactical
	name = "tactical binoculars"
	desc = "A pair of binoculars, with a laser targeting function. Ctrl+Click to target something."
	var/laser_cooldown = 0
	var/cooldown_duration = 200 //20 seconds
	var/obj/effect/overlay/temp/laser_target/laser
	var/obj/effect/overlay/temp/laser_coordinate/coord
	var/target_acquisition_delay = 100 //10 seconds
	var/mode = 0 //Able to be switched between modes, 0 for cas laser, 1 for finding coordinates.
	var/changable = 1 //If set to 0, you can't toggle the mode between CAS and coordinate finding

/obj/item/device/binoculars/tactical/New()
	..()
	update_icon()

/obj/item/device/binoculars/tactical/examine()
	..()
	to_chat(usr, "<span class='notice'>They are currently set to [mode ? "range finder" : "CAS marking"] mode.</span>")

/obj/item/device/binoculars/tactical/Dispose()
	if(laser)
		qdel(laser)
		laser = null
	if(coord)
		qdel(coord)
		coord = null
	. = ..()

/obj/item/device/binoculars/tactical/on_unset_interaction(var/mob/user)
	..()

	if (user && (laser || coord))
		if (!zoom)
			if(laser)
				qdel(laser)
			if(coord)
				qdel(coord)

/obj/item/device/binoculars/tactical/update_icon()
	..()
	if(mode)
		overlays += "binoculars_range"
	else
		overlays += "binoculars_laser"

/obj/item/device/binoculars/tactical/handle_click(var/mob/living/user, var/atom/A, var/list/mods)
	if (mods["ctrl"])
		acquire_target(A, user)
		return 1
	return 0

/obj/item/device/binoculars/tactical/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Laser Mode"
	var/mob/living/user
	if(isliving(loc))
		user = loc
	else
		return

	if(!changable)
		to_chat(user, "These binoculars only have one mode.")
		return

	if(!zoom)
		mode = !mode
		to_chat(user, "<span class='notice'>You switch [src] to [mode? "range finder" : "CAS marking" ] mode.</span>")
		update_icon()
		playsound(usr, 'sound/machines/click.ogg', 15, 1)

/obj/item/device/binoculars/tactical/proc/acquire_target(atom/A, mob/living/carbon/human/user)
	set waitfor = 0

	if(laser || coord)
		to_chat(user, "<span class='warning'>You're already targeting something.</span>")
		return

	if(world.time < laser_cooldown)
		to_chat(user, "<span class='warning'>[src]'s laser battery is recharging.</span>")
		return

	if(!user.mind)
		return

	var/acquisition_time = target_acquisition_delay
	if(user.mind.cm_skills)
		acquisition_time = max(15, acquisition_time - 25*user.mind.cm_skills.leadership)

	var/datum/squad/S = user.assigned_squad

	var/laz_name = ""
	if(S) laz_name = S.name

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
		to_chat(user, "<span class='warning'>INVALID TARGET: target must be visible from high altitude.</span>")
		return
	if(user.action_busy)
		return
	playsound(src, 'sound/effects/nightvision.ogg', 35)
	to_chat(user, "<span class='notice'>INITIATING LASER TARGETING. Stand still.</span>")
	if(!do_after(user, acquisition_time, TRUE, 5, BUSY_ICON_GENERIC) || world.time < laser_cooldown || laser)
		return
	if(mode)
		var/obj/effect/overlay/temp/laser_coordinate/LT = new (TU, laz_name, user)
		coord = LT
		to_chat(user, "<span class='notice'>SIMPLIFIED COORDINATES OF TARGET. LONGITUDE [obfuscate_x(coord.x)]. LATITUDE [obfuscate_y(coord.y)].</span>")
		playsound(src, 'sound/effects/binoctarget.ogg', 35)
		while(coord)
			if(!do_after(user, 50, TRUE, 5, BUSY_ICON_GENERIC))
				if(coord)
					qdel(coord)
					coord = null
				break
	else
		to_chat(user, "<span class='notice'>TARGET ACQUIRED. LASER TARGETING IS ONLINE. DON'T MOVE.</span>")
		var/obj/effect/overlay/temp/laser_target/LT = new (TU, laz_name, user)
		laser = LT
		playsound(src, 'sound/effects/binoctarget.ogg', 35)
		while(laser)
			if(!do_after(user, 50, TRUE, 5, BUSY_ICON_GENERIC))
				if(laser)
					qdel(laser)
					laser = null
				break


/obj/item/device/binoculars/tactical/scout
	name = "scout tactical binoculars"
	desc = "A modified version of tactical binoculars with an advanced laser targeting function. Ctrl+Click to target something."
	cooldown_duration = 80
	target_acquisition_delay = 30

//For events
/obj/item/device/binoculars/tactical/range
	name = "range-finder"
	desc = "A pair of binoculars designed to find coordinates."
	changable = 0
	mode = 1

// Laser Designator

/obj/item/device/binoculars/designator
	name = "laser designator" // Make sure they know this will kill people in the desc below.
	desc = "A laser designator, used to mark targets for airstrikes. This one comes with two modes, one for IR laser which calls in a napalm airstrike upon the position, the other being a UV laser which calculates the distance for a mortar strike. On the side there is a label that reads:<span class='notice'> !!WARNING: Deaths from use of this tool will have the user held accountable!!</span>"
	icon_state = "designator_e"

	//laser_con is to add you to the list of laser users.
	flags_atom = FPRINT|CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	var/atom/target = null // required for lazing at things.
	var/laz_r = 0 //Red Laser, Used to Replace the IR. 0 is not active, 1 is cool down, 2 is actively Lazing the target
	var/laz_b = 0 //Blue laser, Used to rangefind the coordinates for a mortar strike. 0 is not active, 1 is cool down, 2 is active laz.
	var/laz_mode = 0 //What laser mode we are on. If we're on 0 we're not active, 1 is IR laser, 2 is UV Laser
	var/plane_toggle = 0 //Attack plane for Airstrike 0 for E-W 1 for N-S, Mortar power for mortars.
	var/mob/living/carbon/human/FAC = null // Our lovely Forward Air Controllers
	var/lazing = 0 //ARe we using it right now?

/obj/item/device/binoculars/designator/update_icon()
	switch(laz_mode)
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

	switch(laz_mode)
		if(0) //Actually adding descriptions so you can tell what the hell you've selected now.
			laz_mode = 1
			to_chat(usr, "<span class='warning'>IR Laser enabled! You will now designate airstrikes!</span>")
			update_icon()
			return
		if(1)
			laz_mode = 2
			to_chat(usr, "<span class='warning'>UV Laser enabled! You will now designate mortars!</span>")
			update_icon()
			return
		if(2)
			laz_mode = 0
			to_chat(usr, "<span class='warning'> System offline, now this is just a pair of binoculars but heavier.</span>")
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
			to_chat(usr, "<span class='warning'> Airstrike plane is now N-S! If using mortars its now HE rounds!</span>")
			return
		if(1)
			plane_toggle = 0
			to_chat(usr, "<span class='warning'> Airstrike plane is now E-W! If using mortars its now concussion rounds!</span>")
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



/obj/item/device/binoculars/designator/proc/laz(var/mob/living/carbon/human/user, var/atom/A, var/params)
	if(!FAC) return 0
	if(FAC != user) return 0
	if(istype(A,/obj/screen)) return 0
	if(user.stat)
		zoom(user)
		FAC = null
		return 0

	if(lazing)
		return 0

	target = A
	if(!istype(target))
		return 0

	if(target.z != FAC.z || target.z == 0 || FAC.z == 0 || isnull(FAC.loc))
		return 0

	var/list/modifiers = params2list(params) //Only single clicks.
	if(modifiers["middle"] || modifiers["shift"] || modifiers["alt"] || modifiers["ctrl"])	return 0

	var/turf/SS = get_turf(src) //Stand Still, not what you're thinking.
	var/turf/T = get_turf(A)

	if(!laz_mode)
		to_chat(user, "<span class='warning'>The Laser Designator is currently off!</span>")
		return 0

	if(laz_r || laz_b) //Make sure we don't spam strikes
		to_chat(user, "<span class='warning'>The laser is currently cooling down. Please wait roughly 10 minutes from lasing the target.</span>")
		return 0

	to_chat(user, "<span class='boldnotice'> You start lasing the target area.</span>")
	message_admins("ALERT: [user] ([user.key]) IS CURRENTLY LAZING A TARGET: CURRENT MODE [laz_mode], at ([T.x],[T.y],[T.z]) (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>).") // Alert all the admins to this asshole. Added the jmp command from the explosion code.
	var/obj/effect/las_target/lasertarget = new(T.loc)
	if(laz_mode == 1 && !laz_r) // Heres our IR bomb code.
		lazing = 1
		lasertarget.icon_state = "laz_r"
		laz_r = 2
		sleep(50)
		if(SS != get_turf(src)) //Don't move.
			lazing = 0
			laz_r = 0
			return 0
		lasertarget.icon_state = "lazlock_r"
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
		flame_radius(3,target)
		explosion(target,  -1, 2, 3, 5)
		flame_radius(3,target_2)
		explosion(target_2,  -1, 2, 3, 5)
		flame_radius(3,target_3)
		explosion(target_3,  -1, 2, 3, 5)
		flame_radius(3,target_4)
		explosion(target_4,  -1, 2, 3, 5)
		sleep(1)
		qdel(lasertarget)
		lazing = 0
		laz_r = 1
		sleep(6000)
		laz_r = 0
		return
	else if(laz_mode == 2 && !laz_b) //Give them the option for mortar fire.
		lazing = 1
		lasertarget.icon_state = "laz_b"
		laz_b = 2
		sleep(50)
		if(SS != get_turf(src)) //Don't move.
			lazing = 0
			laz_b = 0
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
			lazing = 0
			laz_b = 1
			sleep(6000)
			laz_b = 0
			return

/obj/item/device/binoculars/designator/afterattack(atom/A as mob|obj|turf, mob/user as mob, params) // This is actually WAY better, espically since its fucken already in the code.
	laz(user, A, params)
	return

/obj/effect/las_target
	name = "laser"
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "laz_r"
	opacity = 1
	anchored = 1
	mouse_opacity = 0
	unacidable = 1