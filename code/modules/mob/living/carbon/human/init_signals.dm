/mob/living/carbon/human/proc/register_human_init_signals()
	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PERK_JUGGERNAUT), PROC_REF(on_perk_juggernaut_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PERK_JUGGERNAUT), PROC_REF(on_perk_juggernaut_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PERK_SPEED), PROC_REF(on_perk_speed_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PERK_SPEED), PROC_REF(on_perk_speed_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PERK_EXPLOSIVE_RESISTANCE), PROC_REF(on_perk_explosive_resistance_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PERK_EXPLOSIVE_RESISTANCE), PROC_REF(on_perk_explosive_resistance_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PERK_REVIVE), PROC_REF(on_perk_revive_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PERK_REVIVE), PROC_REF(on_perk_revive_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PERK_GUNNUT), PROC_REF(on_perk_gunnut_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PERK_GUNNUT), PROC_REF(on_perk_gunnut_loss))

/mob/living/carbon/human/proc/on_perk_juggernaut_gain(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("You heartbeat seems stronger."))
	species.total_health += 75
	skills.set_skill(SKILL_ENDURANCE, skills.get_skill_level(SKILL_ENDURANCE) + 2)

/mob/living/carbon/human/proc/on_perk_juggernaut_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your heartbeat seems weaker."))
	species.total_health = initial(species.total_health)
	skills.set_skill(SKILL_ENDURANCE, skills.get_skill_level(SKILL_ENDURANCE) - 2)

/mob/living/carbon/human/proc/on_perk_speed_gain(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body feels much more tense."))
	extra_move_delay_modifier -= 0.33

/mob/living/carbon/human/proc/on_perk_speed_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body seems to relax."))
	extra_move_delay_modifier += 0.33

/mob/living/carbon/human/proc/on_perk_explosive_resistance_gain(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body feels much sturdier."))

/mob/living/carbon/human/proc/on_perk_explosive_resistance_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body feels squisher."))

/mob/living/carbon/human/proc/on_perk_revive_gain(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("You feel like you have another chance at life."))

/mob/living/carbon/human/proc/on_perk_revive_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("You doubt you'll get another chance like that, though."))

/mob/living/carbon/human/proc/on_perk_gunnut_gain(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your eyes feel much sharper, and your hands stop shaking completely."))
	skills.set_skill(SKILL_FIREARMS, skills.get_skill_level(SKILL_FIREARMS) + 2)

/mob/living/carbon/human/proc/on_perk_gunnut_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your eyesight begins to deteriorate, and your hands begin shaking again."))
	skills.set_skill(SKILL_FIREARMS, skills.get_skill_level(SKILL_FIREARMS) - 2)
