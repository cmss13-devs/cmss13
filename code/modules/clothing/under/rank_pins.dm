//ranks
/obj/item/clothing/accessory/ranks
	name = "rank pins"
	gender = PLURAL
	desc = "A set of rank pins, used to denote the paygrade of someone within the military."
	icon_state = "ranks_enlisted"
	icon = 'icons/obj/items/clothing/accessory/ranks.dmi'
	inv_overlay_icon = 'icons/obj/items/clothing/accessory/inventory_overlays/ranks.dmi'
	accessory_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/ranks.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/ranks.dmi'
	)
	var/rank = "Private"
	var/rank_short = PAY_SHORT_ME1
	worn_accessory_slot = ACCESSORY_SLOT_RANK
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
	icon_state = "ranks_me1"

/obj/item/clothing/accessory/ranks/marine/e2
	rank_short = PAY_SHORT_ME2
	icon_state = "ranks_me2"

/obj/item/clothing/accessory/ranks/marine/e3
	rank_short = PAY_SHORT_ME3
	icon_state = "ranks_me3"

/obj/item/clothing/accessory/ranks/marine/e4
	rank_short = PAY_SHORT_ME4
	icon_state = "ranks_me4"

/obj/item/clothing/accessory/ranks/marine/e5
	rank_short = PAY_SHORT_ME5
	icon_state = "ranks_me5"

/obj/item/clothing/accessory/ranks/marine/e6
	rank_short = PAY_SHORT_ME6
	icon_state = "ranks_me6"

/obj/item/clothing/accessory/ranks/marine/e7
	rank_short = PAY_SHORT_ME7
	icon_state = "ranks_me7"

/obj/item/clothing/accessory/ranks/marine/e8
	rank_short = PAY_SHORT_ME8
	icon_state = "ranks_me8"

// Marine Enlisted 8E and above, except ME9 haven't been sprited.

/obj/item/clothing/accessory/ranks/marine/e8e
	rank_short = PAY_SHORT_ME8E
	icon_state = "ranks_me8"

/obj/item/clothing/accessory/ranks/marine/e9
	rank_short = PAY_SHORT_ME9
	icon_state = "ranks_me9"

/obj/item/clothing/accessory/ranks/marine/e9e
	rank_short = PAY_SHORT_ME9E
	icon_state = "ranks_me9"

/obj/item/clothing/accessory/ranks/marine/e9c
	rank_short = PAY_SHORT_ME9C
	icon_state = "ranks_me9"

/obj/item/clothing/accessory/ranks/marine/wo
	name = "rank boards"
	rank_short = PAY_SHORT_MWO
	icon_state = "ranks_warrant"

/obj/item/clothing/accessory/ranks/marine/cwo
	name = "rank boards"
	rank_short = PAY_SHORT_MCWO
	icon_state = "ranks_chiefwarrant"

//OFFICERS
/obj/item/clothing/accessory/ranks/marine/o1
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO1
	icon_state = "ranks_o1"

/obj/item/clothing/accessory/ranks/marine/o2
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO2
	icon_state = "ranks_o2"

/obj/item/clothing/accessory/ranks/marine/o3
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO3
	icon_state = "ranks_o3"

/obj/item/clothing/accessory/ranks/marine/o4
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO4
	icon_state = "ranks_o4"

/obj/item/clothing/accessory/ranks/marine/o5
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO5
	icon_state = "ranks_o5"

/obj/item/clothing/accessory/ranks/marine/o6
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO6
	icon_state = "ranks_o6"

/obj/item/clothing/accessory/ranks/marine/o6e
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO6E
	icon_state = "ranks_o6"

/obj/item/clothing/accessory/ranks/marine/o6c
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO6C
	icon_state = "ranks_o6"

/obj/item/clothing/accessory/ranks/marine/o7
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO7
	icon_state = "ranks_o7"

/obj/item/clothing/accessory/ranks/marine/o8
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO8
	icon_state = "ranks_o8"

/obj/item/clothing/accessory/ranks/marine/o9
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO9
	icon_state = "ranks_o9"

/obj/item/clothing/accessory/ranks/marine/o10
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO10
	icon_state = "ranks_o10"

/obj/item/clothing/accessory/ranks/marine/o10c
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO10C
	icon_state = "ranks_o10"

/obj/item/clothing/accessory/ranks/marine/o10s
	name = "officer rank pins"
	rank_short = PAY_SHORT_MO10S
	icon_state = "ranks_o10"

/*################################################
################ ARMY  #####################
################################################*/

// Comented out until someone adds the faction file.

/*
//ENLISTED
/obj/item/clothing/accessory/ranks/army/e1
	rank_short = PAY_SHORT_AE1
	icon_state = "ranks_ae1"

/obj/item/clothing/accessory/ranks/army/e2
	rank_short = PAY_SHORT_AE2
	icon_state = "ranks_ae2"

/obj/item/clothing/accessory/ranks/army/e3
	rank_short = PAY_SHORT_AE3
	icon_state = "ranks_ae3"

/obj/item/clothing/accessory/ranks/army/e4s
	rank_short = PAY_SHORT_AE4E
	icon_state = "ranks_ae4s"

/obj/item/clothing/accessory/ranks/army/e4
	rank_short = PAY_SHORT_AE4
	icon_state = "ranks_ae4"

/obj/item/clothing/accessory/ranks/army/e5
	rank_short = PAY_SHORT_AE5
	icon_state = "ranks_ae5"

/obj/item/clothing/accessory/ranks/army/e6
	rank_short = PAY_SHORT_AE6
	icon_state = "ranks_ae6"

/obj/item/clothing/accessory/ranks/army/e7
	rank_short = PAY_SHORT_AE7
	icon_state = "ranks_ae7"

//until a better sprites can be made, all above E7 will use its icon. -itus

/obj/item/clothing/accessory/ranks/army/e8
	rank_short = PAY_SHORT_AE8
	icon_state = "ranks_ae7"

/obj/item/clothing/accessory/ranks/army/e8c
	rank_short = PAY_SHORT_AE8E
	icon_state = "ranks_ae7"

/obj/item/clothing/accessory/ranks/army/e9
	rank_short = PAY_SHORT_AE9
	icon_state = "ranks_ae7"

/obj/item/clothing/accessory/ranks/army/e9e
	rank_short = PAY_SHORT_AE9E
	icon_state = "ranks_ae7"

/obj/item/clothing/accessory/ranks/army/e9c
	rank_short = PAY_SHORT_AE9C
	icon_state = "ranks_ae7"

/obj/item/clothing/accessory/ranks/army/wo
	name = "rank boards"
	rank_short = PAY_SHORT_AWO
	icon_state = "ranks_warrant"

/obj/item/clothing/accessory/ranks/army/cwo
	name = "rank boards"
	rank_short = PAY_SHORT_ACWO
	icon_state = "ranks_chiefwarrant"

//OFFICERS
/obj/item/clothing/accessory/army/o1
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO1
	icon_state = "ranks_o1"

/obj/item/clothing/accessory/ranks/army/o2
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO2
	icon_state = "ranks_o2"

/obj/item/clothing/accessory/ranks/army/o3
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO3
	icon_state = "ranks_o3"

/obj/item/clothing/accessory/ranks/army/o4
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO4
	icon_state = "ranks_o4"

/obj/item/clothing/accessory/ranks/army/o5
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO5
	icon_state = "ranks_o5"

/obj/item/clothing/accessory/ranks/army/o6
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO6
	icon_state = "ranks_o6"

/obj/item/clothing/accessory/ranks/army/o6e
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO6E
	icon_state = "ranks_o6"

/obj/item/clothing/accessory/ranks/army/o6c
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO6C
	icon_state = "ranks_o6"

/obj/item/clothing/accessory/ranks/army/o7
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO7
	icon_state = "ranks_o7"

/obj/item/clothing/accessory/ranks/army/o8
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO8
	icon_state = "ranks_o8"

/obj/item/clothing/accessory/ranks/army/o9
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO9
	icon_state = "ranks_o9"

/obj/item/clothing/accessory/ranks/army/o10
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO10
	icon_state = "ranks_o10"

/obj/item/clothing/accessory/ranks/army/o10c
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO10C
	icon_state = "ranks_o10"

/obj/item/clothing/accessory/ranks/army/o10s
	name = "officer rank pins"
	rank_short = PAY_SHORT_AO10S
	icon_state = "ranks_o11"

*/

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
