/datum/tutorial/marine/basic
	name = "Морпех - базовое"
	desc = "Это базовое обучение, а именно что надо знать обычному наземному морпеху."
	tutorial_id = "marine_basic_1"
	tutorial_template = /datum/map_template/tutorial/s8x9/no_baselight
	/// How many items need to be vended from the clothing vendor for the script to continue, if something vends 2 items (for example), increase this number by 2.
	var/clothing_items_to_vend = 8
	/// How many items need to be vended from the gun vendor to continue
	var/gun_items_to_vend = 2

// START OF SCRIPTING

/datum/tutorial/marine/basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	var/obj/item/device/flashlight/flashlight = new(loc_from_corner(2, 3))
	flashlight.anchored = TRUE
	flashlight.set_light_power(4)
	flashlight.set_light_range(12)
	flashlight.icon = null
	flashlight.set_light_on(TRUE)
	add_to_tracking_atoms(flashlight)

	init_mob()
	message_to_player("Это базовое обучение морпеха. Выйди из крио капсулы нажимая <b>[retrieve_bind("North")]</b> или <b>[retrieve_bind("East")]</b>.")
	update_objective("Выйди из крио капсулы с помощью [retrieve_bind("North")] или [retrieve_bind("East")].")
	RegisterSignal(tracking_atoms[/obj/structure/machinery/cryopod/tutorial], COMSIG_CRYOPOD_GO_OUT, PROC_REF(on_cryopod_exit))

/datum/tutorial/marine/basic/proc/on_cryopod_exit()
	SIGNAL_HANDLER

	UnregisterSignal(tracking_atoms[/obj/structure/machinery/cryopod/tutorial], COMSIG_CRYOPOD_GO_OUT)
	message_to_player("Хорошо. Обрати внимание на иконку \"голода\" на правой границе экрана. У тебя подсвечен вендор, <b>раздатчик еды</b>, возьми себе <b>Протеиновый батончик</b>.")
	update_objective("Возьми себе протеиновый батончик из подсвеченного раздатчика еды.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial, food_vendor)
	add_highlight(food_vendor)
	food_vendor.req_access = list()
	RegisterSignal(food_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(on_food_vend))

/datum/tutorial/marine/basic/proc/on_food_vend(datum/source, obj/structure/machinery/cm_vending/vendor, list/itemspec, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial, food_vendor)
	UnregisterSignal(food_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
	remove_highlight(food_vendor)
	food_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
	message_to_player("Теперь нажми на своего персонажа с <b>протеиновым батончиком</b> а активной руке пока не съешь его. Если у тебя не обведена нужная рука, поменяй её с помощью <b>[retrieve_bind("swap_hands")]</b>.")
	update_objective("Съешь протеиновый батончик у тебя в руках, ешь его до тех пор, пока он не кончится.")
	RegisterSignal(tutorial_mob, COMSIG_MOB_EATEN_SNACK, PROC_REF(on_foodbar_eaten))

/datum/tutorial/marine/basic/proc/on_foodbar_eaten(datum/source, obj/item/reagent_container/food/snacks/eaten_food)
	SIGNAL_HANDLER

	if(!istype(eaten_food, /obj/item/reagent_container/food/snacks/protein_pack) || eaten_food.reagents.total_volume)
		return

	UnregisterSignal(source, COMSIG_MOB_EATEN_SNACK)
	message_to_player("Отлично, теперь иди к подсвеченному раздатчику, это раздатчик снаряжения морпеха и возьми оттуда всё начиная с верха.")
	update_objective("Возьми всё что находится внутри подсвеченного раздатчика.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial, clothing_vendor)
	add_highlight(clothing_vendor)
	clothing_vendor.req_access = list()
	RegisterSignal(clothing_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(on_clothing_vend))

/datum/tutorial/marine/basic/proc/on_clothing_vend(datum/source)
	SIGNAL_HANDLER

	clothing_items_to_vend--
	if(clothing_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial, clothing_vendor)
		UnregisterSignal(clothing_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
		clothing_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(clothing_vendor)
		message_to_player("Оу... В комнате пропал свет. Возьми свой <b>флаер</b> из своего <b>подсумка с флаерами</b> с помощью нажатия на него пустой рукой. И теперь зажги его у себя в руке используя <b>[retrieve_bind("activate_inhand")]</b>.")
		update_objective("Нажми на свой подсвеченный подсумок, нажми на доставшийся фраер у себя в руках.")
		var/obj/item/storage/pouch/flare/flare_pouch = locate(/obj/item/storage/pouch/flare) in tutorial_mob.contents
		if(flare_pouch)
			add_highlight(flare_pouch)
		RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF, PROC_REF(on_flare_light))
		addtimer(CALLBACK(src, PROC_REF(dim_room)), 2.5 SECONDS)

/datum/tutorial/marine/basic/proc/on_flare_light(datum/source, obj/item/used)
	SIGNAL_HANDLER

	if(!istype(used, /obj/item/device/flashlight/flare))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF)
	var/obj/item/storage/pouch/flare/flare_pouch = locate(/obj/item/storage/pouch/flare) in tutorial_mob.contents
	if(flare_pouch)
		remove_highlight(flare_pouch)

	message_to_player("Теперь брось <b>флаер</b> нажатием на какую нибудь клетку, или брось на пол с помощью <b>[retrieve_bind("drop_item")]</b>.")
	update_objective("Кинь свой флаер рядом с собой, или брось на пол нажатием на [retrieve_bind("drop_item")].")
	RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_DROPPED, PROC_REF(on_flare_throw))

/datum/tutorial/marine/basic/proc/on_flare_throw(datum/source, obj/item/thrown)
	SIGNAL_HANDLER

	if(!istype(thrown, /obj/item/device/flashlight/flare))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_DROPPED)
	message_to_player("Хорошо. Теперь, комната освещена вновь. Иди к подсвеченному раздатчику оружия и возьми <b>Винтовку (M41A Pulse Rifle MK2)</b>, и <b> магазин к ней</b>.")
	update_objective("Возьми всё из подсвеченного раздатчика с оружием.")
	addtimer(CALLBACK(src, PROC_REF(brighten_room)), 1.5 SECONDS)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial, gun_vendor)
	gun_vendor.req_access = list()
	add_highlight(gun_vendor)
	RegisterSignal(gun_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(on_gun_vend))

/datum/tutorial/marine/basic/proc/on_gun_vend(datum/source)
	SIGNAL_HANDLER

	gun_items_to_vend--
	if(gun_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial, gun_vendor)
		gun_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(gun_vendor)
		UnregisterSignal(gun_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
		message_to_player("Теперь вставь <b>магазин</b> в свою <b>винтовку</b>, нажми <b>магазином</b> по своей <b>винтовке</b>. Если магазин находится в другой руке, поменяй активную руку используя <b>[retrieve_bind("swap_hands")]</b>.")
		update_objective("Вставь магазин в оружие нажимая магазином на винтовку.")
		RegisterSignal(tutorial_mob, COMSIG_MOB_RELOADED_GUN, PROC_REF(on_magazine_insert))

/datum/tutorial/marine/basic/proc/on_magazine_insert(datum/source, atom/attacked, obj/item/attacked_with)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_RELOADED_GUN)
	message_to_player("Отлично. Теперь возьми свою винтовку в обе руки с помощью нажатия <b>[retrieve_bind("activate_inhand")]</b> с винтовкой в активной руке.")
	update_objective("Возьми свою винтовку в обе руки нажатием [retrieve_bind("activate_inhand")] со своей винтовкой в активной руке.")
	RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF, PROC_REF(on_gun_wield))

/datum/tutorial/marine/basic/proc/on_gun_wield(datum/source, obj/item/used)
	SIGNAL_HANDLER

	if(!istype(used, /obj/item/weapon/gun/rifle/m41a))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF)
	message_to_player("Теперь, застрели этого <b>ксеноморфа!</b>")
	update_objective("Стреляй в ксеноморфа!")
	var/mob/living/carbon/xenomorph/drone/tutorial/xeno_dummy = new(loc_from_corner(4, 5))
	add_to_tracking_atoms(xeno_dummy)
	add_highlight(xeno_dummy, COLOR_VIVID_RED)
	RegisterSignal(xeno_dummy, COMSIG_MOB_DEATH, PROC_REF(on_xeno_death))
	RegisterSignal(tutorial_mob, COMSIG_MOB_GUN_EMPTY, PROC_REF(on_magazine_empty)) // I'd like to prevent unwilling softlocks as much as I can

/// Non-contiguous part of the script, called if the user manages to run out of ammo in the gun without the xeno dying
/datum/tutorial/marine/basic/proc/on_magazine_empty(obj/item/weapon/gun/empty_gun)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_GUN_EMPTY)
	message_to_player("В твоей винтовке закончились патроны. Давай возьмём ещё из <b>раздатчика снаряжения</b> и убьём <b>ксеноморфа</b>.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial, gun_vendor)
	gun_vendor.req_access = list()
	gun_vendor.load_ammo() // 99 magazines, to make sure that the xeno dies

/datum/tutorial/marine/basic/proc/on_xeno_death(datum/source)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/xenomorph/drone/tutorial, xeno_dummy)
	UnregisterSignal(xeno_dummy, COMSIG_MOB_DEATH)
	UnregisterSignal(tutorial_mob, COMSIG_MOB_GUN_EMPTY)
	remove_highlight(xeno_dummy)
	addtimer(CALLBACK(src, PROC_REF(disappear_xeno)), 2.5 SECONDS)
	message_to_player("Отлично! Это был конец обучения, теперь ты можешь пройти основы <b>медицины</b>. Скоро ты будешь отправлен обратно в лобби.")
	update_objective("")
	tutorial_end_in(7.5 SECONDS, TRUE)


// END OF SCRIPTING
// START OF SCRIPT HELPERS

/datum/tutorial/marine/basic/proc/dim_room()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/flashlight, flashlight)
	flashlight.set_light_on(FALSE)

/datum/tutorial/marine/basic/proc/brighten_room()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/flashlight, flashlight)
	flashlight.set_light_on(TRUE)

/datum/tutorial/marine/basic/proc/disappear_xeno()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/xenomorph/drone/tutorial, xeno_dummy)
	animate(xeno_dummy, time = 5 SECONDS, alpha = 0)
	remove_from_tracking_atoms(xeno_dummy)
	QDEL_IN(xeno_dummy, 5.5 SECONDS)

// END OF SCRIPT HELPERS

/datum/tutorial/marine/basic/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cryopod/tutorial, tutorial_pod)
	tutorial_pod.go_in_cryopod(tutorial_mob, TRUE, FALSE)


/datum/tutorial/marine/basic/init_map()
	var/obj/structure/machinery/cryopod/tutorial/tutorial_pod = new(bottom_left_corner)
	add_to_tracking_atoms(tutorial_pod)
	var/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial/food_vendor = new(loc_from_corner(0, 2))
	add_to_tracking_atoms(food_vendor)
	var/obj/structure/machinery/cm_vending/clothing/tutorial/clothing_vendor = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(clothing_vendor)
	var/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial/gun_vendor = new(loc_from_corner(0, 5))
	add_to_tracking_atoms(gun_vendor)
