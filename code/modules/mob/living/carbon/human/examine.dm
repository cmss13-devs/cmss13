/mob/living/carbon/human/get_examine_text(mob/user)
	if(HAS_TRAIT(src, TRAIT_SIMPLE_DESC))
		return list(desc)

	if(user.sdisabilities & DISABILITY_BLIND || user.blinded || user.stat==UNCONSCIOUS)
		return list(SPAN_NOTICE("Там что-то есть, но вы не можете разглядеть."))

	var/mob/dead/observer/observer
	if(isobserver(user))
		observer = user

	if(isxeno(user))
		var/msg = "<span class='info'>Это " // SS220 EDIT ADDICTION

		if(icon)
			msg += "[icon2html(icon, user)] "
		msg += SPAN_XENOWARNING("<EM>[declent_ru()]</EM>!<br>") // SS220 EDIT ADDICTION

		if(species && species.flags & IS_SYNTHETIC)
			msg += SPAN_XENOWARNING("Вы чувствуете, что это существо неорганическое.<br>") // SS220 EDIT ADDICTION

		if(status_flags & XENO_HOST)
			msg += SPAN_XENOWARNING("Это существо оплодотворено.<br>") // SS220 EDIT ADDICTION
		else if(chestburst == 2)
			msg += SPAN_XENOWARNING("Из этого существа вырвался грудолом.<br>") // SS220 EDIT ADDICTION
		if(istype(wear_mask, /obj/item/clothing/mask/facehugger))
			msg += SPAN_XENOWARNING("К нему на лицо прицепился лицехват.<br>") // SS220 EDIT ADDICTION
		if(on_fire)
			msg += SPAN_XENOWARNING("Оно горит!<br>") // SS220 EDIT ADDICTION
		if(stat == DEAD)
			msg += SPAN_XENOWARNING("Вы чувствуете, что это существо мертво.<br>") // SS220 EDIT ADDICTION
		else if(stat || !client)
			msg += SPAN_XENOWARNING("Оно без сознания.<br>") // SS220 EDIT ADDICTION
		msg += "</span>"
		return list(msg)

	. = list()

	var/skipgloves = 0
	var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0
	var/skipears = 0
	var/skipeyes = 0
	var/skipface = 0

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipgloves = wear_suit.flags_inv_hide & HIDEGLOVES
		skipsuitstorage = wear_suit.flags_inv_hide & HIDESUITSTORAGE
		skipjumpsuit = wear_suit.flags_inv_hide & HIDEJUMPSUIT
		skipshoes = wear_suit.flags_inv_hide & HIDESHOES

	if(head)
		skipmask = head.flags_inv_hide & HIDEMASK
		skipeyes = head.flags_inv_hide & HIDEEYES
		skipears = head.flags_inv_hide & HIDEEARS
		skipface = head.flags_inv_hide & HIDEFACE

	if(wear_mask)
		skipface |= wear_mask.flags_inv_hide & HIDEFACE

	var/t_He = ru_p_they(TRUE) // SS220 EDIT ADDICTION
	var/t_he = ru_p_they() // SS220 EDIT ADDICTION
	var/t_His = ru_p_them(TRUE) // SS220 EDIT ADDICTION
	var/t_his = ru_p_them() // SS220 EDIT ADDICTION
	var/t_theirs = ru_p_theirs() // SS220 EDIT ADDICTION
	//var/t_has = "has" // SS220 EDIT ADDICTION
	//var/t_is = "is" // SS220 EDIT ADDICTION

	var/id_paygrade = ""
	var/obj/item/card/id/I = get_idcard()
	if(I)
		id_paygrade = I.paygrade
	var/rank_display = get_paygrades(id_paygrade, FALSE, gender)
	var/msg = "<span class='info'>Это " // SS220 EDIT ADDICTION

	if(!skipjumpsuit || !skipface) //big suits/masks/helmets make it hard to tell their gender
		if(icon)
			msg += "[icon2html(src, user)] "

	if(id_paygrade)
		msg += "<EM>[rank_display] </EM>"
	msg += SPAN_NOTICE("<EM>[declent_ru()]</EM>!<br>") // SS220 EDIT ADDICTION

	//uniform
	if(w_uniform && !skipjumpsuit)
		msg += SPAN_NOTICE("[t_He] носит [w_uniform.get_examine_location(src, user, WEAR_BODY, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//head
	if(head)
		msg += SPAN_NOTICE("[t_He] носит [head.get_examine_line(user)] [head.get_examine_location(src, user, WEAR_HEAD, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//suit/armor
	if(wear_suit)
		msg += SPAN_NOTICE("[t_He] носит [wear_suit.get_examine_location(src, user, WEAR_JACKET, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION
	//suit/armor storage
	if(s_store && !skipsuitstorage)
		msg += SPAN_NOTICE("[t_He] несёт [s_store.get_examine_line(user)] [s_store.get_examine_location(src, user, WEAR_J_STORE, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//back
	if(back)
		msg += SPAN_NOTICE("[t_He] носит [back.get_examine_line(user)] [back.get_examine_location(src, user, WEAR_BACK, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//left hand
	if(l_hand)
		msg += SPAN_NOTICE("[t_He] держит [l_hand.get_examine_line(user)] [l_hand.get_examine_location(src, user, WEAR_L_HAND, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//right hand
	if(r_hand)
		msg += SPAN_NOTICE("[t_He] держит [r_hand.get_examine_line(user)] [r_hand.get_examine_location(src, user, WEAR_R_HAND, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//gloves
	if(gloves && !skipgloves)
		msg += SPAN_NOTICE("[t_He] носит [gloves.get_examine_line(user)] [gloves.get_examine_location(src, user, WEAR_HANDS, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION
	else if(hands_blood_color)
		msg += SPAN_WARNING("У [t_theirs] [(hands_blood_color == COLOR_OIL) ? "замасленные" : "окровавленные"] руки!<br>") // SS220 EDIT ADDICTION

	//belt
	if(belt)
		msg += SPAN_NOTICE("[t_He] носит [belt.get_examine_line(user)] [belt.get_examine_location(src, user, WEAR_WAIST, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//shoes
	if(shoes && !skipshoes)
		msg += SPAN_NOTICE("[t_He] носит [shoes.get_examine_line(user)] [shoes.get_examine_location(src, user, WEAR_FEET, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION
	else if(feet_blood_color)
		msg += SPAN_WARNING("У [t_theirs] [(feet_blood_color == COLOR_OIL) ? "замасленные" : "окровавленные"] ноги!<br>") // SS220 EDIT ADDICTION

	//mask
	if(wear_mask && !skipmask)
		msg += SPAN_NOTICE("[t_He] носит [wear_mask.get_examine_line(user)] [wear_mask.get_examine_location(src, user, WEAR_FACE, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//eyes
	if(glasses && !skipeyes)
		msg += SPAN_NOTICE("[t_He] носит [glasses.get_examine_line(user)] [glasses.get_examine_location(src, user, WEAR_EYES, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//ears
	if(!skipears)
		if(wear_l_ear)
			msg += SPAN_NOTICE("[t_He] носит [wear_l_ear.get_examine_line(user)] [wear_l_ear.get_examine_location(src, user, WEAR_L_EAR, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION
		if(wear_r_ear)
			msg += SPAN_NOTICE("[t_He] носит [wear_r_ear.get_examine_line(user)] [wear_r_ear.get_examine_location(src, user, WEAR_R_EAR, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//ID
	if(wear_id)
		msg += SPAN_NOTICE("[t_He] носит [wear_id.get_examine_location(src, user, WEAR_ID, t_He, t_his, t_theirs)].<br>") // SS220 EDIT ADDICTION

	//Inform user if their weapon's IFF will or won't hit src, code by The32bitguy from PVE
	if(ishuman(user))
		var/mob/living/carbon/human/human_with_gun = user
		if(istype(human_with_gun.r_hand, /obj/item/weapon/gun) || istype(human_with_gun.l_hand, /obj/item/weapon/gun))
			var/obj/item/weapon/gun/gun_with_iff
			var/found_iff = FALSE
			if(istype(human_with_gun.get_active_hand(), /obj/item/weapon/gun))
				gun_with_iff = human_with_gun.get_active_hand()
			else
				gun_with_iff = human_with_gun.get_inactive_hand()
			for(var/obj/item/attachable/attachment in gun_with_iff.contents)
				if(locate(/datum/element/bullet_trait_iff) in attachment.traits_to_give)
					found_iff = TRUE
					break
			if(gun_with_iff.traits_to_give != null)
				if(gun_with_iff.traits_to_give.Find("iff") || LAZYFIND(gun_with_iff.traits_to_give,/datum/element/bullet_trait_iff))
					found_iff = TRUE
			if(gun_with_iff.in_chamber != null && gun_with_iff.in_chamber.bullet_traits != null )
				if(gun_with_iff.in_chamber.bullet_traits.Find("iff") || LAZYFIND(gun_with_iff.in_chamber.bullet_traits,/datum/element/bullet_trait_iff))
					found_iff = TRUE
			if(found_iff)
				if(get_target_lock(human_with_gun.get_id_faction_group()) > 0)
					msg += SPAN_HELPFUL("[capitalize(t_He)] is compatible with your weapon's IFF.\n")
				else
					msg += SPAN_DANGER("[capitalize(t_He)] is not compatible with your weapon's IFF. They will be shot by your weapon!\n")
	//Restraints
	if(handcuffed)
		msg += SPAN_ORANGE("[t_His] руки в [handcuffed.declent_ru(PREPOSITIONAL)].\n")

	if(legcuffed)
		msg += SPAN_ORANGE("[capitalize(t_his)] ноги в [handcuffed.declent_ru(PREPOSITIONAL)].\n")

	//Admin-slept
	if(sleeping > 8000000)
		msg += SPAN_HIGHDANGER(SPAN_BOLD("Этот игрок был усыплен администрацией.\n"))

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += SPAN_WARNING(SPAN_BOLD("[t_He] бьется в конвульсиях!\n"))
		else if(jitteriness >= 200)
			msg += SPAN_WARNING("[t_He] сильно дергается.\n")
		else if(jitteriness >= 100)
			msg += SPAN_WARNING("[t_He] слегка подергивается.\n")

	//splints & surgical incisions
	for(var/organ in list("l_leg","r_leg","l_arm","r_arm","l_foot","r_foot","l_hand","r_hand","chest","groin","head"))
		var/obj/limb/o = get_limb(organ)
		if(o)
			var/list/damage = list()
			if(o.status & LIMB_SPLINTED)
				damage += "шина"

			var/limb_incision = o.get_incision_depth()
			if(limb_incision)
				damage += limb_incision

			var/limb_surgeries = o.get_active_limb_surgeries()
			if(limb_surgeries)
				damage += limb_surgeries

			if(length(damage))
				msg += SPAN_WARNING("У [t_theirs] [english_list(damage, final_comma_text = ",")] на [t_his] [o.declent_ru(PREPOSITIONAL)]!\n")

	if(holo_card_color)
		// SS220 START EDIT ADDICTION
		var/holo_card_color_ru = list(
			red = "красная",
			purple = "фиолетовая",
			orange = "оранжевая",
		)
		msg += "У [t_theirs] [holo_card_color_ru[holo_card_color]] голокарта на груди.\n"
		// SS220 END EDIT ADDICTION

	var/distance = get_dist(user,src)
	if(istype(user, /mob/dead/observer) || user.stat == DEAD) // ghosts can see anything
		distance = 1
	if (stat || status_flags & FAKEDEATH)
		msg += SPAN_WARNING("[t_He] не реагирует на окружение, и, кажется, спит.\n")
		if(stat == DEAD && distance <= 3)
			msg += SPAN_WARNING("[t_He] не дышит.\n")
		if(paralyzed > 1 && distance <= 3)
			msg += SPAN_WARNING("[t_He] совершенно неподвижен.\n")
		if(ishuman(user) && !user.stat && Adjacent(user))
			user.visible_message("[SPAN_BOLD("[capitalize(user.declent_ru())]")] проверяет [t_his] пульс.", "Вы проверили [t_his] пульс.", null, 4)
		spawn(15)
			if(user && src && distance <= 1)
				get_pulse(GETPULSE_HAND) // to update it
				if(pulse == PULSE_NONE || status_flags & FAKEDEATH)
					// SS220 START EDIT ADDICTION
					if(client) // SS220 EDIT ADDICTION
						to_chat(user, SPAN_DEADSAY("У [t_theirs] нет пульса и [t_his] душа покинула тело..."))
					else // SS220 EDIT ADDICTION
						to_chat(user, SPAN_DEADSAY("У [t_theirs] нет пульса..."))
					// SS220 END EDIT ADDICTION
				else
					to_chat(user, SPAN_DEADSAY("У [t_theirs] нет пульса!")) // SS220 EDIT ADDICTION

	if((species && !species.has_organ["brain"] || has_brain()) && stat != DEAD && stat != CONSCIOUS)
		if(!key)
			msg += SPAN_DEADSAY("[t_He] глубоко спит. Не похоже, что [t_he] скоро проснется.\n")
		else if(!client)
			msg += "[t_He] внезапно засыпает.\n"

	if(fire_stacks > 0)
		msg += "[t_He] покрыт[genderize_ru(gender, "", "а", "о", "ы")] чем-то легковоспламеняющимся.\n"
	if(fire_stacks < 0)
		msg += "[t_He] промок[genderize_ru(gender, "", "ла", "ло", "ли")].\n"
	if(on_fire)
		msg += SPAN_WARNING("[t_He] горит!\n")

	var/list/wound_flavor_text = list()
	var/list/is_destroyed = list()
	var/list/is_bleeding = list()
	for(var/obj/limb/temp in limbs)
		if(temp)
			if(temp.status & LIMB_DESTROYED)
				is_destroyed["[temp.display_name]"] = 1
				wound_flavor_text["[temp.display_name]"] = SPAN_WARNING(SPAN_BOLD("У [t_theirs] отсутствует [temp.declent_ru()].\n"))
				continue
			if(temp.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
				if(!(temp.brute_dam + temp.burn_dam))
					if(!(temp.status & LIMB_SYNTHSKIN) && !(species && species.flags & IS_SYNTHETIC))
						wound_flavor_text["[temp.display_name]"] = SPAN_WARNING("У [t_theirs] [temp.status & LIMB_UNCALIBRATED_PROSTHETIC ? " нефункционирующий" : ""] протез [temp.declent_ru(GENITIVE)]!\n")
						continue
				else
					wound_flavor_text["[temp.display_name]"] = SPAN_WARNING("У [t_theirs] [temp.status & LIMB_UNCALIBRATED_PROSTHETIC ? " нефункционирующий" : ""] [temp.status & LIMB_SYNTHSKIN ? "синтетический" : "кибернетический"] протез [temp.declent_ru(GENITIVE)]. У него")
				if(temp.brute_dam)
					switch(temp.brute_dam)
						if(0 to 20)
							wound_flavor_text["[temp.display_name]"] += SPAN_WARNING(" малочисленные [temp.status & LIMB_SYNTHSKIN ? "повреждения поверхности" : "вмятины"]")
						if(21 to INFINITY)
							wound_flavor_text["[temp.display_name]"] += temp.status & LIMB_SYNTHSKIN ? SPAN_WARNING(pick(" многочисленные повреждения поверхности", " серьезные повреждения поверхности")) : SPAN_WARNING(pick(" многочисленные вмятины"," глубокие вмятины"))
				if(temp.brute_dam && temp.burn_dam)
					wound_flavor_text["[temp.display_name]"] += SPAN_WARNING(" и")
				if(temp.burn_dam)
					switch(temp.burn_dam)
						if(0 to 20)
							wound_flavor_text["[temp.display_name]"] += SPAN_WARNING(" малочисленные ожоги")
						if(21 to INFINITY)
							wound_flavor_text["[temp.display_name]"] += SPAN_WARNING(pick(" многочисленные ожоги"," серьезные ожоги"))
				if(wound_flavor_text["[temp.display_name]"])
					wound_flavor_text["[temp.display_name]"] += SPAN_WARNING("!\n")
			else if(length(temp.wounds) > 0)
				var/list/wound_descriptors = list()
				for(var/datum/wound/W as anything in temp.wounds)
					if(W.internal && incision_depths[temp.name] == SURGERY_DEPTH_SURFACE)
						continue // can't see internal wounds normally.
					var/this_wound_desc = declent_ru_initial(W.amount > 1 ? "[W.desc]s" : W.desc, W.amount > 1 ? GENITIVE : NOMINATIVE)
					if(W.damage_type == BURN)
						switch(W.salved & (WOUND_BANDAGED|WOUND_SUTURED))
							if(WOUND_BANDAGED)
								this_wound_desc = "обработанн[genderize_ru(W.declent_ru("gender"), "ый", "ая", "ое", "ыx")] [this_wound_desc]"
							if(WOUND_SUTURED, (WOUND_BANDAGED|WOUND_SUTURED)) //Grafting has priority.
								this_wound_desc = "пересаженн[genderize_ru(W.declent_ru("gender"), "ый", "ая", "ое", "ыx")] [this_wound_desc]" //??????!
					else
						switch(W.bandaged & (WOUND_BANDAGED|WOUND_SUTURED))
							if(WOUND_BANDAGED, (WOUND_BANDAGED|WOUND_SUTURED)) //Bandages go over the top.
								this_wound_desc = "перевязанн[genderize_ru(W.declent_ru("gender"), "ый", "ая", "ое", "ыx")] [this_wound_desc]"
							if(WOUND_SUTURED)
								this_wound_desc = "зашит[genderize_ru(W.declent_ru("gender"), "ый", "ая", "ое", "ыx")] [this_wound_desc]"

					if(wound_descriptors[this_wound_desc])
						wound_descriptors[this_wound_desc] += W.amount
						continue
					wound_descriptors[this_wound_desc] = W.amount
				if(length(wound_descriptors))
					var/list/flavor_text = list()
					for(var/wound in wound_descriptors)
						switch(wound_descriptors[wound])
							if(1)
								if(!length(flavor_text))
									flavor_text += SPAN_WARNING("У [t_theirs] [wound]")
								else
									flavor_text += " [wound]"
							if(2)
								if(!length(flavor_text))
									flavor_text += SPAN_WARNING("У [t_theirs] пара [wound]")
								else
									flavor_text += " пара [wound]"
							if(3 to 5)
								if(!length(flavor_text))
									flavor_text += SPAN_WARNING("У [t_theirs] несколько [wound]")
								else
									flavor_text += " нескольно [wound]"
							if(6 to INFINITY)
								if(!length(flavor_text))
									flavor_text += SPAN_WARNING("У [t_theirs] множество [wound]")
								else
									flavor_text += " множество [wound]"
					var/flavor_text_string = ""
					for(var/text = 1, text <= length(flavor_text), text++)
						if(text == length(flavor_text) && length(flavor_text) > 1)
							flavor_text_string += ", а также"
						else if(length(flavor_text) > 1 && text > 1)
							flavor_text_string += ","
						flavor_text_string += flavor_text[text]
					flavor_text_string += " на [t_his] [temp.declent_ru(PREPOSITIONAL)].</span><br>"
					wound_flavor_text["[temp.display_name]"] = flavor_text_string
				else
					wound_flavor_text["[temp.display_name]"] = ""
				for(var/datum/effects/bleeding/external/B in temp.bleeding_effects_list)
					is_bleeding["[temp.display_name]"] = TRUE
					break
			else
				wound_flavor_text["[temp.display_name]"] = ""

	//Handles the text strings being added to the actual description.
	//If they have something that covers the limb, and it is not missing, put flavortext.  If it is covered but bleeding, add other flavortext.
	var/display_head = 0
	var/display_chest = 0
	var/display_groin = 0
	var/display_arm_left = 0
	var/display_arm_right = 0
	var/display_leg_left = 0
	var/display_leg_right = 0
	var/display_foot_left = 0
	var/display_foot_right = 0
	var/display_hand_left = 0
	var/display_hand_right = 0

	if(wound_flavor_text["head"] && (is_destroyed["head"] || (!skipmask && !(wear_mask && istype(wear_mask, /obj/item/clothing/mask/gas)))))
		msg += wound_flavor_text["head"]
	if(is_bleeding["head"])
		display_head = 1
	if(wound_flavor_text["chest"] && !w_uniform && !skipjumpsuit) //No need.  A missing chest gibs you.
		msg += wound_flavor_text["chest"]
	if(is_bleeding["chest"])
		display_chest = 1
	if(wound_flavor_text["left arm"] && (is_destroyed["left arm"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["left arm"]
	if(is_bleeding["left arm"])
		display_arm_left = 1
	if(wound_flavor_text["left hand"] && (is_destroyed["left hand"] || (!gloves && !skipgloves)))
		msg += wound_flavor_text["left hand"]
	if(is_bleeding["left hand"])
		display_hand_left = 1
	if(wound_flavor_text["right arm"] && (is_destroyed["right arm"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["right arm"]
	if(is_bleeding["right arm"])
		display_arm_right = 1
	if(wound_flavor_text["right hand"] && (is_destroyed["right hand"] || (!gloves && !skipgloves)))
		msg += wound_flavor_text["right hand"]
	if(is_bleeding["right hand"])
		display_hand_right = 1
	if(wound_flavor_text["groin"] && (is_destroyed["groin"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["groin"]
	if(is_bleeding["groin"])
		display_groin = 1
	if(wound_flavor_text["left leg"] && (is_destroyed["left leg"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["left leg"]
	if(is_bleeding["left leg"])
		display_leg_left = 1
	if(wound_flavor_text["left foot"]&& (is_destroyed["left foot"] || (!shoes && !skipshoes)))
		msg += wound_flavor_text["left foot"]
	if(is_bleeding["left foot"])
		display_foot_left = 1
	if(wound_flavor_text["right leg"] && (is_destroyed["right leg"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["right leg"]
	if(is_bleeding["right leg"])
		display_leg_right = 1
	if(wound_flavor_text["right foot"]&& (is_destroyed["right foot"] || (!shoes  && !skipshoes)))
		msg += wound_flavor_text["right foot"]
	if(is_bleeding["right foot"])
		display_foot_right = 1

	if (display_head)
		msg += SPAN_WARNING("Кровь капает с [t_his] [SPAN_BOLD("лица!")]\n")

	if (display_chest && display_groin && display_arm_left && display_arm_right && display_hand_left && display_hand_right && display_leg_left && display_leg_right && display_foot_left && display_foot_right)
		msg += SPAN_WARNING("Кровь капает через [t_his] одежду с каждой части [t_his] [SPAN_BOLD("всего тела!")]\n")
	else
		if (display_chest && display_arm_left && display_arm_right && display_hand_left && display_hand_right)
			msg += SPAN_WARNING("Кровь капает через [t_his] одежду с каждой части [t_his] [SPAN_BOLD("всего торса!")]\n")
		else
			if (display_chest)
				msg += SPAN_WARNING("Кровь капает через [t_his] [SPAN_BOLD("футболку!")]\n")
			if (display_arm_left && display_arm_right && display_hand_left && display_hand_left)
				msg += SPAN_WARNING("Кровь капает через [t_his] [SPAN_BOLD("перчатки")] и [SPAN_BOLD("рукава!")]\n")
			else
				if (display_arm_left && display_arm_right)
					msg += SPAN_WARNING("Кровь капает через [t_his] [SPAN_BOLD("рукава!")]\n")
				else
					if (display_arm_left)
						msg += SPAN_WARNING("Кровь капает через [t_his] [SPAN_BOLD("левый рукав!")]\n")
					if (display_arm_right)
						msg += SPAN_WARNING("Кровь капает через [t_his] [SPAN_BOLD("правый рукав!")]\n")
				if (display_hand_left && display_hand_right)
					msg += SPAN_WARNING("Кровь течёт из-под [t_his] [SPAN_BOLD("перчаток!")]\n")
				else
					if (display_hand_left)
						msg += SPAN_WARNING("Кровь течёт из-под [t_his] [SPAN_BOLD("левой перчатки!")]\n")
					if (display_hand_right)
						msg += SPAN_WARNING("Кровь течёт из-под [t_his] [SPAN_BOLD("правой перчатки!")]\n")

		if (display_groin && display_leg_left && display_leg_right && display_foot_left && display_foot_right)
			msg += SPAN_WARNING("Кровь капает через [t_his] одежду с каждой части [t_his] [SPAN_BOLD("нижней половины тела!")]\n")
		else
			if (display_groin)
				msg += SPAN_WARNING("Кровь течёт из [t_his] [SPAN_BOLD("паха!")]\n")
			if (display_leg_left && display_leg_right && display_foot_left && display_foot_right)
				msg += SPAN_WARNING("Кровь течёт из [t_his] [SPAN_BOLD("штанов")] и [SPAN_BOLD("ботинок!")]\n")
			else
				if (display_leg_left && display_leg_right)
					msg += SPAN_WARNING("Кровь течёт из [t_his] [SPAN_BOLD("штанов!")]\n")
				else
					if (display_leg_left)
						msg += SPAN_WARNING("Кровь течёт из [t_his] [SPAN_BOLD("левой штанины!")]\n")
					if (display_leg_right)
						msg += SPAN_WARNING("Кровь течёт из [t_his] [SPAN_BOLD("правой штанины!")]\n")
				if (display_foot_left && display_foot_right)
					msg += SPAN_WARNING("Кровь собирается вокруг [t_his] [SPAN_BOLD("ботинок!")]\n")
				else
					if (display_foot_left)
						msg += SPAN_WARNING("Кровь собирается вокруг [t_his] [SPAN_BOLD("левого ботинка!")]\n")
					if (display_foot_right)
						msg += SPAN_WARNING("Кровь собирается вокруг [t_his] [SPAN_BOLD("правого ботинка!")]\n")

	if(chestburst == 2)
		msg += SPAN_WARNING(SPAN_BOLD("У [t_theirs] огромное отверстие в груди!\n"))

	for(var/implant in get_visible_implants())
		msg += SPAN_BOLDWARNING("У [t_theirs] торчит [lowertext(implant)] в теле!") + "\n" // SS220 EDIT ADDICTION

	if(hasHUD(user,"security") || (observer && observer.HUD_toggled["Security HUD"]))
		var/perpref


		if(wear_id && I)
			perpref = I.registered_ref

		if(perpref)
			var/criminal = "None"
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["ref"] == perpref)
					for (var/datum/data/record/R in GLOB.data_core.security)
						if(R.fields["id"] == E.fields["id"])
							criminal = R.fields["criminal"]

			msg += "<span class = 'deptradio'>Criminal status:</span>"
			if(!observer)
				msg += "<a href='byond://?src=\ref[src];criminal=1'>\[[criminal]\]</a>\n"
			else
				msg += "\[[criminal]\]\n"

			msg += "<span class = 'deptradio'>Security records:</span> <a href='byond://?src=\ref[src];secrecord=1'>\[View\]</a>"
			if(!observer)
				msg += " <a href='byond://?src=\ref[src];secrecordadd=1'>\[Add comment\]</a>\n"
			else
				msg += "\n"
	if(hasHUD(user,"medical"))
		var/cardcolor = holo_card_color
		if(!cardcolor)
			cardcolor = "none"
		msg += "<span class = 'deptradio'>Triage holo card:</span> <a href='byond://?src=\ref[src];medholocard=1'>\[[cardcolor]\]</a> - "

		// scan reports
		var/datum/data/record/N = null
		var/me_ref = WEAKREF(src)
		for(var/datum/data/record/R as anything in GLOB.data_core.medical)
			if (R.fields["ref"] == me_ref)
				N = R
				break
		if(!isnull(N))
			if(!(N.fields["last_scan_time"]))
				msg += "<span class = 'deptradio'>No scan report on record</span>\n"
			else
				msg += "<span class = 'deptradio'><a href='byond://?src=\ref[src];scanreport=1'>Scan from [N.fields["last_scan_time"]]</a></span>\n"


	if(hasHUD(user,"squadleader"))
		var/mob/living/carbon/human/H = user
		if(assigned_squad) //examined mob is a marine in a squad
			if(assigned_squad == H.assigned_squad) //same squad
				msg += "<a href='byond://?src=\ref[src];squadfireteam=1'>\[Manage Fireteams.\]</a>\n"

	if(user.Adjacent(src) && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/temp_msg = "<a href='byond://?src=\ref[src];check_status=1'>\[Проверить статус\]</a>" // SS220 EDIT ADDICTION
		if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC) && locate(/obj/item/clothing/accessory/stethoscope) in human_user.w_uniform)
			temp_msg += " <a href='byond://?src=\ref[src];use_stethoscope=1'>\[Использовать стетоскоп\]</a>" // SS220 EDIT ADDICTION
		msg += "\n<span class = 'deptradio'>Медицинские действия: [temp_msg]\n" // SS220 EDIT ADDICTION

	var/flavor = print_flavor_text()
	if(flavor)
		msg += "[flavor]\n"

	msg += "</span>"

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[t_He] is [pose]"

	. += msg


	if(isyautja(user))
		var/obj/item/clothing/gloves/yautja/hunter/bracers = gloves
		if(istype(bracers) && bracers.name_active)
			. += SPAN_BLUE("Their bracers identifies them as [SPAN_BOLD("[real_name].")]")
		. += SPAN_BLUE("[src] has the scent of [life_kills_total] defeated prey.")
		if(src.hunter_data.hunted)
			. += SPAN_ORANGE("[src] is being hunted by [src.hunter_data.hunter.real_name].")

		if(src.hunter_data.dishonored)
			. += SPAN_RED("[src] was marked as dishonorable for '[src.hunter_data.dishonored_reason]'.")
		else if(src.hunter_data.honored)
			. += SPAN_GREEN("[src] was honored for '[src.hunter_data.honored_reason]'.")

		if(src.hunter_data.thralled)
			. += SPAN_GREEN("[src] was thralled by [src.hunter_data.thralled_set.real_name] for '[src.hunter_data.thralled_reason]'.")
		else if(src.hunter_data.gear)
			. += SPAN_RED("[src] was marked as carrying gear by [src.hunter_data.gear_set].")

//Helper procedure. Called by /mob/living/carbon/human/get_examine_text() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/passed_mob, hudtype)
	if(istype(passed_mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/passed_human = passed_mob
		if (issynth(passed_human))
			return TRUE
		switch(hudtype)
			if("security")
				if(skillcheck(passed_human, SKILL_POLICE, SKILL_POLICE_SKILLED))
					var/datum/mob_hud/sec_hud = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
					if(sec_hud.hudusers[passed_human])
						return TRUE
			if("medical")
				if(skillcheck(passed_human, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
					var/datum/mob_hud/med_hud = GLOB.huds[MOB_HUD_MEDICAL_ADVANCED]
					if(med_hud.hudusers[passed_human])
						return TRUE
			if("squadleader")
				var/datum/mob_hud/faction_hud = GLOB.huds[MOB_HUD_FACTION_MARINE]
				if(passed_human.mind && passed_human.assigned_squad && passed_human.assigned_squad.squad_leader == passed_human && faction_hud.hudusers[passed_mob])
					return TRUE
			else
				return FALSE
	else
		return FALSE
