/datum/caste_datum/pathogen/venator
	caste_type = NEOMORPH_VENATOR
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_6
	melee_damage_upper = XENO_DAMAGE_TIER_6
	melee_vehicle_damage = XENO_DAMAGE_TIER_7
	max_health = XENO_HEALTH_TIER_12
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_8
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_4

	attack_delay = 2 // VERY high slash damage, but attacks relatively slowly

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base

	deevolves_to = list(NEOMORPH_BLIGHT)
	caste_desc = "A fast, powerful combatant."
	evolves_to = list()

	heal_resting = 1.6
	minimum_evolve_time = 0

	minimap_icon = "venator"

/mob/living/carbon/xenomorph/venator
	caste_type = NEOMORPH_VENATOR
	name = NEOMORPH_VENATOR
	desc = "A sleek, fast alien with sharp claws."
	icon_size = 48
	icon_state = "Venator Walking"
	plasma_types = list()
	pixel_x = -12
	old_x = -12
	tier = 3
	organ_value = 10000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/venator,
		/datum/action/xeno_action/activable/venator_abduct,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	claw_type = CLAW_TYPE_VERY_SHARP

	tackle_min = 2
	tackle_max = 6

	icon_xeno = 'icons/mob/neo/venator.dmi'
	icon_xenonid = 'icons/mob/neo/venator.dmi'
	need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_NEOMORPH
	speaking_noise = "neo_talk"


/datum/action/xeno_action/activable/tail_stab/venator
	name = "Spike Lash"
	stab_range = 3

/datum/action/xeno_action/activable/venator_abduct
	name = "Tentacle Grab"
	action_icon_state = "Tentacle Grab"
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 SECONDS
	plasma_cost = 180

	// Config
	var/max_distance = 6
	var/windup = 8 DECISECONDS

/datum/action/xeno_action/activable/venator_abduct/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/abduct_user = owner

	if(!atom || atom.layer >= FLY_LAYER || !isturf(abduct_user.loc))
		return

	if(!action_cooldown_check() || abduct_user.action_busy)
		return

	if(!abduct_user.check_state())
		return

	if(!check_plasma_owner())
		return

	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(abduct_user, atom)
	var/turf/turf = abduct_user.loc
	var/turf/temp = abduct_user.loc
	for(var/distance in 0 to max_distance)
		temp = get_step(turf, facing)
		if(facing in GLOB.diagonals) // check if it goes through corners
			var/reverse_face = GLOB.reverse_dir[facing]
			var/turf/back_left = get_step(temp, turn(reverse_face, 45))
			var/turf/back_right = get_step(temp, turn(reverse_face, -45))
			if((!back_left || back_left.density) && (!back_right || back_right.density))
				break
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/structure in temp)
			if(structure.opacity || ((istype(structure, /obj/structure/barricade) || istype(structure, /obj/structure/girder) && structure.density || istype(structure, /obj/structure/machinery/door)) && structure.density))
				blocked = TRUE
				break
		if(blocked)
			break

		turf = temp

		if (turf in turflist)
			break

		turflist += turf
		facing = get_dir(turf, atom)
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/abduct_hook(turf, windup)

	if(!length(turflist))
		to_chat(abduct_user, SPAN_XENOWARNING("We don't have any room to do our abduction!"))
		return

	abduct_user.visible_message(SPAN_XENODANGER("\The [abduct_user]'s tentacles start coiling..."), SPAN_XENODANGER("We begin coiling our tentacles, aiming towards \the [atom]..."))
	abduct_user.emote("roar")

	var/throw_target_turf = get_step(abduct_user, facing)

	ADD_TRAIT(abduct_user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Tentacle Grab"))
	if(!do_after(abduct_user, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 1))
		to_chat(abduct_user, SPAN_XENOWARNING("You relax your tail."))
		apply_cooldown()

		for (var/obj/effect/xenomorph/xeno_telegraph/xenotelegraph in telegraph_atom_list)
			telegraph_atom_list -= xenotelegraph
			qdel(xenotelegraph)

		REMOVE_TRAIT(abduct_user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Tentacle Grab"))

		return

	if(!check_and_use_plasma_owner())
		return

	REMOVE_TRAIT(abduct_user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Tentacle Grab"))

	playsound(get_turf(abduct_user), 'sound/effects/bang.ogg', 25, 0)
	abduct_user.visible_message(SPAN_XENODANGER("\The [abduct_user] suddenly uncoils its tentacles, extending them towards [atom]!"), SPAN_XENODANGER("We uncoil our tentacles, sending them towards \the [atom]!"))

	var/list/targets = list()
	for (var/turf/target_turf in turflist)
		for (var/mob/living/carbon/target in target_turf)
			if(!isxeno_human(target) || abduct_user.can_not_harm(target) || target.is_dead() || target.is_mob_incapacitated(TRUE) || target.mob_size >= MOB_SIZE_BIG)
				continue

			targets += target
	if (LAZYLEN(targets) == 1)
		abduct_user.balloon_alert(abduct_user, "our tentacles catch and slow one target!", text_color = "#51a16c")
	else if (LAZYLEN(targets) == 2)
		abduct_user.balloon_alert(abduct_user, "our tentacles catch and root two targets!", text_color = "#51a16c")
	else if (LAZYLEN(targets) >= 3)
		abduct_user.balloon_alert(abduct_user, "our tentacles catch and stun [LAZYLEN(targets)] targets!", text_color = "#51a16c")

	apply_cooldown()

	for (var/mob/living/carbon/target in targets)
		abduct_user.visible_message(SPAN_XENODANGER("\The [abduct_user]'s writhing tentacles coil around [target]!"), SPAN_XENODANGER("Our tentacles coil around [target]!"))

		target.apply_effect(0.2, WEAKEN)

		if (LAZYLEN(targets) == 1)
			new /datum/effects/xeno_slow(target, abduct_user, null, null, 2.5 SECONDS)
			target.apply_effect(1, SLOW)
		else if (LAZYLEN(targets) == 2)
			ADD_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Tentacle Grab"))
			if (ishuman(target))
				var/mob/living/carbon/human/target_human = target
				target_human.update_xeno_hostile_hud()
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unroot_human), target, TRAIT_SOURCE_ABILITY("Tentacle Grab")), get_xeno_stun_duration(target, 2.5 SECONDS))
			to_chat(target, SPAN_XENOHIGHDANGER("[abduct_user] has pinned you to the ground! You cannot move!"))

			target.set_effect(2, DAZE)
		else if (LAZYLEN(targets) >= 3)
			target.apply_effect(get_xeno_stun_duration(target, 1.3), WEAKEN)
			to_chat(target, SPAN_XENOHIGHDANGER("You are slammed into the other victims of [abduct_user]!"))


		shake_camera(target, 10, 1)

		var/obj/effect/beam/tail_beam = abduct_user.beam(target, "oppressor_tail", 'icons/effects/beam.dmi', 0.5 SECONDS, 8)
		var/image/tail_image = image('icons/effects/status_effects.dmi', "hooked")
		target.overlays += tail_image

		target.throw_atom(throw_target_turf, get_dist(throw_target_turf, target)-1, SPEED_VERY_FAST)

		qdel(tail_beam) // hook beam catches target, throws them back, is deleted (throw_atom has sleeps), then hook beam catches another target, repeat
		addtimer(CALLBACK(src, /datum/action/xeno_action/activable/prae_abduct/proc/remove_tail_overlay, target, tail_image), 0.5 SECONDS) //needed so it can actually be seen as it gets deleted too quickly otherwise.

	return ..()

/datum/action/xeno_action/activable/venator_abduct/proc/remove_tail_overlay(mob/living/carbon/human/overlayed_human, image/tail_image)
	overlayed_human.overlays -= tail_image
