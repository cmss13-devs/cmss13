var/global/list/gear_datums = list()

/hook/startup/proc/populate_gear_list()
	for(var/type in typesof(/datum/gear)-/datum/gear)
		var/datum/gear/G = new type()
		gear_datums[G.display_name] = G
	return 1

/datum/gear
	var/display_name       //Name/index.
	var/path               //Path to item.
	var/cost               //Number of points used.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/whitelisted        //Term to check the whitelist for..

// This is sorted both by slot and alphabetically! Don't fuck it up!
// Headslot items

/datum/gear/cmbandana
	display_name = "USCM Bandana (Green)"
	path = /obj/item/clothing/head/cmbandana
	cost = 3
	slot = WEAR_HEAD

/datum/gear/cmbandanatan
	display_name = "USCM Bandana (Tan)"
	path = /obj/item/clothing/head/cmbandana/tan
	cost = 3
	slot = WEAR_HEAD

/datum/gear/cmberet
	display_name = "USCM Beret (Green)"
	path = /obj/item/clothing/head/beret/cm
	cost = 3
	slot = WEAR_HEAD

/datum/gear/cmberettan
	display_name = "USCM Beret (Tan)"
	path = /obj/item/clothing/head/beret/cm/tan
	cost = 3
	slot = WEAR_HEAD

/datum/gear/cmheadband
	display_name = "USCM Headband (Green)"
	path = /obj/item/clothing/head/headband
	cost = 3
	slot = WEAR_HEAD

/datum/gear/cmheadbandred
	display_name = "USCM Headband (Red)"
	path = /obj/item/clothing/head/headband/red
	cost = 3
	slot = WEAR_HEAD

/datum/gear/cmheadbandtan
	display_name = "USCM Headband (Tan)"
	path = /obj/item/clothing/head/headband/tan
	cost = 3
	slot = WEAR_HEAD

/datum/gear/cmheadset
	display_name = "USCM Earpiece"
	path = /obj/item/clothing/head/headset
	cost = 3
	slot = WEAR_HEAD

/datum/gear/cmcap
	display_name = "USCM Cap"
	path = /obj/item/clothing/head/cmcap
	cost = 3
	slot = WEAR_HEAD

/datum/gear/booniehat
	display_name = "USCM Boonie Hat (Olive)"
	path = /obj/item/clothing/head/booniehat
	cost = 3
	slot = WEAR_HEAD

/datum/gear/booniehattan
	display_name = "USCM Boonie Hat (Tan)"
	path = /obj/item/clothing/head/booniehat/tan
	cost = 3
	slot = WEAR_HEAD

/datum/gear/eyepatch
	display_name = "Eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	cost = 2
	slot = WEAR_EYES

/datum/gear/thugshades
	display_name = "Shades"
	path = /obj/item/clothing/glasses/sunglasses/big
	cost = 2
	slot = WEAR_EYES

/datum/gear/prescription
	display_name = "Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	cost = 2
	slot = WEAR_EYES

/datum/gear/cigar
	display_name = "Cigar"
	path = /obj/item/clothing/mask/cigarette/cigar
	slot = WEAR_FACE
	cost = 2

/datum/gear/cigarette
	display_name = "Cigarette"
	path = /obj/item/clothing/mask/cigarette
	slot = WEAR_FACE
	cost = 2

/datum/gear/cmgoggles
	display_name = "Ballistic Goggles"
	path = /obj/item/clothing/glasses/mgoggles
	cost = 2
	slot = WEAR_EYES

/datum/gear/cmPgoggles
	display_name = "Prescription Goggles"
	path = /obj/item/clothing/glasses/mgoggles/prescription
	cost = 2
	slot = WEAR_EYES

/datum/gear/aviators
	display_name = "Aviator Shades"
	path = /obj/item/clothing/glasses/sunglasses/aviator
	cost = 2
	slot = WEAR_EYES

/datum/gear/rpgglasses
	display_name = "Marine RPG Glasses"
	path = /obj/item/clothing/glasses/regular
	cost = 2
	slot = WEAR_EYES

/datum/gear/prescglasses
	display_name = "Prescription Glasses"
	path = /obj/item/clothing/glasses/regular/hipster
	cost = 2
	slot = WEAR_EYES

/datum/gear/tacticalmask
	display_name = "Tactical Mask (Gray)"
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask
	slot = WEAR_FACE
	cost = 2

/datum/gear/tacticalmasktan
	display_name = "Tactical Mask (Tan)"
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/tan
	slot = WEAR_FACE
	cost = 2

/datum/gear/tacticalmaskgreen
	display_name = "Tactical Mask (Red)"
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/red
	slot = WEAR_FACE
	cost = 2

/datum/gear/tacticalmaskblack
	display_name = "Tactical Mask (Green)"
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green
	slot = WEAR_FACE
	cost = 2