#define SHOUT_ORDERS (1<<0)
#define TOGGLES_SHOUT_ORDERS_DEFAULT (SHOUT_ORDERS)

/datum/preferences
	var/shout_orders = TOGGLES_SHOUT_ORDERS_DEFAULT

/client/proc/toggle_shout_orders()
	set name = "Toggle Shout Orders"
	set category = "Preferences.Chat"

	prefs.shout_orders ^= SHOUT_ORDERS
	prefs.save_preferences()
	to_chat(usr, "Теперь вы [prefs.shout_orders & SHOUT_ORDERS ? "" : "не "]будете выкрикивать фразы при отдавании приказа.")

/datum/action/human_action/issue_order/action_activate()
	. = ..()

	if(owner.stat != CONSCIOUS)
		return

	var/client/client = owner.client
	if(!client.prefs.shout_orders)
		return

	var/message
	switch(order_type)
		if(COMMAND_ORDER_MOVE)
			message = pick("ДВИГАЕМ БУЛКАМИ!", "ШЕВЕЛИМСЯ!", "ДВИГАЕМСЯ, ДВИГАЕМСЯ!", "ПОШЕЛ, ПОШЕЛ, ПОШЕЛ!", "ВПЕРЕД! БЫСТРЕЕ!", "ДВИГАЙ, ДВИГАЙ, ДВИГАЙ!", "БЕГОМ, МАРШ!", "ШИРЕ ШАГ!", "ШЕВЕЛИМ ЛАСТАМИ!", "ШЕВЕЛИМ НОЖКАМИ, ДАМЫ!")
		if(COMMAND_ORDER_HOLD)
			message = pick("ДЕРЖИМ УДАР!", "БЕРЕЧЬ ГОЛОВУ!", "ПРИГОТОВИТЬСЯ К СТОЛКНОВЕНИЮ!", "ДЕРЖАТЬСЯ!", "ДЕРЖИТЕ СТРОЙ!", "НЕ СДАВАТЬСЯ!", "ПРИГОТОВИТЬСЯ К УДАРУ!")
		if(COMMAND_ORDER_FOCUS)
			message = pick("НЕ ПАЛИТЕ ПО СВОИМ!", "СОСРЕДОТОЧИТЬ ОГОНЬ!", "СТРЕЛЬБА НА ПОРАЖЕНИЕ!", "ПРИМКНУТЬ ШТЫКИ!", "ОГОНЬ ПО ГОТОВНОСТИ!", "ОРУЖИЕ НА ИЗГОТОВКУ!", "ЦЕЛЬСЯ!", "ВНИМАНИЕ!", "ОГОНЬ!", "ГОТОВЬТЕСЬ К БОЮ!", "НАКОРМИТЕ ИХ СВИНЦОМ!", "УНИЧТОЖИТЬ ЦЕЛЬ!")

	if(message)
		owner.say(message)

#undef SHOUT_ORDERS
#undef TOGGLES_SHOUT_ORDERS_DEFAULT
