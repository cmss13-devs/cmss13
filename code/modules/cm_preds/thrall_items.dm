/obj/item/clothing/suit/armor/yautja/thrall
	name = "alien armor"
	desc = "Armor made from scraps of cloth and a strange alloy. It feels cold with an alien weight. It has been adapted to carry both human and alien melee weaponry."

	icon = 'icons/obj/items/hunter/thrall_gear.dmi'
	icon_state = "chest1_cloth"
	item_state = "chest1_cloth"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/hunter/thrall_gear.dmi'
	)
	thrall = TRUE
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

	allowed = list(
		/obj/item/weapon/gun/launcher/spike,
		/obj/item/weapon/gun/energy/yautja,
		/obj/item/weapon,
	)

/obj/item/clothing/suit/armor/yautja/thrall/New(mapload, armor_area = pick("shoulders", "chest", "mix"), armor_number = rand(1,3), armor_material = pick("cloth", "bare"))
	if(armor_number > 3)
		armor_number = 1
	if(armor_number)
		icon_state = "[armor_area][armor_number]_[armor_material]"
		LAZYSET(item_state_slots, WEAR_JACKET, "[armor_area][armor_number]_[armor_material]")
	..()

/obj/item/clothing/shoes/yautja/thrall
	name = "alien greaves"
	desc = "Greaves made from scraps of cloth and a strange alloy. They feel cold with an alien weight. They have been adapted for compatibility with human equipment."

	icon = 'icons/obj/items/hunter/thrall_gear.dmi'
	icon_state = "greaves1_cloth"
	item_icons = list(
		WEAR_FEET = 'icons/mob/humans/onmob/hunter/thrall_gear.dmi'
	)
	thrall = TRUE

	allowed_items_typecache = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/throwing_knife,
		/obj/item/weapon/gun/pistol/holdout,
		/obj/item/weapon/gun/pistol/clfpistol,
		/obj/item/weapon/straight_razor,
	)

/obj/item/clothing/shoes/yautja/thrall/New(mapload, greaves_number = 1, armor_material = pick("cloth", "bare"))
	if(greaves_number > 1)
		greaves_number = 1
	if(greaves_number)
		icon_state = "greaves[greaves_number]_[armor_material]"
		LAZYSET(item_state_slots, WEAR_JACKET, "greaves[greaves_number]_[armor_material]")
	..()

/obj/item/clothing/under/chainshirt/thrall
	name = "alien mesh suit"
	color = "#b85440"
	desc = "A strange alloy weave in the form of a vest. It feels cold with an alien weight. It has been adapted for human physiology."

/obj/item/clothing/gloves/yautja/thrall
	name = "thrall bracers"
	desc = "A pair of strange alien bracers, adapted for human biology."

	color = "#b85440"
	minimap_icon = "thrall"

/obj/item/storage/box/bracer
	name = "alien box"
	desc = "A strange, runed box."
	color = "#68423b"
	icon = 'icons/obj/structures/closet.dmi'
	icon_state = "pred_coffin"
	foldable = FALSE

/obj/item/storage/box/bracer/fill_preset_inventory()
	new /obj/item/clothing/gloves/yautja/thrall(src)
