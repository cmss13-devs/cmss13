//ranks
/obj/item/clothing/accessory/ranks
	name = "rank pins"
	gender = PLURAL
	desc = "A set of rank pins, used to denote the paygrade of someone within the military."
	icon_state = "ranks_enlisted"
	var/rank = "Private"
	var/rank_short = "ME1"
	slot = ACCESSORY_SLOT_RANK
	high_visibility = TRUE
	gender = PLURAL
	jumpsuit_hide_states = UNIFORM_JACKET_REMOVED

/obj/item/clothing/accessory/ranks/New()
	..()
	name = "[initial(name)] ([rank_short])"
	desc = "[initial(desc)] This one is for the rank <b>[get_paygrades(rank_short)]</b>."

/*################################################
################ MARINE  ###################
################################################*/
//ENLISTED
/obj/item/clothing/accessory/ranks/marine/e1

/obj/item/clothing/accessory/ranks/marine/e2
	rank_short = "ME2"

/obj/item/clothing/accessory/ranks/marine/e3
	rank_short = "ME3"

/obj/item/clothing/accessory/ranks/marine/e4
	rank_short = "ME4"
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/marine/e5
	rank_short = "ME5"
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/marine/e6
	rank_short = "ME6"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e7
	rank_short = "ME7"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e8
	rank_short = "ME8"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e8e
	rank_short = "ME8E"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e9
	rank_short = "ME9"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e9e
	rank_short = "ME9E"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e9c
	rank_short = "ME9C"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e10c
	rank_short = "ME10C"
	icon_state = "ranks_snco"
	icon_state = "ranks_snco"

//OFFICERS
/obj/item/clothing/accessory/ranks/marine/o1
	name = "rank boards"
	rank_short = "MO1"
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/marine/o2
	name = "rank boards"
	rank_short = "MO2"
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/marine/o3
	name = "rank boards"
	rank_short = "MO3"
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/marine/o4
	name = "rank boards"
	rank_short = "MO4"
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/marine/o5
	name = "rank boards"
	rank_short = "MO5"
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/marine/o6
	name = "rank boards"
	rank_short = "MO6"
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/marine/o6e
	name = "rank boards"
	rank_short = "MO6E"
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/marine/o6c
	name = "rank boards"
	rank_short = "MO6C"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o7
	name = "rank boards"
	rank_short = "MO7"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o8
	name = "rank boards"
	rank_short = "MO8"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o9
	name = "rank boards"
	rank_short = "MO9"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o10
	name = "rank boards"
	rank_short = "MO10"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o10c
	name = "rank boards"
	rank_short = "MO10C"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o10s
	name = "rank boards"
	rank_short = "MO10S"
	icon_state = "ranks_flagofficer"

/*################################################
################ NAVY  #####################
################################################*/
//ENLISTED
/obj/item/clothing/accessory/ranks/navy/e1
	rank_short = "NE1"

/obj/item/clothing/accessory/ranks/navy/e2
	rank_short = "NE2"

/obj/item/clothing/accessory/ranks/navy/e3
	rank_short = "NE3"

/obj/item/clothing/accessory/ranks/navy/e4
	rank_short = "NE4"
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/navy/e5
	rank_short = "NE5"
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/navy/e6
	rank_short = "NE6"
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/navy/e7
	rank_short = "NE7"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/navy/e7/pvst
	icon_state = "ranks_pvst"

/obj/item/clothing/accessory/ranks/navy/e8
	rank_short = "NE8"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/navy/e8/pvst
	icon_state = "ranks_pvst"

/obj/item/clothing/accessory/ranks/navy/e8c
	rank_short = "NE8C"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/navy/e9
	rank_short = "NE9"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/navy/e9/pvst
	icon_state = "ranks_pvst"

/obj/item/clothing/accessory/ranks/navy/e9c
	rank_short = "NE9C"
	icon_state = "ranks_snco"

//OFFICERS
/obj/item/clothing/accessory/ranks/navy/o1
	name = "rank boards"
	rank_short = "NO1"
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/navy/o2
	name = "rank boards"
	rank_short = "NO2"
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/navy/o3
	name = "rank boards"
	rank_short = "NO3"
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/navy/o4
	name = "rank boards"
	rank_short = "NO4"
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/navy/o5
	name = "rank boards"
	rank_short = "NO5"
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/navy/o6
	name = "rank boards"
	rank_short = "NO6"
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/navy/o6e
	name = "rank boards"
	rank_short = "NO6E"
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/navy/o6c
	name = "rank boards"
	rank_short = "NO6C"
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/navy/o7
	name = "rank boards"
	rank_short = "NO7"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/navy/o8
	name = "rank boards"
	rank_short = "NO8"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/navy/o8/pvst
	icon_state = "ranks_pvstofficer"

/obj/item/clothing/accessory/ranks/navy/o9
	name = "rank boards"
	rank_short = "NO9"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/navy/o9/pvst
	icon_state = "ranks_pvstofficer"

/obj/item/clothing/accessory/ranks/navy/o10
	name = "rank boards"
	rank_short = "NO10"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/navy/o10/pvst
	icon_state = "ranks_pvstofficer"

/obj/item/clothing/accessory/ranks/navy/o10c
	name = "rank boards"
	rank_short = "NO10C"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/navy/o10c/pvst
	rank_short = "PvCM"
	icon_state = "ranks_pvstofficer"

/*################################################
################# SPECIAL  #################
################################################*/
/obj/item/clothing/accessory/ranks/special/insp
	name = "rank boards"
	rank_short = "PvI"
	icon_state = "ranks_pvstofficer"
