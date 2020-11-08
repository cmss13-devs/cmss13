//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	use_me = 0 //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/items/organs.dmi'
	icon_state = "brain1"

/mob/living/brain/Initialize()
	create_reagents(1000)
	..()

/mob/living/brain/Destroy()
	if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat!=DEAD)	//If not dead.
			death(null, 1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()		//Ghostize checks for key so nothing else is necessary.
	. = ..()

/mob/living/brain/say_understands(var/mob/other)//Goddamn is this hackish, but this say code is so odd
	if (isAI(other))
		if(!(container && istype(container, /obj/item/device/mmi)))
			return 0
		else
			return 1
	if (istype(other, /mob/living/silicon/decoy))
		if(!(container && istype(container, /obj/item/device/mmi)))
			return 0
		else
			return 1
	if (isrobot(other))
		if(!(container && istype(container, /obj/item/device/mmi)))
			return 0
		else
			return 1
	if (istype(other, /mob/living/carbon/human))
		return 1
	return ..()


/mob/living/brain/update_canmove()
	canmove = FALSE
	return canmove





/mob/living/brain/update_sight()
	if (stat == DEAD)
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO
	else if (stat != DEAD)
		sight &= ~SEE_TURFS
		sight &= ~SEE_MOBS
		sight &= ~SEE_OBJS
		see_in_dark = 2
		see_invisible = SEE_INVISIBLE_LIVING

/mob/living/brain/synth
	icon = 'icons/obj/items/assemblies.dmi'
	icon_state = "mmi_full"

/mob/living/brain/synth/say_understands(var/mob/other)
	return TRUE

//synth heads can ghost and re-enter given they're basically dead anyway
/mob/living/brain/synth/ghost()
	set desc = "Relinquish your sentience and visit the land of the past."

	if(mind && mind.player_entity)
		mind.player_entity.update_panel_data(round_statistics)
	ghostize(TRUE)

//mostly so the pane isn't empty
/mob/living/brain/synth/Stat()
	if(!..())
		return FALSE

	if(statpanel("Stats"))
		stat("Operation Time:","[worldtime2text()]")
		stat("Status:","CRITICAL")

	return TRUE
