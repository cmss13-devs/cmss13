
/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/

#define HANDLE_CLICK_PASS_THRU -1
#define HANDLE_CLICK_UNHANDLED 0
#define HANDLE_CLICK_HANDLED 1


/mob/living/carbon/human/click(var/atom/A, var/list/mods)
	if(mods["shift"] && !mods["middle"])
		if(selected_ability && client && client.prefs && !(client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK))
			selected_ability.use_ability(A)
			return TRUE
	
	if(mods["middle"] && !mods["shift"])
		if(selected_ability && client && client.prefs && client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK)
			selected_ability.use_ability(A)
			return TRUE

	if(interactee)
		var/result = interactee.handle_click(src, A, mods)
		if(result != HANDLE_CLICK_PASS_THRU)
			return result

	if (mods["middle"] && !mods["shift"] && ishuman(A) && get_dist(src, A) <= 1)
		var/mob/living/carbon/human/H = A
		H.receive_from(src)
		return TRUE

	return ..()

/mob/living/carbon/human/RestrainedClickOn(var/atom/A) //chewing your handcuffs
	if (A != src) return ..()
	var/mob/living/carbon/human/H = A

	if (last_chew + 75 > world.time)
		to_chat(H, SPAN_DANGER("You can't bite your hand again yet..."))
		return


	if (!H.handcuffed) return
	if (H.a_intent != INTENT_HARM) return
	if (H.zone_selected != "mouth") return
	if (H.wear_mask) return
	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket)) return

	var/obj/limb/O = H.get_limb(H.hand?"l_hand":"r_hand")
	if (!O) return

	var/s = SPAN_DANGER("[H.name] chews on \his [O.display_name]!")
	H.visible_message(s, SPAN_DANGER("You chew on your [O.display_name]!"),null, null, CHAT_TYPE_FLUFF_ACTION)
	H.attack_log += text("\[[time_stamp()]\] <font color='red'>[s] [key_name(H)]</font>")
	log_attack("[s] [key_name(H)]")

	if(O.take_damage(1,0,1,1,"teeth marks"))
		H.UpdateDamageIcon()

	last_chew = world.time

/mob/living/carbon/human/UnarmedAttack(var/atom/A, var/proximity, click_parameters)

	if(lying) //No attacks while laying down
		return 0

	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	if(proximity && istype(G) && G.Touch(A, 1))
		return

	var/obj/limb/temp = get_limb(hand ? "l_hand" : "r_hand")
	if(temp && !temp.is_usable())
		to_chat(src, SPAN_NOTICE("You try to move your [temp.display_name], but cannot!"))
		return

	A.attack_hand(src, click_parameters)

/datum/proc/handle_click(mob/living/carbon/human/user, atom/A, params) //Heres our handle click relay proc thing.
	return HANDLE_CLICK_PASS_THRU

/atom/proc/attack_hand(mob/user)
	return

/mob/living/carbon/human/MouseDrop_T(atom/dropping, mob/user)
	if(user != src)
		return . = ..()

	if(pulling != dropping || grab_level != GRAB_AGGRESSIVE || !ishuman(dropping) || !(a_intent & INTENT_GRAB))
		return . = ..()
	
	if(!skillcheck(src, SKILL_POLICE, SKILL_POLICE_MP))
		to_chat(src, SPAN_WARNING("You aren't trained to carry people!"))
		return . = ..()

	var/mob/living/carbon/human/target = dropping

	user.visible_message(SPAN_WARNING("[src] starts loading [target] onto their back."),\
	SPAN_WARNING("You start loading [target] onto your back."))

	if(!do_after(src, SECONDS_3 * get_skill_duration_multiplier(SKILL_CQC), INTERRUPT_ALL, BUSY_ICON_HOSTILE, pulling, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
		return

	user.visible_message(SPAN_WARNING("[src] loads [target] onto their back."),\
	SPAN_WARNING("You load [target] onto your back."))

	if(pulling != dropping || !dropping || QDELETED(dropping))
		return . = ..()

	grab_level = GRAB_CARRY

	target.Move(user.loc, get_dir(target.loc, user.loc))
	target.update_transform(TRUE)

	target.update_canmove()
	
		
	