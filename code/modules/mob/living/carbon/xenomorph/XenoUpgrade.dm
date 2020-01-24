

/mob/living/carbon/Xenomorph/proc/upgrade_xeno(newlevel)
	visible_message(SPAN_XENONOTICE("\The [src] begins to twist and contort."), \
	SPAN_XENONOTICE("You begin to twist and contort."))
	xeno_jitter(SECONDS_2)
	add_timer(CALLBACK(src, /mob/living/carbon/Xenomorph/proc/upgrade_xeno_finish, newlevel), SECONDS_2)

/mob/living/carbon/Xenomorph/proc/upgrade_xeno_finish(newlevel)
	if(stat == DEAD || !caste || disposed)
		return

	upgrade = newlevel
	upgrade_stored = 0

	switch(upgrade)
		//FIRST UPGRADE
		if(1)
			to_chat(src, SPAN_XENODANGER("You feel a bit stronger."))
		//SECOND UPGRADE
		if(2)
			to_chat(src, SPAN_XENODANGER("You feel a whole lot stronger."))
		//Final UPGRADE
		if(3)
			switch(caste.caste_name)
				if("Runner")
					to_chat(src, SPAN_XENOANNOUNCE("You are the fastest assassin of all time. Your speed is unmatched."))
				if("Lurker")
					to_chat(src, SPAN_XENOANNOUNCE("You are the epitome of the hunter. Few can stand against you in open combat."))
				if("Ravager")
					to_chat(src, SPAN_XENOANNOUNCE("You are death incarnate. All will tremble before you."))
				if ("Defender")
					to_chat(src, SPAN_XENOANNOUNCE("You are a incredibly resilient, you can control the battle through sheer force."))
				if ("Warrior")
					to_chat(src, SPAN_XENOANNOUNCE("None can stand before you. You will annihilate all weaklings who try."))
				if("Crusher")
					to_chat(src, SPAN_XENOANNOUNCE("You are the physical manifestation of a tank. Almost nothing can harm you."))
				if("Sentinel")
					to_chat(src, SPAN_XENOANNOUNCE("You are the stun master. Your stunning is legendary and causes massive quantities of salt."))
				if("Spitter")
					to_chat(src, SPAN_XENOANNOUNCE("You are a master of ranged stuns and damage. Go forth and generate salt."))
				if("Boiler")
					to_chat(src, SPAN_XENOANNOUNCE("You are the master of ranged artillery. Bring death from above."))
				if("Praetorian")
					to_chat(src, SPAN_XENOANNOUNCE("You are the most fearsome of warleaders. You are inevitable. Bring death to the opponents of the hive!"))
				if("Drone")
					to_chat(src, SPAN_XENOANNOUNCE("You are the ultimate worker of the Hive. Time to clock in, and clock the tallhosts out."))
				if("Hivelord")
					to_chat(src, SPAN_XENOANNOUNCE("You are the builder of walls. Ensure that the marines are the ones who pay for them."))
				if("Carrier")
					to_chat(src, SPAN_XENOANNOUNCE("You are the master of huggers. Throw them like baseballs at the marines!"))
				if("Burrower")
					to_chat(src, SPAN_XENOANNOUNCE("You are the master of traps. You are the bane of marine pushes!"))
				if("Queen")
					to_chat(src, SPAN_XENOANNOUNCE("You are the Alpha and the Omega. The beginning and the end."))
		if(4)
			switch(caste.caste_name)
				if("Queen")
					to_chat(src, SPAN_XENOANNOUNCE("Your sheer presence causes the world to tremble, your existence makes your opponents wish they didn't exist. Go forth, and destroy all that there is."))
				if("Praetorian")
					to_chat(src, SPAN_XENOANNOUNCE("Merely looking at someone causes them to freeze in terror and run at your majestic presence. You're second only to the Queen in your aura's sheer strength."))
				if("Ravager")
					to_chat(src, SPAN_XENOANNOUNCE("Being the incarnation of death itself is an understatement, your scythes could tear an entire spaceship in half with a single fell swoop."))
				if("Crusher")
					to_chat(src, SPAN_XENOANNOUNCE("Your mere footsteps cause buildings to crumble, your defenses are impenetrable. Go forth and become the Queen's unbreakable shield."))
				if("Lurker")
					to_chat(src, SPAN_XENOANNOUNCE("You've become a killing machine, the closest thing to staring at death in the eye. Your claws rend metal like butter."))
				if("Warrior")
					to_chat(src, SPAN_XENOANNOUNCE("Your muscles could deadlift a military base without flinching. You've become the true definition of a one xeno army."))

	update_caste()

	generate_name() //Give them a new name now

	hud_update() //update the upgrade level insignia on our xeno hud.

	// Update the hive status
	if(hive)
		hive.hive_ui.update_xeno_info()

	//One last shake for the sake of it
	xeno_jitter(25)

//Tiered spawns.
/mob/living/carbon/Xenomorph/Runner/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Runner/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Runner/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Drone/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Drone/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Drone/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Carrier/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Carrier/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Carrier/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Hivelord/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Hivelord/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Hivelord/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Praetorian/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Praetorian/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Praetorian/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Ravager/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Ravager/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Ravager/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Sentinel/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Sentinel/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Sentinel/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Spitter/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Spitter/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Spitter/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Lurker/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Lurker/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Lurker/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Queen/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Queen/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Queen/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Crusher/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Crusher/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Crusher/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Boiler/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Boiler/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Boiler/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Defender/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Defender/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Defender/ancient/New()
	..()
	upgrade_xeno(3)


/mob/living/carbon/Xenomorph/Warrior/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Warrior/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Warrior/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Burrower/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Burrower/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Burrower/ancient/New()
	..()
	upgrade_xeno(3)
