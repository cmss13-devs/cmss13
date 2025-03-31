/datum/xeno_strain/gambler

	name = DRONE_GAMBLER
	description = "I CANT STOP WINNING"
	flavor_description = "I cant stop winning."
	icon_state_prefix = "Fancy"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/activable/transfer_plasma,
	)


	actions_to_add = list(
		/datum/action/xeno_action/activable/lets_go_gambling,
	)

	behavior_delegate_type = /datum/behavior_delegate/drone_gambler

/datum/xeno_strain/gambler/apply_strain(mob/living/carbon/xenomorph/drone/gamba)
	gamba.plasma_max = XENO_PLASMA_TIER_GAMBLER
	gamba.recalculate_everything()
	playsound(gamba, 'sound/voice/play_on_init_gamble.ogg', 50)


/datum/behavior_delegate/drone_gambler // copy paste spam so the caste can handle abilities.

	name = "Gambler Drone Behavior Delegate"

	var/shield_decay_time = 15 SECONDS // Time in deciseconds before our shield decays
	var/slash_charge_cdr = 3 SECONDS // Amount to reduce charge cooldown by per slash
	var/knockdown_amount = 1.6
	var/fling_distance = 3
	var/empower_targets = 0
	var/super_empower_threshold = 3
	var/dmg_buff_per_target = 2
	var/lunging = FALSE
	var/kills = 2
	var/invis_recharge_time = 20 SECONDS
	var/invis_start_time = -1 // Special value for when we're not invisible
	var/invis_duration = 30 SECONDS // so we can display how long the lurker is invisible to it
	var/base_fury = 999999
	var/next_slash_buffed = FALSE

/mob/living/carbon/xenomorph/drone/proc/queen_gut(atom/target)
	if(!iscarbon(target))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_HAULED))
		to_chat(src, SPAN_XENOWARNING("[target] needs to be released first."))
		return FALSE
	var/mob/living/carbon/victim = target

	if(get_dist(src, victim) > 1)
		return FALSE

	if(!check_state())
		return FALSE

	if(issynth(victim))
		var/obj/limb/head/synthhead = victim.get_limb("head")
		if(synthhead.status & LIMB_DESTROYED)
			return FALSE

	if(isxeno(victim))
		var/mob/living/carbon/xenomorph/xeno = victim
		if(hivenumber == xeno.hivenumber)
			to_chat(src, SPAN_WARNING("You can't bring yourself to harm a fellow sister to this magnitude."))
			return FALSE

	var/turf/cur_loc = victim.loc
	if(!istype(cur_loc))
		return FALSE

	if(action_busy)
		return FALSE

	if(!check_plasma(200))
		return FALSE

	visible_message(SPAN_XENOWARNING("[src] begins slowly lifting [victim] into the air."),
	SPAN_XENOWARNING("You begin focusing your anger as you slowly lift [victim] into the air."))
	if(do_after(src, 80, INTERRUPT_ALL, BUSY_ICON_HOSTILE, victim))
		if(!victim)
			return FALSE
		if(victim.loc != cur_loc)
			return FALSE
		if(!check_plasma(200))
			return FALSE

		use_plasma(200)

		visible_message(SPAN_XENODANGER("[src] viciously smashes and wrenches [victim] apart!"),
		SPAN_XENODANGER("You suddenly unleash pure anger on [victim], instantly wrenching \him apart!"))
		emote("roar")

		attack_log += text("\[[time_stamp()]\] <font color='red'>gibbed [key_name(victim)]</font>")
		victim.attack_log += text("\[[time_stamp()]\] <font color='orange'>was gibbed by [key_name(src)]</font>")
		victim.gib(create_cause_data("Queen gutting", src)) //Splut

		stop_pulling()
		return TRUE

/mob/living/carbon/xenomorph/drone/start_pulling(atom/movable/movable_atom, lunge)
	var/mob/living/carbon/xenomorph/enterpanuer_drone = src //buy my books
	var/datum/behavior_delegate/drone_gambler/gamba_delegate = enterpanuer_drone.behavior_delegate
	if (!check_state())
		return FALSE

	if(!isliving(movable_atom))
		return FALSE
	var/mob/living/living_mob = movable_atom
	var/should_neckgrab = !(src.can_not_harm(living_mob)) && lunge

	if(!QDELETED(living_mob) && !QDELETED(living_mob.pulledby) && living_mob != src ) //override pull of other mobs
		visible_message(SPAN_WARNING("[src] has broken [living_mob.pulledby]'s grip on [living_mob]!"), null, null, 5)
		living_mob.pulledby.stop_pulling()

	. = ..(living_mob, lunge, should_neckgrab)

	if(.) //successful pull
		if(isxeno(living_mob))
			var/mob/living/carbon/xenomorph/xeno = living_mob
			if(xeno.tier >= 2) // Tier 2 castes or higher immune to warrior grab stuns
				return

		if(should_neckgrab && living_mob.mob_size < MOB_SIZE_BIG)
			living_mob.drop_held_items()
			var/duration = get_xeno_stun_duration(living_mob, 2)
			living_mob.KnockDown(duration)
			living_mob.Stun(duration)
			if(living_mob.pulledby != src)
				return // Grab was broken, probably as Stun side effect (eg. target getting knocked away from a manned M56D)
			visible_message(SPAN_XENOWARNING("[src] grabs [living_mob] by the throat!"),
			SPAN_XENOWARNING("We grab [living_mob] by the throat!"))
			gamba_delegate.lunging = TRUE
			addtimer(CALLBACK(src, PROC_REF(stop_lunging)), get_xeno_stun_duration(living_mob, 2) SECONDS + 1 SECONDS)

/mob/living/carbon/xenomorph/drone/proc/stop_lunging(world_time)

/mob/living/carbon/xenomorph/drone/hitby(atom/movable/movable_atom)
	if(ishuman(movable_atom))
		return
	..()

/datum/behavior_delegate/drone_gambler/proc/decloak_handler(mob/source)
	SIGNAL_HANDLER
	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invis_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if(istype(lurker_invis_action))
		lurker_invis_action.invisibility_off(0.5) // Partial refund of remaining time

/// Implementation for enabling invisibility.
/datum/behavior_delegate/drone_gambler/proc/on_invisibility()

	ADD_TRAIT(bound_xeno, TRAIT_CLOAKED, TRAIT_SOURCE_ABILITY("cloak"))
	RegisterSignal(bound_xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL, PROC_REF(decloak_handler))
	bound_xeno.stealth = TRUE
	invis_start_time = world.time

/// Implementation for disabling invisibility.
/datum/behavior_delegate/drone_gambler/proc/on_invisibility_off()
	bound_xeno.stealth = FALSE
	REMOVE_TRAIT(bound_xeno, TRAIT_CLOAKED, TRAIT_SOURCE_ABILITY("cloak"))
	UnregisterSignal(bound_xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL)
	invis_start_time = -1

/datum/action/xeno_action/activable/lets_go_gambling

	name = "Let's go gambling"
	action_icon_state = "gardener_plant"
	plasma_cost = 0 // it costs NOTHING to gamble
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS

	var/list/jackpot = list(
		/datum/action/xeno_action/activable/gut,
		/datum/action/xeno_action/onclick/screech,
		/datum/action/xeno_action/activable/fluff_ability_2,
		/datum/action/xeno_action/activable/fluff_ability_3,
	)


	var/list/high_end_abilities = list(
		/datum/action/xeno_action/onclick/crusher_shield,
		/datum/action/xeno_action/activable/prae_abduct,
		/datum/action/xeno_action/onclick/empower,
		/datum/action/xeno_action/onclick/apprehend,
		/datum/action/xeno_action/onclick/feralrush,
		/datum/action/xeno_action/activable/feralfrenzy,
		/datum/action/xeno_action/onclick/predalien_roar,
		/datum/action/xeno_action/activable/prae_retrieve,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/activable/fluff_ability_3,
		/datum/action/xeno_action/activable/fluff_ability_4,
	)


	var/list/medium_end_abilities = list(
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/fling,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/pierce,
		/datum/action/xeno_action/onclick/crusher_stomp,
		/datum/action/xeno_action/activable/cleave,
		/datum/action/xeno_action/activable/oppressor_punch,
		/datum/action/xeno_action/activable/tail_lash,
		/datum/action/xeno_action/activable/pounce/crusher_charge,
		/datum/action/xeno_action/activable/scissor_cut,
		/datum/action/xeno_action/activable/high_gallop,
		/datum/action/xeno_action/onclick/tremor,
		/datum/action/xeno_action/activable/boiler_trap,
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/onclick/lurker_assassinate,
		/datum/action/xeno_action/activable/fluff_ability_1,
	)


/datum/action/xeno_action/activable/lets_go_gambling/use_ability()
	var/mob/living/carbon/xenomorph/enterpanuer_drone = owner //buy my books

	if (!enterpanuer_drone.check_state() || enterpanuer_drone.action_busy)
		return

	if (!action_cooldown_check())
		return

	var/list_result = pick(20;high_end_abilities, 75;medium_end_abilities, 5;jackpot)

	if(list_result == jackpot)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), enterpanuer_drone,'sound/voice/play_on_rare.ogg'), 1.25 SECONDS)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), enterpanuer_drone, 'sound/voice/play_on_jackpot.ogg'), 1.25 SECONDS)
	else if(list_result == medium_end_abilities)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), enterpanuer_drone,'sound/voice/play_on_fail.ogg'), 1.25 SECONDS)
	else if(list_result == high_end_abilities)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), enterpanuer_drone,'sound/voice/play_on_rare.ogg'), 1.25 SECONDS)

	var/datum/action/action_result = pick(list_result)
	var/datum/action/action_given = give_action(enterpanuer_drone, action_result)


	RegisterSignal(action_given, COMSIG_XENO_ACTION_USED, PROC_REF(delete_ability))
	addtimer(CALLBACK(src, PROC_REF(delete_ability), action_given, enterpanuer_drone), 10 SECONDS)

	playsound(enterpanuer_drone, 'sound/voice/play_on_use.ogg')
	apply_cooldown()
	..()

/datum/action/xeno_action/activable/lets_go_gambling/proc/delete_ability(datum/action/source, mob/owner)
	SIGNAL_HANDLER
	source.hide_from(owner)
	UnregisterSignal(source, COMSIG_XENO_ACTION_USED)


// These are just buffer abilities, some silly stuff
/datum/action/xeno_action/activable/fluff_ability_1

	name = "Mystery Ability" // These are named vaguely because if i named them it would tell them what they do, we dont want that.
	action_icon_state = "gardener_plant"
	plasma_cost = 0 // it costs NOTHING
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS

/datum/action/xeno_action/activable/fluff_ability_1/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/gamba_drone = owner
	var/spawn_amount = 5 // reasonable right

	if(!gamba_drone.check_state())
		return

	target = get_turf(gamba_drone)

	for(var/fish_in = 1, fish_in <= spawn_amount, fish_in++)
		playsound(src, 'sound/effects/phasein.ogg', 25, 1)
		new /mob/living/simple_animal/hostile/carp(target)

	apply_cooldown()
	..()


/datum/action/xeno_action/activable/fluff_ability_2 // Same ability, but for cats!!! now THIS is the real jacpot.
	name = "Mystery Ability" // These are named vaguely because if i named them it would tell them what they do, we dont want that.
	action_icon_state = "gardener_plant"
	plasma_cost = 0 // it costs NOTHING
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS

/datum/action/xeno_action/activable/fluff_ability_2/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/gamba_drone = owner
	var/spawn_amount = 5 // reasonable right

	if(!gamba_drone.check_state())
		return

	target = get_turf(gamba_drone)

	for(var/cats_in = 1, cats_in <= spawn_amount, cats_in++)
		playsound(src, 'sound/effects/phasein.ogg', 25, 1)
		new /mob/living/simple_animal/cat(target)

	apply_cooldown()
	..()

/datum/action/xeno_action/activable/fluff_ability_3
	name = "Mystery Ability"
	action_icon_state = "gardener_plant"
	plasma_cost = 0
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS

/datum/action/xeno_action/activable/fluff_ability_3/use_ability(atom/target) // I think this is going to get me banned
	var/mob/living/carbon/xenomorph/gamba_drone = owner

	if(!gamba_drone.check_state())
		return

	var/datum/cause_data/cause_data = create_cause_data("trolled", gamba_drone)

	cell_explosion(gamba_drone, 200, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data) // just a rocket like deal, doesnt kill anyone else.

	apply_cooldown()
	..()


/datum/action/xeno_action/activable/fluff_ability_4 //
	name = "Mystery Ability" // These are named vaguely because if i named them it would tell them what they do, we dont want that.
	action_icon_state = "gardener_plant"
	plasma_cost = 0 // it costs NOTHING
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS

/datum/action/xeno_action/activable/fluff_ability_4/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/gamba_drone = owner
	var/spawn_amount = 2 // reasonable right

	if(!gamba_drone.check_state())
		return

	target = get_turf(gamba_drone)

	for(var/cats_in = 1, cats_in <= spawn_amount, cats_in++)
		playsound(src, 'sound/effects/phasein.ogg', 25, 1)
		new /mob/living/simple_animal/hostile/retaliate/giant_lizard(target)

	apply_cooldown()
	..()
