// Camera mob, used by AI camera.
/mob/camera
	name = "camera mob"
	density = FALSE
	status_flags = GODMODE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	see_in_dark = 7
	invisibility = INVISIBILITY_ABSTRACT // No one can see us
	sight = SEE_SELF
	move_on_shuttle = FALSE

/mob/camera/forceMove(atom/destination)
	var/old_loc = loc
	var/old_locs = locs
	loc = destination
	Moved(old_loc, old_locs, NONE, TRUE)

/mob/camera/drop_held_item()
	return

/mob/camera/emote(act, m_type, message, intentional = FALSE)
	return
