/mob/living/carbon/human/get_examine_text(mob/user)
	if(HAS_TRAIT(src, TRAIT_SIMPLE_DESC))
		return list(desc)

	if(user.sdisabilities & DISABILITY_BLIND || user.blinded || user.stat==UNCONSCIOUS)
		return list(SPAN_NOTICE("Тут что-то есть, но вы не можете разглядеть."))

	var/mob/dead/observer/observer
	if(isobserver(user))
		observer = user

	if(isxeno(user))
		var/msg = "<span class='info'>Это "

		if(icon)
			msg += "[icon2html(icon, user)] "
		msg += "<EM>[src]</EM>!\n"

		if(species && species.flags & IS_SYNTHETIC)
			msg += "<span style='font-weight: bold; color: purple;'>Вы чуствуете, что это существо не является органическим.\n</span>"

		if(status_flags & XENO_HOST)
			msg += "Это существо оплодотворено.\n"
		else if(chestburst == 2)
			msg += "Грудолом вырвался из этого существа.\n"
		if(istype(wear_mask, /obj/item/clothing/mask/facehugger))
			msg += "Лицехват уже уселся на лице существа.\n"
		if(on_fire)
			msg += "Оно горит!\n"
		if(stat == DEAD)
			msg += "<span style='font-weight: bold; color: purple;'>Вы чувствуете, что это существо мертво.\n</span>"
		else if(stat || !client)
			msg += SPAN_XENOWARNING("Оно без сознания.\n")
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

	var/t_He = ru_p_they(TRUE)
	var/t_he = ru_p_they()
	var/t_His = ru_p_them(TRUE)
	var/t_his = ru_p_them()
	var/t_theirs = ru_p_theirs()
	// var/t_has = "has"
	// var/t_is = "is"

	var/id_paygrade = ""
	var/obj/item/card/id/I = get_idcard()
	if(I)
		id_paygrade = I.paygrade
	var/rank_display = get_paygrades(id_paygrade, FALSE, gender)
	var/msg = "<span class='info'>\nЭто "

	if(!skipjumpsuit || !skipface) //big suits/masks/helmets make it hard to tell their gender
		if(icon)
			msg += "[icon2html(src, user)] "

	if(id_paygrade)
		msg += "<EM>[rank_display] </EM>"
	msg += "<EM>[declent_ru(NOMINATIVE)]</EM>!\n"

	//uniform
	if(w_uniform && !skipjumpsuit)
		msg += "[t_He] носит [w_uniform.get_examine_location(src, user, WEAR_BODY, t_He, t_his, t_theirs)].\n"

	//head
	if(head)
		msg += "[t_He] носит [head.get_examine_line(user)] [head.get_examine_location(src, user, WEAR_HEAD, t_He, t_his, t_theirs)].\n"

	//suit/armor
	if(wear_suit)
		msg += "[t_He] носит [wear_suit.get_examine_location(src, user, WEAR_JACKET, t_He, t_his, t_theirs)].\n"
	//suit/armor storage
	if(s_store && !skipsuitstorage)
		msg += "[t_He] носит [s_store.get_examine_line(user)] [s_store.get_examine_location(src, user, WEAR_J_STORE, t_He, t_his, t_theirs)].\n"

	//back
	if(back)
		msg += "[t_He] носит [back.get_examine_line(user)] [back.get_examine_location(src, user, WEAR_BACK, t_He, t_his, t_theirs)].\n"

	//left hand
	if(l_hand)
		msg += "[t_He] держит [l_hand.get_examine_line(user)] [l_hand.get_examine_location(src, user, WEAR_L_HAND, t_He, t_his, t_theirs)].\n"

	//right hand
	if(r_hand)
		msg += "[t_He] держит [r_hand.get_examine_line(user)] [r_hand.get_examine_location(src, user, WEAR_R_HAND, t_He, t_his, t_theirs)].\n"

	//gloves
	if(gloves && !skipgloves)
		msg += "[t_He] носит [gloves.get_examine_line(user)] [gloves.get_examine_location(src, user, WEAR_HANDS, t_He, t_his, t_theirs)].\n"
	else if(hands_blood_color)
		msg += SPAN_WARNING("У [t_theirs] [(hands_blood_color != COLOR_OIL) ? "окровавленные" : "замасленные"] руки!\n")

	//belt
	if(belt)
		msg += "[t_He] носит [belt.get_examine_line(user)] [belt.get_examine_location(src, user, WEAR_WAIST, t_He, t_his, t_theirs)].\n"

	//shoes
	if(shoes && !skipshoes)
		msg += "[t_He] носит [shoes.get_examine_line(user)] [shoes.get_examine_location(src, user, WEAR_FEET, t_He, t_his, t_theirs)].\n"
	else if(feet_blood_color)
		msg += SPAN_WARNING("[t_He] [(feet_blood_color != COLOR_OIL) ? "окровавленные" : "замасленные"] ноги!\n")

	//mask
	if(wear_mask && !skipmask)
		msg += "[t_He] носит [wear_mask.get_examine_line(user)] [wear_mask.get_examine_location(src, user, WEAR_FACE, t_He, t_his, t_theirs)].\n"

	//eyes
	if(glasses && !skipeyes)
		msg += "[t_He] носит [glasses.get_examine_line(user)] [glasses.get_examine_location(src, user, WEAR_EYES, t_He, t_his, t_theirs)].\n"

	//ears
	if(!skipears)
		if(wear_l_ear)
			msg += "[t_He] носит [wear_l_ear.get_examine_line(user)] [wear_l_ear.get_examine_location(src, user, WEAR_L_EAR, t_He, t_his, t_theirs)].\n"
		if(wear_r_ear)
			msg += "[t_He] носит [wear_r_ear.get_examine_line(user)] [wear_r_ear.get_examine_location(src, user, WEAR_R_EAR, t_He, t_his, t_theirs)].\n"

	//ID
	if(wear_id)
		msg += "[t_He] носит [wear_id.get_examine_location(src, user, WEAR_ID, t_He, t_his, t_theirs)].\n"

	//Restraints
	if(handcuffed)
		msg += SPAN_ORANGE("[t_His] руки в [handcuffed.declent_ru(PREPOSITIONAL)].\n")

	if(legcuffed)
		msg += SPAN_ORANGE("[capitalize(t_his)] ноги в [handcuffed.declent_ru(PREPOSITIONAL)].\n")

	//Admin-slept
	if(sleeping > 8000000)
		msg += SPAN_HIGHDANGER("<B>Этот игрок был усыплен администрацией.</B>\n")

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += SPAN_WARNING("<B>[t_He] бьется в конвульсиях!</B>\n")
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
		msg += "У [t_theirs] [holo_card_color] голокарта на груди.\n"

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
			user.visible_message("<b>[capitalize(user.declent_ru(NOMINATIVE))]</b> проверяет [t_his] пульс.", "Вы проверили [t_his] пульс.", null, 4)
		spawn(15)
			if(user && src && distance <= 1)
				get_pulse(GETPULSE_HAND) // to update it
				if(pulse == PULSE_NONE || status_flags & FAKEDEATH)
					to_chat(user, SPAN_DEADSAY("У [t_theirs] нету пульса[client ? "" : " и [t_his] душа ушла"]..."))
				else
					to_chat(user, SPAN_DEADSAY("У [t_theirs] нету пульса!"))

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
				wound_flavor_text["[temp.display_name]"] = SPAN_WARNING("<b>У [t_theirs] отсутствует [temp.declent_ru(NOMINATIVE)].</b>\n")
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
		msg += SPAN_WARNING("Кровь капает с [t_his] <b>лица</b>!\n")

	if (display_chest && display_groin && display_arm_left && display_arm_right && display_hand_left && display_hand_right && display_leg_left && display_leg_right && display_foot_left && display_foot_right)
		msg += SPAN_WARNING("Кровь капает через [t_his] одежду <b>всего тела</b>!\n")
	else
		if (display_chest && display_arm_left && display_arm_right && display_hand_left && display_hand_right)
			msg += SPAN_WARNING("Кровь капает через [t_his] одежду <b>всего торса</b>!\n")
		else
			if (display_chest)
				msg += SPAN_WARNING("Кровь капает через [t_his] <b>футболку</b>!\n")
			if (display_arm_left && display_arm_right && display_hand_left && display_hand_left)
				msg += SPAN_WARNING("Кровь капает через [t_his] <b>перчатки</b> и <b>рукава</b>!\n")
			else
				if (display_arm_left && display_arm_right)
					msg += SPAN_WARNING("Кровь капает через [t_his] <b>рукава</b>!\n")
				else
					if (display_arm_left)
						msg += SPAN_WARNING("Кровь капает через [t_his] <b>левый рукав</b>!\n")
					if (display_arm_right)
						msg += SPAN_WARNING("Кровь капает через [t_his] <b>правый рукав</b>!\n")
				if (display_hand_left && display_hand_right)
					msg += SPAN_WARNING("Кровь течёт из-под [t_his] <b>перчаток</b>!\n")
				else
					if (display_hand_left)
						msg += SPAN_WARNING("Кровь течёт из-под [t_his] <b>левой перчатки</b>!\n")
					if (display_hand_right)
						msg += SPAN_WARNING("Кровь течёт из-под [t_his] <b>правой перчатки</b>!\n")

		if (display_groin && display_leg_left && display_leg_right && display_foot_left && display_foot_right)
			msg += SPAN_WARNING("Кровь капает через [t_his] одежду <b>с нижней половины тела</b>!\n") //?
		else
			if (display_groin)
				msg += SPAN_WARNING("Кровь течёт из [t_his] <b>паха</b>!\n")
			if (display_leg_left && display_leg_right && display_foot_left && display_foot_right)
				msg += SPAN_WARNING("Кровь течёт из [t_his] <b>штанов</b> и <b>ботинок</b>!\n")
			else
				if (display_leg_left && display_leg_right)
					msg += SPAN_WARNING("Кровь течёт из [t_his] <b>штанов</b>!\n")
				else
					if (display_leg_left)
						msg += SPAN_WARNING("Кровь течёт из [t_his] <b>левой штанины</b>!\n")
					if (display_leg_right)
						msg += SPAN_WARNING("Кровь течёт из [t_his] <b>правой штанины</b>!\n")
				if (display_foot_left && display_foot_right)
					msg += SPAN_WARNING("Кровь собирается вокруг [t_his] <b>ботинок</b>!\n")
				else
					if (display_foot_left)
						msg += SPAN_WARNING("Кровь собирается вокруг [t_his] <b>левого ботинка</b>!\n")
					if (display_foot_right)
						msg += SPAN_WARNING("Кровь собирается вокруг [t_his] <b>правого ботинка</b>!\n")

	if(chestburst == 2)
		msg += SPAN_WARNING("<b>У [t_theirs] огромное отверстие в груди!</b>\n")

	for(var/obj/implant in get_visible_implants())
		msg += SPAN_WARNING("<b>[capitalize(implant.declent_ru(NOMINATIVE))] торчит из-под [t_his] кожи!</b>\n")

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
		var/temp_msg = "<a href='byond://?src=\ref[src];check_status=1'>\[Check Status\]</a>"
		if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC) && locate(/obj/item/clothing/accessory/stethoscope) in human_user.w_uniform)
			temp_msg += " <a href='byond://?src=\ref[src];use_stethoscope=1'>\[Use Stethoscope\]</a>"
		msg += "\n<span class = 'deptradio'>Medical actions: [temp_msg]\n"

	if(print_flavor_text())
		msg += "[print_flavor_text()]\n"

	msg += "</span>"

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[t_He] is [pose]"

	. += msg


	if(isyautja(user))
		var/obj/item/clothing/gloves/yautja/hunter/bracers = gloves
		if(istype(bracers) && bracers.name_active)
			. += SPAN_BLUE("Their bracers identifies them as <b>[real_name]</b>.")
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
