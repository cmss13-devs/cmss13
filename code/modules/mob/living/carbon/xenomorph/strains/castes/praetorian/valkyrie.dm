/datum/xeno_strain/valkyrie
	name = PRAETORIAN_VALKYRIE
	description = "You trade your ranged abilities and acid to gain the ability to emit strong pheromones and buff other Xenomorphs, giving them extra armor. An ability that knocksdown people in a 2 by 3 infront of you while also throwing back grenades. You get an ability that rejuvenates everyone in a certain range depending on your rage. You also trade your tailstab for an extinguisher, while it doesn't do damage it can put out both enemies and allies. This can be used to extuingish people on fire to help capture them."
	flavor_description = "This one will deny her sisters' deaths until they earn it. Fight or be forgotten."
	icon_state_prefix = "Warden"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/onclick/tacmap,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab/tail_fountain,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/valkyrie_rage,
		/datum/action/xeno_action/activable/high_gallop,
		/datum/action/xeno_action/onclick/fight_or_flight,
		/datum/action/xeno_action/activable/prae_retrieve,
		/datum/action/xeno_action/onclick/tacmap,
	)


	behavior_delegate_type = /datum/behavior_delegate/praetorian_valkyrie

/datum/xeno_strain/valkyrie/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	prae.armor_modifier += XENO_ARMOR_MOD_SMALL
	prae.claw_type = CLAW_TYPE_VERY_SHARP
	prae.recalculate_everything()

/datum/behavior_delegate/praetorian_valkyrie
	name = "Praetorian Valkyrie Behavior Delegate"

	// Config
	var/fury_max = 200
	var/fury_per_attack = 15
	var/fury_per_life = 5
	var/heal_range =  3
	var/raging = FALSE

	// State
	var/base_fury = 0
	var/transferred_healing = 0
	var/damage_mitigated = 0

/datum/behavior_delegate/praetorian_valkyrie/append_to_stat()
	. = list()
	. += "Fury: [base_fury]/[fury_max]"
	. += "Healing Done: [transferred_healing]"
	. += "Damage Mitigated: [floor(damage_mitigated)]"

/datum/behavior_delegate/praetorian_valkyrie/on_life()
	base_fury = min(fury_max, base_fury + fury_per_life)

	var/mob/living/carbon/xenomorph/praetorian/praetorian = bound_xeno
	var/image/holder = praetorian.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

	if(praetorian.stat == DEAD)
		return

	var/percentage_energy = round((base_fury / fury_max) * 100, 10)
	if(percentage_energy)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_energy]")

/datum/behavior_delegate/praetorian_valkyrie/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/praetorian_valkyrie/melee_attack_additional_effects_self()
	..()

	add_base_fury(fury_per_attack)

	if(SEND_SIGNAL(bound_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		return

	for(var/mob/living/carbon/xenomorph/xeno_in_range in range(heal_range, bound_xeno))
		if(xeno_in_range.on_fire)
			continue
		if(xeno_in_range.stat == DEAD)
			continue
		if(!xeno_in_range.ally_of_hivenumber(bound_xeno.hivenumber))
			continue
		xeno_in_range.flick_heal_overlay(2 SECONDS, "#00B800")
		if(raging == TRUE)
			xeno_in_range.gain_health(25)
			transferred_healing += 25
		else
			xeno_in_range.gain_health(15)
			transferred_healing += 15


/datum/behavior_delegate/praetorian_valkyrie/proc/add_base_fury(amount)
	if (amount > 0)
		if (base_fury >= fury_max)
			return
		to_chat(bound_xeno, SPAN_XENODANGER("We are overcome with rage."))
	base_fury = clamp(base_fury + amount, 0, fury_max)

/datum/behavior_delegate/praetorian_valkyrie/proc/use_internal_fury_ability(cost)
	if (cost > base_fury)
		to_chat(bound_xeno, SPAN_XENODANGER("We dont feel angry enough to do this!"))
		return FALSE

	add_base_fury(-cost)
	return TRUE

/datum/action/xeno_action/activable/valkyrie_rage/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/raging_valkyrie = owner
	var/mob/living/carbon/xenomorph/buffing_target = target
	var/datum/behavior_delegate/praetorian_valkyrie/behavior = raging_valkyrie.behavior_delegate


	if (!raging_valkyrie.check_state() || raging_valkyrie.action_busy)
		return

	if (!isxeno(target))
		return

	if (!buffing_target.ally_of_hivenumber(raging_valkyrie.hivenumber))
		to_chat(raging_valkyrie, SPAN_XENOWARNING("Why would we help our enemies?!"))
		return

	if (buffing_target.is_dead())
		to_chat(raging_valkyrie, SPAN_XENOWARNING("No amount of anger can bring our sister back."))
		return

	if (istype(buffing_target.strain, /datum/xeno_strain/valkyrie))
		to_chat(raging_valkyrie, SPAN_XENOWARNING("We can't order another valkyrie with our rage."))
		return

	if (HAS_TRAIT(buffing_target, TRAIT_VALKYRIE_ARMORED))
		to_chat(raging_valkyrie, SPAN_XENOWARNING("[buffing_target] is already enraged!"))
		return

	if (!action_cooldown_check())
		return



	if (!behavior.use_internal_fury_ability(rage_cost) || !check_and_use_plasma_owner())
		return

	if (behavior.raging == TRUE)
		return
	focus_rage = WEAKREF(buffing_target)
	armor_buffs_active = TRUE
	armor_buffs_active_target = TRUE
	behavior.raging = TRUE

	playsound(get_turf(raging_valkyrie), "alien_roar", 40)
	to_chat(raging_valkyrie, SPAN_XENODANGER("Our rage drives us forward, our healing and armor is increased."))
	raging_valkyrie.create_custom_empower(icolor = "#a31010", ialpha = 200, small_xeno = TRUE)
	raging_valkyrie.add_filter("raging", 1, list("type" = "outline", "color" = "#a31010", "size" = 1))
	raging_valkyrie.balloon_alert(raging_valkyrie, "we feel an overwhelming rage", text_color = "#93ec78")
	raging_valkyrie.armor_modifier += armor_buff
	ADD_TRAIT(raging_valkyrie, TRAIT_VALKYRIE_ARMORED, TRAIT_SOURCE_ABILITY("Tantrum"))
	raging_valkyrie.recalculate_armor()
	RegisterSignal(raging_valkyrie, list(COMSIG_XENO_PRE_APPLY_ARMOURED_DAMAGE, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE), PROC_REF(calculate_damage_mitigation_self))

	if(istype(buffing_target.caste, /datum/caste_datum/crusher) || istype(buffing_target.caste, /datum/caste_datum/ravager)) // i wouldve made this a list() but for some reason it didnt work.
		playsound(get_turf(buffing_target), "alien_roar", 40)
		buffing_target.create_custom_empower(icolor = "#a31010", ialpha = 200, small_xeno = TRUE)
		buffing_target.add_filter("raging", 1, list("type" = "outline", "color" = "#a31010", "size" = 1))
		buffing_target.speed_modifier -= speed_buff_amount
		ADD_TRAIT(buffing_target, TRAIT_VALKYRIE_ARMORED, TRAIT_SOURCE_ABILITY("Tantrum"))
		buffing_target.recalculate_speed()
		addtimer(CALLBACK(src, PROC_REF(remove_target_speed)), speed_buff_dur)
	else
		playsound(get_turf(buffing_target), "alien_roar", 40)
		buffing_target.create_custom_empower(icolor = "#a31010", ialpha = 200, small_xeno = TRUE)
		buffing_target.add_filter("raging", 1, list("type" = "outline", "color" = "#a31010", "size" = 1))
		buffing_target.armor_modifier += target_armor_buff
		ADD_TRAIT(buffing_target, TRAIT_VALKYRIE_ARMORED, TRAIT_SOURCE_ABILITY("Tantrum"))
		buffing_target.recalculate_armor()
		addtimer(CALLBACK(src, PROC_REF(remove_target_rage)), armor_buffs_targer_dur)
		RegisterSignal(buffing_target, list(COMSIG_XENO_PRE_APPLY_ARMOURED_DAMAGE, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE), PROC_REF(calculate_damage_mitigation_target))

	addtimer(CALLBACK(src, PROC_REF(remove_rage)), armor_buffs_duration)

	apply_cooldown()
	return ..()


/datum/action/xeno_action/activable/valkyrie_rage/proc/remove_rage()
	var/mob/living/carbon/xenomorph/raging_valkyrie = owner
	var/datum/behavior_delegate/praetorian_valkyrie/behavior = raging_valkyrie.behavior_delegate
	raging_valkyrie.remove_filter("raging")
	raging_valkyrie.armor_modifier -= armor_buff
	armor_buffs_active = FALSE
	behavior.raging = FALSE
	REMOVE_TRAIT(raging_valkyrie, TRAIT_VALKYRIE_ARMORED, TRAIT_SOURCE_ABILITY("Tantrum"))
	raging_valkyrie.recalculate_armor()
	UnregisterSignal(raging_valkyrie, list(COMSIG_XENO_PRE_APPLY_ARMOURED_DAMAGE, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE))
	to_chat(raging_valkyrie, SPAN_XENOHIGHDANGER("We feel ourselves calm down."))



/datum/action/xeno_action/activable/valkyrie_rage/proc/remove_target_speed()
	var/mob/living/carbon/xenomorph/target_xeno = focus_rage.resolve()
	if(target_xeno) //if the target was qdeleted it would be null so you need to check for it
		target_xeno.speed_modifier += speed_buff_amount
		target_xeno.remove_filter("raging")
		REMOVE_TRAIT(target_xeno, TRAIT_VALKYRIE_ARMORED, TRAIT_SOURCE_ABILITY("Tantrum"))
		target_xeno.recalculate_speed()
		to_chat(target_xeno, SPAN_XENOHIGHDANGER("We feel ourselves calm down."))
	armor_buffs_speed_target = FALSE

/datum/action/xeno_action/activable/valkyrie_rage/proc/remove_target_rage()
	var/mob/living/carbon/xenomorph/target_xeno = focus_rage.resolve()
	if(target_xeno) //if the target was qdeleted it would be null so you need to check for it
		target_xeno.armor_modifier -= target_armor_buff
		target_xeno.remove_filter("raging")
		REMOVE_TRAIT(target_xeno, TRAIT_VALKYRIE_ARMORED, TRAIT_SOURCE_ABILITY("Tantrum"))
		target_xeno.recalculate_armor()
		UnregisterSignal(target_xeno, list(COMSIG_XENO_PRE_APPLY_ARMOURED_DAMAGE, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE))
		to_chat(target_xeno, SPAN_XENOHIGHDANGER("We feel ourselves calm down."))
	armor_buffs_active_target = FALSE

/datum/action/xeno_action/activable/valkyrie_rage/proc/calculate_damage_mitigation_self(mob/living/carbon/xenomorph/source, list/damagedata)
	SIGNAL_HANDLER

	var/armour_config = GLOB.xeno_ranged
	if(damagedata["armour_type"] == ARMOR_MELEE)
		armour_config = GLOB.xeno_melee

	var/pre_mit_damage = armor_damage_reduction(armour_config, damagedata["damage"],
		damagedata["armor"] - armor_buff, damagedata["penetration"], damagedata["armour_break_pr_pen"],
		damagedata["armour_break_flat"], damagedata["armor_integrity"])

	var/post_mit_damage = armor_damage_reduction(armour_config, damagedata["damage"],
		damagedata["armor"], damagedata["penetration"], damagedata["armour_break_pr_pen"],
		damagedata["armour_break_flat"], damagedata["armor_integrity"])

	var/mob/living/carbon/xenomorph/xeno = owner
	if(istype(xeno.behavior_delegate, /datum/behavior_delegate/praetorian_valkyrie))
		var/datum/behavior_delegate/praetorian_valkyrie/valk = xeno.behavior_delegate
		valk.damage_mitigated += pre_mit_damage - post_mit_damage


/datum/action/xeno_action/activable/valkyrie_rage/proc/calculate_damage_mitigation_target(mob/living/carbon/xenomorph/source, list/damagedata)
	SIGNAL_HANDLER

	var/armour_config = GLOB.xeno_ranged
	if(damagedata["armour_type"] == ARMOR_MELEE)
		armour_config = GLOB.xeno_melee

	var/pre_mit_damage = armor_damage_reduction(armour_config, damagedata["damage"],
		damagedata["armor"] - target_armor_buff, damagedata["penetration"], damagedata["armour_break_pr_pen"],
		damagedata["armour_break_flat"], damagedata["armor_integrity"])

	var/post_mit_damage = armor_damage_reduction(armour_config, damagedata["damage"],
		damagedata["armor"], damagedata["penetration"], damagedata["armour_break_pr_pen"],
		damagedata["armour_break_flat"], damagedata["armor_integrity"])

	var/mob/living/carbon/xenomorph/xeno = owner
	if(istype(xeno.behavior_delegate, /datum/behavior_delegate/praetorian_valkyrie))
		var/datum/behavior_delegate/praetorian_valkyrie/valk = xeno.behavior_delegate
		valk.damage_mitigated += pre_mit_damage - post_mit_damage

/datum/action/xeno_action/activable/high_gallop/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/valkyrie = owner

	if (!istype(valkyrie) || !valkyrie.check_state() || !action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(valkyrie.loc))
		return

	if (!check_plasma_owner())
		return

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 2x3 area of turfs
	var/turf/root = get_turf(valkyrie)
	var/facing = Get_Compass_Dir(valkyrie, A)
	var/turf/infront = get_step(root, facing)
	var/turf/left = get_step(root, turn(facing, 90))
	var/turf/right = get_step(root, turn(facing, -90))
	var/turf/infront_left = get_step(root, turn(facing, 45))
	var/turf/infront_right = get_step(root, turn(facing, -45))
	temp_turfs += infront
	if(!(!infront || infront.density) && !(!left || left.density))
		temp_turfs += infront_left
	if(!(!infront || infront.density) && !(!right || right.density))
		temp_turfs += infront_right

	for(var/turf/range_turf in temp_turfs)
		if (!istype(range_turf))
			continue

		if (range_turf.density)
			continue

		target_turfs += range_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(range_turf, 0.25 SECONDS)

		var/turf/next_turf = get_step(range_turf, facing)
		if (!istype(next_turf) || next_turf.density)
			continue

		target_turfs += next_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(next_turf, 0.25 SECONDS)

	if(!length(target_turfs))
		to_chat(valkyrie, SPAN_XENOWARNING("We don't have enough room!"))
		return

	if(!action_cooldown_check() || !check_and_use_plasma_owner())
		return

	apply_cooldown()

	valkyrie.visible_message(SPAN_XENODANGER("[valkyrie] stomps its feet furiously, breaking the ground underneath!"), SPAN_XENODANGER("We send a shockwave through the ground, breaking the balance of anyone infront of us!"))
	valkyrie.emote("roar")
	playsound(valkyrie, 'sound/effects/alien_footstep_charge3.ogg', 35, 0)

	for (var/turf/range in target_turfs)
		for (var/mob/living/carbon/target in range)
			if (target.stat == DEAD)
				continue

			if(!isxeno_human(target) || valkyrie.can_not_harm(target))
				continue

			if(target.mob_size >= MOB_SIZE_BIG)
				continue

			target.apply_effect(get_xeno_stun_duration(target, 0.5), WEAKEN)
			new /datum/effects/xeno_slow(target, valkyrie, ttl = get_xeno_stun_duration(target, 25))

		for (var/obj/item/explosive/grenade/grenades in range) // sends back grenades
			var/direction = get_dir(valkyrie, grenades)
			var/turf/target_destination = get_ranged_target_turf(grenades, direction, 3)

			grenades.throw_atom(get_step_towards(target_destination, grenades), 3, SPEED_FAST, grenades)

	return ..()


/datum/action/xeno_action/onclick/fight_or_flight/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/valkyrie_flight = owner

	var/datum/behavior_delegate/praetorian_valkyrie/behavior = valkyrie_flight.behavior_delegate


	if (!valkyrie_flight.check_state())
		return

	if (!action_cooldown_check())
		return

	if (!behavior.use_internal_fury_ability(rejuvenate_cost))
		return

	if (!check_and_use_plasma_owner())
		return

	var/range = behavior.base_fury < 75 ? low_rage_range : high_rage_range
	playsound(valkyrie_flight, 'sound/voice/xenos_roaring.ogg', 125)
	for(var/mob/living/carbon/xenomorph/allied_xenomorphs in range(range, valkyrie_flight))
		if(!allied_xenomorphs.ally_of_hivenumber(valkyrie_flight.hivenumber))
			continue
		to_chat(allied_xenomorphs, SPAN_XENOWARNING("Every single inch in our body moves on its own to fight."))
		valkyrie_flight.create_shriekwave(3)
		allied_xenomorphs.xeno_jitter(1 SECONDS,)
		allied_xenomorphs.flick_heal_overlay(3 SECONDS, "#F5007A")
		allied_xenomorphs.clear_debuffs()
	apply_cooldown()
	return ..()


/datum/action/xeno_action/activable/tail_stab/tail_fountain/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/extinguisher_tail = owner
	var/mob/living/carbon/xenomorph/target = atom


	var/distance = get_dist(extinguisher_tail, target)

	if (distance > 2)
		to_chat(extinguisher_tail, SPAN_XENOWARNING("We need to be closer to our target."))
		return

	if(atom	== extinguisher_tail)
		to_chat(extinguisher_tail, SPAN_XENOWARNING("We can't extinguish ourselves."))
		return

	if(!iscarbon(atom))
		to_chat(extinguisher_tail, SPAN_XENOWARNING("We need to target something."))
		return

	if (!action_cooldown_check())
		return

	if (!extinguisher_tail.check_state())
		return

	if (!check_and_use_plasma_owner())
		return FALSE

	playsound(extinguisher_tail, 'sound/effects/splat.ogg', 40, FALSE)
	target.ExtinguishMob() // This can both help your allies, or help caps that are on fire.
	apply_cooldown()
	extinguisher_tail.visible_message(SPAN_XENODANGER("[extinguisher_tail] pours acid all over [target] using its tail."), SPAN_XENOHIGHDANGER("We use our tail to pour acid over [target]"))
	xeno_attack_delay(extinguisher_tail)
	return ..()




/datum/action/xeno_action/activable/prae_retrieve/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/valkyrie = owner
	if(!istype(valkyrie))
		return

	var/datum/behavior_delegate/praetorian_valkyrie/behavior = valkyrie.behavior_delegate
	if(!istype(behavior))
		return

	if(valkyrie.observed_xeno != null)
		to_chat(valkyrie, SPAN_XENOHIGHDANGER("We cannot retrieve sisters through overwatch!"))
		return

	if(!isxeno(A) || !valkyrie.can_not_harm(A))
		to_chat(valkyrie, SPAN_XENODANGER("We must target one of our sisters!"))
		return

	if(A == valkyrie)
		to_chat(valkyrie, SPAN_XENODANGER("We cannot retrieve ourself!"))
		return

	if(!(A in view(7, valkyrie)))
		to_chat(valkyrie, SPAN_XENODANGER("That sister is too far away!"))
		return

	var/mob/living/carbon/xenomorph/targetXeno = A

	if(targetXeno.anchored)
		to_chat(valkyrie, SPAN_XENODANGER("That sister cannot move!"))
		return

	if(!(targetXeno.resting || targetXeno.stat == UNCONSCIOUS))
		if(targetXeno.mob_size > MOB_SIZE_BIG)
			to_chat(valkyrie, SPAN_WARNING("[targetXeno] is too big to retrieve while standing up!"))
			return

	if(targetXeno.stat == DEAD)
		to_chat(valkyrie, SPAN_WARNING("[targetXeno] is already dead!"))
		return

	if(!action_cooldown_check() || valkyrie.action_busy)
		return

	if(!valkyrie.check_state())
		return

	if(!check_plasma_owner())
		return

	if(!behavior.use_internal_fury_ability(retrieve_cost))
		return

	if(!check_and_use_plasma_owner())
		return

	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(valkyrie, A)
	var/reversefacing = get_dir(A, valkyrie)
	var/turf/T = valkyrie.loc
	var/turf/temp = valkyrie.loc
	for(var/x in 0 to max_distance)
		temp = get_step(T, facing)
		if(facing in GLOB.diagonals) // check if it goes through corners
			var/reverse_face = GLOB.reverse_dir[facing]
			var/turf/back_left = get_step(temp, turn(reverse_face, 45))
			var/turf/back_right = get_step(temp, turn(reverse_face, -45))
			if((!back_left || back_left.density) && (!back_right || back_right.density))
				break
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in temp)
			if(S.opacity || ((istype(S, /obj/structure/barricade) || istype(S, /obj/structure/girder)  && S.density|| istype(S, /obj/structure/machinery/door)) && S.density))
				blocked = TRUE
				break
		if(blocked)
			to_chat(valkyrie, SPAN_XENOWARNING("We can't reach [targetXeno] with our resin retrieval hook!"))
			return

		T = temp

		if(T in turflist)
			break

		turflist += T
		facing = get_dir(T, A)
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/green(T, windup)

	if(!length(turflist))
		to_chat(valkyrie, SPAN_XENOWARNING("We don't have any room to do our retrieve!"))
		return

	valkyrie.visible_message(SPAN_XENODANGER("[valkyrie] prepares to fire its resin retrieval hook at [A]!"), SPAN_XENODANGER("We prepare to fire our resin retrieval hook at [A]!"))
	valkyrie.emote("roar")

	var/throw_target_turf = get_step(valkyrie, facing)
	var/turf/behind_turf = get_step(valkyrie, reversefacing)
	if(!(behind_turf.density))
		throw_target_turf = behind_turf

	ADD_TRAIT(valkyrie, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Praetorian Retrieve"))
	if(windup)
		if(!do_after(valkyrie, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 1))
			to_chat(valkyrie, SPAN_XENOWARNING("We cancel our retrieve."))
			apply_cooldown()

			for (var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
				telegraph_atom_list -= XT
				qdel(XT)

			REMOVE_TRAIT(valkyrie, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Praetorian Retrieve"))

			return

	REMOVE_TRAIT(valkyrie, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Praetorian Retrieve"))

	playsound(get_turf(valkyrie), 'sound/effects/bang.ogg', 25, 0)

	var/successful_retrieve = FALSE
	for(var/turf/target_turf in turflist)
		if(targetXeno in target_turf)
			successful_retrieve = TRUE
			break

	if(!successful_retrieve)
		to_chat(valkyrie, SPAN_XENOWARNING("We can't reach [targetXeno] with our resin retrieval hook!"))
		return

	to_chat(targetXeno, SPAN_XENOBOLDNOTICE("We are pulled toward [valkyrie]!"))

	shake_camera(targetXeno, 10, 1)
	var/throw_dist = get_dist(throw_target_turf, targetXeno)-1
	if(throw_target_turf == behind_turf)
		throw_dist++
		to_chat(valkyrie, SPAN_XENOBOLDNOTICE("We fling [targetXeno] over our head with our resin hook, and they land behind us!"))
	else
		to_chat(valkyrie, SPAN_XENOBOLDNOTICE("We fling [targetXeno] towards us with our resin hook, and they land in front of us!"))
	targetXeno.throw_atom(throw_target_turf, throw_dist, SPEED_VERY_FAST, pass_flags = PASS_MOB_THRU)
	apply_cooldown()
	return ..()
