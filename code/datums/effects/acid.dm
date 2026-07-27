/datum/effects/acid
	effect_name = "acid"
	duration = 20
	icon_path = 'icons/effects/status_effects.dmi'
	obj_icon_state_path = "+acid"
	mob_icon_state_path = "human_acid"
	/// How much damage is applied per process for a mob
	var/damage_per_process_human = 1.25
	/// How much damage is applied per process for an object (will be multiplied by obj_dmg_multiplier)
	var/damage_per_process_object = 4
	/// Multiplier for damage_per_process_object
	var/obj_dmg_multiplier = 1
	/// If it's been enhanced by a spit combo to level 2 or by despoiler up to 3
	var/acid_level = 1
	/// What areas can be damaged during process_mob
	var/static/list/damage_areas = list("chest","groin","l_arm","r_arm")
	/// What multiplier_time amount increases the number of hits (must be ascending)
	var/static/list/multiplier_times = list(21, 30, 50) // 50 means 4 hits each process_mob
	/// The current amount time the acid has lasted to determine the multiplier of damage in multiplier_times
	var/multiplier_time = 0
	/// The current hit multiplier based on multiplier_time and multiplier_times
	var/hits_multiplier = 1
	/// The maximum allowed duration per acid_level
	var/static/list/tier_max_duarions = list(20, 40, 80)

/datum/effects/acid/New(atom/atom, mob/from = null, last_dmg_source = null, zone = "chest")
	..(atom, from, last_dmg_source, zone)
	if(ishuman(atom))
		var/mob/living/carbon/human/human = atom
		human.update_effects()

	if(isobj(atom))
		var/obj/obj_target = atom
		if(istype(obj_target, /obj/structure/barricade))
			var/obj/structure/barricade/barricade_targer = obj_target
			obj_dmg_multiplier = barricade_targer.burn_multiplier
		obj_target.update_icon()

	handle_weather()

	RegisterSignal(SSdcs, COMSIG_GLOB_WEATHER_CHANGE, PROC_REF(handle_weather))

/datum/effects/acid/validate_atom(atom/atom)
	if(istype(atom, /obj/structure/barricade))
		return TRUE

	if(isobj(atom))
		return FALSE

	if(ishuman(atom))
		var/mob/living/carbon/human/human = atom
		if(human.status_flags & XENO_HOST && HAS_TRAIT(human, TRAIT_NESTED) || human.stat == DEAD || HAS_TRAIT(human, TRAIT_HAULED))
			return FALSE

	return ..()

/datum/effects/acid/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.last_damage_data = cause_data
	for(var/i in 1 to hits_multiplier)
		affected_mob.apply_armoured_damage(damage_per_process_human, ARMOR_BIO, BURN, pick(damage_areas), 40)

	increment_duration()
	return TRUE

/datum/effects/acid/process_obj()
	. = ..()
	if(!.)
		return FALSE

	var/obj/affected_obj = affected_atom
	affected_obj.update_health((damage_per_process_object * obj_dmg_multiplier))

	return TRUE

/datum/effects/acid/Destroy()
	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/human = affected_atom
		human.update_effects()
		if(acid_level >= 3)
			to_chat(human, SPAN_WARNING("Your armor returns to normal."))

	if(isobj(affected_atom))
		var/obj/obj_target = affected_atom
		obj_target.update_icon()
	return ..()

/**
 *  Increases the duration capped to whatever duration the acid_level currently allows in tier_max_duarions.
 *
 * Arguments:
 * * additional_duration: How much more potential duration to attempt to add.
 */
/datum/effects/acid/proc/prolong_duration(additional_duration = 10)
	duration = min(duration + additional_duration, tier_max_duarions[acid_level])

/**
 * Increases the acid_level if possible, otherwise just prolongs the duration.
 *
 * Arguments:
 * * super_acid: Whether to allow an acid_level of 3 (Despoiler)
 */
/datum/effects/acid/proc/enhance_acid(super_acid = FALSE)
	if(!super_acid && acid_level >= 2 || acid_level >= 3)
		prolong_duration()
		return

	acid_level++
	if(acid_level == 2)
		prolong_duration(20)
		obj_dmg_multiplier = 1.5
		mob_icon_state_path = "human_acid_enhanced"
	else if(acid_level > 2)
		prolong_duration(40)
		mob_icon_state_path = "human_acid_enhanced_super" //need sprite adjustments here

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/affected_human = affected_atom
		affected_human.update_effects()
		if(acid_level == 3)
			to_chat(affected_human, SPAN_WARNING("Your armor has been weakened."))

/**
 * Counts up how long the acid has lasted to determine the hits_multiplier.
 * Calling this outside of process_mob is essentially deemed speeding up the progression.
 *
 * Arguments:
 * * amount: How much to increment progression for hits_multiplier
 */
/datum/effects/acid/proc/increment_duration(amount = 1)
	multiplier_time += amount
	hits_multiplier = 1
	for(var/threshold in multiplier_times)
		if(threshold > multiplier_time)
			break
		hits_multiplier++

/**
 * Reduces the duration of acid such as by extinguisher.
 *
 * Arguments:
 * * amount: How much to decrease the duration by.
 */
/datum/effects/acid/proc/cleanse_acid(amount = 27)
	duration -= amount
	if(duration <= 0)
		return TRUE
	return FALSE

/// Signal handler for COMSIG_GLOB_WEATHER_CHANGE to adjust duration, damage_per_process_human, and damage_per_process_object.
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
		//but since we don't want to check every process if we're in weather etc...
		//its just a one permenant time stat change

/// Getter to determine how this acid may affect armor protection.
/datum/effects/acid/proc/adjust_armor(armor, armor_type)
	if(!(armor_type == ARMOR_MELEE || armor_type == ARMOR_BIO))
		return armor

	if(acid_level != 3)
		return armor

	return max(0, armor - 15)
