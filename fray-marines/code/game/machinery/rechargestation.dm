/obj/structure/machinery/recharge_station
	var/hacky_override = TRUE

/obj/structure/machinery/recharge_station/proc/process_occupant_localized()
	if(src.occupant)
		var/doing_stuff = FALSE
		if (isrobot(occupant))
			var/mob/living/silicon/robot/R = occupant
			if(R.module)
				R.module.respawn_consumable(R)
			if(!R.cell)
				return
			if(!R.cell.fully_charged())
				var/diff = min(R.cell.maxcharge - R.cell.charge, 500) // 500 charge / tick is about 2% every 3 seconds
				diff = min(diff, current_internal_charge) // No over-discharging
				R.cell.give(diff)
				current_internal_charge = max(current_internal_charge - diff, 0)
				to_chat(occupant, "Зарядка...")
				doing_stuff = TRUE
			else
				update_use_power(USE_POWER_IDLE)
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
							if(!doing_stuff && !is_type_in_list(current_implant,known_implants))
								doing_stuff = TRUE
								to_chat(occupant, "Обнаружены постороние материалы в компоненте: '[current_limb.display_name]'. Начало процедуры удаления...")
								sleep(REMOVE_OBJECT_MAX_DURATION)
								current_limb.implants -= current_implant
								humanoid_occupant.embedded_items -= current_implant
								qdel(current_implant)
								to_chat(occupant, "Постороний объект удален.")
			// Сращивание кости
			if(!doing_stuff)
				for(var/obj/limb/current_limb in humanoid_occupant.limbs)
					if (!doing_stuff && current_limb.status & LIMB_BROKEN)
						to_chat(occupant, "Обнаружен отказ компонента: '[current_limb.display_name]'. Начало процесса востановления...")
						doing_stuff = TRUE
						sleep(BONEGEL_REPAIR_MAX_DURATION + BONESETTER_MAX_DURATION)
						if(current_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)
							new /obj/item/stack/medical/splint/nano(loc, 1)
						current_limb.status &= ~(LIMB_SPLINTED|LIMB_SPLINTED_INDESTRUCTIBLE|LIMB_BROKEN)
						current_limb.perma_injury = 0
						humanoid_occupant.pain.recalculate_pain()
						to_chat(occupant, "Востановлено фунционирование компонента: '[current_limb]'.")
			// Печать новой конечности
			if(!doing_stuff)
				for(var/obj/limb/current_limb in humanoid_occupant.limbs)
					if (!doing_stuff && current_limb.parent && !(current_limb.parent.status & LIMB_DESTROYED) && current_limb.status & LIMB_DESTROYED)
						doing_stuff = TRUE
						if (current_limb.status & LIMB_AMPUTATED)
							to_chat(occupant, "Критический компонент отсутсвует: '[current_limb.display_name]'. Печать запасной части...")
							sleep(LIMB_PRINTING_TIME)
							current_limb.robotize(synth_skin = TRUE)
							humanoid_occupant.update_body()
							humanoid_occupant.updatehealth()
							humanoid_occupant.UpdateDamageIcon()
							to_chat(occupant, "Новый компонент подключен: '[current_limb.display_name]'. Калибровка завершена.")
						else
							to_chat(occupant, "Критический компонент отсутсвует: '[current_limb.display_name]'. Требуется подготовка к замене...")
							sleep(SCALPEL_MAX_DURATION)
							current_limb.setAmputatedTree()
							to_chat(occupant, "Крепление подготовлено к новому подключению.")

			// Ремонт внутренних органов
			if(!doing_stuff)
				for(var/datum/internal_organ/current_organ in humanoid_occupant.internal_organs)
					if(!doing_stuff && (current_organ.robotic == ORGAN_ASSISTED||current_organ.robotic == ORGAN_ROBOT)) //this time the machine can *only* fix robotic organs
						if(current_organ.damage > 0)
							to_chat(occupant, "Обнаружено повреждение внутреннего компонента: '[current_organ]'. Начало процесса починки.")
							doing_stuff = TRUE
							sleep(FIX_ORGAN_MAX_DURATION)
							current_organ.rejuvenate()
							to_chat(occupant, "Внутренний компонент отремонтирован.")
			// Пластическая операция для синтетика?
			if(!doing_stuff)
				var/obj/limb/head/H = humanoid_occupant.get_limb("head")
				if (H && H.disfigured)
					to_chat(occupant, "Обнаружено повреждение декоративной части корпуса. Произвожу покраску корпуса...")
					doing_stuff = TRUE
					sleep(10 SECONDS)
					H.remove_all_bleeding(TRUE)
					H.disfigured = FALSE
					H.owner.name = H.owner.get_visible_name()
					to_chat(occupant, "Товарный вид востановлен.")

			// TODO убрать звук дефиба?
			// Дефиб синта
			if(!doing_stuff && occupant.stat == DEAD)
				// К этому моменту технические проблемы по типу сломанного сердца уже починены. Но если игрок не хочет, то игрок не хочет
				if(!humanoid_occupant.is_revivable())
					visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> buzzes: Операционная система андроида не отвечает на сигнал активации. Обратитесь с проблемой к производителю.")
				else
					var/mob/dead/observer/G = humanoid_occupant.get_ghost()
					if(istype(G) && G.client)
						doing_stuff = TRUE
						playsound_client(G.client, 'sound/effects/adminhelp_new.ogg')
						to_chat(G, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("Кто то положил твое тело в [src.name]. Вернись в него если хочешь воскреснуть! \
						(Verbs -> Ghost -> Re-enter corpse, или <a href='?src=\ref[G];reentercorpse=1'>нажми сюда!</a>)")))

						visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> states: Посылаю сигнал активации андроиду [occupant.name]...")
						playsound(get_turf(src),'sound/items/defib_charge.ogg', 25, 0) //Do NOT vary this tune, it needs to be precisely 7 seconds
						// Время звука дефиба (и даем госту время вернуться в тело)
						sleep(7 SECONDS)

						// Что если за 7 секунд мы передумали?
						if(!humanoid_occupant.is_revivable())
							doing_stuff = FALSE
							playsound(get_turf(src), 'sound/items/defib_failed.ogg', 25, 0)
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> buzzes: Операционная система андроида не отвечает на сигнал активации. Обратитесь с проблемой к производителю.")
						// Успешный дефиб
						else
							if(!humanoid_occupant.client) //Freak case, no client at all. This is a braindead mob (like a colonist)
								visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Корневые файлы повреждены, пытаюсь востановить бэкап..."))
							if(isobserver(humanoid_occupant.mind?.current) && !humanoid_occupant.client) //Let's call up the correct ghost! Also, bodies with clients only, thank you.
								humanoid_occupant.mind.transfer_to(humanoid_occupant, TRUE)

							visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] \The [src] beeps: Перезагрузка [occupant.name] успешно завершена!"))
							playsound(get_turf(src), 'sound/items/defib_success.ogg', 25, 0)
							humanoid_occupant.handle_revive()

							to_chat(occupant, SPAN_NOTICE("Ты внезапно чувствуешь вспышку и твое сознание возвращается, вытягивая тебя обратно в мир смертных."))
							if(occupant.client?.prefs.toggles_flashing & FLASH_CORPSEREVIVE)
								window_flash(occupant.client)
							to_chat(occupant, "Активация операционной системы завершена.")
					else
						visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> buzzes: Операционная система андроида не отвечает на сигнал активации. Обратитесь с проблемой к производителю.")

		if(!doing_stuff)
			to_chat(occupant, "Цикл обслуживания завершен. Все системы исправны.")
			go_out()
