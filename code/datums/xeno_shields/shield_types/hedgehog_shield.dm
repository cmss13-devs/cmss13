// Spray shrapnel every hit
/datum/xeno_shield/hedgehog_shield
    var/ammo_type = /datum/ammo/xeno/bone_chips/spread/short_range
    var/mob/living/carbon/Xenomorph/owner = null
    var/shrapnel_amount = 6

/datum/xeno_shield/hedgehog_shield/on_hit(damage)
    if (owner)
        create_shrapnel(get_turf(owner), shrapnel_amount, null, null, ammo_type, null, owner, TRUE)
        owner.visible_message(SPAN_XENODANGER("Damaging the shield of [owner] sprays bone quills everywhere!"))
    
    . =  ..(damage)



