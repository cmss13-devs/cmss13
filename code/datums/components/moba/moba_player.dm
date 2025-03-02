/datum/component/moba_player
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/xenomorph/parent_xeno
	var/datum/moba_player/player_datum
	var/datum/moba_caste/player_caste
	var/datum/moba_item_store/store_ui

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
	) // 8580 XP to level 12

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
	parent_xeno.cooldown_reduction_max = 1 // We allow for cooldown reductions up to 100%, though not feasibly possible
	parent_xeno.sight = SEE_TURFS // We allow seeing turfs but not mobs
	parent_xeno.need_weeds = FALSE
	ADD_TRAIT(parent_xeno, TRAIT_MOBA_PARTICIPANT, TRAIT_SOURCE_INHERENT)
	parent_xeno.AddComponent(\
		/datum/component/moba_death_reward,\
		300,\
		player_datum.level * MOBA_XP_ON_KILL_PER_PLAYER_LEVEL,\
		player.right_team ? XENO_HIVE_MOBA_RIGHT : XENO_HIVE_MOBA_LEFT,\
		TRUE,\
	)
	for(var/datum/action/action_path as anything in parent_xeno.base_actions)
		remove_action(parent_xeno, action_path)

	player_datum = player
	player_caste = GLOB.moba_castes[parent_xeno.caste.type]
	map_id = id
	right_side = right
	store_ui = new(parent_xeno)

/datum/component/moba_player/Destroy(force, silent)
	handle_qdel()
	return ..()

/datum/component/moba_player/RegisterWithParent()
	..()
	RegisterSignal(parent_xeno, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdel))
	RegisterSignal(parent_xeno, COMSIG_XENO_BULLET_ACT, PROC_REF(on_bullet_act))
	RegisterSignal(parent_xeno, COMSIG_XENO_ALIEN_ATTACKED, PROC_REF(on_attacked))
	RegisterSignal(parent_xeno, COMSIG_MOBA_GIVE_XP, PROC_REF(grant_xp))
	RegisterSignal(parent_xeno, COMSIG_MOBA_GIVE_GOLD, PROC_REF(grant_gold))
	RegisterSignal(parent_xeno, COMSIG_MOBA_GET_OWNED_ITEMS, PROC_REF(get_owned_items))
	RegisterSignal(parent_xeno, COMSIG_MOBA_GET_GOLD, PROC_REF(get_gold))
	RegisterSignal(parent_xeno, COMSIG_MOBA_GET_LEVEL, PROC_REF(get_level))
	RegisterSignal(parent_xeno, COMSIG_MOBA_ADD_ITEM, PROC_REF(add_item))
	RegisterSignal(parent_xeno, COMSIG_XENO_USED_TUNNEL, PROC_REF(on_tunnel))
	RegisterSignal(parent_xeno, COMSIG_MOB_DEATH, PROC_REF(on_death))
	RegisterSignal(parent_xeno, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(get_status_tab_item))
	RegisterSignal(parent_xeno, COMSIG_MOB_KILLED_MOB, PROC_REF(on_kill))
	RegisterSignal(parent_xeno, COMSIG_XENO_ADD_ABILITIES, PROC_REF(on_add_abilities))

/datum/component/moba_player/proc/handle_level_up()
	player_datum.level++
	for(var/datum/moba_item/item as anything in held_items)
		item.unapply_stats(parent_xeno, src, player_datum)
	player_caste.handle_level_up(parent_xeno, src, player_datum, player_datum.level)
	for(var/datum/moba_item/item as anything in held_items)
		item.apply_stats(parent_xeno, src, player_datum, TRUE)
	SEND_SIGNAL(player_datum, COMSIG_MOBA_LEVEL_UP, player_datum.level)
	qdel(parent_xeno.GetComponent(/datum/component/moba_death_reward))
	parent_xeno.AddComponent(\
		/datum/component/moba_death_reward,\
		300,\
		player_datum.level * MOBA_XP_ON_KILL_PER_PLAYER_LEVEL,\
		player_datum.right_team ? XENO_HIVE_MOBA_RIGHT : XENO_HIVE_MOBA_LEFT,\
		TRUE,\
	) // We refresh this because we're a level higher, so more XP on kill

/datum/component/moba_player/proc/handle_qdel()
	SIGNAL_HANDLER

	parent_xeno = null
	player_caste = null
	QDEL_NULL(player_datum)

/// If the bullet is acidic, we don't use the value gotten from armor and instead use the acid_armor value
/datum/component/moba_player/proc/on_bullet_act(mob/living/carbon/xenomorph/acting_xeno, list/damage_result, pre_mitigation_damage, ammo_flags, obj/projectile/acting_projectile)
	SIGNAL_HANDLER

	if((acting_projectile.ammo.flags_ammo_behavior|acting_projectile.projectile_override_flags) & AMMO_ACIDIC)
		//damage_result[1] = pre_mitigation_damage * (0.01 * (100 - (parent_xeno.acid_armor + parent_xeno.acid_armor_buff - parent_xeno.acid_armor_debuff - acting_projectile.ammo.penetration)))
		damage_result[1] = armor_damage_reduction(
			GLOB.xeno_ranged,
			damage_result[1],
			parent_xeno.acid_armor + parent_xeno.acid_armor_buff - parent_xeno.acid_armor_debuff,
			acting_projectile.ammo.penetration,
			//zonenote modify this if we ever add armor integrity for acid armor
		)

/datum/component/moba_player/proc/on_attacked(datum/source, mob/living/carbon/xenomorph/attacking_xeno)
	SIGNAL_HANDLER

	if(parent_xeno.hive.is_ally(attacking_xeno))
		return

	ADD_TRAIT(attacking_xeno, TRAIT_MOBA_ATTACKED_HIVE(parent_xeno.hive.hivenumber), "[REF(attacking_xeno)]")
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_remove_trait), attacking_xeno, TRAIT_MOBA_ATTACKED_HIVE(parent_xeno.hive.hivenumber), "[REF(attacking_xeno)]"), 4 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

// At some point we need to account for acid damage from melee if that ever gets implemented

/datum/component/moba_player/proc/grant_xp(datum/source, xp_amount = 0)
	SIGNAL_HANDLER

	if(player_datum.level >= MOBA_MAX_LEVEL)
		return

	player_datum.xp += xp_amount
	while(TRUE)
		if(player_datum.level >= MOBA_MAX_LEVEL)
			break

		if(player_datum.xp > level_up_thresholds[player_datum.level])
			player_datum.xp = max(0, player_datum.xp - level_up_thresholds[player_datum.level])
			handle_level_up()
		else
			break

/datum/component/moba_player/proc/grant_gold(datum/source, gold_amount = 0)
	SIGNAL_HANDLER

	player_datum.gold += gold_amount

/datum/component/moba_player/proc/get_owned_items(datum/source, list/datum/moba_item/items)
	SIGNAL_HANDLER

	for(var/datum/moba_item/item as anything in held_items)
		items += item

/datum/component/moba_player/proc/get_gold(datum/source, list/gold_list)
	SIGNAL_HANDLER

	gold_list += player_datum.gold

/datum/component/moba_player/proc/get_level(datum/source, list/level_list)
	SIGNAL_HANDLER

	level_list += player_datum.level

/datum/component/moba_player/proc/add_item(datum/source, datum/moba_item/new_item)
	SIGNAL_HANDLER

	held_items += new_item
	new_item.apply_stats(parent_xeno, src, player_datum, TRUE)
	player_datum.held_item_types += new_item.type

/datum/component/moba_player/proc/on_tunnel(datum/source, obj/structure/tunnel/used_tunnel)
	SIGNAL_HANDLER

	var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)
	if(right_side)
		parent_xeno.forceMove(controller.right_base)
	else
		parent_xeno.forceMove(controller.left_base)

	to_chat(parent_xeno, SPAN_XENO("We travel back to our hive."))
	playsound(parent_xeno, 'sound/effects/burrowoff.ogg', 25)

/datum/component/moba_player/proc/on_death(datum/source)
	SIGNAL_HANDLER

	remove_action(parent_xeno, /datum/action/ghost/xeno)
	player_datum.deaths++
	SSmoba.get_moba_controller(map_id).start_respawn(player_datum)

/datum/component/moba_player/proc/on_kill(datum/source, mob/killed)
	SIGNAL_HANDLER

	player_datum.kills++

/datum/component/moba_player/proc/get_status_tab_item(datum/source, list/status_tab_items)
	SIGNAL_HANDLER

	status_tab_items += "---------------------------"
	var/duration = SSmoba.get_moba_controller(map_id).game_duration
	var/minutes = floor(SSmoba.get_moba_controller(map_id).game_duration / 600)
	var/seconds = floor((duration - (minutes * 600)) * 0.1)
	if(minutes <= 9)
		minutes = "0[minutes]"
	else
		minutes = "[minutes]"
	if(seconds <= 9)
		seconds = "0[seconds]"
	else
		seconds = "[seconds]"
	status_tab_items += "Round Time: [minutes]:[seconds]"
	status_tab_items += "[MOBA_GOLD_NAME]: [player_datum.gold]"
	status_tab_items += "Level: [player_datum.level]/[MOBA_MAX_LEVEL]"
	status_tab_items += "XP: [player_datum.xp]/[level_up_thresholds[player_datum.level]]"
	var/item_names = ""
	for(var/datum/moba_item/item as anything in held_items)
		item_names += item.name + (item == held_items[length(held_items)] ? "" : ", ")
	status_tab_items += "Items: [item_names]"
	status_tab_items += "---------------------------"

/// None of the default xeno abilities really matter for us
/datum/component/moba_player/proc/on_add_abilities(datum/source)
	SIGNAL_HANDLER

	return COMPONENT_CANCEL_ADDING_ABILITIES
