/datum/xeno_mutator/mender
	name = "STRAIN: Hivelord - Mender"
	description = "You weaken your connection to the resin and lose pheromones to direct resin spore clouds to support your sisters"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_HIVELORD)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/onclick/toggle_speed,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/activable/spore_puff,
		/datum/action/xeno_action/activable/spore_puff_shield,
	)
	keystone = TRUE

/datum/xeno_mutator/mender/apply_mutator(var/datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/Xenomorph/Hivelord/H = MS.xeno

	H.mutation_type = HIVELORD_MENDER
	H.set_resin_build_order(GLOB.resin_build_order_drone)
	mutator_update_actions(H)
	apply_behavior_holder(H)
	MS.recalculate_actions(description, flavor_description)

/mob/living/carbon/Xenomorph/Hivelord/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	. = ..()
	var/datum/effect_system/smoke_spread/xeno_heal_smoke/smoke
	smoke = new /datum/effect_system/smoke_spread/xeno_heal_smoke
	smoke.attach(src)
	smoke.cause_data = create_cause_data(initial(caste_type), src)
	ammo = GLOB.ammo_list[/datum/ammo/xeno/spore_cloud_green]

	update_icon_source()

/mob/living/carbon/Xenomorph/Hivelord/Destroy()
	var/datum/effect_system/smoke_spread/xeno_heal_smoke/smoke
	if(smoke)
		qdel(smoke)
		smoke = null
	. = ..()

/mob/living/carbon/Xenomorph/Hivelord/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	. = ..()
	var/datum/effect_system/smoke_spread/xeno_shield_smoke/smoke
	smoke = new /datum/effect_system/smoke_spread/xeno_shield_smoke
	smoke.attach(src)
	smoke.cause_data = create_cause_data(initial(caste_type), src)
	ammo = GLOB.ammo_list[/datum/ammo/xeno/spore_cloud_yellow]

	update_icon_source()

/mob/living/carbon/Xenomorph/Hivelord/Destroy()
	var/datum/effect_system/smoke_spread/xeno_shield_smoke/smoke
	if(smoke)
		qdel(smoke)
		smoke = null
	. = ..()
