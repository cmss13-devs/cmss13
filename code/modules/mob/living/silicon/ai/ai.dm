#define AI_CHECK_WIRELESS 1
#define AI_CHECK_RADIO 2

var/list/ai_list = list()
var/list/ai_verbs_default = list(
	/mob/living/silicon/ai/proc/ai_alerts,
	/mob/living/silicon/ai/proc/ai_announcement,
	// /mob/living/silicon/ai/proc/ai_recall_shuttle,
	/mob/living/silicon/ai/proc/ai_camera_track,
	/mob/living/silicon/ai/proc/ai_camera_list,
	/mob/living/silicon/ai/proc/ai_goto_location,
	/mob/living/silicon/ai/proc/ai_remove_location,
	/mob/living/silicon/ai/proc/ai_roster,
	/mob/living/silicon/ai/proc/ai_store_location,
	/mob/living/silicon/ai/proc/control_integrated_radio,
	/mob/living/silicon/ai/proc/core,
	/mob/living/silicon/ai/proc/pick_icon,
	/mob/living/silicon/ai/proc/sensor_mode,
	/mob/living/silicon/ai/proc/toggle_acceleration
)


	//mob/living/silicon/ai/proc/ai_hologram_change,

	//mob/living/silicon/ai/proc/ai_network_change
	//mob/living/silicon/ai/proc/ai_statuschange,
	//mob/living/silicon/ai/proc/toggle_camera_light

//Not sure why this is necessary...
/proc/AutoUpdateAI(obj/subject)
	var/is_in_use = 0
	if (subject!=null)
		for(var/A in ai_list)
			var/mob/living/silicon/ai/M = A
			if ((M.client && M.interactee == subject))
				is_in_use = 1
				subject.attack_remote(M)
	return is_in_use


/mob/living/silicon/ai
	name = "AI"
	icon = 'icons/mob/AI.dmi'//
	icon_state = "ai"
	anchored = 1 // -- TLE
	density = 1
	status_flags = CANSTUN|CANKNOCKOUT
	med_hud = MOB_HUD_MEDICAL_BASIC
	sec_hud = MOB_HUD_SECURITY_BASIC
	var/list/network = list(CAMERA_NET_ALMAYER)
	var/obj/structure/machinery/camera/camera = null
	var/list/connected_robots = list()
	var/aiRestorePowerRoutine = 0
	//var/list/laws = list()
	var/viewalerts = 0
	var/lawcheck[1]
	var/ioncheck[1]
	var/lawchannel = "Common" // Default channel on which to state laws
	var/icon/holo_icon//Default is assigned when AI is created.
//	var/obj/item/device/pda/ai/aiPDA = null
	var/obj/item/device/multitool/aiMulti = null
	var/obj/item/device/radio/headset/ai_integrated/aiRadio = null
//Hud stuff

	//MALFUNCTION
	var/datum/AI_Module/module_picker/malf_picker
	var/processing_time = 100
	var/list/datum/AI_Module/current_modules = list()
	var/fire_res_on_core = 0

	var/control_disabled = 0 // Set to 1 to stop AI from interacting via Click() -- TLE
	var/malfhacking = 0 // More or less a copy of the above var, so that malf AIs can hack and still get new cyborgs -- NeoFite

	var/obj/structure/machinery/power/apc/malfhack = null
	var/explosive = 0 //does the AI explode when it dies?

	var/mob/living/silicon/ai/parent = null

	var/camera_light_on = 0	//Defines if the AI toggled the light on the camera it's looking through.
	var/datum/trackable/track = null
	var/last_announcement = ""
	var/datum/announcement/priority/announcement

/mob/living/silicon/ai/proc/add_ai_verbs()
	add_verb(src, ai_verbs_default)

/mob/living/silicon/ai/proc/remove_ai_verbs()
	remove_verb(src, ai_verbs_default)

/mob/living/silicon/ai/New(loc, var/obj/item/device/mmi/B, var/safety = 0)
	var/list/possibleNames = ai_names

	var/pickedName = null
	while(!pickedName)
		pickedName = pick(ai_names)
		for (var/mob/living/silicon/ai/A in GLOB.mob_list)
			if (A.real_name == pickedName && possibleNames.len > 1) //fixing the theoretically possible infinite loop
				possibleNames -= pickedName
				pickedName = null

//	aiPDA = new/obj/item/device/pda/ai(src)
	SetName(pickedName)
	anchored = 1
	canmove = 0
	density = 1
	forceMove(loc)

	holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))

	aiMulti = new(src)
	aiRadio = new(src)
	aiRadio.myAi = src
	aiCamera = new/obj/item/device/camera/siliconcam/ai_camera(src)

	if (istype(loc, /turf))
		add_ai_verbs(src)

	//Languages
	add_language(LANGUAGE_BINARY, 1)
	add_language(LANGUAGE_ENGLISH, 1)
	add_language(LANGUAGE_RUSSIAN, 1)
	add_language(LANGUAGE_XENOMORPH, 0)


	if(!safety)//Only used by AIize() to successfully spawn an AI.
		if (!B)//If there is no player/brain inside.
			new/obj/structure/AIcore/deactivated(loc)//New empty terminal.
			qdel(src)//Delete AI.
			return
		else
			if (B.brainmob.mind)
				B.brainmob.mind.transfer_to(src)

			to_chat(src, "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>")
			to_chat(src, "<B>To look at other parts of the station, click on yourself to get a camera menu.</B>")
			to_chat(src, "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
			to_chat(src, "To use something, simply click on it.")
			to_chat(src, "Use say :b to speak to your cyborgs through binary.")
			show_laws()
			to_chat(src, "<b>These laws may be changed by other players, or by you being the traitor.</b>")

			job = "AI"

	spawn(5)
		new /obj/structure/machinery/ai_powersupply(src)

	ai_list += src
	..()
	return

/mob/living/silicon/ai/Destroy()
	ai_list -= src
	. = ..()

/mob/living/silicon/ai/proc/SetName(pickedName as text)
	change_real_name(src, pickedName)

	if(eyeobj)
		eyeobj.name = "[pickedName] (AI Eye)"

	// Set ai pda name
	/*
	if(aiPDA)
		aiPDA.ownjob = "AI"
		aiPDA.owner = pickedName
		aiPDA.name = pickedName + " (" + aiPDA.ownjob + ")"
	Fuck PDAs */

/*
	The AI Power supply is a dummy object used for powering the AI since only machinery should be using power.
	The alternative was to rewrite a bunch of AI code instead here we are.
*/
/obj/structure/machinery/ai_powersupply
	name="Power Supply"
	active_power_usage=1000
	use_power = 2
	power_channel = POWER_CHANNEL_EQUIP
	var/mob/living/silicon/ai/powered_ai = null
	invisibility = 100

/obj/structure/machinery/ai_powersupply/New(var/mob/living/silicon/ai/ai)
	powered_ai = ai
	if(isnull(powered_ai))
		qdel(src)
		return
	forceMove(powered_ai.loc)
	use_power(1) // Just incase we need to wake up the power system.
	//start_processing()
	//..()

/obj/structure/machinery/ai_powersupply/process()
	if(!powered_ai || powered_ai.stat & DEAD)
		qdel(src)
		return
	if(!powered_ai.anchored)
		forceMove(powered_ai.loc)
		update_use_power(0)
	if(powered_ai.anchored)
		update_use_power(2)

/mob/living/silicon/ai/proc/pick_icon()
	set category = "AI Commands"
	set name = "Set AI Core Display"
	if(stat || aiRestorePowerRoutine)
		return

		//if(icon_state == initial(icon_state))
	var/icontype = tgui_input_list(usr, "Select an icon!", "AI", list("Monochrome", "Rainbow", "Blue", "Inverted", "Text", "Smiley", "Angry", "Dorf", "Matrix", "Bliss", "Firewall", "Green", "Red", "Static", "Triumvirate", "Triumvirate Static", "Soviet", "Trapped", "Heartline", "Chatterbox"))
	switch(icontype)
		if("Rainbow") icon_state = "ai-clown"
		if("Monochrome") icon_state = "ai-mono"
		if("Inverted") icon_state = "ai-u"
		if("Firewall") icon_state = "ai-magma"
		if("Green") icon_state = "ai-wierd"
		if("Red") icon_state = "ai-red"
		if("Static") icon_state = "ai-static"
		if("Text") icon_state = "ai-text"
		if("Smiley") icon_state = "ai-smiley"
		if("Matrix") icon_state = "ai-matrix"
		if("Angry") icon_state = "ai-angryface"
		if("Dorf") icon_state = "ai-dorf"
		if("Bliss") icon_state = "ai-bliss"
		if("Triumvirate") icon_state = "ai-triumvirate"
		if("Triumvirate Static") icon_state = "ai-triumvirate-malf"
		if("Soviet") icon_state = "ai-redoctober"
		if("Trapped") icon_state = "ai-hades"
		if("Heartline") icon_state = "ai-heartline"
		if("Chatterbox") icon_state = "ai-president"
		else icon_state = "ai"

/mob/living/silicon/ai/proc/ai_alerts()
	set category = "AI Commands"
	set name = "Show Alerts"

	var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[src];mach_close=aialerts'>Close</A><BR><BR>"
	for (var/cat in alarms)
		dat += text("<B>[]</B><BR>\n", cat)
		var/list/alarmlist = alarms[cat]
		if (alarmlist.len)
			for (var/area_name in alarmlist)
				var/datum/alarm/alarm = alarmlist[area_name]
				dat += "<NOBR>"

				var/cameratext = ""
				if (alarm.cameras)
					for (var/obj/structure/machinery/camera/I in alarm.cameras)
						cameratext += text("[]<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>", (cameratext=="") ? "" : "|", src, I, I.c_tag)
				dat += text("-- [] ([])", alarm.area.name, (cameratext)? cameratext : "No Camera")

				if (alarm.sources.len > 1)
					dat += text(" - [] sources", alarm.sources.len)
				dat += "</NOBR><BR>\n"
		else
			dat += "-- All Systems Nominal<BR>\n"
		dat += "<BR>\n"

	viewalerts = 1
	src << browse(dat, "window=aialerts&can_close=0")

// this verb lets the ai see the stations manifest
/mob/living/silicon/ai/proc/ai_roster()
	set category = "AI Commands"
	set name = "Show Crew Manifest"
	show_station_manifest()

/mob/living/silicon/ai/var/message_cooldown = 0
/mob/living/silicon/ai/proc/ai_announcement()
	set category = "AI Commands"
	set name = "Make Station Announcement"

	if(check_unable(AI_CHECK_WIRELESS|AI_CHECK_RADIO))
		return

	if(message_cooldown)
		to_chat(src, "Please allow one minute to pass between announcements.")
		return
	var/input = stripped_multiline_input(usr, "Please write a message to announce to the station crew.", "A.I. Announcement")
	if(!input)
		return

	if(check_unable(AI_CHECK_WIRELESS|AI_CHECK_RADIO))
		return

	ai_announcement(input)
	message_cooldown = 1
	spawn(1 MINUTES)//One minute cooldown
		message_cooldown = 0

/mob/living/silicon/ai/check_eye(mob/user)
	if (!camera)
		user.reset_view(null)
		return
	user.reset_view(camera)

/mob/living/silicon/ai/is_mob_restrained()
	return 0

/mob/living/silicon/ai/emp_act(severity)
	if (prob(30)) view_core()
	..()

/mob/living/silicon/ai/Topic(href, href_list)
	if(usr != src)
		return
	..()
	if (href_list["mach_close"])
		if (href_list["mach_close"] == "aialerts")
			viewalerts = 0
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_interaction()
		src << browse(null, t1)
	if (href_list["switchcamera"])
		switchCamera(locate(href_list["switchcamera"])) in cameranet.cameras
	if (href_list["showalerts"])
		ai_alerts()
	//Carn: holopad requests
	if (href_list["jumptoholopad"])
		var/obj/structure/machinery/hologram/holopad/H = locate(href_list["jumptoholopad"])
		if(stat == CONSCIOUS)
			if(H)
				H.attack_remote(src) //may as well recycle
			else
				to_chat(src, SPAN_NOTICE("Unable to locate the holopad."))

	if (href_list["track"])
		var/mob/target = locate(href_list["track"]) in GLOB.mob_list

		if(target && (!istype(target, /mob/living/carbon/human) || html_decode(href_list["trackname"]) == target:get_face_name()))
			ai_actual_track(target)
		else
			to_chat(src, "<span class='danger'>System error. Cannot locate.")
		return

	return

/mob/living/silicon/ai/attack_animal(mob/living/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 25, 1)
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_DANGER("<B>[M]</B> [M.attacktext] [src]!"), 1)
		last_damage_data = create_cause_data(initial(M.name), M)
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		apply_damage(damage, BRUTE)
		updatehealth()

/mob/living/silicon/ai/reset_view(atom/A)
	if(camera)
		camera.SetLuminosity(0)
	if(istype(A,/obj/structure/machinery/camera))
		camera = A
	..()
	if(istype(A,/obj/structure/machinery/camera))
		if(camera_light_on)	A.SetLuminosity(AI_CAMERA_LUMINOSITY)
		else				A.SetLuminosity(0)


/mob/living/silicon/ai/proc/switchCamera(var/obj/structure/machinery/camera/C)
	if (!C || stat == DEAD) //C.can_use())
		return 0

	if(!src.eyeobj)
		view_core()
		return
	// ok, we're alive, camera is good and in our network...
	eyeobj.setLoc(get_turf(C))
	//machine = src

	return 1

/mob/living/silicon/ai/triggerAlarm(var/class, area/A, list/cameralist, var/source)
	if (stat == 2)
		return 1

	..()

	var/cameratext = ""
	for (var/obj/structure/machinery/camera/C in cameralist)
		cameratext += "[(cameratext == "")? "" : "|"]<A HREF=?src=\ref[src];switchcamera=\ref[C]>[C.c_tag]</A>"

	queueAlarm("--- [class] alarm detected in [A.name]! ([(cameratext)? cameratext : "No Camera"])", class)

	if (viewalerts) ai_alerts()

/mob/living/silicon/ai/cancelAlarm(var/class, area/A as area, var/source)
	var/has_alarm = ..()

	if (!has_alarm)
		queueAlarm(text("--- [] alarm in [] has been cleared.", class, A.name), class, 0)
		if (viewalerts) ai_alerts()

	return has_alarm

/mob/living/silicon/ai/cancel_camera()
	set category = "AI Commands"
	set name = "Cancel Camera View"

	//src.cameraFollow = null
	src.view_core()


//Replaces /mob/living/silicon/ai/verb/change_network() in ai.dm & camera.dm
//Adds in /mob/living/silicon/ai/proc/ai_network_change() instead
//Addition by Mord_Sith to define AI's network change ability
/mob/living/silicon/ai/proc/ai_network_change()
	set category = "AI Commands"
	set name = "Jump To Network"
	unset_interaction()
	var/cameralist[0]

	if(check_unable())
		return

	var/mob/living/silicon/ai/U = usr

	for (var/obj/structure/machinery/camera/C in cameranet.cameras)
		if(!C.can_use())
			continue

		var/list/tempnetwork = difflist(C.network,RESTRICTED_CAMERA_NETWORKS,1)
		if(tempnetwork.len)
			for(var/i in tempnetwork)
				cameralist[i] = i
	var/old_network = network
	network = tgui_input_list(U, "Which network would you like to view?", "View network", cameralist)

	if(!U.eyeobj)
		U.view_core()
		return

	if(isnull(network))
		network = old_network // If nothing is selected
	else
		for(var/obj/structure/machinery/camera/C in cameranet.cameras)
			if(!C.can_use())
				continue
			if(network in C.network)
				U.eyeobj.setLoc(get_turf(C))
				break
	to_chat(src, SPAN_NOTICE(" Switched to [network] camera network."))
//End of code by Mord_Sith

/mob/living/silicon/ai/proc/ai_statuschange()
	set category = "AI Commands"
	set name = "AI Status"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/list/ai_emotions = list("Very Happy", "Happy", "Neutral", "Unsure", "Confused", "Surprised", "Sad", "Upset", "Angry", "Awesome", "BSOD", "Blank", "Problems?", "Facepalm", "Friend Computer")
	var/emote = tgui_input_list(usr, "Please, select a status!", "AI Status", ai_emotions)
	for (var/obj/structure/machinery/M in machines) //change status
		if(istype(M, /obj/structure/machinery/ai_status_display))
			var/obj/structure/machinery/ai_status_display/AISD = M
			AISD.emotion = emote
		//if Friend Computer, change ALL displays
		else if(istype(M, /obj/structure/machinery/status_display))

			var/obj/structure/machinery/status_display/SD = M
			if(emote=="Friend Computer")
				SD.friendc = 1
			else
				SD.friendc = 0
	return

//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "AI Commands"

	if(check_unable())
		return

	var/input
	if(alert("Would you like to select a hologram based on a crew member or switch to unique avatar?",,"Crew Member","Unique")=="Crew Member")

		var/personnel_list[] = list()

		for(var/datum/data/record/t in GLOB.data_core.locked)//Look in data core locked.
			personnel_list["[t.fields["name"]]: [t.fields["rank"]]"] = t.fields["image"]//Pull names, rank, and image.

		if(personnel_list.len)
			input = tgui_input_list(usr, "Select a crew member:", "Change hologram",  personnel_list)
			var/icon/character_icon = personnel_list[input]
			if(character_icon)
				qdel(holo_icon)//Clear old icon so we're not storing it in memory.
				holo_icon = getHologramIcon(icon(character_icon))
		else
			alert("No suitable records found. Aborting.")

	else
		var/icon_list[] = list(
		"default",
		"floating face",
		"carp"
		)
		input = tgui_input_list(usr, "Please select a hologram:", "Select hologram", icon_list)
		if(input)
			QDEL_NULL(holo_icon)
			switch(input)
				if("default")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))
				if("floating face")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo2"))
				if("carp")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo4"))
	return

/*/mob/living/silicon/ai/proc/corereturn()
	set category = "Malfunction"
	set name = "Return to Main Core"

	var/obj/structure/machinery/power/apc/apc = src.loc
	if(!istype(apc))
		to_chat(src, SPAN_NOTICE(" You are already in your Main Core."))
		return
	apc.malfvacate()*/

//Toggles the luminosity and applies it by re-entereing the camera.
/mob/living/silicon/ai/proc/toggle_camera_light()
	set name = "Toggle Camera Light"
	set desc = "Toggles the light on the camera the AI is looking through."
	set category = "AI Commands"

	if(check_unable())
		return

	camera_light_on = !camera_light_on
	to_chat(src, "Camera lights [camera_light_on ? "activated" : "deactivated"].")
	if(!camera_light_on)
		if(camera)
			camera.SetLuminosity(0)
			camera = null
	else
		lightNearbyCamera()



// Handled camera lighting, when toggled.
// It will get the nearest camera from the eyeobj, lighting it.

/mob/living/silicon/ai/proc/lightNearbyCamera()
	if(camera_light_on && camera_light_on < world.timeofday)
		if(src.camera)
			var/obj/structure/machinery/camera/camera = near_range_camera(src.eyeobj)
			if(camera && src.camera != camera)
				src.camera.SetLuminosity(0)
				if(!camera.light_disabled)
					src.camera = camera
					src.camera.SetLuminosity(AI_CAMERA_LUMINOSITY)
				else
					src.camera = null
			else if(isnull(camera))
				src.camera.SetLuminosity(0)
				src.camera = null
		else
			var/obj/structure/machinery/camera/camera = near_range_camera(src.eyeobj)
			if(camera && !camera.light_disabled)
				src.camera = camera
				src.camera.SetLuminosity(AI_CAMERA_LUMINOSITY)
		camera_light_on = world.timeofday + 1 * 20 // Update the light every 2 seconds.


/mob/living/silicon/ai/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		if(anchored)
			user.visible_message(SPAN_NOTICE("\The [user] starts to unbolt \the [src] from the plating..."))
			if(!do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(SPAN_NOTICE("\The [user] decides not to unbolt \the [src]."))
				return
			user.visible_message(SPAN_NOTICE("\The [user] finishes unfastening \the [src]!"))
			anchored = 0
			return
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts to bolt \the [src] to the plating..."))
			if(!do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(SPAN_NOTICE("\The [user] decides not to bolt \the [src]."))
				return
			user.visible_message(SPAN_NOTICE("\The [user] finishes fastening down \the [src]!"))
			anchored = 1
			return
	else
		return ..()

/mob/living/silicon/ai/proc/control_integrated_radio()
	set name = "Radio Settings"
	set desc = "Allows you to change settings of your radio."
	set category = "AI Commands"

	if(check_unable(AI_CHECK_RADIO))
		return

	to_chat(src, "Accessing Subspace Transceiver control...")
	if (src.aiRadio)
		src.aiRadio.interact(src)

/mob/living/silicon/ai/proc/sensor_mode()
	set name = "Set Sensor Augmentation"
	set category = "AI Commands"
	set desc = "Augment visual feed with internal sensor overlays"
	toggle_sensor_mode()

/mob/living/silicon/ai/proc/check_unable(var/flags = 0)
	if(stat == DEAD)
		to_chat(usr, SPAN_DANGER("You are dead!"))
		return 1

	if((flags & AI_CHECK_WIRELESS) && src.control_disabled)
		to_chat(usr, SPAN_DANGER("Wireless control is disabled!"))
		return 1
	if((flags & AI_CHECK_RADIO) && src.aiRadio.disabledAi)
		to_chat(src, SPAN_DANGER("System Error - Transceiver Disabled!"))
		return 1
	return 0

#undef AI_CHECK_WIRELESS
#undef AI_CHECK_RADIO
