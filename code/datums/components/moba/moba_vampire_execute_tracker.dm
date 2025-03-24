/datum/component/moba_vampire_execute_tracker
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/xenomorph/parent_xeno
	var/datum/moba_player/parent_player
	/// Dict of mob : image
	var/list/mob/living/carbon/xenomorph/execute_images = list()
	var/map_id
	var/datum/moba_controller/controller
	var/team2

/datum/component/moba_vampire_execute_tracker/Initialize(datum/moba_player/parent_player, map_id, team2)
	. = ..()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE

	parent_xeno = parent
	src.parent_player = parent_player

	if(!istype(parent_xeno.strain, /datum/xeno_strain/vampire))
		return COMPONENT_INCOMPATIBLE

	src.map_id = map_id
	src.team2 = team2
	controller = SSmoba.get_moba_controller(map_id)

	START_PROCESSING(SSprocessing, src)

/datum/component/moba_vampire_execute_tracker/Destroy(force, silent)
	controller = null
	for(var/mob/living/carbon/xenomorph/execute as anything in execute_images)
		parent_xeno.client?.images -= execute_images[execute]
	parent_xeno = null
	return ..()

/datum/component/moba_vampire_execute_tracker/process(delta_time)
	if(!parent_xeno.client)
		return

	if(!controller)
		controller = SSmoba.get_moba_controller(map_id)

	var/datum/action/xeno_action/activable/moba_headbite/headbite = get_action(parent_xeno, /datum/action/xeno_action/activable/moba_headbite)
	var/datum/status_effect/stacking/bloodlust_effect = parent_xeno.has_status_effect(/datum/status_effect/stacking/bloodlust)
	var/damage_to_deal = headbite.true_damage_to_deal + (parent_xeno.melee_damage_upper * 0.7) + (bloodlust_effect ? bloodlust_effect.stacks * 3 : 0)

	/*for(var/datum/moba_player/player as anything in (!team2 ? controller.team2 : controller.team1))
		if(QDELETED(player.tied_xeno) || (player.tied_xeno.stat == DEAD))
			parent_xeno.client.images -= execute_images[player.tied_xeno]
			execute_images -= player.tied_xeno
			continue

		if(player.tied_xeno.health <= damage_to_deal)
			var/image/execute_indicator = image('icons/mob/hud/hud.dmi', player.tied_xeno, "prae_tag")
			parent_xeno.client.images += execute_indicator
			execute_images[player.tied_xeno] = execute_indicator
		else
			parent_xeno.client.images -= execute_images[player.tied_xeno]
			execute_images -= player.tied_xeno*/

	for(var/mob/living/carbon/xenomorph/xeno as anything in GLOB.living_xeno_list)
		if(QDELETED(xeno) || (xeno.stat == DEAD))
			var/image/indicator = execute_images[xeno]
			if(indicator)
				//indicator.icon_state = ""
				parent_xeno.client.images -= indicator
			continue

		if(xeno.health <= damage_to_deal)
			var/image/execute_indicator = image('icons/mob/hud/hud.dmi', xeno, "prae_tag_still")
			parent_xeno.client.images += execute_indicator
			execute_images[xeno] = execute_indicator
		else
			var/image/indicator = execute_images[xeno]
			if(indicator)
				//indicator.icon_state = ""
				parent_xeno.client.images -= indicator
