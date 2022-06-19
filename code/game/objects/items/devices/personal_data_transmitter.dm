/obj/item/device/pdt_locator_tube
	name = "\improper PDT locator tube"
	desc = "The second half of the Personal Data Trasmitter Bracelet/Locator Tube Set, also known as a PDT/L. When activated, this device attempts to locate the paired Personal Data Transmitter Bracelet."
	icon_state = "pdt_locator_tube"
	w_class = SIZE_SMALL

	var/obj/item/clothing/accessory/pdt_bracelet/linked_bracelet
	var/obj/item/cell/crap/battery

/obj/item/device/pdt_locator_tube/Initialize(mapload, obj/item/clothing/accessory/pdt_bracelet/bracelet)
	. = ..()
	if(bracelet)
		linked_bracelet = bracelet
		RegisterSignal(bracelet, COMSIG_PARENT_PREQDELETED, .proc/handle_bracelet_deletion)
	battery = new(src)

/obj/item/device/pdt_locator_tube/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cell/crap))
		if(battery)
			to_chat(user, SPAN_WARNING("\The [src] already has a battery installed."))
			return
		user.drop_inv_item_to_loc(W, src)
		battery = W
		to_chat(user, SPAN_NOTICE("You insert \the [battery] into \the [src]."))
	return ..()

/obj/item/device/pdt_locator_tube/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(!battery)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a battery installed."))
			return
		battery.update_icon()
		user.put_in_hands(battery)
		battery = null
		to_chat(user, SPAN_NOTICE("You pull \the [battery] out of \the [src]."))
		return
	return ..()

/obj/item/device/pdt_locator_tube/attack_self(mob/user)
	..()

	if(!battery || !battery.use(battery.maxcharge / 5))
		to_chat(user, SPAN_WARNING("\The [src] has no battery charge."))
		return
	if(!linked_bracelet)
		to_chat(user, SPAN_WARNING("\The [src] couldn't connect to its linked bracelet."))
		return

	var/turf/self_turf = get_turf(src)
	var/turf/bracelet_turf = get_turf(linked_bracelet)
	var/area/self_area = get_area(self_turf)
	var/area/bracelet_area = get_area(bracelet_turf)

	if(self_turf.z != bracelet_turf.z || self_area.fake_zlevel != bracelet_area.fake_zlevel)
		to_chat(user, SPAN_WARNING("\The [src] couldn't connect to its linked bracelet."))
		return

	var/dist = get_dist(self_turf, bracelet_turf)
	var/direction = dir2text_short(get_dir(self_turf, bracelet_turf))
	if(dist > 1)
		to_chat(user, SPAN_NOTICE("The display on \the [src] lights up: <b>[dist]-[direction]</b>"))
	else
		to_chat(user, SPAN_NOTICE("The display on \the [src] lights up: <b>--><--</b>"))
	playsound(src, 'sound/machines/twobeep.ogg', 15, TRUE)
	playsound(linked_bracelet, 'sound/machines/twobeep.ogg', 15, TRUE)

/obj/item/device/pdt_locator_tube/proc/handle_bracelet_deletion()
	linked_bracelet = null

/obj/item/device/pdt_locator_tube/Destroy()
	linked_bracelet = null
	return ..()

/obj/item/clothing/accessory/pdt_bracelet
	name = "\improper PDT bracelet"
	desc = "A personal data transmitter bracelet, also known as a PDT, is a form of personal locator typically surgically implanted into the body of extrasolar colonists, among others. Its purpose is to allow rapid location of the associated personnel anywhere within a certain radius of the receiving equipment, sometimes up to 30km distance. This bracelet forms part of the PDT/L variant, which is a wearable version of the PDT technology."
	icon_state = "pdt_watch"

/obj/item/clothing/accessory/pdt_bracelet/Initialize()
	. = ..()
	icon_state = "[icon_state]_[rand(0, 2)]"

/obj/item/storage/box/pdt_kit
	name = "\improper Boots! PDT/L Battle Buddy kit"
	desc = "Contains a PDT/L set, consisting of the PDT bracelet and its sister locator tube."
	desc_lore = "This kit was distributed in the 200th (Season 4) Issue of the Boots! magazine, 'Privates die without their battlebuddy!', to drive up sales. Many have noted the poor battery life of these units, leading many to speculate that these were faulty units that were repackaged and shipped off to various USCM-adjacent mil-surplus good stores. The Department of the Navy Observation in Photographs (DNOP) has not released a statement regarding these theories."
	icon_state = "pdt_box"
	can_hold = list(/obj/item/device/pdt_locator_tube, /obj/item/clothing/accessory/pdt_bracelet)
	foldable = TRUE
	storage_slots = 2
	w_class = SIZE_SMALL
	max_w_class = SIZE_SMALL

/obj/item/storage/box/pdt_kit/fill_preset_inventory()
	new /obj/item/device/pdt_locator_tube(src, new /obj/item/clothing/accessory/pdt_bracelet(src))
