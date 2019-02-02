//ARSR packs 
//These are non orderable packs that get in automaticly though the ARSR system. 
//Note these should never show up to buy and some will only show up later in the round. 
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//We use the cost to determine the spawn chance this equals out the crates that spawn later in the round.
#define ASRS_HIGHEST_WEIGHT		0
#define ASRS_VERY_HIGH_WEIGHT	5
#define ASRS_HIGH_WEIGHT		15
#define ASRS_MEDIUM_WEIGHT		25
#define ASRS_LOW_WEIGHT			35
#define ASRS_VERY_LOW_WEIGHT	50
#define ASRS_LOWEST_WEIGHT		100

/datum/supply_packs/asrs/
	cost = ASRS_LOWEST_WEIGHT
	buyable = 0

/datum/supply_packs/flares/asrs
	group = "Utility"
	buyable = 0

/datum/supply_packs/weapons_sentry/asrs
	buyable = 0
	group = "Defence"

/datum/supply_packs/heavyweapons_ammo/asrs
	buyable = 0
	group = "Munition"

/datum/supply_packs/explosives/asrs
	buyable = 0
	group = "Offence"

/datum/supply_packs/explosives_mines/asrs/
	buyable = 0
	group = "Defence"

/datum/supply_packs/explosives_m15/asrs/
	buyable = 0
	group = "Offence"

/datum/supply_packs/explosives_plastique/asrs/
	buyable = 0
	group = "Utility"

/datum/supply_packs/explosives_incendiary/asrs/
	buyable = 0
	group = "Offence"

/datum/supply_packs/explosives_M40_HEDP/asrs/
	buyable = 0
	group = "Offence"

/datum/supply_packs/explosives_hedp/asrs/
	buyable = 0
	group = "Offence"

/datum/supply_packs/explosives_M40_HEDP/asrs/
	buyable = 0
	group = "Offence"

/datum/supply_packs/explosives_hefa/asrs/
	buyable = 0
	group = "Offence"

/datum/supply_packs/ammo_mag_box/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_smg_mag_box/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_mag_box_ext/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_smg_mag_box_ext/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_mag_box_ap/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_smg_mag_box_ap/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_shell_box/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_shell_box_buck/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_regular/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_regular_m41a/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_regular_m4a3/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_regular_m44/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_regular_m39/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_regular_m37a2/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_extended/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_extended_m41a/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_extended_m4a3/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_extended_m39/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_ap/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_ap_m41a/asrs/
	buyable = 0
	group = "Munition"
	
/datum/supply_packs/ammo_ap_m4a3/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_ap_m39/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_box_rifle/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_box_rifle_ap/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_box_smg/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/surplus/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/ammo_smartgun/asrs/
	buyable = 0
	group = "Munition"
	
/datum/supply_packs/ammo_sentry/asrs/
	buyable = 0
	group = "Munition"
	
/datum/supply_packs/napalm/asrs/
	buyable = 0
	group = "Munition"

/datum/supply_packs/sandbags/asrs/
	buyable = 0
	group = "Defence"

/datum/supply_packs/metal50/asrs/
	group = "Defence"
	buyable = 0

/datum/supply_packs/plas50/asrs/
	group = "Defence"
	buyable = 0

/datum/supply_packs/m56d_hmg/asrs/
	name = "m56d crate (x1)"
	contains = list()
	cost = ASRS_MEDIUM_WEIGHT
	containertype = /obj/item/storage/box/m56d_hmg
	containername = "m56d crate"
	group = "Defence"
	buyable = 0

/datum/supply_packs/m56_system/asrs/
	name = "m56 system crate (x1)"
	contains = list()
	cost = ASRS_MEDIUM_WEIGHT
	containertype = /obj/item/storage/box/m56_system
	containername = "m56 system crate"
	group = "Offence"
	iteration_needed = 30
	buyable = 0
		
/datum/supply_packs/motiondetector/asrs/
	name = "Motion Detector (x2)"
	contains = list(
		/obj/item/device/motiondetector,
		/obj/item/device/motiondetector
					)
	cost = ASRS_MEDIUM_WEIGHT
	containertype = /obj/structure/closet/crate/supply
	containername = "Motion Detector crate"
	group = "Utility"
	buyable = 0

/datum/supply_packs/spec_kit/asrs/
	name = "Specialist gear crate (x1)"
	contains = list(/obj/item/spec_kit/asrs)
	cost = ASRS_LOWEST_WEIGHT
	containertype = /obj/structure/closet/crate/supply
	containername = "specialist gear crate"
	group = "Offence"
	iteration_needed = 300
	buyable = 0