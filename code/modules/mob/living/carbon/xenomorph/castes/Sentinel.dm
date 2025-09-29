/datum/caste_datum/sentinel
	caste_type = XENO_CASTE_SENTINEL
	tier = 1

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	melee_vehicle_damage = XENO_DAMAGE_TIER_2
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_5
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_1
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	caste_desc = "A weak ranged combat alien."
	evolves_to = list(XENO_CASTE_SPITTER)
	deevolves_to = list(XENO_CASTE_LARVA)
	acid_level = 1

	tackle_min = 4
	tackle_max = 4
	tackle_chance = 50
	tacklestrength_min = 4
	tacklestrength_max = 4

	behavior_delegate_type = /datum/behavior_delegate/sentinel_base
	minimap_icon = "sentinel"

	minimum_evolve_time = 5 MINUTES

/mob/living/carbon/xenomorph/sentinel
	caste_type = XENO_CASTE_SENTINEL
	name = XENO_CASTE_SENTINEL
	desc = "A slithery, spitting kind of alien."
	icon_size = 48
	icon_state = "Sentinel Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -12
	old_x = -12
	tier = 1
	organ_value = 800
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/sentinel,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/activable/slowing_spit, //first macro
		/datum/action/xeno_action/onclick/paralyzing_slash, //third macro
		/datum/action/xeno_action/activable/draining_bite,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_1/sentinel.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_1/sentinel.dmi'

	acid_overlay = icon('icons/mob/xenos/castes/tier_1/sentinel.dmi', "Sentinel-Spit")

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")

	skull = /obj/item/skull/sentinel
	pelt = /obj/item/pelt/sentinel

/datum/behavior_delegate/sentinel_base
	name = "Base Sentinel Behavior Delegate"

	// State
	var/max_buffed_slashes = 3
	var/buffed_slashes = 0
	var/increment_amount = 7

/datum/behavior_delegate/sentinel_base/melee_attack_modify_damage(original_damage, mob/living/carbon/carbon_target)
	if (!buffed_slashes)
		return original_damage

	if (!isxeno_human(carbon_target))
		return original_damage

	if(skillcheck(carbon_target, SKILL_ENDURANCE, SKILL_ENDURANCE_MAX ))
		carbon_target.visible_message(SPAN_DANGER("[carbon_target] withstands the neurotoxin!"))
		buffed_slashes --
		return original_damage //endurance 5 makes you immune to weak neurotoxin
	if(ishuman(carbon_target))
		var/mob/living/carbon/human/human = carbon_target
		if(human.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO || human.species.flags & NO_NEURO)
			human.visible_message(SPAN_DANGER("[human] shrugs off the neurotoxin!"))
			buffed_slashes --
			return //species like zombies or synths are immune to neurotoxin
		if (buffed_slashes)
			to_chat(bound_xeno, SPAN_XENOHIGHDANGER("Our slash applied a large amount of neurotoxin!"))
			to_chat(carbon_target, SPAN_XENOHIGHDANGER("You feel your muscles, as [bound_xeno] slashes you with its neurotoxin coated claws!"))
			var/datum/effects/sentinel_neuro_stacks/sns = null
			for (var/datum/effects/sentinel_neuro_stacks/sentinel_neuro_stacks in human.effects_list)
				sns = sentinel_neuro_stacks
				break

			if (sns == null)
				sns = new /datum/effects/sentinel_neuro_stacks(human)
			sns.increment_stack_count(increment_amount)

			buffed_slashes --
	if(!buffed_slashes)
		var/datum/action/xeno_action/onclick/paralyzing_slash/ability = get_action(bound_xeno, /datum/action/xeno_action/onclick/paralyzing_slash)
		if (ability && istype(ability))
			ability.button.icon_state = "template"
	return original_damage

/datum/behavior_delegate/sentinel_base/override_intent(mob/living/carbon/target_carbon)
	. = ..()

	if(!isxeno_human(target_carbon))
		return

	if(buffed_slashes)
		return INTENT_HARM



/datum/action/xeno_action/activable/slowing_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/slowspit_user = owner
	if(!slowspit_user.check_state())
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("We must wait for our spit glands to refill."))
		return

	var/turf/current_turf = get_turf(slowspit_user)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	slowspit_user.visible_message(SPAN_XENOWARNING("[slowspit_user] spits at [target]!"),
	SPAN_XENOWARNING("You spit at [target]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(slowspit_user.loc, sound_to_play, 25, 1)

	slowspit_user.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin]
	var/obj/projectile/projectile = new /obj/projectile(current_turf, create_cause_data(initial(slowspit_user.caste_type), slowspit_user))
	projectile.generate_bullet(slowspit_user.ammo)
	projectile.permutated += slowspit_user
	projectile.def_zone = slowspit_user.get_limbzone_target()
	projectile.fire_at(target, slowspit_user, slowspit_user, slowspit_user.ammo.max_range, slowspit_user.ammo.shell_speed)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/scattered_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/scatterspit_user = owner
	if(!scatterspit_user.check_state())
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("We must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(scatterspit_user)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	scatterspit_user.visible_message(SPAN_XENOWARNING("[scatterspit_user] spits at [target]!"),
	SPAN_XENOWARNING("You spit at [target]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(scatterspit_user.loc, sound_to_play, 25, 1)

	scatterspit_user.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin/shotgun]
	var/obj/projectile/projectile = new /obj/projectile(current_turf, create_cause_data(initial(scatterspit_user.caste_type), scatterspit_user))
	projectile.generate_bullet(scatterspit_user.ammo)
	projectile.permutated += scatterspit_user
	projectile.def_zone = scatterspit_user.get_limbzone_target()
	projectile.fire_at(target, scatterspit_user, scatterspit_user, scatterspit_user.ammo.max_range, scatterspit_user.ammo.shell_speed)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/paralyzing_slash/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/paraslash_user = owner

	if (!istype(paraslash_user))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/sentinel_base/behavior = paraslash_user.behavior_delegate
	if (istype(behavior))
		behavior.buffed_slashes = behavior.max_buffed_slashes

	to_chat(paraslash_user, SPAN_XENOHIGHDANGER("Our next three slashes will apply neurotoxin!"))
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/paralyzing_slash/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/unbuffslash_user = owner
	if (!istype(unbuffslash_user))
		return
	var/datum/behavior_delegate/sentinel_base/behavior = unbuffslash_user.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.buffed_slashes)
			return
		behavior.buffed_slashes = 0

	to_chat(unbuffslash_user, SPAN_XENODANGER("We have waited too long, our slash will no longer apply neurotoxin!"))
	button.icon_state = "template"

/datum/action/xeno_action/activable/draining_bite/use_ability(atom/target)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!ishuman(target))
		return
	if(!action_cooldown_check())
		return

	var/mob/living/carbon/human/target_human = target

	if(xeno.can_not_harm(target_human))
		return

	if(!xeno.Adjacent(target_human))
		to_chat(xeno, SPAN_XENOHIGHDANGER("We can only drain bite an adjacent target!"))
		return

	if(xeno.check_state())
		return

	if(xeno.action_busy)
		return

	var/datum/effects/sentinel_neuro_stacks/sns = null
	for (var/datum/effects/sentinel_neuro_stacks/sentinel_neuro_stacks in target_human.effects_list)
		sns = sentinel_neuro_stacks
		break
	var/stun_duration = minimal_stun
	if(sns)
		stun_duration = max(minimal_stun, (sns.stack_count/10)-1)
		sns.increment_stack_count(-sns.stack_count/3)
		apply_neuro(target_human, 0, sns.stack_count/2, TRUE, TRUE, TRUE, FALSE)

	xeno.flick_attack_overlay(target_human, "headbite")
	xeno.animation_attack_on(target_human, pixel_offset = 16)
	target_human.Stun(stun_duration)
	target_human.KnockDown(stun_duration)
	playsound(target_human,'sound/weapons/alien_bite2.ogg', 50, TRUE)
	apply_cooldown()






