/obj/item/stack/nanopaste
	name = "nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "tube"
	
	amount = 10
	max_amount = 10
	w_class = SIZE_SMALL
	stack_id = "nanopaste"

/obj/item/stack/nanopaste/attack(mob/living/M as mob, mob/user as mob)
	if (!istype(M) || !istype(user))
		return 0
	if (isrobot(M))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = M
		if (R.getBruteLoss() || R.getFireLoss() )
			R.adjustBruteLoss(-15)
			R.adjustFireLoss(-15)
			R.updatehealth()
			use(1)
			user.visible_message(SPAN_NOTICE("\The [user] applied some [src] at [R]'s damaged areas."),\
				SPAN_NOTICE("You apply some [src] at [R]'s damaged areas."))
		else
			to_chat(user, SPAN_NOTICE("All [R]'s systems are nominal."))

	if (istype(M,/mob/living/carbon/human))		//Repairing robolimbs
		if(isSynth(M) && M == user)
			return
		var/mob/living/carbon/human/H = M
		var/obj/limb/S = H.get_limb(user.zone_selected)

		if(S.surgery_open_stage == 0)
			if (S && (S.status & LIMB_ROBOT))
				if(S.get_damage())
					S.heal_damage(15, 15, robo_repair = 1)
					H.updatehealth()
					use(1)
					var/others_msg = "\The [user] applies some nanite paste at[user != M ? " \the [M]'s" : " \the"] [S.display_name] with \the [src]." // Needs to create vars for these messages because macro doesn't work otherwise
					var/user_msg = "You apply some nanite paste at [user == M ? "your" : "[M]'s"] [S.display_name]."
					user.visible_message(SPAN_NOTICE("[others_msg]"),\
						SPAN_NOTICE("[user_msg]"))
				else
					to_chat(user, SPAN_NOTICE("Nothing to fix here."))
		else
			if (H.can_be_operated_on())
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, SPAN_NOTICE("Nothing to fix in here."))
