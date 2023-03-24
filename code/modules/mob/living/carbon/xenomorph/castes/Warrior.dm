/datum/caste_datum/warrior
	caste_type = XENO_CASTE_WARRIOR
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_5
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_1
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	behavior_delegate_type = /datum/behavior_delegate/warrior_base

	evolves_to = list(XENO_CASTE_PRAETORIAN, XENO_CASTE_CRUSHER)
	deevolves_to = list(XENO_CASTE_DEFENDER)
	caste_desc = "A powerful front line combatant."
	can_vent_crawl = 0

	tackle_min = 2
	tackle_max = 4

	agility_speed_increase = -0.9

	heal_resting = 1.4

	minimum_evolve_time = 9 MINUTES

	minimap_icon = "warrior"

/mob/living/carbon/xenomorph/warrior
	caste_type = XENO_CASTE_WARRIOR
	name = XENO_CASTE_WARRIOR
	desc = "A beefy alien with an armored carapace."
	icon = 'icons/mob/xenos/warrior.dmi'
	icon_size = 64
	icon_state = "Warrior Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	pixel_x = -16
	old_x = -16
	tier = 2
	pull_speed = 2 // about what it was before, slightly faster

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/fling,
	)

	mutation_type = WARRIOR_NORMAL
	claw_type = CLAW_TYPE_SHARP
	icon_xeno = 'icons/mob/xenos/warrior.dmi'
	icon_xenonid = 'icons/mob/xenonids/warrior.dmi'

	var/lunging = FALSE // whether or not the warrior is currently lunging (holding) a target
/mob/living/carbon/xenomorph/warrior/throw_item(atom/target)
	toggle_throw_mode(THROW_MODE_OFF)

/mob/living/carbon/xenomorph/warrior/stop_pulling()
	if(isliving(pulling) && lunging)
		lunging = FALSE // To avoid extreme cases of stopping a lunge then quickly pulling and stopping to pull someone else
		var/mob/living/lunged = pulling
		lunged.set_effect(0, STUN)
		lunged.set_effect(0, WEAKEN)
	return ..()

/mob/living/carbon/xenomorph/warrior/start_pulling(atom/movable/AM, lunge)
	if (!check_state() || agility)
		return FALSE

	if(!isliving(AM))
		return FALSE
	var/mob/living/L = AM
	var/should_neckgrab = !(src.can_not_harm(L)) && lunge

	if(!QDELETED(L) && !QDELETED(L.pulledby) && L != src ) //override pull of other mobs
		visible_message(SPAN_WARNING("[src] has broken [L.pulledby]'s grip on [L]!"), null, null, 5)
		L.pulledby.stop_pulling()

	. = ..(L, lunge, should_neckgrab)

	if(.) //successful pull
		if(isxeno(L))
			var/mob/living/carbon/xenomorph/X = L
			if(X.tier >= 2) // Tier 2 castes or higher immune to warrior grab stuns
				return .

		if(should_neckgrab && L.mob_size < MOB_SIZE_BIG)
			L.drop_held_items()
			L.apply_effect(get_xeno_stun_duration(L, 2), WEAKEN)
			L.pulledby = src
			visible_message(SPAN_XENOWARNING("\The [src] grabs [L] by the throat!"), \
			SPAN_XENOWARNING("You grab [L] by the throat!"))
			lunging = TRUE
			addtimer(CALLBACK(src, PROC_REF(stop_lunging)), get_xeno_stun_duration(L, 2) SECONDS + 1 SECONDS)

/mob/living/carbon/xenomorph/warrior/proc/stop_lunging(world_time)
	lunging = FALSE

/mob/living/carbon/xenomorph/warrior/hitby(atom/movable/AM)
	if(ishuman(AM))
		return
	..()

/datum/behavior_delegate/warrior_base
	name = "Base Warrior Behavior Delegate"

	var/slash_charge_cdr = 0.20 SECONDS // Amount to reduce charge cooldown by per slash
	var/lifesteal_percent = 7
	var/max_lifesteal = 9
	var/lifesteal_range =  3 // Marines within 3 tiles of range will give the warrior extra health
	var/lifesteal_lock_duration = 20 // This will remove the glow effect on warrior after 2 seconds
	var/color = "#6c6f24"
	var/emote_cooldown = 0

/datum/behavior_delegate/warrior_base/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/activable/lunge/cAction1 = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/lunge)
	if (!cAction1.action_cooldown_check())
		cAction1.reduce_cooldown(slash_charge_cdr)

	var/datum/action/xeno_action/activable/fling/cAction2 = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/fling)
	if (!cAction2.action_cooldown_check())
		cAction2.reduce_cooldown(slash_charge_cdr)

	var/datum/action/xeno_action/activable/warrior_punch/cAction3 = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/warrior_punch)
	if (!cAction3.action_cooldown_check())
		cAction3.reduce_cooldown(slash_charge_cdr)

/datum/behavior_delegate/warrior_base/melee_attack_additional_effects_target(mob/living/carbon/A)
	..()

	if(SEND_SIGNAL(bound_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		return

	var/final_lifesteal = lifesteal_percent
	var/list/mobs_in_range = oviewers(lifesteal_range, bound_xeno)

	for(var/mob/mob as anything in mobs_in_range)
		if(final_lifesteal >= max_lifesteal)
			break

		if(mob.stat == DEAD || HAS_TRAIT(mob, TRAIT_NESTED))
			continue

		if(bound_xeno.can_not_harm(mob))
			continue

		final_lifesteal++

// This part is then outside the for loop
		if(final_lifesteal >= max_lifesteal)
			bound_xeno.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 1, "alpha" = 90))
			bound_xeno.visible_message(SPAN_DANGER("[bound_xeno.name] glows as it heals even more from its injuries!."), SPAN_XENODANGER("You glow as you heal even more from your injuries!"))
			bound_xeno.flick_heal_overlay(2 SECONDS, "#00B800")
		if(istype(bound_xeno) && world.time > emote_cooldown && bound_xeno)
			bound_xeno.emote("roar")
			bound_xeno.xeno_jitter(1 SECONDS)
			emote_cooldown = world.time + 5 SECONDS
		addtimer(CALLBACK(src, PROC_REF(lifesteal_lock)), lifesteal_lock_duration/2)

	bound_xeno.gain_health(Clamp(final_lifesteal / 100 * (bound_xeno.maxHealth - bound_xeno.health), 20, 40))

/datum/behavior_delegate/warrior_base/proc/lifesteal_lock()
	bound_xeno.remove_filter("empower_rage")
