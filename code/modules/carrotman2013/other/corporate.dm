//Case//

/obj/item/storage/secure/briefcase/corpsec
	name = "Corporate Security Equipment"
	desc = "Contains single set of a corporate security equipment."
	icon = 'fray-marines/icons/obj/items/storage.dmi'
	icon_state = "corporates"
	item_state = "sec-case"
	max_storage_space = 4

/obj/item/storage/secure/briefcase/corpsec/fill_preset_inventory()
	new /obj/item/device/radio/headset/distress/WY(src)
	new /obj/item/clothing/under/marine/veteran/pmc/corporate(src)
	new /obj/item/inflatable/door(src)
	new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate(src)
	new /obj/item/clothing/gloves/marine/veteran(src)
	new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate(src)
	new /obj/item/clothing/shoes/marine/corporate(src)
	new /obj/item/storage/backpack/lightpack(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/handcuffs/zip(src)
	new /obj/item/handcuffs/zip(src)
	new /obj/item/handcuffs/zip(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/storage/belt/gun/m4a3/mod88(src)
	new /obj/item/storage/pouch/firstaid/full(src)
	new /obj/item/weapon/gun/rifle/m41a/corporate(src)
	new /obj/item/storage/pouch/magazine/pulse_rifle(src)
	new /obj/item/ammo_magazine/rifle/ap(src)
	new /obj/item/ammo_magazine/rifle/ap(src)

//Button//
#define COOLDOWN_CORPORATE_BUTTON 10 MINUTES

/obj/structure/machinery/computer/corporate/button//TODO:SANITY
	name = "Request Corporate Security"
	desc = "Used to request a dispatch of corporate security squad."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "big_red_button_tablev"
	req_one_access = list(ACCESS_WY_GENERAL)
	var/console_cooldown
	var/console_cooldown_duration = COOLDOWN_CORPORATE_BUTTON

/datum/admins/Topic(href, href_list)
	..()
	if(href_list["csdeny"])
		var/mob/ref_person = locate(href_list["csdeny"])
		log_game("[key_name_admin(usr)] отклонил вызов корпоративной охраны, запрошенный [key_name_admin(ref_person)]")
		message_admins("[key_name_admin(usr)] отклонил вызов корпоративной охраны, запрошенный [key_name_admin(ref_person)]", 1)

	if(href_list["cssend"])
		var/mob/ref_person = locate(href_list["cssend"])
		message_admins("[key_name_admin(usr)] одобрил вызов корпоративной охраны, запрошенный [key_name_admin(ref_person)]")
		marine_announcement("Вызов корпоративной охраны одобрен.", "Corporate Security Beacon", logging = ARES_LOG_SECURITY)
		var/datum/emergency_call/goon/goon = new()
		goon.activate(TRUE, FALSE)
		log_game("[key_name_admin(usr)] has sent corporate security, requested by [key_name_admin(ref_person)]")

/obj/structure/machinery/computer/corporate/button/attack_hand(mob/user)
	. = ..()
	to_chat(user, SPAN_WARNING("Прикладываю палец к сканнеру... Сейчас..."))
	if(!do_after(usr, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return
	if(world.time < console_cooldown)
		to_chat(user, SPAN_WARNING("Заблокировано. Обычно такое на 10 минут."))
		return
	var/message = tgui_input_text(user, "Причина?", "Request Corporate Security", multiline = TRUE)
	if(!message)
		return
	// we know user is a human now, so adjust user for this check
	for(var/client/admin in GLOB.admins)
		if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
			playsound_client(admin,'sound/effects/sos-morse-code.ogg',10)
			message_admins("[key_name(usr)] запросил вызов корпоративной охраны! Причина: <b>[message]</b> [CC_MARK(usr)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];cssend=\ref[user]'>SEND</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];csdeny=\ref[user]'>DENY</A>) [ADMIN_JMP_USER(usr)]")
	console_cooldown = world.time + console_cooldown_duration
