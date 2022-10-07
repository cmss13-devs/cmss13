/obj/item/device/binoculars
	name = "binoculars"
	desc = "A military-issued pair of binoculars."
	icon = 'icons/obj/items/binoculars.dmi'
	icon_state = "binoculars"
	pickupsound = 'sound/handling/wirecutter_pickup.ogg'
	dropsound = 'sound/handling/wirecutter_drop.ogg'
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
	..()

	if(SEND_SIGNAL(user, COMSIG_BINOCULAR_ATTACK_SELF, src))
		return

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
	var/rangefinder_popup = TRUE //Whether coordinates are displayed in a separate popup window.
	var/last_x = "UNKNOWN"
	var/last_y = "UNKNOWN"

/obj/item/device/binoculars/range/Initialize()
	. = ..()
	update_icon()

/obj/item/device/binoculars/range/Destroy()
	QDEL_NULL(coord)
	. = ..()

/obj/item/device/binoculars/range/update_icon()
	overlays += "laser_range"

/obj/item/device/binoculars/range/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE(FONT_SIZE_LARGE("The rangefinder reads: LONGITUDE [last_x], LATITUDE [last_y]."))

/obj/item/device/binoculars/range/verb/toggle_rangefinder_popup()
	set name = "Toggle Rangefinder Display"
	set category = "Object"
	set desc = "Toggles display mode for rangefinder coordinates."
	set src in usr
	rangefinder_popup = !rangefinder_popup
	to_chat(usr, "The rangefinder [rangefinder_popup ? "now" : "no longer"] shows coordinates on the display.")

/obj/item/device/binoculars/range/on_unset_interaction(var/mob/user)
	..()
	if(user && coord && !zoom)
		QDEL_NULL(coord)

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
		if(SEND_SIGNAL(user, COMSIG_BINOCULAR_HANDLE_CLICK, src))
			return FALSE
		if(mods["click_catcher"])
			return FALSE
		if(user.z != A.z)
			to_chat(user, SPAN_WARNING("You cannot get a direct laser from where you are."))
			return FALSE
		if(!(is_ground_level(A.z)))
			to_chat(user, SPAN_WARNING("INVALID TARGET: target must be on the surface."))
			return FALSE
		if(user.sight & SEE_TURFS)
			var/list/turf/path = getline2(user, A, include_from_atom = FALSE)
			for(var/turf/T in path)
				if(T.opacity)
					to_chat(user, SPAN_WARNING("There is something in the way of the laser!"))
					return FALSE
		acquire_target(A, user)
		return TRUE
	return FALSE

/obj/item/device/binoculars/range/proc/stop_targeting(mob/living/carbon/human/user)
	if(coord)
		QDEL_NULL(coord)
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
		acquisition_time = max(15, acquisition_time - 25*user.skills.get_skill_level(SKILL_JTAC))

	var/datum/squad/S = user.assigned_squad

	var/las_name = ""
	if(S)
		las_name = S.name

	// Safety check - prevent targeting items in containers (notably your equipment/inventory)
	if(A.z == 0)
		return

	var/turf/TU = get_turf(A)
	if(!istype(TU) || user.action_busy)
		return
	playsound(src, 'sound/effects/nightvision.ogg', 35)
	to_chat(user, SPAN_NOTICE("INITIATING LASER TARGETING. Stand still."))
	if(!do_after(user, acquisition_time, INTERRUPT_ALL, BUSY_ICON_GENERIC) || world.time < laser_cooldown)
		return
	var/obj/effect/overlay/temp/laser_coordinate/LT = new (TU, las_name, user)
	coord = LT
	last_x = obfuscate_x(coord.x)
	last_y = obfuscate_y(coord.y)
	playsound(src, 'sound/effects/binoctarget.ogg', 35)
	show_coords(user)
	while(coord)
		if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			QDEL_NULL(coord)
			break

/obj/item/device/binoculars/range/proc/show_coords(mob/user)
	if(rangefinder_popup)
		tgui_interact(user)
	else
		to_chat(user, SPAN_NOTICE(FONT_SIZE_LARGE("SIMPLIFIED COORDINATES OF TARGET. LONGITUDE [last_x]. LATITUDE [last_y].")))

/obj/item/device/binoculars/range/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Binoculars", "[src.name]")
		ui.open()

/obj/item/device/binoculars/range/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/device/binoculars/range/ui_data(mob/user)
	var/list/data = list()

	data["xcoord"] = src.last_x
	data["ycoord"] = src.last_y

	return data

//LASER DESIGNATOR with ability to acquire coordinates and CAS lasing support
/obj/item/device/binoculars/range/designator
	name = "laser designator"
	desc = "A laser designator with two modes: target marking for CAS with IR laser and rangefinding. Ctrl + Click turf to target something. Ctrl + Click designator to stop lasing. Alt + Click designator to switch modes."
	var/obj/effect/overlay/temp/laser_target/laser
	var/mode = 0 //Able to be switched between modes, 0 for cas laser, 1 for finding coordinates.
	var/tracking_id //a set tracking id used for CAS

/obj/item/device/binoculars/range/designator/Initialize()
	. = ..()
	tracking_id = ++cas_tracking_id_increment

/obj/item/device/binoculars/range/designator/Destroy()
	QDEL_NULL(laser)
	QDEL_NULL(coord)
	. = ..()

/obj/item/device/binoculars/range/designator/update_icon()
	if(mode)
		overlays += "laser_range"
	else
		overlays += "laser_cas"

/obj/item/device/binoculars/range/designator/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Tracking ID for CAS: [tracking_id].")
	. += SPAN_NOTICE("[src] is currently set to [mode ? "range finder" : "CAS marking"] mode.")

/obj/item/device/binoculars/range/designator/clicked(mob/user, list/mods)
	if(!ishuman(usr))
		return
	if(mods["alt"] && loc == user)
		toggle_bino_mode(user)
		return TRUE
	return ..()

/obj/item/device/binoculars/range/designator/stop_targeting(mob/living/carbon/human/user)
	..()
	if(laser)
		QDEL_NULL(laser)
		to_chat(user, SPAN_WARNING("You stop lasing."))

/obj/item/device/binoculars/range/designator/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Laser Mode"
	set desc = "Toggles laser mode of laser designator between rangefinding and lasing for CAS"
	set src in usr
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
		acquisition_time = max(15, acquisition_time - 25*user.skills.get_skill_level(SKILL_JTAC))

	var/datum/squad/S = user.assigned_squad

	var/las_name
	if(S)
		las_name = S.name
	else
		las_name = "X"
	las_name = las_name + "-[tracking_id]"

	// Safety check - prevent targeting atoms in containers (notably your equipment/inventory)
	if(A.z == 0)
		return

	var/turf/TU = get_turf(A)
	var/area/targ_area = get_area(A)
	if(!istype(TU)) return
	var/is_outside = FALSE
	switch(targ_area.ceiling)
		if(CEILING_NONE)
			is_outside = TRUE
		if(CEILING_GLASS)
			is_outside = TRUE

	if (protected_by_pylon(TURF_PROTECTION_CAS, TU))
		is_outside = FALSE

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
		last_x = obfuscate_x(coord.x)
		last_y = obfuscate_y(coord.y)
		show_coords(user)
		playsound(src, 'sound/effects/binoctarget.ogg', 35)
		while(coord)
			if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				QDEL_NULL(coord)
				break
	else
		to_chat(user, SPAN_NOTICE("TARGET ACQUIRED. LASER TARGETING IS ONLINE. DON'T MOVE."))
		var/obj/effect/overlay/temp/laser_target/LT = new (TU, las_name, user, tracking_id)
		laser = LT

		var/turf/userloc = get_turf(user)
		msg_admin_niche("Laser target [las_name] has been designated by [key_name(user, 1)] at ([TU.x], [TU.y], [TU.z]). (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[userloc.x];Y=[userloc.y];Z=[userloc.z]'>JMP SRC</a>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[TU.x];Y=[TU.y];Z=[TU.z]'>JMP LOC</a>)")
		log_game("Laser target [las_name] has been designated by [key_name(user, 1)] at ([TU.x], [TU.y], [TU.z]).")

		playsound(src, 'sound/effects/binoctarget.ogg', 35)
		while(laser)
			if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				QDEL_NULL(laser)
				break

//IMPROVED LASER DESIGNATER, faster cooldown, faster target acquisition, can be found only in scout spec kit
/obj/item/device/binoculars/range/designator/scout
	name = "scout laser designator"
	desc = "An improved laser designator, issued to USCM scouts, with two modes: target marking for CAS with IR laser and rangefinding. Ctrl + Click turf to target something. Ctrl + Click designator to stop lasing. Alt + Click designator to switch modes."
	cooldown_duration = 80
	target_acquisition_delay = 30

/obj/item/device/binoculars/range/designator/spotter
	name = "spotter's laser designator"
	desc = "A specially-designed laser designator, issued to USCM spotters, with two modes: target marking for CAS with IR laser and rangefinding. Ctrl + Click turf to target something. Ctrl + Click designator to stop lasing. Alt + Click designator to switch modes. Additionally, a trained spotter can laze targets for a USCM marksman, increasing the speed of target acquisition."

	var/spotting_time = 10 SECONDS
	var/spotting_cooldown_delay = 5 SECONDS
	COOLDOWN_DECLARE(spotting_cooldown)

/obj/item/device/binoculars/range/designator/spotter/Initialize()
	LAZYADD(actions_types, /datum/action/item_action/specialist/spotter_target)
	return ..()

/datum/action/item_action/specialist/spotter_target
	ability_primacy = SPEC_PRIMARY_ACTION_1
	var/minimum_laze_distance = 2

/datum/action/item_action/specialist/spotter_target/New(var/mob/living/user, var/obj/item/holder)
	..()
	name = "Spot Target"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "spotter_target")
	button.overlays += IMG
	var/obj/item/device/binoculars/range/designator/spotter/designator = holder_item
	COOLDOWN_START(designator, spotting_cooldown, 0)

/datum/action/item_action/specialist/spotter_target/action_activate()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/human = owner
	if(human.selected_ability == src)
		to_chat(human, "You will no longer use [name] with \
			[human.client && human.client.prefs && human.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		button.icon_state = "template"
		human.selected_ability = null
	else
		to_chat(human, "You will now use [name] with \
			[human.client && human.client.prefs && human.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		if(human.selected_ability)
			human.selected_ability.button.icon_state = "template"
			human.selected_ability = null
		button.icon_state = "template_on"
		human.selected_ability = src

/datum/action/item_action/specialist/spotter_target/can_use_action()
	var/mob/living/carbon/human/human = owner
	if(!(GLOB.character_traits[/datum/character_trait/skills/spotter] in human.traits))
		to_chat(human, SPAN_WARNING("You have no idea how to use this!"))
		return FALSE
	if(istype(human) && !human.is_mob_incapacitated() && !human.lying && (holder_item == human.r_hand || holder_item || human.l_hand))
		return TRUE

/datum/action/item_action/specialist/spotter_target/proc/use_ability(atom/targetted_atom)
	var/mob/living/carbon/human/human = owner
	if(!istype(targetted_atom, /mob/living))
		return

	var/mob/living/target = targetted_atom

	if(target.stat == DEAD || target == human)
		return

	var/obj/item/device/binoculars/range/designator/spotter/designator = holder_item
	if(!COOLDOWN_FINISHED(designator, spotting_cooldown))
		return

	if(!check_can_use(target))
		return

	COOLDOWN_START(designator, spotting_cooldown, designator.spotting_cooldown_delay)

	///Add a decisecond to the default 1.5 seconds for each two tiles to hit.
	var/distance = round(get_dist(target, human) * 0.5)
	var/f_spotting_time = designator.spotting_time + distance

	var/image/I = image(icon = 'icons/effects/Targeted.dmi', icon_state = "locking-spotter", dir = get_cardinal_dir(target, human))
	target.overlays += I
	ADD_TRAIT(target, TRAIT_SPOTTER_LAZED, TRAIT_SOURCE_EQUIPMENT(designator.tracking_id))
	if(human.client)
		playsound_client(human.client, 'sound/weapons/TargetOn.ogg', human, 50)
	playsound(target, 'sound/weapons/TargetOn.ogg', 70, FALSE, 8, falloff = 0.4)

	if(!do_after(human, f_spotting_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, NO_BUSY_ICON))
		target.overlays -= I
		REMOVE_TRAIT(target, TRAIT_SPOTTER_LAZED, TRAIT_SOURCE_EQUIPMENT(designator.tracking_id))
		return
	target.overlays -= I
	REMOVE_TRAIT(target, TRAIT_SPOTTER_LAZED, TRAIT_SOURCE_EQUIPMENT(designator.tracking_id))

/datum/action/item_action/specialist/spotter_target/proc/check_can_use(var/mob/target, var/cover_lose_focus)
	var/mob/living/carbon/human/human = owner
	var/obj/item/device/binoculars/range/designator/spotter/designator = holder_item

	if(!can_use_action())
		return FALSE

	if(designator != human.r_hand && designator != human.l_hand)
		to_chat(human, SPAN_WARNING("How do you expect to do this without your laser designator?"))
		return FALSE

	if(get_dist(human, target) < minimum_laze_distance)
		to_chat(human, SPAN_WARNING("\The [target] is too close to laze!"))
		return FALSE

	return TRUE

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

/obj/item/device/binoculars/designator/proc/lasering(var/mob/living/carbon/human/user, var/atom/A, var/params)
	if(istype(A,/atom/movable/screen))
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
	if(target.z != user.z)
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
		to_chat(user, SPAN_WARNING("The laser is currently cooling down. Please wait roughly 5 minutes from lasing the target."))
		return 0

	to_chat(user, SPAN_BOLDNOTICE(" You start lasing the target area."))
	message_staff("ALERT: [user] ([user.key]) IS CURRENTLY LASING A TARGET: CURRENT MODE [las_mode], at ([T.x],[T.y],[T.z]) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>).") // Alert all the admins to this asshole. Added the jmp command from the explosion code.
	var/obj/effect/las_target/lasertarget = new(T.loc)
	if(las_mode == 1 && !las_r) // Heres our IR bomb code.
		lasing = TRUE
		lasertarget.icon_state = "las_r"
		las_r = 2
		playsound(src, 'sound/effects/nightvision.ogg', 35)
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
		var/datum/cause_data/cause_data = create_cause_data("artillery fire", user)
		flame_radius(cause_data, 3, target, , , , , )
		explosion(target,  -1, 2, 3, 5, , , , cause_data)
		flame_radius(cause_data, 3, target_2, , , , , )
		explosion(target_2,  -1, 2, 3, 5, , , , cause_data)
		flame_radius(cause_data, 3, target_3, , , , , )
		explosion(target_3,  -1, 2, 3, 5, , , , cause_data)
		flame_radius(cause_data, 3, target_4, , , , , )
		explosion(target_4,  -1, 2, 3, 5, , , , cause_data)
		sleep(1)
		qdel(lasertarget)
		lasing = FALSE
		las_r = 1
		addtimer(VARSET_CALLBACK(src, las_r, FALSE), 5 MINUTES)
		return
	else if(las_mode == 2 && !las_b) //Give them the option for mortar fire.
		lasing = TRUE
		lasertarget.icon_state = "laz_b"
		las_b = 2
		playsound(src, 'sound/effects/nightvision.ogg', 35)
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
			var/datum/cause_data/cause_data = create_cause_data("artillery fire", user)
			explosion(target, -1, HE_power, con_power, con_power, , , , cause_data) //Kaboom!
			sleep(rand(15,30)) //This is all better done in a for loop, but I am mad lazy
			explosion(target_2, -1, HE_power, con_power, con_power, , , , cause_data)
			sleep(rand(15,30))
			explosion(target_3, -1, HE_power, con_power, con_power, , , , cause_data)
			lasing = FALSE
			las_b = 1
			addtimer(VARSET_CALLBACK(src, las_b, FALSE), 5 MINUTES)
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
