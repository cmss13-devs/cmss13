/datum/action/xeno_action/activable/weave_bless/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/prime_weaver/self = owner

	if (!action_cooldown_check())
		return

	if (!self.check_state())
		return

	var/mob/living/carbon/human/human = target
	if	(!ishuman(human) || !human.allow_gun_usage)
		to_chat(self, SPAN_XENOWARNING("You must target a non believer!"))
		return

	if (get_dist_sqrd(human, self) > 2)
		to_chat(self, SPAN_XENOWARNING("[target] is too far away!"))
		return

	if (human.stat == DEAD)
		to_chat(self, SPAN_XENOWARNING("[human] is dead, why would you want to touch them?"))
		return

	if (!check_and_use_plasma_owner())
		return

	human.frozen = 1
	human.update_canmove()
	human.update_xeno_hostile_hud()

	apply_cooldown()

	self.frozen = 1
	self.anchored = TRUE
	self.update_canmove()

	if (do_after(self, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		self.visible_message(SPAN_XENOHIGHDANGER("[self] floods [human]'s mind with The Weave!"), SPAN_XENOHIGHDANGER("You flood the mind of [human] with The Weave!"))

		human.apply_effect(get_xeno_stun_duration(human, 0.5), WEAKEN)

		self.animation_attack_on(human)
		self.flick_attack_overlay(human, "tail")

		human.WeaveClaim(CAUSE_WEAVER)

	self.frozen = 0
	self.anchored = FALSE
	self.update_canmove()

	unroot_human(human)

	self.visible_message(SPAN_XENODANGER("[self] rapidly slices into [human]!"))

	. = ..()
	return
