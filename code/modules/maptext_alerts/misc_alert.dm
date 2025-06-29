/atom/movable/screen/text/screen_text/picture
	maptext_height = 64
	maptext_width = 480
	maptext_x = 66
	maptext_y = 32
	letters_per_update = 1
	fade_out_delay = 5 SECONDS
	screen_loc = "WEST:6,1:5"
	style_open = "<span class='langchat' style=font-size:20pt;text-align:left valign='top'>"
	style_close = "</span>"
	layer = INTRO_LAYER
	plane = INTRO_PLANE
	icon = 'icons/ui_icons/screen_alert_images.dmi'
	///image that will display on the left of the screen alert
	var/image_to_play
	///y offset of image
	var/image_to_play_offset_y = 32
	///x offset of image
	var/image_to_play_offset_x = 0
/atom/movable/screen/text/screen_text/picture/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/image/alertimage = image(icon, icon_state = image_to_play, pixel_y = image_to_play_offset_y, pixel_x = image_to_play_offset_x)
	alertimage.appearance_flags = APPEARANCE_UI
	overlays += alertimage

/atom/movable/screen/text/screen_text/picture/starting
	layer = ABOVE_INTRO_LAYER
	plane = FULLSCREEN_PLANE
	maptext_height = 480
	maptext_width = 480
	screen_loc = "LEFT, TOP-3"
	maptext_x = 0
	maptext_y = -410
	image_to_play = "uscm"
	style_open = "<span style='font-size:12pt; text-align:center; color: #70D5E9; font-family: \"VCR OSD Mono\"' valign='top'>"
	fade_out_delay = 1 SECONDS

/atom/movable/screen/text/screen_text/picture/starting/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	add_filter("text_glow", 2, drop_shadow_filter(x = 0, y = 0, size = 3, color = "#70D5E9"))

/atom/movable/screen/text/screen_text/picture/starting/upp
	image_to_play = "upp"

/atom/movable/screen/text/screen_text/hypersleep_status
	maptext_height = 480
	maptext_width = 480
	maptext_x = 0
	maptext_y = -500
	screen_loc = "LEFT,TOP-3"
	letters_per_update = 1
	fade_out_delay = 1 SECONDS
	style_open = "<span style='font-size:15pt; text-align:center; color: #c0f7ff; font-family: \"VCR OSD Mono\"' valign='top'>"
	style_close = "</span>"

/atom/movable/screen/text/screen_text/hypersleep_status/Initialize(mapload)
	. = ..()
	add_filter("text_glow", 2, drop_shadow_filter(x = 0, y = 0, size = 3, color = "#70D5E9"))
