/datum/caste_datum/pathogen/venator
	caste_type = PATHOGEN_CREATURE_VENATOR
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_6
	melee_damage_upper = XENO_DAMAGE_TIER_7
	melee_vehicle_damage = XENO_DAMAGE_TIER_7
	max_health = XENO_HEALTH_TIER_12
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_8
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_5

	attack_delay = 0

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/venator

	deevolves_to = list(PATHOGEN_CREATURE_BLIGHT)
	caste_desc = "Rage, rage, and rage some more."
	evolves_to = list()

	heal_resting = 1.6
	is_intelligent = TRUE

	minimap_icon = "venator"
	evolution_allowed = FALSE

/mob/living/carbon/xenomorph/venator
	caste_type = PATHOGEN_CREATURE_VENATOR
	name = PATHOGEN_CREATURE_VENATOR
	desc = "A wandering ball of death."
	icon_size = 48
	icon_state = "Venator Walking"
	plasma_types = list()
	pixel_x = -8
	old_x = -8
	tier = 3
	organ_value = 8000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/pathogen_t3,
		/datum/action/xeno_action/activable/mycotoxin,
		/datum/action/xeno_action/activable/venator_abduct, // Macro 1
		/datum/action/xeno_action/activable/prae_impale/venator, //Macro 2
		/datum/action/xeno_action/activable/venator_savage, // Macro 3
		/datum/action/xeno_action/onclick/blight_slash,
		/datum/action/xeno_action/onclick/tacmap,
	)
	claw_type = CLAW_TYPE_VERY_SHARP

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 45

	icon_xeno = 'icons/mob/pathogen/venator.dmi'
	icon_xenonid = 'icons/mob/pathogen/venator.dmi'
	//need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_48x48.dmi'
	weed_food_states = list("Venator_1","Venator_2","Venator_3")
	weed_food_states_flipped = list("Venator_1","Venator_2","Venator_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"

	mob_size = MOB_SIZE_BIG
	acid_blood_damage = 0
	bubble_icon = "pathogenroyal"

/datum/action/xeno_action/activable/tail_stab/pathogen_t3
	name = "Spike Lash"
	stab_range = 3

/datum/action/xeno_action/activable/tail_stab/pathogen_t3/ability_act(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/target, obj/limb/limb)

	target.last_damage_data = create_cause_data(initial(stabbing_xeno.caste_type), stabbing_xeno)

	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = stabbing_xeno.dir
	/// Direction var to make the tail stab look cool and immersive.
	var/stab_direction

	var/stab_overlay

	if(blunt_stab)
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] slams a giant arm into [target]'s [limb ? limb.display_name : "chest"], bashing it!"), SPAN_XENOWARNING("We slam our giant arm into [target]'s [limb? limb.display_name : "chest"], bashing it!"))
		if(prob(1))
			playsound(target, 'sound/effects/comical_bonk.ogg', 50, TRUE)
		else
			playsound(target, "punch", 50, TRUE)
		// The xeno smashes the target with their tail, moving it to the side and thus their direction as well.
		stab_direction = turn(stabbing_xeno.dir, pick(90, -90))
		stab_overlay = "slam"
		log_attack("[key_name(stabbing_xeno)] whacked [key_name(target)] at [get_area_name(stabbing_xeno)]")
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>was whacked by [key_name(stabbing_xeno)]</font>")
		stabbing_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>whacked [key_name(target)]</font>")
	else
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] skewers [target] through the [limb ? limb.display_name : "chest"] with its razor spikes!"), SPAN_XENOWARNING("We skewer [target] through the [limb? limb.display_name : "chest"] with our razor spikes!"))
		playsound(target, "alien_bite", 50, TRUE)
		// The xeno flips around for a second to impale the target with their tail. These look awsome.
		stab_overlay = "tail"
		log_attack("[key_name(stabbing_xeno)] spikelashed [key_name(target)] at [get_area_name(stabbing_xeno)]")
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>was spikelashed by [key_name(stabbing_xeno)]</font>")
		stabbing_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>spikelashed [key_name(target)]</font>")

	if(last_dir != stab_direction)
		stabbing_xeno.setDir(stab_direction)
		/// Ditto.
		var/new_dir = stabbing_xeno.dir
		addtimer(CALLBACK(src, PROC_REF(reset_direction), stabbing_xeno, last_dir, new_dir), 0.5 SECONDS)

	stabbing_xeno.animation_attack_on(target)
	stabbing_xeno.flick_attack_overlay(target, stab_overlay)

	var/damage = (stabbing_xeno.melee_damage_upper + stabbing_xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER) * TAILSTAB_MOB_DAMAGE_MULTIPLIER

	if(stabbing_xeno.behavior_delegate)
		stabbing_xeno.behavior_delegate.melee_attack_additional_effects_target(target)
		stabbing_xeno.behavior_delegate.melee_attack_additional_effects_self()
		damage = stabbing_xeno.behavior_delegate.melee_attack_modify_damage(damage, target)

	target.apply_armoured_damage(get_xeno_damage_slash(target, damage), ARMOR_MELEE, BRUTE, limb ? limb.name : "chest")
	if(stabbing_xeno.mob_size >= MOB_SIZE_BIG)
		target.apply_effect(3, DAZE)
	else if(stabbing_xeno.mob_size == MOB_SIZE_XENO)
		target.apply_effect(1, DAZE)
	shake_camera(target, 2, 1)

	target.handle_blood_splatter(get_dir(owner.loc, target.loc))
	return target

/datum/action/xeno_action/activable/venator_abduct
	name = "Tentacle Grab"
	action_icon_state = "abduct"
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




/datum/action/xeno_action/activable/venator_savage
	name = "Savage"
	action_icon_state = "rav_scissor_cut"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 6 SECONDS
	plasma_cost = 25

	// Config
	var/damage = 40

	var/superslow_duration = 3 SECONDS

/datum/action/xeno_action/activable/venator_savage/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	// Get line of turfs
	var/list/turf/target_turfs = list()

	var/facing = Get_Compass_Dir(xeno, target_atom)
	var/turf/turf = xeno.loc
	var/turf/temp = xeno.loc
	var/list/telegraph_atom_list = list()

	for (var/step in 0 to 3)
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
		for(var/obj/structure/structure_blocker in temp)
			if(istype(structure_blocker, /obj/structure/window/framed))
				var/obj/structure/window/framed/framed_window = structure_blocker
				if(!framed_window.unslashable)
					framed_window.deconstruct(disassembled = FALSE)
			if(istype(structure_blocker, /obj/structure/fence))
				var/obj/structure/fence/fence = structure_blocker
				if(!fence.unslashable)
					fence.health -= 50
					fence.healthcheck()

			if(structure_blocker.opacity)
				blocked = TRUE
				break
		if(blocked)
			break

		turf = temp
		target_turfs += turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(turf, 0.25 SECONDS)

	// Extract our 'optimal' turf, if it exists
	if (length(target_turfs) >= 2)
		xeno.animation_attack_on(target_turfs[length(target_turfs)], 15)

	// Hmm today I will kill a marine while looking away from them
	xeno.face_atom(target_atom)
	xeno.emote("roar")
	xeno.visible_message(SPAN_XENODANGER("[xeno] sweeps its tentacle spikes through the area in front of it!"), SPAN_XENODANGER("We sweep our tentacle spikes through the area in front of us!"))

	// Loop through our turfs, finding any humans there and dealing damage to them
	for (var/turf/target_turf in target_turfs)
		for (var/mob/living/carbon/carbon_target in target_turf)
			if (carbon_target.stat == DEAD)
				continue

			if (HAS_TRAIT(carbon_target, TRAIT_NESTED))
				continue

			if(xeno.can_not_harm(carbon_target))
				continue
			xeno.flick_attack_overlay(carbon_target, "slash")
			carbon_target.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
			playsound(get_turf(carbon_target), "alien_claw_flesh", 30, TRUE)

//			if(should_sslow)
//				new /datum/effects/xeno_slow/superslow(carbon_target, xeno, ttl = superslow_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/prae_impale/venator
	ability_primacy = XENO_PRIMARY_ACTION_2


/datum/behavior_delegate/pathogen_base/venator
	name = "Base Venator Behavior Delegate"
