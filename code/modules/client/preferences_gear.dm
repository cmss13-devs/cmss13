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

/datum/gear/cmbeanie
	display_name = "USCM Beanie (gray)"
	path = /obj/item/clothing/head/beanie/gray
	cost = 3
	slot = WEAR_HEAD

/datum/gear/cmbeanie/green
	display_name = "USCM Beanie (green)"
	path = /obj/item/clothing/head/beanie/green

/datum/gear/cmbeanie/tan
	display_name = "USCM Beanie (tan)"
	path = /obj/item/clothing/head/beanie/tan	

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
	cost = 1

/datum/gear/coif
	display_name = "Coif"
	path = /obj/item/clothing/mask/rebreather/scarf
	cost = 2
	slot = WEAR_FACE	

/datum/gear/cmbalaclava
	display_name = "USCM Balaclava (Green)"
	path = /obj/item/clothing/mask/rebreather/scarf/green
	cost = 2
	slot = WEAR_FACE

/datum/gear/cmbalaclava/tan
	display_name = "USCM Balaclava (Tan)"
	path = /obj/item/clothing/mask/rebreather/scarf/tan
	cost = 2
	slot = WEAR_FACE

/datum/gear/cmbalaclava/gray
	display_name = "USCM Balaclava (Gray)"
	path = /obj/item/clothing/mask/rebreather/scarf/gray
	cost = 2
	slot = WEAR_FACE	

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



/datum/gear/tacticalmaskblack
	display_name = "Tactical Mask (Green)"
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green
	slot = WEAR_FACE
	cost = 2
//
/datum/gear/greenfacepaint
	display_name = "Green Facepaint"
	path = /obj/item/facepaint/green
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/brownfacepaint
	display_name = "Brown Facepaint"
	path = /obj/item/facepaint/brown
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/blackfacepaint
	display_name = "Black Facepaint"
	path = /obj/item/facepaint/black
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/skullfacepaint
	display_name = "Skull Facepaint"
	path = /obj/item/facepaint/skull
	slot = WEAR_IN_BACK
	cost = 4 //there needs to be some reason to NOT use this badass facepaint or every marine will have it

/datum/gear/aceofspades
	display_name = "Ace of Spades"
	path = /obj/item/toy/handcard/aceofspades
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/pack_emeraldgreen
	display_name = "Pack Of Emerald Greens"
	path = /obj/item/storage/fancy/cigarettes/emeraldgreen
	slot = WEAR_IN_BACK
	cost = 1

/datum/gear/pack_lucky_strikes
	display_name = "Pack Of Lucky Strikes"
	path = /obj/item/storage/fancy/cigarettes/lucky_strikes
	slot = WEAR_IN_BACK
	cost = 1

/datum/gear/type_80_Bayonet
	display_name = "Type 80 Bayonet"
	path = /obj/item/attachable/bayonet/upp
	slot = WEAR_IN_BACK
	cost = 4

/datum/gear/uno_reverse_red
	display_name = "Uno Reverse - Red"
	path = /obj/item/toy/handcard/uno_reverse_red
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/uno_reverse_blue
	display_name = "Uno Reverse - Blue"
	path = /obj/item/toy/handcard/uno_reverse_blue
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/uno_reverse_purple
	display_name = "Uno Reverse - Purple"
	path = /obj/item/toy/handcard/uno_reverse_purple
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/uno_reverse_yellow
	display_name = "Uno Reverse - Yellow"
	path = /obj/item/toy/handcard/uno_reverse_yellow
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/candy
	display_name = "Bar of candy"
	path = /obj/item/reagent_container/food/snacks/candy
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/lime
	display_name = "Lucky Lime"
	path = /obj/item/reagent_container/food/snacks/grown/lime
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/pen
	display_name = "Pen"
	path = /obj/item/tool/pen
	slot = WEAR_IN_BACK
	cost = 1

/datum/gear/lighter
	display_name = "Random Lighter"
	path = /obj/item/tool/lighter/random
	slot = WEAR_IN_BACK
	cost = 2

/datum/gear/uscmpatch
	display_name = "USCM shoulder patch"
	path = /obj/item/clothing/accessory/patch
	cost = 1
	slot = WEAR_IN_ACCESSORY

/datum/gear/falconpatch
	display_name = "Falling Falcons shoulder patch"
	path = /obj/item/clothing/accessory/patch/falcon
	cost = 1
	slot = WEAR_IN_ACCESSORY

/datum/gear/gas_mask
	display_name = "Gas Mask"
	path = /obj/item/clothing/mask/gas
	cost = 2
	slot = WEAR_FACE
/datum/gear/gunoil
	display_name = "Gun Oil"
	path = /obj/item/prop/helmetgarb/gunoil
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/netting
	display_name = "Helmet Netting"
	path = /obj/item/prop/helmetgarb/netting
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/spent_buck
	display_name = "Spent Buckshot"
	path = /obj/item/prop/helmetgarb/spent_buckshot
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/spent_slugs
	display_name = "Spent Slugs"
	path = /obj/item/prop/helmetgarb/spent_slug
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/spent_flechette
	display_name = "Spent Flechette"
	path = /obj/item/prop/helmetgarb/spent_flech
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/prescription_bottle
	display_name = "Prescription Bottle"
	path = /obj/item/prop/helmetgarb/prescription_bottle
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/raincover
	display_name = "Helmet Rain Cover"
	path = /obj/item/prop/helmetgarb/raincover
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/rabbits_foot
	display_name = "Rabbit's Foot"
	path = /obj/item/prop/helmetgarb/rabbitsfoot
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/rosary
	display_name = "Rosary"
	path = /obj/item/prop/helmetgarb/rosary
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/lucky_feather
	display_name = "Lucky Feather"
	path = /obj/item/prop/helmetgarb/lucky_feather
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/flair_initech
	display_name = "Initech Flair"
	path = /obj/item/prop/helmetgarb/flair_initech
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/flair_io
	display_name = "Io Flair"
	path = /obj/item/prop/helmetgarb/flair_io
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/flair_peace
	display_name = "Peace and Love Flair"
	path = /obj/item/prop/helmetgarb/flair_peace
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/flair_uscm
	display_name = "USCM Flair"
	path = /obj/item/prop/helmetgarb/flair_uscm
	cost = 1
	slot = WEAR_IN_BACK

/datum/gear/spacejam_tickets
	display_name = "Authentic Tickets to Space Jam"
	path = /obj/item/prop/helmetgarb/spacejam_tickets
	cost = 4
	slot = WEAR_IN_BACK