/datum/xeno_strain/dissolver
	name = SPITTER_DISSOLVER
	summary = "Trade health for more armor. Prepare acid reserves, then overwhelm prey with rapid volleys and spreading burns. Carrying more acid weakens your armor, so choose when to commit and when to recover."
	description = "At the cost of a little bit of your health and your spray and enhanced spit, you gain some armor, and further enhance your acid glands. You can store acid in these glands to increase the rate in which you can fire off your projectiles, yet considerably weaken your armor plating by doing so, up to a maximum of 5 times. Your spit now does considerably more damage as well as apply a lingering acid effect, while you now gain the ability to launch a blob of acid at a medium distance, which leaves behind a small area of acid, amplified if it hits a target directly by stunning the target. Additionally you can also now spit your acid in a wide arc, shooting multiple smaller pellets that inflict a small amount of damage but also coat the target in a layer of burning acid."
	flavor_description = "Your acid burns as much as my fury, let your acid blot out the sun, let them choke on their own misery."
	icon_state_prefix = "Dissolver"
	armor_mod = XENO_ARMOR_MOD_SMALL // 25 armor
	health_mod = -XENO_HEALTH_MOD_SMALL_MED // 500 hp
	speed_mod = XENO_SPEED_TIER_2

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab/spitter,
		/datum/action/xeno_action/activable/xeno_spit/spitter,
		/datum/action/xeno_action/onclick/charge_spit,
		/datum/action/xeno_action/activable/spray_acid/spitter,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/corosive_spit,
		/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/acid_blob,
		/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/enzymatic_breath,
		/datum/action/xeno_action/onclick/store_acid,
	)

	behavior_delegate_type = /datum/behavior_delegate/spitter_dissolver

/datum/xeno_strain/dissolver/apply_strain(mob/living/carbon/xenomorph/spitter/spitter)
	..()
	spitter.melee_damage_upper = XENO_DAMAGE_TIER_2
	spitter.plasma_gain = XENO_PLASMA_GAIN_TIER_8
	spitter.damage_state_prefix = icon_state_prefix

/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver
	xeno_cooldown = 11 SECONDS
	cooldown_duration = 11 SECONDS
	retarget_after_windup = TRUE
	var/stored_cooldown = 1 SECONDS
	action_types_to_cd = list(
		/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/corosive_spit,
		/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/acid_blob,
		/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/enzymatic_breath,
	)
	var/second_cooldown_duration = 4 SECONDS
	var/action_types_to_secondary_cd = list(
		/datum/action/xeno_action/onclick/store_acid,
	)
	var/datum/ammo/xeno/ammo

/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/can_use_action()
	. = ..()
	if(owner && owner.action_busy)
		return FALSE

/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/spitter/xeno = owner
	var/datum/behavior_delegate/delegate = xeno.behavior_delegate
	var/datum/behavior_delegate/spitter_dissolver/dissolver_delegate
	if(istype(delegate, /datum/behavior_delegate/spitter_dissolver))
		dissolver_delegate = delegate
		if(dissolver_delegate.acid_stored > 0)
			cooldown_duration = stored_cooldown
	. = ..()
	if(!.)
		return FALSE
	cooldown_duration = initial(cooldown_duration)


	if(dissolver_delegate)
		dissolver_delegate.use_acid()
	for (var/action_type in action_types_to_secondary_cd)
		var/datum/action/xeno_action/xeno_action = get_action(xeno, action_type)
		if (!istype(xeno_action))
			continue
		xeno_action.apply_cooldown_override(second_cooldown_duration)

/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/action_activate()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	xeno.ammo = GLOB.ammo_list[ammo]


/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/corosive_spit
	ability_stats_type = /datum/xeno_ability_stats/dissolver_corosive_spit
	ability_description = "Fire piercing acid that burns over time. High acid reserves improve penetration."
	name = "Corrosive Spit"
	action_icon_state = "xeno_spit"
	plasma_cost = 45
	ammo = /datum/ammo/xeno/acid/spatter/dissolver_corrosive_spit
	ability_primacy = XENO_PRIMARY_ACTION_1
	var/list/options_ammo_list = list(/datum/ammo/xeno/acid/spatter/dissolver_corrosive_spit/one_penetrations, /datum/ammo/xeno/acid/spatter/dissolver_corrosive_spit/two_penetrations, /datum/ammo/xeno/acid/spatter/dissolver_corrosive_spit/three_penetrations)

XENO_ABILITY_STATS(dissolver_corosive_spit, datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/corosive_spit)
	var/datum/ammo/ammo = XENO_ABILITY_VALUE(ability, ammo)
	return projectile_stats(ammo)

/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/corosive_spit/use_ability()
	var/mob/living/carbon/xenomorph/spitter/xeno = owner
	var/datum/behavior_delegate/delegate = xeno.behavior_delegate
	var/datum/behavior_delegate/spitter_dissolver/dissolver_delegate
	if(istype(delegate, /datum/behavior_delegate/spitter_dissolver))
		dissolver_delegate = delegate
		xeno.ammo = GLOB.ammo_list[options_ammo_list[max(1, dissolver_delegate.acid_stored - 2)]]
	else
		xeno.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/spatter/dissolver_corrosive_spit]
	. = ..()

/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/acid_blob
	ability_stats_type = /datum/xeno_ability_stats/dissolver_acid_blob
	ability_description = "Launch a blob that bursts into smaller projectiles. Hits on acid coated targets intensify the acid and knock them down."
	name = "Acid Blob"
	action_icon_state = "acid_glob"
	plasma_cost = 65
	ammo = /datum/ammo/xeno/acid/dissolver_acid_blob
	ability_primacy = XENO_PRIMARY_ACTION_2

XENO_ABILITY_STATS(dissolver_acid_blob, datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/acid_blob)
	var/datum/ammo/ammo = XENO_ABILITY_VALUE(ability, ammo)
	return projectile_stats(ammo)

/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/enzymatic_breath
	ability_stats_type = /datum/xeno_ability_stats/dissolver_enzymatic_breath
	ability_description = "Fire a spread of burning acid pellets. Heavily slow prey, or root already heavily slowed targets. Stored acid shortens the windup."
	name = "Enzymatic Breath"
	action_icon_state = "breath"
	plasma_cost = 55
	ammo = /datum/ammo/xeno/acid/spatter/dissolver_enzymatic_breath
	ability_primacy = XENO_PRIMARY_ACTION_3
	var/stack_windup_reduction = 0.1 SECONDS

XENO_ABILITY_STATS(dissolver_enzymatic_breath, datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/enzymatic_breath)
	var/datum/ammo/ammo = XENO_ABILITY_VALUE(ability, ammo)
	return projectile_stats(ammo)

/datum/action/xeno_action/activable/xeno_spit/bombard/dissolver/enzymatic_breath/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/spitter/xeno = owner
	var/datum/behavior_delegate/delegate = xeno.behavior_delegate
	var/datum/behavior_delegate/spitter_dissolver/dissolver_delegate
	var/initial_windup = xeno.ammo.spit_windup
	if(istype(delegate, /datum/behavior_delegate/spitter_dissolver))
		dissolver_delegate = delegate
		xeno.ammo.spit_windup -= stack_windup_reduction * dissolver_delegate.acid_stored
	. = ..()
	xeno.ammo.spit_windup = initial_windup



/datum/action/xeno_action/onclick/store_acid
	ability_description = "Store an acid charge at the cost of armor. Firing a charge restores that armor and shortens the projectile cooldown."
	ability_stats_type = /datum/xeno_ability_stats/store_acid
	name = "Store Acid"
	action_icon_state = "store_acid_base"
	xeno_cooldown = 5 SECONDS
	plasma_cost = 150
	ability_primacy = XENO_PRIMARY_ACTION_4

XENO_ABILITY_STATS(store_acid, datum/action/xeno_action/onclick/store_acid)
	var/capacity = /datum/behavior_delegate/spitter_dissolver::resource_capacity
	var/armor = /datum/behavior_delegate/spitter_dissolver::armor_reduction_per_stored
	var/cooldown = /datum/action/xeno_action/activable/xeno_spit/bombard/dissolver::stored_cooldown
	return list(
		XENO_STAT_PLASMA(plasma_cost, "Plasma cost per charge"),
		XENO_STAT_VALUE("Maximum charges", capacity, null, "."),
		XENO_STAT_VALUE("Armor lost per charge", armor, null, "."),
		XENO_STAT_VALUE("Charged projectile cooldown", cooldown * 0.1, null, "s."),
	)

/datum/action/xeno_action/onclick/store_acid/can_use_action()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno)
		return FALSE
	var/datum/behavior_delegate/spitter_dissolver/delegate = xeno.behavior_delegate
	if(xeno && !xeno.is_mob_incapacitated() && !HAS_TRAIT(xeno, TRAIT_DAZED) && !xeno.buckled && xeno.plasma_stored >= plasma_cost && !xeno.action_busy && delegate && delegate.acid_stored < delegate.resource_capacity)
		return TRUE
	return FALSE

/datum/action/xeno_action/onclick/store_acid/update_button_icon()
	. = ..()
	if(!button || !owner)
		return
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_dissolver/delegate = xeno.behavior_delegate


	button.overlays.Cut(2,0)
	if(!delegate.acid_stored)
		return
	button.overlays += image(icon_file, button, "charge_[delegate.acid_stored]")



/datum/action/xeno_action/onclick/store_acid/use_ability(atom/target)
	. = ..()
	if(!.)
		return FALSE
	if(!action_cooldown_check())
		return FALSE
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_dissolver/delegate = xeno.behavior_delegate
	if(!delegate)
		return
	if(!check_and_use_plasma_owner())
		return
	delegate.store_acid()
	apply_cooldown()




/datum/behavior_delegate/spitter_dissolver
	resource_name = "Stored Acid"
	resource_capacity = 5
	resource_icon_state = "store_acid_base"
	resource_description = "Store charges for 150 plasma each. Each charge costs 5 armor until consumed by a shot, then restores that armor and reduces the shared projectile cooldown to 1 second."
	var/acid_stored = 0
	var/armor_reduction_per_stored = 5

/datum/behavior_delegate/spitter_dissolver/preview_resource_amount()
	return acid_stored

/datum/behavior_delegate/spitter_dissolver/proc/store_acid()
	if(acid_stored == resource_capacity)
		return FALSE
	acid_stored++
	bound_xeno.armor_modifier -= armor_reduction_per_stored
	bound_xeno.recalculate_armor()
	return TRUE

/datum/behavior_delegate/spitter_dissolver/proc/use_acid()
	if(acid_stored == 0)
		return FALSE
	acid_stored--
	bound_xeno.armor_modifier += armor_reduction_per_stored
	bound_xeno.recalculate_armor()
	return TRUE




