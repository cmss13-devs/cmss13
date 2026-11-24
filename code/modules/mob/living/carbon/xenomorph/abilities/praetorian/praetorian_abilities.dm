//// Abilities PRIMARILY used by Praetorian.


////////// VANGUARD ABILITIES

/datum/action/xeno_action/activable/pierce
	ability_description = "Stab through enemies in a line. Hitting enough targets restores your shield."
	ability_stats_type = /datum/xeno_ability_stats/pierce
	name = "Pierce"
	action_icon_state = "prae_pierce"
	macro_path = /datum/action/xeno_action/verb/verb_pierce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 3 SECONDS
	plasma_cost = 50

	// Config
	var/base_damage = 45
	var/shield_regen_threshold = 2
	cooldown_message = "Our tail is no longer exhausted. We can Pierce with it again!"

XENO_ABILITY_STATS(pierce, datum/action/xeno_action/activable/pierce)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
		XENO_STAT_NUMBER(shield_regen_threshold, "Shield restore hit count"),
	)

/datum/action/xeno_action/activable/pounce/prae_dash
	ability_stats_type = /datum/xeno_ability_stats/activable_pounce_prae_dash
	ability_description = "Dash forward, then activate again to slash the area ahead."
	name = "Dash"
	action_icon_state = "prae_dash"
	action_text = "dash"
	macro_path = /datum/action/xeno_action/verb/verb_dash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 11 SECONDS
	plasma_cost = 50
	cooldown_message = "We feel empowered! The largest crowds cannot stop our body from moving!"

	// Config options
	distance = 5
	knockdown = FALSE
	slash = FALSE
	freeze_self = FALSE

	var/buff_duration = 1.2 SECONDS
	var/base_damage = 40
	var/shield_regen_threshold = 1

	var/activated_once = FALSE
	var/time_until_timeout = 2 SECONDS

XENO_ABILITY_STATS(activable_pounce_prae_dash, datum/action/xeno_action/activable/pounce/prae_dash)
	return list(
		XENO_STAT_TILES(distance, "Dash range"),
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
		XENO_STAT_NUMBER(shield_regen_threshold, "Shield restore hit count"),
	)

/datum/action/xeno_action/activable/pounce/prae_dash/initialize_pounce_pass_flags()
	pounce_pass_flags = PASS_MOB_THRU|PASS_OVER_THROW_MOB

/datum/action/xeno_action/activable/cleave
	ability_stats_type = /datum/xeno_ability_stats/activable_cleave
	ability_description = "Strike a target to root it or fling it away. Your shield strengthens the effect."
	name = "Cleave"
	action_icon_state = "prae_cleave_action"
	macro_path = /datum/action/xeno_action/verb/verb_cleave
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 12 SECONDS
	cooldown_message = "They cannot escape our grasp, now! We are ready to Cleave again!"

	// Root config
	var/root_duration_unbuffed = 1 SECONDS
	var/root_duration_buffed = 1.8 SECONDS

	// Fling config
	var/fling_dist_unbuffed = 3
	var/fling_dist_buffed = 6

	// Root or do a punch-like-effect.
	var/root_toggle = TRUE
	var/buffed = FALSE // Are we buffed

XENO_ABILITY_STATS(activable_cleave, datum/action/xeno_action/activable/cleave)
	return list(
		XENO_STAT_CONTROL_DURATION(root_duration_unbuffed, "Root"),
		XENO_STAT_CONTROL_DURATION(root_duration_buffed, "Empowered root"),
		XENO_STAT_VALUE("Knockback", XENO_ABILITY_VALUE(ability, fling_dist_unbuffed), "crowd_control", " tiles."),
		XENO_STAT_VALUE("Empowered knockback", XENO_ABILITY_VALUE(ability, fling_dist_buffed), "crowd_control", " tiles."),
	)

/datum/action/xeno_action/onclick/toggle_cleave
	ability_description = "Switch Cleave between rooting a target and flinging it away."
	name = "Toggle Cleave Type"
	action_icon_state = "prae_cleave_root"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_toggle_cleave
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/toggle_cleave/can_use_action()
	var/mob/living/carbon/xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/toggle_cleave/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

	if (!istype(X))
		return

	if(!X.check_state(1))
		return

	var/datum/action/xeno_action/activable/cleave/cAction = get_action(X, /datum/action/xeno_action/activable/cleave)

	if (!istype(cAction))
		return

	cAction.root_toggle = !cAction.root_toggle

	var/action_icon_result
	if (cAction.root_toggle)
		action_icon_result = "prae_cleave_root"
		to_chat(X, SPAN_WARNING("We will now root marines with our cleave."))
	else
		action_icon_result = "prae_cleave_fling" // TODO: update
		to_chat(X, SPAN_WARNING("We will now throw marines with our cleave."))

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)
	return ..()

////////// Oppressor powers

/datum/action/xeno_action/activable/tail_stab/tail_seize //no verbmacrohotkey, its just tail stab.
	ability_description = "Snare a target with your tail, slowing it and pulling it closer."
	name = "Tail Seize"
	action_icon_state = "tail_seize"
	action_type = XENO_ACTION_CLICK
	charge_time = 0.5 SECONDS
	xeno_cooldown = 15 SECONDS
	ability_primacy = XENO_TAIL_STAB
	cooldown_message = "Our tail is no longer tired! We can seize control of our enemies again!"

/datum/action/xeno_action/activable/prae_abduct
	ability_description = "Hook enemies and pull them toward you. Larger groups suffer roots or stuns instead of a slow."
	name = "Abduct"
	action_icon_state = "abduct"
	macro_path = /datum/action/xeno_action/verb/verb_prae_abduct
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 SECONDS
	plasma_cost = 180

	// Config
	var/max_distance = 6
	var/windup = 8 DECISECONDS
	cooldown_message = "Our tail twitches eagerly with energy. We are ready to snatch tallhosts again."

/datum/action/xeno_action/activable/oppressor_punch
	ability_stats_type = /datum/xeno_ability_stats/activable_oppressor_punch
	ability_description = "Punch through armor and shorten your other cooldowns. Slowed targets take extra damage and are rooted."
	name = "Dislocate"
	action_icon_state = "punch"
	macro_path = /datum/action/xeno_action/verb/verb_oppressor_punch
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS
	plasma_cost = 55

	// Configurables
	var/base_damage = 20
	cooldown_message = "Our mighty arms and fists are primed to clobber our foes!"

XENO_ABILITY_STATS(activable_oppressor_punch, datum/action/xeno_action/activable/oppressor_punch)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
	)

// This one is more tightly coupled than I'd like, but oh well
// unused
/*datum/action/xeno_action/onclick/crush
	name = "Crush"
	action_icon_state = "prae_crush"
	action_text = "crush"
	macro_path = /datum/action/xeno_action/verb/verb_crush
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 10 SECONDS
	plasma_cost = 80*/

// Tail lash
/datum/action/xeno_action/activable/tail_lash
	ability_stats_type = /datum/xeno_ability_stats/activable_tail_lash
	ability_description = "Knock enemies back with your tail and slow them."
	name = "Tail Lash"
	action_icon_state = "prae_tail_lash"
	macro_path = /datum/action/xeno_action/verb/verb_crush
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 13 SECONDS
	plasma_cost = 80

	// Config
	var/fling_dist = 3
	var/windup = 2 DECISECONDS
	cooldown_message = "Our tail twitches eagerly with energy. We are ready to coil it up and lash our foes!"

XENO_ABILITY_STATS(activable_tail_lash, datum/action/xeno_action/activable/tail_lash)
	return list(
		XENO_STAT_VALUE("Knockback", XENO_ABILITY_VALUE(ability, fling_dist), "crowd_control", " tiles."),
		XENO_STAT_DURATION(windup, "Windup"),
	)

////////// Dancer Abilities

/datum/action/xeno_action/activable/tail_stab/harpoon_tail
	ability_description = "Lance a target with your tail. Disarm intent delivers an armor piercing blunt strike."
	name = "Tail Lance"
	action_icon_state = "tail_harpoon"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_TAIL_STAB

/datum/action/xeno_action/activable/prae_impale
	ability_stats_type = /datum/xeno_ability_stats/activable_prae_impale
	ability_description = "Stab a nearby enemy. Consume a red or golden tag to strike twice. A golden tag also resets this ability's cooldown."
	name = "Impale"
	action_icon_state = "prae_impale"
	macro_path = /datum/action/xeno_action/verb/verb_prae_impale
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 13 SECONDS
	plasma_cost = 80
	var/range = 2

	var/impale_click_miss_cooldown = 0.7 SECONDS
	cooldown_message = "We are ready to impale another foe!"

XENO_ABILITY_STATS(activable_prae_impale, datum/action/xeno_action/activable/prae_impale)
	return list(
		XENO_STAT_TILES(range, "Range"),
		xeno_stat_row("Base brute damage per strike", melee_damage(ability, /datum/caste_datum/praetorian)),
	)

/datum/action/xeno_action/onclick/prae_dodge
	ability_stats_type = /datum/xeno_ability_stats/onclick_prae_dodge
	ability_description = "Briefly gain speed and slip through enemies and allies to evade fire."
	name = "Dodge"
	action_icon_state = "prae_dodge"
	macro_path = /datum/action/xeno_action/verb/verb_prae_dodge
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK

	// Config
	var/duration = DANCER_DODGE_TIME
	var/dodge_timer = TIMER_ID_NULL
	var/speed_buff_amount = 0.5
	var/afterimage_interval = 1 DECISECONDS
	cooldown_message = "Our muscles and tendons feel limber enough tofeel fast as a speeding boom tube!"

	/// How much refund we want to get back? 1.0 is 1s used to 1s cooldown, 2.0 is 1s used 2s cooldown.
	var/refund_multiplier = 2.0
	/// Used in calculation, finalized number will be displayed as cooldown.
	var/recharge_time = null
	/// Cooldown after activation to prevent accidental double click.
	var/safe_click_cooldown = 0

XENO_ABILITY_STATS(onclick_prae_dodge, datum/action/xeno_action/onclick/prae_dodge)
	return list(
		XENO_STAT_DURATION(duration, "Maximum duration"),
	)

/datum/action/xeno_action/activable/prae_tail_trip
	ability_stats_type = /datum/xeno_ability_stats/activable_prae_tail_trip
	ability_description = "Trip prey with your tail. Consume a red or golden tag for a stronger knockdown and daze. A golden tag also resets this ability's cooldown."
	name = "Tail Trip"
	action_icon_state = "prae_tail_trip"
	macro_path = /datum/action/xeno_action/verb/verb_prae_tail_trip
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 13 SECONDS
	plasma_cost = 30

	var/tail_click_miss_cooldown = 0.7 SECONDS

	// Config
	var/range = 2
	var/slow_duration = 0.3 SECONDS
	var/stun_duration_default = 0.1
	var/daze_duration_default = 1
	var/stun_duration_buffed = 1
	var/daze_duration_buffed = 2

XENO_ABILITY_STATS(activable_prae_tail_trip, datum/action/xeno_action/activable/prae_tail_trip)
	return list(
		XENO_STAT_CONTROL_LEGACY(stun_duration_default, "Base knockdown"),
		XENO_STAT_CONTROL_LEGACY(stun_duration_buffed, "Tagged knockdown"),
		XENO_STAT_CONTROL_LEGACY(daze_duration_buffed, "Tagged daze"),
	)

////////// BASE PRAE

/datum/action/xeno_action/activable/xeno_spit/praetorian
	ability_description = "Spit acid to build stacks on a human target. Reaching the stack limit triggers a burn; spit hits also build your shield."
	ability_stats_type = /datum/xeno_ability_stats/praetorian_spit
	name = "Spit Acid"
	xeno_cooldown = 2 SECONDS

XENO_ABILITY_STATS(praetorian_spit, datum/action/xeno_action/activable/xeno_spit/praetorian)
	var/shield = /datum/behavior_delegate/praetorian_base::max_shield
	return list(
		XENO_STAT_VALUE("Maximum shield", shield, "shield", "."),
	) + projectile_stats(/datum/ammo/xeno/acid/praetorian) + praetorian_acid_stats()

/datum/action/xeno_action/activable/pounce/base_prae_dash
	ability_stats_type = /datum/xeno_ability_stats/activable_pounce_base_prae_dash
	ability_description = "Dash toward the selected tile to close a gap or escape."
	name = "Dash"
	action_icon_state = "prae_dash"
	action_text = "dash"
	macro_path = /datum/action/xeno_action/verb/verb_dash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS
	plasma_cost = 40

	// Config options
	distance = 6
	knockdown = FALSE
	slash = FALSE
	freeze_self = FALSE
	cooldown_message = "Our legs are ready to take us at unparalleled speeds."

XENO_ABILITY_STATS(activable_pounce_base_prae_dash, datum/action/xeno_action/activable/pounce/base_prae_dash)
	return list(
		XENO_STAT_TILES(distance, "Range"),
	)

/datum/action/xeno_action/activable/prae_acid_ball
	ability_stats_type = /datum/xeno_ability_stats/activable_prae_acid_ball
	ability_description = "Launch a ball of acid that bursts and scatters acid around it."
	name = "Acid Ball"
	action_icon_state = "prae_acid_ball"
	macro_path = /datum/action/xeno_action/verb/verb_acid_ball
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 18 SECONDS
	plasma_cost = 80

	var/activation_delay = 1 SECONDS
	var/prime_delay = 1.25 SECONDS
	cooldown_message = "Our acid glands fill enough to shoot acid balls again!"

XENO_ABILITY_STATS(activable_prae_acid_ball, datum/action/xeno_action/activable/prae_acid_ball)
	return list(
		XENO_STAT_DURATION(activation_delay, "Windup"),
		XENO_STAT_DURATION(prime_delay, "Fuse"),
		XENO_STAT_VALUE("Acid fragments", /obj/item/explosive/grenade/xeno_acid_grenade::shrapnel_count, null, "."),
	) + projectile_stats(/obj/item/explosive/grenade/xeno_acid_grenade::shrapnel_type) + praetorian_acid_stats()

/datum/action/xeno_action/activable/prae_acid_ball/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/acid_ball_user = owner

	if(acid_ball_user.action_busy)
		return

	XENO_ACTION_CHECK(acid_ball_user)

	var/turf/current_turf = get_turf(acid_ball_user)

	if(!current_turf)
		return

	if(!do_after(acid_ball_user, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		to_chat(acid_ball_user, SPAN_XENODANGER("We cancel our acid ball."))
		return

	XENO_ACTION_CHECK_USE_PLASMA(acid_ball_user)

	apply_cooldown()

	to_chat(acid_ball_user, SPAN_XENOWARNING("We lob a compressed ball of acid into the air!"))

	var/obj/item/explosive/grenade/xeno_acid_grenade/grenade = new /obj/item/explosive/grenade/xeno_acid_grenade
	grenade.cause_data = create_cause_data(initial(acid_ball_user.caste_type), acid_ball_user)
	grenade.forceMove(get_turf(acid_ball_user))
	grenade.throw_atom(target_atom, 5, SPEED_AVERAGE, acid_ball_user, TRUE, launch_type = HIGH_LAUNCH, pass_flags = PASS_ACID_GRENADE)
	addtimer(CALLBACK(grenade, TYPE_PROC_REF(/obj/item/explosive, prime)), prime_delay)

	return ..()


/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid
	ability_stats_type = /datum/xeno_ability_stats/activable_spray_acid/praetorian
	ability_description = "Spray acid across the ground to burn enemies in its path."
	name = "Spray Acid"
	action_icon_state = "spray_acid"
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

	plasma_cost = 80
	xeno_cooldown = 10 SECONDS

	// Configurable options
	spray_type = ACID_SPRAY_LINE
	spray_distance = 7
	spray_effect_type = /obj/effect/xenomorph/spray/praetorian

XENO_ABILITY_STATS(activable_spray_acid/praetorian, datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid)
	return ..() + praetorian_acid_stats()
///////////////////////// VALKYRIE PRAE

/datum/action/xeno_action/activable/tail_stab/tail_fountain //no verbmacrohotkey, its just tail stab.
	ability_stats_type = null
	ability_description = "Extinguish a nearby ally or enemy with fluid from your tail."
	name = "Tail Fountain"
	action_icon_state = "tail_seize"
	action_type = XENO_ACTION_CLICK
	charge_time = 0.5 SECONDS
	xeno_cooldown = 10 SECONDS
	ability_primacy = XENO_TAIL_STAB

	cooldown_message = "Our tail is filled with harmless acid again."

/datum/action/xeno_action/activable/valkyrie_rage
	ability_stats_type = /datum/xeno_ability_stats/activable_valkyrie_rage
	ability_description = "Spend fury to bolster your armor and empower a nearby sister."
	name = "Tantrum"
	action_icon_state = "warden_heal"
	action_type = XENO_ACTION_QUEUE
	ability_primacy = XENO_PRIMARY_ACTION_1
	macro_path = /datum/action/xeno_action/verb/verb_prae_rage
	plasma_cost = 100
	xeno_cooldown = 7 SECONDS
	var/datum/weakref/focus_rage = null

	//rage configs
	var/armor_buff = 10 // the idea behind this is you can buff somebody to go in, or get them out which is why the armor is so high while the duration is so low, will need tweaks according to how well it does
	var/armor_buffs_duration = 5 SECONDS // your buff lasts longer because its less and ideally you should be in there slashing people already
	var/armor_buffs_active = FALSE
	var/max_range = 8

	var/target_armor_buff = 15
	var/armor_buffs_targer_dur = 3 SECONDS
	var/armor_buffs_active_target = FALSE

	var/speed_buff_dur = 2 SECONDS // tier 3's get speed boost instead of armor because they become a little broken.
	var/speed_buff_amount = 0.7
	var/armor_buffs_speed_target = FALSE
	var/rage_cost = 75

XENO_ABILITY_STATS(activable_valkyrie_rage, datum/action/xeno_action/activable/valkyrie_rage)
	return list(
		XENO_STAT_NUMBER(rage_cost, "Fury cost"),
		XENO_STAT_NUMBER(armor_buff, "Self armor"),
		XENO_STAT_DURATION(armor_buffs_duration, "Self armor duration"),
		XENO_STAT_NUMBER(target_armor_buff, "Ally armor"),
		XENO_STAT_DURATION(armor_buffs_targer_dur, "Ally armor duration"),
	)

/datum/action/xeno_action/activable/high_gallop
	ability_stats_type = /datum/xeno_ability_stats/activable_high_gallop
	ability_description = "Strike an area in front of you to knock enemies down and throw grenades back."
	name = "High Gallop"
	action_icon_state = "prae_tail_trip"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	macro_path = /datum/action/xeno_action/verb/verb_prae_high_gallop
	xeno_cooldown = 12 SECONDS

	//knockdown range
	var/gallop_range = 3
	cooldown_message = "Our tail feels sturdy as a metal pillar! We can toss anything with it!"

XENO_ABILITY_STATS(activable_high_gallop, datum/action/xeno_action/activable/high_gallop)
	return list(
		XENO_STAT_TILES(gallop_range, "Range"),
	)

/datum/action/xeno_action/onclick/fight_or_flight
	ability_stats_type = /datum/xeno_ability_stats/onclick_fight_or_flight
	ability_description = "Spend fury to clear debuffs from nearby sisters. Higher fury increases the range."
	name = "Fight or Flight"
	action_icon_state = "screech"
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	macro_path = /datum/action/xeno_action/verb/verb_prae_fight_or_flight
	xeno_cooldown = 45 SECONDS
	plasma_cost = 300

	// ranges and windup duration, this part of the ability is heavily experimental and will be touched after if it makes to testing
	var/low_rage_range = 4
	var/high_rage_range = 6
	var/rejuvenate_cost = 75
	cooldown_message = "We feel an overwhelming urge to keep our sisters alive!"

XENO_ABILITY_STATS(onclick_fight_or_flight, datum/action/xeno_action/onclick/fight_or_flight)
	return list(
		XENO_STAT_NUMBER(rejuvenate_cost, "Fury cost"),
		XENO_STAT_TILES(low_rage_range, "Low fury radius"),
		XENO_STAT_TILES(high_rage_range, "High fury radius"),
	)

/datum/action/xeno_action/activable/prae_retrieve
	ability_stats_type = /datum/xeno_ability_stats/activable_prae_retrieve
	ability_description = "Pull an allied xenomorph toward you."

	name = "Retrieve"
	action_icon_state = "retrieve"
	macro_path = /datum/action/xeno_action/verb/verb_prae_retrieve
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 10 SECONDS
	plasma_cost = 180

	//Config variables
	var/max_distance = 7
	var/windup = 0.6 SECONDS
	var/retrieve_cost = 100
	cooldown_message = "We are ready to retrieve endangered sisters again!"

XENO_ABILITY_STATS(activable_prae_retrieve, datum/action/xeno_action/activable/prae_retrieve)
	return list(
		XENO_STAT_NUMBER(retrieve_cost, "Fury cost"),
		XENO_STAT_TILES(max_distance, "Range"),
		XENO_STAT_DURATION(windup, "Windup"),
	)
