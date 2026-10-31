GLOBAL_LIST_INIT(mapless_maps, list(MAP_RUNTIME, MAP_CHINOOK, MAIN_SHIP_DEFAULT_NAME, MAP_ROSTOCK, MAP_HUNTERSHIP))

/obj/item/map
	name = "map"
	icon = 'icons/obj/items/marine-items.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi'
	)
	icon_state = "map"
	item_state = "map"
	throw_speed = SPEED_FAST
	throw_range = 5
	/// Default size when unfolded / readable.
	w_class = SIZE_MEDIUM
	// color = ... (Colors can be names - "red, green, grey, cyan" or a HEX color code "#FF0000")
	var/dat // Page content
	var/html_link = ""
	/// TRUE = folded (tiny, unreadable), FALSE = unfolded (medium, readable).
	var/folded = FALSE
	/// TRUE while the browser window is open so we can restore the correct item_state on close/drop.
	var/being_studied = FALSE


/obj/item/map/attack_self(mob/user)
	. = ..()
	if(folded)
		toggle_fold(user)
		return

	user.visible_message(SPAN_NOTICE("[user] opens [src]."))
	set_studied(TRUE, user)
	initialize_map(user)


/obj/item/map/clicked(mob/user, list/mods)
	if(mods["alt"])
		toggle_fold(user)
		return TRUE
	return ..()


/// Shared toggle used by the verb and by alt-click.
/obj/item/map/proc/toggle_fold(mob/user)
	if(!user || user.stat == DEAD)
		return
	if(user.get_active_hand() != src && user.get_inactive_hand() != src)
		to_chat(user, SPAN_WARNING("You need to be holding the map."))
		return

	if(folded)
		to_chat(user, SPAN_INFO("You unfold the map; it takes up much more space now."))
		w_class = SIZE_MEDIUM
		folded = FALSE
		icon_state = "map"
		item_state = being_studied ? "[icon_state]_studied" : "map"	// If we were studying it, keep the studied in-hand; otherwise normal map state.
		playsound(user.loc, "map_unfold", 25, 1, 3)
	else
		to_chat(user, SPAN_INFO("You fold up the map; it's now much smaller."))
		w_class = SIZE_TINY
		folded = TRUE
		icon_state = "map_folded"
		item_state = "" // no distinct folded in-hand
		being_studied = FALSE
		playsound(user.loc, "map_fold", 25, 1, 3)

	update_held_sprites(user)


/obj/item/map/verb/fold_unfold()
	set name = "Fold/Unfold"
	set category = null
	set src in usr
	toggle_fold(usr)


/obj/item/map/attack()
	return


/obj/item/map/proc/initialize_map(mob/user)
	var/wikiurl = CONFIG_GET(string/wikiurl)
	if(wikiurl)
		dat = {"
			<!DOCTYPE html>
			<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=edge">
				<meta charset="utf-8">
				<style>
					img {
						display: none;
						position: absolute;
						top: 30;
						left: 0;
						max-width: 100%;
						height: auto;
						overflow: hidden;
						border: 0;
					}
				</style>
			</head>
			<body>
			<script type="text/javascript">
				function pageloaded(obj) {
					document.getElementById("loading").style.display = "none";
					obj.style.display = "inline";
				}
			</script>
			<p id='loading'>You start unfolding the map...</p>
				<img onload="pageloaded(this)" src="[wikiurl]/[html_link]?printable=yes&remove_links=1" id="main_frame" alt=""></img>
			</body>
			</html>
		"}

	// use_onclose = FALSE so our subsequent onclose() call is not overwritten by the
	// async setup_onclose() that show_browser normally schedules (see #13245).
	show_browser(user, dat, name, "papermap", width = 1280, height = 720, use_onclose = FALSE)
	onclose(user, "papermap", src)


/obj/item/map/Topic(href, href_list)
	. = ..()
	if(href_list["close"])
		set_studied(FALSE, usr)


/// Sets or clears the "being studied" visual state and refreshes in-hands.
/obj/item/map/proc/set_studied(new_state, mob/user)
	if(being_studied == new_state)
		return
	being_studied = new_state
	if(being_studied && !folded)
		item_state = "[icon_state]_studied"
	else if(folded)
		item_state = ""
	else
		item_state = initial(item_state)
	update_held_sprites(user)


/// Updates the holder's left/right hand overlays if they are actually holding us.
/obj/item/map/proc/update_held_sprites(mob/user)
	if(!user)
		return
	if(user.get_active_hand() == src || user.get_inactive_hand() == src)
		user.update_inv_l_hand()
		user.update_inv_r_hand()


/obj/item/map/dropped(mob/user)
	. = ..()
	set_studied(FALSE, user)	// Always restore a clean state when the item leaves the hands.
	if(folded)
		item_state = ""	// keep folded appearance
	else
		item_state = initial(item_state)


/obj/item/map/Destroy()
	being_studied = FALSE
	return ..()


/obj/item/map/lazarus_landing_map
	name = "\improper Lazarus Landing Map"
	desc = "A satellite printout of the Lazarus Landing colony on LV-624."
	html_link = "images/6/6f/LV624.png"

/obj/item/map/ice_colony_map
	name = "\improper Ice Colony map"
	desc = "A satellite printout of the Ice Colony."
	html_link = "images/1/18/Map_icecolony.png"
	color = "cyan"

/obj/item/map/ice_colony_map_v3
	name = "\improper Shivas Snowball map"
	desc = "A labelled print out of the anterior scan of the UA colony Shivas Snowball."
	html_link = "images/1/18/Map_icecolony.png"
	color = "cyan"

/obj/item/map/whiskey_outpost_map
	name = "\improper Whiskey Outpost map"
	desc = "A tactical printout of the Whiskey Outpost defensive positions and locations."
	html_link = "images/7/78/Whiskey_outpost.png"
	color = "grey"

/obj/item/map/big_red_map
	name = "\improper Solaris Ridge Map"
	desc = "A censored blueprint of the Solaris Ridge facility."
	html_link = "images/9/9e/Solaris_Ridge.png"
	color = "#e88a10"

/obj/item/map/FOP_map
	name = "\improper Fiorina Orbital Penitentiary Map"
	desc = "A labelled interior scan of Fiorina Orbital Penitentiary."
	html_link = "images/4/4c/Map_Prison.png"
	color = "#e88a10"

/obj/item/map/FOP_map_v3
	name = "\improper Fiorina Orbital Civilian Annex Map"
	desc = "A scan produced by the Almayer's sensor array of the Fiorina Orbital Penitentiary Civilian Annex. It appears to have broken off from the rest of the station and is now in free geo-sync orbit around the planet."
	html_link = "images/e/e0/Prison_Station_Science_Annex.png"
	color = "#e88a10"

/obj/item/map/desert_dam
	name = "\improper Trijent Dam map"
	desc = "An orbital scan printout of the Trijent Dam colony."
	html_link = "images/9/92/Trijent_Dam.png"
	color = "#ad8d0e"

/obj/item/map/sorokyne_map
	name = "\improper Sorokyne Strata map"
	desc = "A map of the UPP colony Sorokyne Outpost, commonly known as Sorokyne Strata."
	html_link = "images/2/21/Sorokyne_Wiki_Map.jpg" //The fact that this is just a wiki-link makes me sad and amused.
	color = "cyan"

/obj/item/map/corsat
	name = "\improper CORSAT map"
	desc = "A blueprint of CORSAT station."
	html_link = "images/8/8e/CORSAT_Satellite.png"
	color = "red"

/obj/item/map/kutjevo_map
	name = "\improper Kutjevo Refinery map"
	desc = "An orbital scan of Kutjevo Refinery."
	html_link = "images/0/0d/Kutjevo_a1.jpg"
	color = "red"

/obj/item/map/lv522_map
	name = "\improper LV-522 Map"
	desc = "An overview of LV-522 schematics."
	html_link = "images/b/bb/C_claim.png"
	color = "cyan"

/obj/item/map/lv759_map
	name = "\improper LV-759 Map"
	desc = "An overview of LV-759 schematics."
	html_link = "images/6/60/LV759_Hybrisa_Prospera.png" //needs proper image still.
	color = "#005eab"

/obj/item/map/new_varadero
	name = "\improper New Varadero map"
	desc = "A labeled blueprint of the UA outpost New Varadero."
	html_link = "images/9/94/New_Varadero.png"
	color = "red"

/obj/item/map/tyrargo_rift
	name = "\improper Tyrargo Rift map"
	desc = "A labeled blueprint of the UA city Tyrargo Rift."
	html_link = "images/7/79/Tyrargo_Rift.png"

/obj/item/map/white_antre_map
	name = "\improper White Antre Research Facility map"
	desc = "An overview of the White Antre facility schematics."
	html_link = "images/d/da/White_Antre_Research_Facility.png"
	color = "cyan"

/obj/item/map/galaxy
	name = "\improper Galaxy map"
	desc = "A diagrammatic map of the milky way, laid out by sector."
	html_link = "images/9/9e/Galaxy_Map.png"
	color = "#005eab"

GLOBAL_LIST_INIT_TYPED(map_type_list, /obj/item/map, setup_all_maps())

/proc/setup_all_maps()
	return list(
		MAP_LV_624 = new /obj/item/map/lazarus_landing_map(),
		MAP_ICE_COLONY = new /obj/item/map/ice_colony_map(),
		MAP_ICE_COLONY_V3 = new /obj/item/map/ice_colony_map_v3(),
		MAP_WHISKEY_OUTPOST = new /obj/item/map/whiskey_outpost_map(),
		MAP_BIG_RED = new /obj/item/map/big_red_map(),
		MAP_PRISON_STATION = new /obj/item/map/FOP_map(),
		MAP_PRISON_STATION_V3 = new /obj/item/map/FOP_map_v3(),
		MAP_DESERT_DAM = new /obj/item/map/desert_dam(),
		MAP_SOROKYNE_STRATA = new /obj/item/map/sorokyne_map(),
		MAP_CORSAT = new /obj/item/map/corsat(),
		MAP_KUTJEVO = new /obj/item/map/kutjevo_map(),
		MAP_LV522_CHANCES_CLAIM = new /obj/item/map/lv522_map(),
		MAP_LV759_HYBRISA_PROSPERA = new /obj/item/map/lv759_map(),
		MAP_NEW_VARADERO = new /obj/item/map/new_varadero(),
		MAP_TYRARGO_RIFT = new /obj/item/map/tyrargo_rift(),
		MAP_WHITE_ANTRE_RESEARCH_FACILITY = new /obj/item/map/white_antre_map()
	)

//used by marine equipment machines to spawn the correct map.
/obj/item/map/current_map

/obj/item/map/current_map/Initialize(mapload, ...)
	. = ..()

	var/map_name = SSmapping.configs[GROUND_MAP].map_name
	var/obj/item/map/map = GLOB.map_type_list[map_name]
	if (!map && (map_name in GLOB.mapless_maps))
		return // "Maps" we don't have maps for so we don't need to throw a runtime for (namely in unit_testing)
	name = map.name
	desc = map.desc
	html_link = map.html_link
	color = map.color

// Landmark - Used for mapping. Will spawn the appropriate map for each gamemode (LV map items will spawn when LV is the gamemode, etc)
/obj/effect/landmark/map_item
	name = "map item"
	icon_state = "ipool"

/obj/effect/landmark/map_item/Initialize(mapload, ...)
	. = ..()
	GLOB.map_items += src

/obj/effect/landmark/map_item/Destroy()
	GLOB.map_items -= src
	return ..()
