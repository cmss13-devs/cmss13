// Group to populate with all the explosives exept OB and mortar shell

/datum/supply_packs/explosives
	name = "surplus explosives crate (claymore mine x5, M40 HIDP x2, M40 HEDP x2, M15 Frag x2, M12 Blast x2, M40 MFHS x2)"
	contains = list(
		/obj/item/storage/box/explosive_mines,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/high_explosive/m15,
		/obj/item/explosive/grenade/high_explosive/m15,
		/obj/item/explosive/grenade/high_explosive/pmc,
		/obj/item/explosive/grenade/high_explosive/pmc,
		/obj/item/explosive/grenade/metal_foam,
		/obj/item/explosive/grenade/metal_foam,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosives crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_mines
	name = "claymore mines crate (x10)"
	contains = list(
		/obj/item/storage/box/explosive_mines,
		/obj/item/storage/box/explosive_mines,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive mine boxes crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_m15
	name = "M15 fragmentation grenades crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/m15,
		/obj/item/storage/box/packet/m15,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M15 grenades crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_plastic
	name = "plastic explosives crate (x3)"
	contains = list(
		/obj/item/explosive/plastic,
		/obj/item/explosive/plastic,
		/obj/item/explosive/plastic,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper plastic explosives crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_breaching_charge
	name = "breaching charge crate (x4)"
	contains = list(
		/obj/item/explosive/plastic/breaching_charge,
		/obj/item/explosive/plastic/breaching_charge,
		/obj/item/explosive/plastic/breaching_charge,
		/obj/item/explosive/plastic/breaching_charge,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper plastic explosives crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_incendiary
	name = "M40 HIDP incendiary grenades crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/incendiary,
		/obj/item/storage/box/packet/incendiary,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M40 HIDP incendiary grenades crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_M40_HEDP
	name = "M40 HEDP blast grenades crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/high_explosive,
		/obj/item/storage/box/packet/high_explosive,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M40 HEDP grenades crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_sebb
	name = "G2 electroshock grenades crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/sebb,
		/obj/item/storage/box/packet/sebb,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper G2 electroshock grenades crate (WARNING)"
	group = "Explosives"


/datum/supply_packs/explosives_hedp
	name = "M40 HEDP blast grenade box crate (x25)"
	contains = list(
		/obj/item/storage/box/nade_box,
	)
	cost = 100
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive HEDP grenade crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_M40_CCDP
	name = "M40 CCDP chemical compound grenades crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/phosphorus,
		/obj/item/storage/box/packet/phosphorus,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper M40 CCDP grenade crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_M40_CCDP_crate
	name = "M40 WPDP chemical compund grenade box crate (x25)"
	contains = list(
		/obj/item/storage/box/nade_box/phophorus,
	)
	cost = 100
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper CCDP grenade crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_M40_HEFA
	name = "M40 HEFA fragmentation grenades crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/hefa,
		/obj/item/storage/box/packet/hefa,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M40 HEFA grenades crate (WARNING)"
	group = "Explosives"


/datum/supply_packs/explosives_hefa
	name = "M40 HEFA fragmentation grenade box crate (x25)"
	contains = list(
		/obj/item/storage/box/nade_box/frag,
	)
	cost = 100
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive HEFA grenade crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_M74_AGM_F
	name = "M74 airburst grenades crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/airburst_he,
		/obj/item/storage/box/packet/airburst_he,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M74 AGM-F grenades crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_AGMF
	name = "M74 Airburst Grenade Munition fragmentation grenade box crate (x25)"
	contains = list(
		/obj/item/storage/box/nade_box/airburst,
	)
	cost = 100
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper  explosive M74 AGM-F grenades crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_incendiary
	name = "M74 Airburst Grenade Munition incendiary grenades crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/airburst_incen,
		/obj/item/storage/box/packet/airburst_incen,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M74 AGM-I grenades crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_M74_AGM_I_box
	name = "M74 Airburst Grenade Munition incendiary grenades box crate (x25)"
	contains = list(
		/obj/item/storage/box/nade_box/airburstincen,
	)
	cost = 100
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper M74 Airburst Grenade Munition incendiary grenades crate (WARNING)"
	group = "Explosives"

/datum/supply_packs/explosives_airburst_smoke
	name = "M74 Airburst Grenade Munition smoke grenades crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/airburst_smoke,
		/obj/item/storage/box/packet/airburst_smoke,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M74 AGM-S grenades crate"
	group = "Explosives"

/datum/supply_packs/explosives_m74_hornet
	name = "M74 AGM-Hornet Grenade Crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/hornet,
		/obj/item/storage/box/packet/hornet,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "M74 AGM-Hornet Grenade Crate"
	group = "Explosives"

/datum/supply_packs/explosives_m74_starshell
	name = "M74 AGM-Star Shell Grenade Crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/flare,
		/obj/item/storage/box/packet/flare,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "M74 AGM-Star Shell Grenade Crate"
	group = "Explosives"

/datum/supply_packs/explosives_baton_slug
	name = "M40 HIRR Baton Slug Crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/baton_slug,
		/obj/item/storage/box/packet/baton_slug,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/explosives
	containername = "M40 HIRR Baton Slug Crate"
	group = "Explosives"
