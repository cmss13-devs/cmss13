/atom/movable/screen/plane_master
	screen_loc = "CENTER"
	icon_state = "blank"
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	plane = LOWEST_EVER_PLANE
	var/show_alpha = 255
	var/hide_alpha = 0

	//--rendering relay vars--
	///integer: what plane we will relay this planes render to
	var/render_relay_plane = RENDER_PLANE_GAME
	///bool: Whether this plane should get a render target automatically generated
	var/generate_render_target = TRUE
	///integer: blend mode to apply to the render relay in case you dont want to use the plane_masters blend_mode
	var/blend_mode_override
	///reference: current relay this plane is utilizing to render
	var/obj/render_plane_relay/relay

/atom/movable/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/atom/movable/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

//Why do plane masters need a backdrop sometimes? Read https://secure.byond.com/forum/?post=2141928
//Trust me, you need one. Period. If you don't think you do, you're doing something extremely wrong.
/atom/movable/screen/plane_master/proc/backdrop(mob/mymob)
	SHOULD_CALL_PARENT(TRUE)
	if(!isnull(render_relay_plane))
		relay_render_to_plane(mymob, render_relay_plane)

/atom/movable/screen/plane_master/floor
	name = "floor plane master"
	plane = FLOOR_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY

///Contains most things in the game world
/atom/movable/screen/plane_master/game_world
	name = "game world plane master"
	plane = GAME_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/game_world/backdrop(mob/mymob)
	. = ..()
	remove_filter("AO")
	if(istype(mymob) && mymob?.client?.prefs?.toggle_prefs & TOGGLE_AMBIENT_OCCLUSION)
		add_filter("AO", 1, drop_shadow_filter(x = 0, y = -2, size = 4, color = "#04080FAA"))

/atom/movable/screen/plane_master/ghost
	name = "ghost plane master"
	plane = GHOST_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_NON_GAME

/**
 * Plane master handling byond internal blackness
 * vars are set as to replicate behavior when rendering to other planes
 * do not touch this unless you know what you are doing
 */
/atom/movable/screen/plane_master/blackness
	name = "darkness plane master"
	plane = BLACKNESS_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE
//byond internal end

///Contains all lighting objects
/atom/movable/screen/plane_master/lighting
	name = "lighting plane master"
	plane = LIGHTING_PLANE
	blend_mode_override = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/plane_master/lighting/exterior
	name = "exterior lighting plane master"
	plane = EXTERIOR_LIGHTING_PLANE

/atom/movable/screen/plane_master/runechat
	name = "runechat plane master"
	plane = RUNECHAT_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/runechat/backdrop(mob/mymob)
	. = ..()
	remove_filter("AO")
	add_filter("AO", 1, drop_shadow_filter(x = 0, y = -2, size = 4, color = "#04080FAA"))

/atom/movable/screen/plane_master/fullscreen
	name = "fullscreen alert plane"
	plane = FULLSCREEN_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/plane_master/hud
	name = "HUD plane"
	plane = HUD_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/above_hud
	name = "above HUD plane"
	plane = ABOVE_HUD_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/cinematic
	name = "cinematic plane"
	plane = CINEMATIC_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME
