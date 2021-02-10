// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/robot/upgrade
	name = "A borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	var/locked = 0
	var/require_module = 0
	var/installed = 0

/obj/item/robot/upgrade/proc/action()
	return


/obj/item/robot/upgrade/reset
	name = "Borg module reset board"
	desc = "Used to reset a borg's module. Destroys any other upgrades applied to the borg."
	icon_state = "cyborg_upgrade1"
	require_module = 1

/obj/item/robot/upgrade/reset/action(var/mob/living/silicon/robot/R)
	R.uneq_all()
	del(R.module)
	R.module = null
	R.modtype = "robot"
	R.nopush = 0
	R.hands.icon_state = "nomod"
	R.base_icon = "robot"
	R.icon_state = "robot"
	R.updateicon()
	R.languages = list()
	R.speech_synthesizer_langs = list()
	var/new_name = "Cyborg [R.ident]"
	R.change_real_name(R, new_name)

	return 1



/obj/item/robot/upgrade/flashproof
	name = "Borg Flash-Supression"
	desc = "A highly advanced, complicated system for supressing incoming flashes directed at the borg's optical processing system."
	icon_state = "cyborg_upgrade4"
	require_module = 1


/obj/item/robot/upgrade/flashproof/New()   // Why the fuck does the fabricator make a new instance of all the items?
	//desc = "Sunglasses with duct tape." // Why?  D:

/obj/item/robot/upgrade/flashproof/action(var/mob/living/silicon/robot/R)
	if(R.module)
		R.module += src

	return 1

/obj/item/robot/upgrade/restart
	name = "Borg emergancy restart module"
	desc = "Used to force a restart of a disabled-but-repaired borg, bringing it back online."
	icon_state = "cyborg_upgrade1"


/obj/item/robot/upgrade/restart/action(var/mob/living/silicon/robot/R)
	if(!R.key)
		for(var/mob/dead/observer/ghost in world)
			if(ghost.corpse == R && ghost.client)
				ghost.client.mob = ghost.corpse

	if(R.health < 0)
		to_chat(usr, "You have to repair the borg before using this module!")
		return 0

	R.stat = 0
	return 1


/obj/item/robot/upgrade/vtec
	name = "Borg VTEC Module"
	desc = "Used to kick in a borgs VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	require_module = 1

/obj/item/robot/upgrade/vtec/action(var/mob/living/silicon/robot/R)
	if(R.speed == -1)
		return 0

	R.speed--
	return 1


/obj/item/robot/upgrade/tasercooler
	name = "Borg Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate.."
	icon_state = "cyborg_upgrade3"
	require_module = 1


/obj/item/robot/upgrade/tasercooler/action(var/mob/living/silicon/robot/R)
	if(!istype(R.module, /obj/item/weapon/robot_module/security))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0

	var/obj/item/weapon/gun/energy/taser/cyborg/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		to_chat(usr, "This cyborg has had its taser removed!")
		return 0

	if(T.recharge_time <= 2)
		to_chat(R, "Maximum cooling achieved for this hardpoint!")
		to_chat(usr, "There's no room for another cooling unit!")
		return 0

	else
		T.recharge_time = max(2 , T.recharge_time - 4)

	return 1

/obj/item/robot/upgrade/jetpack
	name = "Mining Borg Jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations"
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/robot/upgrade/jetpack/action(var/mob/living/silicon/robot/R)
	if(!istype(R.module, /obj/item/weapon/robot_module/miner))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0
	else
		R.module.modules += new/obj/item/weapon/tank/jetpack/carbondioxide
		for(var/obj/item/weapon/tank/jetpack/carbondioxide in R.module.modules)
			R.internals = src
		R.icon_state="Miner+j"
		return 1
