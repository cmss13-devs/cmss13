// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/robot/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/items/circuitboards.dmi'
	icon_state = "cyborg_upgrade"
	var/locked = 0
	var/require_module = 0
	var/installed = 0

/obj/item/robot/upgrade/proc/action(var/mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(usr, SPAN_DANGER("The [src] will not function on a deceased robot."))
		return 1
	return 0


/obj/item/robot/upgrade/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	require_module = 1

/obj/item/robot/upgrade/reset/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	R.uneq_all()
	R.hands.icon_state = "nomod"
	R.icon_state = "robot"
	QDEL_NULL(R.module)
	R.camera.network.Remove(list("Engineering","Medical","MINE"))
	R.updatename("Default")
	R.status_flags |= CANPUSH
	R.update_icons()

	return 1

/obj/item/robot/upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	var/heldname = "default name"

/obj/item/robot/upgrade/rename/attack_self(mob/user)
	..()
	heldname = stripped_input(user, "Enter new robot name", "Robot Reclassification", heldname, MAX_NAME_LEN)

/obj/item/robot/upgrade/rename/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	R.custom_name = heldname
	R.change_real_name(R, heldname)

	return 1

/obj/item/robot/upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"


/obj/item/robot/upgrade/restart/action(var/mob/living/silicon/robot/R)
	if(R.health < 0)
		to_chat(usr, "You have to repair the robot before using this module!")
		return 0

	if(!R.key)
		for(var/mob/dead/observer/ghost in GLOB.observer_list)
			if(ghost.mind && ghost.mind.original == R)
				R.key = ghost.key
				if(R.client) R.client.change_view(world_view_size)
				break

	R.stat = CONSCIOUS
	return 1


/obj/item/robot/upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	require_module = 1

/obj/item/robot/upgrade/vtec/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.speed == -1)
		return 0

	R.speed--
	return 1


/obj/item/robot/upgrade/tasercooler
	name = "robotic Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	require_module = 1


/obj/item/robot/upgrade/tasercooler/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
/*

	if(!istype(R.module, /obj/item/circuitboard/robot_module/security))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0

	var/obj/item/weapon/gun/energy/taser/cyborg/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		to_chat(usr, "This robot has had its taser removed!")
		return 0

	if(T.recharge_time <= 2)
		to_chat(R, "Maximum cooling achieved for this hardpoint!")
		to_chat(usr, "There's no room for another cooling unit!")
		return 0

	else
		T.recharge_time = max(2 , T.recharge_time - 4)
*/
	return 1

/obj/item/robot/upgrade/jetpack
	name = "mining robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/robot/upgrade/jetpack/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	R.module.modules += new/obj/item/tank/jetpack/carbondioxide
	for(var/obj/item/tank/jetpack/carbondioxide in R.module.modules)
		R.internal = src
	//R.icon_state="Miner+j"
	return 1


/obj/item/robot/upgrade/syndicate
	name = "illegal equipment module"
	desc = "Unlocks the hidden, deadlier functions of a robot"
	icon_state = "cyborg_upgrade3"
	require_module = 1
