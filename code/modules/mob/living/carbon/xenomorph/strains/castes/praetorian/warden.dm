/datum/xeno_strain/warden
	// i mean so basically im braum
	name = PRAETORIAN_WARDEN
	description = "You trade your acid ball, acid spray, dash, and a small bit of your slash damage and speed to become an effective medic. You gain the ability to emit strong pheromones, an ability that retrieves endangered, knocked-down or resting allies and pulls them to your location, and you gain an internal hitpoint pool that fills with every slash against your enemies, which can be spent to aid your allies and yourself by healing them or curing their ailments."
	flavor_description = "This one will deny her sisters' deaths until they earn it. Fight or be forgotten."
	icon_state_prefix = "Warden"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/onclick/tacmap,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/spray_acid/prae_warden,
		/datum/action/xeno_action/activable/warden_heal,
		/datum/action/xeno_action/activable/prae_retrieve,
		/datum/action/xeno_action/onclick/prae_switch_heal_type,
		/datum/action/xeno_action/onclick/tacmap,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_warden

/datum/xeno_strain/warden/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	// Make a 'halftank'
	prae.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	prae.damage_modifier -= XENO_DAMAGE_MOD_SMALL

	prae.recalculate_everything()

/datum/behavior_delegate/praetorian_warden
	name = "Praetorian Warden Behavior Delegate"

	// Config
	var/internal_hitpoints_max = 350
	var/internal_hitpoints_per_attack = 50
	var/internal_hp_per_life = 5


	// State
	var/internal_hitpoints = 0
	var/transferred_healing = 0

/datum/behavior_delegate/praetorian_warden/append_to_stat()
	. = list()
	. += "Energy Reserves: [internal_hitpoints]/[internal_hitpoints_max]"
	. += "Healing Done: [transferred_healing]"

/datum/behavior_delegate/praetorian_warden/on_life()
	internal_hitpoints = min(internal_hitpoints_max, internal_hitpoints + internal_hp_per_life)

	var/mob/living/carbon/xenomorph/praetorian/praetorian = bound_xeno
	var/image/holder = praetorian.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

	if(praetorian.stat == DEAD)
		return

	var/percentage_energy = round((internal_hitpoints / internal_hitpoints_max) * 100, 10)
	if(percentage_energy)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_energy]")

/datum/behavior_delegate/praetorian_warden/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/praetorian_warden/melee_attack_additional_effects_self()
	..()

	add_internal_hitpoints(internal_hitpoints_per_attack)

/datum/behavior_delegate/praetorian_warden/ranged_attack_additional_effects_target(atom/target_atom)
	if(ismob(target_atom))
		add_internal_hitpoints(internal_hitpoints_per_attack)

/datum/behavior_delegate/praetorian_warden/proc/add_internal_hitpoints(amount)
	if (amount > 0)
		if (internal_hitpoints >= internal_hitpoints_max)
			return
		to_chat(bound_xeno, SPAN_XENODANGER("You feel your internal health reserves increase!"))
	internal_hitpoints = clamp(internal_hitpoints + amount, 0, internal_hitpoints_max)

/datum/behavior_delegate/praetorian_warden/proc/remove_internal_hitpoints(amount)
	add_internal_hitpoints(-1*amount)

/datum/behavior_delegate/praetorian_warden/proc/use_internal_hp_ability(cost)
	if (cost > internal_hitpoints)
		to_chat(bound_xeno, SPAN_XENODANGER("Your health reserves are insufficient! You need at least [cost] to do that!"))
		return FALSE
	else
		remove_internal_hitpoints(cost)
		return TRUE


/datum/action/xeno_action/activable/warden_heal/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/wardenbuff_user = owner
	if (!istype(wardenbuff_user))
		return

	if (!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(wardenbuff_user.loc) || !wardenbuff_user.check_state(TRUE))
		return

	if (!isxeno(A) || !wardenbuff_user.can_not_harm(A))
		to_chat(wardenbuff_user, SPAN_XENODANGER("We must target one of our sisters!"))
		return

	if (A == wardenbuff_user)
		to_chat(wardenbuff_user, SPAN_XENODANGER("We cannot heal ourself!"))
		return

	if (A.z != wardenbuff_user.z)
		to_chat(wardenbuff_user, SPAN_XENODANGER("That Sister is too far away!"))
		return

	var/mob/living/carbon/xenomorph/targetXeno = A

	if(targetXeno.stat == DEAD)
		to_chat(wardenbuff_user, SPAN_WARNING("[targetXeno] is already dead!"))
		return

	if (!check_plasma_owner())
		return

	var/use_plasma = FALSE

	if (curr_effect_type == WARDEN_HEAL_SHIELD)
		if (SEND_SIGNAL(targetXeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			to_chat(wardenbuff_user, SPAN_XENOWARNING("We cannot bolster the defenses of this xeno!"))
			return

		var/bonus_shield = 0

		var/datum/behavior_delegate/praetorian_warden/behavior = wardenbuff_user.behavior_delegate
		if (!istype(behavior))
			return

		if (!behavior.use_internal_hp_ability(shield_cost))
			return

		bonus_shield = behavior.internal_hitpoints*0.5
		if (!behavior.use_internal_hp_ability(bonus_shield))
			bonus_shield = 0

		var/total_shield_amount = shield_amount + bonus_shield

		if (wardenbuff_user.observed_xeno != null)
			to_chat(wardenbuff_user, SPAN_XENOHIGHDANGER("We cannot shield [targetXeno] as effectively over distance!"))
			total_shield_amount = total_shield_amount/4
			targetXeno.visible_message(SPAN_BOLDNOTICE("[targetXeno]'s exoskeleton shimmers for a fraction of a second."))//marines probably should know if a xeno gets healed
		else //so both visible messages don't appear at the same time
			targetXeno.visible_message(SPAN_BOLDNOTICE("[wardenbuff_user] points at [targetXeno], and it shudders as its exoskeleton shimmers for a second!")) //this one is a bit less important than healing and rejuvenating
		to_chat(wardenbuff_user, SPAN_XENODANGER("We bolster the defenses of [targetXeno]!")) //but i imagine it'll be useful for predators, survivors and for battle flavor
		to_chat(targetXeno, SPAN_XENOHIGHDANGER("We feel our defenses bolstered by [wardenbuff_user]!"))

		targetXeno.add_xeno_shield(total_shield_amount, XENO_SHIELD_SOURCE_WARDEN_PRAE, duration = shield_duration, decay_amount_per_second = shield_decay)
		targetXeno.xeno_jitter(1 SECONDS)
		targetXeno.flick_heal_overlay(3 SECONDS, "#FFA800") //D9F500
		wardenbuff_user.add_xeno_shield(total_shield_amount*0.5, XENO_SHIELD_SOURCE_WARDEN_PRAE, duration = shield_duration, decay_amount_per_second = shield_decay) // X is the prae itself
		wardenbuff_user.xeno_jitter(1 SECONDS)
		wardenbuff_user.flick_heal_overlay(3 SECONDS, "#FFA800") //D9F500
		use_plasma = TRUE

	else if (curr_effect_type == WARDEN_HEAL_HP)
		if (!wardenbuff_user.Adjacent(A))
			to_chat(wardenbuff_user, SPAN_XENODANGER("We must be within touching distance of [targetXeno]!"))
			return
		if (SEND_SIGNAL(targetXeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			to_chat(wardenbuff_user, SPAN_XENOWARNING("We cannot heal this xeno!"))
			return

		var/bonus_heal = 0
		var/datum/behavior_delegate/praetorian_warden/behavior = wardenbuff_user.behavior_delegate
		if (!istype(behavior))
			return

		if (!behavior.use_internal_hp_ability(heal_cost))
			return

		bonus_heal = behavior.internal_hitpoints*0.5
		if (!behavior.use_internal_hp_ability(bonus_heal))
			bonus_heal = 0

		to_chat(wardenbuff_user, SPAN_XENOHIGHDANGER("We heal [targetXeno]!"))
		to_chat(targetXeno, SPAN_XENOHIGHDANGER("We are healed by [wardenbuff_user]!"))
		//Amount to heal in this cast of the ability
		var/quantity_healed = heal_amount
		if(istype(targetXeno.strain, /datum/xeno_strain/warden))
			quantity_healed = quantity_healed / 2	// Half the healing if warden

		else
			quantity_healed = quantity_healed + bonus_heal

		targetXeno.gain_health(quantity_healed)
		targetXeno.visible_message(SPAN_BOLDNOTICE("[wardenbuff_user] places its claws on [targetXeno], and its wounds are quickly sealed!")) //marines probably should know if a xeno gets healed
		wardenbuff_user.gain_health(heal_amount*0.5 + bonus_heal*0.5)
		wardenbuff_user.flick_heal_overlay(3 SECONDS, "#00B800")
		behavior.transferred_healing += quantity_healed
		use_plasma = TRUE //it's already hard enough to gauge health without hp showing on the mob
		targetXeno.flick_heal_overlay(3 SECONDS, "#00B800")//so the visible_message and recovery overlay will warn marines and possibly predators that the xenomorph has been healed!

	else if (curr_effect_type == WARDEN_HEAL_DEBUFFS)
		if (wardenbuff_user.observed_xeno != null)
			to_chat(wardenbuff_user, SPAN_XENOHIGHDANGER("We cannot rejuvenate targets through overwatch!"))
			return

		var/datum/behavior_delegate/praetorian_warden/behavior = wardenbuff_user.behavior_delegate
		if (!istype(behavior))
			return

		if (!behavior.use_internal_hp_ability(debuff_cost))
			return

		to_chat(wardenbuff_user, SPAN_XENOHIGHDANGER("We rejuvenate [targetXeno]!"))
		to_chat(targetXeno, SPAN_XENOHIGHDANGER("We are rejuvenated by [wardenbuff_user]!"))
		targetXeno.visible_message(SPAN_BOLDNOTICE("[wardenbuff_user] points at [targetXeno], and it spasms as it recuperates unnaturally quickly!")) //marines probably should know if a xeno gets rejuvenated
		targetXeno.xeno_jitter(1 SECONDS) //it might confuse them as to why the queen got up half a second after being AT rocketed, and give them feedback on the Praetorian rejuvenating
		targetXeno.flick_heal_overlay(3 SECONDS, "#F5007A") //therefore making the Praetorian a priority target
		targetXeno.clear_debuffs()
		use_plasma = TRUE
	if (use_plasma)
		use_plasma_owner()

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/prae_retrieve/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/warden = owner
	if(!istype(warden))
		return

	var/datum/behavior_delegate/praetorian_warden/behavior = warden.behavior_delegate
	if(!istype(behavior))
		return

	if(warden.observed_xeno != null)
		to_chat(warden, SPAN_XENOHIGHDANGER("We cannot retrieve sisters through overwatch!"))
		return

	if(!isxeno(A) || !warden.can_not_harm(A))
		to_chat(warden, SPAN_XENODANGER("We must target one of our sisters!"))
		return

	if(A == warden)
		to_chat(warden, SPAN_XENODANGER("We cannot retrieve ourself!"))
		return

	if(!(A in view(7, warden)))
		to_chat(warden, SPAN_XENODANGER("That sister is too far away!"))
		return

	var/mob/living/carbon/xenomorph/targetXeno = A

	if(targetXeno.anchored)
		to_chat(warden, SPAN_XENODANGER("That sister cannot move!"))
		return

	if(!(targetXeno.resting || targetXeno.stat == UNCONSCIOUS))
		if(targetXeno.mob_size > MOB_SIZE_BIG)
			to_chat(warden, SPAN_WARNING("[targetXeno] is too big to retrieve while standing up!"))
			return

	if(targetXeno.stat == DEAD)
		to_chat(warden, SPAN_WARNING("[targetXeno] is already dead!"))
		return

	if(!action_cooldown_check() || warden.action_busy)
		return

	if(!warden.check_state())
		return

	if(!check_plasma_owner())
		return

	if(!behavior.use_internal_hp_ability(retrieve_cost))
		return

	if(!check_and_use_plasma_owner())
		return

	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(warden, A)
	var/reversefacing = get_dir(A, warden)
	var/turf/T = warden.loc
	var/turf/temp = warden.loc
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
			to_chat(warden, SPAN_XENOWARNING("We can't reach [targetXeno] with our resin retrieval hook!"))
			return

		T = temp

		if(T in turflist)
			break

		turflist += T
		facing = get_dir(T, A)
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/green(T, windup)

	if(!length(turflist))
		to_chat(warden, SPAN_XENOWARNING("We don't have any room to do our retrieve!"))
		return

	warden.visible_message(SPAN_XENODANGER("[warden] prepares to fire its resin retrieval hook at [A]!"), SPAN_XENODANGER("We prepare to fire our resin retrieval hook at [A]!"))
	warden.emote("roar")

	var/throw_target_turf = get_step(warden.loc, facing)
	var/turf/behind_turf = get_step(warden.loc, reversefacing)
	if(!(behind_turf.density))
		throw_target_turf = behind_turf

	ADD_TRAIT(warden, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Praetorian Retrieve"))
	if(windup)
		if(!do_after(warden, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 1))
			to_chat(warden, SPAN_XENOWARNING("We cancel our retrieve."))
			apply_cooldown()

			for (var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
				telegraph_atom_list -= XT
				qdel(XT)

			REMOVE_TRAIT(warden, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Praetorian Retrieve"))

			return

	REMOVE_TRAIT(warden, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Praetorian Retrieve"))

	playsound(get_turf(warden), 'sound/effects/bang.ogg', 25, 0)

	var/successful_retrieve = FALSE
	for(var/turf/target_turf in turflist)
		if(targetXeno in target_turf)
			successful_retrieve = TRUE
			break

	if(!successful_retrieve)
		to_chat(warden, SPAN_XENOWARNING("We can't reach [targetXeno] with our resin retrieval hook!"))
		return

	to_chat(targetXeno, SPAN_XENOBOLDNOTICE("We are pulled toward [warden]!"))

	shake_camera(targetXeno, 10, 1)
	var/throw_dist = get_dist(throw_target_turf, targetXeno)-1
	if(throw_target_turf == behind_turf)
		throw_dist++
		to_chat(warden, SPAN_XENOBOLDNOTICE("We fling [targetXeno] over our head with our resin hook, and they land behind us!"))
	else
		to_chat(warden, SPAN_XENOBOLDNOTICE("We fling [targetXeno] towards us with our resin hook, and they land in front of us!"))
	targetXeno.throw_atom(throw_target_turf, throw_dist, SPEED_VERY_FAST, pass_flags = PASS_MOB_THRU)
	apply_cooldown()
	return ..()
