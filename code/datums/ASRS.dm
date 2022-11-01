//ARSR packs
//These are non orderable packs that get in automaticly though the ARSR system.
//Note these should never show up to buy and some will only show up later in the round.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//We use the cost to determine the spawn chance this equals out the crates that spawn later in the round.
#define ASRS_HIGHEST_WEIGHT		0 //warning this weight wont change.
#define ASRS_VERY_HIGH_WEIGHT	5
#define ASRS_HIGH_WEIGHT		15
#define ASRS_MEDIUM_WEIGHT		25
#define ASRS_LOW_WEIGHT			35
#define ASRS_VERY_LOW_WEIGHT	50
#define ASRS_LOWEST_WEIGHT		100

/datum/supply_packs/gun/ammo_hpr/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_LOWEST_WEIGHT

/datum/supply_packs/ammo_rounds_box_smg/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_MEDIUM_WEIGHT

/datum/supply_packs/ammo_rounds_box_smg_ap/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_LOW_WEIGHT

/datum/supply_packs/ammo_rounds_box_rifle/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_MEDIUM_WEIGHT

/datum/supply_packs/ammo_rounds_box_rifle_ap/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_LOW_WEIGHT

/datum/supply_packs/ammo_rounds_box_xm88/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_LOW_WEIGHT

/datum/supply_packs/ammo_m4a3_mag_box/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_LOW_WEIGHT

/datum/supply_packs/ammo_m4a3_mag_box_ap/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_smg_mag_box/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_smg_mag_box_ap/asrs
	buyable = 0
	group = "ASRS"

/datum/supply_packs/ammo_mag_box/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_mag_box_ap/asrs
	buyable = 0
	group = "ASRS"

/datum/supply_packs/ammo_l42_mag_box/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_l42_mag_box_ap/asrs
	buyable = 0
	group = "ASRS"

/datum/supply_packs/ammo_shell_box/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_shell_box_buck/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_shell_box_flechette/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_smartgun/asrs
	buyable = 0
	group = "ASRS"

/datum/supply_packs/ammo_sentry/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_sentry_flamer/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_napalm/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_napalm_gel/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs/ammo_flamer_mixed/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_VERY_LOW_WEIGHT


//===================================
// Mortar ammo
/datum/supply_packs/ammo_mortar_he/asrs
	buyable = 0
	group = "ASRS"

/datum/supply_packs/ammo_mortar_incend/asrs
	buyable = 0
	group = "ASRS"

/datum/supply_packs/ammo_mortar_flare/asrs
	buyable = 0
	group = "ASRS"

//===================================
//speciality armor
/datum/supply_packs/armor_leader/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_LOWEST_WEIGHT

/datum/supply_packs/armor_rto/asrs
	buyable = 0
	group = "ASRS"
	cost = ASRS_LOWEST_WEIGHT
