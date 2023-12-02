/datum/element/simple_unwrench
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2
	/// If we have a delay or if the wrenching is instant
	var/has_delay = TRUE

/datum/element/simple_unwrench/Attach(datum/target, has_wrench_delay)
	. = ..()
	if(!isobj(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attack))

	if(!isnull(has_wrench_delay))
		has_delay = has_wrench_delay

/datum/element/simple_unwrench/Detach(datum/source, force)
	UnregisterSignal(source, COMSIG_PARENT_ATTACKBY)
	return ..()

/datum/element/simple_unwrench/proc/on_attack(obj/source, obj/item/weapon, mob/living/user, params)
	SIGNAL_HANDLER

	if(!HAS_TRAIT(weapon, TRAIT_TOOL_WRENCH))
		return

	if(SEND_SIGNAL(source, COMSIG_OBJ_TRY_UNWRENCH, weapon, user) & ELEMENT_OBJ_STOP_UNWRENCH)
		return COMPONENT_NO_AFTERATTACK

	if(has_delay && user.action_busy)
		return

	INVOKE_ASYNC(src, PROC_REF(handle_wrench), source, weapon, user)
	return COMPONENT_NO_AFTERATTACK

/datum/element/simple_unwrench/proc/handle_wrench(obj/source, obj/item/weapon, mob/living/user)
	// If there's a delay, take 1-4 seconds (dependent on skill) to unwrench/wrench this
	if(has_delay && !do_after(user, max(1 SECONDS, (4 SECONDS) - (user.skills.get_skill_level(SKILL_ENGINEER) * (1 SECONDS))), INTERRUPT_ALL, BUSY_ICON_BUILD))
		return

	user.visible_message(
		SPAN_NOTICE("[user] [source.anchored ? "unanchors" : "anchors"] [source]."),
		SPAN_NOTICE("You [source.anchored ? "unanchor" : "anchor"] [source]."),
		SPAN_NOTICE("You hear the sound of bolts being wrenched."),
		)
	playsound(source, 'sound/items/Ratchet.ogg', 25, 1)
	source.anchored = !source.anchored
