//Refer to life.dm for caller

/mob/living/carbon/human/proc/breathe()

	//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!

	if(reagents.has_reagent("lexorin"))
		return
	if(istype(loc, /obj/structure/machinery/cryo_cell))
		return
	if(species && (species.flags & NO_BREATHE || species.flags & IS_SYNTHETIC))
		return

	var/list/air_info

	// HACK NEED CHANGING LATER
	if(health < config.health_threshold_crit && !reagents.has_reagent("inaprovaline"))
		losebreath++

	if(losebreath > 0) //Suffocating so do not take a breath
		losebreath--
		if(prob(20)) //Gasp per 5 ticks? Sounds about right.
			spawn emote("gasp")
		if(istype(loc, /atom/movable))
			var/atom/movable/container = loc
			container.handle_internal_lifeform(src)
	else
		//First, check for air from internal atmosphere (using an air tank and mask generally)
		air_info = get_breath_from_internal()

		//No breath from internal atmosphere so get breath from location
		if(!air_info)			
			var/turf/T = get_turf(loc)
			air_info = T.return_air()

			//Handle filtering
			var/block = 0
			if(wear_mask)
				if(wear_mask.flags_inventory & BLOCKGASEFFECT)
					block = 1
			if(glasses)
				if(glasses.flags_inventory & BLOCKGASEFFECT)
					block = 1
			if(head)
				if(head.flags_inventory & BLOCKGASEFFECT)
					block = 1

			if(!block)
				for(var/obj/effect/particle_effect/smoke/chem/smoke in view(1, src))
					if(smoke.reagents.total_volume)
						smoke.reagents.reaction(src, INGEST)
						smoke.reagents.copy_to(src, 10) //I dunno, maybe the reagents enter the blood stream through the lungs?
						break //If they breathe in the nasty stuff once, no need to continue checking

	handle_breath(air_info)

/mob/living/carbon/human/proc/get_breath_from_internal()
	if(internal)
		if(istype(buckled,/obj/structure/machinery/optable))
			var/obj/structure/machinery/optable/O = buckled
			if(O.anes_tank)
				return O.anes_tank.return_air()
			return null
		if(!contents.Find(internal))
			internal = null
		if(!wear_mask || !(wear_mask.flags_inventory & ALLOWINTERNALS))
			internal = null
		if(internal)
			return internal.return_air()
	return null

/mob/living/carbon/human/proc/handle_breath(list/air_info)
	oxygen_alert = 0 // so unless no air info is returned (which happens only when gasping or lack of atmosphere) it'll always be 0
	if(status_flags & GODMODE)
		return

	if(!air_info)
		if(health > config.health_threshold_crit)
			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		else
			adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		oxygen_alert = max(oxygen_alert, 1)

		return 0

	switch(air_info[1])
		if(GAS_TYPE_N2O)
			if(!isYautja(src)) // Prevent Predator anesthetic memes
				var/SA_pp = air_info[3]
				if(SA_pp > 20) // Enough to make us paralysed for a bit
					KnockOut(3) // 3 gives them one second to wake up and run away a bit!
					//Enough to make us sleep as well
					if(SA_pp > 30)
						sleeping = min(sleeping+4, 10)
				else if(SA_pp > 1)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
					if(prob(20))
						spawn(0) emote(pick("giggle", "laugh"))
	adjustOxyLoss(-2)
	return 1
