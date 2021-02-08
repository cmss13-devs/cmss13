
/var/global/icon/marine_mapview
/var/global/list/marine_mapview_overlay_1 // yes because need to qdel each one cleanly
/var/global/list/marine_mapview_overlay_2
/var/global/list/marine_mapview_overlay_3
/var/global/list/marine_mapview_overlay_4
/var/global/list/marine_mapview_overlay_5
/var/global/squad1updated = FALSE
/var/global/squad2updated = FALSE
/var/global/squad3updated = FALSE
/var/global/squad4updated = FALSE
/var/global/squad0updated = FALSE // echo squad go away, none of this old spooky code handles you anyway
/var/global/refreshfrequency = 1 MINUTES // How often the map may update for each squad and the Queen. Anti-lag.
/var/global/list/map_sizes = list(list(),list(),list())

/proc/generate_marine_mapview()
	var/icon/minimap = icon('icons/minimap.dmi',SSmapping.configs[GROUND_MAP].map_name)
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
		var/obj/structure/resource_node/plasma/plasma = locate(/obj/structure/resource_node/plasma) in T
		if(plasma && plasma.growth_level)
			minimap.DrawBox(rgb(196,48,201),T.x-1,T.y-1,T.x+1,T.y+1)
			continue
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
	map_sizes[1] = list(max_x,max_y,min_x,min_y)
	marine_mapview = minimap
	return minimap

/proc/overlay_marine_mapview(var/datum/squad/S = null)
	if(istype(S)) // Update timer since this is a rather performance heavy proc
		if(S.color == 1 && squad1updated)
			return
		if(S.color == 2 && squad2updated)
			return
		if(S.color == 3 && squad3updated)
			return
		if(S.color == 4 && squad4updated)
			return
	else if(squad0updated)
		return
	var/icon/newoverlay = icon(marine_mapview)
	var/list/marines_with_helmets = list(list(),list(),list(),list(),list())
	var/list/vehicles = list()
	var/list/tier_0 = list()
	var/list/tier_1 = list()
	var/list/tier_2 = list()
	var/list/tier_3 = list()
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(!is_ground_level(H.z))
			continue
		if(!H.has_helmet_camera())
			continue
		if(H.stat == DEAD)
			continue
		if(!H.assigned_squad)
			marines_with_helmets[5] += H
			continue
		switch(H.assigned_squad.color) // because string compares are expensive
			if(1)
				marines_with_helmets[1] += H
			if(2)
				marines_with_helmets[2] += H
			if(3)
				marines_with_helmets[3] += H
			if(4)
				marines_with_helmets[4] += H
	var/list/colors = squad_colors.Copy()
	colors += rgb(51,204,51)
	var/selected = 0
	if(istype(S))
		selected = S.color
		var/i = 1
		while(i <= 4)
			if(i != S.color)
				colors[i] = rgb(51,204,51)
			i++
		colors[selected] = squad_colors[selected]
	var/j
	for(j=1,j<=marines_with_helmets.len,j++)
		if(j == selected) continue
		for(var/mob/living/carbon/human/L in marines_with_helmets[j])
			newoverlay.DrawBox(colors[j],L.loc.x-1,L.loc.y-1,L.loc.x+1,L.loc.y+1)
	if(selected)
		for(var/mob/living/carbon/human/sel in marines_with_helmets[selected])
			newoverlay.DrawBox(colors[selected],sel.loc.x-1,sel.loc.y-1,sel.loc.x+1,sel.loc.y+1)
	for(var/obj/vehicle/multitile/MULT in GLOB.all_multi_vehicles)
		if(MULT.visible_in_tacmap && is_ground_level(MULT.z))	//don't need colony/hostile vehicle to show
			vehicles += MULT
	if(vehicles.len)
		for(var/obj/vehicle/multitile/V in vehicles)
			newoverlay.DrawBox(rgb(0,153,77),V.x-1,V.y-1,V.x+1,V.y+1)
			newoverlay.DrawBox(rgb(128,255,128),V.x-1,V.y)
			newoverlay.DrawBox(rgb(128,255,128),V.x+1,V.y)
			newoverlay.DrawBox(rgb(128,255,128),V.x,V.y-1)
			newoverlay.DrawBox(rgb(128,255,128),V.x,V.y+1)
	if(SSticker.toweractive)
		for(var/mob/living/carbon/Xenomorph/X in GLOB.living_xeno_list)
			if(!is_ground_level(X.loc.z)) continue
			switch(X.tier)
				if(0)
					tier_0 += X
				if(1)
					tier_1 += X
				if(2)
					tier_2 += X
				if(3)
					tier_3 += X
			for(var/mob/living/carbon/Xenomorph/T0 in tier_0)
				newoverlay.DrawBox(rgb(255,153,153),T0.loc.x-1,T0.loc.y-1,T0.loc.x+1,T0.loc.y+1)
			for(var/mob/living/carbon/Xenomorph/T1 in tier_1)
				newoverlay.DrawBox(rgb(255,128,128),T1.loc.x-1,T1.loc.y-1,T1.loc.x+1,T1.loc.y+1)
			for(var/mob/living/carbon/Xenomorph/T2 in tier_2)
				newoverlay.DrawBox(rgb(255,102,102),T2.loc.x-1,T2.loc.y-1,T2.loc.x+1,T2.loc.y+1)
			for(var/mob/living/carbon/Xenomorph/T3 in tier_3)
				newoverlay.DrawBox(rgb(255,77,77),T3.loc.x-1,T3.loc.y-1,T3.loc.x+1,T3.loc.y+1)
	newoverlay.Crop(1,1,map_sizes[1][1],map_sizes[1][2])
	newoverlay.Scale(map_sizes[1][1]*2,map_sizes[1][2]*2)
	if(selected)
		switch(selected)
			if(1)
				marine_mapview_overlay_1 = newoverlay
				squad1updated = TRUE
				spawn(refreshfrequency)
					squad1updated = FALSE
			if(2)
				marine_mapview_overlay_2 = newoverlay
				squad2updated = TRUE
				spawn(refreshfrequency)
					squad2updated = FALSE
			if(3)
				marine_mapview_overlay_3 = newoverlay
				squad3updated = TRUE
				spawn(refreshfrequency)
					squad3updated = FALSE
			if(4)
				marine_mapview_overlay_4 = newoverlay
				squad4updated = TRUE
				spawn(refreshfrequency)
					squad4updated = FALSE
	else
		marine_mapview_overlay_5 = newoverlay
		squad0updated = TRUE
		spawn(refreshfrequency)
			squad0updated = FALSE

	return newoverlay


/mob/living/carbon/human/proc/has_helmet_camera()
	if(faction == FACTION_MARINE)
		return istype(head, /obj/item/clothing/head/helmet/marine)
