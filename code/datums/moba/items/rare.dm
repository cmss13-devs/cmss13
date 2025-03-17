/datum/moba_item/rare/shredder_claws
	name = "Rending Claws"
	description = "<b>Armor Shred</b><br>Remove [/datum/status_effect/stacking/rended_armor::shred_per_stack]% of anyone slashed. Stacks up to [/datum/status_effect/stacking/rended_armor::max_stacks], lasting [/datum/status_effect/stacking/rended_armor::delay_before_decay * 0.1] seconds since your last attack."
	icon_state = "red"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3
	unique = TRUE
	component_items = list(
		/datum/moba_item/uncommon/penetrating_claws,
		/datum/moba_item/common/sharp_claws,
		/datum/moba_item/common/sharp_claws,
		/datum/moba_item/common/strong_constitution,
	)

	health = 200
	attack_damage = 20

/datum/moba_item/rare/shredder_claws/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACK, PROC_REF(on_attack))

/datum/moba_item/rare/shredder_claws/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACK)

/datum/moba_item/rare/shredder_claws/proc/on_attack(datum/source, mob/living/carbon/xenomorph/attacking, damage)
	SIGNAL_HANDLER

	var/datum/status_effect/stacking/rended_armor/rended = attacking.has_status_effect(/datum/status_effect/stacking/rended_armor)
	if(!rended)
		rended = attacking.apply_status_effect(/datum/status_effect/stacking/rended_armor)
	rended.add_stacks(1)



/datum/moba_item/rare/corrosive_acid
	name = "Corrosive Acid"
	icon_state = "red"
	gold_cost = MOBA_GOLD_PER_MINUTE * 2.75
	unique = TRUE
	component_items = list(
		/datum/moba_item/uncommon/special_acid,
		/datum/moba_item/common/enlarged_plasma,
		/datum/moba_item/common/concentrated_acid,
		/datum/moba_item/common/strong_constitution,
	)

	acid_power = 85
	health = 250
	plasma = 300

/datum/moba_item/rare/corrosive_acid/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()


/datum/moba_item/rare/corrosive_acid/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()


/datum/moba_item/rare/corrosive_acid/proc/on_acid_hit()
	SIGNAL_HANDLER

	return
