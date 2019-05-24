/mob/living/carbon/monkey
	name = "monkey"
	voice_name = "monkey"
	speak_emote = list("chimpers")
	icon_state = "monkey1"
	icon = 'icons/mob/monkey.dmi'
	gender = NEUTER
	flags_pass = PASSTABLE
	hud_possible = list(STATUS_HUD_XENO_INFECTION)

	var/obj/item/card/id/wear_id = null // Fix for station bounced radios -- Skie
	icon_state = "monkey1"
	//var/uni_append = "12C4E2"                // Small appearance modifier for different species.
	var/list/uni_append = list(0x12C,0x4E2)    // Same as above for DNA2.
	var/update_muts = 1                        // Monkey gene must be set at start.
	var/env_low_temp_resistance = T0C + 10 //lowest temperature the monkey can handle without taking dmg (used by yiren)


/mob/living/carbon/monkey/prepare_huds()
	..()
	med_hud_set_status()
	add_to_all_mob_huds()


/mob/living/carbon/monkey/tajara
	name = "farwa"
	voice_name = "farwa"
	speak_emote = list("mews")
	icon_state = "tajkey1"
	uni_append = list(0x0A0,0xE00) // 0A0E00

/mob/living/carbon/monkey/skrell
	name = "neaera"
	voice_name = "neaera"
	speak_emote = list("squicks")
	icon_state = "skrellkey1"
	uni_append = list(0x01C,0xC92) // 01CC92

/mob/living/carbon/monkey/unathi
	name = "stok"
	voice_name = "stok"
	speak_emote = list("hisses")
	icon_state = "stokkey1"
	uni_append = list(0x044,0xC5D) // 044C5D

/mob/living/carbon/monkey/New()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	living_misc_mobs += src

	if(name == initial(name)) //To stop Pun-Pun becoming generic.
		name = "[name] ([rand(1, 1000)])"
		real_name = name

	if(gender == NEUTER)
		gender = pick(MALE, FEMALE)

	..()

/mob/living/carbon/monkey/Dispose()
	..()
	living_misc_mobs -= src

/mob/living/carbon/monkey/movement_delay()
	. = ..()

	if(reagents)
		if(reagents.has_reagent("hyperzine")) . -= 1

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 45) . += (health_deficiency / 25)

	if(bodytemperature < 283.222)
		. += (283.222 - bodytemperature) / 10 * 1.75

	. += config.monkey_delay


/mob/living/carbon/monkey/Topic(href, href_list)
	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_interaction()
		src << browse(null, t1)
	if (href_list["item"])
		if(!usr.is_mob_incapacitated() && in_range(src, usr))
			if(!usr.action_busy)
				var/slot = text2num(href_list["item"])
				var/obj/item/what = get_item_by_slot(slot)
				if(what)
					usr.stripPanelUnequip(what,src,slot)
				else
					what = usr.get_active_hand()
					usr.stripPanelEquip(what,src,slot)

	if(href_list["internal"])

		if(!usr.action_busy)
			attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their internals toggled by [usr.name] ([usr.ckey])</font>")
			usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to toggle [name]'s ([ckey]) internals</font>")
			if(internal)
				usr.visible_message(SPAN_DANGER("<B>[usr] is trying to disable [src]'s internals</B>"), null, 4)
			else
				usr.visible_message(SPAN_DANGER("<B>[usr] is trying to enable [src]'s internals.</B>"), null, 4)

			if(do_after(usr, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
				if (internal)
					internal.add_fingerprint(usr)
					internal = null
					if (hud_used && hud_used.internals)
						hud_used.internals.icon_state = "internal0"
				else
					if(istype(wear_mask, /obj/item/clothing/mask))
						if (istype(back, /obj/item/tank))
							internal = back
							visible_message("[src] is now running on internals.", null, 3)
							internal.add_fingerprint(usr)
							if (hud_used && hud_used.internals)
								hud_used.internals.icon_state = "internal1"


	..()


/mob/living/carbon/monkey/attack_paw(mob/M as mob)
	..()

	if (M.a_intent == HELP_INTENT)
		help_shake_act(M)
	else
		if ((M.a_intent == "hurt" && !( istype(wear_mask, /obj/item/clothing/mask/muzzle) )))
			if ((prob(75) && health > 0))
				playsound(loc, 'sound/weapons/bite.ogg', 25, 1)
				for(var/mob/O in viewers(src, null))
					O.show_message(SPAN_DANGER("<B>[M.name] has bit [name]!</B>"), 1)
				var/damage = rand(1, 5)
				adjustBruteLoss(damage)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
				for(var/datum/disease/D in M.viruses)
					if(istype(D, /datum/disease/jungle_fever))
						contract_disease(D,1,0)
			else
				for(var/mob/O in viewers(src, null))
					O.show_message(SPAN_DANGER("<B>[M.name] has attempted to bite [name]!</B>"), 1)
	return

/mob/living/carbon/monkey/attack_hand(mob/living/carbon/human/M as mob)
	if (!ticker)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		to_chat(M, "No attacking people at spawn, you jackass.")
		return

	if(M.gloves)
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(G.cell.charge >= 2500)
					G.cell.use(2500)
					KnockDown(5)
					if (stuttering < 5)
						stuttering = 5
					Stun(5)

					for(var/mob/O in viewers(src, null))
						if (O.client)
							O.show_message(SPAN_DANGER("<B>[src] has been touched with the stun gloves by [M]!</B>"), 1, SPAN_DANGER("You hear someone fall"), 2)
					return
				else
					to_chat(M, SPAN_WARNING("Not enough charge! "))
					return

	if (M.a_intent == HELP_INTENT)
		help_shake_act(M)
	else
		if (M.a_intent == "hurt")
			var/datum/unarmed_attack/attack = M.species.unarmed
			if ((prob(75) && health > 0))
				visible_message(SPAN_DANGER("<B>[M] [pick(attack.attack_verb)]ed [src]!</B>"))

				playsound(loc, "punch", 25, 1)
				var/damage = rand(5, 10)
				if (prob(40))
					damage = rand(10, 15)
					if (knocked_out < 5)
						KnockOut(rand(10, 15))
						visible_message(SPAN_DANGER("<B>[M] has knocked out [src]!</B>"))

				adjustBruteLoss(damage)

				M.attack_log += text("\[[time_stamp()]\] <font color='red'>[pick(attack.attack_verb)]ed [src.name] ([src.ckey])</font>")
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [pick(attack.attack_verb)]ed by [M.name] ([M.ckey])</font>")
				msg_admin_attack("[key_name(M)] [pick(attack.attack_verb)]ed [key_name(src)]")

				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1)
				visible_message(SPAN_DANGER("<B>[M] tried to [pick(attack.attack_verb)] [src]!</B>"))
		else
			if (M.a_intent == GRAB_INTENT)
				if(M == src || anchored)
					return 0

				M.start_pulling(src)
				return 1
			else
				if (!( knocked_out ))
					if (prob(25))
						KnockOut(2)
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1)
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(SPAN_DANGER("<B>[M] has pushed down [name]!</B>"), 1)
					else
						drop_held_item()
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1)
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(SPAN_DANGER("<B>[M] has disarmed [name]!</B>"), 1)
	return

/mob/living/carbon/monkey/attack_animal(mob/living/M as mob)
	if (!..())
		return 0

	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 25, 1)
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_DANGER("<B>[M]</B> [M.attacktext] [src]!"), 1)
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()

	return 1


/mob/living/carbon/monkey/Stat()
	stat(null, text("Intent: []", a_intent))
	stat(null, text("Move Mode: []", m_intent))

/mob/living/carbon/monkey/verb/removeinternal()
	set name = "Remove Internals"
	set category = "IC"
	internal = null
	return


/mob/living/carbon/monkey/emp_act(severity)
	if(wear_id) wear_id.emp_act(severity)
	..()

/mob/living/carbon/monkey/IsAdvancedToolUser()//Unless its monkey mode monkeys cant use advanced tools
	if(universal_speak == 1)
		return 1
	return 0

/mob/living/carbon/monkey/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/italics=0, var/message_range = world.view, var/list/used_radios = list())
        if(stat)
                return

        if(copytext(message,1,2) == "*")
                return emote(copytext(message,2))

        if(stat)
                return

        if(speak_emote.len)
                verb = pick(speak_emote)

        message = capitalize(trim_left(message))

        ..(message, speaking, verb, alt_name, italics, message_range, used_radios)


/mob/living/carbon/monkey/rejuvenate()
	..()
	living_misc_mobs += src

/mob/living/carbon/monkey/update_sight()
	if (stat == DEAD || (XRAY in mutations))
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO
	else if (stat != DEAD)
		sight &= ~SEE_TURFS
		sight &= ~SEE_MOBS
		sight &= ~SEE_OBJS
		see_in_dark = 2
		see_invisible = SEE_INVISIBLE_LIVING
