#define APC_WIRE_MAIN_POWER 1
#define APC_WIRE_IDSCAN 2

#define APC_COVER_CLOSED 0
#define APC_COVER_OPEN 1
#define APC_COVER_REMOVED 2

//update_state
#define UPSTATE_CELL_IN 1
#define UPSTATE_OPENED1 2
#define UPSTATE_OPENED2 4
#define UPSTATE_MAINT 8
#define UPSTATE_BROKE 16
#define UPSTATE_BLUESCREEN 32
#define UPSTATE_WIREEXP 64
#define UPSTATE_ALLGOOD 128

//update_overlay
#define APC_UPOVERLAY_CHARGEING0 1
#define APC_UPOVERLAY_CHARGEING1 2
#define APC_UPOVERLAY_CHARGEING2 4
#define APC_UPOVERLAY_EQUIPMENT0 8
#define APC_UPOVERLAY_EQUIPMENT1 16
#define APC_UPOVERLAY_EQUIPMENT2 32
#define APC_UPOVERLAY_LIGHTING0 64
#define APC_UPOVERLAY_LIGHTING1 128
#define APC_UPOVERLAY_LIGHTING2 256
#define APC_UPOVERLAY_ENVIRON0 512
#define APC_UPOVERLAY_ENVIRON1 1024
#define APC_UPOVERLAY_ENVIRON2 2048
#define APC_UPOVERLAY_LOCKED 4096
#define APC_UPOVERLAY_OPERATING 8192

#define APC_UPDATE_ICON_COOLDOWN 100 //10 seconds


//The Area Power Controller (APC), formerly Power Distribution Unit (PDU)
//One per area, needs wire conection to power network

//Controls power to devices in that area
//May be opened to change power cell
//Three different channels (lighting/equipment/environ) - may each be set to on, off, or auto


//NOTE: STUFF STOLEN FROM AIRLOCK.DM thx
/obj/structure/machinery/power/apc/weak
	cell_type = /obj/item/cell

/obj/structure/machinery/power/apc/high
	cell_type = /obj/item/cell/high

/obj/structure/machinery/power/apc/super
	cell_type = /obj/item/cell/super

/obj/structure/machinery/power/apc/hyper
	cell_type = /obj/item/cell/hyper

/obj/structure/machinery/power/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "apc0"
	anchored = 1
	use_power = 0
	req_one_access = list(ACCESS_CIVILIAN_ENGINEERING, ACCESS_MARINE_ENGINEERING)
	unslashable = TRUE
	unacidable = TRUE

	var/area/area
	var/areastring = null

	var/obj/item/cell/cell
	var/start_charge = 90 //Initial cell charge %
	var/cell_type = /obj/item/cell/apc //0 = no cell, 1 = regular, 2 = high-cap (x5) <- old, now it's just 0 = no cell, otherwise dictate cellcapacity by changing this value. 1 used to be 1000, 2 was 2500

	var/opened = APC_COVER_CLOSED
	var/shorted = 0
	var/lighting = 3
	var/equipment = 3
	var/environ = 3
	var/operating = 1
	var/charging = 0
	var/chargemode = 1
	var/chargecount = 0
	var/locked = 1
	var/coverlocked = 1
	var/aidisabled = 0
	var/tdir = null
	var/obj/structure/machinery/power/terminal/terminal = null
	var/lastused_light = 0
	var/lastused_equip = 0
	var/lastused_environ = 0
	var/lastused_oneoff = 0
	var/lastused_total = 0
	var/main_status = 0

	var/wiresexposed = 0
	var/apcwires = 3

	powernet = 0 //Set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(
	var/debug = 0
	var/autoflag = 0 // 0 = off, 1 = eqp and lights off, 2 = eqp off, 3 = all on.
	var/has_electronics = 0 // 0 - none, 1 - plugged in, 2 - secured by screwdriver
	var/overload = 1 //Used for the Blackout malf module
	var/beenhit = 0 //Used for counting how many times it has been hit, used for Aliens at the moment
	var/longtermpower = 10
	var/update_state = -1
	var/update_overlay = -1
	var/global/status_overlays = 0
	var/updating_icon = 0
	var/crash_break_probability = 85 //Probability of APC being broken by a shuttle crash on the same z-level

	var/global/list/status_overlays_lock
	var/global/list/status_overlays_charging
	var/global/list/status_overlays_equipment
	var/global/list/status_overlays_lighting
	var/global/list/status_overlays_environ

	var/printout = FALSE
	power_machine = TRUE

	appearance_flags = TILE_BOUND

/obj/structure/machinery/power/apc/New(var/turf/loc, var/ndir, var/building=0)
	. = ..()

	//Offset 24 pixels in direction of dir
	//This allows the APC to be embedded in a wall, yet still inside an area

	if(building)
		dir = ndir

	set_pixel_location()

	if(building == 0)
		init()
	else
		area = loc.loc:master
		area.apc |= src
		opened = APC_COVER_OPEN
		operating = 0
		name = "\improper [area.name] APC"
		stat |= MAINT
		update_icon()
		add_timer(CALLBACK(src, .proc/update), 5)

	start_processing()

	sleep(0) //Break few ACPs on the colony

	if(!start_charge && z == 1 && prob(10))
		set_broken()

/obj/structure/machinery/power/apc/set_pixel_location()
	tdir = dir //To fix Vars bug
	dir = SOUTH

	pixel_x = (tdir & 3) ? 0 : (tdir == 4 ? 24 : -24)
	pixel_y = (tdir & 3) ? (tdir == 1 ? 24 : -24) : 0

/obj/structure/machinery/power/apc/Destroy()
	if(terminal)
		terminal.master = null
		terminal = null
	if(cell)
		qdel(cell)
		cell = null
	. = ..()

// the very fact that i have to override this screams to me that apcs shouldnt be under machinery - spookydonut
/obj/structure/machinery/power/apc/power_change()
	return

/obj/structure/machinery/power/apc/proc/make_terminal()
	//Create a terminal object at the same position as original turf loc
	//Wires will attach to this
	terminal = new/obj/structure/machinery/power/terminal(src.loc)
	terminal.dir = tdir
	terminal.master = src

/obj/structure/machinery/power/apc/proc/init()
	has_electronics = 2 //Installed and secured
	//Is starting with a power cell installed, create it and set its charge level
	if(cell_type)
		cell = new cell_type(src)
		cell.charge = start_charge * cell.maxcharge / 100.0 //Convert percentage to actual value

	var/area/A = loc.loc

	//If area isn't specified use current
	if(isarea(A) && src.areastring == null)
		area = A
		name = "\improper [area.name] APC"
	else
		area = get_area_name(areastring)
		name = "\improper [area.name] APC"

	area.apc |= src
	update_icon()
	make_terminal()

	add_timer(CALLBACK(src, .proc/update), 5)

/obj/structure/machinery/power/apc/examine(mob/user)
	to_chat(user, desc)
	if(stat & BROKEN)
		to_chat(user, SPAN_INFO("It appears to be completely broken. It's hard to see what else is wrong with it."))
		return
	if(opened)
		if(has_electronics && terminal)
			to_chat(user, SPAN_INFO("The cover is [opened == 2 ? "removed":"open"] and the power cell is [cell ? "installed":"missing"]."))
		else if (!has_electronics && terminal)
			to_chat(user, SPAN_INFO("There are some wires but no any electronics."))
		else if (has_electronics && !terminal)
			to_chat(user, SPAN_INFO("Electronics installed but not wired."))
		else
			to_chat(user, SPAN_INFO("There is no electronics nor connected wires."))

	else
		if(stat & MAINT)
			to_chat(user, SPAN_INFO("The cover is closed. Something is wrong with it, it doesn't work."))
		else
			to_chat(user, SPAN_INFO("The cover is closed."))

//Update the APC icon to show the three base states
//Also add overlays for indicator lights
/obj/structure/machinery/power/apc/update_icon()

	if(!status_overlays)
		status_overlays = 1
		status_overlays_lock = new
		status_overlays_charging = new
		status_overlays_equipment = new
		status_overlays_lighting = new
		status_overlays_environ = new

		status_overlays_lock.len = 2
		status_overlays_charging.len = 3
		status_overlays_equipment.len = 4
		status_overlays_lighting.len = 4
		status_overlays_environ.len = 4

		status_overlays_lock[1] = image(icon, "apcox-0") //0 = blue, 1 = red
		status_overlays_lock[2] = image(icon, "apcox-1")

		status_overlays_charging[1] = image(icon, "apco3-0")
		status_overlays_charging[2] = image(icon, "apco3-1")
		status_overlays_charging[3] = image(icon, "apco3-2")

		status_overlays_equipment[1] = image(icon, "apco0-0") //0 = red, 1 = green, 2 = blue
		status_overlays_equipment[2] = image(icon, "apco0-1")
		status_overlays_equipment[3] = image(icon, "apco0-2")
		status_overlays_equipment[4] = image(icon, "apco0-3")

		status_overlays_lighting[1] = image(icon, "apco1-0")
		status_overlays_lighting[2] = image(icon, "apco1-1")
		status_overlays_lighting[3] = image(icon, "apco1-2")
		status_overlays_lighting[4] = image(icon, "apco1-3")

		status_overlays_environ[1] = image(icon, "apco2-0")
		status_overlays_environ[2] = image(icon, "apco2-1")
		status_overlays_environ[3] = image(icon, "apco2-2")
		status_overlays_environ[4] = image(icon, "apco2-3")

	var/update = check_updates()	//Returns 0 if no need to update icons.
									//1 if we need to update the icon_state
									//2 if we need to update the overlays
	if(!update)
		return

	if(update & 1) //Updating the icon state
		if(update_state & UPSTATE_ALLGOOD)
			icon_state = "apc0"
		else if(update_state & (UPSTATE_OPENED1|UPSTATE_OPENED2))
			var/basestate = "apc[cell ? "2" : "1"]"
			if(update_state & UPSTATE_OPENED1)
				if(update_state & (UPSTATE_MAINT|UPSTATE_BROKE))
					icon_state = "apcmaint" //Disabled APC cannot hold cell
				else
					icon_state = basestate
			else if(update_state & UPSTATE_OPENED2)
				icon_state = "[basestate]-nocover"
		else if(update_state & UPSTATE_BROKE)
			icon_state = "apc-b"
		else if(update_state & UPSTATE_BLUESCREEN)
			icon_state = "apcemag"
		else if(update_state & UPSTATE_WIREEXP)
			icon_state = "apcewires"

	if(!(update_state & UPSTATE_ALLGOOD))
		if(overlays.len)
			overlays = 0
			return

	if(update & 2)

		if(overlays.len)
			overlays = 0

		if(!(stat & (BROKEN|MAINT)) && update_state & UPSTATE_ALLGOOD)
			overlays += status_overlays_lock[locked + 1]
			overlays += status_overlays_charging[charging + 1]
			if(operating)
				overlays += status_overlays_equipment[equipment + 1]
				overlays += status_overlays_lighting[lighting + 1]
				overlays += status_overlays_environ[environ + 1]

/obj/structure/machinery/power/apc/proc/check_updates()

	var/last_update_state = update_state
	var/last_update_overlay = update_overlay
	update_state = 0
	update_overlay = 0

	if(cell)
		update_state |= UPSTATE_CELL_IN
	if(stat & BROKEN)
		update_state |= UPSTATE_BROKE
	if(stat & MAINT)
		update_state |= UPSTATE_MAINT
	if(opened)
		if(opened == 1)
			update_state |= UPSTATE_OPENED1
		if(opened == 2)
			update_state |= UPSTATE_OPENED2
	else if(wiresexposed)
		update_state |= UPSTATE_WIREEXP
	if(update_state <= 1)
		update_state |= UPSTATE_ALLGOOD

	if(operating)
		update_overlay |= APC_UPOVERLAY_OPERATING

	if(update_state & UPSTATE_ALLGOOD)
		if(locked)
			update_overlay |= APC_UPOVERLAY_LOCKED

		if(!charging)
			update_overlay |= APC_UPOVERLAY_CHARGEING0
		else if(charging == 1)
			update_overlay |= APC_UPOVERLAY_CHARGEING1
		else if(charging == 2)
			update_overlay |= APC_UPOVERLAY_CHARGEING2

		if (!equipment)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT0
		else if(equipment == 1)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT1
		else if(equipment == 2)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT2

		if(!lighting)
			update_overlay |= APC_UPOVERLAY_LIGHTING0
		else if(lighting == 1)
			update_overlay |= APC_UPOVERLAY_LIGHTING1
		else if(lighting == 2)
			update_overlay |= APC_UPOVERLAY_LIGHTING2

		if(!environ)
			update_overlay |= APC_UPOVERLAY_ENVIRON0
		else if(environ == 1)
			update_overlay |= APC_UPOVERLAY_ENVIRON1
		else if(environ == 2)
			update_overlay |= APC_UPOVERLAY_ENVIRON2

	var/results = 0
	if(last_update_state == update_state && last_update_overlay == update_overlay)
		return 0
	if(last_update_state != update_state)
		results += 1
	if(last_update_overlay != update_overlay && update_overlay != 0)
		results += 2
	return results

/obj/structure/machinery/power/apc/proc/queue_icon_update()

	if(!updating_icon)
		updating_icon = 1
		//Start the update
		spawn(APC_UPDATE_ICON_COOLDOWN)
			update_icon()
			updating_icon = 0

//Attack with an item - open/close cover, insert cell, or (un)lock interface
/obj/structure/machinery/power/apc/attackby(obj/item/W, mob/user)

	if(isRemoteControlling(user) && get_dist(src, user) > 1)
		return attack_hand(user)
	add_fingerprint(user)
	if(iscrowbar(W) && opened)
		if(has_electronics == 1)
			if(user.action_busy) return
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no idea how to deconstruct [src]."))
				return
			if(terminal)
				to_chat(user, SPAN_WARNING("Disconnect the terminal first."))
				return
			playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] starts removing [src]'s power control board."),
			SPAN_NOTICE("You start removing [src]'s power control board.")) //lpeters - fixed grammar issues
			if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && has_electronics == 1)
				has_electronics = 0
				if((stat & BROKEN))
					user.visible_message(SPAN_NOTICE("[user] breaks [src]'s charred power control board and removes the remains."),
					SPAN_NOTICE("You break [src]'s charred power control board and remove the remains."))
				else
					user.visible_message(SPAN_NOTICE("[user] removes [src]'s power control board."),
					SPAN_NOTICE("You remove [src]'s power control board."))
					new /obj/item/circuitboard/apc(loc)
				raiseEvent(GLOBAL_EVENT, EVENT_APC_DISABLED + "\ref[user]", get_area(src))

		else if(opened != APC_COVER_REMOVED) //Cover isn't removed
			opened = APC_COVER_CLOSED
			update_icon()
	else if(iscrowbar(W) && !((stat & BROKEN)))
		if(coverlocked && !(stat & MAINT))
			to_chat(user, SPAN_WARNING("The cover is locked and cannot be opened."))
			return
		else
			opened = APC_COVER_OPEN
			update_icon()
	else if(istype(W, /obj/item/cell) && opened) //Trying to put a cell inside
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You have no idea how to fit [W] into [src]."))
			return
		if(cell)
			to_chat(user, SPAN_WARNING("There is a power cell already installed."))
			return
		else
			if(stat & MAINT)
				to_chat(user, SPAN_WARNING("There is no connector for your power cell."))
				return
			if(user.drop_inv_item_to_loc(W, src))
				cell = W
				user.visible_message(SPAN_NOTICE("[user] inserts [W] into [src]!"), \
					SPAN_NOTICE("You insert [W] into [src]!"))
				chargecount = 0
				update_icon()
	else if(isscrewdriver(W)) //Haxing
		if(opened)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("[src]'s wiring confuses you."))
				return
			if(cell)
				to_chat(user, SPAN_WARNING("Close the APC first.")) //Less hints more mystery!
				return
			else
				if(has_electronics == 1 && terminal)
					has_electronics = 2
					stat &= ~MAINT
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					user.visible_message(SPAN_NOTICE("[user] screws [src]'s circuit electronics into place."),
					SPAN_NOTICE("You screw [src]'s circuit electronics into place."))
				else if(has_electronics == 2)
					has_electronics = 1
					stat |= MAINT
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					user.visible_message(SPAN_NOTICE("[user] unfastens [src]'s circuit electronics."),
					SPAN_NOTICE("You unfasten [src]'s circuit electronics."))
				else
					to_chat(user, SPAN_WARNING("There is nothing to secure."))
					return
				update_icon()
		else
			wiresexposed = !wiresexposed
			user.visible_message(SPAN_NOTICE("[user] [wiresexposed ? "exposes" : "unexposes"] [src]'s wiring."),
			SPAN_NOTICE("You [wiresexposed ? "expose" : "unexpose"] [src]'s wiring."))
			update_icon()

	else if(istype(W, /obj/item/card/id)) //Trying to unlock the interface with an ID card
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You're not sure where to swipe [W] on [src]."))
			return
		if(opened)
			to_chat(user, SPAN_WARNING("You must close the cover to swipe an ID card."))
		else if(wiresexposed)
			to_chat(user, SPAN_WARNING("You must close the panel."))
		else if(stat & (BROKEN|MAINT))
			to_chat(user, SPAN_WARNING("Nothing happens."))
		else
			if(allowed(usr))
				locked = !locked
				user.visible_message(SPAN_NOTICE("[user] [locked ? "locks" : "unlocks"] [src]'s interface."),
				SPAN_NOTICE("You [locked ? "lock" : "unlock"] [src]'s interface."))
				update_icon()
			else
				to_chat(user, SPAN_WARNING("Access denied."))
	else if(iswire(W) && !terminal && opened && has_electronics != 2)
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You have no idea what to do with [src]."))
			return
		if(loc:intact_tile)
			to_chat(user, SPAN_WARNING("You must remove the floor plating in front of the APC first."))
			return
		var/obj/item/stack/cable_coil/C = W
		if(C.get_amount() < 10)
			to_chat(user, SPAN_WARNING("You need more wires."))
			return
		user.visible_message(SPAN_NOTICE("[user] starts wiring [src]'s frame."),
		SPAN_NOTICE("You start wiring [src]'s frame."))
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
		if(do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && !terminal && opened && has_electronics != 2)
			var/turf/T = get_turf(src)
			var/obj/structure/cable/N = T.get_cable_node()
			if(prob(50) && electrocute_mob(usr, N, N))
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				return
			if(C.use(10))
				user.visible_message(SPAN_NOTICE("[user] wires [src]'s frame."),
				SPAN_NOTICE("You wire [src]'s frame."))
				make_terminal()
				terminal.connect_to_network()
	else if(iswirecutter(W) && terminal && opened && has_electronics != 2)
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You have no idea what to do with [W]."))
			return
		if(loc:intact_tile)
			to_chat(user, SPAN_WARNING("You must remove the floor plating in front of the APC first."))
			return
		user.visible_message(SPAN_NOTICE("[user] starts removing [src]'s wiring and terminal."),
		SPAN_NOTICE("You start removing [src]'s wiring and terminal."))
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!terminal)
				to_chat(user, SPAN_WARNING("The [src] lacks a terminal to be removed."))
				return
			if (prob(50) && electrocute_mob(user, terminal.powernet, terminal))
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				return
			new /obj/item/stack/cable_coil(loc,10)
			user.visible_message(SPAN_NOTICE("[user] removes [src]'s wiring and terminal."),
			SPAN_NOTICE("You remove [src]'s wiring and terminal."))
			qdel(terminal)
			terminal = null
	else if(istype(W, /obj/item/circuitboard/apc) && opened && has_electronics == 0 && !(stat & BROKEN))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You have no idea what to do with [W]."))
			return
		user.visible_message(SPAN_NOTICE("[user] starts inserting the power control board into [src]."),
		SPAN_NOTICE("You start inserting the power control board into [src]."))
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
		if(do_after(user, 15, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			has_electronics = 1
			user.visible_message(SPAN_NOTICE("[user] inserts the power control board into [src]."),
			SPAN_NOTICE("You insert the power control board into [src]."))
			qdel(W)
	else if(istype(W, /obj/item/circuitboard/apc) && opened && has_electronics == 0 && (stat & BROKEN))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You have no idea what to do with [W]."))
			return
		to_chat(user, SPAN_WARNING("You cannot put the board inside, the frame is damaged."))
		return
	else if(iswelder(W) && opened && has_electronics == 0 && !terminal)
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You have no idea what to do with [W]."))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(WT.get_fuel() < 3)
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return
		user.visible_message(SPAN_NOTICE("[user] starts welding [src]'s frame."),
		SPAN_NOTICE("You start welding [src]'s frame."))
		playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!src || !WT.remove_fuel(3, user)) return
			if((stat & BROKEN) || opened == 2)
				new /obj/item/stack/sheet/metal(loc)
				user.visible_message(SPAN_NOTICE("[user] welds [src]'s frame apart."),
				SPAN_NOTICE("You weld [src]'s frame apart."))
			else
				new /obj/item/frame/apc(loc)
				user.visible_message(SPAN_NOTICE("[user] welds [src]'s frame off the wall."),
				SPAN_NOTICE("You weld [src]'s frame off the wall."))
			qdel(src)
			return
	else if(istype(W, /obj/item/frame/apc) && opened && (stat & BROKEN))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You have no idea what to do with [W]."))
			return
		if(has_electronics)
			to_chat(user, SPAN_WARNING("You cannot repair this APC until you remove the electronics still inside."))
			return
		user.visible_message(SPAN_NOTICE("[user] begins replacing [src]'s damaged frontal panel with a new one."),
		SPAN_NOTICE("You begin replacing [src]'s damaged frontal panel with a new one."))
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user] replaces [src]'s damaged frontal panel with a new one."),
			SPAN_NOTICE("You replace [src]'s damaged frontal panel with a new one."))
			user.count_niche_stat(STATISTICS_NICHE_REPAIR_APC)
			qdel(W)
			stat &= ~BROKEN
			if(opened == 2)
				opened = APC_COVER_OPEN
			update_icon()
	else
		if(((stat & BROKEN)) && !opened && W.force >= 5)
			opened = APC_COVER_REMOVED
			user.visible_message(SPAN_WARNING("[user] knocks down [src]'s cover with [W]!"), \
				SPAN_WARNING("You knock down [src]'s cover with [W]!"))
			update_icon()
		else
			if(isRemoteControlling(user))
				return attack_hand(user)
			if(!opened && wiresexposed && (ismultitool(W) || iswirecutter(W)))
				return attack_hand(user)
			user.visible_message(SPAN_DANGER("[user] hits [src] with [W]!"), \
			SPAN_DANGER("You hit [src] with [W]!"))

//Attack with hand - remove cell (if cover open) or interact with the APC
/obj/structure/machinery/power/apc/attack_hand(mob/user)

	if(!user)
		return

	add_fingerprint(user)

	//Human mob special interaction goes here.
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(H.species.flags & IS_SYNTHETIC && H.a_intent == INTENT_GRAB)
			if(H.action_busy)
				return

			if(!do_after(H, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				return

			playsound(src.loc, 'sound/effects/sparks2.ogg', 25, 1)

			if(stat & BROKEN)
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(3, 1, src)
				s.start()
				to_chat(H, SPAN_DANGER("The APC's power currents surge eratically, damaging your chassis!"))
				H.apply_damage(10,0, BURN)
			else if(cell && cell.charge > 0)
				if(!istype(H.back, /obj/item/storage/backpack/marine/smartpack))
					return

				var/obj/item/storage/backpack/marine/smartpack/S = H.back
				if(S.battery_charge < SMARTPACK_MAX_POWER_STORED)
					cell.charge -= SMARTPACK_MAX_POWER_STORED
					S.battery_charge = SMARTPACK_MAX_POWER_STORED
					to_chat(user, SPAN_NOTICE("You slot your fingers into the APC interface and siphon off some of the stored charge. [S.name] now has [S.battery_charge]/[SMARTPACK_MAX_POWER_STORED]"))
					charging = 1
				else
					to_chat(user, SPAN_WARNING("[S.name] is already fully charged."))
			else
				to_chat(user, SPAN_WARNING("There is no charge to draw from that APC."))
			return
		else if(H.species.can_shred(H))
			user.visible_message(SPAN_WARNING("[user.name] slashes [src]!"),
			SPAN_WARNING("You slash [src]!"))
			playsound(src.loc, 'sound/weapons/slash.ogg', 25, 1)
			var/allcut = 1
			for(var/wire = 1; wire < length(get_wire_descriptions()); wire++)
				if(!isWireCut(wire))
					allcut = 0
					break
			if(beenhit >= pick(3, 4) && wiresexposed != 1)
				wiresexposed = 1
				update_icon()
				visible_message(SPAN_WARNING("[src]'s cover flies open, exposing the wires!"))

			else if(wiresexposed == 1 && allcut == 0)
				for(var/wire = 1; wire < length(get_wire_descriptions()); wire++)
					cut(wire)
				update_icon()
				visible_message(SPAN_WARNING("[src]'s wires are shredded!"))
			else
				beenhit += 1
			return


	if(usr == user && opened && (!isRemoteControlling(user)))
		if(cell)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no idea how to remove the power cell from [src]."))
				return
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell.updateicon()

			src.cell = null
			user.visible_message(SPAN_NOTICE("[user] removes the power cell from [src]!"),
			SPAN_NOTICE("You remove the power cell from [src]."))
			charging = 0
			update_icon()
			raiseEvent(GLOBAL_EVENT, EVENT_APC_DISABLED + "\ref[user]", get_area(src))
		return
	if(stat & (BROKEN|MAINT))
		return

	ui_interact(user)

/obj/structure/machinery/power/apc/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)
	if(!user)
		return

	var/list/data = list(
		"locked" = locked,
		"wiresExposed" = wiresexposed,
		"isOperating" = operating,
		"externalPower" = main_status,
		"powerCellStatus" = cell ? cell.percent() : null,
		"chargeMode" = chargemode,
		"chargingStatus" = charging,
		"totalLoad" = round(lastused_total),
		"coverLocked" = coverlocked,
		"siliconUser" = isRemoteControlling(user),

		"powerChannels" = list(
			list(
				"title" = "Equipment",
				"powerLoad" = round(lastused_equip),
				"status" = equipment,
				"topicParams" = list(
					"auto" = list("eqp" = 3),
					"on"   = list("eqp" = 2),
					"off"  = list("eqp" = 1)
				)
			),
			list(
				"title" = "Lighting",
				"powerLoad" = round(lastused_light),
				"status" = lighting,
				"topicParams" = list(
					"auto" = list("lgt" = 3),
					"on"   = list("lgt" = 2),
					"off"  = list("lgt" = 1)
				)
			),
			list(
				"title" = "Environment",
				"powerLoad" = round(lastused_environ),
				"status" = environ,
				"topicParams" = list(
					"auto" = list("env" = 3),
					"on"   = list("env" = 2),
					"off"  = list("env" = 1)
				)
			)
		),

		"wires" = null
	)

	var/list/wire_descriptions = get_wire_descriptions()
	var/list/panel_wires = list()
	for(var/wire = 1 to wire_descriptions.len)
		panel_wires += list(list("desc" = wire_descriptions[wire], "cut" = isWireCut(wire)))

	if(panel_wires.len)
		data["wires"] = panel_wires

	//Update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		//The ui does not exist, so we'll create a new() one
        //For a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "apc.tmpl", "[area.name] - APC", 520, data["siliconUser"] ? 465 : 440)
		//When the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		//Open the new ui window
		ui.open()
		//Auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/structure/machinery/power/apc/proc/report()
	return "[area.name] : [equipment]/[lighting]/[environ] ([lastused_total]) : [cell? cell.percent() : "N/C"] ([charging])"

/obj/structure/machinery/power/apc/proc/update()
	if(operating && !shorted)
		area.update_power_channels((equipment > 1), (lighting > 1), (environ > 1))
	else
		area.update_power_channels(FALSE, FALSE, FALSE)

/obj/structure/machinery/power/apc/proc/get_wire_descriptions()
	return list(
		APC_WIRE_MAIN_POWER   = "Main power",
		APC_WIRE_IDSCAN       = "ID scanner"
	)

/obj/structure/machinery/power/apc/proc/isWireCut(var/wire)
	var/wireFlag = getWireFlag(wire)
	return !(apcwires & wireFlag)

/obj/structure/machinery/power/apc/proc/cut(var/wire, var/user)
	apcwires ^= getWireFlag(wire)

	switch(wire)
		if(APC_WIRE_MAIN_POWER)
			shock(usr, 50)
			shorted = 1
			visible_message(SPAN_WARNING("\The [src] begins flashing error messages wildly!"))
			if(ishuman(user))
				raiseEvent(GLOBAL_EVENT, EVENT_APC_DISABLED + "\ref[user]", get_area(src))
		if(APC_WIRE_IDSCAN)
			locked = 0
			visible_message(SPAN_NOTICE("\The [src] emits a click."))
	if(isXeno(usr)) //So aliens don't see this when they cut all of the wires.
		return

/obj/structure/machinery/power/apc/proc/mend(var/wire)
	apcwires |= getWireFlag(wire)

	switch(wire)
		if(APC_WIRE_MAIN_POWER)
			if(!isWireCut(APC_WIRE_MAIN_POWER))
				shorted = 0
				shock(usr, 50)

		if(APC_WIRE_IDSCAN)
			locked = 1
			visible_message(SPAN_NOTICE("\The [src] emits a slight thunk."))

/obj/structure/machinery/power/apc/proc/pulse(var/wire, var/user)
	switch(wire)
		if(APC_WIRE_IDSCAN) //Unlocks the APC for 30 seconds, if you have a better way to hack an APC I'm all ears
			locked = 0
			visible_message(SPAN_NOTICE("\The [src] emits a click."))
			spawn(SECONDS_30)
				locked = 1
				visible_message(SPAN_NOTICE("\The [src] emits a slight thunk."))

		if(APC_WIRE_MAIN_POWER)
			if(shorted == 0)
				shorted = 1
				visible_message(SPAN_WARNING("\The [src] begins flashing error messages wildly!"))
				if(ishuman(user))
					raiseEvent(GLOBAL_EVENT, EVENT_APC_DISABLED + "\ref[user]", get_area(src))
			spawn(1200)
				if(shorted == 1)
					shorted = 0

/obj/structure/machinery/power/apc/proc/can_use(mob/user as mob, var/loud = 0) //used by attack_hand() and Topic()
	if(user.client && user.client.remote_control)
		return TRUE

	if(user.stat)
		to_chat(user, SPAN_WARNING("You must be conscious to use [src]!"))
		return 0
	if(!user.client)
		return 0
	if(!(ishuman(user) || isRemoteControlling(user)))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to use [src]!"))
		nanomanager.close_user_uis(user, src)
		return 0
	if(user.is_mob_restrained())
		to_chat(user, SPAN_WARNING("You must have free hands to use [src]."))
		return 0
	if(user.lying)
		to_chat(user, SPAN_WARNING("You can't reach [src]!"))
		return 0
	autoflag = 5
	if(isRemoteControlling(user))
		if(aidisabled)
			if(!loud)
				to_chat(user, SPAN_WARNING("[src] has AI control disabled!"))
				nanomanager.close_user_uis(user, src)
			return 0
	else
		if((!in_range(src, user) || !istype(src.loc, /turf)))
			nanomanager.close_user_uis(user, src)
			return 0

	var/mob/living/carbon/human/H = user
	if(istype(H))
		if(H.getBrainLoss() >= 60)
			for(var/mob/M in viewers(src, null))
				H.visible_message(SPAN_WARNING("[H] stares cluelessly at [src] and drools."),
				SPAN_WARNING("You stare cluelessly at [src] and drool."))
			return 0
		else if(prob(H.getBrainLoss()))
			to_chat(user, SPAN_WARNING("You momentarily forget how to use [src]."))
			return 0
	return 1

/obj/structure/machinery/power/apc/Topic(href, href_list, var/usingUI = 1)
	if(!(isrobot(usr) && (href_list["apcwires"] || href_list["pulse"])))
		if(!can_use(usr, 1))
			return 0
	add_fingerprint(usr)
	if(ishuman(usr) && !skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(usr, SPAN_WARNING("You don't know how to use [src]'s interface."))
		return

	if(href_list["apcwire"])
		var/wire = text2num(href_list["apcwire"])

		if(!iswirecutter(usr.get_active_hand()))
			to_chat(usr, SPAN_WARNING("You need wirecutters!"))
			return 0

		if(isWireCut(wire))
			mend(wire)
		else
			cut(wire, usr)

	else if(href_list["pulse"])
		var/wire = text2num(href_list["pulse"])

		if(!ismultitool(usr.get_active_hand()))
			to_chat(usr, SPAN_WARNING("You need a multitool!"))
			return 0

		if(isWireCut(wire))
			to_chat(usr, SPAN_WARNING("You can't pulse a cut wire."))
			return 0
		else
			pulse(wire, usr)

	else if(href_list["lock"])
		coverlocked = !coverlocked

	else if(href_list["breaker"])
		operating = !operating
		update()
		update_icon()

	else if(href_list["cmode"])
		chargemode = !chargemode
		if(!chargemode)
			charging = 0
			update_icon()

	else if(href_list["eqp"])
		var/val = text2num(href_list["eqp"])
		equipment = (val == 1) ? 0 : val
		update_icon()
		update()

	else if (href_list["lgt"])
		var/val = text2num(href_list["lgt"])
		lighting = (val == 1) ? 0 : val
		update_icon()
		update()

	else if (href_list["env"])
		var/val = text2num(href_list["env"])
		environ = (val == 1) ? 0 :val
		update_icon()
		update()

	else if( href_list["close"] )
		nanomanager.close_user_uis(usr, src)
		return 0

	else if (href_list["close2"])
		close_browser(usr, "apcwires")
		return 0

	else if(href_list["overload"])
		if(isRemoteControlling(usr) && !aidisabled)
			overload_lighting()

	return 1

/obj/structure/machinery/power/apc/proc/ion_act()
	//intended to be a bit like an emag
	if(prob(3))
		locked = 0
		if(cell.charge > 0)
			cell.charge = 0
			update_icon()
			var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread()
			smoke.set_up(1, 0, loc)
			smoke.attach(src)
			smoke.start()
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(1, 1, src)
			s.start()
			visible_message(SPAN_WARNING("[src] suddenly lets out a blast of smoke and some sparks!"))

/obj/structure/machinery/power/apc/surplus()
	if(terminal)
		return terminal.surplus()
	else
		return 0

/obj/structure/machinery/power/apc/proc/last_surplus()
	if(terminal && terminal.powernet)
		return terminal.powernet.last_surplus()
	else
		return 0

//Returns 1 if the APC should attempt to charge
/obj/structure/machinery/power/apc/proc/attempt_charging()
	return (chargemode && charging == 1 && operating)

/obj/structure/machinery/power/apc/add_load(var/amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0

/obj/structure/machinery/power/apc/avail()
	if(terminal)
		return terminal.avail()
	else
		return 0

/obj/structure/machinery/power/apc/process()
	if(stat & (BROKEN|MAINT))
		return
	if(!area.requires_power)
		return

	lastused_light = area.usage(POWER_CHANNEL_LIGHT)
	lastused_equip = area.usage(POWER_CHANNEL_EQUIP)
	lastused_environ = area.usage(POWER_CHANNEL_ENVIRON)
	lastused_oneoff = area.usage(POWER_CHANNEL_ONEOFF, TRUE) //getting the one-off power usage and resetting it to 0 for the next processing tick
	lastused_total = lastused_light + lastused_equip + lastused_environ + lastused_oneoff

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()
	var/power_excess = 0

	var/perapc = 0
	if(terminal && terminal.powernet)
		perapc = terminal.powernet.perapc

	if(debug)
		log_debug( "Status: [main_status] - Excess: [excess] - Last Equip: [lastused_equip] - Last Light: [lastused_light]")

	if(cell && !shorted)
		var/cell_maxcharge = cell.maxcharge

		//Calculate how much power the APC will try to get from the grid.
		var/target_draw = lastused_total
		if(attempt_charging())
			target_draw += min((cell_maxcharge - cell.charge), (cell_maxcharge * CHARGELEVEL))/CELLRATE
		target_draw = min(target_draw, perapc) //Limit power draw by perapc

		//Try to draw power from the grid
		var/power_drawn = 0
		if(avail())
			power_drawn = add_load(target_draw) //Get some power from the powernet

		//Figure out how much power is left over after meeting demand
		power_excess = power_drawn - lastused_total

		if(power_excess < 0) //Couldn't get enough power from the grid, we will need to take from the power cell.

			charging = 0

			var/required_power = -power_excess
			if(cell.charge >= required_power * CELLRATE) //Can we draw enough from cell to cover what's left over?
				cell.use(required_power * CELLRATE)

			else if (autoflag != 0)	//Not enough power available to run the last tick!
				chargecount = 0
				//This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)
				autoflag = 0

		//Set external power status
		if(!power_drawn)
			main_status = 0
		else if(power_excess < 0)
			main_status = 1
		else
			main_status = 2

		//Set channels depending on how much charge we have left
		// Allow the APC to operate as normal if the cell can charge
		if(charging && longtermpower < 10)
			longtermpower += 1
		else if(longtermpower > -10)
			longtermpower -= 2


		if(cell.charge >= 1250 || longtermpower > 0) //Put most likely at the top so we don't check it last, effeciency 101
			if(autoflag != 3)
				equipment = autoset(equipment, 1)
				lighting = autoset(lighting, 1)
				environ = autoset(environ, 1)
				autoflag = 3
				area.poweralert(1, src)
				if(cell.charge >= 4000)
					area.poweralert(1, src)
		else if(cell.charge < 1250 && cell.charge > 750 && longtermpower < 0) //<30%, turn off equipment
			if(autoflag != 2)
				equipment = autoset(equipment, 2)
				lighting = autoset(lighting, 1)
				environ = autoset(environ, 1)
				area.poweralert(0, src)
				autoflag = 2
		else if(cell.charge < 750 && cell.charge > 10) //<15%, turn off lighting & equipment
			if((autoflag > 1 && longtermpower < 0) || (autoflag > 1 && longtermpower >= 0))
				equipment = autoset(equipment, 2)
				lighting = autoset(lighting, 2)
				environ = autoset(environ, 1)
				area.poweralert(0, src)
				autoflag = 1
		else if(cell.charge <= 0) //Zero charge, turn all off
			if(autoflag != 0)
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)
				area.poweralert(0, src)
				autoflag = 0

		//Now trickle-charge the cell
		if(attempt_charging())
			if(power_excess > 0) //Check to make sure we have enough to charge
				cell.give(power_excess * CELLRATE) //Actually recharge the cell
			else
				charging = 0 //Stop charging
				chargecount = 0

		//Show cell as fully charged if so
		if(cell.charge >= cell_maxcharge)
			charging = 2

		//If we have excess power for long enough, think about re-enable charging.
		if(chargemode)
			if(!charging)
				//last_surplus() overestimates the amount of power available for charging, but it's equivalent to what APCs were doing before.
				if(last_surplus() * CELLRATE >= cell_maxcharge * CHARGELEVEL)
					chargecount++
				else
					chargecount = 0
					charging = 0

				if(chargecount >= 10)
					chargecount = 0
					charging = 1

		else //Chargemode off
			charging = 0
			chargecount = 0

	else //No cell, switch everything off
		charging = 0
		chargecount = 0
		equipment = autoset(equipment, 0)
		lighting = autoset(lighting, 0)
		environ = autoset(environ, 0)
		area.poweralert(0, src)
		autoflag = 0

	//Update icon & area power if anything changed

	if(last_lt != lighting || last_eq != equipment || last_en != environ)
		queue_icon_update()
		update()
	else if (last_ch != charging)
		queue_icon_update()

//val 0 = off, 1 = off(auto) 2 = on, 3 = on(auto)
//on 0 = off, 1 = auto-on, 2 = auto-off

/proc/autoset(var/val, var/on)

	if(on == 0) //Turn things off
		if(val == 2) //If on, return off
			return 0
		else if(val == 3) //If auto-on, return auto-off
			return 1

	else if(on == 1) //Turn things auto-on
		if(val == 1) //If auto-off, return auto-on
			return 3

	else if(on == 2) //Turn things auto-off
		if(val == 3) //If auto-on, return auto-off
			return 1
	return val

//Damage and destruction acts
/obj/structure/machinery/power/apc/emp_act(severity)
	if(cell)
		cell.emp_act(severity)
	lighting = 0
	equipment = 0
	environ = 0
	spawn(MINUTES_1)
		equipment = 3
		environ = 3
	..()

/obj/structure/machinery/power/apc/ex_act(severity)

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				set_broken()
				if(cell && prob(25))
					cell.ex_act(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				set_broken()
				if(cell && prob(50))
					cell.ex_act(severity)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if(cell)
				cell.ex_act(severity) //More lags woohoo
			qdel(src)
			return

/obj/structure/machinery/power/apc/proc/set_broken()

	//Aesthetically much better!
	visible_message(SPAN_WARNING("[src]'s screen flickers with warnings briefly!"))
	spawn(rand(2, 5))
		visible_message(SPAN_DANGER("[src]'s screen suddenly explodes in rain of sparks and small debris!"))
		stat |= BROKEN
		operating = 0
		update_icon()
		update()

//Overload all the lights in this APC area
/obj/structure/machinery/power/apc/proc/overload_lighting()
	if(!operating || shorted)
		return
	if(cell && cell.charge >= 20)
		cell.use(20)
		spawn(0)
			for(var/area/A in area.related)
				for(var/obj/structure/machinery/light/L in A)
					L.on = 1
					L.broken()
					sleep(1)

/obj/structure/machinery/power/apc/Destroy()
	area.power_light = 0
	area.power_equip = 0
	area.power_environ = 0
	area.power_change()
	. = ..()

/obj/structure/machinery/power/apc/antag
	cell_type = /obj/item/cell/apc/full
	req_one_access = list(ACCESS_ILLEGAL_PIRATE)


//------Almayer APCs ------//

/obj/structure/machinery/power/apc/almayer
	cell_type = /obj/item/cell/high

/obj/structure/machinery/power/apc/almayer/hardened
	name = "hardened area power controller"
	desc = "A control terminal for the area electrical systems. This one is hardened against sudden power fluctuations caused by electrical grid damage."
	crash_break_probability = 0





#undef APC_UPDATE_ICON_COOLDOWN
