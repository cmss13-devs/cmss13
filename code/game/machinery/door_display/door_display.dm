///////////////////////////////////////////////////////////////////////////////////////////////
//  Parent of all door displays.
//  Description: This is a controls the timer for the brig doors, displays the timer on itself and
//    has a popup window when used, allowing to set the timer.
//  Code Notes: Combination of old brigdoor.dm code from rev4407 and the status_display.dm code
//  Date: 01/September/2010
//  Programmer: Veryinky
/////////////////////////////////////////////////////////////////////////////////////////////////
/obj/structure/machinery/door_display
	name = "Door Display"
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "frame"
	desc = "A remote control for a door."
	anchored = TRUE // can't pick it up
	density = FALSE // can walk through it.
	var/open = 0 // If door should be open.
	var/id = null // id of door it controls.
	var/picture_state // icon_state of alert picture, if not displaying text/numbers
	var/list/obj/structure/machinery/targets = list()
	var/uses_tgui = FALSE

	maptext_height = 26
	maptext_width = 32

/obj/structure/machinery/door_display/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door_display/LateInitialize()
	. = ..()
	get_targets()

/obj/structure/machinery/door_display/proc/get_targets()
	for(var/obj/structure/machinery/door/D in GLOB.machines)
		if (D.id == id)
			targets += D

	if(length(targets) == 0)
		stat |= BROKEN
	update_icon()


// has the door power situation changed, if so update icon.
/obj/structure/machinery/door_display/power_change()
	..()
	update_icon()
	return


// open/closedoor checks if door_display has power, if so it checks if the
// linked door is open/closed (by density) then opens it/closes it.

// Opens and locks doors, power check
/obj/structure/machinery/door_display/proc/open_door()
	if(inoperable()) return FALSE

	for(var/obj/structure/machinery/door/D in targets)
		if(!D.density) continue
		INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door, open))

	return TRUE


// Closes and unlocks doors, power check
/obj/structure/machinery/door_display/proc/close_door()
	if(inoperable()) return FALSE

	for(var/obj/structure/machinery/door/D in targets)
		if(D.density) continue
		INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door, close))

	return TRUE

// Allows AIs to use door_display, see human attack_hand function below
/obj/structure/machinery/door_display/attack_remote(mob/user as mob)
	return attack_hand(user)


// Allows humans to use door_display
// Opens dialog window when someone clicks on door timer
// Allows altering timer and the timing boolean.
/obj/structure/machinery/door_display/attack_hand(mob/user as mob)
	if(..())
		return

	if(!uses_tgui)
		user.set_interaction(src)
		show_browser(user, display_contents(user), name, "computer", "size=400x500")
	return

/obj/structure/machinery/door_display/proc/display_contents(mob/user as mob)
	var/data = "<HTML><BODY><TT>"

	data += "<HR>Linked Door:</hr>"
	data += " <b> [id]</b><br/>"

	// Open/Close Door
	if (open)
		data += "<a href='?src=\ref[src];open=0'>Close Door</a><br/>"
	else
		data += "<a href='?src=\ref[src];open=1'>Open Door</a><br/>"

	data += "<br/>"

	data += "<br/><a href='?src=\ref[user];mach_close=computer'>Close Display</a>"
	data += "</TT></BODY></HTML>"

	return data

// Function for using door_data dialog input, checks if user has permission
// href_list to
//  "open" open/close door
// Also updates dialog window and display icon.
/obj/structure/machinery/door_display/Topic(href, href_list)
	if(..())
		return FALSE
	if(!allowed(usr))
		return FALSE

	usr.set_interaction(src)

	if(href_list["open"])
		open = text2num(href_list["open"])

		if (open)
			open_door()
		else
			close_door()

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	src.update_icon()

	return TRUE


//icon update function
// if NOPOWER, display blank
// if BROKEN, display blue screen of death icon AI uses
/obj/structure/machinery/door_display/update_icon()
	if (stat & (NOPOWER))
		icon_state = "frame"
		return
	if (stat & (BROKEN))
		set_picture("ai_bsod")
		return

	var/display
	if (open)
		display = "OPEN"
	else
		display = "CLOSED"

	update_display(display)
	return


// Adds an icon in case the screen is broken/off, stolen from status_display.dm
/obj/structure/machinery/door_display/proc/set_picture(state)
	picture_state = state
	overlays.Cut()
	overlays += image('icons/obj/structures/machinery/status_display.dmi', icon_state = picture_state)


//Checks to see if there's 1 line or 2, adds text-icons-numbers/letters over display
// Stolen from status_display
/obj/structure/machinery/door_display/proc/update_display(text)
	var/new_text = {"<div style="font-size:'5pt'; color:'#09f'; font:'Arial Black'; text-align:center;" valign="top">[text]</div>"}
	if(maptext != new_text)
		maptext = new_text


//Actual string input to icon display for loop, with 5 pixel x offsets for each letter.
//Stolen from status_display
/obj/structure/machinery/door_display/proc/texticon(tn, px = 0, py = 0)
	var/image/I = image('icons/obj/structures/machinery/status_display.dmi', "blank")
	var/len = length(tn)

	for(var/d = 1 to len)
		var/char = copytext(tn, len-d+1, len-d+2)
		if(char == " ")
			continue
		var/image/ID = image('icons/obj/structures/machinery/status_display.dmi', icon_state = char)
		ID.pixel_x = -(d - 1) * 5 + px
		ID.pixel_y = py
		I.overlays += ID
	return I

//************ RESEARCH DOORS ****************\\
// Research cells have flashers and shutters/pod doors.
/obj/structure/machinery/door_display/research_cell
	var/open_shutter = FALSE
	var/has_wall_divider = FALSE
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "research"
	maptext = ""
	req_access = list(ACCESS_MARINE_RESEARCH)
	uses_tgui = TRUE

/obj/structure/machinery/door_display/research_cell/get_targets()
	..()
	for(var/obj/structure/machinery/flasher/F in GLOB.machines)
		if(F.id == id)
			targets += F
	if(has_wall_divider)
		for(var/turf/closed/wall/almayer/research/containment/wall/divide/W in ORANGE_TURFS(8, src))
			targets += W

/obj/structure/machinery/door_display/research_cell/Destroy()
	//Opening doors and shutters
	ion_act()
	return ..()

/obj/structure/machinery/door_display/research_cell/proc/ion_act()
	//Open the doors up to let the xenos out
	//Otherwise there isn't a way to get them out
	//And they deserve a rampage after being locked up for so long
	open_shutter(TRUE)
	open_door(TRUE)

/obj/structure/machinery/door_display/update_icon()
	return

// TGUI \\

/obj/structure/machinery/door_display/research_cell/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResearchDoorDisplay", "[src.name]")
		ui.open()

/obj/structure/machinery/door_display/research_cell/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/door_display/research_cell/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(!allowed(user))
		return UI_CLOSE

/obj/structure/machinery/door_display/research_cell/ui_static_data(mob/user)
	var/list/data = list()
	var/has_flash = FALSE

	if(locate(/obj/structure/machinery/flasher) in targets)
		has_flash = TRUE

	data["has_divider"] = has_wall_divider
	data["door_id"] = id
	data["has_flash"] = has_flash

	return data

/obj/structure/machinery/door_display/research_cell/ui_data(mob/user)
	var/list/data = list()
	var/flash_charging

	flash_charging = FALSE
	for(var/obj/structure/machinery/flasher/F in targets)
		if(F.last_flash && (F.last_flash + 150) > world.time)
			flash_charging = TRUE

	data["open_door"] = open
	data["open_shutter"] = open_shutter
	data["flash_charging"] = flash_charging

	return data

/obj/structure/machinery/door_display/research_cell/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("flash")
			for(var/obj/structure/machinery/flasher/F in targets)
				F.flash()
				. = TRUE

		if("divider")
			for(var/turf/closed/wall/almayer/research/containment/wall/divide/W in targets)
				if(W.density)
					W.open()
				else
					W.close()
				playsound(loc, 'sound/machines/elevator_openclose.ogg', 25, 1)
				. = TRUE

		if("shutter")
			if(!open_shutter)
				open_shutter()
			else
				close_door()
				close_shutter()
			. = TRUE

		if("door")
			if(!open)
				open_door()
			else
				close_door()
			. = TRUE

	add_fingerprint(usr)


/obj/structure/machinery/door_display/research_cell/attack_hand(mob/user)
	. = ..()
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied!"))

	tgui_interact(user)

// Opens and locks doors, power check
/obj/structure/machinery/door_display/research_cell/open_door(force = FALSE)
	if(inoperable() && !force)
		return FALSE

	for(var/obj/structure/machinery/door/airlock/D in targets)
		if(!D.density)
			continue
		D.unlock(force)
		D.open(force)
		open = TRUE

	return TRUE

// Closes and unlocks doors, power check
/obj/structure/machinery/door_display/research_cell/close_door()
	if(inoperable())
		return FALSE

	for(var/obj/structure/machinery/door/airlock/D in targets)
		if(D.density)
			continue
		D.close()
		D.lock()
		open = FALSE

	return TRUE

// Opens and locks doors, power check
/obj/structure/machinery/door_display/research_cell/proc/open_shutter(force = FALSE)
	if(inoperable() && !force)
		return FALSE

	for(var/obj/structure/machinery/door/poddoor/D in targets)
		if(D.stat & BROKEN)
			continue
		if(!D.density)
			continue
		D.open()
		open_shutter = TRUE
	return TRUE

// Closes and unlocks doors, power check
/obj/structure/machinery/door_display/research_cell/proc/close_shutter()
	if(inoperable())
		return FALSE

	for(var/obj/structure/machinery/door/poddoor/D in targets)
		if(D.stat & BROKEN)
			continue
		if(D.density)
			continue
		D.close()
		open_shutter = FALSE
	return TRUE
