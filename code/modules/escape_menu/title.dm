// This doesn't instantiate right away, since we rely on other GLOBs
GLOBAL_DATUM(escape_menu_title, /atom/movable/screen/escape_menu/title)

/// Provides a singleton for the escape menu details screen.
/proc/give_escape_menu_title()
	if (isnull(GLOB.escape_menu_title))
		GLOB.escape_menu_title = new

	return GLOB.escape_menu_title

/atom/movable/screen/escape_menu/title
	screen_loc = "NORTH:-100,WEST:32"
	maptext_height = 100
	maptext_width = 500

/atom/movable/screen/escape_menu/title/Initialize(mapload)
	. = ..()

	update_text()

/atom/movable/screen/escape_menu/title/Destroy()
	if (GLOB.escape_menu_title == src)
		stack_trace("Something tried to delete the escape menu details screen")
		return QDEL_HINT_LETMELIVE

	return ..()

/atom/movable/screen/escape_menu/title/proc/update_text()
	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, PROC_REF(do_update_text))
	return do_update_text()

/atom/movable/screen/escape_menu/title/proc/do_update_text()
	var/gotten_text = SSticker.mode?.get_escape_menu()
	var/subtitle_text = MAPTEXT("<span style='font-size: 8px'>[gotten_text ? gotten_text : "Fighting... in space!"]</span>")
	var/short_name = SSmapping.configs[GROUND_MAP].short_name
	var/title_text = {"
		<span style='font-weight: bolder; font-size: 24px'>
			[short_name ? short_name : SSmapping.configs[GROUND_MAP].map_name]
		</span>
	"}

	maptext = "<font align='top'>" + subtitle_text + MAPTEXT_VCR_OSD_MONO(title_text) + "</font>"
