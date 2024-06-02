//ranks
/obj/item/clothing/accessory/ranks
	name = "rank pins"
	gender = PLURAL
	desc = "A set of rank pins, used to denote the paygrade of someone within the military."
	icon_state = "ranks_enlisted"
	var/rank = "Private"
	var/rank_short = PAY_SHORT_ME1
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
	rank_short = PAY_SHORT_ME2

/obj/item/clothing/accessory/ranks/marine/e3
	rank_short = PAY_SHORT_ME3

/obj/item/clothing/accessory/ranks/marine/e4
	rank_short = PAY_SHORT_ME4
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/marine/e5
	rank_short = PAY_SHORT_ME5
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/marine/e6
	rank_short = PAY_SHORT_ME6
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e7
	rank_short = PAY_SHORT_ME7
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e8
	rank_short = PAY_SHORT_ME8
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e8e
	rank_short = PAY_SHORT_ME8E
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e9
	rank_short = PAY_SHORT_ME9
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e9e
	rank_short = PAY_SHORT_ME9E
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/marine/e9c
	rank_short = PAY_SHORT_ME9C
	icon_state = "ranks_snco"

//OFFICERS
/obj/item/clothing/accessory/ranks/marine/o1
	name = "rank boards"
	rank_short = PAY_SHORT_MO1
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/marine/o2
	name = "rank boards"
	rank_short = PAY_SHORT_MO2
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/marine/o3
	name = "rank boards"
	rank_short = PAY_SHORT_MO3
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/marine/o4
	name = "rank boards"
	rank_short = PAY_SHORT_MO4
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/marine/o5
	name = "rank boards"
	rank_short = PAY_SHORT_MO5
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/marine/o6
	name = "rank boards"
	rank_short = PAY_SHORT_MO6
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/marine/o6e
	name = "rank boards"
	rank_short = PAY_SHORT_MO6E
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/marine/o6c
	name = "rank boards"
	rank_short = PAY_SHORT_MO6C
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o7
	name = "rank boards"
	rank_short = PAY_SHORT_MO7
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o8
	name = "rank boards"
	rank_short = PAY_SHORT_MO8
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o9
	name = "rank boards"
	rank_short = PAY_SHORT_MO9
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o10
	name = "rank boards"
	rank_short = PAY_SHORT_MO10
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o10c
	name = "rank boards"
	rank_short = PAY_SHORT_MO10C
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/marine/o10s
	name = "rank boards"
	rank_short = PAY_SHORT_MO10S
	icon_state = "ranks_flagofficer"

/*################################################
################ NAVY  #####################
################################################*/
//ENLISTED
/obj/item/clothing/accessory/ranks/navy/e1
	rank_short = PAY_SHORT_NE1

/obj/item/clothing/accessory/ranks/navy/e2
	rank_short = PAY_SHORT_NE2

/obj/item/clothing/accessory/ranks/navy/e3
	rank_short = PAY_SHORT_NE3

/obj/item/clothing/accessory/ranks/navy/e4
	rank_short = PAY_SHORT_NE4
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/navy/e5
	rank_short = PAY_SHORT_NE5
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/navy/e6
	rank_short = PAY_SHORT_NE6
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/navy/e7
	rank_short = PAY_SHORT_NE7
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/navy/e8
	rank_short = PAY_SHORT_NE8
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/navy/e8c
	rank_short = PAY_SHORT_NE8C
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/navy/e9
	rank_short = PAY_SHORT_NE9
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/navy/e9c
	rank_short = PAY_SHORT_NE9C
	icon_state = "ranks_snco"

//OFFICERS
/obj/item/clothing/accessory/ranks/navy/o1
	name = "rank boards"
	rank_short = PAY_SHORT_NO1
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/navy/o2
	name = "rank boards"
	rank_short = PAY_SHORT_NO2
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/navy/o3
	name = "rank boards"
	rank_short = PAY_SHORT_NO3
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/navy/o4
	name = "rank boards"
	rank_short = PAY_SHORT_NO4
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/navy/o5
	name = "rank boards"
	rank_short = PAY_SHORT_NO5
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/navy/o6
	name = "rank boards"
	rank_short = PAY_SHORT_NO6
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/navy/o6e
	name = "rank boards"
	rank_short = PAY_SHORT_NO6E
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/navy/o6c
	name = "rank boards"
	rank_short = PAY_SHORT_NO6C
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/navy/o7
	name = "rank boards"
	rank_short = PAY_SHORT_NO7
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/navy/o8
	name = "rank boards"
	rank_short = PAY_SHORT_NO8
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/navy/o9
	name = "rank boards"
	rank_short = PAY_SHORT_NO9
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/navy/o10
	name = "rank boards"
	rank_short = PAY_SHORT_NO10
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/navy/o10c
	name = "rank boards"
	rank_short = PAY_SHORT_NO10C
	icon_state = "ranks_flagofficer"

/*################################################
################# SPECIAL  #################
################################################*/
/obj/item/clothing/accessory/ranks/special/insp
	name = "rank boards"
	rank_short = "PvI"
	icon_state = "ranks_pvstofficer"
