#define APPLY_INTEGRITY_INCREASE_EFFECT(to_check) ((integrity_level >= to_check) && (old_level < to_check))
#define APPLY_INTEGRITY_DECREASE_EFFECT(to_check) ((old_level >= to_check) && (integrity_level < to_check))

//HEAD

/obj/limb/head/on_integrity_tier_increased(old_level)
	..()
	if(APPLY_INTEGRITY_INCREASE_EFFECT(LIMB_INTEGRITY_OKAY))
		//to_chat(owner, SPAN_DANGER("BLABLABLABLA"))
		ADD_TRAIT(owner, TRAIT_MOB_STUTTER, TRAIT_SOURCE_INTEGRITY)
		owner.speech_problem_flag = TRUE

/obj/limb/head/on_integrity_tier_lowered(old_level)
	..()
	if(APPLY_INTEGRITY_DECREASE_EFFECT(LIMB_INTEGRITY_OKAY))
		REMOVE_TRAIT(owner, TRAIT_MOB_STUTTER, TRAIT_SOURCE_INTEGRITY)

//CHEST

/obj/limb/chest/on_integrity_tier_increased(old_level)
	..()
	if(APPLY_INTEGRITY_INCREASE_EFFECT(LIMB_INTEGRITY_SERIOUS))
		to_chat(owner, SPAN_DANGER("Adrenaline puppets you for a little longer, but your wounds are nearing critical limits; no shock will patch you if you fail now!"))
		burn_multiplier = 1.65

/obj/limb/chest/on_integrity_tier_lowered(old_level)
	..()
	if(APPLY_INTEGRITY_DECREASE_EFFECT(LIMB_INTEGRITY_SERIOUS))
		burn_multiplier = 1

//GROIN

/obj/limb/groin/on_integrity_tier_increased(old_level)
	..()
	//if(APPLY_INTEGRITY_INCREASE_EFFECT())

/obj/limb/groin/on_integrity_tier_lowered(old_level)
	..()

//LEGS

/obj/limb/leg/on_integrity_tier_increased(old_level)
	..()
	if(APPLY_INTEGRITY_INCREASE_EFFECT(LIMB_INTEGRITY_SERIOUS))
		to_chat(owner, SPAN_DANGER("Your legs feels limper and weaker; perhaps climbing and dragging wouldn't be a good idea."))
		RegisterSignal(owner, COMSIG_LIVING_CLIMB_STRUCTURE, .proc/handle_climb_delay)
		RegisterSignal(owner, COMSIG_MOB_ADD_DRAG_DELAY, .proc/handle_drag_delay)

	if(APPLY_INTEGRITY_INCREASE_EFFECT(LIMB_INTEGRITY_CRITICAL))
		to_chat(owner, SPAN_DANGER("Your leg buckles and your knees flare in pain just standing up, this could be very bad if you got knocked over!"))
		RegisterSignal(owner, COMSIG_MOB_ADD_KNOCKDOWN, .proc/add_knockdown)

/obj/limb/leg/on_integrity_tier_lowered(old_level)
	..()
	if(APPLY_INTEGRITY_DECREASE_EFFECT(LIMB_INTEGRITY_SERIOUS))
		UnregisterSignal(owner, list(
			COMSIG_LIVING_CLIMB_STRUCTURE,
			COMSIG_MOB_ADD_DRAG_DELAY))

	if(APPLY_INTEGRITY_DECREASE_EFFECT(LIMB_INTEGRITY_CRITICAL))
		UnregisterSignal(owner, COMSIG_MOB_ADD_KNOCKDOWN)

/obj/limb/leg/proc/handle_climb_delay(var/mob/living/M, list/climbdata)
	SIGNAL_HANDLER
	climbdata["climb_delay"] *= 2

/obj/limb/leg/proc/handle_drag_delay(var/mob/living/M, list/dragdata)
	SIGNAL_HANDLER
	dragdata["drag_delay"] *= 1.5

/obj/limb/leg/proc/add_knockdown(var/mob/living/M, list/knockdowndata)
	SIGNAL_HANDLER
	knockdowndata["knockdown"] += 1

//TOO LAZY TO ADD THIS RN LMAO - Foolosopher
/*
#define STUMBLE_TILES_UNTIL_COLLAPSE 20

#define WARNING_MESSAGE STUMBLE_TILES_UNTIL_COLLAPSE * 0.3
#define DANGER_MESSAGE STUMBLE_TILES_UNTIL_COLLAPSE * 0.6

#define MESSAGE_COOLDOWN 1.5 SECONDS

/datum/limb_wound/severely_torn_ligaments
	name = "Severely Torn Ligaments"
	var/steps_walking
	var/last_message_time
	var/datum/action/human_action/rest_legs/bound_action

/datum/limb_wound/severely_torn_ligaments/new_wound_message()
	to_chat(owner, SPAN_HIGHDANGER("You hear a sound like paper tearing inside of your [affected_limb.display_name] and your next step is noticeably painful. You should probably find a cane or a doctor."))
	//todo add rip sound

/datum/limb_wound/severely_torn_ligaments/apply_debuffs()
	..()
	RegisterSignal(owner, COMSIG_MOVABLE_TURF_ENTERED, .proc/stumble)
	give_action(owner, /datum/action/human_action/rest_legs, null, null, src)

/datum/limb_wound/severely_torn_ligaments/remove_debuffs()
	..()
	UnregisterSignal(owner, COMSIG_MOVABLE_TURF_ENTERED, .proc/stumble)
	bound_action.unique_remove_action(owner, /datum/action/human_action/rest_legs, src)

/datum/limb_wound/severely_torn_ligaments/proc/stumble(var/mob/living/M)
	SIGNAL_HANDLER

	if(HAS_TRAIT(M, TRAIT_HOLDS_CANE))
		if(last_message_time + MESSAGE_COOLDOWN * 10 < world.time) //longer cooldown if using canes
			M.visible_message(SPAN_NOTICE("[M] paces \his movement with \his cane."), SPAN_NOTICE("Your cane lets you pace your movement, lessening the suffering on your [affected_limb.display_name]."))
			last_message_time = world.time //has the unfortunate downside of showing those messages when forcibly moved (thrown), but oh well
		steps_walking = max(steps_walking - 1, 0)
		return

	steps_walking++

	switch(steps_walking)
		if(WARNING_MESSAGE to DANGER_MESSAGE)
			if(last_message_time + MESSAGE_COOLDOWN < world.time)
				to_chat(M, SPAN_WARNING("Your damaged [affected_limb.display_name] skips half a step as you lose control of it from the increasing pain."))
				last_message_time = world.time
		if(DANGER_MESSAGE to STUMBLE_TILES_UNTIL_COLLAPSE)
			if(last_message_time + MESSAGE_COOLDOWN < world.time)
				to_chat(M, SPAN_DANGER("You stumble for an agonizing moment as your [affected_limb.display_name] rebels against you. You feel like you need to take a breath before walking again."))
				last_message_time = world.time
		if(STUMBLE_TILES_UNTIL_COLLAPSE to INFINITY)
			to_chat(M, SPAN_HIGHDANGER("Your [affected_limb.display_name] jerks wildly from incoherent pain!"))
			steps_walking = max(steps_walking - WARNING_MESSAGE, 0) //pity reduction
			var/stun_time = 3 SECONDS
			M.Shake(15, 0, stun_time)
			INVOKE_ASYNC(M, /mob/living/carbon/human.proc/emote, "pain")
			M.Stun(stun_time * 0.1) //already are seconds in Stun()
			addtimer(CALLBACK(src, .proc/rest_legs_pain, M, FALSE), stun_time)
			return

	INVOKE_ASYNC(src, .proc/rest_legs, M, FALSE)

/datum/limb_wound/severely_torn_ligaments/proc/rest_legs_pain(var/mob/living/M, var/action = FALSE)
	to_chat(M, SPAN_NOTICE("You can move again, but you should probably rest for a bit."))
	rest_legs(M, action)

/datum/limb_wound/severely_torn_ligaments/proc/rest_legs(var/mob/living/M, var/action = FALSE)

	if(!steps_walking)
		bound_action.in_use = FALSE
		if(!action)
			return FALSE
		to_chat(M, SPAN_WARNING("Your [affected_limb.display_name] seems to be as stable as it's going to get."))
		return FALSE

	var/show_icon = action ? BUSY_ICON_FRIENDLY : NO_BUSY_ICON
	bound_action.in_use = TRUE
	if(!do_after(M, 1.5 SECONDS, INTERRUPT_MOVED, show_icon))
		bound_action.in_use = FALSE
		if(!action)
			return FALSE
		to_chat(M, SPAN_WARNING("You need to stand still to rest your [affected_limb.display_name] for a moment."))
		return FALSE

	to_chat(M, SPAN_HELPFUL("The pain in your [affected_limb.display_name] [ (steps_walking > WARNING_MESSAGE) ? "slightly abates" : "subsides"] after your short rest."))
	steps_walking = max(steps_walking - WARNING_MESSAGE, 0)
	bound_action.in_use = FALSE
	rest_legs(M, action)
	return TRUE

/datum/action/human_action/rest_legs
	name = "Rest Leg"
	action_icon_state = "stumble"
	var/in_use = FALSE
	var/datum/limb_wound/severely_torn_ligaments/bound_wound

/datum/action/human_action/rest_legs/New(target, override_icon_state, var/datum/limb_wound/severely_torn_ligaments/bound_wound)
	. = ..()
	if(bound_wound)
		name = "Rest [bound_wound.affected_limb.display_name]"
		src.bound_wound = bound_wound
		src.bound_wound.bound_action = src
	else
		CRASH("No bound wound to link action")

/datum/action/human_action/rest_legs/action_activate()
	var/mob/living/carbon/human/H = owner
	if(in_use)
		to_chat(H, SPAN_WARNING("You're already doing that!"))
		return
	in_use = bound_wound.rest_legs(H, TRUE)

// Needs unique remove action due to possibility of two of these on the same mob.
/datum/action/human_action/rest_legs/proc/unique_remove_action(mob/L, action_path, var/datum/limb_wound/severely_torn_ligaments/bound_wound)
	for(var/datum/action/A as anything in L.actions)
		if(A.type == action_path && src.bound_wound == bound_wound)
			A.remove_from(L)
			return A

/obj/item/card/id/verb/break_leg()
	set name = "Debug break leg"
	set category = "Object"
	set src in usr

	var/mob/living/carbon/human/H = usr
	var/obj/limb/leg/r_leg/RL
	for(var/obj/limb/L as anything in H.limbs)
		if(istype(L, /obj/limb/leg/r_leg))
			RL = L
	RL.integrity_damage = 200
	RL.integrity_level = 4
	to_chat(H, SPAN_HIGHDANGER("You hear a sound like paper tearing inside of your leg and your next step is noticeably painful. You should probably find a cane or a doctor."))
	RL.add_limb_wound(/datum/limb_wound/severely_torn_ligaments, LIMB_INTEGRITY_CRITICAL)

#undef STUMBLE_TILES_UNTIL_COLLAPSE

#undef WARNING_MESSAGE
#undef DANGER_MESSAGE

#undef MESSAGE_COOLDOWN
*/

//FEET

/obj/limb/foot/on_integrity_tier_increased(old_level)
	..()
	if(APPLY_INTEGRITY_INCREASE_EFFECT(LIMB_INTEGRITY_CRITICAL))
		to_chat(owner, SPAN_DANGER("You feel significantly more slower, as your feet can no longer handle your movement!"))
		RegisterSignal(owner, COMSIG_HUMAN_POST_MOVE_DELAY, .proc/increase_move_delay)

/obj/limb/foot/on_integrity_tier_lowered(old_level)
	..()
	if(APPLY_INTEGRITY_DECREASE_EFFECT(LIMB_INTEGRITY_CRITICAL))
		UnregisterSignal(owner, COMSIG_HUMAN_POST_MOVE_DELAY)

/obj/limb/foot/proc/increase_move_delay(var/mob/living/M, list/movedata)
	SIGNAL_HANDLER
	return COMPONENT_HUMAN_MOVE_DELAY_MALUS

//ARMS

/obj/limb/arm/on_integrity_tier_increased(old_level)
	..()
	var/increase_check = FALSE

	if(APPLY_INTEGRITY_INCREASE_EFFECT(LIMB_INTEGRITY_SERIOUS))
		to_chat(owner, SPAN_DANGER("You feel as if your arms have weights strapped against them, forcing you to exert yourself to raise any weapon or tool!"))
		owner.minimum_wield_delay += 5
		increase_check = TRUE
		work_delay_mult = 1.3
	else
		if(APPLY_INTEGRITY_INCREASE_EFFECT(LIMB_INTEGRITY_CONCERNING))
			increase_check = TRUE
			work_delay_mult = 2

	if(increase_check)
		to_chat(owner, SPAN_DANGER("Your arms begin to tremble in weakness; this may be horrible for any work you have planned."))
		RegisterSignal(owner, COMSIG_MOB_ADD_DELAY, .proc/increase_work_delay)

/obj/limb/arm/on_integrity_tier_lowered(old_level)
	..()
	if(APPLY_INTEGRITY_DECREASE_EFFECT(LIMB_INTEGRITY_SERIOUS))
		owner.minimum_wield_delay -= 5
		work_delay_mult = 1.3

	if(APPLY_INTEGRITY_DECREASE_EFFECT(LIMB_INTEGRITY_CONCERNING))
		work_delay_mult = 1
		UnregisterSignal(owner, COMSIG_MOB_ADD_DELAY)

/obj/limb/arm/proc/increase_work_delay(var/mob/living/M, list/delaydata)
	SIGNAL_HANDLER
	delaydata["work_delay"] *= work_delay_mult

//HANDS

/obj/limb/hand/on_integrity_tier_increased(old_level)
	..()
	if(APPLY_INTEGRITY_INCREASE_EFFECT(LIMB_INTEGRITY_OKAY))
		to_chat(owner, SPAN_DANGER("Your hands become less responsive due to the tears on them, you're definitely going to need more time to solve stuff now."))
		owner.action_delay += 8

	if(APPLY_INTEGRITY_INCREASE_EFFECT(LIMB_INTEGRITY_SERIOUS))
		to_chat(owner, SPAN_DANGER("Your hands struggle to deal with any future recoil, as the wounds eat away at your flesh and bone."))
		ADD_TRAIT(owner, TRAIT_MOB_WEAK_HANDS, TRAIT_SOURCE_INTEGRITY)

/obj/limb/hand/on_integrity_tier_lowered(old_level)
	..()
	if(APPLY_INTEGRITY_DECREASE_EFFECT(LIMB_INTEGRITY_SERIOUS))
		REMOVE_TRAIT(owner, TRAIT_MOB_WEAK_HANDS, TRAIT_SOURCE_INTEGRITY)

	if(APPLY_INTEGRITY_DECREASE_EFFECT(LIMB_INTEGRITY_OKAY))
		to_chat(owner, SPAN_DANGER("Your hands become less responsive due to the tears on them, you're definitely going to need more time to solve stuff now."))
		owner.action_delay -= 8
