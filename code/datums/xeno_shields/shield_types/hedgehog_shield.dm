// Spray shrapnel every hit
/datum/xeno_shield/hedgehog_shield
    var/ammo_type = /datum/ammo/xeno/bone_chips/spread/short_range
    var/mob/living/carbon/Xenomorph/owner = null
    var/shrapnel_amount = 6
    var/last_proc_time

/datum/xeno_shield/hedgehog_shield/on_hit(damage)
    . =  ..(damage)
    if (last_proc_time > world.time)
        return
    if (!owner)
        return
    last_proc_time = world.time
    create_shrapnel(get_turf(owner), shrapnel_amount, null, null, ammo_type, null, owner, TRUE)
    owner.visible_message(SPAN_XENODANGER("Damaging the shield of [owner] sprays bone quills everywhere!"))

/datum/xeno_shield/hedgehog_shield/on_removal()
	. = ..()
	if(owner)
		// Remove the shield overlay early
		owner.remove_suit_layer()
    



