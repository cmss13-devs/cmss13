// ==========================================
// ======== Действия с инструментами ========

/obj/structure/bed/chair/stroller/attackby(obj/item/O as obj, mob/user as mob)
	if(user.action_busy)
		to_chat(user, SPAN_WARNING("Вы уже чем-то заняты!"))
		return

	// Присоединение
	if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		to_chat(user, SPAN_WARNING("Коляску можно [connected ? "от" : "при"]соединить только через мотоцикл."))
		return FALSE

	// Ремонт корпуса
	if (iswelder(O))
		return handle_welder(O, user)

	// Ремонт шин
	//if (iswire())
	. = ..()

/obj/structure/bed/chair/stroller/proc/handle_welder(obj/item/O, mob/user)
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
		to_chat(user, SPAN_NOTICE("Вы сварили корпус [src.name] с помощью [O]. Сварено на [procent]%"))
		health = min(health + welder_health, maxhealth)
		playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
	else
		to_chat(user, SPAN_WARNING("В [O] не хватает топлива!"))
		return FALSE
	return TRUE
