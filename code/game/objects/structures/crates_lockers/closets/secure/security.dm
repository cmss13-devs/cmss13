/obj/structure/closet/secure_closet/warden
	name = "Warden's Locker"
	req_access = list(ACCESS_MARINE_BRIG)
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"

/obj/structure/closet/secure_closet/warden/Initialize()
	..()
	sleep(2)
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel/sec(src)
	new /obj/item/clothing/suit/armor/vest/security(src)
	new /obj/item/clothing/under/rank/warden(src)
	new /obj/item/clothing/under/rank/warden/corp(src)
	new /obj/item/clothing/suit/armor/vest/warden(src)
	new /obj/item/clothing/head/helmet/warden(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/belt/security(src)
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/weapon/baton/loaded(src)
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/storage/box/holobadge(src)
	new /obj/item/clothing/head/beret/sec/warden(src)

/obj/structure/closet/secure_closet/marshal
	name = "Marshal's Locker"
	req_access = list(ACCESS_MARINE_BRIG)
	icon_state = "secure_locked_warrant"
	icon_closed = "secure_unlocked_warrant"
	icon_locked = "secure_locked_warrant"
	icon_opened = "secure_open_warrant"
	icon_broken = "secure_locked_warrant"
	icon_off = "secure_closed_warrant"


/obj/structure/closet/secure_closet/marshal/Initialize()
	..()
	new /obj/item/clothing/suit/storage/CMB(src)
	new /obj/item/clothing/under/CM_uniform(src)
	new /obj/item/storage/backpack/security(src)
	new /obj/item/storage/belt/security(src)
	new /obj/item/clothing/shoes/jackboots(src)

/obj/structure/closet/secure_closet/security
	name = "Security Officer's Locker"
	req_access = list(ACCESS_MARINE_BRIG)
	icon_state = "secure_locked_police"
	icon_closed = "secure_closed_police"
	icon_locked = "secure_locked_police"
	icon_opened = "secure_open_police"
	icon_broken = "secure_broken_police"
	icon_off = "secure_closed_police"

/obj/structure/closet/secure_closet/security/Initialize()
	..()
	sleep(2)
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel/sec(src)
	new /obj/item/clothing/suit/armor/vest/security(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/storage/belt/security(src)
	new /obj/item/device/flash(src)
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/weapon/baton/loaded(src)
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/device/hailer(src)
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/clothing/head/soft/sec/corp(src)
	new /obj/item/clothing/under/rank/security/corp(src)


/obj/structure/closet/secure_closet/security/cargo/Initialize()
	..()
	new /obj/item/clothing/accessory/armband/cargo(src)

/obj/structure/closet/secure_closet/security/engine/Initialize()
	..()
	new /obj/item/clothing/accessory/armband/engine(src)
	new /obj/item/device/encryptionkey/engi(src)

/obj/structure/closet/secure_closet/security/science/Initialize()
	..()
	new /obj/item/clothing/accessory/armband/science(src)

/obj/structure/closet/secure_closet/security/med/Initialize()
	..()
	new /obj/item/clothing/accessory/armband/medgreen(src)
	new /obj/item/device/encryptionkey/med(src)

/obj/structure/closet/secure_closet/security_empty
	name = "Security Officer's Locker"
	req_access = list(ACCESS_MARINE_BRIG)
	icon_state = "secure_open_police"
	icon_closed = "secure_closed_police"
	icon_locked = "secure_locked_police"
	icon_opened = "secure_open_police"
	icon_broken = "secure_broken_police"
	icon_off = "secoff"

	opened = 1
	locked = 0
	density = 0

/obj/structure/closet/secure_closet/detective
	name = "Detective's Cabinet"
	req_access = list(ACCESS_MARINE_BRIG)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

/obj/structure/closet/secure_closet/detective/Initialize()
	..()
	sleep(2)
	new /obj/item/clothing/under/det(src)
	new /obj/item/clothing/under/det/black(src)
	new /obj/item/clothing/under/det/slob(src)
	new /obj/item/clothing/suit/storage/det_suit(src)
	new /obj/item/clothing/suit/storage/det_suit/black(src)
	new /obj/item/clothing/suit/storage/forensics/blue(src)
	new /obj/item/clothing/suit/storage/forensics/red(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/head/det_hat(src)
	new /obj/item/clothing/head/det_hat/black(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/storage/box/evidence(src)
	new /obj/item/clothing/suit/armor/det_suit(src)
	new /obj/item/clothing/accessory/holster/armpit(src)

/obj/structure/closet/secure_closet/detective/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/injection
	name = "Lethal Injections"
	req_access = list(ACCESS_MARINE_COMMANDER)

/obj/structure/closet/secure_closet/injection/Initialize()
	..()
	sleep(2)
	new /obj/item/reagent_container/ld50_syringe/choral(src)
	new /obj/item/reagent_container/ld50_syringe/choral(src)

/obj/structure/closet/secure_closet/brig
	name = "Brig Locker"
	req_access = list(ACCESS_MARINE_BRIG)
	anchored = TRUE
	locked = TRUE
	var/id = null

/obj/structure/closet/secure_closet/brig/Initialize()
	..()
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/device/radio/headset(src)
	update_icon()

/obj/structure/closet/secure_closet/courtroom
	name = "Courtroom Locker"
	req_access = list(ACCESS_MARINE_BRIG)

/obj/structure/closet/secure_closet/courtroom/Initialize()
	..()
	sleep(2)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/paper/Court (src)
	new /obj/item/paper/Court (src)
	new /obj/item/paper/Court (src)
	new /obj/item/tool/pen (src)
	new /obj/item/clothing/suit/judgerobe (src)
	new /obj/item/clothing/head/powdered_wig (src)
	new /obj/item/storage/briefcase(src)

/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	req_access = list(ACCESS_MARINE_BRIG)
	icon_state = "wall-locker1"
	density = 1
	icon_closed = "wall-locker"
	icon_locked = "wall-locker1"
	icon_opened = "wall-lockeropen"
	icon_broken = "wall-lockerbroken"
	icon_off = "wall-lockeroff"

	//too small to put a man in
	large = 0

/obj/structure/closet/secure_closet/wall/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened
