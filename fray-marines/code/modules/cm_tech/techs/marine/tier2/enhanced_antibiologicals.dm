/datum/tech/droppod/item/enhanced_antibiologicals
	name = "Enhanced Antibiologicals"
	desc = "Marines get access to limited-use kits that can convert ammo magazines into the specified ammo."
	icon_state = "ammo"
	droppod_name = "Ammo Kits"
	flags = TREE_FLAG_MARINE

	required_points = 10
	tier = /datum/tier/two/additional

	droppod_input_message = "Choose an ammo kit to retrieve from the droppod."

/datum/tech/droppod/item/enhanced_antibiologicals/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	.["Incendiary Buckshot Kit"] = /obj/item/storage/box/shotgun/buckshot
	.["Incendiary Slug Kit"] = /obj/item/storage/box/shotgun/slug
	.["Incendiary Ammo Kit"] = /obj/item/ammo_kit/incendiary
	.["Cluster Ammo Kit"] = /obj/item/ammo_kit/cluster
	.["Toxin Ammo Kit"] = /obj/item/ammo_kit/toxin

/obj/item/ammo_kit/cluster
	name = "cluster ammo kit"
	icon_state = "kit_cluster"
	desc = "Converts magazines into cluster-hit ammo. The ammo will stack up cluster micro-missiles inside the target, detonating them at a certain threshold."

/obj/item/ammo_kit/cluster/get_convert_map()
	. = ..()
	.[/obj/item/ammo_magazine/smg/m39] = /obj/item/ammo_magazine/smg/m39/cluster
	.[/obj/item/ammo_magazine/rifle] = /obj/item/ammo_magazine/rifle/cluster
	.[/obj/item/ammo_magazine/rifle/l42a] = /obj/item/ammo_magazine/rifle/l42a/cluster
	.[/obj/item/ammo_magazine/rifle/m41aMK1] = /obj/item/ammo_magazine/rifle/m41aMK1/cluster
	.[/obj/item/ammo_magazine/pistol] =  /obj/item/ammo_magazine/pistol/cluster
	.[/obj/item/ammo_magazine/pistol/vp78] =  /obj/item/ammo_magazine/pistol/vp78/cluster
	.[/obj/item/ammo_magazine/pistol/mod88] =  /obj/item/ammo_magazine/pistol/mod88/cluster
	.[/obj/item/ammo_magazine/revolver] =  /obj/item/ammo_magazine/revolver/cluster
