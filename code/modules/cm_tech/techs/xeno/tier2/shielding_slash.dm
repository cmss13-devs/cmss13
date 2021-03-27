/datum/tech/xeno/shielding_slash
	name = "Shielding Slash Evolution"
	desc = "Every time a xenomorph slashes a marine enough times, they'll get protection."

	var/stat_name = "Shielding Slash Shield"

	flags = TREE_FLAG_XENO

	required_points = 25
	var/max_shield = 160
	var/shield_per_slash = 25
	tier = /datum/tier/two

/datum/tech/xeno/shielding_slash/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Slashes required to activate: [round(max_shield/shield_per_slash)]",
			"color" = "red",
			"icon" = "angry"
		),
		list(
			"content" = "Shield gained on activation: [max_shield]",
			"color" = "orange",
			"icon" = "shield-alt"
		)
	)

/datum/tech/xeno/shielding_slash/on_unlock(datum/techtree/tree)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, .proc/give_shielding_slash)

	for(var/xeno in hive.totalXenos)
		give_shielding_slash(src, xeno)

/datum/tech/xeno/shielding_slash/proc/give_shielding_slash(datum/source, mob/living/carbon/Xenomorph/X)
	SIGNAL_HANDLER
	if(X.hivenumber != hivenumber)
		return

	X.AddComponent(/datum/component/shield_slash, max_shield, shield_per_slash, stat_name)
	to_chat(X, SPAN_XENODANGER("You feel like slashing will increase your durability!"))
