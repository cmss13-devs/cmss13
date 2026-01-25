/datum/caste_datum/despoiler
	caste_type = XENO_CASTE_DESPOILER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_4
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_5
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_HELLHOUND

	deevolves_to = list(XENO_CASTE_SPITTER)
	acid_level = 3


	tackle_min = 4
	tackle_max = 6
	tackle_chance = 25
	tacklestrength_min = 3
	tacklestrength_max = 4

	behavior_delegate_type = /datum/behavior_delegate/despoiler_base
	minimap_icon = "despoiler"
	spit_types = list(/datum/ammo/xeno/acid/despoiler)
	minimum_evolve_time = 15 MINUTES
	evolution_allowed = FALSE


/mob/living/carbon/xenomorph/despoiler
	caste_type = XENO_CASTE_DESPOILER
	name = XENO_CASTE_DESPOILER
	desc = "An emaciated acidic terror, barely alive and constantly leaking acid."
	icon_size = 64
	icon_state = "Despoiler Walking"
	plasma_types = list(PLASMA_NEUROTOXIN, PLASMA_PURPLE)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	organ_value = 3000

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/despoiler,
		/datum/action/xeno_action/activable/corrosive_acid/strong,
		/datum/action/xeno_action/activable/xeno_spit/despoiler,
		/datum/action/xeno_action/onclick/corrosive_slash,
		/datum/action/xeno_action/onclick/decomposing_enzymes,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_3/despoiler.dmi'
	icon_xenonid = null // if someone makes xenoid sprites in future feel free to
	acid_overlay = "Despoiler-Spit"

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Despoiler_1","Despoiler_2","Despoiler_3")
	weed_food_states_flipped = list("Despoiler_1","Despoiler_2","Despoiler_3")

	skull = /obj/item/skull/despoiler
	pelt = /obj/item/pelt/despoiler



/datum/action/xeno_action/onclick/corrosive_slash/use_ability(atom/targeted_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/despoiler_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		behavior.slashes_enhanced = TRUE
	xeno.attack_speed_modifier -= slash_speedup

	to_chat(xeno, SPAN_XENOHIGHDANGER("Our slashes will apply stronger acid!"))

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/corrosive_slash/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return
	var/datum/behavior_delegate/despoiler_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		if (!behavior.slashes_enhanced)
			return
		behavior.slashes_enhanced = FALSE
	xeno.attack_speed_modifier += slash_speedup
	to_chat(xeno, SPAN_XENODANGER("Our power weakens, our slashes will no longer apply stronger acid!"))


/datum/behavior_delegate/despoiler_base
	name = "Base Despoiler Behavior Delegate"

	var/slashes_enhanced = FALSE

/datum/behavior_delegate/despoiler_base/melee_attack_modify_damage(original_damage, mob/living/carbon/target_carbon)
	if (!isxeno_human(target_carbon))
		return original_damage
	var/datum/effects/acid/acid_effect = locate() in target_carbon.effects_list
	var/speed_up_progress = 10
	if (slashes_enhanced)
		speed_up_progress = 20
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We significantly strengthen our attack, covering [target_carbon] in acid!"))
		if(acid_effect)
			acid_effect.enhance_acid(super_acid = TRUE)

	if(!acid_effect)
		acid_effect = new /datum/effects/acid/(target_carbon)

	acid_effect.increment_duration(speed_up_progress)


	to_chat(target_carbon, SPAN_XENOHIGHDANGER("You feel a burning pain as [bound_xeno] slashes you, covering you in acid!"))

	return original_damage

/datum/action/xeno_action/activable/tail_stab/despoiler/ability_act(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/target, obj/limb/limb, apply_behavior_delagate = FALSE)
	. = ..()
	var/datum/effects/acid/acid_effect = locate() in target.effects_list
	if(!acid_effect)
		return
	target.apply_armoured_damage(acid_effect.acid_level * 15, ARMOR_BIO, BURN, limb ? limb.name : "chest", acid_effect.acid_level * 10 )

/datum/action/xeno_action/onclick/decomposing_enzymes/use_ability(atom/target)
	. = ..()

	var/mob/living/carbon/xenomorph/xeno = owner
	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	playsound(xeno, 'sound/voice/xeno_praetorian_screech.ogg', 75, 0, status = 0)
	xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] begins to exude a carrion gas!"))
	xeno.create_shriekwave()

	var/datum/effect_system/smoke_spread/decomposing_enzymes/smoke_gas = new()
	smoke_gas.set_up(3, 0, get_turf(xeno), null, 6)
	smoke_gas.start()

	apply_cooldown()

