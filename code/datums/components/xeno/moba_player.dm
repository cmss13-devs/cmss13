/datum/component/moba_player
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/xenomorph/parent_xeno
	var/datum/moba_player/player_datum
	var/datum/moba_caste/player_caste

	var/level = 1
	var/level_cap = 12
	var/xp = 0
	var/gold = 0
	var/static/list/level_up_thresholds = list(
		280, // level 2
		380, // 3
		480, // 4
		580, // 5
		680, // 6
		780, // 7
		880, // 8
		980, // 9
		1080, // 10
		1180, // 11
		1280, // 12
	)

	var/list/datum/moba_item/held_items = list()
	var/map_id = 0
	/// If true, on the right team. If false, on the left team
	var/right_side = FALSE

/datum/component/moba_player/Initialize(datum/moba_player/player, id, right)
	. = ..()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE

	parent_xeno = parent
	parent_xeno.melee_damage_lower = parent_xeno.melee_damage_upper // Randomization is bad so we set melee damage to be the max possible
	ADD_TRAIT(parent_xeno, TRAIT_MOBA_PARTICIPANT, TRAIT_SOURCE_INHERENT)
	player_datum = player
	player_caste = GLOB.moba_castes[parent_xeno.caste.type]
	map_id = id
	right_side = right

/datum/component/moba_player/Destroy(force, silent)
	handle_qdel()
	return ..()

/datum/component/moba_player/RegisterWithParent()
	..()
	RegisterSignal(parent_xeno, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdel))
	RegisterSignal(parent_xeno, COMSIG_XENO_BULLET_ACT, PROC_REF(on_bullet_act))
	RegisterSignal(parent_xeno, COMSIG_MOBA_GIVE_XP, PROC_REF(grant_xp))
	RegisterSignal(parent_xeno, COMSIG_MOBA_GIVE_GOLD, PROC_REF(grant_gold))
	RegisterSignal(parent_xeno, COMSIG_XENO_USED_TUNNEL, PROC_REF(on_tunnel))

/datum/component/moba_player/proc/handle_level_up()
	level++
	for(var/datum/moba_item/item as anything in held_items)
		item.unapply_stats(parent_xeno, src, player_datum)
	player_caste.handle_level_up(parent_xeno, src, player_datum, level)
	for(var/datum/moba_item/item as anything in held_items)
		item.apply_stats(parent_xeno, src, player_datum, TRUE)

/datum/component/moba_player/proc/handle_qdel()
	SIGNAL_HANDLER

	REMOVE_TRAIT(parent_xeno, TRAIT_MOBA_PARTICIPANT, TRAIT_SOURCE_INHERENT)
	parent_xeno = null
	player_caste = null
	QDEL_NULL(player_datum)

/// If the bullet is acidic, we don't use the value gotten from armor and instead use the acid_armor value
/datum/component/moba_player/proc/on_bullet_act(mob/living/carbon/xenomorph/acting_xeno, list/damage_result, pre_mitigation_damage, ammo_flags, obj/projectile/acting_projectile)
	SIGNAL_HANDLER

	if((acting_projectile.ammo.flags_ammo_behavior|acting_projectile.projectile_override_flags) & AMMO_ACIDIC)
	// account for penetration
		damage_result[1] = pre_mitigation_damage * (0.01 * (100 - (parent_xeno.acid_armor + parent_xeno.acid_armor_buff - parent_xeno.acid_armor_debuff - acting_projectile.ammo.penetration)))

// At some point we need to account for acid damage from melee if that ever gets implemented

/datum/component/moba_player/proc/grant_xp(datum/source, xp_amount = 0)
	SIGNAL_HANDLER

	if(level >= level_cap)
		return

	xp += xp_amount
	while(TRUE)
		if(level >= level_cap)
			break

		if(xp > level_up_thresholds[level])
			xp = max(0, xp - level_up_thresholds[level])
			handle_level_up()
		else
			break

/datum/component/moba_player/proc/grant_gold(datum/source, gold_amount = 0)
	SIGNAL_HANDLER

	gold += gold_amount

/datum/component/moba_player/proc/on_tunnel(datum/source, obj/structure/tunnel/used_tunnel)
	SIGNAL_HANDLER

	var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)
	if(right_side)
		parent_xeno.forceMove(controller.right_base)
	else
		parent_xeno.forceMove(controller.left_base)

	to_chat(parent_xeno, SPAN_XENO("We travel back to our hive."))
	playsound(parent_xeno, 'sound/effects/burrowoff.ogg', 25)
