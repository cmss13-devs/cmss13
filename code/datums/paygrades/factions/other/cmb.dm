/datum/paygrade/cmb
	name = "CMB Paygrade"
	pay_multiplier = 1.4 // Government work. Nice benefits.

/datum/paygrade/cmb/standard
	paygrade = "GS-9"
	name = "CMB Deputy"
	prefix = "Dep."

/datum/paygrade/cmb/leader
	paygrade = "GS-13"
	name = "CMB Marshal"
	prefix = "Marshal"

/datum/paygrade/cmb/syn
	paygrade = "GS-C.9"
	name = "CMB Investigative Synthetic"

/datum/paygrade/cmb/liaison
	paygrade = "GS-6"
	name = "Interstellar Commerce Commission Corporate Liaison"
	prefix = "Exec."

/datum/paygrade/cmb/observer
	paygrade = "GS-3"
	name = "Interstellar Human Rights Observer"
/datum/paygrade/marine
	name = "Marine Paygrade"
	rank_pin = /obj/item/clothing/accessory/ranks/marine
	pay_multiplier = 1

// ENLISTED PAYGRADES

/datum/paygrade/marine/e1
	paygrade = "ME1"
	name = "Private"
	prefix = "PVT"
	rank_pin = /obj/item/clothing/accessory/ranks/marine/e1
	ranking = 0
	pay_multiplier = 0.8

/datum/paygrade/marine/e2
	paygrade = "ME2"
	name = "Private First Class"
	prefix = "PFC"
	rank_pin = /obj/item/clothing/accessory/ranks/marine/e2
	ranking = 1
	pay_multiplier = 1 // the default.

/datum/paygrade/marine/e3
	paygrade = "ME3"
	name = "Lance Corporal"
	prefix = "LCpl"
	rank_pin = /obj/item/clothing/accessory/ranks/marine/e3
	ranking = 2
	pay_multiplier = 1.4

/datum/paygrade/marine/e4
	paygrade = "ME4"
	name = "Corporal"
	prefix = "Cpl"
	rank_pin = /obj/item/clothing/accessory/ranks/marine/e4
	ranking = 3
	pay_multiplier = 1.6

/datum/paygrade/marine/e5
	paygrade = "ME5"
	name = "Sergeant"
	prefix = "Sgt"
	rank_pin = /obj/item/clothing/accessory/ranks/marine/e5
	ranking = 4
	pay_multiplier = 1.8

/datum/paygrade/marine/e6
	paygrade = "ME6"
	name = "Staff Sergeant"
	prefix = "SSgt"
	rank_pin = /obj/item/clothing/accessory/ranks/marine/e6
	ranking = 5
	pay_multiplier = 2
