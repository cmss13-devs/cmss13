/datum/action/human_action/update_button_icon()
	if(action_cooldown_check())
		button.color = rgb(120,120,120,200)
	else
		button.color = rgb(255,255,255,255)

/datum/action/human_action/proc/action_cooldown_check()
	return FALSE


/datum/action/human_action/issue_order
	name = "Issue Order"
	action_icon_state = "order"
	var/order_type = "help"

/datum/action/human_action/issue_order/give_action(var/mob/living/L)
	..()
	if(!ishuman(L))
		return
	cooldown = COMMAND_ORDER_COOLDOWN

/datum/action/human_action/issue_order/action_activate()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.issue_order(order_type)

/datum/action/human_action/issue_order/action_cooldown_check()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	return !H.command_aura_available

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


/datum/action/human_action/smartpack/action_cooldown_check()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(istype(H.back, /obj/item/storage/backpack/marine/smartpack))
		var/obj/item/storage/backpack/marine/smartpack/S = H.back
		return cooldown_check(S)
	else
		return FALSE

/datum/action/human_action/smartpack/action_activate()
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = owner
	if(istype(H.back, /obj/item/storage/backpack/marine/smartpack))
		var/obj/item/storage/backpack/marine/smartpack/S = H.back
		form_call(S, H)

/datum/action/human_action/smartpack/give_action(var/mob/living/L)
	..()
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	if(istype(H.back, /obj/item/storage/backpack/marine/smartpack))
		var/obj/item/storage/backpack/marine/smartpack/S = H.back
		cooldown = set_cooldown(S)
	else
		return

/datum/action/human_action/smartpack/proc/form_call(var/obj/item/storage/backpack/marine/smartpack/S, var/mob/living/carbon/human/H)
	return

/datum/action/human_action/smartpack/proc/set_cooldown(var/obj/item/storage/backpack/marine/smartpack/S)
	return

/datum/action/human_action/smartpack/proc/cooldown_check(var/obj/item/storage/backpack/marine/smartpack/S)
	return S.activated_form


/datum/action/human_action/smartpack/protective_form
	name = "Protective Form"
	action_icon_state = "smartpack_protect"

/datum/action/human_action/smartpack/protective_form/set_cooldown(var/obj/item/storage/backpack/marine/smartpack/S)
	return S.protective_form_cooldown

/datum/action/human_action/smartpack/protective_form/form_call(var/obj/item/storage/backpack/marine/smartpack/S, var/mob/living/carbon/human/H)
	S.protective_form(H)

/datum/action/human_action/smartpack/immobile_form
	name = "Immobile Form"
	action_icon_state = "smartpack_immobile"

/datum/action/human_action/smartpack/immobile_form/form_call(var/obj/item/storage/backpack/marine/smartpack/S, var/mob/living/carbon/human/H)
	S.immobile_form(H)

/datum/action/human_action/smartpack/repair_form
	name = "Repair Form"
	action_icon_state = "smartpack_repair"

/datum/action/human_action/smartpack/repair_form/set_cooldown(var/obj/item/storage/backpack/marine/smartpack/S)
	return S.repair_form_cooldown

/datum/action/human_action/smartpack/repair_form/form_call(var/obj/item/storage/backpack/marine/smartpack/S, var/mob/living/carbon/human/H)
	S.repair_form(H)

/datum/action/human_action/smartpack/repair_form/cooldown_check(var/obj/item/storage/backpack/marine/smartpack/S)
	return S.repairing

/*
CULT
*/
/datum/action/human_action/activable
	var/ability_used_time = 0

/datum/action/human_action/activable/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && !H.dazed)
		return TRUE

// Called when the action is clicked on.
/datum/action/human_action/activable/action_activate()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.selected_ability == src)
		to_chat(H, "You will no longer use [name] with \
			[H.client && H.client.prefs && H.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		button.icon_state = "template"
		H.selected_ability = null
	else
		to_chat(H, "You will now use [name] with \
			[H.client && H.client.prefs && H.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		if(H.selected_ability)
			H.selected_ability.button.icon_state = "template"
			H.selected_ability = null
		button.icon_state = "template_on"
		H.selected_ability = src

/datum/action/human_action/activable/remove_action(mob/living/carbon/human/H)
	..()
	if(H.selected_ability == src)
		H.selected_ability = null

/datum/action/human_action/activable/proc/use_ability(var/mob/M)
	return

/datum/action/human_action/activable/update_button_icon()
	if(!button)
		return
	if(!action_cooldown_check())
		button.color = rgb(240,180,0,200)
	else
		button.color = rgb(255,255,255,255)

/datum/action/human_action/activable/action_cooldown_check()
	return ability_used_time <= world.time

/datum/action/human_action/activable/proc/enter_cooldown(var/amount = cooldown)
	ability_used_time = world.time + amount

	update_button_icon()

	addtimer(CALLBACK(src, .proc/update_button_icon), amount)

/datum/action/human_action/activable/cult
	name = "Activable Cult Ability"

/datum/action/human_action/activable/cult/speak_hivemind
	name = "Speak in Hivemind"
	action_icon_state = "cultist_channel_hivemind"

/datum/action/human_action/activable/cult/speak_hivemind/action_activate()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner


	var/input = input(H, "Say in Hivemind", "Hivemind Chat")

	if(!input)
		return

	var/datum/hive_status/hive = hive_datum[H.hivenumber]

	if(!istype(hive))
		return

	H.hivemind_broadcast(input, hive)

/datum/action/human_action/activable/cult/obtain_equipment
	name = "Obtain Equipment"
	action_icon_state = "cultist_channel_equipment"
	var/list/items_to_spawn = list(/obj/item/clothing/suit/cultist_hoodie/, /obj/item/clothing/head/cultist_hood/)

/datum/action/human_action/activable/cult/obtain_equipment/action_activate()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner

	var/input = alert(H, "Once obtained, you'll be unable to take it off. Confirm selection.", "Obtain Equipment","Yes","No")

	if(input == "No")
		to_chat(H, SPAN_WARNING("You have decided not to obtain your equipment."))
		return

	H.visible_message(SPAN_DANGER("[H] gets onto their knees and begins praying."), \
	SPAN_WARNING("You get onto your knees to pray."))

	if(!do_after(H, SECONDS_3, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
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
		O.remove_action(H)

/datum/action/human_action/activable/cult_leader
	name = "Activable Leader Ability"

/datum/action/human_action/activable/cult_leader/proc/can_target(var/mob/living/carbon/human/H)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/Hu = owner

	if(H.skills && (skillcheck(H, SKILL_LEADERSHIP, SKILL_LEAD_EXPERT) || skillcheck(H, SKILL_POLICE, SKILL_POLICE_MP)))
		to_chat(Hu, SPAN_WARNING("This mind is too strong to target with your abilities."))
		return

	if(get_dist_sqrd(get_turf(H), get_turf(owner)) > 2)
		to_chat(Hu, SPAN_WARNING("This target is too far away!"))
		return

	return H.stat != DEAD && istype(H) && isHumanStrict(H) && H.hivenumber != Hu.hivenumber && !isnull(get_hive())

/datum/action/human_action/activable/cult_leader/proc/get_hive()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/datum/hive_status/hive = LAZYACCESS(hive_datum, H.hivenumber)
	if(!hive)
		return

	if(!hive.living_xeno_queen && !hive.allow_no_queen_actions)
		return

	return hive

/datum/action/human_action/activable/cult_leader/convert
	name = "Convert"
	action_icon_state = "cultist_channel_convert"

/datum/action/human_action/activable/cult_leader/convert/use_ability(var/mob/M)
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

	if(!do_after(H, SECONDS_10, INTERRUPT_ALL, BUSY_ICON_HOSTILE, chosen, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(H, SPAN_XENOMINORWARNING("You decide not to convert [chosen]."))
		return

	var/datum/equipment_preset/other/xeno_cultist/XC = new()

	XC.load_race(chosen, H.hivenumber)
	XC.load_status(chosen)

	chosen.faction = hive.name

	to_chat(chosen, SPAN_HIGHDANGER("<hr>You are now a Xeno Cultist!"))
	to_chat(chosen, SPAN_DANGER("Worship the Xenomorphs and listen to the Cult Leader for orders. The Cult Leader is typically the person who transformed you. Do not kill anyone unless you are wearing your black robes, you may defend yourself.<hr>"))

	xeno_message("[chosen] has been converted into a cultist!", 2, hive.hivenumber)

	chosen.KnockOut(5)
	chosen.make_jittery(105)

	if(chosen.client)
		playsound_client(chosen.client, 'sound/effects/xeno_newlarva.ogg', null, 25)

/datum/action/human_action/activable/cult_leader/stun
	name = "Psychic Stun"
	action_icon_state = "cultist_channel_stun"

	cooldown = MINUTES_1

/datum/action/human_action/activable/cult_leader/stun/use_ability(var/mob/M)
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

	chosen.frozen = TRUE
	chosen.update_canmove()

	chosen.update_xeno_hostile_hud()

	if(!do_after(H, SECONDS_2, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, chosen, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(H, SPAN_XENOMINORWARNING("You decide not to stun [chosen]."))
		unroot_human(chosen)

		enter_cooldown(SECONDS_5)
		return

	enter_cooldown()

	unroot_human(chosen)

	chosen.KnockOut(10)
	chosen.make_jittery(105)

	to_chat(chosen, SPAN_HIGHDANGER("An immense psychic wave passes through you, causing you to pass out!"))

	playsound(get_turf(chosen), 'sound/scp/scare1.ogg', 25)

/datum/action/human_action/activable/mutineer
	name = "Mutiny abilities"

/datum/action/human_action/activable/mutineer/mutineer_convert
	name = "Convert"
	action_icon_state = "mutineer_convert"

	var/list/converted = list()

/datum/action/human_action/activable/mutineer/mutineer_convert/use_ability(var/mob/M)
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/chosen = M

	if(!istype(chosen))
		return

	if(chosen.faction != FACTION_MARINE || (chosen.skills && skillcheck(chosen, SKILL_POLICE, 2)) || (chosen in converted))
		to_chat(H, SPAN_WARNING("You can't convert [chosen]!"))
		return

	to_chat(H, SPAN_NOTICE("Mutiny join request sent to [chosen]!"))

	if(alert(chosen, "Do you want to be a mutineer?", "Become Mutineer", "Yes", "No") == "No")
		return

	converted += chosen
	to_chat(chosen, SPAN_WARNING("You'll become a mutineer when the mutiny begins. Prepare yourself and do not cause any harm until you've been made into a mutineer."))

	message_staff("[key_name_admin(chosen)] has been converted into a mutineer by [key_name_admin(H)].")

/datum/action/human_action/activable/mutineer/mutineer_begin
	name = "Begin Mutiny"
	action_icon_state = "mutineer_begin"

/datum/action/human_action/activable/mutineer/mutineer_begin/action_activate()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/H = owner

	if(alert(H, "Are you sure you want to begin the mutiny?", "Begin Mutiny?", "Yes", "No") == "No")
		return

	shipwide_ai_announcement("DANGER: Communications received; a mutiny is in progress. Code: Detain, Arrest, Defend")
	var/datum/equipment_preset/other/mutineer/XC = new()

	XC.load_status(H)
	to_chat(H, SPAN_HIGHDANGER("<hr>You are now a Mutineer!"))
	to_chat(H, SPAN_DANGER("Please check the rules to see what you can and can't do as a mutineer.<hr>"))

	for(var/datum/action/human_action/activable/mutineer/mutineer_convert/converted in H.actions)
		for(var/mob/living/carbon/human/chosen in converted.converted)
			XC.load_status(chosen)
			to_chat(chosen, SPAN_HIGHDANGER("<hr>You are now a Mutineer!"))
			to_chat(chosen, SPAN_DANGER("Please check the rules to see what you can and can't do as a mutineer.<hr>"))

		converted.remove_action(H)

	message_staff("[key_name_admin(H)] has begun the mutiny.")
	src.remove_action(H)