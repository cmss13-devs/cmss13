/obj/item/clothing/suit/storage/co_jacket
	name = "Formal dress jacket."
	desc = "Smells like vanilla. Signifies prestige and power, if a little flashy. Light kevlar is sown into the fabric, along with other forms of basic protection. It has some hooks to allow pistol rigs to attach."
	icon = 'icons/obj/clothing/cm_suits.dmi'
	sprite_sheet_id = 1
	icon_state = "co_jacket"
	blood_overlay_type = "coat"
	flags_armor_protection = UPPER_TORSO|ARMS
	armor = list(melee = 30, bullet = 50, laser = 20,energy = 20, bomb = 10, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/gun/,
	/obj/item/tank/emergency_oxygen,
	/obj/item/device/flashlight,
	/obj/item/storage/fancy/cigarettes,
	/obj/item/tool/lighter,
	/obj/item/weapon/baton,
	/obj/item/handcuffs,
	/obj/item/device/binoculars,
	/obj/item/weapon/combat_knife,
	/obj/item/storage/belt/gun/m4a3,
	/obj/item/storage/belt/gun/m44,
	/obj/item/storage/belt/gun/mateba,)