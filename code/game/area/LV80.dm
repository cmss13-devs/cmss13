//LV80 AREAS--------------------------------------//
/area/lv80
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	ambience_exterior = AMBIENCE_JUNGLE
	minimap_color = MINIMAP_AREA_COLONY

/area/lv80/ground
	name = "Ground"
	icon_state = "green"
	always_unpowered = 1 //Will this mess things up? God only knows


//Lazarus landing
/area/lv80/lazarus
	name = "\improper Lazarus"
	icon_state = "green"
	ceiling = CEILING_METAL

/area/lv80/lazarus/landing_zones
	ceiling = CEILING_NONE
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/lv80/lazarus/landing_zones/lz1
	name = "\improper LZ1 Corporate"

/area/lv80/lazarus/landing_zones/lz1/storage
	name = "\improper LZ1 Shipping Storage"

/area/lv80/lazarus/landing_zones/lz1/perimiter
	name = "\improper LZ1 Perimiter"

/area/lv80/lazarus/landing_zones/lz1/perimiter_south
	name = "\improper LZ1 Perimiter South"
	icon_state = "south"

/area/lv80/lazarus/landing_zones/lz1/perimiter_south_east
	name = "\improper LZ1 Perimiter South East"
	icon_state = "south"

/area/lv80/lazarus/landing_zones/lz1/perimiter_south_west
	name = "\improper LZ1 Perimiter South West"
	icon_state = "south"

/area/lv80/lazarus/landing_zones/lz2
	name = "\improper LZ2 Civilian"

/area/lv80/lazarus/landing_zones/lz2/perimiter
	name = "\improper LZ2 Perimiter"

/area/lv80/lazarus/landing_zones/lz2/perimiter_north
	name = "\improper LZ2 Perimiter North"
	icon_state = "north"

/area/lv80/lazarus/landing_zones/lz2/perimiter_south
	name = "\improper LZ2 Perimiter South"
	icon_state = "south"

//Shopping Centre
/area/lv80/ground/shopping_centre
	minimap_color = MINIMAP_AREA_COLONY

/area/lv80/ground/shopping_centre/cafeteria
	name = "\improper Canteen"
	icon_state = "cafeteria"

/area/lv80/ground/shopping_centre/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/lv80/ground/shopping_centre/department_store
	name = "\improper Clothing Store"
	icon_state = "red"

/area/lv80/ground/shopping_centre/mall_hospital
	name = "\improper Mall Hospital"
	icon_state = "south"

/area/lv80/ground/shopping_centre/shooting_range
	name = "\improper Shooting Range"
	icon_state = "blue"

/area/lv80/ground/shopping_centre/mall_office
	name = "\improper Mall Office"
	icon_state = "yellow"

/area/lv80/ground/shopping_centre/mall_storage
	name = "\improper Mall Storage"
	icon_state = "yellow"

/area/lv80/ground/shopping_centre/mall_janitor
	name = "\improper Mall Janitor Room"
	icon_state = "yellow"

//Corporate Offices
/area/lv80/ground/corporate/north_corporate_rooms
	name = "\improper Northern Corporate Offices"
	icon_state = "xeno_lab"

/area/lv80/ground/corporate/middle_corporate_rooms
	name = "\improper Southern Corporate Offices"
	icon_state = "xeno_lab"

/area/lv80/ground/corporate/south_corporate_rooms
	name = "\improper Southern Corporate Offices"
	icon_state = "xeno_lab"

/area/lv80/ground/corporate/parking_lot
	name = "\improper Corporate Parking"
	icon_state = "blue"

/area/lv80/ground/corporate/entrance
	name = "\improper Corporate Parking"
	icon_state = "red"

/area/lv80/ground/corporate/engineering
	name = "\improper Corporate to Engineering Walkway"
	icon_state = "purple"

//Research
/area/lv80/ground/research
	name = "\improper Research Labs"
	icon_state = "yellow"

//Checkpoints
/area/lv80/ground/checkpoint
	name = "\improper Security Checkpoint"
	icon_state = "red"

/area/lv80/ground/checkpoint/north
	name = "\improper North Security Checkpoint"

/area/lv80/ground/checkpoint/south
	name = "\improper South Security Checkpoint"

//Town
/area/lv80/ground/town
	name = "\improper Town Square"
	icon_state = "purple"

/area/lv80/ground/town/church
	name = "\improper Church"
	icon_state = "courtroom"

/area/lv80/ground/town/station
	name = "\improper Police Station"
	icon_state = "brig"

/area/lv80/ground/town/bar
	name = "\improper Bar"
	icon_state = "bar"

/area/lv80/ground/town/community_center
	name = "\improper Community Center"
	icon_state = "yellow"

//Park
/area/lv80/ground/park
	name = "\improper Recreation Park"
	icon_state = "blue"

/area/lv80/ground/park/basketball
	name = "\improper Basketball Court"
	icon_state = "basketball"

/area/lv80/ground/park/botanical
	name = "\improper Botanical Garden"
	icon_state = "yellow"

//Residence
/area/lv80/ground/Residence
	name = "\improper Residence"

/area/lv80/ground/Residence/backyard
	name = "\improper Residence Backyard"

/area/lv80/ground/Residence/fence
	name = "\improper Residence Fence Yard"

//Reactor/water treatment
/area/lv80/ground/engineering
	name = "\improper Engineering"
	icon_state = "yellow"

/area/lv80/ground/engineering/office
	name = "\improper Engineering Offices"
	icon_state = "yellow"

/area/lv80/ground/engineering/storage
	name = "\improper Engineering Storage"
	icon_state = "yellow"

/area/lv80/ground/engineering/water
	name = "\improper Engineering Water Processing"
	icon_state = "yellow"

/area/lv80/ground/engineering/residence
	name = "\improper Engineering Residence Walkway"
	icon_state = "yellow"

//Comms
/area/lv80/ground/communications
	name = "\improper Western Communications"
	icon_state = "blue"

//Tunnels
/area/lv80/ground/tunnels/north_tunnel
	name= "\improper Northern Tunnel"
	icon_state = "north"

/area/lv80/ground/tunnels/north_east_tunnel
	name= "\improper North Eastern Tunnels"
	icon_state = "east"

/area/lv80/ground/tunnels/east_tunnel
	name= "\improper Eastern Tunnels"
	icon_state = "east"
