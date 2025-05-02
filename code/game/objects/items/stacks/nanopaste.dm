/obj/item/stack/nanopaste
	name = "nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/items/medical_stacks.dmi'
	icon_state = "tube"

	attack_speed = 3
	amount = 10
	max_amount = 10
	w_class = SIZE_SMALL
	stack_id = "nanopaste"
	black_market_value = 25

/obj/item/stack/nanopaste/attack(mob/living/M as mob, mob/user as mob)
	if (!istype(M) || !istype(user))
		return 0

	if (istype(M,/mob/living/carbon/human)) //Repairing robolimbs
		var/mob/living/carbon/human/H = M
		if(isspeciessynth(H) && M == user && !H.allow_gun_usage)
			to_chat(H, SPAN_WARNING("Your programming forbids you from self-repairing with \the [src]."))
			return
		var/obj/limb/S = H.get_limb(user.zone_selected)

		if (S && (S.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))
			if(S.get_damage())
				S.heal_damage(15, 15, robo_repair = 1)
				H.pain.recalculate_pain()
				H.updatehealth()
				use(1)
				var/others_msg = "\The [user] applies some nanite paste at[user != M ? " \the [M]'s" : " the"] [S.display_name] with \the [src]." // Needs to create vars for these messages because macro doesn't work otherwise
				var/user_msg = "You apply some nanite paste at [user == M ? "your" : "[M]'s"] [S.display_name]."
				user.visible_message(SPAN_NOTICE("[others_msg]"),
					SPAN_NOTICE("[user_msg]"))
			else
				to_chat(user, SPAN_NOTICE("Nothing to fix here."))

