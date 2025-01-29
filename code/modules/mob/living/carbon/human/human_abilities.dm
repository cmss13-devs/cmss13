/mob/living/carbon/human/proc/set_selected_ability(datum/action/human_action/activable/ability)
	if(!ability)
		selected_ability = null
		client?.set_right_click_menu_mode(shift_only = FALSE)
		return
	selected_ability = ability
	if(get_ability_mouse_key() == XENO_ABILITY_CLICK_RIGHT)
		client?.set_right_click_menu_mode(shift_only = TRUE)

/datum/action/human_action/issue_order
	name = "Issue Order"
	action_icon_state = "order"
	var/order_type = "help"

/datum/action/human_action/issue_order/give_to(mob/living/L)
	..()
	if(!ishuman(L))
		return
	cooldown = COMMAND_ORDER_COOLDOWN

/datum/action/human_action/issue_order/action_activate()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/my_owner = owner
	my_owner.issue_order(order_type)

/datum/action/human_action/issue_order/action_cooldown_check()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/my_owner = owner
	return my_owner.command_aura_available

/datum/action/human_action/issue_order/move
	name = "Issue Order - Move"
	action_icon_state = "order_move"
	order_type = COMMAND_ORDER_MOVE

/datum/action/human_action/issue_order/hold
	name = "Issue Order - Hold"
	action_icon_state = "order_hold"
	order_type = COMMAND_ORDER_HOLD

/datum/action/human_action/issue_order/focus
	name = "Issue Order - Focus"
	action_icon_state = "order_focus"
	order_type = COMMAND_ORDER_FOCUS

/datum/action/human_action/psychic_whisper
	name = "Psychic Whisper"
	action_icon_state = "cultist_channel_hivemind"

/datum/action/human_action/psychic_whisper/action_activate()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/human_owner = owner

	if(human_owner.client.prefs.muted & MUTE_IC)
		to_chat(human_owner, SPAN_DANGER("You cannot whisper (muted)."))
		return FALSE

	if(human_owner.stat == DEAD)
		to_chat(human_owner, SPAN_WARNING("You cannot talk while dead."))
		return FALSE

	var/list/target_list = list()
	for(var/mob/living/carbon/possible_target in view(7, human_owner))
		if(possible_target == human_owner || !possible_target.client)
			continue
		target_list += possible_target

	var/mob/living/carbon/target_mob = tgui_input_list(human_owner, "Target", "Send a Psychic Whisper to whom?", target_list, theme = "wizard")
	if(!target_mob)
		return FALSE

	human_owner.psychic_whisper(target_mob)


/datum/action/human_action/psychic_radiance
	name = "Psychic Radiance"
	action_icon_state = "cultist_channel_hivemind"

/datum/action/human_action/psychic_radiance/action_activate(atom/A)
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/human_owner = owner

	if(human_owner.client.prefs.muted & MUTE_IC)
		to_chat(human_owner, SPAN_DANGER("You cannot whisper (muted)."))
		return FALSE

	if(human_owner.stat == DEAD)
		to_chat(human_owner, SPAN_WARNING("You cannot talk while dead."))
		return FALSE

	human_owner.psychic_radiance()

/*
CULT
*/
/datum/action/human_action/activable/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && !HAS_TRAIT(H, TRAIT_DAZED))
		return TRUE

// Called when the action is clicked on.
/datum/action/human_action/activable/action_activate()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.selected_ability == src)
		to_chat(H, "You will no longer use [name] with [H.get_ability_mouse_name()].")
		button.icon_state = "template"
		H.set_selected_ability(null)
	else
		to_chat(H, "You will now use [name] with [H.get_ability_mouse_name()].")
		if(H.selected_ability)
			H.selected_ability.button.icon_state = "template"
			H.set_selected_ability(null)
		button.icon_state = "template_on"
		H.set_selected_ability(src)

/datum/action/human_action/activable/remove_from(mob/living/carbon/human/H)
	..()
	if(H.selected_ability == src)
		H.set_selected_ability(null)

/datum/action/human_action/activable/proc/use_ability(mob/M)
	return

/datum/action/human_action/activable/update_button_icon()
	if(!button)
		return
	if(!action_cooldown_check())
		button.color = rgb(240,180,0,200)
	else
		button.color = rgb(255,255,255,255)

/datum/action/human_action/activable/droppod
	name = "Call Droppod"
	action_icon_state = "techpod_deploy"

	var/obj/structure/droppod/tech/assigned_droppod

/datum/action/human_action/activable/droppod/proc/can_deploy_droppod(turf/T)
	var/mob/living/carbon/human/H = owner
	if(assigned_droppod)
		return

	if(!(T in view(H)))
		to_chat(H, SPAN_WARNING("This target can't be seen!"))
		return

	if(get_dist(T, H) > 5)
		to_chat(H, SPAN_WARNING("This target is too far away!"))
		return

	if(!(is_ground_level(T.z)))
		to_chat(H, SPAN_WARNING("The droppod cannot land here!"))
		return

	if(protected_by_pylon(TURF_PROTECTION_CAS, T))
		to_chat(H, SPAN_WARNING("The droppod cannot punch through an organic ceiling!"))
		return

	return TRUE


/datum/action/human_action/activable/droppod/use_ability(atom/A)
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner

	var/turf/T = get_turf(A)

	if(!T)
		return

	if(assigned_droppod)
		if(tgui_alert(H, "Do you want to recall the current pod?",\
			"Recall Droppod", list("No", "Yes")) == "Yes")
			if(!assigned_droppod)
				return

			if(!(assigned_droppod.droppod_flags & (DROPPOD_DROPPING|DROPPOD_RETURNING)))
				message_admins("[key_name_admin(H)] recalled a tech droppod at [get_area(assigned_droppod)].")
				assigned_droppod.recall()
			else
				to_chat(H, SPAN_WARNING("It's too late to recall the droppod now!"))
		return

	if(!can_deploy_droppod(T))
		return

	to_chat(H, SPAN_WARNING("No droppods currently available."))
	return

/* // FULL IMPLEM OF DROPPODS FOR REUSE
	var/list/list_of_techs = list()
	if(!can_deploy_droppod(T))
		return
	var/area/turf_area = get_area(T)
	if(!turf_area)
		return
	var/land_time = max(turf_area.ceiling, 1) * (20 SECONDS)
	playsound(T, 'sound/effects/alert.ogg', 75)
	assigned_droppod = new(T, tech_to_deploy)
	assigned_droppod.drop_time = land_time
	assigned_droppod.launch(T)
	var/list/to_send_to = H.assigned_squad?.marines_list
	if(!to_send_to)
		to_send_to = list(H)
	message_admins("[key_name_admin(H)] called a tech droppod down at [get_area(assigned_droppod)].", T.x, T.y, T.z)
	for(var/M in to_send_to)
		to_chat(M, SPAN_BLUE("<b>SUPPLY DROP REQUEST:</b> Droppod requested at LONGITUDE: [obfuscate_x(T.x)], LATITUDE: [obfuscate_y(T.y)]. ETA [floor(land_time*0.1)] seconds."))
	RegisterSignal(assigned_droppod, COMSIG_PARENT_QDELETING, PROC_REF(handle_droppod_deleted))
*/

/datum/action/human_action/activable/droppod/proc/handle_droppod_deleted(obj/structure/droppod/tech/T)
	SIGNAL_HANDLER
	if(T != assigned_droppod)
		return
	assigned_droppod = null

/datum/action/human_action/activable/droppod/Destroy()
	if(assigned_droppod)
		handle_droppod_deleted(assigned_droppod)

	return ..()


/datum/action/human_action/activable/droppod/give_to(user)
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user

	if(H.job != JOB_SQUAD_TEAM_LEADER)
		return FALSE

	return ..()

/datum/action/human_action/activable/cult
	name = "Activable Cult Ability"

/datum/action/human_action/activable/cult/speak_hivemind
	name = "Speak in Hivemind"
	action_icon_state = "cultist_channel_hivemind"

/datum/action/human_action/activable/cult/speak_hivemind/action_activate()
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner


	var/message = input(H, "Say in Hivemind", "Hivemind Chat") as null|text
	if(!message)
		return

	message = trim(strip_html(message))

	message = capitalize(trim(message))
	message = process_chat_markup(message, list("~", "_"))

	if(!(copytext(message, -1) in ENDING_PUNCT))
		message += "."

	var/datum/hive_status/hive = GLOB.hive_datum[H.hivenumber]
	if(!istype(hive))
		return

	H.hivemind_broadcast(message, hive)

/datum/action/human_action/activable/cult/obtain_equipment
	name = "Obtain Equipment"
	action_icon_state = "cultist_channel_equipment"
	var/list/items_to_spawn = list(/obj/item/clothing/suit/cultist_hoodie/, /obj/item/clothing/head/cultist_hood/)

/datum/action/human_action/activable/cult/obtain_equipment/action_activate()
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner

	var/input = tgui_alert(H, "Once obtained, you'll be unable to take it off. Confirm selection.", "Obtain Equipment", list("Yes","No"))

	if(input != "Yes")
		to_chat(H, SPAN_WARNING("You have decided not to obtain your equipment."))
		return

	H.visible_message(SPAN_DANGER("[H] gets onto their knees and begins praying."),
	SPAN_WARNING("You get onto your knees to pray."))

	if(!do_after(H, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(H, SPAN_WARNING("You decide not to retrieve your equipment."))
		return

	H.drop_inv_item_on_ground(H.get_item_by_slot(WEAR_JACKET), FALSE, TRUE)
	H.drop_inv_item_on_ground(H.get_item_by_slot(WEAR_HEAD), FALSE, TRUE)

	var/obj/item/clothing/C = new /obj/item/clothing/suit/cultist_hoodie()
	H.equip_to_slot_or_del(C, WEAR_JACKET)
	C.flags_item |= NODROP|DELONDROP

	C = new /obj/item/clothing/head/cultist_hood()
	H.equip_to_slot_or_del(C, WEAR_HEAD)
	C.flags_item |= NODROP|DELONDROP

	H.put_in_any_hand_if_possible(new /obj/item/device/flashlight, FALSE, TRUE)

	playsound(H.loc, 'sound/voice/scream_horror1.ogg', 25)

	H.visible_message(SPAN_HIGHDANGER("[H] puts on their robes."), SPAN_WARNING("You put on your robes."))
	for(var/datum/action/human_action/activable/cult/obtain_equipment/O in H.actions)
		O.remove_from(H)

/datum/action/human_action/activable/cult_leader
	name = "Activable Leader Ability"

/datum/action/human_action/activable/cult_leader/proc/can_target(mob/living/carbon/human/H)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/Hu = owner

	if(H.skills && (skillcheck(H, SKILL_LEADERSHIP, SKILL_LEAD_EXPERT) || skillcheck(H, SKILL_POLICE, SKILL_POLICE_SKILLED)))
		to_chat(Hu, SPAN_WARNING("This mind is too strong to target with your abilities."))
		return

	if(get_dist_sqrd(get_turf(H), get_turf(owner)) > 2)
		to_chat(Hu, SPAN_WARNING("This target is too far away!"))
		return

	return H.stat != DEAD && istype(H) && ishuman_strict(H) && H.hivenumber != Hu.hivenumber && !isnull(get_hive())

/datum/action/human_action/activable/cult_leader/proc/get_hive()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/datum/hive_status/hive = GLOB.hive_datum[H.hivenumber]
	if(!hive)
		return

	if(!hive.living_xeno_queen && !hive.allow_no_queen_actions)
		return

	return hive

/datum/action/human_action/activable/cult_leader/convert
	name = "Convert"
	action_icon_state = "cultist_channel_convert"

/datum/action/human_action/activable/cult_leader/convert/use_ability(mob/M)
	var/datum/hive_status/hive = get_hive()

	if(!istype(hive))
		to_chat(owner, SPAN_DANGER("There is no Queen. You are alone."))
		return

	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner

	var/mob/living/carbon/human/chosen = M

	if(!can_target(chosen))
		return

	if(chosen.stat != CONSCIOUS)
		to_chat(H, SPAN_XENOMINORWARNING("[chosen] must be conscious for the conversion to work!"))
		return

	if(!do_after(H, 10 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, chosen, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(H, SPAN_XENOMINORWARNING("You decide not to convert [chosen]."))
		return

	var/datum/equipment_preset/preset = GLOB.gear_path_presets_list[/datum/equipment_preset/other/xeno_cultist]
	preset.load_race(chosen)
	preset.load_status(chosen, H.hivenumber)

	to_chat(chosen, SPAN_ROLE_HEADER("You are now a Xeno Cultist!"))
	to_chat(chosen, SPAN_ROLE_BODY("Worship the Xenomorphs and listen to the Cult Leader for orders. The Cult Leader is typically the person who transformed you. Do not kill anyone unless you are wearing your black robes, you may defend yourself."))

	xeno_message("[chosen] has been converted into a cultist!", 2, hive.hivenumber)

	chosen.apply_effect(5, PARALYZE)
	chosen.make_jittery(105)

	if(chosen.client)
		playsound_client(chosen.client, 'sound/effects/xeno_newlarva.ogg', null, 25)

/datum/action/human_action/activable/cult_leader/stun
	name = "Psychic Stun"
	action_icon_state = "cultist_channel_stun"

	cooldown = 1 MINUTES

/datum/action/human_action/activable/cult_leader/stun/use_ability(mob/M)
	if(!action_cooldown_check())
		return

	var/datum/hive_status/hive = get_hive()

	if(!istype(hive))
		to_chat(owner, SPAN_DANGER("There is no Queen. You are alone."))
		return

	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner

	var/mob/living/carbon/human/chosen = M

	if(!can_target(chosen))
		return

	to_chat(chosen, SPAN_HIGHDANGER("You feel a dangerous presence in the back of your head. You find yourself unable to move!"))
	ADD_TRAIT(chosen, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Cultist Stun"))

	chosen.update_xeno_hostile_hud()

	if(!do_after(H, 2 SECONDS, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, chosen, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(H, SPAN_XENOMINORWARNING("You decide not to stun [chosen]."))
		unroot_human(chosen, TRAIT_SOURCE_ABILITY("Cultist Stun"))

		enter_cooldown(5 SECONDS)
		return

	enter_cooldown()

	unroot_human(chosen, TRAIT_SOURCE_ABILITY("Cultist Stun"))

	chosen.apply_effect(10, PARALYZE)
	chosen.make_jittery(105)

	to_chat(chosen, SPAN_HIGHDANGER("An immense psychic wave passes through you, causing you to pass out!"))

	playsound(get_turf(chosen), 'sound/scp/scare1.ogg', 25)

/datum/action/human_action/activable/mutineer
	name = "Mutiny abilities"

/datum/action/human_action/activable/mutineer/mutineer_convert
	name = "Convert"
	action_icon_state = "mutineer_convert"

	var/list/converted = list()

/datum/action/human_action/activable/mutineer/mutineer_convert/use_ability(mob/M)
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/chosen = M

	if(!istype(chosen))
		return

	if(skillcheck(chosen, SKILL_POLICE, SKILL_POLICE_MAX) || (chosen in converted))
		to_chat(H, SPAN_WARNING("You can't convert [chosen]!"))
		return

	to_chat(H, SPAN_NOTICE("Mutiny join request sent to [chosen]!"))

	if(tgui_alert(chosen, "Do you want to be a mutineer?", "Become Mutineer", list("Yes", "No")) != "Yes")
		return

	converted += chosen
	to_chat(chosen, SPAN_WARNING("You'll become a mutineer when the mutiny begins. Prepare yourself and do not cause any harm until you've been made into a mutineer."))

	message_admins("[key_name_admin(chosen)] has been converted into a mutineer by [key_name_admin(H)].")

/datum/action/human_action/activable/mutineer/mutineer_begin
	name = "Begin Mutiny"
	action_icon_state = "mutineer_begin"

/datum/action/human_action/activable/mutineer/mutineer_begin/action_activate()
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner

	if(tgui_alert(H, "Are you sure you want to begin the mutiny?", "Begin Mutiny?", list("Yes", "No")) != "Yes")
		return

	shipwide_ai_announcement("DANGER: Communications received; a mutiny is in progress. Code: Detain, Arrest, Defend.")
	var/datum/equipment_preset/other/mutineer/XC = new()

	XC.load_status(H)
	for(var/datum/action/human_action/activable/mutineer/mutineer_convert/converted in H.actions)
		for(var/mob/living/carbon/human/chosen in converted.converted)
			XC.load_status(chosen)
		converted.remove_from(H)

	message_admins("[key_name_admin(H)] has begun the mutiny.")
	remove_from(H)


/datum/action/human_action/cancel_view // cancel-camera-view, but a button
	name = "Cancel View"
	action_icon_state = "cancel_view"

/datum/action/human_action/cancel_view/give_to(user)
	. = ..()
	RegisterSignal(user, COMSIG_MOB_RESET_VIEW, PROC_REF(remove_from)) // will delete the button even if you reset view by resisting or the verb

/datum/action/human_action/cancel_view/remove_from(mob/L)
	. = ..()
	UnregisterSignal(L, COMSIG_MOB_RESET_VIEW)

/datum/action/human_action/cancel_view/action_activate()
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner

	H.cancel_camera()
	H.reset_view()
	H.client.change_view(GLOB.world_view_size, target)
	H.client.pixel_x = 0
	H.client.pixel_y = 0

//Similar to a cancel-camera-view button, but for mobs that were buckled to special vehicle seats.
//Unbuckles them, which handles the view and offsets resets and other stuff.
/datum/action/human_action/vehicle_unbuckle
	name = "Vehicle Unbuckle"
	action_icon_state = "unbuckle"

/datum/action/human_action/vehicle_unbuckle/give_to(user)
	. = ..()
	RegisterSignal(user, COMSIG_MOB_RESET_VIEW, PROC_REF(remove_from))//since unbuckling from special vehicle seats also resets the view, gonna use same signal

/datum/action/human_action/vehicle_unbuckle/remove_from(mob/L)
	. = ..()
	UnregisterSignal(L, COMSIG_MOB_RESET_VIEW)

/datum/action/human_action/vehicle_unbuckle/action_activate()
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner
	if(H.buckled)
		if(istype(H.buckled, /obj/structure/bed/chair/comfy/vehicle))
			H.buckled.unbuckle()
		else if(!isVehicleMultitile(H.interactee))
			remove_from(H)
	else if(!isVehicleMultitile(H.interactee))
		remove_from(H)

	H.unset_interaction()
	H.client.change_view(GLOB.world_view_size, target)
	H.client.pixel_x = 0
	H.client.pixel_y = 0
	H.reset_view()
	remove_from(H)


/datum/action/human_action/mg_exit
	name = "Exit MG"
	action_icon_state = "cancel_view"

/datum/action/human_action/mg_exit/action_activate()
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/human_user = owner
	SEND_SIGNAL(human_user, COMSIG_MOB_MG_EXIT)

/datum/action/human_action/toggle_arc_antenna
	name = "Toggle Sensor Antenna"
	action_icon_state = "recoil_compensation"

/datum/action/human_action/toggle_arc_antenna/give_to(mob/user)
	. = ..()
	RegisterSignal(user, COMSIG_MOB_RESET_VIEW, PROC_REF(remove_from))

/datum/action/human_action/toggle_arc_antenna/remove_from(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_RESET_VIEW)

/datum/action/human_action/toggle_arc_antenna/action_activate()
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/human_user = owner
	if(istype(human_user.buckled, /obj/structure/bed/chair/comfy/vehicle))
		var/obj/structure/bed/chair/comfy/vehicle/vehicle_chair = human_user.buckled
		if(istype(vehicle_chair.vehicle, /obj/vehicle/multitile/arc))
			var/obj/vehicle/multitile/arc/vehicle = vehicle_chair.vehicle
			vehicle.toggle_antenna(human_user)
