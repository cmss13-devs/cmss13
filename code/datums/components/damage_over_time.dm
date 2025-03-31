//used on soro boiling water

/datum/component/damage_over_time
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// How much to damage (negative is healing)
	var/dam_amount = 5
	/// The kind of damage to perform
	var/dam_type = BURN
	/// The desired body temperature to approach (if temp_delta specified)
	var/target_temp = T90C
	/// How much to adjust temperature each tick (does nothing if 0 - changing sign makes no difference).
	var/temp_delta = 5
	/// The kind of thing to try and locate in loc to persist the effect
	var/cause_path
	/// Damage multiplier for synthetics
	var/synth_dmg_mult = 0.5
	/// Damage multiplier for predators
	var/pred_dmg_mult = 0.5

/datum/component/damage_over_time/Initialize(cause_path, dam_amount=5, dam_type=BURN, target_temp=T90C, temp_delta=5, synth_dmg_mult=0.5, pred_dmg_mult=0.5)
	if(!parent || !ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/human_parent = parent
	src.dam_amount = dam_amount
	src.dam_type = dam_type
	src.target_temp = target_temp
	src.temp_delta = temp_delta
	src.cause_path = cause_path
	src.synth_dmg_mult = synth_dmg_mult
	src.pred_dmg_mult = pred_dmg_mult
	
	if(!ispath(cause_path)
		return COMPONENT_INCOMPATIBLE
	src.cause_path = cause_path
	src.synth_dmg_mult = synth_dmg_mult
	src.pred_dmg_mult = pred_dmg_mult
	
	if(!ispath(cause_path)
		return COMPONENT_INCOMPATIBLE

	if(human_parent.stat == DEAD)
		return COMPONENT_INCOMPATIBLE
	if(isxeno(human_parent))
		return COMPONENT_INCOMPATIBLE

	if(issynth(human_parent))
		dam_amount *= synth_dmg_mult
	else if(isyautja(human_parent))
		dam_amount *= pred_dmg_mult
	if(human_parent.body_position == STANDING_UP)
		human_parent.apply_damage(dam_amount,dam_type,"l_leg")
		human_parent.apply_damage(dam_amount,dam_type,"l_foot")
		human_parent.apply_damage(dam_amount,dam_type,"r_leg")
		human_parent.apply_damage(dam_amount,dam_type,"r_foot")
	else
		human_parent.apply_damage(5*dam_amount,dam_type)

	if(ishuman(human_parent))
		if(human_parent.bodytemperature + temp_delta < target_temp) //go up if we are below the target
			human_parent.bodytemperature += temp_delta
		else if(human_parent.bodytemperature - temp_delta > target_temp) //go down if we are above it (if you manage to get to super high temps jumping into boiling water will cool you down, yes)
			human_parent.bodytemperature -= temp_delta
		else
			human_parent.bodytemperature = target_temp //if we are within a detla's difference from the target, just set to the target
		if(!issynth(human_parent))
			to_chat(parent, SPAN_DANGER("You feel your body start to shake as the scalding water sears your skin, heat overwhelming your senses..."))

/datum/component/damage_over_time/process(delta_time)
	if(!parent)
		qdel(src)
		return
	var/mob/living/carbon/human/human_parent = parent
	if(human_parent.stat == DEAD)
		qdel(src)
		return
	var/cause = locate(cause_path) in human_parent.loc
	if(!cause) //if we are no longer on a tile with the damage causing effect, stop.
		qdel(src)
		return

	if(issynth(human_parent) || isyautja(human_parent))
		dam_amount = max(dam_mount - 0.5, 0)
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
