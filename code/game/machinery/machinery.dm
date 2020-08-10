/*
Overview:
   Used to create objects that need a per step proc call.  Default definition of 'New()'
   stores a reference to src machine in global 'machines list'.  Default definition
   of 'Del' removes reference to src machine in global 'machines list'.

Class Variables:
   use_power (num)
      current state of auto power use.
      Possible Values:
         0 -- no auto power use
         1 -- machine is using power at its idle power level
         2 -- machine is using power at its active power level

   active_power_usage (num)
      Value for the amount of power to use when in active power mode

   idle_power_usage (num)
      Value for the amount of power to use when in idle power mode

   power_channel (num)
      What channel to draw from when drawing power for power mode
      Possible Values:
         EQUIP:0 -- Equipment Channel
         LIGHT:2 -- Lighting Channel
         ENVIRON:3 -- Environment Channel

   component_parts (list)
      A list of component parts of machine used by frame based machines.

   uid (num)
      Unique id of machine across all machines.

   stat (bitflag)
      Machine status bit flags.
      Possible bit flags:
         BROKEN:1 -- Machine is broken
         NOPOWER:2 -- No power is being supplied to machine.
         POWEROFF:4 -- tbd
         MAINT:8 -- machine is currently under going maintenance.
         EMPED:16 -- temporary broken by EMP pulse

   manual (num)
      Currently unused.

Class Procs:
   New()                     'game/machinery/machine.dm'

   Dispose()                     'game/machinery/machine.dm'

      Default definition uses 'use_power', 'power_channel', 'active_power_usage',
      'idle_power_usage', 'powered()', and 'use_power()' implement behavior.

   powered(chan = EQUIP)         'modules/power/power.dm'
      Checks to see if area that contains the object has power available for power
      channel given in 'chan'.

   use_power(amount, chan=EQUIP, autocalled)   'modules/power/power.dm'
      Deducts 'amount' from the power channel 'chan' of the area that contains the object.
      If it's autocalled then everything is normal, if something else calls use_power we are going to
      need to recalculate the power two ticks in a row.

   power_change()               'modules/power/power.dm'
      Called by the area that contains the object when ever that area under goes a
      power state change (area runs out of power, or area channel is turned off).

   RefreshParts()               'game/machinery/machine.dm'
      Called to refresh the variables in the machine that are contributed to by parts
      contained in the component_parts list. (example: glass and material amounts for
      the autolathe)

      Default definition does nothing.

   assign_uid()               'game/machinery/machine.dm'
      Called by machine to assign a value to the uid variable.

   process()                  'game/machinery/machine.dm'
      Called by the 'master_controller' once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/

/obj/structure/machinery
	name = "machinery"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	var/stat = 0
	var/use_power = 1
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/power_channel = POWER_CHANNEL_EQUIP
	var/mob/living/carbon/human/operator = null //Had no idea where to put this so I put this here. Used for operating machines with RELAY_CLICK
		//EQUIP,ENVIRON or LIGHT
	var/list/component_parts = list() //list of all the parts used to build it, if made from certain kinds of frames.
	var/manual = 0
	layer = OBJ_LAYER
	var/machine_processing = 0 // whether the machine is busy and requires process() calls in scheduler.
	throwpass = 1
	projectile_coverage = PROJECTILE_COVERAGE_MEDIUM
	var/power_machine = FALSE //Whether the machine should process on power, or normal processor

/obj/structure/machinery/New()
	..()
	machines += src
	var/area/A = get_area(src)
	if(A)
		A.add_machine(src) //takes care of adding machine's power usage

/obj/structure/machinery/Dispose()
	machines -= src
	processing_machines -= src
	power_machines -= src
	var/area/A = get_area(src)
	if(A)
		A.remove_machine(src) //takes care of removing machine from power usage
	. = ..()

/obj/structure/machinery/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_HIGH_OVER_ONLY, PASS_AROUND)

/obj/structure/machinery/proc/start_processing()
	if(!machine_processing)
		machine_processing = 1
		if(power_machine)
			addToListNoDupe(power_machines, src)
		else
			addToListNoDupe(processing_machines, src)

/obj/structure/machinery/proc/stop_processing()
	if(machine_processing)
		machine_processing = 0
		processing_machines -= src
		power_machines -= src

/obj/structure/machinery/process()//If you dont use process or power why are you here
	return PROCESS_KILL

/obj/structure/machinery/examine(mob/user)
	..()
	if (!stat)
		return

	to_chat(user, "It does not appear to be working.")
	var/msg = get_repair_move_text(FALSE)
	if(msg && skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("[msg]"))

/obj/structure/machinery/emp_act(severity)
	if(use_power && stat == 0)
		use_power(7500/severity)
	new /obj/effect/overlay/temp/emp_sparks (loc)
	..()


/obj/structure/machinery/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
	return

//sets the use_power var and then forces an area power update
/obj/structure/machinery/proc/update_use_power(var/new_use_power)
	if (new_use_power == use_power)
		return	//don't need to do anything

	var/delta_power = 0 //figuring how much our power delta is
	delta_power -= calculate_current_power_usage() //current usage
	use_power = new_use_power
	delta_power += calculate_current_power_usage() //updated usage

	//we're updating our power over time amount, not just using one-off power usage, hence why we're passing the channel
	use_power(delta_power, power_channel)

/obj/structure/machinery/proc/calculate_current_power_usage()
	switch(use_power)
		if(1)
			return idle_power_usage
		if(2)
			return idle_power_usage + active_power_usage
	return 0

/obj/structure/machinery/proc/operable(var/additional_flags = 0)
	return !inoperable(additional_flags)

/obj/structure/machinery/proc/inoperable(var/additional_flags = 0)
	return (stat & (NOPOWER|BROKEN|additional_flags))

/obj/structure/machinery/Topic(href, href_list)
	..()
	if(inoperable())
		return 1
	if(usr.is_mob_restrained() || usr.lying || usr.stat)
		return 1
	if ( ! (istype(usr, /mob/living/carbon/human) || \
			isRemoteControlling(usr) || \
			istype(usr, /mob/living/carbon/Xenomorph)))
		to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
		return 1

	src.add_fingerprint(usr)

	return 0

/obj/structure/machinery/attack_remote(mob/user as mob)
	if(isrobot(user))
		// For some reason attack_robot doesn't work
		// This is to stop robots from using cameras to remotely control machines.
		if(user.client && user.client.eye == user)
			return src.attack_hand(user)
	else
		return src.attack_hand(user)

/obj/structure/machinery/attack_hand(mob/user as mob)
	if(inoperable(MAINT))
		return 1
	if(user.lying || user.stat)
		return 1
	if ( ! (istype(usr, /mob/living/carbon/human) || \
			isRemoteControlling(usr) || \
			istype(usr, /mob/living/carbon/Xenomorph)))
		to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
		return 1
/*
	//distance checks are made by atom/proc/clicked()
	if ((get_dist(src, user) > 1 || !istype(src.loc, /turf)) && !isRemoteControlling(user))
		return 1
*/
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 60)
			visible_message(SPAN_DANGER("[H] stares cluelessly at [src] and drools."))
			return 1
		else if(prob(H.getBrainLoss()))
			to_chat(user, SPAN_DANGER("You momentarily forget how to use [src]."))
			return 1

	src.add_fingerprint(user)

	return 0

/obj/structure/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return
	return 0

/obj/structure/machinery/proc/state(var/msg)
  for(var/mob/O in hearers(src, null))
    O.show_message("[htmlicon(src, O)] [SPAN_NOTICE("[msg]")]", 2)

/obj/structure/machinery/proc/ping(text=null)
  if (!text)
    text = "\The [src] pings."

  state(text, "blue")
  playsound(src.loc, 'sound/machines/ping.ogg', 25, 0)

/obj/structure/machinery/proc/shock(mob/user, prb)
	if(inoperable())
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if (electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/obj/structure/machinery/proc/dismantle()
	playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
	var/obj/structure/machinery/constructable_frame/M = new /obj/structure/machinery/constructable_frame(loc)
	M.state = CONSTRUCTION_STATE_PROGRESS
	M.update_icon()
	for(var/obj/I in component_parts)
		if(I.reliability != 100 && crit_fail)
			I.crit_fail = 1
		I.loc = loc
	qdel(src)
	return 1

/obj/structure/machinery/proc/get_repair_move_text(var/include_name = TRUE)
	return