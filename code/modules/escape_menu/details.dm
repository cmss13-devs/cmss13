// This doesn't instantiate right away, since we rely on other GLOBs
GLOBAL_DATUM(escape_menu_details, /atom/movable/screen/escape_menu/details)

/// Provides a singleton for the escape menu details screen.
/proc/give_escape_menu_details()
	if (isnull(GLOB.escape_menu_details))
		GLOB.escape_menu_details = new

	return GLOB.escape_menu_details

/atom/movable/screen/escape_menu/details
	screen_loc = "EAST:-180,NORTH:-25"
	maptext_height = 100
	maptext_width = 200

/atom/movable/screen/escape_menu/details/Initialize(mapload)
	. = ..()

	update_text()
	START_PROCESSING(SSescape_menu, src)

/atom/movable/screen/escape_menu/details/Destroy()
	if (GLOB.escape_menu_details == src)
		stack_trace("Something tried to delete the escape menu details screen")
		return QDEL_HINT_LETMELIVE

	STOP_PROCESSING(SSescape_menu, src)
	return ..()

/atom/movable/screen/escape_menu/details/process(delta_time)
	update_text()

/atom/movable/screen/escape_menu/details/proc/update_text()
	var/webmap_host = CONFIG_GET(string/webmap_host)

	var/ship_map = "<a style='color: #88f;' href=\"[webmap_host][SSmapping.configs[SHIP_MAP]?.webmap_url]\"><u>[SSmapping.configs[SHIP_MAP].map_name || "Loading..."]</u></a>"
	var/ground_map = "<a style='color: #88f;' href=\"[webmap_host][SSmapping.configs[GROUND_MAP]?.webmap_url]\"><u>[SSmapping.configs[GROUND_MAP].map_name || "Loading..."]</u></a>"

	var/new_maptext = {"
		<span style='text-align: right; line-height: 0.7'>
			Round ID: [GLOB.round_id || "NULL"]<br />
			Round Time: [duration2text()]<br />
			[SSmapping.configs[GROUND_MAP].disable_ship_map ? "" : "Ship: [ship_map]<br />"]
			Ground: [ground_map]<br />
		</span>
	"}

	maptext = MAPTEXT(new_maptext)
