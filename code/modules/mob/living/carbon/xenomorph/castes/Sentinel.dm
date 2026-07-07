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
	xenonid_pixel_x = -9
	tier = 1
	organ_value = 800
	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/activable/slowing_spit, //first macro
		/datum/action/xeno_action/activable/scattered_spit, //second macro
		/datum/action/xeno_action/onclick/paralyzing_slash, //third macro
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
	var/next_slash_buffed = FALSE

#define NEURO_TOUCH_DELAY 4 SECONDS

/datum/behavior_delegate/sentinel_base/melee_attack_modify_damage(original_damage, mob/living/carbon/carbon_target)
	if(!next_slash_buffed)
		return original_damage

	if(!isxeno_human(carbon_target))
		return original_damage

	if(skillcheck(carbon_target, SKILL_ENDURANCE, SKILL_ENDURANCE_MAX ))
		carbon_target.visible_message(SPAN_DANGER("[carbon_target] withstands the neurotoxin!"))
		next_slash_buffed = FALSE
		return original_damage //endurance 5 makes you immune to weak neurotoxin
	if(ishuman(carbon_target))
		var/mob/living/carbon/human/target_human = carbon_target
		if(target_human.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO || target_human.species.flags & NO_NEURO)
			target_human.visible_message(SPAN_DANGER("[target_human] shrugs off the neurotoxin!"))
			next_slash_buffed = FALSE
			return //species like zombies or synths are immune to neurotoxin
	if(next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We add neurotoxin into our attack, [carbon_target] is about to fall over paralyzed!"))
		to_chat(carbon_target, SPAN_XENOHIGHDANGER("You feel like you're about to fall over, as [bound_xeno] slashes you with its neurotoxin coated claws!"))
		carbon_target.sway_jitter(times = 3, steps = floor(NEURO_TOUCH_DELAY/3))
		carbon_target.apply_effect(4, DAZE)
		addtimer(CALLBACK(src, PROC_REF(paralyzing_slash), carbon_target), NEURO_TOUCH_DELAY)
		next_slash_buffed = FALSE
	if(!next_slash_buffed)
		var/datum/action/xeno_action/onclick/paralyzing_slash/ability = get_action(bound_xeno, /datum/action/xeno_action/onclick/paralyzing_slash)
		if(ability && istype(ability))
			ability.button.icon_state = "template"
	return original_damage

#undef NEURO_TOUCH_DELAY

/datum/behavior_delegate/sentinel_base/override_intent(mob/living/carbon/target_carbon)
	. = ..()

	if(!isxeno_human(target_carbon))
		return

	if(next_slash_buffed)
		return INTENT_HARM

/datum/behavior_delegate/sentinel_base/proc/paralyzing_slash(mob/living/carbon/human/human_target)
	human_target.KnockDown(2)
	human_target.Stun(2)
	to_chat(human_target, SPAN_XENOHIGHDANGER("You fall over, paralyzed by the toxin!"))



/datum/action/xeno_action/activable/slowing_spit/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("We must wait for our spit glands to refill."))
		return

	var/turf/current_turf = get_turf(xeno)

	if(!current_turf)
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	xeno.visible_message(SPAN_XENOWARNING("[xeno] spits at [target_atom]!"),
	SPAN_XENOWARNING("You spit at [target_atom]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(xeno.loc, sound_to_play, 25, 1)

	xeno.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin]
	var/obj/projectile/projectile = new /obj/projectile(current_turf, create_cause_data(initial(xeno.caste_type), xeno))
	projectile.generate_bullet(xeno.ammo)
	projectile.permutated += xeno
	projectile.def_zone = xeno.get_limbzone_target()
	projectile.fire_at(target_atom, xeno, xeno, xeno.ammo.max_range, xeno.ammo.shell_speed)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/scattered_spit/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("We must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(xeno)

	if(!current_turf)
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	xeno.visible_message(SPAN_XENOWARNING("[xeno] spits at [target_atom]!"),
	SPAN_XENOWARNING("You spit at [target_atom]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(xeno.loc, sound_to_play, 25, 1)

	xeno.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin/shotgun]
	var/obj/projectile/projectile = new /obj/projectile(current_turf, create_cause_data(initial(xeno.caste_type), xeno))
	projectile.generate_bullet(xeno.ammo)
	projectile.permutated += xeno
	projectile.def_zone = xeno.get_limbzone_target()
	projectile.fire_at(target_atom, xeno, xeno, xeno.ammo.max_range, xeno.ammo.shell_speed)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/paralyzing_slash/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	var/datum/behavior_delegate/sentinel_base/behavior = xeno.behavior_delegate
	if(istype(behavior))
		behavior.next_slash_buffed = TRUE

	to_chat(xeno, SPAN_XENOHIGHDANGER("Our next slash will apply neurotoxin!"))
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/paralyzing_slash/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return
	var/datum/behavior_delegate/sentinel_base/behavior = xeno.behavior_delegate
	if(istype(behavior))
		// In case slash has already landed
		if(!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(xeno, SPAN_XENODANGER("We have waited too long, our slash will no longer apply neurotoxin!"))
	button.icon_state = "template_xeno"
