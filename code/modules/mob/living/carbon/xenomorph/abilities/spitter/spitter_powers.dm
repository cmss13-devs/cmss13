/datum/action/xeno_action/onclick/charge_spit/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/zenomorf = owner

	if (!action_cooldown_check())
		return

	if (!istype(zenomorf) || !zenomorf.check_state())
		return

	if (buffs_active)
		to_chat(zenomorf, SPAN_XENOHIGHDANGER("We cannot stack this!"))
		return

	if (!check_and_use_plasma_owner())
		return

	to_chat(zenomorf, SPAN_XENOHIGHDANGER("We accumulate acid in your glands. Our next spit will be stronger but shorter-ranged."))
	to_chat(zenomorf, SPAN_XENOWARNING("Additionally, we are slightly faster and more armored for a small amount of time."))
	zenomorf.create_custom_empower(icolor = "#93ec78", ialpha = 200, small_xeno = TRUE)
	zenomorf.balloon_alert(zenomorf, "our next spit will be stronger", text_color = "#93ec78")
	buffs_active = TRUE
	zenomorf.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/spatter] // shitcode is my city
	zenomorf.speed_modifier -= speed_buff_amount
	zenomorf.armor_modifier += armor_buff_amount
	zenomorf.recalculate_speed()
	zenomorf.recalculate_armor()

	/// Though the ability's other buffs are supposed to last for its duration, it's only supposed to enhance one spit.
	RegisterSignal(zenomorf, COMSIG_XENO_POST_SPIT, PROC_REF(disable_spatter))

	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/charge_spit/proc/disable_spatter()
	SIGNAL_HANDLER
	var/mob/living/carbon/xenomorph/zenomorf = owner
	if(zenomorf.ammo == GLOB.ammo_list[/datum/ammo/xeno/acid/spatter])
		to_chat(zenomorf, SPAN_XENOWARNING("Our acid glands empty out and return back to normal. We will once more fire long-ranged weak spits."))
		zenomorf.balloon_alert(zenomorf, "our spits are back to normal", text_color = "#93ec78")
		zenomorf.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid] // el codigo de mierda es mi ciudad
	UnregisterSignal(zenomorf, COMSIG_XENO_POST_SPIT)

/datum/action/xeno_action/onclick/charge_spit/proc/remove_effects()
	var/mob/living/carbon/xenomorph/zenomorf = owner

	if (!istype(zenomorf))
		return

	zenomorf.speed_modifier += speed_buff_amount
	zenomorf.armor_modifier -= armor_buff_amount
	zenomorf.recalculate_speed()
	zenomorf.recalculate_armor()
	to_chat(zenomorf, SPAN_XENOHIGHDANGER("We feel our movement speed slow down!"))
	disable_spatter()
	buffs_active = FALSE

/datum/action/xeno_action/activable/tail_stab/spitter/use_ability(atom/A)
	var/target = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.reagents.add_reagent("molecularacid", 2)
		carbon_target.reagents.set_source_mob(owner, /datum/reagent/toxin/molecular_acid)

// Alchemist Powers

/datum/action/xeno_action/activable/tail_inject/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_alchemist/alchemist = xeno.behavior_delegate
	var/mob/living/carbon/carbon = target

	if(!isxeno(xeno))
		return

	if(!istype(xeno.behavior_delegate, alchemist))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(get_dist(xeno, target) > 2)
		return

	if(alchemist.producing_alchem)
		to_chat(xeno, SPAN_XENOWARNING("We should wait until we've finished making chemicals!"))
		return

	var/list/turf/path = get_line(xeno, target, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
			return
		var/atom/barrier = path_turf.handle_barriers(A = xeno , pass_flags = (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
			return
		for(var/obj/structure/current_structure in path_turf)
			if(current_structure.density && !current_structure.throwpass)
				to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
				return

	if(!iscarbon(target) && carbon.stat == DEAD)
		xeno.visible_message(SPAN_XENOWARNING("\The [xeno] swipes their tail through the air!"), SPAN_XENOWARNING("We swipe our tail through the air!"))
		apply_cooldown(0.2)
		playsound(xeno, 'sound/effects/alien_tail_swipe1.ogg', 50, TRUE)
		return

	if(xeno.can_not_harm(carbon) && ishuman(carbon)|| islarva(carbon)) // Don't want to try using on friendly humans or larva
		return

	var/obj/limb/target_limb = carbon.get_limb(check_zone(xeno.zone_selected))
	if(ishuman(target) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = carbon.get_limb("chest")

	alchemist.parse_final_alchem()
	if(alchemist.final_alchem_reagent != null && alchemist.final_alchem_source != null)
		if(isxeno(target))
			var/mob/living/carbon/xenomorph/xenoid = target
			alchemist.alchem_xeno_reaction(xenoid)

		if(!xeno.can_not_harm(carbon) && ishuman(target) && !issynth(target) && !HAS_TRAIT(target, TRAIT_NESTED) && carbon.status_flags & XENO_HOST)
			var/mob/living/carbon/human/humanoid = target
			if(isyautja(humanoid))
				humanoid.reagents.add_reagent(alchemist.final_alchem_reagent, alchemist.total_pool / 2)
				humanoid.reagents.set_source_mob(xeno, alchemist.final_alchem_source)
			else
				humanoid.reagents.add_reagent(alchemist.final_alchem_reagent, alchemist.total_pool)
				humanoid.reagents.set_source_mob(xeno, alchemist.final_alchem_source)
		alchemist.final_alchem_info(carbon)
		if(alchemist.total_pool > 14)
			alchem_cooldown_modifier = alchemist.total_pool * 0.07
		else
			alchem_cooldown_modifier = 1
		alchemist.empty_entire_stockpile()
		check_and_use_plasma_owner()

	if(!xeno.can_not_harm(carbon))
		xeno.visible_message(SPAN_XENOWARNING("[xeno] stabs [carbon] in the [target_limb ? target_limb.display_name : "chest"] with their tail!"), \
		SPAN_XENOWARNING("We stab [carbon] in the [target_limb ? target_limb.display_name : "chest"] with our tail!"))
		playsound(carbon,'sound/weapons/alien_tail_attack.ogg', 50, TRUE)

		carbon.apply_armoured_damage(get_xeno_damage_slash(target, xeno.caste.melee_damage_lower), ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")
		carbon.last_damage_data = create_cause_data(xeno.caste_type, xeno)
		log_attack("[key_name(xeno)] attacked [key_name(carbon)] with Tail Injection")
	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno] gently jabs [carbon] with their tail!"), \
		SPAN_XENOWARNING("We gently jab our tail into [carbon], making sure not to harm them!"))
		playsound(xeno, 'sound/effects/alien_tail_swipe1.ogg', 50, TRUE)
		if(alchemist.final_alchem_name == null)
			alchem_cooldown_modifier = 0.2
	var/stab_direction
	stab_direction = turn(get_dir(xeno, target), 180)

	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = xeno.dir

	xeno.setDir(stab_direction)
	xeno.flick_attack_overlay(target, "tail")
	xeno.animation_attack_on(target)

	var/new_dir = xeno.dir
	addtimer(CALLBACK(src, PROC_REF(reset_direction), xeno, last_dir, new_dir), 0.5 SECONDS)

	apply_cooldown(alchem_cooldown_modifier)
	return ..()

/datum/action/xeno_action/activable/tail_inject/proc/reset_direction(mob/living/carbon/xenomorph/xeno, last_dir, new_dir)
	// If the xenomorph is still holding the same direction as the tail stab animation's changed it to, reset it back to the old direction so the xenomorph isn't stuck facing backwards.
	if(new_dir == xeno.dir)
		xeno.setDir(last_dir)

/datum/action/xeno_action/onclick/select_alchem/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_alchemist/alchemist = xeno.behavior_delegate

	if(!isxeno(xeno))
		return

	if(!istype(xeno.behavior_delegate, alchemist))
		return

	if(!xeno.check_state())
		return

	if(alchemist.producing_alchem)
		to_chat(xeno, SPAN_XENOWARNING("We cannot change what chemicals to produce while producing chemicals!"))
		return

	alchemist.choose_alchem()
	return ..()

/datum/action/xeno_action/onclick/produce_alchem/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_alchemist/alchemist = xeno.behavior_delegate

	if(!isxeno(xeno))
		return

	if(!istype(xeno.behavior_delegate, alchemist))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(alchemist.total_pool == alchemist.total_pool_cap)
		to_chat(xeno, SPAN_XENOWARNING("We cannot stockpile any more chemicals!"))
		return

	if(alchemist.current_alchem == null)
		to_chat(xeno, SPAN_XENOWARNING("We haven't chosen any chemical to produce!"))
		return

	if(alchemist.producing_alchem)
		to_chat(xeno, SPAN_XENOWARNING("We're already making chemicals!"))
		return

	if(!check_plasma_owner())
		return

	alchemist.producing_alchem = TRUE
	if(!do_after(xeno, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		alchemist.producing_alchem = FALSE
		return
	alchemist.producing_alchem = FALSE
	alchemist.stockpile_alchem(amount)
	use_plasma_owner()
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/remove_alchem/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_alchemist/alchemist = xeno.behavior_delegate

	if(!isxeno(xeno))
		return

	if(!istype(xeno.behavior_delegate, alchemist))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(alchemist.total_pool == 0)
		to_chat(xeno, SPAN_XENOWARNING("We have no chemicals to remove!"))
		return

	if(alchemist.current_alchem == null)
		to_chat(xeno, SPAN_XENOWARNING("We haven't chosen any chemical for our body to remove!"))
		return

	if(alchemist.producing_alchem)
		to_chat(xeno, SPAN_XENOWARNING("We cannot remove chemicals while making chemicals!"))
		return

	if(!check_plasma_owner())
		return

	alchemist.remove_alchem()
	use_plasma_owner()
	return ..()
