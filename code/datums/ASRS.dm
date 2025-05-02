//ARSR packs
//These are non orderable packs that get in automaticly though the ARSR system.
//Note these should never show up to buy and some will only show up later in the round.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.


/datum/supply_packs_asrs
	/// How likely we are to select this pack over others
	var/cost = ASRS_MEDIUM_WEIGHT
	/// Which pool of ASRS automatically dispensed supplies this belongs to
	var/pool = ASRS_POOL_MAIN
	/// What supply pack would this dispense
	var/datum/supply_packs/reference_package

//===================================
// Rounds
/datum/supply_packs_asrs/ammo_rounds_box_rifle
	reference_package = /datum/supply_packs/ammo_rounds_box_rifle
	cost = ASRS_MEDIUM_WEIGHT

/datum/supply_packs_asrs/ammo_rounds_box_rifle_ap
	reference_package = /datum/supply_packs/ammo_rounds_box_rifle_ap
	cost = ASRS_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_rounds_box_xm88
	reference_package = /datum/supply_packs/ammo_rounds_box_xm88
	cost = ASRS_LOW_WEIGHT

//===================================
// Magazines
/datum/supply_packs_asrs/gun/ammo_hpr
	reference_package = /datum/supply_packs/ammo_hpr
	cost = ASRS_LOWEST_WEIGHT

/datum/supply_packs_asrs/ammo_m4a3_mag_box
	reference_package = /datum/supply_packs/ammo_m4a3_mag_box
	cost = ASRS_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_m4a3_mag_box_ap
	reference_package = /datum/supply_packs/ammo_m4a3_mag_box_ap
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_m4a3_mag_box_hp
	reference_package = /datum/supply_packs/ammo_m4a3_mag_box_hp
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_mag_box
	reference_package = /datum/supply_packs/ammo_mag_box
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_mag_box_ap
	reference_package = /datum/supply_packs/ammo_mag_box_ap

/datum/supply_packs_asrs/ammo_m4ra_mag_box
	reference_package = /datum/supply_packs/ammo_m4ra_mag_box
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_m4ra_mag_box_ap
	reference_package = /datum/supply_packs/ammo_m4ra_mag_box_ap

/datum/supply_packs_asrs/ammo_shell_box
	reference_package = /datum/supply_packs/ammo_shell_box
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_shell_box_buck
	reference_package = /datum/supply_packs/ammo_shell_box_buck
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_shell_box_flechette
	reference_package = /datum/supply_packs/ammo_shell_box_flechette
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_shell_box_breaching
	reference_package = /datum/supply_packs/ammo_shell_box_breaching
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_xm51
	reference_package = /datum/supply_packs/ammo_xm51
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_smartgun
	reference_package = /datum/supply_packs/ammo_smartgun

/datum/supply_packs_asrs/ammo_napalm
	reference_package = /datum/supply_packs/ammo_napalm
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_napalm_gel
	reference_package = /datum/supply_packs/ammo_napalm_gel
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/ammo_flamer_mixed
	reference_package = /datum/supply_packs/ammo_flamer_mixed
	cost = ASRS_VERY_LOW_WEIGHT

//===================================
// Misc supplies
/datum/supply_packs_asrs/flares
	reference_package = /datum/supply_packs/flares
	cost = ASRS_LOW_WEIGHT

/datum/supply_packs_asrs/mre
	reference_package = /datum/supply_packs/mre
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/flashlights
	reference_package = /datum/supply_packs/flashlights
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/batteries
	reference_package = /datum/supply_packs/batteries
	cost = ASRS_VERY_LOW_WEIGHT

/datum/supply_packs_asrs/repairkits
	reference_package = /datum/supply_packs/repairkits
	cost = ASRS_VERY_LOW_WEIGHT

// ============================
// FOOD POOL - for Mess Tech gradual supplies throughout the round
/datum/supply_packs_asrs/ingredient
	reference_package = /datum/supply_packs/ingredient
	pool = ASRS_POOL_FOOD
	cost = ASRS_VERY_LOW_WEIGHT
