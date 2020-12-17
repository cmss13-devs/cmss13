/obj/item/map
	name = "map"
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "map"
	item_state = "map"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_TINY
	// color = ... (Colors can be names - "red, green, grey, cyan" or a HEX color code "#FF0000")
	var/dat        // Page content
	var/html_link = ""
	var/window_size = "1280x720"

/obj/item/map/attack_self(var/mob/usr as mob) //Open the map
	usr.visible_message(SPAN_NOTICE("[usr] opens the [src.name]. "))
	initialize_map()

/obj/item/map/attack()
	return

/obj/item/map/proc/initialize_map()
	var/wikiurl = CONFIG_GET(string/wikiurl)
	if(wikiurl)
		dat = {"

			<html><head>
			<style>
				iframe {
					display: none;
				}
			</style>
			</head>
			<body>
			<script type="text/javascript">
				function pageloaded(myframe) {
					document.getElementById("loading").style.display = "none";
					myframe.style.display = "inline";
    			}
			</script>
			<p id='loading'>You start unfolding the map...</p>
			<iframe width='100%' height='97%' onload="pageloaded(this)" src="[wikiurl]/[html_link]?printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
			</body>

			</html>

			"}
	show_browser(usr, dat, name, "map", "size=[window_size]")

/obj/item/map/lazarus_landing_map
	name = "\improper Lazarus Landing Map"
	desc = "A satellite printout of the Lazarus Landing colony on LV-624."
	html_link = "images/6/6f/LV624.png"

/obj/item/map/ice_colony_map
	name = "\improper Ice Colony map"
	desc = "A satellite printout of the Ice Colony."
	html_link = "images/1/18/Map_icecolony.png"
	color = "cyan"

/obj/item/map/whiskey_outpost_map
	name = "\improper Whiskey Outpost map"
	desc = "A tactical printout of the Whiskey Outpost defensive positions and locations."
	html_link = "images/7/78/Whiskey_outpost.png"
	color = "grey"

/obj/item/map/big_red_map
	name = "\improper Solaris Ridge Map"
	desc = "A censored blueprint of the Solaris Ridge facility"
	html_link = "images/c/c5/Big_Red.png"
	color = "#e88a10"

/obj/item/map/FOP_map
	name = "\improper Fiorina Orbital Penitentiary Map"
	desc = "A labelled interior scan of Fiorina Orbital Penitentiary"
	html_link = "images/4/4c/Map_Prison.png"
	color = "#e88a10"

/obj/item/map/desert_dam
	name = "\improper Trijent Dam map"
	desc = "An orbital scan printout of the Trijent Dam colony."
	html_link = "images/9/92/Trijent_Dam.png"
	color = "#ad8d0e"

/obj/item/map/sorokyne_map
	name = "\improper Sorokyne Outpost Map"
	desc = "A labelled schematic of the Sorokyne Outpost and the surrounding caves."
	html_link = "images/2/21/Sorokyne_Wiki_Map.jpg" //The fact that this is just a wiki-link makes me sad and amused.
	color = "cyan"
/obj/item/map/corsat
	name = "\improper CORSAT map"
	desc = "A blueprint of CORSAT station"
	html_link = "images/8/8e/CORSAT_Satellite.png"
	color = "red"

/obj/item/map/kutjevo_map
	name = "\improper Kutjevo Refinery map"
	desc = "An orbital scan of Kutjevo Refinery"
	html_link = "images/0/0d/Kutjevo_a1.jpg"
	color = "red"


//used by marine equipment machines to spawn the correct map.
/obj/item/map/current_map

/obj/item/map/current_map/New()
	..()
	if(!map_tag)
		qdel(src)
		return
	switch(map_tag)
		if(MAP_LV_624)
			name = "\improper Lazarus Landing Map"
			desc = "A satellite printout of the Lazarus Landing colony on LV-624."
			html_link = "images/6/6f/LV624.png"
		if(MAP_ICE_COLONY)
			name = "\improper Ice Colony map"
			desc = "A satellite printout of the Ice Colony."
			html_link = "images/1/18/Map_icecolony.png"
			color = "cyan"
		if(MAP_BIG_RED)
			name = "\improper Solaris Ridge Map"
			desc = "A censored blueprint of the Solaris Ridge facility"
			html_link = "images/9/9e/Solaris_Ridge.png"
			color = "#e88a10"
		if(MAP_PRISON_STATION)
			name = "\improper Fiorina Orbital Penitentiary Map"
			desc = "A labelled interior scan of Fiorina Orbital Penitentiary"
			html_link = "images/4/4c/Map_Prison.png"
			color = "#e88a10"
		if(MAP_DESERT_DAM)
			name = "\improper Trijent Dam map"
			desc = "A map of Trijent Dam"
			html_link = "images/9/92/Trijent_Dam.png"
			color = "#cec13f"
			//did only the basics todo change later
		if(MAP_SOROKYNE_STRATA)
			name = "\improper Sorokyne Strata map"
			desc = "A map of the Weston-Yamada colony Sorokyne Outpost, commonly known as Sorokyne Strata."
			html_link = "images/1/1c/Sorokyne_map.png"
			color = "cyan"
		if (MAP_CORSAT)
			name = "\improper CORSAT map"
			desc = "A blueprint of CORSAT station"
			html_link = "images/8/8e/CORSAT_Satellite.png"
			color = "red"
		if (MAP_KUTJEVO)
			name = "\improper Kutjevo Refinery map"
			desc = "An orbital scan of Kutjevo Refinery"
			html_link = "images/0/0d/Kutjevo_a1.jpg"
			color = "red"
		else
			qdel(src)



// Landmark - Used for mapping. Will spawn the appropriate map for each gamemode (LV map items will spawn when LV is the gamemode, etc)
/obj/effect/landmark/map_item
	name = "map item"

/obj/effect/landmark/map_item/Initialize(mapload, ...)
	. = ..()
	GLOB.map_items += src

/obj/effect/landmark/map_item/Destroy()
	GLOB.map_items -= src
	return ..()
