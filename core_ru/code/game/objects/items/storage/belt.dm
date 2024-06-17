//	Добавлен механизм режима кобуры
/obj/item/storage/belt/gun
	var/holster_mode = TRUE	// Переключатель для выхватывания оружия

/obj/item/storage/belt/gun/verb/toggle_mode()	// Переключатель для выхватывания оружия
	set category = "Object"
	set name = "Переключить режим кобуры"
	set src in usr
	if(src && ishuman(usr))
		holster_mode = !holster_mode
		to_chat(usr, SPAN_NOTICE("Теперь при взаимодействии я буду [holster_mode ? "выхватывать оружие": "открывать пояс для осмотра"]."))

/obj/item/storage/belt/gun/get_examine_text()
	. = ..()
	. += SPAN_NOTICE("На данный момент при взаимодействии [holster_mode ? "оружие из пояса сразу берётся в руки": "пояс открывается для осмотра"].")

/obj/item/storage/belt/gun/attack_hand(mob/user, mods)
	if(holster_mode)
		if(length(holstered_guns) && ishuman(user) && loc == user)
			var/obj/item/I
			if(mods && mods["alt"] && length(contents) > length(holstered_guns)) //Withdraw the most recently inserted magazine, if possible.
				var/list/magazines = contents - holstered_guns
				I = magazines[length(magazines)]
			else //Otherwise find and draw the last-inserted gun.
				I = holstered_guns[length(holstered_guns)]
			I.attack_hand(user)
			return

	..()

//	Ремонтный пояс
//	Доступен за очки, хранит гвоздомет, его магазины и много материалов, за основу взята механика XM51

/obj/item/storage/belt/gun/repairbelt
	name = "M276 Repair belt"
	desc = "M276 является стандартной пехотной амуницией USCM, представляющую собой модульный ремнень с различными креплениями. Эта версия предназначена для инженерных войск, и имеет кобуру для промышленого гвоздомета, большой подсумок для материалов и пары магазинов."
	icon = 'core_ru/icons/obj/items/nailgun.dmi'
	icon_state = "nailgun_holster"
	item_icons = list(
		WEAR_WAIST = 'core_ru/icons/mob/human/onmob/belt.dmi',
		WEAR_L_HAND = 'core_ru/icons/mob/human/items_lefthand_1.dmi',
		WEAR_R_HAND = 'core_ru/icons/mob/human/items_righthand_1.dmi'
		)
	item_state_slots = list(
		WEAR_L_HAND = "utility",
		WEAR_R_HAND = "utility"
		)
	has_gamemode_skin = FALSE
	gun_has_gamemode_skin = FALSE
	holster_mode = FALSE
	storage_slots = 10
	max_w_class = 5
	can_hold = list(
		/obj/item/weapon/gun/smg/nailgun,
		/obj/item/ammo_magazine/smg/nailgun,
		/obj/item/ammo_magazine/handful,
		/obj/item/ammo_magazine/pistol,
		/obj/item/tool/weldingtool,
		/obj/item/tool/shovel/etool,
		/obj/item/device/lightreplacer,

		/obj/item/stack/barbed_wire,
		/obj/item/stack/sheet,
		/obj/item/stack/rods,
		/obj/item/stack/cable_coil,
		/obj/item/stack/tile,
		/obj/item/stack/sandbags_empty,
	)
	holster_slots = list(
		"1" = list(
			"icon_x" = 8,
			"icon_y" = 0))

	var/maxmats = 5
	var/mats = 0

/obj/item/storage/belt/gun/repairbelt/synth/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/nailgun/compact())
	new /obj/item/ammo_magazine/smg/nailgun(src)
	new /obj/item/ammo_magazine/smg/nailgun(src)
	new /obj/item/tool/weldingtool/hugetank(src)
	new /obj/item/device/lightreplacer(src)
	new /obj/item/tool/shovel/etool(src)
/*	new /obj/item/stack/sheet/metal/large_stack(src)		// Пока оставим так - давать его в обычный вендор еще и с ресурсами это не честно
	new /obj/item/stack/sheet/metal/medium_stack(src)
	new /obj/item/stack/sheet/plasteel/med_large_stack(src) */

/obj/item/storage/belt/gun/repairbelt/can_be_inserted(obj/item/item, mob/user, stop_messages = FALSE) // проверка на добавление
	. = ..()
	if(mats >= maxmats && istype(item, /obj/item/stack))
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src] не может хранить больше материалов."))
		return FALSE

/obj/item/storage/belt/gun/repairbelt/handle_item_insertion(obj/item/item, prevent_warning = FALSE, mob/user) // добавление
	. = ..()
	if(istype(item, /obj/item/stack))
		mats++

/obj/item/storage/belt/gun/repairbelt/remove_from_storage(obj/item/item as obj, atom/new_location) // извлечение
	. = ..()
	if(istype(item, /obj/item/stack))
		mats--

/obj/item/storage/belt/gun/repairbelt/on_stored_atom_del(atom/movable/item) // удаление
	if(istype(item, /obj/item/stack))
		mats--

// Кейсы и заказы
/obj/item/storage/box/guncase/repairbelt
	name = "F1X Nailgun"
	desc = "Кейс, содержащий ремонтно-фортификационный набор. Поставляется с промышленным гвоздометом, магазинами к нему, сваркой, лопатой и комплектом материалов."
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/smg/nailgun,
		/obj/item/ammo_magazine/smg/nailgun,
		/obj/item/tool/weldingtool,
		/obj/item/tool/shovel/etool,
		/obj/item/stack/sheet/metal,
		/obj/item/stack/sandbags_empty,
		)

/obj/item/storage/box/guncase/repairbelt/fill_preset_inventory()
	new /obj/item/weapon/gun/smg/nailgun(src)
	new /obj/item/ammo_magazine/smg/nailgun(src)
	new /obj/item/ammo_magazine/smg/nailgun(src)
	new /obj/item/tool/weldingtool/hugetank(src)
	new /obj/item/tool/shovel/etool(src)
	new /obj/item/stack/sheet/metal/med_small_stack(src)
	new /obj/item/stack/sandbags_empty/half(src)
	new /obj/item/storage/belt/gun/repairbelt(src)

/datum/supply_packs/repairbelt
	name = "F1X Nailgun Create (х2)"
	contains = list(
		/obj/item/storage/box/guncase/repairbelt,
		/obj/item/storage/box/guncase/repairbelt,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "F1X Nailgun Create"
	group = "Weapons"
