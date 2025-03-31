//used on soro boiling water

/datum/component/damage_over_time
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	/// How much to damage (negative is healing) will incorporate dmg_mult after Initialize
	var/dam_amount = 5
	/// The kind of damage to perform
	var/dam_type = BURN
	/// The desired body temperature to approach (if temp_delta specified)
	var/target_temp = T90C
	/// How much to adjust temperature each tick (does nothing if 0 - changing sign makes no difference).
	var/temp_delta = 5
	/// The kind of thing to try and locate in loc to persist the effect
	var/cause_path

	/// Parent as a human
	var/mob/living/carbon/human/human_parent

/datum/component/damage_over_time/InheritComponent(cause_path, dam_amount, dam_type, target_temp, temp_delta, synth_dmg_mult, pred_dmg_mult, warning_message)
	return // Ultimately just here to suppress named arg errors

/datum/component/damage_over_time/Initialize(cause_path, dam_amount=5, dam_type=BURN, target_temp=T90C, temp_delta=5, synth_dmg_mult=0.5, pred_dmg_mult=0.5, warning_message="You feel your body start to shake as the scalding water sears your skin, heat overwhelming your senses...")
	src.dam_amount = dam_amount
	src.dam_type = dam_type
	src.target_temp = target_temp
	src.temp_delta = temp_delta
	src.cause_path = cause_path

	human_parent = parent

	if(!ispath(cause_path))
		return COMPONENT_INCOMPATIBLE

	if(!istype(human_parent))
		return COMPONENT_INCOMPATIBLE
	if(human_parent.stat == DEAD)
		return COMPONENT_INCOMPATIBLE

	if(issynth(human_parent))
		dam_amount *= synth_dmg_mult
	else
		if(warning_message)
			to_chat(parent, SPAN_DANGER(warning_message))
		if(isyautja(human_parent))
			dam_amount *= pred_dmg_mult

	try_to_damage()

/datum/component/damage_over_time/process(delta_time)
	try_to_damage()

/datum/component/damage_over_time/proc/try_to_damage()
	if(QDELETED(human_parent) || human_parent.stat == DEAD)
		qdel(src)
		return

	var/cause = locate(cause_path) in human_parent.loc
	if(!cause) //if we are no longer on a tile with the damage causing effect, stop.
		qdel(src)
		return

	if(human_parent.body_position == STANDING_UP)
		human_parent.apply_damage(dam_amount,dam_type,"l_leg")
		human_parent.apply_damage(dam_amount,dam_type,"l_foot")
		human_parent.apply_damage(dam_amount,dam_type,"r_leg")
		human_parent.apply_damage(dam_amount,dam_type,"r_foot")
	else
		human_parent.apply_damage(5*dam_amount,dam_type)

	if(temp_delta)
		if(human_parent.bodytemperature + temp_delta < target_temp)
			human_parent.bodytemperature += temp_delta
		else if(human_parent.bodytemperature - temp_delta > target_temp)
			human_parent.bodytemperature -= temp_delta
		else
			human_parent.bodytemperature = target_temp

/datum/component/damage_over_time/RegisterWithParent()
	START_PROCESSING(SSdcs, src)

/datum/component/damage_over_time/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
