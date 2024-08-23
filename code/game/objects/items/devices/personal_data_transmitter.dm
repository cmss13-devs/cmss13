
#define PDT_BATTERY_DEFAULT_CAPACITY 500
#define PDT_BATTERY_WARNING_CAPACITY 250

#define PDT_BATTERY_SCREEN_DRAW 10
#define PDT_BATTERY_LOCATE_DRAW 50
#define PDT_BATTERY_TOTAL_DRAW PDT_BATTERY_SCREEN_DRAW + PDT_BATTERY_LOCATE_DRAW


/obj/item/device/pdt_locator_tube
	name = "\improper PDT locator tube"
	desc = "The second half of the Personal Data Transmitter Bracelet/Locator Tube Set, also known as a PDT/L. When activated, this device attempts to locate the paired Personal Data Transmitter Bracelet. They both share a serial number for ease of detection in case of mixup."
	icon_state = "pdt_locator_tube"
	w_class = SIZE_SMALL

	var/obj/item/clothing/accessory/pdt_bracelet/linked_bracelet
	var/obj/item/cell/crap/battery

/obj/item/device/pdt_locator_tube/Initialize(mapload, obj/item/clothing/accessory/pdt_bracelet/bracelet)
	. = ..()
	if(bracelet)
		linked_bracelet = bracelet
		linked_bracelet.copied_serial_number = src.serial_number
		RegisterSignal(bracelet, COMSIG_PARENT_PREQDELETED, PROC_REF(handle_bracelet_deletion))
	battery = new(src)
	update_icon()

/obj/item/device/pdt_locator_tube/update_icon()
	overlays.Cut()
	. = ..()
	var/batcheck = TRUE

	if(battery)
		icon_state = "pdt_locator_tube"
		switch(battery.charge)
			//all good
			if(PDT_BATTERY_WARNING_CAPACITY to PDT_BATTERY_DEFAULT_CAPACITY)
				overlays += image('icons/obj/items/devices.dmi', "+pdt_locator_tube_overlay_normal")
			//getting low, warning
			if(PDT_BATTERY_TOTAL_DRAW to PDT_BATTERY_WARNING_CAPACITY)
				overlays += image('icons/obj/items/devices.dmi', "+pdt_locator_tube_overlay_yellow")
			//blinking red, can't do anything but draw screens
			if(PDT_BATTERY_SCREEN_DRAW to PDT_BATTERY_TOTAL_DRAW)
				overlays += image('icons/obj/items/devices.dmi', "+pdt_locator_tube_overlay_red")
			//it's gone...
			else
				batcheck = FALSE
				//overlays += none!!
	else
		icon_state = "pdt_locator_tube_e"
		batcheck = FALSE
	if(batcheck)
		if(linked_bracelet)
			overlays += image('icons/obj/items/devices.dmi', "+pdt_locator_tube_overlay_bracelet_linked")
		else
			overlays += image('icons/obj/items/devices.dmi', "+pdt_locator_tube_overlay_bracelet_unlinked")

/obj/item/device/pdt_locator_tube/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cell/crap))
		if(battery)
			to_chat(user, SPAN_WARNING("\The [src] already has a battery installed."))
			return
		user.drop_inv_item_to_loc(W, src)
		battery = W
		to_chat(user, SPAN_NOTICE("You insert \the [battery] into \the [src]."))
		playsound(src, 'sound/machines/pda_button2.ogg', 15, TRUE)
		update_icon()
	else if(istype(W, /obj/item/cell))
		to_chat(user, SPAN_NOTICE("That industrial-sized battery is WAY too big for the tiny battery slot."))
	return ..()

/obj/item/device/pdt_locator_tube/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(!battery)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a battery installed."))
			return
		battery.update_icon()
		user.put_in_hands(battery)
		to_chat(user, SPAN_NOTICE("You pull \the [battery] out of \the [src]."))
		battery = null
		playsound(src, 'sound/machines/pda_button1.ogg', 15, TRUE)
		update_icon()
		return
	return ..()

/obj/item/device/pdt_locator_tube/attack_self(mob/user)
	..()

	if(!battery)
		to_chat(user, SPAN_WARNING("\The [src] doesn't do anything! It must have run out of battery already... what a piece of junk. You realize the battery cover is open."))
		playsound(src, 'sound/machines/switch.ogg', 15, TRUE)
		return

	if(!battery.use(PDT_BATTERY_SCREEN_DRAW))
		to_chat(user, SPAN_WARNING("\The [src] doesn't do anything! It must have run out of battery already... what a piece of junk."))
		playsound(src, 'sound/machines/switch.ogg', 15, TRUE)
		return
	update_icon()

	if(!battery.use(PDT_BATTERY_LOCATE_DRAW))
		to_chat(user, SPAN_WARNING("The display on \the [src] dimly lights up: <b> LOW POWER <b>"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 15, TRUE)
		return
	update_icon()

	if(!linked_bracelet)
		to_chat(user, SPAN_BOLDWARNING("The display on \the [src] lights up: <b> ERROR: NO LINKED BRACELET DETECTED<b>"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 15, TRUE)
		return

	locate_bracelet(user)

/obj/item/device/pdt_locator_tube/proc/locate_bracelet(mob/user)
	var/turf/self_turf = get_turf(src)
	var/turf/bracelet_turf = get_turf(linked_bracelet)
	var/area/self_area = get_area(self_turf)
	var/area/bracelet_area = get_area(bracelet_turf)

	if(self_turf.z != bracelet_turf.z || self_area.fake_zlevel != bracelet_area.fake_zlevel)
		to_chat(user, SPAN_BOLDWARNING("The display on \the [src] lights up: <b> UNABLE TO CONNECT TO LINKED BRACELET<b>"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 15, TRUE)
		return

	var/dist = get_dist(self_turf, bracelet_turf)
	var/direction = dir2text_short(Get_Compass_Dir(self_turf, bracelet_turf))
	if(dist > 1)
		to_chat(user, SPAN_BOLDNOTICE("The display on \the [src] lights up: <b>[dist]-[direction]</b>"))
	else
		to_chat(user, SPAN_BOLDNOTICE("The display on \the [src] lights up: <b>--><--</b>"))
	playsound(src, 'sound/machines/ping.ogg', 15, TRUE)

	linked_bracelet.visible_message(SPAN_BOLDNOTICE("\The [src] lights up for a moment and makes a beeping noise!"), max_distance = 3)
	playsound(linked_bracelet, 'sound/machines/twobeep.ogg', 15, TRUE)
	return

/obj/item/device/pdt_locator_tube/proc/handle_bracelet_deletion()
	linked_bracelet = null
	update_icon()

/obj/item/device/pdt_locator_tube/Destroy()
	linked_bracelet = null
	QDEL_NULL(battery)
	return ..()

/obj/item/clothing/accessory/pdt_bracelet
	name = "\improper PDT bracelet"
	desc = "A personal data transmitter bracelet, also known as a PDT, is a form of personal locator typically surgically implanted into the body of extrasolar colonists, among others. Its purpose is to allow rapid location of the associated personnel anywhere within a certain radius of the receiving equipment, sometimes up to 30km distance. This bracelet forms part of the PDT/L variant, which is a wearable version of the PDT technology. Both it and the linked locator tube share a serial number for ease of detection in case of mixup."
	var/dummy_icon_state = "pdt_watch"
	var/copied_serial_number = null

/obj/item/clothing/accessory/pdt_bracelet/get_examine_text(mob/user)
	. = ..()
	if(!isxeno(user) && (get_dist(user, src) < 2 || isobserver(user)) && copied_serial_number)
		. += SPAN_INFO("The serial number is [copied_serial_number].")

/obj/item/clothing/accessory/pdt_bracelet/Initialize()
	. = ..()
	icon_state = "[dummy_icon_state]_[rand(0, 2)]"

/obj/item/storage/box/pdt_kit
	name = "\improper Boots! PDT/L Battle Buddy kit"
	desc = "Contains a PDT/L set, consisting of the PDT bracelet and its sister locator tube, alongside a spare cell seemingly wedged into the kit."
	desc_lore = "This kit was distributed in the 200th (Season 4) Issue of the Boots! magazine, 'Privates die without their battlebuddy!', to drive up sales. Many have noted the poor battery life of these units, leading many to speculate that these were faulty units that were repackaged and shipped off to various USCM-adjacent mil-surplus good stores. The Department of the Navy Observation in Photographs (DNOP) has not released a statement regarding these theories."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "pdt_box"
	can_hold = list(/obj/item/device/pdt_locator_tube, /obj/item/clothing/accessory/pdt_bracelet)
	foldable = /obj/item/stack/sheet/cardboard
	storage_slots = 3
	w_class = SIZE_SMALL
	max_w_class = SIZE_SMALL

/obj/item/storage/box/pdt_kit/fill_preset_inventory()
	new /obj/item/device/pdt_locator_tube(src, new /obj/item/clothing/accessory/pdt_bracelet(src))
	new /obj/item/cell/crap(src) //it not fitting is intentional

/// THE ADVANCED VERSION... ADMIN SPAWN ONLY... USES TGUI RADAR... ///

/obj/item/storage/box/pdt_kit/advanced
	name = "advanced PDT/L Battle Buddy kit"
	desc = "Contains a PDT/L set, consisting of the advanced PDT bracelet and its sister locator tube, alongside a spare cell seemingly wedged into the kit."

/obj/item/storage/box/pdt_kit/advanced/fill_preset_inventory()
	new /obj/item/device/pdt_locator_tube/advanced(src, new /obj/item/clothing/accessory/pdt_bracelet/advanced(src))
	new /obj/item/cell/crap(src) //it not fitting is intentional

/obj/item/device/pdt_locator_tube/advanced
	name = "advanced PDT locator tube"
	var/datum/radar/advanced_pdtl/radar

/obj/item/device/pdt_locator_tube/advanced/Initialize(mapload, obj/item/clothing/accessory/pdt_bracelet/bracelet)
	. = ..()
	radar = new /datum/radar/advanced_pdtl(src)

/obj/item/device/pdt_locator_tube/advanced/Destroy()
	QDEL_NULL(radar)
	. = ..()

/obj/item/device/pdt_locator_tube/advanced/handle_bracelet_deletion()
	. = ..()
	SStgui.close_uis(radar)

/obj/item/device/pdt_locator_tube/advanced/locate_bracelet(mob/user)
	radar.tgui_interact(user)

/obj/item/clothing/accessory/pdt_bracelet/advanced
	name = "advanced PDT bracelet"
