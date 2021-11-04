
/datum/limb_wound
	var/name = "Generic Wound"
	///Has this limb wound applied its debuffs?
	var/applied
	var/tier //When deciding which wound of a certain id should be kept, the higher tier wins
	var/id //Wounds of different types can share an id
	var/mob/living/carbon/human/owner
	var/obj/limb/affected_limb

/datum/limb_wound/New(owner_mob, obj/limb/limb, silent)
	owner = owner_mob
	owner.limb_wounds[limb.name] += src
	affected_limb = limb
	. = ..()

	//Listen to the signal in case the initial application is blocked
	RegisterSignal(affected_limb, COMSIG_LIMB_WOUND_STABILIZER_REMOVED, .proc/try_apply_debuffs)
	try_apply_debuffs()

	//Send a message to the victim, if necessary.
	if(!silent)
		new_wound_message()

/datum/limb_wound/Destroy(force)
	if(applied)
		remove_debuffs()
	affected_limb.limb_wounds -= src
	affected_limb = null
	owner = null
	return ..()

/datum/limb_wound/proc/new_wound_message()
	return

//Tries to apply the wound's debuffs
/datum/limb_wound/proc/try_apply_debuffs()
	SIGNAL_HANDLER
	if(check_stabilized(affected_limb) || applied)
		return
	apply_debuffs()

///Tries to remove the wound's debuffs, and the wound itself if the integrity level is below the required
/datum/limb_wound/proc/try_remove_debuffs()
	SIGNAL_HANDLER
	if(check_stabilized(affected_limb) && applied) //Only remove the debuff. Wound will try to apply the debuffs later
		remove_debuffs(affected_limb)

/datum/limb_wound/proc/check_stabilized()
	if(SEND_SIGNAL(affected_limb, COMSIG_PRE_LOCAL_WOUND_EFFECTS, type) & COMPONENT_STABILIZE_WOUND)
		return TRUE
	return FALSE

//These procs handle the effects of the debuff
/datum/limb_wound/proc/apply_debuffs()
	applied = TRUE

	UnregisterSignal(affected_limb, COMSIG_LIMB_WOUND_STABILIZER_REMOVED)
	RegisterSignal(affected_limb, COMSIG_LIMB_WOUND_STABILIZER_ADDED, .proc/try_remove_debuffs)

/datum/limb_wound/proc/remove_debuffs()
	applied = FALSE

	UnregisterSignal(affected_limb, COMSIG_LIMB_WOUND_STABILIZER_ADDED)
	RegisterSignal(affected_limb, COMSIG_LIMB_WOUND_STABILIZER_REMOVED, .proc/try_apply_debuffs)

//////////////////////////////////////////////
//			       Fractures				//
//////////////////////////////////////////////

//-----------------------------------------------

/datum/limb_wound/fracture
	name = "Fracture"
	var/grace_period = TRUE

/datum/limb_wound/fracture/new_wound_message()
	to_chat(owner, SPAN_HIGHDANGER("Something feels like it shattered in your [affected_limb.display_name], fragments ripping all over it!"))

/datum/limb_wound/fracture/apply_debuffs()
	if(grace_period)
		addtimer(CALLBACK(src, .proc/try_apply_debuffs), 8 SECONDS)
		grace_period = FALSE
	else
		..()
		RegisterSignal(owner, COMSIG_MOVABLE_MOVED, .proc/walk_damage)

/datum/limb_wound/fracture/remove_debuffs()
	..()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

/datum/limb_wound/fracture/proc/walk_damage()
	SIGNAL_HANDLER
	if((!owner.lying && world.time - owner.l_move_time > 2 SECONDS) && affected_limb.integrity_damage < LIMB_INTEGRITY_BONE_MOVEMENT_CAP)
		to_chat(owner, SPAN_WARNING("You feel your [affected_limb.display_name]'s bones shift around, further ripping and damaging it!"))
		affected_limb.take_integrity_damage(PASSIVE_INT_DAMAGE_PER_STEP)

//////////////////////////////////////////////
//			       Bleeding					//
//////////////////////////////////////////////

/datum/limb_wound/bleeding_arterial
	name = "Arterial Bleeding"
	var/datum/effects/bleeding/arterial/bleeding_effect

/datum/limb_wound/bleeding_arterial/New(owner_mob, obj/limb/limb, level, silent)
	bleeding_effect = new(owner_mob, limb, 40) //Damage doesn't matter for this but if it doesn't have some number it will qdel on process.
	STOP_PROCESSING(SSeffects, bleeding_effect) //So it doesn't apply if it's already tourniqueted.
	. = ..()

/datum/limb_wound/bleeding_arterial/Destroy(force)
	qdel(bleeding_effect)
	return ..()

/datum/limb_wound/bleeding_arterial/apply_debuffs()
	..()
	START_PROCESSING(SSeffects, bleeding_effect)

/datum/limb_wound/bleeding_arterial/remove_debuffs()
	..()
	STOP_PROCESSING(SSeffects, bleeding_effect)
