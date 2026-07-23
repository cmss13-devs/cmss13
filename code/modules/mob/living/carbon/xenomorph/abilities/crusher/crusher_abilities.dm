/datum/action/xeno_action/activable/pounce/crusher_charge
	name = "Charge"
	action_icon_state = "ready_charge"
	action_text = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_charge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 14 SECONDS
	plasma_cost = 20
	// Config options
	distance = 9
	knockdown = TRUE
	knockdown_duration = 2
	slash = FALSE
	freeze_self = FALSE
	windup = TRUE
	windup_duration = 1.2 SECONDS
	windup_interruptable = FALSE
	should_destroy_objects = TRUE
	throw_speed = SPEED_FAST
	tracks_target = FALSE
	var/direct_hit_damage = 60
	var/frontal_armor = 15
	// Object types that don't reduce cooldown when hit
	var/list/not_reducing_objects = list()

/datum/action/xeno_action/onclick/crusher_stomp
	name = "Stomp"
	action_icon_state = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_stomp
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 18 SECONDS
	plasma_cost = 30

	var/damage = 65

	var/distance = 2
	var/effect_type_base = /datum/effects/xeno_slow/superslow
	var/effect_duration = 1 SECONDS

/datum/action/xeno_action/onclick/crusher_stomp/charger
	name = "Crush"
	action_icon_state = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_charger_stomp
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 25
	damage = 75
	distance = 3
	xeno_cooldown = 12 SECONDS


/datum/action/xeno_action/onclick/crusher_shield
	name = "Defensive Shield"
	action_icon_state = "empower"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_charge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 50
	xeno_cooldown = 26 SECONDS
	var/shield_amount = 200
	var/explosion_immunity_dur = 2.5 SECONDS
	var/shield_dur = 7 SECONDS

/datum/action/xeno_action/activable/fling/charger
	name = "Headbutt"
	action_icon_state = "ram"
	macro_path = /datum/action/xeno_action/verb/verb_fling
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 10 SECONDS
	plasma_cost = 10
	// Configurables
	fling_distance = 3
	stun_power = 0
	weaken_power = 0
	slowdown = 8


/datum/action/xeno_action/onclick/charger_charge
	name = "Toggle Charging"
	action_icon_state = "ready_charge"
	plasma_cost = 0 // manually applied in the proc
	macro_path = /datum/action/xeno_action/verb/verb_crusher_toggle_charging
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1

	// Config vars
	var/max_momentum = 8
	var/steps_to_charge = 4
	var/speed_per_momentum = XENO_SPEED_FASTMOD_TIER_5 + XENO_SPEED_FASTMOD_TIER_1//2
	var/plasma_per_step = 3 // charger has 400 plasma atm, this gives a good 100 tiles of crooshing

	// State vars
	var/activated = FALSE
	var/steps_taken = 0
	var/charge_dir
	var/noise_timer = 0

	//How much shield you gain on max momentum
	var/shield_amount = 100
	// How long the max momentum shield lasts
	var/shield_timeout = 4
	// If the shield is active or not
	var/shield_active = FALSE

	/// The last time the crusher moved while charging
	var/last_charge_move
	/// Dictates speed and damage dealt via collision, increased with movement
	var/momentum = 0


/datum/action/xeno_action/activable/tumble
	name = "Tumble"
	action_icon_state = "tumble"
	macro_path = /datum/action/xeno_action/verb/verb_crusher_tumble
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2

	plasma_cost = 25
	xeno_cooldown = 10 SECONDS

/datum/action/xeno_action/activable/tumble/proc/on_end_throw(start_charging)
	var/mob/living/carbon/xenomorph/Xeno = owner
	Xeno.flags_atom &= ~DIRLOCK
	if(start_charging)
		SEND_SIGNAL(Xeno, COMSIG_XENO_START_CHARGING)


/datum/action/xeno_action/activable/tumble/proc/handle_mob_collision(mob/living/carbon/Mob)
	var/mob/living/carbon/xenomorph/Xeno = owner
	Xeno.visible_message(SPAN_XENODANGER("[Xeno] Sweeps to the side, knocking down [Mob]!"), SPAN_XENODANGER("We knock over [Mob] as we sweep to the side!"))
	var/turf/target_turf = get_turf(Mob)
	playsound(Mob,'sound/weapons/alien_claw_block.ogg', 50, 1)
	Mob.apply_damage(15,BRUTE)
	if(ishuman(Mob))
		var/mob/living/carbon/human/Human = Mob
		Xeno.throw_carbon(Human, distance = 1)
		Human.apply_effect(1, WEAKEN)
	else
		Mob.apply_effect(1, WEAKEN)
	if(!LinkBlocked(Xeno, get_turf(Xeno), target_turf))
		Xeno.forceMove(target_turf)

