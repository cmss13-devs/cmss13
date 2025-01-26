/mob/living/carbon/xenomorph/lesser_drone/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_IS_XENO|PASS_MOB_THRU_XENO|PASS_MOB_IS_HUMAN|PASS_MOB_THRU_HUMAN
		PF.flags_can_pass_all = PASS_MOB_IS_XENO|PASS_MOB_THRU_XENO|PASS_MOB_IS_HUMAN|PASS_MOB_THRU_HUMAN

/datum/xeno_strain/slave
	name = "Slave"
	description = "You lose your ability to slash and you gain damage off weeds, and gain more plasma in your pool and your build fast such a drone. Your buildings be more fragile."
	flavor_description = "Okay, okay i will work!"
	icon_state_prefix = "Slave"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/activable/tail_stab,
	)
	actions_to_add = list(/datum/action/xeno_action/activable/secrete_resin)

	behavior_delegate_type = /datum/behavior_delegate/lesser_slave

/datum/xeno_strain/slave/apply_strain(mob/living/carbon/xenomorph/lesser_drone/lesser)
	lesser.plasmapool_modifier = 1.5 // ~500
	lesser.speed_modifier = XENO_SPEED_SLOWMOD_TIER_4
	lesser.damage_modifier -= XENO_DAMAGE_MOD_LARGE
	lesser.tackle_chance_modifier -= 35
	lesser.caste.build_time_mult = BUILD_TIME_MULT_BUILDER

	lesser.recalculate_everything()

	lesser.set_resin_build_order(GLOB.resin_build_order_lesser_slave)
	for(var/datum/action/xeno_action/action in lesser.actions)

		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			if(choose_resin_ability)
				choose_resin_ability.update_button_icon(lesser.selected_resin)
				break

/datum/behavior_delegate/lesser_base/on_life()
	return

//  Смерть вне травы
/datum/behavior_delegate/lesser_slave/on_life()
	var/turf/own_turf = get_turf(bound_xeno)
	if(bound_xeno.body_position == STANDING_UP && !(own_turf.weeds && own_turf.weeds.linked_hive.hivenumber == bound_xeno.hivenumber))
		bound_xeno.adjustBruteLoss(20)

//	Способности

/datum/resin_construction/resin_turf/wall/lesser_slave
	name = "Lesser resin wall"
	desc = "Lesser resin wall."
	cost = 60
	build_path = /turf/closed/wall/resin/lesser_slave
	build_animation_effect = /obj/effect/resin_construct/weak

/turf/closed/wall/resin/lesser_slave
	name = "Lesser resin wall"
	desc = "Weird slime solidified into a wall."
	damage_cap = 600
	color = LESSER_BUILD_COLOR

/datum/resin_construction/resin_turf/membrane/lesser_slave
	name = "Lesser resin membrane"
	desc = "Resin membrane that can be seen through."
	cost = 50
	build_path = /turf/closed/wall/resin/membrane/lesser_slave
	build_animation_effect = /obj/effect/resin_construct/transparent/weak

/turf/closed/wall/resin/membrane/lesser_slave
	name = "Lesser resin membrane"
	desc = "Weird slime translucent enough to let light pass through."
	damage_cap = 200
	color = LESSER_BUILD_COLOR

/datum/resin_construction/resin_obj/door/lesser_slave
	name = "Lesser resin door"
	desc = "A resin door that only sisters may pass."
	cost = 60
	build_path = /obj/structure/mineral_door/resin/lesser_slave
	build_animation_effect = /obj/effect/resin_construct/door

/obj/structure/mineral_door/resin/lesser_slave
	name = "Lesser resin door"
	hardness = 1
	health = 300
	color = LESSER_BUILD_COLOR
