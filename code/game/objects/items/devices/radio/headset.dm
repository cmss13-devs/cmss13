#define LOW_MULTIBROADCAST_COOLDOWN 1 MINUTES
#define HIGH_MULTIBROADCAST_COOLDOWN 3 MINUTES

/obj/item/device/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys."
	icon_state = "generic_headset"
	item_state = "headset"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_righthand.dmi',
	)
	matter = list("metal" = 75)
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away

	flags_equip_slot = SLOT_EAR
	inherent_traits = list(TRAIT_ITEM_EAR_EXCLUSIVE)
	var/translate_apollo = FALSE
	var/translate_hive = FALSE
	var/maximum_keys = 3
	var/list/initial_keys //Typepaths of objects to be created at initialisation.
	var/list/keys //Actual objects.
	maxf = 1489

	var/list/inbuilt_tracking_options = list(
		"Squad Leader" = TRACKER_SL,
		"Fireteam Leader" = TRACKER_FTL,
		"Landing Zone" = TRACKER_LZ
	)
	var/list/tracking_options = list()

	var/list/volume_settings

	var/last_multi_broadcast = -999
	var/multibroadcast_cooldown = HIGH_MULTIBROADCAST_COOLDOWN

	var/has_hud = FALSE
	var/headset_hud_on = FALSE
	var/locate_setting = TRACKER_SL
	var/misc_tracking = FALSE
	var/hud_type = MOB_HUD_FACTION_MARINE //Main faction hud. This determines minimap icons and tracking stuff
	var/list/additional_hud_types = list() //Additional faction huds, doesn't change minimap icon or similar
	var/default_freq

	///The type of minimap this headset is added to
	var/minimap_type = MINIMAP_FLAG_USCM

	var/obj/item/device/radio/listening_bug/spy_bug
	var/spy_bug_type

	var/mob/living/carbon/human/wearer

/obj/item/device/radio/headset/Initialize()
	. = ..()
	keys = list()
	for (var/key in initial_keys)
		keys += new key(src)
	recalculateChannels()

	if(length(volume_settings))
		verbs += /obj/item/device/radio/headset/proc/set_volume_setting

	if(has_hud)
		headset_hud_on = TRUE
		verbs += /obj/item/device/radio/headset/proc/toggle_squadhud
		verbs += /obj/item/device/radio/headset/proc/switch_tracker_target

	if(frequency)
		for(var/cycled_channel in GLOB.radiochannels)
			if(GLOB.radiochannels[cycled_channel] == frequency)
				default_freq = cycled_channel

	if(spy_bug_type)
		spy_bug = new spy_bug_type
		spy_bug.forceMove(src)

/obj/item/device/radio/headset/Destroy()
	wearer = null
	if(spy_bug)
		qdel(spy_bug)
		spy_bug = null
	QDEL_NULL_LIST(keys)
	return ..()

/obj/item/device/radio/headset/proc/set_volume_setting()
	set name = "Set Headset Volume"
	set category = "Object"
	set src in usr

	var/static/list/text_to_volume = list(
		RADIO_VOLUME_QUIET_STR = RADIO_VOLUME_QUIET,
		RADIO_VOLUME_RAISED_STR = RADIO_VOLUME_RAISED,
		RADIO_VOLUME_IMPORTANT_STR = RADIO_VOLUME_IMPORTANT,
		RADIO_VOLUME_CRITICAL_STR = RADIO_VOLUME_CRITICAL
	)

	var/volume_setting = tgui_input_list(usr, "Select the volume you want your headset to transmit at.", "Headset Volume", volume_settings)
	if(!volume_setting)
		return
	volume = text_to_volume[volume_setting]
	to_chat(usr, SPAN_NOTICE("You set \the [src]'s volume to <b>[volume_setting]</b>."))

/obj/item/device/radio/headset/handle_message_mode(mob/living/M as mob, message, channel)
	if (channel == RADIO_CHANNEL_SPECIAL)
		if (translate_apollo)
			var/datum/language/apollo = GLOB.all_languages[LANGUAGE_APOLLO]
			apollo.broadcast(M, message)
		if (translate_hive)
			var/datum/language/hivemind = GLOB.all_languages[LANGUAGE_HIVEMIND]
			hivemind.broadcast(M, message)
		return null

	if(default_freq && channel == default_freq)
		return radio_connection

	return ..()

/obj/item/device/radio/headset/attack_self(mob/user as mob)
	on = TRUE //Turn it on if it was off
	. = ..()

/obj/item/device/radio/headset/receive_range(freq, level, aiOverride = 0)
	if (aiOverride)
		return ..(freq, level)
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.has_item_in_ears(src))
			return ..(freq, level)
	return -1

/obj/item/device/radio/headset/attack_hand(mob/user as mob)
	if(!ishuman(user) || loc != user)
		return ..()
	var/mob/living/carbon/human/H = user
	if (!H.has_item_in_ears(src))
		return ..()
	user.set_interaction(src)
	tgui_interact(user)

/obj/item/device/radio/headset/examine(mob/user as mob)
	if(ishuman(user) && loc == user)
		tgui_interact(user)
	return ..()

/obj/item/device/radio/headset/MouseDrop(obj/over_object as obj)
	if(!CAN_PICKUP(usr, src))
		return ..()
	if(!istype(over_object, /atom/movable/screen))
		return ..()
	if(loc != usr) //Makes sure that the headset is equipped, so that we can't drag it into our hand from miles away.
		return ..()

	switch(over_object.name)
		if("r_hand")
			if(usr.drop_inv_item_on_ground(src))
				usr.put_in_r_hand(src)
		if("l_hand")
			if(usr.drop_inv_item_on_ground(src))
				usr.put_in_l_hand(src)
	add_fingerprint(usr)

/obj/item/device/radio/headset/attackby(obj/item/W as obj, mob/user as mob)
// ..()
	user.set_interaction(src)
	if ( !(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) || (istype(W, /obj/item/device/encryptionkey)) ))
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		var/turf/T = get_turf(user)
		if(!T)
			to_chat(user, "You cannot do it here.")
			return
		var/removed_keys = FALSE
		for (var/obj/item/device/encryptionkey/key in keys)
			if(key.abstract)
				continue
			key.forceMove(T)
			keys -= key
			removed_keys = TRUE
		if(removed_keys)
			recalculateChannels()
			to_chat(user, SPAN_NOTICE("You pop out the encryption keys in \the [src]!"))
		else
			to_chat(user, SPAN_NOTICE("This headset doesn't have any encryption keys!  How useless..."))

	if(istype(W, /obj/item/device/encryptionkey/))
		for (var/obj/item/device/encryptionkey/key as anything in keys)
			if (istype(key, W.type))
				to_chat(user, SPAN_NOTICE("A [W.name] is already installed on this device!"))
				return

		var/keycount = 0
		for (var/obj/item/device/encryptionkey/key in keys)
			if(!key.abstract)
				keycount++
		if(keycount >= maximum_keys)
			to_chat(user, SPAN_WARNING("\The [src] can't hold another key!"))
			return
		if(user.drop_held_item())
			W.forceMove(src)
			keys += W
			to_chat(user, SPAN_NOTICE("You slot \the [W] into \the [src]!"))
			recalculateChannels()

	return


/obj/item/device/radio/headset/proc/recalculateChannels()
	for(var/ch_name in channels)
		SSradio.remove_object(src, GLOB.radiochannels[ch_name])
		secure_radio_connections[ch_name] = null
	channels = list()
	translate_apollo = FALSE
	translate_hive = FALSE

	tracking_options = length(inbuilt_tracking_options) ? inbuilt_tracking_options.Copy() : list()
	for(var/i in keys)
		var/obj/item/device/encryptionkey/key = i
		for(var/ch_name in key.channels)
			if(ch_name in channels)
				continue
			channels += ch_name
			channels[ch_name] = key.channels[ch_name]
		for(var/tracking_option in key.tracking_options)
			tracking_options[tracking_option] = key.tracking_options[tracking_option]
		if(key.translate_apollo)
			translate_apollo = TRUE
		if(key.translate_hive)
			translate_hive = TRUE

	if(length(tracking_options))
		var/list/tracking_stuff = list()
		for(var/tracking_fluff in tracking_options)
			tracking_stuff += tracking_options[tracking_fluff]
		if(!(locate_setting in tracking_stuff))
			locate_setting = tracking_stuff[1]
	else
		locate_setting = initial(locate_setting)

	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = SSradio.add_object(src, GLOB.radiochannels[ch_name],  RADIO_CHAT)
	SStgui.update_uis(src)

/obj/item/device/radio/headset/set_frequency(new_frequency)
	..()
	if(frequency)
		for(var/cycled_channel in GLOB.radiochannels)
			if(GLOB.radiochannels[cycled_channel] == frequency)
				default_freq = cycled_channel

/obj/item/device/radio/headset/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if (slot == WEAR_L_EAR || slot == WEAR_R_EAR)
		RegisterSignal(user, list(
			COMSIG_LIVING_REJUVENATED,
			COMSIG_HUMAN_REVIVED,
		), PROC_REF(turn_on))
		wearer = user
		RegisterSignal(user, COMSIG_MOB_STAT_SET_ALIVE, PROC_REF(update_minimap_icon))
		RegisterSignal(user, COMSIG_MOB_LOGGED_IN, PROC_REF(add_hud_tracker))
		RegisterSignal(user, COMSIG_MOB_DEATH, PROC_REF(update_minimap_icon))
		RegisterSignal(user, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(update_minimap_icon))
		if(headset_hud_on)
			var/datum/mob_hud/H = GLOB.huds[hud_type]
			H.add_hud_to(user, src)
			for(var/per_faction_hud in additional_hud_types)
				var/datum/mob_hud/alt_hud = GLOB.huds[per_faction_hud]
				alt_hud.add_hud_to(user, src)
			//squad leader locator is no longer invisible on our player HUD.
			if(user.mind && (user.assigned_squad || misc_tracking) && user.hud_used && user.hud_used.locate_leader)
				user.show_hud_tracker()
			if(misc_tracking)
				SStracking.start_misc_tracking(user)
			INVOKE_NEXT_TICK(src, PROC_REF(update_minimap_icon), wearer)

/obj/item/device/radio/headset/dropped(mob/living/carbon/human/user)
	UnregisterSignal(user, list(
		COMSIG_LIVING_REJUVENATED,
		COMSIG_HUMAN_REVIVED,
		COMSIG_MOB_LOGGED_IN,
		COMSIG_MOB_DEATH,
		COMSIG_HUMAN_SET_UNDEFIBBABLE,
		COMSIG_MOB_STAT_SET_ALIVE
	))
	if(istype(user) && user.has_item_in_ears(src)) //dropped() is called before the inventory reference is update.
		var/datum/mob_hud/H = GLOB.huds[hud_type]
		H.remove_hud_from(user, src)
		for(var/per_faction_hud in additional_hud_types)
			var/datum/mob_hud/alt_hud = GLOB.huds[per_faction_hud]
			alt_hud.remove_hud_from(user, src)

		//squad leader locator is invisible again
		if(user.hud_used && user.hud_used.locate_leader)
			user.hide_hud_tracker()
		if(misc_tracking)
			SStracking.stop_misc_tracking(user)
		SSminimaps.remove_marker(wearer)
	wearer = null
	..()

/obj/item/device/radio/headset/proc/add_hud_tracker(mob/living/carbon/human/user)
	SIGNAL_HANDLER

	if(headset_hud_on && user.mind && (user.assigned_squad || misc_tracking) && user.hud_used?.locate_leader)
		user.show_hud_tracker()

/obj/item/device/radio/headset/proc/turn_on()
	SIGNAL_HANDLER
	on = TRUE

/obj/item/device/radio/headset/proc/toggle_squadhud()
	set name = "Toggle Headset HUD"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0
	headset_hud_on = !headset_hud_on
	if(ishuman(usr))
		var/mob/living/carbon/human/user = usr
		if(user.has_item_in_ears(src)) //worn
			var/datum/mob_hud/H = GLOB.huds[hud_type]
			if(headset_hud_on)
				H.add_hud_to(usr, src)
				for(var/per_faction_hud in additional_hud_types)
					var/datum/mob_hud/alt_hud = GLOB.huds[per_faction_hud]
					alt_hud.add_hud_to(usr, src)
				if(user.mind && (misc_tracking || user.assigned_squad) && user.hud_used?.locate_leader)
					user.show_hud_tracker()
				if(misc_tracking)
					SStracking.start_misc_tracking(user)
				update_minimap_icon()
			else
				H.remove_hud_from(usr, src)
				for(var/per_faction_hud in additional_hud_types)
					var/datum/mob_hud/alt_hud = GLOB.huds[per_faction_hud]
					alt_hud.remove_hud_from(usr, src)
				if(user.hud_used?.locate_leader)
					user.hide_hud_tracker()
				if(misc_tracking)
					SStracking.stop_misc_tracking(user)
				SSminimaps.remove_marker(wearer)
	to_chat(usr, SPAN_NOTICE("You toggle [src]'s headset HUD [headset_hud_on ? "on":"off"]."))
	playsound(src,'sound/machines/click.ogg', 20, 1)

/obj/item/device/radio/headset/proc/switch_tracker_target()
	set name = "Switch Tracker Target"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	handle_switching_tracker_target(usr)

/obj/item/device/radio/headset/proc/handle_switching_tracker_target(mob/living/carbon/human/user)
	var/new_track = tgui_input_list(user, "Choose a new tracking target.", "Tracking Selection", tracking_options)
	if(!new_track)
		return
	to_chat(user, SPAN_NOTICE("You set your headset's tracker to point to <b>[new_track]</b>."))
	locate_setting = tracking_options[new_track]

/obj/item/device/radio/headset/proc/update_minimap_icon()
	SIGNAL_HANDLER
	if(!has_hud)
		return

	if(!wearer)
		return

	SSminimaps.remove_marker(wearer)
	if(!wearer.assigned_equipment_preset || !wearer.assigned_equipment_preset.minimap_icon)
		return
	var/marker_flags = minimap_type
	var/turf/turf_gotten = get_turf(wearer)
	if(!turf_gotten)
		return
	var/z_level = turf_gotten.z

	if(wearer.assigned_equipment_preset.always_minimap_visible == TRUE || wearer.stat == DEAD) //We show to all marines if we have this flag, separated by faction
		if(hud_type == MOB_HUD_FACTION_MARINE)
			marker_flags = MINIMAP_FLAG_USCM
		else if(hud_type == MOB_HUD_FACTION_UPP)
			marker_flags = MINIMAP_FLAG_UPP
		else if(hud_type == MOB_HUD_FACTION_PMC || hud_type == MOB_HUD_FACTION_WY)
			marker_flags = MINIMAP_FLAG_WY
		else if(hud_type == MOB_HUD_FACTION_CLF)
			marker_flags = MINIMAP_FLAG_CLF

	if(wearer.undefibbable)
		set_undefibbable_on_minimap(z_level, marker_flags)
		return

	if(wearer.stat == DEAD)
		set_dead_on_minimap(z_level, marker_flags)
		return

	SSminimaps.add_marker(wearer, z_level, marker_flags, given_image = wearer.assigned_equipment_preset.get_minimap_icon(wearer))

///Change the minimap icon to a dead icon
/obj/item/device/radio/headset/proc/set_dead_on_minimap(z_level, marker_flags)
	var/icon_to_use
	if(world.time > wearer.timeofdeath + wearer.revive_grace_period - 1 MINUTES)
		icon_to_use = "defibbable4"
	else if(world.time > wearer.timeofdeath + wearer.revive_grace_period - 2 MINUTES)
		icon_to_use = "defibbable3"
	else if(world.time > wearer.timeofdeath + wearer.revive_grace_period - 3 MINUTES)
		icon_to_use = "defibbable2"
	else
		icon_to_use = "defibbable"
	SSminimaps.add_marker(wearer, z_level, marker_flags, given_image = wearer.assigned_equipment_preset.get_minimap_icon(wearer), overlay_iconstates = list(icon_to_use))

///Change the minimap icon to a undefibbable icon
/obj/item/device/radio/headset/proc/set_undefibbable_on_minimap(z_level, marker_flags)
	SSminimaps.add_marker(wearer, z_level, marker_flags, given_image = wearer.assigned_equipment_preset.get_minimap_icon(wearer), overlay_iconstates = list("undefibbable"))

/obj/item/device/radio/headset/binary
	initial_keys = list(/obj/item/device/encryptionkey/binary)

//MARINE HEADSETS

/obj/item/device/radio/headset/almayer
	name = "marine radio headset"
	desc = "A standard military radio headset. Bulkier than combat models."
	icon_state = "generic_headset"
	item_state = "headset"
	frequency = PUB_FREQ
	has_hud = TRUE

/obj/item/device/radio/headset/almayer/verb/enter_tree()
	set name = "Enter Techtree"
	set desc = "Enter the Marine techtree"
	set category = "Object.Techtree"
	set src in usr

	var/datum/techtree/T = GET_TREE(TREE_MARINE)
	T.enter_mob(usr)

/obj/item/device/radio/headset/almayer/verb/give_medal_recommendation()
	set name = "Give Medal Recommendation"
	set desc = "Send a medal recommendation for approval by the Commanding Officer"
	set category = "Object.Medals"
	set src in usr

	var/mob/living/carbon/human/wearer = usr
	if(!istype(wearer))
		return
	var/obj/item/card/id/id_card = wearer.get_idcard()
	if(!id_card)
		return

	var/datum/paygrade/paygrade_actual = GLOB.paygrades[id_card.paygrade]
	if(!paygrade_actual)
		return
	if(!istype(paygrade_actual, /datum/paygrade/marine)) //We only want marines to be able to recommend for medals
		return
	if(paygrade_actual.ranking < 3) //E1 starts at 0, so anyone above Corporal (ranking = 3) can recommend for medals
		to_chat(wearer, SPAN_WARNING("Only officers or NCO's (ME4+) can recommend medals!"))
		return
	if(add_medal_recommendation(usr))
		to_chat(usr, SPAN_NOTICE("Recommendation successfully submitted."))

/obj/item/device/radio/headset/almayer/ce
	name = "chief engineer's headset"
	desc = "The headset of the guy in charge of spooling engines, managing MTs, and tearing up the floor for scrap metal. Of robust and sturdy construction. Channels are as follows: :n - engineering, :v - marine command, :m - medical, :u - requisitions, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "ce_headset"
	initial_keys = list(/obj/item/device/encryptionkey/ce)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN
	misc_tracking = TRUE

	inbuilt_tracking_options = list(
		"Landing Zone" = TRACKER_LZ,
		"Alpha SL" = TRACKER_ASL,
		"Bravo SL" = TRACKER_BSL,
		"Charlie SL" = TRACKER_CSL,
		"Delta SL" = TRACKER_DSL,
		"Echo SL" = TRACKER_ESL,
		"Foxtrot SL" = TRACKER_FSL,
		"Intel SL" = TRACKER_ISL
	)

/obj/item/device/radio/headset/almayer/cmo
	name = "chief medical officer's headset"
	desc = "A headset issued to the top brass of medical professionals. Channels are as follows: :m - medical, :v - marine command."
	icon_state = "cmo_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmo)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/almayer/mt
	name = "engineering radio headset"
	desc = "Useful for coordinating maintenance bars and orbital bombardments. Of robust and sturdy construction. To access the engineering channel, use :n."
	icon_state = "eng_headset"
	initial_keys = list(/obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/chef
	name = "kitchen radio headset"
	desc = "Used by the onboard kitchen staff, filled with background noise of sizzling pots. Can coordinate with the supply channel, using :u and inform command of delivery service using :v."
	icon_state = "req_headset"
	initial_keys = list(/obj/item/device/encryptionkey/req/mst)

/obj/item/device/radio/headset/almayer/doc
	name = "medical radio headset"
	desc = "A headset used by the highly trained staff of the medbay. To access the medical channel, use :m."
	icon_state = "med_headset"
	initial_keys = list(/obj/item/device/encryptionkey/med)

/obj/item/device/radio/headset/almayer/research
	name = "researcher radio headset"
	desc = "A headset used by medbay's skilled researchers. Channels are as follows: :m - medical, :t - intel."
	icon_state = "med_headset"
	initial_keys = list(/obj/item/device/encryptionkey/medres)

/obj/item/device/radio/headset/almayer/ct
	name = "supply radio headset"
	desc = "Used by the lowly Cargo Technicians of the USCM, light weight and portable. To access the supply channel, use :u."
	icon_state = "req_headset"
	initial_keys = list(/obj/item/device/encryptionkey/req/ct)

/obj/item/device/radio/headset/almayer/qm
	desc = "A headset used by the quartermaster for controlling their slave(s). Channels are as follows: :u - requisitions, :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	name = "requisition officer radio headset"
	icon_state = "ro_headset"
	initial_keys = list(/obj/item/device/encryptionkey/qm)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/almayer/mmpo
	name = "marine military police radio headset"
	desc = "This is used by marine military police members. Channels are as follows: :p - military police, :v - marine command. :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "sec_headset"
	additional_hud_types = list(MOB_HUD_FACTION_CMB)
	initial_keys = list(/obj/item/device/encryptionkey/mmpo)
	locate_setting = TRACKER_CMP
	misc_tracking = TRUE

	inbuilt_tracking_options = list(
		"Chief MP" = TRACKER_CMP,
		"Military Warden" = TRACKER_WARDEN,
	)

/obj/item/device/radio/headset/almayer/marine/mp_honor
	name = "marine honor guard radio headset"
	desc = "This is used by members of the marine honor guard. Channels are as follows: :p - military police, :v - marine command. :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "sec_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mmpo)
	additional_hud_types = list(MOB_HUD_FACTION_CMB)
	volume = RADIO_VOLUME_RAISED
	locate_setting = TRACKER_CO
	misc_tracking = TRUE

	inbuilt_tracking_options = list(
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Chief MP" = TRACKER_CMP,
		"Military Warden" = TRACKER_WARDEN,
	)

/obj/item/device/radio/headset/almayer/mwcom
	name = "marine Military Warden radio headset"
	desc = "It seems oddly similar to the CMPs'... Smells like donuts too. Channels are as follows: :v - marine command, :p - military police, :n - engineering, :m - medbay, :u - requisitions, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "sec_headset"
	additional_hud_types = list(MOB_HUD_FACTION_CMB, MOB_HUD_FACTION_WY)
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom)
	volume = RADIO_VOLUME_CRITICAL
	locate_setting = TRACKER_CMP
	misc_tracking = TRUE

	inbuilt_tracking_options = list(
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Chief MP" = TRACKER_CMP,
	)

/obj/item/device/radio/headset/almayer/cmpcom
	name = "marine chief MP radio headset"
	desc = "For discussing the purchase of donuts and arresting of hooligans. Channels are as follows: :v - marine command, :p - military police, :n - engineering, :m - medbay, :u - requisitions, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "sec_headset"
	additional_hud_types = list(MOB_HUD_FACTION_CMB, MOB_HUD_FACTION_WY)
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom)
	volume = RADIO_VOLUME_CRITICAL
	locate_setting = TRACKER_CO
	misc_tracking = TRUE

	inbuilt_tracking_options = list(
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Military Warden" = TRACKER_WARDEN,
	)

/obj/item/device/radio/headset/almayer/mcom
	name = "marine command radio headset"
	desc = "Used by CIC staff and higher-ups, features a non-standard brace. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel."
	icon_state = "mcom_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mcom)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN
	misc_tracking = TRUE
	locate_setting = TRACKER_CO

	inbuilt_tracking_options = list(
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Landing Zone" = TRACKER_LZ,
		"Alpha SL" = TRACKER_ASL,
		"Bravo SL" = TRACKER_BSL,
		"Charlie SL" = TRACKER_CSL,
		"Delta SL" = TRACKER_DSL,
		"Echo SL" = TRACKER_ESL,
		"Foxtrot SL" = TRACKER_FSL,
		"Intel SL" = TRACKER_ISL
	)

/obj/item/device/radio/headset/almayer/mcom/alt
	initial_keys = list(/obj/item/device/encryptionkey/mcom/alt)

/obj/item/device/radio/headset/almayer/marine/mp_honor/com
	name = "marine honor guard command radio headset"
	desc = "Given to highly trusted marine honor guard only. It features a non-standard brace. Channels are as follows: :v - marine command, :p - military police, :n - engineering, :m - medbay, :u - requisitions, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "mcom_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom)

/obj/item/device/radio/headset/almayer/po
	name = "marine pilot radio headset"
	desc = "Used by Pilot Officers. Channels are as follows: :v - marine command, :n - engineering, :m - medical, :j - JTAC, :t - intel."
	initial_keys = list(/obj/item/device/encryptionkey/po)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/almayer/intel
	name = "marine intel radio headset"
	desc = "Used by Intelligence Officers. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medical, :j - JTAC, :t - intel."
	initial_keys = list(/obj/item/device/encryptionkey/io)
	frequency = INTEL_FREQ

/obj/item/device/radio/headset/almayer/mcl
	name = "corporate liaison radio headset"
	desc = "Used by the CL to convince people to sign NDAs. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel, :y for WY."
	icon_state = "wy_headset"
	maximum_keys = 5
	initial_keys = list(/obj/item/device/encryptionkey/mcom/cl)
	additional_hud_types = list(MOB_HUD_FACTION_WY, MOB_HUD_FACTION_PMC)
	spy_bug_type = /obj/item/device/radio/listening_bug/radio_linked/fax/wy

/obj/item/device/radio/headset/almayer/mcl/Initialize()
	. = ..()
	if(spy_bug)
		spy_bug.nametag = "CL Radio"

/obj/item/device/radio/headset/almayer/mcl/sec
	name = "corporate security radio headset"
	spy_bug_type = null

	misc_tracking = TRUE
	locate_setting = TRACKER_CL
	inbuilt_tracking_options = list(
		"Corporate Liaison" = TRACKER_CL
	)

/obj/item/device/radio/headset/almayer/reporter
	name = "reporter radio headset"
	desc = "Used by the combat correspondent to get the scoop. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel."
	initial_keys = list(/obj/item/device/encryptionkey/mcom)

/obj/item/device/radio/headset/almayer/rep
	name = "representative radio headset"
	desc = "This headset was the worst invention made, constant chatter comes from it."
	icon_state = "wy_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mcom/rep)

/obj/item/device/radio/headset/almayer/mcom/cdrcom
	name = "marine senior command headset"
	desc = "Issued only to senior command staff. Channels are as follows: :v - marine command, :p - military police, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC,  :t - intel"
	icon_state = "mco_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom/cdrcom)
	additional_hud_types = list(MOB_HUD_FACTION_WY, MOB_HUD_FACTION_CMB)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/mcom/cdrcom/xo
	locate_setting = TRACKER_CO

	inbuilt_tracking_options = list(
		"Commanding Officer" = TRACKER_CO,
		"Landing Zone" = TRACKER_LZ,
		"Alpha SL" = TRACKER_ASL,
		"Bravo SL" = TRACKER_BSL,
		"Charlie SL" = TRACKER_CSL,
		"Delta SL" = TRACKER_DSL,
		"Echo SL" = TRACKER_ESL,
		"Foxtrot SL" = TRACKER_FSL,
		"Intel SL" = TRACKER_ISL
	)

/obj/item/device/radio/headset/almayer/mcom/cdrcom/co
	locate_setting = TRACKER_XO

	inbuilt_tracking_options = list(
		"Executive Officer" = TRACKER_XO,
		"Landing Zone" = TRACKER_LZ,
		"Alpha SL" = TRACKER_ASL,
		"Bravo SL" = TRACKER_BSL,
		"Charlie SL" = TRACKER_CSL,
		"Delta SL" = TRACKER_DSL,
		"Echo SL" = TRACKER_ESL,
		"Foxtrot SL" = TRACKER_FSL,
		"Intel SL" = TRACKER_ISL
	)

/obj/item/device/radio/headset/almayer/mcom/sea
	name = "marine senior enlisted advisor headset"
	desc = "Issued only to senior enlisted advisors. Channels are as follows: :v - marine command, :p - military police, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC,  :t - intel"
	icon_state = "mco_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom/cdrcom)
	volume = RADIO_VOLUME_CRITICAL
	misc_tracking = TRUE
	locate_setting = TRACKER_CO

	inbuilt_tracking_options = list(
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Chief MP" = TRACKER_CMP
	)

/obj/item/device/radio/headset/almayer/mcom/synth
	name = "marine synth headset"
	desc = "Issued only to USCM synthetics. Channels are as follows: :v - marine command, :p - military police, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC,  :t - intel"
	icon_state = "ms_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom/synth)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/mcom/ai
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom/synth/ai)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine
	initial_keys = list(/obj/item/device/encryptionkey/public)

/obj/item/device/radio/headset/almayer/cia
	name = "radio headset"
	desc = "A radio headset."
	frequency = CIA_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/cia, /obj/item/device/encryptionkey/soc, /obj/item/device/encryptionkey/public)


//############################## ALPHA ###############################
/obj/item/device/radio/headset/almayer/marine/alpha
	name = "marine alpha radio headset"
	desc = "This is used by Alpha squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "alpha_headset"
	frequency = ALPHA_FREQ //default frequency is alpha squad channel, not PUB_FREQ

/obj/item/device/radio/headset/almayer/marine/alpha/lead
	name = "marine alpha leader radio headset"
	desc = "This is used by the marine Alpha squad leader. Channels are as follows: :u - requisitions, :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

	inbuilt_tracking_options = list(
		"Squad Leader" = TRACKER_SL,
		"Fireteam Leader" = TRACKER_FTL,
		"Landing Zone" = TRACKER_LZ,
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Bravo SL" = TRACKER_BSL,
		"Charlie SL" = TRACKER_CSL,
		"Delta SL" = TRACKER_DSL,
		"Echo SL" = TRACKER_ESL,
		"Foxtrot SL" = TRACKER_FSL,
		"Intel SL" = TRACKER_ISL
	)

/obj/item/device/radio/headset/almayer/marine/alpha/tl
	name = "marine alpha team leader radio headset"
	desc = "This is used by the marine Alpha team leader. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/alpha/engi
	name = "marine alpha engineer radio headset"
	desc = "This is used by the marine Alpha combat engineers. To access the engineering channel, use :n. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/alpha/med
	name = "marine alpha corpsman radio headset"
	desc = "This is used by the marine Alpha combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)

//############################## BRAVO ###############################
/obj/item/device/radio/headset/almayer/marine/bravo
	name = "marine bravo radio headset"
	desc = "This is used by Bravo squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "bravo_headset"
	frequency = BRAVO_FREQ

/obj/item/device/radio/headset/almayer/marine/bravo/lead
	name = "marine bravo leader radio headset"
	desc = "This is used by the marine Bravo squad leader. Channels are as follows: :u - requisitions, :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

	inbuilt_tracking_options = list(
		"Squad Leader" = TRACKER_SL,
		"Fireteam Leader" = TRACKER_FTL,
		"Landing Zone" = TRACKER_LZ,
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Alpha SL" = TRACKER_ASL,
		"Charlie SL" = TRACKER_CSL,
		"Delta SL" = TRACKER_DSL,
		"Echo SL" = TRACKER_ESL,
		"Foxtrot SL" = TRACKER_FSL,
		"Intel SL" = TRACKER_ISL
	)

/obj/item/device/radio/headset/almayer/marine/bravo/tl
	name = "marine bravo team leader radio headset"
	desc = "This is used by the marine Bravo team leader. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/bravo/engi
	name = "marine bravo engineer radio headset"
	desc = "This is used by the marine Bravo combat engineers. To access the engineering channel, use :n. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/bravo/med
	name = "marine bravo corpsman radio headset"
	desc = "This is used by the marine Bravo combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)

//############################## CHARLIE ###############################
/obj/item/device/radio/headset/almayer/marine/charlie
	name = "marine charlie radio headset"
	desc = "This is used by Charlie squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "charlie_headset"
	frequency = CHARLIE_FREQ

/obj/item/device/radio/headset/almayer/marine/charlie/lead
	name = "marine charlie leader radio headset"
	desc = "This is used by the marine Charlie squad leader. Channels are as follows: :u - requisitions, :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

	inbuilt_tracking_options = list(
		"Squad Leader" = TRACKER_SL,
		"Fireteam Leader" = TRACKER_FTL,
		"Landing Zone" = TRACKER_LZ,
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Alpha SL" = TRACKER_ASL,
		"Bravo SL" = TRACKER_BSL,
		"Delta SL" = TRACKER_DSL,
		"Echo SL" = TRACKER_ESL,
		"Foxtrot SL" = TRACKER_FSL,
		"Intel SL" = TRACKER_ISL
	)

/obj/item/device/radio/headset/almayer/marine/charlie/tl
	name = "marine charlie team leader radio headset"
	desc = "This is used by the marine Charlie team leader. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/charlie/engi
	name = "marine charlie engineer radio headset"
	desc = "This is used by the marine Charlie combat engineers. To access the engineering channel, use :n. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/charlie/med
	name = "marine charlie corpsman radio headset"
	desc = "This is used by the marine Charlie combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)

//############################## DELTA ###############################
/obj/item/device/radio/headset/almayer/marine/delta
	name = "marine delta radio headset"
	desc = "This is used by Delta squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "delta_headset"
	frequency = DELTA_FREQ

/obj/item/device/radio/headset/almayer/marine/delta/lead
	name = "marine delta leader radio headset"
	desc = "This is used by the marine Delta squad leader. Channels are as follows: :u - requisitions, :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

	inbuilt_tracking_options = list(
		"Squad Leader" = TRACKER_SL,
		"Fireteam Leader" = TRACKER_FTL,
		"Landing Zone" = TRACKER_LZ,
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Alpha SL" = TRACKER_ASL,
		"Bravo SL" = TRACKER_BSL,
		"Charlie SL" = TRACKER_CSL,
		"Echo SL" = TRACKER_ESL,
		"Foxtrot SL" = TRACKER_FSL,
		"Intel SL" = TRACKER_ISL
	)

/obj/item/device/radio/headset/almayer/marine/delta/tl
	name = "marine delta team leader radio headset"
	desc = "This is used by the marine Delta team leader. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/delta/engi
	name = "marine delta engineer radio headset"
	desc = "This is used by the marine Delta combat engineers. To access the engineering channel, use :n. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/delta/med
	name = "marine delta corpsman radio headset"
	desc = "This is used by the marine Delta combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)

//############################## ECHO ###############################
/obj/item/device/radio/headset/almayer/marine/echo
	name = "marine echo radio headset"
	desc = "This is used by Echo squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "echo_headset"
	frequency = ECHO_FREQ

/obj/item/device/radio/headset/almayer/marine/echo/lead
	name = "marine echo leader radio headset"
	desc = "This is used by the marine Echo squad leader. Channels are as follows: :u - requisitions, :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

	inbuilt_tracking_options = list( //unknown if this, as of Sept 2024, given to echo leads but adding this here just in case
		"Squad Leader" = TRACKER_SL,
		"Fireteam Leader" = TRACKER_FTL,
		"Landing Zone" = TRACKER_LZ,
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Alpha SL" = TRACKER_ASL,
		"Bravo SL" = TRACKER_BSL,
		"Charlie SL" = TRACKER_CSL,
		"Delta SL" = TRACKER_DSL,
		"Foxtrot SL" = TRACKER_FSL,
		"Intel SL" = TRACKER_ISL
	)

/obj/item/device/radio/headset/almayer/marine/echo/tl
	name = "marine echo team leader radio headset"
	desc = "This is used by the marine Echo team leader. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/echo/engi
	name = "marine echo engineer radio headset"
	desc = "This is used by the marine Echo combat engineers. To access the engineering channel, use :n. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/echo/med
	name = "marine echo corpsman radio headset"
	desc = "This is used by the marine Echo combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)


//############################## CRYO ###############################
/obj/item/device/radio/headset/almayer/marine/cryo
	name = "marine foxtrot radio headset"
	desc = "This is used by Foxtrot squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "cryo_headset"
	frequency = CRYO_FREQ

/obj/item/device/radio/headset/almayer/marine/cryo/lead
	name = "marine foxtrot leader radio headset"
	desc = "This is used by the marine Foxtrot squad leader. Channels are as follows: :u - requisitions, :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

	inbuilt_tracking_options = list(
		"Squad Leader" = TRACKER_SL,
		"Fireteam Leader" = TRACKER_FTL,
		"Landing Zone" = TRACKER_LZ,
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Alpha SL" = TRACKER_ASL,
		"Bravo SL" = TRACKER_BSL,
		"Charlie SL" = TRACKER_CSL,
		"Delta SL" = TRACKER_DSL,
		"Echo SL" = TRACKER_ESL
	)

/obj/item/device/radio/headset/almayer/marine/cryo/tl
	name = "marine foxtrot team leader radio headset"
	desc = "This is used by the marine Foxtrot team leader. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/cryo/engi
	name = "marine foxtrot engineer radio headset"
	desc = "This is used by the marine Foxtrot combat engineers. To access the engineering channel, use :n. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/cryo/med
	name = "marine foxtrot corpsman radio headset"
	desc = "This is used by the marine Foxtrot combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)

/obj/item/device/radio/headset/almayer/marine/mortar
	name = "mortar crew radio headset"
	desc = "This is used by the dust raider's bunker mortar crew to get feedback on how good the hits of that 80mm rain turned out. Comes with access to the engineering channel with :e, JTAC for coordinating with :j, Intel with :t, and request more shells supply with :u - this ain't Winchester Outpost!"
	icon_state = "ce_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mortar)
	volume = RADIO_VOLUME_RAISED

//*************************************
//-----SELF SETTING MARINE HEADSET-----
//*************************************/
//For events. Currently used for WO only. After equipping it, self_set() will adapt headset to marine.

/obj/item/device/radio/headset/almayer/marine/self_setting/proc/self_set()
	var/mob/living/carbon/human/H = loc
	if(istype(H, /mob/living/carbon/human))
		if(H.assigned_squad)
			switch(H.assigned_squad.name)
				if(SQUAD_MARINE_1)
					name = "[SQUAD_MARINE_1] radio headset"
					desc = "This is used by [SQUAD_MARINE_1] squad members."
					icon_state = "alpha_headset"
					frequency = ALPHA_FREQ
				if(SQUAD_MARINE_2)
					name = "[SQUAD_MARINE_2] radio headset"
					desc = "This is used by [SQUAD_MARINE_2] squad members."
					icon_state = "bravo_headset"
					frequency = BRAVO_FREQ
				if(SQUAD_MARINE_3)
					name = "[SQUAD_MARINE_3] radio headset"
					desc = "This is used by [SQUAD_MARINE_3] squad members."
					icon_state = "charlie_headset"
					frequency = CHARLIE_FREQ
				if(SQUAD_MARINE_4)
					name = "[SQUAD_MARINE_4] radio headset"
					desc = "This is used by [SQUAD_MARINE_4] squad members."
					icon_state = "delta_headset"
					frequency = DELTA_FREQ
				if(SQUAD_MARINE_5)
					name = "[SQUAD_MARINE_5] radio headset"
					desc = "This is used by [SQUAD_MARINE_5] squad members."
					frequency = ECHO_FREQ
				if(SQUAD_MARINE_CRYO)
					name = "[SQUAD_MARINE_CRYO] radio headset"
					desc = "This is used by [SQUAD_MARINE_CRYO] squad members."
					frequency = CRYO_FREQ

			switch(GET_DEFAULT_ROLE(H.job))
				if(JOB_SQUAD_LEADER)
					name = "marine leader " + name
					keys += new /obj/item/device/encryptionkey/squadlead(src)
					volume = RADIO_VOLUME_CRITICAL
				if(JOB_SQUAD_MEDIC)
					name = "marine hospital corpsman " + name
					keys += new /obj/item/device/encryptionkey/med(src)
				if(JOB_SQUAD_ENGI)
					name = "marine combat technician " + name
					keys += new /obj/item/device/encryptionkey/engi(src)
				if(JOB_SQUAD_TEAM_LEADER)
					name = "marine fireteam leader " + name
					keys += new /obj/item/device/encryptionkey/jtac(src)
				else
					name = "marine " + name

			set_frequency(frequency)
			for(var/ch_name in channels)
				secure_radio_connections[ch_name] = SSradio.add_object(src, GLOB.radiochannels[ch_name],  RADIO_CHAT)
			recalculateChannels()
			if(H.mind && H.hud_used && H.hud_used.locate_leader) //make SL tracker visible
				H.hud_used.locate_leader.alpha = 255
				H.hud_used.locate_leader.mouse_opacity = MOUSE_OPACITY_ICON

//Distress (ERT) headsets.

/obj/item/device/radio/headset/distress
	name = "colony headset"
	desc = "A standard headset used by colonists."
	frequency = COLONY_FREQ

/obj/item/device/radio/headset/distress/WY
	name = "WY corporate headset"
	desc = "A headset commonly worn by WY corporate personnel."
	icon_state = "wy_headset"
	frequency = WY_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/WY)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_WY

/obj/item/device/radio/headset/distress/WY/guard
	misc_tracking = TRUE
	locate_setting = TRACKER_CL
	inbuilt_tracking_options = list(
		"Corporate Liaison" = TRACKER_CL
	)
	additional_hud_types = list(MOB_HUD_FACTION_WY)

/obj/item/device/radio/headset/distress/hyperdyne
	name = "HC corporate headset"
	desc = "A headset commonly worn by Hyperdyne corporate personnel."
	icon_state = "generic_headset"
	frequency = HDC_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/hyperdyne)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_HC

/obj/item/device/radio/headset/distress/dutch
	name = "Dutch's Dozen headset"
	desc = "A special headset used by small groups of trained operatives. Or terrorists. To access the colony channel, use :h."
	frequency = DUT_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	ignore_z = TRUE

/obj/item/device/radio/headset/distress/cbrn
	name = "\improper CBRN headset"
	desc = "A headset given to CBRN marines. Channels are as follows: :g - public, :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel"
	frequency = CBRN_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/mcom)
	ignore_z = TRUE
	has_hud = TRUE

/obj/item/device/radio/headset/distress/forecon
	name = "\improper Force Recon headset"
	desc = "A headset given to FORECON marines. Channels are as follows: :g - public, :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel"
	frequency = FORECON_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/mcom)
	ignore_z = TRUE
	has_hud = TRUE

//WY Headsets

/obj/item/device/radio/headset/distress/wy_android
	name = "W-Y android headset"
	desc = "A special headset used by unidentified androids. Channels are as follows: :o - colony :y - Corporate #pmc - PMC"
	frequency = WY_WO_FREQ
	icon_state = "ms_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/WY, /obj/item/device/encryptionkey/pmc/command)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_WO
	additional_hud_types = list(MOB_HUD_FACTION_WY, MOB_HUD_FACTION_PMC)

/obj/item/device/radio/headset/distress/pmc
	name = "PMC headset"
	desc = "A special headset used by corporate personnel. Channels are as follows: :g - public, :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel, :y - Corporate."
	frequency = PMC_FREQ
	icon_state = "pmc_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/mcom/cl)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_PMC

	misc_tracking = TRUE
	locate_setting = TRACKER_CL
	inbuilt_tracking_options = list(
		"Corporate Liaison" = TRACKER_CL
	)
	additional_hud_types = list(MOB_HUD_FACTION_WY)

/obj/item/device/radio/headset/distress/pmc/commando
	name = "W-Y commando headset"
	desc = "A special headset used by unidentified operatives. Channels are as follows: :g - public, :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel, :y - Corporate."
	icon_state = "pmc_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/mcom/cl, /obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/WY, /obj/item/device/encryptionkey/pmc)
	maximum_keys = 5

/obj/item/device/radio/headset/distress/pmc/commando/hvh
	name = "W-Y commando headset"
	desc = "A special headset used by unidentified operatives. Channels are as follows: :o - colony :y - Corporate #pmc - PMC."
	icon_state = "pmc_headset"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/WY, /obj/item/device/encryptionkey/pmc)

/obj/item/device/radio/headset/distress/pmc/commando/leader
	name = "W-Y commando leader headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/mcom/cl, /obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/WY, /obj/item/device/encryptionkey/pmc/command)

/obj/item/device/radio/headset/distress/pmc/hvh
	desc = "A special headset used by corporate personnel. Channels are as follows: :o - colony."
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/WY)
	misc_tracking = FALSE

/obj/item/device/radio/headset/distress/pmc/cct
	name = "PMC-CCT headset"
	desc = "A special headset used by corporate personnel. Channels are as follows: :o - colony, #e - engineering, #o - JTAC, #p - general"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/engi, /obj/item/device/encryptionkey/mcom/cl)

/obj/item/device/radio/headset/distress/pmc/cct/hvh
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/engi)
	misc_tracking = FALSE

/obj/item/device/radio/headset/distress/pmc/medic
	name = "PMC-MED headset"
	desc = "A special headset used by corporate personnel. Channels are as follows: :o - colony, #f - medical, #p - general"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/medic, /obj/item/device/encryptionkey/mcom/cl)

/obj/item/device/radio/headset/distress/pmc/medic/hvh
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/medic)
	misc_tracking = FALSE

/obj/item/device/radio/headset/distress/pmc/command
	name = "PMC-CMD headset"
	desc = "A special headset used by corporate personnel. Channels are as follows: :o - colony, #z - command, #f - medical, #e - engineering, #o - JTAC, #p - general"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/command, /obj/item/device/encryptionkey/mcom/cl)
	additional_hud_types = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_WY)

/obj/item/device/radio/headset/distress/pmc/command/hvh
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/command)
	misc_tracking = FALSE
	additional_hud_types = list(MOB_HUD_FACTION_WY)

/obj/item/device/radio/headset/distress/pmc/command/director
	name = "WY director headset"
	desc = "A special headset used by corporate directors. Channels are as follows: :o - colony, #z - command, #f - medical, #e - engineering, #o - JTAC, #p - general"
	maximum_keys = 4
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/command, /obj/item/device/encryptionkey/commando, /obj/item/device/encryptionkey/mcom/cl)
	additional_hud_types = list(MOB_HUD_FACTION_WY, MOB_HUD_FACTION_WO, MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_MARINE)

/obj/item/device/radio/headset/distress/pmc/command/director/hvh
	maximum_keys = 3
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/command, /obj/item/device/encryptionkey/commando)
	misc_tracking = FALSE



//UPP Headsets
/obj/item/device/radio/headset/distress/UPP
	name = "UPP headset"
	desc = "A special headset used by UPP military. To access the colony channel, use :o."
	frequency = UPP_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_UPP

/obj/item/device/radio/headset/distress/UPP/cct
	name = "UPP-CCT headset"
	desc = "A special headset used by UPP military. Channels are as follows: :o - colony, #j - combat controller, #n engineering."
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/upp/engi)

/obj/item/device/radio/headset/distress/UPP/medic
	name = "UPP-MED headset"
	desc = "A special headset used by UPP military. Channels are as follows: :o - colony, #m - medical."
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/upp/medic)

/obj/item/device/radio/headset/distress/UPP/command
	name = "UPP-CMD headset"
	desc = "A special headset used by UPP military. Channels are as follows: :o - colony, #j - combat controller, #n - engineering, #m - medical, #v - command, #u - UPP general."
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/upp/command)

/obj/item/device/radio/headset/distress/UPP/kdo
	name = "UPP-Kdo headset"
	desc = "A specialist headset used by UPP kommandos. Channels are as follows: :o - colony, #j - combat controller, #u - UPP general, #T - kommandos."
	initial_keys = list(/obj/item/device/encryptionkey/upp/kdo, /obj/item/device/encryptionkey/colony)

/obj/item/device/radio/headset/distress/UPP/kdo/medic
	name = "UPP-KdoM headset"
	desc = "A specialist headset used by UPP kommandos. Channels are as follows: :o - colony, #j - combat controller, #m - medical #u - UPP general, #T - kommandos."
	initial_keys = list(/obj/item/device/encryptionkey/upp/kdo, /obj/item/device/encryptionkey/colony)

/obj/item/device/radio/headset/distress/UPP/kdo/command
	name = "UPP-KdoC headset"
	desc = "A specialist headset used by UPP kommandos. Channels are as follows: :o - colony, #j - combat controller, #n - engineering, #m - medical, #v - command, #u - UPP general, #T - kommandos."
	initial_keys = list(/obj/item/device/encryptionkey/upp/kdo, /obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/upp/command)

//CLF Headsets
/obj/item/device/radio/headset/distress/CLF
	name = "CLF headset"
	desc = "A special headset used by small groups of trained operatives. Or terrorists. To access the colony channel use :o."
	frequency = CLF_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_CLF

/obj/item/device/radio/headset/distress/CLF/cct
	name = "CLF-CCT headset"
	desc = "A special headset used by small groups of trained operatives. Or terrorists. Channels are as follows: :o - colony, #d - combat controller, #b - engineering"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/clf/engi)

/obj/item/device/radio/headset/distress/CLF/medic
	name = "CLF-MED headset"
	desc = "A special headset used by small groups of trained operatives. Or terrorists. Channels are as follows: :o - colony, #a - medical"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/clf/medic)

/obj/item/device/radio/headset/distress/CLF/command
	desc = "A special headset used by small groups of trained operatives. Or terrorists. Channels are as follows: :o - colony, #a - medical, #b - engineering, #c - command, #d - combat controller, #g clf general"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/clf/command)

/obj/item/device/radio/headset/distress/contractor
	name = "VAI Headset"
	desc = "A special headset used by Vanguard's Arrow Incorporated mercenaries, features a non-standard brace. Channels are as follows: :g - public, :v - marine command, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel."
	frequency = VAI_FREQ
	icon_state = "vai_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/contractor)
	has_hud = TRUE

/obj/item/device/radio/headset/distress/royal_marine
	name = "Royal Marine Headset"
	desc = "A sleek headset used by the Royal Marines Commando. Low profile enough to fit under their unique helmets."
	frequency = RMC_FREQ
	icon_state = "vai_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/royal_marine)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_TWE
	volume = RADIO_VOLUME_IMPORTANT

/obj/item/device/radio/headset/distress/iasf
	name = "IASF Headset"
	desc = "A sleek headset used by the IASF. Low profile enough to fit under any headgear."
	frequency = RMC_FREQ
	icon_state = "vai_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/royal_marine)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_IASF
	additional_hud_types = list(MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_IASF, MOB_HUD_FACTION_MARINE)
	volume = RADIO_VOLUME_IMPORTANT

//CMB Headsets
/obj/item/device/radio/headset/distress/CMB
	name = "\improper CMB Earpiece"
	desc = "A sleek headset used by The Colonial Marshal Bureau, crafted in Sol. Low profile and comfortable. No one is above the law. Featured channels include: ; - CMB, :o - Colony, :g - public, :v - marine command, :m - medbay, :t - intel."
	frequency = CMB_FREQ
	icon_state = "cmb_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmb)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_CMB
	additional_hud_types = list(MOB_HUD_FACTION_MARINE)

/obj/item/device/radio/headset/distress/CMB/limited
	name = "\improper Damaged CMB Earpiece"
	desc = "A sleek headset used by The Colonial Marshal Bureau, crafted in Sol. Low profile and comfortable. No one is above the law. This one is damaged, so the channels are: ; - CMB, :o - Colony."
	initial_keys = list(/obj/item/device/encryptionkey/colony)

/obj/item/device/radio/headset/distress/CMB/ICC
	name = "\improper ICC Liaison Headset"
	desc = "An expensive headset used by The Interstellar Commerce Commission. This one in particular has a liaison chip with the CMB. Featured channels include: ; - CMB, :o - Colony, :g - public, :v - marine command, :m - medbay, :t - intel, :y - Weyland-Yutani."
	icon_state = "wy_headset"
	additional_hud_types = list(MOB_HUD_FACTION_WY)
	initial_keys = list(/obj/item/device/encryptionkey/WY, /obj/item/device/encryptionkey/cmb)

/obj/item/device/radio/headset/distress/NSPA
	name = "NSPA Headset"
	desc = "A special headset used by the NSPA."
	frequency = RMC_FREQ
	icon_state = "vai_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/royal_marine)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_NSPA
	additional_hud_types = list(MOB_HUD_FACTION_TWE)
	volume = RADIO_VOLUME_IMPORTANT

/obj/item/device/radio/headset/almayer/highcom
	name = "USCM High Command headset"
	desc = "Issued to members of USCM High Command and their immediate subordinates. Channels are as follows: :v - marine command, :p - military police, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC,  :t - intel,  :z - HighCom"
	icon_state = "mhc_headset"
	frequency = HC_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/highcom)
	additional_hud_types = list(MOB_HUD_FACTION_WY, MOB_HUD_FACTION_CMB, MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_MARINE)
	volume = RADIO_VOLUME_CRITICAL
	has_hud = TRUE
	hud_type = MOB_HUD_SECURITY_ADVANCED

/obj/item/device/radio/headset/almayer/provost
	name = "USCM Provost headset"
	desc = "Issued to members of the USCM Provost Office and their immediate subordinates."
	icon_state = "pvst_headset"
	frequency = PVST_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/provost)
	additional_hud_types = list(MOB_HUD_FACTION_CMB, MOB_HUD_FACTION_MARINE)
	volume = RADIO_VOLUME_CRITICAL
	has_hud = TRUE
	hud_type = MOB_HUD_SECURITY_ADVANCED

/obj/item/device/radio/headset/almayer/sof
	name = "USCM SOF headset"
	desc = "Issued exclusively to Marine Raiders and members of the USCM's Force Reconnaissance."
	icon_state = "soc_headset"
	frequency = SOF_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/soc)
	additional_hud_types = list(MOB_HUD_FACTION_WY, MOB_HUD_FACTION_CMB, MOB_HUD_FACTION_TWE)
	volume = RADIO_VOLUME_IMPORTANT

/obj/item/device/radio/headset/almayer/sof/survivor_forecon
	name = "USCM SOF headset"
	desc = "Issued exclusively to Marine Raiders and members of the USCM's Force Reconnaissance."
	icon_state = "soc_headset"
	frequency = SOF_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/soc/forecon)
	volume = RADIO_VOLUME_QUIET
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_MARINE

/obj/item/device/radio/headset/almayer/mcom/vc
	name = "marine vehicle crew radio headset"
	desc = "Used by USCM vehicle crew, features a non-standard brace. Channels are as follows: :v - marine command, :n - engineering, :m - medbay, :u - requisitions"
	initial_keys = list(/obj/item/device/encryptionkey/vc)
	volume = RADIO_VOLUME_RAISED
	multibroadcast_cooldown = HIGH_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/distress/UPP/recon
	name = "\improper UPP headset"
	desc = "A special headset used by recon elements of the UPP military."
	frequency = UPP_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/upp)
	volume = RADIO_VOLUME_QUIET
	ignore_z = FALSE
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_UPP

/obj/item/device/radio/headset/distress/PaP
	name = "\improper UPP PaP headset"
	desc = "A special headset used by the People's Armed Police of the UPP."
	frequency = UPP_FREQ
	icon_state = "sec_headset"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/upp)
	ignore_z = FALSE
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_PAP
	additional_hud_types = list(MOB_HUD_FACTION_UPP)
	volume = RADIO_VOLUME_IMPORTANT
