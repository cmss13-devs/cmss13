/datum/xeno_strain/carbuncle
	name = DEFENDER_CARBUNCLE
	description = "Trade some of your armor, some of your speed, and most of your normal abilities to gain fire immunity and new abilities. Being on fire adds a bit of extra damage to your slashes and tail slams. Vomit Bile can be used to immediately extinguish allies and turfs for a faster cooldown, or to cover enemies in a flammable substance; if you are on fire, you can no longer extinguish allies or turfs but will instead cut out the middleman and directly set enemies on fire! Thermoregulation only works when you are on fire and provides a 5-second buff to speed and slash speed before extinguishing you."
	flavor_description = "Shed your fear, sister. Turn it around on our foes."
	icon_state_prefix = "Carbuncle"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/onclick/tail_sweep,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/vomit_bile,
		/datum/action/xeno_action/onclick/thermoregulation,
	)

	behavior_delegate_type = /datum/behavior_delegate/defender_carbuncle

/datum/xeno_strain/carbuncle/apply_strain(mob/living/carbon/xenomorph/defender/defender)
	defender.armor_modifier -= XENO_ARMOR_MOD_SMALL
	defender.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	defender.fire_immunity = FIRE_IMMUNITY_NO_DAMAGE
	defender.remove_fire_immunity_signals()
	defender.add_fire_immunity_signals()
	defender.recalculate_stats()

/datum/behavior_delegate/defender_carbuncle
	name = "Defender Carbuncle Behavior Delegate"

	var/burning_bonus_damage = 3 // Penetrates armor, so not a large value

/datum/behavior_delegate/defender_carbuncle/on_update_icons() // Carbuncle keeps Toggle Crest Defence but has different behavior delegate, so this keeps things working properly
	if(bound_xeno.stat == DEAD)
		return

	if(bound_xeno.crest_defense && bound_xeno.health > 0)
		bound_xeno.icon_state = "Carbuncle Defender Crest"
		return TRUE

/datum/behavior_delegate/defender_carbuncle/melee_attack_additional_effects_target(mob/living/carbon/target)
	if(bound_xeno.on_fire)
		target.apply_damage(burning_bonus_damage, BURN, bound_xeno.zone_selected, sharp = FALSE, edge = FALSE)
		if(target.fire_stacks > 0)
			target.IgniteMob()

// Abilities
/datum/action/xeno_action/activable/vomit_bile/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/fendy = owner

	if(!istype(fendy) || !fendy.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!fendy.Adjacent(target_atom))
		to_chat(fendy, SPAN_XENOWARNING("We must be next to our desired target!"))

	// If targeting burning turf, extinguish it unless we're also burning
	var/turf/target_turf = get_turf(target_atom)
	for(var/obj/flamer_fire/burning in target_turf)
		if(!fendy.on_fire)
			if(!check_and_use_plasma_owner(plasma_cost * 0.25)) // Discounted plasma cost for more frequent extinguishing
				return
			qdel(burning)
			playsound(fendy, 'sound/effects/splat.ogg', 40, FALSE)
			fendy.visible_message(SPAN_XENODANGER("[fendy] regurgitates an orange bile onto [target_atom], extinguishing it!"), \
			SPAN_XENONOTICE("We regurgitate bile onto [target_atom] and extinguish it!"))
			apply_cooldown(0.2) // Ditto as with plasma
			return ..()
		else
			to_chat(fendy, SPAN_XENOWARNING("We're on fire, our bile would only add to the fire, not extinguish it!"))
			return

	var/mob/living/carbon/carbon_target = target_atom
	if(carbon_target.stat == DEAD)
		return

	// Check target; are they friend or foe?
	if(fendy.can_not_harm(target_atom))
		// If friend, check if we're on fire; we don't want to burn them, do we?
		if(fendy.on_fire)
			to_chat(fendy, SPAN_XENOWARNING("We're on fire, our bile would burn them!"))
			return
		// As we are not on fire, are they on fire?
		if(carbon_target.on_fire)
			if(!check_and_use_plasma_owner(plasma_cost * 0.5)) // Also discounted plasma cost but not as much as extinguishing turf
				return
			// If yes, extinguish them!
			carbon_target.ExtinguishMob()
			playsound(fendy, 'sound/effects/splat.ogg', 40, FALSE)
			fendy.visible_message(SPAN_XENODANGER("[fendy] regurgitates an orange bile onto [carbon_target], extinguishing them!"), \
			SPAN_XENODANGER("We regurgitate bile onto [carbon_target] and extinguish them!"))
			apply_cooldown(0.5) // Ditto to plasma
			return ..()
	// If they are not friendly however...
	else
		check_and_use_plasma_owner() // Check if we have the plasma for this. No discount for you, you're using this offensively now!
		// Check if we're on fire; if so, try to burn them!
		if(fendy.on_fire)
			if(carbon_target.TryIgniteMob(on_fire_fire_stack_amount)) // If they are not fireproof, BURN BABY BURN!
				if(ishuman(carbon_target))
					to_chat(carbon_target, SPAN_XENOHIGHDANGER("You are covered in a gross orange bile- OH FUCK, IT'S BURNING!"))
				fendy.visible_message(SPAN_XENODANGER("[fendy] regurgitates a burning orange bile onto [carbon_target], setting them on fire!"), \
				SPAN_XENODANGER("We regurgitate burning bile onto [carbon_target] and set them on fire!"))
			 // If they are fireproof, notify us that the ability didn't work!
			else
				fendy.visible_message(SPAN_XENODANGER("[fendy] regurgitates a burning orange bile onto [carbon_target], but it fails to ignite them!"), \
				SPAN_XENODANGER("We regurgitate burning bile onto [carbon_target], but it fails to ignite them!"))
		// If we are not on fire, just cover them in flammable shit
		else
			carbon_target.adjust_fire_stacks(on_fire_fire_stack_amount)
			if(ishuman(carbon_target))
				to_chat(carbon_target, SPAN_XENOHIGHDANGER("You are covered in a gross orange bile! It smells... oh God, it smells flammable!"))
			fendy.visible_message(SPAN_XENODANGER("[fendy] regurgitates an orange bile onto [carbon_target]!"), \
			SPAN_XENODANGER("We regurgitate bile onto [carbon_target], rendering them flammable!"))

		playsound(fendy, 'sound/effects/splat.ogg', 40, FALSE)
		apply_cooldown()
		return ..()

/datum/action/xeno_action/onclick/thermoregulation/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/fendy = owner

	if(!istype(fendy) || !fendy.check_state())
		return

	if(!action_cooldown_check() || !check_and_use_plasma_owner())
		return

	fendy.speed_modifier -= thermoregulate_bonus_speed
	fendy.attack_speed_modifier -= thermoregulate_attack_speed
	fendy.recalculate_speed()
	addtimer(CALLBACK(src, PROC_REF(thermoregulation_deactivate)), thermoregulate_duration)

	var/color = "#ffa95e"
	var/alpha = 50
	color += num2text(alpha, 2, 16)
	fendy.add_filter("carbuncle_boost", 1, list("type" = "outline", "color" = color, "size" = 3))

	fendy.visible_message(SPAN_XENODANGER("The flames on [fendy] flare up as it begins moving startlingly fast!"), \
	SPAN_XENODANGER("We absorb the heat energy from the fire on us to bolster ourself!"))

	fendy.emote("roar")

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/thermoregulation/proc/thermoregulation_deactivate()
	var/mob/living/carbon/xenomorph/fendy = owner

	fendy.speed_modifier += thermoregulate_bonus_speed
	fendy.attack_speed_modifier += thermoregulate_attack_speed
	fendy.recalculate_speed()
	fendy.ExtinguishMob()

	fendy.remove_filter("carbuncle_boost")

	fendy.visible_message(SPAN_XENODANGER("The fire on [fendy] dies out as they slow down!"), \
	SPAN_XENODANGER("We expend all the energy of the fire on us and return to normal!"))
