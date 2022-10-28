#define LOW_MULTIBROADCAST_COOLDOWN 1 MINUTES
#define HIGH_MULTIBROADCAST_COOLDOWN 3 MINUTES

/obj/item/device/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys."
	icon_state = "generic_headset"
	item_state = "headset"
	matter = list("metal" = 75)
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away

	flags_equip_slot = SLOT_EAR
	inherent_traits = list(TRAIT_ITEM_EAR_EXCLUSIVE)
	var/translate_binary = FALSE
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
	var/hud_type = MOB_HUD_FACTION_USCM
	var/default_freq

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
		for(var/cycled_channel in radiochannels)
			if(radiochannels[cycled_channel] == frequency)
				default_freq = cycled_channel

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
		if (translate_binary)
			var/datum/language/binary = GLOB.all_languages[LANGUAGE_BINARY]
			binary.broadcast(M, message)
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
//	..()
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
		SSradio.remove_object(src, radiochannels[ch_name])
		secure_radio_connections[ch_name] = null
	channels = list()
	translate_binary = FALSE
	translate_hive = FALSE
	syndie = FALSE

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
		if(key.translate_binary)
			translate_binary = TRUE
		if(key.translate_hive)
			translate_hive = TRUE
		if(key.syndie)
			syndie = TRUE

	if(length(tracking_options))
		var/list/tracking_stuff = list()
		for(var/tracking_fluff in tracking_options)
			tracking_stuff += tracking_options[tracking_fluff]
		if(!(locate_setting in tracking_stuff))
			locate_setting = tracking_stuff[1]
	else
		locate_setting = initial(locate_setting)

	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = SSradio.add_object(src, radiochannels[ch_name],  RADIO_CHAT)
	SStgui.update_uis(src)

/obj/item/device/radio/headset/set_frequency(new_frequency)
	..()
	if(frequency)
		for(var/cycled_channel in radiochannels)
			if(radiochannels[cycled_channel] == frequency)
				default_freq = cycled_channel

/obj/item/device/radio/headset/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if (slot == WEAR_L_EAR || slot == WEAR_R_EAR)
		RegisterSignal(user, list(
			COMSIG_LIVING_REJUVENATED,
			COMSIG_HUMAN_REVIVED,
		), .proc/turn_on)
		RegisterSignal(user, COMSIG_MOB_LOGIN, .proc/add_hud_tracker)
		if(headset_hud_on)
			var/datum/mob_hud/H = huds[hud_type]
			H.add_hud_to(user)
			//squad leader locator is no longer invisible on our player HUD.
			if(user.mind && (user.assigned_squad || misc_tracking) && user.hud_used && user.hud_used.locate_leader)
				user.show_hud_tracker()
			if(misc_tracking)
				SStracking.start_misc_tracking(user)

/obj/item/device/radio/headset/dropped(mob/living/carbon/human/user)
	UnregisterSignal(user, list(
		COMSIG_LIVING_REJUVENATED,
		COMSIG_HUMAN_REVIVED,
		COMSIG_MOB_LOGIN
	))
	if(user.has_item_in_ears(src)) //dropped() is called before the inventory reference is update.
		var/datum/mob_hud/H = huds[hud_type]
		H.remove_hud_from(user)
		//squad leader locator is invisible again
		if(user.hud_used && user.hud_used.locate_leader)
			user.hide_hud_tracker()
		if(misc_tracking)
			SStracking.stop_misc_tracking(user)
	..()

/obj/item/device/radio/headset/proc/add_hud_tracker(var/mob/living/carbon/human/user)
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
			var/datum/mob_hud/H = huds[hud_type]
			if(headset_hud_on)
				H.add_hud_to(usr)
				if(user.mind && (misc_tracking || user.assigned_squad) && user.hud_used?.locate_leader)
					user.show_hud_tracker()
				if(misc_tracking)
					SStracking.start_misc_tracking(user)
			else
				H.remove_hud_from(usr)
				if(user.hud_used?.locate_leader)
					user.hide_hud_tracker()
				if(misc_tracking)
					SStracking.stop_misc_tracking(user)
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

/obj/item/device/radio/headset/binary
	initial_keys = list(/obj/item/device/encryptionkey/binary)

/obj/item/device/radio/headset/ai_integrated //No need to care about icons, it should be hidden inside the AI anyway.
	name = "AI Subspace Transceiver"
	desc = "Integrated AI radio transceiver."
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	initial_keys = list(/obj/item/device/encryptionkey/ai_integrated)
	var/myAi = null    // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = 0 // Atlantis: Used to manually disable AI's integrated radio via intellicard menu.

/obj/item/device/radio/headset/ai_integrated/receive_range(freq, level)
	if (disabledAi)
		return -1 //Transciever Disabled.
	return ..(freq, level, 1)

/obj/item/device/radio/headset/ert
	name = "Wey-Yu Response Team headset"
	desc = "The headset of the boss's boss. Channels are as follows: :h - Response Team :c - command, :p - security, :n - engineering, :m - medical."
	icon_state = "com_headset"
	item_state = "headset"
	freerange = 1
	initial_keys = list(/obj/item/device/encryptionkey/ert)

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

/obj/item/device/radio/headset/almayer/ce
	name = "chief engineer's headset"
	desc = "The headset of the guy in charge of spooling engines, managing MTs, and tearing up the floor for scrap metal. Of robust and sturdy construction. Channels are as follows: :n - engineering, :v - marine command, :m - medical, :u - requisitions, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "ce_headset"
	initial_keys = list(/obj/item/device/encryptionkey/ce)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

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
	desc = "Used by the onboard kitchen staff, filled with background noise of sizzling pots. Can coordinate with the supply channel, using :u."
	icon_state = "req_headset"
	initial_keys = list(/obj/item/device/encryptionkey/req/ct)

/obj/item/device/radio/headset/almayer/doc
	name = "medical radio headset"
	desc = "A headset used by the highly trained staff of the medbay. To access the medical channel, use :m."
	icon_state = "med_headset"
	initial_keys = list(/obj/item/device/encryptionkey/med)

/obj/item/device/radio/headset/almayer/ct
	name = "supply radio headset"
	desc = "Used by the lowly Cargo Technicians of the USCM, light weight and portable. To access the supply channel, use :u."
	icon_state = "req_headset"
	initial_keys = list(/obj/item/device/encryptionkey/req/ct)

/obj/item/device/radio/headset/almayer/ro
	desc = "A headset used by the RO for controlling their slave(s). Channels are as follows: :u - requisitions, :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	name = "requisition officer radio headset"
	icon_state = "ro_headset"
	initial_keys = list(/obj/item/device/encryptionkey/ro)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/almayer/mmpo
	name = "marine military police radio headset"
	desc = "This is used by marine military police members. Channels are as follows: :p - military police, :v - marine command. :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "sec_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mmpo)

/obj/item/device/radio/headset/almayer/marine/mp_honor
	name = "marine honor guard radio headset"
	desc = "This is used by members of the marine honor guard. Channels are as follows: :p - military police, :v - marine command. :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "sec_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mmpo)
	volume = RADIO_VOLUME_RAISED
	locate_setting = TRACKER_CO
	misc_tracking = TRUE

	inbuilt_tracking_options = list(
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO
	)

/obj/item/device/radio/headset/almayer/cmpcom
	name = "marine chief MP radio headset"
	desc = "For discussing the purchase of donuts and arresting of hooligans. Channels are as follows: :v - marine command, :p - military police, :n - engineering, :m - medbay, :u - requisitions, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "sec_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/mcom
	name = "marine command radio headset"
	desc = "Used by CIC staff and higher-ups, features a non-standard brace. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel."
	icon_state = "mcom_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mcom)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/almayer/marine/mp_honor/com
	name = "marine honor guard command radio headset"
	desc = "Given to highly trusted marine honor guard only. It features a non-standard brace. Channels are as follows: :v - marine command, :p - military police, :n - engineering, :m - medbay, :u - requisitions, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "mcom_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom)

/obj/item/device/radio/headset/almayer/po
	name = "marine pilot radio headset"
	desc = "Used by Pilot Officers. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :j - JTAC, :t - intel."
	initial_keys = list(/obj/item/device/encryptionkey/po)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/almayer/intel
	name = "marine intel radio headset"
	desc = "Used by Intelligence Officers. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :j - JTAC, :t - intel."
	initial_keys = list(/obj/item/device/encryptionkey/po)

/obj/item/device/radio/headset/almayer/mcl
	name = "corporate liaison radio headset"
	desc = "Used by the CL to convince people to sign NDAs. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel, :y for WY."
	icon_state = "wy_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mcom/cl)

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
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/mcom/synth
	name = "marine synth headset"
	desc = "Issued only to USCM synthetics. Channels are as follows: :v - marine command, :p - military police, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC,  :t - intel"
	icon_state = "ms_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom/synth)
	volume = RADIO_VOLUME_CRITICAL
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
		"Echo SL" = TRACKER_ESL
	)

/obj/item/device/radio/headset/almayer/mcom/ai
	initial_keys = list(/obj/item/device/encryptionkey/mcom/ai)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine
	initial_keys = list(/obj/item/device/encryptionkey/public)

//############################## ALPHA ###############################
/obj/item/device/radio/headset/almayer/marine/alpha
	name = "marine alpha radio headset"
	desc = "This is used by Alpha squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "alpha_headset"
	frequency = ALPHA_FREQ //default frequency is alpha squad channel, not PUB_FREQ

/obj/item/device/radio/headset/almayer/marine/alpha/lead
	name = "marine alpha leader radio headset"
	desc = "This is used by the marine Alpha squad leader. Channels are as follows: :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/alpha/rto
	name = "marine alpha RTO radio headset"
	desc = "This is used by the marine Alpha RTO. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
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
	desc = "This is used by the marine Bravo squad leader. Channels are as follows: :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/bravo/rto
	name = "marine bravo RTO radio headset"
	desc = "This is used by the marine Bravo RTO. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
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
	desc = "This is used by the marine Charlie squad leader. Channels are as follows: :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/charlie/rto
	name = "marine charlie RTO radio headset"
	desc = "This is used by the marine Charlie RTO. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
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
	desc = "This is used by the marine Delta squad leader. Channels are as follows: :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/delta/rto
	name = "marine delta RTO radio headset"
	desc = "This is used by the marine Delta RTO. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
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
	desc = "This is used by the marine Echo squad leader. Channels are as follows: :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/echo/rto
	name = "marine echo RTO radio headset"
	desc = "This is used by the marine Echo RTO. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
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
	desc = "This is used by the marine Foxtrot squad leader. Channels are as follows: :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/cryo/rto
	name = "marine foxtrot RTO radio headset"
	desc = "This is used by the marine Foxtrot RTO. Channels are as follows: :u - requisitions, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
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
				if(JOB_SQUAD_RTO)
					name = "marine RTO " + name
					keys += new /obj/item/device/encryptionkey/jtac(src)
				else
					name = "marine " + name

			set_frequency(frequency)
			for(var/ch_name in channels)
				secure_radio_connections[ch_name] = SSradio.add_object(src, radiochannels[ch_name],  RADIO_CHAT)
			recalculateChannels()
			if(H.mind && H.hud_used && H.hud_used.locate_leader)	//make SL tracker visible
				H.hud_used.locate_leader.alpha = 255
				H.hud_used.locate_leader.mouse_opacity = 1

//Distress (ERT) headsets.

/obj/item/device/radio/headset/distress
	name = "colony headset"
	desc = "A standard headset used by colonists."
	frequency = COLONY_FREQ

/obj/item/device/radio/headset/distress/dutch
	name = "Dutch's Dozen headset"
	desc = "A special headset used by small groups of trained operatives. Or terrorists. To access the colony channel, use :h."
	frequency = DUT_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	ignore_z = TRUE

/obj/item/device/radio/headset/distress/PMC
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

/obj/item/device/radio/headset/distress/PMC/hvh
	desc = "A special headset used by corporate personnel. Channels are as follows: :h - public."
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	misc_tracking = FALSE

/obj/item/device/radio/headset/distress/PMC/hvh/cct
	name = "PMC-CCT headset"
	desc = "A special headset used by corporate personnel. Channels are as follows: :h - public, :o - combat controller."
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/cct)

/obj/item/device/radio/headset/distress/UPP
	name = "UPP headset"
	desc = "A special headset used by UPP military. To access the colony channel, use :h."
	frequency = RUS_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_UPP

/obj/item/device/radio/headset/distress/UPP/recalculateChannels()
	..()
	syndie = 1

/obj/item/device/radio/headset/distress/UPP/cct
	name = "UPP-CCT headset"
	desc = "A special headset used by UPP military. Channels are as follows: :h - public, :o - combat controller."
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/cct)

/obj/item/device/radio/headset/distress/CLF
	name = "CLF headset"
	desc = "A special headset used by small groups of trained operatives. Or terrorists. To access the colony channel, use :h."
	frequency = CLF_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	has_hud = TRUE
	hud_type = MOB_HUD_FACTION_CLF

/obj/item/device/radio/headset/distress/CLF/cct
	name = "CLF-CCT headset"
	desc = "A special headset used by small groups of trained operatives. Or terrorists. Channels are as follows: :h - public, :o - combat controller."
	frequency = CLF_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/cct)

/obj/item/device/radio/headset/distress/commando
	name = "Commando headset"
	desc = "A special headset used by unidentified operatives. Channels are as follows: :g - public, :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel."
	frequency = DTH_FREQ
	icon_state = "pmc_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/mcom)

/obj/item/device/radio/headset/distress/contractor
	name = "VAI Headset"
	desc = "A special headset used by Vanguard's Arrow Incorporated mercenaries, features a non-standard brace. Channels are as follows: :g - public, :v - marine command, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel."
	frequency = VAI_FREQ
	icon_state = "vai_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/contractor)
	has_hud = TRUE

/obj/item/device/radio/headset/almayer/highcom
	name = "USCM High Command headset"
	desc = "Issued to members of USCM High Command and their immediate subordinates. Channels are as follows: :v - marine command, :p - military police, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC,  :t - intel,  :z - HighCom"
	icon_state = "mhc_headset"
	initial_keys = list(/obj/item/device/encryptionkey/highcom)
	volume = RADIO_VOLUME_CRITICAL
	ignore_z = TRUE

/obj/item/device/radio/headset/almayer/marsoc
	name = "USCM MARSOC headset"
	desc = "Issued exclusively to members of the Marines Special Operations Command."
	icon_state = "soc_headset"
	frequency = MARSOC_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/soc)
	volume = RADIO_VOLUME_IMPORTANT
	ignore_z = TRUE

/obj/item/device/radio/headset/almayer/mcom/vc
	name = "marine vehicle crew radio headset"
	desc = "Used by USCM vehicle crew, features a non-standard brace. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :n - engineering, :m - medbay, :u - requisitions, :j - JTAC, :t - intel."
	volume = RADIO_VOLUME_RAISED
	multibroadcast_cooldown = HIGH_MULTIBROADCAST_COOLDOWN
