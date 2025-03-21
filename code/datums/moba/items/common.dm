// Utterly basic things, mostly used for a single stat boost or as components for better items
// Gold per stat values are based off of these

/datum/moba_item/common/sharp_claws
	name = "Sharpened Claws"
	icon_state = "sharpened_claws"
	gold_cost = MOBA_GOLD_PER_MINUTE

	attack_damage = 8

/datum/moba_item/common/strong_constitution
	name = "Strengthened Constitution"
	icon_state = "strengthened_constitution"
	gold_cost = MOBA_GOLD_PER_MINUTE * 1.25

	health = 150

/datum/moba_item/common/mending_carapace
	name = "Mending Carapace"
	icon_state = "mending_carapace"
	gold_cost = MOBA_GOLD_PER_MINUTE

	health_regen = 4

/datum/moba_item/common/concentrated_acid
	name = "Concentrated Acid"
	icon_state = "concentrated_acid"
	gold_cost = MOBA_GOLD_PER_MINUTE * 1.25

	acid_power = 20

/datum/moba_item/common/enlarged_plasma
	name = "Enlarged Plasma Sac"
	icon_state = "enlarged_plasma_sac"
	gold_cost = MOBA_GOLD_PER_MINUTE * 0.9

	plasma = 250

/datum/moba_item/common/accelerated_plasma_regen
	name = "Accelerated Plasma Regeneration"
	icon_state = "accelerated_plasma_regeneration"
	gold_cost = MOBA_GOLD_PER_MINUTE * 0.75

	plasma_regen = 3

/datum/moba_item/common/armor_fortification
	name = "Fortified Carapace"
	icon_state = "fortified_carapace"
	gold_cost = MOBA_GOLD_PER_MINUTE * 1.5

	armor = 5

/datum/moba_item/common/acid_armor_resist
	name = "Acid-Resistant Carapace"
	icon_state = "acid_resistant_carapace"
	gold_cost = MOBA_GOLD_PER_MINUTE * 1.5

	acid_armor = 5

/datum/moba_item/common/superior_stamina
	name = "Superior Stamina"
	icon_state = "superior_stamina"
	gold_cost = MOBA_GOLD_PER_MINUTE * 1.75

	ability_cooldown_reduction = 0.9 // 10%
