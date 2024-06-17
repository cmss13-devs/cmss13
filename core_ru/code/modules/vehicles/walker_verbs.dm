/obj/vehicle/walker/verb/enter_walker()
	set category = "Object"
	set name = "Enter Into Walker"
	set src in oview(1)

	if(usr.skills.get_skill_level(SKILL_POWERLOADER) >= SKILL_POWERLOADER_TRAINED)
		move_in(usr)
	else
		to_chat(usr, "How to operate it?")

/obj/vehicle/walker/verb/get_out()
	set name = "Eject"
	set category = "Vehicle"
	set hidden = FALSE
	set src in range(0)

	move_out()

/obj/vehicle/walker/verb/toggle_lights()
	set name = "Lights on/off"
	set category = "Vehicle"
	set src in range(0)

	lights()

/obj/vehicle/walker/verb/eject_magazines()
	set name = "Deploy Magazine"
	set category = "Vehicle"
	set src in range(0)

	deploy_magazine()

/obj/vehicle/walker/verb/get_stats()
	set name = "Status Display"
	set category = "Vehicle"
	set src in range(0)

	tgui_interact(usr)

/obj/vehicle/walker/verb/select_weapon()
	set name = "Select Weapon"
	set category = "Vehicle"
	set src in range(0)

	cycle_weapons()

/obj/vehicle/walker/verb/toggle_zoom()
	set name = "Zoom on/off"
	set category = "Vehicle"
	set src in range(0)

	zoom_activate()
