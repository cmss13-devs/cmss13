/datum/caste_datum/despoiler
	caste_type = XENO_CASTE_DESPOILER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_4
	max_health = XENO_HEALTH_TIER_8
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_6
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_3


	tackle_min = 4
	tackle_max = 6
	behavior_delegate_type = /datum/behavior_delegate/despoiler_base
	minimap_icon = "xenoqueen"
	spit_types = list(/datum/ammo/xeno/acid/despoiler)


/mob/living/carbon/xenomorph/despoiler
	caste_type = XENO_CASTE_DESPOILER
	name = XENO_CASTE_DESPOILER
	desc = "A huge, looming beast of an alien."
	icon_size = 64
	icon_state = "Praetorian Walking"
	plasma_types = list(PLASMA_PHEROMONE,PLASMA_NEUROTOXIN)
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
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit/despoiler,
		/datum/action/xeno_action/onclick/despoiler_empower_slash,
		/datum/action/xeno_action/onclick/tacmap,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_3/praetorian.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_3/praetorian.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Praetorian_1","Praetorian_2","Praetorian_3")
	weed_food_states_flipped = list("Praetorian_1","Praetorian_2","Praetorian_3")

	skull = /obj/item/skull/praetorian
	pelt = /obj/item/pelt/praetorian

/datum/action/xeno_action/onclick/despoiler_empower_slash/use_ability(atom/targeted_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/despoiler_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		behavior.next_slash_buffed = TRUE

	to_chat(xeno, SPAN_XENOHIGHDANGER("Our slashes will apply accid!"))

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/despoiler_empower_slash/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return
	var/datum/behavior_delegate/despoiler_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(xeno, SPAN_XENODANGER("Out power weakens, out slashes will no longer apply acid!"))


/datum/behavior_delegate/despoiler_base
	name = "Base Despoiler Behavior Delegate"

	var/next_slash_buffed = TRUE

/datum/behavior_delegate/despoiler_base/melee_attack_modify_damage(original_damage, mob/living/carbon/target_carbon)
	if (!isxeno_human(target_carbon))
		return original_damage

	if (next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We significantly strengthen our attack, covering [target_carbon] in acid!"))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You feel a burning pain as [bound_xeno] slashes you, covering you in acid!"))
		var/datum/effects/acid/acid_effect = locate() in target_carbon.effects_list
		if(acid_effect)
			acid_effect.enhance_acid(super_acid = TRUE)
			return

		new /datum/effects/acid/(target_carbon)


	return original_damage
