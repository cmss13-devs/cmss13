/datum/element/bullet_trait_incendiary
	// Generic bullet trait vars
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

	var/datum/reagent/burn_reagent
	var/burn_stacks

/datum/element/bullet_trait_incendiary/Attach(datum/target, reagent = /datum/reagent/napalm/ut, stacks = 20)
	. = ..()
	if(!istype(target, /obj/item/projectile))
		return ELEMENT_INCOMPATIBLE

	if(ispath(reagent))
		var/datum/reagent/R = reagent
		burn_reagent = chemical_reagents_list[initial(R.id)]
	else
		burn_reagent = reagent
	burn_stacks = stacks

	RegisterSignal(target, COMSIG_BULLET_ACT_LIVING, .proc/ignite_living)
	RegisterSignal(target, COMSIG_BULLET_ACT_HUMAN, .proc/ignite_human)
	RegisterSignal(target, COMSIG_BULLET_ACT_XENO, .proc/ignite_xeno)

/datum/element/bullet_trait_incendiary/Detach(datum/target)
	UnregisterSignal(target, list(
		COMSIG_BULLET_ACT_LIVING,
		COMSIG_BULLET_ACT_HUMAN,
		COMSIG_BULLET_ACT_XENO
	))

	return ..()

/datum/element/bullet_trait_incendiary/proc/ignite_living(datum/target, mob/living/projectile_target, damage, damage_actual)
	SIGNAL_HANDLER

	if(!projectile_target.TryIgniteMob(burn_stacks, burn_reagent))
		return
	to_chat(projectile_target, SPAN_HIGHDANGER("You burst into flames!! Stop drop and roll!"))

/datum/element/bullet_trait_incendiary/proc/ignite_human(datum/target, mob/living/carbon/human/projectile_target, damage, damage_actual)
	SIGNAL_HANDLER

	projectile_target.adjust_fire_stacks(burn_stacks, burn_reagent)
	projectile_target.IgniteMob(TRUE)
	to_chat(projectile_target, SPAN_HIGHDANGER("You burst into flames!! Stop drop and roll!"))

/datum/element/bullet_trait_incendiary/proc/ignite_xeno(datum/target, mob/living/carbon/Xenomorph/projectile_target, damage, damage_actual)
	SIGNAL_HANDLER

	if(projectile_target.caste.fire_immune)
		if(!projectile_target.stat)
			to_chat(projectile_target, SPAN_AVOIDHARM("You shrug off some persistent flames."))
		return
	projectile_target.adjust_fire_stacks(burn_stacks/2 + round(damage_actual / 4), burn_reagent)
	projectile_target.IgniteMob()
	projectile_target.visible_message(
		SPAN_DANGER("[projectile_target] bursts into flames!"), \
		SPAN_XENODANGER("You burst into flames!! Auuugh! Resist to put out the flames!") \
	)
