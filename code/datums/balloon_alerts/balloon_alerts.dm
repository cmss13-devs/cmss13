#define BALLOON_TEXT_WIDTH 200
#define BALLOON_TEXT_SPAWN_TIME (0.2 SECONDS)
#define BALLOON_TEXT_FADE_TIME (0.1 SECONDS)
#define BALLOON_TEXT_FULLY_VISIBLE_TIME (0.7 SECONDS)
#define BALLOON_TEXT_TOTAL_LIFETIME(mult) (BALLOON_TEXT_SPAWN_TIME + BALLOON_TEXT_FULLY_VISIBLE_TIME*mult + BALLOON_TEXT_FADE_TIME)
/// The increase in duration per character in seconds
#define BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT (0.05)
/// The amount of characters needed before this increase takes into effect
#define BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN 10

/// Creates text that will float from the atom upwards to the viewer.
/atom/proc/balloon_alert(mob/viewer, text, text_color)
	SHOULD_NOT_SLEEP(TRUE)

	INVOKE_ASYNC(src, PROC_REF(balloon_alert_perform), viewer, text, text_color)

/// Create balloon alerts (text that floats up) to everything within range.
/// Will only display to people who can see.
/atom/proc/balloon_alert_to_viewers(message, self_message, max_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, text_color)
	SHOULD_NOT_SLEEP(TRUE)

	var/list/hearers = get_mobs_in_view(max_distance, src)
	hearers -= ignored_mobs

	for(var/mob/hearer in hearers)
		if(is_blind(hearer))
			continue

		balloon_alert(hearer, (hearer == src && self_message) || message, text_color)

// Do not use.
// MeasureText blocks. I have no idea for how long.
// I would've made the maptext_height update on its own, but I don't know
// if this would look bad on laggy clients.
/atom/proc/balloon_alert_perform(mob/viewer, text, text_color)
	var/client/viewer_client = viewer.client
	if (isnull(viewer_client))
		return

	var/image/balloon_alert = image(loc = get_atom_on_turf(src), layer = ABOVE_MOB_LAYER)
	balloon_alert.plane = RUNECHAT_PLANE
	balloon_alert.alpha = 0
	balloon_alert.color = text_color
	balloon_alert.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR|RESET_TRANSFORM|RESET_ALPHA
	balloon_alert.maptext = MAPTEXT("<span class='center langchat'>[text]</span>")
	balloon_alert.maptext_height = WXH_TO_HEIGHT(viewer_client?.MeasureText(text, null, BALLOON_TEXT_WIDTH))
	balloon_alert.maptext_width = BALLOON_TEXT_WIDTH
	balloon_alert.maptext_x = get_maxptext_x_offset(balloon_alert)
	if(appearance_flags & PIXEL_SCALE)
		balloon_alert.appearance_flags |= PIXEL_SCALE
	//"<span style='text-align: center; -dm-text-outline: 1px #0005'>[text]</span>"
	viewer_client?.images += balloon_alert

	var/duration_mult = 1
	var/duration_length = length(text) - BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN

	if(duration_length > 0)
		duration_mult += duration_length*BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT

	animate(
		balloon_alert,
		pixel_y = world.icon_size * 1.2,
		time = BALLOON_TEXT_TOTAL_LIFETIME(1),
		easing = SINE_EASING | EASE_OUT,
	)

	animate(
		alpha = 255,
		time = BALLOON_TEXT_SPAWN_TIME,
		easing = CUBIC_EASING | EASE_OUT,
		flags = ANIMATION_PARALLEL,
	)

	animate(
		alpha = 0,
		time = BALLOON_TEXT_FULLY_VISIBLE_TIME*duration_mult,
		easing = CUBIC_EASING | EASE_IN,
	)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_image_from_client), balloon_alert, viewer_client), BALLOON_TEXT_TOTAL_LIFETIME(duration_mult))

#undef BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN
#undef BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT
#undef BALLOON_TEXT_FADE_TIME
#undef BALLOON_TEXT_FULLY_VISIBLE_TIME
#undef BALLOON_TEXT_SPAWN_TIME
#undef BALLOON_TEXT_TOTAL_LIFETIME
#undef BALLOON_TEXT_WIDTH
