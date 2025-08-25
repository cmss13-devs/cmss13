////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/reagent_container/syringe
	name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/items/syringe.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	item_state = "syringe_0"
	icon_state = "0"
	matter = list("glass" = 150)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10, 15)
	volume = 15
	w_class = SIZE_TINY
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST|SLOT_EAR|SLOT_SUIT_STORE
	sharp = IS_SHARP_ITEM_SIMPLE
	transparent = TRUE
	reagent_desc_override = TRUE //uses display_contents
	var/mode = SYRINGE_DRAW

/obj/item/reagent_container/syringe/on_reagent_change()
	update_icon()

/obj/item/reagent_container/syringe/get_examine_text(mob/user)
	. = ..()
	var/pill_info = display_contents(user)
	if(pill_info)
		. += pill_info


/obj/item/reagent_container/syringe/pickup(mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_container/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/syringe/attack_self(mob/user)
	..()

	switch(mode)
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

/obj/item/reagent_container/syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_container/syringe/attackby(obj/item/I, mob/user)
	return

/obj/item/reagent_container/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(!target.reagents)
		return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, SPAN_DANGER("This syringe is broken!"))
		return

	if (user.a_intent == INTENT_HARM && ismob(target))
		var/mob/M = target
		if(M != user && M.stat != DEAD && M.a_intent != INTENT_HELP && !M.is_mob_incapacitated() && (skillcheck(M, SKILL_CQC, SKILL_CQC_SKILLED) || isyautja(M))) // preds have null skills
			user.apply_effect(3, WEAKEN)
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Used CQC skill to stop [key_name(user)] injecting them.</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Was stopped from injecting [key_name(M)] by their cqc skill.</font>")
			msg_admin_attack("[key_name(user)] got robusted by the CQC of [key_name(M)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
			M.visible_message(SPAN_DANGER("[M]'s reflexes kick in and knock [user] to the ground before they could use \the [src]'!"),
				SPAN_WARNING("You knock [user] to the ground before they inject you!"), null, 5)
			playsound(user.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
			return

		syringestab(target, user)
		return

	var/injection_time = 2 SECONDS
	if(user.skills)
		if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("You aren't trained to use syringes..."))
			return
		else
			injection_time = (injection_time*user.get_skill_duration_multiplier(SKILL_MEDICAL))


	switch(mode)
		if(SYRINGE_DRAW)

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_DANGER("The syringe is full."))
				return

			if(ismob(target))//Blood!
				if(iscarbon(target))//maybe just add a blood reagent to all mobs. Then you can suck them dry...With hundreds of syringes. Jolly good idea.
					var/amount = src.reagents.maximum_volume - src.reagents.total_volume
					var/mob/living/carbon/T = target
					if(T.get_blood_id() && reagents.has_reagent(T.get_blood_id()))
						to_chat(user, SPAN_DANGER("There is already a blood sample in this syringe"))
						return

					if(ishuman(T))
						var/mob/living/carbon/human/H = T
						if(H.species.flags & NO_BLOOD)
							to_chat(user, SPAN_DANGER("You are unable to locate any blood."))
							return
						else
							T.take_blood(src,amount)
					else
						T.take_blood(src,amount)

					on_reagent_change()
					reagents.handle_reactions()
					user.visible_message(SPAN_WARNING("[user] takes a blood sample from [target]."),
						SPAN_NOTICE("You take a blood sample from [target]."), null, 4)

			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, SPAN_DANGER("[target] is empty."))
					return

				if(!target.is_open_container() && !target.can_be_syringed())
					to_chat(user, SPAN_DANGER("You cannot directly remove reagents from this object."))
					return

				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this) // transfer from, transfer to - who cares?

				if(!trans)
					to_chat(user, SPAN_DANGER("You fail to remove reagents from [target]."))
					return

				to_chat(user, SPAN_NOTICE(" You fill the syringe with [trans] units of the solution."))
			if (reagents.total_volume >= reagents.maximum_volume)
				mode=!mode
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, SPAN_DANGER("The syringe is empty."))
				return
			if(istype(target, /obj/item/implantcase/chem))
				return

			if(!target.is_open_container() && !ismob(target) && !target.can_be_syringed())
				to_chat(user, SPAN_DANGER("You cannot directly fill this object."))
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, SPAN_DANGER("[target] is full."))
				return

			if(ismob(target))
				var/mob/living/M = target
				if(!istype(M))
					return
				if(!M.can_inject(user, TRUE))
					return
				if(target != user)

					if(ishuman(target))
						var/mob/living/carbon/human/H = target
						if(istype(H.wear_suit, /obj/item/clothing/suit/space))
							injection_time = 60

					if(injection_time != 60)
						user.visible_message(SPAN_DANGER("<B>[user] is trying to inject [target]!</B>"))
					else
						user.visible_message(SPAN_DANGER("<B>[user] begins hunting for an injection port on [target]'s suit!</B>"))

					if(!do_after(user, injection_time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
						return

					user.visible_message(SPAN_DANGER("[user] injects [target] with the syringe!"))

					var/list/injected = list()
					for(var/datum/reagent/R in src.reagents.reagent_list)
						injected += R.name
						R.last_source_mob = WEAKREF(user)
					var/contained = english_list(injected)
					M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been injected with [src.name] by [key_name(user)]. Reagents: [contained]</font>")
					user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to inject [key_name(M)]. Reagents: [contained]</font>")
					msg_admin_attack("[key_name(user)] injected [key_name(M)] with [src.name] (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

				reagents.reaction(target, INGEST)


			var/trans = amount_per_transfer_from_this
			if(iscarbon(target) && locate(/datum/reagent/blood) in reagents.reagent_list)
				var/mob/living/carbon/C = target
				C.inject_blood(src, amount_per_transfer_from_this)
			else

				var/list/reagents_in_syringe = list()
				for(var/datum/reagent/R in reagents.reagent_list)
					reagents_in_syringe += R.name
				var/contained = english_list(reagents_in_syringe)
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>[key_name(user)] injected [target] with a syringe (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))])</font>")
				msg_admin_niche("[key_name(user)] injected [target] with a syringe (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

				trans = reagents.trans_to(target, amount_per_transfer_from_this)

			to_chat(user, SPAN_NOTICE(" You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units."))
			if (reagents.total_volume <= 0 && mode==SYRINGE_INJECT)
				mode = SYRINGE_DRAW
				update_icon()


/obj/item/reagent_container/syringe/update_icon()
	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		overlays.Cut()
		return
	var/rounded_vol = round(reagents.total_volume,5)
	overlays.Cut()
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		overlays += injoverlay
	icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "syringe10")

		filling.icon_state = "syringe[rounded_vol]"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling


/obj/item/reagent_container/syringe/proc/syringestab(mob/living/carbon/target as mob, mob/living/carbon/user as mob)
	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(target)] with [src.name] (INTENT: [uppertext(intent_text(user.a_intent))])</font>"
	target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [key_name(user)] with [src.name] (INTENT: [uppertext(intent_text(user.a_intent))])</font>"
	msg_admin_attack("[key_name(user)] attacked [key_name(target)] with [src.name] (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/target_zone = rand_zone(check_zone(user.zone_selected, target))
		var/obj/limb/affecting = H.get_limb(target_zone)

		if (!affecting)
			return
		if(affecting.status & LIMB_DESTROYED)
			to_chat(user, "What [affecting.display_name]?")
			return
		var/hit_area = affecting.display_name

		if((user != target) && H.check_shields(7, "the [src.name]"))
			return

		if (target != user && target.getarmor(target_zone, ARMOR_MELEE) > 5 && prob(50))
			for(var/mob/O in viewers(GLOB.world_view_size, user))
				O.show_message(text(SPAN_DANGER("<B>[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!</B>")), SHOW_MESSAGE_VISIBLE)
			user.temp_drop_inv_item(src)
			qdel(src)
			return

		for(var/mob/O in viewers(GLOB.world_view_size, user))
			O.show_message(text(SPAN_DANGER("<B>[user] stabs [target] in \the [hit_area] with [src.name]!</B>")), SHOW_MESSAGE_VISIBLE)

		if(affecting.take_damage(3))
			target:UpdateDamageIcon()

	else
		for(var/mob/O in viewers(GLOB.world_view_size, user))
			O.show_message(text(SPAN_DANGER("<B>[user] stabs [target] with [src.name]!</B>")), SHOW_MESSAGE_VISIBLE)
		target.take_limb_damage(3)// 7 is the same as crowbar punch

	src.reagents.reaction(target, INGEST)
	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	src.reagents.trans_to(target, syringestab_amount_transferred)
	src.desc += " It is broken."
	src.mode = SYRINGE_BROKEN
	src.add_mob_blood(target)
	src.add_fingerprint(usr)
	src.update_icon()


/obj/item/reagent_container/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	icon = 'icons/obj/items/syringe.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	item_state = "syringe_0"
	icon_state = "0"
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = null //list(5,10,15)
	volume = 50
	var/mode = SYRINGE_DRAW

/obj/item/reagent_container/ld50_syringe/on_reagent_change()
	update_icon()

/obj/item/reagent_container/ld50_syringe/pickup(mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_container/ld50_syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/ld50_syringe/attack_self(mob/user)
	..()
	mode = !mode
	update_icon()

/obj/item/reagent_container/ld50_syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_container/ld50_syringe/attackby(obj/item/I, mob/user)
	return

/obj/item/reagent_container/ld50_syringe/afterattack(obj/target, mob/user , flag)
	if(!target.reagents)
		return

	switch(mode)
		if(SYRINGE_DRAW)

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_DANGER("The syringe is full."))
				return

			if(ismob(target))
				if(istype(target, /mob/living/carbon))//I Do not want it to suck 50 units out of people
					to_chat(usr, "This needle isn't designed for drawing blood.")
					return
			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, SPAN_DANGER("[target] is empty."))
					return

				if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
					to_chat(user, SPAN_DANGER("You cannot directly remove reagents from this object."))
					return

				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this) // transfer from, transfer to - who cares?

				if(!trans)
					to_chat(user, SPAN_DANGER("You fail to remove reagents from [target]."))
					return

				to_chat(user, SPAN_NOTICE(" You fill the syringe with [trans] units of the solution."))
			if (reagents.total_volume >= reagents.maximum_volume)
				mode=!mode
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, SPAN_DANGER("The Syringe is empty."))
				return
			if(istype(target, /obj/item/implantcase/chem))
				return
			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_container/food))
				to_chat(user, SPAN_DANGER("You cannot directly fill this object."))
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, SPAN_DANGER("[target] is full."))
				return

			if(ismob(target) && target != user)
				user.visible_message(SPAN_DANGER("<B>[user] is trying to inject [target] with a giant syringe!</B>"))
				if(!do_after(user, 300, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return
				user.visible_message(SPAN_DANGER("[user] injects [target] with a giant syringe!"))
				src.reagents.reaction(target, INGEST)
			if(ismob(target) && target == user)
				src.reagents.reaction(target, INGEST)
			spawn(5)
				var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
				to_chat(user, SPAN_NOTICE(" You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units."))
				if (reagents.total_volume >= reagents.maximum_volume && mode==SYRINGE_INJECT)
					mode = SYRINGE_DRAW
					update_icon()
	return


/obj/item/reagent_container/ld50_syringe/update_icon()
	var/rounded_vol = round(reagents.total_volume,50)
	if(ismob(loc))
		var/mode_t
		switch(mode)
			if (SYRINGE_DRAW)
				mode_t = "d"
			if (SYRINGE_INJECT)
				mode_t = "i"
		icon_state = "[mode_t][rounded_vol]"
	else
		icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"


////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////



/obj/item/reagent_container/syringe/inaprovaline
	name = "\improper syringe (Inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."

/obj/item/reagent_container/syringe/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/antitoxin
	name = "syringe (anti-toxin)"
	desc = "Contains anti-toxins."

/obj/item/reagent_container/syringe/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/antiviral
	name = "\improper syringe (Spaceacillin)"
	desc = "Contains antiviral agents. Can also be used to treat infected wounds."

/obj/item/reagent_container/syringe/antiviral/Initialize()
	. = ..()
	reagents.add_reagent("spaceacillin", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/counteragent
	name = "\improper syringe (Counteragent)"
	desc = "Contains special antiviral counteragents."

/obj/item/reagent_container/syringe/counteragent/Initialize()
	. = ..()
	reagents.add_reagent("vaccine", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/drugs
	name = "syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."

/obj/item/reagent_container/syringe/drugs/Initialize()
	. = ..()
	reagents.add_reagent("space_drugs",  5)
	reagents.add_reagent("mindbreaker",  5)
	reagents.add_reagent("cryptobiolin", 5)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/ld50_syringe/choral

/obj/item/reagent_container/ld50_syringe/choral/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 50)
	mode = SYRINGE_INJECT
	update_icon()


//Robot syringes
//Not special in any way, code wise. They don't have added variables or procs.
/obj/item/reagent_container/syringe/robot/antitoxin
	name = "syringe (anti-toxin)"
	desc = "Contains anti-toxins."

/obj/item/reagent_container/syringe/robot/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/robot/inoprovaline
	name = "\improper syringe (Inoprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."

/obj/item/reagent_container/syringe/robot/inoprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/robot/mixed
	name = "\improper syringe (mixed)"
	desc = "Contains inaprovaline & anti-toxins."

/obj/item/reagent_container/syringe/robot/mixed/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 7)
	reagents.add_reagent("anti_toxin", 8)
	mode = SYRINGE_INJECT
	update_icon()
