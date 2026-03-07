////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////

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
	var/untoggleable_mode = FALSE

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

	if(untoggleable_mode)
		to_chat(user, SPAN_WARNING("You cannot toggle the mode of the [src]."))
		return

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

/obj/item/reagent_container/syringe/attackby(obj/item/syringe, mob/user)
	return

/obj/item/reagent_container/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(!target.reagents)
		return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, SPAN_DANGER("This syringe is broken!"))
		return

	var/injection_delay = 2 SECONDS
	var/injection_time = (injection_delay * user.get_skill_duration_multiplier(SKILL_MEDICAL))
	var/target_zone = user.zone_selected

	if(user.skills)
		if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("You aren't trained to use syringes..."))
			return

	var/mob/living/carbon/human/target_human
	if(ishuman(target))
		target_human = target

	if(target_human)
		var/obj/limb/affecting = target_human.get_limb(target_zone)

		if(!affecting || (affecting.status & LIMB_DESTROYED))
			var/list/obj/limb/possible_limbs = list()
			for(var/obj/limb/limbus in target_human.limbs)
				if(limbus == affecting || (limbus.status & (LIMB_DESTROYED|LIMB_ROBOT)))
					continue
				possible_limbs += limbus

			if(length(possible_limbs))
				var/obj/limb/new_affecting = pick(possible_limbs)
				to_chat(user, SPAN_NOTICE("...but you notice [target_human] [affecting ? affecting.display_name : user.zone_selected] is missing and decide to target their [new_affecting.display_name] instead."))
				target_zone = new_affecting.name
				injection_time += 2 SECONDS
			else
				return

	if(user.a_intent == INTENT_HARM && ishuman(target))
		var/mob/harming = target
		if(harming != user && harming.stat != DEAD && harming.a_intent != INTENT_HELP && !harming.is_mob_incapacitated() && (skillcheck(harming, SKILL_CQC, SKILL_CQC_SKILLED) || isyautja(harming))) // preds have null skills
			user.apply_effect(3, WEAKEN)
			harming.visible_message(SPAN_DANGER("[harming]'s reflexes kick in and knock [user] to the ground before they could use the [src]'!"),
				SPAN_WARNING("You knock [user] to the ground before they inject you!"), null, 5)
			playsound(user.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)

			harming.attack_log += text("\[[time_stamp()]\] <font color='orange'>Used CQC skill to stop [key_name(user)] harming them.</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Was stopped from harming [key_name(harming)] by their cqc skill.</font>")
			msg_admin_attack("[key_name(user)] got robusted by the CQC of [key_name(harming)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
			return

		syringestab(target, user, target_zone)
		return

	switch(mode)

		if(SYRINGE_DRAW)

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_DANGER("The syringe is full."))
				return

			if(target_human)
				var/amount = reagents.maximum_volume - reagents.total_volume
				if(target_human.get_blood_id() && reagents.has_reagent(target_human.get_blood_id()))
					to_chat(user, SPAN_DANGER("There is already a blood sample in this syringe."))
					return

				if(target_human.species.flags & NO_BLOOD)
					to_chat(user, SPAN_DANGER("You are unable to locate any blood."))
					return

				var/obj/limb/injection_limb = target_human.get_limb(target_zone)
				if(injection_limb)
					var/obj/item/blocker = target_human.get_sharp_obj_blocker(injection_limb)
					if(blocker)
						injection_delay = 3 SECONDS
						if(user == target_human)
							user.visible_message(SPAN_DANGER("<B>[user] begins looking for a good spot to draw blood from their [blocker]!</B>"), \
								SPAN_DANGER("<B>You begin looking for a good spot to draw blood from your [blocker]!</B>"))
						else
							user.visible_message(SPAN_DANGER("<B>[user] begins looking for a good spot to draw blood from [target_human]'s [blocker]!</B>"), \
								SPAN_DANGER("<B>You begin looking for a good spot to draw blood from [target_human]'s [blocker]!</B>"))
					else
						if(user == target_human)
							user.visible_message(SPAN_DANGER("<B>[user] is trying to draw blood from themself!</B>"), \
								SPAN_DANGER("<B>You are trying to draw blood from yourself!</B>"))
						else
							user.visible_message(SPAN_DANGER("<B>[user] is trying to draw blood from [target_human]!</B>"), \
								SPAN_DANGER("<B>You are trying to draw blood from [target_human]!</B>"))

				if(!do_after(user, injection_time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return

				target_human.take_blood(src,amount)
				on_reagent_change()
				reagents.handle_reactions()
				if(user == target)
					user.visible_message(SPAN_WARNING("[user] takes a blood sample from themself."), \
						SPAN_NOTICE("You take a blood sample from yourself."), null, 4)
				else
					user.visible_message(SPAN_WARNING("[user] takes a blood sample from [target]."), \
						SPAN_NOTICE("You take a blood sample from [target]."), null, 4)
				update_icon()
				user.update_inv_l_hand()
				user.update_inv_r_hand()

			else
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

				to_chat(user, SPAN_NOTICE("You fill the syringe with [trans] units of the solution."))
				user.update_inv_l_hand()
				user.update_inv_r_hand()

			if(reagents.total_volume >= reagents.maximum_volume)
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

			if(target_human)
				if(!target_human.can_inject(user, TRUE))
					return

				var/obj/limb/injection_limb = target_human.get_limb(target_zone)
				if(injection_limb)
					var/obj/item/blocker = target_human.get_sharp_obj_blocker(injection_limb)

					if(blocker)
						injection_delay = 3 SECONDS
						if(user == target_human)
							user.visible_message(SPAN_DANGER("<B>[user] begins looking for a good spot to inject something into their [blocker]!</B>"), \
								SPAN_DANGER("<B>You begin looking for a good spot to inject something into your [blocker]!</B>"))
						else
							user.visible_message(SPAN_DANGER("<B>[user] begins looking for a good spot to inject something into [target_human]'s [blocker]!</B>"), \
								SPAN_DANGER("<B>You begin looking for a good spot to inject something into [target_human]'s [blocker]!</B>"))
					else
						if(user == target_human)
							user.visible_message(SPAN_DANGER("<B>[user] is trying to inject something into themself!</B>"), \
								SPAN_DANGER("<B>You are trying to inject something into yourself!</B>"))
						else
							user.visible_message(SPAN_DANGER("<B>[user] is trying to inject something into [target_human]!</B>"), \
								SPAN_DANGER("<B>You are trying to inject something into [target_human]!</B>"))

				if(!do_after(user, injection_time, (INTERRUPT_ALL & ~INTERRUPT_MOVED & ~INTERRUPT_NEEDHAND | INTERRUPT_OUT_OF_RANGE), BUSY_ICON_FRIENDLY, target, INTERRUPT_TARGET_IN_RANGE, BUSY_ICON_MEDICAL, status_effect = SLOW))
					return

				if(user == target)
					user.visible_message(SPAN_DANGER("[user] injects themself with the syringe!"), \
						SPAN_DANGER("You inject yourself with the syringe!"))
				else
					user.visible_message(SPAN_DANGER("[user] injects [target] with the syringe!"), \
						SPAN_DANGER("You inject [target] with the syringe!"))

				if(target != user)
					var/list/injected = list()
					for(var/datum/reagent/identification in reagents.reagent_list)
						injected += identification.name
						identification.last_source_mob = WEAKREF(user)

					var/contained = english_list(injected)
					target_human.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been injected with [src.name] by [key_name(user)]. Reagents: [contained]</font>")
					user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to inject [key_name(target_human)]. Reagents: [contained]</font>")
					msg_admin_attack("[key_name(user)] injected [key_name(target_human)] with [src.name] (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

				reagents.reaction(target, INJECTION)


			var/trans = amount_per_transfer_from_this
			if(iscarbon(target) && locate(/datum/reagent/blood) in reagents.reagent_list)
				var/mob/living/carbon/carbo = target
				carbo.inject_blood(src, amount_per_transfer_from_this, INJECTION)

			else
				var/list/reagents_in_syringe = list()
				for(var/datum/reagent/identification in reagents.reagent_list)
					reagents_in_syringe += identification.name

				var/contained = english_list(reagents_in_syringe)
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>[key_name(user)] injected [target] with a syringe (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))])</font>")
				msg_admin_niche("[key_name(user)] injected [target] with a syringe (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

				trans = reagents.trans_to(target, amount_per_transfer_from_this, method = INJECTION)

			user.update_inv_l_hand()
			user.update_inv_r_hand()
			to_chat(user, SPAN_NOTICE("You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units."))

			if(reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
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
			if(SYRINGE_DRAW)
				injoverlay = "draw"
			if(SYRINGE_INJECT)
				injoverlay = "inject"

		overlays += injoverlay

	icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "syringe10")

		filling.icon_state = "syringe[rounded_vol]"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling


/obj/item/reagent_container/syringe/proc/syringestab(mob/living/carbon/human/target, mob/living/carbon/user, target_zone = "chest")
	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(target)] with [src.name] (INTENT: [uppertext(intent_text(user.a_intent))])</font>"
	target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [key_name(user)] with [src.name] (INTENT: [uppertext(intent_text(user.a_intent))])</font>"
	msg_admin_attack("[key_name(user)] attacked [key_name(target)] with [src.name] (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

	var/obj/limb/affecting = target.get_limb(target_zone)

	var/hit_area = affecting.display_name

	if((user != target) && !(flags_item & UNBLOCKABLE) && target.check_shields("the [src.name]", get_dir(target, user)))
		return

	var/obj/item/blocker = target.get_sharp_obj_blocker(affecting)
	if(target != user && blocker)
		user.visible_message(SPAN_DANGER("<B>[user] tries to stab [target] in [hit_area] with [src], but the attack is deflected by [blocker]!</B>"))
		return

	if(user == target)
		user.visible_message(SPAN_DANGER("<B>[user] stabs their [hit_area] with [src]!</B>"), \
			SPAN_DANGER("<B>You stab your [hit_area] with [src]!</B>"))
	else
		user.visible_message(SPAN_DANGER("<B>[user] stabs [target]'s [hit_area] with [src]!</B>"), \
			SPAN_DANGER("<B>You stab [target]'s [hit_area] with [src]!</B>"))

	affecting.take_damage(3)

	reagents.reaction(target, ABSORPTION)
	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	reagents.trans_to(target, syringestab_amount_transferred, method = ABSORPTION)
	desc += " It is broken."
	mode = SYRINGE_BROKEN
	add_mob_blood(target)
	add_fingerprint(usr)
	update_icon()


/obj/item/reagent_container/syringe/ld50_syringe
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
	untoggleable_mode = TRUE // would be kind of weird for the parent specifically since it doesnt actually carry anything

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

/obj/item/reagent_container/syringe/ld50_syringe/choral

/obj/item/reagent_container/syringe/ld50_syringe/choral/Initialize()
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

/obj/item/reagent_container/syringe/robot/inaprovaline
	name = "\improper syringe (Inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."

/obj/item/reagent_container/syringe/robot/inaprovaline/Initialize()
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
