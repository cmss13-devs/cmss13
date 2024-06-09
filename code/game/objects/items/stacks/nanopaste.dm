/obj/item/stack/nanopaste
	name = "Polymer tape"
	singular_name = "Polymer tape"
	desc = "A roll of tape made of self bonding polymer , used for repair of synthetic and metalic instruments on the field."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "tube"

	attack_speed = 3
	amount = 10
	max_amount = 10
	w_class = SIZE_SMALL
	stack_id = "nanopaste"
	black_market_value = 25
	var/healing_time = 3 SECONDS

/obj/item/stack/nanopaste/attack(mob/living/target_living, mob/user as mob)
	if(!ishuman(target_living) || !ishuman(user))
		return
	var/mob/living/carbon/human/humanus = target_living
	var/obj/limb/target_limb = humanus.get_limb(user.zone_selected)
	if(target_limb && (target_limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))
		if(user == target_living)
			healing_time += 3 SECONDS //self healing penalty
		if(do_after(user, max(1 SECONDS, healing_time - (user.skills.get_skill_level(SKILL_ENGINEER)SECONDS)), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			if(target_limb.get_damage())
				target_limb.heal_damage(20, 20, TRUE)
				target_living.pain.recalculate_pain()
				target_living.updatehealth()
				use(1)
				user.affected_message(user,
					SPAN_HELPFUL("You apply a piece of [src] to [target_living]'s [target_limb.display_name]"),
					SPAN_HELPFUL("[user] repairs your [target_limb.display_name] with the [src]"),
					SPAN_NOTICE("[user] repairs [target_living]'s [target_limb.display_name]"))
				playsound(user, 'sound/handling/bandage.ogg', 25, 1, 2)
			else
				to_chat(user, SPAN_NOTICE("Nothing to fix here."))
