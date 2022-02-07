/mob/living/carbon/human/var/cpr_cooldown
/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M)
	if(..())
		return TRUE

	if((M != src) && check_shields(0, M.name))
		visible_message(SPAN_DANGER("<B>[M] attempted to touch [src]!</B>"), null, null, 5)
		return 0

	switch(M.a_intent)
		if(INTENT_HELP)

			if(on_fire && M != src)
				adjust_fire_stacks(-10, min_stacks = 0)
				playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
				M.visible_message(SPAN_DANGER("[M] tries to put out the fire on [src]!"), \
					SPAN_WARNING("You try to put out the fire on [src]!"), null, 5)
				if(fire_stacks <= 0)
					M.visible_message(SPAN_DANGER("[M] has successfully extinguished the fire on [src]!"), \
						SPAN_NOTICE("You extinguished the fire on [src]."), null, 5)
				return 1

			// If unconcious with oxygen damage, do CPR. If dead, we do CPR
			if(!(stat == UNCONSCIOUS && getOxyLoss() > 0) && !(stat == DEAD))
				help_shake_act(M)
				return 1

			if(M.head && (M.head.flags_inventory & COVERMOUTH) || M.wear_mask && (M.wear_mask.flags_inventory & COVERMOUTH) && !(M.wear_mask.flags_inventory & ALLOWCPR))
				to_chat(M, SPAN_NOTICE(" <B>Remove your mask!</B>"))
				return 0
			if(head && (head.flags_inventory & COVERMOUTH) || wear_mask && (wear_mask.flags_inventory & COVERMOUTH) && !(wear_mask.flags_inventory & ALLOWCPR))
				to_chat(M, SPAN_NOTICE(" <B>Remove [src.gender==MALE?"his":"her"] mask!</B>"))
				return 0

			//CPR
			if(M.action_busy)
				return 1

			M.visible_message(SPAN_NOTICE("<b>[M]</b> starts performing <b>CPR</b> on <b>[src]</b>."),
				SPAN_HELPFUL("You start <b>performing CPR</b> on <b>[src]</b>."))

			if(do_after(M, HUMAN_STRIP_DELAY * M.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
				if(stat != DEAD)
					var/suff = min(getOxyLoss(), 10) //Pre-merge level, less healing, more prevention of dieing.
					apply_damage(-suff, OXY)
					updatehealth()
					src.affected_message(M,
						SPAN_HELPFUL("You feel a <b>breath of fresh air</b> enter your lungs. It feels good."),
						SPAN_HELPFUL("You <b>perform CPR</b> on <b>[src]</b>. Repeat at least every <b>7 seconds</b>."),
						SPAN_NOTICE("<b>[M]</b> performs <b>CPR</b> on <b>[src]</b>."))
				if(is_revivable() && stat == DEAD)
					if(cpr_cooldown < world.time)
						revive_grace_period += 7 SECONDS
						M.visible_message(SPAN_NOTICE("<b>[M]</b> performs <b>CPR</b> on <b>[src]</b>."),
							SPAN_HELPFUL("You perform <b>CPR</b> on <b>[src]</b>."))
					else
						M.visible_message(SPAN_NOTICE("<b>[M]</b> fails to perform CPR on <b>[src]</b>."),
							SPAN_HELPFUL("You <b>fail</b> to perform <b>CPR</b> on <b>[src]</b>. Incorrect rhythm. Do it <b>slower</b>."))
					cpr_cooldown = world.time + 7 SECONDS

			return 1

		if(INTENT_GRAB)
			if(M == src)
				check_for_injuries()
				return 1

			if(anchored)
				return 0

			if(w_uniform)
				w_uniform.add_fingerprint(M)

			M.start_pulling(src)

			return 1

		if(INTENT_HARM)
			// See if they can attack, and which attacks to use.
			var/datum/unarmed_attack/attack = M.species.unarmed
			if(!attack.is_usable(M)) attack = M.species.secondary_unarmed
			if(!attack.is_usable(M)) return

			last_damage_data = create_cause_data("fisticuffs", src)
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>[pick(attack.attack_verb)]ed [key_name(src)]</font>")
			attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [pick(attack.attack_verb)]ed by [key_name(M)]</font>")
			msg_admin_attack("[key_name(M)] [pick(attack.attack_verb)]ed [key_name(src)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

			M.animation_attack_on(src)
			M.flick_attack_overlay(src, "punch")

			var/extra_cqc_dmg = 0 //soft maximum of 5, this damage is added onto the final value depending on how much cqc skill you have
			if(M.skills)
				extra_cqc_dmg = M.skills?.get_skill_level(SKILL_CQC)
			var/raw_damage = 0 //final value, gets absorbed by the armor and then deals the leftover to the mob

			var/obj/limb/affecting = get_limb(rand_zone(M.zone_selected, 70))
			var/armor = getarmor(affecting, ARMOR_MELEE)

			playsound(loc, attack.attack_sound, 25, 1)

			visible_message(SPAN_DANGER("[M] [pick(attack.attack_verb)]ed [src]!"), null, null, 5)

			raw_damage = attack.damage + extra_cqc_dmg
			var/final_damage = armor_damage_reduction(GLOB.marine_melee, raw_damage, armor, FALSE) // no penetration from punches
			apply_damage(final_damage, BRUTE, affecting)

		if(INTENT_DISARM)
			if(M == src)
				check_for_injuries()
				return 1

			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [key_name(src)]</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [key_name(M)]</font>")

			M.animation_attack_on(src)
			M.flick_attack_overlay(src, "disarm")

			msg_admin_attack("[key_name(M)] disarmed [key_name(src)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

			if(w_uniform)
				w_uniform.add_fingerprint(M)

			//Accidental gun discharge
			if(!skillcheck(M, SKILL_CQC, SKILL_CQC_SKILLED))
				if (isgun(r_hand) || isgun(l_hand))
					var/obj/item/weapon/gun/W = null
					var/chance = 0

					if (isgun(l_hand))
						W = l_hand
						chance = hand ? 40 : 20

					if (isgun(r_hand))
						W = r_hand
						chance = !hand ? 40 : 20

					if (prob(chance))
						visible_message(SPAN_DANGER("[src]'s [W.name] goes off during the struggle!"), null, null, 5)
						var/list/turfs = list()
						for(var/turf/T in view())
							turfs += T
						var/turf/target = pick(turfs)
						count_niche_stat(STATISTICS_NICHE_DISCHARGE)

						attack_log += "\[[time_stamp()]\] <b>[key_name(src)]</b> accidentally fired <b>[W.name]</b> in [get_area(src)] triggered by <b>[key_name(M)]</b>."
						M:attack_log += "\[[time_stamp()]\] <b>[key_name(src)]</b> accidentally fired <b>[W.name]</b> in [get_area(src)] triggered by <b>[key_name(M)]</b>."
						msg_admin_attack("[key_name(src)] accidentally fired <b>[W.name]</b> in [get_area(M)] ([M.loc.x],[M.loc.y],[M.loc.z]).", M.loc.x, M.loc.y, M.loc.z)

						return W.afterattack(target,src)

			var/randn = rand(1, 100)
			if(M.skills)
				randn -= 5 * M.skills.get_skill_level(SKILL_CQC) //attacker's martial arts training

			if(skills)
				randn += 5 * skills.get_skill_level(SKILL_CQC) //defender's martial arts training


			if (randn <= 25)
				apply_effect(3, WEAKEN)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
				visible_message(SPAN_DANGER("<B>[M] has pushed [src]!</B>"), null, null, 5)
				return

			if(randn <= 60)
				//BubbleWrap: Disarming breaks a pull
				if(pulling)
					visible_message(SPAN_DANGER("<b>[M] has broken [src]'s grip on [pulling]!</B>"), null, null, 5)
					stop_pulling()
				else
					drop_held_item()
					visible_message(SPAN_DANGER("<B>[M] has disarmed [src]!</B>"), null, null, 5)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
				return


			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, 7)
			visible_message(SPAN_DANGER("<B>[M] attempted to disarm [src]!</B>"), null, null, 5)
	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return

/mob/living/carbon/human/help_shake_act(mob/living/carbon/M)
	//Target is us
	if(src == M)
		if(holo_card_color) //if we have a triage holocard printed on us, we remove it.
			holo_card_color = null
			update_targeted()
			visible_message(SPAN_NOTICE("[src] removes the holo card on [gender==MALE?"himself":"herself"]."), \
				SPAN_NOTICE("You remove the holo card on yourself."), null, 3)
			return
		check_for_injuries()
		return

	//Target is not us
	var/t_him = "it"
	if (gender == MALE)
		t_him = "him"
	else if (gender == FEMALE)
		t_him = "her"
	if (w_uniform)
		w_uniform.add_fingerprint(M)

	if(lying || sleeping)
		if(client)
			sleeping = max(0,src.sleeping-5)
		if(!sleeping)
			if(M.pulling == src && M.grab_level != GRAB_LIFTUP) //Helping someone to stand up
				M.visible_message(SPAN_NOTICE("[M] starts lifting [src] up..."),
								  SPAN_NOTICE("You start lifting [src] to help [t_him] stand up..."))
				if(do_after(M, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
					M.grab_level = GRAB_LIFTUP
					M.visible_message(SPAN_NOTICE("[M] lifts [src] up from the ground and holds [t_him], helping them to stand up."),
									SPAN_NOTICE("You lift [src] up from the ground and hold [t_him], preventing [t_him] from falling."))
					M.AddElement(/datum/element/standing_helper)

			resting = 0
			update_canmove()
		else
			M.visible_message(SPAN_NOTICE("[M] shakes [src] trying to wake [t_him] up!"), \
				SPAN_NOTICE("You shake [src] trying to wake [t_him] up!"), null, 4)
	else
		var/mob/living/carbon/human/H = M
		if(istype(H))
			H.species.hug(H, src, H.zone_selected)
		else
			M.visible_message(SPAN_NOTICE("[M] pats [src] on the back to make [t_him] feel better!"), \
				SPAN_NOTICE("You pat [src] on the back to make [t_him] feel better!"), null, 4)
			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 5)
		return

	AdjustKnockedout(-3)
	AdjustStunned(-3)
	AdjustKnockeddown(-3)

	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)

/mob/living/carbon/human/proc/check_for_injuries()
	visible_message(SPAN_NOTICE("[src] examines \himself."), \
	SPAN_NOTICE("You check yourself for injuries."), null, 3)

	var/dat
	var/count
	var/severe //False/null = period, TRUE = exclamation mark.
	var/prosthetic

	for(var/obj/limb/org as anything in limbs)
		var/list/status = list()
		if(org.status & LIMB_DESTROYED)
			if(org.parent?.status & LIMB_DESTROYED) //The foot of a severed limb shouldn't have any conditions at all.
				count++ //Add it to the tally. The parent will show in the list, so we shouldn't get someone with no messages other than "my other limbs are ok".
				continue
			if(org.status & LIMB_AMPUTATED)
				status += "an amputated stump"
			else
				status += "a torn stump"
				severe = TRUE
		else if(org.status & LIMB_ROBOT)
			prosthetic = TRUE
			if(org.status & LIMB_UNCALIBRATED_PROSTHETIC)
				status += " not working"
				severe = TRUE
			switch(org.brute_dam)
				if(1 to 20)
					status += "dented"
				if(20 to 40)
					status += "battered"
				if(40 to INFINITY)
					status += "mangled"
					severe = TRUE

			switch(org.burn_dam)
				if(1 to 10)
					status += "singed"
				if(10 to 40)
					status += "scorched"
				if(40 to INFINITY)
					status += "charred"
					severe = TRUE
		else
			if(org.status & LIMB_MUTATED)
				status += "weirdly shaped"
				severe = TRUE
			if(halloss > 0)
				status += "tingling"
			switch(org.brute_dam)
				if(1 to 20)
					status += "bruised"
				if(20 to 40)
					status += "battered"
				if(40 to INFINITY)
					status += "mangled"
					severe = TRUE

			switch(org.burn_dam)
				if(1 to 10)
					status += "numb"
				if(10 to 40)
					status += "blistered"
				if(40 to INFINITY)
					status += "peeling away"
					severe = TRUE

//This proc needs to display int and wounds at some point and I intend to do that, but the surgery rework majorly messes with it, so let's wait until that's merged in before poking it again. -VVanagandr
		if(org.get_incision_depth()) //Unindented because robotic and severed limbs may also have surgeries performed upon them.
			status += "cut open"

		for(var/datum/effects/bleeding/external/E in org.bleeding_effects_list)
			status += "bleeding"
			break

		var/limb_surgeries = org.get_active_limb_surgeries()
		if(limb_surgeries)
			status += "undergoing [limb_surgeries]"

		var/postscript
		/*if(org.status & LIMB_BROKEN)
			postscript += " <b>(BROKEN)</b>"*/

		if(length(status) || postscript)
			count++
			dat += "\t My [prosthetic && !isSpeciesSynth(src) ? "cybernetic " : ""][org.display_name] is [SPAN_ALERT("[english_list(status, nothing_text = "OK", final_comma_text = ",")][severe ? "!" : "."][postscript]")]\n"

	switch(count)
		if(null)
			dat += SPAN_HELPFUL("\t I'm OK.\n")
		if(1 to HUMAN_LIMB_AMOUNT - 2)
			dat += SPAN_HELPFUL("\t My other limbs are OK.\n")
		if(HUMAN_LIMB_AMOUNT - 1)
			dat += SPAN_HELPFUL("\t My other limb is OK.\n")
	
	dat += "<a href='?src=\ref[src];limbitems=1'>Check limb items</a>"
	to_chat(src, dat)
