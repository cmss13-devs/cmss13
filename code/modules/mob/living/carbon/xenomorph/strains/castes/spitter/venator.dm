/datum/xeno_strain/venator
	name = SPITTER_VENATOR
	description = ""
	flavor_description = ""
	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab/spitter,
		/datum/action/xeno_action/activable/xeno_spit/spitter,
		/datum/action/xeno_action/onclick/charge_spit,
		/datum/action/xeno_action/activable/spray_acid/spitter,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/corosive_spit,
		/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/acid_blob,
		/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/enzymatic_breath,
		/datum/action/xeno_action/onclick/store_acid,
	)
	behavior_delegate_type = /datum/behavior_delegate/spitter_venator

/datum/xeno_strain/venator/apply_strain(mob/living/carbon/xenomorph/spitter/spitter)
	if(!istype(spitter))
		return FALSE

	spitter.tileoffset = 0
	spitter.armor_modifier += XENO_ARMOR_MOD_SMALL // 25 armor
	spitter.health_modifier -= XENO_HEALTH_MOD_SMALL_MED // 500 hp

	spitter.speed_modifier += XENO_SPEED_TIER_2
	spitter.recalculate_everything()

/datum/action/xeno_action/activable/xeno_spit/bombard/venetor
	xeno_cooldown = 11 SECONDS
	cooldown_duration = 11 SECONDS
	var/stored_cooldown = 1 SECONDS
	action_types_to_cd = list(
		/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/corosive_spit,
		/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/acid_blob,
		/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/enzymatic_breath,
	)
	var/second_cooldown_duration = 4 SECONDS
	var/action_types_to_secondary_cd = list(
		/datum/action/xeno_action/onclick/store_acid,
	)
	var/datum/ammo/xeno/ammo

/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/spitter/xeno = owner
	var/datum/behavior_delegate/delegate = xeno.behavior_delegate
	var/datum/behavior_delegate/spitter_venator/venator_delegate
	if(istype(delegate, /datum/behavior_delegate/spitter_venator))
		venator_delegate = delegate
		if(venator_delegate.acid_stored > 0)
			cooldown_duration = stored_cooldown
	. = ..()
	cooldown_duration = initial(cooldown_duration)


	if(!action_cooldown_check()) // activate c/d only if we already spit
		if(venator_delegate)
			venator_delegate.use_acid()
		for (var/action_type in action_types_to_secondary_cd)
			var/datum/action/xeno_action/xeno_action = get_action(xeno, action_type)
			if (!istype(xeno_action))
				continue
			xeno_action.apply_cooldown_override(second_cooldown_duration)

/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/action_activate()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	xeno.ammo = GLOB.ammo_list[ammo]





/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/corosive_spit
	name = "corosive spit"
	plasma_cost = 45
	ammo = /datum/ammo/xeno/boiler_gas/acid

/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/acid_blob
	name = "acid blob"
	plasma_cost = 65
	ammo = /datum/ammo/xeno/boiler_gas

/datum/action/xeno_action/activable/xeno_spit/bombard/venetor/enzymatic_breath
	name = "enzymatic breath"
	plasma_cost = 55
	ammo = /datum/ammo/xeno/toxin

/datum/action/xeno_action/onclick/store_acid
	name = "store acid"
	xeno_cooldown = 5 SECONDS
	plasma_cost = 150

/datum/action/xeno_action/onclick/store_acid/can_use_action()
	. = ..()

	if(!.)
		return FALSE
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_venator/delegate = xeno.behavior_delegate
	if(delegate.acid_stored >= delegate.max_acid_stored)
		return FALSE

/datum/action/xeno_action/onclick/store_acid/use_ability(atom/target)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_venator/delegate = xeno.behavior_delegate
	if(!delegate)
		return
	if(!check_and_use_plasma_owner())
		return
	delegate.store_acid()
	apply_cooldown()




/datum/behavior_delegate/spitter_venator
	var/acid_stored = 0
	var/max_acid_stored = 5
	var/armor_reduction_per_stored = 5

/datum/behavior_delegate/spitter_venator/proc/store_acid()
	if(acid_stored == max_acid_stored)
		return FALSE
	acid_stored ++
	bound_xeno.armor_modifier -= armor_reduction_per_stored
	bound_xeno.recalculate_armor()
	return TRUE

/datum/behavior_delegate/spitter_venator/proc/use_acid()
	if(acid_stored == 0)
		return FALSE
	acid_stored --
	bound_xeno.armor_modifier += armor_reduction_per_stored
	bound_xeno.recalculate_armor()
	return TRUE




