/mob/living/silicon/robot/drone
	name = "drone"
	real_name = "drone"
	icon = 'icons/mob/robots.dmi'
	icon_state = "repairbot"
	maxHealth = 35
	health = 35
	universal_speak = 0
	universal_understand = 1
	gender = NEUTER
	braintype = "Robot"
	lawupdate = 0
	density = 1
	req_access = list(ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_RESEARCH)
	integrated_light_power = 2
	local_transmit = 1
	layer = ABOVE_LYING_MOB_LAYER
	var/nicknumber = 0

	// We need to keep track of a few module items so we don't need to do list operations
	// every time we need them. These get set in Initialize() after the module is chosen.
	var/obj/item/stack/sheet/metal/cyborg/stack_metal = null
	var/obj/item/stack/sheet/wood/cyborg/stack_wood = null
	var/obj/item/stack/sheet/glass/cyborg/stack_glass = null
	var/obj/item/stack/sheet/mineral/plastic/cyborg/stack_plastic = null
	var/obj/item/device/matter_decompiler/decompiler = null

	//Used for self-mailing.
	var/mail_destination = ""

	holder_type = /obj/item/holder/drone

/mob/living/silicon/robot/drone/Initialize()
	nicknumber = rand(100,999)

	..()


	add_verb(src, /mob/living/proc/hide)
	add_language(LANGUAGE_DRONE, 1)

	if(camera && ("Robots" in camera.network))
		camera.network.Add("Engineering")

	//They are unable to be upgraded, so let's give them a bit of a better battery.
	cell.maxcharge = 50000
	cell.charge = 50000

	// NO BRAIN.
	mmi = null

	//We need to screw with their HP a bit. They have around one fifth as much HP as a full borg.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.max_damage = 10

	remove_verb(src, list(
		/mob/living/silicon/robot/verb/Namepick,
		/mob/living/silicon/robot/drone/verb/set_mail_tag, // we dont have mail tubes
	))
	add_verb(src, list(
		/mob/living/silicon/robot/drone/verb/Drone_name_pick,
		/mob/living/silicon/robot/drone/verb/Power_up,
	))

	module = new /obj/item/circuitboard/robot_module/drone(src)

	//Grab stacks.
	stack_metal = locate(/obj/item/stack/sheet/metal/cyborg) in src.module
	stack_wood = locate(/obj/item/stack/sheet/wood/cyborg) in src.module
	stack_glass = locate(/obj/item/stack/sheet/glass/cyborg) in src.module
	stack_plastic = locate(/obj/item/stack/sheet/mineral/plastic/cyborg) in src.module

	//Grab decompiler.
	decompiler = locate(/obj/item/device/matter_decompiler) in src.module

	//Some tidying-up.
	flavor_text = "This is an XP-45 Engineering Drone, one of the many fancy things that come out of the Weyland-Yutani Research Department. It's designed to assist both ship repairs as well as ground missions. Shiny!"
	update_icons()

/mob/living/silicon/robot/drone/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER

/mob/living/silicon/robot/drone/init()
	connected_ai = null

	aiCamera = new/obj/item/device/camera/siliconcam/drone_camera(src)
	playsound(src.loc, 'sound/machines/twobeep.ogg', 25, 0)

//Redefining some robot procs...
/mob/living/silicon/robot/drone/updatename()
	var/new_name = "XP-45 Engineering Drone ([nicknumber])"
	change_real_name(src, new_name)

/mob/living/silicon/robot/drone/update_icons()

	overlays.Cut()
	if(stat == 0)
		overlays += "eyes-[icon_state]"
	else
		overlays -= "eyes"

/mob/living/silicon/robot/drone/choose_icon()
	return

/mob/living/silicon/robot/drone/pick_module()
	return

//Drones cannot be upgraded with borg modules so we need to catch some items before they get used in ..().
/mob/living/silicon/robot/drone/attackby(obj/item/W, mob/living/user)

	if(istype(W, /obj/item/robot/upgrade/))
		to_chat(user, SPAN_DANGER("The maintenance drone chassis not compatible with \the [W]."))
		return

	else if (HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		to_chat(user, "The machine is hermetically sealed. You can't open the case.")
		return

	..()

//DRONE LIFE/DEATH

//For some goddamn reason robots have this hardcoded. Redefining it for our fragile friends here.
/mob/living/silicon/robot/drone/updatehealth()
	if(status_flags & GODMODE)
		health = 35
		stat = CONSCIOUS
		return
	health = 35 - (getBruteLoss() + getFireLoss())
	return

//Easiest to check this here, then check again in the robot proc.
//Standard robots use config for crit, which is somewhat excessive for these guys.
//Drones killed by damage will gib.
/mob/living/silicon/robot/drone/handle_regular_status_updates()

	if(health <= -35 && src.stat != 2)
		timeofdeath = world.time
		death(last_damage_data) //Possibly redundant, having trouble making death() cooperate.
		gib(last_damage_data)
		return
	..()

//DRONE MOVEMENT.
/mob/living/silicon/robot/drone/Process_Spaceslipping(var/prob_slip)
	//TODO: Consider making a magboot item for drones to equip. ~Z
	return 0

//CONSOLE PROCS
/mob/living/silicon/robot/drone/proc/shut_down()
	if(stat != 2)
		to_chat(src, SPAN_DANGER("You feel a system kill order percolate through your tiny brain, and you obediently destroy yourself."))
		death()

//Reboot procs.

/mob/living/silicon/robot/drone/proc/request_player()
	for(var/mob/dead/observer/O in GLOB.observer_list)
		if(jobban_isbanned(O, "Cyborg"))
			continue

/mob/living/silicon/robot/drone/proc/question(var/client/C)
	spawn(0)
		if(!C || jobban_isbanned(C,"Cyborg"))	return
		var/response = alert(C, "Someone is attempting to reboot a maintenance drone. Would you like to play as one?", "Maintenance drone reboot", "Yes", "No", "Never for this round.")
		if(!C || ckey)
			return
		else if(response == "Yes")
			transfer_personality(C)

/mob/living/silicon/robot/drone/proc/transfer_personality(var/client/player)

	if(!player) return
	player.change_view(world_view_size)
	src.ckey = player.ckey

	if(player.mob && player.mob.mind)
		player.mob.mind.transfer_to(src)

	lawupdate = 0
	to_chat(src, "<b>Systems rebooted</b>. Loading base pattern maintenance protocol... <b>loaded</b>.")
	to_chat(src, "<br><b>You are a maintenance drone, a tiny-brained robotic repair machine</b>.")
	to_chat(src, "You have no individual will, no personality, and no drives or urges other than your laws.")
	to_chat(src, "Use <b>:d</b> to talk to other drones and <b>say</b> to speak silently to your nearby fellows.")
	to_chat(src, "Remember, <b>you are lawed against interference with the crew</b>.")
	to_chat(src, "<b>Don't invade their worksites and don't steal their resources.</b>")
	to_chat(src, "<b>If a crewmember has noticed you, <i>you are probably breaking your third law</i></b>.")

/mob/living/silicon/robot/drone/Collide(atom/A)
	if (!istype(A,/obj/structure/machinery/door) && \
	 !istype(A,/obj/structure/machinery/recharge_station) && \
	 !istype(A,/obj/structure/machinery/disposal/deliveryChute) && \
	 !istype(A,/obj/structure/machinery/teleport/hub) && \
	 !istype(A,/obj/effect/portal)
	) return
	..()
	return

/mob/living/silicon/robot/drone/Collided(atom/movable/AM)
	return

/mob/living/silicon/robot/drone/start_pulling(atom/movable/AM)

	if(istype(AM,/obj/item/pipe) || istype(AM,/obj/structure/disposalconstruct))
		..()
	else if(istype(AM,/obj/item))
		var/obj/item/O = AM
		if(O.w_class > SIZE_SMALL)
			to_chat(src, SPAN_WARNING("You are too small to pull that."))
			return
		else
			..()
	else
		to_chat(src, SPAN_WARNING("You are too small to pull that."))
		return

/mob/living/silicon/robot/drone/add_robot_verbs()

/mob/living/silicon/robot/drone/remove_robot_verbs()

/mob/living/silicon/robot/drone/verb/Drone_name_pick()
	set category = "Robot Commands"
	if(custom_name)
		return 0

	spawn(0)
		var/newname
		newname = tgui_input_list(src,"You are drone. Pick a name, no duplicates allowed.", "Drone name pick", greek_letters)
		if(custom_name)
			return

		for (var/mob/living/silicon/robot/drone/A in GLOB.mob_list)
			if(newname == A.nicknumber)
				to_chat(src, SPAN_WARNING("That identifier is taken, pick again."))
				return

		custom_name = newname
		nicknumber = newname

		updatename()
		update_icons()

/mob/living/silicon/robot/drone/verb/Power_up()
	set category = "Robot Commands"
	if(resting)
		resting = 0
		to_chat(src, SPAN_NOTICE("You begin powering up."))
