/turf/closed/wall/r_wall
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to separate rooms."
	icon_state = "r_wall_mapicon"

	damage_cap = HEALTH_WALL_REINFORCED

	walltype = WALL_REINFORCED


//Just different looking wall
/turf/closed/wall/r_wall/research
	icon_state = "research"
	walltype = WALL_REINFORCED_RESEARCH

/turf/closed/wall/r_wall/dense
	icon_state = "iron0"
	walltype = WALL_REINFORCED_IRON
	turf_flags = TURF_HULL

/turf/closed/wall/r_wall/unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon_state = "heavy_r_wall_mapicon"
	walltype = WALL_REINFORCED
	turf_flags = TURF_HULL

/turf/closed/wall/r_wall/unmeltable/attackby() //This should fix everything else. No cables, etc
	return

//Chigusa

/turf/closed/wall/r_wall/chigusa
	name = "facility wall"
	icon = 'icons/turf/walls/chigusa.dmi'
	icon_state = "chigusa"
	walltype = WALL_REINFORCED_CHIGUSA

/turf/closed/wall/r_wall/chigusa/update_icon()
	..()
	if(special_icon)
		return
	if(neighbors_bitfield == (EAST|WEST))
		var/r1 = rand(0,10) //Make a random chance for this to happen
		var/r2 = rand(0,3) // Which wall if we do choose it
		if(r1 >= 9)
			overlays += image(icon, icon_state = "deco_wall[r2]")

//Bunker Walls

/turf/closed/wall/r_wall/bunker
	name = "bunker wall"
	icon = 'icons/turf/walls/bunker.dmi'
	icon_state = "bunker"
	walltype = WALL_REINFORCED_BUNKER

//Prison

/turf/closed/wall/r_wall/prison
	name = "reinforced metal wall"
	icon = 'icons/turf/walls/prison.dmi'
	icon_state = "rwall"
	walltype = WALL_REINFORCED

/turf/closed/wall/r_wall/prison_unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon = 'icons/turf/walls/prison.dmi'
	icon_state = "hwall"
	walltype = WALL_REINFORCED
	turf_flags = TURF_HULL

/turf/closed/wall/r_wall/prison_unmeltable/ex_act(severity) //Should make it indestructible
		return

/turf/closed/wall/r_wall/prison_unmeltable/fire_act(exposed_temperature, exposed_volume)
		return

/turf/closed/wall/r_wall/prison_unmeltable/attackby() //This should fix everything else. No cables, etc
		return

//Biodome

/turf/closed/wall/r_wall/biodome
	name = "reinforced metal wall"
	icon = 'icons/turf/walls/corsat.dmi'
	icon_state = "r_dome"
	walltype = WALL_DOMER

/turf/closed/wall/r_wall/biodome/biodome_unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon_state = "h_dome"
	turf_flags = TURF_HULL

/turf/closed/wall/r_wall/biodome/biodome_unmeltable/ex_act(severity) //Should make it indestructible
		return

/turf/closed/wall/r_wall/biodome/biodome_unmeltable/fire_act(exposed_temperature, exposed_volume)
		return

/turf/closed/wall/r_wall/biodome/biodome_unmeltable/attackby() //This should fix everything else. No cables, etc
		return


/// Destructible elevator walls, for when you want the elevator to act as a prop rather than an actual elevator
/turf/closed/wall/r_wall/elevator
	icon = 'icons/turf/elevator.dmi'
	icon_state = "wall"
	special_icon = TRUE

// Wall with gears that animate when elevator is moving
/turf/closed/wall/r_wall/elevator/gears
	icon_state = "wall_gear"

// Special wall icons
/turf/closed/wall/r_wall/elevator/research
	icon_state = "wall_research"

/turf/closed/wall/r_wall/elevator/dorm
	icon_state = "wall_dorm"

/turf/closed/wall/r_wall/elevator/freight
	icon_state = "wall_freight"

/turf/closed/wall/r_wall/elevator/arrivals
	icon_state = "wall_arrivals"

// Elevator Buttons
/turf/closed/wall/r_wall/elevator/button
	name = "elevator buttons"

/turf/closed/wall/r_wall/elevator/button/research
	icon_state = "wall_button_research"

/turf/closed/wall/r_wall/elevator/button/dorm
	icon_state = "wall_button_dorm"

/turf/closed/wall/r_wall/elevator/button/freight
	icon_state = "wall_button_freight"

/turf/closed/wall/r_wall/elevator/button/arrivals
	icon_state = "wall_button_arrivals"

