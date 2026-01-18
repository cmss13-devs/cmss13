/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	icon_state = "secure_locked_basic"
	icon_opened = "secure_open_basic"
	icon_closed = "secure_locked_basic"
	crate_customizing_types = null
	var/icon_locked = "secure_locked_basic"
	var/icon_unlocked = "secure_unlocked_basic"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	var/broken = 0
	var/locked = 1

/obj/structure/closet/crate/secure/Initialize()
	. = ..()
	update_icon()


/obj/structure/closet/crate/secure/update_icon()
	overlays.Cut()
	if(opened)
		icon_state = icon_opened
	else if(locked)
		icon_state = icon_locked
	else
		icon_state = icon_unlocked
	if(welded)
		overlays += "welded"


/obj/structure/closet/crate/secure/can_open()
	return !locked

/obj/structure/closet/crate/secure/proc/togglelock(mob/user as mob)
	if(src.opened)
		to_chat(user, SPAN_NOTICE("Close the crate first."))
		return
	if(src.broken)
		to_chat(user, SPAN_WARNING("The crate appears to be broken."))
		return
	if(src.allowed(user))
		src.locked = !src.locked
		for(var/mob/O in viewers(user, 3))
			if((O.client && !( O.blinded )))
				to_chat(O, SPAN_NOTICE("The crate has been [locked ? null : "un"]locked by [user]."))
		icon_state = locked ? icon_locked : icon_unlocked
	else
		to_chat(user, SPAN_NOTICE("Access Denied"))

/obj/structure/closet/crate/secure/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(usr.is_mob_incapacitated()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

/obj/structure/closet/crate/secure/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(locked)
		src.togglelock(user)
	else
		src.toggle(user)

/obj/structure/closet/crate/secure/attackby(obj/item/W as obj, mob/user as mob)
	if(isxeno(user))
		var/mob/living/carbon/xenomorph/opener = user
		src.attack_alien(opener)
		return
	if(is_type_in_list(W, list(/obj/item/packageWrap, /obj/item/stack/cable_coil, /obj/item/device/radio/electropack, /obj/item/tool/wirecutters, /obj/item/tool/weldingtool)))
		return ..()
	if(!opened)
		src.togglelock(user)
		return
	return ..()

/obj/structure/closet/crate/secure/break_open()
	broken = TRUE
	locked = FALSE
	..()

/obj/structure/closet/crate/secure/emp_act(severity)
	. = ..()
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50/severity))
		if(!locked)
			locked = 1
		else
			overlays.Cut()
			overlays += emag
			overlays += sparks
			spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
			playsound(src.loc, 'sound/effects/sparks4.ogg', 25, 1)
			locked = 0
		update_icon()
	if(!opened && prob(20/severity))
		if(!locked)
			open()
		else
			src.req_access = list()
			src.req_access += pick(get_access(ACCESS_LIST_MARINE_MAIN))


//------------------------------------
// Secure Crates
//------------------------------------

/obj/structure/closet/crate/secure/ammo
	name = "secure ammunitions crate"
	desc = "A secure ammunitions crate"
	icon_state = "secure_locked_ammo"
	icon_opened = "secure_open_ammo"
	icon_locked = "secure_locked_ammo"
	icon_unlocked = "secure_unlocked_ammo"

/obj/structure/closet/crate/secure/explosives
	name = "explosives crate"
	desc = "An explosives crate"
	icon_state = "secure_locked_explosives"
	icon_opened = "secure_open_explosives"
	icon_locked = "secure_locked_explosives"
	icon_unlocked = "secure_unlocked_explosives"

// Needs to be converted to new system that does not use overlays
// using default secure crate for now
/obj/structure/closet/crate/secure/phoron
	name = "phoron crate"
	desc = "A secure phoron crate."

// Needs to be converted to new system that does not use overlays
// using Wayland crate for now
/obj/structure/closet/crate/secure/gear
	name = "gear crate"
	desc = "A secure gear crate."
	icon_state = "secure_locked_ammo"
	icon_opened = "secure_open_ammo"
	icon_locked = "secure_locked_ammo"
	icon_unlocked = "secure_unlocked_ammo"

/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of the station's botanists."
	icon_state = "secure_locked_hydro"
	icon_opened = "secure_open_hydro"
	icon_locked = "secure_locked_hydro"
	icon_unlocked = "secure_unlocked_hydro"

/obj/structure/closet/crate/secure/surgery
	name = "surgery crate"
	desc = "A surgery crate."
	icon_state = "secure_locked_surgery"
	icon_opened = "secure_open_surgery"
	icon_locked = "secure_locked_surgery"
	icon_unlocked = "secure_unlocked_surgery"

/obj/structure/closet/crate/secure/medical
	name = "medical crate"
	desc = "A medical crate with a secure lock on it."
	icon_state = "secure_locked_medical"
	icon_opened = "secure_open_medical"
	icon_locked = "secure_locked_medical"
	icon_unlocked = "secure_unlocked_medical"

/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	icon_state = "secure_locked_weapons"
	icon_opened = "secure_open_weapons"
	icon_locked = "secure_locked_weapons"
	icon_unlocked = "secure_unlocked_weapons"

/obj/structure/closet/crate/secure/weyland
	name = "secure W-Y crate"
	desc = "A secure crate with a W-Y insignia on it."
	icon_state = "secure_locked_weyland"
	icon_opened = "secure_open_weyland"
	icon_locked = "secure_locked_weyland"
	icon_unlocked = "secure_unlocked_weyland"

/obj/structure/closet/crate/secure/vulture
	name = "secure M707 crate"
	desc = "A secure crate, containing an M707 anti-materiel rifle."
	icon_state = "secure_locked_vulture"
	icon_opened = "secure_open_vulture"
	icon_locked = "secure_locked_vulture"
	icon_unlocked = "secure_unlocked_vulture"

/obj/structure/closet/crate/secure/vulture/Initialize()
	. = ..()
	new /obj/item/storage/box/guncase/vulture(src)

//special version, able to store OB fuel and warheads only
/obj/structure/closet/crate/secure/ob
	name = "secure orbital bombardment ammunition crate"
	desc = "A secure crate capable of storing orbital bombardment warheads and fuel."
	icon_state = "secure_locked_ob"
	icon_opened = "secure_open_ob"
	icon_locked = "secure_locked_ob"
	icon_unlocked = "secure_unlocked_ob"

/obj/structure/closet/crate/secure/ob/close()
	if(!opened)
		return FALSE
	if(!can_close())
		return FALSE

	playsound(src.loc, 'sound/machines/click.ogg', 15, 1)
	var/itemcount = 0
	for(var/obj/O in get_turf(src))
		if(itemcount >= storage_capacity)
			break
		//Only OB warheads and fuel gets in this boi
		if(!istype(O, /obj/structure/ob_ammo))
			continue
		O.forceMove(src)
		itemcount++

	opened = FALSE
	climbable = TRUE
	update_icon()
	return TRUE
