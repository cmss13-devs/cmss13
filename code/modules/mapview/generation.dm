var/global/list/base_mapview_types = list()
var/global/list/populated_mapview_types = list()
var/global/list/populated_mapview_type_updated = list()

var/global/list/map_sizes = list()
var/global/list/faction_to_tacmap_color = list(
	FACTION_UPP = "#c26a2f",
	FACTION_CLF = "#2f98c2",
	FACTION_PMC = "#d19513"
)

#define TACMAP_REFRESH_FREQUENCY 1 MINUTES

/proc/generate_tacmap(map_type = TACMAP_BASE_OCCLUDED)
	var/icon/minimap = icon('icons/minimap.dmi', SSmapping.configs[GROUND_MAP].map_name)
	var/min_x = 1000
	var/max_x = 0
	var/min_y = 1000
	var/max_y = 0
	for(var/z1 in z1turfs)
		var/turf/T = z1
		if(T.x < min_x && !istype(T,/turf/open/space))
			min_x = T.x
		if(T.x > max_x && !istype(T,/turf/open/space))
			max_x = T.x
		if(T.y < min_y && !istype(T,/turf/open/space))
			min_y = T.y
		if(T.y > max_y && !istype(T,/turf/open/space))
			max_y = T.y
		var/area/A = get_area(T)
		if((SSmapping.configs[GROUND_MAP].map_name != MAP_PRISON_STATION || SSmapping.configs[GROUND_MAP].map_name != MAP_PRISON_STATION_V3 ||SSmapping.configs[GROUND_MAP].map_name != MAP_CORSAT) && istype(T,/turf/open/space))
			minimap.DrawBox(rgb(0,0,0),T.x,T.y)
			continue
		if(map_type == TACMAP_BASE_OCCLUDED)
			if(A.ceiling >= CEILING_PROTECTION_TIER_2 && A.ceiling != CEILING_REINFORCED_METAL)
				minimap.DrawBox(rgb(0,0,0),T.x,T.y)
				continue
			if(A.ceiling >= CEILING_PROTECTION_TIER_2)
				minimap.DrawBox(rgb(0,0,0),T.x,T.y)
				continue
		if(locate(/obj/structure/window_frame) in T || locate(/obj/structure/window/framed) in T || locate(/obj/structure/machinery/door) in T)
			minimap.DrawBox(rgb(25,25,25),T.x,T.y)
			continue
		if(locate(/obj/structure/fence) in T)
			minimap.DrawBox(rgb(150,150,150),T.x,T.y)
			continue
		if(locate(/obj/structure/cargo_container) in T)
			minimap.DrawBox(rgb(120,120,120),T.x,T.y)
			continue
		if(A.ceiling == CEILING_METAL)
			minimap.DrawBox(rgb(50,50,50),T.x,T.y)
			continue
		if(A.ceiling == CEILING_REINFORCED_METAL)
			minimap.DrawBox(rgb(35,35,35),T.x,T.y)
			continue
		if(A.ceiling == CEILING_GLASS)
			minimap.DrawBox(rgb(100,100,100),T.x,T.y)
			continue
		if(istype(T,/turf/open/gm/river))
			minimap.DrawBox(rgb(180,180,180),T.x,T.y)
			continue
		if(istype(T,/turf/open/gm/dirt))
			minimap.DrawBox(rgb(200,200,200),T.x,T.y)
			continue
	minimap.Crop(1,1,max_x,max_y)
	if(!length(map_sizes))
		map_sizes = list(max_x, max_y,min_x, min_y)
	base_mapview_types[map_type] = minimap
	return minimap

/proc/draw_tacmap_units(icon/tacmap, tacmap_type = TACMAP_DEFAULT, additional_parameter = null)
	switch(tacmap_type)
		if(TACMAP_DEFAULT)
			draw_marines(tacmap)
			draw_vehicles(tacmap)
			draw_xenos(tacmap)
			draw_tcomms_towers(tacmap)
		if(TACMAP_XENO)
			draw_xenos(tacmap, FALSE, FALSE, additional_parameter)
		if(TACMAP_YAUTJA)
			draw_marines(tacmap)
			draw_vehicles(tacmap)
			draw_xenos(tacmap, FALSE, FALSE)
		if(TACMAP_FACTION)
			draw_faction_units(tacmap, additional_parameter, (additional_parameter in faction_to_tacmap_color) ? faction_to_tacmap_color[additional_parameter] : "#2facc2d3")
			draw_tcomms_towers(tacmap)

/proc/draw_marines(icon/tacmap)
	var/list/colors = squad_colors.Copy()
	colors += rgb(51, 204, 204)
	for(var/mob/living/carbon/human/H as anything in GLOB.alive_human_list)
		if(!is_ground_level(H.z))
			continue
		if(!H.has_helmet_camera())
			continue
		var/color = null
		if(!H.assigned_squad)
			color = colors[6]
		else
			color = colors[H.assigned_squad.color]
		if(color)
			tacmap.DrawBox(color, H.loc.x-1, H.loc.y-1, H.loc.x+1, H.loc.y+1)

/proc/draw_faction_units(icon/tacmap, faction, color)
	for(var/mob/living/carbon/human/H as anything in GLOB.alive_human_list)
		if(H.faction != faction)
			continue
		if(!is_ground_level(H.z))
			continue
		tacmap.DrawBox(color, H.loc.x-1, H.loc.y-1, H.loc.x+1, H.loc.y+1)

/proc/draw_vehicles(icon/tacmap)
	for(var/obj/vehicle/multitile/V as anything in GLOB.all_multi_vehicles)
		if(V.visible_in_tacmap && is_ground_level(V.z)) //don't need colony/hostile vehicle to show
			tacmap.DrawBox(rgb(0,153,77),V.x-1,V.y-1,V.x+1,V.y+1)
			tacmap.DrawBox(rgb(128,255,128),V.x-1,V.y)
			tacmap.DrawBox(rgb(128,255,128),V.x+1,V.y)
			tacmap.DrawBox(rgb(128,255,128),V.x,V.y-1)
			tacmap.DrawBox(rgb(128,255,128),V.x,V.y+1)

/proc/draw_tcomms_towers(icon/tacmap)
	for(var/obj/structure/machinery/telecomms/relay/preset/tower/V as anything in GLOB.all_static_telecomms_towers)
		if(is_ground_level(V.z))
			tacmap.DrawBox(rgb(255,123,0),V.x-1,V.y-1,V.x+1,V.y+1)
			tacmap.DrawBox(rgb(255,180,0),V.x-1,V.y)
			tacmap.DrawBox(rgb(255,180,0),V.x+1,V.y)
			tacmap.DrawBox(rgb(255,180,0),V.x,V.y+1)
			tacmap.DrawBox(rgb(255,180,0),V.x,V.y-1)

/proc/draw_xenos(icon/tacmap, human_pov = TRUE, use_vehicle = TRUE, hivenumber = null)
	if(!human_pov || SSticker.toweractive)
		for(var/mob/living/carbon/xenomorph/X as anything in GLOB.living_xeno_list)
			if(hivenumber && X.hivenumber != hivenumber)
				continue
			if(!is_ground_level(X.loc.z))
				continue
			var/xeno_color = null
			switch(X.tier)
				if(0)
					xeno_color = rgb(255, 153, 153)
				if(1)
					xeno_color = rgb(255, 128, 128)
				if(2)
					xeno_color = rgb(255, 102, 102)
				if(3)
					xeno_color = rgb(255, 77, 77)
			if(xeno_color)
				tacmap.DrawBox(xeno_color, X.loc.x-1, X.loc.y-1, X.loc.x+1, X.loc.y+1)
	else if(use_vehicle && length(GLOB.command_apc_list))
		//take xenomorph from the pool
		for(var/mob/living/carbon/xenomorph/X as anything in GLOB.living_xeno_list)
			if(hivenumber && X.hivenumber != hivenumber)
				continue
			//filter out those not on the ground
			var/turf/XT = get_turf(X)
			if(!is_ground_level(XT?.z))
				continue
			//check whether xeno is within sensors range of any intact CMD APCs deployed on the ground
			for(var/obj/vehicle/multitile/apc/command/CMDAPC as anything in GLOB.command_apc_list)
				if(CMDAPC.health > 0 && CMDAPC.visible_in_tacmap && is_ground_level(CMDAPC.loc?.z) && get_dist(CMDAPC, X) <= CMDAPC.sensor_radius)
					var/xeno_color
					switch(X.tier)
						if(0)
							xeno_color = rgb(255, 153, 153)
						if(1)
							xeno_color = rgb(255, 128, 128)
						if(2)
							xeno_color = rgb(255, 102, 102)
						if(3)
							xeno_color = rgb(255, 77, 77)
					if(xeno_color)
						tacmap.DrawBox(xeno_color, XT.x-1, XT.y-1, XT.x+1, XT.y+1)

/proc/overlay_tacmap(map_string = TACMAP_DEFAULT, map_type = TACMAP_BASE_OCCLUDED, additional_parameter = null)
	var/tacmap_string = map_string
	if(additional_parameter)
		tacmap_string += "-[additional_parameter]"
	if(populated_mapview_type_updated[tacmap_string]) // update this every [refresh_frequency] units of time, iconops is laggy
		return populated_mapview_types[tacmap_string]

	var/icon/tacmap = icon(base_mapview_types[map_type])
	draw_tacmap_units(tacmap, map_string, additional_parameter)
	tacmap.Crop(1, 1, map_sizes[1], map_sizes[2])
	tacmap.Scale(map_sizes[1] * 2, map_sizes[2] * 2)
	populated_mapview_types[tacmap_string] = tacmap
	populated_mapview_type_updated[tacmap_string] = TRUE
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(prepare_tacmap_for_update), tacmap_string), TACMAP_REFRESH_FREQUENCY)
	return tacmap

/proc/prepare_tacmap_for_update(tacmap_string = TACMAP_DEFAULT)
	populated_mapview_type_updated[tacmap_string] = FALSE

/mob/living/carbon/human/proc/has_helmet_camera()
	if(faction == FACTION_MARINE)
		return istype(head, /obj/item/clothing/head/helmet/marine)

#undef TACMAP_REFRESH_FREQUENCY
