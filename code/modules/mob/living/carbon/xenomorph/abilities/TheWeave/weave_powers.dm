
/datum/action/xeno_action/onclick/exude_energy/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/self = owner
	plasma_cost = (self.plasma_max / 2)

	if (!action_cooldown_check())
		return FALSE

	if (!self.check_state())
		return FALSE

	var/datum/hive_status/mutated/weave/nexus = self.hive
	if(!istype(nexus))
		to_chat(self, SPAN_XENOWARNING("You cannot reach The Weave!"))
		return FALSE

	if(nexus.weave_energy >= nexus.weave_energy_max)
		to_chat(self, SPAN_XENOWARNING("The Weave is strong enough here already, it does not require replenishment."))
		return FALSE

	self.visible_message(SPAN_XENONOTICE("[self] begins to focus their energy!"), SPAN_XENONOTICE("You start to focus your energies!"))
	if (do_after(self, 10 SECONDS, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY))
		if (!check_and_use_plasma_owner())
			to_chat(self, SPAN_XENOWARNING("You do not have enough plasma stored to do this. You have [self.plasma_stored]/[plasma_cost]!"))
			return FALSE

		self.visible_message(SPAN_XENONOTICE("[self] exudes energy back into The Weave!"), SPAN_XENONOTICE("You release some of your energy into The Weave!"))

		nexus.weave_energy += (plasma_cost / 10)
	else
		self.visible_message(SPAN_XENOWARNING("[self] decides not to release their energy."), SPAN_XENOWARNING("You decide not to release your energy."))

	. = ..()
	return TRUE
