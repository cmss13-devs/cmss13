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

	var/healing_value_standing = 0
	var/healing_value_resting = 0
	var/plasma_value_standing = 0
	var/plasma_value_resting = 0
	/// How much HP we have that isn't from our caste. Used for item scaling and etc.
	var/bonus_hp = 0
	/// How much "Acid Power" (AP) we have, used for the scaling of certain abilities
	var/acid_power = 0

/datum/component/moba_player/Initialize(datum/moba_player/player, id, right)
	. = ..()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE

	map_id = id
	right_side = right
	player_datum = player

	parent_xeno = parent
	parent_xeno.melee_damage_lower = parent_xeno.melee_damage_upper // Randomization is bad so we set melee damage to be the max possible
	parent_xeno.cooldown_reduction_max = 1 // We allow for cooldown reductions up to 100%, though not feasibly possible
	parent_xeno.sight = SEE_TURFS // We allow seeing turfs but not mobs
	parent_xeno.need_weeds = FALSE
	parent_xeno.passive_healing = FALSE // We do this ourselves
	parent_xeno.gibs_path = /obj/effect/decal/remains/xeno/decaying
	parent_xeno.blood_path = /obj/effect/decal/cleanable/blood/xeno/decaying
	parent_xeno.create_hud()
	// cannot be bothered to create real hud elements
	var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)
	parent_xeno.hud_used.locate_marker.maptext = "<span class='maptext'>Team Wards: <b>[!right_side ? controller.team1_ward_count : controller.team2_ward_count]</b>/<b>[!right_side ? controller.team1_max_wards : controller.team2_max_wards]</b></span>"
	parent_xeno.hud_used.locate_marker.maptext_width = 128
	parent_xeno.hud_used.locate_marker.maptext_x = -48
	parent_xeno.hud_used.locate_marker.maptext_y = 160
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

	give_action(parent_xeno, /datum/action/open_moba_scoreboard, map_id)
	give_action(parent_xeno, /datum/action/xeno_action/watch_xeno)
	give_action(parent_xeno, /datum/action/xeno_action/activable/place_ward, null, null, right_side, map_id)

	store_ui = new(parent_xeno)
	player_caste = GLOB.moba_castes[parent_xeno.caste.type]
	player_caste.apply_caste(parent_xeno, src, player_datum)

	for(var/path in player_datum.held_item_types) // recreate any items that we had before we died
		var/datum/moba_item/new_item = new path
		held_items += new_item
		new_item.apply_stats(parent_xeno, src, player_datum, TRUE)

	START_PROCESSING(SSprocessing, src)

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
	RegisterSignal(parent_xeno, COMSIG_MOBA_GET_AP, PROC_REF(get_ap))
	RegisterSignal(parent_xeno, COMSIG_MOBA_ADD_ITEM, PROC_REF(add_item))
	RegisterSignal(parent_xeno, COMSIG_XENO_USED_TUNNEL, PROC_REF(on_tunnel))
	RegisterSignal(parent_xeno, COMSIG_MOB_DEATH, PROC_REF(on_death))
	RegisterSignal(parent_xeno, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(get_status_tab_item))
	RegisterSignal(parent_xeno, COMSIG_MOB_KILLED_MOB, PROC_REF(on_kill))
	RegisterSignal(parent_xeno, COMSIG_XENO_ADD_ABILITIES, PROC_REF(on_add_abilities))
	RegisterSignal(parent_xeno, COMSIG_XENO_TRY_HIVEMIND_TALK, PROC_REF(on_hivemind_talk))
	RegisterSignal(parent_xeno, COMSIG_XENO_TRY_OVERWATCH, PROC_REF(on_overwatch))
	RegisterSignal(parent_xeno, COMSIG_MOB_LOGGED_IN, PROC_REF(on_reconnect))

/datum/component/moba_player/proc/handle_level_up()
	player_datum.level_up()
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

/datum/component/moba_player/process(delta_time)
	if(parent_xeno.health < parent_xeno.maxHealth && parent_xeno.last_hit_time + parent_xeno.caste.heal_delay_time <= world.time && (!parent_xeno.caste || (parent_xeno.caste.fire_immunity & FIRE_IMMUNITY_NO_IGNITE) || !parent_xeno.fire_stacks) && parent_xeno.health < 0)
		var/damage_to_heal = 0
		if(parent_xeno.body_position == LYING_DOWN || parent_xeno.resting)
			damage_to_heal = healing_value_resting
		else
			damage_to_heal = healing_value_standing
		if(istype(get_area(parent_xeno), /area/misc/moba/base/fountain))
			damage_to_heal *= MOBA_FOUNTAIN_HEAL_MULTIPLIER
		var/brute = parent_xeno.getBruteLoss()
		var/burn = parent_xeno.getFireLoss()
		var/percentage_brute = brute / (brute + burn)
		var/percentage_burn = burn / (brute + burn)
		parent_xeno.apply_damage(-(damage_to_heal * percentage_brute), BRUTE)
		parent_xeno.apply_damage(-(damage_to_heal * percentage_burn), BURN)
		parent_xeno.updatehealth()

	if(parent_xeno.plasma_stored < parent_xeno.plasma_max)
		parent_xeno.plasma_stored += (parent_xeno.body_position == LYING_DOWN || parent_xeno.resting) ? plasma_value_resting : plasma_value_standing

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

		if(player_datum.xp >= level_up_thresholds[player_datum.level])
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

/datum/component/moba_player/proc/get_ap(datum/source, list/ap_list)
	SIGNAL_HANDLER

	ap_list += acid_power

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
	if(player_datum.level < MOBA_MAX_LEVEL)
		status_tab_items += "XP: [player_datum.xp]/[level_up_thresholds[player_datum.level]]"
	else
		status_tab_items += "XP: MAX"
	var/item_names = ""
	for(var/datum/moba_item/item as anything in held_items)
		item_names += item.name + (item == held_items[length(held_items)] ? "" : ", ")
	status_tab_items += "Items: [item_names]"
	status_tab_items += "---------------------------"

/// None of the default xeno abilities really matter for us
/datum/component/moba_player/proc/on_add_abilities(datum/source)
	SIGNAL_HANDLER

	return COMPONENT_CANCEL_ADDING_ABILITIES

/// We use our own bespoke hivemind speech so that we only talk to hive members in our map ID
/datum/component/moba_player/proc/on_hivemind_talk(datum/source, message)
	SIGNAL_HANDLER

	if(!message)
		return

	log_hivemind("[key_name(parent_xeno)] : [message]")

	for(var/mob/listener in GLOB.player_list)
		if(!QDELETED(listener) && (isxeno(listener) || listener.stat == DEAD) && !istype(listener, /mob/new_player))
			if(istype(listener, /mob/dead/observer))
				if(listener.client.prefs && listener.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
					var/track = "(<a href='byond://?src=\ref[listener];track=\ref[parent_xeno]'>F</a>)"
					listener.show_message(SPAN_XENO("Hivemind, [parent_xeno.name][track] hisses, <span class='normal'>'[message]'</span>"), SHOW_MESSAGE_AUDIBLE)

			else if((parent_xeno.hive.hivenumber == xeno_hivenumber(listener)) && HAS_TRAIT(listener, TRAIT_MOBA_MAP_PARTICIPANT(map_id)))
				var/overwatch_insert = " (<a href='byond://?src=\ref[listener];[XENO_OVERWATCH_TARGET_HREF]=\ref[parent_xeno];[XENO_OVERWATCH_SRC_HREF]=\ref[listener]'>watch</a>)"
				listener.show_message(SPAN_XENO("Hivemind, [parent_xeno.name][overwatch_insert] hisses, <span class='normal'>'[message]'</span>"), SHOW_MESSAGE_AUDIBLE)

	return COMPONENT_OVERRIDE_HIVEMIND_TALK

/// We also have our own overwatch
/datum/component/moba_player/proc/on_overwatch(datum/source)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(handle_overwatch))

	return COMPONENT_CANCEL_OVERWATCH

/datum/component/moba_player/proc/handle_overwatch() //zonenote: come back to this and clean up overwatching objects if this becomes a permanent thing
	if(parent_xeno.observed_xeno)
		parent_xeno.overwatch(parent_xeno.observed_xeno, TRUE)
		return

	var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)

	var/list/possible_things = list()
	for(var/datum/moba_player/player as anything in SSmoba.get_moba_controller(map_id).players)
		var/mob/living/carbon/xenomorph/player_xeno = player.get_tied_xeno()
		if((player == player_datum) || !player_xeno)
			continue

		if(player_xeno.hivenumber != player_datum.get_tied_xeno().hivenumber)
			continue

		if(!HAS_TRAIT(player_xeno, TRAIT_MOBA_MAP_PARTICIPANT(map_id)))
			continue

		possible_things += player_xeno

	var/list/ward_list
	if(!right_side)
		ward_list = controller.team1_wards
	else
		ward_list = controller.team2_wards

	for(var/obj/effect/alien/resin/construction/ward/ward as anything in ward_list)
		if(QDELETED(ward))
			ward_list -= ward
			continue

		possible_things += ward

	var/atom/selected_thing = tgui_input_list(parent_xeno, "Target", "Watch what?", possible_things, theme="hive_status")

	if(isxeno(selected_thing))
		var/mob/living/carbon/xenomorph/selected_xeno = selected_thing
		if(!selected_xeno || QDELETED(selected_xeno) || selected_xeno == parent_xeno.observed_xeno || selected_xeno.stat == DEAD || !parent_xeno.check_state(TRUE))
			parent_xeno.overwatch(parent_xeno.observed_xeno, TRUE) // Cancel OW
		else
			parent_xeno.overwatch(selected_xeno)
	else
		if(!selected_thing || QDELETED(selected_thing) || selected_thing == parent_xeno.observed_xeno)
			parent_xeno.overwatch(parent_xeno.observed_xeno, TRUE) // Cancel OW
		else
			parent_xeno.overwatch(selected_thing)

/datum/component/moba_player/proc/on_reconnect(mob/source)
	SIGNAL_HANDLER

	var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)
	if(!right_side)
		for(var/obj/effect/alien/resin/construction/ward/ward as anything in controller.team1_wards)
			parent_xeno.client.images += ward.appearance
	else
		for(var/obj/effect/alien/resin/construction/ward/ward as anything in controller.team2_wards)
			parent_xeno.client.images += ward.appearance

#ifdef MOBA_TESTING
/mob/living/carbon/xenomorph/proc/gxp()
	var/datum/component/moba_player/MP = GetComponent(/datum/component/moba_player)
	if(MP)
		MP.grant_xp(null, 1000)

/mob/living/carbon/xenomorph/proc/ggxp()
	var/datum/component/moba_player/MP = GetComponent(/datum/component/moba_player)
	if(MP)
		MP.grant_xp(null, 8580) // enough for level 12

/mob/living/carbon/xenomorph/proc/ggold()
	var/datum/component/moba_player/MP = GetComponent(/datum/component/moba_player)
	if(MP)
		MP.grant_gold(null, 10000)

#endif
