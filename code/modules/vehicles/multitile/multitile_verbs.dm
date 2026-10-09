//------------------------------------------------------
//------------------------VERBS-------------------------
//This file contains all basic verbs that vehicles contain


//Used to swap which module a position is using
//e.g. swapping primary gunner from the minigun to the flare launcher
/obj/vehicle/multitile/proc/switch_hardpoint()
	set name = "Change Active Hardpoint"
	set category = "Vehicle"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!V || !istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return

	var/list/usable_hps = V.get_activatable_hardpoints(seat)
	if(!LAZYLEN(usable_hps))
		to_chat(M, SPAN_WARNING("None of the hardpoints can be activated or they are all broken."))
		return

	var/obj/item/hardpoint/HP = tgui_input_list(usr, "Select a hardpoint.", "Switch Hardpoint", usable_hps)
	if(!HP)
		return

	var/obj/item/hardpoint/old_HP = V.active_hp[seat]
	if(old_HP)
		SEND_SIGNAL(old_HP, COMSIG_GUN_INTERRUPT_FIRE) //stop fire when switching away from HP

	V.active_hp[seat] = HP
	var/msg = "You select \the [HP]."
	if(HP.ammo)
		msg += " Ammo: <b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(HP.backup_clips))]/[SPAN_HELPFUL(HP.max_clips)]</b>"
	to_chat(M, SPAN_WARNING(msg))
	V.refresh_hardpoint_actions()

//cycles through hardpoints in a activatable hardpoints list without asking anything
/obj/vehicle/multitile/proc/cycle_hardpoint(mob/toggler)
	set name = "Cycle Active Hardpoint"
	set category = "Vehicle"

	var/mob/M = toggler || usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return

	var/list/usable_hps = V.get_activatable_hardpoints(seat)
	if(!LAZYLEN(usable_hps))
		to_chat(M, SPAN_WARNING("None of the hardpoints can be activated or they are all broken."))
		return
	var/new_hp = usable_hps.Find(V.active_hp[seat])
	if(!new_hp)
		new_hp = 0

	new_hp = (new_hp % length(usable_hps)) + 1
	var/obj/item/hardpoint/HP = usable_hps[new_hp]
	if(!HP)
		return

	var/obj/item/hardpoint/old_HP = V.active_hp[seat]
	if(old_HP)
		SEND_SIGNAL(old_HP, COMSIG_GUN_INTERRUPT_FIRE) //stop fire when switching away from HP

	V.active_hp[seat] = HP
	var/msg = "You select \the [HP]."
	if(HP.ammo)
		msg += " Ammo: <b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(HP.backup_clips))]/[SPAN_HELPFUL(HP.max_clips)]</b>"
	to_chat(M, SPAN_WARNING(msg))
	V.refresh_hardpoint_actions()

// Used to lock/unlock the vehicle doors to anyone without proper access
/obj/vehicle/multitile/proc/toggle_door_lock(mob/toggler)
	set name = "Toggle Door Locks"
	set category = "Vehicle"

	var/mob/M = toggler || usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return
	if(seat != VEHICLE_DRIVER)
		return

	V.door_locked = !V.door_locked
	to_chat(M, SPAN_NOTICE("You [V.door_locked ? "lock" : "unlock"] the vehicle doors."))
	V.refresh_hardpoint_actions()

/// Manually toggles this vehicle's IFF module online/offline. Actual gating lives on the module itself.
/obj/vehicle/multitile/proc/toggle_iff_module(mob/toggler)
	set name = "Toggle IFF"
	set category = "Vehicle"

	var/mob/user = toggler || usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/obj/item/hardpoint/iff_module/module = locate() in vehicle.get_hardpoints_copy()
	if(!module)
		to_chat(user, SPAN_WARNING("No IFF module installed."))
		return

	module.toggle_online(user)

//opens vehicle status window with HP and ammo of hardpoints
/obj/vehicle/multitile/proc/get_status_info()
	set name = "Get Status Info"
	set desc = "Displays all available information about your vehicle in a small window."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	V.tgui_interact(user)

// BEGIN TGUI \\

/obj/vehicle/multitile/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VehicleStatus", "[capitalize(name)]")
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

//opens vehicle controls guide, that contains description of all verbs and shortcuts in it
/obj/vehicle/multitile/proc/open_controls_guide()
	set name = "Vehicle Controls Guide"
	set desc = "MANDATORY FOR FIRST PLAY AS VEHICLE CREWMAN OR AFTER UPDATES."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	var/dat = "<b><i>Common verbs:</i></b><br>1. <b>\"A: Change Active Hardpoint\"</b> - brings up a list of all not destroyed activatable hardpoints you have access to and allows you to switch your current active hardpoint to one from the list. To activate currently selected hardpoint, click on your target. <font color='#cd6500'><b>MAKE SURE NOT TO HIT MARINES.</b></font><br>\
	2. <b>\"G: Name Vehicle\"</b> - used to add a custom name to the vehicle. Single use. 26 characters maximum.<br> \
	3. <b>\"I: Get Status Info\"</b> - brings up \"Vehicle Status Info\" window with all available information about your vehicle.<br> \
	<font color='#cd6500'><b><i>Driver verbs:</i></b></font><br> 1. <b>\"G: Activate Horn\"</b> - activates vehicle horn. Keep in mind, that vehicle horn is very loud and can be heard from afar by both allies and foes.<br> \
	2. <b>\"G: Toggle Door Locks\"</b> - toggles vehicle's access restrictions. Crewman, Brig and Command accesses bypass these restrictions.<br> \
	<font color=\"red\"><b><i>Gunner verbs:</i></b></font><br> 1. <b>\"A: Cycle Active Hardpoint\"</b> - works similarly to one above, except it automatically switches to next hardpoint in a list allowing you to switch faster.<br> \
	2. <b>\"G: Toggle Middle/Shift Clicking\"</b> - toggles between using <i>Middle Mouse Button</i> click and <i>Shift + Click</i> to fire not currently selected weapon if possible.<br> \
	3. <b>\"G: Toggle Turret Rotation and Hardpoint Safety\"</b> - locks the turret to the hull's own facing, blocks mouse-driven aim, and prevents any mounted hardpoint from firing. The turret is gyrostabilized (holds its own facing independent of hull rotation) automatically whenever the gunner's seat is occupied, unless this is on. <i>(Exists only on vehicles with rotating turret, e.g. M34A2 Longstreet Light Tank)</i><br> \
	<font color='#003300'><b><i>Support Gunner verbs:</i></b></font><br> 1. <b>\"Reload Firing Port Weapon\"</b> - initiates automated reloading process for M56 FPW. Requires a confirmation.<br> \
	<font color='#cd6500'><b><i>Driver shortcuts:</i></b></font><br> 1. <b>\"CTRL + Click\"</b> - activates vehicle horn.<br> \
	<font color=\"red\"><b><i>Gunner shortcuts:</i></b></font><br> 1. <b>\"ALT + Click\"</b> - toggles Turret Rotation and Hardpoint Safety. <i>(Exists only on vehicles with rotating turret, e.g. M34A2 Longstreet Light Tank)</i><br>"

	show_browser(user, dat, "Vehicle Controls Guide", "vehicle_help", width = 900, height = 500)
	onclose(user, "vehicle_help")
	return

/// This vehicle's own gyro-capable hardpoint: its turret holder, or a rotation-tracked top-level hardpoint.
/obj/vehicle/multitile/proc/get_gyro_hardpoint() as /obj/item/hardpoint
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in hardpoints
	if(turret)
		return turret
	for(var/obj/item/hardpoint/H in hardpoints)
		if(H.uses_live_rotation_tracking)
			return H
	return null

// Toggles the turret's (or a top-level tracked weapon's) safety lock.
/obj/vehicle/multitile/proc/toggle_turret_safety(mob/toggler)
	set name = "Toggle Turret Rotation and Hardpoint Safety"
	set desc = "Toggles the turret's rotation/hardpoint safety lock - stops it from following the mouse or firing, and returns it to the hull's own facing."
	set category = "Vehicle"

	var/mob/M = toggler || usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/obj/item/hardpoint/T = V.get_gyro_hardpoint()
	if(!T)
		return
	T.toggle_turret_safety(M)
	V.refresh_hardpoint_actions()

//toggles the artillery module's magnified optics for your own view - available to both driver and gunner
/obj/vehicle/multitile/proc/toggle_artillery_optics(mob/toggler)
	set name = "Toggle Artillery Optics"
	set desc = "Toggles the artillery module's magnified optics for your own view."
	set category = "Vehicle"

	var/mob/living/user = toggler || usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/obj/item/hardpoint/support/artillery_module/AM = locate() in vehicle.hardpoints
	if(!AM)
		to_chat(user, SPAN_WARNING("No artillery module installed."))
		return

	AM.toggle_optics(user)

//toggles the artillery module's night vision overlay for your own view - available to both driver and gunner
/obj/vehicle/multitile/proc/toggle_artillery_nvg(mob/toggler)
	set name = "Toggle Artillery Night Vision"
	set desc = "Toggles the artillery module's night vision overlay for your own view."
	set category = "Vehicle"

	var/mob/living/user = toggler || usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/obj/item/hardpoint/support/artillery_module/AM = locate() in vehicle.hardpoints
	if(!AM)
		to_chat(user, SPAN_WARNING("No artillery module installed."))
		return

	AM.toggle_nvg(user)

//hands control of the secondary hardpoint (aim + fire) between the gunner and the driver
/obj/vehicle/multitile/proc/toggle_slave_secondary_to_driver(mob/toggler)
	set name = "Slave Secondary to Driver"
	set desc = "Toggles handing control of the secondary weapon's aim and fire between yourself and the driver."
	set category = "Vehicle"

	var/mob/user = toggler || usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/obj/item/hardpoint/secondary/secondary_weapon = vehicle.get_slavable_secondary()
	if(!secondary_weapon)
		to_chat(user, SPAN_WARNING("No secondary weapon installed."))
		return

	secondary_weapon.toggle_slaved_to_driver(user)
	vehicle.refresh_hardpoint_actions()

//toggles the fire mode for hardpoints. currently only used for the primary and secondary flamers to switch between glob and stream
/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode()
	set name = "Toggle Hardpoint Fire Mode"
	set desc = "Toggles the fire mode of your currently selected hardpoint, if it supports one."
	set category = "Vehicle"

	var/mob/user = usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/obj/item/hardpoint/selected_hardpoint = vehicle.get_mob_hp(user)
	if(!selected_hardpoint)
		to_chat(user, SPAN_WARNING("You have no hardpoint selected."))
		return

	selected_hardpoint.toggle_fire_mode(usr)

//single use verb that allows VCs to add a nickname in "" at the end of their vehicle name
/obj/vehicle/multitile/proc/name_vehicle()
	set name = "Name Vehicle"
	set desc = "Allows you to add a custom name to your vehicle. Single use. 26 characters maximum."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	if(V.nickname)
		to_chat(user, SPAN_WARNING("Vehicle already has a \"[V.nickname]\" nickname."))
		return

	var/new_nickname = stripped_input(user, "Enter a unique IC name or a callsign to add to your vehicle's name. [MAX_NAME_LEN] characters maximum. \n\nIMPORTANT! This is an IC nickname/callsign for your vehicle and you will be punished for putting in meme names.\nSINGLE USE ONLY.", "Name your vehicle", null, MAX_NAME_LEN)
	if(!new_nickname)
		return
	if(length(new_nickname) > MAX_NAME_LEN)
		alert(user, "Name [new_nickname] is over [MAX_NAME_LEN] characters limit. Try again.", "Naming vehicle failed", "Ok")
		return
	if(alert(user, "Vehicle's name will be [V.name + "\"[new_nickname]\""]. Confirm?", "Confirmation?", "Yes", "No") != "Yes")
		return

	//post-checks
	if(V.seats[seat] != user) //check that we are still in seat
		to_chat(user, SPAN_WARNING("You need to be buckled to vehicle seat to do this."))
		return

	if(V.nickname) //check again if second VC was faster.
		to_chat(user, SPAN_WARNING("The other crewman beat you to it!"))
		return

	V.nickname = new_nickname
	V.name = initial(V.name) + " \"[V.nickname]\""
	to_chat(user, SPAN_NOTICE("You've added \"[V.nickname]\" nickname to your vehicle."))

	message_admins(WRAP_STAFF_LOG(user, "added \"[V.nickname]\" nickname to their [initial(V.name)]. ([V.x],[V.y],[V.z])"), V.x, V.y, V.z)

	V.initialize_cameras(TRUE)

//Activates vehicle horn. Yes, it is annoying.
/obj/vehicle/multitile/proc/activate_horn()
	set name = "Activate Horn"
	set desc = "Activates vehicle signal. Beep-beep."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	if(world.time < V.next_honk)
		to_chat(user, SPAN_WARNING("You need to wait [(V.next_honk - world.time) / 10] seconds."))
		return

	V.next_honk = world.time + 10 SECONDS
	to_chat(user, SPAN_NOTICE("You activate vehicle's horn."))
	V.perform_honk()

//shifts up through the gear-transmission's GLOB.vehicle_gear_order, driver only
/obj/vehicle/multitile/proc/cycle_gear_up()
	set name = "Shift Gear Up"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle) || !vehicle.uses_gear_transmission)
		return

	// The matching keybinding calls this directly, so a gunner could otherwise shift gears via hotkey.
	if(vehicle.get_mob_seat(user) != VEHICLE_DRIVER)
		return

	if(vehicle.get_driver_vehicle_prefs() & VEHICLE_SIMPLE_TRANSMISSION)
		to_chat(user, SPAN_WARNING("Your vehicle preferences have simple transmission enabled - the vehicle shifts gears on its own."))
		return

	to_chat(user, SPAN_NOTICE("You shift into [vehicle.cycle_gear(1)]."))

//shifts down through the gear-transmission's GLOB.vehicle_gear_order, driver only
/obj/vehicle/multitile/proc/cycle_gear_down()
	set name = "Shift Gear Down"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle) || !vehicle.uses_gear_transmission)
		return

	// Needed because the keybinding calls this directly, see cycle_gear_up()'s matching check.
	if(vehicle.get_mob_seat(user) != VEHICLE_DRIVER)
		return

	if(vehicle.get_driver_vehicle_prefs() & VEHICLE_SIMPLE_TRANSMISSION)
		to_chat(user, SPAN_WARNING("Your vehicle preferences have simple transmission enabled - the vehicle shifts gears on its own."))
		return

	to_chat(user, SPAN_NOTICE("You shift into [vehicle.cycle_gear(-1)]."))

//toggles cruise control, driver only. While on, gas/brake adjust the target speed instead.
/obj/vehicle/multitile/proc/toggle_cruise_control()
	set name = "Toggle Cruise Control"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle) || !vehicle.uses_gear_transmission)
		return

	// Needed because the keybinding calls this directly, see cycle_gear_up()'s matching check.
	if(vehicle.get_mob_seat(user) != VEHICLE_DRIVER)
		return

	if(!vehicle.cruise_control_enabled && (vehicle.get_driver_vehicle_prefs() & VEHICLE_SIMPLE_ACCELERATION))
		to_chat(user, SPAN_WARNING("Cruise control isn't available with simple vehicle acceleration enabled."))
		return

	vehicle.cruise_control_enabled = !vehicle.cruise_control_enabled
	if(vehicle.cruise_control_enabled)
		vehicle.cruise_control_target_speed = vehicle.current_speed
		vehicle.start_momentum_decay_if_needed()
		// Drifting is only available with cruise control off, cancel one in progress instead of decaying it.
		vehicle.drift_speed = 0
		vehicle.drift_direction = 0
		to_chat(user, SPAN_NOTICE("Cruise control engaged, holding [round(vehicle.current_speed, 0.1)] tiles/s. Gas/brake now adjust the target speed."))
	else
		to_chat(user, SPAN_WARNING("Cruise control disengaged."))

//adjusts how much a single gas/brake press changes cruise control target speed, driver only.
/obj/vehicle/multitile/proc/set_cruise_control_granularity()
	set name = "Set Cruise Control Granularity"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle) || !vehicle.uses_gear_transmission)
		return

	var/new_granularity = input(user, "How much should each gas/brake press change the cruise control target speed by, in tiles/sec?", "Cruise Control Granularity", vehicle.cruise_control_granularity) as num|null
	if(isnull(new_granularity) || new_granularity <= 0)
		return
	if(vehicle.gear_stats && vehicle.gear_stats["D"] && new_granularity > vehicle.gear_stats["D"]["max_speed"])
		to_chat(user, SPAN_WARNING("That's more than the vehicle's top speed - pick something smaller."))
		return

	vehicle.cruise_control_granularity = new_granularity
	to_chat(user, SPAN_NOTICE("Cruise control granularity set to [new_granularity] tiles/s per press."))

//toggles the engine on/off, driver only. Off blocks driving and stops the engine sound loop.
/obj/vehicle/multitile/proc/toggle_engine(mob/toggler)
	set name = "Toggle Engine"
	set category = "Vehicle"

	var/mob/user = toggler || usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle) || !vehicle.uses_gear_transmission)
		return

	// Explicit seat check, an action button can call this directly unlike the driver-only verb list.
	if(vehicle.get_mob_seat(user) != VEHICLE_DRIVER)
		return

	if(world.time < vehicle.next_engine_toggle_time)
		to_chat(user, SPAN_WARNING("The ignition needs a moment to reset before you can toggle it again."))
		return

	// Only the starting transition needs gating, engine_on being TRUE already means a healthy engine.
	var/obj/item/hardpoint/engine/engine_hp = vehicle.get_engine_hardpoint()
	if(!vehicle.engine_on && (!engine_hp || engine_hp.health <= 0))
		to_chat(user, SPAN_WARNING("There's no working engine installed - the engine can't start."))
		return

	// A busted battery can't deliver power to the starter regardless of leftover current_charge.
	var/obj/item/hardpoint/battery/battery = vehicle.get_battery_hardpoint()
	if(!vehicle.engine_on && (!battery || battery.health <= 0))
		to_chat(user, SPAN_WARNING("There's no working battery installed - the engine can't start."))
		return

	if(!vehicle.engine_on && !vehicle.has_fuel())
		to_chat(user, SPAN_WARNING("There's no fuel - the engine can't start."))
		return

	vehicle.next_engine_toggle_time = world.time + 5 SECONDS
	vehicle.set_engine_on(!vehicle.engine_on)
	to_chat(user, SPAN_NOTICE("You [vehicle.engine_on ? "start" : "shut off"] the engine."))
	vehicle.refresh_hardpoint_actions()

//toggles the north blinker signal, driver only.
/obj/vehicle/multitile/proc/toggle_turn_signal_north()
	set name = "North Blinker Signal"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle) || !vehicle.uses_gear_transmission)
		return

	if(!(vehicle.turn_signal_flags & NORTH) && !vehicle.can_use_turn_signals())
		to_chat(user, SPAN_WARNING("The turn signals need a charged battery or a running engine."))
		return

	vehicle.toggle_turn_signal(NORTH)
	to_chat(user, SPAN_NOTICE("North blinker signal [(vehicle.turn_signal_flags & NORTH) ? "on" : "off"]."))

//toggles the south blinker signal, driver only.
/obj/vehicle/multitile/proc/toggle_turn_signal_south()
	set name = "South Blinker Signal"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle) || !vehicle.uses_gear_transmission)
		return

	if(!(vehicle.turn_signal_flags & SOUTH) && !vehicle.can_use_turn_signals())
		to_chat(user, SPAN_WARNING("The turn signals need a charged battery or a running engine."))
		return

	vehicle.toggle_turn_signal(SOUTH)
	to_chat(user, SPAN_NOTICE("South blinker signal [(vehicle.turn_signal_flags & SOUTH) ? "on" : "off"]."))

//toggles the east blinker signal, driver only.
/obj/vehicle/multitile/proc/toggle_turn_signal_east()
	set name = "East Blinker Signal"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle) || !vehicle.uses_gear_transmission)
		return

	if(!(vehicle.turn_signal_flags & EAST) && !vehicle.can_use_turn_signals())
		to_chat(user, SPAN_WARNING("The turn signals need a charged battery or a running engine."))
		return

	vehicle.toggle_turn_signal(EAST)
	to_chat(user, SPAN_NOTICE("East blinker signal [(vehicle.turn_signal_flags & EAST) ? "on" : "off"]."))

//toggles the west blinker signal, driver only.
/obj/vehicle/multitile/proc/toggle_turn_signal_west()
	set name = "West Blinker Signal"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/vehicle = user.interactee
	if(!istype(vehicle) || !vehicle.uses_gear_transmission)
		return

	if(!(vehicle.turn_signal_flags & WEST) && !vehicle.can_use_turn_signals())
		to_chat(user, SPAN_WARNING("The turn signals need a charged battery or a running engine."))
		return

	vehicle.toggle_turn_signal(WEST)
	to_chat(user, SPAN_NOTICE("West blinker signal [(vehicle.turn_signal_flags & WEST) ? "on" : "off"]."))

/obj/vehicle/multitile/proc/perform_honk()
	if(honk_sound)
		playsound(loc, honk_sound, 75, TRUE, 15) //heard within ~15 tiles

//Support gunner verbs

/obj/vehicle/multitile/proc/reload_firing_port_weapon()
	set name = "Reload Firing Port Weapon"
	set desc = "Initiates firing port weapon automated reload process."
	set category = "Vehicle"

	var/mob/user = usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	if(V.health < initial(V.health) * 0.5)
		to_chat(user, SPAN_WARNING("\The [V]'s hull is too damaged to operate!"))

	for(var/obj/item/hardpoint/special/firing_port_weapon/FPW in V.hardpoints)
		if(FPW.allowed_seat == seat)
			if(alert(user, "Initiate M56 FPW reload process? It will take [FPW.reload_time / 10] seconds.", "Initiate reload", "Yes", "No") == "Yes")
				FPW.start_auto_reload(user)
			return

	to_chat(user, SPAN_WARNING("Warning. No FPW for [seat] found, tell a dev!"))
