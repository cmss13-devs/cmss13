/obj/structure/closet/l3closet
	name = "level-3 biohazard suit closet"
	desc = "It's a storage unit for level-3 biohazard gear."
	icon_state = "bio_general"
	icon_closed = "bio_general"
	icon_opened = "bio_generalopen"

/obj/structure/closet/l3closet/Initialize()
	. = ..()
	new /obj/item/clothing/suit/bio_suit( src )
	new /obj/item/clothing/head/bio_hood( src )

/obj/structure/closet/l3closet/medical
	icon_state = "bio_medical"
	icon_closed = "bio_medical"
	icon_opened = "bio_medicalopen"

/obj/structure/closet/l3closet/medical/Initialize()
	. = ..()
	contents = list()
	new /obj/item/clothing/suit/bio_suit/medical( src )
	new /obj/item/clothing/head/bio_hood/medical( src )

/obj/structure/closet/l3closet/virology
	icon_state = "bio_virology"
	icon_closed = "bio_virology"
	icon_opened = "bio_virologyopen"

/obj/structure/closet/l3closet/virology/Initialize()
	. = ..()
	contents = list()
	new /obj/item/clothing/suit/bio_suit/virology( src )
	new /obj/item/clothing/head/bio_hood/virology( src )

/obj/structure/closet/l3closet/security
	icon_state = "bio_security"
	icon_closed = "bio_security"
	icon_opened = "bio_securityopen"

/obj/structure/closet/l3closet/security/Initialize()
	. = ..()
	contents = list()
	new /obj/item/clothing/suit/bio_suit/security( src )
	new /obj/item/clothing/head/bio_hood/security( src )

/obj/structure/closet/l3closet/scientist
	icon_state = "bio_scientist"
	icon_closed = "bio_scientist"
	icon_opened = "bio_scientistopen"

/obj/structure/closet/l3closet/scientist/Initialize()
	. = ..()
	contents = list()
	new /obj/item/clothing/suit/bio_suit/scientist( src )
	new /obj/item/clothing/head/bio_hood/scientist( src )

/obj/structure/closet/bionational_closet
	name = "Lasalle Bionational biohazard suit closet"
	desc = "It's a storage unit for Lasalle Bionational biohazard gear."
	icon_state = "bion"
	icon_closed = "bion"
	icon_opened = "bionopen"

/obj/structure/closet/bionational_closet/Initialize()
	. = ..()
	new /obj/item/clothing/accessory/patch/lasalle( src )
	new /obj/item/clothing/suit/bio_suit/lasalle( src )
	new /obj/item/clothing/head/bio_hood/lasalle( src )
	new /obj/item/clothing/mask/gas/pmc/lasalle( src )
	RemoveElement(/datum/element/corp_label/wy)
	AddElement(/datum/element/corp_label/bionational)

/obj/structure/closet/bionational_closet/alt
	icon_state = "bion_alt"
	icon_closed = "bion_alt"
	icon_opened = "bion_altopen"

/obj/structure/closet/bionational_closet/alt/Initialize()
	. = ..()
	new /obj/item/clothing/accessory/patch/lasalle( src )
	new /obj/item/clothing/suit/bio_suit/lasalle( src )
	new /obj/item/clothing/head/bio_hood/lasalle( src )
	new /obj/item/clothing/mask/gas/pmc/lasalle( src )
	RemoveElement(/datum/element/corp_label/wy)
	AddElement(/datum/element/corp_label/bionational)
