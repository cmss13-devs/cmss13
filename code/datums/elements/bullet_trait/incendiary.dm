/datum/element/bullet_trait_incendiary
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

/datum/element/bullet_trait_incendiary/proc/ignite_living(datum/source, mob/living/target, damage, damage_actual)
    SIGNAL_HANDLER

    if(!target.TryIgniteMob(burn_stacks, burn_reagent))
        return
    to_chat(target, SPAN_HIGHDANGER("You burst into flames!! Stop drop and roll!"))

/datum/element/bullet_trait_incendiary/proc/ignite_human(datum/source, mob/living/carbon/human/target, damage, damage_actual)
    SIGNAL_HANDLER

    target.adjust_fire_stacks(burn_stacks, burn_reagent)
    target.IgniteMob(TRUE)
    to_chat(target, SPAN_HIGHDANGER("You burst into flames!! Stop drop and roll!"))

/datum/element/bullet_trait_incendiary/proc/ignite_xeno(datum/source, mob/living/carbon/Xenomorph/target, damage, damage_actual)
    SIGNAL_HANDLER

    if(target.caste.fire_immune)
        if(!target.stat)
            to_chat(target, SPAN_AVOIDHARM("You shrug off some persistent flames."))
        return
    target.adjust_fire_stacks(burn_stacks/2 + round(damage_actual / 4), burn_reagent)
    target.IgniteMob()
    target.visible_message(
        SPAN_DANGER("[target] bursts into flames!"), \
        SPAN_XENODANGER("You burst into flames!! Auuugh! Resist to put out the flames!") \
    )
