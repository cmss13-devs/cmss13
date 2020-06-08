
//Areas for the Sorokyne Strata (aka Carp Lake.dm)

/* AG in a path stands for ABOVE GROUND, while UG stands for underground.
After that, all areas are sorted by EXTERIOR or INTERIOR. With INTERIOR being any area that isn't nippy and cold. (All buildings & jungle caves)
EXTERIOR is FUCKING FREEZING, and refers to areas out in the open and or exposed to the elements.
*/

/area/strata
	name = "Sorokyne Strata"
	icon = 'icons/turf/area_strata.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "strata"
	can_build_special = TRUE //T-Comms structure
	temperature = SOROKYNE_TEMPERATURE //If not in a building, it'll be cold. All interior areas are set to T20C

/area/shuttle/drop1/strata //Not in Sulaco.DM because holy shit we need to sort things.
	name = "Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	lighting_use_dynamic = 0 //No bad

/area/shuttle/drop2/strata
	name = "Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	lighting_use_dynamic = 0

/*A WHOLE BUNCH OF PARENT ENTITIES
fake_zlevel = 1 or 2. 1 is 'above' 2 is 'below', however ladders are flipped and think that 1 is below, and 2 is above.
But, players don't actually care where they are so long as the ladders look correct going up and down. They shouldn't notice.
However, this might break the tacmap. This entire system might be replaced by Slywater's fake-Z smooth transition anyway.*/

/area/strata/ag
	name = "Above Ground Area"
	icon_state = "ag"
	fake_zlevel = 1 //'Above' ground fake Z

/area/strata/ag/exterior
	name = "Exterior Above Ground Area"
	icon_state = "ag_e"
	//always_unpowered = 1 So exterior lights work, this will be commented out unless it causes unforseen issues.
	is_resin_allowed = FALSE

/area/strata/ag/exterior/paths
	is_resin_allowed = TRUE

/area/strata/ag/exterior/restricted
	flags_atom = AREA_NOTUNNEL

/area/strata/ag/interior
	name = "Interior Above Ground Area"
	icon_state = "ag_i"
	requires_power = 1
	can_hellhound_enter = 0
	temperature = T20C //Nice and room temp
	ceiling = CEILING_METAL

/area/strata/ag/interior/restricted
	is_resin_allowed = FALSE
	flags_atom = AREA_NOTUNNEL

/area/strata/ag/interior/restricted/devroom
	name = "Super Secret Credits Room"

/area/strata/ug
	name = "Under Ground Area"
	icon_state = "ug"
	fake_zlevel = 2 //'Underground', because numbers are fun
	ceiling = CEILING_UNDERGROUND

/area/strata/ug/interior
	name = "Interior Under Ground Area"
	icon_state = "ug_i"
	requires_power = 1
	can_hellhound_enter = 0
	temperature = T20C

/area/strata/ug/exterior
	name = "Exterior Under Ground Area"
	icon_state = "ug_i"
	requires_power = 1
	can_hellhound_enter = 0
	temperature = T20C
	ceiling = CEILING_NONE

//END PARENT ENTITIES

//Begin actual area definitions. There's probably a better way to do this.

//Landing Zones, places near LZs (Open Air, Above Ground)

/area/strata/ag/interior/landingzone_1
	name = "Landing Zone 1 Pad - Mining Aerodrome"
	icon_state = "landingzone_1"
	weather_enabled = FALSE
	unlimited_power = 1 //So the DS computer always works for the Queen

/area/strata/ag/exterior/landingzone_2
	name = "Landing Zone 2 Pad - Ice Fields"
	icon_state = "landingzone_2"
	weather_enabled = FALSE
	unlimited_power = 1 //So the DS computer always works for the Queen

/area/strata/ag/interior/nearlz1
	name = "Landing Zone 1 - Mining Aerodrome"
	icon_state = "nearlz1"
	weather_enabled = FALSE
	is_resin_allowed = FALSE

/area/strata/ag/exterior/nearlz2
	name = "Landing Zone 2 - Ice Fields"
	icon_state = "nearlz2"
	weather_enabled = TRUE //This LZ is outside, but consider disabling if it destroys the meta.

/area/strata/ag/exterior/landingzone_valley
	name = "Landing Zone Valley"
	icon_state = "lzvalley"

/area/strata/ag/exterior/landingzone_lake
	name = "Landing Zone Lake Ice"
	icon_state = "lzfrozenlake"

/area/strata/ag/exterior/landingzone_water
	name = "Landing Zone Lake Water"
	icon_state = "lzfrozenwater"
	temperature = TCMB //Cold enough to kill through protective clothing.

/////Research Station//////

/area/strata/ag/exterior/research_decks
	name = "Outpost Decks"
	icon_state = "rdecks"
	is_resin_allowed = TRUE

/area/strata/ag/exterior/research_decks/north
	name = "North Outpost Decks"

/area/strata/ag/exterior/research_decks/south
	name = "South Outpost Decks"

/area/strata/ag/exterior/research_decks/east
	name = "East Outpost Decks"

/area/strata/ag/exterior/research_decks/west
	name = "West Outpost Decks"

/area/strata/ag/exterior/research_decks/center //The decks on the deck.
	name = "Seconday Outpost Decks"

/area/strata/ag/exterior/research_decks/pipes //pipemaze thingy
	name = "Pipes at Outpost Decks"
	icon_state = "security_station"

/area/strata/ag/interior/research_decks/security //For all security stuff outside the outpost.
	name = "Outpost Deck Security Checkpoint"
	icon_state = "rdecks_sec"

/area/strata/ag/exterior/paths/north_outpost //The area north of the outpost
	name = "Outpost - North Access Channel"
	icon_state = "outpost_gen_2"

////////close to research/////////

/area/strata/ag/exterior/paths/southresearch
	name = "South Of The Outpost"

/area/strata/ag/exterior/shed_five_caves
	name = "Terminal Five Topside Caves"
	icon_state = "lzcaves"
	is_resin_allowed = TRUE

////////Telecomms//////////////////

/area/strata/ag/interior/tcomms/ //T-Comms is inside until you leave the sheltered area..
	name = "Telecommunications Relay"
	icon_state = "tcomms1"

/area/strata/ag/interior/tcomms/tcomms_engi
	name = "Telecommunications Maintenance"
	icon_state = "tcomms2"

/area/strata/ag/exterior/tcomms/tcomms_cave
	name = "Telecommunications Cave"
	icon_state = "tcomms3"

/area/strata/ag/exterior/tcomms/tcomms_deck
	name = "Telecommunications Storage Deck"
	icon_state = "tcomms4"

//JUNGLE CAVES, ALL UNDERGROUND, ALL INTERIOR//

/area/strata/ug/interior/jungle
	name = "Deep I"

//Maintenance/Generator Sheds (Above & Below Ground)
//Terminals are below ground, Sheds are above ground.

/area/strata/ag/interior/engi_shed //Above ground parent
	name = "engi_shed AG parent"
	icon_state = "shed_x_ag"

/area/strata/ug/interior/engi_shed //Below ground parent
	name = "engi_shed UG parent"
	icon_state = "shed_x_ug"

///Engineering Terminals / Sheds, whatever. Map Power///

/area/strata/ag/interior/engi_shed/one
	name = "Generator Shed One"
	icon_state = "shed_1_ag"
	ceiling = CEILING_METAL

/area/strata/ug/interior/engi_shed/one
	name = "Generator Terminal One"
	icon_state = "shed_1_ug"

/area/strata/ag/interior/engi_shed/two
	name = "Generator Shed Two"
	icon_state = "shed_2_ag"

/area/strata/ug/interior/engi_shed/two
	name = "Generator Terminal Two"
	icon_state = "shed_2_ug"

/area/strata/ag/interior/engi_shed/three
	name = "Generator Shed Three"
	icon_state = "shed_3_ag"

/area/strata/ug/interior/engi_shed/three
	name = "Generator Terminal Three"
	icon_state = "shed_3_ug"

/area/strata/ag/interior/engi_shed/four
	name = "Generator Shed Four"
	icon_state = "shed_4_ag"

/area/strata/ug/interior/engi_shed/four
	name = "Generator Terminal Four"
	icon_state = "shed_4_ug"

/area/strata/ag/interior/engi_shed/five
	name = "Generator Shed Five"
	icon_state = "shed_5_ag"

/area/strata/ug/interior/engi_shed/five
	name = "Generator Terminal Five"
	icon_state = "shed_5_ug"

/area/strata/ag/interior/engi_shed/six
	name = "Generator Shed Six"
	icon_state = "shed_6_ag"

/area/strata/ug/interior/engi_shed/six
	name = "Generator Terminal Six"
	icon_state = "shed_6_ug"

/area/strata/ag/interior/engi_shed/seven
	name = "Generator Shed Seven"
	icon_state = "shed_7_ag"

/area/strata/ug/interior/engi_shed/seven
	name = "Generator Terminal Seven"
	icon_state = "shed_7_ug"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL

/area/strata/ag/interior/engi_shed/eight
	name = "Generator Shed Eight"
	icon_state = "shed_8_ag"

/area/strata/ug/interior/engi_shed/eight
	name = "Generator Terminal Eight"
	icon_state = "shed_8_ug"


//Topside Structures //Clean these up into a sub tree

/area/strata/ag/interior/landingzone_checkpoint
	name = "Landing Zone Security Checkpoint"
	icon_state = "security_station"

/area/strata/ag/exterior/landingzone_checkpoint_deck
	name = "Landing Zone Security Checkpoint Deck"
	icon_state = "security_station"

/area/strata/ag/exterior/disposals
	name = "Disposals Courtyard"
	icon_state = "disposal"

/area/strata/ag/interior/disposals
	name = "Disposals Overhang"
	icon_state = "disposal"

/area/strata/ag/interior/vanjam //a jam, just for vans
	name = "Flight Control Garage Overhang"
	icon_state = "garage"

/area/strata/ag/exterior/vanyard
	name = "Flight Control Vehicle Yard"
	icon_state = "garage"

/area/strata/ag/interior/administration
	name = "Flight Control Offices"
	icon_state = "offices"

/area/strata/ag/exterior/administration_decks
	name = "Flight Control Office Deck"
	icon_state = "offices"

/area/strata/ag/interior/administrative_wash_closet
	name = "Flight Control Wash Closet"
	icon_state = "offices"

/area/strata/ag/interior/dorms
	name = "External Mining Dormitories"
	icon_state = "dorms_0"
	is_resin_allowed = FALSE

/area/strata/ag/interior/dorms/north
	name = "North External Mining Dormitories"
	icon_state = "dorms_1"

/area/strata/ag/interior/dorms/west
	name = "West External Mining Dormitories"
	icon_state = "dorms_2"

/area/strata/ag/interior/dorms/south
	name = "South External Mining Dormitories"
	icon_state = "dorms_3"

/area/strata/ag/exterior/dorms_deck
	name = "External Mining Dormitory Decks"
	icon_state = "dorms_2"

/area/strata/ag/interior/dorms/maintenance
	name = "External Mining Dormitory Maintenance"
	icon_state = "outpost_maint"
	is_resin_allowed = TRUE

/area/strata/ag/interior/dorms/hive
	name = "External Mining Dormitory Thermal Storage"
	icon_state = "dorms_beno"
	is_resin_allowed = TRUE

/area/strata/ag/interior/dorms/canteen
	name = "External Mining Dormitory Canteen"
	icon_state = "dorms_canteen"

/area/strata/ag/interior/dorms/flight_control
	name = "External Mining Flight Control"
	icon_state = "dorms_lobby"

/area/strata/ag/interior/dorms/lobby
	name = "External Mining Lobby"
	icon_state = "dorms_2"

/area/strata/ag/interior/dorms/bar
	name = "External Mining Bar"
	icon_state = "dorms_1"


//More topside areas, somehow these got duplicated?? Includes some parent defs.

//Also marshes

/area/strata/ag/exterior/marsh
	name = "Cryo-Thermal Marshes"
	icon_state = "marsh"

/area/strata/ag/exterior/marsh/center
	name = "Cryo-Thermal Springs"
	icon_state = "marshcenter"

/area/strata/ag/exterior/marsh/river
	name = "Cryo-Thermal River"
	icon_state = "marshriver"

/area/strata/ag/exterior/marsh/crash
	name = "Cryo-Thermal Crashed Lifeboat"
	icon_state = "marshship"

/area/strata/ag/exterior/marsh/water
	name = "Cryo-Thermal Water"
	icon_state = "marshwater"
	temperature = TCMB //space cold

/area/strata/ag/exterior/north_lz_caves
	name = "External Mining Aerodrome Caves"
	icon_state = "lzcaves"

/area/strata/ag/exterior/paths //parent entity, just for sorting within the object tree, if anything, very generic, use as a placeholder.
	name = "Ice Path"
	icon_state = "path"

/area/strata/ag/exterior/paths/northadmin
	name = "North Of Flight Control"

/area/strata/ag/exterior/paths/eastadmin
	name = "East Of Flight Control"

/area/strata/ag/exterior/paths/southadmin
	name = "South Of Flight Control"

/area/strata/ag/exterior/paths/westadmin
	name = "West Of Flight Control"

/area/strata/ag/exterior/paths/dorms_quad //The area between the deck.
	name = "Mining Dormitories Quad"
	icon_state = "path"
	is_resin_allowed = FALSE

/area/strata/ag/exterior/paths/cabin_area
	name = "Far North Of The Outpost"
	icon_state = "cabin"

/area/strata/ag/exterior/paths/cabin_area/lake
	name = "Wooden Hospital - Lake"

/area/strata/ag/exterior/paths/cabin_area/shed
	name = "Wooden Hospital - Out Shed"

/area/strata/ag/exterior/paths/cabin_area/central
	name = "Wooden Hospital - Front Yard"

/area/strata/ag/interior/paths/cabin_area/central
	name = "Wooden Hospital - Hospital Proper"
	icon_state = "cabin3"

/area/strata/ag/interior/paths/cabin_area/cave
	name = "Wooden Hospital - Forgotten Passage"
	icon_state = "hive_1"

/area/strata/ag/exterior/paths/cabin_area/minehead
	name = "Wooden Hospital - Minehead"

/area/strata/ug/interior/jungle/deep/minehead
	icon_state = "cabin2"
	name = "Deep Jungle - Minehead"


///OUTPOST INTERIOR///

/area/strata/ag/interior/outpost
	name = "Sorokyne Outpost"
	icon_state = "research_station"

/area/strata/ag/interior/outpost/gen
	name = "Outpost Interior"
	icon_state = "outpost_gen_0"

/area/strata/ag/interior/outpost/gen/foyer
	name = "Outpost Main Foyer"
	icon_state = "outpost_gen_1"

/area/strata/ag/interior/outpost/gen/bball //come on and SLAM.
	name = "Outpost Basket Ball Court"
	icon_state = "outpost_gen_4"

/area/strata/ag/interior/outpost/gen/bball/nest //come on and BURST AND DIE.
	name = "Outpost - B-Ball Caves"
	icon_state = "hive_1"


///ALL MAINTENANCE AREAS///


/area/strata/ag/interior/outpost/maint
	name = "Outpost Maintenance"
	icon_state = "outpost_maint"

/area/strata/ag/interior/outpost/maint/foyer1
	name = "Outpost Main Foyer North Maintenance"

/area/strata/ag/interior/outpost/maint/foyer2
	name = "Outpost Main Foyer South Maintenance"

/area/strata/ag/interior/outpost/maint/med1
	name = "Outpost Medical - Admin Lobby Maintenance"

/area/strata/ag/interior/outpost/maint/med2
	name = "Outpost Medical - Directors Office Maintenance"

/area/strata/ag/interior/outpost/maint/med3
	name = "Outpost Medical - Admin Lounge Maintenance"

/area/strata/ag/interior/outpost/maint/sec_west
	name = "Outpost Security - West Maintenance"

/area/strata/ag/interior/outpost/maint/aerodrome_to_admin
	name = "Outpost Aerodrome - West Maintenance"

/area/strata/ag/interior/outpost/maint/aerodrome_to_jungle
	name = "Outpost Aerodrome - South Maintenance"

/area/strata/ag/interior/outpost/maint/canteen_e_1
	name = "Outpost Canteen - Eastern Maintenance"

/area/strata/ag/interior/outpost/maint/canteen_e_2
	name = "Outpost Canteen - Emergency Rations"

/area/strata/ag/interior/outpost/maint/canteen_e_3
	name = "Outpost Canteen - Emergency Manuals"

/area/strata/ag/interior/outpost/maint/bar
	name = "Outpost Bar - Maintenance"

///OUTPOST MEDICAL///

/area/strata/ag/interior/outpost/med
	name = "Outpost Medical"
	icon_state = "outpost_med"

/area/strata/ag/interior/outpost/med/hall
	name = "Outpost Medical Primary Hall"
	icon_state = "outpost_med_hall"

/area/strata/ag/interior/outpost/med/reception
	name = "Outpost Medical Reception"
	icon_state = "outpost_med_recp"

/area/strata/ag/interior/outpost/med/or1
	name = "Outpost Medical Operating Theatre 1"
	icon_state = "outpost_med_or"

/area/strata/ag/interior/outpost/med/chemstorage
	name = "Outpost Medical Chemical Storage"
	icon_state = "outpost_med_chem"

/area/strata/ag/interior/outpost/med/recovery
	name = "Outpost Medical Recovery"
	icon_state = "outpost_med_recovery"

/area/strata/ag/interior/outpost/med/paperroom
	name = "Outpost Medical Paper Room"
	icon_state = "outpost_med_stock"

/area/strata/ag/interior/outpost/med/spareuniform
	name = "Outpost Medical Spare Uniform Closet"
	icon_state = "outpost_med_closet"

/area/strata/ag/interior/outpost/med/lounge
	name = "Outpost Medical Lounge"

/area/strata/ag/interior/outpost/med/utility
	name = "Outpost Medical Utility Closet"

/area/strata/ag/interior/outpost/med/lounge
	name = "Outpost Medical Lounge"

/area/strata/ag/interior/outpost/med/stockroom
	name = "Outpost Medical Stock Room"
	icon_state = "outpost_med_stock"

/area/strata/ag/interior/outpost/med/morgue
	name = "Outpost Morgue"

/area/strata/ag/interior/outpost/med/autopsy
	name = "Outpost Autopsy Room"

/area/strata/ag/interior/outpost/med/records
	name = "Outpost Medical - Engineering Records"

/area/strata/ag/interior/outpost/med/jung_hall
	name = "Outpost Medical South Hall"

/area/strata/ag/interior/outpost/med/jungle_lock
	name = "Outpost Medical Cave Lock"

///OUTPOST ENGINEERING///

/area/strata/ag/interior/outpost/engi
	name = "Outpost Engineering"
	icon_state = "outpost_engi_0"

/area/strata/ag/interior/outpost/engi/foyer
	name = "Outpost Engineering Main Foyer"
	icon_state = "outpost_engi_1"

/area/strata/ag/interior/outpost/engi/foyerdecks
	name = "Outpost Engineering Main Foyer Decks"

/area/strata/ag/interior/outpost/engi/garage
	name = "Outpost Engineering Garage"

/area/strata/ag/interior/outpost/engi/tool_storage
	name = "Outpost Engineering Tool Storage"
	icon_state = "outpost_engi_2"

/area/strata/ag/interior/outpost/engi/power_monitoring
	name = "Outpost Engineering Power Monitoring"
	icon_state = "outpost_engi_3"

/area/strata/ag/interior/outpost/engi/hall
	name = "Outpost Engineering Main Hall"

/area/strata/ag/interior/outpost/engi/emergency_storage
	name = "Outpost Engineering Emergency Storage"
	icon_state = "outpost_engi_4"

/area/strata/ag/interior/outpost/engi/drome
	name = "Outpost Aerodome"
	icon_state = "outpost_engi_4"

/area/strata/ag/interior/outpost/engi/drome/shuttle
	name = "Dismantled VDVK Eagle Mk 4"
	icon_state = "outpost_engi_3"

/area/strata/ag/interior/outpost/engi/drome/security
	name = "Outpost Aerodome Security Station"
	icon_state = "outpost_engi_2"

/area/strata/ag/interior/outpost/engi/drome/northlock
	name = "Outpost Aerodome EOD Closet"
	icon_state = "outpost_engi_2"

/area/strata/ag/interior/outpost/engi/drome/foreman
	name = "Outpost Foreman's Office"
	icon_state = "outpost_engi_1"

/area/strata/ag/interior/outpost/engi/drome/northhall
	name = "Outpost Aerodrome North Hall"

/area/strata/ag/interior/outpost/engi/drome/jung_hall
	name = "Outpost Aerodrome East Hall"

/area/strata/ag/interior/outpost/engi/drome/jungle_lock
	name = "Outpost Aerodrome Cave Lock"
	icon_state = "outpost_engi_4"

///OUTPOST SECURITY

/area/strata/ag/interior/outpost/security
	name = "Outpost Security"
	icon_state = "outpost_sec_0"

/area/strata/ag/interior/outpost/security/hall
	name = "Outpost Security Main Hall"
	icon_state = "outpost_sec_1"

/area/strata/ag/interior/outpost/security/armory
	name = "Outpost Armory"
	icon_state = "outpost_sec_4"

/area/strata/ag/interior/outpost/security/access_line
	name = "Outpost Security ID Processing"
	icon_state = "outpost_sec_3"

/area/strata/ag/interior/outpost/security/breakroom
	name = "Outpost Security Breakroom"
	icon_state = "outpost_sec_2"

/area/strata/ag/interior/outpost/security/holding
	name = "Outpost Security Holding Cell"
	icon_state = "outpost_sec_4"

/area/strata/ag/interior/outpost/security/briefing
	name = "Outpost Security Briefing"

/area/strata/ag/interior/outpost/security/lockers
	name = "Outpost Security Locker Room"

/area/strata/ag/interior/outpost/security/wardens
	name = "Outpost Warden's Office"
	icon_state = "outpost_sec_3"

/area/strata/ag/interior/outpost/security/helpdesk
	name = "Outpost Helpdesk"

/area/strata/ag/interior/outpost/security/dispatch
	name = "Outpost Security Dispatch And Monitoring"
	icon_state = "outpost_sec_3"

///OUTPOST ADMINISTRATION

/area/strata/ag/interior/outpost/admin
	name = "Outpost Administration"
	icon_state = "outpost_admin_0"

/area/strata/ag/interior/outpost/admin/dir_office
	name = "Outpost Director's Office"
	icon_state = "outpost_admin_1"

/area/strata/ag/interior/outpost/admin/dir_waiting
	name = "Outpost Administration Waiting Room"

/area/strata/ag/interior/outpost/admin/office_0
	name = "Outpost Administration Offices Ground Level"

/area/strata/ag/interior/outpost/admin/office_1
	name = "Outpost Administration Offices Level 1"
	icon_state = "outpost_admin_1"

/area/strata/ag/interior/outpost/admin/office_2
	name = "Outpost Administration Offices Level 2"
	icon_state = "outpost_admin_2"

/area/strata/ag/interior/outpost/admin/lounge
	name = "Outpost Administration Lounge"
	icon_state = "outpost_admin_4"

/area/strata/ag/interior/outpost/admin/records
	name = "Outpost Administration Records"
	icon_state = "outpost_admin_4"

/area/strata/ag/interior/outpost/admin/wc
	name = "Outpost Administration Wash Closet"
	icon_state = "outpost_admin_2"

/area/strata/ag/interior/outpost/admin/backhall
	name = "Outpost Administration East Hall"

///CANTEEN / GENERAL QUARTERS///

/area/strata/ag/interior/outpost/canteen
	name = "Outpost Canteen"
	icon_state = "outpost_canteen_0"

/area/strata/ag/interior/outpost/canteen/kitchen
	name = "Outpost Kitchen"
	icon_state = "outpost_canteen_1"

/area/strata/ag/interior/outpost/canteen/bar
	name = "Outpost Bar"
	icon_state = "outpost_canteen_2"

/area/strata/ag/interior/outpost/canteen/northlock
	name = "Outpost Canteen North Airlock"
	icon_state = "outpost_canteen_2"

/area/strata/ag/interior/outpost/canteen/freezer
	name = "Outpost Kitchen and Bar Freezer"
	icon_state = "outpost_canteen_3"

/area/strata/ag/interior/outpost/canteen/janitors
	name = "Outpost Sanitation Closet"
	icon_state = "outpost_canteen_4"

/area/strata/ag/interior/outpost/canteen/upper_cafeteria
	name = "Outpost Cafeteria Elevated Seating"
	icon_state = "outpost_canteen_4"

/area/strata/ag/interior/outpost/canteen/lower_cafeteria
	name = "Outpost Cafeteria"
	icon_state = "outpost_canteen_0"

/area/strata/ag/interior/outpost/canteen/hall
	name = "Outpost Canteen East Hall"
	icon_state = "outpost_canteen_3"

/area/strata/ag/interior/outpost/canteen/personal_storage
	name = "Outpost Personal Storage"

/area/strata/ag/interior/outpost/canteen/spare_uniforms
	name = "Outpost Spare Uniform Closet"

/area/strata/ag/interior/outpost/canteen/showers
	name = "Outpost Communal Showers"

/area/strata/ag/interior/outpost/canteen/bar_2
	name = "Outpost Gambling Den"

/area/strata/ag/interior/outpost/canteen/jungle_lock
	name = "Outpost General Cave Lock"


///JUNGLE STRUCTURES - UNDERGROUND///

/area/strata/ug/interior/outpost/jung
	name = "Underground Jungle Structures"
	icon_state = "ug_jung_dorm"

/area/strata/ug/interior/outpost/jung/dorms
	name = "Underground Dorms"

/area/strata/ug/interior/outpost/jung/dorms/sec1
	name = "Underground Security Dorm #1"

/area/strata/ug/interior/outpost/jung/dorms/sec2
	name = "Underground Security Dorm #2"

/area/strata/ug/interior/outpost/jung/dorms/admin1
	name = "Underground General Staff Dorm #1"

/area/strata/ug/interior/outpost/jung/dorms/admin2
	name = "Underground General Staff Dorm #2"

/area/strata/ug/interior/outpost/jung/dorms/admin3
	name = "Underground General Staff Dorm #3"

/area/strata/ug/interior/outpost/jung/dorms/admin4
	name = "Underground Colony Administration Dorm #1"

/area/strata/ug/interior/outpost/jung/dorms/engi1
	name = "Underground Engineering Dorm #1"

/area/strata/ug/interior/outpost/jung/dorms/engi2
	name = "Underground Engineering Dorm #2"

/area/strata/ug/interior/outpost/jung/dorms/engi3
	name = "Underground Engineering Dorm #3"

/area/strata/ug/interior/outpost/jung/dorms/engi4
	name = "Underground Engineering Dorm #4"

/area/strata/ug/interior/outpost/jung/dorms/med1
	name = "Underground Medical Dorm #1"

/area/strata/ug/interior/outpost/jung/dorms/med2
	name = "Underground Medical Dorm #2"


////END OUTPOST DEFINES////

///DEEP JUNGLE///

/area/strata/ug/interior/jungle
	name = "Underground Jungle"
	icon_state = "ug_jung_0"

/area/strata/ug/interior/jungle/platform
	name = "Underground Platform"
	icon_state = "ug_jung_2"

/area/strata/ug/interior/jungle/platform/south
	name = "Underground Platform South"

/area/strata/ug/interior/jungle/platform/south/scrub
	name = "Underground Platform South Scrub"
	icon_state = "ug_jung_1"

/area/strata/ug/interior/jungle/platform/east
	name = "Underground Platform East"

/area/strata/ug/interior/jungle/platform/east/scrub
	name = "Underground Platform East Scrub"
	icon_state = "ug_jung_1"

/area/strata/ug/interior/jungle/deep
	name = "Deep Jungle"
	ceiling = CEILING_DEEP_UNDERGROUND

/area/strata/ug/interior/jungle/deep/carplake
	name = "Deep Jungle - Carp Lake Shores"
	icon_state = "ug_jung_2"

/area/strata/ug/exterior
	ceiling = CEILING_NONE

/area/strata/ug/exterior/jungle/deep/carplake_water
	name = "Deep Jungle - Carp Lake Waters"
	icon_state = "ug_jung_5"

/area/strata/ug/exterior/jungle/deep/carplake_center
	name = "Deep Jungle - Carp Lake Center Island"
	icon_state = "ug_jung_1"


/area/strata/ug/interior/jungle/deep/north_carp
	name = "Deep Jungle - North of Carp Lake"
	icon_state = "ug_jung_6"

/area/strata/ug/interior/jungle/deep/south_carp
	name = "Deep Jungle - South of Carp Lake"
	icon_state = "ug_jung_3"

/area/strata/ug/interior/jungle/deep/east_carp
	name = "Deep Jungle - East of Carp Lake"
	icon_state = "ug_jung_5"

/area/strata/ug/interior/jungle/deep/tearlake
	name = "Deep Jungle - Weeping Pool"
	icon_state = "ug_jung_3"

/area/strata/ug/interior/jungle/deep/tearlake_south
	name = "Deep Jungle - South of Weeping Pool"
	icon_state = "ug_jung_8"

/area/strata/ug/interior/jungle/deep/tearlake_north
	name = "Deep Jungle - North of Weeping Pool"
	icon_state = "ug_jung_3"

/area/strata/ug/interior/jungle/deep/tearlake_east
	name = "Deep Jungle - East of Weeping Pool"
	icon_state = "ug_jung_6"

/area/strata/ug/interior/jungle/deep/tearlake_west
	name = "Deep Jungle - West of Weeping Pool"
	icon_state = "ug_jung_5"

/area/strata/ug/interior/jungle/deep/south_dorms
	name = "Deep Jungle - South Dorms"
	icon_state = "ug_jung_4"

/area/strata/ug/interior/jungle/deep/east_dorms
	name = "Deep Jungle - East Dorms"
	icon_state = "ug_jung_0"

/area/strata/ug/interior/jungle/deep/structures
	name = "Deep Jungle - Unknown Structure"
	icon_state = "ug_jung_1"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL

/area/strata/ug/interior/jungle/deep/structures/res
	icon_state = "ug_jung_2"
	name = "Deep Jungle - Classified Research Station"

/area/strata/ug/interior/jungle/deep/south_res
	icon_state = "ug_jung_3"
	name = "Deep Jungle - South of Classified Research Station"

/area/strata/ug/interior/jungle/deep/hotsprings
	icon_state = "ug_jung_4"
	name = "Deep Jungle - Hot Springs"

/area/strata/ug/interior/jungle/deep/structures/engi
	icon_state = "ug_jung_5"
	name = "Deep Jungle - Planetary Core Monitoring"

/area/strata/ug/interior/jungle/deep/south_engi
	icon_state = "ug_jung_7"
	name = "Deep Jungle - South of Core Monitoring"

/area/strata/ug/interior/jungle/deep/east_engi
	icon_state = "ug_jung_6"
	name = "Deep Jungle - East of Core Monitoring"

/area/strata/ug/interior/jungle/deep/west_engi
	icon_state = "ug_jung_8"
	name = "Deep Jungle - West of Core Monitoring"

/area/strata/ug/interior/jungle/deep/minehead
	icon_state = "ug_jung_mine_1"
	name = "Deep Jungle - Old Tunnels"

/area/strata/ug/interior/jungle/deep/minehead/north
	icon_state = "ug_jung_mine_2"
	name = "Deep Jungle - North Old Tunnels"

/area/strata/ug/interior/jungle/deep/minehead/south
	icon_state = "ug_jung_mine_3"
	name = "Deep Jungle - South Old Tunnels"

/area/strata/ug/interior/jungle/deep/minehead/east
	icon_state = "ug_jung_mine_4"
	name = "Deep Jungle - East Old Tunnels"

/area/strata/ug/interior/jungle/deep/minehead/west
	icon_state = "ug_jung_mine_5"
	name = "Deep Jungle - West Old Tunnels"

/area/strata/ug/interior/jungle/deep/minehead/ruins
	icon_state = "ug_jung_mine_4"
	name = "Deep Jungle - Ancient Dorms"





