/datum/effects/acid
	effect_name = "acid"
	duration = 20
	icon_path = 'icons/effects/status_effects.dmi'
	obj_icon_state_path = "+acid"
	mob_icon_state_path = "human_acid"
	var/damage_per_process_human = 1.25
	var/damage_per_process_object = 4
	var/acid_multiplier = 1
	/// If it's been enhanced by a spit combo to level 2 or by despoiler up to 3
	var/acid_level = 1
	var/damage_areas = list("chest","groin","l_arm","r_arm")
	var/increment_times =  list(21,30,41,50)
	var/active_for = 0
	var/hits = 1
	var/tier_max_duarions = list(20, 40, 80)


/datum/effects/acid/New(atom/A, mob/from = null, last_dmg_source = null, zone = "chest")
	..(A, from, last_dmg_source, zone)
	if(ishuman(A))
		var/mob/living/carbon/human/human = A
		human.update_effects()

	if(isobj(A))
		var/obj/O = A
		if(istype(O, /obj/structure/barricade))
			var/obj/structure/barricade/B = O
			acid_multiplier = B.burn_multiplier
		O.update_icon()

	handle_weather()

	RegisterSignal(SSdcs, COMSIG_GLOB_WEATHER_CHANGE, PROC_REF(handle_weather))

/datum/effects/acid/validate_atom(atom/A)
	if(istype(A, /obj/structure/barricade))
		return TRUE

	if(isobj(A))
		return FALSE

	if(ishuman(A))
		var/mob/living/carbon/human/human = A
		if(human.status_flags & XENO_HOST && HAS_TRAIT(human, TRAIT_NESTED) || human.stat == DEAD || HAS_TRAIT(human, TRAIT_HAULED))
			return FALSE

	. = ..()

/datum/effects/acid/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.last_damage_data = cause_data
	for(var/i in 1 to hits)
		affected_mob.apply_armoured_damage(damage_per_process_human, ARMOR_BIO, BURN, pick(damage_areas), 40)
	increment_duration()
	return TRUE

/datum/effects/acid/process_obj()
	. = ..()
	if(!.)
		return FALSE

	var/obj/affected_obj = affected_atom
	affected_obj.update_health((damage_per_process_object * acid_multiplier))

	return TRUE

/datum/effects/acid/Destroy()
	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/human = affected_atom
		human.update_effects()
		if(acid_level == 3)
			to_chat(human, SPAN_WARNING("Your armor returns to normal."))

	if(isobj(affected_atom))
		var/obj/O = affected_atom
		O.update_icon()
	return ..()


/datum/effects/acid/proc/prolong_duration()
	duration = min(duration + 10, tier_max_duarions[acid_level])

/datum/effects/acid/proc/enhance_acid(super_acid = FALSE)
	if(!super_acid && acid_level >= 2 || acid_level >= 3)
		prolong_duration()
		return

	acid_level++
	if(acid_level == 2)
		duration += 20
		acid_multiplier = 1.5
		mob_icon_state_path = "human_acid_enhanced"
	else
		duration += 40
		mob_icon_state_path = "human_acid_enhanced_super" //need sprite adjustments here

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/affected_human = affected_atom
		affected_human.update_effects()
		if(acid_level == 3)
			to_chat(affected_human, SPAN_WARNING("Your armor has been weakened."))

/datum/effects/acid/proc/increment_duration()
	active_for ++
	active_for = min(active_for, tier_max_duarions[acid_level])
	if(active_for in increment_times)
		hits ++

/datum/effects/acid/proc/cleanse_acid()
	duration -= 27
	if(duration <= 0)
		if(acid_level == 3 || ishuman(affected_atom))
			var/mob/living/carbon/human/affected_human = affected_atom
			to_chat(affected_human, SPAN_WARNING("Your armor returns to normal."))
		return TRUE
	else
		return FALSE

/datum/effects/acid/proc/handle_weather()
	SIGNAL_HANDLER

	var/area/acids_area = get_area(src)
	if(!acids_area)
		return

	if(SSweather.is_weather_event && locate(acids_area) in SSweather.weather_areas)
		//smothering_strength is 1-10, we use this to take a proportional amount off the stats
		duration -= (duration * (SSweather.weather_event_instance.fire_smothering_strength * 0.1))

		damage_per_process_human -= (damage_per_process_human * (SSweather.weather_event_instance.fire_smothering_strength * 0.1))
		damage_per_process_object -= (damage_per_process_object * (SSweather.weather_event_instance.fire_smothering_strength * 0.1))
		//ideally this would look like the rain dilutting the acid
		//but since we dont want to check every process if we're in weather etc...
		//its just a one permenant time stat change

/datum/effects/acid/proc/adjust_armor(armor, armor_type)
	if(!(armor_type == ARMOR_MELEE || armor_type == ARMOR_BIO))
		return armor

	if(acid_level != 3)
		return armor
	return max(0, armor - 15)

