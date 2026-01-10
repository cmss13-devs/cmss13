/obj/structure/closet/secure_closet/quartermaster
	name = "Quartermaster's Locker"
	req_access = list(ACCESS_CIVILIAN_PUBLIC)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

/obj/structure/closet/secure_closet/quartermaster/Initialize()
	. = ..()
	new /obj/item/clothing/under/rank/cargo(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/suit/fire/firefighter(src)
	new /obj/item/tank/emergency_oxygen(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/clothing/head/soft(src)
	return

/obj/structure/closet/secure_closet/quartermaster_uscm
	name = "Quartermaster's Locker"
	req_access = list(ACCESS_MARINE_RO)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

/obj/structure/closet/secure_closet/quartermaster_uscm/Initialize()
	. = ..()
	new /obj/item/clothing/under/rank/qm_suit(src)
	new /obj/item/clothing/head/cmcap/req/ro(src)
	new /obj/item/clothing/shoes/marine(src)
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/tool/stamp/ro(src)
	new /obj/item/device/flash(src)
	new /obj/item/clothing/suit/fire/firefighter(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/folder/yellow(src)
	new /obj/item/clipboard(src)
	return




//**********************Miner Lockers**************************/

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"
	req_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/closet/secure_closet/miner/Initialize()
	. = ..()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel/eng(src)
// new /obj/item/device/radio/headset/almayer/ct(src)
	new /obj/item/clothing/under/hybrisa/kelland_mining(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/device/flashlight/lantern(src)
	new /obj/item/tool/shovel(src)
	new /obj/item/tool/pickaxe(src)
	new /obj/item/clothing/glasses/meson(src)
