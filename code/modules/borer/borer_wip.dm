/mob/living/carbon/cortical_borer/proc/transfer_host()
	set category = "Borer.Controlling"
	set name = "Transfer Host"
	set desc = "Transfer from one host to another by direct contact."

	if(!host_mob)
		to_chat(src, "You must be in a host to transfer from one to another!.")
		return FALSE
	if(stat)
		to_chat(host_mob, "You cannot infest a target in your current state.")
		return FALSE
	var/obj/item/grab/grab_effect = host_mob.get_held_item()
	if(!istype(grab_effect) || !ishuman(grab_effect.grabbed_thing))
		to_chat(host_mob, SPAN_WARNING("You need to be holding a humanoid target to do this!"))
		return FALSE
	if(host_mob.grab_level < GRAB_AGGRESSIVE)
		to_chat(host_mob, SPAN_WARNING("You need a better grip to do that!"))
		return FALSE

	var/mob/living/carbon/target = grab_effect.grabbed_thing

	if(!target || !host_mob.Adjacent(target))
		return FALSE
	if(target.stat == DEAD)
		to_chat(host_mob, SPAN_WARNING("You cannot infest the dead."))
		return FALSE
	if(target.has_brain_worms())
		to_chat(host_mob, SPAN_WARNING("You cannot infest someone who is already infested!"))
		return FALSE
	if(host_mob.is_mob_incapacitated())
		to_chat(host_mob, "You cannot infest a target in your current state.")
		return FALSE

	host_mob.visible_message(SPAN_WARNING("[src] leans forward, holding their head beside that of [target]."), SPAN_NOTICE("You position your host's head beside [target]'s, reading to crawl from one ear to another."))
	if(!do_after(host_mob, 50, INTERRUPT_ALL_OUT_OF_RANGE, BUSY_ICON_HOSTILE, target))
		host_mob.visible_message(SPAN_NOTICE("[src] draws back from [target]."), SPAN_WARNING("You withdraw back into your current host as [target] escapes your clutches."))
		return FALSE
	if(!target || !host_mob)
		return FALSE
	if(stat)
		to_chat(host_mob, SPAN_XENOWARNING("You cannot change host in your current state."))
		return FALSE
	if(!host_mob.Adjacent(target))
		to_chat(host_mob, "They are no longer in range!")
		return FALSE

	to_chat(host_mob, SPAN_NOTICE("You wiggle into [target]'s ear."))
	if(!stealthy && !target.stat)
		to_chat(target, SPAN_DANGER("Something disgusting and slimy wiggles into your ear!"))
	detach()
	leave_host()
	perform_infestation(target)
	return TRUE
