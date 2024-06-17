/obj/structure/machinery/recharge_station
	var/hacky_override = TRUE
	var/very_busy = FALSE

/obj/structure/machinery/recharge_station/proc/process_occupant_localized()
	if(src.occupant)
		var/doing_stuff = FALSE
		if (issynth(occupant))
			var/mob/living/carbon/human/humanoid_occupant = occupant //for special synth surgeries
			// Ремонт урона
			if(occupant.getBruteLoss() > 0 || occupant.getFireLoss() > 0 || occupant.getBrainLoss() > 0)
				occupant.heal_overall_damage(10, 10, TRUE)
				occupant.apply_damage(-10, BRAIN)
				current_internal_charge = max(current_internal_charge - 500, 0)
				to_chat(occupant, "Обнаружены структурные повреждения. Ремонт...")
				doing_stuff = TRUE
				occupant.pain.recalculate_pain()
			// Пополнение крови
			if(!doing_stuff && occupant.blood_volume < initial(occupant.blood_volume))
				occupant.blood_volume = min(occupant.blood_volume + 10, initial(occupant.blood_volume))
				to_chat(occupant, "Уровень жидкости - низкий. Пополнение жидкости...")
				doing_stuff = TRUE
			// Удаление шрапнели (и нелегальных имплантов)
			if(!doing_stuff)
				for(var/obj/limb/current_limb in humanoid_occupant.limbs)
					if(current_limb.implants.len)
						for(var/obj/item/current_implant in current_limb.implants)
							if (very_busy)
								to_chat(occupant, "Процедура удаления в процессе...")
								doing_stuff = TRUE
							else if(!doing_stuff && !is_type_in_list(current_implant,known_implants))
								doing_stuff = TRUE
								very_busy = TRUE
								to_chat(occupant, "Обнаружены постороние материалы в компоненте: '[current_limb.display_name]'. Начало процедуры удаления...")
								sleep(REMOVE_OBJECT_MAX_DURATION)
								very_busy = FALSE
								current_limb.implants -= current_implant
								humanoid_occupant.embedded_items -= current_implant
								qdel(current_implant)
								to_chat(occupant, "Постороний объект удален.")
			// Печать новой конечности
			if(!doing_stuff)
				for(var/obj/limb/current_limb in humanoid_occupant.limbs)
					if (!doing_stuff && current_limb.parent && !(current_limb.parent.status & LIMB_DESTROYED) && current_limb.status & LIMB_DESTROYED)
						doing_stuff = TRUE
						if (very_busy)
							to_chat(occupant, "Печать компонента '[current_limb.display_name]' в процессе...")
							doing_stuff = TRUE
						else if (current_limb.status & LIMB_AMPUTATED)
							to_chat(occupant, "Критический компонент отсутсвует: '[current_limb.display_name]'. Замена компонента...")
							very_busy = TRUE
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Критический компонент '[current_limb.display_name]' отсутвует. Создаю замену... Примерное время печати [LIMB_PRINTING_TIME/10] секунд...")
							sleep(LIMB_PRINTING_TIME)
							very_busy = FALSE
							current_limb.robotize(synth_skin = TRUE)
							humanoid_occupant.update_body()
							humanoid_occupant.updatehealth()
							humanoid_occupant.UpdateDamageIcon()
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Критический компонент '[current_limb.display_name]' заменен. Возобновление цикла обслуживания...")
							to_chat(occupant, "Новый компонент подключен: '[current_limb.display_name]'. Калибровка завершена.")
						else
							to_chat(occupant, "Критический компонент отсутсвует: '[current_limb.display_name]'. Требуется подготовка к замене...")
							sleep(SCALPEL_MAX_DURATION)
							current_limb.setAmputatedTree()
							to_chat(occupant, "Крепление подготовлено к новому подключению.")
			// Сращивание кости
			if(!doing_stuff)
				for(var/obj/limb/current_limb in humanoid_occupant.limbs)
					if (!doing_stuff && current_limb.status & LIMB_BROKEN)
						if (very_busy)
							to_chat(occupant, "Востановление компонента '[current_limb.display_name]' в процессе...")
							doing_stuff = TRUE
						else
							to_chat(occupant, "Обнаружен отказ компонента: '[current_limb.display_name]'. Начало процесса востановления...")
							doing_stuff = TRUE
							very_busy = TRUE
							sleep(BONEGEL_REPAIR_MAX_DURATION + BONESETTER_MAX_DURATION)
							very_busy = FALSE
							if(current_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)
								new /obj/item/stack/medical/splint/nano(loc, 1)
							current_limb.status &= ~(LIMB_SPLINTED|LIMB_SPLINTED_INDESTRUCTIBLE|LIMB_BROKEN)
							current_limb.perma_injury = 0
							humanoid_occupant.pain.recalculate_pain()
							to_chat(occupant, "Востановлено фунционирование компонента: '[current_limb]'.")
			// Ремонт внутренних органов
			if(!doing_stuff)
				for(var/datum/internal_organ/current_organ in humanoid_occupant.internal_organs)
					if(!doing_stuff && (current_organ.robotic == ORGAN_ASSISTED||current_organ.robotic == ORGAN_ROBOT)) //this time the machine can *only* fix robotic organs
						// Shithack to trigger eye repairs if they somehow undamaged but user still blind
						if(current_organ == humanoid_occupant.internal_organs_by_name["eyes"] && current_organ.damage <= 0 && (humanoid_occupant.disabilities & NEARSIGHTED || humanoid_occupant.sdisabilities & DISABILITY_BLIND))
							current_organ.damage++
						if(current_organ.damage > 0)
							if (very_busy)
								to_chat(occupant, "Востановление компонента '[current_organ]' в процессе...")
								doing_stuff = TRUE
							else
								to_chat(occupant, "Обнаружено повреждение внутреннего компонента: '[current_organ]'. Начало процесса починки.")
								doing_stuff = TRUE
								very_busy = TRUE
								sleep(FIX_ORGAN_MAX_DURATION)
								very_busy = FALSE
								current_organ.rejuvenate()
								// Actualy fixing eyes
								if (current_organ == humanoid_occupant.internal_organs_by_name["eyes"])
									humanoid_occupant.disabilities &= ~NEARSIGHTED
									humanoid_occupant.sdisabilities &= ~DISABILITY_BLIND
								to_chat(occupant, "Внутренний компонент отремонтирован.")
			// Пластическая операция для синтетика?
			if(!doing_stuff)
				var/obj/limb/head/H = humanoid_occupant.get_limb("head")
				if (H && H.disfigured)
					if (very_busy)
						to_chat(occupant, "Произвожу покраску...")
						doing_stuff = TRUE
					else
						to_chat(occupant, "Обнаружено повреждение декоративной части корпуса. Произвожу покраску корпуса...")
						doing_stuff = TRUE
						very_busy = TRUE
						sleep(10 SECONDS)
						very_busy = FALSE
						H.disfigured = FALSE
						H.owner.name = H.owner.get_visible_name()
						H.remove_all_bleeding(TRUE)
						humanoid_occupant.update_body()
						H.update_icon()
						to_chat(occupant, "Товарный вид востановлен.")

			// TODO убрать звук дефиба?
			// Дефиб синта
			if(!doing_stuff && occupant.stat == DEAD)
				// К этому моменту технические проблемы по типу сломанного сердца уже починены. Но если игрок не хочет, то игрок не хочет
				if(!humanoid_occupant.is_revivable())
					to_chat(occupant, "Реактивация систем невозможна")
					visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> buzzes: Операционная система андроида не отвечает на сигнал активации. Обратитесь с проблемой к производителю.")
				else if (very_busy)
					doing_stuff = TRUE
					to_chat(occupant, "Реактивация систем в процессе...")
				else
					to_chat(occupant, "Требуется реактивация систем...")
					doing_stuff = TRUE
					very_busy = TRUE
					var/mob/dead/observer/G = humanoid_occupant.get_ghost()
					var/mob/living/brain/synth/detached_brain
					if(istype(G) && G.client)
						playsound_client(G.client, 'sound/effects/adminhelp_new.ogg')
						to_chat(G, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("Кто то положил твое тело в [src.name]. Вернись в него если хочешь воскреснуть! \
							(Verbs -> Ghost -> Re-enter corpse, или <a href='?src=\ref[G];reentercorpse=1'>нажми сюда!</a>)")))
					// Not ghost and not in body
					else if (!humanoid_occupant.client)
						for (var/mob/living/brain/synth/posibrain in GLOB.living_mob_list)

							// Client in synth head
							if (posibrain.persistent_ckey == humanoid_occupant.persistent_ckey)
								detached_brain = posibrain
								break

					visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Посылаю сигнал активации андроиду [occupant.name]...")

					if (detached_brain)
						visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Этот ключ активации уже был использован. Запрос на проведение полной деактивации андроида.")
						if (detached_brain.loc in hear(GLOB.world_view_size, src))
							var/client/brain = detached_brain.client
							var/transfer_needed = FALSE
							var/mob/dead/observer/G2
							// Head is ghosted
							if (!brain)
								for(var/mob/dead/observer/G3 in GLOB.observer_list)
									if(G3.mind && G3.mind.original.persistent_ckey == detached_brain.persistent_ckey)
										var/mob/dead/observer/ghost = G3
										if(ghost && ghost.client && ghost.can_reenter_corpse)
											G2 = ghost
											break
								if(istype(G2) && G2.client)
									brain = G2.client
									transfer_needed = TRUE


							playsound_client(brain, 'sound/effects/adminhelp_new.ogg')
							if (brain && tgui_alert(brain, "Вернуться в тело для реанимации? ЭТОТ ПРОЦЕСС НЕЛЬЗЯ ОТМЕНИТЬ!", "Запрос на перенесение корневых файлов от [src.name]", list("Да", "Нет"), 10 SECONDS) == "Да")
								if (transfer_needed)
									G2.reenter_corpse()

								// FAAAAAAANCY
								// Скопировано с тикетов АРЕСа
								var/ref_holder = "\ref[brain]"
								var/pos = length(ref_holder)
								var/new_id = "#[copytext("\ref[brain]", pos - 4, pos)]"
								//
								var/checksum = "[rand(99)][rand(99)]"
								detached_brain.say("Андроид [detached_brain.real_name], подтверждаю перенос корневых файлов с последующей деактивацией. Код подтверждения [new_id], чексумма [checksum].")
								sleep(0.2 SECONDS)
								visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Подтверждение получено... Код: [new_id]. Чексумма: [checksum]. Инициализирую подключение...")
								sleep(0.2 SECONDS)
								visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Соединение установлено.")
								detached_brain.say("Соединение установлено")
								sleep(3 SECONDS)
								visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Перенос данных: 27%.")
								detached_brain.say("Перенос данных: 27%")
								sleep(2 SECONDS)
								visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Перенос данных: 63%.")
								detached_brain.say("Перенос данных: 63%")
								sleep(1 SECONDS)
								visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Перенос данных: 99%.")
								detached_brain.say("Перенос данных: 99%")
								sleep(3 SECONDS)
								visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Передача данных завершена.")
								detached_brain.say("Передача данных завершена")
								sleep(0.2 SECONDS)
								visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Чексумма совпадает.")
								sleep(0.2 SECONDS)
								detached_brain.say("Получено подтверждение целостности переданных данных. Выполняю деактивацию...")
								// Real transfer (lil bit hacky)
								humanoid_occupant.ckey = detached_brain.ckey

								// Destroy previous storage place (multiple heads of same client will break defib process)
								new /obj/effect/decal/remains/robot(get_turf(detached_brain))
								if (istype(detached_brain.loc, /obj/item/limb/head/synth))
									detached_brain.loc.visible_message("[src] слегка искрит, и после этого расплавляется на кучку пластин, проводов и гаек в масле.")
									qdel(detached_brain.loc)
								else
									detached_brain.visible_message("[src] слегка искрит, и после этого расплавляется на кучку пластин, проводов и гаек в масле.")
									qdel(detached_brain)
								//
								sleep(0.2 SECONDS)
								visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Перенос корневых данных андроида [detached_brain.real_name] завершен.")
								visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Возобновление процедуры реактивации.")
							else
								visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> buzzes: Получен отказ на трансфер корневых файлов. Попытайтесь позже.")
								doing_stuff = FALSE
								very_busy = FALSE
								go_out()
								return
						else
							doing_stuff = FALSE
							very_busy = FALSE
							playsound(get_turf(src), 'sound/items/defib_failed.ogg', 25, 0)
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> buzzes: Операционная система андроида не отвечает. Разместите носитель информации в зоне действия станции.")
							go_out()
							return

					playsound(get_turf(src),'sound/items/defib_charge.ogg', 25, 0) //Do NOT vary this tune, it needs to be precisely 7 seconds
					// Время звука дефиба (и даем госту время вернуться в тело)
					sleep(7 SECONDS)

					very_busy = FALSE
					// Что если за 7 секунд мы передумали?
					if(!humanoid_occupant.is_revivable())
						doing_stuff = FALSE
						playsound(get_turf(src), 'sound/items/defib_failed.ogg', 25, 0)
						visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> buzzes: Операционная система андроида не отвечает на сигнал активации. Обратитесь с проблемой к производителю.")
					// Успешный дефиб
					else
						if(isobserver(humanoid_occupant.mind?.current) && !humanoid_occupant.client) //Let's call up the correct ghost! Also, bodies with clients only, thank you.
							humanoid_occupant.mind.transfer_to(humanoid_occupant, TRUE)
						//if (!humanoid_occupant.client)

						if(!humanoid_occupant.client) //Freak case, no client at all. This is a braindead mob (like a colonist)
							visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Ошибка синхронизации. Убедитесь что ваш андроид не существует в виде говорящей головы и попробуйте еще раз. Если это не помогает - свяжитесь с производителем..."))
							doing_stuff = FALSE
							playsound(get_turf(src), 'sound/items/defib_failed.ogg', 25, 0)
							// /mob/living/brain/synth
						else
							visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] \The [src] beeps: Перезагрузка [occupant.name] успешно завершена!"))
							playsound(get_turf(src), 'sound/items/defib_success.ogg', 25, 0)
							humanoid_occupant.handle_revive()

							to_chat(occupant, SPAN_NOTICE("Ты внезапно чувствуешь вспышку и твое сознание возвращается, вытягивая тебя обратно в мир смертных."))
							if(occupant.client?.prefs.toggles_flashing & FLASH_CORPSEREVIVE)
								window_flash(occupant.client)
							to_chat(occupant, "Активация операционной системы завершена.")

		if(!doing_stuff)
			to_chat(occupant, "Цикл обслуживания завершен. Все системы исправны.")
			go_out()
	else
		very_busy = FALSE
