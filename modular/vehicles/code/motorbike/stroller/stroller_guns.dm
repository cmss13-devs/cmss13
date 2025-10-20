/obj/structure/bed/chair/stroller
	var/obj/structure/machinery/m56d_hmg/mounted
	var/allowed_types_to_mount = list(
		/obj/item/device/m56d_gun,
		/obj/item/device/m2c_gun)
	var/allowed_types_to_reload = list(
		/obj/item/ammo_magazine/m56d,
		/obj/item/ammo_magazine/m2c)
	var/mounted_type
	var/mounted_time_to_assembly = 20 SECONDS	// Присоединение
	var/mounted_time_to_disassembly = 7 SECONDS	// Отсоединение

	var/mounted_div_shoot_degree = 1.5 // Уменьшаем градус стрельбы

// ==========================================
// ================ Пулеметы ================

/obj/structure/machinery/m56d_hmg/low
	// Стрельба
	shoot_degree = 65
	fire_delay = 0.4 SECONDS
	burst_fire_delay = 0.3 SECONDS
	autofire_slow_mult = 1.2

/obj/structure/machinery/m56d_hmg/auto/low
	// Стрельба
	shoot_degree = 45
	fire_delay = 0.2 SECONDS
	burst_fire_delay = 0.25 SECONDS
	cadeblockers_range = 0
	autofire_slow_mult = 1.2


// ==========================================
// ============== Безопасность ==============
// Убираем возможность убить байкера.

/obj/structure/machinery/m56d_hmg
	var/list/objects_for_permutated = list()	// Кого не стоит дополнительно задевать, кроме стрелка.

// Даем пуле понимание кого "не трогать"
/obj/structure/machinery/m56d_hmg/load_into_chamber()
	. = ..()
	if(!in_chamber)
		return .
	if(!length(objects_for_permutated))
		return .
	for(var/i in objects_for_permutated)
		in_chamber.permutated |= i

/obj/structure/bed/chair/stroller/proc/update_bike_permutated(only_mob = FALSE)
	if(!mounted)
		return
	if(!connected)
		return
	if(!only_mob)
		mounted.objects_for_permutated.Add(connected)
	if(!connected.buckled_mob)
		return
	mounted.objects_for_permutated.Add(connected.buckled_mob)

/obj/structure/bed/chair/stroller/proc/reset_bike_permutated(only_mob = FALSE)
	if(!mounted)
		return
	// Убираем возможность "задеть" байкера.
	if(!connected)
		mounted.objects_for_permutated = list()
		return
	if(!only_mob)
		mounted.objects_for_permutated.Remove(connected)
	if(!connected.buckled_mob)
		return
	mounted.objects_for_permutated.Remove(connected.buckled_mob)


// ==========================================
// ============== Взаимодействие =============

/obj/structure/bed/chair/stroller/get_examine_text(mob/user)
	. = ..()
	if(!mounted)
		return
	if(user != buckled_mob)
		. += SPAN_NOTICE("На [name] установлен [mounted.name].")
		return
	if(isxeno(user))
		. += SPAN_WARNING("Вы видите установленную огнепалку на этой железяке...")
		return
	. += SPAN_NOTICE("В [mounted.name] боекомплект [mounted.rounds]/[mounted.rounds_max]")

/obj/structure/bed/chair/stroller/attackby(obj/item/O as obj, mob/user as mob)
	if(!ishuman(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		return ..()

	// Установка пулеметов
	for(var/allowed_type in allowed_types_to_mount)
		if(istype(O, allowed_type))
			assembly(O, user)
			return TRUE

	if(!mounted)
		return ..()

	// Перезарядка
	for(var/allowed_type in allowed_types_to_reload)
		if(istype(O, allowed_type))
			reload(O, user)
			return TRUE

	// Разборка уже установленного объекта
	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER)) // Lets take it apart.
		return dissasemble(O, user)

	. = ..()

// Сборка
/obj/structure/bed/chair/stroller/proc/assembly(obj/item/O, mob/user)
	to_chat(user, "Вы устанавливаете [mounted] на коляску...")
	if(!do_after(user, mounted_time_to_assembly * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return FALSE

	var/rounds_temp = 0

	if(istype(O, /obj/item/device/m56d_gun))
		//var/obj/structure/machinery/m56d_post/post = new(src)
		var/obj/item/device/m56d_gun/D = O
		if(D.has_mount)
			to_chat(user, SPAN_NOTICE("Вы отсоединили станок от [D.name]."))
			new /obj/item/device/m56d_post(user.loc)
		var/obj/structure/machinery/m56d_hmg/low/G = new(src)
		mounted = G
		mounted_type = D.type
		rounds_temp = D.rounds

	else if(istype(O, /obj/item/device/m2c_gun))
		var/obj/item/device/m2c_gun/D = O
		var/obj/structure/machinery/m56d_hmg/auto/low/G = new(src)	// Да, это тип M2C
		mounted = G
		mounted_type = D.type
		rounds_temp = D.rounds

	if(mounted)
		mounted.setDir(dir) // Make sure we face the right direction
		mounted.rounds = rounds_temp
		mounted.health = O.health // retain damage
		mounted.anchored = TRUE
		O.transfer_label_component(mounted)
		to_chat(user, SPAN_NOTICE("Вы установили [mounted.name] на коляску."))
		update_overlay()
		update_mob_gun_signal() // вдруг уже кто-то сидит
		update_bike_permutated() // Не хотим чтобы он застрелил того кто сидит
		QDEL_NULL(O)

// Разборка
/obj/structure/bed/chair/stroller/proc/dissasemble(obj/item/O, mob/user)
	if(!mounted)
		return FALSE
	if(mounted.locked)
		to_chat(user, "Установленное [mounted.name] невозможно отсоединить...")
		return FALSE
	to_chat(user, "Вы отсоединяете [mounted.name] на коляске...")
	if(!do_after(user, mounted_time_to_disassembly * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(user, SPAN_DANGER("Вы прекратили отсоединение [mounted.name] на коляске."))
		return FALSE
	user.visible_message(SPAN_NOTICE("[user] отсоединил [mounted.name] от [src.name]!"), SPAN_NOTICE("Вы отсоединили [mounted.name] от [src.name]!"))
	playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)

	var/obj/item/device/m56d_gun/HMG = new mounted_type(loc)
	mounted.transfer_label_component(HMG)
	HMG.rounds = mounted.rounds
	HMG.health = mounted.health
	HMG.update_icon()

	update_mob_gun_signal(TRUE) // вдруг уже кто-то сидит
	QDEL_NULL(mounted)
	update_overlay()
	update_buckle_mob()
	return TRUE

// Перезарядка
/obj/structure/bed/chair/stroller/proc/reload(obj/item/O, mob/user)
	if(!skillcheck(user, SKILL_FIREARMS, SKILL_FIREARMS_TRAINED))
		to_chat(user, SPAN_WARNING("Вы недостаточно натренированы чтобы работать с этим калибром!"))
		return
	// Тыкаем магазином в них же и совершаем "перезарядку"
	// Он должен тыканьем заполненного магазина менять магазин внутри.
	mounted.attackby(O, user)
	update_overlay()


// ==========================================
// ================ Сигналы =================

#define COMSIG_MOB_MG_ENTER_VC "mob_vc_mg_enter"
#define COMSIG_MOB_MG_EXIT_VC "mob_vc_mg_exit"


// Стрельба
/obj/structure/bed/chair/stroller/proc/update_mob_gun_signal(force_reset = FALSE)
	if(!buckled_mob)
		return
	if(!ishuman_strict(buckled_mob))
		return	// Только люди могут стрелять
	// Перезапускаем сигналы и кнопки
	if(force_reset)
		remove_action(buckled_mob, /datum/action/human_action/mg_enter_vc)
		remove_action(buckled_mob, /datum/action/human_action/mg_exit_vc)
		UnregisterSignal(buckled_mob, COMSIG_MOB_MG_ENTER_VC)
		UnregisterSignal(buckled_mob, COMSIG_MOB_MG_EXIT_VC)
		if(mounted) mounted.on_unset_interaction(buckled_mob)

	// Даем сигналы мобу, если прикручен пулемет и моб сидит и не мертв
	else if(mounted && !buckled_mob.stat)
		RegisterSignal(buckled_mob, COMSIG_MOB_MG_ENTER_VC, PROC_REF(on_set_gun_interaction))	// Теперь мы можем перезайти за пулемет
		RegisterSignal(buckled_mob, COMSIG_MOB_MG_EXIT_VC, PROC_REF(on_unset_gun_interaction))
		give_action(buckled_mob, /datum/action/human_action/mg_enter_vc)

/obj/structure/bed/chair/stroller/proc/on_set_gun_interaction()
	SIGNAL_HANDLER
	mounted.on_set_interaction_vc(buckled_mob)

/obj/structure/bed/chair/stroller/proc/on_unset_gun_interaction()
	SIGNAL_HANDLER
	mounted.on_unset_interaction_vc(buckled_mob)

/obj/structure/bed/chair/stroller/proc/update_gun_dir()
	mounted.setDir(dir)

/obj/structure/machinery/m56d_hmg/proc/on_set_interaction_vc(mob/user)
	//ADD_TRAIT(user, TRAIT_IMMOBILIZED, INTERACTION_TRAIT)
	give_action(user, /datum/action/human_action/mg_exit_vc)
	remove_action(user, /datum/action/human_action/mg_enter_vc)
	user.setDir(dir)
	user.reset_view(src)
	user.status_flags |= IMMOBILE_ACTION
	user.visible_message(SPAN_NOTICE("[user] mans [src]."), SPAN_NOTICE("You man [src], locked and loaded!"))

	RegisterSignal(user, list(COMSIG_MOB_RESISTED, COMSIG_MOB_DEATH, COMSIG_LIVING_SET_BODY_POSITION), PROC_REF(exit_interaction))
	RegisterSignal(user, COMSIG_MOB_MOUSEDOWN, PROC_REF(start_fire))
	RegisterSignal(user, COMSIG_MOB_MOUSEDRAG, PROC_REF(change_target))
	RegisterSignal(user, COMSIG_MOB_MOUSEUP, PROC_REF(stop_fire))

	operator = user
	update_mouse_pointer(operator, TRUE)
	flags_atom |= RELAY_CLICK

/obj/structure/machinery/m56d_hmg/proc/on_unset_interaction_vc(mob/user)
	//REMOVE_TRAIT(user, TRAIT_IMMOBILIZED, INTERACTION_TRAIT)
	give_action(user, /datum/action/human_action/mg_enter_vc)
	remove_action(user, /datum/action/human_action/mg_exit_vc)
	user.setDir(dir) //set the direction of the player to the direction the gun is facing
	user.reset_view(null)
	user.status_flags &= ~IMMOBILE_ACTION
	user.visible_message(SPAN_NOTICE("[user] lets go of [src]."), SPAN_NOTICE("You let go of [src], letting the gun rest."))
	user.remove_temp_pass_flags(PASS_MOB_THRU) // this is necessary because being knocked over while using the gun makes you incorporeal

	SEND_SIGNAL(src, COMSIG_GUN_INTERRUPT_FIRE)
	UnregisterSignal(user, list(
		COMSIG_MOB_RESISTED,
		COMSIG_MOB_DEATH,
		COMSIG_LIVING_SET_BODY_POSITION,
		COMSIG_MOB_MOUSEUP,
		COMSIG_MOB_MOUSEDOWN,
		COMSIG_MOB_MOUSEDRAG,
	))

	if(operator == user) //We have no operator now
		operator = null
	flags_atom &= ~RELAY_CLICK

// ================ Actions =================
/datum/action/human_action/mg_enter_vc
	name = "Использовать орудие"
	action_icon_state = "frontline_toggle_on"

/datum/action/human_action/mg_enter_vc/action_activate()
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/human_user = owner
	SEND_SIGNAL(human_user, COMSIG_MOB_MG_ENTER_VC)


/datum/action/human_action/mg_exit_vc
	name = "Отставить орудие"
	action_icon_state = "cancel_view"

/datum/action/human_action/mg_exit_vc/action_activate()
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/human_user = owner
	SEND_SIGNAL(human_user, COMSIG_MOB_MG_EXIT_VC)



#undef COMSIG_MOB_MG_EXIT


// ==========================================
