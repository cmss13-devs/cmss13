/turf/open/space/transit
	name = "\proper hyperspace"
	icon_state = "black"
	dir = SOUTH
	baseturfs = /turf/open/space/transit
	var/auto_space_icon = TRUE

/turf/open/space/transit/south
	dir = SOUTH

/turf/open/space/transit/north
	dir = NORTH

/turf/open/space/transit/horizontal
	dir = WEST

/turf/open/space/transit/west
	dir = WEST

/turf/open/space/transit/east
	dir = EAST


/turf/open/space/transit/Initialize(mapload)
	. = ..()
	update_icon()

/turf/open/space/transit/update_icon()
	. = ..()
	if(auto_space_icon)
		icon_state = "speedspace_ns_[get_transit_state(src)]"
		transform = turn(matrix(), get_transit_angle(src))

/proc/get_transit_state(turf/T)
	var/p = 9
	. = 1
	switch(T.dir)
		if(NORTH)
			. = ((-p*T.x+T.y) % 15) + 1
			if(. < 1)
				. += 15
		if(EAST)
			. = ((T.x+p*T.y) % 15) + 1
		if(WEST)
			. = ((T.x-p*T.y) % 15) + 1
			if(. < 1)
				. += 15
		else
			. = ((p*T.x+T.y) % 15) + 1

/proc/get_transit_angle(turf/T)
	. = 0
	switch(T.dir)
		if(NORTH)
			. = 180
		if(EAST)
			. = 90
		if(WEST)
			. = -90


// =======================
// Legacy static turf type definitions below. Just use the above instead
// =======================

/turf/open/space/transit/north // moving to the north
	shuttlespace_ns1
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_1"
	shuttlespace_ns2
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_2"
	shuttlespace_ns3
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_3"
	shuttlespace_ns4
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_4"
	shuttlespace_ns5
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_5"
	shuttlespace_ns6
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_6"
	shuttlespace_ns7
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_7"
	shuttlespace_ns8
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_8"
	shuttlespace_ns9
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_9"
	shuttlespace_ns10
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_10"
	shuttlespace_ns11
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_11"
	shuttlespace_ns12
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_12"
	shuttlespace_ns13
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_13"
	shuttlespace_ns14
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_14"
	shuttlespace_ns15
		auto_space_icon = FALSE
		icon_state = "speedspace_ns_15"

/turf/open/space/transit/east // moving to the east
	shuttlespace_ew1
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_1"
	shuttlespace_ew2
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_2"
	shuttlespace_ew3
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_3"
	shuttlespace_ew4
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_4"
	shuttlespace_ew5
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_5"
	shuttlespace_ew6
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_6"
	shuttlespace_ew7
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_7"
	shuttlespace_ew8
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_8"
	shuttlespace_ew9
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_9"
	shuttlespace_ew10
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_10"
	shuttlespace_ew11
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_11"
	shuttlespace_ew12
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_12"
	shuttlespace_ew13
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_13"
	shuttlespace_ew14
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_14"
	shuttlespace_ew15
		auto_space_icon = FALSE
		icon_state = "speedspace_ew_15"
