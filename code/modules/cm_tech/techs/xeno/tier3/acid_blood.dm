/datum/tech/xeno/acidic_blood
	name = "Acidic Blood Evolution"
	desc = "Increases the damage of acidic blood, punishing close-ranged combatants."
	icon_state = "acid_blood"

	flags = TREE_FLAG_XENO

	required_points = 25
	tier = /datum/tier/three
	var/acid_damage_mult = 2

/datum/tech/xeno/acidic_blood/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Acid Blood Damage Increase: [(acid_damage_mult-1)*100]%",
			"color" = "xeno",
			"icon" = "biohazard"
		)
	)

/datum/tech/xeno/acidic_blood/on_unlock(datum/techtree/tree)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, .proc/register_component)

	for(var/m in hive.totalXenos)
		register_component(src, m)

/datum/tech/xeno/acidic_blood/proc/register_component(datum/source, var/mob/living/carbon/Xenomorph/X)
	SIGNAL_HANDLER
	if(X.hivenumber == hivenumber)
		RegisterSignal(X, COMSIG_XENO_DEAL_ACID_DAMAGE, .proc/handle_acid_blood)

/datum/tech/xeno/acidic_blood/proc/handle_acid_blood(var/mob/living/carbon/Xenomorph/X, var/mob/target, var/list/damage)
	SIGNAL_HANDLER
	damage["damage"] *= acid_damage_mult
