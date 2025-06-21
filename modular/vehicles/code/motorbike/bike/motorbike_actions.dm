// ==========================================
// ======== Действия с инструментами ========

/obj/vehicle/motorbike/attackby(obj/item/O as obj, mob/user as mob)
	if(user.action_busy)
		to_chat(user, SPAN_WARNING("Вы уже чем-то заняты!"))
		return

	// Присоединение
	if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		return handle_wrench(O, user)

	// Ремонт корпуса
	if (iswelder(O))
		return handle_welder(O, user)

	// Мытье от крови мылом
	if (istype(O, /obj/item/tool/soap))
		return handle_wash(O, user)

	// Мытье от крови шваброй
	if (istype(O, /obj/item/tool/mop))
		if(O.reagents.total_volume < 1)
			to_chat(user, SPAN_NOTICE("Слишком сухая швабра!"))
			return FALSE
		return handle_wash(O, user)

	// Ремонт шин
	//if (iswire())
	. = ..()

/obj/vehicle/motorbike/proc/handle_wash(obj/item/O, mob/user)
	if(!blooded)
		to_chat(user, SPAN_NOTICE("Вы не можете вычистить то, чего нет."))
		return FALSE
	var/mob/living/L = user
	L.animation_attack_on(src)
	to_chat(user, SPAN_NOTICE("Вы начали мытье [src.name] с помощью [O]."))
	if(!do_after(user, 10 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("Вы отменили мытье [src.name] с помощью [O]."))
		return FALSE
	to_chat(user, SPAN_NOTICE("Вы вычистили следы крови с [src.name] с помощью [O]."))
	L.animation_attack_on(src)
	blooded = FALSE
	update_overlay()
	return TRUE

/obj/vehicle/motorbike/proc/handle_wrench(obj/item/O, mob/user)
	var/mob/living/L = user
	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	L.animation_attack_on(src)
	to_chat(user, SPAN_NOTICE("Вы начинаете крутить крепежи..."))
	if(!do_after(user, wrench_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("Крутка крипежей прервана."))
		return FALSE
	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	L.animation_attack_on(src)
	if(stroller)
		disconnect()
	else
		if(!try_connect(user))
			return FALSE
	to_chat(user, SPAN_NOTICE("Вы [anchored ? "присоединили" : "отсоединили"] коляску."))
	return TRUE

/obj/vehicle/motorbike/proc/handle_welder(obj/item/O, mob/user)
	if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
		to_chat(user, SPAN_WARNING("[O] недостаточен для ремонта корпуса!"))
		return FALSE
	if(health >= maxhealth)
		to_chat(user, SPAN_NOTICE("Корпус [src.name] в починке не нуждается!"))
		return TRUE
	var/obj/item/tool/weldingtool/WT = O
	if(WT.remove_fuel(1, user))
		if(!do_after(user, welder_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE("Вы прервали сварку корпуса [src.name] с помощью [O]."))
			return FALSE
		if(!src || !WT.isOn())
			to_chat(user, SPAN_NOTICE("Сварка корпуса [src.name] прервана из-за непригодных обстоятельств."))
			return FALSE
		var/procent = round((health / maxhealth) * 100)
		if(lighting_holder && !lighting_holder.light)
			lighting_holder.set_light_on(TRUE)
			lighting_holder.set_light_range(vehicle_light_range)
		to_chat(user, SPAN_NOTICE("Вы сварили корпус [src.name] с помощью [O]. Сварено на [procent]%"))
		health = min(health + welder_health, maxhealth)
		playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
	else
		to_chat(user, SPAN_WARNING("В [O] не хватает топлива!"))
		return FALSE
	return TRUE
