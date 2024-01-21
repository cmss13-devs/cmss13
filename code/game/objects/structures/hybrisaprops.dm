// Hybrisa props

/obj/structure/prop/hybrisa
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
	icon_state = "pimp"

// Cave props

/obj/structure/prop/hybrisa/boulders
	icon = 'icons/obj/structures/props/boulder_largedark.dmi'
	icon_state = "boulder_largedark1"

/obj/structure/prop/hybrisa/boulders/large_boulderdark
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/boulder_largedark.dmi'
	icon_state = "boulder_largedark1"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/hybrisa/boulders/large_boulderdark/boulder_dark1
	icon_state = "boulder_largedark1"
/obj/structure/prop/hybrisa/boulders/large_boulderdark/boulder_dark2
	icon_state = "boulder_largedark2"

/obj/structure/prop/hybrisa/boulders/wide_boulderdark
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/boulder_widedark.dmi'
	icon_state = "boulderwidedark"
	bound_height = 32
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/hybrisa/boulders/wide_boulderdark/wide_boulder1
	icon_state = "boulderwidedark"

/obj/structure/prop/hybrisa/boulders/smallboulderdark
	name = "boulder"
	icon_state = "bouldersmalldark1"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/boulder_small.dmi'
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/hybrisa/boulders/smallboulderdark/boulder_dark1
	icon_state = "bouldersmalldark1"
/obj/structure/prop/hybrisa/boulders/smallboulderdark/boulder_dark2
	icon_state = "bouldersmalldark2"
/obj/structure/prop/hybrisa/boulders/smallboulderdark/boulder_dark3
	icon_state = "bouldersmalldark3"

/obj/structure/prop/hybrisa/cavedecor
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	name = "stalagmite"
	icon_state = "stalagmite"
	desc = "A cave stalagmite."
/obj/structure/prop/hybrisa/cavedecor/stalagmite0
	icon_state = "stalagmite"
/obj/structure/prop/hybrisa/cavedecor/stalagmite1
	icon_state = "stalagmite1"
/obj/structure/prop/hybrisa/cavedecor/stalagmite2
	icon_state = "stalagmite2"
/obj/structure/prop/hybrisa/cavedecor/stalagmite3
	icon_state = "stalagmite3"
/obj/structure/prop/hybrisa/cavedecor/stalagmite4
	icon_state = "stalagmite4"
/obj/structure/prop/hybrisa/cavedecor/stalagmite5
	icon_state = "stalagmite5"

// Vehicles

/obj/structure/prop/hybrisa/vehicles
    icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
    icon_state = "SUV"

/obj/structure/prop/hybrisa/vehicles/suv
    icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
    icon_state = "SUV"

/obj/structure/prop/hybrisa/vehicles/suvdamaged
    icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
    icon_state = "SUV_damaged"

/obj/structure/prop/hybrisa/vehicles/largetruck
    icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
    icon_state = "zenithlongtruck3"

/obj/structure/prop/hybrisa/vehicles/suv
	name = "SUV"
	desc = "Seems to be broken down."
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
	icon_state = "SUV"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/suv/suv_1
	icon_state = "SUV1"
/obj/structure/prop/hybrisa/vehicles/suv/suv_2
	icon_state = "SUV2"
/obj/structure/prop/hybrisa/vehicles/suv/suv_5
	icon_state = "SUV5"
/obj/structure/prop/hybrisa/vehicles/suv/suv_6
	icon_state = "SUV6"
/obj/structure/prop/hybrisa/vehicles/suv/suv_7
	icon_state = "SUV7"
/obj/structure/prop/hybrisa/vehicles/suv/suv_8
	icon_state = "SUV8"

// damaged suv

/obj/structure/prop/hybrisa/vehicles/suvdamaged
    name = "heavily damaged SUV"
    desc = "A shell of a vehicle, broken down beyond repair."
/obj/structure/prop/hybrisa/vehicles/suvdamaged/suv_damaged0
	icon_state = "SUV_damaged"
/obj/structure/prop/hybrisa/vehicles/suvdamaged/suv_damaged1
	icon_state = "SUV1_damaged"
/obj/structure/prop/hybrisa/vehicles/suvdamaged/suv_damaged2
	icon_state = "SUV2_damaged"

// small trucks

/obj/structure/prop/hybrisa/vehicles/truck
	name = "truck"
	icon_state = "zentruck1"
	desc = "Seems to be broken down."
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/truck/truck1
	icon_state = "zentruck2"
/obj/structure/prop/hybrisa/vehicles/truck/truck2
	icon_state = "zentruck3"
/obj/structure/prop/hybrisa/vehicles/truck/truck3
	icon_state = "zentruck4"
/obj/structure/prop/hybrisa/vehicles/truck/truck4
	icon_state = "zentruck5"
/obj/structure/prop/hybrisa/vehicles/truck/garbage
	name = "garbage truck"
	icon_state = "zengarbagetruck"
	desc = "Seems to be broken down."

// large trucks

/obj/structure/prop/hybrisa/vehicles/largetruck
	name = "mega-hauler truck"
	icon_state = "zenithlongtruck4"
	desc = "Seems to be broken down."
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruck1
	icon_state = "zenithlongtruck2"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruck2
	icon_state = "zenithlongtruck3"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruck3
	icon_state = "zenithlongtruck4"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruck4
	icon_state = "zenithlongtruck5"

// mining truck

/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckmining
	icon_state = "zenithlongtruckkellandmining1"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckmining
    name = "Kelland mining mega-hauler truck"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckmining/mining
	icon_state = "zenithlongtruckkellandmining1"

// w-y truck

/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckwy
	icon_state = "zenithlongtruckweyland1"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckwy
    name = "Weyland-Yutani mega-hauler truck"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckwy/wy1
	icon_state = "zenithlongtruckweyland1"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckwy/wy2
	icon_state = "zenithlongtruckweyland2"

// Colony Crawlers

/obj/structure/prop/hybrisa/vehicles/colonycrawlers
	icon_state = "crawler_wy2"
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining
	icon_state = "miningcrawler1"
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/science
	icon_state = "crawler_wy2"
	desc = "It is a tread bound crawler used in harsh conditions. This one is designed for personnel transportation. Supplied by Orbital Blue International; 'Your friends, in the Aerospace business.' A subsidiary of Weyland Yutani."
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'

// science crawlers

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/science
    name = "weyland-yutani colony crawler"

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/science/science1
	icon_state = "crawler_wy1"
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/science/science2
	icon_state = "crawler_wy2"
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'

// Mining Crawlers

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining
    name = "kelland mining colony crawler"

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining/mining1
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon_state = "miningcrawler2"
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining/mining2
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon_state = "miningcrawler3"
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining/mining3
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon_state = "miningcrawler4"
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining/mining4
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon_state = "miningcrawlerblank"

// Special SUV's

/obj/structure/prop/hybrisa/vehicles/suv/misc
	name = "Weyland-Yutani rapid response vehicle"
	desc = "Seems to be broken down."
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
	icon_state = "WYSUV1"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/suv/misc/wy1
	icon_state = "WYSUV1"
/obj/structure/prop/hybrisa/vehicles/suv/misc/wy2
	icon_state = "WYSUV2"
/obj/structure/prop/hybrisa/vehicles/suv/misc/wy3
	icon_state = "WYSUV3"
/obj/structure/prop/hybrisa/vehicles/suv/misc/ambulance
	name = "emergency response medical van"
	desc = "Seems to be broken down."
	icon_state = "ambulance"
/obj/structure/prop/hybrisa/vehicles/suv/misc/whitevan
	name = "maintenance SUV"
	desc = "Seems to be broken down."
	icon_state = "whitevan"
/obj/structure/prop/hybrisa/vehicles/suv/misc/maintenance
	name = "maintenance SUV"
	desc = "Seems to be broken down."
	icon_state = "maintenaceSUV"
/obj/structure/prop/hybrisa/vehicles/suv/misc/marshalls
	name = "colonial marshalls rapid response SUV"
	desc = "Seems to be broken down."
	icon_state = "marshalls"
/obj/structure/prop/hybrisa/vehicles/suv/misc/marshalls2
	name = "colonial marshalls rapid response SUV"
	desc = "Seems to be broken down."
	icon_state = "marshalls2"
/obj/structure/prop/hybrisa/vehicles/suv/misc/expensive
	name = "Expensive looking SUV"
	desc = "Seems to be broken down."
	icon_state = "SUV9"
/obj/structure/prop/hybrisa/vehicles/suv/misc/expensive2
	name = "Expensive Weyland-Yutani SUV"
	desc = "Seems to be broken down."
	icon_state = "blackSUV"
/obj/structure/prop/hybrisa/vehicles/suv/misc/expensive3
	name = "The Pimp-Mobile"
	desc = "Seems to be broken down."
	icon_state = "pimpmobile"

// Vans

/obj/structure/prop/hybrisa/vehicles/van
	name = "van"
	desc = "Seems to be broken down."
	icon = 'icons/obj/structures/props/vehiclesexpanded2.dmi'
	icon_state = "greyvan"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/van/vandamaged
	name = "van"
	desc = "A shell of a vehicle, broken down beyond repair."
	icon_state = "greyvan_damaged"
/obj/structure/prop/hybrisa/vehicles/van/vanpizza
	name = "pizza delivery van"
	desc = "Seems to be broken down."
	icon_state = "pizzavan"
/obj/structure/prop/hybrisa/vehicles/van/vanmining
	name = "Kelland Mining van"
	desc = "Seems to be broken down."
	icon_state = "kellandminingvan"

/obj/structure/prop/hybrisa/vehicles/crashedcarsleft
	name = "car pileup"
	desc = "Burned out wrecked vehicles block your path."
	icon = 'icons/obj/structures/props/crashedcars.dmi'
	icon_state = "crashedcarsleft"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/crashedcarsright
	name = "car pileup"
	desc = "Burned out wrecked vehicles block your path."
	icon = 'icons/obj/structures/props/crashedcars.dmi'
	icon_state = "crashedcarsright"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE

// Supermart

/obj/structure/prop/hybrisa/supermart
	name = "long rack"
	icon_state = "longrack1"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'

/obj/structure/prop/hybrisa/supermart/rack/longrackempty
	name = "shelf"
	desc = "A long empty shelf."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrackempty"
/obj/structure/prop/hybrisa/supermart/rack/longrack1
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack1"
/obj/structure/prop/hybrisa/supermart/rack/longrack2
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack2"
/obj/structure/prop/hybrisa/supermart/rack/longrack3
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack3"
/obj/structure/prop/hybrisa/supermart/rack/longrack4
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack4"
/obj/structure/prop/hybrisa/supermart/rack/longrack5
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack5"
/obj/structure/prop/hybrisa/supermart/rack/longrack6
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack6"
/obj/structure/prop/hybrisa/supermart/rack/longrack7
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack7"

/obj/structure/prop/hybrisa/supermart/supermartbelt
	name = "conveyor belt"
	desc = "A conveyor belt."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "checkoutbelt"

/obj/structure/prop/hybrisa/supermart/freezer
	name = "commercial freezer"
	desc = "A commercial grade freezer."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezerupper"
	density = TRUE
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer1
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezerupper"
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer2
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezerlower"
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer3
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezermid"
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer4
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezerupper1"
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer5
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezerlower1"
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer6
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezermid1"

/obj/structure/prop/hybrisa/supermart/supermartfruitbasketempty
	name = "basket"
	desc = "A basket."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasketempty"
/obj/structure/prop/hybrisa/supermart/supermartfruitbasketoranges
	name = "basket"
	desc = "A basket full of oranges."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasket1"
/obj/structure/prop/hybrisa/supermart/supermartfruitbasketpears
	name = "basket"
	desc = "A basket full of pears."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasket2"
/obj/structure/prop/hybrisa/supermart/supermartfruitbasketcarrots
	name = "basket"
	desc = "A basket full of carrots."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasket3"
/obj/structure/prop/hybrisa/supermart/supermartfruitbasketmelons
	name = "basket"
	desc = "A basket full of melons."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasket4"
/obj/structure/prop/hybrisa/supermart/supermartfruitbasketapples
	name = "basket"
	desc = "A basket full of apples."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasket5"

// Hospital

/obj/structure/prop/hybrisa/hospital
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "hospital"

/obj/structure/prop/hybrisa/hospital/hospitalbedrollerbody
	name = "hospital bed"
	desc = "A hospital bed, there's a body under the cloth..."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "bigroller_body1up"
	density = TRUE

/obj/structure/prop/hybrisa/hospital/hospitalbedrollerbody1
	name = "hospital bed"
	desc = "A hospital bed, there's a body under the cloth..."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "bigroller_body2up"
	density = TRUE

/obj/structure/prop/hybrisa/hospital/hospitalbedrollerbody2
	name = "hospital bed"
	desc = "A hospital bed, there's a body under the cloth..."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "bigroller_body3up"
	density = TRUE

/obj/structure/prop/hybrisa/hospital/hospitalbedrollerbody3
	name = "hospital bed"
	desc = "A hospital bed, there's a body under the cloth..."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "bigroller_body4up"
	density = TRUE

/obj/structure/prop/hybrisa/hospital/hospitaldivider
	name = "hospital divider"
	desc = "A hospital divider for privacy."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "hospitalcurtain"
	layer = ABOVE_MOB_LAYER

// Furniture

/obj/structure/prop/hybrisa/furniture
    icon = 'icons/obj/structures/props/zenithtables.dmi'
    icon_state = "blackmetaltable"

/obj/structure/prop/hybrisa/furniture/tables
    icon = 'icons/obj/structures/props/zenithtables.dmi'
    icon_state = "table_pool"

/obj/structure/prop/hybrisa/furniture/tables/tableblack
	name = "large metal table"
	desc = "A large black metal table, looks very expensive."
	icon_state = "blackmetaltable"
	density = TRUE
	climbable = TRUE
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/metal)
/obj/structure/prop/hybrisa/furniture/tables/tablepool
	name = "pool table"
	desc = "A large table used for Pool."
	icon = 'icons/obj/structures/props/zenithtables.dmi'
	icon_state = "table_pool"
	density = TRUE
	climbable = TRUE
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/wood)
/obj/structure/prop/hybrisa/furniture/tables/tablegambling
	name = "gambling table"
	desc = "A large table used for gambling."
	icon = 'icons/obj/structures/props/zenithtables.dmi'
	icon_state = "table_cards"
	density = TRUE
	climbable = TRUE
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/wood)

// Chairs
/obj/structure/bed/hybrisa/chairs
    name = "expensive chair"
    desc = "A expensive looking chair"

/obj/structure/bed/hybrisa/chairs/black
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "comfychair_zenithblack"
/obj/structure/bed/hybrisa/chairs/red
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "comfychair_zenithred"
/obj/structure/bed/hybrisa/chairs/blue
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "comfychair_zenithblue"
/obj/structure/bed/hybrisa/chairs/brown
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "comfychair_zenithbrown"

// Beds

/obj/structure/bed/hybrisa
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "hybrisa"

/obj/structure/bed/hybrisa/prisonbed
	name = "bunk bed"
	desc = "A sorry looking bunk-bed."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "prisonbed"

/obj/structure/bed/hybrisa/bunkbed1
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zbunkbed"

/obj/structure/bed/hybrisa/bunkbed2
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zbunkbed2"

/obj/structure/bed/hybrisa/bunkbed3
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zbunkbed3"

/obj/structure/bed/hybrisa/bunkbed4
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zbunkbed4"

/obj/structure/bed/hybrisa/hospitalbeds
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "hospital"

/obj/structure/bed/hybrisa/hospitalbeds/hospitalbed1
	name = "hospital bed"
	desc = "A mattress seated on a rectangular metallic frame with wheels. This is used to support a lying person in a comfortable manner."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "bigroller_up"

/obj/structure/bed/hybrisa/hospitalbeds/hospitalbed2
	name = "hospital bed"
	desc = "A mattress seated on a rectangular metallic frame with wheels. This is used to support a lying person in a comfortable manner."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "bigroller_up2"

/obj/structure/bed/hybrisa/hospitalbeds/hospitalbed3
	name = "hospital bed"
	desc = "A mattress seated on a rectangular metallic frame with wheels. This is used to support a lying person in a comfortable manner."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "bigroller_up3"

// Xenobiology

/obj/structure/prop/hybrisa/xenobiology
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellemptyon"

/obj/structure/prop/hybrisa/xenobiology/small/empty
	name = "specimen containment cell"
	desc = "It's empty."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellemptyon"
/obj/structure/prop/hybrisa/xenobiology/small/offempty
	name = "specimen containment cell"
	desc = "It's turned off and empty."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellemptyoff"
/obj/structure/prop/hybrisa/xenobiology/small/larva
	name = "specimen containment cell"
	desc = "There is something worm-like inside..."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocelllarva"
/obj/structure/prop/hybrisa/xenobiology/small/egg
	name = "specimen containment cell"
	desc = "There is, what looks like some sort of egg inside..."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellegg"
/obj/structure/prop/hybrisa/xenobiology/small/hugger
	name = "specimen containment cell"
	desc = "There's something spider-like inside..."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellhugger"
/obj/structure/prop/hybrisa/xenobiology/small/cracked1
	name = "specimen containment cell"
	desc = "Looks like something broke it...from the inside."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellcrackedempty"
/obj/structure/prop/hybrisa/xenobiology/small/cracked2
	name = "specimen containment cell"
	desc = "Looks like something broke it...from the inside."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellcrackedempty2"
/obj/structure/prop/hybrisa/xenobiology/small/crackedegg
	name = "specimen containment cell"
	desc = "Looks like something broke it, there's a giant empty egg inside."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellcrackedegg"

/obj/structure/prop/hybrisa/xenobiology/big
	name = "specimen containment cell"
	desc = "A giant tube with a hulking monstrosity inside, is this thing alive?"
	icon = 'icons/obj/structures/props/zenithxenocryogenics2.dmi'
	icon_state = "bigqueencryo1"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE

/obj/structure/prop/hybrisa/xenobiology/big/bigleft
	icon = 'icons/obj/structures/props/zenithxenocryogenics2.dmi'
	icon_state = "bigqueencryo1"
/obj/structure/prop/hybrisa/xenobiology/big/bigright
	icon = 'icons/obj/structures/props/zenithxenocryogenics2.dmi'
	icon_state = "bigqueencryo2"
/obj/structure/prop/hybrisa/xenobiology/big/bigbottomleft
	icon = 'icons/obj/structures/props/zenithxenocryogenics2.dmi'
	icon_state = "bigqueencryo3"
	density = TRUE
/obj/structure/prop/hybrisa/xenobiology/big/bigbottomright
	icon = 'icons/obj/structures/props/zenithxenocryogenics2.dmi'
	icon_state = "bigqueencryo4"
	density = TRUE

/obj/structure/prop/hybrisa/xenobiology/misc
	name = "strange egg"
	desc = "A strange ancient looking egg, it seems to be inert."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "inertegg"
	unslashable = TRUE
	layer = 2

// Engineer

/obj/structure/prop/hybrisa/engineer
	icon = 'icons/obj/structures/props/blackgoocontainers.dmi'
	icon_state = "blackgoocontainer1"

/obj/structure/prop/hybrisa/engineer/engineerpillar
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW1fade"
	bound_height = 64
	bound_width = 128
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/engineer/engineerpillar/northwesttop
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_NW1"
/obj/structure/prop/hybrisa/engineer/engineerpillar/northwestbottom
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_NW2"
/obj/structure/prop/hybrisa/engineer/engineerpillar/southwesttop
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW1"
/obj/structure/prop/hybrisa/engineer/engineerpillar/southwestbottom
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW2"
/obj/structure/prop/hybrisa/engineer/engineerpillar/smallsouthwest1
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW1fade"
/obj/structure/prop/hybrisa/engineer/engineerpillar/smallsouthwest2
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW2fade"

/obj/structure/prop/hybrisa/engineer/blackgoocontainer
	name = "strange container"
	icon_state = "blackgoocontainer1"
	desc = "A strange alien container, who knows what's inside..."
	icon = 'icons/obj/structures/props/blackgoocontainers.dmi'

// Signs

/obj/structure/prop/hybrisa/signs
	name = "neon sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "jacksopen_on"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/signs/casniosign
	name = "casino sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "nightgoldcasinoopen_on"
/obj/structure/prop/hybrisa/signs/jackssign
	name = "jack's surplus sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "jacksopen_on"
/obj/structure/prop/hybrisa/signs/opensign
	name = "open sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "open_on"
/obj/structure/prop/hybrisa/signs/opensign2
	name = "open sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "open_on2"
/obj/structure/prop/hybrisa/signs/pizzasign
	name = "pizza sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "pizzaneon_on"
/obj/structure/prop/hybrisa/signs/weymartsign
	name = "weymart sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "weymartsign"
/obj/structure/prop/hybrisa/signs/weymartsign2
	name = "weymart sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "weymartsign2"
/obj/structure/prop/hybrisa/signs/mechanicsign
	name = "mechanic sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "mechanicopen_on2"
/obj/structure/prop/hybrisa/signs/cuppajoessign
	name = "cuppa joe's sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "cuppajoes"

// Airport

/obj/structure/prop/hybrisa/airport
	name = "nose cone"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipfrontwhite1"
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/hybrisa/airport/dropshipnosecone
	name = "nose cone"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipfrontwhite1"
	indestructible = TRUE
/obj/structure/prop/hybrisa/airport/dropshipwingleft
	name = "wing"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipwingtop1"
	indestructible = TRUE
/obj/structure/prop/hybrisa/airport/dropshipwingright
	name = "wing"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipwingtop2"
	indestructible = TRUE
/obj/structure/prop/hybrisa/airport/dropshipvent1left
	name = "vent"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipvent1"
	indestructible = TRUE
/obj/structure/prop/hybrisa/airport/dropshipvent2right
	name = "vent"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipvent2"
	indestructible = TRUE
/obj/structure/prop/hybrisa/airport/dropshipventleft
	name = "vent"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipvent3"
	indestructible = TRUE
/obj/structure/prop/hybrisa/airport/dropshipventright
	name = "vent"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipvent4"
	indestructible = TRUE

// Dropship damage

/obj/structure/prop/hybrisa/airport/dropshipenginedamage
	name = "dropship damage"
	desc = "the engine appears to have severe damage."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "dropship_engine_damage"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/hybrisa/airport/dropshipenginedamagenofire
	name = "dropship damage"
	desc = "the engine appears to have severe damage."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "dropship_engine_damage_nofire"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/hybrisa/airport/refuelinghose
	name = "refueling hose"
	desc = "A long refueling hose that connects to various types of dropships."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "fuelline1"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/hybrisa/airport/refuelinghose2
	name = "refueling hose"
	desc = "A long refueling hose that connects to various types of dropships."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "fuelline2"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE

// Pilot body

/obj/structure/prop/hybrisa/airport/deadpilot1
	name = "decapitated Weyland-Yutani Pilot"
	desc = "What remains of a Weyland-Yutani Pilot. Their entire head is missing. Where'd it roll off to?..."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "pilotbody_decap1"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/hybrisa/airport/deadpilot2
	name = "decapitated Weyland-Yutani Pilot"
	desc = "What remains of a Weyland-Yutani Pilot. Their entire head is missing. Where'd it roll off to?..."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "pilotbody_decap2"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE

// Misc

/obj/structure/prop/hybrisa/misc
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier"

// Floor props

/obj/structure/prop/hybrisa/misc/floorprops
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate1"

/obj/structure/prop/hybrisa/misc/floorprops/grate
	name = "solid metal grate"
	desc = "A metal grate."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate1"

/obj/structure/prop/hybrisa/misc/floorprops/grate2
	name = "solid metal grate"
	desc = "A metal grate."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate5"

/obj/structure/prop/hybrisa/misc/floorprops/grate3
	name = "solid metal grate"
	desc = "A metal grate."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zhalfgrate1"

/obj/structure/prop/hybrisa/misc/floorprops/floorglass
	name = "reinforced glass floor"
	desc = "A heavily reinforced glass floor panel, this looks almost indestructible."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate2"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
/obj/structure/prop/hybrisa/misc/floorprops/floorglass2
	name = "reinforced glass floor"
	desc = "A heavily reinforced glass floor panel, this looks almost indestructible."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate3"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
	layer = 2.1
/obj/structure/prop/hybrisa/misc/floorprops/floorglass3
	name = "reinforced glass floor"
	desc = "A heavily reinforced glass floor panel, this looks almost indestructible."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate4"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE

// Graffiti

/obj/structure/prop/hybrisa/misc/graffiti
	name = "graffiti"
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti4"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
	breakable = TRUE

/obj/structure/prop/hybrisa/misc/graffiti/graffiti1
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti1"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti2
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti2"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti3
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti3"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti4
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti4"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti5
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti5"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti6
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti6"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti7
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti7"

// Wall Blood

/obj/structure/prop/hybrisa/misc/blood
	name = "blood"
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "wallblood_floorblood"
	unslashable = TRUE
	unacidable = TRUE
	breakable = TRUE
	layer = 2

/obj/structure/prop/hybrisa/misc/blood/blood1
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "wallblood_floorblood"
/obj/structure/prop/hybrisa/misc/blood/blood2
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "wall_blood_1"
/obj/structure/prop/hybrisa/misc/blood/blood3
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "wall_blood_2"

// Fire

/obj/structure/prop/hybrisa/misc/fire/fire1
	name = "fire"
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zfire_smoke"
/obj/structure/prop/hybrisa/misc/fire/fire2
	name = "fire"
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zfire_smoke2"
/obj/structure/prop/hybrisa/misc/fire/firebarrel
	name = "barrel"
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zbarrelfireon"

// Misc

/obj/structure/prop/hybrisa/misc/commandosuitemptyprop
	name = "Weyland-Yutani 'Ape-Suit' Showcase"
	desc = "A display model of the Weyland-Yutani 'Apesuit', shame it's only a model..."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dogcatchersuitempty1"

/obj/structure/prop/hybrisa/misc/cabinet
	name = "cabinet"
	desc = "a small cabinet with drawers."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "sidecabinet"

/obj/structure/prop/hybrisa/misc/redmeter
	name = "meter"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "redmeter"

/obj/structure/prop/hybrisa/misc/firebarreloff
	name = "barrel"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zfirebarreloff"

/obj/structure/prop/hybrisa/misc/trashbagfullprop
	name = "trash bag"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "ztrashbag"

/obj/structure/prop/hybrisa/misc/slotmachine
	name = "slot machine"
	desc = "A slot machine."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "slotmachine"

/obj/structure/prop/hybrisa/misc/coffeestuff/coffeemachine1
	name = "coffee machine"
	desc = "A coffee machine."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "coffee"

/obj/structure/prop/hybrisa/misc/coffeestuff/coffeemachine2
	name = "coffee machine"
	desc = "A coffee machine."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "coffee_cup"

/obj/structure/prop/hybrisa/misc/machinery/computers
	name = "computer"
	icon_state = "mapping_comp"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerwhite/computer1
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "mapping_comp"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerwhite/computer2
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "mps"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerwhite/computer3
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "sensor_comp1"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerwhite/computer4
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "sensor_comp2"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerwhite/computer5
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "sensor_comp3"


/obj/structure/prop/hybrisa/misc/machinery/computers/computerblack/computer1
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "blackmapping_comp"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerblack/computer2
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "blackmps"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerblack/computer3
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "blacksensor_comp1"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerblack/computer4
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "blacksensor_comp2"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerblack/computer5
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "blacksensor_comp3"


/obj/structure/prop/hybrisa/misc/machinery/screens
    name = "monitor"


/obj/structure/prop/hybrisa/misc/machinery/screens/frame
	icon_state = "frame"
	layer = 2

/obj/structure/prop/hybrisa/misc/machinery/screens/security
	icon_state = "security"
	layer = 2

/obj/structure/prop/hybrisa/misc/machinery/screens/evac
	icon_state = "evac"
	layer = 2

/obj/structure/prop/hybrisa/misc/machinery/screens/redalert
	icon_state = "redalert"
	layer = 2

/obj/structure/prop/hybrisa/misc/machinery/screens/redalertblank
	icon_state = "redalertblank"
	layer = 2

/obj/structure/prop/hybrisa/misc/machinery/screens/entertainment
	icon_state = "entertainment"
	layer = 2

/obj/structure/prop/hybrisa/misc/machinery/screens/telescreen
	icon_state = "telescreen"
	layer = 2

/obj/structure/prop/hybrisa/misc/machinery/screens/telescreenbroke
	icon_state = "telescreenb"
	layer = 2

/obj/structure/prop/hybrisa/misc/machinery/screens/telescreenbrokespark
	icon_state = "telescreenbspark"
	layer = 2

/obj/structure/prop/hybrisa/misc/fake/pipes
    name = "disposal pipe"

/obj/structure/prop/hybrisa/misc/fake/pipes/pipe1
	layer = 2
	icon_state = "pipe-s"
/obj/structure/prop/hybrisa/misc/fake/pipes/pipe2
	layer = 2
	icon_state = "pipe-c"
/obj/structure/prop/hybrisa/misc/fake/pipes/pipe3
	layer = 2
	icon_state = "pipe-j1"
/obj/structure/prop/hybrisa/misc/fake/pipes/pipe4
	layer = 2
	icon_state = "pipe-y"
/obj/structure/prop/hybrisa/misc/fake/pipes/pipe5
	layer = 2
	icon_state = "pipe-b"

/obj/structure/prop/hybrisa/misc/fake/wire
    name = "power cable"

/obj/structure/prop/hybrisa/misc/fake/wire/red
	layer = 2
	icon_state = "intactred"
/obj/structure/prop/hybrisa/misc/fake/wire/yellow
	layer = 2
	icon_state = "intactyellow"
/obj/structure/prop/hybrisa/misc/fake/wire/blue
	layer = 2
	icon_state = "intactblue"


/obj/structure/prop/hybrisa/misc/fake/heavydutywire
    name = "heavy duty wire"

/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy1
	layer = 2
	icon_state = "0-1"
/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy2
	layer = 2
	icon_state = "1-2"
/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy3
	layer = 2
	icon_state = "1-4"
/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy4
	layer = 2
	icon_state = "1-2-4"
/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy5
	layer = 2
	icon_state = "1-2-4-8"

/obj/structure/prop/hybrisa/misc/fake/lattice
    name = "structural lattice"

/obj/structure/prop/hybrisa/misc/fake/lattice/full
	icon_state = "latticefull"
	layer = 2

// Barriers

/obj/structure/prop/hybrisa/misc/road
	name = "road barrier"
	desc = "A plastic barrier for blocking entry."
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/mineral/plastic)

/obj/structure/prop/hybrisa/misc/road/roadbarrierred
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier"
/obj/structure/prop/hybrisa/misc/road/roadbarrierblue
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier2"
/obj/structure/prop/hybrisa/misc/road/roadbarrierwyblack
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier3"
/obj/structure/prop/hybrisa/misc/road/roadbarrierwyblackjoined
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrierjoined3"
/obj/structure/prop/hybrisa/misc/road/roadbarrierjoined
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrierjoined"

/obj/structure/prop/hybrisa/misc/road/wood
	name = "road barrier"
	desc = "A wooden barrier for blocking entry."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrierwood"
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/wood)

/obj/structure/prop/hybrisa/misc/road/wood/roadbarrierwoodorange
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrierwood"
/obj/structure/prop/hybrisa/misc/road/wood/roadbarrierwoodblue
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrierpolice"

// Cargo Containers extended

/obj/structure/prop/hybrisa/containersextended
	name = "cargo container"
	desc = "a cargo container."
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "blackwyleft"
	bound_width = 32
	bound_height = 32
	density = TRUE
	health = 200
	opacity = TRUE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/hybrisa/containersextended/blueleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "blueleft"
/obj/structure/prop/hybrisa/containersextended/blueright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "blueright"
/obj/structure/prop/hybrisa/containersextended/greenleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "greenleft"
/obj/structure/prop/hybrisa/containersextended/greenright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "greenright"
/obj/structure/prop/hybrisa/containersextended/tanleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "tanleft"
/obj/structure/prop/hybrisa/containersextended/tanright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "tanright"
/obj/structure/prop/hybrisa/containersextended/greywyleft
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "greywyleft"
/obj/structure/prop/hybrisa/containersextended/greywyright
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "greywyright"
/obj/structure/prop/hybrisa/containersextended/lightgreywyleft
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "lightgreywyleft"
/obj/structure/prop/hybrisa/containersextended/lightgreywyright
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "lightgreywyright"
/obj/structure/prop/hybrisa/containersextended/blackwyleft
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "blackwyleft"
/obj/structure/prop/hybrisa/containersextended/blackwyright
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "blackwyright"
/obj/structure/prop/hybrisa/containersextended/whitewyleft
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "whitewyleft"
/obj/structure/prop/hybrisa/containersextended/whitewyright
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended2.dmi'
	icon_state = "whitewyright"



// Decals


/obj/structure/prop/hybrisa/decal
	icon = 'icons/obj/structures/props/zenithdecals.dmi'
	icon_state = "weylandyutanilogo1"
	unslashable = TRUE
	unacidable = TRUE
	breakable = TRUE

/obj/structure/prop/hybrisa/decal/WY/WY1
	name = "Weyland-Yutani"
	icon = 'icons/obj/structures/props/zenithdecals.dmi'
	icon_state = "weylandyutanilogo1"

/obj/structure/prop/hybrisa/decal/WY/WYworn
	name = "Weyland-Yutani"
	icon = 'icons/obj/structures/props/zenithdecals.dmi'
	icon_state = "weylandyutanilogo2"

/obj/structure/prop/hybrisa/decal/road
	name = "road line"
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_M2"
	layer = 1
/obj/structure/prop/hybrisa/decal/road/lines1
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_W1"
/obj/structure/prop/hybrisa/decal/road/lines2
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_N2"
/obj/structure/prop/hybrisa/decal/road/lines3
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_S3"
/obj/structure/prop/hybrisa/decal/road/lines4
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_E4"
/obj/structure/prop/hybrisa/decal/road/lines5
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_M1"
/obj/structure/prop/hybrisa/decal/road/lines6
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_M2"

/obj/structure/prop/hybrisa/decal/gold
	name = "border"
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_S"
	layer = 1
/obj/structure/prop/hybrisa/decal/gold/line1
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_S"
/obj/structure/prop/hybrisa/decal/gold/line2
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_E"
/obj/structure/prop/hybrisa/decal/gold/line3
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_N"
/obj/structure/prop/hybrisa/decal/gold/line4
	icon = 'icons/effects/hybrisa_lines.dmi'
	icon_state = "Z_W"


/// Fake Platforms

/obj/structure/prop/hybrisa/fakeplatforms
    name = "platform"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
/obj/structure/prop/hybrisa/fakeplatforms/platform1
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "engineer_platform"
/obj/structure/prop/hybrisa/fakeplatforms/platform2
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "engineer_platform_platformcorners"
/obj/structure/prop/hybrisa/fakeplatforms/platform3
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "platform"
/obj/structure/prop/hybrisa/fakeplatforms/platform4
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zenithplatform3"