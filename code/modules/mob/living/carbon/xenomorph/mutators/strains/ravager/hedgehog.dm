/datum/xeno_mutator/hedgehog
	name = "STRAIN: Ravager - Hedgehog"
	description = "You lose the ability to chip shrapnel from your claws. In exchange, you grow a set of spikes that can be thrown at targets at range. You also gain the ability to spin your claws for an AOE attack."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Ravager")  	// Only Ravager.
	mutator_actions_to_remove = list("Empower (100)")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/spike_spray, /datum/action/xeno_action/activable/spin_slash)
	keystone = TRUE

/datum/xeno_mutator/hedgehog/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return	

	var/mob/living/carbon/Xenomorph/Ravager/R = MS.xeno
	R.used_lunge = FALSE
	R.used_pounce = FALSE
	R.speed_modifier -= XENO_SPEED_MOD_LARGE
	R.health_modifier -= XENO_HEALTH_MOD_MED
	R.mutation_type = RAVAGER_HEDGEHOG
	mutator_update_actions(R)
	MS.recalculate_actions(description)

/*
	SPIKE SPRAY
*/

/datum/action/xeno_action/activable/spike_spray
	name = "Spike Spray (30)"
	action_icon_state = "rav_spike"
	ability_name = "spike spray"
	macro_path = /datum/action/xeno_action/verb/verb_spike_spray
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/spike_spray/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.spike_spray(A)
	..()

/datum/action/xeno_action/activable/spike_spray/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	return !X.used_pounce

/datum/action/xeno_action/verb/verb_spike_spray()
	set category = "Alien"
	set name = "Spike Spray"
	set hidden = 1
	var/action_name = "Spike Spray (30)"
	handle_xeno_macro(src, action_name) 

/mob/living/carbon/Xenomorph/proc/spike_spray(var/turf/T)
	var/mob/living/carbon/Xenomorph/Ravager/R = src
	var/datum/caste_datum/ravager/rCaste = src.caste
	
	if(!T || T.layer >= FLY_LAYER || !isturf(loc) || !check_state() || used_pounce) 
		return

	if(!check_plasma(30))
		to_chat(src, SPAN_NOTICE("You don't have enough plasma!"))
		return

	visible_message(SPAN_XENOWARNING("\The [src] launches their spikes at [T]!"), \
	SPAN_XENOWARNING("You launch your spikes toward [T]!"))
	used_pounce = TRUE
	use_plasma(30)
	
	spin_circle()

	var/turf/target = locate(T.x, T.y, T.z)
	var/obj/item/projectile/P = new /obj/item/projectile(initial(caste_name), src, loc)
	P.generate_bullet(R.ammo)
	P.fire_at(target, src, src, R.ammo.max_range, R.ammo.shell_speed)
	playsound(src, 'sound/effects/spike_spray.ogg', 25, 1)

	spawn(rCaste.spike_shed_cooldown)
		used_pounce = FALSE
		to_chat(src, SPAN_NOTICE("Your spikes regrow. They can be launched again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()

/*
	SPIN SLASH
*/

/datum/action/xeno_action/activable/spin_slash
	name = "Spin Slash (60)"
	action_icon_state = "spin_slash"
	ability_name = "spin slash"
	macro_path = /datum/action/xeno_action/verb/verb_spin_slash
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/spin_slash/use_ability()
	var/mob/living/carbon/Xenomorph/X = owner
	X.spin_slash()
	..()

/datum/action/xeno_action/activable/spin_slash/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	return !X.used_lunge

/datum/action/xeno_action/verb/verb_spin_slash()
	set category = "Alien"
	set name = "Spin Slash"
	set hidden = 1
	var/action_name = "Spin Slash (60)"
	handle_xeno_macro(src, action_name) 

/mob/living/carbon/Xenomorph/proc/spin_slash()
	var/datum/caste_datum/ravager/rCaste = src.caste

	if (!check_state())
		return

	if (used_lunge)
		to_chat(src, SPAN_XENOWARNING("You must gather your strength before using your spin slash again."))
		return

	if (!check_plasma(60))
		to_chat(src, SPAN_XENOWARNING("You don't have enough plasma! You need [60-src.plasma_stored] more.</span>"))
		return

	visible_message(SPAN_XENOWARNING("[src] lashes out with its sycthe-like claws!"), SPAN_XENOWARNING("You unleash a flurry of slashes around you!"))

	spin_circle()

	var/sweep_range = 1
	var/list/L = orange(sweep_range)
	// Spook patrol
	src.emote("roar")

	for (var/mob/living/carbon/human/H in L)
		if(H != H.handle_barriers(src)) continue
		if(H.stat == DEAD) continue
		if(istype(H.buckled, /obj/structure/bed/nest)) continue
		step_away(H, src, sweep_range, 3)

		// MOST of the time, hit our target zone.
		var/target_zone = ran_zone("chest", 75)
		var/armor = H.getarmor(target_zone, ARMOR_MELEE)
		var/damage = armor_damage_reduction(config.marine_melee, rand(rCaste.melee_damage_lower, rCaste.melee_damage_upper)+rCaste.spin_damage_offset, armor, 10)
		
		// Flat bonus damage that ignores armor
		damage += rCaste.spin_damage_ignore_armor

		H.last_damage_mob = src
		H.last_damage_source = initial(caste_name)
		H.apply_damage(damage, BRUTE, target_zone)
		shake_camera(H, 2, 1)
		H.KnockDown(2, 1)

		to_chat(H, SPAN_DANGER("You are slashed by \the [src]'s claws!"))
		playsound(H,'sound/weapons/alien_claw_block.ogg', 50, 1)

	used_lunge = 1
	use_plasma(60)

	spawn(rCaste.spin_cooldown)
		used_lunge = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to use your spin slash again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()
