/atom/movable/screen/ghost
	icon = 'icons/mob/screen_ghost.dmi'

/atom/movable/screen/ghost/MouseEntered()
	flick(icon_state + "_anim", src)

/atom/movable/screen/attack_ghost(mob/dead/observer/user)
	Click()

/atom/movable/screen/ghost/follow_ghosts
	name = "Follow"
	icon_state = "follow_ghost"

/atom/movable/screen/ghost/follow_ghosts/Click()
	var/mob/dead/observer/G = usr
	G.follow()

/atom/movable/screen/ghost/minimap
	name = "Minimap"
	icon_state = "minimap"

/atom/movable/screen/ghost/minimap/Click()
	var/mob/dead/observer/ghost = usr

	ghost.minimap.action_activate()

/atom/movable/screen/ghost/reenter_corpse
	name = "Reenter corpse"
	icon_state = "reenter_corpse"

/atom/movable/screen/ghost/reenter_corpse/Click()
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/ghost/toggle_huds
	name = "Toggle HUDs"
	icon_state = "ghost_hud_toggle"

/atom/movable/screen/ghost/toggle_huds/Click()
	var/client/client = usr.client
	client.toggle_ghost_hud()

/atom/movable/screen/move_up
	icon = 'icons/mob/screen_ghost.dmi'
	icon_state = "move_up"

/atom/movable/screen/move_up/Click()
	var/mob/dead/observer/ghost = usr

	ghost.teleport_z_up()
	return

/atom/movable/screen/move_down
	icon = 'icons/mob/screen_ghost.dmi'
	icon_state = "move_down"

/atom/movable/screen/move_down/Click()
	var/mob/dead/observer/ghost = usr

	ghost.teleport_z_down()
	return

/datum/hud/ghost/New(mob/owner, ui_style='icons/mob/hud/human_white.dmi', ui_color, ui_alpha = 230)
	. = ..()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/ghost/follow_ghosts()
	using.screen_loc = ui_ghost_slot2
	static_inventory += using

	using = new /atom/movable/screen/ghost/minimap()
	using.screen_loc = ui_ghost_slot3
	static_inventory += using

	// using = new /atom/movable/screen/ghost/follow_human()
	// using.screen_loc = ui_ghost_slot3
	// static_inventory += using

	using = new /atom/movable/screen/ghost/reenter_corpse()
	using.screen_loc = ui_ghost_slot4
	static_inventory += using

	using = new /atom/movable/screen/ghost/toggle_huds()
	using.screen_loc = ui_ghost_slot5
	static_inventory += using

	// Using the same slot because they are two parts of the same slot
	using = new /atom/movable/screen/move_up()
	using.screen_loc = ui_ghost_slot6
	static_inventory += using

	using = new /atom/movable/screen/move_down()
	using.screen_loc = ui_ghost_slot6
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
