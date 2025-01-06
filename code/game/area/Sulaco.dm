//SULACO AREAS--------------------------------------//
/area/shuttle
	ceiling = CEILING_METAL
	requires_power = 0
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE


//Drop Pods
/area/shuttle/drop1
	//soundscape_playlist = list('sound/soundscape/drum1.ogg')
	soundscape_interval = 30 //seconds
	flags_area = AREA_NOTUNNEL
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop1/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop1/sulaco
	name = "\improper Dropship Alamo"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255
	is_resin_allowed = FALSE

/area/shuttle/drop1/LV624
	name = "\improper Dropship Alamo"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle"

/area/shuttle/drop1/prison
	name = "\improper Dropship Alamo"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle"

/area/shuttle/drop1/BigRed
	name = "\improper Dropship Alamo"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle"

/area/shuttle/drop1/ice_colony
	name = "\improper Dropship Alamo"
	icon_state = "shuttle"

/area/shuttle/drop1/DesertDam
	name = "\improper Dropship Alamo"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle"

/area/shuttle/drop1/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper Dropship Alamo Transit"
	icon_state = "shuttle2"

/area/shuttle/drop1/lz1
	name = "\improper Alamo Landing Zone"
	icon_state = "away1"




/area/shuttle/drop2
	//soundscape_playlist = list('sound/soundscape/drum1.ogg')
	soundscape_interval = 30 //seconds
	flags_area = AREA_NOTUNNEL
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop2/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop2/sulaco
	name = "\improper Dropship Normandy"
	icon_state = "shuttle"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255
	is_resin_allowed = FALSE

/area/shuttle/drop2/LV624
	name = "\improper Dropship Normandy"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle2"

/area/shuttle/drop2/prison
	name = "\improper Dropship Normandy"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle2"

/area/shuttle/drop2/BigRed
	name = "\improper Dropship Normandy"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle2"

/area/shuttle/drop2/ice_colony
	name = "\improper Dropship Normandy"
	icon_state = "shuttle2"

/area/shuttle/drop2/DesertDam
	name = "\improper Dropship Normandy"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle2"

/area/shuttle/drop2/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper Dropship Normandy Transit"
	icon_state = "shuttlered"

/area/shuttle/drop2/lz2
	name = "\improper Normandy Landing Zone"
	icon_state = "away2"

/area/shuttle/drop3
	//soundscape_playlist = list('sound/soundscape/drum1.ogg')
	soundscape_interval = 30 //seconds
	flags_area = AREA_NOTUNNEL
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop3/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop3/sulaco
	name = "\improper Dropship Saipan"
	icon_state = "shuttle"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255

/area/shuttle/drop3/LV624
	name = "\improper Dropship Saipan"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle2"

/area/shuttle/drop3/prison
	name = "\improper Dropship Saipan"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle2"

/area/shuttle/drop3/BigRed
	name = "\improper Dropship Saipan"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle2"

/area/shuttle/drop3/ice_colony
	name = "\improper Dropship Saipan"
	icon_state = "shuttle2"

/area/shuttle/drop3/DesertDam
	name = "\improper Dropship Saipan"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle2"

/area/shuttle/drop3/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper Dropship Saipan Transit"
	icon_state = "shuttlered"

/area/shuttle/drop3/lz3
	name = "\improper Saipan Landing Zone"
	icon_state = "away2"

//UPP DROPSHIP

/area/shuttle/drop_upp/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop_upp
	soundscape_interval = 30 //seconds
	flags_area = AREA_NOTUNNEL
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop_upp/morana
	name = "\improper Dropship Morana"
	icon_state = "shuttle"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255

/area/shuttle/drop_upp/LV624
	name = "\improper Dropship Morana"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle2"

/area/shuttle/drop_upp/prison
	name = "\improper Dropship Morana"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle2"

/area/shuttle/drop_upp/BigRed
	name = "\improper Dropship Morana"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle2"

/area/shuttle/drop_upp/ice_colony
	name = "\improper Dropship Morana"
	icon_state = "shuttle2"

/area/shuttle/drop_upp/DesertDam
	name = "\improper Dropship Morana"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle2"

/area/shuttle/drop_upp/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper Dropship Morana Transit"
	icon_state = "shuttlered"

/area/shuttle/drop_upp/lz_upp
	name = "\improper Morana Landing Zone"
	icon_state = "away2"

////

/area/shuttle/drop_upp2/devana
	name = "\improper Dropship Devana"
	icon_state = "shuttle"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255

/area/shuttle/drop_upp2/LV624
	name = "\improper Dropship Devana"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle2"

/area/shuttle/drop_upp2/prison
	name = "\improper Dropship Devana"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle2"

/area/shuttle/drop_upp2/BigRed
	name = "\improper Dropship Devana"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle2"

/area/shuttle/drop_upp2/ice_colony
	name = "\improper Dropship Devana"
	icon_state = "shuttle2"

/area/shuttle/drop_upp2/DesertDam
	name = "\improper Dropship Devana"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle2"

/area/shuttle/drop_upp2/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper Dropship Devana Transit"
	icon_state = "shuttlered"

/area/shuttle/drop_upp2/lz_upp
	name = "\improper Devana Landing Zone"
	icon_state = "away2"

//DISTRESS SHUTTLES

/area/shuttle/distress
	base_lighting_alpha = 255
	unique = TRUE

/area/shuttle/distress/start
	name = "\improper Distress Shuttle"
	icon_state = "away1"
	flags_atom = AREA_ALLOW_XENO_JOIN

/area/shuttle/distress/transit
	name = "\improper Distress Shuttle Transit"
	icon_state = "away2"


/area/shuttle/distress/start_pmc
	name = "\improper Distress Shuttle PMC"
	icon_state = "away1"

/area/shuttle/distress/transit_pmc
	name = "\improper Distress Shuttle PMC Transit"
	icon_state = "away2"


/area/shuttle/distress/start_upp
	name = "\improper Distress Shuttle UPP"
	icon_state = "away1"


/area/shuttle/distress/transit_upp
	name = "\improper Distress Shuttle UPP Transit"
	icon_state = "away2"


/area/shuttle/distress/start_big
	name = "\improper Distress Shuttle Big"
	icon_state = "away1"


/area/shuttle/distress/transit_big
	name = "\improper Distress Shuttle Big Transit"
	icon_state = "away2"


/area/shuttle/distress/arrive_1
	name = "\improper Distress Shuttle"
	icon_state = "away3"

/area/shuttle/distress/arrive_2
	name = "\improper Distress Shuttle"
	icon_state = "away4"

/area/shuttle/distress/arrive_3
	name = "\improper Distress Shuttle"
	icon_state = "away"


/area/shuttle/distress/arrive_n_hangar
	name = "\improper Distress Shuttle"
	icon_state = "away"

/area/shuttle/distress/arrive_s_hangar
	name = "\improper Distress Shuttle"
	icon_state = "away3"

/area/shuttle/distress/start_small
	name = "\improper VIP Shuttle"
	icon_state = "away3"

/area/shuttle/distress/transit_small
	name = "\improper VIP Shuttle Transit"
	icon_state = "away2"

/area/shuttle/distress/arrive_n_engi
	name = "\improper VIP Shuttle"
	icon_state = "away"

/area/shuttle/distress/arrive_s_engi
	name = "\improper VIP Shuttle"
	icon_state = "away2"
