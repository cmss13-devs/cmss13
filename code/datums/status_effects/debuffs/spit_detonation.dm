/datum/status_effect/stacking/spit_detonation
	id = "spit_detonation"
	stack_decay = 3
	delay_before_decay = 10 SECONDS
	consumed_on_threshold = TRUE
	stack_threshold = 3
	tick_interval = 1 SECONDS
	max_stacks = 3
	alert_type = null
	var/explosion_damage = 130

/datum/status_effect/stacking/spit_detonation/on_creation(mob/living/new_owner, stacks_to_apply, explo_damage = 130)
	explosion_damage = explo_damage
	return ..()

/datum/status_effect/stacking/spit_detonation/stacks_consumed_effect()
	if(!isxeno(owner))
		return

	. = ..()
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	var/obj/item/explosive/grenade/xeno_acid_grenade/nodamage/nade = new()
	nade.cause_data = create_cause_data("acid detonation", owner)
	nade.invisibility = INVISIBILITY_MAXIMUM
	nade.forceMove(get_turf(owner))
	nade.prime()
	for(var/mob/living/carbon/xenomorph/xeno in range(3, get_turf(owner)))
		if(xeno.hivenumber != xeno_owner.hivenumber)
			continue

		if(xeno.stat == DEAD)
			continue

		var/list/armorpen_list = list()
		SEND_SIGNAL(owner, COMSIG_MOBA_GET_ACID_PENETRATION, armorpen_list)
		xeno.apply_armoured_damage(explosion_damage, ARMOR_BIO, BURN, penetration = armorpen_list[1])
		if(xeno == owner)
			to_chat(xeno, SPAN_XENOWARNING("We feel a burst of acid blast out from our wounds!"))
		else
			to_chat(xeno, SPAN_XENOWARNING("We are showered with acid exploding from [owner]!"))

	xeno_owner.visible_message(SPAN_XENOWARNING("Acid explodes from [xeno_owner]'s wounds!"))

/obj/item/explosive/grenade/xeno_acid_grenade/nodamage
	shrapnel_type = /datum/ammo/xeno/acid/prae_nade/nodamage

/datum/ammo/xeno/acid/prae_nade/nodamage
	max_range = 3
	damage = 0

/datum/ammo/xeno/acid/prae_nade/nodamage/on_hit_mob(mob/M, obj/projectile/P)
	return
