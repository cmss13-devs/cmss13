
/var/global/icon/marine_mapview
/var/global/icon/xeno_mapview
/var/global/icon/xeno_mapview_overlay
/var/global/icon/xeno_almayer_mapview
/var/global/list/map_sizes = list(list(),list(),list())

/proc/overlay_xeno_mapview()
	var/icon/newoverlay = icon(xeno_mapview)
	var/list/hosts_in_sight = list()
	var/list/tier_0 = list()
	var/list/tier_1 = list()
	var/list/tier_2 = list()
	var/list/tier_3 = list()
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.loc.z != 1) continue
		if(X.hivenumber != XENO_HIVE_NORMAL) continue
		switch(X.tier)
			if(0)
				tier_0 += X
			if(1)
				tier_1 += X
			if(2)
				tier_2 += X
			if(3)
				tier_3 += X
		for(var/mob/living/carbon/C in orange(7,X))
			if(isXeno(C)) continue
			if(isYautja(C)) continue
			if(C in hosts_in_sight) continue
			if(C.stat == DEAD) continue
			hosts_in_sight += C
	for(var/mob/living/carbon/Xenomorph/T0 in tier_0)
		newoverlay.DrawBox(rgb(255,153,153),T0.loc.x-1,T0.loc.y-1,T0.loc.x+1,T0.loc.y+1)
	for(var/mob/living/carbon/Xenomorph/T1 in tier_1)
		newoverlay.DrawBox(rgb(255,128,128),T1.loc.x-1,T1.loc.y-1,T1.loc.x+1,T1.loc.y+1)
	for(var/mob/living/carbon/Xenomorph/T2 in tier_2)
		newoverlay.DrawBox(rgb(255,102,102),T2.loc.x-1,T2.loc.y-1,T2.loc.x+1,T2.loc.y+1)
	for(var/mob/living/carbon/Xenomorph/T3 in tier_3)
		newoverlay.DrawBox(rgb(255,77,77),T3.loc.x-1,T3.loc.y-1,T3.loc.x+1,T3.loc.y+1)
	for(var/mob/living/carbon/H in hosts_in_sight)
		if(H.status_flags & XENO_HOST)
			newoverlay.DrawBox(rgb(0,204,255),H.x-1,H.y-1,H.x+1,H.y+1)
		else
			newoverlay.DrawBox(rgb(51,204,51),H.x-1,H.y-1,H.x+1,H.y+1)
	newoverlay.Crop(1,1,map_sizes[1][1],map_sizes[1][2])
	newoverlay.Scale(map_sizes[1][1]*2,map_sizes[1][2]*2)
	cdel(xeno_mapview_overlay)
	xeno_mapview_overlay = newoverlay
	return newoverlay

/proc/generate_xeno_mapview()
	//if(z_level != 1 || z_level != MAIN_SHIP_Z_LEVEL) return 0
	var/icon/minimap = icon('icons/minimap.dmi',map_tag)
	var/max_x = 0
	var/max_y = 0
	for(var/turf/T in turfs)
		if(T.z != 1) continue
		if(T.x > max_x && !istype(T,/turf/open/space))
			max_x = T.x
		if(T.y > max_y && !istype(T,/turf/open/space))
			max_y = T.y
		//var/area/A = get_area(T)
		if(map_tag != MAP_PRISON_STATION && istype(T,/turf/open/space))
			minimap.DrawBox(rgb(0,0,0),T.x,T.y)
			continue
		if(istype(T,/turf/open/gm/empty))
			minimap.DrawBox(rgb(0,0,0),T.x,T.y)
			continue
		if(istype(T,/turf/closed))
			if(locate(/obj/effect/alien/weeds) in T)
				minimap.DrawBox(rgb(36,0,77),T.x,T.y)
			else
				minimap.DrawBox(rgb(0,0,0),T.x,T.y)
			continue
		if(locate(/obj/structure/window_frame) in T || locate(/obj/structure/window/framed) in T || locate(/obj/machinery/door) in T)
			minimap.DrawBox(rgb(25,25,25),T.x,T.y)
			continue
		if(locate(/obj/structure/fence) in T)
			minimap.DrawBox(rgb(150,150,150),T.x,T.y)
			continue
		if(locate(/obj/structure/cargo_container) in T)
			minimap.DrawBox(rgb(120,120,120),T.x,T.y)
			continue
		if(istype(T,/turf/open/gm/river))
			minimap.DrawBox(rgb(180,180,180),T.x,T.y)
			continue
		if(locate(/obj/structure/mineral_door/resin) in T)
			minimap.DrawBox(rgb(197,153,255),T.x,T.y)
			continue
		if(istype(T,/turf/open/gm/dirt))
			if(locate(/obj/effect/alien/weeds) in T)
				minimap.DrawBox(rgb(241,230,255),T.x,T.y)
			else
				minimap.DrawBox(rgb(200,200,200),T.x,T.y)
			continue

		if(locate(/turf/closed/wall/resin) in T)
			minimap.DrawBox(rgb(183,128,255),T.x,T.y)
			continue
		if(locate(/obj/effect/alien/weeds) in T)
			minimap.DrawBox(rgb(241,230,255),T.x,T.y)
	minimap.Crop(1,1,max_x,max_y)
	map_sizes[1] = list(max_x,max_y)
	cdel(xeno_mapview)
	xeno_mapview = minimap
	return minimap

/proc/generate_marine_mapview()
	var/icon/minimap = icon('icons/minimap.dmi',map_tag)
	for(var/turf/T in turfs)
		if(T.z != 1) continue
		var/area/A = get_area(T)
		if(map_tag != MAP_PRISON_STATION && istype(T,/turf/open/space))
			minimap.DrawBox(rgb(0,0,0),T.x,T.y)
			continue
		if(A.ceiling > CEILING_METAL)
			minimap.DrawBox(rgb(0,0,0),T.x,T.y)
			continue
		if(istype(T,/turf/closed) || istype(T,/turf/open/gm/empty))
			minimap.DrawBox(rgb(0,0,0),T.x,T.y)
			continue
		if(locate(/obj/structure/window_frame) in T || locate(/obj/structure/window/framed) in T || locate(/obj/machinery/door) in T)
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
		if(A.ceiling == CEILING_GLASS)
			minimap.DrawBox(rgb(100,100,100),T.x,T.y)
			continue
		if(istype(T,/turf/open/gm/river))
			minimap.DrawBox(rgb(180,180,180),T.x,T.y)
			continue
		if(istype(T,/turf/open/gm/dirt))
			minimap.DrawBox(rgb(200,200,200),T.x,T.y)
			continue
	marine_mapview = minimap
	return minimap
