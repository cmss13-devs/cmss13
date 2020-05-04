/datum/xeno_mutator/praetorian_oppressor
	// Dread it, run from it, destiny still arrives.. or should I say, I do
	name = "STRAIN: Praetorian - Oppressor"
	description = "You abandon your speed to become a nigh-indestructible bulwark of the Queen. Your slashes deal increased damage to prone targets, and you gain a stomp that knocks over opponents in front of you as well as an ability that buffs your next slash and one that knocks your opponents back."
	flavor_description = "Dread it. Run from it. The Hive still arrives. Or, more accurately, you do."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Praetorian")  
	mutator_actions_to_remove = list("Xeno Spit","Dash", "Acid Ball", "Spray Acid")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/prae_stomp, /datum/action/xeno_action/onclick/crush, /datum/action/xeno_action/activable/tail_lash)
	behavior_delegate_type = /datum/behavior_delegate/oppressor_praetorian
	keystone = TRUE

/datum/xeno_mutator/praetorian_oppressor/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return
	
	var/mob/living/carbon/Xenomorph/Praetorian/P = MS.xeno
	
	P.armor_modifier += XENO_ARMOR_MOD_SMALL
	P.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_LARGE
	P.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	P.speed_modifier += XENO_SPEED_MOD_ULTRA
	P.plasma_types = list(PLASMA_NEUROTOXIN, PLASMA_CHITIN)
	
	mutator_update_actions(P)
	
	MS.recalculate_actions(description, flavor_description)

	apply_behavior_holder(P)
	
	P.recalculate_everything()
	P.mutation_type = PRAETORIAN_OPPRESSOR

/datum/behavior_delegate/oppressor_praetorian
	name = "Oppressor Praetorian Behavior Delegate"

	// Config
	var/additional_damage_vs_prone = 15
	var/crush_additional_damage = 15
	var/root_duration = 25
	
	// State
	// Check if our next slash is empowered by our 'crush' ability.
	var/next_slash_buffed = FALSE

/datum/behavior_delegate/oppressor_praetorian/melee_attack_additional_effects_target(atom/A)
	if (!istype(A, /mob/living/carbon/human))
		return 

	var/mob/living/carbon/human/H = A 
	if (H.stat)
		return

	var/total_bonus_damage = next_slash_buffed ? crush_additional_damage : 0

	if (H.knocked_down)
		total_bonus_damage += additional_damage_vs_prone
		if (next_slash_buffed)
			to_chat(H, SPAN_XENOHIGHDANGER("[bound_xeno] has pinned you to the ground! You cannot move!"))
			H.frozen = 1
			H.update_canmove()
			add_timer(CALLBACK(GLOBAL_PROC, .proc/unroot_human, H), root_duration)


	next_slash_buffed = FALSE
	H.apply_damage(total_bonus_damage, BRUTE)
	return