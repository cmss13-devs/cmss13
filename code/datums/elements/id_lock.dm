/datum/component/id_lock
	var/registered_gid
	var/registered_name

/datum/component/id_lock/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ATTEMPTING_EQUIP, PROC_REF(handle_equip))
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(handle_attack))

/datum/component/id_lock/proc/handle_equip(source, mob/user)
	SIGNAL_HANDLER

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user

	var/obj/item/card/id/registered_id = human_user.get_idcard()

	if(!registered_id)
		if(!TIMER_COOLDOWN_CHECK(human_user, COOLDOWN_IDLOCK_TEXTALERT))
			human_user.balloon_alert(user, "requires id!")
			to_chat(human_user, SPAN_NOTICE("This item requires an ID scan to equip."))
			TIMER_COOLDOWN_START(human_user, COOLDOWN_IDLOCK_TEXTALERT, 1 SECONDS)
		return COMPONENT_CANCEL_EQUIP

	var/id_gid = registered_id.registered_gid

	if(registered_gid)
		if(registered_gid != id_gid)
			if(!TIMER_COOLDOWN_CHECK(human_user, COOLDOWN_IDLOCK_TEXTALERT))
				human_user.balloon_alert(user, "item locked!")
				to_chat(human_user, SPAN_NOTICE("This item has been locked to [registered_name]."))
				TIMER_COOLDOWN_START(human_user, COOLDOWN_IDLOCK_TEXTALERT, 1 SECONDS)
			return COMPONENT_CANCEL_EQUIP
		return

	registered_gid = id_gid
	registered_name = registered_id.registered_name
	human_user.balloon_alert(user, "item locked")

	RegisterSignal(human_user, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_HUMAN_SET_UNDEFIBBABLE
	), PROC_REF(handle_human_death))

/datum/component/id_lock/proc/handle_human_death(source)
	SIGNAL_HANDLER

	registered_gid = null
	registered_name = null

/datum/component/id_lock/proc/handle_attack(source, obj/attacking_object, mob/user)
	SIGNAL_HANDLER

	if(!registered_gid)
		return

	if(!istype(attacking_object, /obj/item/card/id))
		return

	var/obj/item/card/id/attacking_id = attacking_object

	if(attacking_id.registered_gid != registered_gid && !attacking_id.check_access(ACCESS_MARINE_CAPTAIN))
		return

	user.balloon_alert(user, "item unlocked")

	registered_gid = null
	registered_name = null
