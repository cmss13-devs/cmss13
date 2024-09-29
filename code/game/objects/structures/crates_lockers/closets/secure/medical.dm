/obj/structure/closet/secure_closet/medical1
	name = "medicine closet"
	desc = "Filled with medical items."
	icon_state = "secure_locked_medical_white"
	icon_closed = "secure_unlocked_medical_white"
	icon_locked = "secure_locked_medical_white"
	icon_opened = "secure_open_medical_white"
	icon_broken = "secure_closed_medical_white"
	icon_off = "secure_closed_medical_white"
	req_access = list(ACCESS_MARINE_MEDBAY)

/obj/structure/closet/secure_closet/medical1/Initialize()
	. = ..()
	new /obj/item/storage/box/syringes(src)
	new /obj/item/reagent_container/dropper(src)
	new /obj/item/reagent_container/dropper(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/bottle/inaprovaline(src)
	new /obj/item/reagent_container/glass/bottle/antitoxin(src)
	new /obj/item/storage/box/pillbottles(src)
	new /obj/item/storage/box/pillbottles(src)
	return

/obj/structure/closet/secure_closet/medical2
	name = "anesthetic closet"
	desc = "Used to knock people out."
	icon_state = "secure_locked_medical_white"
	icon_closed = "secure_unlocked_medical_white"
	icon_locked = "secure_locked_medical_white"
	icon_opened = "secure_open_medical_white"
	icon_broken = "secure_closed_medical_white"
	icon_off = "secure_closed_medical_white"
	req_access = list(ACCESS_MARINE_MEDBAY)

/obj/structure/closet/secure_closet/medical2/Initialize()
	. = ..()
	new /obj/item/tank/anesthetic(src)
	new /obj/item/tank/anesthetic(src)
	new /obj/item/tank/anesthetic(src)
	new /obj/item/clothing/mask/breath/medical(src)
	new /obj/item/clothing/mask/breath/medical(src)
	new /obj/item/clothing/mask/breath/medical(src)
	return

/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(ACCESS_MARINE_MEDBAY)
	icon_state = "secure_locked_medical_white"
	icon_closed = "secure_unlocked_medical_white"
	icon_locked = "secure_locked_medical_white"
	icon_opened = "secure_open_medical_white"
	icon_broken = "secure_closed_medical_white"
	icon_off = "secure_closed_medical_white"

/obj/structure/closet/secure_closet/medical3/Initialize()
	. = ..()
	new /obj/item/storage/belt/medical/full(src)
	new /obj/item/storage/belt/medical/full(src)
	new /obj/item/storage/backpack/marine/satchel(src)
	new /obj/item/clothing/under/rank/medical/green(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/storage/pouch/medical(src)
	new /obj/item/storage/pouch/medical(src)
	new /obj/item/storage/pouch/syringe(src)
	new /obj/item/storage/pouch/medkit(src)
	new /obj/item/storage/pouch/medkit(src)
	new /obj/item/storage/pouch/chem(src)
	new /obj/item/storage/pouch/chem(src)
	new /obj/item/storage/pouch/vials/full(src)
	new /obj/item/storage/pouch/vials/full(src)
	new /obj/item/storage/pouch/pressurized_reagent_canister(src)
	new /obj/item/storage/pouch/pressurized_reagent_canister(src)
	if(is_mainship_level(z))
		new /obj/item/device/radio/headset/almayer/doc(src)
	return

/obj/structure/closet/secure_closet/CMO
	name = "chief medical officer's locker"
	req_access = list(ACCESS_MARINE_CMO)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

/obj/structure/closet/secure_closet/CMO/Initialize()
	. = ..()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/under/rank/medical/green(src)
	new /obj/item/clothing/under/rank/medical/blue(src)
	new /obj/item/clothing/under/rank/medical/lightblue(src)
	new /obj/item/clothing/under/rank/medical/purple(src)
	new /obj/item/clothing/head/surgery/green(src)
	new /obj/item/clothing/head/surgery/blue(src)
	new /obj/item/clothing/head/surgery/purple(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/head/cmo(src)
	new /obj/item/reagent_container/hypospray/tricordrazine(src)
	new /obj/item/device/flash(src)
	new /obj/item/storage/pouch/medical(src)
	new /obj/item/storage/pouch/syringe(src)
	new /obj/item/storage/pouch/medkit(src)
	return
/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "secure_locked_medical_white"
	icon_closed = "secure_unlocked_medical_white"
	icon_locked = "secure_locked_medical_white"
	icon_opened = "secure_open_medical_white"
	icon_broken = "secure_closed_medical_white"
	icon_off = "secure_closed_medical_white"
	req_access = list(ACCESS_MARINE_CHEMISTRY)

/obj/structure/closet/secure_closet/chemical/Initialize()
	. = ..()
	for(var/i = 0, i < 4, i++)
		new /obj/item/storage/box/pillbottles(src)
	return

/obj/structure/closet/secure_closet/medical_wall
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall_locked"
	icon_closed = "medical_wall_unlocked"
	icon_locked = "medical_wall_locked"
	icon_opened = "medical_wall_open"
	icon_broken = "medical_wall_spark"
	icon_off = "medical_wall_off"
	anchored = TRUE
	density = FALSE
	wall_mounted = 1
	req_access = list(ACCESS_MARINE_MEDBAY)

/obj/structure/closet/secure_closet/medical_wall/update_icon()
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

/obj/structure/closet/secure_closet/surgical
	name = "surgical equipment cabinet"
	desc = "A self-sterilizing, wall-mounted cabinet containing all the surgical tools you need."
	req_access = list(ACCESS_MARINE_MEDBAY)
	icon_state = "surgical_wall_locked"
	icon_closed = "surgical_wall_unlocked"
	icon_locked = "surgical_wall_locked"
	icon_opened = "surgical_wall_open"
	icon_broken = "surgical_wall_spark"
	density = FALSE
	store_mobs = FALSE
	wall_mounted = TRUE


/obj/structure/closet/secure_closet/surgical/Initialize()
	. = ..()
	new /obj/item/storage/surgical_tray(src)
	new /obj/item/roller/surgical(src)

/obj/structure/closet/secure_closet/professor_dummy
	name = "professor dummy cabinet"
	desc = "An ultrasafe cabinet containing Professor DUMMY and its tablet. Only accessible by Chief Medical Officers and Senior Listed Advisors."
	icon_state = "surgical_wall_locked"
	icon_closed = "surgical_wall_unlocked"
	icon_locked = "surgical_wall_locked"
	icon_opened = "surgical_wall_open"
	icon_broken = "surgical_wall_spark"
	health = null	// Unbreakable
	unacidable = TRUE
	unslashable = TRUE
	store_mobs = TRUE
	wall_mounted = TRUE

/obj/structure/closet/secure_closet/professor_dummy/Initialize()
	. = ..()
	new /mob/living/carbon/human/professor_dummy(src)

/obj/structure/closet/secure_closet/professor_dummy/togglelock(mob/living/user)
	if(user.job == JOB_CMO || user.job == JOB_SEA)
		return ..()

	to_chat(user, SPAN_WARNING("Only the [JOB_CMO] or the [JOB_SEA] can toggle this lock."))

/obj/structure/closet/secure_closet/professor_dummy/dump_contents()
	if(locate(/mob/living/carbon/human/professor_dummy) in src)
		visible_message(SPAN_HIGHDANGER("Professor DUMMY should only be used for teaching medical personnel, exclusively done by the [JOB_CMO] or the [JOB_SEA]. Do not abuse it."))
	return ..()

/obj/structure/closet/secure_closet/professor_dummy/close()
	for(var/mob/mob in loc)
		if(!istype(mob, /mob/living/carbon/human/professor_dummy))
			visible_message(SPAN_WARNING("[src] won't budge!"))
			return
	..()

	// Force locking upon closing it
	locked = TRUE
	update_icon()

/obj/structure/closet/secure_closet/professor_dummy/flashbang(datum/source, obj/item/explosive/grenade/flashbang/FB)
	return

/obj/structure/closet/secure_closet/professor_dummy/proc/check_and_destroy_dummy()
	var/mob/dummy = locate(/mob/living/carbon/human/professor_dummy) in src
	if(dummy)
		visible_message(SPAN_DANGER("Something in [src] blows apart!"))
		playsound(src, 'sound/effects/metal_crash.ogg', 25, 1)
		qdel(dummy)

/obj/structure/closet/secure_closet/professor_dummy/emp_act(severity)
	check_and_destroy_dummy()
	..()

/obj/structure/closet/secure_closet/professor_dummy/ex_act(severity)
	check_and_destroy_dummy()
	..()
