/atom/movable/screen/ghost
	icon = 'icons/mob/hud/cm_hud/cm_hud_ghost_objects.dmi'

/atom/movable/screen/ghost/MouseEntered()
	flick(icon_state + "_anim", src)

/atom/movable/screen/attack_ghost(mob/dead/observer/user)
	Click()

/atom/movable/screen/ghost/follow_ghosts
	name = "Follow"
	icon_state = "orbit"

/atom/movable/screen/ghost/follow_ghosts/Click()
	var/mob/dead/observer/G = usr
	G.follow()

/atom/movable/screen/ghost/reenter_corpse
	name = "Reenter corpse"
	icon_state = "return_to_body"

/atom/movable/screen/ghost/reenter_corpse/Click()
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/ghost/toggle_huds
	name = "Toggle HUDs"
	icon_state = "hud_prefs"

/atom/movable/screen/ghost/toggle_huds/Click()
	var/client/client = usr.client
	client.toggle_ghost_hud()

/atom/movable/screen/move_up
	icon = 'icons/mob/hud/cm_hud/cm_hud_ghost_objects.dmi'
	icon_state = "z_level_up"

/atom/movable/screen/move_up/Click()
	var/mob/dead/observer/ghost = usr

	ghost.teleport_z_up()
	return

/atom/movable/screen/move_down
	icon = 'icons/mob/hud/cm_hud/cm_hud_ghost_objects.dmi'
	icon_state = "z_level_down"

/atom/movable/screen/move_down/Click()
	var/mob/dead/observer/ghost = usr

	ghost.teleport_z_down()
	return

/datum/hud/ghost/New(mob/owner)
	. = ..()
	var/atom/movable/screen/using

	// using = new /atom/movable/screen/backhud/ghost()
	// using.screen_loc = ui_datum.ui_backhud
	// static_inventory += backhud

	using = new /atom/movable/screen/ghost/follow_ghosts()
	using.screen_loc = ui_ghost_slot2
	static_inventory += using

	// using = new /atom/movable/screen/ghost/follow_human()
	// using.screen_loc = ui_ghost_slot3
	// static_inventory += using

	using = new /atom/movable/screen/ghost/reenter_corpse()
	using.screen_loc = ui_ghost_slot3
	static_inventory += using

	using = new /atom/movable/screen/ghost/toggle_huds()
	using.screen_loc = ui_ghost_slot4
	static_inventory += using

	// Using the same slot because they are two parts of the same slot
	using = new /atom/movable/screen/move_up()
	using.screen_loc = ui_ghost_slot5
	static_inventory += using

	using = new /atom/movable/screen/move_down()
	using.screen_loc = ui_ghost_slot5
	static_inventory += using

/datum/hud/ghost/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observe_target_mob)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob

	if(!hud_shown)
		screenmob.client.remove_from_screen(static_inventory)
	else
		screenmob.client.add_to_screen(static_inventory)
