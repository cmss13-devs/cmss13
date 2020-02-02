/obj/item/device/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys."
	icon_state = "generic_headset"
	item_state = "headset"
	matter = list("metal" = 75)
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away

	flags_equip_slot = SLOT_EAR
	var/translate_binary = 0
	var/translate_hive = 0
	var/obj/item/device/encryptionkey/keyslot1 = null
	var/obj/item/device/encryptionkey/keyslot2 = null
	var/obj/item/device/encryptionkey/keyslot3 = null
	maxf = 1489

/obj/item/device/radio/headset/New()
	..()
	recalculateChannels()

/obj/item/device/radio/headset/handle_message_mode(mob/living/M as mob, message, channel)
	if (channel == "special")
		if (translate_binary)
			var/datum/language/binary = all_languages["Robot Talk"]
			binary.broadcast(M, message)
		if (translate_hive)
			var/datum/language/hivemind = all_languages["Hivemind"]
			hivemind.broadcast(M, message)
		return null

	return ..()

/obj/item/device/radio/headset/receive_range(freq, level, aiOverride = 0)
	if (aiOverride)
		return ..(freq, level)
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.wear_ear == src)
			return ..(freq, level)
	return -1

/obj/item/device/radio/headset/attackby(obj/item/W as obj, mob/user as mob)
//	..()
	user.set_interaction(src)
	if (!( istype(W, /obj/item/tool/screwdriver) || (istype(W, /obj/item/device/encryptionkey/ ))))
		return

	if(istype(W, /obj/item/tool/screwdriver))
		if(keyslot1 || keyslot2 || keyslot3)


			for(var/ch_name in channels)
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null


			if(keyslot1)
				var/turf/T = get_turf(user)
				if(T)
					keyslot1.loc = T
					keyslot1 = null



			if(keyslot2)
				var/turf/T = get_turf(user)
				if(T)
					keyslot2.loc = T
					keyslot2 = null

			if(keyslot3)
				var/turf/T = get_turf(user)
				if(T)
					keyslot3.loc = T
					keyslot3 = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption keys in the headset!")

		else
			to_chat(user, "This headset doesn't have any encryption keys!  How useless...")

	if(istype(W, /obj/item/device/encryptionkey/))
		if(keyslot1 && keyslot2 && keyslot3)
			to_chat(user, "The headset can't hold another key!")
			return

		if(!keyslot1)
			if(user.drop_held_item())
				W.forceMove(src)
				keyslot1 = W


		if(!keyslot2)
			if(user.drop_held_item())
				W.forceMove(src)
				keyslot2 = W
		else
			if(user.drop_held_item())
				W.forceMove(src)
				keyslot3 = W


		recalculateChannels()

	return


/obj/item/device/radio/headset/proc/recalculateChannels()
	channels = list()
	translate_binary = 0
	translate_hive = 0
	syndie = 0

	if(keyslot1)
		for(var/ch_name in keyslot1.channels)
			if(ch_name in channels)
				continue
			channels += ch_name
			channels[ch_name] = keyslot1.channels[ch_name]

		if(keyslot1.translate_binary)
			translate_binary = 1

		if(keyslot1.translate_hive)
			translate_hive = 1

		if(keyslot1.syndie)
			syndie = 1

	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(ch_name in channels)
				continue
			channels += ch_name
			channels[ch_name] = keyslot2.channels[ch_name]

		if(keyslot2.translate_binary)
			translate_binary = 1

		if(keyslot2.translate_hive)
			translate_hive = 1

		if(keyslot2.syndie)
			syndie = 1

	if(keyslot3)
		for(var/ch_name in keyslot3.channels)
			if(ch_name in channels)
				continue
			channels += ch_name
			channels[ch_name] = keyslot3.channels[ch_name]

		if(keyslot3.translate_binary)
			translate_binary = 1

		if(keyslot3.translate_hive)
			translate_hive = 1

		if(keyslot3.syndie)
			syndie = 1


	for (var/ch_name in channels)
		if(!radio_controller)
			sleep(30) // Waiting for the radio_controller to be created.
		if(!radio_controller)
			name = "broken radio headset"
			return

		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)




/obj/item/device/radio/headset/syndicate

	keyslot1 = new /obj/item/device/encryptionkey/syndicate


/obj/item/device/radio/headset/binary

	keyslot1 = new /obj/item/device/encryptionkey/binary



/obj/item/device/radio/headset/ai_integrated //No need to care about icons, it should be hidden inside the AI anyway.
	name = "AI Subspace Transceiver"
	desc = "Integrated AI radio transceiver."
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	keyslot1 = new /obj/item/device/encryptionkey/ai_integrated
	var/myAi = null    // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = 0 // Atlantis: Used to manually disable AI's integrated radio via intellicard menu.

/obj/item/device/radio/headset/ai_integrated/receive_range(freq, level)
	if (disabledAi)
		return -1 //Transciever Disabled.
	return ..(freq, level, 1)

/obj/item/device/radio/headset/ert
	name = "W-Y Response Team headset"
	desc = "The headset of the boss's boss. Channels are as follows: :h - Response Team :c - command, :p - security, :e - engineering, :m - medical."
	icon_state = "com_headset"
	item_state = "headset"
	freerange = 1
	keyslot1 = new /obj/item/device/encryptionkey/ert




//MARINE HEADSETS

/obj/item/device/radio/headset/almayer
	name = "marine radio headset"
	desc = "A standard military radio headset. Bulkier than combat models."
	icon_state = "generic_headset"
	item_state = "headset"
	frequency = PUB_FREQ
	var/headset_hud_on = 1


/obj/item/device/radio/headset/almayer/equipped(mob/living/carbon/human/user, slot)
	if(slot == WEAR_EAR)
		if(headset_hud_on)
			var/datum/mob_hud/H = huds[MOB_HUD_SQUAD]
			H.add_hud_to(user)
			//squad leader locator is no longer invisible on our player HUD.
			if(user.mind && user.assigned_squad && user.hud_used && user.hud_used.locate_leader)
				user.hud_used.locate_leader.alpha = 255
				user.hud_used.locate_leader.mouse_opacity = 1

	..()

/obj/item/device/radio/headset/almayer/dropped(mob/living/carbon/human/user)
	if(istype(user) && headset_hud_on)
		if(user.wear_ear == src) //dropped() is called before the inventory reference is update.
			var/datum/mob_hud/H = huds[MOB_HUD_SQUAD]
			H.remove_hud_from(user)
			//squad leader locator is invisible again
			if(user.hud_used && user.hud_used.locate_leader)
				user.hud_used.locate_leader.alpha = 0
				user.hud_used.locate_leader.mouse_opacity = 0
	..()


/obj/item/device/radio/headset/almayer/verb/toggle_squadhud()
	set name = "Toggle headset HUD"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0
	headset_hud_on = !headset_hud_on
	if(ishuman(usr))
		var/mob/living/carbon/human/user = usr
		if(src == user.wear_ear) //worn
			var/datum/mob_hud/H = huds[MOB_HUD_SQUAD]
			if(headset_hud_on)
				H.add_hud_to(usr)
				if(user.mind && user.assigned_squad && user.hud_used && user.hud_used.locate_leader)
					user.hud_used.locate_leader.alpha = 255
					user.hud_used.locate_leader.mouse_opacity = 1
			else
				H.remove_hud_from(usr)
				if(user.hud_used && user.hud_used.locate_leader)
					user.hud_used.locate_leader.alpha = 0
					user.hud_used.locate_leader.mouse_opacity = 0
	to_chat(usr, SPAN_NOTICE("You toggle [src]'s headset HUD [headset_hud_on ? "on":"off"]."))
	playsound(src,'sound/machines/click.ogg', 20, 1)


/obj/item/device/radio/headset/almayer/ce
	name = "chief engineer's headset"
	desc = "The headset of the guy in charge of spooling engines, managing MTs, and tearing up the floor for scrap metal. Of robust and sturdy construction. Channels are as follows: :e - engineering, :v - marine command, :m - medical, :u - requisitions, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "ce_headset"
	keyslot1 = new /obj/item/device/encryptionkey/ce

/obj/item/device/radio/headset/almayer/cmo
	name = "chief medical officer's headset"
	desc = "A headset issued to the top brass of medical professionals. Channels are as follows: :m - medical, :v - marine command."
	icon_state = "cmo_headset"
	keyslot1 = new /obj/item/device/encryptionkey/cmo

/obj/item/device/radio/headset/almayer/mt
	name = "engineering radio headset"
	desc = "Useful for coordinating maintenance bars and orbital bombardments. Of robust and sturdy construction. To access the engineering channel, use :e."
	icon_state = "eng_headset"
	keyslot1 = new /obj/item/device/encryptionkey/engi

/obj/item/device/radio/headset/almayer/doc
	name = "medical radio headset"
	desc = "A headset used by the highly trained staff of the medbay. To access the medical channel, use :m."
	icon_state = "med_headset"
	keyslot1 = new /obj/item/device/encryptionkey/med

/obj/item/device/radio/headset/almayer/ct
	name = "supply radio headset"
	desc = "Used by the lowly Cargo Technicians of the USCM, light weight and portable. To access the supply channel, use :u."
	icon_state = "req_headset"
	keyslot1 = new /obj/item/device/encryptionkey/req

/obj/item/device/radio/headset/almayer/ro
	desc = "A headset used by the RO for controlling their slave(s). Channels are as follows: :u - requisitions, :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	name = "requisition officer radio headset"
	icon_state = "ro_headset"
	keyslot1 = new /obj/item/device/encryptionkey/ro

/obj/item/device/radio/headset/almayer/mmpo
	name = "marine military police radio headset"
	desc = "This is used by marine military police members. Channels are as follows: :p - military police, :v - marine command."
	icon_state = "sec_headset"
	keyslot1 = new /obj/item/device/encryptionkey/mmpo

/obj/item/device/radio/headset/almayer/cmpcom
	name = "marine chief MP radio headset"
	desc = "For discussing the purchase of donuts and arresting of hooligans. Channels are as follows: :v - marine command, :p - military police, :m - medbay, :e - engineering, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad."
	icon_state = "sec_headset"
	keyslot1 = new /obj/item/device/encryptionkey/cmpcom

/obj/item/device/radio/headset/almayer/mcom
	name = "marine command radio headset"
	desc = "Used by CIC staff and higher-ups, features a non-standard brace. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :e - engineering, :m - medbay, :u - requisitions, :j - JTAC, :z - intelligence."
	icon_state = "mcom_headset"
	keyslot1 = new /obj/item/device/encryptionkey/mcom

/obj/item/device/radio/headset/almayer/po
	name = "marine pilot radio headset"
	desc = "Used by Pilot Officers. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :j - JTAC, :z - intelligence."
	keyslot1 = new /obj/item/device/encryptionkey/po

/obj/item/device/radio/headset/almayer/intel
	name = "marine intel radio headset"
	desc = "Used by Intelligence Officers. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :j - JTAC, :z - intelligence."
	keyslot1 = new /obj/item/device/encryptionkey/po

/obj/item/device/radio/headset/almayer/mcl
	name = "corporate liaison radio headset"
	desc = "Used by the CL to convince people to sign NDAs. Channels are as follows: :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :e - engineering, :m - medbay, :u - requisitions, :j - JTAC, :z - intelligence."
	icon_state = "wy_headset"
	keyslot1 = new /obj/item/device/encryptionkey/mcom

/obj/item/device/radio/headset/almayer/mcom/cdrcom
	name = "marine commanding officer headset"
	desc = "Issued only to Captains. Channels are as follows: :v - marine command, :p - military police, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :e - engineering, :m - medbay, :u - requisitions, :j - JTAC,  :z - intelligence"
	icon_state = "mco_headset"
	keyslot1 = new /obj/item/device/encryptionkey/cmpcom/cdrcom

/obj/item/device/radio/headset/almayer/mcom/ai
	keyslot1 = new /obj/item/device/encryptionkey/mcom/ai

/obj/item/device/radio/headset/almayer/marine

/obj/item/device/radio/headset/almayer/marine/alpha
	name = "marine alpha radio headset"
	desc = "This is used by Alpha squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "alpha_headset"
	frequency = ALPHA_FREQ //default frequency is alpha squad channel, not PUB_FREQ

/obj/item/device/radio/headset/almayer/marine/alpha/lead
	name = "marine alpha leader radio headset"
	desc = "This is used by the marine Alpha squad leader. Channels are as follows: :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/squadlead

/obj/item/device/radio/headset/almayer/marine/alpha/engi
	name = "marine alpha engineer radio headset"
	desc = "This is used by the marine Alpha combat engineers. To access the engineering channel, use :e. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/engi

/obj/item/device/radio/headset/almayer/marine/alpha/med
	name = "marine alpha medic radio headset"
	desc = "This is used by the marine Alpha combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/med



/obj/item/device/radio/headset/almayer/marine/bravo
	name = "marine bravo radio headset"
	desc = "This is used by Bravo squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "bravo_headset"
	frequency = BRAVO_FREQ

/obj/item/device/radio/headset/almayer/marine/bravo/lead
	name = "marine bravo leader radio headset"
	desc = "This is used by the marine Bravo squad leader. Channels are as follows: :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/squadlead

/obj/item/device/radio/headset/almayer/marine/bravo/engi
	name = "marine bravo engineer radio headset"
	desc = "This is used by the marine Bravo combat engineers. To access the engineering channel, use :e. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/engi

/obj/item/device/radio/headset/almayer/marine/bravo/med
	name = "marine bravo medic radio headset"
	desc = "This is used by the marine Bravo combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/med



/obj/item/device/radio/headset/almayer/marine/charlie
	name = "marine charlie radio headset"
	desc = "This is used by Charlie squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "charlie_headset"
	frequency = CHARLIE_FREQ

/obj/item/device/radio/headset/almayer/marine/charlie/lead
	name = "marine charlie leader radio headset"
	desc = "This is used by the marine Charlie squad leader. Channels are as follows: :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/squadlead

/obj/item/device/radio/headset/almayer/marine/charlie/engi
	name = "marine charlie engineer radio headset"
	desc = "This is used by the marine Charlie combat engineers. To access the engineering channel, use :e. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/engi

/obj/item/device/radio/headset/almayer/marine/charlie/med
	name = "marine charlie medic radio headset"
	desc = "This is used by the marine Charlie combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/med



/obj/item/device/radio/headset/almayer/marine/delta
	name = "marine delta radio headset"
	desc = "This is used by Delta squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "delta_headset"
	frequency = DELTA_FREQ

/obj/item/device/radio/headset/almayer/marine/delta/lead
	name = "marine delta leader radio headset"
	desc = "This is used by the marine Delta squad leader. Channels are as follows: :v - marine command, :j - JTAC. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/squadlead

/obj/item/device/radio/headset/almayer/marine/delta/engi
	name = "marine delta engineer radio headset"
	desc = "This is used by the marine Delta combat engineers. To access the engineering channel, use :e. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/engi

/obj/item/device/radio/headset/almayer/marine/delta/med
	name = "marine delta medic radio headset"
	desc = "This is used by the marine Delta combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/med


/* Echo squad cryo support, planned, but not yet implemented. Uncomment when needed.
/obj/item/device/radio/headset/almayer/marine/echo
	name = "marine echo radio headset"
	desc = "This is used by Echo squad members. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	icon_state = "echo_headset"
	frequency = ECHO_FREQ

/obj/item/device/radio/headset/almayer/marine/echo/lead
	name = "marine echo leader radio headset"
	desc = "This is used by the marine Echo squad leader. Channels are as follows: :v - marine command. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/squadlead

/obj/item/device/radio/headset/almayer/marine/echo/engi
	name = "marine echo engineer radio headset"
	desc = "This is used by the marine Echo combat engineers. To access the engineering channel, use :e. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/engi

/obj/item/device/radio/headset/almayer/marine/echo/med
	name = "marine echo medic radio headset"
	desc = "This is used by the marine Echo combat medics. To access the medical channel, use :m. When worn, grants access to Squad Leader tracker. Click tracker with empty hand to open Squad Info window."
	keyslot2 = new /obj/item/device/encryptionkey/med
*/

//Distress (ERT) headsets.

/obj/item/device/radio/headset/distress
	name = "operative headset"
	desc = "A special headset used by small groups of trained operatives."
	frequency = CIV_GEN_FREQ

/obj/item/device/radio/headset/distress/dutch
	name = "Colonist headset"
	desc = "A special headset used by small groups of trained operatives. Or terrorists. To access the civillian common channel, use :h."
	frequency = DUT_FREQ
	keyslot1 = new /obj/item/device/encryptionkey/public_civ

/obj/item/device/radio/headset/distress/PMC
	name = "PMC headset"
	desc = "A special headset used by private security forces. Channels are as follows: :g - public, :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :e - engineering, :m - medbay, :u - requisitions, :j - JTAC, :z - intelligence."
	frequency = PMC_FREQ
	icon_state = "wy_headset"
	keyslot1 = new /obj/item/device/encryptionkey/public
	keyslot2 = new /obj/item/device/encryptionkey/mcom

/obj/item/device/radio/headset/distress/bears
	name = "UPP headset"
	desc = "A special headset used by UPP military. To access the civillian common channel, use :h."
	frequency = RUS_FREQ
	keyslot1 = new /obj/item/device/encryptionkey/public_civ

/obj/item/device/radio/headset/distress/bears/recalculateChannels()
	..()
	syndie = 1

/obj/item/device/radio/headset/distress/commando
	name = "Commando headset"
	desc = "A special headset used by unidentified operatives. Channels are as follows: :g - public, :v - marine command, :a - alpha squad, :b - bravo squad, :c - charlie squad, :d - delta squad, :e - engineering, :m - medbay, :u - requisitions, :j - JTAC, :z - intelligence."
	frequency = DTH_FREQ
	icon_state = "wy_headset"
	keyslot1 = new /obj/item/device/encryptionkey/public
	keyslot2 = new /obj/item/device/encryptionkey/mcom
