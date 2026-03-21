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
		/datum/action/xeno_action/activable/acid_barrage,
		/datum/action/xeno_action/activable/pounce/caustic_embrace,
		/datum/action/xeno_action/onclick/oozing_wounds,
		/datum/action/xeno_action/onclick/catalyze,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_3/despoiler.dmi'
	icon_xenonid = null // if someone makes xenoid sprites in future feel free to
	acid_overlay = "Despoiler-Spit"

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Despoiler_1","Despoiler_2","Despoiler_3")
	weed_food_states_flipped = list("Despoiler_1","Despoiler_2","Despoiler_3")

	skull = /obj/item/skull/despoiler
	pelt = /obj/item/pelt/despoiler

/mob/living/carbon/xenomorph/despoiler/proc/update_hypertension()
	var/image/holder = hud_list[SPECIAL_HUD]
	holder.overlays.Cut()
	if (stat == DEAD)
		return

	var/datum/behavior_delegate/despoiler_base/delegate = behavior_delegate

	if(!delegate)
		return

	var/image/hypertension = image('icons/mob/hud/hud.dmi', src, "hypertension_[delegate.hypertension_stacks]", pixel_x = 27, pixel_y = -12)
	holder.overlays += hypertension

/mob/living/carbon/xenomorph/despoiler/get_status_tab_items()
	. = ..()
	var/datum/behavior_delegate/despoiler_base/delegate = behavior_delegate

	. += "Hypertension: [delegate.hypertension] / [delegate.hypertension_to_stacks_ratio]"

/mob/living/carbon/xenomorph/despoiler/apply_damage(damage, damagetype, def_zone, used_weapon, sharp, edge, force, enviro, chemical)
	. = ..()
	var/datum/behavior_delegate/despoiler_base/delegate = behavior_delegate
	if(damage > 0)
		delegate.last_combat_time = world.time
		delegate.increase_hypertension(round(damage))

/datum/behavior_delegate/despoiler_base
	name = "Base Despoiler Behavior Delegate"

	var/next_ability_empowered = FALSE
	var/image/empowered_overlay

	// State
	var/hypertension_stacks = 0
	var/hypertension = 0
	var/hypertension_to_stacks_ratio = 200
	var/last_combat_time = 0
	var/last_hypertension_loss_time = 0
	var/hypertension_loss_time = 10 SECONDS

/datum/behavior_delegate/despoiler_base/proc/increase_hypertension(amount)
	var/mob/living/carbon/xenomorph/despoiler/xeno = bound_xeno
	hypertension += amount

	if(hypertension >= hypertension_to_stacks_ratio)
		hypertension -= hypertension_to_stacks_ratio
		hypertension_stacks = min(4, hypertension_stacks+1)
		xeno.update_hypertension()

/datum/behavior_delegate/despoiler_base/on_life()
	if (last_hypertension_loss_time <= last_combat_time &&  last_combat_time + hypertension_loss_time <= world.time)
		hypertension_stacks = max(0, hypertension_stacks - 1)
		var/mob/living/carbon/xenomorph/despoiler/xeno = bound_xeno
		xeno.update_hypertension()

/datum/behavior_delegate/despoiler_base/melee_attack_additional_effects_self()
	..()
	last_combat_time = world.time

/datum/behavior_delegate/despoiler_base/melee_attack_modify_burn_damage(original_damage, mob/living/carbon/target_carbon)
	if (!isxeno_human(target_carbon))
		return original_damage

	increase_hypertension(100)
	var/burn_damage = hypertension_stacks * 5

	if(hypertension_stacks < 3)
		return original_damage + burn_damage

	var/datum/effects/acid/acid_effect = locate() in target_carbon.effects_list
	var/speed_up_progress = (hypertension_stacks - 2) * 5

	if(!acid_effect)
		acid_effect = new /datum/effects/acid/(target_carbon)

	acid_effect.increment_duration(speed_up_progress)
	to_chat(target_carbon, SPAN_XENOHIGHDANGER("You feel a burning pain as [bound_xeno] slashes you, covering you in acid!"))

	return original_damage + burn_damage

/datum/action/xeno_action/activable/tail_stab/despoiler/ability_act(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/target, obj/limb/limb, apply_behavior_delagate = FALSE)
	. = ..()
	var/datum/effects/acid/acid_effect = locate() in target.effects_list
	if(!acid_effect)
		return
	target.apply_armoured_damage(acid_effect.acid_level * 15, ARMOR_BIO, BURN, limb ? limb.name : "chest", acid_effect.acid_level * 10)

/datum/action/xeno_action/activable/acid_barrage/on_select(mob/user)
	RegisterSignal(user, COMSIG_MOB_MOUSEDOWN, PROC_REF(on_mouse_down))

/datum/action/xeno_action/activable/acid_barrage/proc/on_mouse_down(mob/source, atom/target, turf, skin_ctl, params)
	SIGNAL_HANDLER
	var/list/mods = params2list(params)
	source.click(target, mods)

/datum/action/xeno_action/activable/acid_barrage/on_deselect(mob/user)
	UnregisterSignal(user, COMSIG_MOB_MOUSEDOWN)

/datum/action/xeno_action/activable/acid_barrage/use_ability(atom/target)
	. = ..()
	var/mob/living/carbon/xenomorph/despoiler/xeno = owner
	if(!action_cooldown_check())
		to_chat(xeno, SPAN_WARNING("We must wait for our spit glands to refill."))
		return

	if(!check_and_use_plasma_owner())
		return

	// Prevent some mouse down shenangians
	apply_cooldown()

	to_chat(owner, SPAN_XENOHIGHDANGER("We slow down as we begin charging a barrage of acid!"))
	start_time = world.time
	xeno.speed_modifier += XENO_SPEED_SLOWMOD_TIER_3
	xeno.recalculate_speed()
	var/max_charge_notification_timer = addtimer(CALLBACK(src, PROC_REF(notify_max_charge)), max_charge_time, TIMER_STOPPABLE)
	timers += max_charge_notification_timer
	for(var/index in 0 to 3)
		timers += addtimer(CALLBACK(src, PROC_REF(update_barrage_charge_overlay), index), index * (max_charge_time / 3), TIMER_STOPPABLE)
	RegisterSignal(owner, COMSIG_MOB_MOUSEUP, PROC_REF(release_barrage), timers)


/datum/action/xeno_action/activable/acid_barrage/proc/update_barrage_charge_overlay(stage)
	if(charge_overlay)
		owner.overlays -= charge_overlay
	charge_overlay = image('icons/mob/do_afters.dmi', "charge_[stage]", pixel_x = 10, pixel_y = 54)
	charge_overlay.layer = FLY_LAYER
	charge_overlay.plane = ABOVE_GAME_PLANE
	owner.overlays |= charge_overlay

/datum/action/xeno_action/activable/acid_barrage/proc/notify_max_charge()
	to_chat(owner, SPAN_XENOHIGHDANGER("Our acid barrage is full!"))

/datum/action/xeno_action/activable/acid_barrage/proc/release_barrage(atom/source, atom/target, turf, skin_ctl, params)
	SIGNAL_HANDLER
	// The real cooldown starts here
	apply_cooldown_override(xeno_cooldown)
	for(var/timer in timers)
		deltimer(timer)
	timers.Cut()
	if(charge_overlay)
		owner.overlays -= charge_overlay
		charge_overlay = null
	var/mob/living/carbon/xenomorph/despoiler/xeno = owner
	UnregisterSignal(owner, COMSIG_MOB_MOUSEUP)
	xeno.speed_modifier -= XENO_SPEED_SLOWMOD_TIER_3
	xeno.recalculate_speed()

	var/datum/behavior_delegate/despoiler_base/delegate = xeno.behavior_delegate
	var/time_charged = min(world.time - start_time, max_charge_time)
	var/modifier = 0
	if(delegate.next_ability_empowered)
		delegate.next_ability_empowered = FALSE
		modifier += empower_modifier
		xeno.overlays -= delegate.empowered_overlay

	var/barrage_size = max(round((time_charged / max_charge_time) * max_volley), min_volley) + modifier
	playsound(xeno, 'sound/voice/xeno_praetorian_screech.ogg', 75, 0, status = 0)
	playsound(xeno.loc, "acid_spit", 25, 1)
	for(var/index in 1 to barrage_size)
		var/initial_angle = Get_Angle(xeno, target)
		var/rand_angle = rand(-scatter, scatter)
		var/turf/new_target = get_angle_target_turf(xeno, initial_angle + rand_angle, rand(1, 6))
		var/obj/projectile/proj = new (get_turf(xeno), create_cause_data(xeno.ammo.name, xeno))
		var/matrix/scale_matrix = matrix()
		var/factor = rand(0.9, 1.33)
		scale_matrix.Scale(factor, factor)
		proj.transform = scale_matrix
		proj.generate_bullet(xeno.ammo)
		proj.permutated += xeno
		proj.def_zone = xeno.get_limbzone_target()
		proj.fire_at(new_target, xeno, xeno, xeno.ammo.max_range, xeno.ammo.shell_speed)

/datum/action/xeno_action/activable/pounce/caustic_embrace/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/despoiler/xeno = owner
	var/datum/behavior_delegate/despoiler_base/delegate = xeno.behavior_delegate
	if(delegate.next_ability_empowered)
		distance = empowered_distance
	else
		distance = initial(distance)

	. = ..()

/datum/action/xeno_action/activable/pounce/caustic_embrace/additional_effects_always()
	var/mob/living/carbon/xenomorph/despoiler/xeno = owner
	var/datum/behavior_delegate/despoiler_base/delegate = xeno.behavior_delegate
	xeno.emote("roar")

	if(delegate.next_ability_empowered)
		delegate.next_ability_empowered = FALSE
		xeno.overlays -= delegate.empowered_overlay
		return // Handled in additional_effects()

	var/list/turfs = orange(1, get_turf(xeno)) - get_step(xeno.loc, REVERSE_DIR(xeno.dir))
	for(var/turf/turf in turfs)
		for(var/mob/living/carbon/human/target in turf)
			playsound(target.loc, "acid_strike", 25, 1)
			var/armor_block_acid = target.getarmor("chest", ARMOR_BIO)
			var/n_acid_damage = armor_damage_reduction(GLOB.marine_melee, damage, armor_block_acid)
			if(n_acid_damage <= 0.34*damage)
				to_chat(target, SPAN_WARNING("Your armor absorbs the acid!"))
			else if(n_acid_damage <= 0.67*damage)
				to_chat(target, SPAN_WARNING("Your armor softens the acid!"))
			target.apply_damage(n_acid_damage, BURN, "chest")
		if(prob(30))
			new /obj/effect/lingering_acid(turf, xeno.hivenumber)
		new /obj/effect/xenomorph/xeno_telegraph/yellow(turf, 2)

/datum/action/xeno_action/activable/pounce/caustic_embrace/additional_effects(mob/living/carbon/target)
	var/mob/living/carbon/xenomorph/despoiler/xeno = owner
	var/datum/behavior_delegate/despoiler_base/delegate = xeno.behavior_delegate

	if(!delegate.next_ability_empowered)
		return

	xeno.visible_message(SPAN_XENODANGER("[xeno] ravages [target] as it charges at them!"), SPAN_XENODANGER("We ruthlessly ravage [target] as we charge at them!"))
	target.apply_effect(weaken_duration, WEAKEN)
	target.attack_alien(xeno, rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
	xeno.flick_attack_overlay(target, "embrace_slash")

	var/datum/effects/acid/acid_effect = locate() in target.effects_list

	if(!acid_effect)
		acid_effect = new /datum/effects/acid(target)
	acid_effect.enhance_acid()
	acid_effect.enhance_acid(TRUE)


/datum/action/xeno_action/onclick/oozing_wounds/use_ability()
	. = ..()

	var/mob/living/carbon/xenomorph/despoiler/xeno = owner
	var/datum/behavior_delegate/despoiler_base/delegate = xeno.behavior_delegate

	if(!action_cooldown_check())
		to_chat(xeno, SPAN_WARNING("We must wait for our acid glands to refill."))
		return

	if(!check_and_use_plasma_owner())
		return

	apply_cooldown()

	playsound(xeno, 'sound/voice/xeno_praetorian_screech.ogg', 75, 0, status = 0)
	var/severity = (xeno.health <= (0.7 * xeno.maxHealth)) + (xeno.health <= (0.3 * xeno.maxHealth))
	var/acid_range = severity + 1
	var/empowered = delegate.next_ability_empowered

	if(empowered)
		delegate.next_ability_empowered = FALSE
		xeno.overlays -= delegate.empowered_overlay

	for(var/turf/turf in orange(acid_range, get_turf(xeno)))
		if(get_dist_sqrd(turf, xeno) > acid_range ** 2)
			continue
		addtimer(CALLBACK(src, PROC_REF(spawn_acid), xeno, turf, empowered), 0.2 SECONDS * get_dist(turf, xeno))

/datum/action/xeno_action/onclick/oozing_wounds/proc/spawn_acid(mob/living/carbon/xenomorph/xeno, turf/turf, empowered)
	if(empowered)
		new /obj/effect/xenomorph/spray/despoiler/empowered(turf, create_cause_data(initial(xeno.caste_type), src), xeno.hivenumber)
	else
		new /obj/effect/xenomorph/spray/despoiler(turf, create_cause_data(initial(xeno.caste_type), src), xeno.hivenumber)

	if(prob(20))
		new /obj/effect/lingering_acid(turf, xeno.hivenumber)

/datum/action/xeno_action/onclick/catalyze/use_ability(atom/target)
	. = ..()
	var/mob/living/carbon/xenomorph/despoiler/xeno = owner
	var/datum/behavior_delegate/despoiler_base/delegate = xeno.behavior_delegate

	if(!action_cooldown_check())
		to_chat(xeno, SPAN_WARNING("We must wait before empowering an ability again."))
		return

	if(!check_and_use_plasma_owner())
		return

	if(delegate.hypertension_stacks < 1)
		to_chat(xeno, SPAN_WARNING("We don't enough acid to do that."))
		return

	apply_cooldown()

	delegate.hypertension_stacks--
	delegate.next_ability_empowered = TRUE
	delegate.empowered_overlay = image('icons/mob/xenos/castes/tier_3/despoiler.dmi', "hypertension")
	delegate.empowered_overlay.layer = FLY_LAYER
	delegate.empowered_overlay.plane = ABOVE_GAME_PLANE
	xeno.overlays |= delegate.empowered_overlay
	to_chat(owner, SPAN_XENOHIGHDANGER("We catalyze our acid and empowerd our next ability!"))
	addtimer(CALLBACK(src, PROC_REF(debuff_next_ability)), duration)

// Waited too long
/datum/action/xeno_action/onclick/catalyze/proc/debuff_next_ability()
	var/mob/living/carbon/xenomorph/despoiler/xeno = owner
	var/datum/behavior_delegate/despoiler_base/delegate = xeno.behavior_delegate
	if(delegate.next_ability_empowered)
		to_chat(owner, SPAN_XENOHIGHDANGER("We waited too long, our next ability is no longer empowered!"))
		xeno.overlays -= delegate.empowered_overlay
		delegate.next_ability_empowered = FALSE

/obj/effect/lingering_acid
	name = "acid"
	desc = "A small puddle of acid."
	icon = 'icons/effects/acid.dmi'
	icon_state = "acid_puddle"
	density = FALSE
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_OBJ_LAYER
	var/hivenumber = XENO_HIVE_NORMAL
	var/damage = 20
	var/slow_amt = 4

	var/target_limbs = list(
		"l_leg",
		"l_foot",
		"r_leg",
		"r_foot"
	)

/obj/effect/lingering_acid/Initialize(mapload, hive)
	. = ..()
	if (hive)
		hivenumber = hive

	var/decay_time = rand(15 SECONDS, 20 SECONDS)
	animate(src, alpha = 127, time = decay_time)
	QDEL_IN(src, decay_time)

/obj/effect/lingering_acid/Crossed(atom/movable/movable)
	. = ..()
	var/mob/living/carbon/carbon = movable
	if(!istype(carbon))
		return

	if(carbon.ally_of_hivenumber(hivenumber))
		return

	if(HAS_TRAIT(carbon, TRAIT_HAULED))
		return

	playsound(loc, "sound/bullets/acid_impact1.ogg", 15)
	if(!isliving(movable))
		return

	var/mob/living/target_mob = movable
	if(!target_mob.ally_of_hivenumber(hivenumber))
		target_mob.next_move_slowdown = max(target_mob.next_move_slowdown, slow_amt)
		carbon.apply_armoured_damage(damage, damage_type = BURN, def_zone = pick(target_limbs))
