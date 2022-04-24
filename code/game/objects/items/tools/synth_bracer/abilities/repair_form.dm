#define REPAIR_COST 50

/obj/item/clothing/gloves/synth
	var/repairing = FALSE
	var/repair_form_cooldown = 15 SECONDS

/obj/item/clothing/gloves/synth/verb/repair_form_verb()
	set name = "Repair Form (50)"
	set desc = "Repair yourself at the cost of 50u of charge."
	set category = "Synthetic.SIMI"
	set src in usr

	if(!isSynth(usr))
		return

	repair_form(usr)

/obj/item/clothing/gloves/synth/proc/repair_form(mob/living/carbon/human/user)
	if(!ishuman(user) || repairing)
		return

	if(battery_charge < REPAIR_COST)
		to_chat(user, SPAN_WARNING("There is a lack of charge for that action. Charge: <b>[battery_charge]/[REPAIR_COST]</b>"))
		return

	if(user.getBruteLoss() <= 0 && user.getFireLoss() <= 0)
		to_chat(user, SPAN_WARNING("[name] beeps, \"No noticeable damage. Procedure cancelled.\""))
		return

	repairing = TRUE
	update_icon(user)

	user.visible_message(SPAN_WARNING("[name] beeps, \"Engaging the repairing process.\""), SPAN_WARNING("[name] beeps, \"Beginning to carefully examine your sustained damage.\""))
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	if(!do_after(user, 5 SECONDS, INTERRUPT_INCAPACITATED|INTERRUPT_CLICK, BUSY_ICON_FRIENDLY))
		repairing = FALSE
		update_icon(user)
		to_chat(user, SPAN_DANGER("[name] beeps, \"Repair process was cancelled.\""))
		return

	playsound(loc, 'sound/items/Welder2.ogg', 25, TRUE)
	battery_charge -= REPAIR_COST
	user.heal_overall_damage(25, 25, TRUE)
	user.pain.recalculate_pain()
	user.visible_message(SPAN_NOTICE("[name] beeps, \"Completed the repairing process. Charge now reads [battery_charge]/[initial(battery_charge)].\""))

	addtimer(CALLBACK(src, .proc/repair_form_cooldown, user), repair_form_cooldown)

/obj/item/clothing/gloves/synth/proc/repair_form_cooldown(mob/user)
	repairing = FALSE

#undef REPAIR_COST
