/datum/moba_item/uncommon/steel_carapace
	name = "Steel Carapace"
	icon_state = "steel_carapace"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3.5

	armor = 10
	acid_armor = 5

/datum/moba_item/uncommon/penetrating_claws
	name = "Penetrating Claws"
	icon_state = "penetrating_claws"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3.5

	slash_penetration = 10

/datum/moba_item/uncommon/penetrating_acid
	name = "Penetrating Acid"
	icon_state = "penetrating_acid"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3.5

	acid_penetration = 10

/datum/moba_item/uncommon/heightened_senses
	name = "Heightened Senses"
	icon_state = "heightened_senses"
	gold_cost = MOBA_GOLD_PER_MINUTE * 2

	speed = -0.1
	ability_cooldown_reduction = 0.9

/datum/moba_item/uncommon/vampiric_claws
	name = "Vampiric Slashes"
	icon_state = "vampiric_slashes"
	gold_cost = MOBA_GOLD_PER_MINUTE * 4.125

	lifesteal = 0.08
	attack_damage = 15

/datum/moba_item/uncommon/viscious_slashes
	name = "Viscious Slashes"
	icon_state = "viscious_slashes"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3.875

	attack_damage = 30

/datum/moba_item/uncommon/special_acid
	name = "Special Acid Mixture"
	icon_state = "special_acid_mixture"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3.25
	component_items = list(
		/datum/moba_item/common/accelerated_plasma_regen,
	)

	acid_power = 50
	plasma_regen = 6

/datum/moba_item/uncommon/antiheal
	name = "Mending Disruptor"
	description = "<br><b>Disruption</b><br>Upon landing an attack on a target, healing is N% less effective on them for N seconds."
	icon_state = "mending_disruptor"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3.5
	component_items = list(
		/datum/moba_item/common/sharp_claws,
	)

	attack_damage = 12
	var/healing_reduction = 0.4

/datum/moba_item/uncommon/antiheal/New(datum/moba_player/creating_player)
	. = ..()
	description = "<br><b>Disruption</b><br>Upon landing an attack on a target, healing is [healing_reduction * 100]% less effective on them for [/datum/status_effect/antiheal::duration * 0.1] seconds."

/datum/moba_item/uncommon/antiheal/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACK, PROC_REF(on_attack))

/datum/moba_item/uncommon/antiheal/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACK)

/datum/moba_item/uncommon/antiheal/proc/on_attack(mob/living/carbon/xenomorph/source, mob/living/carbon/xenomorph/attacking, damage)
	SIGNAL_HANDLER

	attacking.apply_status_effect(/datum/status_effect/antiheal)
