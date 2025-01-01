//------------------------------------------------------
//------------------------VERBS-------------------------
//This file contains all basic verbs that vehicles contain


//Used to swap which module a position is using
//e.g. swapping primary gunner from the minigun to the smoke launcher
/obj/vehicle/multitile/proc/switch_hardpoint()
	set name = "Change Active Hardpoint"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	var/list/usable_hps = user_vehicle.get_activatable_hardpoints(seat)
	if(!LAZYLEN(usable_hps))
		to_chat(user, SPAN_WARNING("None of the hardpoints can be activated or they are all broken."))
		return

	var/obj/item/hardpoint/hardpoint = tgui_input_list(usr, "Select a hardpoint.", "Switch Hardpoint", usable_hps)
	if(!hardpoint)
		return

	var/obj/item/hardpoint/old_hp = user_vehicle.active_hp[seat]
	if(old_hp)
		SEND_SIGNAL(old_hp, COMSIG_GUN_INTERRUPT_FIRE) //stop fire when switching away from HP

	user_vehicle.active_hp[seat] = hardpoint
	var/msg = "You select \the [hardpoint]."
	if(hardpoint.ammo)
		msg += " Ammo: <b>[SPAN_HELPFUL(hardpoint.ammo.current_rounds)]/[SPAN_HELPFUL(hardpoint.ammo.max_rounds)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(hardpoint.backup_clips))]/[SPAN_HELPFUL(hardpoint.max_clips)]</b>"
	to_chat(user, SPAN_WARNING(msg))

//cycles through hardpoints in a activatable hardpoints list without asking anything
/obj/vehicle/multitile/proc/cycle_hardpoint()
	set name = "Cycle Active Hardpoint"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	var/list/usable_hps = user_vehicle.get_activatable_hardpoints(seat)
	if(!LAZYLEN(usable_hps))
		to_chat(user, SPAN_WARNING("None of the hardpoints can be activated or they are all broken."))
		return
	var/new_hp = usable_hps.Find(user_vehicle.active_hp[seat])
	if(!new_hp)
		new_hp = 0

	new_hp = (new_hp % length(usable_hps)) + 1
	var/obj/item/hardpoint/current_hp = usable_hps[new_hp]
	if(!current_hp)
		return

	var/obj/item/hardpoint/old_hp = user_vehicle.active_hp[seat]
	if(old_hp)
		SEND_SIGNAL(old_hp, COMSIG_GUN_INTERRUPT_FIRE) //stop fire when switching away from HP

	user_vehicle.active_hp[seat] = current_hp
	var/msg = "You select \the [current_hp]."
	if(current_hp.ammo)
		msg += " Ammo: <b>[SPAN_HELPFUL(current_hp.ammo.current_rounds)]/[SPAN_HELPFUL(current_hp.ammo.max_rounds)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(current_hp.backup_clips))]/[SPAN_HELPFUL(current_hp.max_clips)]</b>"
	to_chat(user, SPAN_WARNING(msg))

// Used to lock/unlock the vehicle doors to anyone without proper access
/obj/vehicle/multitile/proc/toggle_door_lock()
	set name = "Toggle Door Locks"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	if(seat != VEHICLE_DRIVER)
		return

	user_vehicle.door_locked = !user_vehicle.door_locked
	to_chat(user, SPAN_NOTICE("You [user_vehicle.door_locked ? "lock" : "unlock"] the vehicle doors."))

//switches between SHIFT + Click and Middle Mouse Button Click to fire not selected currently weapon
/obj/vehicle/multitile/proc/toggle_shift_click()
	set name = "Toggle Middle/Shift Clicking"
	set desc = "Toggles between using Middle Mouse Button click and Shift + Click to fire not currently selected weapon if possible."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	if(seat == VEHICLE_GUNNER)
		user_vehicle.vehicle_flags ^= VEHICLE_TOGGLE_SHIFT_CLICK_GUNNER
		to_chat(usr, SPAN_NOTICE("You will fire not selected weapon with [(user_vehicle.vehicle_flags & VEHICLE_TOGGLE_SHIFT_CLICK_GUNNER) ? "Shift + Click" : "Middle Mouse Button click"] now, if possible."))
	return

//opens vehicle status window with HP and ammo of hardpoints
/obj/vehicle/multitile/proc/get_status_info()
	set name = "Get Status Info"
	set desc = "Displays all available information about your vehicle in a small window."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	user_vehicle.tgui_interact(user)

// BEGIN TGUI \\

/obj/vehicle/multitile/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VehicleStatus", "[name]")
		ui.open()

/obj/vehicle/multitile/ui_data(mob/user)
	var/list/data = list()

	var/list/resist_name = list("Bio" = "acid", "Slash" = "slash", "Bullet" = "bullet", "Expl" = "explosive", "Blunt" = "blunt")
	var/list/resist_data_list = list()

	for(var/i in resist_name)
		var/resist = 1 - LAZYACCESS(dmg_multipliers, LAZYACCESS(resist_name, i))
		resist_data_list += list(list(
			"name" = i,
			"pct" = resist
		))

	data["resistance_data"] = resist_data_list
	data["integrity"] = floor(100 * health / initial(health))
	data["door_locked"] = door_locked
	data["total_passenger_slots"] = interior.passengers_slots
	data["total_taken_slots"] = interior.passengers_taken_slots

	var/list/passenger_category_data_list = list()

	for(var/datum/role_reserved_slots/RRS in interior.role_reserved_slots)
		passenger_category_data_list += list(list(
			"name" = RRS.category_name,
			"taken" = RRS.taken,
			"total" = RRS.total
		))

	data["passenger_categories_data"] = passenger_category_data_list

	var/list/hps = hardpoints.Copy()
	var/list/hardpoint_data_list = list()

	for(var/obj/item/hardpoint/holder/H in hps)
		hardpoint_data_list += H.get_tgui_info()
		LAZYREMOVE(hps, H)
	for(var/obj/item/hardpoint/H in hps)
		hardpoint_data_list += list(H.get_tgui_info())

	data["hardpoint_data"] = hardpoint_data_list

	return data

/obj/vehicle/multitile/ui_state(mob/user)
	return GLOB.not_incapacitated_state

// END TGUI \\

//Megaphone gaming
/obj/vehicle/multitile/proc/use_megaphone()
	set name = "Use Megaphone"
	set desc = "Let's you shout a message to peoples around the vehicle."
	set category = "Vehicle"

	var/mob/living/user = usr
	if(!istype(user) || !user.client)
		return

	if(user.client.prefs?.muted & MUTE_IC)
		to_chat(src, SPAN_DANGER("You cannot speak in IC (muted)."))
		return
	if(user.silent || user.is_mob_incapacitated())
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	if(world.time < user_vehicle.next_shout)
		to_chat(user, SPAN_WARNING("You need to wait [(user_vehicle.next_shout - world.time) / 10] seconds."))
		return

	var/message = tgui_input_text(user, "Shout a message?", "Megaphone", multiline = TRUE, timeout = 30 SECONDS)
	if(!message || !user.client)
		return

	if(user.client.prefs?.muted & MUTE_IC)
		to_chat(src, SPAN_DANGER("You cannot speak in IC (muted)."))
		return
	if(user.silent || user.is_mob_incapacitated())
		return

	if(user_vehicle.seats[seat] != user)
		to_chat(user, SPAN_WARNING("You need to be buckled to vehicle seat to do this."))
		return

	var/mob/living/carbon/human/shouting = user
	var/list/new_message = shouting.handle_speech_problems(message)
	message = new_message[1]
	message = capitalize(message)
	log_admin("[key_name(user)] used a vehicle megaphone to say: >[message]<")

	user_vehicle.next_shout = world.time + 10 SECONDS
	var/list/mob/langchat_long_listeners = list()
	for(var/mob/listener in get_mobs_in_view(9, user_vehicle))
		if(!ishumansynth_strict(listener) && !isobserver(listener))
			listener.show_message("[user_vehicle] broadcasts something, but you can't understand it.")
			continue
		listener.show_message("<B>[user_vehicle]</B> broadcasts, [FONT_SIZE_LARGE("\"[message]\"")]", SHOW_MESSAGE_AUDIBLE) // 2 stands for hearable message
		langchat_long_listeners += listener
	user_vehicle.langchat_long_speech(message, langchat_long_listeners, user.get_default_language())

//opens vehicle controls guide, that contains description of all verbs and shortcuts in it
/obj/vehicle/multitile/proc/open_controls_guide()
	set name = "Vehicle Controls Guide"
	set desc = "MANDATORY FOR FIRST PLAY AS VEHICLE CREWMAN OR AFTER UPDATES."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	var/dat = "<b><i>Common verbs:</i></b><br>1. <b>\"A: Change Active Hardpoint\"</b> - brings up a list of all not destroyed activatable hardpoints you have access to and allows you to switch your current active hardpoint to one from the list. To activate currently selected hardpoint, click on your target. <font color='#cd6500'><b>MAKE SURE NOT TO HIT MARINES.</b></font><br>\
	2. <b>\"G: Name Vehicle\"</b> - used to add a custom name to the vehicle. Single use. 26 characters maximum.<br> \
	3. <b>\"I: Get Status Info\"</b> - brings up \"Vehicle Status Info\" window with all available information about your vehicle.<br> \
	<font color='#cd6500'><b><i>Driver verbs:</i></b></font><br> 1. <b>\"G: Activate Horn\"</b> - activates vehicle horn. Keep in mind, that vehicle horn is very loud and can be heard from afar by both allies and foes.<br> \
	2. <b>\"G: Toggle Door Locks\"</b> - toggles vehicle's access restrictions. Crewman, Brig and Command accesses bypass these restrictions.<br> \
	<font color=\"red\"><b><i>Gunner verbs:</i></b></font><br> 1. <b>\"A: Cycle Active Hardpoint\"</b> - works similarly to one above, except it automatically switches to next hardpoint in a list allowing you to switch faster.<br> \
	2. <b>\"G: Toggle Middle/Shift Clicking\"</b> - toggles between using <i>Middle Mouse Button</i> click and <i>Shift + Click</i> to fire not currently selected weapon if possible.<br> \
	3. <b>\"G: Toggle Turret Gyrostabilizer\"</b> - toggles Turret Gyrostabilizer allowing it to keep current direction ignoring hull turning. <i>(Exists only on vehicles with rotating turret, e.g. M34A2 Longstreet Light Tank)</i><br> \
	<font color='#003300'><b><i>Support Gunner verbs:</i></b></font><br> 1. <b>\"Reload Firing Port Weapon\"</b> - initiates automated reloading process for M56 FPW. Requires a confirmation.<br> \
	<font color='#cd6500'><b><i>Driver shortcuts:</i></b></font><br> 1. <b>\"CTRL + Click\"</b> - activates vehicle horn.<br> \
	<font color=\"red\"><b><i>Gunner shortcuts:</i></b></font><br> 1. <b>\"ALT + Click\"</b> - toggles Turret Gyrostabilizer. <i>(Exists only on vehicles with rotating turret, e.g. M34A2 Longstreet Light Tank)</i><br>"

	show_browser(user, dat, "Vehicle Controls Guide", "vehicle_help", "size=900x500")
	onclose(user, "vehicle_help")
	return

//toggles gyrostabilizer for vehicles that have turret, allowing it to keep direction regardless hull rotations
/obj/vehicle/multitile/proc/toggle_gyrostabilizer()
	set name = "Toggle Turret Gyrostabilizer"
	set desc = "Toggles Turret Gyrostabilizer allowing it independent movement regardless of hull direction."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in user_vehicle.hardpoints
	if(!turret)
		return

	turret.toggle_gyro(usr)

//single use verb that allows VCs to add a nickname in "" at the end of their vehicle name
/obj/vehicle/multitile/proc/name_vehicle()
	set name = "Name Vehicle"
	set desc = "Allows you to add a custom name to your vehicle. Single use. 26 characters maximum."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	if(user_vehicle.nickname)
		to_chat(user, SPAN_WARNING("Vehicle already has a \"[user_vehicle.nickname]\" nickname."))
		return

	var/new_nickname = stripped_input(user, "Enter a unique IC name or a callsign to add to your vehicle's name. [MAX_NAME_LEN] characters maximum. \n\nIMPORTANT! This is an IC nickname/callsign for your vehicle and you will be punished for putting in meme names.\nSINGLE USE ONLY.", "Name your vehicle", null, MAX_NAME_LEN)
	if(!new_nickname)
		return

	if(length(new_nickname) > MAX_NAME_LEN)
		tgui_alert(user, "Name [new_nickname] is over [MAX_NAME_LEN] characters limit. Try again.", "Naming vehicle failed?", list("Ok"), 30 SECONDS)
		return

	if(tgui_alert(user, "Vehicle's name will be [user_vehicle.name + "\"[new_nickname]\""]. Confirm?", "Confirmation?", list("Yes", "No"), 10 SECONDS) != "Yes")
		return

	if(user_vehicle.seats[seat] != user) //check that we are still in seat
		to_chat(user, SPAN_WARNING("You need to be buckled to vehicle seat to do this."))
		return

	if(user_vehicle.nickname) //check again if second VC was faster.
		to_chat(user, SPAN_WARNING("The other crewman beat you to it!"))
		return

	user_vehicle.nickname = new_nickname
	user_vehicle.name = initial(user_vehicle.name) + " \"[user_vehicle.nickname]\""
	to_chat(user, SPAN_NOTICE("You've added \"[user_vehicle.nickname]\" nickname to your vehicle."))

	message_admins(WRAP_STAFF_LOG(user, "added \"[user_vehicle.nickname]\" nickname to their [initial(user_vehicle.name)]. ([user_vehicle.x],[user_vehicle.y],[user_vehicle.z])"), user_vehicle.x, user_vehicle.y, user_vehicle.z)

	user_vehicle.initialize_cameras(TRUE)

//Activates vehicle horn. Yes, it is annoying.
/obj/vehicle/multitile/proc/activate_horn()
	set name = "Activate Horn"
	set desc = "Activates vehicle signal. Beep-beep."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	if(world.time < user_vehicle.next_honk)
		to_chat(user, SPAN_WARNING("You need to wait [(user_vehicle.next_honk - world.time) / 10] seconds."))
		return

	user_vehicle.next_honk = world.time + 10 SECONDS
	to_chat(user, SPAN_NOTICE("You activate vehicle's horn."))
	user_vehicle.perform_honk()

/obj/vehicle/multitile/proc/perform_honk()
	if(honk_sound)
		playsound(loc, honk_sound, 75, TRUE, 15) //heard within ~15 tiles

//Support gunner verbs

/obj/vehicle/multitile/proc/reload_firing_port_weapon()
	set name = "Reload Firing Port Weapon"
	set desc = "Initiates firing port weapon automated reload process."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/user_vehicle = user.interactee
	if(!istype(user_vehicle))
		return

	var/seat = user_vehicle.get_mob_seat(user)
	if(!seat)
		return

	if(user_vehicle.health < initial(user_vehicle.health) * 0.5)
		to_chat(user, SPAN_WARNING("\The [user_vehicle]'s hull is too damaged to operate!"))
		return

	for(var/obj/item/hardpoint/special/firing_port_weapon/fpw in user_vehicle.hardpoints)
		if(fpw.allowed_seat != seat)
			continue
		if(tgui_alert(user, "Initiate M56 FPW reload process? It will take [fpw.reload_time / 10] seconds.", "Initiate reload?", list("Yes", "No"), 10 SECONDS) == "Yes")
			fpw.start_auto_reload(user)
		return

	to_chat(user, SPAN_WARNING("Warning. No FPW for [seat] found, tell a dev!"))
