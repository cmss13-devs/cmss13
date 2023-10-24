//////////////////////////// SUPPRESSOR POWERS

/datum/action/xeno_action/onclick/shift_spits/suppressor/use_ability(atom/A)
	. = ..()
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, "prae_aid")

	apply_cooldown()

/datum/action/xeno_action/onclick/charge_spit/suppressor/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	var/datum/logged_spit_datum = X.ammo
	..()

	if(logged_spit_datum.type == /datum/ammo/xeno/sticky/heal)
		X.ammo = GLOB.ammo_list[/datum/ammo/xeno/sticky/heal/strong]
	else
		X.ammo = GLOB.ammo_list[/datum/ammo/xeno/sticky/strong]

/datum/action/xeno_action/onclick/charge_spit/suppressor/disable_spatter(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	var/datum/logged_spit_datum = X.ammo
	if(logged_spit_datum.type in X.spit_types)
		return
	..()

	if(logged_spit_datum.type == /datum/ammo/xeno/sticky/heal/strong)
		X.ammo = GLOB.ammo_list[/datum/ammo/xeno/sticky/heal]
	else
		X.ammo = GLOB.ammo_list[/datum/ammo/xeno/sticky]
