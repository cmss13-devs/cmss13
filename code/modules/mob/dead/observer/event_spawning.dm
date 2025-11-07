/mob/dead/verb/join_as_event_mob()
	set category = "Ghost.Join"
	set name = "Join as Event Mob"
	set desc = "Select an event mob to play as."

	if(!stat || !mind)
		return FALSE

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return FALSE

	if(key in GLOB.event_mob_players)
		to_chat(src, SPAN_WARNING("You have already played as an event mob this round! You cannot respawn!"))
		return FALSE

	var/list/event_mob_choices = GLOB.event_mob_landmarks.Copy()
	for(var/obj/effect/landmark/event_mob_spawn/pos_spawner in event_mob_choices)
		if(pos_spawner.being_spawned)
			event_mob_choices -= pos_spawner

	if(!length(event_mob_choices))
		to_chat(src, SPAN_WARNING("There are no Event Mobs available."))
		return FALSE
	var/obj/effect/landmark/event_mob_spawn/spawner = tgui_input_list(usr, "Pick an Event Mob:", "Join as Event Mob", event_mob_choices)
	if(!spawner)
		return FALSE

	if(!spawner.being_spawned)
		spawner.join_as_mob(src)
		return TRUE

	to_chat(src, SPAN_WARNING("This event mob is no longer available! Try another."))
	return FALSE

/obj/effect/landmark/event_mob_spawn
	name = "event mob spawnpoint"
	desc = "The spot an event mob spawns in. Players in-game can't see this."
	icon_state = "freed_mob_spawner"
	invisibility_value = INVISIBILITY_OBSERVER

	/// The path of the equipment preset used by the event mob.
	var/spawn_preset_path
	/// Whether or not the landmark is already in use.
	var/being_spawned = FALSE
	/// Whether or not the event mob is forced to use random name.
	var/always_random_name = FALSE

	/// The title, if one, that appears in the join list.
	var/custom_join_title

	/// Override of the mob's 'assignment' variable on ID card.
	var/custom_assignment
	/// Override of the mob's 'rank' variable on ID card.
	var/custom_job_title
	/// Override of the mob's paygrade on ID card.
	var/custom_paygrade

	/// Whether or not to wait on setup of this landmark, intended for manual preparation mid-round.
	var/delay_setup = FALSE
	/// How many uses the landmark has, defaulting to 1.
	var/num_uses = 1

/obj/effect/landmark/event_mob_spawn/midround
	delay_setup = TRUE

/obj/effect/landmark/event_mob_spawn/Initialize(mapload, ...)
	. = ..()
	if(!delay_setup)
		handle_setup()
		return

	GLOB.event_mob_landmarks_delayed += src

/obj/effect/landmark/event_mob_spawn/proc/handle_setup()
	if(!spawn_preset_path || !(spawn_preset_path in GLOB.equipment_presets.gear_path_presets_list))
		qdel(src)
		return

	if(delay_setup)
		GLOB.event_mob_landmarks_delayed -= src
		delay_setup = FALSE

	if(custom_join_title)
		name = "#[GLOB.event_mob_number] [custom_join_title]"
	else
		name = "#[GLOB.event_mob_number] [GLOB.equipment_presets.gear_path_presets_list[spawn_preset_path].assignment]"

	GLOB.event_mob_number++
	GLOB.event_mob_landmarks += src

/obj/effect/landmark/event_mob_spawn/Destroy()
	GLOB.event_mob_landmarks -= src
	GLOB.event_mob_landmarks_delayed -= src
	return ..()

/obj/effect/landmark/event_mob_spawn/attack_ghost(mob/dead/observer/user)
	if(delay_setup)
		return FALSE

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return FALSE

	if(user.key in GLOB.event_mob_players)
		to_chat(src, SPAN_WARNING("You have already played as an event mob this round! You cannot respawn!"))
		return FALSE

	if(!(tgui_alert(user, "Do you wish to spawn as this mob?", "Confirm Spawn", list("Yes","No")) == "Yes"))
		return FALSE

	if(!being_spawned)
		join_as_mob(user)
		return TRUE

	to_chat(user, SPAN_WARNING("This event mob is no longer available! Try another."))
	return FALSE

/obj/effect/landmark/event_mob_spawn/proc/join_as_mob(mob/dead/observer/observer)
	being_spawned = TRUE
	observer.forceMove(get_turf(src))

	addtimer(CALLBACK(src, PROC_REF(handle_mob_spawn), observer), 1 SECONDS)

/obj/effect/landmark/event_mob_spawn/proc/handle_mob_spawn(mob/dead/observer/observer)
	var/use_random_name = always_random_name
	if(!isobserver(observer.mind.original))
		use_random_name = TRUE

	var/mob/living/carbon/human/new_player = observer.change_mob_type(/mob/living/carbon/human, get_turf(src), null, TRUE, SPECIES_HUMAN, TRUE)
	if(!ishuman(new_player))
		message_admins("Something went wrong with preparing an event mob.")
		qdel(src)
		return FALSE

	if(!new_player.hud_used)
		new_player.create_hud()

	arm_equipment(new_player, spawn_preset_path, use_random_name, count_participant = TRUE)
	message_admins("[key_name_admin(new_player)] joined an event mob! ([name])")
	GLOB.event_mob_players += new_player.key

	var/obj/item/card/id/id_card = new_player.get_idcard()
	if(id_card)
		if(custom_assignment)
			id_card.assignment = custom_assignment
			id_card.name = "[id_card.registered_name]'s [id_card.id_type] ([id_card.assignment])"
		if(custom_job_title)
			id_card.rank = custom_job_title
		if(custom_paygrade)
			id_card.paygrade = custom_paygrade

	num_uses--
	if(num_uses <= 0)
		qdel(src)
	else
		being_spawned = FALSE

/obj/effect/landmark/event_mob_spawn/debug
	custom_join_title = "Debugging Spawn"
	spawn_preset_path = /datum/equipment_preset/uscm_event/colonel
