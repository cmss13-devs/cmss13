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
