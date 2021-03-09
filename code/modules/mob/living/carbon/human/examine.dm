/mob/living/carbon/human/examine(mob/user)
	if(user.sdisabilities & DISABILITY_BLIND || user.blinded || user.stat==UNCONSCIOUS)
		to_chat(user, SPAN_NOTICE("Something is there but you can't see it."))
		return

	if(isXeno(user))
		var/msg = "<span class='info'>*---------*\nThis is "

		if(icon)
			msg += "[icon2html(icon, user)] "
		msg += "<EM>[src]</EM>!\n"

		if(species && species.flags & IS_SYNTHETIC)
			msg += "<span style='font-weight: bold; color: purple;'>You sense this creature is not organic.\n</span>"

		if(status_flags & XENO_HOST)
			msg += "This creature is impregnated.\n"
		else if(chestburst == 2)
			msg += "A larva escaped from this creature.\n"
		if(istype(wear_mask, /obj/item/clothing/mask/facehugger))
			msg += "It has a little one on its face.\n"
		if(on_fire)
			msg += "It is on fire!\n"
		if(stat == DEAD)
			msg += "<span style='font-weight: bold; color: purple;'>You sense this creature is dead.\n"
		else if(stat || !client)
			msg += "<span class='xenowarning'>It doesn't seem responsive.\n</span>"
		msg += "*---------*</span>"
		to_chat(user, msg)
		return

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

	// crappy hacks because you can't do \his[src] etc. I'm sorry this proc is so unreadable, blame the text macros :<
	var/t_He = "It" //capitalised for use at the start of each line.
	var/t_his = "its"
	var/t_him = "it"
	var/t_has = "has"
	var/t_is = "is"

	var/id_paygrade = ""
	var/obj/item/card/id/I = get_idcard()
	if(I)
		id_paygrade = I.paygrade
	var/rank_display = get_paygrades(id_paygrade, FALSE, gender)
	var/msg = "<span class='info'>*---------*\nThis is "

	if(skipjumpsuit && skipface) //big suits/masks/helmets make it hard to tell their gender
		t_He = "They"
		t_his = "their"
		t_him = "them"
		t_has = "have"
		t_is = "are"
	else
		if(icon)
			msg += "[icon2html(src, user)] "
		switch(gender)
			if(MALE)
				t_He = "He"
				t_his = "his"
				t_him = "him"
			if(FEMALE)
				t_He = "She"
				t_his = "her"
				t_him = "her"

	if(id_paygrade)
		msg += "<EM>[rank_display] </EM>"
	msg += "<EM>[src]</EM>!\n"

	//uniform
	if(w_uniform && !skipjumpsuit)
		msg += "[t_He] [t_is] wearing [w_uniform.get_examine_line()].\n"

	//head
	if(head)
		msg += "[t_He] [t_is] wearing [head.get_examine_line()] on [t_his] head.\n"

	//suit/armour
	if(wear_suit)
		msg += "[t_He] [t_is] wearing [wear_suit.get_examine_line()].\n"
		//suit/armour storage
		if(s_store && !skipsuitstorage)
			msg += "[t_He] [t_is] carrying [s_store.get_examine_line()] on [t_his] [wear_suit.name].\n"

	//back
	if(back)
		msg += "[t_He] [t_has] [back.get_examine_line()] on [t_his] back.\n"

	//left hand
	if(l_hand)
		msg += "[t_He] [t_is] holding [l_hand.get_examine_line()] in [t_his] left hand.\n"

	//right hand
	if(r_hand)
		msg += "[t_He] [t_is] holding [r_hand.get_examine_line()] in [t_his] right hand.\n"

	//gloves
	if(gloves && !skipgloves)
		msg += "[t_He] [t_has] [gloves.get_examine_line()] on [t_his] hands.\n"
	else if(hands_blood_color)
		msg += SPAN_WARNING("[t_He] [t_has] [(hands_blood_color != "#030303") ? "blood" : "oil"]-stained hands!\n")

	//belt
	if(belt)
		msg += "[t_He] [t_has] [belt.get_examine_line()] about [t_his] waist.\n"

	//shoes
	if(shoes && !skipshoes)
		msg += "[t_He] [t_is] wearing [shoes.get_examine_line()] on [t_his] feet.\n"
	else if(feet_blood_color)
		msg += SPAN_WARNING("[t_He] [t_has] [(feet_blood_color != "#030303") ? "blood" : "oil"]-stained feet!\n")

	//mask
	if(wear_mask && !skipmask)
		msg += "[t_He] [t_has] [wear_mask.get_examine_line()] on [t_his] face.\n"

	//eyes
	if(glasses && !skipeyes)
		msg += "[t_He] [t_has] [glasses.get_examine_line()] covering [t_his] eyes.\n"

	//ear
	if(wear_ear && !skipears)
		msg += "[t_He] [t_has] [wear_ear.get_examine_line()] on [t_his] right ear.\n"

	//ID
	if(wear_id)
		msg += "[t_He] [t_is] wearing [wear_id.get_examine_line()].\n"

	//Admin-slept
	if(sleeping > 8000000)
		msg += SPAN_HIGHDANGER("<B>This player has been slept by staff.</B>\n")

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += SPAN_WARNING("<B>[t_He] [t_is] convulsing violently!</B>\n")
		else if(jitteriness >= 200)
			msg += SPAN_WARNING("[t_He] [t_is] extremely jittery.\n")
		else if(jitteriness >= 100)
			msg += SPAN_WARNING("[t_He] [t_is] twitching ever so slightly.\n")

	//splints
	for(var/organ in list("l_leg","r_leg","l_arm","r_arm","l_foot","r_foot","l_hand","r_hand","chest","groin","head"))
		var/obj/limb/o = get_limb(organ)
		if(o && o.status & LIMB_SPLINTED)
			msg += SPAN_WARNING("[t_He] [t_has] a splint on [t_his] [o.display_name]!\n")

	if(holo_card_color)
		msg += "[t_He] has a [holo_card_color] holo card on [t_his] chest.\n"

	var/distance = get_dist(user,src)
	if(istype(user, /mob/dead/observer) || user.stat == DEAD) // ghosts can see anything
		distance = 1
	if (stat)
		msg += SPAN_WARNING("[t_He] [t_is]n't responding to anything around [t_him] and seems to be asleep.\n")
		if(stat == DEAD && distance <= 3)
			msg += SPAN_WARNING("[t_He] does not appear to be breathing.\n")
		if(paralyzed > 1 && distance <= 3)
			msg += SPAN_WARNING("[t_He] seems to be completely still.\n")
		if(ishuman(user) && !user.stat && Adjacent(user))
			user.visible_message("<b>[user]</b> checks [src]'s pulse.", "You check [src]'s pulse.", null, 4)
		spawn(15)
			if(user && src && distance <= 1 && user.stat != 1)
				if(pulse == PULSE_NONE)
					to_chat(user, "<span class='deadsay'>[t_He] has no pulse[client ? "" : " and [t_his] soul has departed"]...</span>")
				else
					to_chat(user, "<span class='deadsay'>[t_He] has a pulse!</span>")

	if((species && !species.has_organ["brain"] || has_brain()) && stat != DEAD && stat != CONSCIOUS)
		if(!key)
			msg += "<span class='deadsay'>[t_He] [t_is] fast asleep. It doesn't look like they are waking up anytime soon.\n</span>"
		else if(!client)
			msg += "[t_He] [t_has] suddenly fallen asleep.\n"

	if(fire_stacks > 0)
		msg += "[t_He] [t_is] covered in something flammable.\n"
	if(fire_stacks < 0)
		msg += "[t_He] looks a little soaked.\n"
	if(on_fire)
		msg += SPAN_WARNING("[t_He] [t_is] on fire!\n")

	var/list/wound_flavor_text = list()
	var/list/is_destroyed = list()
	var/list/is_bleeding = list()
	for(var/obj/limb/temp in limbs)
		if(temp)
			if(temp.status & LIMB_DESTROYED)
				is_destroyed["[temp.display_name]"] = 1
				wound_flavor_text["[temp.display_name]"] = SPAN_WARNING("<b>[t_He] is missing [t_his] [temp.display_name].</b>\n")
				continue
			if(temp.status & LIMB_ROBOT)
				if(!(temp.brute_dam + temp.burn_dam))
					if(!(species && species.flags & IS_SYNTHETIC))
						wound_flavor_text["[temp.display_name]"] = SPAN_WARNING("[t_He] has a robot [temp.display_name]!\n")
						continue
				else
					wound_flavor_text["[temp.display_name]"] = SPAN_WARNING("[t_He] has a robot [temp.display_name]. It has")
				if(temp.brute_dam) switch(temp.brute_dam)
					if(0 to 20)
						wound_flavor_text["[temp.display_name]"] += " some dents"
					if(21 to INFINITY)
						wound_flavor_text["[temp.display_name]"] += pick(" a lot of dents"," severe denting")
				if(temp.brute_dam && temp.burn_dam)
					wound_flavor_text["[temp.display_name]"] += " and"
				if(temp.burn_dam) switch(temp.burn_dam)
					if(0 to 20)
						wound_flavor_text["[temp.display_name]"] += " some burns"
					if(21 to INFINITY)
						wound_flavor_text["[temp.display_name]"] += pick(" a lot of burns"," severe melting")
				if(wound_flavor_text["[temp.display_name]"])
					wound_flavor_text["[temp.display_name]"] += "!\n"
			else if(temp.wounds.len > 0)
				var/list/wound_descriptors = list()
				for(var/datum/wound/W in temp.wounds)
					if(W.internal && !temp.surgery_open_stage) continue // can't see internal wounds
					var/this_wound_desc = W.desc
					if(W.damage_type == BURN && W.salved) this_wound_desc = "salved [this_wound_desc]"
					else if(W.bandaged) this_wound_desc = "bandaged [this_wound_desc]"
					if(wound_descriptors[this_wound_desc])
						wound_descriptors[this_wound_desc] += W.amount
						continue
					wound_descriptors[this_wound_desc] = W.amount
				if(wound_descriptors.len)
					var/list/flavor_text = list()
					var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
					"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area")
					for(var/wound in wound_descriptors)
						switch(wound_descriptors[wound])
							if(1)
								if(!flavor_text.len)
									flavor_text += SPAN_WARNING("[t_He] has[prob(10) && !(wound in no_exclude)  ? " what might be" : ""] a [wound]")
								else
									flavor_text += "[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a [wound]"
							if(2)
								if(!flavor_text.len)
									flavor_text += SPAN_WARNING("[t_He] has[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a pair of [wound]s")
								else
									flavor_text += "[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a pair of [wound]s"
							if(3 to 5)
								if(!flavor_text.len)
									flavor_text += SPAN_WARNING("[t_He] has several [wound]s")
								else
									flavor_text += " several [wound]s"
							if(6 to INFINITY)
								if(!flavor_text.len)
									flavor_text += SPAN_WARNING("[t_He] has a bunch of [wound]s")
								else
									flavor_text += " a ton of [wound]\s"
					var/flavor_text_string = ""
					for(var/text = 1, text <= flavor_text.len, text++)
						if(text == flavor_text.len && flavor_text.len > 1)
							flavor_text_string += ", and"
						else if(flavor_text.len > 1 && text > 1)
							flavor_text_string += ","
						flavor_text_string += flavor_text[text]
					flavor_text_string += " on [t_his] [temp.display_name].</span><br>"
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
		msg += SPAN_WARNING("[t_He] has blood dripping from [t_his] <b>face</b>!\n")

	if (display_chest && display_groin && display_arm_left && display_arm_right && display_hand_left && display_hand_right && display_leg_left && display_leg_right && display_foot_left && display_foot_right)
		msg += SPAN_WARNING("[t_He] has blood soaking through [t_his] clothes from [t_his] <b>entire body</b>!\n")
	else
		if (display_chest && display_arm_left && display_arm_right && display_hand_left && display_hand_right)
			msg += SPAN_WARNING("[t_He] has blood soaking through [t_his] clothes from [t_his] <b>upper body</b>!\n")
		else
			if (display_chest)
				msg += SPAN_WARNING("[t_He] has blood soaking through [t_his] <b>shirt</b>!\n")
			if (display_arm_left && display_arm_right && display_hand_left && display_hand_left)
				msg += SPAN_WARNING("[t_He] has blood soaking through [t_his] <b>gloves</b> and <b>sleeves</b>!\n")
			else
				if (display_arm_left && display_arm_right)
					msg += SPAN_WARNING("[t_He] has blood soaking through [t_his] <b>sleeves</b>!\n")
				else
					if (display_arm_left)
						msg += SPAN_WARNING("[t_He] has soaking through [t_his] <b>left sleeve</b>!\n")
					if (display_arm_right)
						msg += SPAN_WARNING("[t_He] has soaking through [t_his] <b>right sleeve</b>!\n")
				if (display_hand_left && display_hand_right)
					msg += SPAN_WARNING("[t_He] has blood running out from under [t_his] <b>gloves</b>!\n")
				else
					if (display_hand_left)
						msg += SPAN_WARNING("[t_He] has blood running out from under [t_his] <b>left glove</b>!\n")
					if (display_hand_right)
						msg += SPAN_WARNING("[t_He] has blood running out from under [t_his] <b>right glove</b>!\n")

		if (display_groin && display_leg_left && display_leg_right && display_foot_left && display_foot_right)
			msg += SPAN_WARNING("[t_He] has blood soaking through [t_his] clothes from [t_his] <b>lower body!</b>\n")
		else
			if (display_groin)
				msg += SPAN_WARNING("[t_He] has blood dripping from [t_his] <b>groin</b>!\n")
			if (display_leg_left && display_leg_right && display_foot_left && display_foot_right)
				msg += SPAN_WARNING("[t_He] has blood soaking through [t_his] <b>pant legs</b> and <b>boots</b>!\n")
			else
				if (display_leg_left && display_leg_right)
					msg += SPAN_WARNING("[t_He] has blood soaking through [t_his] <b>pant legs</b>!\n")
				else
					if (display_leg_left)
						msg += SPAN_WARNING("[t_He] has blood soaking through [t_his] <b>left pant leg</b>!\n")
					if (display_leg_right)
						msg += SPAN_WARNING("[t_He] has blood soaking through [t_his] <b>right pant leg</b>!\n")
				if (display_foot_left && display_foot_right)
					msg += SPAN_WARNING("[t_He] has blood pooling around[t_his] <b>boots</b>!\n")
				else
					if (display_foot_left)
						msg += SPAN_WARNING("[t_He] has blood pooling around [t_his] <b>left boot</b>!\n")
					if (display_foot_right)
						msg += SPAN_WARNING("[t_He] has blood pooling around [t_his] <b>right boot</b>!\n")

	if(chestburst == 2)
		msg += SPAN_WARNING("<b>[t_He] has a giant hole in [t_his] chest!</b>\n")

	for(var/implant in get_visible_implants())
		msg += SPAN_WARNING("<b>[t_He] has \a [implant] sticking out of [t_his] flesh!\n")

	if(hasHUD(user,"security"))
		var/perpname = "wot"
		var/criminal = "None"

		if(wear_id)
			if(I)
				perpname = I.registered_name
			else
				perpname = name
		else
			perpname = name

		if(perpname)
			for (var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["name"] == perpname)
					for (var/datum/data/record/R in GLOB.data_core.security)
						if(R.fields["id"] == E.fields["id"])
							criminal = R.fields["criminal"]

			msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>\n"
			msg += "<span class = 'deptradio'>Security records:</span> <a href='?src=\ref[src];secrecord=1'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=1'>\[Add comment\]</a>\n"

	if(hasHUD(user,"medical"))
		var/cardcolor = holo_card_color
		if(!cardcolor) cardcolor = "none"
		msg += "<span class = 'deptradio'>Triage holo card:</span> <a href='?src=\ref[src];medholocard=1'>\[[cardcolor]\]</a> - "

		// scan reports
		var/datum/data/record/N = null
		for(var/datum/data/record/R in GLOB.data_core.medical)
			if (R.fields["name"] == real_name)
				N = R
				break
		if(!isnull(N))
			if(!(N.fields["last_scan_time"]))
				msg += "<span class = 'deptradio'>No scan report on record</span>\n"
			else
				msg += "<span class = 'deptradio'><a href='?src=\ref[src];scanreport=1'>Scan from [N.fields["last_scan_time"]]</a></span>\n"


	if(hasHUD(user,"squadleader"))
		var/mob/living/carbon/human/H = user
		if(assigned_squad) //examined mob is a marine in a squad
			if(assigned_squad == H.assigned_squad) //same squad
				msg += "<a href='?src=\ref[src];squadfireteam=1'>\[Manage Fireteams.\]</a>\n"


	if(print_flavor_text())
		msg += "[print_flavor_text()]\n"

	msg += "*---------*</span>"

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[t_He] is [pose]"

	to_chat(user, msg)

	if(isYautja(user))
		to_chat(user, SPAN_BLUE("[src] is worth [max(life_kills_total, 1)] honor."))

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M, hudtype)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if (isSynth(H))
			return 1
		switch(hudtype)
			if("security")
				//only MPs can use the security HUD glasses's functionalities
				if(skillcheck(H, SKILL_POLICE, SKILL_POLICE_MP))
					return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				if(skillcheck(H, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
					return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
			if("squadleader")
				return H.mind && H.assigned_squad && H.assigned_squad.squad_leader == H && istype(H.wear_ear, /obj/item/device/radio/headset/almayer/marine)
			else
				return 0
	else if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		switch(hudtype)
			if("security")
				return istype(R.module_state_1, /obj/item/robot/sight/hud/sec) || istype(R.module_state_2, /obj/item/robot/sight/hud/sec) || istype(R.module_state_3, /obj/item/robot/sight/hud/sec)
			if("medical")
				return istype(R.module_state_1, /obj/item/robot/sight/hud/med) || istype(R.module_state_2, /obj/item/robot/sight/hud/med) || istype(R.module_state_3, /obj/item/robot/sight/hud/med)
			else
				return 0
	else
		return 0
